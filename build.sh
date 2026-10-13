#!/bin/sh
# build.sh -- the host build, kept for habit: make does it now.
#   out/f77      the S/370 compiler: Fortran in, IFOX00 assembler out
#   out/f77-s32  the same front end over the SLOW-32 back end, a reference
set -eu
cd "$(dirname "$0")"
make out/f77 out/f77-s32
echo "built: $(pwd)/out/f77 $(pwd)/out/f77-s32"
