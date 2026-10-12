#!/bin/sh
# dtoa.sh -- check the runtime's exact HFP-to-decimal digits against
# Python's Fraction for a list of decimals.  The words come from the
# compiler's own conversion (truncating, as H's); the check is that
# the digits printed are exactly those of the HFP value the words hold.
set -e
cd "$(dirname "$0")/../.."
cc -O1 -o out/dtoa_test tests/host/dtoa_test.c runtime/s370/f77dtoa.c
out/dtoa_test 0.1 1.0E-6 100099.999999737 0.666666666666666667 1.0E20 123456789.0 0.0 -5.0E-3 \
    500.404006199570 847.610420053770 1.0E75 5.4E-79 1.0 16.0 0.0625 2.5 3.14159265358979 \
    -0.000123456789 999999999999999.9 0.99999999999999999 > out/dtoa.txt
python3 - <<'EOF'
from fractions import Fraction
ok = 0; bad = 0
for line in open('out/dtoa.txt'):
    text, words, nd, decpt, digits = line.split()[:5]
    e15 = line.split('E15=')[1].split()[0]
    hi = int(words[:8], 16); lo = int(words[8:], 16)
    frac = ((hi & 0xFFFFFF) << 32) | lo
    exp = (hi >> 24) & 0x7F
    neg = hi >> 31
    val = Fraction(frac) * Fraction(16) ** (exp - 64) / Fraction(2 ** 56)
    # exact digits: val = 0.digits * 10**decpt
    if frac == 0:
        want = ('0', 0)
    else:
        s = format(val.numerator * 10 ** 400 // val.denominator, 'd')   # 400 extra decimals: exact for HFP
        s = s.rstrip('0')
        want = (s.lstrip('0'), len(s) - 400 + (0))
        # len(s) counts digits of val*10^400 -> decpt = len(s) - 400
    got = (digits, int(decpt))
    # recompute want decpt properly
    if frac:
        n = val.numerator * 10 ** 400 // val.denominator
        s = str(n)
        want = (s.rstrip('0'), len(s) - 400)
    # E15: round half up to 15 digits of the exact digit string
    if frac:
        ds, dp = want
        if len(ds) > 15:
            head = ds[:15]
            if ds[15] >= '5':
                head = str(int(head) + 1)
                if len(head) > 15: head = head[:15]; dp += 1
            ds15 = head.ljust(15, '0')
        else:
            ds15 = ds.ljust(15, '0')
        want_e = ('-' if neg else '') + '0.' + ds15 + str(dp)
    else:
        want_e = '0.' + '0' * 15 + '0'
    if got == want and e15 == want_e:
        ok += 1
    else:
        bad += 1
        print('MISMATCH', text, 'got', got, e15, 'want', want, want_e)
print(f'{ok} ok, {bad} bad')
raise SystemExit(1 if bad else 0)
EOF
