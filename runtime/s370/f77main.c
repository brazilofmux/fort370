/* f77main.c -- the C side of a fort370 program: libc370's startup
 * (crt0) calls __start here, which calls this main, which calls the
 * Fortran main program; its END returns here and exit flushes the
 * units.  STOP calls exit itself. */
#include <stdio.h>
#include <clibgrt.h>
#include <clibcrt.h>

extern void F77MAIN(void);
int main(void) { F77MAIN(); return 0; }

/* The C stack libc370's startup allocates (its weak external @@STKLEN;
 * the default is 256K, all of it in the GO step's region).  Only the
 * runtime runs on it: a Fortran unit's save area and locals are static,
 * and a CALL passes the stack pointer along unchanged, so the depth is
 * the runtime's own and does not grow with the program.  Painted and
 * measured over the FCVS on MVS (2026-10-15), the deepest any program
 * reached was 9.3K, most 1.5K-4.5K; nothing checks for overflow, so
 * 64K leaves a wide margin and gives 192K back to the region. */
int __stklen = 65536;

/* In place of libc370's __start (@@START), which opened SYSPRINT,
 * SYSTERM and SYSIN before main, read SYSENV and set the time zone.
 * A Fortran program has no use for the environment or the time zone,
 * and its units are its own DDs, FTnnF001; the standard streams stand
 * in only for a unit 5 or 6 without a DD, unit 0, and the runtime's
 * messages, so they are opened when first used (f77std.h).  Opened
 * here, a DD without a block size cost each one a 32K buffer, 164K in
 * all, whether the program used it or not.  TSO's parameter list is
 * still recognised, since the streams open differently there; the
 * PARM is not used. */
int __start(char *p, char *pgmname, int tsojbid, void **pgmr1) {
    CLIBGRT *grt;
    int parmlen;
    grt = __grtget();
    parmlen = ((unsigned int)(unsigned char)p[0] << 8) | (unsigned int)(unsigned char)p[1];
    if (grt && parmlen > 0 && p[2] == 0) grt->grtflag1 |= GRTFLAG1_TSO;
    (void)pgmname; (void)tsojbid; (void)pgmr1;
    __exit(main());
    return 0;
}

int f77_nofile __asm__("F77@NOFL");
int f77_nofile;

/* libc370's own anchors, as <stdio.h> names them: (*__gtout()) is
 * stdout.  Opened as libc370's startup opened them, and closed by its
 * exit with the other files. */
FILE **f77_gtout(void) __asm__("F77@SOUT");
FILE **f77_gtout(void) {
    FILE **f = __gtout();
    if (f && !*f) *f = fopen("*SYSPRINT", "w");
    return f;
}
FILE **f77_gterr(void) __asm__("F77@SERR");
FILE **f77_gterr(void) {
    FILE **f = __gterr();
    if (f && !*f) *f = fopen("*SYSTERM", "w");
    if (f && !*f) f = f77_gtout();          /* no SYSTERM: the messages go to SYSPRINT */
    return f;
}
FILE **f77_gtin(void) __asm__("F77@SIN");
FILE **f77_gtin(void) {
    FILE **f = __gtin();
    if (f && !*f) *f = fopen("dd:SYSIN", "r");
    if (f && !*f) *f = fopen("'NULLFILE'", "r");
    return f;
}
/* Flush the ones that are open, opening none. */
void f77_flush_std(void) __asm__("F77@SFLU");
void f77_flush_std(void) {
    FILE **f;
    f = __gtout(); if (f && *f) fflush(*f);
    f = __gterr(); if (f && *f) fflush(*f);
}
