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

2026-10-13. The compiler runs on MVS 3.8j itself: FORT370, a load
module built from the same C with cc370, compiles in REGION=8192K and
writes, byte for byte, what the host compiler writes for every FCVS
program and test; with F77RT, the runtime as object decks, IFOX00 and
IEWL on the guest make a running program (`docs/INSTALL-MVS.txt`,
`jcl/F77CLG.jcl`). On a host, `out/f77` compiles a program unit to IFOX00 assembler with
standard OS linkage, static storage per unit and symbolic references
the linkage editor resolves; the I/O is FORTRAN H's `IBCOM#` or the
compiler's own runtime (`runtime/s370`, C for libc370 with its own
libm, exact decimal conversion, and direct access through BDAM). All
192 FCVS programs compile, link and run on TK5 through that runtime:
3346 tests pass, and the 2 that fail are FM923's, which NIST's data
file causes for every compiler (a deleted test's cards were left in it;
`bench/fcvs-expected.txt` pins the expected output, and
`bench/results-fcvs-2026-10-12.txt` has the accounting). The seven kernels and the programs in `tests/s370/`
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

A real program, not a kernel: Doug Wegscheid's pi spigot (9000 digits,
a MOD and a divide by `2*I-1` 270 million times) runs in 8.99 seconds
to H's 11.93 at OPT=2, the same digits, because fort370 takes the
quotient and the remainder from one `DR` where H divides twice
(`bench/results-spigot-2026-10-14.txt`).

The inner loops are H's: daxpy is `LD / MDR / AD / STD / BXLE`, and
matmul's is five instructions to H's eight; an outer loop that only
counts is one `BXH`. What H does that this compiler does not yet:
parameter lists built once in static storage, and a second base
register for code beyond 4K (a branch to such a target here loads its
address from the pool, `L 15,=A(L) / BC m,0(,15)`). The MVS package
is FORT370.xmit and F77RT.obj, built by `make mvs`. `docs/BACKEND.md` has the design and the record of the
work.

How large a program unit each compiler takes
(`bench/results-limits-2026-10-13.txt`): on MVS a fort370 unit holds
8192 instructions in 1024 blocks, which comes to about 900 statements
of straight-line array code, 500 logical IFs, 1000 labelled statements
or 2700 scalar variables. H at OPT=2 takes fewer IFs and labels (450
and 900) but far more straight-line code and variables (at least 8000
and 16000). On a host the ceilings are four times as large. A source
file may hold any number of units.

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

## Building and using it

Each dated release carries host binaries for Linux, macOS and Windows,
built and checked by CI on their own platforms (the binary is
`fort370`), and the MVS package, FORT370.xmit and F77RT.obj, built by
`make mvs` with its clock pinned so that the SHA256 in the release
notes reproduces. The Linux and Windows ones are static. The macOS one is
unsigned: if it came through a browser, `xattr -d
com.apple.quarantine fort370` lets it run. To build from source:

    make

No dependencies beyond a C compiler. `make check-asm` compiles every
test program and compares it with the assembler committed beside it,
which is what CI does on each platform; `make test` runs the host
checks (Python 3).

    out/f77 program.f program.asm

compiles a file of program units to one assembler source with
standard OS linkage, which assembles with IFOX00 on the guest or with
mvslovers' as370 on a host. A program needs fort370's runtime
(`runtime/s370`, C for libc370): `make runtime` builds its objects
with [cc370](https://github.com/mvslovers/cc370), and
`bench/mkload.sh program.f` shows the whole host path, from Fortran
to a load module and its XMIT. The main program's CSECT is `F77MAIN`;
libc370's startup calls it through the runtime's `main`. Units are the
DD names `FTnnF001`, 0 to 99 (6 falls back to SYSPRINT, 5 to SYSIN,
0 to SYSTERM), and a
direct-access file is a DASD data set of fixed blocks, RECL bytes each.

## Layout

    src/                  the FORTRAN 77 front end and the driver, f77.c
    backend/              the optimizer, the S/370 code generator
                          (hir_*_s370.h, s370_hfp.h) and the SLOW-32 one
    runtime/              the I/O runtime, in C: libf77.c is the SLOW-32 one,
                          runtime/s370/ the MVS one generated from it by
                          port.py, with its own libm and exact conversion
    tests/f77/            regression programs; tests/oracle.sh runs gfortran
    tests/s370/           programs run through both H and fort370 on MVS
    Makefile              make: out/f77; make check-asm, make test, make runtime,
                          make mvs (FORT370.xmit and F77RT.obj)
    jcl/F77CLG.jcl        compile, assemble, link and go on MVS
    docs/INSTALL-MVS.txt  installing and running the compiler on MVS
    CHANGES.md            what each release brought
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
    bench/fcvs-jcl.py     the FCVS as 192 MVS jobs, compiled, linked and run there
    bench/port-sweep.py   every program compiled on the guest, diffed with the host's
    bench/clg-test.py     the MVS package installed and used on the guest
    bench/mkrtlib.py      the runtime as object decks for IEWL (F77RT.obj)
    bench/listings/       H's OPT=2 object listings
    bench/results-*.txt   the raw timings and the FCVS results

## License

MIT. See `LICENSE`.
