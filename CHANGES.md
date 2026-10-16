# Changes

One entry per release, newest first. A release is named by its date and
tagged `vYYYY.MM.DD` (a second the same day `vYYYY.MM.DD.1`); the tag's
message carries what it brought and, once the compiler runs on the
guest, the SHA256 of its MVS package. Each entry
names the fort370 commit it was built from, so `git log` between two
entries has the detail. Host binaries for Linux, macOS and Windows come
with each release, built and checked by CI on their own platforms.

## 2026-10-16.1

Tagged `v2026.10.16.1`: END DO and DO WHILE; whole-array I/O of an
adjustable array.  Built from `356c477`: FORT370.xmit SHA256
`85c0a714f8b35a69…`, 525,680 bytes; F77RT.obj unchanged, SHA256
`594bddcda2e8d8cf…`, 422,160 bytes.  All 192 FCVS programs, 88 tests,
the 600K source, the 85-deep nesting test, a unit at each size limit,
ANCORR, AIDAFC and Doug Wegscheid's pi spigot compile on the guest to
the host's assembler, byte for byte, in REGION=7168K; the FCVS
programs' assembler is what it was, which passed on MVS.

- END DO and DO WHILE, as Marco Verpelli suggested: from MIL-STD-1753
  (1978), END DO as a labelled DO's terminal statement and DO WHILE
  (e), labelled or not; and, as VAX FORTRAN and later Fortran 90 have
  it, a DO without a label, ended by END DO.  A unit that ends with a DO
  waiting for its END DO, or a block IF without END IF, is refused
  now; before, it compiled without a word.
- An adjustable array written or read whole -- REAL A(M,N) and then
  WRITE (6,100) A -- was refused ("whole-array I/O needs constant
  extents").  F77 allows it, and it works now.

## 2026-10-16

Tagged `v2026.10.16`: the DOUBLE PRECISION functions correctly rounded
but for about one argument in a hundred; COMPLEX*16; COMPLEX division
in double precision.  Built from `ef404d9`: FORT370.xmit SHA256
`f0a55547e10c1da9…`, 525,360 bytes; F77RT.obj SHA256
`594bddcda2e8d8cf…`, 422,160 bytes.  All 192 FCVS programs, 86 tests,
the 600K source, the 85-deep nesting test, a unit at each size limit,
ANCORR, AIDAFC and Doug Wegscheid's pi spigot compile on the guest to
the host's assembler, byte for byte, in REGION=7168K; the FCVS on MVS
passes as before.

- DEXP, DLOG, DLOG10, DATAN, DATAN2, DASIN, DACOS, DSINH, DCOSH, DTANH,
  DTAN and D**D are within 0.7 of a unit in the last place, where they
  were 3 to 700 units off (DTAN 12); FORTLIB's are within 1 or 2, D**D
  400.  Each ends in a sum of nearly exact terms added in extended
  precision and rounded once.  They cost more than before (DEXP 0.43
  seconds for 200,000 calls, 0.28 before, DTAN 0.99), and FORTLIB's
  assembler routines a fifth to a tenth of either.
- COMPLEX division was done in single precision and could be 21 units
  off (FORTLIB's 12); it is within a unit now.
- COMPLEX*16 and DOUBLE COMPLEX, IBM's: FORTRAN H's rules (a constant
  with a D part is COMPLEX*16, and so is COMPLEX with DOUBLE
  PRECISION) and its DCMPLX, DCONJG, CDABS, CDSQRT, CDEXP, CDLOG, CDSIN
  and CDCOS, with DIMAG, DREAL and the generic names.  COMPLEX*16 was
  accepted before and compiled as COMPLEX, without a word.
- REAL*8 FUNCTION F(X) was refused ("more than one main program"), and
  so were REAL*8 H and CHARACTER*8 HUE (a length before a name that
  begins with H was read as a Hollerith count; found in SLOW-32).
- A program's runtime is about 20K larger, 412K without arrays.

## 2026-10-15.2

Tagged `v2026.10.15.2`: floating point surveyed against the exact
values, and repaired where it was behind FORTRAN H; an inlining bug.
Built from `d993697`: FORT370.xmit SHA256 `8263c1803849642b…`, 524,800
bytes; F77RT.obj SHA256 `3c83408fc8844741…`, 399,120 bytes.  All 192
FCVS programs, 82 tests, the 600K source, the 85-deep nesting test and
a unit at each size limit compile on the guest to the host's assembler,
byte for byte, in REGION=7168K; the FCVS on MVS passes as before.

- A small subroutine inlined in a DO loop could have its work hoisted
  out of the loop, and every call then had the first call's answer,
  silently: when the loop's variable was passed to it and also to a
  call in the loop that was not inlined.  Found by the survey, whose
  generator returned one value 300 times.
- DSQRT is correctly rounded, as FORTLIB's is; it was up to 10 units
  in the last place off.
- SIN, COS and TAN of a huge argument (SIN(1E20), DSIN(1D20), CEXP of
  a huge imaginary part) abended with S0CC; any argument is now
  reduced exactly, by the bits of 2/pi.  ATAN2 and ** no longer
  overflow on a huge quotient or exponent.
- A constant in the source and the same number read by READ are now
  the same value, both rounded to the nearest; constants were
  truncated, as H's are, and a REAL READ rounded, so 0.1 read from a
  card was not the program's 0.1.  A REAL constant can now be one unit
  above H's.
- IBM's ARSIN, ARCOS, DARSIN and DARCOS are the intrinsics ASIN and
  ACOS, not externals.
- docs/INSTALL-MVS.txt has the survey: constants, output, arithmetic,
  the functions against FORTLIB's (DOUBLE PRECISION DEXP, DLOG10,
  DATAN, DASIN, DACOS, DATAN2 and the hyperbolics are still behind
  it), large arguments, and what an error does in each.

## 2026-10-15.1

Tagged `v2026.10.15.1`: a program needs 320K less storage to run.
Built from `68bb637`: FORT370.xmit SHA256 `65ee82b998c7c673…`, 524,720
bytes (the compiler is 2026-10-15's; only its date stamp changed);
F77RT.obj SHA256 `b9166ff3028371c8…`, 389,920 bytes.  All 192 FCVS
programs, 80 tests, the 600K source, the 85-deep nesting test, a unit at
each size limit, ANCORR, AIDAFC and Doug Wegscheid's pi spigot compile
on the guest to the host's assembler, byte for byte, in REGION=7168K;
the FCVS on MVS passes as before.

- A program's GO step took 712K before its first array (FORTRAN H's
  takes 28K), as Doug Wegscheid's measurements showed.  The C stack
  libc370's startup allocates is now 64K, not 256K: only the runtime
  runs on it, and the deepest any FCVS program reached was 9.3K.  The
  runtime's two 64K buffers, for unformatted and direct access records
  and for concatenation, are allocated by the first statement that
  needs one.  A program with no arrays now runs in 392K; its load
  module is 156K, not 283K.

## 2026-10-15

Tagged `v2026.10.15`: an inlined subprogram is typed by its own rules.
Built from `549c6b1`: FORT370.xmit SHA256 `02461119cf3b5a56…`, 524,720
bytes; F77RT.obj SHA256 `939fe019e61d8244…`, 576,400 bytes (the runtime
is 2026-10-14.2's; only its date stamp changed).  All 192 FCVS
programs, 80 tests, the 600K source, the 85-deep nesting test, a unit at
each size limit, ANCORR, AIDAFC and Doug Wegscheid's pi spigot compile
on the guest to the host's assembler, byte for byte, in REGION=7168K.

- A short subprogram that the front end inlines took its caller's
  IMPLICIT: a caller's IMPLICIT NONE refused the callee's own names,
  the message naming the callee's header (Marco Verpelli's INTEGER
  FUNCTION SUCC), and a caller's IMPLICIT INTEGER (A-Z) made the
  callee's REAL variables INTEGER, without a word
  (`tests/s370/implinl.f`).
- An error later in a statement whose CALL was inlined names the
  statement's line, not the callee's last (found first in slow32-public's
  copy of the front end).
- The compiler's environment switches are copied when first read: a
  libc may return every answer in one buffer.
- `tests/s370/cmpscr.f` uses stand-in text for the two prompts it had
  copied from a contributor's program.

## 2026-10-14.3

Tagged `v2026.10.14.3`: FORT370 about nine times faster on MVS.  René
Ferland's ADDAD/AIDAFC ran out of his 10-minute limit compiling; on our
TK5 it took 3:05 of CPU, and ANCORR 2:20.  Nine tenths of that was
libc370's getenv, which the compiler called for its debugging switches
once per interference edge and per instruction; it now asks once per
name, and AIDAFC compiles in 0:21.  The assembler it writes is the same,
byte for byte.  Built from `fc71850`: FORT370.xmit SHA256
`c432a976e9f206ba…`, 524,640 bytes; F77RT.obj unchanged (SHA256
`b325ab26ed95f390…`, 576,400 bytes, the same bytes as 2026-10-14.2's).
All 192 FCVS programs, 79 tests, the 600K source, the 85-deep nesting
test, a unit at each size limit, ANCORR, AIDAFC and Doug Wegscheid's pi
spigot compile on the guest to the host's assembler, byte for byte, in
REGION=7168K.

## 2026-10-14.2

Tagged `v2026.10.14.2`: what René Ferland's ADDAD/ANCORR found when it
ran with his own JCL and data -- four wrong-code bugs, three runtime
gaps and IBM's static locals.  ANCORR now runs on TK5 from his OS/390
JCL unchanged, and of about 1,830 numbers in its listing 1,808 are his
OS/390 run's and 18 differ by 1 or 2 in the last digit.  Built from
`be9c4d0`: FORT370.xmit SHA256 `0ec8e1f5f3c01472…`, 524,640 bytes;
F77RT.obj SHA256 `b325ab26ed95f390…`, 576,400 bytes.  All 192 FCVS
programs, 79 tests, the 600K source, the 85-deep nesting test, a unit
at each size limit, ANCORR and Doug Wegscheid's pi spigot compile on
the guest to the host's assembler, byte for byte, in REGION=7168K; the
FCVS on MVS passes as before (3,346 tests, the 2 FM923 failures by
design).

- A compare took its first operand from a scratch register that its
  storage operand then reloaded as a base: `IF (IFIN .GT. MEMOIR)
  RETURN` compared MEMOIR's address with its value
  (`tests/s370/cmpscr.f`).
- Phi simplification took the undefined value for "no value yet", so a
  variable set in a loop only sometimes became the loop index itself
  (`tests/s370/phiundef.f`).
- Registers that trade values on a loop's back edge lost one: a swap of
  FPR0 and FPR2 left both the same (`tests/s370/phiswap.f`).
- A dead block's ALLOCA was removed while a live block still stored
  through it.
- A subprogram's local variable keeps its value from one call to the
  next, as FORTRAN H's and VS FORTRAN's do, without SAVE: one whose
  value on entry can be used stays in its (static) frame slot.  ADDAD's
  monitor keeps its file table that way (`tests/s370/keepvar.f`).
- Units 0 to 99, as IBM numbers them: OPEN refused any above 31.  Unit
  0 is DD FT00F001 when the job has one, SYSTERM otherwise
  (`tests/s370/unit99.f`).
- A WRITE whose items run out inside a repeated descriptor (`15A1`)
  ends its record there; the literal that begins the next group was
  written (`tests/s370/fmtend.f`).

## 2026-10-14.1

Tagged `v2026.10.14.1`: two ENTRY bugs, from slow-32's copy of the front
end.  Built from `649a2f3`: FORT370.xmit SHA256 `37e6c6ba6450a245…`,
511,120 bytes; F77RT.obj SHA256 `7205793a0e8ce2ff…`, 570,400 bytes --
the same runtime as 2026-10-14, its END cards now dated with this
build (that release's carried 2026-10-13's date, a stale object the
Makefile did not rebuild when the clock changed; it does now).  All 192
FCVS programs, 73 tests, the 600K source, the 85-deep nesting test, a
unit at each size limit, René Ferland's ADDAD and Doug Wegscheid's pi
spigot compile on the guest to the host's assembler, byte for byte, in
REGION=7168K.

- An ENTRY is compiled from its parent's whole text.  It had been
  compiled from the parent's declarations and then from the ENTRY
  statement on, so a GO TO from after the ENTRY back into the text
  before it had no statement to reach, and a legal program was refused
  ("statement label 5 is referred to but never defined").
- A subprogram and its ENTRY points share one set of static storage
  (SAVE, DATA, EQUIVALENCE).  Each ENTRY had had its own: a SAVEd
  variable set through one entry was not the one the other read.
  `tests/s370/entry3.f` has both; of the FCVS, FM509, FM517 and FM719
  change, and pass on MVS as before.

## 2026-10-14

Tagged `v2026.10.14`: faster code, found by measuring a reader's real
program against FORTRAN H, and a compiler that no longer ignores what it
does not understand.  Built from `6843cec`: FORT370.xmit SHA256
`68aba44b541f8530…`, 511,040 bytes; F77RT.obj unchanged from
2026-10-13.3, SHA256 `1239f98ff9697452…`, 570,400 bytes.  All 192 FCVS
programs, 72 tests, the 600K source, the 85-deep nesting test, a unit
at each size limit, René Ferland's ADDAD and Doug Wegscheid's pi spigot
compile on the guest to the host's assembler, byte for byte, in
REGION=7168K.  Doug's spigot (`bench/results-spigot-2026-10-14.txt`)
runs in 0.754 of FORTRAN H's time at OPT=2, from 1.055.

- A local scalar in static storage (SAVE, or an initial value) outside
  COMMON that the unit never stores is read-only, and its load moves
  out of loops, as a scalar dummy's already did -- unless it is in an
  EQUIVALENCE or the unit has ENTRY points.  LEN in Doug Wegscheid's
  spigot (`INTEGER LEN/30000/`) was reloaded on every pass;
  `tests/s370/ldro.f` checks each way such a variable can still
  change in a loop.
- MOD(X,Y) and X/Y of the same two values share one divide: DR leaves
  the remainder and the quotient in R0:R1, and the second takes its
  half while nothing has written the pair since.  For it, CSE now takes
  two integer constants of one value as the same operand within a
  block, so the two copies of 2*I-1 in Doug Wegscheid's pi spigot are
  one value.  Its inner loop goes from 28 instructions to 22 (FORTRAN H
  OPT=2: 26, with two divides); `tests/s370/divrem.f`.
- Text a statement's parser leaves unread is an error, "unexpected text
  after the statement": a missing comma (`DIMENSION A(3) B(2)`) or a
  form the compiler does not take.  Ignored, it had been ignored without
  a word -- the type-statement initial values of 2026-10-13.3 were lost
  this way, with every name after them.  Handlers that stopped one token
  short of the end (GO TO, STOP, PAUSE, ASSIGN, PARAMETER, block IF,
  ELSE IF, BACKSPACE and ENDFILE with parentheses) now read to it; the
  FCVS and every test compile to the same assembler.
- `jcl/F77CLG.jcl` and `docs/INSTALL-MVS.txt` say what to do when the
  assembly step ends with RC 8: its SYSPRINT is DUMMY, so add
  `//ASM.SYSPRINT DD SYSOUT=*` to see IFOX00's messages (NOLIST would
  hide them too).  A reader saw only the return code.

## 2026-10-13.3

The day's fourth release, tagged `v2026.10.13.3`: fixes for the first
real programs readers sent.  Built from `707f7f2`: FORT370.xmit SHA256
`088f429cb4545e8b…`, 510,800 bytes; F77RT.obj SHA256
`1239f98ff9697452…`, 570,400 bytes (the runtime changes, for A editing
of numeric items).  All 192 FCVS programs, 70 tests, the 600K source,
the 85-deep nesting test, a unit at each size limit, René Ferland's
ADDAD and Doug Wegscheid's pi spigot compile on the guest to the host's
assembler, byte for byte, in REGION=7168K; ADDAD assembles and links
there, and the spigot prints pi to 100 digits as gfortran does.

- Three code generation bugs found by René Ferland's ADDAD program (a
  1985 correspondence-analysis library, 2,187 lines), which compiled but
  then failed in IFOX00 with RC 8:
  - a REAL stored storage to storage into an element of a dummy array
    (`X(I)=-E` with `-E` spilled) gave `MVC 0(2,5)(4),...`: MVC takes no
    index register.  The address is now formed first, `LA 14,0(2,5)`.
  - a DO loop whose index was spilled gave `LR 2,/` in its BXLE/BXH
    test; such a loop now tests with an add, a compare and a branch.
  - a REAL read before anything assigned it stopped the compile with
    "missing operand" when stored; it is now 0.0, as an integer is 0.
  as370 accepted both bad statements; IFOX00 did not.
  `tests/s370/mvcidx.f` and `tests/s370/bxspill.f` reproduce them.
- A statement label that is referred to (GO TO, DO, IF, END=) but that
  no statement carries is an error; it had compiled, falling through.
- Initial values in a type statement, IBM's extension (`INTEGER
  N/9000/, A(3)/1,2*7/`), are the same as DATA for the whole entity.
  They had been skipped without a word, and with them every name after
  them in the statement: the variables were undefined and an array
  declared later lost its dimension.  Found in Doug Wegscheid's
  program on H390-MVS; `tests/s370/typeinit.f`.
- A editing of INTEGER, REAL and DOUBLE PRECISION items: text kept in
  numeric variables, as FORTRAN 66 and IBM's compilers keep it
  (`INTEGER D/1H5/` written with `A1`).  Aw writes the item's first w
  bytes as they lie in storage, padding on the left when w is larger,
  and reads the same way as into CHARACTER.  The runtime had printed
  stars on output and stopped on input.  Doug Wegscheid's program
  prints its digits this way; `tests/s370/holtext.f`.  F77RT.obj
  changes with this release.
- An intrinsic function's name not followed by `(` is a variable of
  the unit (`INTEGER LEN`), and an array of that name is the array; the
  compiler had stopped with "intrinsic needs arguments".  Also from
  Doug's program; `tests/s370/intrvar.f`.
- A character or Hollerith constant continued from a line that ends
  short of column 72 keeps the blanks out to 72, as the card had.  The
  host compiler had joined the continuation right after the last
  character, so a file with trimmed lines compiled differently on the
  host than the same deck on MVS; the port sweep found it in ADDAD.
  `tests/s370/contstr.f` checks both kinds.
- An integer read before anything assigned it no longer stops the
  compiler with "s370: missing operand" when it is compared or tested
  (`IF (I) 1,2,3`, `IF (I.GT.0)`): it is undefined in FORTRAN, and is
  now 0, an ordinary value, as it already was when passed to a call.
  Old programs written for FORTRAN H do this often.  FCVS FM718 loads
  its undefined argument with `LA 0,0` where it had `SR 0,0`.
- `bench/fcvs-jcl.py` writes the NIST FCVS as MVS jobs, one per
  program: F77CLG as an instream procedure, the program's source and
  its data instream, and the scratch data sets the suite opens, so the
  whole suite compiles, links and runs on the guest with no host in the
  loop.  Asked for on H390-MVS by Doug Wegscheid, as workload.

## 2026-10-13.2

The day's third release, tagged `v2026.10.13.2`, for one bug found by
the first program a reader tried.  Built from `1655d63`: FORT370.xmit
SHA256 `cc0efa8ef0d3e105…`, 510,560 bytes; F77RT.obj unchanged,
SHA256 `a41062cd214f7998…`, 569,840 bytes.  All 192 FCVS programs, 63
tests, the 600K source, the 85-deep nesting test and a unit at each
size limit compile on the guest to the host's assembler, byte for byte,
in REGION=7168K.

- A main program after its subprograms is compiled.  The compiler had
  begun a main program only before the first subprogram, so one after
  them was taken for more of the last subprogram, past its END, and
  never compiled: the source compiled without a word and the job failed
  at link or run time.  A PROGRAM statement inside a subprogram (its
  END missing) and a second main program are now refused, each with
  its message.  Reported by Marco Verpelli on H390-MVS.

## 2026-10-13.1

The day's second release, tagged `v2026.10.13.1`.  Built from
`8bac2de`: FORT370.xmit SHA256 `4ff22c51662f95fd…`, 510,560 bytes;
F77RT.obj unchanged from 2026-10-13, SHA256 `a41062cd214f7998…`,
569,840 bytes.  All 192 FCVS programs, 62 tests, the 600K source, the
85-deep nesting test and a unit at each size limit compile on the guest
to the host's assembler, byte for byte, in REGION=7168K.  This release
is about how large a unit the compiler takes, measured against FORTRAN
H in `bench/results-limits-2026-10-13.txt`.

- Larger units: 4096 symbols and 4096 statement labels in a unit, from
  1024 and 512 (four times that on a host, where the labels had not
  grown with the other tables).  Symbols are found by hashing, not by
  scanning them all; an array's bounds live in a row of their own, so a
  scalar no longer carries 112 bytes of them; flags and types are bytes
  and halfwords.  The list of a unit's locals is sized by its
  instructions, which it can never outnumber: past 4096 locals it had
  been written beyond its end.  On MVS, 464K more storage (4.4MB with
  the code): every FCVS program and test compiles in REGION=7168K, from
  6656K, the heaviest being FM912, whose interference graph wants 1MB
  in one piece.  (The 2026-10-13 notes said 6144K, measured on eight
  programs; FM509, FM910 and FM912 needed 6656K.)  How
  large a unit fort370 and FORTRAN H each take is measured in
  `bench/results-limits-2026-10-13.txt`.
- A constant subscript, A(3) or the 2 of A(I,2), is part of the
  address's displacement: one instruction where it had been four (the
  constant, a shift, an add and the lower bound).  Units of
  straight-line array code compile to about 900 statements on MVS, from
  499, and the branches and labels a unit may hold are now bounded by
  its 1024 blocks: 508 logical IFs and 1017 labelled statements, more
  than FORTRAN H takes at OPT=2.  An address over an array's base is
  shared within a block, not across the unit, so it does not hold a
  register from its first use to its last.  71 FCVS programs compile
  differently, with 1.5% fewer statements of assembler among them (20
  grew, by at most 4%, where registers fell out differently); each
  still prints what it did on MVS, and the kernels print H's checksums.
- A small subroutine kept whole for the inliner no longer keeps the
  comment lines between its END and the next unit: the 600K test file,
  a block of comments after each of 200 subroutines, had held 750K of
  heap for them.
- An undefined value -- a variable read before anything assigned it,
  as FCVS FM718 does on a failure line -- is passed to a call as zero;
  the code generator had looked up a register for it before the start
  of its table.  The diagnostic messages say `f77:`.

## 2026-10-13

Built from `b85619e`: FORT370.xmit SHA256 `ce198b41447fe930…`, 510,320
bytes; F77RT.obj SHA256 `a41062cd214f7998…`, 569,840 bytes.  All 192
FCVS programs, 62 tests, a 600K source of 204 units and an expression
nested 85 deep compile on the guest to the host's assembler, byte for
byte, in REGION=8192K.  The language and the code it compiles to are
as on 2026-10-12; this release is about the compiler fitting MVS.

- `jcl/F77CLG.jcl`'s GO step asks for REGION=4096K.  It had none, and a
  job class's default region is too small for a program with large
  arrays: matmul (525K) ended at once with return code 12.
- The source is streamed: the compiler holds a statement, or a unit,
  and 32K of lookahead instead of the whole file, so a source file of
  any length compiles (it was refused past 256K), and FORT370 needs
  256K less (6.2MB with its code).  On MVS the first reading copies
  SYSIN to the work data set SYSUT1 for the second; `jcl/F77CLG.jcl`
  and `docs/INSTALL-MVS.txt` have the DD.  Without SYSUT1 the whole
  source is kept in storage, as before.  `tests/host/stream.sh`
  compiles a 600K file, the same through a 1K window.
- CI builds the SLOW-32 reference compiler too: the constants-from-text
  change had broken it, unseen.
- Less storage on MVS: FORT370's static storage and code are 3.9MB, from
  6.2MB.  The tables only one phase uses -- SSA construction's, the
  instruction selector's costs and rules, the interference graph's
  edges -- are allocated for that phase and freed after, so they no
  longer all sit in storage at once; the seven buffers of 8 to 33K that
  sat in stack frames (two of them in recursive ones) are on the heap or
  static; and libc370's stack is 128K, not 256K, with expressions limited
  to 90 levels of nesting (FCVS FM045 has 57), refused with a message
  past that.  And 34 per-instruction tables that hold an instruction
  index or no more -- sources, blocks, use counts, registers, list
  links, positions -- are halfwords (hir_ix), 560K less.  The largest
  FCVS units and the 600K test file compile in REGION=6144K; 8192K stays
  the recommendation.

## 2026-10-12

The first release.  Built from `887e804`: FORT370.xmit SHA256
`ef22abf9405d9423…`, 496,000 bytes; F77RT.obj SHA256
`378de5218fd62d7e…`, 569,840 bytes.  All 192 FCVS programs and 62
tests compile on the guest to the host's assembler, byte for byte.

- **The compiler.** The FORTRAN 77 front end and SSA optimizer of
  [slow32-public/fortran](https://github.com/brazilofmux/slow32-public/tree/main/fortran),
  which passes NIST's FCVS 2.1, over a new S/370 back end: BURS
  instruction selection with storage operands and index registers,
  iterated register coalescing with even/odd pairs for `BXLE`, a static
  area per unit, far branches past the code base's 4K, and IFOX00
  assembler out with standard OS linkage.  All 192 FCVS programs
  compile.
- **On MVS itself.** FORT370, the same C built with cc370, runs in
  REGION=8192K (its tables brought from 9.7MB to 6.4MB) and writes, byte
  for byte, what the host compiler writes; F77RT, the runtime as object
  decks, lets IFOX00 and IEWL on the guest make a running program
  (`docs/INSTALL-MVS.txt`, `jcl/F77CLG.jcl`).  SYSIN may be `DD *`.  On a
  host the tables have four times the room.
- **Measured against FORTRAN H.** Seven kernels (daxpy, ddot, matmul,
  three Livermore loops, LINPACK) print FORTRAN H's checksums to the
  digit and run at 0.89 to 1.00 of H's CPU time at OPT=2, H measured the
  same hour (`bench/results-s370-2026-10-12d.txt`).
- **The runtime.** fort370's own, in C for libc370 (`runtime/s370`):
  formatted, list-directed, unformatted and internal I/O; OPEN, CLOSE
  and INQUIRE in MVS terms (units are DD names `FTnnF001`); its own
  HFP-aware mathematical library; exact decimal conversion; direct
  access by BSAM and BDAM, as IBM's FORTRAN did it, and unformatted
  sequential files positioned by record count; LGE and its kin in
  ASCII's collating sequence, as the standard asks.
- **The FCVS on MVS 3.8j**, through that runtime: 192 programs, 3346
  tests passed, 2 failed, both expected: NIST deleted FM923's test CT022
  but left its two cards in FM923.DAT, so tests 22 and 23 read them, as
  they do under gfortran.  The files run as distributed, and what every
  program that is not a clean pass must print is pinned in
  `bench/fcvs-expected.txt` (`bench/results-fcvs-2026-10-12.txt`).
- **Host build and CI.** `make`, `make check-asm` (62 programs to their
  committed assembler, byte-identical on Linux, macOS and Windows) and
  `make test`; a date tag publishes the host binaries, and the MVS
  package is attached, built by `make mvs` with its clock pinned so that
  the SHA256s above reproduce.
