/* f77mlr.c -- the REAL mathematical functions a program calls
 * (f77m.h): FORTLIB's checks of the argument, then the core. */
#define F77M_NO_MAP
#include "f77m.h"

double f77f_sqrt(double x) { return f77c_sqrt(x, 1); }
double f77f_exp(double x) { return f77c_exp(x, 1); }
double f77f_log(double x) { return f77c_log(x, 1); }
double f77f_log10(double x) { return f77c_log10(x, 1); }
double f77f_sin(double x) { return f77c_sin(x, 1); }
double f77f_cos(double x) { return f77c_cos(x, 1); }
double f77f_tan(double x) { return f77c_tan(x, 1); }
double f77f_atan(double x) { return f77m_atan(x); }
double f77f_atan2(double x, double y) { return f77c_atan2(x, y, 1); }
double f77f_asin(double x) { return f77c_asin(x, 1); }
double f77f_acos(double x) { return f77c_acos(x, 1); }
double f77f_sinh(double x) { return f77c_sinh(x, 1); }
double f77f_cosh(double x) { return f77c_cosh(x, 1); }
double f77f_tanh(double x) { return f77m_tanh(x); }
double f77f_pow(double x, double y) { return f77c_pow(x, y, 1); }
