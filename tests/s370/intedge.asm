* main
F77MAIN  CSECT
         USING *,15
         B     L00025
         DC    AL1(7),CL7'F77MAIN'
L00025   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00026
L00027   DC    A(S00000)
L00026   L     15,L00027
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00018   DS    0H
         LA    15,0
         ST    15,T00016
L00019   DS    0H
         LA    2,8
         LA    3,0
         L     4,C00028
L00020   DS    0H
         A     3,C00029
L00022   DS    0H
         LR    5,4
         A     5,C00029
         AH    2,C00030
         C     2,C00031
         BC    2,L00032
         B     L00021
L00032   DS    0H
         LR    4,5
         B     L00020
L00021   DS    0H
         C     3,C00033
         LA    2,1
         BC    8,L00034
         SR    2,2
L00034   DS    0H
         C     4,C00035
         LA    3,1
         BC    8,L00036
         SR    3,3
L00036   DS    0H
         NR    2,3
         ST    2,T00015
         L     0,C00038
         ST    0,P00037+0
         LA    0,T00015
         ST    0,P00037+4
         LA    0,T00016
         ST    0,P00037+8
         LA    0,6
         ST    0,P00037+12
         OI    P00037+12,X'80'
         LA    1,P00037
         L     15,C00039
         BALR  14,15
         LA    15,1
         ST    15,T00010
         L     0,C00040
         ST    0,P00037+0
         LA    0,T00010
         ST    0,P00037+4
         LA    0,T00016
         ST    0,P00037+8
         LA    0,6
         ST    0,P00037+12
         OI    P00037+12,X'80'
         LA    1,P00037
         L     15,C00039
         BALR  14,15
         LA    15,1
         ST    15,T00011
         L     0,C00041
         ST    0,P00037+0
         LA    0,T00011
         ST    0,P00037+4
         LA    0,T00016
         ST    0,P00037+8
         LA    0,6
         ST    0,P00037+12
         OI    P00037+12,X'80'
         LA    1,P00037
         L     15,C00039
         BALR  14,15
         L     14,C00044
         MVC   0(8,14),C00042
         L     14,C00044
         L     3,0(,14)
         L     15,C00046
         C     3,0(,15)
         LA    2,1
         BC    8,L00047
         SR    2,2
L00047   DS    0H
         L     14,C00048
         L     4,0(,14)
         L     15,C00046
         C     4,4(,15)
         LA    3,1
         BC    8,L00049
         SR    3,3
L00049   DS    0H
         NR    2,3
         ST    2,T00012
         L     0,C00050
         ST    0,P00037+0
         LA    0,T00012
         ST    0,P00037+4
         LA    0,T00016
         ST    0,P00037+8
         LA    0,6
         ST    0,P00037+12
         OI    P00037+12,X'80'
         LA    1,P00037
         L     15,C00039
         BALR  14,15
         LA    0,T00017
         ST    0,P00037+0
         LA    0,25
         ST    0,P00037+4
         L     0,C00051
         ST    0,P00037+8
         LA    0,24
         ST    0,P00037+12
         LA    1,P00037
         L     15,C00052
         BALR  14,15
         LA    0,7
         ST    0,P00037+0
         LA    1,P00037
         L     15,C00053
         BALR  14,15
         LA    0,T00017
         ST    0,P00037+0
         LA    0,25
         ST    0,P00037+4
         LA    0,1
         ST    0,P00037+8
         L     0,C00054
         ST    0,P00037+12
         LA    0,0
         ST    0,P00037+16
         LA    1,P00037
         L     15,C00055
         BALR  14,15
         L     0,C00057
         ST    0,P00037+0
         LA    1,P00037
         L     15,C00058
         BALR  14,15
         L     15,C00059
         BALR  14,15
         L     14,C00057
         L     3,0(,14)
         L     15,C00046
         C     3,0(,15)
         LA    2,1
         BC    8,L00060
         SR    2,2
L00060   DS    0H
         L     14,C00061
         L     4,0(,14)
         L     15,C00046
         C     4,4(,15)
         LA    3,1
         BC    8,L00062
         SR    3,3
L00062   DS    0H
         NR    2,3
         ST    2,T00013
         L     0,C00063
         ST    0,P00037+0
         LA    0,T00013
         ST    0,P00037+4
         LA    0,T00016
         ST    0,P00037+8
         LA    0,6
         ST    0,P00037+12
         OI    P00037+12,X'80'
         LA    1,P00037
         L     15,C00039
         BALR  14,15
         LA    0,10
         ST    0,P00037+0
         LA    1,P00037
         L     15,C00064
         BALR  14,15
         LA    0,10
         ST    0,P00037+0
         LA    0,0
         ST    0,P00037+4
         LA    1,P00037
         L     15,C00065
         BALR  14,15
         L     14,C00067
         LD    0,0(,14)
         STD   0,S00000+408
         LD    0,S00000+408
         STD   0,P00037+0
         LA    1,P00037
         L     15,C00068
         BALR  14,15
         L     15,C00069
         BALR  14,15
         LA    0,10
         ST    0,P00037+0
         LA    1,P00037
         L     15,C00064
         BALR  14,15
         LA    0,10
         ST    0,P00037+0
         LA    0,0
         ST    0,P00037+4
         LA    0,0
         ST    0,P00037+8
         LA    1,P00037
         L     15,C00070
         BALR  14,15
         L     0,C00057
         ST    0,P00037+0
         LA    1,P00037
         L     15,C00058
         BALR  14,15
         L     15,C00059
         BALR  14,15
         L     14,C00057
         L     3,0(,14)
         L     15,C00067
         C     3,0(,15)
         LA    2,1
         BC    8,L00071
         SR    2,2
L00071   DS    0H
         L     14,C00061
         L     4,0(,14)
         L     15,C00067
         C     4,4(,15)
         LA    3,1
         BC    8,L00072
         SR    3,3
L00072   DS    0H
         NR    2,3
         ST    2,T00014
         L     0,C00073
         ST    0,P00037+0
         LA    0,T00014
         ST    0,P00037+4
         LA    0,T00016
         ST    0,P00037+8
         LA    0,6
         ST    0,P00037+12
         OI    P00037+12,X'80'
         LA    1,P00037
         L     15,C00039
         BALR  14,15
         LA    0,6
         ST    0,P00037+0
         L     0,C00074
         ST    0,P00037+4
         LA    1,P00037
         L     15,C00065
         BALR  14,15
         L     3,T00016
         LR    0,3
         ST    0,P00037+0
         LA    1,P00037
         L     15,C00075
         BALR  14,15
         L     15,C00069
         BALR  14,15
L00023   DS    0H
L00024   DS    0H
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
T00010   DS    XL4
         DS    XL4
T00011   DS    XL4
         DS    XL4
T00012   DS    XL4
         DS    XL4
T00013   DS    XL4
         DS    XL4
T00014   DS    XL4
         DS    XL4
T00015   DS    XL8
T00016   DS    XL48
T00017   DS    XL136
         DS    1D
P00037   DS    5F
         DS    XL4
C00042   DC    X'011286D80EC190DB'
C00028   DC    F'2147483640'
C00029   DC    F'1'
C00031   DC    F'0'
C00033   DC    F'8'
C00035   DC    F'2147483647'
C00038   DC    A(Q00001)
C00039   DC    V(CHK)
C00040   DC    A(Q00002)
C00041   DC    A(Q00003)
C00044   DC    A(G00043)
C00046   DC    A(G00045)
C00048   DC    A(G00043+4)
C00050   DC    A(Q00004)
C00051   DC    A(Q00005)
C00052   DC    V(F77STRCP)
C00053   DC    V(F77FMTLM)
C00054   DC    A(Q00006)
C00055   DC    V(F77RDBI)
C00057   DC    A(G00056)
C00058   DC    V(F77RDD)
C00059   DC    V(F77RDEND)
C00061   DC    A(G00056+4)
C00063   DC    A(Q00007)
C00064   DC    V(F77REWND)
C00065   DC    V(F77WRBEG)
C00067   DC    A(G00066)
C00068   DC    V(F77WRD)
C00069   DC    V(F77WREND)
C00070   DC    V(F77RDBEG)
C00073   DC    A(Q00008)
C00074   DC    A(Q00009)
C00075   DC    V(F77WRI)
C00030   DC    H'-1'
Q00009   DC    C'('' >BAD '',I2)'
Q00001   DC    C'DOTOP '
Q00002   DC    C'DIVM1 '
Q00003   DC    C'PARM1 '
Q00004   DC    C'DTINY '
Q00005   DC    C'  9.9999999999999974D-78'
Q00006   DC    C'(D25.0)'
Q00007   DC    C'RTINY '
Q00008   DC    C'RTMIN '
* CHK
CHK      CSECT
         USING *,15
         B     L00086
         DC    AL1(3),CL7'CHK'
L00086   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00087
L00088   DC    A(S00076)
L00087   L     15,L00088
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00076,13
         ST    1,S00076+72
L00079   DS    0H
         L     5,0(,1)
         L     4,4(,1)
         L     3,8(,1)
         L     2,0(,4)
         LTR   2,2
         BC    7,L00080
L00081   DS    0H
         LA    0,6
         ST    0,P00089+0
         L     0,C00090
         ST    0,P00089+4
         LA    1,P00089
         L     15,C00091
         BALR  14,15
         LR    0,5
         ST    0,P00089+0
         LA    0,6
         ST    0,P00089+4
         LA    1,P00089
         L     15,C00092
         BALR  14,15
         L     15,C00093
         BALR  14,15
L00084   DS    0H
         L     2,0(,3)
         A     2,C00094
         ST    2,0(,3)
L00082   DS    0H
         LA    0,0
         B     L00085
L00080   DS    0H
         LA    0,6
         ST    0,P00089+0
         L     0,C00095
         ST    0,P00089+4
         LA    1,P00089
         L     15,C00091
         BALR  14,15
         LR    0,5
         ST    0,P00089+0
         LA    0,6
         ST    0,P00089+4
         LA    1,P00089
         L     15,C00092
         BALR  14,15
         L     15,C00093
         BALR  14,15
L00083   DS    0H
         B     L00082
L00085   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00076   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00089   DS    2F
C00090   DC    A(Q00078)
C00091   DC    V(F77WRBEG)
C00092   DC    V(F77WRA)
C00093   DC    V(F77WREND)
C00094   DC    F'1'
C00095   DC    A(Q00077)
Q00077   DC    C'('' >'',A6,'' OK'')'
Q00078   DC    C'('' >'',A6,'' BAD'')'
G00043   CSECT
         DS    0D
         DS    XL8
G00056   CSECT
         DS    0D
         DS    XL8
G00045   CSECT
         DS    0D
         DC    X'011286D80EC190DB'
G00066   CSECT
         DS    0D
         DC    X'8010000000000000'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
