/* f77std.h -- the standard streams of a fort370 program, opened on
 * first use (f77main.c).  libc370's startup opened SYSPRINT, SYSTERM
 * and SYSIN before main, each with a 32K buffer when its DD gave no
 * block size: 164K of an empty program's 412K.  Included after
 * <stdio.h>, so that the runtime's stdout, stderr and stdin open their
 * data set the first time they are used.  F77_NOFILE stands in where a
 * stream is needed but never read or written (an internal file, a
 * direct-access unit). */
#ifndef F77STD_H
#define F77STD_H

FILE **f77_gtout(void) __asm__("F77@SOUT");
FILE **f77_gterr(void) __asm__("F77@SERR");
FILE **f77_gtin(void) __asm__("F77@SIN");
void f77_flush_std(void) __asm__("F77@SFLU");
extern int f77_nofile __asm__("F77@NOFL");

#undef  stdout
#define stdout (*f77_gtout())
#undef  stderr
#define stderr (*f77_gterr())
#undef  stdin
#define stdin  (*f77_gtin())
#define F77_NOFILE ((FILE *)&f77_nofile)

#endif
