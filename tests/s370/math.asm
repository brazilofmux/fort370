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
         LA    1,P00043
         L     15,C00044
         BALR  14,15
         LA    1,P00045
         L     15,C00046
         BALR  14,15
         LD    0,S00000+232
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    1,P00043
         L     15,C00044
         BALR  14,15
         LA    1,P00050
         L     15,C00046
         BALR  14,15
         LD    0,S00000+232
         LPDR  0,0
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00051
         BALR  14,15
         STD   0,S00000+248
         LD    0,S00000+248
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    1,P00043
         L     15,C00044
         BALR  14,15
         LA    1,P00052
         L     15,C00046
         BALR  14,15
         LD    0,S00000+232
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00053
         BALR  14,15
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    1,P00043
         L     15,C00044
         BALR  14,15
         LA    1,P00054
         L     15,C00046
         BALR  14,15
         LD    0,S00000+232
         LPDR  0,0
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00055
         BALR  14,15
         STD   0,S00000+248
         LD    0,S00000+248
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    1,P00043
         L     15,C00044
         BALR  14,15
         LA    1,P00056
         L     15,C00046
         BALR  14,15
         LD    0,S00000+232
         LPDR  0,0
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00057
         BALR  14,15
         STD   0,S00000+248
         LD    0,S00000+248
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    1,P00043
         L     15,C00044
         BALR  14,15
         LA    1,P00058
         L     15,C00046
         BALR  14,15
         LD    0,S00000+232
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00059
         BALR  14,15
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    1,P00043
         L     15,C00044
         BALR  14,15
         LA    1,P00060
         L     15,C00046
         BALR  14,15
         LD    0,S00000+232
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00061
         BALR  14,15
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    1,P00043
         L     15,C00044
         BALR  14,15
         LA    1,P00062
         L     15,C00046
         BALR  14,15
         LD    0,S00000+232
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00063
         BALR  14,15
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    1,P00043
         L     15,C00044
         BALR  14,15
         LA    1,P00064
         L     15,C00046
         BALR  14,15
         LD    0,S00000+232
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00065
         BALR  14,15
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    1,P00043
         L     15,C00044
         BALR  14,15
         LA    1,P00066
         L     15,C00046
         BALR  14,15
         LD    0,S00000+232
         STD   0,P00067+0
         LD    0,C00068
         STD   0,P00067+8
         LA    1,P00067
         L     15,C00069
         BALR  14,15
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    1,P00043
         L     15,C00044
         BALR  14,15
         LA    1,P00070
         L     15,C00046
         BALR  14,15
         LD    0,S00000+232
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00071
         BALR  14,15
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    1,P00043
         L     15,C00044
         BALR  14,15
         LA    1,P00072
         L     15,C00046
         BALR  14,15
         LD    0,S00000+232
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00073
         BALR  14,15
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    1,P00043
         L     15,C00044
         BALR  14,15
         LA    1,P00074
         L     15,C00046
         BALR  14,15
         LD    0,S00000+232
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00075
         BALR  14,15
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    1,P00043
         L     15,C00044
         BALR  14,15
         LA    1,P00076
         L     15,C00046
         BALR  14,15
         LD    0,S00000+232
         LPDR  0,0
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00067+0
         LD    0,C00077
         STD   0,P00067+8
         LA    1,P00067
         L     15,C00078
         BALR  14,15
         STD   0,S00000+232
         LD    0,S00000+232
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
L00029   DS    0H
         BXLE  2,4,L00027
L00028   DS    0H
         LA    1,P00043
         L     15,C00044
         BALR  14,15
         LA    1,P00079
         L     15,C00046
         BALR  14,15
         LD    0,C00038
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00080
         BALR  14,15
         STD   0,S00000+232
         LD    0,S00000+232
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    1,P00043
         L     15,C00044
         BALR  14,15
         LA    1,P00081
         L     15,C00046
         BALR  14,15
         LD    0,C00038
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00082
         BALR  14,15
         STD   0,S00000+232
         LD    0,S00000+232
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    1,P00043
         L     15,C00044
         BALR  14,15
         LA    1,P00083
         L     15,C00046
         BALR  14,15
         LD    0,C00084
         LCDR  0,0
         STD   0,S00000+232
         LD    0,S00000+232
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00080
         BALR  14,15
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    1,P00085
         L     15,C00044
         BALR  14,15
         LA    1,P00086
         L     15,C00046
         BALR  14,15
         LE    0,C00088
         STE   0,P00087+0
         LA    1,P00087
         L     15,C00089
         BALR  14,15
         STE   0,S00000+232
         LE    0,S00000+232
         STE   0,P00090+0
         LA    1,P00090
         L     15,C00091
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    1,P00085
         L     15,C00044
         BALR  14,15
         LA    1,P00092
         L     15,C00046
         BALR  14,15
         LE    0,C00088
         STE   0,P00087+0
         LA    1,P00087
         L     15,C00093
         BALR  14,15
         STE   0,S00000+232
         LE    0,S00000+232
         STE   0,P00090+0
         LA    1,P00090
         L     15,C00091
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    1,P00085
         L     15,C00044
         BALR  14,15
         LA    1,P00094
         L     15,C00046
         BALR  14,15
         LE    0,C00088
         STE   0,P00087+0
         LA    1,P00087
         L     15,C00095
         BALR  14,15
         STE   0,S00000+232
         LE    0,S00000+232
         STE   0,P00090+0
         LA    1,P00090
         L     15,C00091
         BALR  14,15
         L     15,C00049
         BALR  14,15
         LA    1,P00085
         L     15,C00044
         BALR  14,15
         LA    1,P00096
         L     15,C00046
         BALR  14,15
         LE    0,C00088
         STE   0,P00097+0
         LE    0,C00098
         STE   0,P00097+8
         LA    1,P00097
         L     15,C00099
         BALR  14,15
         STE   0,S00000+232
         LE    0,S00000+232
         STE   0,P00090+0
         LA    1,P00090
         L     15,C00091
         BALR  14,15
         L     15,C00049
         BALR  14,15
L00030   DS    0H
L00031   DS    0H
         LA    1,P00100
         L     15,C00101
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
P00043   DC    F'6'
         DC    A(Q00001)
P00045   DC    A(Q00002)
         DC    F'1'
P00047   DC    A(0)
         DC    A(0)
P00050   DC    A(Q00003)
         DC    F'4'
P00052   DC    A(Q00004)
         DC    F'3'
P00054   DC    A(Q00005)
         DC    F'3'
P00056   DC    A(Q00006)
         DC    F'5'
P00058   DC    A(Q00007)
         DC    F'3'
P00060   DC    A(Q00008)
         DC    F'3'
P00062   DC    A(Q00009)
         DC    F'3'
P00064   DC    A(Q00010)
         DC    F'4'
P00066   DC    A(Q00011)
         DC    F'5'
P00067   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
P00070   DC    A(Q00012)
         DC    F'4'
P00072   DC    A(Q00013)
         DC    F'4'
P00074   DC    A(Q00014)
         DC    F'4'
P00076   DC    A(Q00015)
         DC    F'3'
P00079   DC    A(Q00016)
         DC    F'4'
P00081   DC    A(Q00017)
         DC    F'4'
P00083   DC    A(Q00018)
         DC    F'4'
P00085   DC    F'6'
         DC    A(Q00019)
P00086   DC    A(Q00020)
         DC    F'5'
P00087   DC    A(0)
         DC    F'0'
P00090   DC    A(0)
P00092   DC    A(Q00021)
         DC    F'4'
P00094   DC    A(Q00022)
         DC    F'4'
P00096   DC    A(Q00023)
         DC    F'4'
         DS    F
P00097   DC    A(0)
         DC    F'0'
         DC    A(0)
         DC    F'0'
P00100   DC    F'0'
         DS    XL4
C00037   DC    X'4120000000000000'
C00038   DC    X'4080000000000000'
C00039   DC    X'41A0000000000000'
C00040   DC    X'3E4189374BC6A7F0'
C00041   DC    X'427B74BC6A7EF9DB'
C00042   DC    X'4128000000000000'
C00068   DC    X'4130000000000000'
C00077   DC    X'4118000000000000'
C00084   DC    X'40E6666666666666'
C00044   DC    V(F77WRBEG)
C00046   DC    V(F77WRA)
C00048   DC    V(F77WRD)
C00049   DC    V(F77WREND)
C00051   DC    V(DSQRT)
C00053   DC    V(DEXP)
C00055   DC    V(DLOG)
C00057   DC    V(DLOG10)
C00059   DC    V(DSIN)
C00061   DC    V(DCOS)
C00063   DC    V(DTAN)
C00065   DC    V(DATAN)
C00069   DC    V(DATAN2)
C00071   DC    V(DSINH)
C00073   DC    V(DCOSH)
C00075   DC    V(DTANH)
C00078   DC    V(DPOW)
C00080   DC    V(DASIN)
C00082   DC    V(DACOS)
C00088   DC    X'41200000'
C00089   DC    V(SQRT)
C00091   DC    V(F77WRR)
C00093   DC    V(SIN)
C00095   DC    V(EXP)
C00098   DC    X'40800000'
C00099   DC    V(POW)
C00101   DC    V(EXIT)
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
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
