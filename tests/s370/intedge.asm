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
         LA    1,P00037
         L     15,C00038
         BALR  14,15
         LA    15,1
         ST    15,T00010
         LA    1,P00039
         L     15,C00038
         BALR  14,15
         LA    15,1
         ST    15,T00011
         LA    1,P00040
         L     15,C00038
         BALR  14,15
         L     14,C00043
         MVC   0(8,14),C00041
         L     14,C00043
         L     3,0(,14)
         L     15,C00045
         C     3,0(,15)
         LA    2,1
         BC    8,L00046
         SR    2,2
L00046   DS    0H
         L     14,C00047
         L     4,0(,14)
         L     15,C00045
         C     4,4(,15)
         LA    3,1
         BC    8,L00048
         SR    3,3
L00048   DS    0H
         NR    2,3
         ST    2,T00012
         LA    1,P00049
         L     15,C00038
         BALR  14,15
         LA    1,P00050
         L     15,C00051
         BALR  14,15
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         LA    1,P00054
         L     15,C00055
         BALR  14,15
         LA    1,P00057
         L     15,C00058
         BALR  14,15
         L     15,C00059
         BALR  14,15
         L     14,C00060
         L     3,0(,14)
         L     15,C00045
         C     3,0(,15)
         LA    2,1
         BC    8,L00061
         SR    2,2
L00061   DS    0H
         L     14,C00062
         L     4,0(,14)
         L     15,C00045
         C     4,4(,15)
         LA    3,1
         BC    8,L00063
         SR    3,3
L00063   DS    0H
         NR    2,3
         ST    2,T00013
         LA    1,P00064
         L     15,C00038
         BALR  14,15
         LA    1,P00065
         L     15,C00066
         BALR  14,15
         LA    1,P00067
         L     15,C00068
         BALR  14,15
         L     14,C00070
         LD    0,0(,14)
         STD   0,S00000+408
         LD    0,S00000+408
         STD   0,P00071+0
         LA    1,P00071
         L     15,C00072
         BALR  14,15
         L     15,C00073
         BALR  14,15
         LA    1,P00065
         L     15,C00066
         BALR  14,15
         LA    1,P00074
         L     15,C00075
         BALR  14,15
         LA    1,P00057
         L     15,C00058
         BALR  14,15
         L     15,C00059
         BALR  14,15
         L     14,C00060
         L     3,0(,14)
         L     15,C00070
         C     3,0(,15)
         LA    2,1
         BC    8,L00076
         SR    2,2
L00076   DS    0H
         L     14,C00062
         L     4,0(,14)
         L     15,C00070
         C     4,4(,15)
         LA    3,1
         BC    8,L00077
         SR    3,3
L00077   DS    0H
         NR    2,3
         ST    2,T00014
         LA    1,P00078
         L     15,C00038
         BALR  14,15
         LA    1,P00079
         L     15,C00068
         BALR  14,15
         L     3,T00016
         LR    0,3
         ST    0,P00080+0
         LA    1,P00080
         L     15,C00081
         BALR  14,15
         L     15,C00073
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
P00037   DC    A(Q00001)
         DC    A(T00015)
         DC    A(T00016)
         DC    XL1'80',FL3'6'
P00039   DC    A(Q00002)
         DC    A(T00010)
         DC    A(T00016)
         DC    XL1'80',FL3'6'
P00040   DC    A(Q00003)
         DC    A(T00011)
         DC    A(T00016)
         DC    XL1'80',FL3'6'
P00049   DC    A(Q00004)
         DC    A(T00012)
         DC    A(T00016)
         DC    XL1'80',FL3'6'
P00050   DC    A(T00017)
         DC    F'25'
         DC    A(Q00005)
         DC    F'24'
P00052   DC    F'7'
P00054   DC    A(T00017)
         DC    F'25'
         DC    F'1'
         DC    A(Q00006)
         DC    F'0'
P00057   DC    A(G00056)
P00064   DC    A(Q00007)
         DC    A(T00013)
         DC    A(T00016)
         DC    XL1'80',FL3'6'
P00065   DC    F'10'
P00067   DC    F'10'
         DC    F'0'
P00071   DC    A(0)
         DC    A(0)
P00074   DC    F'10'
         DC    F'0'
         DC    F'0'
P00078   DC    A(Q00008)
         DC    A(T00014)
         DC    A(T00016)
         DC    XL1'80',FL3'6'
P00079   DC    F'6'
         DC    A(Q00009)
P00080   DC    A(0)
C00041   DC    X'011286D80EC190DB'
C00028   DC    F'2147483640'
C00029   DC    F'1'
C00031   DC    F'0'
C00033   DC    F'8'
C00035   DC    F'2147483647'
C00038   DC    V(CHK)
C00043   DC    A(G00042)
C00045   DC    A(G00044)
C00047   DC    A(G00042+4)
C00051   DC    V(F77STRCP)
C00053   DC    V(F77FMTLM)
C00055   DC    V(F77RDBI)
C00058   DC    V(F77RDD)
C00059   DC    V(F77RDEND)
C00060   DC    A(G00056)
C00062   DC    A(G00056+4)
C00066   DC    V(F77REWND)
C00068   DC    V(F77WRBEG)
C00070   DC    A(G00069)
C00072   DC    V(F77WRD)
C00073   DC    V(F77WREND)
C00075   DC    V(F77RDBEG)
C00081   DC    V(F77WRI)
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
         B     L00092
         DC    AL1(3),CL7'CHK'
L00092   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00093
L00094   DC    A(S00082)
L00093   L     15,L00094
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00082,13
         ST    1,S00082+72
L00085   DS    0H
         L     5,0(,1)
         L     4,4(,1)
         L     3,8(,1)
         L     2,0(,4)
         LTR   2,2
         BC    7,L00086
L00087   DS    0H
         LA    1,P00095
         L     15,C00096
         BALR  14,15
         LR    0,5
         ST    0,P00097+0
         LA    1,P00097
         L     15,C00098
         BALR  14,15
         L     15,C00099
         BALR  14,15
L00090   DS    0H
         L     2,0(,3)
         A     2,C00100
         ST    2,0(,3)
L00088   DS    0H
         LA    0,0
         B     L00091
L00086   DS    0H
         LA    1,P00101
         L     15,C00096
         BALR  14,15
         LR    0,5
         ST    0,P00097+0
         LA    1,P00097
         L     15,C00098
         BALR  14,15
         L     15,C00099
         BALR  14,15
L00089   DS    0H
         B     L00088
L00091   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00082   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00095   DC    F'6'
         DC    A(Q00084)
P00097   DC    A(0)
         DC    F'6'
P00101   DC    F'6'
         DC    A(Q00083)
C00096   DC    V(F77WRBEG)
C00098   DC    V(F77WRA)
C00099   DC    V(F77WREND)
C00100   DC    F'1'
Q00083   DC    C'('' >'',A6,'' OK'')'
Q00084   DC    C'('' >'',A6,'' BAD'')'
G00042   CSECT
         DS    0D
         DS    XL8
G00056   CSECT
         DS    0D
         DS    XL8
G00044   CSECT
         DS    0D
         DC    X'011286D80EC190DB'
G00069   CSECT
         DS    0D
         DC    X'8010000000000000'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
