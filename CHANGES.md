# Changes

One entry per release, newest first. A release is named by its date and
tagged `vYYYY.MM.DD`; the tag's message carries what it brought and, once
the compiler runs on the guest, the SHA256 of its MVS package. Each entry
names the fort370 commit it was built from, so `git log` between two
entries has the detail. Host binaries for Linux, macOS and Windows come
with each release, built and checked by CI on their own platforms.

## Unreleased

The first release, everything to date (2026-10-12):

- **The compiler.** The FORTRAN 77 front end and SSA optimizer of
  [slow32-public/fortran](https://github.com/brazilofmux/slow32-public/tree/main/fortran),
  which passes NIST's FCVS 2.1, over a new S/370 back end: BURS
  instruction selection with storage operands and index registers,
  iterated register coalescing with even/odd pairs for `BXLE`, a static
  area per unit, far branches past the code base's 4K, and IFOX00
  assembler out with standard OS linkage. All 192 FCVS programs compile.
- **Measured against FORTRAN H.** Seven kernels (daxpy, ddot, matmul,
  three Livermore loops, LINPACK) print FORTRAN H's checksums to the
  digit and run at 0.89 to 1.00 of H's CPU time at OPT=2, H measured
  the same hour (`bench/results-s370-2026-10-12d.txt`).
- **The runtime.** fort370's own, in C for libc370
  (`runtime/s370`): formatted, list-directed, unformatted and internal
  I/O, OPEN, CLOSE and INQUIRE in MVS terms (units are DD names
  `FTnnF001`), its own HFP-aware mathematical library, exact decimal
  conversion, and records -- direct access by BSAM and BDAM, as IBM's
  FORTRAN did it, and unformatted sequential files positioned by record
  count, since QSAM cannot seek.
- **The FCVS on MVS 3.8j**, through that runtime: 192 programs, 3318
  tests passed, 2 failed, the two being cards in the 1997 data file
  that their program never lists (`bench/results-fcvs-2026-10-12.txt`).
- **Host build and CI.** `make`, `make check-asm` (62 programs to their
  committed assembler, byte-identical on every platform) and `make test`
  on Linux, macOS and Windows; a date tag publishes the binaries.
