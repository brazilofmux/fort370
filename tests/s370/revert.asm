* main
F77MAIN  CSECT
         USING *,15
         B     L00048
         DC    AL1(7),CL7'F77MAIN'
L00048   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00049
L00050   DC    A(S00000)
L00049   L     15,L00050
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00023   DS    0H
         LA    1,P00051
         L     15,C00052
         BALR  14,15
         LA    2,5
         LA    3,1
L00024   DS    0H
         C     2,C00053
         BC    2,L00025
L00026   DS    0H
         L     15,C00054
         BALR  14,15
         LA    1,P00055
         L     15,C00056
         BALR  14,15
         LR    3,15
         C     3,C00053
         LA    2,1
         BC    7,L00057
         SR    2,2
L00057   DS    0H
         LA    1,P00058
         L     15,C00056
         BALR  14,15
         LR    4,15
         C     4,C00053
         LA    3,1
         BC    7,L00059
         SR    3,3
L00059   DS    0H
         OR    2,3
         LTR   2,2
         BC    7,L00027
L00028   DS    0H
         LA    1,P00060
         L     15,C00056
         BALR  14,15
         LR    2,15
         C     2,C00053
         BC    7,L00029
L00030   DS    0H
         LA    1,P00061
         L     15,C00062
         BALR  14,15
         LA    5,T00022-4
         LA    2,4
         LA    3,5
L00031   DS    0H
         C     3,C00053
         BC    2,L00032
L00033   DS    0H
         L     15,C00063
         BALR  14,15
         L     3,T00022
         C     3,C00064
         LA    2,1
         BC    7,L00065
         SR    2,2
L00065   DS    0H
         L     4,T00022+12
         C     4,C00066
         LA    3,1
         BC    7,L00067
         SR    3,3
L00067   DS    0H
         OR    2,3
         L     4,T00022+16
         C     4,C00068
         LA    3,1
         BC    7,L00069
         SR    3,3
L00069   DS    0H
         OR    2,3
         LTR   2,2
         BC    7,L00034
L00035   DS    0H
         LA    1,P00070
         L     15,C00071
         BALR  14,15
         LA    1,P00072
         L     15,C00071
         BALR  14,15
         LA    1,P00073
         L     15,C00071
         BALR  14,15
         LA    1,P00074
         L     15,C00071
         BALR  14,15
         LA    1,P00075
         L     15,C00062
         BALR  14,15
         LA    1,P00076
         L     15,C00077
         BALR  14,15
         LA    1,P00078
         L     15,C00077
         BALR  14,15
         LA    1,P00079
         L     15,C00077
         BALR  14,15
         LA    1,P00080
         L     15,C00077
         BALR  14,15
         L     15,C00063
         BALR  14,15
         LA    1,P00081
         L     15,C00056
         BALR  14,15
         LR    3,15
         C     3,C00053
         LA    2,1
         BC    7,L00082
         SR    2,2
L00082   DS    0H
         LA    1,P00083
         L     15,C00056
         BALR  14,15
         LR    4,15
         C     4,C00053
         LA    3,1
         BC    7,L00084
         SR    3,3
L00084   DS    0H
         OR    2,3
         LA    1,P00085
         L     15,C00056
         BALR  14,15
         LR    4,15
         C     4,C00053
         LA    3,1
         BC    7,L00086
         SR    3,3
L00086   DS    0H
         OR    2,3
         LTR   2,2
         BC    7,L00036
L00037   DS    0H
         LA    1,P00087
         L     15,C00052
         BALR  14,15
         LA    2,6
         LA    3,1
L00038   DS    0H
         C     2,C00053
         BC    2,L00039
L00040   DS    0H
         L     15,C00054
         BALR  14,15
         LA    1,P00088
         L     15,C00056
         BALR  14,15
         LR    3,15
         C     3,C00053
         LA    2,1
         BC    7,L00089
         SR    2,2
L00089   DS    0H
         LA    1,P00090
         L     15,C00056
         BALR  14,15
         LR    4,15
         C     4,C00053
         LA    3,1
         BC    7,L00091
         SR    3,3
L00091   DS    0H
         OR    2,3
         LTR   2,2
         BC    7,L00041
L00042   DS    0H
         LA    1,P00092
         L     15,C00093
         BALR  14,15
         LA    1,P00094
         L     15,C00095
         BALR  14,15
         L     15,C00054
         BALR  14,15
         LA    1,P00096
         L     15,C00097
         BALR  14,15
         B     L00047
L00025   DS    0H
         LR    0,3
         ST    0,P00098+0
         LA    1,P00098
         L     15,C00095
         BALR  14,15
         A     3,C00064
         AH    2,C00099
         B     L00024
L00027   DS    0H
         LA    1,P00100
         L     15,C00097
         BALR  14,15
         B     L00047
L00029   DS    0H
         LA    1,P00101
         L     15,C00097
         BALR  14,15
         B     L00047
L00032   DS    0H
         LR    4,5
         AR    4,2
         LR    0,4
         ST    0,P00098+0
         LA    1,P00098
         L     15,C00102
         BALR  14,15
         AH    3,C00099
         A     2,C00066
         B     L00031
L00034   DS    0H
         LA    1,P00103
         L     15,C00097
         BALR  14,15
         B     L00047
L00036   DS    0H
         LA    1,P00094
         L     15,C00097
         BALR  14,15
         B     L00047
L00039   DS    0H
         LR    0,3
         ST    0,P00098+0
         LA    1,P00098
         L     15,C00095
         BALR  14,15
         A     3,C00064
         AH    2,C00099
         B     L00038
L00041   DS    0H
         LA    1,P00104
         L     15,C00097
         BALR  14,15
         B     L00047
L00043   DS    0H
L00044   DS    0H
L00045   DS    0H
L00046   DS    0H
L00047   DS    0H
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
T00017   DS    XL8
T00018   DS    XL8
T00019   DS    XL8
T00020   DS    XL8
T00021   DS    XL28
         DS    XL4
T00022   DS    XL44
         DS    XL4
P00051   DC    A(T00021)
         DC    F'4'
         DC    F'6'
         DC    A(Q00001)
P00055   DC    A(T00021)
         DC    F'4'
         DC    A(Q00002)
         DC    F'4'
P00058   DC    A(T00021+8)
         DC    F'4'
         DC    A(Q00003)
         DC    F'4'
P00060   DC    A(T00021+16)
         DC    F'4'
         DC    A(Q00004)
         DC    F'4'
P00061   DC    A(T00021)
         DC    F'4'
         DC    F'6'
         DC    A(Q00001)
         DC    F'0'
P00070   DC    A(T00021)
         DC    F'4'
         DC    A(Q00005)
         DC    F'2'
P00072   DC    A(T00021+4)
         DC    F'4'
         DC    A(Q00006)
         DC    F'2'
P00073   DC    A(T00021+8)
         DC    F'4'
         DC    A(Q00007)
         DC    F'2'
P00074   DC    A(T00021+12)
         DC    F'4'
         DC    A(Q00008)
         DC    F'2'
P00075   DC    A(T00021)
         DC    F'4'
         DC    F'6'
         DC    A(Q00009)
         DC    F'0'
P00076   DC    A(T00017)
         DC    F'4'
P00078   DC    A(T00018)
         DC    F'4'
P00079   DC    A(T00019)
         DC    F'4'
P00080   DC    A(T00020)
         DC    F'4'
P00081   DC    A(T00017)
         DC    F'4'
         DC    A(Q00010)
         DC    F'2'
P00083   DC    A(T00019)
         DC    F'4'
         DC    A(Q00011)
         DC    F'2'
P00085   DC    A(T00020)
         DC    F'4'
         DC    A(Q00012)
         DC    F'2'
P00087   DC    A(T00021)
         DC    F'4'
         DC    F'6'
         DC    A(Q00013)
P00088   DC    A(T00021)
         DC    F'4'
         DC    A(Q00014)
         DC    F'4'
P00090   DC    A(T00021+8)
         DC    F'4'
         DC    A(Q00015)
         DC    F'4'
P00092   DC    F'6'
         DC    A(Q00016)
P00094   DC    F'4'
P00096   DC    F'0'
P00098   DC    A(0)
P00100   DC    F'1'
P00101   DC    F'2'
P00103   DC    F'3'
P00104   DC    F'5'
         DS    XL4
C00052   DC    V(F77WRBI)
C00053   DC    F'0'
C00054   DC    V(F77WREND)
C00056   DC    V(F77STRCM)
C00062   DC    V(F77RDBI)
C00063   DC    V(F77RDEND)
C00064   DC    F'1'
C00066   DC    F'4'
C00068   DC    F'5'
C00071   DC    V(F77STRCP)
C00077   DC    V(F77RDS)
C00093   DC    V(F77WRBEG)
C00095   DC    V(F77WRI)
C00097   DC    V(EXIT)
C00102   DC    V(F77RDI)
C00099   DC    H'-1'
Q00001   DC    C'(I4)'
Q00009   DC    C'(A)'
Q00013   DC    C'(2I2)'
Q00016   DC    C'(1X,''>REVERT'',I3)'
Q00002   DC    C'   1'
Q00003   DC    C'   3'
Q00004   DC    C'   5'
Q00005   DC    C'XA'
Q00006   DC    C'YB'
Q00007   DC    C'ZC'
Q00008   DC    C'PD'
Q00010   DC    C'XA'
Q00011   DC    C'ZC'
Q00012   DC    C'PD'
Q00014   DC    C' 1 2'
Q00015   DC    C' 5 6'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
