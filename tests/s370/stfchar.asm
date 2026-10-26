* main
F77MAIN  CSECT
         USING *,15
         B     L00042
         DC    AL1(7),CL7'F77MAIN'
L00042   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00043
L00044   DC    A(S00000)
L00043   L     15,L00044
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00032   DS    0H
         LA    1,P00045
         L     15,C00046
         BALR  14,15
         LA    1,P00047
         L     15,C00046
         BALR  14,15
         LA    1,P00048
         L     15,C00046
         BALR  14,15
         LA    6,1
L00033   DS    0H
         LA    7,12
         LR    3,6
         LA    2,0
L00034   DS    0H
         LR    4,3
         AH    4,C00049
         LA    5,T00029
         AR    5,4
         LR    0,5
         ST    0,P00050+8
         LA    1,P00050
         L     15,C00046
         BALR  14,15
         LA    1,P00051
         L     15,C00052
         BALR  14,15
         LR    5,15
         C     5,C00053
         LA    4,1
         BC    7,L00054
         SR    4,4
L00054   DS    0H
         LA    1,P00055
         L     15,C00052
         BALR  14,15
         LR    8,15
         C     8,C00053
         LA    5,1
         BC    7,L00056
         SR    5,5
L00056   DS    0H
         NR    4,5
         LTR   4,4
         BC    8,L00037
L00036   DS    0H
         A     2,C00057
L00037   DS    0H
L00038   DS    0H
         BXLE  3,6,L00034
L00035   DS    0H
         LA    1,P00058
         L     15,C00059
         BALR  14,15
         LR    0,2
         ST    0,P00060+0
         LA    1,P00060
         L     15,C00061
         BALR  14,15
         LA    3,T00029
         A     3,C00062
         LR    0,3
         ST    0,P00063+8
         LA    1,P00063
         L     15,C00046
         BALR  14,15
         LA    1,P00064
         L     15,C00052
         BALR  14,15
         LR    3,15
         C     3,C00053
         LA    2,1
         BC    7,L00065
         SR    2,2
L00065   DS    0H
         LA    1,P00066
         L     15,C00052
         BALR  14,15
         LR    4,15
         C     4,C00053
         LA    3,1
         BC    7,L00067
         SR    3,3
L00067   DS    0H
         NR    2,3
         LR    0,2
         ST    0,P00060+0
         LA    1,P00060
         L     15,C00068
         BALR  14,15
         LA    3,T00029
         A     3,C00069
         LR    0,3
         ST    0,P00070+8
         LA    1,P00070
         L     15,C00046
         BALR  14,15
         LA    1,P00071
         L     15,C00052
         BALR  14,15
         LR    3,15
         C     3,C00053
         LA    2,1
         BC    7,L00072
         SR    2,2
L00072   DS    0H
         LA    1,P00073
         L     15,C00052
         BALR  14,15
         LR    4,15
         C     4,C00053
         LA    3,1
         BC    7,L00074
         SR    3,3
L00074   DS    0H
         NR    2,3
         LR    0,2
         ST    0,P00060+0
         LA    1,P00060
         L     15,C00068
         BALR  14,15
         LA    1,P00075
         L     15,C00046
         BALR  14,15
         LA    1,P00076
         L     15,C00052
         BALR  14,15
         LR    3,15
         C     3,C00053
         LA    2,1
         BC    7,L00077
         SR    2,2
L00077   DS    0H
         LA    1,P00078
         L     15,C00052
         BALR  14,15
         LR    4,15
         C     4,C00053
         LA    3,1
         BC    7,L00079
         SR    3,3
L00079   DS    0H
         NR    2,3
         LR    0,2
         ST    0,P00060+0
         LA    1,P00060
         L     15,C00068
         BALR  14,15
         L     15,C00080
         BALR  14,15
         LA    1,P00081
         L     15,C00059
         BALR  14,15
         LA    3,T00029
         A     3,C00082
         LR    0,3
         ST    0,P00083+8
         LA    1,P00083
         L     15,C00046
         BALR  14,15
         LA    1,P00084
         L     15,C00085
         BALR  14,15
         LR    3,15
         LR    0,3
         ST    0,P00060+0
         LA    1,P00060
         L     15,C00061
         BALR  14,15
         LA    1,P00086
         L     15,C00046
         BALR  14,15
         LA    1,P00087
         L     15,C00085
         BALR  14,15
         LR    3,15
         LR    0,3
         ST    0,P00060+0
         LA    1,P00060
         L     15,C00061
         BALR  14,15
         LA    1,P00088
         L     15,C00046
         BALR  14,15
         LA    1,P00089
         L     15,C00085
         BALR  14,15
         LR    3,15
         LR    0,3
         ST    0,P00060+0
         LA    1,P00060
         L     15,C00061
         BALR  14,15
         LA    1,P00090
         L     15,C00046
         BALR  14,15
         LA    1,P00091
         L     15,C00085
         BALR  14,15
         LR    3,15
         LR    0,3
         ST    0,P00060+0
         LA    1,P00060
         L     15,C00061
         BALR  14,15
         LA    1,P00092
         L     15,C00046
         BALR  14,15
         LA    1,P00093
         L     15,C00085
         BALR  14,15
         LR    3,15
         LR    0,3
         ST    0,P00060+0
         LA    1,P00060
         L     15,C00061
         BALR  14,15
         L     15,C00080
         BALR  14,15
L00039   DS    0H
L00040   DS    0H
L00041   DS    0H
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
T00021   DS    XL9
         DS    XL7
T00022   DS    XL9
         DS    XL7
T00023   DS    XL9
         DS    XL7
T00024   DS    XL9
         DS    XL7
T00025   DS    XL9
         DS    XL7
T00026   DS    XL9
         DS    XL7
T00027   DS    XL9
         DS    XL7
T00028   DS    XL9
         DS    XL7
T00029   DS    XL16
T00030   DS    XL32
T00031   DS    XL45
         DS    XL3
P00045   DC    A(T00029)
         DC    F'12'
         DC    A(Q00001)
         DC    F'9'
P00047   DC    A(T00030)
         DC    F'5'
         DC    A(Q00002)
         DC    F'5'
P00048   DC    A(T00030+5)
         DC    F'5'
         DC    A(Q00003)
         DC    F'2'
P00050   DC    A(T00031)
         DC    F'1'
         DC    A(0)
         DC    F'1'
P00051   DC    A(T00031)
         DC    F'1'
         DC    A(Q00019)
         DC    F'1'
P00055   DC    A(T00031)
         DC    F'1'
         DC    A(Q00020)
         DC    F'1'
P00058   DC    F'6'
         DC    A(Q00004)
P00060   DC    A(0)
P00063   DC    A(T00021)
         DC    F'1'
         DC    A(0)
         DC    F'1'
P00064   DC    A(T00021)
         DC    F'1'
         DC    A(Q00005)
         DC    F'1'
P00066   DC    A(T00021)
         DC    F'1'
         DC    A(Q00006)
         DC    F'1'
P00070   DC    A(T00022)
         DC    F'1'
         DC    A(0)
         DC    F'1'
P00071   DC    A(T00022)
         DC    F'1'
         DC    A(Q00007)
         DC    F'1'
P00073   DC    A(T00022)
         DC    F'1'
         DC    A(Q00008)
         DC    F'1'
P00075   DC    A(T00023)
         DC    F'1'
         DC    A(Q00009)
         DC    F'1'
P00076   DC    A(T00023)
         DC    F'1'
         DC    A(Q00010)
         DC    F'1'
P00078   DC    A(T00023)
         DC    F'1'
         DC    A(Q00011)
         DC    F'1'
P00081   DC    F'6'
         DC    A(Q00012)
P00083   DC    A(T00024)
         DC    F'3'
         DC    A(0)
         DC    F'6'
P00084   DC    A(T00024)
         DC    F'3'
         DC    A(Q00013)
         DC    F'1'
P00086   DC    A(T00025)
         DC    F'3'
         DC    A(T00030)
         DC    F'5'
P00087   DC    A(T00025)
         DC    F'3'
         DC    A(Q00014)
         DC    F'1'
P00088   DC    A(T00026)
         DC    F'3'
         DC    A(T00029)
         DC    F'12'
P00089   DC    A(T00026)
         DC    F'3'
         DC    A(Q00015)
         DC    F'1'
P00090   DC    A(T00027)
         DC    F'3'
         DC    A(T00030+5)
         DC    F'5'
P00091   DC    A(T00027)
         DC    F'3'
         DC    A(Q00016)
         DC    F'1'
P00092   DC    A(T00028)
         DC    F'3'
         DC    A(Q00017)
         DC    F'4'
P00093   DC    A(T00028)
         DC    F'3'
         DC    A(Q00018)
         DC    F'1'
         DS    XL4
C00046   DC    V(F77STRCP)
C00052   DC    V(F77STRCM)
C00053   DC    F'0'
C00057   DC    F'1'
C00059   DC    V(F77WRBEG)
C00061   DC    V(F77WRI)
C00062   DC    F'2'
C00068   DC    V(F77WRL)
C00069   DC    F'4'
C00080   DC    V(F77WREND)
C00082   DC    F'3'
C00085   DC    V(F77INDEX)
C00049   DC    H'-1'
Q00004   DC    C'('' >S '',I3,3L2)'
Q00012   DC    C'('' >Q '',5I3)'
Q00001   DC    C'MX ,Q7 ZQ'
Q00002   DC    C'RQTSV'
Q00003   DC    C'KL'
Q00019   DC    C' '
Q00020   DC    C','
Q00005   DC    C' '
Q00006   DC    C','
Q00007   DC    C' '
Q00008   DC    C','
Q00009   DC    C'Y'
Q00010   DC    C' '
Q00011   DC    C','
Q00013   DC    C'Q'
Q00014   DC    C'Q'
Q00015   DC    C'Q'
Q00016   DC    C' '
Q00017   DC    C'A BC'
Q00018   DC    C' '
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
