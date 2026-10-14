* main
F77MAIN  CSECT
         USING *,15
         B     L00015
         DC    AL1(7),CL7'F77MAIN'
L00015   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00016
L00017   DC    A(S00000)
L00016   L     15,L00017
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00002   DS    0H
L00003   DS    0H
L00005   DS    0H
L00006   DS    0H
L00008   DS    0H
L00009   DS    0H
         LH    4,C00018
         LA    5,0
         LA    2,3
L00010   DS    0H
L00012   DS    0H
         BXH   2,4,L00010
L00011   DS    0H
         LA    0,6
         ST    0,P00019+0
         L     0,C00020
         ST    0,P00019+4
         LA    1,P00019
         L     15,C00021
         BALR  14,15
         L     15,C00022
         BALR  14,15
L00013   DS    0H
         B     L00014
L00004   DS    0H
L00007   DS    0H
L00014   DS    0H
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
P00019   DS    2F
C00020   DC    A(Q00001)
C00021   DC    V(F77WRBEG)
C00022   DC    V(F77WREND)
C00018   DC    H'-1'
Q00001   DC    C'(1X,''>UNDEFINT OK'')'
         END
