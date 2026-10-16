#!/usr/bin/env python3
"""clg-test.py PROG.f... -- the MVS package used the way docs/INSTALL-MVS.txt
says: FORT370 compiles on the guest, IFOX00 assembles, IEWL links with
F77RT, the program runs; no host in the loop but to submit the job.

  1. install: FORT370.xmit RECEIVEd into HERC01.FORT370.LOAD, F77RT.upd
     (both through HEXIN) made the library HERC01.FORT370.F77RT by
     IEBUPDTE;
  2. one job: jcl/F77CLG.jcl as an instream procedure, one invocation
     per program, its source DD * on the compile step, scratch DDs
     FT01F001-FT04F001 and FT07F001-FT30F001 on the GO step;
  3. print each program's lines that begin with ">" (the convention of
     tests/s370) and its steps' return codes.

Run from the repository root after `make mvs`; the guest arrangement is
bench/ship.py's.  --no-install skips step 1."""
import os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import ship

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
WORK = os.path.join(REPO, 'bench', 'out', 'clg')
JOBCARD = ("//HERC01S  JOB (TEST),'FORT370 CLG',CLASS=A,MSGCLASS=Z,\n"
           "//         USER=HERC01,PASSWORD=@HERC01PW@\n")


def install():
    comp = os.path.join(REPO, 'out', 'mvs', 'FORT370.xmit')
    rt = os.path.join(REPO, 'out', 'mvs', 'F77RT.upd')
    jcl = JOBCARD
    jcl += ("//DEL      EXEC PGM=IEFBR14\n"
            "//DD1      DD DSN=HERC01.FORT370.CLGX,DISP=(MOD,DELETE),\n"
            "//            SPACE=(TRK,(1)),UNIT=SYSDA\n"
            "//DD2      DD DSN=HERC01.FORT370.LOAD,DISP=(MOD,DELETE),\n"
            "//            SPACE=(TRK,(1)),UNIT=SYSDA\n"
            "//DD3      DD DSN=HERC01.FORT370.F77RT,DISP=(MOD,DELETE),\n"
            "//            SPACE=(TRK,(1)),UNIT=SYSDA\n"
            "//DD4      DD DSN=HERC01.FORT370.F77UPD,DISP=(MOD,DELETE),\n"
            "//            SPACE=(TRK,(1)),UNIT=SYSDA\n")
    for dsn, f in (('HERC01.FORT370.CLGX', comp), ('HERC01.FORT370.F77UPD', rt)):
        jcl += ("//HEX      EXEC PGM=HEXIN,REGION=1024K\n"
                "//STEPLIB  DD DSN=HERC01.FORT370.UTIL,DISP=SHR\n"
                "//SYSPRINT DD SYSOUT=Z\n"
                "//SYSTERM  DD SYSOUT=Z\n"
                f"//SYSUT2   DD DSN={dsn},DISP=(NEW,CATLG),UNIT=SYSDA,\n"
                "//            SPACE=(CYL,(5,5)),DCB=(RECFM=FB,LRECL=80,BLKSIZE=3120)\n"
                "//SYSIN    DD *\n" + ship.hex_cards(open(f, 'rb').read()) + "/*\n")
    jcl += ("//RCV      EXEC PGM=IKJEFT01,DYNAMNBR=60,COND=(0,NE)\n"
            "//SYSTSPRT DD SYSOUT=Z\n"
            "//SYSPRINT DD SYSOUT=Z\n"
            "//SYSTSIN  DD *\n"
            "RECEIVE INDATASET('HERC01.FORT370.CLGX') -\n"
            "  DATASET('HERC01.FORT370.LOAD') DIR(5) NOPROMPT\n"
            "/*\n"
            "//LIB      EXEC PGM=IEBUPDTE,PARM=NEW\n"
            "//SYSPRINT DD SYSOUT=Z\n"
            "//SYSUT2   DD DSN=HERC01.FORT370.F77RT,DISP=(NEW,CATLG),UNIT=SYSDA,\n"
            "//            SPACE=(CYL,(2,1,40)),DCB=(RECFM=FB,LRECL=80,BLKSIZE=3120)\n"
            "//SYSIN    DD DSN=HERC01.FORT370.F77UPD,DISP=SHR\n")
    deck = os.path.join(WORK, 'install.jcl')
    open(deck, 'w').write(jcl)
    out = os.path.join(WORK, 'install.out')
    ship.run_deck(deck, out)
    t = open(out, 'rb').read().decode('latin-1')
    print('installed' if re.search(r'RCV\s+IKJEFT01\s+RC= 0000', t) and re.search(r'LIB\s+IEBUPDTE\s+RC= 0000', t) else 'install FAILED, see ' + out)


def main():
    args = sys.argv[1:]
    inst = True
    if args and args[0] == '--no-install':
        inst = False
        args = args[1:]
    if not args: sys.exit(__doc__)
    os.makedirs(WORK, exist_ok=True)
    if inst: install()
    proc = open(os.path.join(REPO, 'jcl', 'F77CLG.jcl')).read()
    proc = proc[:proc.index('//         PEND')] + '//         PEND\n'
    jcl = JOBCARD + proc
    names = []
    for k, f in enumerate(args):
        step = f'P{k}'
        names.append((step, f))
        jcl += f"//{step:<8} EXEC F77CLG\n//FORT.SYSIN DD *\n"
        for l in open(f).read().expandtabs(8).split('\n'):
            if l.strip(): jcl += l.rstrip()[:80] + '\n'
        jcl += "/*\n"
        for u in list(range(1, 5)) + list(range(7, 31)):
            jcl += (f"//GO.FT{u:02d}F001 DD UNIT=SYSDA,SPACE=(TRK,(10,10)),DISP=(NEW,DELETE),\n"
                    f"//            DCB=(RECFM=VB,LRECL=260,BLKSIZE=2604)\n")
    deck = os.path.join(WORK, 'clg.jcl')
    open(deck, 'w').write(jcl)
    out = os.path.join(WORK, 'clg.out')
    ship.run_deck(deck, out)
    t = open(out, 'rb').read().decode('latin-1')
    for step, f in names:
        rcs = re.findall(rf'HERC01S\s+{step}\s+(\S+)\s+\S+\s+RC= (\d+)|HERC01S\s+{step}\s+(\S+)\s+\S+\s+(ABEND \S+)', t)
        print(f'{os.path.basename(f)}: ' + ' '.join(f'{a or c}={b or d}' for a, b, c, d in rcs))
    lines = [l.split('\x0c')[0].rstrip('\r ') for l in t.split('\n') if l.lstrip().startswith('>')]
    for l in lines: print('   ', l)


if __name__ == '__main__':
    main()
