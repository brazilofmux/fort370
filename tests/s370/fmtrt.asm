* main
F77MAIN  CSECT
         USING *,15
         B     L00028
         DC    AL1(7),CL7'F77MAIN'
L00028   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00029
L00030   DC    A(S00000)
L00029   L     15,L00030
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00013   DS    0H
L00014   DS    0H
         LA    10,12
         LA    11,36
         LA    2,12
         LA    3,1
L00015   DS    0H
L00017   DS    0H
         LA    7,T00011-16
         LA    8,10
         AR    7,2
         LA    9,30
         LA    4,10
         LA    5,4
L00018   DS    0H
         LR    6,4
         AR    6,3
         ST    6,0(5,7)
L00020   DS    0H
         A     5,C00031
         BXLE  4,8,L00018
L00019   DS    0H
         A     3,C00032
         BXLE  2,10,L00015
L00016   DS    0H
         LA    1,P00033
         L     15,C00034
         BALR  14,15
         LA    1,P00036
         L     15,C00037
         BALR  14,15
         LA    1,P00038
         L     15,C00039
         BALR  14,15
         LA    1,P00040
         L     15,C00039
         BALR  14,15
         LA    1,P00041
         L     15,C00039
         BALR  14,15
         LA    1,P00042
         L     15,C00039
         BALR  14,15
         LA    1,P00043
         L     15,C00039
         BALR  14,15
         LA    1,P00044
         L     15,C00039
         BALR  14,15
         L     15,C00045
         BALR  14,15
         LA    1,P00046
         L     15,C00047
         BALR  14,15
         LA    3,T00010
         A     3,C00048
         LA    1,P00049
         L     15,C00034
         BALR  14,15
         LR    0,3
         ST    0,P00050+0
         LA    1,P00050
         L     15,C00051
         BALR  14,15
         LA    1,P00041
         L     15,C00039
         BALR  14,15
         LA    1,P00042
         L     15,C00039
         BALR  14,15
         L     15,C00045
         BALR  14,15
         LA    1,P00043
         L     15,C00034
         BALR  14,15
         LA    1,P00052
         L     15,C00037
         BALR  14,15
         LA    1,P00053
         L     15,C00054
         BALR  14,15
         LA    1,P00055
         L     15,C00054
         BALR  14,15
         L     15,C00045
         BALR  14,15
         LA    1,P00056
         L     15,C00034
         BALR  14,15
         LA    1,P00057
         L     15,C00037
         BALR  14,15
         LA    6,3
         LA    7,3
L00021   DS    0H
         C     7,C00058
         BC    2,L00022
L00023   DS    0H
         L     15,C00045
         BALR  14,15
         LA    1,P00059
         L     15,C00034
         BALR  14,15
         LA    1,P00061
         L     15,C00037
         BALR  14,15
         LA    1,P00062
         L     15,C00039
         BALR  14,15
         LA    1,P00063
         L     15,C00039
         BALR  14,15
         L     15,C00045
         BALR  14,15
         LA    1,P00064
         L     15,C00034
         BALR  14,15
         LA    1,P00066
         L     15,C00037
         BALR  14,15
         LA    1,P00067
         L     15,C00039
         BALR  14,15
         L     15,C00045
         BALR  14,15
         LA    1,P00068
         L     15,C00034
         BALR  14,15
         LA    1,P00069
         L     15,C00037
         BALR  14,15
         LA    1,P00043
         L     15,C00039
         BALR  14,15
         LA    1,P00044
         L     15,C00039
         BALR  14,15
         L     15,C00045
         BALR  14,15
         LA    1,P00070
         L     15,C00047
         BALR  14,15
         LA    1,P00033
         L     15,C00034
         BALR  14,15
         LA    1,P00072
         L     15,C00073
         BALR  14,15
         LA    1,P00074
         L     15,C00075
         BALR  14,15
         LA    1,P00076
         L     15,C00075
         BALR  14,15
         L     15,C00077
         BALR  14,15
         LA    1,P00033
         L     15,C00034
         BALR  14,15
         LA    1,P00036
         L     15,C00037
         BALR  14,15
         L     3,T00008
         LR    0,3
         ST    0,P00078+0
         LA    1,P00078
         L     15,C00039
         BALR  14,15
         L     3,T00009
         LR    0,3
         ST    0,P00078+0
         LA    1,P00078
         L     15,C00039
         BALR  14,15
         L     15,C00045
         BALR  14,15
         LA    1,P00063
         L     15,C00034
         BALR  14,15
         LA    1,P00080
         L     15,C00073
         BALR  14,15
         LR    3,15
         C     3,C00032
         LA    2,1
         BC    8,L00081
         SR    2,2
L00081   DS    0H
         LCR   4,2
         LR    2,3
         X     2,C00082
         NR    2,4
         XR    2,3
         C     3,C00083
         LA    5,1
         BC    8,L00084
         SR    5,5
L00084   DS    0H
         LCR   4,5
         LA    3,1
         XR    3,2
         NR    3,4
         XR    2,3
         LA    1,P00074
         L     15,C00075
         BALR  14,15
         L     15,C00077
         BALR  14,15
         LA    1,P00056
         L     15,C00034
         BALR  14,15
         LA    1,P00085
         L     15,C00037
         BALR  14,15
         C     2,C00058
         LA    3,1
         BC    2,L00086
         SR    3,3
L00086   DS    0H
         LR    0,3
         ST    0,P00078+0
         LA    1,P00078
         L     15,C00087
         BALR  14,15
         L     15,C00045
         BALR  14,15
         B     L00027
L00022   DS    0H
         LR    5,6
         AH    5,C00088
         AH    5,C00089
         LA    2,3
         LA    3,1
L00024   DS    0H
         C     2,C00058
         BC    2,L00025
L00026   DS    0H
         AH    7,C00089
         A     6,C00090
         B     L00021
L00025   DS    0H
         LR    4,5
         AR    4,3
         SLL   4,2
         L     8,T00011(4)
         LR    0,8
         ST    0,P00078+0
         LA    1,P00078
         L     15,C00039
         BALR  14,15
         AH    3,C00091
         AH    2,C00089
         B     L00024
L00027   DS    0H
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
T00008   DS    XL8
T00009   DS    XL8
T00010   DS    XL36
         DS    XL4
T00011   DS    XL52
         DS    XL4
T00012   DS    XL80
P00033   DC    F'12'
P00036   DC    F'6'
         DC    A(G00035)
P00038   DC    F'1'
P00040   DC    F'2'
P00041   DC    F'3'
P00042   DC    F'4'
P00043   DC    F'5'
P00044   DC    F'6'
P00046   DC    A(T00010)
         DC    F'13'
         DC    A(Q00001)
         DC    F'6'
P00049   DC    F'15'
P00050   DC    A(0)
         DC    F'7'
         DC    F'1'
         DC    A(Q00002)
P00052   DC    F'6'
         DC    A(Q00003)
P00053   DC    A(Q00004)
         DC    F'2'
P00055   DC    A(T00010)
         DC    F'13'
P00056   DC    F'13'
P00057   DC    F'6'
         DC    A(T00010)
P00059   DC    F'22'
P00061   DC    F'6'
         DC    A(G00060)
P00062   DC    F'7'
P00063   DC    F'8'
P00064   DC    F'18'
P00066   DC    F'6'
         DC    A(G00065)
P00067   DC    F'9'
P00068   DC    F'16'
P00069   DC    F'6'
         DC    A(Q00005)
P00070   DC    A(T00012)
         DC    F'8'
         DC    A(Q00006)
         DC    F'6'
P00072   DC    A(T00012)
         DC    F'8'
         DC    F'1'
         DC    A(G00071)
         DC    F'0'
P00074   DC    A(T00008)
P00076   DC    A(T00009)
P00078   DC    A(0)
P00080   DC    A(T00012)
         DC    F'8'
         DC    F'1'
         DC    A(G00079)
         DC    F'2'
P00085   DC    F'6'
         DC    A(Q00007)
C00031   DC    F'4'
C00032   DC    F'1'
C00034   DC    V(F77FMTLM)
C00037   DC    V(F77WRBEG)
C00039   DC    V(F77WRI)
C00045   DC    V(F77WREND)
C00047   DC    V(F77STRCP)
C00048   DC    F'6'
C00051   DC    V(F77WRBI)
C00054   DC    V(F77WRA)
C00058   DC    F'0'
C00073   DC    V(F77RDBI)
C00075   DC    V(F77RDI)
C00077   DC    V(F77RDEND)
C00082   DC    F'-1'
C00083   DC    F'2'
C00087   DC    V(F77WRL)
C00090   DC    F'3'
C00088   DC    H'-3'
C00089   DC    H'-1'
C00091   DC    H'1'
Q00001   DC    C'('' >'','
Q00002   DC    C'(I2,''I'',I3,'')'')'
Q00003   DC    C'(A,A)'
Q00004   DC    C' >'
Q00005   DC    C'( '' >'' , 2 I 4 )'
Q00006   DC    C' 12 34'
Q00007   DC    C'('' >BAD '',L1)'
G00035   CSECT
         DS    0D
         DC    X'4D7D406E7D406BF3C940F25D'
G00060   CSECT
         DS    0D
         DC    X'4DF1E76B40F440C86E40C1C26B40F240C940F35D4040'
G00065   CSECT
         DS    0D
         DC    X'4D7D406E407D7DD87D7D7D6B40C940F25D40'
G00071   CSECT
         DS    0D
         DC    X'4D40F2C940F35D91A4959240'
G00079   CSECT
         DS    0D
         DC    X'4DC8C95D40404040'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
