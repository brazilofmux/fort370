* main
F77MAIN  CSECT
         USING *,15
         B     L00043
         DC    AL1(7),CL7'F77MAIN'
L00043   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00044
L00045   DC    A(S00000)
L00044   L     15,L00045
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00026   DS    0H
         LA    1,P00046
         L     15,C00047
         BALR  14,15
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LA    1,P00050
         L     15,C00051
         BALR  14,15
         L     15,C00052
         BALR  14,15
         LA    1,P00053
         L     15,C00049
         BALR  14,15
         LA    1,P00054
         L     15,C00051
         BALR  14,15
         L     15,C00052
         BALR  14,15
         LA    1,P00055
         L     15,C00049
         BALR  14,15
         LA    1,P00056
         L     15,C00051
         BALR  14,15
         LA    1,P00057
         L     15,C00051
         BALR  14,15
         L     15,C00052
         BALR  14,15
         LA    1,P00058
         L     15,C00049
         BALR  14,15
         L     15,C00052
         BALR  14,15
         LA    1,P00059
         L     15,C00060
         BALR  14,15
         LA    1,P00061
         L     15,C00062
         BALR  14,15
         LR    2,15
         C     2,C00063
         BC    8,L00028
L00027   DS    0H
         LA    1,P00064
         L     15,C00065
         BALR  14,15
         LA    1,P00066
         L     15,C00065
         BALR  14,15
         LA    1,P00067
         L     15,C00065
         BALR  14,15
         L     15,C00068
         BALR  14,15
         LA    1,P00069
         L     15,C00070
         BALR  14,15
         LR    3,15
         C     3,C00071
         LA    2,1
         BC    7,L00072
         SR    2,2
L00072   DS    0H
         LA    1,P00073
         L     15,C00070
         BALR  14,15
         LR    4,15
         C     4,C00071
         LA    3,1
         BC    7,L00074
         SR    3,3
L00074   DS    0H
         OR    2,3
         LA    1,P00075
         L     15,C00070
         BALR  14,15
         LR    4,15
         C     4,C00071
         LA    3,1
         BC    7,L00076
         SR    3,3
L00076   DS    0H
         OR    2,3
         LTR   2,2
         BC    7,L00029
L00030   DS    0H
         LA    1,P00061
         L     15,C00062
         BALR  14,15
         LR    2,15
         C     2,C00063
         BC    8,L00028
L00031   DS    0H
         LA    1,P00064
         L     15,C00065
         BALR  14,15
         LA    1,P00066
         L     15,C00065
         BALR  14,15
         LA    1,P00067
         L     15,C00065
         BALR  14,15
         LA    1,P00077
         L     15,C00065
         BALR  14,15
         LA    1,P00078
         L     15,C00065
         BALR  14,15
         L     15,C00068
         BALR  14,15
         LA    1,P00079
         L     15,C00070
         BALR  14,15
         LR    3,15
         C     3,C00071
         LA    2,1
         BC    7,L00080
         SR    2,2
L00080   DS    0H
         LA    1,P00081
         L     15,C00070
         BALR  14,15
         LR    4,15
         C     4,C00071
         LA    3,1
         BC    7,L00082
         SR    3,3
L00082   DS    0H
         OR    2,3
         LA    1,P00083
         L     15,C00070
         BALR  14,15
         LR    4,15
         C     4,C00071
         LA    3,1
         BC    7,L00084
         SR    3,3
L00084   DS    0H
         OR    2,3
         LTR   2,2
         BC    7,L00032
L00033   DS    0H
         LA    1,P00085
         L     15,C00070
         BALR  14,15
         LR    3,15
         C     3,C00071
         LA    2,1
         BC    7,L00086
         SR    2,2
L00086   DS    0H
         LA    1,P00087
         L     15,C00070
         BALR  14,15
         LR    4,15
         C     4,C00071
         LA    3,1
         BC    7,L00088
         SR    3,3
L00088   DS    0H
         OR    2,3
         LTR   2,2
         BC    7,L00034
L00035   DS    0H
         LA    1,P00089
         L     15,C00049
         BALR  14,15
         L     15,C00052
         BALR  14,15
         LA    1,P00090
         L     15,C00049
         BALR  14,15
         LA    1,P00091
         L     15,C00092
         BALR  14,15
         L     15,C00052
         BALR  14,15
         LA    1,P00093
         L     15,C00094
         BALR  14,15
         B     L00042
L00028   DS    0H
         LA    1,P00095
         L     15,C00094
         BALR  14,15
         B     L00042
L00029   DS    0H
         LA    1,P00059
         L     15,C00094
         BALR  14,15
         B     L00042
L00032   DS    0H
         LA    1,P00091
         L     15,C00094
         BALR  14,15
         B     L00042
L00034   DS    0H
         LA    1,P00096
         L     15,C00094
         BALR  14,15
         B     L00042
L00036   DS    0H
L00037   DS    0H
L00038   DS    0H
L00039   DS    0H
L00040   DS    0H
L00041   DS    0H
L00042   DS    0H
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
T00022   DS    XL8
T00023   DS    XL8
T00024   DS    XL8
T00025   DS    XL8
P00046   DC    F'1'
         DC    F'0'
         DC    F'0'
         DC    A(Q00001)
         DC    F'7'
         DC    F'0'
         DC    F'0'
         DC    A(Q00002)
         DC    F'9'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
P00048   DC    F'1'
         DC    A(Q00003)
P00050   DC    A(Q00004)
         DC    F'1'
P00053   DC    F'1'
         DC    A(Q00005)
P00054   DC    A(Q00006)
         DC    F'1'
P00055   DC    F'1'
         DC    A(Q00007)
P00056   DC    A(Q00008)
         DC    F'1'
P00057   DC    A(Q00009)
         DC    F'1'
P00058   DC    F'1'
         DC    A(Q00010)
P00059   DC    F'1'
P00061   DC    F'1'
         DC    A(Q00005)
         DC    F'1'
P00064   DC    A(T00021)
         DC    F'4'
P00066   DC    A(T00022)
         DC    F'4'
P00067   DC    A(T00023)
         DC    F'4'
P00069   DC    A(T00021)
         DC    F'4'
         DC    A(Q00011)
         DC    F'1'
P00073   DC    A(T00022)
         DC    F'4'
         DC    A(Q00012)
         DC    F'1'
P00075   DC    A(T00023)
         DC    F'4'
         DC    A(Q00013)
         DC    F'1'
P00077   DC    A(T00024)
         DC    F'4'
P00078   DC    A(T00025)
         DC    F'4'
P00079   DC    A(T00021)
         DC    F'4'
         DC    A(Q00014)
         DC    F'1'
P00081   DC    A(T00022)
         DC    F'4'
         DC    A(Q00015)
         DC    F'1'
P00083   DC    A(T00023)
         DC    F'4'
         DC    A(Q00016)
         DC    F'1'
P00085   DC    A(T00024)
         DC    F'4'
         DC    A(Q00017)
         DC    F'1'
P00087   DC    A(T00025)
         DC    F'4'
         DC    A(Q00018)
         DC    F'1'
P00089   DC    F'6'
         DC    A(Q00019)
P00090   DC    F'6'
         DC    A(Q00020)
P00091   DC    F'2'
P00093   DC    F'0'
P00095   DC    F'9'
P00096   DC    F'3'
         DS    XL4
C00047   DC    V(F77OPEN)
C00049   DC    V(F77WRBEG)
C00051   DC    V(F77WRA)
C00052   DC    V(F77WREND)
C00060   DC    V(F77REWND)
C00062   DC    V(F77RDBEG)
C00063   DC    F'1'
C00065   DC    V(F77RDS)
C00068   DC    V(F77RDEND)
C00070   DC    V(F77STRCM)
C00071   DC    F'0'
C00092   DC    V(F77WRI)
C00094   DC    V(EXIT)
Q00003   DC    C'(A,/)'
Q00005   DC    C'(A)'
Q00007   DC    C'(A,//,A)'
Q00010   DC    C'(/)'
Q00019   DC    C'(1X,''FIRST LINE'',/)'
Q00020   DC    C'(1X,''>SLASH'',I3)'
Q00001   DC    C'SCRATCH'
Q00002   DC    C'FORMATTED'
Q00004   DC    C'X'
Q00006   DC    C'Y'
Q00008   DC    C'P'
Q00009   DC    C'Q'
Q00011   DC    C'X'
Q00012   DC    C' '
Q00013   DC    C'Y'
Q00014   DC    C'P'
Q00015   DC    C' '
Q00016   DC    C'Q'
Q00017   DC    C' '
Q00018   DC    C' '
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
