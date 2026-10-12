#!/bin/sh
# Build the compiler for the host.  One translation unit: src/f77.c
# includes the front end and, from backend/, the optimizer and code
# generator.  The output is out/f77.
#
# At this stage the back end is still the SLOW-32 one, so what out/f77
# writes is SLOW-32 assembly.  The host build exists to prove the copy
# is whole and to run the front end over the test corpus.
set -eu
HERE="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$HERE/out"
CC="${CC:-cc}"
$CC -O1 -w -I "$HERE/backend" -o "$HERE/out/f77" "$HERE/src/f77.c"
echo "built: $HERE/out/f77"
