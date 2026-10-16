/* f77start.c -- FORT370's own __start, in place of libc370's (@@START).
 *
 * libc370's opened SYSPRINT, SYSTERM and SYSIN before main, each with
 * a 32K buffer when its DD gave no block size, in the region the
 * compiler's tables need.  The compiler reads SYSIN and writes
 * SYSPUNCH; SYSTERM has its messages, when there are any, and SYSPRINT
 * nothing.  So the streams are opened when first used
 * (runtime/s370/f77std.h, which f77.c includes).  As libc370's did,
 * this splits the PARM into arguments (FORT370 takes the source and
 * the output as PARM='in out', which a job may use instead of SYSIN and
 * SYSPUNCH), recognises TSO's parameter list, and reads SYSENV for
 * getenv; the time zone the compiler never needs. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <clibgrt.h>
#include <clibcrt.h>

extern int main(int argc, char **argv);
#include <clibenv.h>

#define F77_MAXARG 8

int __start(char *p, char *pgmname, int tsojbid, void **pgmr1) {
    CLIBGRT *grt;
    char buf[312];
    char *argv[F77_MAXARG + 1];
    char *q;
    int len, tso, proglen, argc, i;
    grt = __grtget();
    len = ((unsigned int)(unsigned char)p[0] << 8) | (unsigned int)(unsigned char)p[1];
    tso = len > 0 && p[2] == 0;
    proglen = tso ? (unsigned char)p[3] : 0;
    if (grt && tso) grt->grtflag1 |= GRTFLAG1_TSO;
    if (tso) len = len - 4;
    if (len < 0) len = 0;
    if (len > (int)sizeof buf - 1) len = (int)sizeof buf - 1;
    memset(buf, 0, sizeof buf);
    memcpy(buf, p + (tso ? 4 : 2), (size_t)len);
    q = buf + (tso ? proglen : 0);
    for (i = 0; i < 8 && pgmname[i] && pgmname[i] != ' '; i++) ;
    pgmname[i] = 0;
    argv[0] = pgmname;
    argc = 1;
    for (;;) {
        while (*q == ' ') q++;
        if (!*q || argc >= F77_MAXARG) break;
        argv[argc++] = q;
        while (*q && *q != ' ') q++;
        if (*q) *q++ = 0;
    }
    argv[argc] = 0;
    if (loadenv("dd:SYSENV")) loadenv("dd:ENVIRON");
    (void)tsojbid; (void)pgmr1;
    __exit(main(argc, argv));
    return 0;
}
