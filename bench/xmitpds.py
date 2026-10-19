#!/usr/bin/env python3
"""xmitpds.py -- a partitioned data set of 80-byte records, members and
aliases, as a TSO TRANSMIT (NETDATA) file that MVS RECEIVEs: the form in
which F77RT, the runtime library, is shipped beside FORT370.xmit
(fort370 issue 22).

mvslovers' xmit370 makes such files from text; F77RT's members are
object decks, binary, and IEWL finds them by alias as often as by name,
and xmit370 does neither.  This writes the same structure, from the
formats as documented (cc370's internals/unload-format.md,
xmit-format.md and xmit-source-pds.md; https://xmi.readthedocs.io) and
as measured on xmit370's own output, which it reproduces byte for byte
for a text library (bench/xmitpds-check.py).  No code is taken from
xmit370, which is GPL; this file is MIT, as fort370 is.

The transmission is one file, an IEBCOPY unload of the library:

  COPYR1, COPYR2   the unload's header: the library's DCB, the source
                   device (a 3350) and its extent
  directory        256-byte blocks keyed by their last name, entries in
                   EBCDIC order: NAME TTR C, C X'80' for an alias, no
                   user data; then a 12-byte end-of-directory record
  member data      FB blocks of BLKSIZE as CKD record images, packed on
                   3350 tracks, each member ending in a DL=0 record

wrapped in NETDATA: INMR01, INMR02 (IEBCOPY, the library), INMR02
(INMCOPY, the unload), INMR03, the data records, INMR06; segments of up
to 255 bytes in a stream cut into 80-byte records.
"""
import time

TRACK = 19254          # 3350 track bytes, against 185 + DL per record
TRK_CYL = 30           # 3350 tracks per cylinder
CYL0 = 0x8d            # the first cylinder the unload's addresses use

# COPYR1 and COPYR2 as an unload of a PO FB80 library from a 3350 has
# them; mkhdr() stamps the BLKSIZE and the extent.
COPYR1 = bytes.fromhex(
    '00ca6d0f02000c300050900000000c443050200b00004a7d0230001e4b36010b'
    '5208020000000000000000000000000000000000')
assert len(COPYR1) == 52
COPYR2_HEAD = bytes.fromhex(
    '01000000ff0000008f096644049bd0e8500027c80000008d0000008d001d001e')
COPYR2_LEN = 276


def e(s):
    return s.encode('cp037')


def mkhdr(blksize, ncyl):
    c1 = bytearray(COPYR1)
    c1[6:8] = blksize.to_bytes(2, 'big')                # the library's BLKSIZE
    c1[14:16] = (blksize + 20).to_bytes(2, 'big')       # the unload's
    c2 = bytearray(COPYR2_HEAD + bytes(COPYR2_LEN - len(COPYR2_HEAD)))
    c2[26:28] = (CYL0 + ncyl - 1).to_bytes(2, 'big')    # the extent's last cylinder
    c2[30:32] = (ncyl * TRK_CYL).to_bytes(2, 'big')     # and its tracks
    return bytes(c1), bytes(c2)


def count(cc, hh, r, kl, dl):
    return bytes([0, 0, 0, 0]) + cc.to_bytes(2, 'big') + hh.to_bytes(2, 'big') + bytes([r, kl]) + dl.to_bytes(2, 'big')


def blocks_of(records, blksize):
    per = blksize // 80
    return [b''.join(records[i:i + per]) for i in range(0, len(records), per)]


def unload(members, aliases, blksize):
    """members: [(name, [80-byte EBCDIC records])]; aliases: {alias: member}.
    Returns (header records, directory records, member records): the
    logical records of the unload, as NETDATA carries them."""
    order = sorted(members, key=lambda m: e(m[0].ljust(8)))
    # member data: CKD images packed along 3350 tracks
    track, used, r = 0, 0, 0
    ttr = {}
    mrecs = []

    def place(dl, then=0):
        """the next record's address, with `then` more bytes still to
        fit on its track"""
        nonlocal track, used, r
        if used + 185 + dl + then > TRACK:
            track, used, r = track + 1, 0, 0
        used, r = used + 185 + dl, r + 1
        return track, r

    for name, recs in order:
        bl = blocks_of(recs, blksize)
        out = []
        # A record goes on a track only with room left for one more
        # record's 185 bytes after it, the DL=0 record too.  A short
        # last block shares its logical record with the
        # DL=0 record; after a full one that is a record of its own.
        # (As xmit370 lays them out.)
        short = bool(bl) and len(bl[-1]) < blksize
        for k, b in enumerate(bl):
            t, rr = place(len(b), 185)
            if k == 0: ttr[name] = (t, rr)
            out.append(count(CYL0 + t // TRK_CYL, t % TRK_CYL, rr, 0, len(b)) + b)
        t, rr = place(0, 185)
        if not bl: ttr[name] = (t, rr)
        eom = count(CYL0 + t // TRK_CYL, t % TRK_CYL, rr, 0, 0)
        if short:
            out[-1] = out[-1] + eom
        else:
            out.append(eom)
        mrecs.extend(out)
    ncyl = -(-(track + 2) // TRK_CYL)
    # directory: members and aliases, EBCDIC order, 12 bytes each
    ents = [(e(n.ljust(8)), ttr[n], 0x00) for n, _ in members]
    ents += [(e(a.ljust(8)), ttr[m], 0x80) for a, m in aliases.items()]
    ents.sort()
    dblocks = []
    cur, last = b'', None
    for nm, (t, rr), c in ents:
        if 2 + len(cur) + 12 > 256:
            dblocks.append((last, cur)); cur = b''
        cur += nm + t.to_bytes(2, 'big') + bytes([rr, c])
        last = nm
    if 2 + len(cur) + 12 > 256:
        dblocks.append((last, cur)); cur = b''
    cur += b'\xff' * 8 + bytes(4)                            # the terminator entry
    dblocks.append((b'\xff' * 8, cur))
    drecs = []
    for k, (key, body) in enumerate(dblocks):
        blk = (len(body) + 2).to_bytes(2, 'big') + body
        rec = count(0, 0, 0, 8, 256) + key + blk + bytes(256 - len(blk))
        if k == len(dblocks) - 1:
            rec += bytes(12)                                 # end of directory
        drecs.append(rec)
    c1, c2 = mkhdr(blksize, ncyl)
    return [c1, c2], drecs, mrecs


def tu(key, *vals):
    out = key.to_bytes(2, 'big') + len(vals).to_bytes(2, 'big')
    for v in vals:
        out += len(v).to_bytes(2, 'big') + v
    return out


def netdata(recs):
    """[(control?, bytes)] -> the FB80 stream."""
    out = b''
    for ctl, r in recs:
        segs = [r[i:i + 253] for i in range(0, len(r), 253)] or [b'']
        for k, s in enumerate(segs):
            fl = (0x80 if k == 0 else 0) | (0x40 if k == len(segs) - 1 else 0) | (0x20 if ctl else 0)
            out += bytes([len(s) + 2, fl]) + s
    return out + bytes(-len(out) % 80)


def xmit(dsn, members, aliases=None, blksize=3120, ftime=None, node='ORIGNODE', user='HERC01', touser=None):
    """The TRANSMIT file, bytes.  ftime: 'yyyymmddhhmmss' for INMFTIME, by
    default now; a release pins it, so that the file reproduces."""
    aliases = aliases or {}
    touser = touser or user
    if ftime is None: ftime = time.strftime('%Y%m%d%H%M%S', time.gmtime())
    hdr, drecs, mrecs = unload(members, aliases, blksize)
    data = sum(len(r) for r in mrecs)
    whole = data + sum(len(r) for r in hdr) + sum(len(r) for r in drecs)
    ndir = max(10, len(drecs) + 5)
    i4 = lambda v: v.to_bytes(4, 'big')
    r01 = e('INMR01') + tu(0x0042, i4(80)) + tu(0x1011, e(node)) + tu(0x1012, e(user)) + \
          tu(0x1001, e(node)) + tu(0x1002, e(touser)) + tu(0x1024, e(ftime + '00')) + tu(0x102f, b'\x01')
    r02a = e('INMR02') + i4(1) + tu(0x1028, e('IEBCOPY')) + tu(0x102c, i4(data)) + \
           tu(0x000c, ndir.to_bytes(3, 'big')) + tu(0x0042, i4(80)) + tu(0x003c, b'\x02\x00') + \
           tu(0x0030, i4(blksize)) + tu(0x0049, b'\x90\x00') + tu(0x0002, *[e(q) for q in dsn.split('.')])
    r02b = e('INMR02') + i4(1) + tu(0x1028, e('INMCOPY')) + tu(0x102c, i4(whole)) + \
           tu(0x0042, i4(blksize + 16)) + tu(0x003c, b'\x40\x00') + tu(0x0030, i4(blksize + 20)) + \
           tu(0x0049, b'\x48\x02')
    r03 = e('INMR03') + tu(0x102c, i4(data)) + tu(0x0042, i4(80)) + tu(0x003c, b'\x40\x00') + tu(0x0049, b'\x00\x01')
    recs = [(True, r01), (True, r02a), (True, r02b), (True, r03)]
    recs += [(False, r) for r in hdr + drecs + mrecs]
    recs.append((True, e('INMR06')))
    return netdata(recs)


def text_records(path):
    """A text file's lines as FB80 EBCDIC records, as xmit370 makes them
    (for bench/xmitpds-check.py)."""
    lines = open(path, encoding='ascii').read().split('\n')
    if lines and lines[-1] == '': lines.pop()        # the last line's newline
    return [e(line.rstrip().ljust(80)) for line in lines]


def read(data):
    """A TRANSMIT file of an FB80 PDS read back: ({name: [records]},
    {alias: member}).  For checking what xmit() wrote."""
    recs, cur, ctl, i = [], b'', False, 0
    while i < len(data) and data[i]:
        ln, fl = data[i], data[i + 1]
        if fl & 0x80: cur, ctl = b'', bool(fl & 0x20)
        cur += data[i + 2:i + ln]
        if fl & 0x40: recs.append((ctl, cur))
        i += ln
    body = b''.join(r for c, r in recs if not c)[len(COPYR1) + COPYR2_LEN:]
    # the directory: 276-byte block records (count, key, block), then 12 zeros
    ents, p = [], 0
    while body[p + 9] == 8:
        blk = body[p + 20:p + 276]
        used = int.from_bytes(blk[:2], 'big')
        q = 2
        while q < used:
            nm, t, rr, c = blk[q:q + 8], int.from_bytes(blk[q + 8:q + 10], 'big'), blk[q + 10], blk[q + 11]
            if nm != b'\xff' * 8: ents.append((nm.decode('cp037').rstrip(), (t, rr), c))
            q += 12 + 2 * (c & 0x1f)
        p += 276
    p += 12
    # member data: count + data, a DL=0 record ending each member
    data_at, order, cur, first = {}, [], None, True
    while p + 12 <= len(body):
        cc, hh, rr = int.from_bytes(body[p + 4:p + 6], 'big'), int.from_bytes(body[p + 6:p + 8], 'big'), body[p + 8]
        dl = int.from_bytes(body[p + 10:p + 12], 'big')
        addr = ((cc - CYL0) * TRK_CYL + hh, rr)
        if cur is None: cur = (addr, b''); order.append(cur)
        if dl == 0:
            data_at[cur[0]] = cur[1]; cur = None
        else:
            cur = (cur[0], cur[1] + body[p + 12:p + 12 + dl]); order[-1] = cur
        p += 12 + dl
    mem = {n: [data_at[a][i:i + 80] for i in range(0, len(data_at[a]), 80)] for n, a, c in ents if not c & 0x80}
    by = {a: n for n, a, c in ents if not c & 0x80}
    ali = {n: by[a] for n, a, c in ents if c & 0x80}
    return mem, ali
