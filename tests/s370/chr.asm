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
         LA    0,T00022
         ST    0,P00048+0
         LA    0,5
         ST    0,P00048+4
         L     0,C00049
         ST    0,P00048+8
         LA    0,3
         ST    0,P00048+12
         LA    1,P00048
         L     15,C00050
         BALR  14,15
         LA    0,T00021
         ST    0,P00048+0
         LA    0,3
         ST    0,P00048+4
         L     0,C00051
         ST    0,P00048+8
         LA    0,3
         ST    0,P00048+12
         LA    1,P00048
         L     15,C00050
         BALR  14,15
         LA    0,T00022
         ST    0,P00048+0
         LA    0,5
         ST    0,P00048+4
         LA    0,T00021
         ST    0,P00048+8
         LA    0,3
         ST    0,P00048+12
         LA    1,P00048
         L     15,C00050
         BALR  14,15
         LA    0,T00022
         ST    0,P00048+0
         LA    0,5
         ST    0,P00048+4
         L     0,C00052
         ST    0,P00048+8
         LA    0,3
         ST    0,P00048+12
         LA    1,P00048
         L     15,C00053
         BALR  14,15
         LR    2,15
         C     2,C00054
         BC    7,L00027
L00026   DS    0H
         LA    0,6
         ST    0,P00048+0
         L     0,C00055
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00056
         BALR  14,15
         L     0,C00057
         ST    0,P00048+0
         LA    0,3
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00058
         BALR  14,15
         L     15,C00059
         BALR  14,15
L00027   DS    0H
         LA    0,T00022
         ST    0,P00048+0
         LA    0,5
         ST    0,P00048+4
         L     0,C00060
         ST    0,P00048+8
         LA    0,3
         ST    0,P00048+12
         LA    1,P00048
         L     15,C00053
         BALR  14,15
         LR    2,15
         C     2,C00054
         BC    8,L00029
L00028   DS    0H
         LA    0,6
         ST    0,P00048+0
         L     0,C00055
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00056
         BALR  14,15
         L     0,C00061
         ST    0,P00048+0
         LA    0,3
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00058
         BALR  14,15
         L     15,C00059
         BALR  14,15
L00029   DS    0H
         LA    0,T00023
         ST    0,P00048+0
         LA    0,7
         ST    0,P00048+4
         L     0,C00062
         ST    0,P00048+8
         LA    0,7
         ST    0,P00048+12
         LA    1,P00048
         L     15,C00050
         BALR  14,15
         LA    0,T00023
         ST    0,P00048+0
         LA    0,7
         ST    0,P00048+4
         LA    0,T00022
         ST    0,P00048+8
         LA    0,5
         ST    0,P00048+12
         LA    1,P00048
         L     15,C00053
         BALR  14,15
         LR    2,15
         C     2,C00054
         BC    13,L00031
L00030   DS    0H
         LA    0,6
         ST    0,P00048+0
         L     0,C00055
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00056
         BALR  14,15
         L     0,C00063
         ST    0,P00048+0
         LA    0,3
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00058
         BALR  14,15
         L     15,C00059
         BALR  14,15
L00031   DS    0H
         LA    0,T00023
         ST    0,P00048+0
         LA    0,3
         ST    0,P00048+4
         LA    0,T00021
         ST    0,P00048+8
         LA    0,3
         ST    0,P00048+12
         LA    1,P00048
         L     15,C00053
         BALR  14,15
         LR    2,15
         C     2,C00054
         BC    7,L00033
L00032   DS    0H
         LA    0,6
         ST    0,P00048+0
         L     0,C00055
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00056
         BALR  14,15
         L     0,C00064
         ST    0,P00048+0
         LA    0,3
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00058
         BALR  14,15
         L     15,C00059
         BALR  14,15
L00033   DS    0H
         L     0,C00065
         ST    0,P00048+0
         LA    0,3
         ST    0,P00048+4
         L     0,C00066
         ST    0,P00048+8
         LA    0,3
         ST    0,P00048+12
         LA    1,P00048
         L     15,C00053
         BALR  14,15
         LR    2,15
         C     2,C00054
         BC    11,L00035
L00034   DS    0H
         LA    0,6
         ST    0,P00048+0
         L     0,C00055
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00056
         BALR  14,15
         L     0,C00067
         ST    0,P00048+0
         LA    0,3
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00058
         BALR  14,15
         L     15,C00059
         BALR  14,15
L00035   DS    0H
         LA    0,T00024
         ST    0,P00048+0
         LA    0,14
         ST    0,P00048+4
         L     0,C00068
         ST    0,P00048+8
         LA    0,14
         ST    0,P00048+12
         LA    1,P00048
         L     15,C00050
         BALR  14,15
         LA    0,T00024
         ST    0,P00048+0
         LA    0,14
         ST    0,P00048+4
         LA    0,T00021
         ST    0,P00048+8
         LA    0,3
         ST    0,P00048+12
         LA    1,P00048
         L     15,C00050
         BALR  14,15
         LA    0,T00024
         ST    0,P00048+0
         LA    0,14
         ST    0,P00048+4
         L     0,C00069
         ST    0,P00048+8
         LA    0,3
         ST    0,P00048+12
         LA    1,P00048
         L     15,C00053
         BALR  14,15
         LR    2,15
         C     2,C00054
         BC    7,L00037
L00036   DS    0H
         LA    0,6
         ST    0,P00048+0
         L     0,C00055
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00056
         BALR  14,15
         L     0,C00070
         ST    0,P00048+0
         LA    0,3
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00058
         BALR  14,15
         L     15,C00059
         BALR  14,15
L00037   DS    0H
         LA    0,T00024
         ST    0,P00048+0
         LA    0,14
         ST    0,P00048+4
         L     0,C00071
         ST    0,P00048+8
         LA    0,3
         ST    0,P00048+12
         LA    1,P00048
         L     15,C00053
         BALR  14,15
         LR    2,15
         C     2,C00054
         BC    8,L00039
L00038   DS    0H
         LA    0,6
         ST    0,P00048+0
         L     0,C00055
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00056
         BALR  14,15
         L     0,C00072
         ST    0,P00048+0
         LA    0,3
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00058
         BALR  14,15
         L     15,C00059
         BALR  14,15
L00039   DS    0H
         LA    0,6
         ST    0,P00048+0
         L     0,C00073
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00056
         BALR  14,15
         LA    0,T00022
         ST    0,P00048+0
         LA    0,5
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00058
         BALR  14,15
         LA    0,T00021
         ST    0,P00048+0
         LA    0,3
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00058
         BALR  14,15
         LA    0,T00023
         ST    0,P00048+0
         LA    0,7
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00058
         BALR  14,15
         L     15,C00059
         BALR  14,15
         LA    0,6
         ST    0,P00048+0
         L     0,C00074
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00056
         BALR  14,15
         LA    0,T00024
         ST    0,P00048+0
         LA    0,14
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00058
         BALR  14,15
         L     15,C00059
         BALR  14,15
L00040   DS    0H
L00041   DS    0H
L00042   DS    0H
         LA    0,0
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00075
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
P00048   DS    4F
C00049   DC    A(Q00001)
C00050   DC    V(F77STRCP)
C00051   DC    A(Q00002)
C00052   DC    A(Q00003)
C00053   DC    V(F77STRCM)
C00054   DC    F'0'
C00055   DC    A(Q00004)
C00056   DC    V(F77WRBEG)
C00057   DC    A(Q00005)
C00058   DC    V(F77WRA)
C00059   DC    V(F77WREND)
C00060   DC    A(Q00006)
C00061   DC    A(Q00007)
C00062   DC    A(Q00008)
C00063   DC    A(Q00009)
C00064   DC    A(Q00010)
C00065   DC    A(Q00011)
C00066   DC    A(Q00012)
C00067   DC    A(Q00013)
C00068   DC    A(Q00014)
C00069   DC    A(Q00015)
C00070   DC    A(Q00016)
C00071   DC    A(Q00017)
C00072   DC    A(Q00018)
C00073   DC    A(Q00019)
C00074   DC    A(Q00020)
C00075   DC    V(EXIT)
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
