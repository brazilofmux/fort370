* main
F77MAIN  CSECT
         USING *,15
         B     L00034
         DC    AL1(7),CL7'F77MAIN'
L00034   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00035
L00036   DC    A(S00000)
L00035   L     15,L00036
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00025   DS    0H
         MVC   T00024(8),C00037
         MVC   T00024+8(8),C00038
         MVC   T00024+16(8),C00039
         MVC   T00024+24(8),C00040
         MVC   T00024+32(8),C00041
         LD    0,C00042
         LCDR  0,0
         STD   0,T00024+40
L00026   DS    0H
         LA    4,8
         LA    5,48
         LA    2,8
L00027   DS    0H
         LD    0,T00024-8(2)
         STD   0,S00000+232
         LA    0,6
         ST    0,P00043+0
         L     0,C00044
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         L     0,C00046
         ST    0,P00043+0
         LA    0,1
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00047
         BALR  14,15
         LD    0,S00000+232
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    0,6
         ST    0,P00043+0
         L     0,C00044
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         L     0,C00050
         ST    0,P00043+0
         LA    0,4
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00047
         BALR  14,15
         LD    0,S00000+232
         LPDR  0,0
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00051
         BALR  14,15
         STD   0,S00000+248
         LD    0,S00000+248
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    0,6
         ST    0,P00043+0
         L     0,C00044
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         L     0,C00052
         ST    0,P00043+0
         LA    0,3
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00047
         BALR  14,15
         LD    0,S00000+232
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00053
         BALR  14,15
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    0,6
         ST    0,P00043+0
         L     0,C00044
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         L     0,C00054
         ST    0,P00043+0
         LA    0,3
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00047
         BALR  14,15
         LD    0,S00000+232
         LPDR  0,0
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00055
         BALR  14,15
         STD   0,S00000+248
         LD    0,S00000+248
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    0,6
         ST    0,P00043+0
         L     0,C00044
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         L     0,C00056
         ST    0,P00043+0
         LA    0,5
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00047
         BALR  14,15
         LD    0,S00000+232
         LPDR  0,0
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00057
         BALR  14,15
         STD   0,S00000+248
         LD    0,S00000+248
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    0,6
         ST    0,P00043+0
         L     0,C00044
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         L     0,C00058
         ST    0,P00043+0
         LA    0,3
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00047
         BALR  14,15
         LD    0,S00000+232
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00059
         BALR  14,15
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    0,6
         ST    0,P00043+0
         L     0,C00044
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         L     0,C00060
         ST    0,P00043+0
         LA    0,3
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00047
         BALR  14,15
         LD    0,S00000+232
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00061
         BALR  14,15
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    0,6
         ST    0,P00043+0
         L     0,C00044
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         L     0,C00062
         ST    0,P00043+0
         LA    0,3
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00047
         BALR  14,15
         LD    0,S00000+232
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00063
         BALR  14,15
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    0,6
         ST    0,P00043+0
         L     0,C00044
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         L     0,C00064
         ST    0,P00043+0
         LA    0,4
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00047
         BALR  14,15
         LD    0,S00000+232
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00065
         BALR  14,15
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    0,6
         ST    0,P00043+0
         L     0,C00044
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         L     0,C00066
         ST    0,P00043+0
         LA    0,5
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00047
         BALR  14,15
         LD    0,S00000+232
         STD   0,P00043+0
         LD    0,C00067
         STD   0,P00043+8
         LA    1,P00043
         L     15,C00068
         BALR  14,15
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    0,6
         ST    0,P00043+0
         L     0,C00044
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         L     0,C00069
         ST    0,P00043+0
         LA    0,4
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00047
         BALR  14,15
         LD    0,S00000+232
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00070
         BALR  14,15
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    0,6
         ST    0,P00043+0
         L     0,C00044
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         L     0,C00071
         ST    0,P00043+0
         LA    0,4
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00047
         BALR  14,15
         LD    0,S00000+232
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00072
         BALR  14,15
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    0,6
         ST    0,P00043+0
         L     0,C00044
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         L     0,C00073
         ST    0,P00043+0
         LA    0,4
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00047
         BALR  14,15
         LD    0,S00000+232
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00074
         BALR  14,15
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    0,6
         ST    0,P00043+0
         L     0,C00044
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         L     0,C00075
         ST    0,P00043+0
         LA    0,3
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00047
         BALR  14,15
         LD    0,S00000+232
         LPDR  0,0
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00043+0
         LD    0,C00076
         STD   0,P00043+8
         LA    1,P00043
         L     15,C00077
         BALR  14,15
         STD   0,S00000+232
         LD    0,S00000+232
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
L00029   DS    0H
         BXLE  2,4,L00027
L00028   DS    0H
         LA    0,6
         ST    0,P00043+0
         L     0,C00044
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         L     0,C00078
         ST    0,P00043+0
         LA    0,4
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00047
         BALR  14,15
         LD    0,C00038
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00079
         BALR  14,15
         STD   0,S00000+232
         LD    0,S00000+232
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    0,6
         ST    0,P00043+0
         L     0,C00044
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         L     0,C00080
         ST    0,P00043+0
         LA    0,4
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00047
         BALR  14,15
         LD    0,C00038
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00081
         BALR  14,15
         STD   0,S00000+232
         LD    0,S00000+232
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    0,6
         ST    0,P00043+0
         L     0,C00044
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         L     0,C00082
         ST    0,P00043+0
         LA    0,4
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00047
         BALR  14,15
         LD    0,C00083
         LCDR  0,0
         STD   0,S00000+232
         LD    0,S00000+232
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00079
         BALR  14,15
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    0,6
         ST    0,P00043+0
         L     0,C00084
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         L     0,C00085
         ST    0,P00043+0
         LA    0,5
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00047
         BALR  14,15
         LE    0,C00086
         STE   0,P00043+0
         XC    P00043+4(4),P00043+4
         LA    1,P00043
         L     15,C00051
         BALR  14,15
         STE   0,S00000+232
         LE    0,S00000+232
         STE   0,P00043+0
         LA    1,P00043
         L     15,C00087
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    0,6
         ST    0,P00043+0
         L     0,C00084
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         L     0,C00088
         ST    0,P00043+0
         LA    0,4
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00047
         BALR  14,15
         LE    0,C00086
         STE   0,P00043+0
         XC    P00043+4(4),P00043+4
         LA    1,P00043
         L     15,C00059
         BALR  14,15
         STE   0,S00000+232
         LE    0,S00000+232
         STE   0,P00043+0
         LA    1,P00043
         L     15,C00087
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    0,6
         ST    0,P00043+0
         L     0,C00084
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         L     0,C00089
         ST    0,P00043+0
         LA    0,4
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00047
         BALR  14,15
         LE    0,C00086
         STE   0,P00043+0
         XC    P00043+4(4),P00043+4
         LA    1,P00043
         L     15,C00053
         BALR  14,15
         STE   0,S00000+232
         LE    0,S00000+232
         STE   0,P00043+0
         LA    1,P00043
         L     15,C00087
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    0,6
         ST    0,P00043+0
         L     0,C00084
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         L     0,C00090
         ST    0,P00043+0
         LA    0,4
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00047
         BALR  14,15
         LE    0,C00086
         STE   0,P00043+0
         XC    P00043+4(4),P00043+4
         LE    0,C00091
         STE   0,P00043+8
         XC    P00043+12(4),P00043+12
         LA    1,P00043
         L     15,C00077
         BALR  14,15
         STE   0,S00000+232
         LE    0,S00000+232
         STE   0,P00043+0
         LA    1,P00043
         L     15,C00087
         BALR  14,15
         L     15,C00049
         BALR  14,15
L00030   DS    0H
L00031   DS    0H
         LA    0,0
         ST    0,P00043+0
         LA    1,P00043
         L     15,C00092
         BALR  14,15
         B     L00033
L00032   DS    0H
L00033   DS    0H
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
T00024   DS    XL52
         DS    XL4
         DS    3D
P00043   DS    4F
C00037   DC    X'4120000000000000'
C00038   DC    X'4080000000000000'
C00039   DC    X'41A0000000000000'
C00040   DC    X'3E4189374BC6A7F0'
C00041   DC    X'427B74BC6A7EF9DB'
C00042   DC    X'4128000000000000'
C00067   DC    X'4130000000000000'
C00076   DC    X'4118000000000000'
C00083   DC    X'40E6666666666666'
C00044   DC    A(Q00001)
C00045   DC    V(F77WRBEG)
C00046   DC    A(Q00002)
C00047   DC    V(F77WRA)
C00048   DC    V(F77WRD)
C00049   DC    V(F77WREND)
C00050   DC    A(Q00003)
C00051   DC    V(SQRT)
C00052   DC    A(Q00004)
C00053   DC    V(EXP)
C00054   DC    A(Q00005)
C00055   DC    V(LOG)
C00056   DC    A(Q00006)
C00057   DC    V(LOG10)
C00058   DC    A(Q00007)
C00059   DC    V(SIN)
C00060   DC    A(Q00008)
C00061   DC    V(COS)
C00062   DC    A(Q00009)
C00063   DC    V(TAN)
C00064   DC    A(Q00010)
C00065   DC    V(ATAN)
C00066   DC    A(Q00011)
C00068   DC    V(ATAN2)
C00069   DC    A(Q00012)
C00070   DC    V(SINH)
C00071   DC    A(Q00013)
C00072   DC    V(COSH)
C00073   DC    A(Q00014)
C00074   DC    V(TANH)
C00075   DC    A(Q00015)
C00077   DC    V(POW)
C00078   DC    A(Q00016)
C00079   DC    V(ASIN)
C00080   DC    A(Q00017)
C00081   DC    V(ACOS)
C00082   DC    A(Q00018)
C00084   DC    A(Q00019)
C00085   DC    A(Q00020)
C00086   DC    X'41200000'
C00087   DC    V(F77WRR)
C00088   DC    A(Q00021)
C00089   DC    A(Q00022)
C00090   DC    A(Q00023)
C00091   DC    X'40800000'
C00092   DC    V(EXIT)
Q00001   DC    C'('' >'',A6,D25.17)'
Q00019   DC    C'('' >'',A6,E16.8)'
Q00002   DC    C'X'
Q00003   DC    C'SQRT'
Q00004   DC    C'EXP'
Q00005   DC    C'LOG'
Q00006   DC    C'LOG10'
Q00007   DC    C'SIN'
Q00008   DC    C'COS'
Q00009   DC    C'TAN'
Q00010   DC    C'ATAN'
Q00011   DC    C'ATAN2'
Q00012   DC    C'SINH'
Q00013   DC    C'COSH'
Q00014   DC    C'TANH'
Q00015   DC    C'POW'
Q00016   DC    C'ASIN'
Q00017   DC    C'ACOS'
Q00018   DC    C'ASIN'
Q00020   DC    C'RSQRT'
Q00021   DC    C'RSIN'
Q00022   DC    C'REXP'
Q00023   DC    C'RPOW'
         END
