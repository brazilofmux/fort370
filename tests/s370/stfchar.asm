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
         LA    0,T00029
         ST    0,P00045+0
         LA    0,12
         ST    0,P00045+4
         L     0,C00046
         ST    0,P00045+8
         LA    0,9
         ST    0,P00045+12
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         LA    0,T00030
         ST    0,P00045+0
         LA    0,5
         ST    0,P00045+4
         L     0,C00048
         ST    0,P00045+8
         LA    0,5
         ST    0,P00045+12
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         LA    3,T00030+5
         LR    0,3
         ST    0,P00045+0
         LA    0,5
         ST    0,P00045+4
         L     0,C00049
         ST    0,P00045+8
         LA    0,2
         ST    0,P00045+12
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         LA    6,1
L00033   DS    0H
         LA    7,12
         LR    3,6
         LA    2,0
L00034   DS    0H
         LR    4,3
         AH    4,C00050
         LA    5,T00029
         AR    5,4
         LA    0,T00031
         ST    0,P00045+0
         LA    0,1
         ST    0,P00045+4
         LR    0,5
         ST    0,P00045+8
         LA    0,1
         ST    0,P00045+12
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         LA    0,T00031
         ST    0,P00045+0
         LA    0,1
         ST    0,P00045+4
         L     0,C00051
         ST    0,P00045+8
         LA    0,1
         ST    0,P00045+12
         LA    1,P00045
         L     15,C00052
         BALR  14,15
         LR    5,15
         C     5,C00053
         LA    4,1
         BC    7,L00054
         SR    4,4
L00054   DS    0H
         LA    0,T00031
         ST    0,P00045+0
         LA    0,1
         ST    0,P00045+4
         L     0,C00055
         ST    0,P00045+8
         LA    0,1
         ST    0,P00045+12
         LA    1,P00045
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
         LA    0,6
         ST    0,P00045+0
         L     0,C00058
         ST    0,P00045+4
         LA    1,P00045
         L     15,C00059
         BALR  14,15
         LR    0,2
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00060
         BALR  14,15
         LA    3,T00029
         A     3,C00061
         LA    0,T00021
         ST    0,P00045+0
         LA    0,1
         ST    0,P00045+4
         LR    0,3
         ST    0,P00045+8
         LA    0,1
         ST    0,P00045+12
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         LA    0,T00021
         ST    0,P00045+0
         LA    0,1
         ST    0,P00045+4
         L     0,C00062
         ST    0,P00045+8
         LA    0,1
         ST    0,P00045+12
         LA    1,P00045
         L     15,C00052
         BALR  14,15
         LR    3,15
         C     3,C00053
         LA    2,1
         BC    7,L00063
         SR    2,2
L00063   DS    0H
         LA    0,T00021
         ST    0,P00045+0
         LA    0,1
         ST    0,P00045+4
         L     0,C00064
         ST    0,P00045+8
         LA    0,1
         ST    0,P00045+12
         LA    1,P00045
         L     15,C00052
         BALR  14,15
         LR    4,15
         C     4,C00053
         LA    3,1
         BC    7,L00065
         SR    3,3
L00065   DS    0H
         NR    2,3
         LR    0,2
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00066
         BALR  14,15
         LA    3,T00029
         A     3,C00067
         LA    0,T00022
         ST    0,P00045+0
         LA    0,1
         ST    0,P00045+4
         LR    0,3
         ST    0,P00045+8
         LA    0,1
         ST    0,P00045+12
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         LA    0,T00022
         ST    0,P00045+0
         LA    0,1
         ST    0,P00045+4
         L     0,C00068
         ST    0,P00045+8
         LA    0,1
         ST    0,P00045+12
         LA    1,P00045
         L     15,C00052
         BALR  14,15
         LR    3,15
         C     3,C00053
         LA    2,1
         BC    7,L00069
         SR    2,2
L00069   DS    0H
         LA    0,T00022
         ST    0,P00045+0
         LA    0,1
         ST    0,P00045+4
         L     0,C00070
         ST    0,P00045+8
         LA    0,1
         ST    0,P00045+12
         LA    1,P00045
         L     15,C00052
         BALR  14,15
         LR    4,15
         C     4,C00053
         LA    3,1
         BC    7,L00071
         SR    3,3
L00071   DS    0H
         NR    2,3
         LR    0,2
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00066
         BALR  14,15
         LA    0,T00023
         ST    0,P00045+0
         LA    0,1
         ST    0,P00045+4
         L     0,C00072
         ST    0,P00045+8
         LA    0,1
         ST    0,P00045+12
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         LA    0,T00023
         ST    0,P00045+0
         LA    0,1
         ST    0,P00045+4
         L     0,C00073
         ST    0,P00045+8
         LA    0,1
         ST    0,P00045+12
         LA    1,P00045
         L     15,C00052
         BALR  14,15
         LR    3,15
         C     3,C00053
         LA    2,1
         BC    7,L00074
         SR    2,2
L00074   DS    0H
         LA    0,T00023
         ST    0,P00045+0
         LA    0,1
         ST    0,P00045+4
         L     0,C00075
         ST    0,P00045+8
         LA    0,1
         ST    0,P00045+12
         LA    1,P00045
         L     15,C00052
         BALR  14,15
         LR    4,15
         C     4,C00053
         LA    3,1
         BC    7,L00076
         SR    3,3
L00076   DS    0H
         NR    2,3
         LR    0,2
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00066
         BALR  14,15
         L     15,C00077
         BALR  14,15
         LA    0,6
         ST    0,P00045+0
         L     0,C00078
         ST    0,P00045+4
         LA    1,P00045
         L     15,C00059
         BALR  14,15
         LA    3,T00029
         A     3,C00079
         LA    0,T00024
         ST    0,P00045+0
         LA    0,3
         ST    0,P00045+4
         LR    0,3
         ST    0,P00045+8
         LA    0,6
         ST    0,P00045+12
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         LA    0,T00024
         ST    0,P00045+0
         LA    0,3
         ST    0,P00045+4
         L     0,C00080
         ST    0,P00045+8
         LA    0,1
         ST    0,P00045+12
         LA    1,P00045
         L     15,C00081
         BALR  14,15
         LR    3,15
         LR    0,3
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00060
         BALR  14,15
         LA    0,T00025
         ST    0,P00045+0
         LA    0,3
         ST    0,P00045+4
         LA    0,T00030
         ST    0,P00045+8
         LA    0,5
         ST    0,P00045+12
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         LA    0,T00025
         ST    0,P00045+0
         LA    0,3
         ST    0,P00045+4
         L     0,C00082
         ST    0,P00045+8
         LA    0,1
         ST    0,P00045+12
         LA    1,P00045
         L     15,C00081
         BALR  14,15
         LR    3,15
         LR    0,3
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00060
         BALR  14,15
         LA    0,T00026
         ST    0,P00045+0
         LA    0,3
         ST    0,P00045+4
         LA    0,T00029
         ST    0,P00045+8
         LA    0,12
         ST    0,P00045+12
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         LA    0,T00026
         ST    0,P00045+0
         LA    0,3
         ST    0,P00045+4
         L     0,C00083
         ST    0,P00045+8
         LA    0,1
         ST    0,P00045+12
         LA    1,P00045
         L     15,C00081
         BALR  14,15
         LR    3,15
         LR    0,3
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00060
         BALR  14,15
         LA    3,T00030+5
         LA    0,T00027
         ST    0,P00045+0
         LA    0,3
         ST    0,P00045+4
         LR    0,3
         ST    0,P00045+8
         LA    0,5
         ST    0,P00045+12
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         LA    0,T00027
         ST    0,P00045+0
         LA    0,3
         ST    0,P00045+4
         L     0,C00084
         ST    0,P00045+8
         LA    0,1
         ST    0,P00045+12
         LA    1,P00045
         L     15,C00081
         BALR  14,15
         LR    3,15
         LR    0,3
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00060
         BALR  14,15
         LA    0,T00028
         ST    0,P00045+0
         LA    0,3
         ST    0,P00045+4
         L     0,C00085
         ST    0,P00045+8
         LA    0,4
         ST    0,P00045+12
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         LA    0,T00028
         ST    0,P00045+0
         LA    0,3
         ST    0,P00045+4
         L     0,C00086
         ST    0,P00045+8
         LA    0,1
         ST    0,P00045+12
         LA    1,P00045
         L     15,C00081
         BALR  14,15
         LR    3,15
         LR    0,3
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00060
         BALR  14,15
         L     15,C00077
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
P00045   DS    4F
C00046   DC    A(Q00001)
C00047   DC    V(F77STRCP)
C00048   DC    A(Q00002)
C00049   DC    A(Q00003)
C00051   DC    A(Q00019)
C00052   DC    V(F77STRCM)
C00053   DC    F'0'
C00055   DC    A(Q00020)
C00057   DC    F'1'
C00058   DC    A(Q00004)
C00059   DC    V(F77WRBEG)
C00060   DC    V(F77WRI)
C00061   DC    F'2'
C00062   DC    A(Q00005)
C00064   DC    A(Q00006)
C00066   DC    V(F77WRL)
C00067   DC    F'4'
C00068   DC    A(Q00007)
C00070   DC    A(Q00008)
C00072   DC    A(Q00009)
C00073   DC    A(Q00010)
C00075   DC    A(Q00011)
C00077   DC    V(F77WREND)
C00078   DC    A(Q00012)
C00079   DC    F'3'
C00080   DC    A(Q00013)
C00081   DC    V(F77INDEX)
C00082   DC    A(Q00014)
C00083   DC    A(Q00015)
C00084   DC    A(Q00016)
C00085   DC    A(Q00017)
C00086   DC    A(Q00018)
C00050   DC    H'-1'
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
