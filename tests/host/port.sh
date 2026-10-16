#!/bin/sh
# port.sh -- the MVS runtime (runtime/s370/f77rt.c, f77intr.c, f77rt.h) is what
# runtime/s370/port.py makes of runtime/libf77.c: regenerated, it must
# not change.  An edit to the generated files instead of to libf77.c or
# port.py would be lost at the next regeneration.
cd "$(dirname "$0")/../.." || exit 2
mkdir -p out/port
cp runtime/s370/f77rt.c runtime/s370/f77intr.c runtime/s370/f77rt.h out/port/
python3 runtime/s370/port.py >/dev/null || exit 1
if cmp -s runtime/s370/f77rt.c out/port/f77rt.c && cmp -s runtime/s370/f77intr.c out/port/f77intr.c &&
   cmp -s runtime/s370/f77rt.h out/port/f77rt.h; then
  echo "port: f77rt.c, f77intr.c and f77rt.h are port.py's output"
else
  echo "port: f77rt.c or f77rt.h differs from what port.py makes of libf77.c"
  cp out/port/f77rt.c out/port/f77intr.c out/port/f77rt.h runtime/s370/
  exit 1
fi
