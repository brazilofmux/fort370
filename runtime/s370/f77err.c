/* f77err.c -- FORTLIB's error monitor, for the errors a program
 * recovers from: the program interrupts f77spie.asm intercepts
 * (IHC207I-IHC209I), and the mathematical functions' arguments out of
 * their domains (f77mchk.c, IHC241I-IHC269I).  As FORTLIB keeps them, each error number has its
 * count: the first five are reported, each with STANDARD FIXUP TAKEN;
 * the tenth ends the program, IHC900I first, with return code 16; and
 * when the program ends, a summary of every error number counted.  Each
 * message is followed by a traceback, as FORTLIB's is.
 * The messages go to unit 6 between the program's own records, as
 * FORTLIB writes them, each line with its carriage control. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "f77dtoa.h"

#define F77E_LO    200
#define F77E_HI    310
#define F77E_PRINT 5             /* reported, of each error number */
#define F77E_STOP  10            /* the count that ends the program */

static int f77e_count[F77E_HI - F77E_LO + 1];
static int f77e_any;             /* an error counted: the summary is due */

/* Unit 6: the runtime's own stream for it (f77rt.c), referred to
 * weakly so that a program with no I/O does not carry the I/O runtime
 * for its sake; without it, DD FT06F001 opened here, else SYSPRINT. */
FILE *fio_errfile(void) __asm__("F77ERRFL") __attribute__((weak));
static FILE *f77e_own;
static FILE *f77e_file(void) {
    if (fio_errfile) return fio_errfile();
    if (!f77e_own) f77e_own = fopen("dd:FT06F001", "w");
    if (!f77e_own) f77e_own = stdout;
    return f77e_own;
}

/* The summary, when the program ends having counted any error: at
 * exit, or from the runtime's fatal-error exit before it closes the
 * units.  Once. */
void f77e_finish(void) __asm__("F77EFIN");
void f77e_finish(void) {
    int n;
    FILE *f;
    if (f77e_any != 1) return;
    f77e_any = 2;
    f = f77e_file();
    fputs("1SUMMARY OF ERRORS FOR THIS JOB   ERROR NUMBER   NUMBER OF ERRORS\n", f);
    for (n = F77E_HI; n >= F77E_LO; n--)
        if (f77e_count[n - F77E_LO])
            fprintf(f, "0%34s%3d%15d\n", "", n, f77e_count[n - F77E_LO]);
    fflush(f);
}

/* The C stack: main's frame (f77main.c) and the __stklen bytes above
 * it, where the runtime's frames are.  A Fortran unit's save area is
 * static, in the load module, never here. */
char *f77e_stack;
extern int __stklen;

/* Count an error of number n.  0: carry on silently; 1: report it
 * and take the fixup; 2: report it, and the program ends after
 * (f77e_end). */
static int f77e_note(int n) {
    int c;
    if (n < F77E_LO || n > F77E_HI) return 1;
    if (!f77e_any) { f77e_any = 1; atexit(f77e_finish); }
    c = ++f77e_count[n - F77E_LO];
    if (c >= F77E_STOP) {
        fprintf(f77e_file(), "0IHC900I EXECUTION TERMINATING DUE TO ERROR COUNT FOR ERROR NUMBER %4d\n", n);
        return 2;
    }
    return c <= F77E_PRINT;
}

/* The traceback after a message, FORTLIB's: from the save area sa of
 * the routine at fault, each routine back to the main program, with
 * the registers it was called with -- R14, the return into its
 * caller, R15, its entry point, R0 and R1 -- as its caller's save area
 * holds them (its own, at +4, points to that one), and the routine's
 * name from the identifier at its entry point, B around a length and
 * the name (Fortran's units and cc370's functions both have it).  The
 * runtime's own routines are left out of it, a line before the first
 * routine a program calls.  Every address is checked before it is
 * read: a wrong one ends the traceback, not the program. */
static int f77e_okp(unsigned a) { return a != 0 && (a & 3) == 0 && a < 0x01000000u; }

static int f77e_name(unsigned ep, char *nm) {
    const unsigned char *e = (const unsigned char *)ep;
    int n;
    int i;
    if (ep == 0 || (ep & 1) || ep >= 0x01000000u) return 0;
    if (e[0] != 0x47 || e[1] != 0xF0 || (e[2] & 0xF0) != 0xF0) return 0;
    n = e[4];
    if (n < 1 || n > 8) return 0;
    for (i = 0; i < n; i++) {
        int c = e[5 + i];
        if (!((c >= 0xC1 && c <= 0xC9) || (c >= 0xD1 && c <= 0xD9) || (c >= 0xE2 && c <= 0xE9) ||
              (c >= 0xF0 && c <= 0xF9) || c == 0x7C || c == 0x7B || c == 0x5B)) return 0;
        nm[i] = (char)c;
    }
    nm[n] = 0;
    return 1;
}

/* the runtime's own: the error monitor, the checks, the cores */
static int f77e_inner(const char *nm) {
    return (nm[0] == 'M' && nm[1] == '@') || strncmp(nm, "F77E", 4) == 0 || strcmp(nm, "F77PINT") == 0;
}

/* A routine of the runtime's own, not the program's (an I/O error's
 * traceback, inner 2, begins at the last of them, the one the program
 * called, as FORTLIB's begins at IBCOM). */
static int f77e_rt(const char *nm) {
    return (strncmp(nm, "F77", 3) == 0 && strcmp(nm, "F77MAIN") != 0) || nm[0] == '@' ||
           nm[0] == '#' || (nm[0] == 'M' && nm[1] == '@');
}

/* The name of the routine that called the one whose save area is up. */
static int f77e_caller(unsigned *up, char *nm) {
    if (!f77e_okp(up[1])) return 0;
    return f77e_name(((unsigned *)up[1])[4] & 0x00FFFFFFu, nm);
}

static void f77e_trace(unsigned sa, int inner) {
    FILE *f = f77e_file();
    unsigned main_ep = 0;
    unsigned ep = 0;
    int depth;
    fputs("0TRACEBACK  ROUTINE  CALLED FROM ISN   REG.  14   REG.  15   REG.   0   REG.   1\n", f);
    for (depth = 0; depth < 40 && f77e_okp(sa); depth++) {
        unsigned *own = (unsigned *)sa;
        unsigned *up;
        char nm[9];
        int lib;
        if (!f77e_okp(own[1])) break;
        up = (unsigned *)own[1];
        ep = up[4] & 0x00FFFFFFu;
        if (!f77e_name(ep, nm)) break;
        if (inner == 2) {
            char cn[9];
            if (f77e_rt(nm) && f77e_caller(up, cn) && f77e_rt(cn)) { sa = own[1]; continue; }
            inner = 0;
        }
        if (!(inner && f77e_inner(nm))) {
            inner = 0;
            lib = f77e_stack && (char *)sa >= f77e_stack && (char *)sa < f77e_stack + __stklen;
            fprintf(f, "0%*s%-*s%08X   %08X   %08X   %08X\n", lib ? 11 : 14, "", lib ? 27 : 24, nm,
                    up[3], up[4], up[5], up[6]);
        }
        if (strcmp(nm, "F77MAIN") == 0) { main_ep = ep; break; }
        sa = own[1];
    }
    fprintf(f, "0ENTRY POINT=  %08X\n", main_ep ? main_ep : ep);
}

static void f77e_end(int how) {
    if (how == 2) exit(16);
    fputs("0STANDARD FIXUP TAKEN , EXECUTION CONTINUING\n", f77e_file());
}

/* Report error n, its message text (without the IHCnnnI, which this
 * adds), counted as the rest; the caller then takes its fixup. */
int f77_r13(void) __asm__("F77R13");       /* f77spie.asm */

void f77e_say(int n, const char *text) __asm__("F77ESAY");
void f77e_say(int n, const char *text) {
    int how = f77e_note(n);
    if (!how) return;
    fprintf(f77e_file(), "0IHC%dI %s\n", n, text);
    f77e_trace((unsigned)f77_r13(), 1);
    f77e_end(how);
}

/* An I/O error's: its traceback from the entry point the program
 * called (f77rec.c, DEFINE FILE's). */
void f77e_sayio(int n, const char *text) __asm__("F77ESYIO");
void f77e_sayio(int n, const char *text) {
    int how = f77e_note(n);
    if (!how) return;
    fprintf(f77e_file(), "0IHC%dI %s\n", n, text);
    f77e_trace((unsigned)f77_r13(), 2);
    f77e_end(how);
}

/* A number as FORTLIB's messages give it: REAL (r) as E14.7, DOUBLE
 * PRECISION as D23.16, the exponent's sign a blank when it is plus,
 * zero as 0.0 and blanks to the width. */
char *f77e_num(char *b, double v, int r) __asm__("F77ENUM");
char *f77e_num(char *b, double v, int r) {
    char mant[24];
    int neg;
    int e;
    int nsig = r ? 7 : 16;
    if (v == 0.0) {
        sprintf(b, "%-*s", nsig + 7, " 0.0");
        return b;
    }
    e = f77_fmt_e(v, nsig, mant, &neg);
    sprintf(b, "%c0.%s%c%c%02d", neg ? '-' : ' ', mant, r ? 'E' : 'D', e < 0 ? '-' : ' ', e < 0 ? -e : e);
    return b;
}

/* A zero base and an exponent not positive, INTEGER (f77misc.c):
 * FIXPI's message, FRXPI's or FDXPI's, and zero. */
int f77e_ipow0(int n) __asm__("F77EIP0");
int f77e_ipow0(int n) {
    char t[80];
    sprintf(t, "FIXPI INTEGER BASE=0,INTEGER EXPONENT=%11d, LE 0", n);
    f77e_say(241, t);
    return 0;
}

double f77e_xpow0(int n, int dbl) __asm__("F77EXP0");
double f77e_xpow0(int n, int dbl) {
    char t[80];
    sprintf(t, "%s BASE=0.0, INTEGER EXPONENT=%11d, LE 0", dbl ? "FDXPI REAL*8" : "FRXPI REAL*4", n);
    f77e_say(dbl ? 243 : 242, t);
    return 0.0;
}

/* f77spie.asm's PIINFO */
struct f77pinfo {
    int code;                    /* the interrupt code */
    unsigned inst;               /* the instruction's address */
    unsigned psw[2];             /* the old PSW */
    unsigned reg[2];             /* its register, before the fixup */
    unsigned gr[16];             /* the registers at the exit */
    double fpr[4];
};

void f77_pint(struct f77pinfo *p) __asm__("F77PINT");
void f77_pint(struct f77pinfo *p) {
    int how;
    int n;
    const char *what;
    FILE *f;
    char *r13 = (char *)p->gr[13];
    /* An underflow in the runtime's own arithmetic -- converting a
     * small number, EXP of a large negative one -- is the zero it
     * would have been with underflow masked, and FORTLIB's library
     * says nothing of its own either.  An overflow or a divide check
     * there is the program's: its operands came from it. */
    if (p->code == 13 && f77e_stack && r13 >= f77e_stack && r13 < f77e_stack + __stklen)
        return;
    switch (p->code) {
    case 12: n = 207; what = "  OVERFLOW  "; break;
    case 13: n = 208; what = " UNDERFLOW  "; break;
    default: n = 209; what = "DIVIDE CHECK"; break;
    }
    how = f77e_note(n);
    if (!how) return;
    f = f77e_file();
    fprintf(f, "0IHC%dI IBCOM - PROGRAM INTERRUPT (P) - %s OLD PSW IS  %08X%08X",
            n, what, p->psw[0], p->psw[1]);
    if (p->code != 9) fprintf(f, " . REGISTER CONTAINED   %08X%08X", p->reg[0], p->reg[1]);
    fputc('\n', f);
    f77e_trace(p->gr[13], 0);
    f77e_end(how);
}
