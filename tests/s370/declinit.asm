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
         L     0,C00043
         ST    0,P00030+0
         LA    0,T00014
         ST    0,P00030+4
         LA    0,T00013
         ST    0,P00030+8
         LA    0,6
         ST    0,P00030+12
         OI    P00030+12,X'80'
         LA    1,P00030
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
         L     0,C00051
         ST    0,P00030+0
         LA    0,T00008
         ST    0,P00030+4
         LA    0,T00013
         ST    0,P00030+8
         LA    0,6
         ST    0,P00030+12
         OI    P00030+12,X'80'
         LA    1,P00030
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
         L     0,C00053
         ST    0,P00030+0
         LA    0,T00009
         ST    0,P00030+4
         LA    0,T00013
         ST    0,P00030+8
         LA    0,6
         ST    0,P00030+12
         OI    P00030+12,X'80'
         LA    1,P00030
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
         L     0,C00060
         ST    0,P00030+0
         LA    0,T00010
         ST    0,P00030+4
         LA    0,T00013
         ST    0,P00030+8
         LA    0,6
         ST    0,P00030+12
         OI    P00030+12,X'80'
         LA    1,P00030
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
         L     0,C00071
         ST    0,P00030+0
         LA    0,T00011
         ST    0,P00030+4
         LA    0,T00013
         ST    0,P00030+8
         LA    0,6
         ST    0,P00030+12
         OI    P00030+12,X'80'
         LA    1,P00030
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
         L     0,C00077
         ST    0,P00030+0
         LA    0,T00012
         ST    0,P00030+4
         LA    0,T00013
         ST    0,P00030+8
         LA    0,6
         ST    0,P00030+12
         OI    P00030+12,X'80'
         LA    1,P00030
         L     15,C00044
         BALR  14,15
         LA    0,6
         ST    0,P00030+0
         L     0,C00078
         ST    0,P00030+4
         LA    1,P00030
         L     15,C00079
         BALR  14,15
         L     3,T00013
         LR    0,3
         ST    0,P00030+0
         LA    1,P00030
         L     15,C00080
         BALR  14,15
         L     15,C00081
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
P00030   DS    4F
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
C00043   DC    A(Q00001)
C00044   DC    V(CHK)
C00045   DC    X'41280000'
C00047   DC    X'41380000'
C00049   DC    X'41480000'
C00051   DC    A(Q00002)
C00053   DC    A(Q00003)
C00060   DC    A(Q00004)
C00061   DC    X'41100000'
C00063   DC    X'41200000'
C00066   DC    X'41300000'
C00069   DC    X'41400000'
C00071   DC    A(Q00005)
C00072   DC    V(NEXTN)
C00073   DC    F'7'
C00075   DC    F'8'
C00077   DC    A(Q00006)
C00078   DC    A(Q00007)
C00079   DC    V(F77WRBEG)
C00080   DC    V(F77WRI)
C00081   DC    V(F77WREND)
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
         B     L00085
         DC    AL1(5),CL7'STEPI'
L00085   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00086
L00087   DC    A(S00082)
L00086   L     15,L00087
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00082,13
         ST    1,S00082+72
L00083   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     14,C00089
         L     2,0(,14)
         ST    2,0(,3)
         L     14,C00089
         L     2,0(,14)
         A     2,C00090
         L     14,C00089
         ST    2,0(,14)
         LA    0,0
L00084   DS    0H
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
C00089   DC    A(G00088)
C00090   DC    F'2'
* STEPR
STEPR    CSECT
         USING *,15
         B     L00094
         DC    AL1(5),CL7'STEPR'
L00094   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00095
L00096   DC    A(S00091)
L00095   L     15,L00096
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00091,13
         ST    1,S00091+72
L00092   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         L     14,C00098
         LE    0,0(,14)
         STE   0,0(,2)
         LE    0,C00099
         L     15,C00098
         AE    0,0(,15)
         L     14,C00098
         STE   0,0(,14)
         LA    0,0
L00093   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00091   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00098   DC    A(G00097)
C00099   DC    X'41100000'
* STEPL
STEPL    CSECT
         USING *,15
         B     L00103
         DC    AL1(5),CL7'STEPL'
L00103   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00104
L00105   DC    A(S00100)
L00104   L     15,L00105
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00100,13
         ST    1,S00100+72
L00101   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     14,C00107
         L     2,0(,14)
         ST    2,0(,3)
         L     14,C00107
         L     3,0(,14)
         LTR   3,3
         LA    2,1
         BC    8,L00108
         SR    2,2
L00108   DS    0H
         L     14,C00107
         ST    2,0(,14)
         LA    0,0
L00102   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00100   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00107   DC    A(G00106)
* STEPD
STEPD    CSECT
         USING *,15
         B     L00112
         DC    AL1(5),CL7'STEPD'
L00112   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00113
L00114   DC    A(S00109)
L00113   L     15,L00114
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00109,13
         ST    1,S00109+72
L00110   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         L     14,C00116
         LD    0,0(,14)
         STD   0,0(,2)
         L     14,C00116
         LD    0,0(,14)
         ADR   0,0
         L     14,C00116
         STD   0,0(,14)
         LA    0,0
L00111   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00109   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00116   DC    A(G00115)
* STEPC
STEPC    CSECT
         USING *,15
         B     L00120
         DC    AL1(5),CL7'STEPC'
L00120   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00121
L00122   DC    A(S00117)
L00121   L     15,L00122
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00117,13
         ST    1,S00117+72
L00118   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         L     14,C00124
         LE    2,0(,14)
         L     14,C00125
         LE    0,0(,14)
         STE   2,0(,2)
         STE   0,4(,2)
         LE    2,C00126
         L     15,C00124
         AE    2,0(,15)
         LE    0,C00126
         L     15,C00124
         AE    0,4(,15)
         L     14,C00124
         STE   2,0(,14)
         L     14,C00125
         STE   0,0(,14)
         LA    0,0
L00119   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00117   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00124   DC    A(G00123)
C00125   DC    A(G00123+4)
C00126   DC    X'41100000'
* NEXTN
NEXTN    CSECT
         USING *,15
         B     L00130
         DC    AL1(5),CL7'NEXTN'
L00130   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00131
L00132   DC    A(S00127)
L00131   L     15,L00132
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00127,13
         ST    1,S00127+72
L00128   DS    0H
         L     14,C00134
         L     3,0(,14)
         LR    2,3
         A     2,C00135
         L     14,C00134
         ST    2,0(,14)
         LR    0,3
L00129   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00127   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00134   DC    A(G00133)
C00135   DC    F'1'
* CHK
CHK      CSECT
         USING *,15
         B     L00146
         DC    AL1(3),CL7'CHK'
L00146   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00147
L00148   DC    A(S00136)
L00147   L     15,L00148
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00136,13
         ST    1,S00136+72
L00139   DS    0H
         L     5,0(,1)
         L     4,4(,1)
         L     3,8(,1)
         L     2,0(,4)
         LTR   2,2
         BC    7,L00140
L00141   DS    0H
         LA    0,6
         ST    0,P00149+0
         L     0,C00150
         ST    0,P00149+4
         LA    1,P00149
         L     15,C00151
         BALR  14,15
         LR    0,5
         ST    0,P00149+0
         LA    0,6
         ST    0,P00149+4
         LA    1,P00149
         L     15,C00152
         BALR  14,15
         L     15,C00153
         BALR  14,15
L00144   DS    0H
         L     2,0(,3)
         A     2,C00154
         ST    2,0(,3)
L00142   DS    0H
         LA    0,0
         B     L00145
L00140   DS    0H
         LA    0,6
         ST    0,P00149+0
         L     0,C00155
         ST    0,P00149+4
         LA    1,P00149
         L     15,C00151
         BALR  14,15
         LR    0,5
         ST    0,P00149+0
         LA    0,6
         ST    0,P00149+4
         LA    1,P00149
         L     15,C00152
         BALR  14,15
         L     15,C00153
         BALR  14,15
L00143   DS    0H
         B     L00142
L00145   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00136   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00149   DS    2F
C00150   DC    A(Q00138)
C00151   DC    V(F77WRBEG)
C00152   DC    V(F77WRA)
C00153   DC    V(F77WREND)
C00154   DC    F'1'
C00155   DC    A(Q00137)
Q00137   DC    C'('' >'',A6,'' OK'')'
Q00138   DC    C'('' >'',A6,'' BAD'')'
G00088   CSECT
         DS    0D
         DC    X'00000001'
G00097   CSECT
         DS    0D
         DC    X'41280000'
G00106   CSECT
         DS    0D
         DC    X'00000001'
G00115   CSECT
         DS    0D
         DC    X'4040000000000000'
G00123   CSECT
         DS    0D
         DC    X'4110000041200000'
G00133   CSECT
         DS    0D
         DC    X'00000007'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
