#!/usr/bin/env python3
"""mkrtlib.py OUT.obj -- fort370's runtime as object decks, for IEWL on MVS.

A program compiled on the guest (FORT370, then IFOX00) is linked there
by IEWL, which reads object decks -- not the load modules ld370 writes,
which it misreads (bench/ship.py).  So the runtime goes aboard as one
sequential FB/80 data set of object decks, each ending in its END card:
libc370's startup (crt0), fort370's runtime objects (make runtime), and
exactly the libc370 members they call, in the order ld370's autocall
resolves them, every section's storage covered by text (zeros where the
compiler wrote none: IEWL fills uncovered storage from its own buffers).
Its last card is the control statement ENTRY @@CRT0, so a link's SYSLIN
is the program's object with this data set concatenated
(docs/INSTALL-MVS.txt, jcl/F77CLG.jcl).

The member list is ld370's own: a program is linked here once with -v,
and every archive member its autocall pulls in is taken from libc.a by
the offset ld370 reports.  Run from the repository root after
`make runtime`."""
import os, re, subprocess, sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RT = ['f77rt', 'f77dtoa', 'f77main', 'f77math', 'f77rec', 'f77ishim', 'millicode']


def zerofill(deck):
    """The same deck with every byte of every section covered by text:
    zeros where the compiler wrote none (C's static storage, a DS).
    IEWL fills what no TXT card covers from its own buffers, so on MVS
    3.8j a linked module's uninitialized storage is whatever IEWL had in
    hand -- and C assumes zeros (libc370's stdio tables began as garbage,
    S0C4 in @@FPUTC).  The zero cards go right after the ESD cards, so
    every card the compiler wrote still follows and overrides nothing."""
    cards = [deck[i:i + 80] for i in range(0, len(deck), 80)]
    ESD, TXT = 'ESD'.encode('cp037'), 'TXT'.encode('cp037')
    secs = {}
    covered = {}
    last_esd = -1
    for k, c in enumerate(cards):
        if c[1:4] == ESD:
            last_esd = k
            n = int.from_bytes(c[10:12], 'big')
            idx = int.from_bytes(c[14:16], 'big')
            p = 16
            while p < 16 + n:
                e = c[p:p + 16]
                p += 16
                ty = e[8] & 0x0f
                if ty == 1: continue                 # LD: no ESDID of its own
                if ty in (0, 4):                     # SD, PC: a section with a length
                    secs[idx] = (int.from_bytes(e[9:12], 'big'), int.from_bytes(e[13:16], 'big'))
                idx += 1
        elif c[1:4] == TXT:
            sid = int.from_bytes(c[14:16], 'big')
            a = int.from_bytes(c[5:8], 'big')
            n = int.from_bytes(c[10:12], 'big')
            covered.setdefault(sid, set()).update(range(a, a + n))
    fill = []
    for sid, (org, ln) in sorted(secs.items()):
        cov = covered.get(sid, set())
        a = org
        while a < org + ln:
            if a in cov:
                a += 1
                continue
            b = a
            while b < org + ln and b not in cov and b - a < 56: b += 1
            card = bytearray(b'\x40' * 80)
            card[0] = 0x02
            card[1:4] = TXT
            card[5:8] = a.to_bytes(3, 'big')
            card[10:12] = (b - a).to_bytes(2, 'big')
            card[14:16] = sid.to_bytes(2, 'big')
            card[16:16 + (b - a)] = bytes(b - a)
            fill.append(bytes(card))
            a = b
    return b''.join(cards[:last_esd + 1] + fill + cards[last_esd + 1:])


def main():
    if len(sys.argv) != 2: sys.exit(__doc__)
    out = sys.argv[1]
    work = os.path.join(REPO, 'out', 'rtlib')
    os.makedirs(work, exist_ok=True)
    cc = os.path.expanduser('~/.local/cc370')
    lib = os.path.join(cc, 'lib', 'libc.a')
    crt0 = os.path.join(cc, 'lib', 'crt0.o')
    objs = [os.path.join(REPO, 'out', 'crt', n + '.o') for n in RT]
    for o in objs:
        if not os.path.exists(o): sys.exit(f'{o}: make runtime first')
    # a main program to link against: the smallest Fortran there is
    src = os.path.join(work, 'probe.f')
    open(src, 'w').write('      PRINT *, 1\n      END\n')
    subprocess.run([os.path.join(REPO, 'out', 'f77'), src, os.path.join(work, 'probe.asm')], check=True)
    subprocess.run(['as370', '-o', os.path.join(work, 'probe.o'), os.path.join(work, 'probe.asm')],
                   check=True, capture_output=True)
    r = subprocess.run(['cc370', '-o', os.path.join(work, 'PROBE'), os.path.join(work, 'probe.o')] + objs +
                       ['-Wl,-v'], capture_output=True, text=True)
    if r.returncode != 0: sys.exit('link failed:\n' + r.stdout + r.stderr)
    offs = []
    for m in re.finditer(r"autocall: '[^']*' -> archive 0 member @(\d+)", r.stdout + r.stderr):
        o = int(m.group(1))
        if o not in offs: offs.append(o)
    a = open(lib, 'rb').read()
    decks = [open(crt0, 'rb').read()] + [open(o, 'rb').read() for o in objs]
    names = []
    for o in offs:
        hdr = a[o:o + 60]
        names.append(hdr[:16].decode().strip().rstrip('/'))
        size = int(hdr[48:58])
        decks.append(a[o + 60:o + 60 + size])
    for d in decks:
        if len(d) % 80: sys.exit('an object is not card images')
    decks = [zerofill(d) for d in decks]
    # the link's control statement travels with the decks, so SYSLIN is
    # just the program's object and this data set, concatenated (a
    # cataloged procedure cannot carry DD * on MVS 3.8j)
    decks.append(' ENTRY @@CRT0'.ljust(80).encode('cp037'))
    open(out, 'wb').write(b''.join(decks))
    total = sum(len(d) for d in decks)
    print(f'{out}: crt0, {len(objs)} runtime objects, {len(names)} libc370 members, {total // 80} cards')


if __name__ == '__main__':
    main()
