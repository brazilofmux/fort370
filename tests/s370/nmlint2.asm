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
         L     6,C00036
         AH    6,C00038
         L     5,C00036
         AH    5,C00039
         LA    15,777
         L     14,C00036
         ST    15,0(,14)
         LH    15,C00040
         L     14,C00041
         ST    15,0(,14)
         LA    15,1
         L     14,C00042
         STH   15,0(,14)
         LH    15,C00043
         L     14,C00044
         STH   15,0(,14)
         LH    15,C00045
         L     14,C00046
         STH   15,0(,14)
         LA    15,1
         L     14,C00047
         STC   15,0(,14)
         LA    15,0
         L     14,C00048
         STC   15,0(,14)
         LA    0,12
         ST    0,P00049+0
         L     0,C00050
         ST    0,P00049+4
         LA    0,4
         ST    0,P00049+8
         LA    0,0
         ST    0,P00049+12
         LA    0,0
         ST    0,P00049+16
         LA    1,P00049
         L     15,C00051
         BALR  14,15
         LA    0,1
         ST    0,P00049+0
         LA    0,3
         ST    0,P00049+4
         LA    1,P00049
         L     15,C00052
         BALR  14,15
         L     0,C00053
         ST    0,P00049+0
         LA    0,1
         ST    0,P00049+4
         LA    0,1
         ST    0,P00049+8
         LR    0,2
         ST    0,P00049+12
         LA    0,2
         ST    0,P00049+16
         LA    0,3
         ST    0,P00049+20
         LA    1,P00049
         L     15,C00054
         BALR  14,15
         L     0,C00055
         ST    0,P00049+0
         LA    0,1
         ST    0,P00049+4
         LA    0,6
         ST    0,P00049+8
         LR    0,6
         ST    0,P00049+12
         LA    0,1
         ST    0,P00049+16
         LA    0,1
         ST    0,P00049+20
         LA    1,P00049
         L     15,C00054
         BALR  14,15
         L     0,C00056
         ST    0,P00049+0
         LA    0,1
         ST    0,P00049+4
         LA    0,6
         ST    0,P00049+8
         LR    0,5
         ST    0,P00049+12
         LA    0,1
         ST    0,P00049+16
         LA    0,1
         ST    0,P00049+20
         LA    1,P00049
         L     15,C00054
         BALR  14,15
         L     15,C00057
         BALR  14,15
         LA    0,12
         ST    0,P00049+0
         LA    1,P00049
         L     15,C00058
         BALR  14,15
         LA    15,0
         L     14,C00042
         STH   15,0(,14)
         LA    15,0
         L     14,C00044
         STH   15,0(,14)
         LA    15,0
         L     14,C00046
         STH   15,0(,14)
         LA    15,0
         L     14,C00047
         STC   15,0(,14)
         LA    15,1
         L     14,C00048
         STC   15,0(,14)
         LA    0,12
         ST    0,P00049+0
         L     0,C00059
         ST    0,P00049+4
         LA    0,4
         ST    0,P00049+8
         LA    0,1
         ST    0,P00049+12
         LA    0,0
         ST    0,P00049+16
         LA    1,P00049
         L     15,C00051
         BALR  14,15
         LA    0,1
         ST    0,P00049+0
         LA    0,3
         ST    0,P00049+4
         LA    1,P00049
         L     15,C00052
         BALR  14,15
         L     0,C00060
         ST    0,P00049+0
         LA    0,1
         ST    0,P00049+4
         LA    0,1
         ST    0,P00049+8
         LR    0,2
         ST    0,P00049+12
         LA    0,2
         ST    0,P00049+16
         LA    0,3
         ST    0,P00049+20
         LA    1,P00049
         L     15,C00054
         BALR  14,15
         L     0,C00061
         ST    0,P00049+0
         LA    0,1
         ST    0,P00049+4
         LA    0,6
         ST    0,P00049+8
         LR    0,6
         ST    0,P00049+12
         LA    0,1
         ST    0,P00049+16
         LA    0,1
         ST    0,P00049+20
         LA    1,P00049
         L     15,C00054
         BALR  14,15
         L     0,C00062
         ST    0,P00049+0
         LA    0,1
         ST    0,P00049+4
         LA    0,6
         ST    0,P00049+8
         LR    0,5
         ST    0,P00049+12
         LA    0,1
         ST    0,P00049+16
         LA    0,1
         ST    0,P00049+20
         LA    1,P00049
         L     15,C00054
         BALR  14,15
         L     15,C00057
         BALR  14,15
         L     14,C00036
         L     3,0(,14)
         C     3,C00063
         BC    7,L00017
L00018   DS    0H
         L     14,C00041
         L     3,0(,14)
         C     3,C00064
         BC    7,L00019
L00020   DS    0H
         L     14,C00042
         LH    4,0(,14)
         C     4,C00065
         LA    3,1
         BC    7,L00066
         SR    3,3
L00066   DS    0H
         L     14,C00044
         LH    7,0(,14)
         C     7,C00067
         LA    4,1
         BC    7,L00068
         SR    4,4
L00068   DS    0H
         OR    3,4
         L     14,C00046
         LH    7,0(,14)
         C     7,C00069
         LA    4,1
         BC    7,L00070
         SR    4,4
L00070   DS    0H
         OR    3,4
         LTR   3,3
         BC    7,L00021
L00022   DS    0H
         L     14,C00047
         SR    4,4
         IC    4,0(,14)
         LTR   4,4
         LA    3,1
         BC    8,L00071
         SR    3,3
L00071   DS    0H
         L     14,C00048
         SR    4,4
         IC    4,0(,14)
         OR    3,4
         LTR   3,3
         BC    7,L00023
L00024   DS    0H
         LA    0,9
         ST    0,P00049+0
         L     0,C00072
         ST    0,P00049+4
         LA    1,P00049
         L     15,C00073
         BALR  14,15
         L     0,C00074
         ST    0,P00049+0
         LA    0,29
         ST    0,P00049+4
         LA    1,P00049
         L     15,C00075
         BALR  14,15
         L     15,C00076
         BALR  14,15
         LA    0,9
         ST    0,P00049+0
         LA    1,P00049
         L     15,C00058
         BALR  14,15
         LA    0,9
         ST    0,P00049+0
         L     0,C00077
         ST    0,P00049+4
         LA    0,4
         ST    0,P00049+8
         LA    0,1
         ST    0,P00049+12
         LA    0,0
         ST    0,P00049+16
         LA    1,P00049
         L     15,C00051
         BALR  14,15
         LA    0,1
         ST    0,P00049+0
         LA    0,3
         ST    0,P00049+4
         LA    1,P00049
         L     15,C00052
         BALR  14,15
         L     0,C00078
         ST    0,P00049+0
         LA    0,1
         ST    0,P00049+4
         LA    0,1
         ST    0,P00049+8
         LR    0,2
         ST    0,P00049+12
         LA    0,2
         ST    0,P00049+16
         LA    0,3
         ST    0,P00049+20
         LA    1,P00049
         L     15,C00054
         BALR  14,15
         L     0,C00079
         ST    0,P00049+0
         LA    0,1
         ST    0,P00049+4
         LA    0,6
         ST    0,P00049+8
         LR    0,6
         ST    0,P00049+12
         LA    0,1
         ST    0,P00049+16
         LA    0,1
         ST    0,P00049+20
         LA    1,P00049
         L     15,C00054
         BALR  14,15
         L     0,C00080
         ST    0,P00049+0
         LA    0,1
         ST    0,P00049+4
         LA    0,6
         ST    0,P00049+8
         LR    0,5
         ST    0,P00049+12
         LA    0,1
         ST    0,P00049+16
         LA    0,1
         ST    0,P00049+20
         LA    1,P00049
         L     15,C00054
         BALR  14,15
         L     15,C00057
         BALR  14,15
         L     14,C00036
         L     4,0(,14)
         C     4,C00063
         LA    3,1
         BC    7,L00081
         SR    3,3
L00081   DS    0H
         L     14,C00041
         L     7,0(,14)
         C     7,C00064
         LA    4,1
         BC    7,L00082
         SR    4,4
L00082   DS    0H
         OR    3,4
         LTR   3,3
         BC    7,L00025
L00026   DS    0H
         LA    0,6
         ST    0,P00049+0
         L     0,C00083
         ST    0,P00049+4
         LA    1,P00049
         L     15,C00073
         BALR  14,15
         L     2,C00036
         AH    2,C00084
         LA    3,2
         LA    4,3
L00027   DS    0H
         C     4,C00085
         BC    2,L00028
L00029   DS    0H
         L     14,C00047
         SR    3,3
         IC    3,0(,14)
         LR    0,3
         ST    0,P00049+0
         LA    1,P00049
         L     15,C00086
         BALR  14,15
         L     14,C00048
         SR    3,3
         IC    3,0(,14)
         LR    0,3
         ST    0,P00049+0
         LA    1,P00049
         L     15,C00086
         BALR  14,15
         L     15,C00076
         BALR  14,15
L00030   DS    0H
L00031   DS    0H
         B     L00032
L00017   DS    0H
         LA    0,1
         ST    0,P00049+0
         LA    1,P00049
         L     15,C00087
         BALR  14,15
         B     L00032
L00019   DS    0H
         LA    0,2
         ST    0,P00049+0
         LA    1,P00049
         L     15,C00087
         BALR  14,15
         B     L00032
L00021   DS    0H
         LA    0,3
         ST    0,P00049+0
         LA    1,P00049
         L     15,C00087
         BALR  14,15
         B     L00032
L00023   DS    0H
         LA    0,4
         ST    0,P00049+0
         LA    1,P00049
         L     15,C00087
         BALR  14,15
         B     L00032
L00025   DS    0H
         LA    0,5
         ST    0,P00049+0
         LA    1,P00049
         L     15,C00087
         BALR  14,15
         B     L00032
L00028   DS    0H
         LH    8,0(3,2)
         LR    0,8
         ST    0,P00049+0
         LA    0,2
         ST    0,P00049+4
         LA    1,P00049
         L     15,C00088
         BALR  14,15
         AH    4,C00089
         A     3,C00090
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
P00049   DS    6F
C00036   DC    A(BOX)
C00041   DC    A(BOX+12)
C00042   DC    A(BOX+4)
C00044   DC    A(BOX+6)
C00046   DC    A(BOX+8)
C00047   DC    A(BOX+10)
C00048   DC    A(BOX+11)
C00050   DC    A(Q00001)
C00051   DC    V(F77NMLBG)
C00052   DC    V(F77NMLDM)
C00053   DC    A(Q00002)
C00054   DC    V(F77NMLIT)
C00055   DC    A(Q00003)
C00056   DC    A(Q00004)
C00057   DC    V(F77NMLEN)
C00058   DC    V(F77REWND)
C00059   DC    A(Q00005)
C00060   DC    A(Q00006)
C00061   DC    A(Q00007)
C00062   DC    A(Q00008)
C00063   DC    F'777'
C00064   DC    F'-4242'
C00065   DC    F'1'
C00067   DC    F'-2'
C00069   DC    F'30003'
C00072   DC    A(Q00009)
C00073   DC    V(F77WRBEG)
C00074   DC    A(Q00010)
C00075   DC    V(F77WRA)
C00076   DC    V(F77WREND)
C00077   DC    A(Q00011)
C00078   DC    A(Q00012)
C00079   DC    A(Q00013)
C00080   DC    A(Q00014)
C00083   DC    A(Q00015)
C00085   DC    F'0'
C00086   DC    V(F77WRL)
C00087   DC    V(EXIT)
C00088   DC    V(F77WRIN)
C00090   DC    F'2'
C00037   DC    H'4'
C00038   DC    H'10'
C00039   DC    H'11'
C00040   DC    H'-4242'
C00043   DC    H'-2'
C00045   DC    H'30003'
C00084   DC    H'2'
C00089   DC    H'-1'
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
