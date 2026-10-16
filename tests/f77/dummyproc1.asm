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
         LA    0,T00001
         ST    0,P00013+0
         OI    P00013+0,X'80'
         LA    1,P00013
         L     15,C00014
         BALR  14,15
         LE    2,C00015
         AER   2,0
         STE   2,S00000+224
L00005   DS    0H
         LA    0,6
         ST    0,P00013+0
         LA    0,0
         ST    0,P00013+4
         LA    1,P00013
         L     15,C00016
         BALR  14,15
         LE    0,S00000+224
         STE   0,P00013+0
         LA    1,P00013
         L     15,C00017
         BALR  14,15
         L     15,C00018
         BALR  14,15
         LH    15,C00019
         ST    15,T00002
         LA    0,T00002
         ST    0,P00013+0
         OI    P00013+0,X'80'
         LA    1,P00013
         L     15,C00020
         BALR  14,15
         LR    2,0
         SLL   2,1
L00006   DS    0H
         LA    0,6
         ST    0,P00013+0
         LA    0,0
         ST    0,P00013+4
         LA    1,P00013
         L     15,C00016
         BALR  14,15
         LR    0,2
         ST    0,P00013+0
         LA    1,P00013
         L     15,C00021
         BALR  14,15
         L     15,C00018
         BALR  14,15
         MVC   T00003(4),C00022
         LA    0,6
         ST    0,P00013+0
         LA    0,0
         ST    0,P00013+4
         LA    1,P00013
         L     15,C00016
         BALR  14,15
         LA    0,T00003
         ST    0,P00013+0
         OI    P00013+0,X'80'
         LA    1,P00013
         L     15,C00014
         BALR  14,15
         STE   0,S00000+224
         LE    0,S00000+224
         STE   0,P00013+0
         LA    1,P00013
         L     15,C00017
         BALR  14,15
         L     15,C00018
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
P00013   DS    2F
C00012   DC    X'41300000'
C00014   DC    V(SQ)
C00015   DC    X'41100000'
C00016   DC    V(F77WRBEG)
C00017   DC    V(F77WRR)
C00018   DC    V(F77WREND)
C00020   DC    V(I#IABS)
C00021   DC    V(F77WRI)
C00022   DC    X'41200000'
C00019   DC    H'-7'
* SUB
SUB      CSECT
         USING *,15
         B     L00026
         DC    AL1(3),CL7'SUB'
L00026   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00027
L00028   DC    A(S00023)
L00027   L     15,L00028
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00023,13
         ST    1,S00023+72
L00024   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         L     2,8(,1)
         LA    2,0(,2)
         LR    0,3
         ST    0,P00029+0
         OI    P00029+0,X'80'
         LA    1,P00029
         LR    15,4
         BALR  14,15
         AE    0,C00030
         STE   0,0(,2)
         LA    0,0
L00025   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00023   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00029   DS    1F
         DS    XL4
C00030   DC    X'41100000'
* IAPPLY
IAPPLY   CSECT
         USING *,15
         B     L00034
         DC    AL1(6),CL7'IAPPLY'
L00034   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00035
L00036   DC    A(S00031)
L00035   L     15,L00036
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00031,13
         ST    1,S00031+72
L00032   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         LR    0,3
         ST    0,P00037+0
         OI    P00037+0,X'80'
         LA    1,P00037
         LR    15,4
         BALR  14,15
         LR    2,0
         SLL   2,1
         LR    0,2
L00033   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00031   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00037   DS    1F
         DS    XL4
* S2
S2       CSECT
         USING *,15
         B     L00041
         DC    AL1(2),CL7'S2'
L00041   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00042
L00043   DC    A(S00038)
L00042   L     15,L00043
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00038,13
         ST    1,S00038+72
L00039   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         LA    0,6
         ST    0,P00044+0
         LA    0,0
         ST    0,P00044+4
         LA    1,P00044
         L     15,C00045
         BALR  14,15
         LR    0,3
         ST    0,P00044+0
         OI    P00044+0,X'80'
         LA    1,P00044
         LR    15,4
         BALR  14,15
         STE   0,S00038+176
         LE    0,S00038+176
         STE   0,P00044+0
         LA    1,P00044
         L     15,C00046
         BALR  14,15
         L     15,C00047
         BALR  14,15
         LA    0,0
L00040   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00038   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
         DS    1D
P00044   DS    2F
C00045   DC    V(F77WRBEG)
C00046   DC    V(F77WRR)
C00047   DC    V(F77WREND)
* SQ
SQ       CSECT
         USING *,15
         B     L00051
         DC    AL1(2),CL7'SQ'
L00051   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00052
L00053   DC    A(S00048)
L00052   L     15,L00053
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00048,13
         ST    1,S00048+72
L00049   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         LE    0,0(,2)
         MER   0,0
L00050   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00048   DS    0D
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
