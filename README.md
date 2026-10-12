# fort370

A FORTRAN 77 compiler for MVS 3.8j, intended to run on MVS 3.8j itself and
emit S/370 assembler for the system's own IFOX00 and IEWL. The front end
and the optimizer are here, copied from slow32-public; the S/370 back
end is not yet. This repository started with a measurement, because the
bar was already known.

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
    backend/              the optimizer and (for now) the SLOW-32 code generator
    runtime/              the formatted-I/O runtime, still in C for SLOW-32
    tests/f77/            regression programs; tests/oracle.sh runs gfortran
    build.sh              host build: out/f77
    PROVENANCE.md         where the copies came from, and how to check them
    docs/FORTRAN-H.md     the measurement, and why it is measured
    docs/FITTING.md       the region TK5 grants, and what the compiler needs
    bench/kernels/        the seven kernels, in Fortran IV
    bench/mk.sh           a FORTHCLG deck for one kernel at one OPT level
    bench/run.sh          all of them; RUNNER is the local submit command
    bench/listings/       H's OPT=2 object listings
    bench/results-*.txt   the raw timings

## License

MIT. See `LICENSE`.
