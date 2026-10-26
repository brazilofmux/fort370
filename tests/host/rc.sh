#!/bin/sh
# rc.sh -- the compiler's return code is the worst severity it reported,
# as IBM's compilers give it (#33): 0 a clean compile, 4 a warning (the
# source ends without an END), 8 an error, 12 a table of the compiler's
# too small for the unit, 16 no compile at all (no source).
cd "$(dirname "$0")/../.." || exit 2
F77=out/f77
[ -x out/f77.exe ] && F77=out/f77.exe
T=out/rc.tmp; mkdir -p $T
bad=0
rc() {    # file code
  "$F77" "$T/$1.f" "$T/$1.asm" 2>/dev/null
  r=$?
  if [ $r != $2 ]; then echo "rc: $1 gave $r; expected $2"; bad=$((bad+1)); fi
}
printf '      X = 1.0\n      END\n' > $T/clean.f
rc clean 0
printf '      X = 1.0\n      STOP\n' > $T/noend.f
rc noend 4
printf '      X = (1.0\n      END\n' > $T/syntax.f
rc syntax 8
printf '      X = (1.0\n' > $T/both.f
rc both 8
python3 bench/limits.py straight 12000 > $T/big.f
rc big 12
rc nosuch 16
rm -rf $T
[ $bad = 0 ] && echo "rc: a clean compile 0, a warning 4, an error 8, a table too small 12, no source 16"
[ $bad = 0 ]
