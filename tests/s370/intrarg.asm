* main
F77MAIN  CSECT
         USING *,15
         B     L00007
         DC    AL1(7),CL7'F77MAIN'
L00007   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00008
L00009   DC    A(S00000)
L00008   L     15,L00009
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00003   DS    0H
L00004   DS    0H
         LA    1,P00010
         L     15,C00011
         BALR  14,15
         LA    1,P00012
         L     15,C00013
         BALR  14,15
         LA    1,P00014
         L     15,C00013
         BALR  14,15
         L     15,C00015
         BALR  14,15
         MVC   T00002(4),C00016
         LA    1,P00017
         L     15,C00018
         BALR  14,15
L00005   DS    0H
L00006   DS    0H
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
T00002   DS    XL16
P00010   DC    F'6'
         DC    A(Q00001)
P00012   DC    F'17'
P00014   DC    F'21'
P00017   DC    V(I#SQRT)
         DC    XL1'80',AL3(T00002)
C00011   DC    V(F77WRBEG)
C00013   DC    V(F77WRI)
C00015   DC    V(F77WREND)
C00016   DC    X'42310000'
C00018   DC    V(APPLY)
Q00001   DC    C'('' >V '',2I4)'
* SETOUT
SETOUT   CSECT
         USING *,15
         B     L00022
         DC    AL1(6),CL7'SETOUT'
L00022   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00023
L00024   DC    A(S00019)
L00023   L     15,L00024
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00019,13
         ST    1,S00019+72
L00020   DS    0H
         L     3,0(,1)
         L     2,4(,1)
         LA    2,0(,2)
         LA    15,17
         ST    15,0(,3)
         LA    15,21
         ST    15,0(,2)
         LA    0,0
L00021   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00019   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
* APPLY
APPLY    CSECT
         USING *,15
         B     L00030
         DC    AL1(5),CL7'APPLY'
L00030   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00031
L00032   DC    A(S00025)
L00031   L     15,L00032
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00025,13
         ST    1,S00025+72
L00027   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         LA    1,P00033
         L     15,C00034
         BALR  14,15
         LR    0,3
         ST    0,P00035+0
         OI    P00035+0,X'80'
         LA    1,P00035
         LR    15,4
         BALR  14,15
         STE   0,S00025+176
         LE    0,S00025+176
         STE   0,P00036+0
         LA    1,P00036
         L     15,C00037
         BALR  14,15
         L     15,C00038
         BALR  14,15
L00028   DS    0H
         LA    0,0
L00029   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00025   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
         DS    1D
P00033   DC    F'6'
         DC    A(Q00026)
P00035   DC    XL1'80',AL3(0)
         DS    F
P00036   DC    A(0)
         DS    XL4
C00034   DC    V(F77WRBEG)
C00037   DC    V(F77WRR)
C00038   DC    V(F77WREND)
Q00026   DC    C'('' >F '',F6.2)'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
