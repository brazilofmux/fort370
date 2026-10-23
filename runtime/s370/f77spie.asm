*
* f77spie -- program interrupts recovered as FORTLIB recovers them.
* F77SPIE, called once from main (f77main.c), sets a SPIE exit for
* fixed-point divide (9), exponent overflow (12), exponent underflow
* (13) and floating-point divide (15).  As FORTLIB's SPIE does, it
* leaves fixed-point overflow, decimal overflow and significance
* masked off and exponent underflow on.
*
* The exit takes FORTLIB's standard fixup and asks F77PINT
* (f77err.c) to report it:
*   overflow    the result register gets the largest magnitude, with
*               the result's sign (and the low half of an extended
*               result the same);
*   underflow   the result register gets zero;
*   divide      nothing: the operation was suppressed, so the
*               dividend is still where the quotient would have gone
*               (1/0 is 1, as under FORTLIB).
* The interrupted program then resumes after the instruction.
*
* On entry R1 is the PIE (+4 the old PSW, BC format; +12 R14-R2 at
* the interrupt), R14 the return to the supervisor, which reloads
* R14-R2 from the PIE; R3-R13 are the program's and must come back as
* they were, and so must the floating-point registers but the one
* fixed.  The C function runs on the C stack: word 76 of every save
* area, Fortran's and C's, holds its next free byte (f77main.c).
* Not reentrant: one program, one task, and an interrupt in the exit
* itself abends.
*
F77SPIE  CSECT
         STM   14,12,12(13)
         LR    12,15
         USING F77SPIE,12
         LA    1,PICA
         SVC   14                    SPIE
         LM    14,12,12(13)
         SR    15,15
         BR    14
         DROP  12
*
PIEXIT   DS    0H
         USING PIEXIT,15
         STM   0,15,PIREGS           R3-R13 are the program's
         LR    12,15
         DROP  15
         USING PIEXIT,12
         MVC   PIPSW(8),4(1)
         XC    PIREG(8),PIREG
         L     2,PIPSW+4
         LA    2,0(,2)               where the program resumes
         SR    3,3
         IC    3,PIPSW+4
         SRL   3,6                   the instruction's length code
         SLL   3,1                   in bytes
         SR    2,3
         ST    2,PIINST              the instruction
         SR    4,4
         IC    4,PIPSW+3
         ST    4,PICODE              the interrupt code
         C     4,=F'9'
         BE    PICALL                fixed-point divide: no fixup
         SR    5,5
         IC    5,1(,2)
         N     5,=X'000000F0'        R1 of the instruction, for EX
         EX    5,STDX                its register, before the fixup
         C     4,=F'15'
         BE    PICALL                FP divide: the dividend stays
         SR    6,6
         IC    6,0(,2)               the operation code
         LA    7,XOPS
PIXOP    CLI   0(7),0
         BE    PIFIX                 not an extended operation
         CLM   6,1,0(7)
         BE    PIXFIX
         LA    7,1(,7)
         B     PIXOP
PIXFIX   LA    7,X'20'(,5)           extended: R1+2, the low half, too
         C     4,=F'13'
         BE    PIXZ
         TM    PIREG,X'80'
         BO    PIXN
         EX    7,LDXMAX
         B     PIFIX
PIXN     EX    7,LDXMAXN
         B     PIFIX
PIXZ     EX    7,LDZERO
PIFIX    C     4,=F'13'
         BE    PIUND
         TM    PIREG,X'80'
         BO    PIOVN
         EX    5,LDMAX               overflow: the largest, its sign
         B     PICALL
PIOVN    EX    5,LDMAXN
         B     PICALL
PIUND    EX    5,LDZERO              underflow: zero
*
PICALL   STD   0,PIFPR
         STD   2,PIFPR+8
         STD   4,PIFPR+16
         STD   6,PIFPR+24
         MVC   PISAVE+76(4),76(13)   the C stack's next free byte
         ST    13,PISAVE+4
         LA    13,PISAVE
         LA    1,PIPARM
         L     15,=V(F77PINT)
         BALR  14,15
         LD    0,PIFPR
         LD    2,PIFPR+8
         LD    4,PIFPR+16
         LD    6,PIFPR+24
         LM    0,15,PIREGS
         BR    14                    resume after the instruction
*
STDX     STD   0,PIREG
LDMAX    LD    0,MAXP
LDMAXN   LD    0,MAXN
LDXMAX   LD    0,XMAXP
LDXMAXN  LD    0,XMAXN
LDZERO   LD    0,ZERO
         LTORG
         DS    0D
MAXP     DC    X'7FFFFFFFFFFFFFFF'
MAXN     DC    X'FFFFFFFFFFFFFFFF'
XMAXP    DC    X'71FFFFFFFFFFFFFF'   the low half of the largest
XMAXN    DC    X'F1FFFFFFFFFFFFFF'
ZERO     DC    D'0'
* the extended operations: AXR SXR MXR MXDR MXD
XOPS     DC    X'3637262767',X'00'
         DS    0F
PICA     DC    X'02'                 the mask: exponent underflow on
         DC    AL3(PIEXIT)
         DC    X'004D'               interrupts 9, 12, 13, 15
PIPARM   DC    A(PIINFO)
* what F77PINT is given (struct f77pinfo in f77err.c)
         DS    0D
PIINFO   DS    0D
PICODE   DS    F                     the interrupt code
PIINST   DS    F                     the instruction's address
PIPSW    DS    2F                    the old PSW
PIREG    DS    D                     the register before the fixup
PIREGS   DS    16F                   R0-R15 at the exit
PIFPR    DS    4D
PISAVE   DS    20F
         END
