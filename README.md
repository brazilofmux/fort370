# fort370

A FORTRAN 77 compiler for MVS 3.8j, intended to run on MVS 3.8j itself and
emit S/370 assembler for the system's own IFOX00 and IEWL. The front end
and the optimizer are copied from slow32-public; the S/370 back end is
new, and its first version is here. This repository started with a
measurement, because the bar was already known.

## The bar

Optimizing compilers began with Fortran. On MVS 3.8j the language is
Fortran IV, through FORTRAN G, WATFIV and FORTRAN H. H is the optimizing
compiler whose techniques were published by Lowry and Medlock in 1969, and
compilers have used them ever since. A FORTRAN 77 compiler for this system
is worth having only if it brings the 1978 language without giving up what
H delivers.

[`docs/FORTRAN-H.md`](docs/FORTRAN-H.md) measures what H delivers. Seven
kernels, including LINPACK 100 and three Livermore loops, were run at
OPT=0, 1 and 2. At OPT=2, H's inner loops are as short as they can be
without unrolling. The remaining room is in nested-loop addressing,
unrolling and calls, and it is worth perhaps 10 to 35%, not multiples.

## The plan

- **Front end:** the FORTRAN 77 compiler in
  [slow32-public/fortran](https://github.com/brazilofmux/slow32-public/tree/main/fortran),
  which passes NIST's FCVS 2.1, 192 programs of 192.
- **Back end:** that compiler's SSA optimizer (invariant code motion,
  strength reduction, BURS instruction selection), retargeted to S/370.
  The target is four floating-point registers, base-plus-displacement
  addressing and BXLE, inside a 24-bit region. Fortran program units
  compile independently, so the optimizer needs only one unit in memory at
  a time.
- **Oracle:** FORTRAN H's own output and timings for the same programs, on
  the same system.

## Where it stands

2026-10-12. `out/f77` compiles a program unit to IFOX00 assembler with
standard OS linkage, static storage per unit, FORTRAN H's `IBCOM#` for
formatted output and STOP, and symbolic references the linkage editor
resolves. All 192 FCVS programs compile; the seven kernels and the
programs in `tests/s370/` have been assembled, linked and run on TK5,
and print FORTRAN H's results to the digit. CPU seconds of the GO
step, against H at OPT=2 on the same system (the last block of
`bench/results-s370-2026-10-12d.txt`; about 2% of any figure is
run-to-run drift):

| kernel  | fort370 | FORTRAN H OPT=2 |
|---------|--------:|----------------:|
| daxpy   |    4.46 |            4.40 |
| ddot    |    3.49 |            3.49 |
| matmul  |    4.59 |            5.04 |
| lll1    |    9.20 |            9.15 |
| lll5    |    5.55 |            5.53 |
| lll7    |   14.98 |           15.14 |
| linpack |   13.18 |           13.64 |

The inner loops are H's: daxpy is `LD / MDR / AD / STD / BXLE`, and
matmul's is five instructions to H's eight. What H does that this
compiler does not yet: parameter lists built once in static storage,
and an outer loop reduced to a single `BXLE`. What is not yet written:
the compiler's own I/O runtime (`IBCOM#` covers only H's repertoire),
branches beyond 4K of code, the FCVS run on MVS itself, and the XMIT
package that would put the compiler on the system. `docs/BACKEND.md`
has the design and the record of the work.

## The larger aim

The back end matters more than the compiler. On SLOW-32 it produces
tighter code than GCC. Ported to S/370, it could generate code for more
languages than Fortran on MVS 3.8j. Fortran comes first because FORTRAN H
gives an honest standard: a back end that holds its own against H on the
loops has proved itself. A second comparison is C-shaped code against
cc370, which is GCC 3.4.6 for the 370.

The back end stays separate from the Fortran front end. Only the
front-end contract crosses between them, so if another language arrives,
the back end can move out without being untangled. The optimizer,
instruction selection and register allocation are what carry over. Each
language's runtime model, such as COBOL's decimal arithmetic or Pascal's
nested procedures, is still its own work.

## Layout

    src/                  the FORTRAN 77 front end and the driver, f77.c
    backend/              the optimizer, the S/370 code generator
                          (hir_*_s370.h, s370_hfp.h) and the SLOW-32 one
    runtime/              the formatted-I/O runtime, still in C for SLOW-32;
                          runtime/s370/ holds IPRINT/DPRINT, which write a
                          value to the job log for debugging on MVS
    tests/f77/            regression programs; tests/oracle.sh runs gfortran
    tests/s370/           programs run through both H and fort370 on MVS
    build.sh              host build: out/f77 (S/370) and out/f77-s32
    PROVENANCE.md         where the copies came from, and how to check them
    docs/FORTRAN-H.md     the measurement, and why it is measured
    docs/FITTING.md       the region TK5 grants, and what the compiler needs
    docs/BACKEND.md       the S/370 back end: design, decisions, record
    bench/kernels/        the seven kernels, in Fortran IV
    bench/mk.sh           a FORTHCLG deck for one kernel at one OPT level
    bench/run.sh          all of them through H; RUNNER is the submit command
    bench/asmclg.sh       an IFOX00, IEWL and GO deck for one .asm file
    bench/ab.sh           one program through H and through fort370, compared
    bench/listings/       H's OPT=2 object listings
    bench/results-*.txt   the raw timings

## License

MIT. See `LICENSE`.
