* main
F77MAIN  CSECT
         USING *,15
         B     L00045
         DC    AL1(7),CL7'F77MAIN'
L00045   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00046
L00047   DC    A(S00000)
L00046   L     15,L00047
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00025   DS    0H
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LA    1,P00050
         L     15,C00049
         BALR  14,15
         LA    1,P00051
         L     15,C00049
         BALR  14,15
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         LR    2,15
         C     2,C00054
         BC    7,L00027
L00026   DS    0H
         LA    1,P00055
         L     15,C00056
         BALR  14,15
         LA    1,P00057
         L     15,C00058
         BALR  14,15
         L     15,C00059
         BALR  14,15
L00027   DS    0H
         LA    1,P00060
         L     15,C00053
         BALR  14,15
         LR    2,15
         C     2,C00054
         BC    8,L00029
L00028   DS    0H
         LA    1,P00055
         L     15,C00056
         BALR  14,15
         LA    1,P00061
         L     15,C00058
         BALR  14,15
         L     15,C00059
         BALR  14,15
L00029   DS    0H
         LA    1,P00062
         L     15,C00049
         BALR  14,15
         LA    1,P00063
         L     15,C00053
         BALR  14,15
         LR    2,15
         C     2,C00054
         BC    13,L00031
L00030   DS    0H
         LA    1,P00055
         L     15,C00056
         BALR  14,15
         LA    1,P00064
         L     15,C00058
         BALR  14,15
         L     15,C00059
         BALR  14,15
L00031   DS    0H
         LA    1,P00065
         L     15,C00053
         BALR  14,15
         LR    2,15
         C     2,C00054
         BC    7,L00033
L00032   DS    0H
         LA    1,P00055
         L     15,C00056
         BALR  14,15
         LA    1,P00066
         L     15,C00058
         BALR  14,15
         L     15,C00059
         BALR  14,15
L00033   DS    0H
         LA    1,P00067
         L     15,C00053
         BALR  14,15
         LR    2,15
         C     2,C00054
         BC    11,L00035
L00034   DS    0H
         LA    1,P00055
         L     15,C00056
         BALR  14,15
         LA    1,P00068
         L     15,C00058
         BALR  14,15
         L     15,C00059
         BALR  14,15
L00035   DS    0H
         LA    1,P00069
         L     15,C00049
         BALR  14,15
         LA    1,P00070
         L     15,C00049
         BALR  14,15
         LA    1,P00071
         L     15,C00053
         BALR  14,15
         LR    2,15
         C     2,C00054
         BC    7,L00037
L00036   DS    0H
         LA    1,P00055
         L     15,C00056
         BALR  14,15
         LA    1,P00072
         L     15,C00058
         BALR  14,15
         L     15,C00059
         BALR  14,15
L00037   DS    0H
         LA    1,P00073
         L     15,C00053
         BALR  14,15
         LR    2,15
         C     2,C00054
         BC    8,L00039
L00038   DS    0H
         LA    1,P00055
         L     15,C00056
         BALR  14,15
         LA    1,P00074
         L     15,C00058
         BALR  14,15
         L     15,C00059
         BALR  14,15
L00039   DS    0H
         LA    1,P00075
         L     15,C00056
         BALR  14,15
         LA    1,P00076
         L     15,C00058
         BALR  14,15
         LA    1,P00077
         L     15,C00058
         BALR  14,15
         LA    1,P00078
         L     15,C00058
         BALR  14,15
         L     15,C00059
         BALR  14,15
         LA    1,P00079
         L     15,C00056
         BALR  14,15
         LA    1,P00080
         L     15,C00058
         BALR  14,15
         L     15,C00059
         BALR  14,15
L00040   DS    0H
L00041   DS    0H
L00042   DS    0H
         LA    1,P00081
         L     15,C00082
         BALR  14,15
         B     L00044
L00043   DS    0H
L00044   DS    0H
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
T00021   DS    XL8
T00022   DS    XL12
         DS    XL4
T00023   DS    XL12
         DS    XL4
T00024   DS    XL20
         DS    XL4
P00048   DC    A(T00022)
         DC    F'5'
         DC    A(Q00001)
         DC    F'3'
P00050   DC    A(T00021)
         DC    F'3'
         DC    A(Q00002)
         DC    F'3'
P00051   DC    A(T00022)
         DC    F'5'
         DC    A(T00021)
         DC    F'3'
P00052   DC    A(T00022)
         DC    F'5'
         DC    A(Q00003)
         DC    F'3'
P00055   DC    F'6'
         DC    A(Q00004)
P00057   DC    A(Q00005)
         DC    F'3'
P00060   DC    A(T00022)
         DC    F'5'
         DC    A(Q00006)
         DC    F'3'
P00061   DC    A(Q00007)
         DC    F'3'
P00062   DC    A(T00023)
         DC    F'7'
         DC    A(Q00008)
         DC    F'7'
P00063   DC    A(T00023)
         DC    F'7'
         DC    A(T00022)
         DC    F'5'
P00064   DC    A(Q00009)
         DC    F'3'
P00065   DC    A(T00023)
         DC    F'3'
         DC    A(T00021)
         DC    F'3'
P00066   DC    A(Q00010)
         DC    F'3'
P00067   DC    A(Q00011)
         DC    F'3'
         DC    A(Q00012)
         DC    F'3'
P00068   DC    A(Q00013)
         DC    F'3'
P00069   DC    A(T00024)
         DC    F'14'
         DC    A(Q00014)
         DC    F'14'
P00070   DC    A(T00024)
         DC    F'14'
         DC    A(T00021)
         DC    F'3'
P00071   DC    A(T00024)
         DC    F'14'
         DC    A(Q00015)
         DC    F'3'
P00072   DC    A(Q00016)
         DC    F'3'
P00073   DC    A(T00024)
         DC    F'14'
         DC    A(Q00017)
         DC    F'3'
P00074   DC    A(Q00018)
         DC    F'3'
P00075   DC    F'6'
         DC    A(Q00019)
P00076   DC    A(T00022)
         DC    F'5'
P00077   DC    A(T00021)
         DC    F'3'
P00078   DC    A(T00023)
         DC    F'7'
P00079   DC    F'6'
         DC    A(Q00020)
P00080   DC    A(T00024)
         DC    F'14'
P00081   DC    F'0'
         DS    XL4
C00049   DC    V(F77STRCP)
C00053   DC    V(F77STRCM)
C00054   DC    F'0'
C00056   DC    V(F77WRBEG)
C00058   DC    V(F77WRA)
C00059   DC    V(F77WREND)
C00082   DC    V(EXIT)
Q00004   DC    C'('' >'',A3)'
Q00019   DC    C'('' >'',A5,''#'',A3,''#'',A7,''#'')'
Q00020   DC    C'('' >'',A14,''#'')'
Q00001   DC    C'   '
Q00002   DC    C'ABC'
Q00003   DC    C'ABC'
Q00005   DC    C'EQ1'
Q00006   DC    C'ABC'
Q00007   DC    C'NE1'
Q00008   DC    C'ABC  XY'
Q00009   DC    C'GT2'
Q00010   DC    C'EQ3'
Q00011   DC    C'ABC'
Q00012   DC    C'ABD'
Q00013   DC    C'LT4'
Q00014   DC    C'              '
Q00015   DC    C'ABC'
Q00016   DC    C'EQ5'
Q00017   DC    C'ABC'
Q00018   DC    C'NE5'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
