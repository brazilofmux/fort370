*
* f77cshim -- the COMPLEX-valued specific intrinsics a program passes
* as actual arguments (F77 15.9.3): CSQRT, CEXP, CLOG, CSIN, CCOS and
* CONJG, and COMPLEX*16's CDSQRT, CDEXP, CDLOG, CDSIN, CDCOS and
* DCONJG.  Fortran takes a COMPLEX function's value in FPR0, the real
* part, and FPR2, the imaginary, which a C function cannot return; so
* each I# entry here calls the runtime's C copy (f77rt.c, f77i_csqrt
* and the rest, external names C#...), which leaves the value in a
* work area, and loads the two registers from it.  Each entry saves
* the caller's registers, picks its C function and the size of a part
* (4, or 8 for COMPLEX*16) and goes on to the common part, addressed
* from R15, its own entry point; the C function is called with the
* caller's C stack (word 76 of its save area), as f77spie.asm does.
*
F77CSHIM CSECT
         ENTRY I#CSQRT
I#CSQRT  STM   14,12,12(13)
         L     2,VCSQRT-I#CSQRT(,15)       the C function
         LA    3,4                   the size of a part
         B     CSCOM-I#CSQRT(,15)
         ENTRY I#CEXP
I#CEXP   STM   14,12,12(13)
         L     2,VCEXP-I#CEXP(,15)       the C function
         LA    3,4                   the size of a part
         B     CSCOM-I#CEXP(,15)
         ENTRY I#CLOG
I#CLOG   STM   14,12,12(13)
         L     2,VCLOG-I#CLOG(,15)       the C function
         LA    3,4                   the size of a part
         B     CSCOM-I#CLOG(,15)
         ENTRY I#CSIN
I#CSIN   STM   14,12,12(13)
         L     2,VCSIN-I#CSIN(,15)       the C function
         LA    3,4                   the size of a part
         B     CSCOM-I#CSIN(,15)
         ENTRY I#CCOS
I#CCOS   STM   14,12,12(13)
         L     2,VCCOS-I#CCOS(,15)       the C function
         LA    3,4                   the size of a part
         B     CSCOM-I#CCOS(,15)
         ENTRY I#CONJG
I#CONJG  STM   14,12,12(13)
         L     2,VCONJG-I#CONJG(,15)       the C function
         LA    3,4                   the size of a part
         B     CSCOM-I#CONJG(,15)
         ENTRY I#CDSQRT
I#CDSQRT STM   14,12,12(13)
         L     2,VCDSQRT-I#CDSQRT(,15)       the C function
         LA    3,8                   the size of a part
         B     CSCOM-I#CDSQRT(,15)
         ENTRY I#CDEXP
I#CDEXP  STM   14,12,12(13)
         L     2,VCDEXP-I#CDEXP(,15)       the C function
         LA    3,8                   the size of a part
         B     CSCOM-I#CDEXP(,15)
         ENTRY I#CDLOG
I#CDLOG  STM   14,12,12(13)
         L     2,VCDLOG-I#CDLOG(,15)       the C function
         LA    3,8                   the size of a part
         B     CSCOM-I#CDLOG(,15)
         ENTRY I#CDSIN
I#CDSIN  STM   14,12,12(13)
         L     2,VCDSIN-I#CDSIN(,15)       the C function
         LA    3,8                   the size of a part
         B     CSCOM-I#CDSIN(,15)
         ENTRY I#CDCOS
I#CDCOS  STM   14,12,12(13)
         L     2,VCDCOS-I#CDCOS(,15)       the C function
         LA    3,8                   the size of a part
         B     CSCOM-I#CDCOS(,15)
         ENTRY I#DCONJG
I#DCONJG STM   14,12,12(13)
         L     2,VDCONJG-I#DCONJG(,15)       the C function
         LA    3,8                   the size of a part
         B     CSCOM-I#DCONJG(,15)
CSCOM    BALR  12,0
         USING *,12
         L     4,0(,1)               the argument's address
         ST    4,CSPL
         LA    4,CSOUT
         ST    4,CSPL+4
         OI    CSPL+4,X'80'
         MVC   CSSAVE+76(4),76(13)   the C stack's next free byte
         ST    13,CSSAVE+4
         LA    13,CSSAVE
         LA    1,CSPL
         LR    15,2
         BALR  14,15
         L     13,4(,13)
         C     3,=F'4'
         BNE   CSLONG
         LE    0,CSOUT               COMPLEX
         LE    2,CSOUT+4
         B     CSRET
CSLONG   LD    0,CSOUT               COMPLEX*16
         LD    2,CSOUT+8
CSRET    LM    14,12,12(13)
         BR    14
         LTORG
         DS    0D
CSOUT    DS    2D
CSSAVE   DS    20F
CSPL     DS    2F
VCSQRT   DC    V(C#CSQRT)
VCEXP    DC    V(C#CEXP)
VCLOG    DC    V(C#CLOG)
VCSIN    DC    V(C#CSIN)
VCCOS    DC    V(C#CCOS)
VCONJG   DC    V(C#CONJG)
VCDSQRT  DC    V(C#CDSQRT)
VCDEXP   DC    V(C#CDEXP)
VCDLOG   DC    V(C#CDLOG)
VCDSIN   DC    V(C#CDSIN)
VCDCOS   DC    V(C#CDCOS)
VDCONJG  DC    V(C#DCONJG)
         END
