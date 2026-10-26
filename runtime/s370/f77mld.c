/* f77mld.c -- the DOUBLE PRECISION mathematical functions a program calls
 * (f77m.h): FORTLIB's checks of the argument, then the core. */
#define F77M_NO_MAP
#include "f77m.h"

/* DSQRT is f77msq.asm; its negative arguments come here for the message */
double f77f_dsqrt_neg(double x) __asm__("M@DSQRN");
double f77f_dsqrt_neg(double x) { return f77c_sqrt(x, 0); }
/* DEXP, DLOG, DLOG10 and DPOW are f77mexp.asm; what gives a message comes here */
double f77f_dexp_c(double x) __asm__("M@DEXPC");
double f77f_dexp_c(double x) { return f77c_exp(x, 0); }
double f77f_dlog_c(double x) __asm__("M@DLOGC");
double f77f_dlog_c(double x) { return f77c_log(x, 0); }
double f77f_dlog10_c(double x) __asm__("M@DLG10C");
double f77f_dlog10_c(double x) { return f77c_log10(x, 0); }
/* DSIN and DCOS are f77mtan.asm too; 2^20 and past come here */
double f77f_dsin_c(double x) __asm__("M@DSINC");
double f77f_dsin_c(double x) { return f77c_sin(x, 0); }
double f77f_dcos_c(double x) __asm__("M@DCOSC");
double f77f_dcos_c(double x) { return f77c_cos(x, 0); }
/* DTAN is f77mtan.asm; 2^20 and past, and the singularities, come here */
double f77f_dtan_c(double x) __asm__("M@DTANC");
double f77f_dtan_c(double x) { return f77c_tan(x, 0); }
double f77f_datan2_c(double y, double x) __asm__("M@DATN2C");
double f77f_datan2_c(double y, double x) { return f77c_atan2(y, x, 0); }
/* DATAN, DASIN and DACOS are f77matn.asm; arguments past 1 come here */
double f77f_dasin_c(double x) __asm__("M@DASINC");
double f77f_dasin_c(double x) { return f77c_asin(x, 0); }
double f77f_dacos_c(double x) __asm__("M@DACOSC");
double f77f_dacos_c(double x) { return f77c_acos(x, 0); }
/* DSINH, DCOSH and DTANH are f77mexp.asm; past 175.366 comes here */
double f77f_dsinh_c(double x) __asm__("M@DSINHC");
double f77f_dsinh_c(double x) { return f77c_sinh(x, 0); }
double f77f_dcosh_c(double x) __asm__("M@DCOSHC");
double f77f_dcosh_c(double x) { return f77c_cosh(x, 0); }
double f77f_dpow_c(double x, double y) __asm__("M@DPOWC");
double f77f_dpow_c(double x, double y) { return f77c_pow(x, y, 0); }
