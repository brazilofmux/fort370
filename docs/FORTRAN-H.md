# FORTRAN H

## Where this began

Compiler optimization began with Fortran. The first FORTRAN compiler, built
by John Backus's team at IBM and delivered in 1957, existed to show that
compiled code could rival hand-written assembler. Without that, nobody would
have given up hand coding. Index-register allocation, common subexpressions
and loop analysis were in it from the start, because the language's whole
case depended on them.

FORTRAN H took that further a decade later. It was IBM's optimizing compiler
for System/360, and its optimizer is the subject of E. S. Lowry and C. W.
Medlock, "Object Code Optimization", *Communications of the ACM* 12(1),
January 1969. That paper covers flow analysis over a whole program unit,
common-expression elimination, moving invariant code out of loops, strength
reduction, and register allocation planned around loops. Each of these is
still standard in compilers today, because they worked here first.

The FORTRAN H on TK4- and TK5 is level 21.8, June 1974.

This project measures against it. That isn't a contest. Anything fort370
does in an optimizer was done here first, by people who had no prior work to
build on. The point of measuring is to learn what that compiler already
knew, and to be honest about whether a new one deserves a place beside it.

## The measurement

On 2026-10-12, under Hercules, seven kernels went through the system's
`FORTHCLG` procedure at each of OPT=0, 1 and 2. Each kernel is its own job,
so the GO step's CPU time (IEF374I) is that kernel alone. The kernels are
written in Fortran IV, which is what H accepts. All arithmetic is REAL*8.
Each kernel repeats its work enough to run for seconds and prints a
checksum, which is the correctness check and also keeps the work from being
optimized away.

| kernel | what it is | work |
|---|---|---|
| daxpy  | `Y(I)=Y(I)+A*X(I)` | n=1000, 200,000 reps |
| ddot   | `S=S+X(I)*Y(I)` | n=1000, 200,000 reps |
| matmul | `C=C+A*B`, J-K-I order, B(K,J) hoisted by hand | n=100, 200 reps |
| lll1   | Livermore loop 1, hydro fragment | n=1000, 200,000 reps |
| lll5   | Livermore loop 5, tri-diagonal elimination, a recurrence | n=1000, 200,000 reps |
| lll7   | Livermore loop 7, equation of state | n=1000, 100,000 reps |
| linpk  | LINPACK 100: MATGEN, DGEFA, DGESL, with the BLAS as subroutines | 1,000 solves |

The BLAS in `linpk` are the unit-stride loops: INCX and INCY are accepted
and ignored. MATGEN's integer `MOD` arithmetic counts in `linpk`'s time.

The kernels, the deck generator, the runner, the results and H's OPT=2
object listings are in `bench/`.

### CPU seconds, GO step

| kernel | OPT=0 | OPT=1 | OPT=2 | OPT=2 rerun | OPT=0 / OPT=2 |
|---|---:|---:|---:|---:|---:|
| daxpy  | 15.23 |  6.52 |  4.40 |  4.47 | 3.5x |
| ddot   | 12.60 |  6.11 |  3.37 |  3.38 | 3.7x |
| matmul | 26.37 | 10.53 |  5.04 |  5.15 | 5.2x |
| lll1   | 23.10 | 11.50 |  8.85 |  8.94 | 2.6x |
| lll5   | 19.23 |  7.06 |  5.53 |  5.53 | 3.5x |
| lll7   | 32.83 | 18.14 | 15.14 | 15.06 | 2.2x |
| linpk  | 36.95 | 24.73 | 13.64 | 13.63 | 2.7x |

Absolute times depend on the host Hercules runs on, but the ratios don't.
Repeat runs agree within about 2%. Every checksum is the same at all three
levels and matches the closed form where there is one: DAXPY gives 100,100,
and LINPACK's solution is all ones, so it sums to 100, with INFO 0. A
compile takes 0.01 to 0.04 s of CPU and 832K of virtual storage.

### The code it writes

These are the inner loops at OPT=2, from the listings:

| loop | H at OPT=2 | instructions | floor without unrolling |
|---|---|---:|---:|
| daxpy  | `LD MDR AD STD BXLE`, A held in FPR4 | 5 | 5 |
| ddot   | `LD MD ADR BXLE`, S held in FPR4 | 4 | 4 |
| lll5   | `LD SD MD STD BXLE`; X(I-1) is reread, but as SD's own operand | 5 | 5 |
| lll1   | 8 floating-point operations, then BXLE | 9 | 9 |
| lll7   | 20 floating-point operations, then BXLE | 21 | 21 |
| matmul | `LR AR LD MDR AD STD AR BXLE` | 8 | 5 |
| linpk's DAXPY | `LD MDR AD STD BXLE` | 5 | 5 |

On every simple loop here, H at OPT=2 is already at the floor.
- Invariants are hoisted, into floating-point registers when one is free.
- Reductions stay in registers.
- Array elements are storage operands, so a load costs nothing extra.
- Every loop closes with a single BXLE.

The System/360 has four floating-point registers. lll1 and lll7 read R, T
and Q from storage because all four are in use, and nothing simple does
better.

### What is left

These aren't flaws, just the places where a later compiler has room:

1. **Nested-loop addressing.** In matmul, A(I,K) and C(I,J) advance by the
   same stride, but H keeps two index registers and rebuilds one each time
   (`LR`, `AR`). With each column's base in a register, one index would
   serve both: 5 instructions instead of 8. The outer loops keep their
   counters and offsets in memory temporaries and update them with
   `L`/`A`/`ST`.
2. **Unrolling.** H doesn't unroll, so BXLE is one instruction in four or
   five in the BLAS-like loops. Unrolling by four takes DAXPY from 5
   instructions per element to 4.25.
3. **Calls.** LINPACK calls DAXPY once per column, paying the full linkage
   and DAXPY's guard tests each time. Small leaf routines in the same
   compilation could be inlined. (fort370 does this: a unit of up to 12
   statements is spliced into its callers in the same source file, and
   DGEFA's DAXPY loop is `LDR / MD / AD / STD / BXLE`.)

Hercules charges per instruction, not per pipeline stall, so instruction
count is the right measure on these systems. Tricks for real pipelines,
such as multiple accumulators, gain nothing here.

## What it asks of fort370

- **Falling short is easy.** OPT=0 is 2.2 to 5.2 times slower than OPT=2.
  A back end that allocates registers one statement at a time, without
  hoisting invariants or strength-reducing subscripts, would land between
  OPT=0 and OPT=1.
- **Matching H** takes what Lowry and Medlock described: invariants moved
  out of loops and into registers, subscripts reduced to a byte index that
  BXLE steps, storage operands chosen where they're free, and allocation
  that respects four floating-point registers.
- **Going past it** means the items in "What is left". On these kernels
  that is worth perhaps 10 to 35%, not multiples. A FORTRAN 77 compiler
  that brought the newer language and gave up H's speed would not be worth
  having.

## Not measured yet

- REAL*4, INTEGER-heavy code and COMPLEX.
- The cost of formatted I/O.
- Large subprograms: how H's OPT=2 copes with them, and whether it degrades
  or refuses.
- FORTRAN G and WATFIV.
- Real FORTRAN 77 programs.
