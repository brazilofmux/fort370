/* f77main.c -- the C side of a fort370 program: libc370's startup
 * (crt0) calls this main, which calls the Fortran main program; its
 * END returns here and exit flushes the units.  STOP calls exit
 * itself. */
extern void F77MAIN(void);
int main(void) { F77MAIN(); return 0; }
