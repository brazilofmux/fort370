#!/bin/sh
# units.sh -- how the compiler divides a source into program units, where
# a mistake loses a unit without a word: a PROGRAM statement inside a
# subprogram (its END missing) and a second main program are refused,
# each with its message.  tests/s370/mainlast.f has a main program after
# its subprograms, compiled to the assembler committed beside it.
cd "$(dirname "$0")/../.." || exit 2
F77=out/f77
[ -x out/f77.exe ] && F77=out/f77.exe
T=out/units.tmp; mkdir -p $T
bad=0
expect() {    # file message
  if "$F77" "$T/$1.f" "$T/$1.asm" 2>"$T/$1.err"; then
    echo "units: $1 compiled; expected: $2"; bad=$((bad+1))
  elif ! grep -q "$2" "$T/$1.err"; then
    echo "units: $1 said:"; sed 's/^/    /' "$T/$1.err"; bad=$((bad+1))
  fi
}
printf '      SUBROUTINE PRINTIT\n      RETURN\n      PROGRAM HELLO\n      CALL PRINTIT\n      END\n' > $T/noend.f
expect noend "line 3: PROGRAM statement inside a subprogram: the END before it is missing"
printf '      PROGRAM A\n      END\n      PROGRAM B\n      END\n' > $T/twomain.f
expect twomain "line 3: more than one main program"
rm -rf $T
[ $bad = 0 ] && echo "units: a missing END and a second main program refused"
[ $bad = 0 ]
