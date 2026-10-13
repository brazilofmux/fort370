"""The FCVS summary: one report per program from the batch outputs.

A report runs from the FCVS header to its PASS/FAIL/DELETED counts; the
subset-level routines also print END OF PROGRAM, the full-language ones
do not, and the program names itself in the header.  Usage:
python3 fcvs_summary.py DIR  (DIR holds batch*.out; writes DIR/FMnnn.txt)."""
import glob, re, sys, os

def summarize(d):
    rows = {}
    for f in sorted(glob.glob(os.path.join(d, 'batch*.out'))):
        t = open(f, 'rb').read().decode('latin-1')
        heads = [m.start() for m in re.finditer(r'FORTRAN COMPILER VALIDATION SYSTEM', t)]
        for i, h in enumerate(heads):
            end = heads[i + 1] if i + 1 < len(heads) else len(t)
            seg = t[h:end]
            nm = re.search(r'\b(FM\d{3})\b', seg)
            if not nm: continue
            name = nm.group(1)
            p = re.search(r'(\d+)\s+TESTS PASSED', seg)
            if not p:
                # a report without counts: the inspection programs
                # (FM005, FM109: text to look at; FM500: counts withheld
                # as *****), or one that ended early (FM257 STOPs in its
                # test 6 by design)
                if name in rows: continue
                if re.search(r'\*+\s+TESTS PASSED', seg): rows[name] = 'inspection (counts withheld)'
                elif 'END OF PROGRAM' in seg or 'END OF TEST' in seg: rows[name] = 'inspection (no counts)'
                else:
                    last = re.findall(r'^\s+(\d+)\s+(?:PASS|FAIL|DELETE)', seg, re.M)
                    rows[name] = 'ends after test %s' % last[-1] if last else 'no report'
                open(os.path.join(d, name + '.txt'), 'w').write(seg[:6000])
                continue
            fl = re.search(r'(\d+)\s+TESTS FAILED', seg); dl = re.search(r'(\d+)\s+TESTS DELETED', seg)
            open(os.path.join(d, name + '.txt'), 'w').write(seg[:seg.find('TESTS PASSED') + 2000])
            r = (int(p.group(1)), int(fl.group(1)) if fl else 0, int(dl.group(1)) if dl else 0)
            if name in rows and isinstance(rows[name], tuple):
                rows[name] = tuple(a + b for a, b in zip(rows[name], r))   # a routine reporting in parts
            else:
                rows[name] = r
        for m in re.finditer(r'Stepname: GO(\d+)\s+Program name: (FM\d+)', t):
            name = m.group(2)
            ab = re.search(r'HERC01S\s+GO' + m.group(1) + r'\s+-\s+ABEND (\S+)', t)
            if ab and not isinstance(rows.get(name), tuple):
                rows[name] = 'ABEND ' + ab.group(1) + (', ' + rows[name] if name in rows and rows[name].startswith('ends') else '')
            elif name not in rows:
                rows[name] = 'no report'
    tot_p = tot_f = 0
    for name in sorted(rows):
        r = rows[name]
        if isinstance(r, tuple):
            tot_p += r[0]; tot_f += r[1]
            print('%s pass %3d fail %3d deleted %3d%s' % (name, r[0], r[1], r[2], '' if r[1] == 0 or name == 'FM001' else '   <--'))
        else:
            print('%s %s%s' % (name, r, '' if r.startswith('inspection') or name == 'FM257' else '   <--'))
    print('%d programs, %d tests passed, %d failed' % (len(rows), tot_p, tot_f))

if __name__ == '__main__':
    summarize(sys.argv[1])
