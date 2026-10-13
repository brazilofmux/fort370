#!/bin/sh
# check-asm.sh [--update] -- every test program compiles to exactly the
# assembler committed beside it: tests/f77/*.f, tests/s370/*.f and
# bench/kernels/*.f, each with its NAME.asm.  The compiler must give the
# same bytes on every host it is built on; CI runs this on each platform
# a release ships for.  --update rewrites the committed files, for a
# deliberate change to the code generated (review the diff).
cd "$(dirname "$0")/.." || exit 2
F77=out/f77
[ -x out/f77.exe ] && F77=out/f77.exe
update=0
[ "${1:-}" = "--update" ] && update=1
tmp=out/check-asm.tmp
n=0; bad=0
for f in tests/f77/*.f tests/s370/*.f bench/kernels/*.f; do
  a=${f%.f}.asm
  n=$((n+1))
  if ! "$F77" "$f" "$tmp" 2>out/check-asm.err; then
    echo "$f: does not compile"; sed 's/^/    /' out/check-asm.err; bad=$((bad+1)); continue
  fi
  if [ $update = 1 ]; then cp "$tmp" "$a"; continue; fi
  if [ ! -f "$a" ]; then echo "$f: no committed $a"; bad=$((bad+1)); continue; fi
  if ! cmp -s "$tmp" "$a"; then
    echo "$f: differs from $a"; diff "$a" "$tmp" | head -10; bad=$((bad+1))
  fi
done
rm -f "$tmp" out/check-asm.err
if [ $update = 1 ]; then echo "check-asm: $n assembler files written"; exit 0; fi
echo "check-asm: $n programs, $bad differ"
[ $bad = 0 ]
