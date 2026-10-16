#!/bin/sh
# port.sh -- the MVS runtime (runtime/s370/f77rt.c, f77misc.c, the
# f77intN.c that f77int.lst names, and f77rt.h) is what
# runtime/s370/port.py makes of runtime/libf77.c: regenerated, it must
# not change.  An edit to the generated files instead of to libf77.c or
# port.py would be lost at the next regeneration.
cd "$(dirname "$0")/../.." || exit 2
rm -rf out/port; mkdir -p out/port
gen() { echo runtime/s370/f77rt.c runtime/s370/f77rt.h runtime/s370/f77misc.c runtime/s370/f77int.lst runtime/s370/f77int[0-9]*.c; }
cp $(gen) out/port/
python3 runtime/s370/port.py >/dev/null || exit 1
bad=0
for f in $(gen); do cmp -s "$f" "out/port/$(basename "$f")" || bad=1; done
[ "$(ls out/port | wc -l)" -eq "$(gen | wc -w)" ] || bad=1
if [ $bad -eq 0 ]; then
  echo "port: f77rt.c, f77rt.h, f77misc.c and the f77intN.c are port.py's output"
else
  echo "port: a runtime file differs from what port.py makes of libf77.c"
  cp out/port/* runtime/s370/
  exit 1
fi
