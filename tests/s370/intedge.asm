* main
F77MAIN  CSECT
         USING *,15
         B     L00023
         DC    AL1(7),CL7'F77MAIN'
L00023   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00024
L00025   DC    A(S00000)
L00024   L     15,L00025
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00016   DS    0H
         LA    15,0
         ST    15,T00014
L00017   DS    0H
         LA    2,8
         LA    3,0
         L     4,C00026
L00018   DS    0H
         A     3,C00027
L00020   DS    0H
         LR    5,4
         A     5,C00027
         AH    2,C00028
         C     2,C00029
         BC    2,L00030
         B     L00019
L00030   DS    0H
         LR    4,5
         B     L00018
L00019   DS    0H
         C     3,C00031
         LA    2,1
         BC    8,L00032
         SR    2,2
L00032   DS    0H
         C     4,C00033
         LA    3,1
         BC    8,L00034
         SR    3,3
L00034   DS    0H
         NR    2,3
         ST    2,T00013
         L     0,C00036
         ST    0,P00035+0
         LA    0,T00013
         ST    0,P00035+4
         LA    0,T00014
         ST    0,P00035+8
         LA    0,6
         ST    0,P00035+12
         OI    P00035+12,X'80'
         LA    1,P00035
         L     15,C00037
         BALR  14,15
         LA    15,1
         ST    15,T00009
         L     0,C00038
         ST    0,P00035+0
         LA    0,T00009
         ST    0,P00035+4
         LA    0,T00014
         ST    0,P00035+8
         LA    0,6
         ST    0,P00035+12
         OI    P00035+12,X'80'
         LA    1,P00035
         L     15,C00037
         BALR  14,15
         LA    15,1
         ST    15,T00010
         L     0,C00039
         ST    0,P00035+0
         LA    0,T00010
         ST    0,P00035+4
         LA    0,T00014
         ST    0,P00035+8
         LA    0,6
         ST    0,P00035+12
         OI    P00035+12,X'80'
         LA    1,P00035
         L     15,C00037
         BALR  14,15
         L     14,C00042
         MVC   0(8,14),C00040
         L     14,C00042
         L     3,0(,14)
         L     15,C00044
         C     3,0(,15)
         LA    2,1
         BC    8,L00045
         SR    2,2
L00045   DS    0H
         L     14,C00046
         L     4,0(,14)
         L     15,C00044
         C     4,4(,15)
         LA    3,1
         BC    8,L00047
         SR    3,3
L00047   DS    0H
         NR    2,3
         ST    2,T00011
         L     0,C00048
         ST    0,P00035+0
         LA    0,T00011
         ST    0,P00035+4
         LA    0,T00014
         ST    0,P00035+8
         LA    0,6
         ST    0,P00035+12
         OI    P00035+12,X'80'
         LA    1,P00035
         L     15,C00037
         BALR  14,15
         LA    0,T00015
         ST    0,P00035+0
         LA    0,25
         ST    0,P00035+4
         L     0,C00049
         ST    0,P00035+8
         LA    0,24
         ST    0,P00035+12
         LA    1,P00035
         L     15,C00050
         BALR  14,15
         LA    0,7
         ST    0,P00035+0
         LA    1,P00035
         L     15,C00051
         BALR  14,15
         LA    0,T00015
         ST    0,P00035+0
         LA    0,25
         ST    0,P00035+4
         LA    0,1
         ST    0,P00035+8
         L     0,C00052
         ST    0,P00035+12
         LA    0,0
         ST    0,P00035+16
         LA    1,P00035
         L     15,C00053
         BALR  14,15
         L     0,C00055
         ST    0,P00035+0
         LA    1,P00035
         L     15,C00056
         BALR  14,15
         L     15,C00057
         BALR  14,15
         L     14,C00055
         L     3,0(,14)
         L     15,C00044
         C     3,0(,15)
         LA    2,1
         BC    8,L00058
         SR    2,2
L00058   DS    0H
         L     14,C00059
         L     4,0(,14)
         L     15,C00044
         C     4,4(,15)
         LA    3,1
         BC    8,L00060
         SR    3,3
L00060   DS    0H
         NR    2,3
         ST    2,T00012
         L     0,C00061
         ST    0,P00035+0
         LA    0,T00012
         ST    0,P00035+4
         LA    0,T00014
         ST    0,P00035+8
         LA    0,6
         ST    0,P00035+12
         OI    P00035+12,X'80'
         LA    1,P00035
         L     15,C00037
         BALR  14,15
         LA    0,6
         ST    0,P00035+0
         L     0,C00062
         ST    0,P00035+4
         LA    1,P00035
         L     15,C00063
         BALR  14,15
         L     3,T00014
         LR    0,3
         ST    0,P00035+0
         LA    1,P00035
         L     15,C00064
         BALR  14,15
         L     15,C00065
         BALR  14,15
L00021   DS    0H
L00022   DS    0H
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
T00009   DS    XL4
         DS    XL4
T00010   DS    XL4
         DS    XL4
T00011   DS    XL4
         DS    XL4
T00012   DS    XL4
         DS    XL4
T00013   DS    XL8
T00014   DS    XL48
T00015   DS    XL112
P00035   DS    5F
         DS    XL4
C00040   DC    X'011286D80EC190DB'
C00026   DC    F'2147483640'
C00027   DC    F'1'
C00029   DC    F'0'
C00031   DC    F'8'
C00033   DC    F'2147483647'
C00036   DC    A(Q00001)
C00037   DC    V(CHK)
C00038   DC    A(Q00002)
C00039   DC    A(Q00003)
C00042   DC    A(G00041)
C00044   DC    A(G00043)
C00046   DC    A(G00041+4)
C00048   DC    A(Q00004)
C00049   DC    A(Q00005)
C00050   DC    V(F77STRCP)
C00051   DC    V(F77FMTLM)
C00052   DC    A(Q00006)
C00053   DC    V(F77RDBI)
C00055   DC    A(G00054)
C00056   DC    V(F77RDD)
C00057   DC    V(F77RDEND)
C00059   DC    A(G00054+4)
C00061   DC    A(Q00007)
C00062   DC    A(Q00008)
C00063   DC    V(F77WRBEG)
C00064   DC    V(F77WRI)
C00065   DC    V(F77WREND)
C00028   DC    H'-1'
Q00008   DC    C'('' >BAD '',I2)'
Q00001   DC    C'DOTOP '
Q00002   DC    C'DIVM1 '
Q00003   DC    C'PARM1 '
Q00004   DC    C'DTINY '
Q00005   DC    C'  9.9999999999999974D-78'
Q00006   DC    C'(D25.0)'
Q00007   DC    C'RTINY '
* CHK
CHK      CSECT
         USING *,15
         B     L00076
         DC    AL1(3),CL7'CHK'
L00076   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00077
L00078   DC    A(S00066)
L00077   L     15,L00078
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00066,13
         ST    1,S00066+72
L00069   DS    0H
         L     5,0(,1)
         L     4,4(,1)
         L     3,8(,1)
         L     2,0(,4)
         LTR   2,2
         BC    7,L00070
L00071   DS    0H
         LA    0,6
         ST    0,P00079+0
         L     0,C00080
         ST    0,P00079+4
         LA    1,P00079
         L     15,C00081
         BALR  14,15
         LR    0,5
         ST    0,P00079+0
         LA    0,6
         ST    0,P00079+4
         LA    1,P00079
         L     15,C00082
         BALR  14,15
         L     15,C00083
         BALR  14,15
L00074   DS    0H
         L     2,0(,3)
         A     2,C00084
         ST    2,0(,3)
L00072   DS    0H
         LA    0,0
         B     L00075
L00070   DS    0H
         LA    0,6
         ST    0,P00079+0
         L     0,C00085
         ST    0,P00079+4
         LA    1,P00079
         L     15,C00081
         BALR  14,15
         LR    0,5
         ST    0,P00079+0
         LA    0,6
         ST    0,P00079+4
         LA    1,P00079
         L     15,C00082
         BALR  14,15
         L     15,C00083
         BALR  14,15
L00073   DS    0H
         B     L00072
L00075   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00066   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00079   DS    2F
C00080   DC    A(Q00068)
C00081   DC    V(F77WRBEG)
C00082   DC    V(F77WRA)
C00083   DC    V(F77WREND)
C00084   DC    F'1'
C00085   DC    A(Q00067)
Q00067   DC    C'('' >'',A6,'' OK'')'
Q00068   DC    C'('' >'',A6,'' BAD'')'
G00041   CSECT
         DS    0D
         DS    XL8
G00054   CSECT
         DS    0D
         DS    XL8
G00043   CSECT
         DS    0D
         DC    X'011286D80EC190DB'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
