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
         LA    0,1
         ST    0,P00046+0
         LA    0,0
         ST    0,P00046+4
         LA    0,0
         ST    0,P00046+8
         L     0,C00047
         ST    0,P00046+12
         LA    0,7
         ST    0,P00046+16
         LA    0,0
         ST    0,P00046+20
         LA    0,0
         ST    0,P00046+24
         L     0,C00048
         ST    0,P00046+28
         LA    0,9
         ST    0,P00046+32
         LA    0,0
         ST    0,P00046+36
         LA    0,0
         ST    0,P00046+40
         LA    0,0
         ST    0,P00046+44
         LA    0,0
         ST    0,P00046+48
         LA    1,P00046
         L     15,C00049
         BALR  14,15
         LA    0,1
         ST    0,P00046+0
         L     0,C00050
         ST    0,P00046+4
         LA    1,P00046
         L     15,C00051
         BALR  14,15
         L     0,C00052
         ST    0,P00046+0
         LA    0,1
         ST    0,P00046+4
         LA    1,P00046
         L     15,C00053
         BALR  14,15
         L     15,C00054
         BALR  14,15
         LA    0,1
         ST    0,P00046+0
         L     0,C00055
         ST    0,P00046+4
         LA    1,P00046
         L     15,C00051
         BALR  14,15
         L     0,C00056
         ST    0,P00046+0
         LA    0,1
         ST    0,P00046+4
         LA    1,P00046
         L     15,C00053
         BALR  14,15
         L     15,C00054
         BALR  14,15
         LA    0,1
         ST    0,P00046+0
         L     0,C00057
         ST    0,P00046+4
         LA    1,P00046
         L     15,C00051
         BALR  14,15
         L     0,C00058
         ST    0,P00046+0
         LA    0,1
         ST    0,P00046+4
         LA    1,P00046
         L     15,C00053
         BALR  14,15
         L     0,C00059
         ST    0,P00046+0
         LA    0,1
         ST    0,P00046+4
         LA    1,P00046
         L     15,C00053
         BALR  14,15
         L     15,C00054
         BALR  14,15
         LA    0,1
         ST    0,P00046+0
         L     0,C00060
         ST    0,P00046+4
         LA    1,P00046
         L     15,C00051
         BALR  14,15
         L     15,C00054
         BALR  14,15
         LA    0,1
         ST    0,P00046+0
         LA    1,P00046
         L     15,C00061
         BALR  14,15
         LA    0,1
         ST    0,P00046+0
         L     0,C00055
         ST    0,P00046+4
         LA    0,1
         ST    0,P00046+8
         LA    1,P00046
         L     15,C00062
         BALR  14,15
         LR    2,15
         C     2,C00063
         BC    8,L00028
L00027   DS    0H
         LA    0,T00021
         ST    0,P00046+0
         LA    0,4
         ST    0,P00046+4
         LA    1,P00046
         L     15,C00064
         BALR  14,15
         LA    0,T00022
         ST    0,P00046+0
         LA    0,4
         ST    0,P00046+4
         LA    1,P00046
         L     15,C00064
         BALR  14,15
         LA    0,T00023
         ST    0,P00046+0
         LA    0,4
         ST    0,P00046+4
         LA    1,P00046
         L     15,C00064
         BALR  14,15
         L     15,C00065
         BALR  14,15
         LA    0,T00021
         ST    0,P00046+0
         LA    0,4
         ST    0,P00046+4
         L     0,C00066
         ST    0,P00046+8
         LA    0,1
         ST    0,P00046+12
         LA    1,P00046
         L     15,C00067
         BALR  14,15
         LR    3,15
         C     3,C00068
         LA    2,1
         BC    7,L00069
         SR    2,2
L00069   DS    0H
         LA    0,T00022
         ST    0,P00046+0
         LA    0,4
         ST    0,P00046+4
         L     0,C00070
         ST    0,P00046+8
         LA    0,1
         ST    0,P00046+12
         LA    1,P00046
         L     15,C00067
         BALR  14,15
         LR    4,15
         C     4,C00068
         LA    3,1
         BC    7,L00071
         SR    3,3
L00071   DS    0H
         OR    2,3
         LA    0,T00023
         ST    0,P00046+0
         LA    0,4
         ST    0,P00046+4
         L     0,C00072
         ST    0,P00046+8
         LA    0,1
         ST    0,P00046+12
         LA    1,P00046
         L     15,C00067
         BALR  14,15
         LR    4,15
         C     4,C00068
         LA    3,1
         BC    7,L00073
         SR    3,3
L00073   DS    0H
         OR    2,3
         LTR   2,2
         BC    7,L00029
L00030   DS    0H
         LA    0,1
         ST    0,P00046+0
         L     0,C00055
         ST    0,P00046+4
         LA    0,1
         ST    0,P00046+8
         LA    1,P00046
         L     15,C00062
         BALR  14,15
         LR    2,15
         C     2,C00063
         BC    8,L00028
L00031   DS    0H
         LA    0,T00021
         ST    0,P00046+0
         LA    0,4
         ST    0,P00046+4
         LA    1,P00046
         L     15,C00064
         BALR  14,15
         LA    0,T00022
         ST    0,P00046+0
         LA    0,4
         ST    0,P00046+4
         LA    1,P00046
         L     15,C00064
         BALR  14,15
         LA    0,T00023
         ST    0,P00046+0
         LA    0,4
         ST    0,P00046+4
         LA    1,P00046
         L     15,C00064
         BALR  14,15
         LA    0,T00024
         ST    0,P00046+0
         LA    0,4
         ST    0,P00046+4
         LA    1,P00046
         L     15,C00064
         BALR  14,15
         LA    0,T00025
         ST    0,P00046+0
         LA    0,4
         ST    0,P00046+4
         LA    1,P00046
         L     15,C00064
         BALR  14,15
         L     15,C00065
         BALR  14,15
         LA    0,T00021
         ST    0,P00046+0
         LA    0,4
         ST    0,P00046+4
         L     0,C00074
         ST    0,P00046+8
         LA    0,1
         ST    0,P00046+12
         LA    1,P00046
         L     15,C00067
         BALR  14,15
         LR    3,15
         C     3,C00068
         LA    2,1
         BC    7,L00075
         SR    2,2
L00075   DS    0H
         LA    0,T00022
         ST    0,P00046+0
         LA    0,4
         ST    0,P00046+4
         L     0,C00076
         ST    0,P00046+8
         LA    0,1
         ST    0,P00046+12
         LA    1,P00046
         L     15,C00067
         BALR  14,15
         LR    4,15
         C     4,C00068
         LA    3,1
         BC    7,L00077
         SR    3,3
L00077   DS    0H
         OR    2,3
         LA    0,T00023
         ST    0,P00046+0
         LA    0,4
         ST    0,P00046+4
         L     0,C00078
         ST    0,P00046+8
         LA    0,1
         ST    0,P00046+12
         LA    1,P00046
         L     15,C00067
         BALR  14,15
         LR    4,15
         C     4,C00068
         LA    3,1
         BC    7,L00079
         SR    3,3
L00079   DS    0H
         OR    2,3
         LTR   2,2
         BC    7,L00032
L00033   DS    0H
         LA    0,T00024
         ST    0,P00046+0
         LA    0,4
         ST    0,P00046+4
         L     0,C00080
         ST    0,P00046+8
         LA    0,1
         ST    0,P00046+12
         LA    1,P00046
         L     15,C00067
         BALR  14,15
         LR    3,15
         C     3,C00068
         LA    2,1
         BC    7,L00081
         SR    2,2
L00081   DS    0H
         LA    0,T00025
         ST    0,P00046+0
         LA    0,4
         ST    0,P00046+4
         L     0,C00082
         ST    0,P00046+8
         LA    0,1
         ST    0,P00046+12
         LA    1,P00046
         L     15,C00067
         BALR  14,15
         LR    4,15
         C     4,C00068
         LA    3,1
         BC    7,L00083
         SR    3,3
L00083   DS    0H
         OR    2,3
         LTR   2,2
         BC    7,L00034
L00035   DS    0H
         LA    0,6
         ST    0,P00046+0
         L     0,C00084
         ST    0,P00046+4
         LA    1,P00046
         L     15,C00051
         BALR  14,15
         L     15,C00054
         BALR  14,15
         LA    0,6
         ST    0,P00046+0
         L     0,C00085
         ST    0,P00046+4
         LA    1,P00046
         L     15,C00051
         BALR  14,15
         LA    0,2
         ST    0,P00046+0
         LA    1,P00046
         L     15,C00086
         BALR  14,15
         L     15,C00054
         BALR  14,15
         LA    0,0
         ST    0,P00046+0
         LA    1,P00046
         L     15,C00087
         BALR  14,15
         B     L00042
L00028   DS    0H
         LA    0,9
         ST    0,P00046+0
         LA    1,P00046
         L     15,C00087
         BALR  14,15
         B     L00042
L00029   DS    0H
         LA    0,1
         ST    0,P00046+0
         LA    1,P00046
         L     15,C00087
         BALR  14,15
         B     L00042
L00032   DS    0H
         LA    0,2
         ST    0,P00046+0
         LA    1,P00046
         L     15,C00087
         BALR  14,15
         B     L00042
L00034   DS    0H
         LA    0,3
         ST    0,P00046+0
         LA    1,P00046
         L     15,C00087
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
P00046   DS    13F
         DS    XL4
C00047   DC    A(Q00001)
C00048   DC    A(Q00002)
C00049   DC    V(F77OPEN)
C00050   DC    A(Q00003)
C00051   DC    V(F77WRBEG)
C00052   DC    A(Q00004)
C00053   DC    V(F77WRA)
C00054   DC    V(F77WREND)
C00055   DC    A(Q00005)
C00056   DC    A(Q00006)
C00057   DC    A(Q00007)
C00058   DC    A(Q00008)
C00059   DC    A(Q00009)
C00060   DC    A(Q00010)
C00061   DC    V(F77REWND)
C00062   DC    V(F77RDBEG)
C00063   DC    F'1'
C00064   DC    V(F77RDS)
C00065   DC    V(F77RDEND)
C00066   DC    A(Q00011)
C00067   DC    V(F77STRCM)
C00068   DC    F'0'
C00070   DC    A(Q00012)
C00072   DC    A(Q00013)
C00074   DC    A(Q00014)
C00076   DC    A(Q00015)
C00078   DC    A(Q00016)
C00080   DC    A(Q00017)
C00082   DC    A(Q00018)
C00084   DC    A(Q00019)
C00085   DC    A(Q00020)
C00086   DC    V(F77WRI)
C00087   DC    V(EXIT)
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
