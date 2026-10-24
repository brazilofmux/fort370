/* f77m.h -- the mathematical functions, three ways.
 *
 * The cores (f77math.c), M@SQRT and the rest, compute and say nothing
 * of an argument out of their domain.  The runtime's own C calls them
 * through the libm names, mapped here: CLOG(0) taking the log of zero
 * is not the program's ALOG(0.0).
 *
 * The checks (f77mchk.c) are FORTLIB's: an argument out of a function's
 * domain gets its IHC message and its standard fixup (f77err.c counts
 * them), the rest the core's value.  r is 1 for the REAL function, 0
 * for the DOUBLE PRECISION one: the message's number and the format
 * of the argument in it differ.
 *
 * The entries (f77mlr.c, REAL; f77mld.c, DOUBLE PRECISION) are what a
 * program calls (backend/s370_rtnames.h), or what it passes for an
 * intrinsic named as an argument (f77int*.c). */
#ifndef F77M_H
#define F77M_H

double f77m_sqrt(double) __asm__("M@SQRT");
double f77m_zabs(double, double) __asm__("M@ZABS");
void f77m_zsqrt(double, double, double *) __asm__("M@ZSQRT");
void f77m_zsin(double, double, double *) __asm__("M@ZSIN");
void f77m_zcos(double, double, double *) __asm__("M@ZCOS");
void f77m_zlog(double, double, double *) __asm__("M@ZLOG");
double f77m_exp(double) __asm__("M@EXP");
double f77m_log(double) __asm__("M@LOG");
double f77m_log10(double) __asm__("M@LOG10");
double f77m_sin(double) __asm__("M@SIN");
double f77m_cos(double) __asm__("M@COS");
double f77m_tan(double) __asm__("M@TAN");
double f77m_atan(double) __asm__("M@ATAN");
double f77m_atan2(double, double) __asm__("M@ATAN2");
double f77m_asin(double) __asm__("M@ASIN");
double f77m_acos(double) __asm__("M@ACOS");
double f77m_sinh(double) __asm__("M@SINH");
double f77m_cosh(double) __asm__("M@COSH");
double f77m_tanh(double) __asm__("M@TANH");
double f77m_pow(double, double) __asm__("M@POW");
double f77m_tan_gap(double) __asm__("M@TANGP");

double f77c_sqrt(double, int r) __asm__("M@CSQRT");
double f77c_exp(double, int r) __asm__("M@CEXP");
double f77c_log(double, int r) __asm__("M@CLOG");
double f77c_log10(double, int r) __asm__("M@CLOG10");
double f77c_sin(double, int r) __asm__("M@CSIN");
double f77c_cos(double, int r) __asm__("M@CCOS");
double f77c_tan(double, int r) __asm__("M@CTAN");
double f77c_atan2(double, double, int r) __asm__("M@CATAN2");
double f77c_asin(double, int r) __asm__("M@CASIN");
double f77c_acos(double, int r) __asm__("M@CACOS");
double f77c_sinh(double, int r) __asm__("M@CSINH");
double f77c_cosh(double, int r) __asm__("M@CCOSH");
double f77c_pow(double, double, int r) __asm__("M@CPOW");
/* the COMPLEX (r 1) and COMPLEX*16 ones' (f77mzc.c): 1, the fixup in
 * out, for an argument out of the function's domain */
int f77k_exp(double, double, double *out, int r) __asm__("M@KEXP");
int f77k_log(double, double, double *out, int r) __asm__("M@KLOG");
int f77k_sin(double, double, double *out, int c, int r) __asm__("M@KSIN");
int f77k_pow(double, double, int, double *out, int r) __asm__("M@KPOW");

double f77f_sqrt(double) __asm__("SQRT");
double f77f_exp(double) __asm__("EXP");
double f77f_log(double) __asm__("LOG");
double f77f_log10(double) __asm__("LOG10");
double f77f_sin(double) __asm__("SIN");
double f77f_cos(double) __asm__("COS");
double f77f_tan(double) __asm__("TAN");
double f77f_atan(double) __asm__("ATAN");
double f77f_atan2(double, double) __asm__("ATAN2");
double f77f_asin(double) __asm__("ASIN");
double f77f_acos(double) __asm__("ACOS");
double f77f_sinh(double) __asm__("SINH");
double f77f_cosh(double) __asm__("COSH");
double f77f_tanh(double) __asm__("TANH");
double f77f_pow(double, double) __asm__("POW");

double f77f_dsqrt(double) __asm__("DSQRT");
double f77f_dexp(double) __asm__("DEXP");
double f77f_dlog(double) __asm__("DLOG");
double f77f_dlog10(double) __asm__("DLOG10");
double f77f_dsin(double) __asm__("DSIN");
double f77f_dcos(double) __asm__("DCOS");
double f77f_dtan(double) __asm__("DTAN");
double f77f_datan(double) __asm__("DATAN");
double f77f_datan2(double, double) __asm__("DATAN2");
double f77f_dasin(double) __asm__("DASIN");
double f77f_dacos(double) __asm__("DACOS");
double f77f_dsinh(double) __asm__("DSINH");
double f77f_dcosh(double) __asm__("DCOSH");
double f77f_dtanh(double) __asm__("DTANH");
double f77f_dpow(double, double) __asm__("DPOW");

#ifndef F77M_NO_MAP
#define sqrt(...) f77m_sqrt(__VA_ARGS__)
#define exp(...) f77m_exp(__VA_ARGS__)
#define log(...) f77m_log(__VA_ARGS__)
#define log10(...) f77m_log10(__VA_ARGS__)
#define sin(...) f77m_sin(__VA_ARGS__)
#define cos(...) f77m_cos(__VA_ARGS__)
#define tan(...) f77m_tan(__VA_ARGS__)
#define atan(...) f77m_atan(__VA_ARGS__)
#define atan2(...) f77m_atan2(__VA_ARGS__)
#define asin(...) f77m_asin(__VA_ARGS__)
#define acos(...) f77m_acos(__VA_ARGS__)
#define sinh(...) f77m_sinh(__VA_ARGS__)
#define cosh(...) f77m_cosh(__VA_ARGS__)
#define tanh(...) f77m_tanh(__VA_ARGS__)
#define pow(...) f77m_pow(__VA_ARGS__)
#endif

#endif
