#!/bin/sh
# fcvs.sh [FM...] -- the FCVS on MVS: build every FM*.FOR of the corpus
# (FCVS=~/refs/fcvs/fcvs21) as a load module with bench/mkload.sh, ship
# them to the guest in batches with bench/ship.py, keep each program's
# printed report in bench/out/fcvs/FMnnn.txt and summarize what each
# said of itself: the FCVS routines count their own PASS, FAIL and
# DELETED tests.  FM001's test 2 fails by design.
#
# A program that needs its FMnnn.DAT on unit 5 gets it as FT05F001.
#
# RUNNER as elsewhere in bench/; the guest arrangement of ship.py.
set -u
B=$(cd "$(dirname "$0")" && pwd); R=$(cd "$B/.." && pwd); O=$B/out; F=${FCVS:-$HOME/refs/fcvs/fcvs21}
mkdir -p "$O/fcvs"
BATCH=${BATCH:-9}
if [ $# -gt 0 ]; then progs="$*"; else progs=$(cd "$F" && ls FM*.FOR | sed 's/\.FOR$//'); fi
built=""; nfail=0
for n in $progs; do
  if "$B/mkload.sh" "$F/$n.FOR" "$n" >/dev/null 2>"$O/fcvs/$n.build"; then built="$built $n"; rm -f "$O/fcvs/$n.build"
  else nfail=$((nfail+1)); echo "$n: build failed: $(grep -m1 'ERROR\|error\|f77:' "$O/fcvs/$n.build")"; fi
done
echo "built $(echo $built | wc -w | tr -d ' '), failed $nfail"
set -- $built
k=0
while [ $# -gt 0 ]; do
  batch=""; sysin=""; i=0
  while [ $# -gt 0 ] && [ $i -lt $BATCH ]; do
    # a program with a data file reads it on unit 5: ship it alone with --sysin
    if [ -f "$F/$1.DAT" ]; then
      if [ -z "$batch" ]; then batch="$O/$1.xmit"; sysin="$F/$1.DAT"; shift; fi
      break
    fi
    batch="$batch $O/$1.xmit"; shift; i=$((i+1))
  done
  k=$((k+1))
  if [ -n "$sysin" ]; then python3 "$B/ship.py" --sysin "$sysin" --out "$O/fcvs/batch$k.out" $batch
  else python3 "$B/ship.py" --out "$O/fcvs/batch$k.out" $batch; fi
done
# the reports, one file per program, and the summary
python3 "$B/fcvs_summary.py" "$O/fcvs"
