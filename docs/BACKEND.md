# The S/370 back end

How the SLOW-32 optimizer is retargeted to System/370 for IFOX00 and
IEWL. The generic half of `backend/` (`hir.h`, `hir_ssa.h`, `hir_opt.h`,
`hir_licm.h`) stays as it is. The target half (`hir_burg.h`,
`hir_regalloc.h`, `hir_codegen.h`, all SLOW-32) gets S/370 counterparts,
`*_s370.h`, written to the same interfaces. The x86-64 and AArch64
retargets of the same optimizer were the models: they kept the IRC
allocator's core and the BURS engine and wrote the emitter fresh.

What FORTRAN H's listings show (`docs/FORTRAN-H.md`, `bench/listings/`)
is the shape to aim at, and where this design copies H it says so.

## The machine, as the optimizer sees it

- 16 general registers, 32-bit; four floating-point registers (0, 2, 4,
  6), each holding a short (32-bit) or long (64-bit) hexadecimal float.
- Storage operands on most instructions: `A 2,X(4,13)` adds from
  storage, `AD 2,0(4,5)` likewise for doubles. Addressing is
  base+index+displacement, displacement 0..4095, and register 0 as a
  base or index means "none".
- No immediates except `LA` (0..4095) and the halfword forms (`LH`,
  `AH`, `MH`). Constants live in storage.
- Multiply and divide want an even/odd register pair. `BXLE` wants an
  even/odd pair for increment and limit.
- Standard OS linkage: R1 → parameter list (addresses; the last entry
  carries X'80'), R13 → the caller's save area, R14 return, R15 entry.
  The callee saves R14–R12 with one `STM` and restores them with one
  `LM`; the floating-point registers are not preserved across calls.

## Values

**Doubles are one value.** On SLOW-32 a double is a pair of 32-bit
words and arithmetic is a pseudo-call (`__fp64_add`) the back end
expands. The x86-64 retarget introduced `S12CC_NATIVE_F64` for the C
front end: a double is a single HIR value of type `TY_DOUBLE`, operated
on by `HI_FADD` and friends. The Fortran front end gets the same switch,
`F77_NATIVE_F64`: one value, one 8-byte load or store, one `HI_FCONST`,
one `HI_RET`. REAL is likewise one `TY_FLOAT` value. Both are allocated
to floating-point registers. COMPLEX stays what it is, two values.

**Integers are 32-bit**, as the HIR already assumes. `h_val` holds a
32-bit constant; the optimizer folds in 32-bit arithmetic. Fortran 77
has no 64-bit integer, so `TY_LLONG` never appears.

**Byte order is big-endian.** Every place the front end writes a
multi-byte image (DATA statements into `ps_ginit_pool`, the word order
of a split constant) is host-order today and becomes explicit
big-endian under the S/370 target.

**Floating-point constants are converted by the compiler, truncating.**
H truncates: `1.0D-6` is `3C10C6F7A0B5ED8D`, not `...8E`. Going through
the host's IEEE `double` would double-round, so the lexer keeps the
constant's text and `s370_hfp.h` converts decimal to a 56-bit fraction
exactly, truncated. Constants the front end folds (`2.0D0*3.0D0`) are
folded in host arithmetic and then converted, which can differ from H
by an ulp; nothing in the kernels folds. The emitted form is
`DC X'3C10C6F7A0B5ED8D'` with the decimal in a comment, so what the
assembler sees is what the compiler decided, on any host.

## Storage

**A unit's storage is static.** Fortran 77 forbids recursion, so every
unit gets one static area, as H does: the save area first (18 words),
then its constants and address constants, then its scalars, temporaries
and spill slots, then its arrays. R13 points at it, as standard linkage
requires anyway, and everything in the first 4K is `D(0,13)` from it.

The HIR's `HI_ALLOCA` carries a negative frame offset; here it becomes
a label in the area, and every reference to the area is written
symbolically (`L 2,T0012`, `LD 4,T0012(5)`), so the assembler chooses
base and displacement from the `USING`s. If the near part of the area
outgrows 4K, R11 becomes a second data base (`USING AREA+4096,11`) and
is withheld from the allocator; the decision is made before register
allocation from the sizes of the allocas.

**Arrays past the first 4K are reached through address constants.** An
ALLOCA that does not fit is not a storage-operand base; it is
materialized into a register with `L r,A0003` (an `A(T0003)` in the
pool), which invariant code motion hoists out of loops. That is H's
`L 5,0(0,12)` for Y−8 in DAXPY. The layout pass puts small objects
first so scalars, temporaries and spills are always near.

**COMMON blocks are `COM` sections**, which the linkage editor merges
across separately compiled units, the way H's are. SAVE'd and DATA'd
locals are static anyway.

A stack model (R13 → a frame carved from a GETMAINed stack, for
languages with recursion) changes only the prologue, the epilogue and
where the far arrays go; the body code is the same `D(X,13)` either
way. It is not built, but the emitter keeps that door open by never
assuming the area's address is a constant.

## Registers

**General registers.** R12 is the code base, R13 the data base, R14 and
R15 linkage, R0 and R1 scratch (R0 cannot be a base or index; R1 holds
the parameter list only around a call). The allocatable pool is
**R2–R11, ten registers, all callee-saved**: standard linkage saves and
restores them all with one `STM`/`LM`, so the allocator needs no
per-register save bookkeeping and values stay in registers across calls,
as H's BXLE triples do. R0/R1 serve as the even/odd scratch pair for
`MR`/`DR`; R14/R15 are the reload scratch for spilled values (they can
be bases and indexes; R0 cannot).

**Floating-point registers.** A second register class, four colours,
caller-saved: a value that crosses a call is spilled, not coloured. The
IRC allocator gets two classes the way the AArch64 retarget did it: only
same-class nodes interfere, chosen by `ty_is_fp`. The pair machinery the
SLOW-32 allocator uses for fp64 halves is removed; later it may come
back to pair the increment and limit of a `BXLE`.

**Function results**: R0 for INTEGER and LOGICAL, FPR0 for REAL and
DOUBLE PRECISION, as H and FORTLIB expect.

## Code

**Code is based on R12**, set by `BALR 12,0` in the prologue. Code never
needs addressability for anything but branch targets: constants and data
are reached through R13. A branch whose target may lie more than 4K
from the base goes through an address constant, `L 15,A0021` /
`BCR mask,15`, H's "ADCONS FOR B BLOCK LABELS". The decision uses an
upper estimate of the target's offset, so a small unit (every kernel,
most real subroutines) has only direct branches and a large one pays
one extra instruction on its far branches.

**Prologue and epilogue** are H's:

    DAXPY    CSECT
             USING *,15
             B     12(,15)
             DC    AL1(5),CL7'DAXPY'
             STM   14,12,12(13)
             BALR  12,0
             USING *,12
             DROP  15
             LA    15,SAVE              own save area
             ST    13,4(,15)            back chain
             ST    15,8(,13)            forward chain
             LR    13,15
             USING SAVE,13
             ...                        pick up arguments from 0(1)
    ...
             L     13,4(,13)
             LM    14,12,12(13)
             SR    15,15
             BR    14

For an INTEGER function, R0 is loaded before the `LM`; for a REAL or
DOUBLE one, FPR0 is loaded and survives the `LM` untouched.

**Calls** build a parameter list of addresses. Every argument is passed
by reference, including the arguments of runtime routines: a by-value
integer or double in the HIR is stored to a temporary and the
temporary's address goes in the list. Lists whose words are all
compile-time constants are assembled statically; computed addresses are
stored into the list before the call, as H does.

    LA    0,T0040
    ST    0,PL0003+8
    LA    1,PL0003
    L     15,V0002                V(DAXPY) from the pool
    BALR  14,15

**Instruction selection.** The BURS grammar has the nonterminals REG,
IMM (a constant that fits `LA`), FADDR (a static-area label plus
displacement), SADDR (a symbol reached through an address constant) and
STMT, as the SLOW-32 one does. The first version operates register to
register: `L`, then `AR`. The second adds MEM, a storage operand
(base, index, displacement) matched from a single-use load with no
intervening store or call, and rules such as `REG: FADD(REG, MEM)`, so
that DAXPY's loop becomes `LD / MDR / AD / STD / BXLE` rather than
`LD / LD / MDR / ADR / STD`. The x86-64 retarget bolted its reg-mem
forms on as rewrites after BURS; here they belong in the grammar, since
on this machine the storage operand is the ordinary form.

**Comparisons** fuse with the branch they feed, as on SLOW-32
(`C 2,T0012` / `BC 2,L0017`). A comparison that must produce 0 or 1
costs four instructions.

**Integer multiply and divide** use the R0/R1 pair: `LR 1,a` /
`MR 0,b` / `LR d,1`; `LR 1,a` / `SRDA 0,32` / `D 0,b` / `LR d,1`.
Multiplication by a power of two is already a shift by the time the
optimizer is done.

## The runtime

The kernels of step 2 wrote through **IBCOM#**, FORTLIB's own I/O
routine, exactly as H's code does, which gave H's digits for free and
made the first checksum comparison exact (`F77_IBCOM=1` still emits
that: `BAL 14,4(,15)` begins a WRITE, `BAL 14,8(,15)` one item with
its length, type and S-constant inline, `BAL 14,16(,15)` ends it,
`BAL 14,52(,15)` is STOP). IBCOM# knows nothing of CHARACTER,
list-directed I/O, OPEN or internal files, so the runtime a Fortran 77
program needs is fort370's own, and it is the SLOW-32 one
(`runtime/libf77.c`, a C format interpreter) carried to MVS:

- `runtime/s370/port.py` generates `f77rt.c` and `f77rt.h` from
  `libf77.c` by textual replacements, each asserted to match once, so
  the SLOW-32 copy stays a copy (PROVENANCE.md) and what differs on MVS
  is in one place: units are the DD names `FTnnF001`, as IBM's Fortran
  names them (6 falls back to SYSPRINT, 5 to SYSIN); floating numbers
  are edited by `f77dtoa.c`, an exact big-integer conversion with
  half-up rounding (libc370's printf gives 0.1 as
  `1.000000000000004E-01`, and D22.15 has to show the number's own
  digits), and read by the compiler's own text-to-HFP (`s370_hfp.h`),
  truncating as H does; C89's `sprintf` for the rest.
- It is built with **cc370** for **libc370** (mvslovers), the toolchain
  cobc370 is built with, and called by cc370's convention: the
  arguments as values in a list R1 points to (a DOUBLE PRECISION a
  doubleword, a REAL widened to one for the libm functions, which take
  double), the C stack pointer in word 76 of the current save area,
  results in R15 and FPR0. Every unit's prologue copies word 76 from
  its caller's save area into its own static one, so a C function can
  be called from any Fortran unit; FPRs are caller-saved on both sides
  already. cc370 mangles C names to eight characters with `_` as `@`
  (`f77_wr_begin` and `f77_wr_begin_int` would collide), so every entry
  carries an asm label, `F77WRBEG`, from the table the compiler emits
  from (`backend/s370_rtnames.h`; `tests/host/rtnames.sh` checks the
  two agree). The intrinsics a program passes as actual arguments are
  `I#DSQRT` and so on.
- The load module's entry is libc370's `@@CRT0`; its C `main`
  (`f77main.c`) calls the Fortran main program, whose CSECT is
  therefore **F77MAIN** (C's `main` is already `MAIN`), and `exit`
  flushes the units. STOP calls `exit` directly. Mathematical
  intrinsics call libc370's `SQRT`, `EXP`, ... with the C convention
  rather than FORTLIB's `DSQRT`.
- The 64-bit millicode cc370 emits calls to (`@@MULDI3`, `@@NEGDI2`) is
  cobc370's `mvs370-millicode.c`, copied.

A program is linked **on the host**: `bench/mkload.sh prog.f` runs the
compiler, `as370`, and `cc370` as the linker (crt0, the runtime
objects, libc.a) and writes a load module and its XMIT. Linking on the
guest with IEWL would have let the IFOX00 decks of before include a
runtime library, but IEWL misreads a module ld370 wrote (the relinked
module took an operation exception in its first C function, both with
an IFOX00 object added and alone; 2026-10-12, one for mvslovers), so
the module goes aboard whole: `bench/ship.py` sends each XMIT as
hexadecimal cards on SYSIN to **HEXIN** (`runtime/s370/hexin.c`, a cc370
program installed once by tape, `ship.py --install`), which writes the
image back as the FB/80 data set it was; RECEIVE makes a load library
of it and the GO step runs it with `FT06F001` on the printer. A tape
file per module was the first version, and MVS asked for the volume to
be mounted again at every one.

## Names

External names are at most eight characters, upper case. Fortran names
fit. Runtime entry points are mapped to eight-character names in one
table (`backend/s370_rtnames.h`: `f77_wr_begin` → `F77WRBEG`). Compiler-generated
labels are `Lnnnn` (blocks), `Tnnnn` (static-area slots), `Cnnnn`
(constants), `Annnn` (address constants), `Vnnnn` (V-constants),
`PLnnnn` (parameter lists). Blank COMMON is `#BLANK`.

## Where it stands

2026-10-12: all seven steps have a first version. The kernels
assemble under IFOX00, link against FORTLIB and print FORTRAN H's
checksums to the digit. `bench/results-s370-2026-10-12.txt` is the
register-to-register grammar, between H's OPT=0 and OPT=1;
`bench/results-s370-2026-10-12b.txt` adds storage operands, index
registers and BXLE, and DAXPY's loop is then `LDR / MD / AD / STD /
BXLE`, five instructions like H's, at 4.64 s against H's 4.40.
`bench/results-s370-2026-10-12c.txt` adds subscript constants in the
displacement, each subscript term scaled by itself and invariant terms
hoisted into a register base: matmul's loop is the five-instruction
floor against H's eight (4.78 to 5.04), lll5 and lll7 are at H's
count, and the seven kernels stand at 0.95 to 1.18 of H's OPT=2, the
1.18 being LINPACK, where register pressure in DGEFA spills hoisted
bases into the innermost loop. `bench/results-s370-2026-10-12d.txt`
removes that: the spill cost had not counted the reads an instruction
makes through a folded address (the folded ADDs are NOPs), so the
inner-loop bases weighed nothing and went first; with those reads
counted, DGEFA's inlined DAXPY loop is `LDR / MD / AD / STD / BXLE`
and LINPACK is 13.62 to H's 13.64. The seven kernels now stand
between 0.95 and 1.07 of H's OPT=2, the difference in the slower ones
being within the run-to-run noise of the measurement (about 2%)
plus one or two instructions in loop setup. Two more findings the same
night: a local passed to an inlined routine had its slot retyped to an
address by the callee's declaration of the dummy, which the SSA
promoter then read as a type pun and left in memory (DGEFA's `T`,
reloaded in every iteration of DSCAL's loop; LINPACK 13.03); and
`LDR 0,2 / MD 0,X` against H's `LD 0,X / MDR 0,2` -- the same two
instructions -- is 5% on daxpy under Hercules, so a commutative
operation on a surviving register takes H's order. With H re-measured
the same hour, the seven kernels stand at 0.91 to 1.01 of H's OPT=2
(the last block of `bench/results-s370-2026-10-12d.txt`). Then
`s370_rehoist`: the passes after LICM (strength reduction's derived
induction variables, `s370_hoist_bases`, `s370_loops`) left an inner
loop's setup in its preheader, which is the enclosing loop's body;
what is invariant there now moves to the enclosing loop's preheader,
round by round, so daxpy's outer loop is `LA / inner / AH / C / BC`
and the kernels' code is 15-25% shorter. Three things had to go with
it. LICM's live-range split around loops is off for S/370
(`F77_SPLIT=1` restores it): the allocator's own spilling serves, and
the split's reload hid the outer loop's trip count from the BXLE pass.
A BXLE's step and limit, pinned constants, had been free to unpin when
a colouring failed, so lifting them to where three loops' pairs
competed lost matmul's inner BXLE; they now weigh their loop use
twice, pinned constants are not lifted at all (one `LA` an outer
iteration), and a respill victim must be of the failing node's own
class. And a fused compare is a NOP by allocation time, so its
operands -- a BXLE's index and limit -- had no weight and DGEFA's
DSCAL limit was the first thing spilled. `F77_NO_REHOIST` switches
the pass off. Last, a loop with only a trip count -- an outer DO whose
variable is unused -- counts it down with `BXH`, the -1 and the 0 a
register pair as a BXLE's step and limit are, so daxpy's outer loop
is `LA / LH / LA / inner / BXH`. The seven kernels then stand at 0.89
to 1.00 of H's OPT=2, H measured the same hour.

Code beyond 4K of the base: the CSECT is emitted in a sizing pass
first (`cg_dry`, nothing written, every `Lnnnnn` label's offset
recorded), and a target 4K or more past the `BALR 12,0` is far: the
branch becomes `L 15,=A(Lnnnnn)` from the pool and `BC m,0(,15)`, or
`BXLE r,s,0(15)`. The longer form moves later labels further, so the
sizing repeats until no label turns far, and everything the emission
allocates (labels, pool entries, temporaries, parameter lists) is
restored between passes so that each pass numbers alike. H instead
reserves more base registers; that costs every loop in the unit a
register, and a far loop here pays one `L` an iteration instead --
the better trade for the kernels, open to revisiting for a unit whose
hot loop sits past 4K. With it, an `IF (c) statement`'s then arm is
laid next to the test (the branch inverts), as H does, rather than at
the unit's end. `tests/s370/big.f` is a 7K unit with branches both
ways across the boundary and a loop nest at the far end, and agrees
with H. `bench/ab.sh` runs one program through both
compilers and compares what they print; `tests/s370/` holds such
programs; `F77_NO_MEM`, `F77_NO_BXLE`, `F77_NO_REASSOC`,
`F77_NO_IDX`, `F77_NO_HOIST` and `F77_NO_REHOIST` switch the step-3
transformations off one at a time,
which is how the two miscompiles they first brought were found.

## The order of work

1. `s370_hfp.h`: decimal → HFP, truncating, checked against the
   constants in H's listings.
2. `F77_NATIVE_F64` in the front end, and big-endian data images.
3. `hir_burg_s370.h`, register-to-register grammar.
4. `hir_regalloc_s370.h`: two classes, no pairs, no ABI colours.
5. `hir_codegen_s370.h`: the emitter, static layout, IBCOM# I/O.
6. The seven kernels through IFOX00 and IEWL on TK5, checksums against
   `bench/results-2026-10-12.txt`, with the optimizer off.
7. The optimizer on; then MEM in the grammar; then `BXLE`; compared
   loop by loop with `bench/listings/`.
