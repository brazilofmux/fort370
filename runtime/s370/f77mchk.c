/* f77mchk.c -- FORTLIB's checks of the mathematical functions'
 * arguments (f77m.h).  Each message, its condition and its standard
 * fixup are FORTRAN H's, run on TK5 (2026-10-23): the REAL function's
 * message gives the argument as E14.7, the DOUBLE PRECISION one's as
 * D23.16, and some give its hexadecimal too.  r is 1 for REAL.
 *
 * Two of the conditions are measured, not documented: TAN's singularity
 * is an argument within 7.9E-6 (REAL) or 2**-49 (DOUBLE PRECISION) of
 * an odd multiple of pi/2, in units of pi/4 -- H flagged every argument
 * at 7.69E-6 or less and none at 8.10E-6 or more, and in DOUBLE
 * PRECISION every one at 1.21E-15 or less and none at 2.18E-15 or more.
 *
 * Not FORTLIB's: an EXP or ** whose result underflows is zero without
 * a word, where FORTLIB's EXP takes an underflow interrupt of its own
 * and reports it, IHC208I, with the rest of the program's. */
#include <stdio.h>
#define F77M_NO_MAP
#include "f77m.h"

void f77e_say(int n, const char *text) __asm__("F77ESAY");
char *f77e_num(char *b, double v, int r) __asm__("F77ENUM");

typedef union { double d; unsigned int w[2]; } Hfp;

/* The largest number, REAL's for a REAL function: narrowed, the long
 * one would round up into an overflow. */
static double m_huge(int r) { Hfp u; u.w[0] = 0x7FFFFFFFu; u.w[1] = r ? 0 : 0xFFFFFFFFu; return u.d; }
#define HUGE m_huge(r)
#define M_PI_2_18 823549.6644696414      /* pi * 2**18 */
#define M_PI_2_50 3537118876014220.0     /* pi * 2**50, near enough */
/* SIN's fixup, SQRT(2)/2, from its digits */
static double m_sqrt_half(void) { Hfp u; u.w[0] = 0x40B504F3u; u.w[1] = 0x33F9DE65u; return u.d; }
#define M_SQRT_HALF m_sqrt_half()

static char m_text[160];
static char m_num[40];

static char *m_hex(char *b, double x, int r) {
    Hfp u;
    u.d = x;
    if (r) sprintf(b, "%08X", u.w[0]);
    else sprintf(b, "%08X%08X", u.w[0], u.w[1]);
    return b;
}

double f77c_sqrt(double x, int r) {
    if (x < 0.0) {
        sprintf(m_text, "%s NEGATIVE ARGUMENT=%s", r ? "SQRT" : "DSQRT", f77e_num(m_num, x, r));
        f77e_say(r ? 251 : 261, m_text);
        x = -x;
    }
    return f77m_sqrt(x);
}

static void m_exp_big(double x, int r) {
    sprintf(m_text, "%s ARG=%s, GT 174.673", r ? "EXP" : "DEXP", f77e_num(m_num, x, r));
    f77e_say(r ? 252 : 262, m_text);
}

double f77c_exp(double x, int r) {
    if (x > 174.673) { m_exp_big(x, r); return HUGE; }
    return f77m_exp(x);
}

/* ALOG(0) is the largest negative number, ALOG of a negative number
 * the log of its magnitude. */
static int m_log_bad(double x, int r) {
    if (x > 0.0) return 0;
    sprintf(m_text, "%s ARG=%s LE ZERO", r ? "ALOG-ALOG10" : "DLOG-DLOG10", f77e_num(m_num, x, r));
    f77e_say(r ? 253 : 263, m_text);
    return x == 0.0 ? 2 : 1;
}

double f77c_log(double x, int r) {
    int bad = m_log_bad(x, r);
    if (bad == 2) return -HUGE;
    return f77m_log(bad ? -x : x);
}

double f77c_log10(double x, int r) {
    int bad = m_log_bad(x, r);
    if (bad == 2) return -HUGE;
    return f77m_log10(bad ? -x : x);
}

static int m_trig_big(double x, int r, int n, const char *name, const char *sep) {
    char hex[20];
    double ax = x < 0.0 ? -x : x;
    if (ax < (r ? M_PI_2_18 : M_PI_2_50)) return 0;
    sprintf(m_text, "%s /ARG/=/%s(HEX=%s)/%s GE PI*2**%d", name, f77e_num(m_num, x, r),
            m_hex(hex, x, r), sep, r ? 18 : 50);
    f77e_say(n, m_text);
    return 1;
}

double f77c_sin(double x, int r) {
    if (m_trig_big(x, r, r ? 254 : 264, r ? "SIN-COS" : "DSIN-DCOS", ",")) return M_SQRT_HALF;
    return f77m_sin(x);
}

double f77c_cos(double x, int r) {
    if (m_trig_big(x, r, r ? 254 : 264, r ? "SIN-COS" : "DSIN-DCOS", ",")) return M_SQRT_HALF;
    return f77m_cos(x);
}

/* TAN of a huge argument is 1, at a singularity the largest number,
 * on either side of it. */
double f77c_tan(double x, int r) {
    char hex[20];
    if (m_trig_big(x, r, r ? 258 : 268, r ? "TAN-COTAN" : "DTAN-DCOTAN", r ? "," : "")) return 1.0;
    if (f77m_tan_gap(x) < (r ? 7.9e-6 : 1.7763568394002505e-15)) {
        sprintf(m_text, "%s /ARG/=/%s(HEX=%s)/%s APPROACHES SINGULARITY",
                r ? "TAN-COTAN" : "DTAN-DCOTAN", f77e_num(m_num, x, r), m_hex(hex, x, r), r ? "," : "");
        f77e_say(r ? 259 : 269, m_text);
        return HUGE;
    }
    return f77m_tan(x);
}

double f77c_atan2(double y, double x, int r) {
    if (y == 0.0 && x == 0.0) {
        sprintf(m_text, "%s ARGUMENTS=0.0", r ? "ATAN2" : "DATAN2");
        f77e_say(r ? 255 : 265, m_text);
        return 0.0;
    }
    return f77m_atan2(y, x);
}

static int m_arc_bad(double x, int r) {
    if (x >= -1.0 && x <= 1.0) return 0;
    sprintf(m_text, "%s /ARG/=/%s/%s GT 1", r ? "ARSIN-ARCOS" : "DARSIN-DARCOS", f77e_num(m_num, x, r), r ? "" : ",");
    f77e_say(r ? 257 : 267, m_text);
    return 1;
}

double f77c_asin(double x, int r) { return m_arc_bad(x, r) ? 0.0 : f77m_asin(x); }
double f77c_acos(double x, int r) { return m_arc_bad(x, r) ? 0.0 : f77m_acos(x); }

/* SINH of a large argument of either sign, as COSH, is the largest
 * positive number. */
static int m_hyp_big(double x, int r) {
    if (x > -175.366 && x < 175.366) return 0;
    sprintf(m_text, "%s /ARG/=/%s/, GE 175.366", r ? "SINH-COSH" : "DSINH-DCOSH", f77e_num(m_num, x, r));
    f77e_say(r ? 256 : 266, m_text);
    return 1;
}

double f77c_sinh(double x, int r) { return m_hyp_big(x, r) ? HUGE : f77m_sinh(x); }
double f77c_cosh(double x, int r) { return m_hyp_big(x, r) ? HUGE : f77m_cosh(x); }

/* x**y, both REAL or both DOUBLE PRECISION.  A zero base with an
 * exponent not positive is zero, with FRXPR's or FDXPD's message; a
 * negative base is ALOG's error, and the power that of its magnitude;
 * a power too large is EXP's error, y*ALOG(x) its argument. */
double f77c_pow(double x, double y, int r) {
    double lx;
    double t;
    if (x == 0.0) {
        if (y <= 0.0) {
            sprintf(m_text, "%s BASE=0.0, %s EXPONENT=%s, LE 0", r ? "FRXPR REAL*4" : "FDXPD REAL*8",
                    r ? "REAL*4" : "REAL*8", f77e_num(m_num, y, r));
            f77e_say(r ? 244 : 245, m_text);
        }
        return 0.0;
    }
    if (x < 0.0) {
        m_log_bad(x, r);
        x = -x;
    }
    lx = f77m_log(x);
    if (lx != 0.0 && (y > 0.0) == (lx > 0.0)) {
        double ay = y < 0.0 ? -y : y;
        double al = lx < 0.0 ? -lx : lx;
        if (ay > 174.673 / al) {
            t = ay <= 7.0e75 / al ? ay * al : HUGE;
            m_exp_big(t, r);
            return HUGE;
        }
    }
    return f77m_pow(x, y);
}
