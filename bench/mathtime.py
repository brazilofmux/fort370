#!/usr/bin/env python3
"""mathtime.py [--no-h] [NAME...] -- the DOUBLE PRECISION functions'
speed on the guest, fort370's against FORTRAN H's FORTLIB (issue #3).

Each function is called 200,000 times in a program of its own, with an
argument that moves through a range where it is defined, the results
summed and printed so that nothing is optimized away; a program that
only steps the argument is the baseline.  Jobs of four run every program
through F77CLG (the installed package, as bench/clg-test.py installs
it) and, unless --no-h, through FORTHCLG.  Each GO step's CPU time,
from the job log's IEF374I, less the baseline's, is the
function's: printed in seconds for 200,000 calls, with each program's
printed sum, which the two compilers' should agree on to their
functions' accuracy.

Run from the repository root with the package installed (clg-test.py
without --no-install, once); the guest arrangement is bench/ship.py's."""
import os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import ship

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
WORK = os.path.join(REPO, 'bench', 'out', 'mathtime')
JOBCARD = ("//HERC01M  JOB (TEST),'FORT370 MATH',CLASS=A,MSGCLASS=Z,\n"
           "//         USER=HERC01,PASSWORD=@HERC01PW@\n")
N = 200000

# name, the expression summed, the argument's start and step
FUNCS = [
    ('NONE',   'X',            '0.5D0',  '1.0D-5'),
    ('DSQRT',  'DSQRT(X)',     '0.5D0',  '1.0D-5'),
    ('DEXP',   'DEXP(X)',      '-1.0D0', '1.0D-5'),
    ('DLOG',   'DLOG(X)',      '0.5D0',  '1.0D-5'),
    ('DSIN',   'DSIN(X)',      '-1.0D0', '1.0D-5'),
    ('DCOS',   'DCOS(X)',      '-1.0D0', '1.0D-5'),
    ('DTAN',   'DTAN(X)',      '-1.0D0', '1.0D-5'),
    ('DATAN',  'DATAN(X)',     '-1.0D0', '1.0D-5'),
    ('DASIN',  'DARSIN(X)',    '-0.9D0', '0.9D-5'),
    ('DPOW',   'X ** 1.37D0',  '0.5D0',  '1.0D-5'),
    ('DATAN2', 'DATAN2(X, 0.7D0)', '-1.0D0', '1.0D-5'),
    ('DSINH',  'DSINH(X)',     '-1.0D0', '1.0D-5'),
    ('DCOSH',  'DCOSH(X)',     '-1.0D0', '1.0D-5'),
    ('DTANH',  'DTANH(X)',     '-1.0D0', '1.0D-5'),
]


def program(name, expr, x0, dx):
    return (f"      DOUBLE PRECISION X, S\n"
            f"      S = 0.0D0\n"
            f"      X = {x0}\n"
            f"      DO 10 I = 1, {N}\n"
            f"        S = S + {expr}\n"
            f"        X = X + {dx}\n"
            f"   10 CONTINUE\n"
            f"      WRITE (6,1) S\n"
            f"    1 FORMAT(' >{name:<6}', D24.16)\n"
            f"      END\n")


def main():
    args = sys.argv[1:]
    withh = True
    if args and args[0] == '--no-h':
        withh = False
        args = args[1:]
    funcs = [f for f in FUNCS if f[0] == 'NONE' or not args or f[0] in args]
    os.makedirs(WORK, exist_ok=True)
    proc = open(os.path.join(REPO, 'jcl', 'F77CLG.jcl')).read()
    proc = proc[:proc.index('//         PEND')] + '//         PEND\n'
    runs = []
    for comp in (('F', 'H') if withh else ('F',)):
        for name, expr, x0, dx in funcs:
            runs.append((comp, name, expr, x0, dx))
    # four programs to a job: more run the work volume out of space
    cpu, t = [], ''
    for b in range(0, len(runs), 4):
        jcl = JOBCARD + proc
        for k, (comp, name, expr, x0, dx) in enumerate(runs[b:b + 4]):
            step = f'{comp}{b + k}'
            if comp == 'F':
                jcl += f"//{step:<8} EXEC F77CLG,PARM.FORT='NOSOURCE'\n//FORT.SYSIN DD *\n"
            else:
                jcl += f"//{step:<8} EXEC FORTHCLG,PARM.FORT='OPT=2'\n//FORT.SYSIN DD *\n"
            jcl += program(name, expr, x0, dx) + "/*\n"
        deck = os.path.join(WORK, f'mathtime{b // 4}.jcl')
        open(deck, 'w').write(jcl)
        out = os.path.join(WORK, f'mathtime{b // 4}.out')
        ship.run_deck(deck, out)
        tb = open(out, 'rb').read().decode('latin-1')
        t += tb
        cpu += [60 * int(m) + float(sec)
                for m, sec in re.findall(r'IEF374I STEP /GO\s*/ STOP\s+\S+ CPU\s+(\d+)MIN (\d+\.\d+)SEC', tb)]
    runs = [(c, n) for c, n, *_ in runs]
    # the programs' lines, not the listings': H writes D 06 for D+06
    sums = [(n, v.replace(' ', '+')) for n, v in
            re.findall(r'^ ?>(\w+)\s+(-?0\.\d+D[ +-]\d\d)', t, re.M)]
    if len(cpu) != len(runs):
        sys.exit(f'mathtime: {len(cpu)} GO steps timed for {len(runs)} programs; see {WORK}')
    base = {c: s for (c, n), s in zip(runs, cpu) if n == 'NONE'}
    res = {}
    for (c, n), s in zip(runs, cpu):
        res[(c, n)] = s - base[c]
    got = {}
    for (c, n), (sn, sv) in zip(runs, sums):
        got[(c, n)] = sv
    print(f"{'':8}{'fort370':>9}{'H':>7}   (seconds for {N:,} calls, the loop's own less)")
    for name, *_ in funcs:
        if name == 'NONE': continue
        h = f"{res[('H', name)]:7.2f}" if withh else ''
        print(f"{name:<8}{res[('F', name)]:9.2f}{h}   {got.get(('F', name), '?')}"
              + (f"  {got.get(('H', name), '?')}" if withh else ''))


if __name__ == '__main__':
    main()
