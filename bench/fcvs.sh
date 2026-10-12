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
python3 - "$O/fcvs" <<'EOF'
import glob, re, sys, os
d = sys.argv[1]
rows = {}
for f in sorted(glob.glob(os.path.join(d, 'batch*.out'))):
    t = open(f, 'rb').read().decode('latin-1')
    # a program's report runs from its first heading to END OF PROGRAM
    for m in re.finditer(r'END OF PROGRAM\s+(FM\d+)', t):
        name = m.group(1)
        start = t.rfind('FORTRAN COMPILER VALIDATION SYSTEM', 0, m.start())
        if start < 0: start = max(0, m.start() - 20000)
        seg = t[start:m.end() + 2500]
        open(os.path.join(d, name + '.txt'), 'w').write(seg)
        p = re.search(r'(\d+)\s+TESTS PASSED', seg); fl = re.search(r'(\d+)\s+TESTS FAILED', seg); dl = re.search(r'(\d+)\s+TESTS DELETED', seg)
        rows[name] = (int(p.group(1)) if p else 0, int(fl.group(1)) if fl else 0, int(dl.group(1)) if dl else 0)
    for m in re.finditer(r'HERC01S\s+GO\d+\s+-\s+ABEND (\S+)', t):
        pass
    for m in re.finditer(r'Stepname: GO(\d+)\s+Program name: (FM\d+)', t):
        name = m.group(2)
        if name not in rows:
            ab = re.search(rf'HERC01S\s+GO{m.group(1)}\s+-\s+ABEND (\S+)', t)
            rows[name] = ('ABEND ' + ab.group(1)) if ab else 'no report'
tot_p = tot_f = 0
for name in sorted(rows):
    r = rows[name]
    if isinstance(r, tuple):
        tot_p += r[0]; tot_f += r[1]
        print('%s pass %3d fail %3d deleted %3d%s' % (name, r[0], r[1], r[2], '' if r[1] == 0 or name == 'FM001' else '   <--'))
    else:
        print('%s %s   <--' % (name, r))
print('%d programs, %d tests passed, %d failed' % (len(rows), tot_p, tot_f))
EOF
