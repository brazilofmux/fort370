#!/bin/sh
# abc.sh prog.f -- the same program through FORTRAN H on the guest and
# through fort370 with its own runtime (bench/mkload.sh, bench/ship.py);
# print what each wrote and whether they agree.  As bench/ab.sh, which
# runs the IBCOM# version through IFOX00 on the guest instead.
#
# The program's output lines must begin with " >" (a blank for carriage
# control, then the marker).  H writes a positive exponent as "D 06",
# the runtime as "D+06"; both are standard, and the blank is normalized
# to the plus before comparing.
#
# RUNNER as in run.sh; JOBUSER/JOBPASS as in mk.sh.  Keeps its files in
# $OUT (default bench/out).
export LC_ALL=C
: "${RUNNER:?set RUNNER to a command: RUNNER deck.jcl out.txt}"
p=${1:?usage: abc.sh prog.f}
B=$(cd "$(dirname "$0")" && pwd); O=${OUT:-$B/out}; mkdir -p "$O"
n=$(basename "$p" .f)
jn=$(echo "H$n" | tr a-z A-Z | cut -c1-8)
{
  printf '//%-8s JOB (1),%s,\n' "$jn" "'FORTH'"
  if [ -n "${JOBUSER:-}" ]; then
    printf '//             CLASS=A,MSGCLASS=Z,MSGLEVEL=(1,1),\n'
    printf '//             USER=%s,PASSWORD=%s\n' "$JOBUSER" "${JOBPASS:-}"
  else
    printf '//             CLASS=A,MSGCLASS=Z,MSGLEVEL=(1,1)\n'
  fi
  printf "//S1       EXEC FORTHCLG,SOUT=Z,PARM.FORT='OPT=2'\n"
  echo "//FORT.SYSIN DD *"
  expand "$p" | cut -c1-72
  echo "/*"
  echo "//GO.SYSIN DD DUMMY"
  echo "//"
} > "$O/$n-h.jcl"
$RUNNER "$O/$n-h.jcl" "$O/$n-h.out" >/dev/null 2>&1
grep -a '^>' "$O/$n-h.out" | sed 's/\([DE]\) \([0-9][0-9]\)/\1+\2/g' > "$O/$n-h.txt"
x=$("$B/mkload.sh" "$p" 2>&1 | tail -1) || { echo "$n: fort370 failed to build"; exit 1; }
python3 "$B/ship.py" --out "$O/$n-c.out" "$x" >/dev/null || { echo "$n: ship failed"; exit 1; }
# the last line ends in a carriage return and a form feed, and the
# printer's banner follows on the same line: cut it there
grep -a '^>' "$O/$n-c.out" | tr -d '\r' | sed 's/'"$(printf '\f')"'.*$//' > "$O/$n-c.txt"
if cmp -s "$O/$n-h.txt" "$O/$n-c.txt"; then
  echo "$n: same ($(wc -l < "$O/$n-c.txt" | tr -d ' ') lines)"
else
  echo "$n: DIFFER"
  diff "$O/$n-h.txt" "$O/$n-c.txt" | head -20
  grep -a 'ABEND\|f77:\|INTERRUPT AT' "$O/$n-c.out" | head -5
fi
