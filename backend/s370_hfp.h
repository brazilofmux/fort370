/* s370_hfp.h -- decimal text to System/370 hexadecimal floating point.
 *
 * A REAL or DOUBLE PRECISION constant is converted from its source text,
 * not from a host double: going through IEEE would round twice, and the
 * host's own double is IEEE on a Mac and HFP on MVS, so the compiler
 * would not reproduce.  FORTRAN H truncates (1.0D-6 is 3C10C6F7A0B5ED8D
 * in its listings; rounding would give ...8E), and so does this.
 *
 * Long HFP: sign bit, 7-bit characteristic (exponent of 16, excess 64),
 * 56-bit fraction in [1/16, 1) when normalized.  Short HFP is the same
 * with a 24-bit fraction, i.e. the long form's first word.
 *
 * The arithmetic is exact: the decimal digits become a big integer D
 * with a decimal exponent e10, and the value D*10^e10 is compared and
 * divided against powers of two and sixteen as big integers.  Nothing
 * here is fast, and nothing needs to be.
 */
#ifndef S370_HFP_H
#define S370_HFP_H

#define HFP_BIGW 40   /* 32-bit limbs: enough for 10^300 (~1000 bits) */

typedef struct { unsigned int w[HFP_BIGW]; int n; } HfpBig;

static void hfp_big_set(HfpBig *b, unsigned int v) {
    int i;
    for (i = 0; i < HFP_BIGW; i++) b->w[i] = 0;
    b->w[0] = v;
    b->n = v ? 1 : 0;
}

static int hfp_big_iszero(HfpBig *b) { return b->n == 0; }

/* b = b * m + a, small m and a */
static void hfp_big_muladd(HfpBig *b, unsigned int m, unsigned int a) {
    unsigned long long c;
    int i;
    c = a;
    for (i = 0; i < b->n; i++) {
        c = c + (unsigned long long)b->w[i] * m;
        b->w[i] = (unsigned int)c;
        c = c >> 32;
    }
    if (c && b->n < HFP_BIGW) { b->w[b->n] = (unsigned int)c; b->n = b->n + 1; }
}

/* b = b << s, s < 32 */
static void hfp_big_shl(HfpBig *b, int s) {
    unsigned int c;
    unsigned int t;
    int i;
    if (s == 0) return;
    c = 0;
    for (i = 0; i < b->n; i++) {
        t = b->w[i];
        b->w[i] = (t << s) | c;
        c = t >> (32 - s);
    }
    if (c && b->n < HFP_BIGW) { b->w[b->n] = c; b->n = b->n + 1; }
}

/* returns b1 <=> b2 */
static int hfp_big_cmp(HfpBig *x, HfpBig *y) {
    int i;
    if (x->n != y->n) return x->n < y->n ? -1 : 1;
    for (i = x->n - 1; i >= 0; i--)
        if (x->w[i] != y->w[i]) return x->w[i] < y->w[i] ? -1 : 1;
    return 0;
}

/* b = b - y, requires b >= y */
static void hfp_big_sub(HfpBig *b, HfpBig *y) {
    long long c;
    int i;
    c = 0;
    for (i = 0; i < b->n; i++) {
        c = (long long)b->w[i] - (i < y->n ? y->w[i] : 0) + c;
        if (c < 0) { b->w[i] = (unsigned int)(c + 4294967296LL); c = -1; }
        else { b->w[i] = (unsigned int)c; c = 0; }
    }
    while (b->n > 0 && b->w[b->n - 1] == 0) b->n = b->n - 1;
}

static int hfp_big_bits(HfpBig *b) {
    unsigned int t;
    int k;
    if (b->n == 0) return 0;
    t = b->w[b->n - 1];
    k = 0;
    while (t) { k = k + 1; t = t >> 1; }
    return (b->n - 1) * 32 + k;
}

/* Convert decimal text (digits, optional point, optional E/D exponent,
 * optional sign) to HFP.  *hi gets the first word, *lo the second; for
 * short HFP the caller keeps *hi only, which is a truncation, as H's
 * REAL constants are.  Returns 0 on success, -1 if the text is not a
 * number, 1 if the exponent is out of HFP's range (the result is then
 * the largest or smallest magnitude, or zero). */
static int hfp_from_text(const char *s, unsigned int *hi, unsigned int *lo) {
    HfpBig num;      /* numerator:   D * 2^shift (* 10^e10 when e10 > 0) */
    HfpBig den;      /* denominator: 10^-e10 (when e10 < 0) */
    int neg;
    int e10;
    int ndig;
    int sawdot;
    int e;           /* HFP exponent: value in [16^(e-1), 16^e) */
    int i;
    int bits;
    unsigned long long frac;
    int fbits;
    int nb, db;
    int shift;

    neg = 0; e10 = 0; ndig = 0; sawdot = 0;
    hfp_big_set(&num, 0);
    if (*s == '+' || *s == '-') { neg = (*s == '-'); s++; }
    while ((*s >= '0' && *s <= '9') || *s == '.') {
        if (*s == '.') { if (sawdot) return -1; sawdot = 1; s++; continue; }
        if (ndig < 300 && !(ndig == 0 && *s == '0' && !sawdot && 0)) {
            hfp_big_muladd(&num, 10, (unsigned int)(*s - '0'));
            if (!hfp_big_iszero(&num)) ndig = ndig + 1;
        }
        if (sawdot) e10 = e10 - 1;
        s++;
    }
    if (*s == 'E' || *s == 'e' || *s == 'D' || *s == 'd') {
        int eneg;
        int ev;
        s++;
        eneg = 0; ev = 0;
        if (*s == '+' || *s == '-') { eneg = (*s == '-'); s++; }
        if (!(*s >= '0' && *s <= '9')) return -1;
        while (*s >= '0' && *s <= '9') { if (ev < 10000) ev = ev * 10 + (*s - '0'); s++; }
        e10 = e10 + (eneg ? -ev : ev);
    }
    if (*s != 0) return -1;
    *hi = 0; *lo = 0;
    if (hfp_big_iszero(&num)) return 0;   /* +0 and -0 are both zero */
    if (e10 > 75 || e10 < -90) {
        /* beyond any HFP number: overflow or underflow.  The bound is
         * loose on purpose; the exact range test comes below. */
        if (e10 > 0) { *hi = (neg ? 0x80000000u : 0) | 0x7FFFFFFFu; *lo = 0xFFFFFFFFu; return 1; }
        return 1;
    }
    hfp_big_set(&den, 1);
    if (e10 > 0) { for (i = 0; i < e10; i++) hfp_big_muladd(&num, 10, 0); }
    else { for (i = 0; i < -e10; i++) hfp_big_muladd(&den, 10, 0); }

    /* value = num/den.  Find e with 16^(e-1) <= value < 16^e by
     * comparing bit lengths, then refine by one comparison. */
    nb = hfp_big_bits(&num);
    db = hfp_big_bits(&den);
    bits = nb - db;   /* value is in [2^(bits-1), 2^(bits+1)) */
    {
        /* exact: is num >= den * 2^bits ?  compare num against den<<bits */
        HfpBig t;
        int k;
        t = den;
        k = bits;
        if (k >= 0) { while (k >= 31) { hfp_big_shl(&t, 31); k = k - 31; } hfp_big_shl(&t, k); }
        else {
            HfpBig u;
            u = num;
            k = -k;
            while (k >= 31) { hfp_big_shl(&u, 31); k = k - 31; }
            hfp_big_shl(&u, k);
            if (hfp_big_cmp(&u, &den) >= 0) bits = bits + 1;
            goto have_bits;
        }
        if (hfp_big_cmp(&num, &t) >= 0) bits = bits + 1;
    }
have_bits:
    /* now 2^(bits-1) <= value < 2^bits */
    e = bits >= 0 ? (bits + 3) / 4 : -((-bits) / 4);
    /* 16^(e-1) <= value < 16^e  <=>  4(e-1) <= bits-1 < 4e */
    while (4 * (e - 1) > bits - 1) e = e - 1;
    while (bits - 1 >= 4 * e) e = e + 1;
    if (e + 64 > 127) { *hi = (neg ? 0x80000000u : 0) | 0x7FFFFFFFu; *lo = 0xFFFFFFFFu; return 1; }
    if (e + 64 < 0) return 1;

    /* fraction = floor(value / 16^e * 2^56) = floor(num * 2^(56-4e) / den) */
    shift = 56 - 4 * e;
    if (shift >= 0) {
        while (shift >= 31) { hfp_big_shl(&num, 31); shift = shift - 31; }
        hfp_big_shl(&num, shift);
    } else {
        shift = -shift;
        while (shift >= 31) { hfp_big_shl(&den, 31); shift = shift - 31; }
        hfp_big_shl(&den, shift);
    }
    /* long division num/den, quotient fits 56 bits: do it bit by bit */
    frac = 0;
    fbits = hfp_big_bits(&num) - hfp_big_bits(&den) + 1;
    if (fbits > 57) fbits = 57;
    {
        HfpBig t;
        int k;
        for (k = fbits - 1; k >= 0; k--) {
            int j;
            t = den;
            j = k;
            while (j >= 31) { hfp_big_shl(&t, 31); j = j - 31; }
            hfp_big_shl(&t, j);
            if (hfp_big_cmp(&num, &t) >= 0) {
                hfp_big_sub(&num, &t);
                frac = frac | (1ULL << k);
            }
        }
    }
    *hi = (unsigned int)((neg ? 0x80000000u : 0) | ((unsigned int)(e + 64) << 24) |
                         (unsigned int)(frac >> 32));
    *lo = (unsigned int)(frac & 0xFFFFFFFFu);
    return 0;
}

#endif
