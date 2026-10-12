*
* f77ishim -- the INTEGER-valued specific intrinsics a program passes
* as actual arguments (F77 15.9.3), in Fortran's convention: R1 to a
* list of addresses, the result in R0.  The runtime's C functions
* could not be these: cc370 returns an integer in R15.  Nothing here
* calls anything, so no save area is needed; R14 is the return, R15
* and R0/R1 scratch, as the convention allows.  The floating-point
* ones stay in C (f77rt.c): both conventions give FPR0.
*
I#IABS   CSECT
         USING *,15
         L     15,0(,1)              address of the INTEGER
         L     0,0(,15)
         LPR   0,0
         BR    14
         DROP  15
I#ISIGN  CSECT
         USING *,15
         L     0,4(,1)               the sign's address
         L     0,0(,0)
         L     15,0(,1)
         L     15,0(,15)             the magnitude
         LTR   0,0
         BM    ISNEG
         LPR   0,15
         BR    14
ISNEG    LNR   0,15
         BR    14
         DROP  15
I#IDIM   CSECT
         USING *,15
         L     0,4(,1)
         L     0,0(,0)               b
         L     15,0(,1)
         L     15,0(,15)             a
         SR    15,0                  a - b
         LTR   0,15
         BP    IDIMP
         SR    0,0
IDIMP    BR    14
         DROP  15
I#MOD    CSECT
         USING *,15
         L     0,4(,1)
         L     0,0(,0)               b, kept in R15's place below
         LR    15,0
         L     0,0(,1)
         L     1,0(,0)               a
         LR    0,1
         SRDA  0,32                  the dividend pair R0:R1
         DR    0,15                  remainder in R0
         BR    14
         DROP  15
I#NINT   CSECT
         BALR  15,0
         USING *,15
         L     1,0(,1)               address of the REAL
         LE    0,0(,1)
         LTDR  0,0
         BM    NNEG
         AD    0,=D'0.5'
         B     NCVT
NNEG     SD    0,=D'0.5'
NCVT     AW    0,=X'4E00000000000000'    integer part as a fixed word
         STD   0,NTMP
         L     0,NTMP+4
         BR    14
NTMP     DS    D
         LTORG
         DROP  15
I#IDNINT CSECT
         BALR  15,0
         USING *,15
         L     1,0(,1)               address of the DOUBLE PRECISION
         LD    0,0(,1)
         LTDR  0,0
         BM    DNEG
         AD    0,=D'0.5'
         B     DCVT
DNEG     SD    0,=D'0.5'
DCVT     AW    0,=X'4E00000000000000'    integer part as a fixed word
         STD   0,DTMP
         L     0,DTMP+4
         BR    14
DTMP     DS    D
         LTORG
         DROP  15
         END
