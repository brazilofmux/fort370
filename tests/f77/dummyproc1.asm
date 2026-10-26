* main
F77MAIN  CSECT
         USING *,15
         B     L00009
         DC    AL1(7),CL7'F77MAIN'
L00009   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00010
L00011   DC    A(S00000)
L00010   L     15,L00011
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00004   DS    0H
         MVC   T00001(4),C00012
         LA    1,P00013
         L     15,C00014
         BALR  14,15
         LE    2,C00015
         AER   2,0
         STE   2,S00000+224
L00005   DS    0H
         LA    1,P00016
         L     15,C00017
         BALR  14,15
         LE    0,S00000+224
         STE   0,P00018+0
         LA    1,P00018
         L     15,C00019
         BALR  14,15
         L     15,C00020
         BALR  14,15
         LH    15,C00021
         ST    15,T00002
         LA    1,P00022
         L     15,C00023
         BALR  14,15
         LR    2,0
         SLL   2,1
L00006   DS    0H
         LA    1,P00016
         L     15,C00017
         BALR  14,15
         LR    0,2
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00025
         BALR  14,15
         L     15,C00020
         BALR  14,15
         MVC   T00003(4),C00026
         LA    1,P00016
         L     15,C00017
         BALR  14,15
         LA    1,P00027
         L     15,C00014
         BALR  14,15
         STE   0,S00000+224
         LE    0,S00000+224
         STE   0,P00018+0
         LA    1,P00018
         L     15,C00019
         BALR  14,15
         L     15,C00020
         BALR  14,15
L00007   DS    0H
L00008   DS    0H
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
T00001   DS    XL12
         DS    XL4
T00002   DS    XL12
         DS    XL4
T00003   DS    XL12
         DS    XL4
         DS    1D
P00013   DC    XL1'80',AL3(T00001)
P00016   DC    F'6'
         DC    F'0'
         DS    F
P00018   DC    A(0)
P00022   DC    XL1'80',AL3(T00002)
P00024   DC    A(0)
P00027   DC    XL1'80',AL3(T00003)
C00012   DC    X'41300000'
C00014   DC    V(SQ)
C00015   DC    X'41100000'
C00017   DC    V(F77WRBEG)
C00019   DC    V(F77WRR)
C00020   DC    V(F77WREND)
C00023   DC    V(I#IABS)
C00025   DC    V(F77WRI)
C00026   DC    X'41200000'
C00021   DC    H'-7'
* SUB
SUB      CSECT
         USING *,15
         B     L00031
         DC    AL1(3),CL7'SUB'
L00031   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00032
L00033   DC    A(S00028)
L00032   L     15,L00033
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00028,13
         ST    1,S00028+72
L00029   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         L     2,8(,1)
         LA    2,0(,2)
         LR    0,3
         ST    0,P00034+0
         OI    P00034+0,X'80'
         LA    1,P00034
         LR    15,4
         BALR  14,15
         AE    0,C00035
         STE   0,0(,2)
         LA    0,0
L00030   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00028   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00034   DC    XL1'80',AL3(0)
         DS    XL4
C00035   DC    X'41100000'
* IAPPLY
IAPPLY   CSECT
         USING *,15
         B     L00039
         DC    AL1(6),CL7'IAPPLY'
L00039   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00040
L00041   DC    A(S00036)
L00040   L     15,L00041
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00036,13
         ST    1,S00036+72
L00037   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         LR    0,3
         ST    0,P00042+0
         OI    P00042+0,X'80'
         LA    1,P00042
         LR    15,4
         BALR  14,15
         LR    2,0
         SLL   2,1
         LR    0,2
L00038   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00036   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00042   DC    XL1'80',AL3(0)
         DS    XL4
* S2
S2       CSECT
         USING *,15
         B     L00046
         DC    AL1(2),CL7'S2'
L00046   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00047
L00048   DC    A(S00043)
L00047   L     15,L00048
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00043,13
         ST    1,S00043+72
L00044   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         LA    1,P00049
         L     15,C00050
         BALR  14,15
         LR    0,3
         ST    0,P00051+0
         OI    P00051+0,X'80'
         LA    1,P00051
         LR    15,4
         BALR  14,15
         STE   0,S00043+176
         LE    0,S00043+176
         STE   0,P00052+0
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         L     15,C00054
         BALR  14,15
         LA    0,0
L00045   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00043   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
         DS    1D
P00049   DC    F'6'
         DC    F'0'
P00051   DC    XL1'80',AL3(0)
         DS    F
P00052   DC    A(0)
         DS    XL4
C00050   DC    V(F77WRBEG)
C00053   DC    V(F77WRR)
C00054   DC    V(F77WREND)
* SQ
SQ       CSECT
         USING *,15
         B     L00058
         DC    AL1(2),CL7'SQ'
L00058   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00059
L00060   DC    A(S00055)
L00059   L     15,L00060
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00055,13
         ST    1,S00055+72
L00056   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         LE    0,0(,2)
         MER   0,0
L00057   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00055   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
