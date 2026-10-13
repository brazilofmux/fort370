#!/usr/bin/env python3
"""fcvs-jcl.py [options] [FMnnn...] -- the NIST FCVS as MVS jobs: one job
per program, everything on the guest.  Each job is jcl/F77CLG.jcl as an
instream procedure -- FORT370 compiles, IFOX00 assembles, IEWL links with
F77RT, the program runs -- with the program's source instream on the
compile step, its FMnnn.DAT (if it has one) instream as FT05F001, and
the scratch data sets the suite opens on the GO step.  No host is needed
to run them, only to write them: the decks are self-contained.

  --fcvs DIR     the FCVS sources (default ~/refs/fcvs/fcvs21, or $FCVS)
  --out DIR      where the decks go (default bench/out/fcvs-jcl)
  --load DSN     FORT370's load library (default HERC01.FORT370.LOAD)
  --rt DSN       the F77RT object deck (default HERC01.FORT370.F77RT)
  --jobcard F    a job card template, {name} for the job name; the
                 default is //{name} JOB (FCVS),'FCVS {name}',CLASS=A,
                 MSGCLASS=A,MSGLEVEL=(1,1)
  --cataloged    EXEC F77CLG from a procedure library instead of
                 carrying it instream

Writes DIR/FMnnn.jcl, one job each, and DIR/FCVS.jcl, all of them in
one stream.  The FCVS programs print their own PASS/FAIL/DELETED counts
on FT06F001; bench/fcvs-expected.txt says which do not end in a clean
pass (FM001's test 2 and FM923's tests 22 and 23 fail by design)."""
import os, sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
JOBCARD = "//{name:<8} JOB (FCVS),'FCVS {name}',CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1)\n"
# the FCVS's OPEN FILE= names (a sequential and a direct-access file), and
# units 1-4 and 7-30, which it writes, rewinds and reads like any other
SCRATCH = ([('CSEQ', 'RECFM=VB,LRECL=260,BLKSIZE=2604'), ('SEQFILE', 'RECFM=VB,LRECL=260,BLKSIZE=2604'),
            ('CDIR', 'RECFM=F,LRECL=132,BLKSIZE=132'), ('DIRFILE', 'RECFM=F,LRECL=132,BLKSIZE=132')] +
           [('FT%02dF001' % u, 'RECFM=VB,LRECL=260,BLKSIZE=2604') for u in list(range(1, 5)) + list(range(7, 31))])


def cards(path):
    """A file as 80-column cards; every line is a card, blank ones too."""
    t = open(path, encoding='latin-1').read()
    if t.endswith('\n'): t = t[:-1]
    out = []
    for l in t.split('\n'):
        l = l.rstrip('\r').expandtabs(8)
        if len(l) > 80: sys.exit('%s: a line is longer than 80 columns' % path)
        if l.startswith('@@'): sys.exit('%s: a line begins with the delimiter @@' % path)
        out.append(l.rstrip())
    return out


def procedure(load, rt):
    p = open(os.path.join(REPO, 'jcl', 'F77CLG.jcl')).read()
    p = p[:p.index('//         PEND')] + '//         PEND\n'
    p = p.replace('HERC01.FORT370.LOAD', load).replace('HERC01.FORT370.F77RT', rt)
    return p


def job(name, src, dat, jobcard, proc):
    j = jobcard.format(name=name)
    if proc: j += proc
    j += "//%-8s EXEC F77CLG\n" % name
    j += "//FORT.SYSIN DD DATA,DLM=@@\n" + ''.join(c + '\n' for c in cards(src)) + "@@\n"
    # an override must come before the step's added DDs: after them it
    # is one more DD of that name, and the procedure's DUMMY wins
    if dat:
        j += "//GO.FT05F001 DD DATA,DLM=@@\n" + ''.join(c + '\n' for c in cards(dat)) + "@@\n"
    for dd, dcb in SCRATCH:
        j += ("//GO.%-8s DD UNIT=SYSDA,SPACE=(TRK,(10,10)),DISP=(NEW,DELETE),\n"
              "//            DCB=(%s)\n" % (dd, dcb))
    j += "//\n"
    return j


def main():
    a = sys.argv[1:]
    fcvs = os.path.expanduser(os.environ.get('FCVS', '~/refs/fcvs/fcvs21'))
    out = os.path.join(REPO, 'bench', 'out', 'fcvs-jcl')
    load, rt, jobcard, cataloged, only = 'HERC01.FORT370.LOAD', 'HERC01.FORT370.F77RT', JOBCARD, False, []
    while a:
        o = a.pop(0)
        if o == '--fcvs': fcvs = a.pop(0)
        elif o == '--out': out = a.pop(0)
        elif o == '--load': load = a.pop(0)
        elif o == '--rt': rt = a.pop(0)
        elif o == '--jobcard': jobcard = open(a.pop(0)).read()
        elif o == '--cataloged': cataloged = True
        elif o.startswith('-'): sys.exit(__doc__)
        else: only.append(o.upper())
    if not jobcard.endswith('\n'): jobcard += '\n'
    progs = sorted(f[:-4] for f in os.listdir(fcvs) if f.startswith('FM') and f.endswith('.FOR'))
    if only: progs = [p for p in progs if p in only]
    if not progs: sys.exit('no FCVS programs in ' + fcvs)
    os.makedirs(out, exist_ok=True)
    proc = None if cataloged else procedure(load, rt)
    allj = ''
    for p in progs:
        dat = os.path.join(fcvs, p + '.DAT')
        j = job(p, os.path.join(fcvs, p + '.FOR'), dat if os.path.exists(dat) else None, jobcard, proc)
        open(os.path.join(out, p + '.jcl'), 'w').write(j)
        allj += j
    open(os.path.join(out, 'FCVS.jcl'), 'w').write(allj)
    print('%d jobs in %s' % (len(progs), out))


if __name__ == '__main__':
    main()
