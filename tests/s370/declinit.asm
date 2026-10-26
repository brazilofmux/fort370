* main
F77MAIN  CSECT
         USING *,15
         B     L00027
         DC    AL1(7),CL7'F77MAIN'
L00027   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00028
L00029   DC    A(S00000)
L00028   L     15,L00029
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00020   DS    0H
         LA    15,0
         ST    15,T00013
L00021   DS    0H
         LA    11,T00015-4
         LA    10,T00019-4
         LA    9,T00016-4
         LA    8,T00017-8
         LA    5,T00018-8
         LA    6,8
         LA    7,24
         LA    2,8
         LA    3,4
L00022   DS    0H
         LR    4,11
         AR    4,3
         LR    0,4
         ST    0,P00030+0
         OI    P00030+0,X'80'
         LA    1,P00030
         L     15,C00031
         BALR  14,15
         LR    4,10
         AR    4,3
         LR    0,4
         ST    0,P00030+0
         OI    P00030+0,X'80'
         LA    1,P00030
         L     15,C00032
         BALR  14,15
         LR    4,9
         AR    4,3
         LR    0,4
         ST    0,P00030+0
         OI    P00030+0,X'80'
         LA    1,P00030
         L     15,C00033
         BALR  14,15
         LR    4,8
         AR    4,2
         LR    0,4
         ST    0,P00030+0
         OI    P00030+0,X'80'
         LA    1,P00030
         L     15,C00034
         BALR  14,15
         LR    4,5
         AR    4,2
         LR    0,4
         ST    0,P00030+0
         OI    P00030+0,X'80'
         LA    1,P00030
         L     15,C00035
         BALR  14,15
L00024   DS    0H
         A     3,C00036
         BXLE  2,6,L00022
L00023   DS    0H
         L     3,T00015
         C     3,C00037
         LA    2,1
         BC    8,L00038
         SR    2,2
L00038   DS    0H
         L     4,T00015+4
         C     4,C00039
         LA    3,1
         BC    8,L00040
         SR    3,3
L00040   DS    0H
         NR    2,3
         L     4,T00015+8
         C     4,C00041
         LA    3,1
         BC    8,L00042
         SR    3,3
L00042   DS    0H
         NR    2,3
         ST    2,T00014
         LA    1,P00043
         L     15,C00044
         BALR  14,15
         LE    0,C00045
         CE    0,T00019
         LA    2,1
         BC    8,L00046
         SR    2,2
L00046   DS    0H
         LE    0,C00047
         CE    0,T00019+4
         LA    3,1
         BC    8,L00048
         SR    3,3
L00048   DS    0H
         NR    2,3
         LE    0,C00049
         CE    0,T00019+8
         LA    3,1
         BC    8,L00050
         SR    3,3
L00050   DS    0H
         NR    2,3
         ST    2,T00008
         LA    1,P00051
         L     15,C00044
         BALR  14,15
         L     3,T00016+4
         LTR   3,3
         LA    2,1
         BC    8,L00052
         SR    2,2
L00052   DS    0H
         N     2,T00016
         N     2,T00016+8
         ST    2,T00009
         LA    1,P00053
         L     15,C00044
         BALR  14,15
         LD    0,C00054
         CD    0,T00017
         LA    2,1
         BC    8,L00055
         SR    2,2
L00055   DS    0H
         LD    0,C00056
         CD    0,T00017+8
         LA    3,1
         BC    8,L00057
         SR    3,3
L00057   DS    0H
         NR    2,3
         LD    0,C00058
         CD    0,T00017+16
         LA    3,1
         BC    8,L00059
         SR    3,3
L00059   DS    0H
         NR    2,3
         ST    2,T00010
         LA    1,P00060
         L     15,C00044
         BALR  14,15
         LE    0,C00061
         CE    0,T00018
         LA    2,1
         BC    8,L00062
         SR    2,2
L00062   DS    0H
         LE    0,C00063
         CE    0,T00018+4
         LA    3,1
         BC    8,L00064
         SR    3,3
L00064   DS    0H
         NR    2,3
         LE    0,C00063
         CE    0,T00018+8
         LA    3,1
         BC    8,L00065
         SR    3,3
L00065   DS    0H
         LE    0,C00066
         CE    0,T00018+12
         LA    4,1
         BC    8,L00067
         SR    4,4
L00067   DS    0H
         NR    3,4
         NR    2,3
         LE    0,C00066
         CE    0,T00018+16
         LA    3,1
         BC    8,L00068
         SR    3,3
L00068   DS    0H
         LE    0,C00069
         CE    0,T00018+20
         LA    4,1
         BC    8,L00070
         SR    4,4
L00070   DS    0H
         NR    3,4
         NR    2,3
         ST    2,T00011
         LA    1,P00071
         L     15,C00044
         BALR  14,15
         L     15,C00072
         BALR  14,15
         LR    3,0
         C     3,C00073
         LA    2,1
         BC    8,L00074
         SR    2,2
L00074   DS    0H
         L     15,C00072
         BALR  14,15
         LR    4,0
         C     4,C00075
         LA    3,1
         BC    8,L00076
         SR    3,3
L00076   DS    0H
         NR    2,3
         ST    2,T00012
         LA    1,P00077
         L     15,C00044
         BALR  14,15
         LA    1,P00078
         L     15,C00079
         BALR  14,15
         L     3,T00013
         LR    0,3
         ST    0,P00080+0
         LA    1,P00080
         L     15,C00081
         BALR  14,15
         L     15,C00082
         BALR  14,15
L00025   DS    0H
L00026   DS    0H
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
T00008   DS    XL4
         DS    XL4
T00009   DS    XL4
         DS    XL4
T00010   DS    XL4
         DS    XL4
T00011   DS    XL4
         DS    XL4
T00012   DS    XL4
         DS    XL4
T00013   DS    XL8
T00014   DS    XL8
T00015   DS    XL16
T00016   DS    XL16
T00017   DS    XL28
         DS    XL4
T00018   DS    XL28
         DS    XL4
T00019   DS    XL32
         DS    1D
P00030   DC    XL1'80',AL3(0)
P00043   DC    A(Q00001)
         DC    A(T00014)
         DC    A(T00013)
         DC    XL1'80',FL3'6'
P00051   DC    A(Q00002)
         DC    A(T00008)
         DC    A(T00013)
         DC    XL1'80',FL3'6'
P00053   DC    A(Q00003)
         DC    A(T00009)
         DC    A(T00013)
         DC    XL1'80',FL3'6'
P00060   DC    A(Q00004)
         DC    A(T00010)
         DC    A(T00013)
         DC    XL1'80',FL3'6'
P00071   DC    A(Q00005)
         DC    A(T00011)
         DC    A(T00013)
         DC    XL1'80',FL3'6'
P00077   DC    A(Q00006)
         DC    A(T00012)
         DC    A(T00013)
         DC    XL1'80',FL3'6'
P00078   DC    F'6'
         DC    A(Q00007)
P00080   DC    A(0)
C00054   DC    X'4040000000000000'
C00056   DC    X'4080000000000000'
C00058   DC    X'4110000000000000'
C00031   DC    V(STEPI)
C00032   DC    V(STEPR)
C00033   DC    V(STEPL)
C00034   DC    V(STEPD)
C00035   DC    V(STEPC)
C00036   DC    F'4'
C00037   DC    F'1'
C00039   DC    F'3'
C00041   DC    F'5'
C00044   DC    V(CHK)
C00045   DC    X'41280000'
C00047   DC    X'41380000'
C00049   DC    X'41480000'
C00061   DC    X'41100000'
C00063   DC    X'41200000'
C00066   DC    X'41300000'
C00069   DC    X'41400000'
C00072   DC    V(NEXTN)
C00073   DC    F'7'
C00075   DC    F'8'
C00079   DC    V(F77WRBEG)
C00081   DC    V(F77WRI)
C00082   DC    V(F77WREND)
Q00007   DC    C'('' >BAD '',I2)'
Q00001   DC    C'INT   '
Q00002   DC    C'REAL  '
Q00003   DC    C'LOGIC '
Q00004   DC    C'DOUBLE'
Q00005   DC    C'CMPLX '
Q00006   DC    C'FUNC  '
* STEPI
STEPI    CSECT
         USING *,15
         B     L00086
         DC    AL1(5),CL7'STEPI'
L00086   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00087
L00088   DC    A(S00083)
L00087   L     15,L00088
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00083,13
         ST    1,S00083+72
L00084   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     14,C00090
         L     2,0(,14)
         ST    2,0(,3)
         L     14,C00090
         L     2,0(,14)
         A     2,C00091
         L     14,C00090
         ST    2,0(,14)
         LA    0,0
L00085   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00083   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00090   DC    A(G00089)
C00091   DC    F'2'
* STEPR
STEPR    CSECT
         USING *,15
         B     L00095
         DC    AL1(5),CL7'STEPR'
L00095   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00096
L00097   DC    A(S00092)
L00096   L     15,L00097
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00092,13
         ST    1,S00092+72
L00093   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         L     14,C00099
         LE    0,0(,14)
         STE   0,0(,2)
         LE    0,C00100
         L     15,C00099
         AE    0,0(,15)
         L     14,C00099
         STE   0,0(,14)
         LA    0,0
L00094   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00092   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00099   DC    A(G00098)
C00100   DC    X'41100000'
* STEPL
STEPL    CSECT
         USING *,15
         B     L00104
         DC    AL1(5),CL7'STEPL'
L00104   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00105
L00106   DC    A(S00101)
L00105   L     15,L00106
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00101,13
         ST    1,S00101+72
L00102   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     14,C00108
         L     2,0(,14)
         ST    2,0(,3)
         L     14,C00108
         L     3,0(,14)
         LTR   3,3
         LA    2,1
         BC    8,L00109
         SR    2,2
L00109   DS    0H
         L     14,C00108
         ST    2,0(,14)
         LA    0,0
L00103   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00101   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00108   DC    A(G00107)
* STEPD
STEPD    CSECT
         USING *,15
         B     L00113
         DC    AL1(5),CL7'STEPD'
L00113   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00114
L00115   DC    A(S00110)
L00114   L     15,L00115
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00110,13
         ST    1,S00110+72
L00111   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         L     14,C00117
         LD    0,0(,14)
         STD   0,0(,2)
         L     14,C00117
         LD    0,0(,14)
         ADR   0,0
         L     14,C00117
         STD   0,0(,14)
         LA    0,0
L00112   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00110   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00117   DC    A(G00116)
* STEPC
STEPC    CSECT
         USING *,15
         B     L00121
         DC    AL1(5),CL7'STEPC'
L00121   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00122
L00123   DC    A(S00118)
L00122   L     15,L00123
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00118,13
         ST    1,S00118+72
L00119   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         L     14,C00125
         LE    2,0(,14)
         L     14,C00126
         LE    0,0(,14)
         STE   2,0(,2)
         STE   0,4(,2)
         LE    2,C00127
         L     15,C00125
         AE    2,0(,15)
         LE    0,C00127
         L     15,C00125
         AE    0,4(,15)
         L     14,C00125
         STE   2,0(,14)
         L     14,C00126
         STE   0,0(,14)
         LA    0,0
L00120   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00118   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00125   DC    A(G00124)
C00126   DC    A(G00124+4)
C00127   DC    X'41100000'
* NEXTN
NEXTN    CSECT
         USING *,15
         B     L00131
         DC    AL1(5),CL7'NEXTN'
L00131   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00132
L00133   DC    A(S00128)
L00132   L     15,L00133
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00128,13
         ST    1,S00128+72
L00129   DS    0H
         L     14,C00135
         L     3,0(,14)
         LR    2,3
         A     2,C00136
         L     14,C00135
         ST    2,0(,14)
         LR    0,3
L00130   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00128   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00135   DC    A(G00134)
C00136   DC    F'1'
* CHK
CHK      CSECT
         USING *,15
         B     L00147
         DC    AL1(3),CL7'CHK'
L00147   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00148
L00149   DC    A(S00137)
L00148   L     15,L00149
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00137,13
         ST    1,S00137+72
L00140   DS    0H
         L     5,0(,1)
         L     4,4(,1)
         L     3,8(,1)
         L     2,0(,4)
         LTR   2,2
         BC    7,L00141
L00142   DS    0H
         LA    1,P00150
         L     15,C00151
         BALR  14,15
         LR    0,5
         ST    0,P00152+0
         LA    1,P00152
         L     15,C00153
         BALR  14,15
         L     15,C00154
         BALR  14,15
L00145   DS    0H
         L     2,0(,3)
         A     2,C00155
         ST    2,0(,3)
L00143   DS    0H
         LA    0,0
         B     L00146
L00141   DS    0H
         LA    1,P00156
         L     15,C00151
         BALR  14,15
         LR    0,5
         ST    0,P00152+0
         LA    1,P00152
         L     15,C00153
         BALR  14,15
         L     15,C00154
         BALR  14,15
L00144   DS    0H
         B     L00143
L00146   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00137   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00150   DC    F'6'
         DC    A(Q00139)
P00152   DC    A(0)
         DC    F'6'
P00156   DC    F'6'
         DC    A(Q00138)
C00151   DC    V(F77WRBEG)
C00153   DC    V(F77WRA)
C00154   DC    V(F77WREND)
C00155   DC    F'1'
Q00138   DC    C'('' >'',A6,'' OK'')'
Q00139   DC    C'('' >'',A6,'' BAD'')'
G00089   CSECT
         DS    0D
         DC    X'00000001'
G00098   CSECT
         DS    0D
         DC    X'41280000'
G00107   CSECT
         DS    0D
         DC    X'00000001'
G00116   CSECT
         DS    0D
         DC    X'4040000000000000'
G00124   CSECT
         DS    0D
         DC    X'4110000041200000'
G00134   CSECT
         DS    0D
         DC    X'00000007'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
