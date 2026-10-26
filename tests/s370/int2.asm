* main
F77MAIN  CSECT
         USING *,15
         B     L00068
         DC    AL1(7),CL7'F77MAIN'
L00068   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00069
L00070   DC    A(S00000)
L00069   L     15,L00070
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00024   DS    0H
         L     5,C00072
         L     2,C00074
         LH    15,C00075
         STH   15,T00016
         LA    1,P00076
         L     15,C00077
         BALR  14,15
         LH    4,T00016
         LR    0,4
         ST    0,P00078+0
         LA    1,P00078
         L     15,C00079
         BALR  14,15
         L     15,C00080
         BALR  14,15
L00025   DS    0H
         LA    15,1
         L     14,C00072
         STH   15,0(,14)
         LA    15,2
         L     14,C00081
         STH   15,0(,14)
         LA    15,3
         L     14,C00082
         STH   15,0(,14)
         LA    15,4
         L     14,C00083
         STH   15,0(,14)
         LA    1,P00084
         L     15,C00077
         BALR  14,15
         AH    5,C00085
         LA    3,4
         LA    4,2
L00026   DS    0H
         C     4,C00086
         BC    2,L00027
L00028   DS    0H
         L     15,C00080
         BALR  14,15
L00029   DS    0H
         LA    15,0
         L     14,C00088
         ST    15,0(,14)
         LA    15,1
         L     14,C00088
         STC   15,0(,14)
         LA    15,0
         L     14,C00089
         STC   15,0(,14)
         LA    15,1
         L     14,C00090
         STC   15,0(,14)
         LA    1,P00084
         L     15,C00077
         BALR  14,15
         L     14,C00088
         L     4,0(,14)
         LR    0,4
         ST    0,P00091+0
         LA    1,P00091
         L     15,C00092
         BALR  14,15
         L     15,C00080
         BALR  14,15
         LA    15,1
         STC   15,T00018
         LA    15,0
         STC   15,T00017
         LA    1,P00093
         L     15,C00077
         BALR  14,15
         SR    4,4
         IC    4,T00018
         LR    0,4
         ST    0,P00091+0
         LA    1,P00091
         L     15,C00094
         BALR  14,15
         SR    4,4
         IC    4,T00017
         LR    0,4
         ST    0,P00091+0
         LA    1,P00091
         L     15,C00094
         BALR  14,15
         LA    1,P00095
         L     15,C00094
         BALR  14,15
         L     14,C00088
         SR    4,4
         IC    4,0(,14)
         LR    0,4
         ST    0,P00091+0
         LA    1,P00091
         L     15,C00094
         BALR  14,15
         L     14,C00096
         SR    4,4
         IC    4,0(,14)
         LR    0,4
         ST    0,P00091+0
         LA    1,P00091
         L     15,C00094
         BALR  14,15
         L     15,C00080
         BALR  14,15
L00030   DS    0H
         LA    15,300
         L     14,C00097
         STH   15,0(,14)
         LH    15,C00098
         STH   15,T00016
         LA    1,P00099
         L     15,C00077
         BALR  14,15
         LA    1,P00100
         L     15,C00092
         BALR  14,15
         LH    4,T00016
         LR    0,4
         ST    0,P00078+0
         LA    1,P00078
         L     15,C00079
         BALR  14,15
         L     15,C00080
         BALR  14,15
L00031   DS    0H
         LH    15,C00101
         L     14,C00102
         STH   15,0(,14)
         LA    1,P00103
         L     15,C00104
         BALR  14,15
         LA    1,P00084
         L     15,C00077
         BALR  14,15
         L     4,T00023
         LR    0,4
         ST    0,P00091+0
         LA    1,P00091
         L     15,C00092
         BALR  14,15
         L     15,C00080
         BALR  14,15
         LA    1,P00105
         L     15,C00077
         BALR  14,15
         L     14,C00107
         LH    4,0(,14)
         LR    0,4
         ST    0,P00078+0
         LA    1,P00078
         L     15,C00079
         BALR  14,15
         LR    5,2
         AH    5,C00101
         LA    3,2
         LA    4,3
L00032   DS    0H
         C     4,C00086
         BC    2,L00033
L00034   DS    0H
         L     15,C00080
         BALR  14,15
L00035   DS    0H
         LA    15,1
         STH   15,T00016
L00036   DS    0H
         LH    6,C00108
         LA    7,0
         LA    3,3
L00037   DS    0H
         LA    1,P00076
         L     15,C00077
         BALR  14,15
         LH    5,T00016
         LR    0,5
         ST    0,P00078+0
         LA    1,P00078
         L     15,C00079
         BALR  14,15
         L     15,C00080
         BALR  14,15
L00039   DS    0H
         LH    4,T00016
         SLL   4,16
         A     4,C00109
         SRA   4,16
         STH   4,T00016
         BXH   3,6,L00037
L00038   DS    0H
         LA    1,P00110
         L     15,C00111
         BALR  14,15
         LA    1,P00112
         L     15,C00113
         BALR  14,15
         LA    1,P00114
         L     15,C00115
         BALR  14,15
         LA    1,P00116
         L     15,C00117
         BALR  14,15
         LA    1,P00118
         L     15,C00117
         BALR  14,15
         L     15,C00119
         BALR  14,15
         LA    1,P00105
         L     15,C00077
         BALR  14,15
         LH    4,T00016
         LR    0,4
         ST    0,P00078+0
         LA    1,P00078
         L     15,C00079
         BALR  14,15
         L     14,C00107
         LH    4,0(,14)
         LR    0,4
         ST    0,P00078+0
         LA    1,P00078
         L     15,C00079
         BALR  14,15
         L     15,C00080
         BALR  14,15
         LH    15,C00120
         STH   15,T00016
L00041   DS    0H
         LR    8,2
         AH    8,C00101
         LA    6,2
         LA    7,6
         LA    3,2
         LA    4,1
L00042   DS    0H
         LH    5,0(3,8)
         LR    1,5
         MR    0,4
         LR    5,1
         SLL   5,16
         SRA   5,16
         STH   5,0(3,8)
L00044   DS    0H
         A     4,C00121
         BXLE  3,6,L00042
L00043   DS    0H
L00040   DS    0H
         LA    1,P00105
         L     15,C00077
         BALR  14,15
         LH    4,T00016
         LR    0,4
         ST    0,P00078+0
         LA    1,P00078
         L     15,C00079
         BALR  14,15
         AH    2,C00101
         LA    3,2
         LA    4,3
L00045   DS    0H
         C     4,C00086
         BC    2,L00046
L00047   DS    0H
         L     15,C00080
         BALR  14,15
         MVC   T00021(8),C00122
         MVC   T00021+8(8),C00123
         MVC   T00021+16(8),C00124
         MVC   T00021+24(8),C00125
L00049   DS    0H
         L     6,C00109
         L     7,C00126
         L     2,C00109
         LA    3,2
L00050   DS    0H
         LR    4,2
         A     4,C00127
         SRA   4,16
         STH   4,T00021-2(3)
L00052   DS    0H
         A     3,C00128
         BXLE  2,6,L00050
L00051   DS    0H
L00048   DS    0H
         LA    1,P00129
         L     15,C00077
         BALR  14,15
         LD    0,T00021+16
         STD   0,S00000+512
         LD    0,S00000+512
         STD   0,P00130+0
         LA    1,P00130
         L     15,C00131
         BALR  14,15
         LD    0,T00021+24
         STD   0,S00000+512
         LD    0,S00000+512
         STD   0,P00130+0
         LA    1,P00130
         L     15,C00131
         BALR  14,15
         L     15,C00080
         BALR  14,15
L00053   DS    0H
L00055   DS    0H
         LA    6,2
         LA    7,16
         LA    3,2
         LA    2,0
L00056   DS    0H
         LH    4,T00021-2(3)
         AR    2,4
L00058   DS    0H
         BXLE  3,6,L00056
L00057   DS    0H
L00054   DS    0H
         LA    1,P00084
         L     15,C00077
         BALR  14,15
         LR    0,2
         ST    0,P00091+0
         LA    1,P00091
         L     15,C00092
         BALR  14,15
         L     15,C00080
         BALR  14,15
         LH    3,T00016
         L     14,C00107
         LH    2,0(,14)
         CR    3,2
         BC    13,L00060
L00059   DS    0H
         LA    1,P00076
         L     15,C00077
         BALR  14,15
         LH    3,T00016
         LR    0,3
         ST    0,P00078+0
         LA    1,P00078
         L     15,C00079
         BALR  14,15
         L     15,C00080
         BALR  14,15
L00060   DS    0H
         LH    15,C00075
         STH   15,T00022
L00061   DS    0H
         LH    3,T00022
         LA    1,P00099
         L     15,C00077
         BALR  14,15
         LR    0,3
         ST    0,P00091+0
         LA    1,P00091
         L     15,C00092
         BALR  14,15
         LH    15,C00132
         ST    15,T00013
         LA    1,P00133
         L     15,C00134
         BALR  14,15
         LR    3,0
         LR    0,3
         ST    0,P00091+0
         LA    1,P00091
         L     15,C00092
         BALR  14,15
         L     15,C00080
         BALR  14,15
         LA    1,P00135
         L     15,C00077
         BALR  14,15
         LA    15,1
         ST    15,T00014
         LA    1,P00136
         L     15,C00137
         BALR  14,15
         LA    1,P00138
         L     15,C00139
         BALR  14,15
         L     15,C00080
         BALR  14,15
         LA    1,P00140
         L     15,C00111
         BALR  14,15
         LA    1,P00112
         L     15,C00113
         BALR  14,15
         LA    1,P00141
         L     15,C00115
         BALR  14,15
         LA    2,2
         LA    3,2
L00062   DS    0H
         C     3,C00086
         BC    2,L00063
L00064   DS    0H
         L     15,C00119
         BALR  14,15
         LA    1,P00142
         L     15,C00077
         BALR  14,15
         LH    3,T00020+2
         LR    0,3
         ST    0,P00078+0
         LA    1,P00078
         L     15,C00079
         BALR  14,15
         LH    3,T00020
         LR    0,3
         ST    0,P00078+0
         LA    1,P00078
         L     15,C00079
         BALR  14,15
         L     14,C00144
         LH    3,0(,14)
         LR    0,3
         ST    0,P00078+0
         LA    1,P00078
         L     15,C00079
         BALR  14,15
         L     15,C00080
         BALR  14,15
L00065   DS    0H
L00066   DS    0H
         B     L00067
L00027   DS    0H
         L     7,0(3,5)
         LR    0,7
         ST    0,P00091+0
         LA    1,P00091
         L     15,C00092
         BALR  14,15
         AH    4,C00108
         A     3,C00145
         B     L00026
L00033   DS    0H
         LH    7,0(3,5)
         LR    0,7
         ST    0,P00078+0
         LA    1,P00078
         L     15,C00079
         BALR  14,15
         AH    4,C00108
         A     3,C00128
         B     L00032
L00046   DS    0H
         LH    6,0(3,2)
         LR    0,6
         ST    0,P00078+0
         LA    1,P00078
         L     15,C00079
         BALR  14,15
         AH    4,C00108
         A     3,C00128
         B     L00045
L00063   DS    0H
         LR    4,2
         AH    4,C00101
         LA    5,T00020
         AR    5,4
         LR    0,5
         ST    0,P00078+0
         LA    1,P00078
         L     15,C00117
         BALR  14,15
         AH    3,C00108
         A     2,C00128
         B     L00062
L00067   DS    0H
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
T00013   DS    XL4
         DS    XL4
T00014   DS    XL4
         DS    XL4
T00015   DS    XL4
         DS    XL4
T00016   DS    XL8
T00017   DS    XL8
T00018   DS    XL16
T00019   DS    XL16
T00020   DS    XL32
T00021   DS    XL60
         DS    XL4
T00022   DS    XL76
         DS    XL4
T00023   DS    XL84
         DS    XL4
         DS    1D
P00076   DC    F'6'
         DC    A(Q00001)
P00078   DC    A(0)
         DC    F'2'
P00084   DC    F'6'
         DC    A(Q00002)
P00091   DC    A(0)
P00093   DC    F'6'
         DC    A(Q00003)
P00095   DC    F'1'
P00099   DC    F'6'
         DC    A(Q00004)
P00100   DC    F'90000'
P00103   DC    XL1'80',AL3(T00023)
P00105   DC    F'6'
         DC    A(Q00005)
P00110   DC    A(T00019)
         DC    F'12'
         DC    A(Q00006)
         DC    F'12'
P00112   DC    F'5'
P00114   DC    A(T00019)
         DC    F'12'
         DC    F'1'
         DC    A(Q00007)
         DC    F'0'
P00116   DC    A(T00016)
         DC    F'2'
P00118   DC    A(G00106)
         DC    F'2'
P00129   DC    F'6'
         DC    A(Q00008)
P00130   DC    A(0)
         DC    A(0)
P00133   DC    XL1'80',AL3(T00013)
P00135   DC    F'6'
         DC    A(Q00009)
P00136   DC    A(T00015)
         DC    F'3'
         DC    XL1'80',AL3(T00014)
P00138   DC    A(T00015)
         DC    F'3'
P00140   DC    A(T00019)
         DC    F'12'
         DC    A(Q00010)
         DC    F'4'
P00141   DC    A(T00019)
         DC    F'12'
         DC    F'1'
         DC    A(Q00011)
         DC    F'0'
P00142   DC    F'6'
         DC    A(Q00012)
         DS    XL4
C00122   DC    X'4118000000000000'
C00123   DC    X'4128000000000000'
C00124   DC    X'4138000000000000'
C00125   DC    X'4148000000000000'
C00072   DC    A(G00071)
C00074   DC    A(G00073)
C00077   DC    V(F77WRBEG)
C00079   DC    V(F77WRIN)
C00080   DC    V(F77WREND)
C00081   DC    A(G00071+2)
C00082   DC    A(G00071+4)
C00083   DC    A(G00071+6)
C00086   DC    F'0'
C00088   DC    A(G00087)
C00089   DC    A(G00087+2)
C00090   DC    A(G00087+3)
C00092   DC    V(F77WRI)
C00094   DC    V(F77WRL)
C00096   DC    A(G00087+1)
C00097   DC    A(C)
C00102   DC    A(C+6)
C00104   DC    V(SUB)
C00107   DC    A(G00106)
C00109   DC    F'65536'
C00111   DC    V(F77STRCP)
C00113   DC    V(F77FMTLM)
C00115   DC    V(F77RDBI)
C00117   DC    V(F77RDIN)
C00119   DC    V(F77RDEND)
C00121   DC    F'1'
C00126   DC    F'524288'
C00127   DC    F'6553600'
C00128   DC    F'2'
C00131   DC    V(F77WRD)
C00134   DC    V(IH)
C00137   DC    V(C3)
C00139   DC    V(F77WRA)
C00144   DC    A(G00143)
C00145   DC    F'4'
C00075   DC    H'-25536'
C00085   DC    H'-4'
C00098   DC    H'24464'
C00101   DC    H'-2'
C00108   DC    H'-1'
C00120   DC    H'-32760'
C00132   DC    H'-3'
Q00001   DC    C'('' >K '',I8)'
Q00002   DC    C'('' >IW '',2I12)'
Q00003   DC    C'('' >L '',5L3)'
Q00004   DC    C'('' >MM '',2I10)'
Q00005   DC    C'('' >KD '',4I6)'
Q00008   DC    C'('' >Z '',2F6.2)'
Q00012   DC    C'('' >A '',2A2,1X,A2)'
Q00009   DC    C'('' >C3 '',A)'
Q00006   DC    C'  1234 70000'
Q00007   DC    C'(2I6)'
Q00010   DC    C'ELMS'
Q00011   DC    C'(2A2)'
* JH
JH       CSECT
         USING *,15
         B     L00150
         DC    AL1(2),CL7'JH'
L00150   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00151
L00152   DC    A(S00146)
L00151   L     15,L00152
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00146,13
         ST    1,S00146+72
L00148   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         SLL   2,1
         SLL   2,16
         SRA   2,16
         STH   2,T00147
         LR    0,2
L00149   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00146   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00147   DS    XL8
* IH
IH       CSECT
         USING *,15
         B     L00157
         DC    AL1(2),CL7'IH'
L00157   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00158
L00159   DC    A(S00153)
L00158   L     15,L00159
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00153,13
         ST    1,S00153+72
L00155   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         LR    1,2
         M     0,C00160
         LR    2,1
         SLL   2,16
         SRA   2,16
         STH   2,T00154
         LR    0,2
L00156   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00153   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00154   DS    XL8
C00160   DC    F'30000'
* C3
C3       CSECT
         USING *,15
         B     L00165
         DC    AL1(2),CL7'C3'
L00165   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00166
L00167   DC    A(S00161)
L00166   L     15,L00167
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00161,13
         ST    1,S00161+72
L00163   DS    0H
         L     3,0(,1)
         LR    0,3
         ST    0,P00168+0
         LA    1,P00168
         L     15,C00169
         BALR  14,15
         ICM   2,8,0(3)
         SRA   2,24
         LR    0,2
L00164   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00161   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00168   DC    A(0)
         DC    F'3'
         DC    A(Q00162)
         DC    F'3'
C00169   DC    V(F77STRCP)
Q00162   DC    C'OAK'
* SUB
SUB      CSECT
         USING *,15
         B     L00173
         DC    AL1(3),CL7'SUB'
L00173   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00174
L00175   DC    A(S00170)
L00174   L     15,L00175
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00170,13
         ST    1,S00170+72
L00171   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     14,C00176
         L     2,0(,14)
         ST    2,0(,3)
         LA    0,0
L00172   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00170   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00176   DC    A(C)
* BUMP
BUMP     CSECT
         USING *,15
         B     L00184
         DC    AL1(4),CL7'BUMP'
L00184   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00185
L00186   DC    A(S00177)
L00185   L     15,L00186
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00177,13
         ST    1,S00177+72
L00178   DS    0H
         L     3,0(,1)
         L     5,4(,1)
         L     4,8(,1)
         LA    4,0(,4)
         LH    2,0(,3)
         SLL   2,16
         A     2,C00187
         SRA   2,16
         STH   2,0(,3)
         L     3,0(,4)
         S     3,C00188
         A     3,C00188
L00179   DS    0H
         AH    5,C00189
         LA    6,2
         LR    2,3
         SLL   2,1
         LA    7,0
         AR    7,2
         C     3,C00190
         BC    2,L00191
         B     L00181
L00191   DS    0H
         LA    2,2
         LA    3,1
         B     L00180
L00181   DS    0H
         LA    0,0
         B     L00183
L00180   DS    0H
         LH    4,0(2,5)
         LR    1,4
         MR    0,3
         LR    4,1
         SLL   4,16
         SRA   4,16
         STH   4,0(2,5)
L00182   DS    0H
         A     3,C00188
         BXLE  2,6,L00180
         B     L00181
L00183   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00177   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00187   DC    F'2147418112'
C00188   DC    F'1'
C00190   DC    F'0'
C00189   DC    H'-2'
* PACK
PACK     CSECT
         USING *,15
         B     L00199
         DC    AL1(4),CL7'PACK'
L00199   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00200
L00201   DC    A(S00192)
L00200   L     15,L00201
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00192,13
         ST    1,S00192+72
L00193   DS    0H
         L     5,0(,1)
         L     2,4(,1)
         LA    2,0(,2)
         L     3,0(,2)
         S     3,C00202
         A     3,C00202
L00194   DS    0H
         AH    5,C00203
         L     6,C00204
         LR    2,3
         SLL   2,16
         LA    7,0
         AR    7,2
         C     3,C00205
         BC    2,L00206
         B     L00196
L00206   DS    0H
         L     2,C00204
         LA    3,2
         B     L00195
L00196   DS    0H
         LA    0,0
         B     L00198
L00195   DS    0H
         LR    4,2
         A     4,C00207
         SRA   4,16
         STH   4,0(3,5)
L00197   DS    0H
         A     3,C00208
         BXLE  2,6,L00195
         B     L00196
L00198   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00192   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00202   DC    F'1'
C00204   DC    F'65536'
C00205   DC    F'0'
C00207   DC    F'6553600'
C00208   DC    F'2'
C00203   DC    H'-2'
* UNPK
UNPK     CSECT
         USING *,15
         B     L00216
         DC    AL1(4),CL7'UNPK'
L00216   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00217
L00218   DC    A(S00209)
L00217   L     15,L00218
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00209,13
         ST    1,S00209+72
L00210   DS    0H
         L     4,0(,1)
         L     2,4(,1)
         L     5,8(,1)
         LA    5,0(,5)
         LA    15,0
         ST    15,0(,5)
         L     3,0(,2)
         S     3,C00219
         A     3,C00219
L00211   DS    0H
         AH    4,C00220
         LA    6,2
         LR    2,3
         SLL   2,1
         LA    7,0
         AR    7,2
         C     3,C00221
         BC    2,L00222
         B     L00213
L00222   DS    0H
         LA    2,2
         B     L00212
L00213   DS    0H
         LA    0,0
         B     L00215
L00212   DS    0H
         LH    3,0(2,4)
         A     3,0(,5)
         ST    3,0(,5)
L00214   DS    0H
         BXLE  2,6,L00212
         B     L00213
L00215   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00209   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00219   DC    F'1'
C00221   DC    F'0'
C00220   DC    H'-2'
C        CSECT
         DS    0D
         DS    XL8
G00071   CSECT
         DS    0D
         DS    XL8
G00087   CSECT
         DS    0D
         DS    XL4
G00106   CSECT
         DS    0D
         DC    X'FFF9'
G00073   CSECT
         DS    0D
         DC    X'000500050005'
G00143   CSECT
         DS    0D
         DC    X'D7D8'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
