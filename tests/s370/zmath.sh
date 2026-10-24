#!/bin/sh
# zmath.sh -- measure what tests/s370/zmath.f printed on the guest (its
# " >NAME i hex..." lines, in $1) against the exact values (mpmath): each
# function's worst error, in units of the last place of the result's
# magnitude, which is how a complex value is held to account.  Results
# beyond HFP's range (|w| over 7.2E75 or under 5.4E-79) are left out:
# no library returns them.  An argument a library refuses (FORTLIB's
# IHC28nI) can be left out too: --skip i,j,...
uv run --quiet --with mpmath python3 - "$@" <<'PY'
import re, sys
import mpmath
mpmath.mp.dps = 60
args = sys.argv[1:]
skip = set()
if args and args[0] == '--skip': skip = {int(x) for x in args[1].split(',')}; args = args[2:]
if not args: sys.exit('usage: zmath.sh [--skip i,j] output.txt')
def dec(h):
    v = int(h, 16)
    s = -1 if v >> 63 else 1
    return s * mpmath.mpf(v & ((1 << 56) - 1)) / mpmath.mpf(2) ** 56 * mpmath.mpf(16) ** (((v >> 56) & 0x7F) - 64)
def ulp(x):
    e = int(mpmath.floor(mpmath.log(abs(x), 16))) + 1
    return mpmath.mpf(16) ** e / mpmath.mpf(2) ** 56
got = {}
for l in open(args[0], encoding='latin-1'):
    m = re.match(r'\s*>(\w+)\s+(\d+)((?:\s+[0-9A-F]{16})+)', l)
    if m: got[(m.group(1), int(m.group(2)))] = [dec(h) for h in m.group(3).split()]
fn = {'SQRT': mpmath.sqrt, 'EXP': mpmath.exp, 'LOG': mpmath.log, 'SIN': mpmath.sin, 'COS': mpmath.cos, 'ABS': abs}
n = max(i for (k, i) in got if k == 'ARG')
for name, f in fn.items():
    worst, at, count = 0, 0, 0
    for i in range(1, n + 1):
        if i in skip or (name, i) not in got: continue
        a = got[('ARG', i)]
        w = f(mpmath.mpc(a[0], a[1]))
        mag = abs(w)
        if mag == 0 or mag > mpmath.mpf('7.2e75') or mag < mpmath.mpf('5.4e-79'): continue
        g = got[(name, i)]
        err = abs(g[0] - w) if name == 'ABS' else max(abs(g[0] - w.real), abs(g[1] - w.imag))
        e = float(err / ulp(mag))
        count += 1
        if e > worst: worst, at = e, i
    print('C%-5s %3d values, worst %10.2f units (argument %d)' % ('D' + name, count, worst, at))
PY
