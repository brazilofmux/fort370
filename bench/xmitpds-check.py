#!/usr/bin/env python3
"""xmitpds-check.py [N] -- bench/xmitpds.py against mvslovers' xmit370.

For N libraries of text members (default 20), of random number and
size, with the sizes that matter for the layout among them (one record,
a block exactly, a block and one more, many blocks), xmit370 makes a
TRANSMIT file and xmitpds.xmit() makes one of the same members: the two
must be the same bytes, INMFTIME taken from xmit370's.  This is what
shows xmitpds lays out the unload, the directory and the NETDATA
records as xmit370 does; aliases and binary members, which xmit370 does
not make, are checked on MVS (bench/clg-test.py RECEIVEs F77RT.xmit).
Skipped when xmit370 is not on PATH."""
import os, random, shutil, subprocess, sys, tempfile

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import xmitpds


def records(data):
    out, cur, ctl, i = [], b'', False, 0
    while i < len(data) and data[i]:
        ln, fl = data[i], data[i + 1]
        if fl & 0x80: cur, ctl = b'', bool(fl & 0x20)
        cur += data[i + 2:i + ln]
        if fl & 0x40: out.append((ctl, cur))
        i += ln
    return out


def main():
    n = int(sys.argv[1]) if len(sys.argv) > 1 else 20
    if not shutil.which('xmit370'):
        print('xmitpds-check: no xmit370 on PATH, skipped'); return 0
    random.seed(1978)
    work = tempfile.mkdtemp(prefix='xmitpds-')
    bad = 0
    for t in range(n):
        d = os.path.join(work, 'src%d' % t)
        os.makedirs(d)
        for k in range(random.randint(1, 300)):
            name = 'Q%02d%04d' % (t, k)
            lines = random.choice([1, 2, 38, 39, 40, 77, 78, 79, 117, random.randint(1, 900)])
            open(os.path.join(d, name), 'w').write('\n'.join('%s %d' % (name, i) for i in range(lines)) + '\n')
        ref_path = os.path.join(work, 'ref%d.xmit' % t)
        subprocess.run(['xmit370', 'create', '--dsn', 'HERC01.TEST.PDS', '--no-stats', '-o', ref_path, d],
                       check=True, capture_output=True)
        ref = open(ref_path, 'rb').read()
        r01 = [r for c, r in records(ref) if c][0]
        j = r01.index(bytes.fromhex('1024')) + 6
        ftime = r01[j:j + 16].decode('cp037')[:14]
        mem = [(f, xmitpds.text_records(os.path.join(d, f))) for f in sorted(os.listdir(d))]
        got = xmitpds.xmit('HERC01.TEST.PDS', mem, ftime=ftime)
        if got != ref:
            print('xmitpds-check: library %d differs from xmit370\'s' % t); bad += 1
    shutil.rmtree(work)
    print('xmitpds-check: %d of %d libraries the same bytes as xmit370\'s' % (n - bad, n))
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
