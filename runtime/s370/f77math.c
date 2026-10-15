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
 * Accuracy is a few units in the last place at worst, in the range of
 * the arguments the FCVS and the kernels use.  A REAL result is the
 * long one cut to short, and so the exact value truncated: for SQRT,
 * EXP, ALOG, ALOG10, SIN, COS, ATAN and TANH over 300 arguments each,
 * every time (2026-10-15, on TK5).  FORTLIB's short routines round SQRT
 * and EXP and approximate the rest their own way, up to five units from
 * these (docs/INSTALL-MVS.txt); the long ones are not yet compared. */

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

/* --- square root: Newton on the binary mantissa ----------------- */
double f77m_sqrt(double x) __asm__("SQRT");
double f77m_sqrt(double x) {
    double m;
    double y;
    int e;
    int i;
    if (hfp_is_zero(x)) return 0.0;
    x = m_fabs(x);                       /* a negative argument is taken by its magnitude, as FORTLIB does after its message */
    m = m_frexp(x, &e);                  /* [0.5, 1) */
    if (e & 1) { m = m * 2.0; e = e - 1; }   /* [0.5, 2) with an even exponent */
    y = 0.41731 + 0.59016 * m;           /* within 3% */
    for (i = 0; i < 5; i++) y = 0.5 * (y + m / y);
    return m_ldexp(y, e / 2);
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

/* x = k pi/2 + r, |r| <= pi/4: returns r, *quad = k mod 4.  The
 * three-part pi/2 keeps k * pi/2 exact for |k| below 2^20 (the parts
 * are 36, 36 and 56 bits; tests/s370/math.sh derives them). */
static double m_reduce(double x, int *quad) {
    double kd;
    double k;
    double r;
    int ki;
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
    t = t / (1.0 + f77m_sqrt(1.0 + t * t));
    t = t / (1.0 + f77m_sqrt(1.0 + t * t));
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
    double r;
    if (hfp_is_zero(x)) {
        if (hfp_is_zero(y)) return 0.0;
        return y < 0.0 ? -c_pio2() : c_pio2();
    }
    r = f77m_atan(y / x);
    if (x < 0.0) r = y < 0.0 ? r - c_pi() : r + c_pi();
    return r;
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
    int neg;
    if (hfp_is_zero(y)) return 1.0;
    if (hfp_is_zero(x)) return 0.0;
    neg = 0;
    if (x < 0.0) {
        /* a negative base needs an integral exponent; the result's
         * sign is that of (-1)^y */
        double yi;
        yi = (double)(long)y;
        if (yi != y) return 0.0;
        x = -x;
        neg = ((long)y) & 1;
    }
    r = f77m_exp(y * f77m_log(x));
    return neg ? -r : r;
}
