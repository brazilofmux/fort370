/* f77msum.h -- what f77math.c and f77mz.c share: the HFP format, and
 * sums rounded once, in extended precision (M@XSUM, f77xsum.asm). */
#ifndef F77MSUM_H
#define F77MSUM_H

typedef union { double d; unsigned int w[2]; } Hfp;   /* big-endian: w[0] has the sign and exponent */
typedef union { unsigned int w[2]; double d; } Hw;    /* the same, initialisable from its words: constants in storage, not calls */

static double hfp_make(unsigned int hi, unsigned int lo) { Hfp u; u.w[0] = hi; u.w[1] = lo; return u.d; }
#define hfp_is_zero(x) ((x) == 0.0)                     /* a zero fraction compares equal, whatever its exponent */

#define m_fabs(x) ((x) < 0.0 ? -(x) : (x))               /* x a plain variable */

/* --- sums rounded once ------------------------------------------ */

/* Most of what follows is the same device: the answer is written as a
 * few terms whose sum is nearly exact -- a leading part held exactly,
 * products of two longs (exact in extended), and small corrections
 * whose own errors are far below the answer's last place -- and the
 * terms are added in extended precision and rounded once, to nearest
 * (M@XSUM, f77xsum.asm).  HFP's truncation and its wobble (a leading
 * hex digit of 1 keeps three bits fewer than one of 8) are then paid
 * once, as half a unit, instead of at every step. */

#define SN 20                            /* entries at most; f77xsum.asm knows the layout */

/* the sum of a[i] b[i] 2^s[i], times 16^q */
typedef struct { double a[SN]; double b[SN]; int s[SN]; int n; int q; } Sum;

double m_xsum(Sum *t, double *res) __asm__("M@XSUM");

/* an entry a b 2^s, and a plain one v 2^s: macros, cc370's calls being
 * dear; t is a Sum's address, evaluated more than once */
#define SUM_MUL(t, a_, b_, s_) ((t)->a[(t)->n] = (a_), (t)->b[(t)->n] = (b_), (t)->s[(t)->n] = (s_), (t)->n = (t)->n + 1)
#define SUM_ADD(t, v_, s_) SUM_MUL(t, v_, 1.0, s_)

/* x 16^q, exactly, or the largest magnitude, or zero */
static double m_hex(double x, int q) {
    Hfp u;
    int c;
    if (q == 0 || hfp_is_zero(x)) return x;
    u.d = x;
    c = (int)((u.w[0] >> 24) & 0x7F) + q;
    if (c > 127) { u.w[0] = (u.w[0] & 0x80000000u) | 0x7FFFFFFFu; u.w[1] = 0xFFFFFFFFu; return u.d; }
    if (c < 0) return 0.0;
    u.w[0] = (u.w[0] & 0x80FFFFFFu) | ((unsigned int)c << 24);
    return u.d;
}

/* the sum, rounded; *res (if res) what the rounding left */
static double sum_round(Sum *t, double *res) {
    double r;
    double rr;
    r = m_xsum(t, res ? &rr : 0);
    if (t->q == 0) { if (res) *res = rr; return r; }
    if (res) *res = m_hex(rr, t->q);
    return m_hex(r, t->q);
}

/* the entries so far by 2^k: k mod 4 into their powers of two, the
 * rest as the sum's 16^q -- so that each entry's stays small */
static void sum_frame(Sum *t, int k) {
    int r;
    int i;
    r = k & 3;
    for (i = 0; i < t->n; i++) t->s[i] = t->s[i] + r;
    t->q = (k - r) / 4;
}

/* (the sum t) / (b + bl) as qh + ql: the quotient, and the remainder's
 * own quotient (t is extended); b and bl are plain, t in its frame */
static void m_ddiv(Sum *t, double b, double bl, double *qh, double *ql) {
    double q;
    q = sum_round(t, 0) / b;
    SUM_MUL(t, -q, b, -4 * t->q);
    SUM_MUL(t, -q, bl, -4 * t->q);
    *qh = q;
    *ql = sum_round(t, 0) / b;
}

#endif
