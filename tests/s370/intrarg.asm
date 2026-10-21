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
         LA    0,6
         ST    0,P00010+0
         L     0,C00011
         ST    0,P00010+4
         LA    1,P00010
         L     15,C00012
         BALR  14,15
         LA    0,17
         ST    0,P00010+0
         LA    1,P00010
         L     15,C00013
         BALR  14,15
         LA    0,21
         ST    0,P00010+0
         LA    1,P00010
         L     15,C00013
         BALR  14,15
         L     15,C00014
         BALR  14,15
         MVC   T00002(4),C00015
         L     0,C00016
         ST    0,P00010+0
         LA    0,T00002
         ST    0,P00010+4
         OI    P00010+4,X'80'
         LA    1,P00010
         L     15,C00017
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
P00010   DS    2F
C00011   DC    A(Q00001)
C00012   DC    V(F77WRBEG)
C00013   DC    V(F77WRI)
C00014   DC    V(F77WREND)
C00015   DC    X'42310000'
C00016   DC    V(I#SQRT)
C00017   DC    V(APPLY)
Q00001   DC    C'('' >V '',2I4)'
* SETOUT
SETOUT   CSECT
         USING *,15
         B     L00021
         DC    AL1(6),CL7'SETOUT'
L00021   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00022
L00023   DC    A(S00018)
L00022   L     15,L00023
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00018,13
         ST    1,S00018+72
L00019   DS    0H
         L     3,0(,1)
         L     2,4(,1)
         LA    2,0(,2)
         LA    15,17
         ST    15,0(,3)
         LA    15,21
         ST    15,0(,2)
         LA    0,0
L00020   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00018   DS    0D
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
         B     L00029
         DC    AL1(5),CL7'APPLY'
L00029   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00030
L00031   DC    A(S00024)
L00030   L     15,L00031
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00024,13
         ST    1,S00024+72
L00026   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         LA    0,6
         ST    0,P00032+0
         L     0,C00033
         ST    0,P00032+4
         LA    1,P00032
         L     15,C00034
         BALR  14,15
         LR    0,3
         ST    0,P00032+0
         OI    P00032+0,X'80'
         LA    1,P00032
         LR    15,4
         BALR  14,15
         STE   0,S00024+176
         LE    0,S00024+176
         STE   0,P00032+0
         LA    1,P00032
         L     15,C00035
         BALR  14,15
         L     15,C00036
         BALR  14,15
L00027   DS    0H
         LA    0,0
L00028   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00024   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
         DS    1D
P00032   DS    2F
C00033   DC    A(Q00025)
C00034   DC    V(F77WRBEG)
C00035   DC    V(F77WRR)
C00036   DC    V(F77WREND)
Q00025   DC    C'('' >F '',F6.2)'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
