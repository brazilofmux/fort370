/* f77dtoa.c -- exact decimal digits of a System/370 long hexadecimal
 * floating-point number, and the E and F editing built on them.
 *
 * libc370's printf is not exact in the last places (0.1 comes out as
 * 1.000000000000004E-01), and FORMAT's D22.15 shows fifteen digits
 * that have to be the number's own.  So, as s370_hfp.h does for the
 * other direction in the compiler, this works in big integers: the
 * value is frac * 2^e with frac a 56-bit integer, and its decimal
 * expansion is frac << e for e >= 0 or frac * 5^-e with the point
 * moved -e places for e < 0.  Nothing here is fast; a WRITE is not
 * where a Fortran program spends its time.
 *
 * Rounding is half up (ties away from zero), which is what IBM's
 * conversion does.
 *
 * The core takes the number as its two words so that the host can
 * test it (tests/host/dtoa_test.c); the double wrappers at the end
 * assume a big-endian HFP double, i.e. the target. */
#include <string.h>
#include "f77dtoa.h"

#define DT_BIGW 32    /* 32-bit limbs: 2^56 * 5^312 < 2^782 */

typedef struct { unsigned int w[DT_BIGW]; int n; } DtBig;

static void dt_mul_small(DtBig *b, unsigned int m) {
    unsigned int carry;
    int i;
    carry = 0;
    for (i = 0; i < b->n; i++) {
        unsigned int lo;
        unsigned int hi;
        unsigned int a;
        /* 32x32 -> 64 by halves: cc370 has no widening multiply */
        a = b->w[i];
        {
            unsigned int al = a & 0xFFFFu, ah = a >> 16;
            unsigned int ml = m & 0xFFFFu, mh = m >> 16;
            unsigned int p0 = al * ml;
            unsigned int p1 = al * mh;
            unsigned int p2 = ah * ml;
            unsigned int p3 = ah * mh;
            unsigned int mid = (p0 >> 16) + (p1 & 0xFFFFu) + (p2 & 0xFFFFu);
            lo = (p0 & 0xFFFFu) | (mid << 16);
            hi = p3 + (p1 >> 16) + (p2 >> 16) + (mid >> 16);
        }
        lo = lo + carry;
        if (lo < carry) hi = hi + 1;
        b->w[i] = lo;
        carry = hi;
    }
    if (carry && b->n < DT_BIGW) { b->w[b->n] = carry; b->n = b->n + 1; }
}

static void dt_shl(DtBig *b, int s) {
    while (s > 0) {
        int k;
        unsigned int carry;
        int i;
        k = s > 16 ? 16 : s;
        carry = 0;
        for (i = 0; i < b->n; i++) {
            unsigned int v;
            v = b->w[i];
            b->w[i] = (v << k) | carry;
            carry = v >> (32 - k);
        }
        if (carry && b->n < DT_BIGW) { b->w[b->n] = carry; b->n = b->n + 1; }
        s = s - k;
    }
}

/* b /= d, returning the remainder; d < 2^16 keeps the partial
 * dividends below 2^32 in 16-bit steps. */
static unsigned int dt_divmod_small(DtBig *b, unsigned int d) {
    unsigned int rem;
    int i;
    rem = 0;
    for (i = b->n - 1; i >= 0; i--) {
        unsigned int v;
        unsigned int hi;
        unsigned int lo;
        unsigned int q;
        v = b->w[i];
        hi = (rem << 16) | (v >> 16);
        q = hi / d;
        rem = hi - q * d;
        lo = (rem << 16) | (v & 0xFFFFu);
        v = lo / d;
        rem = lo - v * d;
        b->w[i] = (q << 16) | v;
    }
    while (b->n > 0 && b->w[b->n - 1] == 0) b->n = b->n - 1;
    return rem;
}

/* The decimal digits of b, most significant first, into digits (which
 * must hold 240 + 1 characters).  Returns the count; b is consumed. */
static int dt_to_decimal(DtBig *b, char *digits) {
    char rev[260];
    int n;
    int i;
    n = 0;
    while (b->n > 0 && n < 256) {
        unsigned int r;
        int k;
        r = dt_divmod_small(b, 10000u);
        for (k = 0; k < 4; k++) { rev[n++] = (char)('0' + r % 10); r = r / 10; }
    }
    /* rev holds the least significant digit first: the trailing zeros
     * of the number are at its front, the leading ones at its back */
    while (n > 0 && rev[n - 1] == '0') n--;
    {
        int s;
        s = 0;
        while (s < n && rev[s] == '0') s++;
        for (i = 0; i < n - s; i++) digits[i] = rev[n - 1 - i];
        digits[n - s] = 0;
        return n - s;
    }
}

int f77_hfp_digits(unsigned int hi, unsigned int lo, char *digits, int *decpt, int *neg) {
    DtBig b;
    int exp;
    int e;
    int nd;
    int i;
    *neg = (hi >> 31) & 1;
    exp = (int)((hi >> 24) & 0x7F);
    b.w[0] = lo;
    b.w[1] = hi & 0xFFFFFFu;
    b.n = b.w[1] ? 2 : (b.w[0] ? 1 : 0);
    if (b.n == 0) { digits[0] = 0; *decpt = 0; return 0; }
    e = 4 * exp - 256 - 56;          /* value = frac * 2^e */
    if (e >= 0) {
        dt_shl(&b, e);
        nd = dt_to_decimal(&b, digits);
        /* the integer's digits, with the trailing zeros the conversion
         * dropped counted back into the point's position */
        {
            DtBig c;
            int full;
            c.w[0] = lo; c.w[1] = hi & 0xFFFFFFu; c.n = b.w[1] ? 2 : 1;
            c.n = (hi & 0xFFFFFFu) ? 2 : 1;
            dt_shl(&c, e);
            full = 0;
            while (c.n > 0) { dt_divmod_small(&c, 10u); full++; }
            *decpt = full;
        }
    } else {
        for (i = 0; i < -e; i++) dt_mul_small(&b, 5u);
        {
            DtBig c;
            int full;
            c = b;
            full = 0;
            while (c.n > 0) { dt_divmod_small(&c, 10u); full++; }
            nd = dt_to_decimal(&b, digits);
            *decpt = full - (-e);
        }
    }
    return nd;
}

int f77_round_digits(char *digits, int nd, int keep, int *decpt) {
    int i;
    if (keep >= nd) return nd;
    if (keep < 0) { digits[0] = 0; return 0; }
    if (digits[keep] < '5') {
        while (keep > 0 && digits[keep - 1] == '0') keep--;
        digits[keep] = 0;
        return keep;
    }
    if (keep == 0) { digits[0] = '1'; digits[1] = 0; *decpt = *decpt + 1; return 1; }
    i = keep - 1;
    while (i >= 0) {
        if (digits[i] == '9') { digits[i] = '0'; i--; continue; }
        digits[i] = (char)(digits[i] + 1);
        break;
    }
    if (i < 0) {
        /* 999 -> 1000: one digit, the point one place further */
        digits[0] = '1';
        digits[1] = 0;
        *decpt = *decpt + 1;
        return 1;
    }
    while (keep > 0 && digits[keep - 1] == '0') keep--;
    digits[keep] = 0;
    return keep;
}

int f77_fmt_e_w(unsigned int hi, unsigned int lo, int nsig, char *mant, int *neg) {
    char digits[260];
    int nd;
    int decpt;
    int i;
    if (nsig < 1) nsig = 1;
    if (nsig > 250) nsig = 250;
    nd = f77_hfp_digits(hi, lo, digits, &decpt, neg);
    if (nd == 0) {
        for (i = 0; i < nsig; i++) mant[i] = '0';
        mant[nsig] = 0;
        return 0;
    }
    nd = f77_round_digits(digits, nd, nsig, &decpt);
    for (i = 0; i < nsig; i++) mant[i] = i < nd ? digits[i] : '0';
    mant[nsig] = 0;
    return decpt;
}

void f77_fmt_f_w(unsigned int hi, unsigned int lo, int d, char *out) {
    char digits[260];
    int nd;
    int decpt;
    int neg;
    int i;
    char *q;
    if (d < 0) d = 0;
    if (d > 200) d = 200;
    nd = f77_hfp_digits(hi, lo, digits, &decpt, &neg);
    if (nd > 0) nd = f77_round_digits(digits, nd, decpt + d, &decpt);
    q = out;
    if (neg) *q++ = '-';
    if (nd == 0 || decpt <= 0) *q++ = '0';
    else {
        for (i = 0; i < decpt; i++) *q++ = i < nd ? digits[i] : '0';
    }
    *q++ = '.';
    for (i = 0; i < d; i++) {
        int k;
        k = decpt + i;                   /* digit index of this decimal */
        *q++ = (nd > 0 && k >= 0 && k < nd) ? digits[k] : '0';
    }
    *q = 0;
}

/* --- the target's doubles --------------------------------------- */

typedef union { double d; unsigned int w[2]; } DtWords;   /* big-endian: w[0] is the first word */

int f77_fmt_e(double v, int nsig, char *mant, int *neg) {
    DtWords u;
    u.d = v;
    return f77_fmt_e_w(u.w[0], u.w[1], nsig, mant, neg);
}

void f77_fmt_f(double v, int d, char *out) {
    DtWords u;
    u.d = v;
    f77_fmt_f_w(u.w[0], u.w[1], d, out);
}

double f77_hfp_make(unsigned int hi, unsigned int lo) {
    DtWords u;
    u.w[0] = hi;
    u.w[1] = lo;
    return u.d;
}
