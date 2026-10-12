#!/bin/sh
# ab.sh prog.f -- the same program through FORTRAN H and through fort370,
# on the same system; print what each wrote and whether they agree.
# The program's output lines must begin with " >" (a blank for carriage control, then the marker) so they can be picked
# out of the job's printed output.
#
# RUNNER as in run.sh; JOBUSER/JOBPASS as in mk.sh.  Keeps its files in
# $OUT (default bench/out).
export LC_ALL=C
: "${RUNNER:?set RUNNER to a command: RUNNER deck.jcl out.txt}"
p=${1:?usage: ab.sh prog.f}
B=$(cd "$(dirname "$0")" && pwd); O=${OUT:-$B/out}; mkdir -p "$O"
n=$(basename "$p" .f)
# FORTRAN H
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
grep -a '^>' "$O/$n-h.out" > "$O/$n-h.txt"
# fort370
"$B/../out/f77" "$p" "$O/$n.asm" || { echo "$n: fort370 failed to compile"; exit 1; }
"$B/asmclg.sh" "$O/$n.asm" "$n" > "$O/$n-f.jcl"
$RUNNER "$O/$n-f.jcl" "$O/$n-f.out" >/dev/null 2>&1
grep -a '^>' "$O/$n-f.out" > "$O/$n-f.txt"
if cmp -s "$O/$n-h.txt" "$O/$n-f.txt"; then
  echo "$n: same ($(wc -l < "$O/$n-f.txt" | tr -d ' ') lines)"
else
  echo "$n: DIFFER"
  diff "$O/$n-h.txt" "$O/$n-f.txt" | head -20
  grep -a 'ABEND\|IFO[0-9]\|IEW0\|IHC[0-9]' "$O/$n-f.out" | head -5
fi
