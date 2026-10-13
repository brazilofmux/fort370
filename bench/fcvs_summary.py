"""The FCVS summary: one report per program from the batch outputs.

A report runs from the FCVS header to its PASS/FAIL/DELETED counts; the
subset-level routines also print END OF PROGRAM, the full-language ones
do not, and the program names itself in the header.  A program that
does not end in a clean pass must match what bench/fcvs-expected.txt
says it prints -- its summary line, and the text of its failures -- or it
is a deviation (marked <--).  Usage:
python3 fcvs_summary.py DIR  (DIR holds batch*.out; writes DIR/FMnnn.txt)."""
import glob, re, sys, os

def expectations():
    lines = {}
    texts = {}
    f = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'fcvs-expected.txt')
    for l in open(f):
        l = l.rstrip('\n')
        if not l.strip() or l.startswith('#'): continue
        name, rest = l.split(None, 1)
        if rest.startswith('expect '): texts.setdefault(name, []).append(' '.join(rest[7:].split()))
        else: lines[name] = rest
    return lines, texts

def summarize(d):
    rows = {}
    reports = {}
    for f in sorted(glob.glob(os.path.join(d, 'batch*.out'))):
        t = open(f, 'rb').read().decode('latin-1')
        heads = [m.start() for m in re.finditer(r'FORTRAN COMPILER VALIDATION SYSTEM', t)]
        for i, h in enumerate(heads):
            end = heads[i + 1] if i + 1 < len(heads) else len(t)
            seg = t[h:end]
            nm = re.search(r'\b(FM\d{3})\b', seg)
            if not nm: continue
            name = nm.group(1)
            reports[name] = reports.get(name, '') + seg
            p = re.search(r'(\d+)\s+TESTS PASSED', seg)
            if not p:
                # a report without counts: the inspection programs
                # (FM005, FM109: text to look at), one that ended early
                # (FM257 STOPs in its test 6 by design), or a count that
                # overflowed its field (FM500's did, before 8747604)
                if name in rows: continue
                if re.search(r'\*+\s+TESTS PASSED', seg): rows[name] = 'counts printed as *****'
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
    exp_line, exp_text = expectations()
    tot_p = tot_f = 0
    n_exp = n_dev = 0
    for name in sorted(rows):
        r = rows[name]
        if isinstance(r, tuple):
            tot_p += r[0]; tot_f += r[1]
            line = 'pass %3d fail %3d deleted %3d' % r
            clean = r[1] == 0 and r[2] == 0
        else:
            line = r
            clean = False
        if name in exp_line:
            text = ' '.join(reports.get(name, '').split())
            missing = [t for t in exp_text.get(name, []) if t not in text]
            if line == exp_line[name] and not missing:
                mark = '   (expected)'
                n_exp += 1
            else:
                mark = '   <-- not as bench/fcvs-expected.txt says'
                n_dev += 1
        elif clean:
            mark = ''
        else:
            mark = '   <--'
            n_dev += 1
        print('%s %s%s' % (name, line, mark))
    for name in sorted(set(exp_line) - set(rows)):
        print('%s did not run   <-- expected: %s' % (name, exp_line[name]))
        n_dev += 1
    print('%d programs, %d tests passed, %d failed; %d as expected, %d deviations'
          % (len(rows), tot_p, tot_f, n_exp, n_dev))

if __name__ == '__main__':
    summarize(sys.argv[1])
