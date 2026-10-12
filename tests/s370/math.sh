#!/bin/sh
# math.sh -- check what tests/s370/math.f printed on the guest (its
# " >NAME value" lines, in $1) against Python's exact arithmetic: the
# relative error of each value, and the worst.  HFP long has 56 bits,
# so a few units in the last place is 1e-16.
uv run --quiet --with mpmath python3 - "${1:?usage: math.sh output.txt}" <<'PY'
import re, sys, math
from decimal import Decimal, getcontext
getcontext().prec = 40
def D(s): return Decimal(s.replace('D', 'E'))
x = None; worst = 0; n = 0
import mpmath
mpmath.mp.dps = 40
f = {'SQRT': lambda y: mpmath.sqrt(abs(y)), 'EXP': mpmath.exp, 'LOG': lambda y: mpmath.log(abs(y)),
     'LOG10': lambda y: mpmath.log10(abs(y)), 'SIN': mpmath.sin, 'COS': mpmath.cos, 'TAN': mpmath.tan,
     'ATAN': mpmath.atan, 'ATAN2': lambda y: mpmath.atan2(y, 3), 'SINH': mpmath.sinh, 'COSH': mpmath.cosh,
     'TANH': mpmath.tanh, 'POW': lambda y: abs(y) ** mpmath.mpf('1.5')}
asin_args = iter([mpmath.mpf('0.5'), mpmath.mpf('-0.9')])
for line in open(sys.argv[1], encoding='latin-1'):
    m = re.match(r'\s*>\s*(\w+)\s+(-?[0-9.]+[DE][-+]?\d+)', line)
    if not m: continue
    name, val = m.group(1), m.group(2).replace('D', 'E')
    v = mpmath.mpf(val)
    if name == 'X': x = v; continue
    if name in f: want = f[name](x)
    elif name == 'ASIN': want = mpmath.asin(next(asin_args))
    elif name == 'ACOS': want = mpmath.acos(mpmath.mpf('0.5'))
    elif name == 'RSQRT': want = mpmath.sqrt(2); 
    elif name == 'RSIN': want = mpmath.sin(2)
    elif name == 'REXP': want = mpmath.exp(2)
    elif name == 'RPOW': want = mpmath.sqrt(2)
    else: continue
    rel = abs((v - want) / want) if want != 0 else abs(v)
    n += 1
    if rel > worst: worst = rel
    flag = '' if rel < (1.5e-15 if not name.startswith('R') else 2e-7) else '   <--'
    print('%-6s x=%-10s got %s rel %.1e%s' % (name, mpmath.nstr(x, 6) if x is not None else '', val, rel, flag))
print('%d values, worst relative error %.2e' % (n, worst))
PY
# The constants in runtime/s370/f77math.c, as HFP words, came from this:
#   uv run --with mpmath python3 - <<'PY'
#   import mpmath; mpmath.mp.dps = 60
#   def hfp(v, bits=56):            # words of v truncated to `bits` significant bits
#       v = mpmath.mpf(v); e = int(mpmath.floor(mpmath.log(v, 16))) + 1
#       f = v / mpmath.mpf(16) ** e; frac = int(mpmath.floor(f * 2 ** 56))
#       drop = frac.bit_length() - bits
#       if drop > 0: frac = (frac >> drop) << drop
#       return (e + 64) << 24 | frac >> 32, frac & 0xFFFFFFFF
#   pi2 = mpmath.pi / 2; print([hex(w) for w in hfp(pi2)], [hex(w) for w in hfp(pi2, 36)])
#   PY
# with pio2_2 = the 36 bits of (pi/2 - pio2_1) and pio2_3 the 56 bits of
# the remainder; ln2_hi/ln2_lo likewise.
