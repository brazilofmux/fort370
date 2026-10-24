/* f77mzc.c -- FORTLIB's checks of the COMPLEX and COMPLEX*16 functions'
 * arguments (f77m.h), as f77mchk.c's of the REAL and DOUBLE PRECISION
 * ones.  Each message, its condition, the order of the tests and the
 * standard fixup are FORTRAN H's, run on TK5 (2026-10-24).  r is 1 for
 * COMPLEX, 0 for COMPLEX*16.  A check that finds its argument out of
 * the function's domain reports it, puts the fixup in out and returns
 * 1; the caller then returns it.  Otherwise it returns 0 and the
 * caller computes.
 *
 * A COMPLEX fixup is computed as FORTLIB computes it, in short: the
 * largest REAL number times the REAL function's value, cut, as a short
 * multiply and a store cut them.  The COMPLEX*16 ones take our DSIN and
 * DCOS, which are a few units nearer than FORTLIB's: H's fixups differ
 * from these in their last digits. */
#include <stdio.h>
#define F77M_NO_MAP
#include "f77m.h"

void f77e_say(int n, const char *text) __asm__("F77ESAY");
char *f77e_num(char *b, double v, int r) __asm__("F77ENUM");

typedef union { double d; unsigned int w[2]; } Hfp;

static double m_word(unsigned int hi, unsigned int lo) { Hfp u; u.w[0] = hi; u.w[1] = lo; return u.d; }
/* the largest number, and its half, REAL's for COMPLEX */
#define HUGE (r ? m_word(0x7FFFFFFFu, 0) : m_word(0x7FFFFFFFu, 0xFFFFFFFFu))
#define HALF (r ? m_word(0x7F7FFFFFu, 0) : m_word(0x7F7FFFFFu, 0xFFFFFFFFu))
/* "GE PI*2**18" and "GE PI*2**50", as FORTLIB tests them: COMPLEX's
 * X'45C90000', pi 2**18 to its first four digits, 253.6 below it;
 * COMPLEX*16's X'4DC90FDA00000000' as DSIN's (f77mchk.c).  Measured on
 * TK5 with CEXP, CSIN, CDEXP and CDSIN, 2026-10-24. */
#define M_PI_2_18 823296.0
#define M_PI_2_50 3537118706008064.0
#define M_AT(x) ((x) < 0.0 ? -(x) : (x))
/* "GT 174.673": X'42AEAC50', COMPLEX's and COMPLEX*16's; from DEXP's
 * X'42AEAC4F00000000' to it, CDEXP and CDSIN take DEXP's message, IHC262I,
 * and their own fixup (measured on TK5, 2026-10-24) */
#define M_EXP_BIG 174.673095703125
#define M_DEXP_BIG 174.6730804443359375

double f77c_exp(double, int r) __asm__("M@CEXP");

/* x to short, as STE leaves it, for COMPLEX; x itself for COMPLEX*16 */
static double m_cut(double x, int r) { Hfp u; u.d = x; if (r) u.w[1] = 0; return u.d; }
static double m_sin(double x, int r) { return m_cut(f77m_sin(x), r); }
static double m_cos(double x, int r) { return m_cut(f77m_cos(x), r); }

static char m_text[160];
static char m_num[40];
static char m_hexb[20];

static char *m_hex(double x, int r) {
    Hfp u;
    u.d = x;
    if (r) sprintf(m_hexb, "%08X", u.w[0]);
    else sprintf(m_hexb, "%08X%08X", u.w[0], u.w[1]);
    return m_hexb;
}

/* CEXP: an imaginary part too large for its sine is zero; then a real
 * part too large for the exponential is the largest number in the
 * direction of the imaginary part. */
int f77k_exp(double re, double im, double *out, int r) __asm__("M@KEXP");
int f77k_exp(double re, double im, double *out, int r) {
    if (M_AT(im) >= (r ? M_PI_2_18 : M_PI_2_50)) {
        sprintf(m_text, "%s IMAG ARG=%s(HEX=%s)%s ABS VALUE GE PI*2**%d", r ? "CEXP" : "CDEXP",
                f77e_num(m_num, im, r), m_hex(im, r), r ? "," : "", r ? 18 : 50);
        f77e_say(r ? 272 : 282, m_text);
        out[0] = 0.0;
        out[1] = 0.0;
        return 1;
    }
    if (re >= (r ? M_EXP_BIG : M_DEXP_BIG)) {
        if (re < M_EXP_BIG) f77c_exp(re, 0);
        else {
            sprintf(m_text, "%s REAL ARG=%s(HEX=%s)%s GT 174.673", r ? "CEXP" : "CDEXP",
                    f77e_num(m_num, re, r), m_hex(re, r), r ? "," : "");
            f77e_say(r ? 271 : 281, m_text);
        }
        out[0] = m_cut(HUGE * m_cos(im, r), r);
        out[1] = m_cut(HUGE * m_sin(im, r), r);
        return 1;
    }
    return 0;
}

/* CLOG(0) is the largest negative number. */
int f77k_log(double re, double im, double *out, int r) __asm__("M@KLOG");
int f77k_log(double re, double im, double *out, int r) {
    if (re != 0.0 || im != 0.0) return 0;
    f77e_say(r ? 273 : 283, r ? "CLOG ARGUMENT=0.0+0.0I" : "CDLOG ARGUMENT=0.D0+0.D0I");
    out[0] = -HUGE;
    out[1] = 0.0;
    return 1;
}

/* CSIN and CCOS (c 1): a real part too large for its sine is zero, and
 * the imaginary part is then not looked at; an imaginary part too large
 * for the hyperbolic functions is half the largest number times the
 * sine or cosine of the real part, its sign from the imaginary part. */
int f77k_sin(double re, double im, double *out, int c, int r) __asm__("M@KSIN");
int f77k_sin(double re, double im, double *out, int c, int r) {
    double s;
    double k;
    if (M_AT(re) >= (r ? M_PI_2_18 : M_PI_2_50)) {
        sprintf(m_text, "%s /REAL ARG/=/%s(HEX=%s)/, GE PI*2**%d", r ? "CSIN-CCOS" : "CDSIN-CDCOS",
                f77e_num(m_num, re, r), m_hex(re, r), r ? 18 : 50);
        f77e_say(r ? 274 : 284, m_text);
        out[0] = 0.0;
        out[1] = 0.0;
        return 1;
    }
    if (M_AT(im) >= (r ? M_EXP_BIG : M_DEXP_BIG)) {
        if (M_AT(im) < M_EXP_BIG) f77c_exp(M_AT(im), 0);
        else {
            sprintf(m_text, "%s /IMAG ARG/=/%s(HEX=%s)/, GT 174.673", r ? "CSIN-CCOS" : "CDSIN-CDCOS",
                    f77e_num(m_num, im, r), m_hex(im, r));
            f77e_say(r ? 275 : 285, m_text);
        }
        s = m_cut(HALF * m_sin(re, r), r);
        k = m_cut(HALF * m_cos(re, r), r);
        if (c) { out[0] = k; out[1] = im < 0.0 ? s : -s; }
        else { out[0] = s; out[1] = im < 0.0 ? -k : k; }
        return 1;
    }
    return 0;
}

/* FCXPI and FCDXI: a zero base with an exponent not positive, zero
 * included, is zero. */
int f77k_pow(double re, double im, int n, double *out, int r) __asm__("M@KPOW");
int f77k_pow(double re, double im, int n, double *out, int r) {
    if (re != 0.0 || im != 0.0 || n > 0) return 0;
    sprintf(m_text, "%s BASE=0.0+0.0I, INTEGER EXPONENT=%11d, LE 0", r ? "FCXPI COMPLEX*8" : "FCDXI COMPLEX*16", n);
    f77e_say(r ? 246 : 247, m_text);
    out[0] = 0.0;
    out[1] = 0.0;
    return 1;
}
