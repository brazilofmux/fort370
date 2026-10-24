#!/usr/bin/env python3
"""inline-check.py [--no-install] [--no-fcvs] [NAME...] -- the inliner checked
against itself (fort370 issue 16): every program, compiled with the
front end's inlining (f77_parse.h, f77_inline) and without it
(F77_INLINE_MAX=0), must print the same.  Neither compile needs a
reference answer: a difference is a bug, in the inliner or in what it
exposes.

  1. every FCVS program, test and kernel is compiled on the host both
     ways; one whose assembler is the same either way is done;
  2. the FCVS programs left run on the guest twice through bench/fcvs.sh
     (host-compiled, as always), and each report is compared;
  3. the tests and kernels left run on the guest from the host's
     assembler: jcl/F77CLG.jcl without its compile step, assembled,
     linked with F77RT (installed first, as bench/clg-test.py does
     unless --no-install) and run, both compiles of a program in one
     job, its SYSIN the test's .in file when it has one, scratch DDs
     for every unit as in clg-test.  Each run's printed output and its
     GO step's return code (a self-checking test says only STOP n) are
     compared, the addresses in a traceback aside.

Names (FM026, splicedo) limit it to those programs.  Run from the
repository root after `make runtime` and `make mvs`, TK5 up, with
RUNNER, JOBUSER and JOBPASS as elsewhere in bench/.  Reports land in
bench/out/inline/."""
import glob, importlib.util, os, re, shutil, subprocess, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import ship

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
WORK = os.path.join(REPO, 'bench', 'out', 'inline')
FCVS = os.environ.get('FCVS', os.path.expanduser('~/refs/fcvs/fcvs21'))
JOBCARD = ("//HERC01I  JOB (TEST),'INLINE CHECK',CLASS=A,MSGCLASS=Z,\n"
           "//         USER=HERC01,PASSWORD=@HERC01PW@\n")
PER_JOB = 3          # programs a job, two runs each: scratch DDs run short past that
MARK = '@@INLINE '


def compile_both(src, out_on, out_off):
    f77 = os.path.join(REPO, 'out', 'f77')
    env = dict(os.environ)
    env.pop('F77_INLINE_MAX', None)
    a = subprocess.run([f77, src, out_on], env=env, capture_output=True)
    env['F77_INLINE_MAX'] = '0'
    b = subprocess.run([f77, src, out_off], env=env, capture_output=True)
    if a.returncode or b.returncode:
        return None
    return open(out_on, 'rb').read() != open(out_off, 'rb').read()


def proc_lg():
    """F77CLG without its compile step: the assembler comes in as ASMIN."""
    p = open(os.path.join(REPO, 'jcl', 'F77CLG.jcl')).read()
    p = p[p.index('//F77CLG   PROC'):p.index('//         PEND')] + '//         PEND\n'
    head, rest = p.split('//ASM ', 1)
    p = '//F77LG    PROC\n//ASM ' + rest
    p = p.replace('//ASM      EXEC PGM=IFOX00,PARM=\'OBJ,NODECK\',REGION=2048K,\n//            COND=(0,NE)\n',
                  '//ASM      EXEC PGM=IFOX00,PARM=\'OBJ,NODECK\',REGION=2048K\n')
    p = p.replace('//SYSIN    DD DSN=&&ASM,DISP=(OLD,DELETE)', '//SYSIN    DD DDNAME=ASMIN')
    p = p.replace('COND=((0,NE,FORT),(8,LE,ASM))', 'COND=(8,LE,ASM)')
    p = p.replace('COND=((0,NE,FORT),(8,LE,ASM),(4,LT,LKED))', 'COND=((8,LE,ASM),(4,LT,LKED))')
    if 'FORT' in p.replace('FORTRAN', '').replace('FORT370', ''):
        sys.exit('inline-check: F77CLG changed shape; proc_lg needs a look')
    return p


def go_dds():
    jcl = ''
    for u in list(range(1, 5)) + list(range(7, 31)):
        jcl += (f"//GO.FT{u:02d}F001 DD UNIT=SYSDA,SPACE=(TRK,(10,10)),DISP=(NEW,DELETE),\n"
                f"//            DCB=(RECFM=VB,LRECL=260,BLKSIZE=2604)\n")
    jcl += ("//GO.FT31F001 DD UNIT=SYSDA,SPACE=(TRK,(10,10)),DISP=(NEW,DELETE),\n"
            "//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=3120)\n")
    return jcl


def mark_step(k, text):
    return (f"//M{k:<7} EXEC PGM=IEBGENER\n//SYSPRINT DD DUMMY\n//SYSIN    DD DUMMY\n"
            f"//SYSUT2   DD SYSOUT=*\n//SYSUT1   DD *\n{MARK}{text}\n/*\n")


def banner(l):
    """A line of JES2's separator page, its letters in blocks: the job
    number in it differs from one run to the next."""
    w = l.split()
    return len(w) >= 3 and all(len(x) >= 2 and len(set(x)) == 1 and x[0].isalnum() for x in w)


def normal(lines):
    """A run's printed lines, what may differ between two compiles aside:
    a traceback's registers and entry point are addresses, and JES2's
    separator page carries the job number."""
    out = []
    for l in lines:
        if banner(l): continue
        l = re.sub(r'[0-9A-F]{8}', '<addr>', l) if re.search(r'[0-9A-F]{8}   [0-9A-F]{8}', l) or 'ENTRY POINT=' in l else l
        out.append(l.rstrip())
    while out and not out[-1]: out.pop()
    return out


def asm_cards(asm):
    """The assembler as cards; a program that reports through the job
    log (CALL IPRINT, DPRINT) gets runtime/s370/f77dbg.asm before its
    END, as bench/asmclg.sh gives it."""
    lines = [l[:72].rstrip() for l in open(asm).read().split('\n') if l.strip()]
    if any('V(IPRINT)' in l or 'V(DPRINT)' in l for l in lines):
        end = lines.pop() if re.match(r'^ +END(\s|$)', lines[-1]) else '         END'
        lines += [l[:72].rstrip() for l in open(os.path.join(REPO, 'runtime', 's370', 'f77dbg.asm')).read().split('\n')
                  if l.strip() and not re.match(r'^ +END(\s|$)', l)]
        lines.append(end)
    return ''.join(l + '\n' for l in lines)


def run_tests(progs):
    lg = proc_lg()
    same, bad = 0, []
    for j in range(0, len(progs), PER_JOB):
        chunk = progs[j:j + PER_JOB]
        jcl = JOBCARD + lg
        k = 0
        for name, src, on, off in chunk:
            for how, asm in (('ON', on), ('OFF', off)):
                jcl += mark_step(k, f'{name} {how}')
                jcl += f"//R{k:<7} EXEC F77LG\n//ASM.ASMIN DD *\n"
                jcl += asm_cards(asm)
                jcl += "/*\n//LKED.SYSPRINT DD DUMMY\n" + go_dds()
                inp = os.path.splitext(src)[0] + '.in'
                if os.path.exists(inp):
                    jcl += "//GO.SYSIN DD *\n" + ''.join(l.rstrip()[:80] + '\n' for l in open(inp).read().split('\n')) + "/*\n"
                k += 1
        jcl += mark_step(k, 'END')
        deck = os.path.join(WORK, f'job{j // PER_JOB}.jcl')
        out = os.path.join(WORK, f'job{j // PER_JOB}.out')
        open(deck, 'w').write(jcl)
        ship.run_deck(deck, out)
        t = open(out, 'rb').read().decode('latin-1').replace('\x0c', '\n').replace('\r', '')
        runs, cur = {}, None
        for l in t.split('\n'):
            m = re.match(r'^ ?' + re.escape(MARK) + r'(\S+) (ON|OFF)', l)
            if m: cur = (m.group(1), m.group(2)); runs[cur] = []; continue
            if l.startswith(' ' + MARK + 'END') or l.startswith(MARK + 'END'): cur = None; continue
            if cur and not re.match(r'^\s*(\*{4}|J E S 2|\$HASP|IEF|IEC)', l): runs[cur].append(l)
        # what a run wrote to the job log (WTO), between its LKED and GO lines
        cur = None
        for l in t.split('\n'):
            m = re.match(r'^\d\d\.\d\d\.\d\d JOB +\d+ +(.*)$', l)
            if not m: continue
            m2 = re.match(r'HERC01I\s+R(\d+)\s+(LKED|GO)\s', m.group(1))
            if m2:
                cur = int(m2.group(1)) if m2.group(2) == 'LKED' else None
                continue
            if cur is not None:
                kk, n = 0, None
                for name, src, on, off in chunk:
                    for how in ('ON', 'OFF'):
                        if kk == cur: n = (name, how)
                        kk += 1
                if n: runs.setdefault(n, []).append('LOG ' + m.group(1).rstrip())
        rc = {}
        for kk in range(k):
            m = re.search(rf'HERC01I\s+R{kk}\s+GO\s+\S+\s+(RC= \d+|\*FLUSH\*)|HERC01I\s+R{kk}\s+GO\s+\S+\s+(ABEND \S+)', t)
            rc[kk] = (m.group(1) or m.group(2)) if m else 'NOT RUN'
        kk = 0
        for name, src, on, off in chunk:
            for how in ('ON', 'OFF'):
                runs.setdefault((name, how), []).append('GO ' + rc[kk])
                kk += 1
        for name, src, on, off in chunk:
            a, b = normal(runs.get((name, 'ON'), [])), normal(runs.get((name, 'OFF'), []))
            open(os.path.join(WORK, name + '.on.txt'), 'w').write('\n'.join(a) + '\n')
            open(os.path.join(WORK, name + '.off.txt'), 'w').write('\n'.join(b) + '\n')
            if a == b: same += 1
            else: print(f'{name}: DIFFERS (bench/out/inline/{name}.on.txt, .off.txt)'); bad.append(name)
    return same, bad


def run_fcvs(names):
    """bench/fcvs.sh for these, inlining on and then off; the reports kept
    side by side, bench/out/fcvs as it was."""
    o = os.path.join(REPO, 'bench', 'out', 'fcvs')
    saved = os.path.join(WORK, 'fcvs-saved')
    if os.path.isdir(saved): shutil.rmtree(saved)
    if os.path.isdir(o): shutil.move(o, saved)
    try:
        for how in ('on', 'off'):
            env = dict(os.environ)
            if how == 'off': env['F77_INLINE_MAX'] = '0'
            else: env.pop('F77_INLINE_MAX', None)
            subprocess.run(['sh', os.path.join(REPO, 'bench', 'fcvs.sh')] + names, env=env, check=True,
                           stdout=subprocess.DEVNULL)
            d = os.path.join(WORK, 'fcvs-' + how)
            if os.path.isdir(d): shutil.rmtree(d)
            shutil.move(o, d)
    finally:
        if os.path.isdir(saved): shutil.move(saved, o)
    same, bad = 0, []
    for n in names:
        rd = lambda how: [l.rstrip() for l in open(os.path.join(WORK, 'fcvs-' + how, n + '.txt'), encoding='latin-1')] \
            if os.path.exists(os.path.join(WORK, 'fcvs-' + how, n + '.txt')) else []
        a, b = normal(rd('on')), normal(rd('off'))
        if not a: print(f'{n}: no report'); bad.append(n)
        elif a == b: same += 1
        else: print(f'{n}: DIFFERS (bench/out/inline/fcvs-on/{n}.txt, fcvs-off/)'); bad.append(n)
    return same, bad


def main():
    args = sys.argv[1:]
    inst, fcvs = True, True
    while args and args[0].startswith('--'):
        a = args.pop(0)
        if a == '--no-install': inst = False
        elif a == '--no-fcvs': fcvs = False
        else: sys.exit(__doc__)
    only = set(a.upper() for a in args)
    os.makedirs(WORK, exist_ok=True)
    srcs = sorted(glob.glob(os.path.join(FCVS, 'FM*.FOR')))
    for d in ('tests/f77', 'tests/s370', 'bench/kernels'):
        srcs += sorted(glob.glob(os.path.join(REPO, d, '*.f')))
    fm, tests, n = [], [], 0
    for src in srcs:
        name = os.path.splitext(os.path.basename(src))[0]
        if only and name.upper() not in only: continue
        n += 1
        on = os.path.join(WORK, name + '.on.asm')
        off = os.path.join(WORK, name + '.off.asm')
        d = compile_both(src, on, off)
        if d is None: print(f'{name}: does not compile'); continue
        if not d: continue
        if src.upper().endswith('.FOR'): fm.append(name)
        else: tests.append((name, src, on, off))
    print(f'{n} programs; inlining changes the code of {len(fm)} FCVS programs and {len(tests)} others')
    bad = []
    if fcvs and fm:
        s, b = run_fcvs(fm)
        print(f'FCVS: {s} the same, {len(b)} differ')
        bad += b
    if tests:
        if inst:
            spec = importlib.util.spec_from_file_location('clg', os.path.join(REPO, 'bench', 'clg-test.py'))
            clg = importlib.util.module_from_spec(spec)
            spec.loader.exec_module(clg)
            os.makedirs(clg.WORK, exist_ok=True)
            clg.install()
        s, b = run_tests(tests)
        print(f'tests: {s} the same, {len(b)} differ')
        bad += b
    print('inline-check: ' + ('the same with inlining and without' if not bad else 'DIFFERENCES: ' + ' '.join(bad)))
    sys.exit(1 if bad else 0)


if __name__ == '__main__':
    main()
