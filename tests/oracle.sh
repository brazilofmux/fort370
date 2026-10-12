#!/bin/bash
# Differential oracle: compile and run a fixed-form Fortran 77 program
# with gfortran in a container, and print exactly what it printed.
#
# Every compiler in this project is developed against a reference
# implementation -- LLVM for stage08, gforth for stage01.  This is F77's.
# The oracle runs NATIVE code; it is not a SLOW-32 emulator.  What is
# being compared is program output, not instructions.
#
# Usage:   ./oracle.sh prog.f [args...]
# Exit:    the program's own exit status (so STOP n is testable), or
#          2 when the oracle itself failed to compile the source.
#
# The container mounts only the source file's directory.  Podman on
# macOS runs in a VM that shares home paths but not /tmp, so sources
# must live somewhere under $HOME -- tests/ does.
set -u

IMAGE="${F77_ORACLE_IMAGE:-slow32:fortran-oracle}"

if command -v podman >/dev/null 2>&1; then ENGINE=podman
elif command -v docker >/dev/null 2>&1; then ENGINE=docker
else echo "oracle.sh: neither podman nor docker found" >&2; exit 2; fi

if [ $# -lt 1 ]; then echo "usage: oracle.sh prog.f [args...]" >&2; exit 2; fi

SRC="$1"; shift
if [ ! -f "$SRC" ]; then echo "oracle.sh: no such file: $SRC" >&2; exit 2; fi

DIR="$(cd "$(dirname "$SRC")" && pwd)"
BASE="$(basename "$SRC")"

if ! "$ENGINE" image exists "$IMAGE" 2>/dev/null && \
   ! "$ENGINE" images -q "$IMAGE" 2>/dev/null | grep -q .; then
    echo "oracle.sh: image $IMAGE not found." >&2
    echo "  build it:  $ENGINE build -t $IMAGE -f Dockerfile.fortran-oracle ." >&2
    exit 2
fi

# -i wires the caller's stdin through to the program, which is how
# READ-under-test gets its input; with no redirection it is harmless.
exec "$ENGINE" run --rm -i -v "$DIR:/work" "$IMAGE" "/work/$BASE" "$@"
