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
standard OS linkage, static storage per unit and symbolic references
the linkage editor resolves; the I/O is FORTRAN H's `IBCOM#` or the
compiler's own runtime (`runtime/s370`, C for libc370 with its own
libm and exact decimal conversion). All 192 FCVS programs compile,
link and run on TK5 through that runtime: 3227 tests pass, and each of
the 24 that fail is a runtime gap (direct access and unformatted
records, which need record-level I/O on MVS), a discrepancy in the
1997 data file, or by design (`bench/results-fcvs-2026-10-12.txt` has
the accounting). The seven kernels and the programs in `tests/s370/`
print FORTRAN H's results to the digit. CPU seconds of the GO step,
against H at OPT=2 on the same system (the last block of
`bench/results-s370-2026-10-12d.txt`; about 2% of any figure is
run-to-run drift):

| kernel  | fort370 | FORTRAN H OPT=2 |
|---------|--------:|----------------:|
| daxpy   |    4.41 |            4.40 |
| ddot    |    3.49 |            3.49 |
| matmul  |    4.50 |            5.04 |
| lll1    |    9.06 |            9.15 |
| lll5    |    5.54 |            5.53 |
| lll7    |   14.80 |           15.14 |
| linpack |   12.97 |           13.64 |

The inner loops are H's: daxpy is `LD / MDR / AD / STD / BXLE`, and
matmul's is five instructions to H's eight; an outer loop that only
counts is one `BXH`. What H does that this compiler does not yet:
parameter lists built once in static storage, and a second base
register for code beyond 4K (a branch to such a target here loads its
address from the pool, `L 15,=A(L) / BC m,0(,15)`). What is not yet
written: record-level I/O in the runtime, for direct access and
unformatted files, and the XMIT package that would put the compiler
on the system. `docs/BACKEND.md` has the design and the record of the
work.

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
    runtime/              the I/O runtime, in C: libf77.c is the SLOW-32 one,
                          runtime/s370/ the MVS one generated from it by
                          port.py, with its own libm and exact conversion
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
    bench/abc.sh          the same, fort370 with its own runtime as a load module
    bench/mkload.sh       compile, assemble and link one program on the host
    bench/ship.py         ship load modules to the guest and run them
    bench/fcvs.sh         the FCVS on MVS; fcvs_summary.py reads the reports
    bench/listings/       H's OPT=2 object listings
    bench/results-*.txt   the raw timings and the FCVS results

## License

MIT. See `LICENSE`.
