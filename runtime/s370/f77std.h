/* f77std.h -- the standard streams opened on first use, for the
 * runtime (f77rt.c, f77rec.c) and for FORT370 itself (src/f77.c).
 * libc370's startup opened SYSPRINT, SYSTERM and SYSIN before main,
 * each with a 32K buffer when its DD gave no block size, SYSIN two:
 * 164K of an empty program's 412K.  Our own __start (f77main.c, and
 * src/f77start.c for the compiler) opens none of them; included after
 * <stdio.h>, this makes stdout, stderr and stdin open their data set
 * the first time they are used, as libc370's startup opened them, and
 * libc370's exit closes them with the other files.  F77_NOFILE stands
 * in where a stream is needed but never read or written (an internal
 * file, a direct-access unit).  Static: each file that includes it has
 * its own copy, a few instructions, and no external name. */
#ifndef F77STD_H
#define F77STD_H

static FILE **f77_gtout(void) {
    FILE **f = __gtout();
    if (f && !*f) *f = fopen("*SYSPRINT", "w");
    return f;
}
static FILE **f77_gterr(void) {
    FILE **f = __gterr();
    if (f && !*f) *f = fopen("*SYSTERM", "w");
    if (f && !*f) f = f77_gtout();          /* no SYSTERM: messages go to SYSPRINT */
    return f;
}
static FILE **f77_gtin(void) {
    FILE **f = __gtin();
    if (f && !*f) *f = fopen("dd:SYSIN", "r");
    if (f && !*f) *f = fopen("'NULLFILE'", "r");
    return f;
}
/* Flush the ones that are open, opening none. */
static void f77_flush_std(void) {
    FILE **f;
    f = __gtout(); if (f && *f) fflush(*f);
    f = __gterr(); if (f && *f) fflush(*f);
}
/* Is fp the standard input, without opening it? */
static int f77_is_stdin(FILE *fp) {
    FILE **f = __gtin();
    return f && *f && *f == fp;
}
static int f77_nofile;
#define F77_NOFILE ((FILE *)&f77_nofile)

#undef  stdout
#define stdout (*f77_gtout())
#undef  stderr
#define stderr (*f77_gterr())
#undef  stdin
#define stdin  (*f77_gtin())

#endif
