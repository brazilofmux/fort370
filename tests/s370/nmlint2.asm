* main
F77MAIN  CSECT
         USING *,15
         B     L00033
         DC    AL1(7),CL7'F77MAIN'
L00033   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00034
L00035   DC    A(S00000)
L00034   L     15,L00035
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00016   DS    0H
         L     2,C00036
         AH    2,C00037
         LA    15,777
         L     14,C00036
         ST    15,0(,14)
         LH    15,C00038
         L     14,C00039
         ST    15,0(,14)
         LA    15,1
         L     14,C00040
         STH   15,0(,14)
         LH    15,C00041
         L     14,C00042
         STH   15,0(,14)
         LH    15,C00043
         L     14,C00044
         STH   15,0(,14)
         LA    15,1
         L     14,C00045
         STC   15,0(,14)
         LA    15,0
         L     14,C00046
         STC   15,0(,14)
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         LA    1,P00049
         L     15,C00050
         BALR  14,15
         LA    1,P00051
         L     15,C00052
         BALR  14,15
         LA    1,P00053
         L     15,C00052
         BALR  14,15
         LA    1,P00054
         L     15,C00052
         BALR  14,15
         L     15,C00055
         BALR  14,15
         LA    1,P00056
         L     15,C00057
         BALR  14,15
         LA    15,0
         L     14,C00040
         STH   15,0(,14)
         LA    15,0
         L     14,C00042
         STH   15,0(,14)
         LA    15,0
         L     14,C00044
         STH   15,0(,14)
         LA    15,0
         L     14,C00045
         STC   15,0(,14)
         LA    15,1
         L     14,C00046
         STC   15,0(,14)
         LA    1,P00058
         L     15,C00048
         BALR  14,15
         LA    1,P00049
         L     15,C00050
         BALR  14,15
         LA    1,P00059
         L     15,C00052
         BALR  14,15
         LA    1,P00060
         L     15,C00052
         BALR  14,15
         LA    1,P00061
         L     15,C00052
         BALR  14,15
         L     15,C00055
         BALR  14,15
         L     14,C00036
         L     3,0(,14)
         C     3,C00062
         BC    7,L00017
L00018   DS    0H
         L     14,C00039
         L     3,0(,14)
         C     3,C00063
         BC    7,L00019
L00020   DS    0H
         L     14,C00040
         LH    4,0(,14)
         C     4,C00064
         LA    3,1
         BC    7,L00065
         SR    3,3
L00065   DS    0H
         L     14,C00042
         LH    5,0(,14)
         C     5,C00066
         LA    4,1
         BC    7,L00067
         SR    4,4
L00067   DS    0H
         OR    3,4
         L     14,C00044
         LH    5,0(,14)
         C     5,C00068
         LA    4,1
         BC    7,L00069
         SR    4,4
L00069   DS    0H
         OR    3,4
         LTR   3,3
         BC    7,L00021
L00022   DS    0H
         L     14,C00045
         SR    4,4
         IC    4,0(,14)
         LTR   4,4
         LA    3,1
         BC    8,L00070
         SR    3,3
L00070   DS    0H
         L     14,C00046
         SR    4,4
         IC    4,0(,14)
         OR    3,4
         LTR   3,3
         BC    7,L00023
L00024   DS    0H
         LA    1,P00071
         L     15,C00072
         BALR  14,15
         LA    1,P00073
         L     15,C00074
         BALR  14,15
         L     15,C00075
         BALR  14,15
         LA    1,P00076
         L     15,C00057
         BALR  14,15
         LA    1,P00077
         L     15,C00048
         BALR  14,15
         LA    1,P00049
         L     15,C00050
         BALR  14,15
         LA    1,P00078
         L     15,C00052
         BALR  14,15
         LA    1,P00079
         L     15,C00052
         BALR  14,15
         LA    1,P00080
         L     15,C00052
         BALR  14,15
         L     15,C00055
         BALR  14,15
         L     14,C00036
         L     4,0(,14)
         C     4,C00062
         LA    3,1
         BC    7,L00081
         SR    3,3
L00081   DS    0H
         L     14,C00039
         L     5,0(,14)
         C     5,C00063
         LA    4,1
         BC    7,L00082
         SR    4,4
L00082   DS    0H
         OR    3,4
         LTR   3,3
         BC    7,L00025
L00026   DS    0H
         LA    1,P00083
         L     15,C00072
         BALR  14,15
         L     2,C00036
         AH    2,C00084
         LA    3,2
         LA    4,3
L00027   DS    0H
         C     4,C00085
         BC    2,L00028
L00029   DS    0H
         L     14,C00045
         SR    3,3
         IC    3,0(,14)
         LR    0,3
         ST    0,P00086+0
         LA    1,P00086
         L     15,C00087
         BALR  14,15
         L     14,C00046
         SR    3,3
         IC    3,0(,14)
         LR    0,3
         ST    0,P00086+0
         LA    1,P00086
         L     15,C00087
         BALR  14,15
         L     15,C00075
         BALR  14,15
L00030   DS    0H
L00031   DS    0H
         B     L00032
L00017   DS    0H
         LA    1,P00088
         L     15,C00089
         BALR  14,15
         B     L00032
L00019   DS    0H
         LA    1,P00090
         L     15,C00089
         BALR  14,15
         B     L00032
L00021   DS    0H
         LA    1,P00091
         L     15,C00089
         BALR  14,15
         B     L00032
L00023   DS    0H
         LA    1,P00092
         L     15,C00089
         BALR  14,15
         B     L00032
L00025   DS    0H
         LA    1,P00093
         L     15,C00089
         BALR  14,15
         B     L00032
L00028   DS    0H
         LH    6,0(3,2)
         LR    0,6
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00095
         BALR  14,15
         AH    4,C00096
         A     3,C00097
         B     L00027
L00032   DS    0H
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
P00047   DC    F'12'
         DC    A(Q00001)
         DC    F'4'
         DC    F'0'
         DC    F'0'
P00049   DC    F'1'
         DC    F'3'
P00051   DC    A(Q00002)
         DC    F'1'
         DC    F'1'
         DC    A(BOX+4)
         DC    F'2'
         DC    F'3'
P00053   DC    A(Q00003)
         DC    F'1'
         DC    F'6'
         DC    A(BOX+10)
         DC    F'1'
         DC    F'1'
P00054   DC    A(Q00004)
         DC    F'1'
         DC    F'6'
         DC    A(BOX+11)
         DC    F'1'
         DC    F'1'
P00056   DC    F'12'
P00058   DC    F'12'
         DC    A(Q00005)
         DC    F'4'
         DC    F'1'
         DC    F'0'
P00059   DC    A(Q00006)
         DC    F'1'
         DC    F'1'
         DC    A(BOX+4)
         DC    F'2'
         DC    F'3'
P00060   DC    A(Q00007)
         DC    F'1'
         DC    F'6'
         DC    A(BOX+10)
         DC    F'1'
         DC    F'1'
P00061   DC    A(Q00008)
         DC    F'1'
         DC    F'6'
         DC    A(BOX+11)
         DC    F'1'
         DC    F'1'
P00071   DC    F'9'
         DC    A(Q00009)
P00073   DC    A(Q00010)
         DC    F'29'
P00076   DC    F'9'
P00077   DC    F'9'
         DC    A(Q00011)
         DC    F'4'
         DC    F'1'
         DC    F'0'
P00078   DC    A(Q00012)
         DC    F'1'
         DC    F'1'
         DC    A(BOX+4)
         DC    F'2'
         DC    F'3'
P00079   DC    A(Q00013)
         DC    F'1'
         DC    F'6'
         DC    A(BOX+10)
         DC    F'1'
         DC    F'1'
P00080   DC    A(Q00014)
         DC    F'1'
         DC    F'6'
         DC    A(BOX+11)
         DC    F'1'
         DC    F'1'
P00083   DC    F'6'
         DC    A(Q00015)
P00086   DC    A(0)
P00088   DC    F'1'
P00090   DC    F'2'
P00091   DC    F'3'
P00092   DC    F'4'
P00093   DC    F'5'
P00094   DC    A(0)
         DC    F'2'
         DS    XL4
C00036   DC    A(BOX)
C00039   DC    A(BOX+12)
C00040   DC    A(BOX+4)
C00042   DC    A(BOX+6)
C00044   DC    A(BOX+8)
C00045   DC    A(BOX+10)
C00046   DC    A(BOX+11)
C00048   DC    V(F77NMLBG)
C00050   DC    V(F77NMLDM)
C00052   DC    V(F77NMLIT)
C00055   DC    V(F77NMLEN)
C00057   DC    V(F77REWND)
C00062   DC    F'777'
C00063   DC    F'-4242'
C00064   DC    F'1'
C00066   DC    F'-2'
C00068   DC    F'30003'
C00072   DC    V(F77WRBEG)
C00074   DC    V(F77WRA)
C00075   DC    V(F77WREND)
C00085   DC    F'0'
C00087   DC    V(F77WRL)
C00089   DC    V(EXIT)
C00095   DC    V(F77WRIN)
C00097   DC    F'2'
C00037   DC    H'4'
C00038   DC    H'-4242'
C00041   DC    H'-2'
C00043   DC    H'30003'
C00084   DC    H'2'
C00096   DC    H'-1'
Q00009   DC    C'(A)'
Q00015   DC    C'('' >NL '',3I7,2L2)'
Q00001   DC    C'PAIR'
Q00002   DC    C'H'
Q00003   DC    C'P'
Q00004   DC    C'Q'
Q00005   DC    C'PAIR'
Q00006   DC    C'H'
Q00007   DC    C'P'
Q00008   DC    C'Q'
Q00010   DC    C' &&PAIR H(2)=-7, Q=T, P=F &&END'
Q00011   DC    C'PAIR'
Q00012   DC    C'H'
Q00013   DC    C'P'
Q00014   DC    C'Q'
BOX      CSECT
         DS    0D
         DS    XL16
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
