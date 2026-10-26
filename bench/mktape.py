#!/usr/bin/env python3
"""mktape.py OUT.aws -- the MVS package as a standard-label tape (AWS) for
Hercules (fort370 issue 36): mount it on a tape drive and IEBCOPY loads
the libraries straight from it, with no 3270 file transfer.

  file 1  FORT370.LOAD   the compiler's load library, IEBCOPY unloaded
  file 2  FORT370.F77RT  the runtime library, IEBCOPY unloaded
  file 3  F77CLG.JCL     the procedure, FB 80

The unloads are those in FORT370.xmit and F77RT.xmit (out/mvs): a TSO
TRANSMIT of a library is its IEBCOPY unload in NETDATA records, and the
second INMR02 describes the unload's own data set (RECFM, LRECL,
BLKSIZE), which the tape's labels carry.  The unload's records go one
segment to a block, as IEBCOPY writes them (RECFM=VS); in blocks of
several, as a VBS tape has them, IEBCOPY ends S0C4.

The tape is written here, from the standard label and AWS formats as
IBM and Hercules document them: VOL1; for each file HDR1, HDR2, a
tape mark, the data blocks, a tape mark, EOF1, EOF2 and a tape mark;
another tape mark at the end; each block behind AWS's 6-byte header.
tapemgr (https://github.com/brazilofmux/tapemgr) reads it back: with
TAPEMGR set, or tapemgr on PATH, its scan checks the tape.  The
labels' dates are the package's clock (MVSDATE, as the Makefile gives
it), so the tape's SHA256 reproduces.

Run from the repository root after `make mvs`."""
import os, shutil, subprocess, sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
VOLSER = 'FORT70'


def netdata(path):
    """The control records (name, bytes) and data records of a NETDATA file."""
    raw = open(path, 'rb').read()
    ctl, data = [], []
    cur = b''
    i = 0
    while i < len(raw):
        n = raw[i]
        if n < 2:
            break                                   # the last 80-byte record's padding
        flags = raw[i + 1]
        cur += raw[i + 2:i + n]
        i += n
        if flags & 0x40:                            # the segment ends its record
            if flags & 0x20:
                ctl.append((cur[:6].decode('cp037'), cur))
            else:
                data.append(cur)
            cur = b''
    return ctl, data


def text_units(rec):
    """INMR02's text units after its file number and utility name: {key: [values]}."""
    p = 6 + 4                                       # 'INMR02', the file number
    n = int.from_bytes(rec[p + 2:p + 4], 'big')     # INMUTILN's count of values
    p += 4
    for _ in range(n):
        p += 2 + int.from_bytes(rec[p:p + 2], 'big')
    tu = {}
    while p + 4 <= len(rec):
        key = int.from_bytes(rec[p:p + 2], 'big')
        cnt = int.from_bytes(rec[p + 2:p + 4], 'big')
        p += 4
        vals = []
        for _ in range(cnt):
            ln = int.from_bytes(rec[p:p + 2], 'big')
            vals.append(rec[p + 2:p + 2 + ln])
            p += 2 + ln
        tu[key] = vals
    return tu


def recfm(v):
    """INMRECFM as letters: X'C000' U, X'8000' F, X'4000' V; X'1000' B, X'0800' S."""
    base = {0xC000: 'U', 0x8000: 'F', 0x4000: 'V'}.get(v & 0xC000, '?')
    return base + ('B' if v & 0x1000 else '') + ('S' if v & 0x0800 else '')


def unload(path):
    """The IEBCOPY unload in a TRANSMIT of a library: its records and DCB."""
    ctl, data = netdata(path)
    r2 = [rec for name, rec in ctl if name == 'INMR02']
    if len(r2) < 2:
        sys.exit('mktape: %s has no INMCOPY INMR02' % path)
    tu = text_units(r2[-1])
    num = lambda k: int.from_bytes(tu[k][0], 'big')
    rf = recfm(num(0x0049))
    if rf not in ('VS', 'VBS'):
        sys.exit('mktape: %s: the unload is RECFM %s, not VS' % (path, rf))
    return data, num(0x0042), num(0x0030)          # INMLRECL, INMBLKSZ


def ebc(s, n):
    return s.ljust(n)[:n].encode('cp037')


class Aws:
    """An AWS tape image being written."""
    def __init__(self, path):
        self.f = open(path, 'wb')
        self.prev = 0

    def block(self, data):
        self.f.write(len(data).to_bytes(2, 'little') + self.prev.to_bytes(2, 'little') + b'\xa0\x00' + data)
        self.prev = len(data)

    def tapemark(self):
        self.f.write(b'\x00\x00' + self.prev.to_bytes(2, 'little') + b'\x40\x00')
        self.prev = 0

    def close(self):
        self.f.close()


def hdr1(kind, dsn, seq, date, nblocks):
    return (ebc(kind, 4) + ebc(dsn[-17:], 17) + ebc(VOLSER, 6) + ebc('0001', 4) + ebc('%04d' % seq, 4)
            + ebc('', 4) + ebc('', 2) + ebc(date, 6) + ebc(date, 6) + ebc('0', 1)
            + ebc('%06d' % nblocks, 6) + ebc('IBM OS/VS 370', 13) + ebc('', 7))


def hdr2(kind, recfm, blksize, lrecl, battr):
    return (ebc(kind, 4) + ebc(recfm, 1) + ebc('%05d' % blksize, 5) + ebc('%05d' % lrecl, 5)
            + ebc('3', 1) + ebc('0', 1) + ebc('FORT370 /MKTAPE', 17) + ebc('', 2) + ebc('', 1)
            + ebc('', 1) + ebc(battr, 1) + ebc('', 41))


def vs_blocks(recs, blksize):
    """Variable spanned, unblocked: each block a BDW and one segment."""
    room = blksize - 8
    out = []
    for r in recs:
        if len(r) <= room:
            segs = [(0, r)]
        else:
            pieces = [r[i:i + room] for i in range(0, len(r), room)]
            segs = [(1, pieces[0])] + [(3, x) for x in pieces[1:-1]] + [(2, pieces[-1])]
        for code, d in segs:
            sdw = (len(d) + 4).to_bytes(2, 'big') + bytes([code, 0])
            out.append((len(d) + 8).to_bytes(2, 'big') + b'\0\0' + sdw + d)
    return out


def fb_blocks(lines, lrecl, blksize):
    recs = [ebc(l.rstrip('\n'), lrecl) for l in lines]
    n = blksize // lrecl
    return [b''.join(recs[i:i + n]) for i in range(0, len(recs), n)]


def mvsdate():
    """The package's clock: MVSDATE YYDDD as the Makefile sets it."""
    for line in open(os.path.join(REPO, 'Makefile')):
        if line.startswith('MVSDATE ?='):
            yyddd = line.split('=')[1].strip()
            return ('0' if int(yyddd[:2]) < 70 else ' ') + yyddd   # c yyddd: c 0 for 20xx
    sys.exit('mktape: no MVSDATE in the Makefile')


def main():
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    out = os.path.abspath(sys.argv[1])
    date = mvsdate()
    files = []
    for dsn, xmit in (('FORT370.LOAD', 'FORT370.xmit'), ('FORT370.F77RT', 'F77RT.xmit')):
        recs, lrecl, blksize = unload(os.path.join(REPO, 'out', 'mvs', xmit))
        files.append((dsn, 'V', blksize, lrecl, 'S', vs_blocks(recs, blksize)))
    jcl = open(os.path.join(REPO, 'jcl', 'F77CLG.jcl')).read().split('\n')
    if jcl and jcl[-1] == '':
        jcl = jcl[:-1]
    files.append(('F77CLG.JCL', 'F', 3120, 80, 'B', fb_blocks(jcl, 80, 3120)))
    t = Aws(out)
    t.block(ebc('VOL1', 4) + ebc(VOLSER, 6) + ebc('0', 1) + ebc('', 5) + ebc('', 25) + ebc('FORT370', 10) + ebc('', 29))
    for seq, (dsn, recfm, blksize, lrecl, battr, blocks) in enumerate(files, 1):
        t.block(hdr1('HDR1', dsn, seq, date, 0))
        t.block(hdr2('HDR2', recfm, blksize, lrecl, battr))
        t.tapemark()
        for b in blocks:
            t.block(b)
        t.tapemark()
        t.block(hdr1('EOF1', dsn, seq, date, len(blocks)))
        t.block(hdr2('EOF2', recfm, blksize, lrecl, battr))
        t.tapemark()
    t.tapemark()
    t.close()
    tm = os.environ.get('TAPEMGR') or shutil.which('tapemgr')
    if tm:
        r = subprocess.run([tm, 'scan', out], capture_output=True, text=True)
        if r.returncode != 0 or 'Total Files: %d' % len(files) not in r.stdout:
            sys.exit('mktape: tapemgr cannot read the tape back:\n' + r.stdout + r.stderr)
    print('mktape: %s, volume %s: %s' % (out, VOLSER, ', '.join(
        '%s (%d blocks)' % (f[0], len(f[5])) for f in files)))


if __name__ == '__main__':
    main()
