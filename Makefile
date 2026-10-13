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

out/f77-s32: $(SRC)
	@mkdir -p out
	$(CC) $(CFLAGS) -I backend -o $@ src/f77.c $(LDFLAGS)

check-asm: out/f77
	@sh tests/check-asm.sh

asm: out/f77
	@sh tests/check-asm.sh --update

test: out/f77
	@sh tests/host/dtoa.sh
	@sh tests/host/rtnames.sh
	@sh tests/host/port.sh

RT := f77rt f77dtoa f77main f77math f77rec millicode
runtime: $(RT:%=out/crt/%.o) out/crt/f77ishim.o

out/crt/%.o: runtime/s370/%.c runtime/s370/f77rt.h runtime/s370/f77rec.h
	@mkdir -p out/crt
	cc370 -O1 -c -o $@ $<

out/crt/f77ishim.o: runtime/s370/f77ishim.asm
	@mkdir -p out/crt
	as370 -o $@ $<

clean:
	rm -rf out

.PHONY: all check-asm asm test runtime clean
