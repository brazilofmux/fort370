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
         LA    0,T00021
         ST    0,P00051+0
         LA    0,4
         ST    0,P00051+4
         LA    0,6
         ST    0,P00051+8
         L     0,C00052
         ST    0,P00051+12
         LA    1,P00051
         L     15,C00053
         BALR  14,15
         LA    2,5
         LA    3,1
L00024   DS    0H
         C     2,C00054
         BC    2,L00025
L00026   DS    0H
         L     15,C00055
         BALR  14,15
         LA    0,T00021
         ST    0,P00051+0
         LA    0,4
         ST    0,P00051+4
         L     0,C00056
         ST    0,P00051+8
         LA    0,4
         ST    0,P00051+12
         LA    1,P00051
         L     15,C00057
         BALR  14,15
         LR    3,15
         C     3,C00054
         LA    2,1
         BC    7,L00058
         SR    2,2
L00058   DS    0H
         LA    3,T00021+8
         LR    0,3
         ST    0,P00051+0
         LA    0,4
         ST    0,P00051+4
         L     0,C00059
         ST    0,P00051+8
         LA    0,4
         ST    0,P00051+12
         LA    1,P00051
         L     15,C00057
         BALR  14,15
         LR    4,15
         C     4,C00054
         LA    3,1
         BC    7,L00060
         SR    3,3
L00060   DS    0H
         OR    2,3
         LTR   2,2
         BC    7,L00027
L00028   DS    0H
         LA    3,T00021+16
         LR    0,3
         ST    0,P00051+0
         LA    0,4
         ST    0,P00051+4
         L     0,C00061
         ST    0,P00051+8
         LA    0,4
         ST    0,P00051+12
         LA    1,P00051
         L     15,C00057
         BALR  14,15
         LR    2,15
         C     2,C00054
         BC    7,L00029
L00030   DS    0H
         LA    0,T00021
         ST    0,P00051+0
         LA    0,4
         ST    0,P00051+4
         LA    0,6
         ST    0,P00051+8
         L     0,C00052
         ST    0,P00051+12
         LA    0,0
         ST    0,P00051+16
         LA    1,P00051
         L     15,C00062
         BALR  14,15
         LA    5,T00022-4
         LA    2,4
         LA    3,5
L00031   DS    0H
         C     3,C00054
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
         LA    0,T00021
         ST    0,P00051+0
         LA    0,4
         ST    0,P00051+4
         L     0,C00070
         ST    0,P00051+8
         LA    0,2
         ST    0,P00051+12
         LA    1,P00051
         L     15,C00071
         BALR  14,15
         LA    3,T00021+4
         LR    0,3
         ST    0,P00051+0
         LA    0,4
         ST    0,P00051+4
         L     0,C00072
         ST    0,P00051+8
         LA    0,2
         ST    0,P00051+12
         LA    1,P00051
         L     15,C00071
         BALR  14,15
         LA    3,T00021+8
         LR    0,3
         ST    0,P00051+0
         LA    0,4
         ST    0,P00051+4
         L     0,C00073
         ST    0,P00051+8
         LA    0,2
         ST    0,P00051+12
         LA    1,P00051
         L     15,C00071
         BALR  14,15
         LA    3,T00021+12
         LR    0,3
         ST    0,P00051+0
         LA    0,4
         ST    0,P00051+4
         L     0,C00074
         ST    0,P00051+8
         LA    0,2
         ST    0,P00051+12
         LA    1,P00051
         L     15,C00071
         BALR  14,15
         LA    0,T00021
         ST    0,P00051+0
         LA    0,4
         ST    0,P00051+4
         LA    0,6
         ST    0,P00051+8
         L     0,C00075
         ST    0,P00051+12
         LA    0,0
         ST    0,P00051+16
         LA    1,P00051
         L     15,C00062
         BALR  14,15
         LA    0,T00017
         ST    0,P00051+0
         LA    0,4
         ST    0,P00051+4
         LA    1,P00051
         L     15,C00076
         BALR  14,15
         LA    0,T00018
         ST    0,P00051+0
         LA    0,4
         ST    0,P00051+4
         LA    1,P00051
         L     15,C00076
         BALR  14,15
         LA    0,T00019
         ST    0,P00051+0
         LA    0,4
         ST    0,P00051+4
         LA    1,P00051
         L     15,C00076
         BALR  14,15
         LA    0,T00020
         ST    0,P00051+0
         LA    0,4
         ST    0,P00051+4
         LA    1,P00051
         L     15,C00076
         BALR  14,15
         L     15,C00063
         BALR  14,15
         LA    0,T00017
         ST    0,P00051+0
         LA    0,4
         ST    0,P00051+4
         L     0,C00077
         ST    0,P00051+8
         LA    0,2
         ST    0,P00051+12
         LA    1,P00051
         L     15,C00057
         BALR  14,15
         LR    3,15
         C     3,C00054
         LA    2,1
         BC    7,L00078
         SR    2,2
L00078   DS    0H
         LA    0,T00019
         ST    0,P00051+0
         LA    0,4
         ST    0,P00051+4
         L     0,C00079
         ST    0,P00051+8
         LA    0,2
         ST    0,P00051+12
         LA    1,P00051
         L     15,C00057
         BALR  14,15
         LR    4,15
         C     4,C00054
         LA    3,1
         BC    7,L00080
         SR    3,3
L00080   DS    0H
         OR    2,3
         LA    0,T00020
         ST    0,P00051+0
         LA    0,4
         ST    0,P00051+4
         L     0,C00081
         ST    0,P00051+8
         LA    0,2
         ST    0,P00051+12
         LA    1,P00051
         L     15,C00057
         BALR  14,15
         LR    4,15
         C     4,C00054
         LA    3,1
         BC    7,L00082
         SR    3,3
L00082   DS    0H
         OR    2,3
         LTR   2,2
         BC    7,L00036
L00037   DS    0H
         LA    0,T00021
         ST    0,P00051+0
         LA    0,4
         ST    0,P00051+4
         LA    0,6
         ST    0,P00051+8
         L     0,C00083
         ST    0,P00051+12
         LA    1,P00051
         L     15,C00053
         BALR  14,15
         LA    2,6
         LA    3,1
L00038   DS    0H
         C     2,C00054
         BC    2,L00039
L00040   DS    0H
         L     15,C00055
         BALR  14,15
         LA    0,T00021
         ST    0,P00051+0
         LA    0,4
         ST    0,P00051+4
         L     0,C00084
         ST    0,P00051+8
         LA    0,4
         ST    0,P00051+12
         LA    1,P00051
         L     15,C00057
         BALR  14,15
         LR    3,15
         C     3,C00054
         LA    2,1
         BC    7,L00085
         SR    2,2
L00085   DS    0H
         LA    3,T00021+8
         LR    0,3
         ST    0,P00051+0
         LA    0,4
         ST    0,P00051+4
         L     0,C00086
         ST    0,P00051+8
         LA    0,4
         ST    0,P00051+12
         LA    1,P00051
         L     15,C00057
         BALR  14,15
         LR    4,15
         C     4,C00054
         LA    3,1
         BC    7,L00087
         SR    3,3
L00087   DS    0H
         OR    2,3
         LTR   2,2
         BC    7,L00041
L00042   DS    0H
         LA    0,6
         ST    0,P00051+0
         L     0,C00088
         ST    0,P00051+4
         LA    1,P00051
         L     15,C00089
         BALR  14,15
         LA    0,4
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00090
         BALR  14,15
         L     15,C00055
         BALR  14,15
         LA    0,0
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00091
         BALR  14,15
         B     L00047
L00025   DS    0H
         LR    0,3
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00090
         BALR  14,15
         A     3,C00064
         AH    2,C00092
         B     L00024
L00027   DS    0H
         LA    0,1
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00091
         BALR  14,15
         B     L00047
L00029   DS    0H
         LA    0,2
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00091
         BALR  14,15
         B     L00047
L00032   DS    0H
         LR    4,5
         AR    4,2
         LR    0,4
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00093
         BALR  14,15
         AH    3,C00092
         A     2,C00066
         B     L00031
L00034   DS    0H
         LA    0,3
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00091
         BALR  14,15
         B     L00047
L00036   DS    0H
         LA    0,4
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00091
         BALR  14,15
         B     L00047
L00039   DS    0H
         LR    0,3
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00090
         BALR  14,15
         A     3,C00064
         AH    2,C00092
         B     L00038
L00041   DS    0H
         LA    0,5
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00091
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
P00051   DS    5F
         DS    XL4
C00052   DC    A(Q00001)
C00053   DC    V(F77WRBI)
C00054   DC    F'0'
C00055   DC    V(F77WREND)
C00056   DC    A(Q00002)
C00057   DC    V(F77STRCM)
C00059   DC    A(Q00003)
C00061   DC    A(Q00004)
C00062   DC    V(F77RDBI)
C00063   DC    V(F77RDEND)
C00064   DC    F'1'
C00066   DC    F'4'
C00068   DC    F'5'
C00070   DC    A(Q00005)
C00071   DC    V(F77STRCP)
C00072   DC    A(Q00006)
C00073   DC    A(Q00007)
C00074   DC    A(Q00008)
C00075   DC    A(Q00009)
C00076   DC    V(F77RDS)
C00077   DC    A(Q00010)
C00079   DC    A(Q00011)
C00081   DC    A(Q00012)
C00083   DC    A(Q00013)
C00084   DC    A(Q00014)
C00086   DC    A(Q00015)
C00088   DC    A(Q00016)
C00089   DC    V(F77WRBEG)
C00090   DC    V(F77WRI)
C00091   DC    V(EXIT)
C00093   DC    V(F77RDI)
C00092   DC    H'-1'
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
