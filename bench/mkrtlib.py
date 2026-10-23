#!/usr/bin/env python3
"""mkrtlib.py OUT.upd -- fort370's runtime as a library, F77RT, for MVS.

A program compiled on the guest (FORT370, then IFOX00) is linked there
by IEWL or the loader, which read object decks -- not the load modules
ld370 writes, which IEWL misreads (bench/ship.py).  So the runtime is a
PDS of object decks, F77RT, the link's SYSLIB: automatic library call
takes from it only what the program calls (fort370 issue 1), and the
program's own object names the startup and its entry point (F77@GO,
backend/hir_codegen_s370.h), so a link needs nothing else
(docs/INSTALL-MVS.txt, jcl/F77CLG.jcl).

The library goes aboard as IEBUPDTE input, FB/80, which makes the PDS:
fort370's runtime objects (make runtime) and the libc370 members they
call, each a member named for its first entry point with an alias for
every other (only the front doors of f77rt.o, which has more names
than a member can carry), every section's storage covered by text
(zeros where the compiler wrote none: IEWL fills uncovered storage
from its own buffers).

The member list is ld370's own: a program is linked here once with -v,
with every runtime object, and every archive member its autocall pulls
in is taken from the archive by the offset ld370 reports.  Then every
committed test program is linked from the library the way automatic
call does it, and a name left unresolved fails the build.  Run from the
repository root after `make runtime`."""
import glob, os, re, shutil, subprocess, sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RT = ['f77rt', 'f77misc'] + open(os.path.join(REPO, 'runtime/s370/f77int.lst')).read().split() + ['f77dtoa', 'f77main', 'f77err', 'f77math', 'f77mchk', 'f77mlr', 'f77mld', 'f77rec', 'f77ishim', 'f77xsum', 'f77spie', 'millicode']


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


# A deck may define more names than a member can carry, one name and
# IEBUPDTE's 16 aliases: f77rt.o, formatted I/O, defines 44.  Automatic
# call needs only the names a program can reach it by first -- the
# statements' own entry points; each statement's items (F77WRI after
# F77WRBEG) come after one of them, and a member, once in, defines all
# its names.  check() below proves it over the test programs.
DOORS = ['F77WRBEG', 'F77WRBI', 'F77RDBEG', 'F77RDBI', 'F77WUB@R', 'F77RUB@R', 'F77SRC@R',
         'F77OPEN', 'F77CLOSE', 'F77INQR', 'F77INQ', 'F77REWND', 'F77BKSP', 'F77ENDF', 'F77PAUSE',
         'F77NMLBG']


def esd(deck):
    """(defined names, strong external references) of an object deck."""
    names, refs = [], []
    for i in range(0, len(deck), 80):
        c = deck[i:i + 80]
        if c[1:4] != 'ESD'.encode('cp037'): continue
        n = int.from_bytes(c[10:12], 'big')
        for p in range(16, 16 + n, 16):
            e = c[p:p + 16]
            nm = e[:8].decode('cp037').strip()
            if not nm: continue
            if e[8] in (0x00, 0x01) and nm not in names: names.append(nm)
            if e[8] == 0x02 and nm not in refs: refs.append(nm)
    return names, refs


def keep_names():
    """The external names compiled code calls the runtime by
    (backend/s370_rtnames.h): F77..., and libm's and EXIT, which are
    FORTLIB's names for them too."""
    tab = open(os.path.join(REPO, 'backend', 's370_rtnames.h')).read()
    m = re.search(r'static char \*s370_rt_map\[\] = \{(.*?)\n    0 \};', tab, re.S)
    return set(re.findall(r'"[^"]+",\s*"([^"]+)"', m.group(1)))


def private(decks):
    """The decks with libc370's names out of the program's way.  A name
    the library defines that a Fortran program could also give one of
    its own subprograms -- FOPEN, FREE, MAIN, STRLEN -- is the program's
    at link time, and the library's own calls go to it: MINOS has a
    SUBROUTINE FOPEN, and libc370 opening SYSPRINT called it (Rene
    Ferland, 2026-10-19).  So such a name, unless compiled code calls it
    (keep_names()), becomes #NAME, or for eight letters # and seven of
    them; no Fortran name has a #.  FORTLIB keeps its own the same way, under
    IHC."""
    keep = keep_names()
    defined = set(n for d in decks for n in esd(d)[0])
    ren, taken = {}, set(defined)
    for n in sorted(defined, key=lambda n: (len(n), n)):
        if n in keep or n.startswith('F77') or not re.fullmatch(r'[A-Z][A-Z0-9]{0,7}', n): continue
        for c in ('#' + n, '#' + n[:7], '#' + n[1:], '#' + n[:6] + n[7:]):
            if len(c) <= 8 and c not in taken: break
        else:
            sys.exit('mkrtlib: no private name for ' + n)
        ren[n] = c; taken.add(c)
    out = []
    for d in decks:
        cards = []
        for i in range(0, len(d), 80):
            c = bytearray(d[i:i + 80])
            if c[1:4] == 'ESD'.encode('cp037'):
                n = int.from_bytes(c[10:12], 'big')
                for p in range(16, 16 + n, 16):
                    nm = c[p:p + 8].decode('cp037').strip()
                    if nm in ren: c[p:p + 8] = ren[nm].ljust(8).encode('cp037')
            cards.append(bytes(c))
        out.append(b''.join(cards))
    return out, ren


def members(decks):
    """[(member, aliases, deck)] as the library holds them."""
    out = []
    seen = set()
    for d in decks:
        names = [n for n in esd(d)[0] if n not in seen]
        if not names: continue
        seen.update(names)
        if len(names) > 17:
            names = [n for n in DOORS if n in names]
            if len(names) > 17: sys.exit('mkrtlib: too many doors')
        out.append((names[0], names[1:], d))
    return out


def check(mems, progs):
    """Link each program as the linkage editor's automatic call would
    from this library: every name still unresolved is looked up in the
    directory, its member included, until nothing changes.  A name left
    over would be an unresolved external on MVS."""
    where = {}
    for k, (m, al, d) in enumerate(mems):
        for n in [m] + al: where[n] = k
    defs = [esd(d) for (m, al, d) in mems]
    everything = set(n for dn, dr in defs for n in dn)
    bad = 0
    for name, obj in progs:
        defined, refs = esd(obj)
        defined, refs = set(defined), set(refs)
        took = set()
        while True:
            want = {where[n] for n in refs - defined if n in where} - took
            if not want: break
            for k in want:
                took.add(k); defined |= set(defs[k][0]); refs |= set(defs[k][1])
        left = (refs - defined) & everything      # names of other programs' are not the library's
        if left: print(f'mkrtlib: {name}: unresolved {sorted(left)}'); bad += 1
    return bad


def updte(decks):
    """The library as IEBUPDTE input: each deck a member named for the
    first name it defines, with an alias for every other, so that the
    linkage editor's and the loader's automatic library call find each
    external name (docs/INSTALL-MVS.txt).  Object cards begin X'02', so
    none is taken for a ./ control statement."""
    card = lambda t: t.ljust(80).encode('cp037')
    out = []
    for m, al, d in members(decks):
        out.append(card('./ ADD NAME=' + m))
        out.append(d)
        for n in al: out.append(card('./ ALIAS NAME=' + n))
    out.append(card('./ ENDUP'))
    return b''.join(out)


def main():
    if len(sys.argv) != 2: sys.exit(__doc__)
    out = sys.argv[1]
    work = os.path.join(REPO, 'out', 'rtlib')
    os.makedirs(work, exist_ok=True)
    # the sysroot of the cc370 on PATH: <prefix>/bin/cc370, <prefix>/cc370/lib
    cc = os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(shutil.which('cc370')))), 'cc370')
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
    log = r.stdout + r.stderr
    # ld370 numbers the archives it searches in the order it lists them
    # (cc370 1.6: libcc370rt.a, libc.a, libcc370rt.a again)
    archives = re.findall(r'^\[ld370\] - archive (.*?): \d+ exported', log, re.M)
    picks = []
    for m in re.finditer(r"autocall: '[^']*' -> archive (\d+) member @(\d+)", log):
        k = (archives[int(m.group(1))], int(m.group(2)))
        if k not in picks: picks.append(k)
    data = {}
    decks = [open(o, 'rb').read() for o in objs]   # @@CRT0 is a member of libc.a
    names = []
    for path, o in picks:
        if path not in data: data[path] = open(path, 'rb').read()
        a = data[path]
        hdr = a[o:o + 60]
        names.append(hdr[:16].decode().strip().rstrip('/'))
        size = int(hdr[48:58])
        decks.append(a[o + 60:o + 60 + size])
    for d in decks:
        if len(d) % 80: sys.exit('an object is not card images')
    decks, ren = private([zerofill(d) for d in decks])
    lib = updte(decks)
    # the proof: every committed test program links from the library
    progs = []
    for a in sorted(glob.glob(os.path.join(REPO, 'tests', '*', '*.asm')) + glob.glob(os.path.join(REPO, 'bench', 'kernels', '*.asm'))):
        o = os.path.join(work, 'chk.o')
        if subprocess.run(['as370', '-o', o, a], capture_output=True).returncode != 0: continue
        obj = open(o, 'rb').read()
        if 'F77MAIN' in esd(obj)[0]: progs.append((os.path.relpath(a, REPO), obj))
    if check(members(decks), progs): sys.exit('mkrtlib: the library does not link every test program')
    open(out, 'wb').write(lib)
    mems = members(decks)
    # the same library as a TSO TRANSMIT file, RECEIVEd as FORT370.xmit is
    # (fort370 issue 22), its time the build's pinned clock (LDDATE yyddd,
    # LDTIME hhmmss, as ld370 stamps FORT370.xmit)
    import datetime, xmitpds
    ld, lt = os.environ.get('LDDATE'), os.environ.get('LDTIME')
    ftime = None
    if ld and lt:
        day = datetime.date(2000 + int(ld[:2]), 1, 1) + datetime.timedelta(days=int(ld[2:]) - 1)
        ftime = day.strftime('%Y%m%d') + lt
    xm = xmitpds.xmit('IBMUSER.FORT370.F77RT',
                      [(m, [d[i:i + 80] for i in range(0, len(d), 80)]) for m, al, d in mems],
                      {a: m for m, al, d in mems for a in al},
                      ftime=ftime, user='IBMUSER', touser='DUMMY')
    back = xmitpds.read(xm)
    if back != ({m: [d[i:i + 80] for i in range(0, len(d), 80)] for m, al, d in mems},
                {a: m for m, al, d in mems for a in al}):
        sys.exit('mkrtlib: F77RT.xmit does not read back as the library')
    open(os.path.splitext(out)[0] + '.xmit', 'wb').write(xm)
    print(f'{out}: {len(objs)} runtime objects and {len(names)} libc370 members, '
          f'{len(mems)} members and {sum(len(a) for m, a, d in mems)} aliases, {len(lib) // 80} cards, {len(ren)} names made private; '
          f'all {len(progs)} test programs link from it')

if __name__ == '__main__':
    main()
