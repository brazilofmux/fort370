* main
F77MAIN  CSECT
         USING *,15
         B     L00006
         DC    AL1(7),CL7'F77MAIN'
L00006   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00007
L00008   DC    A(S00000)
L00007   L     15,L00008
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00002   DS    0H
         LA    0,6
         ST    0,P00009+0
         L     0,C00010
         ST    0,P00009+4
         LA    1,P00009
         L     15,C00011
         BALR  14,15
         L     15,C00012
         BALR  14,15
L00003   DS    0H
         LA    0,1
         ST    0,P00009+0
         LA    1,P00009
         L     15,C00013
         BALR  14,15
         B     L00005
L00004   DS    0H
L00005   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00000   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00009   DS    2F
C00010   DC    A(Q00001)
C00011   DC    V(F77WRBEG)
C00012   DC    V(F77WREND)
C00013   DC    V(EXIT)
Q00001   DC    C'('' >STOPONE ENDS WITH RC=1'')'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
