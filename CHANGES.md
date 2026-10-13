# Changes

One entry per release, newest first. A release is named by its date and
tagged `vYYYY.MM.DD`; the tag's message carries what it brought and, once
the compiler runs on the guest, the SHA256 of its MVS package. Each entry
names the fort370 commit it was built from, so `git log` between two
entries has the detail. Host binaries for Linux, macOS and Windows come
with each release, built and checked by CI on their own platforms.

## Unreleased

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
