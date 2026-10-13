* main
F77MAIN  CSECT
         USING *,15
         B     L00011
         DC    AL1(7),CL7'F77MAIN'
L00011   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00012
L00013   DC    A(S00000)
L00012   L     15,L00013
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00003   DS    0H
         LA    6,1
L00004   DS    0H
         LA    7,10
         LA    2,0
         LR    3,6
L00005   DS    0H
         LR    1,3
         MR    0,3
         LR    4,1
         AR    2,4
L00007   DS    0H
         BXLE  3,6,L00005
L00006   DS    0H
         LA    0,6
         ST    0,P00014+0
         L     0,C00015
         ST    0,P00014+4
         LA    1,P00014
         L     15,C00016
         BALR  14,15
         LR    0,2
         ST    0,P00014+0
         LA    1,P00014
         L     15,C00017
         BALR  14,15
         L     15,C00018
         BALR  14,15
L00008   DS    0H
         LA    0,6
         ST    0,P00014+0
         L     0,C00019
         ST    0,P00014+4
         LA    1,P00014
         L     15,C00016
         BALR  14,15
         LE    0,C00020
         STE   0,P00014+0
         XC    P00014+4(4),P00014+4
         LE    0,C00021
         STE   0,P00014+8
         XC    P00014+12(4),P00014+12
         LA    1,P00014
         L     15,C00022
         BALR  14,15
         LE    2,C00023
         MER   2,0
         STE   2,S00000+176
         LE    0,S00000+176
         STE   0,P00014+0
         LA    1,P00014
         L     15,C00024
         BALR  14,15
         L     15,C00018
         BALR  14,15
L00009   DS    0H
L00010   DS    0H
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
         DS    1D
P00014   DS    4F
C00015   DC    A(Q00001)
C00016   DC    V(F77WRBEG)
C00017   DC    V(F77WRI)
C00018   DC    V(F77WREND)
C00019   DC    A(Q00002)
C00020   DC    X'41100000'
C00021   DC    X'00000000'
C00022   DC    V(ATAN2)
C00023   DC    X'41200000'
C00024   DC    V(F77WRR)
Q00001   DC    C'(''SUM OF SQUARES = '',I5)'
Q00002   DC    C'(''PI = '',F10.6)'
         END
