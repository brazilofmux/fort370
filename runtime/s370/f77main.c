/* f77main.c -- the C side of a fort370 program: libc370's startup
 * (@@CRT0) calls this main, which calls the Fortran main program; its
 * END returns here and exit flushes the units.  STOP calls exit
 * itself. */
extern void F77MAIN(void);
/* The SPIE exit for program interrupts (f77spie.asm), set first. */
extern void f77_spie(void) __asm__("F77SPIE");
extern char *f77e_stack;         /* where the C stack starts (f77err.c) */
int main(void) {
    char here;
    f77e_stack = &here;
    f77_spie();
    F77MAIN();
    return 0;
}

/* The C stack libc370's startup allocates (its weak external @@STKLEN;
 * the default is 256K, all of it in the GO step's region).  Only the
 * runtime runs on it: a Fortran unit's save area and locals are static,
 * and a CALL passes the stack pointer along unchanged, so the depth is
 * the runtime's own and does not grow with the program.  Painted and
 * measured over the FCVS on MVS (2026-10-15), the deepest any program
 * reached was 9.3K, most 1.5K-4.5K; nothing checks for overflow, so
 * 64K leaves a wide margin and gives 192K back to the region. */
int __stklen = 65536;
