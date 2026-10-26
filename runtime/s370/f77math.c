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
 * These are the cores, under the runtime's own names (M@SQRT, ...),
 * which say nothing of an argument out of their domain: the runtime's
 * calls through <math.h> come here (f77m.h).  A program's calls go to
 * the entries in f77mlr.c and f77mld.c, SQRT and DSQRT and the rest,
 * which check the argument as FORTLIB does first (f77mchk.c).  A REAL
 * argument arrives widened to double.
 *
 * A REAL result is the long one cut to short, and so within a unit and
 * nearly always the exact value truncated.  The long results, against
 * the exact values (2026-10-15, on TK5; the figures are in
 * docs/INSTALL-MVS.txt): SQRT correctly rounded, as FORTLIB's is;
 * EXP, LOG, LOG10, ATAN, ATAN2, ASIN, ACOS, SINH, COSH, TANH, TAN and
 * POW within 0.7 of a unit, most correctly rounded -- their last step
 * a sum rounded once, in extended precision (see "sums rounded
 * once"); SIN and COS within 2 units at any argument, where FORTLIB's
 * are off by thousands.  The figures came from a model of the
 * machine's arithmetic that agreed with TK5 to the bit on 8,029
 * results. */

#include "f77msum.h"

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
    /* unnormalized: a hex digit at a time, as whole numbers.  This was
     * a call again with u.d * 1.0, which cc370 folds to u.d: it called
     * itself until the stack ran out. */
    while (top == 0) {
        u.w[0] = (u.w[0] & 0xFF000000u) | ((u.w[0] << 4) & 0x00FFFFFFu) | (u.w[1] >> 28);
        u.w[1] = u.w[1] << 4;
        *e = *e - 4;
        top = (u.w[0] >> 20) & 0xFu;
    }
    if (top >= 8) return u.d;
    if (top >= 4) { *e = *e - 1; return u.d * 2.0; }
    if (top >= 2) { *e = *e - 2; return u.d * 4.0; }
    *e = *e - 3;
    return u.d * 8.0;
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

static const Hw k_huge = {{0x7FFFFFFFu, 0xFFFFFFFFu}};
#define HFP_HUGE  (k_huge.d)   /* 16^63 (1 - 16^-14) */

static const Hw k_ln2_hi = {{0x40B17217u, 0xF7D00000u}};   /* its first 36 bits */
#define c_ln2_hi() (k_ln2_hi.d)
static const Hw k_ln2_lo = {{0x371CF79Au, 0xBC9E3B39u}};   /* the rest */
#define c_ln2_lo() (k_ln2_lo.d)
static const Hw k_rln2 = {{0x41171547u, 0x652B82FEu}};   /* 1 / ln 2 */
#define c_rln2() (k_rln2.d)
static const Hw k_rln10 = {{0x406F2DECu, 0x549B9438u}};   /* 1 / ln 10 */
#define c_rln10() (k_rln10.d)
static const Hw k_pio2 = {{0x411921FBu, 0x54442D18u}};   /* pi / 2 */
#define c_pio2() (k_pio2.d)
static const Hw k_pio2_1 = {{0x411921FBu, 0x54440000u}};   /* its first 36 bits */
#define c_pio2_1() (k_pio2_1.d)
static const Hw k_pio2_2 = {{0x372D1846u, 0x98980000u}};   /* the next 36 */
#define c_pio2_2() (k_pio2_2.d)
static const Hw k_pio2_3 = {{0x2DCC5170u, 0x1B839A25u}};   /* the rest */
#define c_pio2_3() (k_pio2_3.d)
static const Hw k_pi = {{0x413243F6u, 0xA8885A30u}};
#define c_pi() (k_pi.d)

static const Hw k_negbig = {{0xFFFFFFFFu, 0xFFFFFFFFu}};      /* the largest negative */
static const Hw k_ln2_hi_half = {{0x4058B90Bu, 0xFBE80000u}}; /* c_ln2_hi / 2, exact */
static const Hw k_rln10_lo = {{0x32CA9AADu, 0xD557D69Au}};    /* 1/ln 10 less c_rln10 */

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
double f77m_sqrt(double x) __asm__("M@SQRT");
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

/* exp(x 2^sc + xl) = 2^k exp(r), sc 0 or 1, k the nearest whole
 * number to the argument over ln 2: its terms into t, plain (the
 * caller frames them by k), and k returned.  r's leading part h is x
 * less k times the first 36 bits of ln 2 (halved when sc is 1),
 * exact; then exp(r) = 1 + r + r^2/2 + r^3 (1/6 + r/24 + ...), r^2/2
 * exact as h h, the series to r^13 needing only a few digits. */
static int m_exp_terms(Sum *t, double x, int sc, double xl) {
    double kd;
    double h;
    double rl;
    double r;
    double p;
    int k;
    kd = x * c_rln2();
    if (sc) kd = kd + kd;
    k = (int)(kd < 0.0 ? kd - 0.5 : kd + 0.5);
    h = x - (double)k * (sc ? k_ln2_hi_half.d : c_ln2_hi());
    rl = xl - (double)k * c_ln2_lo();
    r = (sc ? h + h : h) + rl;
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
    SUM_ADD(t, 1.0, 0);
    SUM_ADD(t, h, sc);
    SUM_ADD(t, rl * (1.0 + r), 0);
    SUM_MUL(t, h, h, 2 * sc - 1);
    SUM_ADD(t, ((r * r) * r) * p, 0);
    return k;
}

double f77m_exp(double x) __asm__("M@EXP");
double f77m_exp(double x) {
    Sum t;
    /* up to ln of the largest number, 174.67309; past it the frame's
     * 16^q takes the result to the largest number (m_hex) */
    if (x > 175.0) return HFP_HUGE;
    if (x < -180.2) return 0.0;
    t.n = 0;
    t.q = 0;
    sum_frame(&t, m_exp_terms(&t, x, 0, 0.0));
    return sum_round(&t, 0);
}

/* --- logarithms ------------------------------------------------- */

/* -log(k/64), k = 64..128: a part in whole multiples of 2^-36, so that
 * e ln2_hi + it is exact, and the rest; k = 128 is -ln 2 in the same
 * two parts as ln 2 itself, so that log(1 + tiny) cancels exactly. */
static const Hw m_logt[65][2] = {
    { {{0x00000000u, 0x00000000u}}, {{0x00000000u, 0x00000000u}} },
    { {{0xBF3F8151u, 0x61000000u}}, {{0xB7F807C7u, 0x9F3DB4EAu}} },
    { {{0xBF7E0A6Cu, 0x39000000u}}, {{0xB7E0CC01u, 0x33E3F04Fu}} },
    { {{0xBFBBA2C7u, 0xB1000000u}}, {{0xB796E7E2u, 0x31A7950Fu}} },
    { {{0xBFF85186u, 0x00000000u}}, {{0xB78B1533u, 0x0BE64B8Bu}} },
    { {{0xC01341D7u, 0x96100000u}}, {{0xB7BD1D09u, 0x29983761u}} },
    { {{0xC016F0D2u, 0x8AE00000u}}, {{0xB756B4B9u, 0xBE499B9Fu}} },
    { {{0xC01A926Du, 0x3A400000u}}, {{0xB7AD5636u, 0x50BD22AAu}} },
    { {{0xC01E2707u, 0x6E200000u}}, {{0xB7AF2E5Eu, 0x9EA87FFEu}} },
    { {{0xC021AEFCu, 0xF9A00000u}}, {{0xB711CB2Cu, 0xD2EE2F48u}} },
    { {{0xC0252AA5u, 0xF0300000u}}, {{0xB7FEA469u, 0x80BB8E20u}} },
    { {{0xC0289A56u, 0xD9900000u}}, {{0xB76FA3CCu, 0xFA7B2A1Fu}} },
    { {{0xC02BFE60u, 0xE1400000u}}, {{0xB7F27A79u, 0x0E7C4141u}} },
    { {{0xC02F5712u, 0x04200000u}}, {{0xB71B2123u, 0x7C6D65ADu}} },
    { {{0xC032A4B5u, 0x39E00000u}}, {{0xB78AD68Eu, 0xC8260EA7u}} },
    { {{0xC035E792u, 0x9D000000u}}, {{0xB717FE5Bu, 0x19CC0327u}} },
    { {{0xC0391FEFu, 0x8F300000u}}, {{0xB7534435u, 0x84BB03DEu}} },
    { {{0xC03C4E0Eu, 0xDC500000u}}, {{0xB75E5CBDu, 0x3D50FFFCu}} },
    { {{0xC03F7230u, 0xDAB00000u}}, {{0xB7C7C551u, 0xAAA8CD87u}} },
    { {{0xC0428C93u, 0x89C00000u}}, {{0xB7E438D7u, 0xDCFDE806u}} },
    { {{0xC0459D72u, 0xAEA00000u}}, {{0xB7E98380u, 0xE731F55Cu}} },
    { {{0xC048A507u, 0xEF300000u}}, {{0xB7DE5968u, 0x90A14F6Au}} },
    { {{0xC04BA38Au, 0xEB800000u}}, {{0xB7474C27u, 0x0B3246A1u}} },
    { {{0xC04E9931u, 0x55A00000u}}, {{0xB7517A71u, 0xCBCD735Du}} },
    { {{0xC051862Fu, 0x08700000u}}, {{0xB717B09Fu, 0x42DECDEDu}} },
    { {{0xC0546AB6u, 0x1CB00000u}}, {{0xB77E0B42u, 0x724F5834u}} },
    { {{0xC05746F6u, 0xFD600000u}}, {{0xB6272942u, 0x36383DC8u}} },
    { {{0xC05A1B20u, 0x7A600000u}}, {{0xB7C52BB1u, 0x10AF8405u}} },
    { {{0xC05CE75Fu, 0xDAE00000u}}, {{0xB7F401A7u, 0x389314FFu}} },
    { {{0xC05FABE0u, 0xEE000000u}}, {{0xB7ABF0D9u, 0x2CE979EDu}} },
    { {{0xC06268CEu, 0x1B000000u}}, {{0xB75096ADu, 0x69C62044u}} },
    { {{0xC0651E50u, 0x70800000u}}, {{0xB745BEAEu, 0x9337451Fu}} },
    { {{0xC067CC8Fu, 0xB2F00000u}}, {{0xB7E612FCu, 0xADA35D9Cu}} },
    { {{0xC06A73B2u, 0x6A600000u}}, {{0xB7821263u, 0x5213FD4Cu}} },
    { {{0xC06D13DDu, 0xEF300000u}}, {{0xB723D8A3u, 0x2FBB6ABAu}} },
    { {{0xC06FAD36u, 0x76900000u}}, {{0xB7C6DEFDu, 0xE1874DEBu}} },
    { {{0xC0723FDFu, 0x1E600000u}}, {{0xB7A6886Bu, 0x097607BDu}} },
    { {{0xC074CBF9u, 0xF8000000u}}, {{0xB73AF558u, 0x77B232FBu}} },
    { {{0xC07751A8u, 0x13000000u}}, {{0xB771282Fu, 0xB989A927u}} },
    { {{0xC079D109u, 0x87500000u}}, {{0xB7A1E1F8u, 0xDF68DBCFu}} },
    { {{0xC07C4A3Du, 0x7EB00000u}}, {{0xB7C1BB2Cu, 0xD720EC45u}} },
    { {{0xC07EBD62u, 0x3DE00000u}}, {{0xB73CC7B6u, 0x6BECF93Bu}} },
    { {{0xC0812A95u, 0x2D200000u}}, {{0xB7E87F63u, 0x4E34AEBFu}} },
    { {{0xC08391F2u, 0xE0E00000u}}, {{0xB76FA027u, 0x2BCB1C49u}} },
    { {{0xC085F397u, 0x21200000u}}, {{0xB795415Bu, 0x4C4BDD9Au}} },
    { {{0xC0884F9Cu, 0xF1600000u}}, {{0xB7A64B7Eu, 0xF1F64D86u}} },
    { {{0xC08AA61Eu, 0x97A00000u}}, {{0xB76AF4D4u, 0xC799D1CBu}} },
    { {{0xC08CF735u, 0xA3300000u}}, {{0xB7E4B766u, 0x2E5EEBBCu}} },
    { {{0xC08F42FAu, 0xF3800000u}}, {{0xB720681Eu, 0xF62CD2FAu}} },
    { {{0xC0918986u, 0xBDF00000u}}, {{0xB75FA141u, 0x6F1B4391u}} },
    { {{0xC093CAF0u, 0x94400000u}}, {{0xB7D88D75u, 0xBC1F9EDDu}} },
    { {{0xC096074Fu, 0x6A200000u}}, {{0xB74745DCu, 0xBD4E18DDu}} },
    { {{0xC0983EB9u, 0x9A700000u}}, {{0xB7885F0Fu, 0xDAC850FBu}} },
    { {{0xC09A7144u, 0xECE00000u}}, {{0xB770E98Bu, 0x75C96C43u}} },
    { {{0xC09C9F06u, 0x9AB00000u}}, {{0xB7150CD4u, 0xE221301Bu}} },
    { {{0xC09EC813u, 0x53800000u}}, {{0xB7AB7D52u, 0x02131E85u}} },
    { {{0xC0A0EC7Fu, 0x42300000u}}, {{0xB7395732u, 0x325E617Au}} },
    { {{0xC0A30C5Eu, 0x10E00000u}}, {{0xB72F613Eu, 0x85BD9BDAu}} },
    { {{0xC0A527C2u, 0xED800000u}}, {{0xB71F5D81u, 0x13DFA3D3u}} },
    { {{0xC0A73EC0u, 0x8DB00000u}}, {{0xB7ADD84Eu, 0x584C2B23u}} },
    { {{0xC0A95169u, 0x32D00000u}}, {{0xB7E2D577u, 0x3BE4578Bu}} },
    { {{0xC0AB5FCEu, 0xAD900000u}}, {{0xB7F9CCA0u, 0x8E310B9Bu}} },
    { {{0xC0AD6A02u, 0x61A00000u}}, {{0xB7CF967Du, 0x94D552F8u}} },
    { {{0xC0AF7015u, 0x49200000u}}, {{0xB6B3AB86u, 0xB04AFE92u}} },
    { {{0xC0B17217u, 0xF7D00000u}}, {{0xB71CF79Au, 0xBC9E3B39u}} }
};

/* atan(k/8), k = 0..8, in two parts */
static const Hw m_atant[9][2] = {
    { {{0x00000000u, 0x00000000u}}, {{0x00000000u, 0x00000000u}} },
    { {{0x401FD5BAu, 0x9AAC2F6Du}}, {{0x32C65912u, 0xF313E7D1u}} },
    { {{0x403EB6EBu, 0xF25901BAu}}, {{0x32C55B71u, 0xE7BD7DE9u}} },
    { {{0x405BD865u, 0x07937BC2u}}, {{0x3239C551u, 0x90916E7Fu}} },
    { {{0x4076B19Cu, 0x1586ED3Du}}, {{0x32A2B7F2u, 0x22F65E1Du}} },
    { {{0x408F005Du, 0x5EF7F59Fu}}, {{0x329B5C83u, 0x5E1665C4u}} },
    { {{0x40A4BC7Du, 0x1934F709u}}, {{0x322419A8u, 0x7F2A457Eu}} },
    { {{0x40B8053Eu, 0x2BC2319Eu}}, {{0x3273CB2Du, 0xA55210A4u}} },
    { {{0x40C90FDAu, 0xA22168C2u}}, {{0x3234C4C6u, 0x628B80DCu}} }
};

/* log x = e ln 2 - log(k/64) + log(1 + f), x = m 2^e with m in
 * [0.5, 1), k the nearest whole number to 64/m and f = m k/64 - 1,
 * under 1/128: exact in two parts, m being split into its first
 * seven hex digits and the rest.  e ln2_hi and the table's first part
 * add exactly; log(1 + f) = f - f^2/2 + f^3 (1/3 - f/4 + ...), the
 * series to f^11. */
static void m_log_terms(Sum *t, double x) {
    Hfp u;
    double m;
    double inv;
    double mh;
    double fh;
    double fl;
    double f;
    double p;
    int e;
    int k;
    m = m_frexp(x, &e);
    k = (int)(64.0 / m + 0.5);
    inv = (double)k * 0.015625;
    u.d = m;
    u.w[1] = u.w[1] & 0xF0000000u;
    mh = u.d;
    fh = mh * inv - 1.0;
    fl = (m - mh) * inv;
    f = fh + fl;
    p = 1.0 / 11.0;
    p = p * f - 1.0 / 10.0;
    p = p * f + 1.0 / 9.0;
    p = p * f - 1.0 / 8.0;
    p = p * f + 1.0 / 7.0;
    p = p * f - 1.0 / 6.0;
    p = p * f + 1.0 / 5.0;
    p = p * f - 1.0 / 4.0;
    p = p * f + 1.0 / 3.0;
    SUM_ADD(t, (double)e * c_ln2_hi() + m_logt[k - 64][0].d, 0);
    SUM_ADD(t, (double)e * c_ln2_lo() + m_logt[k - 64][1].d, 0);
    SUM_ADD(t, fh, 0);
    SUM_ADD(t, fl, 0);
    SUM_MUL(t, -fh, fh, -1);
    SUM_MUL(t, -fh, fl, 0);
    SUM_MUL(t, -fl, fl, -1);
    SUM_ADD(t, ((f * f) * f) * p, 0);
}

double f77m_log(double x) __asm__("M@LOG");
double f77m_log(double x) {
    Sum t;
    if (x <= 0.0) return k_negbig.d;   /* FORTLIB: a message, and the largest negative */
    t.n = 0;
    t.q = 0;
    m_log_terms(&t, x);
    return sum_round(&t, 0);
}

/* log x in two parts, times 1/ln 10 in two */
double f77m_log10(double x) __asm__("M@LOG10");
double f77m_log10(double x) {
    Sum t;
    double r;
    double res;
    if (x <= 0.0) return f77m_log(x) * c_rln10();   /* as before */
    t.n = 0;
    t.q = 0;
    m_log_terms(&t, x);
    r = sum_round(&t, &res);
    t.n = 0;
    SUM_MUL(&t, r, c_rln10(), 0);
    SUM_MUL(&t, r, k_rln10_lo.d, 0);
    SUM_MUL(&t, res, c_rln10(), 0);
    return sum_round(&t, 0);
}

/* --- sine and cosine -------------------------------------------- */

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
/* a[] with the bits m_from_bits(a, n, t) reads, and those above, cleared */
static void m_drop_top(unsigned int *a, int n, int t) {
    int l;
    int e;
    int b;
    int i;
    l = n * LB - 1;
    while (l > 0 && !bn_bit(a, l)) l = l - 1;
    e = l + t >= 0 ? (l + t) / 4 + 1 : -((-(l + t) + 3) / 4) + 1;
    b = 4 * e - 56 - t;
    for (i = b > 0 ? b : 0; i < n * LB; i++) a[i / LB] = a[i / LB] & ~(1u << (i % LB));
}

#define PH_W 10                          /* limbs of 2/pi: 140 bits */
static double m_reduce_big(double x, int *quad, double *lo) {
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
    /* and the next bits, the fraction's 70 good for a dozen more */
    m_drop_top(q, 10, top - 69 - pb - 68);
    for (i = 0; i < 10 && q[i] == 0; i++) ;
    *lo = i < 10 ? m_from_bits(q, 10, top - 69 - pb - 68) : 0.0;
    if (neg) *lo = -*lo;
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
        double lo;
        r = m_reduce_big(m_fabs(x), &ki, &lo);
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

/* sin(j/16) and cos(j/16), j = 0..13, each in two parts */
static const Hw m_sincost[14][4] = {
    { {{0x00000000u, 0x00000000u}}, {{0x00000000u, 0x00000000u}}, {{0x41100000u, 0x00000000u}}, {{0x00000000u, 0x00000000u}} },
    { {{0x3FFFD557u, 0x776A76D5u}}, {{0x31A5D259u, 0xB2F692D5u}}, {{0x40FF800Au, 0xAA4FA69Au}}, {{0x3265070Fu, 0x73284DE2u}} },
    { {{0x401FEAAEu, 0xEE86EE35u}}, {{0x32CA069Au, 0x86721F8Au}}, {{0x40FE00AAu, 0x93EADE9Bu}}, {{0x326D1E6Au, 0x129DF6F2u}} },
    { {{0x402FB820u, 0x5F75E56Au}}, {{0x322B56A1u, 0xC4792F85u}}, {{0x40FB835Eu, 0xFCF670DDu}}, {{0x322CE6FEu, 0x7924697Fu}} },
    { {{0x403F55DDu, 0xA9E62AEDu}}, {{0x327513BDu, 0x7B8E6A3Du}}, {{0x40F80AA4u, 0xFBEF750Bu}}, {{0x32A783D3u, 0x3CB95F95u}} },
    { {{0x404EB44Au, 0x5DA74F60u}}, {{0x31207AAAu, 0x090F0735u}}, {{0x40F399F5u, 0x00C9E9FDu}}, {{0x3237AE99u, 0x57263DACu}} },
    { {{0x405DC409u, 0x55D9084Fu}}, {{0x3248A946u, 0x75A2498Eu}}, {{0x40EE35BFu, 0x5CCAC890u}}, {{0x3252CD91u, 0xDDB734D4u}} },
    { {{0x406C760Cu, 0x14C8585Au}}, {{0x3251DBD3u, 0x4660AE6Cu}}, {{0x40E7E367u, 0xD2956CFBu}}, {{0x3216B6AAu, 0x11E5419Du}} },
    { {{0x407ABBA1u, 0xD12C17BFu}}, {{0x32A1D92Fu, 0x0D93F60Eu}}, {{0x40E0A940u, 0x32DBEA7Cu}}, {{0x32EDBDDDu, 0x9DA2FAFBu}} },
    { {{0x40888686u, 0x25B4E1DBu}}, {{0x32B23133u, 0x10133022u}}, {{0x40D88E82u, 0x0B152631u}}, {{0x321DD561u, 0xEFBC0C1Bu}} },
    { {{0x4095C8EFu, 0x544210ECu}}, {{0x31B91C49u, 0xBD2AA09Fu}}, {{0x40CF9B47u, 0x6C897C25u}}, {{0x32C5BFE7u, 0x50DD3F31u}} },
    { {{0x40A2759Cu, 0x0E79C355u}}, {{0x3282527Cu, 0x32B55F54u}}, {{0x40C5D882u, 0xD2EE4803u}}, {{0x31C7C07Du, 0x28E981E3u}} },
    { {{0x40AE7FE0u, 0xB5FC786Bu}}, {{0x322D966Eu, 0x1D6AF141u}}, {{0x40BB4FF6u, 0x32A908F7u}}, {{0x323EC151u, 0x839CB9DAu}} },
    { {{0x40B9DBB4u, 0x06F52BBEu}}, {{0x32DDB7CFu, 0x923ED5DFu}}, {{0x40B00C29u, 0x37AB1EFAu}}, {{0x328D94BCu, 0x1C8659F9u}} },
};

static const Hw k_pio2_4 = {{0x1F2049C1u, 0x114CF98Fu}};   /* pi/2 less the three parts */

/* tan(rh + rl), quadrant q: sin r and cos r each a sum, r = j/16 + d
 * with |d| <= 1/32 -- sin(j/16) cos d + cos(j/16) sin d and the like,
 * sin d - d and cos d - 1 by their short series -- then one over the
 * other by the corrected division. */
static double m_tan_pair(double rh, double rl, int q) {
    Sum s;
    Sum co;
    Sum *num;
    Sum *den;
    double ah;
    double al;
    double dh;
    double d;
    double d2;
    double p;
    double sd;
    double cm;
    double sh;
    double sl;
    double ch;
    double cl;
    double eh;
    double el;
    double qh;
    double ql;
    int j;
    int i;
    if (rh < 0.0) { ah = -rh; al = -rl; } else { ah = rh; al = rl; }
    j = (int)(ah * 16.0 + 0.5);
    if (j > 13) j = 13;
    dh = ah - (double)j * 0.0625;
    d = dh + al;
    d2 = d * d;
    p = 1.0 / 362880.0;
    p = p * d2 - 1.0 / 5040.0;
    p = p * d2 + 1.0 / 120.0;
    p = p * d2 - 1.0 / 6.0;
    sd = (d * d2) * p;
    p = 1.0 / 40320.0;
    p = p * d2 - 1.0 / 720.0;
    p = p * d2 + 1.0 / 24.0;
    p = p * d2 - 0.5;
    cm = d2 * p;
    sh = m_sincost[j][0].d;
    sl = m_sincost[j][1].d;
    ch = m_sincost[j][2].d;
    cl = m_sincost[j][3].d;
    s.n = 0;
    s.q = 0;
    SUM_ADD(&s, sh, 0);
    SUM_ADD(&s, sl, 0);
    SUM_MUL(&s, sh, cm, 0);
    SUM_MUL(&s, ch, dh, 0);
    SUM_MUL(&s, ch, al, 0);
    SUM_MUL(&s, cl, dh, 0);
    SUM_MUL(&s, ch, sd, 0);
    co.n = 0;
    co.q = 0;
    SUM_ADD(&co, ch, 0);
    SUM_ADD(&co, cl, 0);
    SUM_MUL(&co, ch, cm, 0);
    SUM_MUL(&co, -sh, dh, 0);
    SUM_MUL(&co, -sh, al, 0);
    SUM_MUL(&co, -sl, dh, 0);
    SUM_MUL(&co, -sh, sd, 0);
    if (q & 1) {                         /* -cos r / sin r */
        for (i = 0; i < co.n; i++) co.a[i] = -co.a[i];
        num = &co;
        den = &s;
    } else {
        num = &s;
        den = &co;
    }
    if (rh < 0.0) for (i = 0; i < num->n; i++) num->a[i] = -num->a[i];
    eh = sum_round(den, &el);
    if (hfp_is_zero(eh)) return HFP_HUGE;
    m_ddiv(num, eh, el, &qh, &ql);
    s.n = 0;
    s.q = 0;
    SUM_ADD(&s, qh, 0);
    SUM_ADD(&s, ql, 0);
    return sum_round(&s, 0);
}

/* sin or cos of r = rh + rl, |r| <= pi/4 plus a little, quadrant q:
 * q 0 sin r, 1 cos r, 2 -sin r, 3 -cos r.  r = j/16 + d, |d| <= 1/32,
 * and sin r and cos r each the sum m_tan_pair forms -- sin(j/16) cos d
 * + cos(j/16) sin d and the like, sin d - d and cos d - 1 by their
 * short series -- rounded once. */
static double m_sc_pair(double rh, double rl, int q) {
    Sum s;
    double ah;
    double al;
    double dh;
    double d;
    double d2;
    double p;
    double sd;
    double cm;
    double sh;
    double sl;
    double ch;
    double cl;
    double r;
    int j;
    if (rh < 0.0) { ah = -rh; al = -rl; } else { ah = rh; al = rl; }
    j = (int)(ah * 16.0 + 0.5);
    if (j > 13) j = 13;
    dh = ah - (double)j * 0.0625;
    d = dh + al;
    d2 = d * d;
    p = 1.0 / 362880.0;
    p = p * d2 - 1.0 / 5040.0;
    p = p * d2 + 1.0 / 120.0;
    p = p * d2 - 1.0 / 6.0;
    sd = (d * d2) * p;
    p = 1.0 / 40320.0;
    p = p * d2 - 1.0 / 720.0;
    p = p * d2 + 1.0 / 24.0;
    p = p * d2 - 0.5;
    cm = d2 * p;
    sh = m_sincost[j][0].d;
    sl = m_sincost[j][1].d;
    ch = m_sincost[j][2].d;
    cl = m_sincost[j][3].d;
    s.n = 0;
    s.q = 0;
    if (q & 1) {
        SUM_ADD(&s, ch, 0);
        SUM_ADD(&s, cl, 0);
        SUM_MUL(&s, ch, cm, 0);
        SUM_MUL(&s, -sh, dh, 0);
        SUM_MUL(&s, -sh, al, 0);
        SUM_MUL(&s, -sl, dh, 0);
        SUM_MUL(&s, -sh, sd, 0);
    } else {
        SUM_ADD(&s, sh, 0);
        SUM_ADD(&s, sl, 0);
        SUM_MUL(&s, sh, cm, 0);
        SUM_MUL(&s, ch, dh, 0);
        SUM_MUL(&s, ch, al, 0);
        SUM_MUL(&s, cl, dh, 0);
        SUM_MUL(&s, ch, sd, 0);
    }
    r = sum_round(&s, 0);
    if (!(q & 1) && rh < 0.0) r = -r;   /* sin is odd */
    return q & 2 ? -r : r;
}

/* x = k pi/2 + rh + rl as f77m_tan reduces it, and sin or cos (cosine
 * 1) of it: cos x is sin x's next quadrant */
static double m_sincos(double x, int cosine) {
    Sum t;
    double kd;
    double k;
    double rh;
    double rl;
    int ki;
    if (m_fabs(x) >= 1048576.0) {
        rh = m_reduce_big(m_fabs(x), &ki, &rl);
        if (x < 0.0) { rh = -rh; rl = -rl; ki = -ki; }
        return m_sc_pair(rh, rl, (ki + cosine) & 3);
    }
    kd = x / c_pio2();
    k = (double)(long)(kd < 0.0 ? kd - 0.5 : kd + 0.5);
    t.n = 0;
    t.q = 0;
    SUM_ADD(&t, x - k * c_pio2_1(), 0);
    SUM_MUL(&t, -k, c_pio2_2(), 0);
    SUM_MUL(&t, -k, c_pio2_3(), 0);
    SUM_MUL(&t, -k, k_pio2_4.d, 0);
    rh = sum_round(&t, &rl);
    return m_sc_pair(rh, rl, (((int)k) + cosine) & 3);
}

double f77m_sin(double x) __asm__("M@SIN");
double f77m_sin(double x) { return m_sincos(x, 0); }

double f77m_cos(double x) __asm__("M@COS");
double f77m_cos(double x) { return m_sincos(x, 1); }

/* r in two parts: below 2^20 the reduction by pi/2 in four (k times
 * each of the last three exact in extended), above it Payne and
 * Hanek's with its next bits */
double f77m_tan(double x) __asm__("M@TAN");
double f77m_tan(double x) {
    Sum t;
    double kd;
    double k;
    double rh;
    double rl;
    int ki;
    if (m_fabs(x) >= 1048576.0) {
        rh = m_reduce_big(m_fabs(x), &ki, &rl);
        if (x < 0.0) { rh = -rh; rl = -rl; ki = -ki; }
        return m_tan_pair(rh, rl, ki & 3);
    }
    kd = x / c_pio2();
    k = (double)(long)(kd < 0.0 ? kd - 0.5 : kd + 0.5);
    t.n = 0;
    t.q = 0;
    SUM_ADD(&t, x - k * c_pio2_1(), 0);
    SUM_MUL(&t, -k, c_pio2_2(), 0);
    SUM_MUL(&t, -k, c_pio2_3(), 0);
    SUM_MUL(&t, -k, k_pio2_4.d, 0);
    rh = sum_round(&t, &rl);
    return m_tan_pair(rh, rl, ((int)k) & 3);
}

/* How far x is from the nearest odd multiple of pi/2, where TAN has
 * its singularities, in units of pi/4 (f77mchk.c's check).  Far from
 * one, 1. */
double f77m_tan_gap(double x) __asm__("M@TANGP");
double f77m_tan_gap(double x) {
    int q;
    double r;
    r = m_reduce(x, &q);
    if (!(q & 1)) return 1.0;
    return m_fabs(r) * 2.0 / c_pio2();
}

/* --- arc tangents ----------------------------------------------- */

/* sg atan(zh + zl), 0 <= z <= 1, sg +1 or -1, into t: atan(k/8) +
 * atan u, k the nearest whole number to 8z and u = (z - k/8) / (1 +
 * z k/8), within 1/16, its numerator exact and its denominator in two
 * parts; atan u = u - u^3/3 + ..., to u^17. */
static void m_atan_terms(Sum *t, double zh, double zl, double sg) {
    double c;
    double uh;
    double ul;
    double u2;
    double p;
    int k;
    k = (int)(zh * 8.0 + 0.5);
    c = (double)k * 0.125;
    if (k == 0) {
        uh = zh;
        ul = zl;
    } else {
        Sum d;
        double dh;
        double dl;
        d.n = 0;
        d.q = 0;
        SUM_ADD(&d, 1.0, 0);
        SUM_MUL(&d, c, zh, 0);
        SUM_MUL(&d, c, zl, 0);
        dh = sum_round(&d, &dl);
        d.n = 0;
        SUM_ADD(&d, zh - c, 0);
        SUM_ADD(&d, zl, 0);
        m_ddiv(&d, dh, dl, &uh, &ul);
    }
    u2 = uh * uh;
    p = 1.0 / 17.0;
    p = p * u2 - 1.0 / 15.0;
    p = p * u2 + 1.0 / 13.0;
    p = p * u2 - 1.0 / 11.0;
    p = p * u2 + 1.0 / 9.0;
    p = p * u2 - 1.0 / 7.0;
    p = p * u2 + 1.0 / 5.0;
    p = p * u2 - 1.0 / 3.0;
    SUM_ADD(t, sg * m_atant[k][0].d, 0);
    SUM_ADD(t, sg * m_atant[k][1].d, 0);
    SUM_ADD(t, sg * uh, 0);
    SUM_ADD(t, sg * ul, 0);
    SUM_ADD(t, sg * ((uh * u2) * p), 0);
}

static const Hw k_pio2_lo = {{0x33469898u, 0xCC51701Cu}};   /* pi/2 less c_pio2 */
#define c_pio2_lo() (k_pio2_lo.d)
static const Hw k_pi_lo = {{0x338D3131u, 0x98A2E037u}};   /* pi less c_pi */
#define c_pi_lo() (k_pi_lo.d)

/* atan2(ay, ax), both positive, into t: from 0 to pi/2 */
static void m_atan2_terms(Sum *t, double ay, double ax) {
    Sum q;
    double zh;
    double zl;
    q.n = 0;
    q.q = 0;
    if (ay <= ax) {
        SUM_ADD(&q, ay, 0);
        m_ddiv(&q, ax, 0.0, &zh, &zl);
        m_atan_terms(t, zh, zl, 1.0);
    } else {
        SUM_ADD(&q, ax, 0);
        m_ddiv(&q, ay, 0.0, &zh, &zl);
        SUM_ADD(t, c_pio2(), 0);
        SUM_ADD(t, c_pio2_lo(), 0);
        m_atan_terms(t, zh, zl, -1.0);
    }
}

/* pi less the sum */
static void m_pi_less(Sum *t) {
    int i;
    for (i = 0; i < t->n; i++) t->a[i] = -t->a[i];
    SUM_ADD(t, c_pi(), 0);
    SUM_ADD(t, c_pi_lo(), 0);
}

/* the rounded pi/2 and pi: the constants are cut */
static double m_pio2r(void) { Sum t; t.n = 0; t.q = 0; SUM_ADD(&t, c_pio2(), 0); SUM_ADD(&t, c_pio2_lo(), 0); return sum_round(&t, 0); }
static double m_pir(void) { Sum t; t.n = 0; t.q = 0; SUM_ADD(&t, c_pi(), 0); SUM_ADD(&t, c_pi_lo(), 0); return sum_round(&t, 0); }

double f77m_atan(double x) __asm__("M@ATAN");
double f77m_atan(double x) {
    Sum t;
    double r;
    if (hfp_is_zero(x)) return 0.0;
    t.n = 0;
    t.q = 0;
    m_atan2_terms(&t, m_fabs(x), 1.0);
    r = sum_round(&t, 0);
    return x < 0.0 ? -r : r;
}

double f77m_atan2(double y, double x) __asm__("M@ATAN2");
double f77m_atan2(double y, double x) {
    Sum t;
    double r;
    if (hfp_is_zero(x)) {
        if (hfp_is_zero(y)) return 0.0;
        r = m_pio2r();
        return y < 0.0 ? -r : r;
    }
    t.n = 0;
    t.q = 0;
    m_atan2_terms(&t, m_fabs(y), m_fabs(x));
    if (x < 0.0) m_pi_less(&t);
    r = sum_round(&t, 0);
    return y < 0.0 ? -r : r;
}

/* asin x = atan2(x, s) and acos x = atan2(s, x), s = sqrt(1 - x^2) in
 * two parts: 1 - x^2 exact (as 2d - d^2, d = 1 - |x|, from 0.5 on,
 * where x^2 would cancel), its root rounded and the remainder's
 * share. */
static double m_asincos(double x, int acos) {
    Sum t;
    Sum q;
    double a;
    double wh;
    double wl;
    double sh;
    double sl;
    double zh;
    double zl;
    double r;
    a = m_fabs(x);
    if (a >= 1.0) {
        if (acos) return x > 0.0 ? 0.0 : m_pir();
        r = m_pio2r();
        return x < 0.0 ? -r : r;
    }
    t.n = 0;
    t.q = 0;
    if (a >= 0.5) {
        double d;
        d = 1.0 - a;
        SUM_ADD(&t, d, 1);
        SUM_MUL(&t, -d, d, 0);
    } else {
        SUM_ADD(&t, 1.0, 0);
        SUM_MUL(&t, -a, a, 0);
    }
    wh = sum_round(&t, &wl);
    sh = f77m_sqrt(wh);
    t.n = 0;
    SUM_ADD(&t, wh, 0);
    SUM_ADD(&t, wl, 0);
    SUM_MUL(&t, -sh, sh, 0);
    sl = sum_round(&t, 0) / (2.0 * sh);
    t.n = 0;
    q.n = 0;
    q.q = 0;
    if (!acos) {
        if (a <= sh) {
            SUM_ADD(&q, a, 0);
            m_ddiv(&q, sh, sl, &zh, &zl);
            m_atan_terms(&t, zh, zl, 1.0);
        } else {
            SUM_ADD(&q, sh, 0);
            SUM_ADD(&q, sl, 0);
            m_ddiv(&q, a, 0.0, &zh, &zl);
            SUM_ADD(&t, c_pio2(), 0);
            SUM_ADD(&t, c_pio2_lo(), 0);
            m_atan_terms(&t, zh, zl, -1.0);
        }
        r = sum_round(&t, 0);
        return x < 0.0 ? -r : r;
    }
    if (sh <= a) {
        SUM_ADD(&q, sh, 0);
        SUM_ADD(&q, sl, 0);
        m_ddiv(&q, a, 0.0, &zh, &zl);
        m_atan_terms(&t, zh, zl, 1.0);
    } else {
        SUM_ADD(&q, a, 0);
        m_ddiv(&q, sh, sl, &zh, &zl);
        SUM_ADD(&t, c_pio2(), 0);
        SUM_ADD(&t, c_pio2_lo(), 0);
        m_atan_terms(&t, zh, zl, -1.0);
    }
    if (x < 0.0) m_pi_less(&t);
    return sum_round(&t, 0);
}

double f77m_asin(double x) __asm__("M@ASIN");
double f77m_asin(double x) { return m_asincos(x, 0); }

double f77m_acos(double x) __asm__("M@ACOS");
double f77m_acos(double x) { return m_asincos(x, 1); }

/* --- hyperbolics ------------------------------------------------ */

/* (exp a + sg / exp a) / 2.  1/exp a by a corrected division when the
 * result may be below 1 (exact); else, the result's unit being 16
 * times 1/exp a's at least, a plain one with exp a's low part */
static double m_hyp(double a, double sg, int exact) {
    Sum t;
    Sum e;
    double eh;
    double el;
    double qh;
    double ql;
    int k;
    e.n = 0;
    e.q = 0;
    k = m_exp_terms(&e, a, 0, 0.0);
    t = e;
    sum_frame(&e, k);
    eh = sum_round(&e, &el);
    sum_frame(&t, k - 1);
    if (t.q >= 50) return sum_round(&t, 0);   /* 1/exp a is below exp a by 2^-400 and more */
    if (exact) {
        e.n = 0;
        e.q = 0;
        SUM_ADD(&e, 1.0, 0);
        m_ddiv(&e, eh, el, &qh, &ql);
        SUM_ADD(&t, sg * qh, -1 - 4 * t.q);
        SUM_ADD(&t, sg * ql, -1 - 4 * t.q);
    } else {
        qh = 1.0 / eh;
        SUM_ADD(&t, sg * qh, -1 - 4 * t.q);
        SUM_ADD(&t, -sg * ((qh * qh) * el), -1 - 4 * t.q);
    }
    return sum_round(&t, 0);
}

double f77m_sinh(double x) __asm__("M@SINH");
double f77m_sinh(double x) {
    double a;
    double r;
    a = m_fabs(x);
    if (a > 176.0) return x < 0.0 ? -HFP_HUGE : HFP_HUGE;   /* up to 175.366, as COSH */
    if (a < 0.125) {
        /* the series, to x^13: the exponentials would cancel */
        Sum t;
        double x2;
        double p;
        x2 = x * x;
        p = 1.0 / 6227020800.0;
        p = p * x2 + 1.0 / 39916800.0;
        p = p * x2 + 1.0 / 362880.0;
        p = p * x2 + 1.0 / 5040.0;
        p = p * x2 + 1.0 / 120.0;
        p = p * x2 + 1.0 / 6.0;
        t.n = 0;
        t.q = 0;
        SUM_ADD(&t, x, 0);
        SUM_ADD(&t, (x * x2) * p, 0);
        return sum_round(&t, 0);
    }
    r = m_hyp(a, -1.0, a < 0.8814);
    return x < 0.0 ? -r : r;
}

double f77m_cosh(double x) __asm__("M@COSH");
double f77m_cosh(double x) {
    double a;
    a = m_fabs(x);
    if (a > 176.0) return HFP_HUGE;   /* m_hyp's frame takes it there from 175.366 */
    return m_hyp(a, 1.0, 0);
}

/* u / (u + 2), u = exp(2a) - 1, the denominator in two parts; from
 * 1.75 on, 1 - 2/(u + 2) */
double f77m_tanh(double x) __asm__("M@TANH");
double f77m_tanh(double x) {
    Sum u;
    Sum d;
    double a;
    double dh;
    double dl;
    double qh;
    double ql;
    double r;
    a = m_fabs(x);
    if (a > 22.0) return x < 0.0 ? -1.0 : 1.0;
    u.n = 0;
    u.q = 0;
    if (a < 1.0 / 4096.0) {              /* x - x^3/3 + 2x^5/15 */
        double x2;
        x2 = x * x;
        SUM_ADD(&u, x, 0);
        SUM_ADD(&u, (x * x2) * (-1.0 / 3.0 + (2.0 / 15.0) * x2), 0);
        return sum_round(&u, 0);
    }
    sum_frame(&u, m_exp_terms(&u, a, 1, 0.0));
    if (a >= 1.75) {                     /* 1 - 2/(exp(2a) + 1), the quotient below 1/16 */
        double q;
        SUM_ADD(&u, 1.0, -4 * u.q);
        dh = sum_round(&u, &dl);
        q = 2.0 / dh;
        d.n = 0;
        d.q = 0;
        SUM_ADD(&d, 1.0, 0);
        SUM_ADD(&d, -q, 0);
        SUM_ADD(&d, (q * q) * dl, -1);
        r = sum_round(&d, 0);
        return x < 0.0 ? -r : r;
    }
    SUM_ADD(&u, -1.0, -4 * u.q);
    d = u;
    SUM_ADD(&d, 2.0, -4 * d.q);
    dh = sum_round(&d, &dl);
    m_ddiv(&u, dh, dl, &qh, &ql);
    d.n = 0;
    d.q = 0;
    SUM_ADD(&d, qh, 0);
    SUM_ADD(&d, ql, 0);
    r = sum_round(&d, 0);
    return x < 0.0 ? -r : r;
}

/* --- powers ----------------------------------------------------- */

/* exp(y log x), log x in two parts and their product with y in two */
double f77m_pow(double x, double y) __asm__("M@POW");
double f77m_pow(double x, double y) {
    Sum t;
    double r;
    double lh;
    double ll;
    double xh;
    double xl;
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
    t.n = 0;
    t.q = 0;
    m_log_terms(&t, x);
    lh = sum_round(&t, &ll);
    /* y log x past the exponential's range would overflow the product */
    if (m_fabs(y) > 1.0 && m_fabs(lh) > 200.0 / m_fabs(y))
        r = (y < 0.0) == (lh < 0.0) ? HFP_HUGE : 0.0;
    else {
        t.n = 0;
        SUM_MUL(&t, y, lh, 0);
        SUM_MUL(&t, y, ll, 0);
        xh = sum_round(&t, &xl);
        if (xh > 175.0) r = HFP_HUGE;
        else if (xh < -180.2) r = 0.0;
        else {
            t.n = 0;
            sum_frame(&t, m_exp_terms(&t, xh, 0, xl));
            r = sum_round(&t, 0);
        }
    }
    return neg ? -r : r;
}
