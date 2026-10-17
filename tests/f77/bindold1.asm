* PFILL
PFILL    CSECT
         USING *,15
         B     L00008
         DC    AL1(5),CL7'PFILL'
L00008   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00009
L00010   DC    A(S00000)
L00009   L     15,L00010
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00006   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         LA    0,36
         X     0,C00011
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00012
         LER   0,0
         STE   0,0(,2)
         LA    0,T00005
         ST    0,P00013+0
         LA    0,7
         ST    0,P00013+4
         L     0,C00014
         ST    0,P00013+8
         LA    0,7
         ST    0,P00013+12
         LA    1,P00013
         L     15,C00015
         BALR  14,15
         LA    0,T00002
         ST    0,P00013+0
         LA    0,7
         ST    0,P00013+4
         LA    0,T00005
         ST    0,P00013+8
         LA    0,7
         ST    0,P00013+12
         LA    1,P00013
         L     15,C00015
         BALR  14,15
         LA    0,T00003
         ST    0,P00013+0
         LA    0,7
         ST    0,P00013+4
         LA    0,T00002
         ST    0,P00013+8
         LA    0,7
         ST    0,P00013+12
         LA    1,P00013
         L     15,C00015
         BALR  14,15
         LA    0,T00004
         ST    0,P00013+0
         LA    0,7
         ST    0,P00013+4
         LA    0,T00003
         ST    0,P00013+8
         LA    0,7
         ST    0,P00013+12
         LA    1,P00013
         L     15,C00015
         BALR  14,15
         L     14,C00017
         MVC   0(4,14),C00016
         L     14,C00018
         MVC   0(4,14),C00016
         L     14,C00019
         MVC   0(4,14),C00016
         L     14,C00020
         MVC   0(4,14),C00016
         LA    0,0
L00007   DS    0H
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
T00002   DS    XL12
         DS    XL4
T00003   DS    XL12
         DS    XL4
T00004   DS    XL12
         DS    XL4
T00005   DS    XL76
         DS    XL4
P00013   DS    4F
C00012   DC    X'4E00000080000000'
C00011   DC    F'-2147483648'
C00014   DC    A(Q00001)
C00015   DC    V(F77STRCP)
C00016   DC    X'41100000'
C00017   DC    A(BLK)
C00018   DC    A(BLK+4)
C00019   DC    A(BLK+8)
C00020   DC    A(BLK+12)
Q00001   DC    C'ABCDEFG'
* main
F77MAIN  CSECT
         USING *,15
         B     L00032
         DC    AL1(7),CL7'F77MAIN'
L00032   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00033
L00034   DC    A(S00021)
L00033   L     15,L00034
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00021,13
         ST    1,S00021+72
L00023   DS    0H
         LA    0,T00022
         ST    0,P00035+0
         OI    P00035+0,X'80'
         LA    1,P00035
         L     15,C00036
         BALR  14,15
L00024   DS    0H
L00025   DS    0H
L00027   DS    0H
         LE    0,C00037
         CE    0,T00022
         LA    3,1
         BC    8,L00038
         SR    3,3
L00038   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00039
         SR    2,2
L00039   DS    0H
         LTR   2,2
         BC    7,L00028
L00029   DS    0H
         LA    0,0
         ST    0,P00035+0
         LA    1,P00035
         L     15,C00040
         BALR  14,15
         B     L00031
L00026   DS    0H
L00028   DS    0H
         LA    0,2
         ST    0,P00035+0
         LA    1,P00035
         L     15,C00040
         BALR  14,15
         B     L00031
L00030   DS    0H
L00031   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00021   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00022   DS    XL16
P00035   DS    1F
         DS    XL4
C00036   DC    V(PFILL)
C00037   DC    X'42240000'
C00040   DC    V(EXIT)
* BUMP
BUMP     CSECT
         USING *,15
         B     L00044
         DC    AL1(4),CL7'BUMP'
L00044   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00045
L00046   DC    A(S00041)
L00045   L     15,L00046
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00041,13
         ST    1,S00041+72
L00042   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         A     2,C00047
         ST    2,0(,3)
         LA    0,0
L00043   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00041   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00047   DC    F'1'
BLK      CSECT
         DS    0D
         DS    XL16
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
