/* f77err.c -- FORTLIB's error monitor, for the errors a program
 * recovers from: the program interrupts f77spie.asm intercepts
 * (IHC207I-IHC209I).  As FORTLIB keeps them, each error number has its
 * count: the first five are reported, each with STANDARD FIXUP TAKEN;
 * the tenth ends the program, IHC900I first, with return code 16; and
 * when the program ends, a summary of every error number counted.
 * The messages go to unit 6 between the program's own records, as
 * FORTLIB writes them, each line with its carriage control. */
#include <stdio.h>
#include <stdlib.h>

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

static void f77e_end(int how) {
    if (how == 2) exit(16);
    fputs("0STANDARD FIXUP TAKEN , EXECUTION CONTINUING\n", f77e_file());
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

/* The C stack: main's frame (f77main.c) and the __stklen bytes above
 * it, where the runtime's frames are.  A Fortran unit's save area is
 * static, in the load module, never here. */
char *f77e_stack;
extern int __stklen;

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
    f77e_end(how);
}
