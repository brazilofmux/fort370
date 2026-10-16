# fort370 -- a FORTRAN 77 compiler for MVS 3.8j.
#
#   make              out/f77, the compiler: Fortran in, IFOX00 assembler out
#   make check-asm    every test program compiles to exactly the assembler
#                     committed beside it (tests/f77, tests/s370, bench/kernels)
#   make test         the host checks: the runtime's exact decimal conversion,
#                     the runtime's external names against the compiler's, and
#                     the MVS runtime regenerated from libf77.c without change
#   make asm          rewrite the committed assembler after a deliberate change
#   make runtime      the runtime's objects for linking on the host with cc370
#                     (needs mvslovers' cc370 and libc370; see bench/mkload.sh)
#   make mvs          the compiler itself as an MVS load module and its XMIT,
#                     out/mvs/FORT370.xmit (cc370 again)
#
# One translation unit: src/f77.c includes the front end and, from
# backend/, the optimizer and the S/370 code generator.  C99, no
# dependencies.  out/f77-s32 is the same front end over the SLOW-32 back
# end it came with, kept as a reference.

CC      ?= cc
CFLAGS  ?= -O1 -w
LDFLAGS ?=
SRC     := src/f77.c $(wildcard src/*.h src/*.c backend/*.h)

all: out/f77

out/f77: $(SRC)
	@mkdir -p out
	$(CC) $(CFLAGS) -DF77_TARGET_S370 -I backend -o $@ src/f77.c $(LDFLAGS)

# The host compiler with the guest's table ceilings (F77_ROOM=1, as on
# MVS): what FORT370 on the guest must match byte for byte
# (bench/port-sweep.py).  out/f77 has four times the room, and for a
# unit too large for the guest's tables it may code better.
out/f77-guest: $(SRC)
	@mkdir -p out
	$(CC) $(CFLAGS) -DF77_TARGET_S370 -DF77_ROOM=1 -I backend -o $@ src/f77.c $(LDFLAGS)

out/f77-s32: $(SRC)
	@mkdir -p out
	$(CC) $(CFLAGS) -I backend -o $@ src/f77.c $(LDFLAGS)

check-asm: out/f77
	@sh tests/check-asm.sh

asm: out/f77
	@sh tests/check-asm.sh --update

test: out/f77
	@CC="$(CC)" sh tests/host/dtoa.sh
	@sh tests/host/rtnames.sh
	@sh tests/host/port.sh
	@sh tests/host/units.sh
	@CC="$(CC)" sh tests/host/stream.sh

RT := f77rt f77dtoa f77main f77math f77rec millicode
runtime: $(RT:%=out/crt/%.o) out/crt/f77ishim.o out/crt/f77xsum.o

out/crt/%.o: runtime/s370/%.c runtime/s370/f77rt.h runtime/s370/f77rec.h Makefile
	@mkdir -p out/crt
	$(MVSCLOCK) cc370 -O1 -c -o $@ $<

out/crt/f77ishim.o: runtime/s370/f77ishim.asm Makefile
	@mkdir -p out/crt
	$(MVSCLOCK) as370 -o $@ $<

out/crt/f77xsum.o: runtime/s370/f77xsum.asm Makefile
	@mkdir -p out/crt
	$(MVSCLOCK) as370 -o $@ $<

# The compiler as an MVS load module, out/mvs/FORT370 and its XMIT:
# the same C, built with cc370 for libc370 (docs/INSTALL-MVS.txt).
mvs: out/mvs/FORT370.xmit out/mvs/F77RT.obj

# The clock is pinned (as370 and ld370 stamp the date and time into the
# deck and the module), so two builds of the same source are the same
# bytes and a package's SHA256 reproduces; MVSDATE/MVSTIME choose it.
MVSDATE ?= 26289
MVSTIME ?= 120000
MVSCLOCK = ASMDATE=10/16/26 ASMTIME=12.00 LDDATE=$(MVSDATE) LDTIME=$(MVSTIME)
out/mvs/FORT370.xmit: $(SRC) runtime/s370/millicode.c Makefile
	@mkdir -p out/mvs
	$(MVSCLOCK) cc370 -O1 -w -DF77_TARGET_S370 -I backend -c -o out/mvs/f77.o src/f77.c
	$(MVSCLOCK) cc370 -O1 -c -o out/mvs/millicode.o runtime/s370/millicode.c
	cd out/mvs && $(MVSCLOCK) cc370 -o FORT370 f77.o millicode.o -Wl,--sparse-text -flinker-output=xmit

# The runtime as object decks for IEWL on MVS (bench/mkrtlib.py)
out/mvs/F77RT.obj: runtime bench/mkrtlib.py out/f77
	@mkdir -p out/mvs
	python3 bench/mkrtlib.py $@

clean:
	rm -rf out

.PHONY: all check-asm asm test runtime mvs clean
