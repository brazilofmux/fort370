#!/bin/sh
# mkload.sh prog.f [NAME] -- compile a Fortran program with fort370, assemble
# it with as370, link it with the runtime (built here with cc370 when it
# is out of date) and libc370 into an MVS load module, and write
# bench/out/NAME.xmit for bench/ship.py.  NAME defaults to the source's
# basename in upper case, cut to eight characters.
set -e
p=${1:?usage: mkload.sh prog.f [NAME]}
B=$(cd "$(dirname "$0")" && pwd); R=$(cd "$B/.." && pwd); O=${OUT:-$B/out}; mkdir -p "$O" "$R/out/crt"
n=${2:-$(basename "$p" .f | tr a-z A-Z | cut -c1-8)}
# the runtime objects
for f in f77rt f77misc $(cat "$R/runtime/s370/f77int.lst") f77dtoa f77main f77err f77math f77mz f77mzc f77mchk f77mlr f77mld f77rec millicode; do
  if [ ! -f "$R/out/crt/$f.o" ] || [ "$R/runtime/s370/$f.c" -nt "$R/out/crt/$f.o" ] ||
     [ "$R/runtime/s370/f77rt.h" -nt "$R/out/crt/$f.o" ] || [ "$R/runtime/s370/f77rec.h" -nt "$R/out/crt/$f.o" ] ||
     [ "$R/runtime/s370/f77m.h" -nt "$R/out/crt/$f.o" ]; then
    cc370 -O1 -c -o "$R/out/crt/$f.o" "$R/runtime/s370/$f.c"
  fi
done
# the assembler: the shims for the integer intrinsics passed as
# arguments, the extended-precision sum of the mathematical ones, and
# the SPIE exit for program interrupts
for f in f77ishim f77cshim f77xsum f77msq f77spie; do
  if [ ! -f "$R/out/crt/$f.o" ] || [ "$R/runtime/s370/$f.asm" -nt "$R/out/crt/$f.o" ]; then
    as370 -o "$R/out/crt/$f.o" "$R/runtime/s370/$f.asm" >/dev/null
  fi
done
"$R/out/f77" "$p" "$O/$n.asm"
as370 -o "$O/$n.o" "$O/$n.asm"
# the output file's name is the load module's member name
( cd "$O" && cc370 -o "$n" "$n.o" "$R/out/crt/f77rt.o" "$R/out/crt/f77misc.o" $(for f in $(cat "$R/runtime/s370/f77int.lst"); do echo "$R/out/crt/$f.o"; done) "$R/out/crt/f77dtoa.o" \
      "$R/out/crt/f77main.o" "$R/out/crt/f77err.o" "$R/out/crt/f77math.o" "$R/out/crt/f77mz.o" "$R/out/crt/f77mzc.o" "$R/out/crt/f77mchk.o" "$R/out/crt/f77mlr.o" "$R/out/crt/f77mld.o" \
      "$R/out/crt/f77rec.o" "$R/out/crt/f77ishim.o" "$R/out/crt/f77cshim.o" "$R/out/crt/f77xsum.o" "$R/out/crt/f77msq.o" "$R/out/crt/f77spie.o" "$R/out/crt/millicode.o" -Wl,--sparse-text -flinker-output=xmit )
echo "$O/$n.xmit"
