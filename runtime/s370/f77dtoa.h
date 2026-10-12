/* f77dtoa.h -- exact HFP to decimal, see f77dtoa.c.  The asm labels
 * keep cc370 from mangling these to one eight-character name. */
#ifndef F77DTOA_H
#define F77DTOA_H

/* The exact decimal digits of the long HFP number (hi, lo): no leading
 * or trailing zeros, value = 0.d1d2...dn * 10^decpt.  Returns n, 0 for
 * zero.  digits must hold 260 characters. */
int f77_hfp_digits(unsigned int hi, unsigned int lo, char *digits, int *decpt, int *neg) __asm__("DTOADIG");

/* Round a digit string to keep digits, half up; returns the new count
 * and moves the point when a carry runs off the front. */
int f77_round_digits(char *digits, int nd, int keep, int *decpt) __asm__("DTOARND");

/* E editing: nsig significant digits (zero-padded) into mant, the
 * value being 0.mant * 10^(returned exponent). */
int f77_fmt_e_w(unsigned int hi, unsigned int lo, int nsig, char *mant, int *neg) __asm__("DTOAEW");
int f77_fmt_e(double v, int nsig, char *mant, int *neg) __asm__("DTOAE");

/* F editing: [-]iii.fff with d decimals into out (at least 300 bytes). */
void f77_fmt_f_w(unsigned int hi, unsigned int lo, int d, char *out) __asm__("DTOAFW");
void f77_fmt_f(double v, int d, char *out) __asm__("DTOAF");

/* The double with these two words. */
double f77_hfp_make(unsigned int hi, unsigned int lo) __asm__("DTOAMAKE");

#endif
