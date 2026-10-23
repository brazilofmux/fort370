/* f77mld.c -- the DOUBLE PRECISION mathematical functions a program calls
 * (f77m.h): FORTLIB's checks of the argument, then the core. */
#define F77M_NO_MAP
#include "f77m.h"

double f77f_dsqrt(double x) { return f77c_sqrt(x, 0); }
double f77f_dexp(double x) { return f77c_exp(x, 0); }
double f77f_dlog(double x) { return f77c_log(x, 0); }
double f77f_dlog10(double x) { return f77c_log10(x, 0); }
double f77f_dsin(double x) { return f77c_sin(x, 0); }
double f77f_dcos(double x) { return f77c_cos(x, 0); }
double f77f_dtan(double x) { return f77c_tan(x, 0); }
double f77f_datan(double x) { return f77m_atan(x); }
double f77f_datan2(double x, double y) { return f77c_atan2(x, y, 0); }
double f77f_dasin(double x) { return f77c_asin(x, 0); }
double f77f_dacos(double x) { return f77c_acos(x, 0); }
double f77f_dsinh(double x) { return f77c_sinh(x, 0); }
double f77f_dcosh(double x) { return f77c_cosh(x, 0); }
double f77f_dtanh(double x) { return f77m_tanh(x); }
double f77f_dpow(double x, double y) { return f77c_pow(x, y, 0); }
