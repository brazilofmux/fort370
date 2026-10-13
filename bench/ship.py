#!/usr/bin/env python3
"""ship.py -- put host-linked load modules on the MVS guest and run them.

    bench/ship.py [--sysin FILE] [--out FILE] [--dump] MODULE.xmit ...
    bench/ship.py --install HEXIN.xmit

--dump keeps SYSUDUMP (a dump is long, and the printed output of the
steps after it may not be captured before the runner stops waiting);
without it an abend reports its code and PSW in the job log only.

Each MODULE.xmit is what cc370 -flinker-output=xmit writes beside a
linked program: a TSO TRANSMIT image of a PDS holding one member, named
as the output file was (upper case).  One job carries them all, each
as hexadecimal text on a SYSIN of its own: the HEXIN step (runtime/s370/
hexin.c, a cc370 program installed once in HERC01.FORT370.UTIL) writes
the image back as the FB/80 data set it was, RECEIVE makes it a load
library of its own, HERC01.FORT370.Lk, and the GO step runs the member
from there with FT05F001 from --sysin (or DUMMY) and FT06F001 to the
printer.  The job's printed output lands in --out (default
bench/out/ship.out) and the step results are summarized.

--install puts HEXIN itself aboard, the only time a tape is needed: the
XMIT goes to an AWS tape mounted on 0480 through the Hercules console,
IEBGENER brings it in and RECEIVE installs it.  MVS asks for the mount
again once the job starts (IEF233A); the drive is re-inited when the
request appears in the Hercules log.

The guest arrangement is the one the rest of bench/ assumes: tk5-run on
PATH (or RUNNER) to submit a deck and capture its MSGCLASS=Z output, a
tape at 0480, the Hercules HTTP console (HERC_CONSOLE, default
http://localhost:8038/cgi-bin/tasks/syslog) and its log (HERC_LOG,
default ~/tk5/log/3033.log).  Linking on the guest instead was tried:
IEWL misreads what ld370 writes (2026-10-12), so a module is linked
here whole and only run there.
"""
import os, re, struct, subprocess, sys, threading, time
from urllib.request import urlopen
from urllib.parse import quote_plus

CONSOLE = os.environ.get('HERC_CONSOLE', 'http://localhost:8038/cgi-bin/tasks/syslog')
HLOG = os.path.expanduser(os.environ.get('HERC_LOG', '~/tk5/log/3033.log'))
RUNNER = os.environ.get('RUNNER', 'tk5-run')
JOBCARD = ("//HERC01S  JOB (TEST),'FORT370',CLASS=A,MSGCLASS=Z,REGION=4096K,\n"
           "//         USER=HERC01,PASSWORD=@HERC01PW@\n")

def console(cmd):
    urlopen(f"{CONSOLE}?command={quote_plus(cmd)}", timeout=10).read()

def member_of(xmit):
    """The one member's name, from the IEBCOPY directory in the XMIT."""
    r = subprocess.run(['xmit370', 'list', '-v', xmit], capture_output=True, text=True)
    m = re.search(r'^\s+([A-Z0-9@#$]{1,8})\s+TTR=', r.stdout, re.M)
    if not m: sys.exit(f'{xmit}: no member found')
    return m.group(1)

PRT = os.path.expanduser(os.environ.get('TK5_PRT', '~/tk5/prt/prt00f.txt'))

def run_deck(deck, out):
    """Submit through the runner, then wait for the printer: the runner
    slices the printer file when the job ends, and JES2 is still
    printing the steps' SYSOUT then (a 900-line report took a few
    seconds once the midnight SMF job was running beside it), so the
    slice is re-taken once the job's END trailer has been printed."""
    r = subprocess.run([RUNNER, deck, out], capture_output=True, text=True)
    if r.returncode != 0:
        sys.exit(f'{RUNNER} failed: {r.stderr[-400:]}')
    text = open(out, 'rb').read()
    m = re.search(rb'JOB (\d+)', text)
    if not m or not os.path.exists(PRT): return
    job = m.group(1)
    head = text[:200].split(b'\n')[0]
    trailer = re.compile(rb'\*\*\*\*Z\s+END\s+JOB\s+' + job + rb'\s')
    # JES2 prints a job's output in groups, each with its own trailer,
    # and the step reports can follow the job log's group by seconds:
    # wait until the printer file has been still for a while, then take
    # everything from the job's first line through its last trailer
    deadline = time.time() + 300
    last = -1
    still = 0
    while time.time() < deadline:
        size = os.path.getsize(PRT)
        if size == last: still += 1
        else: still = 0; last = size
        if still >= 3:
            prt = open(PRT, 'rb').read()
            start = prt.rfind(head)
            if start >= 0:
                tail = prt[start:]
                ends = [mm.end() for mm in trailer.finditer(tail)]
                if ends:
                    e = ends[-1]
                    nl = tail.find(b'\n', e)
                    open(out, 'wb').write(tail[:nl + 1 if nl >= 0 else len(tail)])
            return
        time.sleep(2)

def mount_watcher(aws, stop):
    """Re-init the tape whenever MVS asks for the volume again: only
    requests logged after the watcher started count (an earlier job's
    request for the same step name must not satisfy this one)."""
    seen = set()
    pos = os.path.getsize(HLOG)
    while not stop.is_set():
        with open(HLOG, 'rb') as f:
            f.seek(pos)
            data = f.read().decode('latin-1')
        for m in re.finditer(r'JOB (\d+) \*IEF233A M 480,FORT01,,HERC01S,(\w+)', data):
            if m.group(0) not in seen:
                seen.add(m.group(0))
                console(f'devinit 0480 {aws}')
        time.sleep(2)

def install(xmit, work):
    data = open(xmit, 'rb').read()
    assert len(data) % 80 == 0
    tape = bytearray(); prev = 0
    for i in range(0, len(data), 3120):
        b = data[i:i+3120]
        tape += struct.pack('<HHBB', len(b), prev, 0xA0, 0) + b
        prev = len(b)
    tape += struct.pack('<HHBB', 0, prev, 0x40, 0) + struct.pack('<HHBB', 0, 0, 0x40, 0)
    aws = os.path.join(work, 'install.aws')
    open(aws, 'wb').write(tape)
    console(f'devinit 0480 {aws}')
    jcl = JOBCARD + """\
//DEL      EXEC PGM=IEFBR14
//DD1      DD DSN=HERC01.FORT370.UTIL.XMIT,DISP=(MOD,DELETE),
//            SPACE=(TRK,(1)),UNIT=SYSDA
//DD2      DD DSN=HERC01.FORT370.UTIL,DISP=(MOD,DELETE),
//            SPACE=(TRK,(1)),UNIT=SYSDA
//GEN      EXEC PGM=IEBGENER
//SYSUT1   DD UNIT=480,VOL=SER=FORT01,LABEL=(1,NL),DISP=(OLD,KEEP),
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=3120)
//SYSUT2   DD DSN=HERC01.FORT370.UTIL.XMIT,DISP=(NEW,CATLG),UNIT=SYSDA,
//            SPACE=(CYL,(2,1)),DCB=(RECFM=FB,LRECL=80,BLKSIZE=3120)
//SYSPRINT DD SYSOUT=Z
//SYSIN    DD DUMMY
//RECV     EXEC PGM=IKJEFT01,DYNAMNBR=60,COND=(0,NE)
//SYSTSPRT DD SYSOUT=Z
//SYSPRINT DD SYSOUT=Z
//SYSTSIN  DD *
RECEIVE INDATASET('HERC01.FORT370.UTIL.XMIT') -
  DATASET('HERC01.FORT370.UTIL') DIR(5) NOPROMPT
/*
"""
    deck = os.path.join(work, 'install.jcl')
    open(deck, 'w').write(jcl)
    stop = threading.Event()
    t = threading.Thread(target=mount_watcher, args=(aws, stop), daemon=True)
    t.start()
    out = os.path.join(work, 'install.out')
    run_deck(deck, out)
    stop.set()
    text = open(out, 'rb').read().decode('latin-1')
    print('installed' if 'successful' in text else 'install FAILED, see ' + out)

def hex_cards(data):
    """64 hexadecimal digits a card: the deck for one XMIT."""
    h = data.hex().upper()
    return '\n'.join(h[i:i+64] for i in range(0, len(h), 64)) + '\n'

def main():
    args = sys.argv[1:]
    sysin = None
    out = 'bench/out/ship.out'
    mods = []
    inst = None
    dump = False
    while args:
        a = args.pop(0)
        if a == '--dump': dump = True
        elif a == '--sysin': sysin = args.pop(0)
        elif a == '--out': out = args.pop(0)
        elif a == '--install': inst = args.pop(0)
        else: mods.append(a)
    work = os.path.dirname(os.path.abspath(out)) or '.'
    os.makedirs(work, exist_ok=True)
    if inst:
        install(inst, work)
        return
    if not mods: sys.exit(__doc__)
    names = [member_of(m) for m in mods]
    jcl = JOBCARD
    for k, (m, name) in enumerate(zip(mods, names)):
        jcl += (f"//DEL{k}     EXEC PGM=IEFBR14\n"
                f"//DD1      DD DSN=HERC01.FORT370.X{k},DISP=(MOD,DELETE),\n"
                f"//            SPACE=(TRK,(1)),UNIT=SYSDA\n"
                f"//DD2      DD DSN=HERC01.FORT370.L{k},DISP=(MOD,DELETE),\n"
                f"//            SPACE=(TRK,(1)),UNIT=SYSDA\n"
                f"//HEX{k}     EXEC PGM=HEXIN,REGION=1024K\n"
                f"//STEPLIB  DD DSN=HERC01.FORT370.UTIL,DISP=SHR\n"
                f"//SYSPRINT DD SYSOUT=Z\n"
                f"//SYSTERM  DD SYSOUT=Z\n"
                f"//SYSUT2   DD DSN=HERC01.FORT370.X{k},DISP=(NEW,CATLG),UNIT=SYSDA,\n"
                f"//            SPACE=(CYL,(5,5)),DCB=(RECFM=FB,LRECL=80,BLKSIZE=3120)\n"
                f"//SYSIN    DD *\n")
        jcl += hex_cards(open(m, 'rb').read())
        jcl += (f"/*\n"
                f"//RCV{k}     EXEC PGM=IKJEFT01,DYNAMNBR=60,COND=(0,NE)\n"
                f"//SYSTSPRT DD SYSOUT=Z\n"
                f"//SYSPRINT DD SYSOUT=Z\n"
                f"//SYSTSIN  DD *\n"
                f"RECEIVE INDATASET('HERC01.FORT370.X{k}') -\n"
                f"  DATASET('HERC01.FORT370.L{k}') DIR(5) NOPROMPT\n"
                f"/*\n")
    for k, name in enumerate(names):
        jcl += (f"//GO{k}      EXEC PGM={name},REGION=4096K,COND=EVEN,TIME=(0,30)\n"
                f"//STEPLIB  DD DSN=HERC01.FORT370.L{k},DISP=SHR\n"
                f"//SYSPRINT DD SYSOUT=Z\n"
                f"//SYSTERM  DD SYSOUT=Z\n"
                f"//SYSOUT   DD SYSOUT=Z\n"
                f"//SYSUDUMP DD {'SYSOUT=Z' if dump else 'DUMMY'}\n"
                f"//FT06F001 DD SYSOUT=Z,DCB=(RECFM=FBA,LRECL=133,BLKSIZE=133)\n"
                )
        # the FCVS's OPEN FILE= names: a sequential and a direct-access file
        for nm, dcb in (('CSEQ', 'RECFM=VB,LRECL=260,BLKSIZE=2604'), ('SEQFILE', 'RECFM=VB,LRECL=260,BLKSIZE=2604'),
                        ('CDIR', 'RECFM=F,LRECL=132,BLKSIZE=132'), ('DIRFILE', 'RECFM=F,LRECL=132,BLKSIZE=132')):
            jcl += (f"//{nm:<8} DD UNIT=SYSDA,SPACE=(TRK,(10,10)),DISP=(NEW,DELETE),\n"
                    f"//            DCB=({dcb})\n")
        # the FCVS writes, rewinds and reads unit 7 like any other scratch unit
        for u in list(range(1, 5)) + list(range(7, 31)):
            jcl += (f"//FT{u:02d}F001 DD UNIT=SYSDA,SPACE=(TRK,(10,10)),DISP=(NEW,DELETE),\n"
                    f"//            DCB=(RECFM=VB,LRECL=260,BLKSIZE=2604)\n")
        if sysin:
            jcl += "//FT05F001 DD *\n"
            for line in open(sysin).read().split('\n'):
                if line: jcl += line[:80] + '\n'
            jcl += "/*\n"
        else:
            jcl += "//FT05F001 DD DUMMY\n"
    deck = os.path.join(work, 'ship.jcl')
    open(deck, 'w').write(jcl)
    run_deck(deck, out)
    text = open(out, 'rb').read().decode('latin-1')
    for k, name in enumerate(names):
        m = re.search(rf'IEF142I HERC01S\s+GO{k}\s+-\s+STEP WAS EXECUTED - COND CODE (\d+)', text)
        ab = re.search(rf'HERC01S\s+GO{k}\s+-\s+ABEND (\S+)', text)
        cpu = re.search(rf'IEF374I STEP /GO{k}\s+/ STOP\s+\S+ CPU\s+(\d+)MIN (\d+\.\d+)SEC', text)
        c = (int(cpu.group(1)) * 60 + float(cpu.group(2))) if cpu else None
        sk = re.search(rf'IEF272I HERC01S\s+GO{k}\s+-\s+STEP WAS NOT EXECUTED', text)
        print(name, 'cond', m.group(1) if m else ('ABEND ' + ab.group(1) if ab else ('skipped' if sk else '?')), 'cpu', c)

if __name__ == '__main__':
    main()
