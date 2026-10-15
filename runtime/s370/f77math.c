/* f77math.c -- the mathematical intrinsics, in C, for System/370
 * hexadecimal floating point.
 *
 * libc370's libm is not usable from here (its sqrt took an operation
 * exception in a plain C program, 2026-10-12), and FORTLIB's DSQRT and
 * friends live on the guest, where a host-linked module cannot reach
 * them.  So the runtime carries its own: textbook argument reduction
 * and series, written against the HFP format directly -- a long HFP
 * number is a sign, a seven-bit exponent of sixteen (excess 64) and a
 * 56-bit fraction in [1/16, 1) -- so that scaling by powers of two and
 * the splitting of constants are exact.  The constants are built from
 * their hexadecimal digits, not decimal text, for the same reason; the
 * digits come from mpmath (the recipe is in tests/s370/math.sh).
 *
 * The external names are libm's (SQRT, SIN, ...), which is what the
 * compiler emits (backend/s370_rtnames.h) and what the runtime's own
 * calls through <math.h> resolve to; the archive's members are then
 * never pulled in.  A REAL argument arrives widened to double.
 *
 * A REAL result is the long one cut to short, and so within a unit and
 * nearly always the exact value truncated.  The long results, against
 * the exact values and FORTLIB's (2026-10-15, on TK5; the figures are
 * in docs/INSTALL-MVS.txt): SQRT correctly rounded, as FORTLIB's is;
 * SIN and COS within 2 units at any argument, where FORTLIB's are off
 * by thousands; the rest 3 to 30 units, behind FORTLIB's 1 or 2, the
 * wobble of hexadecimal precision across 1.0 in their intermediate
 * values the usual cause. */

typedef union { double d; unsigned int w[2]; } Hfp;   /* big-endian: w[0] has the sign and exponent */

static double hfp_make(unsigned int hi, unsigned int lo) { Hfp u; u.w[0] = hi; u.w[1] = lo; return u.d; }
static int hfp_is_zero(double x) { Hfp u; u.d = x; return (u.w[0] & 0x00FFFFFFu) == 0 && u.w[1] == 0; }

static double m_fabs(double x) { Hfp u; u.d = x; u.w[0] = u.w[0] & 0x7FFFFFFFu; return u.d; }

/* x = m * 2^e with m in [0.5, 1); zero gives m = 0, e = 0.  Exact:
 * the exponent of sixteen is read, and the fraction's leading hex
 * digit says how many doublings bring it to [0.5, 1). */
static double m_frexp(double x, int *e) {
    Hfp u;
    int e16;
    unsigned int top;
    u.d = x;
    if (hfp_is_zero(x)) { *e = 0; return 0.0; }
    e16 = (int)((u.w[0] >> 24) & 0x7F) - 64;
    u.w[0] = (u.w[0] & 0x80FFFFFFu) | (64u << 24);   /* m16 in [1/16, 1) */
    *e = 4 * e16;
    top = (u.w[0] >> 20) & 0xFu;                     /* the leading hex digit, 1..15 when normalized */
    if (top >= 8) return u.d;
    if (top >= 4) { *e = *e - 1; return u.d * 2.0; }
    if (top >= 2) { *e = *e - 2; return u.d * 4.0; }
    if (top >= 1) { *e = *e - 3; return u.d * 8.0; }
    /* unnormalized: normalize by arithmetic (exact), then try again */
    return m_frexp(u.d * 1.0, e);
}

/* x * 2^e, exactly: the exponent of sixteen takes e/4, the remainder
 * is one multiplication by 2, 4 or 8.  Saturates at HFP's largest
 * magnitude, flushes to zero below its smallest. */
static double m_ldexp(double x, int e) {
    Hfp u;
    int e16;
    int q;
    int r;
    if (hfp_is_zero(x)) return 0.0;
    q = e >= 0 ? e / 4 : -((-e + 3) / 4);
    r = e - 4 * q;                                   /* 0..3 */
    u.d = x;
    e16 = (int)((u.w[0] >> 24) & 0x7F) + q;
    if (e16 > 127 || (e16 == 127 && r > 0 && ((u.w[0] >> 20) & 0xFu) >= (8u >> (r - 1)))) {
        u.w[0] = (u.w[0] & 0x80000000u) | 0x7FFFFFFFu; u.w[1] = 0xFFFFFFFFu; return u.d;
    }
    if (e16 < 0) return 0.0;
    u.w[0] = (u.w[0] & 0x80FFFFFFu) | ((unsigned int)e16 << 24);
    if (r == 1) return u.d * 2.0;
    if (r == 2) return u.d * 4.0;
    if (r == 3) return u.d * 8.0;
    return u.d;
}

#define HFP_HUGE  hfp_make(0x7FFFFFFFu, 0xFFFFFFFFu)   /* 16^63 (1 - 16^-14) */

static double c_ln2(void)    { return hfp_make(0x40B17217u, 0xF7D1CF79u); }   /* ln 2 */
static double c_ln2_hi(void) { return hfp_make(0x40B17217u, 0xF7D00000u); }   /* its first 36 bits */
static double c_ln2_lo(void) { return hfp_make(0x371CF79Au, 0xBC9E3B39u); }   /* the rest */
static double c_rln2(void)   { return hfp_make(0x41171547u, 0x652B82FEu); }   /* 1 / ln 2 */
static double c_rln10(void)  { return hfp_make(0x406F2DECu, 0x549B9438u); }   /* 1 / ln 10 */
static double c_pio2(void)   { return hfp_make(0x411921FBu, 0x54442D18u); }   /* pi / 2 */
static double c_pio2_1(void) { return hfp_make(0x411921FBu, 0x54440000u); }   /* its first 36 bits */
static double c_pio2_2(void) { return hfp_make(0x372D1846u, 0x98980000u); }   /* the next 36 */
static double c_pio2_3(void) { return hfp_make(0x2DCC5170u, 0x1B839A25u); }   /* the rest */
static double c_pi(void)     { return hfp_make(0x413243F6u, 0xA8885A30u); }
static double c_sqrthalf(void) { return hfp_make(0x40B504F3u, 0x33F9DE64u); }

/* --- big integers ---------------------------------------------- */

/* Unsigned integers as 14-bit limbs, least significant first: the
 * product of two limbs, and a few of them summed, fit an unsigned int,
 * and the runtime has no use for cc370's 64-bit arithmetic. */
#define LB 14
#define LM 0x3FFFu

/* a[0..n) = f << sh, f the 56 bits hi:lo (hi has 24) */
static void bn_set(unsigned int *a, int n, unsigned int hi, unsigned int lo, int sh) {
    unsigned int f[4];
    int q;
    int r;
    int i;
    f[0] = lo & LM;
    f[1] = (lo >> 14) & LM;
    f[2] = ((lo >> 28) | (hi << 4)) & LM;
    f[3] = (hi >> 10) & LM;
    q = sh / LB;
    r = sh % LB;
    for (i = 0; i < n; i++) a[i] = 0;
    for (i = 0; i < 4; i++) {
        if (i + q < n) a[i + q] = a[i + q] | ((f[i] << r) & LM);
        if (r > 0 && i + q + 1 < n) a[i + q + 1] = a[i + q + 1] | (f[i] >> (LB - r));
    }
}

/* c[0..na+nb) = a * b */
static void bn_mul(unsigned int *c, unsigned int *a, int na, unsigned int *b, int nb) {
    unsigned int carry;
    int i;
    int j;
    for (i = 0; i < na + nb; i++) c[i] = 0;
    for (i = 0; i < na; i++)
        for (j = 0; j < nb; j++) {
            c[i + j] = c[i + j] + a[i] * b[j];
            if (c[i + j] >= 0x40000000u) { c[i + j + 1] = c[i + j + 1] + (c[i + j] >> LB); c[i + j] = c[i + j] & LM; }
        }
    carry = 0;
    for (i = 0; i < na + nb; i++) { c[i] = c[i] + carry; carry = c[i] >> LB; c[i] = c[i] & LM; }
}

/* --- square root, correctly rounded ----------------------------- */

/* Newton on the binary mantissa, n steps from within 3%: four give a
 * few units in the last place. */
static double m_sqrt_est(double x, int n) {
    double m;
    double y;
    int e;
    int i;
    m = m_frexp(x, &e);                  /* [0.5, 1) */
    if (e & 1) { m = m * 2.0; e = e - 1; }   /* [0.5, 2) with an even exponent */
    y = 0.41731 + 0.59016 * m;           /* within 3% */
    for (i = 0; i < n; i++) y = 0.5 * (y + m / y);
    return m_ldexp(y, e / 2);
}

/* Whether (2R + 1)^2 is below 4N, R the 56 bits hi:lo and n4h the
 * high word of 4N mod 2^64 (its low word is zero).  The two agree in
 * all but their last 63 bits or so while R is within a dozen of the
 * root, so the difference mod 2^64 read as signed is the difference. */
static int m_sqrt_low(unsigned int hi, unsigned int lo, unsigned int n4h) {
    unsigned int sh;
    unsigned int sl;
    unsigned int ph;
    unsigned int p00;
    unsigned int p01;
    sh = (hi << 1) | (lo >> 31);         /* S = 2R + 1 */
    sl = (lo << 1) | 1u;
    /* S^2 mod 2^64 = sl^2 + 2 sh sl 2^32; of sl^2 only the high word
     * matters, in halves of 16 */
    p00 = (sl & 0xFFFFu) * (sl & 0xFFFFu);
    p01 = (sl & 0xFFFFu) * (sl >> 16);
    ph = (p00 >> 16) + 2u * (p01 & 0xFFFFu);
    ph = (sl >> 16) * (sl >> 16) + 2u * (p01 >> 16) + (ph >> 16);
    ph = ph + 2u * sh * sl;
    ph = ph - n4h;
    /* the sign bit by a logical shift: cc370 makes "(a - b) & 0x80000000"
     * a signed subtraction's condition code, wrong when it overflows */
    return (int)(ph >> 31);
}

/* x = F 16^e with F the 56-bit fraction; for e even the root's
 * fraction is R = sqrt(F 2^56) and its exponent e/2, for e odd
 * R = sqrt(F 2^52) and (e+1)/2 -- either way a 56-bit integer with a
 * nonzero leading hex digit, and the root of f = F 2^-56 or F 2^-60
 * is R 2^-56, in [1/16, 1).  Newton there, with the last step taken
 * as a correction, puts R within a few units; then whole numbers
 * settle it: the rounded root is the R with (2R-1)^2 < 4 F 2^k <
 * (2R+1)^2 (never equal, the middle being odd and the outside even).
 * FORTLIB's DSQRT is correctly rounded too. */
double f77m_sqrt(double x) __asm__("SQRT");
double f77m_sqrt(double x) {
    Hfp u;
    unsigned int hi;
    unsigned int lo;
    unsigned int n4h;
    int e;
    double f;
    double y;
    if (hfp_is_zero(x)) return 0.0;
    u.d = x;                             /* a negative argument is taken by its magnitude, as FORTLIB does after its message */
    e = (int)((u.w[0] >> 24) & 0x7F) - 64;
    hi = u.w[0] & 0x00FFFFFFu;
    lo = u.w[1];
    while ((hi >> 20) == 0) {            /* unnormalized: a hex digit at a time */
        hi = (hi << 4) | (lo >> 28);
        lo = lo << 4;
        e = e - 1;
    }
    if (e & 1) {
        e = e + 1;
        f = hfp_make(0x3F000000u | hi, lo);
        n4h = (lo & 0x3FFu) << 22;       /* 4 F 2^52 = F 2^54 */
    } else {
        f = hfp_make(0x40000000u | hi, lo);
        n4h = (lo & 0x3Fu) << 26;        /* F 2^58 */
    }
    y = m_sqrt_est(f, 3);                /* within 2^-47 */
    y = y + 0.5 * (f / y - y);
    u.d = y;
    hi = u.w[0] & 0x00FFFFFFu;
    lo = u.w[1];
    if ((u.w[0] >> 24) >= 0x41) { hi = 0x00FFFFFFu; lo = 0xFFFFFFFFu; }
    else while ((u.w[0] >> 24) < 0x40) { lo = (lo >> 4) | (hi << 28); hi = hi >> 4; u.w[0] = u.w[0] + 0x01000000u; }
    while (m_sqrt_low(hi, lo, n4h)) { lo = lo + 1; if (lo == 0) hi = hi + 1; }
    for (;;) {                           /* R - 1 when (2R - 1)^2 is over */
        unsigned int phi;
        unsigned int plo;
        phi = lo == 0 ? hi - 1 : hi;
        plo = lo - 1;
        if (m_sqrt_low(phi, plo, n4h)) break;
        hi = phi;
        lo = plo;
    }
    return hfp_make(((unsigned int)(64 + e / 2) << 24) | hi, lo);
}

/* --- exponential ------------------------------------------------ */
double f77m_exp(double x) __asm__("EXP");
double f77m_exp(double x) {
    double r;
    double p;
    double kd;
    int k;
    if (x > 174.6) return HFP_HUGE;
    if (x < -180.2) return 0.0;
    kd = x * c_rln2();
    k = (int)(kd < 0.0 ? kd - 0.5 : kd + 0.5);
    r = (x - (double)k * c_ln2_hi()) - (double)k * c_ln2_lo();   /* |r| <= ln2/2 */
    /* exp(r) by its series to r^13: the next term is below 1e-17 */
    p = 1.0 / 6227020800.0;
    p = p * r + 1.0 / 479001600.0;
    p = p * r + 1.0 / 39916800.0;
    p = p * r + 1.0 / 3628800.0;
    p = p * r + 1.0 / 362880.0;
    p = p * r + 1.0 / 40320.0;
    p = p * r + 1.0 / 5040.0;
    p = p * r + 1.0 / 720.0;
    p = p * r + 1.0 / 120.0;
    p = p * r + 1.0 / 24.0;
    p = p * r + 1.0 / 6.0;
    p = p * r + 0.5;
    p = p * r + 1.0;
    p = p * r + 1.0;
    return m_ldexp(p, k);
}

/* --- logarithms ------------------------------------------------- */
double f77m_log(double x) __asm__("LOG");
double f77m_log(double x) {
    double m;
    double u;
    double u2;
    double s;
    double t;
    int e;
    int n;
    if (x <= 0.0) return hfp_make(0xFFFFFFFFu, 0xFFFFFFFFu);   /* FORTLIB: a message, and the largest negative */
    m = m_frexp(x, &e);                  /* [0.5, 1) */
    if (m < c_sqrthalf()) { m = m * 2.0; e = e - 1; }   /* [0.7071, 1.4142) */
    u = (m - 1.0) / (m + 1.0);           /* |u| <= 0.1716 */
    u2 = u * u;
    /* log m = 2 (u + u^3/3 + u^5/5 + ...), to u^23 */
    s = 0.0;
    t = u;
    n = 1;
    while (n <= 23) { s = s + t / (double)n; t = t * u2; n = n + 2; }
    return (double)e * c_ln2() + 2.0 * s;
}

double f77m_log10(double x) __asm__("LOG10");
double f77m_log10(double x) { return f77m_log(x) * c_rln10(); }

/* --- sine and cosine -------------------------------------------- */

/* sin r and cos r for |r| <= pi/4, by their series to r^17 and r^18. */
static double m_sin_small(double r) {
    double r2;
    double p;
    r2 = r * r;
    p = -1.0 / 355687428096000.0;
    p = p * r2 + 1.0 / 1307674368000.0;
    p = p * r2 - 1.0 / 6227020800.0;
    p = p * r2 + 1.0 / 39916800.0;
    p = p * r2 - 1.0 / 362880.0;
    p = p * r2 + 1.0 / 5040.0;
    p = p * r2 - 1.0 / 120.0;
    p = p * r2 + 1.0 / 6.0;
    return r - r * r2 * p;
}
static double m_cos_small(double r) {
    double r2;
    double p;
    r2 = r * r;
    p = 1.0 / 6402373705728000.0;
    p = p * r2 - 1.0 / 20922789888000.0;
    p = p * r2 + 1.0 / 87178291200.0;
    p = p * r2 - 1.0 / 479001600.0;
    p = p * r2 + 1.0 / 3628800.0;
    p = p * r2 - 1.0 / 40320.0;
    p = p * r2 + 1.0 / 720.0;
    p = p * r2 - 1.0 / 24.0;
    p = p * r2 + 0.5;
    return 1.0 - r2 * p;
}

/* 2/pi to 392 bits, fourteen at a time, the leading bits first. */
static const unsigned int m_2opi[28] = {
    0x28BE, 0x1836, 0x3939, 0x0415, 0x0A7F, 0x0275, 0x1F47, 0x3534, 0x3770,
    0x0DB6, 0x0A56, 0x193C, 0x10E4, 0x041F, 0x3945, 0x23AB, 0x37AE, 0x3C56,
    0x06DC, 0x246E, 0x0E90, 0x24DD, 0x0B80, 0x0649, 0x0BBA, 0x209D, 0x0648,
    0x1CFE
};

/* the 14 bits of 2/pi from bit p on (the first bit after the point is 1) */
static unsigned int m_2opi_bits(int p) {
    int c;
    int o;
    c = (p - 1) / LB;
    o = (p - 1) % LB;
    if (o == 0) return m_2opi[c];
    return ((m_2opi[c] << o) | (m_2opi[c + 1] >> (LB - o))) & LM;
}

/* pi/2 times 2^68, its 69 bits fourteen at a time, the low ones first */
static const unsigned int m_pio2_68[5] = { 0x0698, 0x3461, 0x0442, 0x3ED5, 0x1921 };

/* bit i of a */
static int bn_bit(unsigned int *a, int i) { return (int)((a[i / LB] >> (i % LB)) & 1u); }

/* a[0..n) times 2^t, truncated to HFP long: the hex exponent puts the
 * leading one in the first digit, and the 56 bits from there are read
 * off.  Nonzero a, and a result in range. */
static double m_from_bits(unsigned int *a, int n, int t) {
    int l;
    int e;
    int b;
    int i;
    unsigned int hi;
    unsigned int lo;
    l = n * LB - 1;
    while (l > 0 && !bn_bit(a, l)) l = l - 1;
    e = l + t >= 0 ? (l + t) / 4 + 1 : -((-(l + t) + 3) / 4) + 1;   /* 16^(e-1) <= a 2^t < 16^e */
    b = 4 * e - 56 - t;                  /* a's bit for the fraction's last */
    hi = 0;
    lo = 0;
    for (i = 55; i >= 0; i--) {
        int v;
        v = b + i >= 0 && b + i < n * LB ? bn_bit(a, b + i) : 0;
        if (i >= 32) hi = hi | ((unsigned int)v << (i - 32)); else lo = lo | ((unsigned int)v << i);
    }
    return hfp_make(((unsigned int)(64 + e) << 24) | hi, lo);
}

/* The reduction for x >= 2^20, where k pi/2 is no longer exact in
 * three parts (Payne and Hanek): x = F 2^s with F the 56-bit fraction,
 * and x 2/pi mod 4 is F times the bits of 2/pi from 2^(1-s) on, the
 * ones before making a multiple of four; 140 of them leave 80 bits and
 * more of the fraction below the nearest quadrant, which an argument
 * of 56 bits comes no nearer to than 2^-62 or so. */
#define PH_W 10                          /* limbs of 2/pi: 140 bits */
static double m_reduce_big(double x, int *quad) {
    Hfp u;
    unsigned int f[4];
    unsigned int w[PH_W];
    unsigned int p[4 + PH_W];
    int s;
    int a;
    int pb;
    int top;
    int i;
    int j;
    int neg;
    unsigned int g[5];
    unsigned int q[10];
    double r;
    u.d = x;
    s = 4 * ((int)((u.w[0] >> 24) & 0x7F) - 64) - 56;
    bn_set(f, 4, u.w[0] & 0x00FFFFFFu, u.w[1], 0);
    a = s - 1 > 1 ? s - 1 : 1;
    for (j = 0; j < PH_W; j++) w[PH_W - 1 - j] = m_2opi_bits(a + LB * j);
    bn_mul(p, f, 4, w, PH_W);
    pb = a + LB * PH_W - 1 - s;          /* the binary point: P / 2^pb */
    *quad = bn_bit(p, pb) + 2 * bn_bit(p, pb + 1);
    neg = bn_bit(p, pb - 1);
    if (neg) {                           /* past the half: 1 - fraction, from the next quadrant */
        unsigned int c;
        c = 1;
        for (i = 0; i < 4 + PH_W; i++) { p[i] = ((~p[i]) & LM) + c; c = p[i] >> LB; p[i] = p[i] & LM; }
        *quad = (*quad + 1) & 3;
    }
    /* r = the fraction times pi/2, in whole numbers: 70 bits of the
     * fraction from its leading one, times 69 of pi/2 */
    top = pb - 1;
    while (top > 0 && !bn_bit(p, top)) top = top - 1;
    for (i = 0; i < 5; i++) g[i] = 0;
    for (i = 0; i < 70 && top - i >= 0; i++)
        if (bn_bit(p, top - i)) g[(69 - i) / LB] = g[(69 - i) / LB] | (1u << ((69 - i) % LB));
    bn_mul(q, g, 5, (unsigned int *)m_pio2_68, 5);
    r = m_from_bits(q, 10, top - 69 - pb - 68);
    return neg ? -r : r;
}

/* x = k pi/2 + r, |r| <= pi/4: returns r, *quad = k mod 4.  The
 * three-part pi/2 keeps k * pi/2 exact for |k| below 2^20 (the parts
 * are 36, 36 and 56 bits; tests/s370/math.sh derives them). */
static double m_reduce(double x, int *quad) {
    double kd;
    double k;
    double r;
    int ki;
    if (m_fabs(x) >= 1048576.0) {
        r = m_reduce_big(m_fabs(x), &ki);
        if (x < 0.0) { r = -r; ki = -ki; }
        *quad = ki & 3;
        return r;
    }
    kd = x / c_pio2();
    k = (double)(long)(kd < 0.0 ? kd - 0.5 : kd + 0.5);
    r = ((x - k * c_pio2_1()) - k * c_pio2_2()) - k * c_pio2_3();
    ki = (int)k;
    *quad = ki & 3;
    return r;
}

double f77m_sin(double x) __asm__("SIN");
double f77m_sin(double x) {
    int q;
    double r;
    r = m_reduce(x, &q);
    if (q == 0) return m_sin_small(r);
    if (q == 1) return m_cos_small(r);
    if (q == 2) return -m_sin_small(r);
    return -m_cos_small(r);
}

double f77m_cos(double x) __asm__("COS");
double f77m_cos(double x) {
    int q;
    double r;
    r = m_reduce(x, &q);
    if (q == 0) return m_cos_small(r);
    if (q == 1) return -m_sin_small(r);
    if (q == 2) return -m_cos_small(r);
    return m_sin_small(r);
}

double f77m_tan(double x) __asm__("TAN");
double f77m_tan(double x) {
    int q;
    double r;
    double s;
    double c;
    r = m_reduce(x, &q);
    s = m_sin_small(r);
    c = m_cos_small(r);
    if (q & 1) { double t; t = s; s = c; c = -t; }
    if (hfp_is_zero(c)) return HFP_HUGE;
    return s / c;
}

/* --- arc tangent ------------------------------------------------ */

/* atan t for 0 <= t <= 1: halved twice (t <= tan pi/16 = 0.199), then
 * the series to t^25, then doubled twice. */
static double m_atan_unit(double t) {
    double t2;
    double s;
    double p;
    int n;
    t = t / (1.0 + m_sqrt_est(1.0 + t * t, 5));   /* the estimate does here, and is quicker */
    t = t / (1.0 + m_sqrt_est(1.0 + t * t, 5));
    t2 = t * t;
    s = 0.0;
    p = t;
    n = 1;
    while (n <= 25) {
        if ((n / 2) & 1) s = s - p / (double)n; else s = s + p / (double)n;
        p = p * t2;
        n = n + 2;
    }
    return 4.0 * s;
}

double f77m_atan(double x) __asm__("ATAN");
double f77m_atan(double x) {
    double a;
    double r;
    a = m_fabs(x);
    if (a > 1.0) r = c_pio2() - m_atan_unit(1.0 / a);
    else r = m_atan_unit(a);
    return x < 0.0 ? -r : r;
}

double f77m_atan2(double y, double x) __asm__("ATAN2");
double f77m_atan2(double y, double x) {
    double ax;
    double ay;
    double r;
    if (hfp_is_zero(x)) {
        if (hfp_is_zero(y)) return 0.0;
        return y < 0.0 ? -c_pio2() : c_pio2();
    }
    /* the smaller over the larger: y / x could overflow */
    ax = m_fabs(x);
    ay = m_fabs(y);
    if (ay <= ax) r = f77m_atan(ay / ax);
    else r = c_pio2() - f77m_atan(ax / ay);
    if (x < 0.0) r = c_pi() - r;
    return y < 0.0 ? -r : r;
}

double f77m_asin(double x) __asm__("ASIN");
double f77m_asin(double x) {
    double c;
    if (x >= 1.0) return c_pio2();
    if (x <= -1.0) return -c_pio2();
    c = f77m_sqrt((1.0 - x) * (1.0 + x));
    return f77m_atan2(x, c);
}

double f77m_acos(double x) __asm__("ACOS");
double f77m_acos(double x) {
    double s;
    if (x >= 1.0) return 0.0;
    if (x <= -1.0) return c_pi();
    s = f77m_sqrt((1.0 - x) * (1.0 + x));
    return f77m_atan2(s, x);
}

/* --- hyperbolics ------------------------------------------------ */
double f77m_sinh(double x) __asm__("SINH");
double f77m_sinh(double x) {
    double a;
    a = m_fabs(x);
    if (a < 1.0) {
        /* the series, to x^17: the difference of exponentials would
         * lose its leading digits here */
        double x2;
        double p;
        x2 = x * x;
        p = 1.0 / 355687428096000.0;
        p = p * x2 + 1.0 / 1307674368000.0;
        p = p * x2 + 1.0 / 6227020800.0;
        p = p * x2 + 1.0 / 39916800.0;
        p = p * x2 + 1.0 / 362880.0;
        p = p * x2 + 1.0 / 5040.0;
        p = p * x2 + 1.0 / 120.0;
        p = p * x2 + 1.0 / 6.0;
        return x + x * x2 * p;
    }
    if (a > 174.0) return x < 0.0 ? -HFP_HUGE : HFP_HUGE;
    {
        double e;
        e = f77m_exp(a);
        e = 0.5 * (e - 1.0 / e);
        return x < 0.0 ? -e : e;
    }
}

double f77m_cosh(double x) __asm__("COSH");
double f77m_cosh(double x) {
    double e;
    x = m_fabs(x);
    if (x > 174.0) return HFP_HUGE;
    e = f77m_exp(x);
    return 0.5 * (e + 1.0 / e);
}

double f77m_tanh(double x) __asm__("TANH");
double f77m_tanh(double x) {
    double a;
    double e;
    a = m_fabs(x);
    if (a > 22.0) return x < 0.0 ? -1.0 : 1.0;
    if (a < 1.0) return f77m_sinh(x) / f77m_cosh(x);
    e = f77m_exp(2.0 * a);
    e = (e - 1.0) / (e + 1.0);
    return x < 0.0 ? -e : e;
}

/* --- powers ----------------------------------------------------- */
double f77m_pow(double x, double y) __asm__("POW");
double f77m_pow(double x, double y) {
    double r;
    double l;
    int neg;
    if (hfp_is_zero(y)) return 1.0;
    if (hfp_is_zero(x)) return 0.0;
    neg = 0;
    if (x < 0.0) {
        /* a negative base needs an integral exponent; the result's
         * sign is that of (-1)^y.  Read from the bits: y = F 2^(4e-56),
         * integral when the fraction's bits below 2^0 are zero, odd
         * when the one at 2^0 is set; from 2^56 on, always even. */
        Hfp u;
        int b;
        u.d = y;
        b = 56 - 4 * ((int)((u.w[0] >> 24) & 0x7F) - 64);   /* bits below the point */
        if (b > 56) return 0.0;          /* |y| < 1 */
        if (b > 0) {
            unsigned int mhi;
            unsigned int mlo;
            int i;
            mhi = 0;
            mlo = 0;
            for (i = 0; i < b; i++) { if (i < 32) mlo = mlo | (1u << i); else mhi = mhi | (1u << (i - 32)); }
            if ((u.w[1] & mlo) != 0 || (u.w[0] & 0x00FFFFFFu & mhi) != 0) return 0.0;
            neg = b < 32 ? (int)((u.w[1] >> b) & 1u) : (int)((u.w[0] >> (b - 32)) & 1u);
        }
        x = -x;
    }
    /* y log x past the exponential's range would overflow the product */
    l = f77m_log(x);
    if (m_fabs(y) > 1.0 && m_fabs(l) > 200.0 / m_fabs(y))
        r = (y < 0.0) == (l < 0.0) ? HFP_HUGE : 0.0;
    else r = f77m_exp(y * l);
    return neg ? -r : r;
}
