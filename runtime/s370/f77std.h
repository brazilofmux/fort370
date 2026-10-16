/* f77std.h -- the standard streams, for the runtime (f77rt.c, f77rec.c)
 * and FORT370 itself (src/f77.c).  libc370 opens SYSPRINT, SYSTERM and
 * SYSIN when they are first used (2.16.0, libc370#564); before, its
 * startup opened all three ahead of main, each with a 32K buffer when
 * its DD gave no block size.  So naming stdout, stderr or stdin opens
 * that stream, and what only stands in for a stream, or only flushes or
 * compares one, reads libc370's slot for it instead (<mvs/crt.h>, as
 * libc370's own code does).  F77_NOFILE stands in where a stream is
 * needed but never read or written: an internal file, a direct-access
 * unit.  Static: each file that includes it has its own copy. */
#ifndef F77STD_H
#define F77STD_H

#include <mvs/crt.h>

/* Flush the ones that are open, opening none. */
static void f77_flush_std(void) {
    CLIBGRT *g = __grtget();
    if (!g) return;
    if (g->grtout) fflush((FILE *)g->grtout);
    if (g->grterr) fflush((FILE *)g->grterr);
}
/* Is fp the standard input, without opening it? */
static int f77_is_stdin(FILE *fp) {
    CLIBGRT *g = __grtget();
    return g && g->grtin && (FILE *)g->grtin == fp;
}
static int f77_nofile;
#define F77_NOFILE ((FILE *)&f77_nofile)

#endif
