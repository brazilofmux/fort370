#!/bin/sh
# Build the compiler for the host.  One translation unit: src/f77.c
# includes the front end and, from backend/, the optimizer and the
# code generator.
#
#   out/f77      the S/370 compiler: Fortran in, IFOX00 assembler out
#   out/f77-s32  the same front end over the SLOW-32 back end it was
#                copied with, kept as a reference
set -eu
HERE="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$HERE/out"
CC="${CC:-cc}"
$CC -O1 -w -DF77_TARGET_S370 -I "$HERE/backend" -o "$HERE/out/f77" "$HERE/src/f77.c"
$CC -O1 -w -I "$HERE/backend" -o "$HERE/out/f77-s32" "$HERE/src/f77.c"
echo "built: $HERE/out/f77 $HERE/out/f77-s32"
