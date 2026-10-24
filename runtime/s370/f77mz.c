/* f77mz.c -- COMPLEX*16's modulus, square root, sine and cosine for
 * System/370 hexadecimal floating point (CDABS, CDSQRT, CDSIN, CDCOS,
 * and the modulus CDLOG takes), each rounded once from a sum in
 * extended precision, as f77math.c's functions are; beside it, not in
 * it, because a library member carries at most seventeen names.  The
 * cores of the real functions are f77math.c's (f77m.h). */
#include "f77m.h"
#include "f77msum.h"

/* --- the modulus of a COMPLEX*16 value --------------------------- */

/* sqrt(re^2 + im^2), CDABS and what CDSQRT and CDLOG take it for: both
 * parts by the power of 16 (exact) that brings the larger near 1, the
 * two squares summed in extended and rounded once, the root correctly
 * rounded, and the root's own remainder, (s - y^2) / 2y, added in the
 * same way -- within a unit, nearly always rounded correctly.  The
 * textbook a sqrt(1 + (b/a)^2), truncated at each of its four steps,
 * was 11 units off; FORTLIB's CDABS is within 2. */
static double m_zabs(double re, double im, double *mres);
double f77m_zabs(double re, double im) __asm__("M@ZABS");
double f77m_zabs(double re, double im) { return m_zabs(re, im, 0); }

/* the modulus, and in *mres (if mres) what its rounding left */
static double m_zabs(double re, double im, double *mres) {
    Sum t;
    Hfp u;
    double a;
    double b;
    double s;
    double rs;
    double y;
    double d;
    int q;
    a = re < 0.0 ? -re : re;
    b = im < 0.0 ? -im : im;
    if (a < b) { y = a; a = b; b = y; }
    if (hfp_is_zero(a)) { if (mres) *mres = 0.0; return 0.0; }
    u.d = a;
    q = (int)((u.w[0] >> 24) & 0x7F) - 64;      /* a in [16^(q-1), 16^q) */
    a = m_hex(a, -q);
    b = m_hex(b, -q);                           /* zero when far below a, where it adds nothing */
    t.n = 0; t.q = 0;
    SUM_MUL(&t, a, a, 0);
    SUM_MUL(&t, b, b, 0);
    s = sum_round(&t, &rs);
    y = f77m_sqrt(s);
    t.n = 0;                                    /* s + rs - y^2: the root's remainder */
    SUM_ADD(&t, s, 0);
    SUM_ADD(&t, rs, 0);
    SUM_MUL(&t, -y, y, 0);
    d = sum_round(&t, 0);
    t.n = 0;
    SUM_ADD(&t, y, 0);
    SUM_ADD(&t, d / y, -1);                     /* d / 2y */
    y = sum_round(&t, mres ? &rs : 0);
    if (mres) *mres = m_hex(rs, q);
    return m_hex(y, q);
}

/* CDSQRT: the root of (m + |re|) / 2, m the modulus (with what its
 * rounding left), the halves summed
 * in extended and rounded once; the other part im / 2r with the
 * quotient's remainder (m_ddiv), rounded once.  The textbook steps,
 * truncated one by one, were 4 units off; FORTLIB's within 1.5. */
void f77m_zsqrt(double re, double im, double *out) __asm__("M@ZSQRT");
void f77m_zsqrt(double re, double im, double *out) {
    Sum t;
    double m;
    double r;
    double ar;
    double qh;
    double ql;
    double q;
    double mres;
    ar = re < 0.0 ? -re : re;
    m = m_zabs(re, im, &mres);
    if (hfp_is_zero(m)) { out[0] = 0.0; out[1] = 0.0; return; }
    t.n = 0; t.q = 0;
    SUM_ADD(&t, m, -1);
    SUM_ADD(&t, mres, -1);
    SUM_ADD(&t, ar, -1);
    r = f77m_sqrt(sum_round(&t, 0));
    t.n = 0;                                    /* |im| / 2r */
    SUM_ADD(&t, im < 0.0 ? -im : im, -1);
    m_ddiv(&t, r, 0.0, &qh, &ql);
    t.n = 0; t.q = 0;
    SUM_ADD(&t, qh, 0);
    SUM_ADD(&t, ql, 0);
    q = sum_round(&t, 0);
    if (re >= 0.0) { out[0] = r; out[1] = im < 0.0 ? -q : q; }
    else { out[0] = q; out[1] = im < 0.0 ? -r : r; }
}

/* CDSIN and CDCOS: sin re cosh im and cos re sinh im (cos re cosh im
 * and -sin re sinh im), each product formed exactly in extended and
 * rounded once.  Where |im| < 1, cosh im is 1 + c, c = 2 sinh^2(im/2)
 * apart, and the product a + a c: cosh im just above 1 has a leading
 * hex digit of 1 and three bits fewer than the product, which made
 * half a unit of it five of the product's.  Truncated, they were 7
 * units off. */
static double m_xcosh(double s, double im) {
    Sum t;
    double h;
    t.n = 0; t.q = 0;
    if (m_fabs(im) < 1.0) {
        h = f77m_sinh(im * 0.5);
        SUM_ADD(&t, s, 0);
        SUM_MUL(&t, s, h * h, 1);                /* s 2 sinh^2(im/2) */
    } else {
        SUM_MUL(&t, s, f77m_cosh(im), 0);
    }
    return sum_round(&t, 0);
}
void f77m_zsin(double re, double im, double *out) __asm__("M@ZSIN");
void f77m_zsin(double re, double im, double *out) {
    Sum t;
    out[0] = m_xcosh(f77m_sin(re), im);
    t.n = 0; t.q = 0; SUM_MUL(&t, f77m_cos(re), f77m_sinh(im), 0); out[1] = sum_round(&t, 0);
}
void f77m_zcos(double re, double im, double *out) __asm__("M@ZCOS");
void f77m_zcos(double re, double im, double *out) {
    Sum t;
    out[0] = m_xcosh(f77m_cos(re), im);
    t.n = 0; t.q = 0; SUM_MUL(&t, -f77m_sin(re), f77m_sinh(im), 0); out[1] = sum_round(&t, 0);
}

/* CDLOG: log|z| + i atan2(im, re).  Near the unit circle log|z| is
 * small and the modulus near 1, whose rounding the log would make
 * thousands of units of the answer; there it is half of log(1 + d),
 * d = re^2 + im^2 - 1 formed in extended, by its series: d - d^2/2,
 * exact, and the rest, far below them, in plain arithmetic.  Elsewhere
 * the log of the modulus.  FORTLIB's CDLOG and the textbook one were
 * 2000 units off near the circle. */
void f77m_zlog(double re, double im, double *out) __asm__("M@ZLOG");
void f77m_zlog(double re, double im, double *out) {
    Sum t;
    double a;
    double b;
    double d;
    double dr;
    double r;
    int k;
    a = m_fabs(re);
    b = m_fabs(im);
    out[1] = f77m_atan2(im, re);
    if ((a > b ? a : b) < 2.0 && a * a + b * b > 0.5) {
        t.n = 0; t.q = 0;
        SUM_MUL(&t, a, a, 0);
        SUM_MUL(&t, b, b, 0);
        SUM_ADD(&t, -1.0, 0);
        d = sum_round(&t, &dr);
        if (m_fabs(d) < 0.0625) {
            r = 0.0;                            /* d^3 (1/3 - d/4 + d^2/5 - ...) */
            for (k = 16; k >= 3; k--) r = 1.0 / (double)k - d * r;
            r = r * d * d * d;
            t.n = 0; t.q = 0;
            SUM_ADD(&t, d, -1);
            SUM_ADD(&t, dr, -1);
            SUM_MUL(&t, -d, d, -2);             /* -d^2/2, halved */
            SUM_ADD(&t, r, -1);
            out[0] = sum_round(&t, 0);
            return;
        }
    }
    out[0] = f77m_log(m_zabs(re, im, 0));
}
