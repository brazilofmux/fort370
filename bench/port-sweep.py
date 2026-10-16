#!/usr/bin/env python3
"""port-sweep.py [--only NAME...] [--batch N] -- the compiler on MVS 3.8j
emits what the host compiler emits.  Compile every FCVS program (FCVS=,
default ~/refs/fcvs/fcvs21) and every test program (tests/f77, tests/s370,
bench/kernels) ON the guest with the FORT370 load module, and diff its
assembler here, member by member, with the host compiler's.

  1. compile everything on the host (the references, bench/out/sweep/ref)
     with out/f77-guest, the host compiler with the guest's table
     ceilings (F77_ROOM=1): the claim is the same compiler, and out/f77
     has more room, which a unit too big for the guest's tables uses;
  2. pack the sources into a PDS XMIT (xmit370), send it and FORT370.xmit
     aboard as hexadecimal cards through HEXIN (bench/ship.py), RECEIVE
     them into HERC01.FORT370.SRC and HERC01.FORT370.COMP;
  3. one FORT370 step per program, SYSIN a member of the source PDS,
     SYSPUNCH a member of HERC01.FORT370.ASM, REGION=8192K;
  4. IEBPTPCH what each batch wrote to the printer and diff it.

What is normalized before the diff, and why that is honest: IEBPTPCH's
page furniture, and trailing blanks (a card is 80 columns; the host's
lines end where they end).  Bytes the Hercules printer's display table
renders differently from CP037 ([ ] | and the like) would read as '?';
the compiler's output has none of them.

The guest arrangement is bench/ship.py's (RUNNER, HEXIN installed).
Run from the repository root after `make mvs`."""
import glob, os, re, subprocess, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import ship

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
WORK = os.path.join(REPO, 'bench', 'out', 'sweep')
FCVS = os.path.expanduser(os.environ.get('FCVS', '~/refs/fcvs/fcvs21'))
JOBCARD = ("//HERC01S  JOB (TEST),'FORT370 SWEEP',CLASS=A,MSGCLASS=Z,\n"
           "//         USER=HERC01,PASSWORD=@HERC01PW@\n")


def sh(*args):
    r = subprocess.run(args, capture_output=True, text=True)
    if r.returncode != 0:
        sys.exit(f"failed: {' '.join(args)}\n{r.stdout}{r.stderr}")
    return r.stdout


def programs(also=()):
    """(member, source) for every program, member names unique."""
    out = []
    seen = set()
    for f in sorted(glob.glob(os.path.join(FCVS, 'FM*.FOR'))):
        out.append((os.path.basename(f)[:-4].upper(), f))
    for m, f in out: seen.add(m)
    for d, pre in (('tests/f77', 'F'), ('tests/s370', 'S'), ('bench/kernels', 'K')):
        for f in sorted(glob.glob(os.path.join(REPO, d, '*.f'))):
            m = (pre + re.sub(r'[^A-Z0-9]', '', os.path.basename(f)[:-2].upper()))[:8]
            k = 1
            while m in seen:                 # truncation made a twin: number it
                m = m[:7 - len(str(k)) + 1] + str(k) if len(m) >= 8 else m + str(k)
                k = k + 1
            seen.add(m)
            out.append((m, f))
    for f in also:
        m = ('X' + re.sub(r'[^A-Z0-9]', '', os.path.basename(f).split('.')[0].upper()))[:8]
        seen.add(m)
        out.append((m, f))
    return out


def hexin_step(k, xmit, dsn, dirblocks):
    """Delete, rebuild through HEXIN and RECEIVE one XMIT as dsn."""
    return (f"//DEL{k}     EXEC PGM=IEFBR14\n"
            f"//DD1      DD DSN=HERC01.FORT370.SWX{k},DISP=(MOD,DELETE),\n"
            f"//            SPACE=(TRK,(1)),UNIT=SYSDA\n"
            f"//DD2      DD DSN={dsn},DISP=(MOD,DELETE),\n"
            f"//            SPACE=(TRK,(1)),UNIT=SYSDA\n"
            f"//HEX{k}     EXEC PGM=HEXIN,REGION=1024K\n"
            f"//STEPLIB  DD DSN=HERC01.FORT370.UTIL,DISP=SHR\n"
            f"//SYSPRINT DD SYSOUT=Z\n"
            f"//SYSTERM  DD SYSOUT=Z\n"
            f"//SYSUT2   DD DSN=HERC01.FORT370.SWX{k},DISP=(NEW,CATLG),UNIT=SYSDA,\n"
            f"//            SPACE=(CYL,(10,5)),DCB=(RECFM=FB,LRECL=80,BLKSIZE=3120)\n"
            f"//SYSIN    DD *\n"
            + ship.hex_cards(open(xmit, 'rb').read()) +
            f"/*\n"
            f"//RCV{k}     EXEC PGM=IKJEFT01,DYNAMNBR=60,COND=(0,NE)\n"
            f"//SYSTSPRT DD SYSOUT=Z\n"
            f"//SYSPRINT DD SYSOUT=Z\n"
            f"//SYSTSIN  DD *\n"
            f"RECEIVE INDATASET('HERC01.FORT370.SWX{k}') -\n"
            f"  DATASET('{dsn}') DIR({dirblocks}) NOPROMPT\n"
            f"/*\n")


def main():
    args = sys.argv[1:]
    only = []
    batch = 12
    setup = True
    sysut1 = False
    also = []
    region = '8192K'
    while args:
        a = args.pop(0)
        if a == '--only':
            while args and not args[0].startswith('--'): only.append(args.pop(0).upper())
        elif a == '--batch': batch = int(args.pop(0))
        elif a == '--no-setup': setup = False
        elif a == '--sysut1': sysut1 = True       # a work data set: the source spooled, one unit held
        elif a == '--also': also.append(args.pop(0))
        elif a == '--region': region = args.pop(0)      # the compile steps' REGION=
        else: sys.exit(__doc__)
    progs = programs(also)
    if only: progs = [p for p in progs if p[0] in only]
    for d in ('src', 'ref', 'got'):
        os.makedirs(os.path.join(WORK, d), exist_ok=True)
    # the reference is the host compiler with the guest's ceilings
    subprocess.run(['make', '-s', '-C', REPO, 'out/f77-guest'], check=True)
    f77 = os.path.join(REPO, 'out', 'f77-guest')
    comp = os.path.join(REPO, 'out', 'mvs', 'FORT370.xmit')
    if not os.path.exists(comp): sys.exit('make mvs first')
    for m, f in progs:
        # the source as card images: the FCVS files are 80 columns already
        text = open(f, encoding='latin-1').read().expandtabs(8)
        open(os.path.join(WORK, 'src', m), 'w').write(
            '\n'.join(l.rstrip()[:80] for l in text.split('\n')).rstrip('\n') + '\n')
        sh(f77, f, os.path.join(WORK, 'ref', m + '.asm'))
    print(f'{len(progs)} programs staged and compiled on the host')
    if setup:
        for f in glob.glob(os.path.join(WORK, 'src', '*')):
            if os.path.basename(f) not in [p[0] for p in progs]: os.remove(f)
        srcx = os.path.join(WORK, 'SRC.xmit')
        sh('xmit370', 'create', '-o', srcx, '--dsn', 'HERC01.FORT370.SRC',
           '--stats-date', '2026-01-01', os.path.join(WORK, 'src'))
        jcl = JOBCARD + hexin_step(0, srcx, 'HERC01.FORT370.SRC', 80) \
            + hexin_step(1, comp, 'HERC01.FORT370.COMP', 5) + \
            "//DELA     EXEC PGM=IEFBR14\n" \
            "//DD1      DD DSN=HERC01.FORT370.ASM,DISP=(MOD,DELETE),\n" \
            "//            SPACE=(TRK,(1)),UNIT=SYSDA\n" \
            "//ALLOC    EXEC PGM=IEFBR14\n" \
            "//DD1      DD DSN=HERC01.FORT370.ASM,DISP=(NEW,CATLG),UNIT=SYSDA,\n" \
            "//            SPACE=(CYL,(60,20,80)),\n" \
            "//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=3120)\n"
        deck = os.path.join(WORK, 'setup.jcl')
        open(deck, 'w').write(jcl)
        out = os.path.join(WORK, 'setup.out')
        ship.run_deck(deck, out)
        t = open(out, 'rb').read().decode('latin-1')
        n_ok = len(re.findall(r'RCV[01]\s.*?RC= 0000|IKJEFT01\s+RC= 0000', t))
        print('setup: sources and compiler aboard' if 'RC= 0000' in t else 'setup FAILED, see ' + out)
    same = 0
    bad = []
    for j in range(0, len(progs), batch):
        chunk = progs[j:j + batch]
        jcl = JOBCARD
        for k, (m, f) in enumerate(chunk):
            jcl += (f"//C{k:02d}      EXEC PGM=FORT370,REGION={region},COND=EVEN,TIME=(3,0)\n"
                    f"//STEPLIB  DD DSN=HERC01.FORT370.COMP,DISP=SHR\n"
                    f"//SYSPRINT DD SYSOUT=Z\n"
                    f"//SYSTERM  DD SYSOUT=Z\n"
                    f"//SYSUDUMP DD DUMMY\n"
                    f"//SYSIN    DD DSN=HERC01.FORT370.SRC({m}),DISP=SHR\n"
                    f"//SYSPUNCH DD DSN=HERC01.FORT370.ASM({m}),DISP=SHR\n"
                    + ("//SYSUT1   DD UNIT=SYSDA,SPACE=(CYL,(5,5))\n" if sysut1 else ""))
        jcl += ("//PRT      EXEC PGM=IEBPTPCH,REGION=2048K,COND=EVEN\n"
                "//SYSUT1   DD DSN=HERC01.FORT370.ASM,DISP=SHR\n"
                "//SYSUT2   DD SYSOUT=Z\n"
                "//SYSPRINT DD SYSOUT=Z\n"
                "//SYSIN    DD *\n"
                f" PRINT TYPORG=PO,MAXFLDS={len(chunk)},MAXNAME={len(chunk)}\n")
        for m, f in chunk:
            jcl += f" MEMBER NAME={m}\n RECORD FIELD=(80)\n"
        jcl += "/*\n"
        deck = os.path.join(WORK, f'sweep{j // batch}.jcl')
        out = os.path.join(WORK, f'sweep{j // batch}.out')
        open(deck, 'w').write(jcl)
        ship.run_deck(deck, out)
        raw = open(out, 'rb').read().decode('latin-1')
        got = {}
        cur = None
        for l in raw.split('\n'):
            l = l.split('\x0c')[0].rstrip('\r')      # a page ends in a form feed
            l = re.sub(r'\s+PAGE\s+\d+\s*$', '', l)
            mm = re.match(r'^\s*MEMBER NAME\s+(\S+)', l)
            if mm:
                cur = mm.group(1)                   # repeated at the top of every page
                got.setdefault(cur, [])
                continue
            if cur is None or l.startswith('****') or 'HASP' in l[:24] or 'IEB' in l[:8]:
                continue
            # the Hercules printer's display table renders three CP037
            # characters differently on the way out of the machine:
            # | [ ] read back as 0xD7, 0xAA, 0xB3 (the data set is right)
            l = l.replace('\xd7', '|').replace('\xaa', '[').replace('\xb3', ']')
            got[cur].append(l.rstrip())
        for m, f in chunk:
            ref = [l.rstrip() for l in open(os.path.join(WORK, 'ref', m + '.asm'), encoding='latin-1').read().split('\n')]
            g = got.get(m, [])
            for i, l in enumerate(g):
                if re.match(r'^ +END(\s|$)', l):     # END, or END F77@GO for a main program
                    g = g[:i + 1]
                    break
            while ref and not ref[-1]: ref.pop()
            while g and not g[-1]: g.pop()
            open(os.path.join(WORK, 'got', m + '.asm'), 'w', encoding='latin-1').write('\n'.join(g) + '\n')
            cc = re.search(rf'HERC01S\s+C{chunk.index((m, f)):02d}\s+-\s+(?:ABEND (\S+)|STEP WAS EXECUTED - COND CODE (\d+))', raw)
            if ref == g:
                same += 1
            else:
                why = ('ABEND ' + cc.group(1)) if cc and cc.group(1) else ('cond ' + cc.group(2)) if cc else 'no step report'
                bad.append((m, why, len(g)))
        print(f'batch {j // batch}: {same} identical, {len(bad)} differ so far')
    print(f'identical={same} differ={len(bad)}')
    for m, why, n in bad:
        print(f'  DIFFERS: {m} ({why}, {n} lines back)')
    sys.exit(0 if not bad else 1)


if __name__ == '__main__':
    main()
