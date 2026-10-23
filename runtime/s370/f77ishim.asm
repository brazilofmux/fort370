*
* f77ishim -- the INTEGER-valued specific intrinsics a program passes
* as actual arguments (F77 15.9.3), in Fortran's convention: R1 to a
* list of addresses, the result in R0.  The runtime's C functions
* could not be these: cc370 returns an integer in R15.  Nothing here
* calls anything; R14 is the return, R15 and R0/R1 scratch, as the
* convention allows, and R2-R3, where more are needed, are saved in
* the caller's save area.  The floating-point ones stay in C
* (f77rt.c): both conventions give FPR0.
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
         STM   2,3,28(13)            in the caller's save area
         L     2,0(,1)
         L     2,0(,2)               the magnitude
         L     3,4(,1)
         L     3,0(,3)               the sign
         LPR   0,2
         LTR   3,3
         BNM   ISPOS
         LNR   0,0
ISPOS    LM    2,3,28(13)
         BR    14
         DROP  15
I#IDIM   CSECT
         USING *,15
         STM   2,3,28(13)
         L     2,0(,1)
         L     2,0(,2)               a
         L     3,4(,1)
         L     3,0(,3)               b
         LR    0,2
         SR    0,3                   a - b
         BP    IDIMP
         SR    0,0
IDIMP    LM    2,3,28(13)
         BR    14
         DROP  15
I#MOD    CSECT
         USING *,15
         STM   2,3,28(13)
         L     2,0(,1)
         L     2,0(,2)               a
         L     3,4(,1)
         L     3,0(,3)               b
         LR    0,2
         SRDA  0,32                  the dividend pair R0:R1
         DR    0,3                   remainder in R0
         LM    2,3,28(13)
         BR    14
         DROP  15
I#NINT   CSECT
         BALR  15,0
         USING *,15
         L     1,0(,1)               address of the REAL
         SDR   0,0                   no low half left over
         LE    0,0(,1)
         LTDR  0,0
         BM    NNEG
         AD    0,=D'0.5'
         AW    0,=X'4E00000000000000'    integer part as a fixed word
         STD   0,NTMP
         L     0,NTMP+4
         BR    14
NNEG     SD    0,=D'0.5'
         AW    0,=X'4E00000000000000'    its magnitude, the sign apart
         STD   0,NTMP
         L     0,NTMP+4
         LCR   0,0
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
         AW    0,=X'4E00000000000000'    integer part as a fixed word
         STD   0,DTMP
         L     0,DTMP+4
         BR    14
DNEG     SD    0,=D'0.5'
         AW    0,=X'4E00000000000000'    its magnitude, the sign apart
         STD   0,DTMP
         L     0,DTMP+4
         LCR   0,0
         BR    14
DTMP     DS    D
         LTORG
         DROP  15
         END
