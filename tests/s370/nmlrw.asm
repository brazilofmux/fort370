* main
F77MAIN  CSECT
         USING *,15
         B     L00112
         DC    AL1(7),CL7'F77MAIN'
L00112   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00113
L00114   DC    A(S00000)
L00113   L     15,L00114
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00077   DS    0H
         LH    15,C00115
         ST    15,T00068
         MVC   T00075(4),C00116
         LD    0,C00117
         LCDR  0,0
         STD   0,T00070
         LE    0,C00118
         LCER  0,0
         MVC   T00071(4),C00119
         STE   0,T00071+4
         LA    15,1
         ST    15,T00069
         LA    1,P00120
         L     15,C00121
         BALR  14,15
L00078   DS    0H
         LA    4,100
         LA    5,400
         LA    2,100
         LA    3,4
L00079   DS    0H
L00081   DS    0H
         ST    2,T00074-4(3)
         A     3,C00122
         BXLE  2,4,L00079
L00080   DS    0H
         MVC   T00073(4),C00123
         MVC   T00073+4(4),C00124
         MVC   T00073+8(4),C00125
         LA    1,P00126
         L     15,C00127
         BALR  14,15
         LA    1,P00128
         L     15,C00129
         BALR  14,15
         LA    1,P00130
         L     15,C00129
         BALR  14,15
         LA    1,P00131
         L     15,C00129
         BALR  14,15
         LA    1,P00132
         L     15,C00129
         BALR  14,15
         LA    1,P00133
         L     15,C00129
         BALR  14,15
         LA    1,P00134
         L     15,C00129
         BALR  14,15
         LA    1,P00135
         L     15,C00136
         BALR  14,15
         LA    1,P00137
         L     15,C00129
         BALR  14,15
         LA    1,P00138
         L     15,C00136
         BALR  14,15
         LA    1,P00139
         L     15,C00129
         BALR  14,15
         L     15,C00140
         BALR  14,15
         LA    1,P00141
         L     15,C00142
         BALR  14,15
L00082   DS    0H
         LA    1,P00143
         L     15,C00144
         BALR  14,15
         LR    2,15
         C     2,C00145
         BC    8,L00084
L00083   DS    0H
         LA    1,P00146
         L     15,C00147
         BALR  14,15
         L     15,C00148
         BALR  14,15
         LA    1,P00149
         L     15,C00150
         BALR  14,15
         LA    1,P00146
         L     15,C00151
         BALR  14,15
         L     15,C00152
         BALR  14,15
         B     L00082
L00084   DS    0H
         LA    1,P00141
         L     15,C00142
         BALR  14,15
         LA    1,P00153
         L     15,C00154
         BALR  14,15
         LA    1,P00155
         L     15,C00127
         BALR  14,15
         LA    1,P00156
         L     15,C00129
         BALR  14,15
         LA    1,P00157
         L     15,C00129
         BALR  14,15
         LA    1,P00158
         L     15,C00129
         BALR  14,15
         LA    1,P00159
         L     15,C00129
         BALR  14,15
         LA    1,P00160
         L     15,C00129
         BALR  14,15
         LA    1,P00161
         L     15,C00129
         BALR  14,15
         LA    1,P00135
         L     15,C00136
         BALR  14,15
         LA    1,P00162
         L     15,C00129
         BALR  14,15
         LA    1,P00138
         L     15,C00136
         BALR  14,15
         LA    1,P00163
         L     15,C00129
         BALR  14,15
         L     15,C00140
         BALR  14,15
         LA    1,P00164
         L     15,C00150
         BALR  14,15
         L     3,T00068
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         LE    0,T00075
         STE   0,S00000+392
         LE    0,S00000+392
         STE   0,P00167+0
         LA    1,P00167
         L     15,C00168
         BALR  14,15
         LD    0,T00070
         STD   0,S00000+392
         LD    0,S00000+392
         STD   0,P00169+0
         LA    1,P00169
         L     15,C00170
         BALR  14,15
         LE    0,T00071
         STE   0,S00000+392
         LE    0,T00071+4
         STE   0,S00000+400
         LE    0,S00000+392
         STE   0,P00169+0
         LE    0,S00000+400
         STE   0,P00169+4
         LA    1,P00169
         L     15,C00171
         BALR  14,15
         L     3,T00069
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00172
         BALR  14,15
         LA    1,P00173
         L     15,C00151
         BALR  14,15
         LA    2,4
         LA    3,4
L00085   DS    0H
         C     3,C00174
         BC    2,L00086
L00087   DS    0H
         LA    2,4
         LA    3,3
L00088   DS    0H
         C     3,C00174
         BC    2,L00089
L00090   DS    0H
         L     15,C00152
         BALR  14,15
         LA    1,P00175
         L     15,C00150
         BALR  14,15
         LA    1,P00176
         L     15,C00151
         BALR  14,15
         L     15,C00152
         BALR  14,15
         LA    1,P00175
         L     15,C00150
         BALR  14,15
         LA    1,P00177
         L     15,C00151
         BALR  14,15
         L     15,C00152
         BALR  14,15
         LA    1,P00175
         L     15,C00150
         BALR  14,15
         LA    1,P00178
         L     15,C00151
         BALR  14,15
         L     15,C00152
         BALR  14,15
         LA    1,P00175
         L     15,C00150
         BALR  14,15
         LA    1,P00179
         L     15,C00151
         BALR  14,15
         L     15,C00152
         BALR  14,15
         LA    1,P00180
         L     15,C00142
         BALR  14,15
         LA    1,P00181
         L     15,C00127
         BALR  14,15
         LA    1,P00182
         L     15,C00129
         BALR  14,15
         LA    1,P00183
         L     15,C00129
         BALR  14,15
         LA    1,P00184
         L     15,C00129
         BALR  14,15
         LA    1,P00185
         L     15,C00129
         BALR  14,15
         LA    1,P00186
         L     15,C00129
         BALR  14,15
         LA    1,P00187
         L     15,C00129
         BALR  14,15
         LA    1,P00135
         L     15,C00136
         BALR  14,15
         LA    1,P00188
         L     15,C00129
         BALR  14,15
         LA    1,P00138
         L     15,C00136
         BALR  14,15
         LA    1,P00189
         L     15,C00129
         BALR  14,15
         L     15,C00140
         BALR  14,15
         LA    1,P00164
         L     15,C00150
         BALR  14,15
         L     3,T00068
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         LE    0,T00075
         STE   0,S00000+392
         LE    0,S00000+392
         STE   0,P00167+0
         LA    1,P00167
         L     15,C00168
         BALR  14,15
         LD    0,T00070
         STD   0,S00000+392
         LD    0,S00000+392
         STD   0,P00169+0
         LA    1,P00169
         L     15,C00170
         BALR  14,15
         LE    0,T00071
         STE   0,S00000+392
         LE    0,T00071+4
         STE   0,S00000+400
         LE    0,S00000+392
         STE   0,P00169+0
         LE    0,S00000+400
         STE   0,P00169+4
         LA    1,P00169
         L     15,C00171
         BALR  14,15
         L     3,T00069
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00172
         BALR  14,15
         LA    1,P00173
         L     15,C00151
         BALR  14,15
         LA    2,4
         LA    3,4
L00091   DS    0H
         C     3,C00174
         BC    2,L00092
L00093   DS    0H
         LA    2,4
         LA    3,3
L00094   DS    0H
         C     3,C00174
         BC    2,L00095
L00096   DS    0H
         L     15,C00152
         BALR  14,15
         LA    1,P00190
         L     15,C00127
         BALR  14,15
         LA    1,P00191
         L     15,C00129
         BALR  14,15
         LA    1,P00192
         L     15,C00129
         BALR  14,15
         LA    1,P00193
         L     15,C00129
         BALR  14,15
         LA    1,P00194
         L     15,C00129
         BALR  14,15
         LA    1,P00195
         L     15,C00129
         BALR  14,15
         LA    1,P00196
         L     15,C00129
         BALR  14,15
         LA    1,P00135
         L     15,C00136
         BALR  14,15
         LA    1,P00197
         L     15,C00129
         BALR  14,15
         LA    1,P00138
         L     15,C00136
         BALR  14,15
         LA    1,P00198
         L     15,C00129
         BALR  14,15
         L     15,C00140
         BALR  14,15
         LA    1,P00164
         L     15,C00150
         BALR  14,15
         L     3,T00068
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         LE    0,T00075
         STE   0,S00000+392
         LE    0,S00000+392
         STE   0,P00167+0
         LA    1,P00167
         L     15,C00168
         BALR  14,15
         LD    0,T00070
         STD   0,S00000+392
         LD    0,S00000+392
         STD   0,P00169+0
         LA    1,P00169
         L     15,C00170
         BALR  14,15
         LE    0,T00071
         STE   0,S00000+392
         LE    0,T00071+4
         STE   0,S00000+400
         LE    0,S00000+392
         STE   0,P00169+0
         LE    0,S00000+400
         STE   0,P00169+4
         LA    1,P00169
         L     15,C00171
         BALR  14,15
         L     3,T00069
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00172
         BALR  14,15
         LA    1,P00173
         L     15,C00151
         BALR  14,15
         LA    2,4
         LA    3,4
L00097   DS    0H
         C     3,C00174
         BC    2,L00098
L00099   DS    0H
         LA    2,4
         LA    3,3
L00100   DS    0H
         C     3,C00174
         BC    2,L00101
L00102   DS    0H
         L     15,C00152
         BALR  14,15
         LA    1,P00199
         L     15,C00127
         BALR  14,15
         LA    1,P00200
         L     15,C00129
         BALR  14,15
         LA    1,P00201
         L     15,C00129
         BALR  14,15
         LA    1,P00202
         L     15,C00129
         BALR  14,15
         LA    1,P00203
         L     15,C00129
         BALR  14,15
         LA    1,P00204
         L     15,C00129
         BALR  14,15
         LA    1,P00205
         L     15,C00129
         BALR  14,15
         LA    1,P00135
         L     15,C00136
         BALR  14,15
         LA    1,P00206
         L     15,C00129
         BALR  14,15
         LA    1,P00138
         L     15,C00136
         BALR  14,15
         LA    1,P00207
         L     15,C00129
         BALR  14,15
         L     15,C00140
         BALR  14,15
         LR    2,15
         C     2,C00145
         BC    8,L00104
L00103   DS    0H
         LA    1,P00208
         L     15,C00150
         BALR  14,15
         LA    1,P00209
         L     15,C00151
         BALR  14,15
         L     15,C00152
         BALR  14,15
L00105   DS    0H
         LA    1,P00210
         L     15,C00150
         BALR  14,15
         LA    1,P00211
         L     15,C00151
         BALR  14,15
         L     15,C00152
         BALR  14,15
         LA    1,P00212
         L     15,C00142
         BALR  14,15
         LA    1,P00213
         L     15,C00127
         BALR  14,15
         LA    1,P00214
         L     15,C00129
         BALR  14,15
         LA    1,P00215
         L     15,C00129
         BALR  14,15
         LA    1,P00216
         L     15,C00129
         BALR  14,15
         LA    1,P00217
         L     15,C00129
         BALR  14,15
         LA    1,P00218
         L     15,C00129
         BALR  14,15
         LA    1,P00219
         L     15,C00129
         BALR  14,15
         LA    1,P00135
         L     15,C00136
         BALR  14,15
         LA    1,P00220
         L     15,C00129
         BALR  14,15
         LA    1,P00138
         L     15,C00136
         BALR  14,15
         LA    1,P00221
         L     15,C00129
         BALR  14,15
         L     15,C00140
         BALR  14,15
         LR    3,15
         C     3,C00145
         LA    2,1
         BC    8,L00222
         SR    2,2
L00222   DS    0H
         LCR   4,2
         LR    2,3
         X     2,C00223
         NR    2,4
         XR    2,3
         C     3,C00224
         LA    5,1
         BC    8,L00225
         SR    5,5
L00225   DS    0H
         LCR   4,5
         LA    3,1
         XR    3,2
         NR    3,4
         XR    2,3
         LA    1,P00226
         L     15,C00150
         BALR  14,15
         LR    0,2
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     3,T00068
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     15,C00152
         BALR  14,15
L00106   DS    0H
L00107   DS    0H
L00108   DS    0H
L00109   DS    0H
L00110   DS    0H
         B     L00111
L00086   DS    0H
         L     5,T00074-4(2)
         LR    0,5
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         AH    3,C00227
         A     2,C00122
         B     L00085
L00089   DS    0H
         LE    0,T00073-4(2)
         STE   0,S00000+392
         LE    0,S00000+392
         STE   0,P00167+0
         LA    1,P00167
         L     15,C00168
         BALR  14,15
         AH    3,C00227
         A     2,C00122
         B     L00088
L00092   DS    0H
         L     5,T00074-4(2)
         LR    0,5
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         AH    3,C00227
         A     2,C00122
         B     L00091
L00095   DS    0H
         LE    0,T00073-4(2)
         STE   0,S00000+392
         LE    0,S00000+392
         STE   0,P00167+0
         LA    1,P00167
         L     15,C00168
         BALR  14,15
         AH    3,C00227
         A     2,C00122
         B     L00094
L00098   DS    0H
         L     5,T00074-4(2)
         LR    0,5
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         AH    3,C00227
         A     2,C00122
         B     L00097
L00101   DS    0H
         LE    0,T00073-4(2)
         STE   0,S00000+392
         LE    0,S00000+392
         STE   0,P00167+0
         LA    1,P00167
         L     15,C00168
         BALR  14,15
         AH    3,C00227
         A     2,C00122
         B     L00100
L00104   DS    0H
         LA    1,P00208
         L     15,C00150
         BALR  14,15
         LA    1,P00228
         L     15,C00151
         BALR  14,15
         L     15,C00152
         BALR  14,15
         B     L00105
L00111   DS    0H
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
T00068   DS    XL8
T00069   DS    XL8
T00070   DS    XL12
         DS    XL4
T00071   DS    XL12
         DS    XL4
T00072   DS    XL12
         DS    XL4
T00073   DS    XL16
T00074   DS    XL20
         DS    XL4
T00075   DS    XL24
T00076   DS    XL84
         DS    XL4
         DS    2D
P00120   DC    A(T00072)
         DC    F'6'
         DC    A(Q00001)
         DC    F'5'
P00126   DC    F'31'
         DC    A(Q00002)
         DC    F'3'
         DC    F'0'
         DC    F'0'
P00128   DC    A(Q00003)
         DC    F'1'
         DC    F'1'
         DC    A(T00068)
         DC    F'4'
         DC    F'1'
P00130   DC    A(Q00004)
         DC    F'1'
         DC    F'2'
         DC    A(T00075)
         DC    F'4'
         DC    F'1'
P00131   DC    A(Q00005)
         DC    F'1'
         DC    F'3'
         DC    A(T00070)
         DC    F'8'
         DC    F'1'
P00132   DC    A(Q00006)
         DC    F'1'
         DC    F'4'
         DC    A(T00071)
         DC    F'8'
         DC    F'1'
P00133   DC    A(Q00007)
         DC    F'1'
         DC    F'6'
         DC    A(T00069)
         DC    F'4'
         DC    F'1'
P00134   DC    A(Q00008)
         DC    F'1'
         DC    F'7'
         DC    A(T00072)
         DC    F'6'
         DC    F'1'
P00135   DC    F'1'
         DC    F'4'
P00137   DC    A(Q00009)
         DC    F'1'
         DC    F'1'
         DC    A(T00074)
         DC    F'4'
         DC    F'4'
P00138   DC    F'1'
         DC    F'3'
P00139   DC    A(Q00010)
         DC    F'1'
         DC    F'2'
         DC    A(T00073)
         DC    F'4'
         DC    F'3'
P00141   DC    F'31'
P00143   DC    F'31'
         DC    A(Q00021)
         DC    F'1'
P00146   DC    A(T00076)
         DC    F'80'
P00149   DC    F'6'
         DC    A(Q00067)
P00153   DC    A(T00068)
         DC    A(T00075)
         DC    A(T00070)
         DC    A(T00071)
         DC    A(T00069)
         DC    A(T00072)
         DC    A(T00074)
         DC    A(T00073)
         DC    XL1'80',FL3'6'
P00155   DC    F'31'
         DC    A(Q00011)
         DC    F'3'
         DC    F'1'
         DC    F'0'
P00156   DC    A(Q00012)
         DC    F'1'
         DC    F'1'
         DC    A(T00068)
         DC    F'4'
         DC    F'1'
P00157   DC    A(Q00013)
         DC    F'1'
         DC    F'2'
         DC    A(T00075)
         DC    F'4'
         DC    F'1'
P00158   DC    A(Q00014)
         DC    F'1'
         DC    F'3'
         DC    A(T00070)
         DC    F'8'
         DC    F'1'
P00159   DC    A(Q00015)
         DC    F'1'
         DC    F'4'
         DC    A(T00071)
         DC    F'8'
         DC    F'1'
P00160   DC    A(Q00016)
         DC    F'1'
         DC    F'6'
         DC    A(T00069)
         DC    F'4'
         DC    F'1'
P00161   DC    A(Q00017)
         DC    F'1'
         DC    F'7'
         DC    A(T00072)
         DC    F'6'
         DC    F'1'
P00162   DC    A(Q00018)
         DC    F'1'
         DC    F'1'
         DC    A(T00074)
         DC    F'4'
         DC    F'4'
P00163   DC    A(Q00019)
         DC    F'1'
         DC    F'2'
         DC    A(T00073)
         DC    F'4'
         DC    F'3'
P00164   DC    F'6'
         DC    A(Q00020)
P00165   DC    A(0)
P00167   DC    A(0)
         DS    F
P00169   DC    A(0)
         DC    A(0)
P00173   DC    A(T00072)
         DC    F'6'
P00175   DC    F'9'
         DC    A(Q00021)
P00176   DC    A(Q00022)
         DC    F'30'
P00177   DC    A(Q00023)
         DC    F'34'
P00178   DC    A(Q00024)
         DC    F'17'
P00179   DC    A(Q00025)
         DC    F'23'
P00180   DC    F'9'
P00181   DC    F'9'
         DC    A(Q00026)
         DC    F'3'
         DC    F'1'
         DC    F'0'
P00182   DC    A(Q00027)
         DC    F'1'
         DC    F'1'
         DC    A(T00068)
         DC    F'4'
         DC    F'1'
P00183   DC    A(Q00028)
         DC    F'1'
         DC    F'2'
         DC    A(T00075)
         DC    F'4'
         DC    F'1'
P00184   DC    A(Q00029)
         DC    F'1'
         DC    F'3'
         DC    A(T00070)
         DC    F'8'
         DC    F'1'
P00185   DC    A(Q00030)
         DC    F'1'
         DC    F'4'
         DC    A(T00071)
         DC    F'8'
         DC    F'1'
P00186   DC    A(Q00031)
         DC    F'1'
         DC    F'6'
         DC    A(T00069)
         DC    F'4'
         DC    F'1'
P00187   DC    A(Q00032)
         DC    F'1'
         DC    F'7'
         DC    A(T00072)
         DC    F'6'
         DC    F'1'
P00188   DC    A(Q00033)
         DC    F'1'
         DC    F'1'
         DC    A(T00074)
         DC    F'4'
         DC    F'4'
P00189   DC    A(Q00034)
         DC    F'1'
         DC    F'2'
         DC    A(T00073)
         DC    F'4'
         DC    F'3'
P00190   DC    F'9'
         DC    A(Q00035)
         DC    F'3'
         DC    F'1'
         DC    F'0'
P00191   DC    A(Q00036)
         DC    F'1'
         DC    F'1'
         DC    A(T00068)
         DC    F'4'
         DC    F'1'
P00192   DC    A(Q00037)
         DC    F'1'
         DC    F'2'
         DC    A(T00075)
         DC    F'4'
         DC    F'1'
P00193   DC    A(Q00038)
         DC    F'1'
         DC    F'3'
         DC    A(T00070)
         DC    F'8'
         DC    F'1'
P00194   DC    A(Q00039)
         DC    F'1'
         DC    F'4'
         DC    A(T00071)
         DC    F'8'
         DC    F'1'
P00195   DC    A(Q00040)
         DC    F'1'
         DC    F'6'
         DC    A(T00069)
         DC    F'4'
         DC    F'1'
P00196   DC    A(Q00041)
         DC    F'1'
         DC    F'7'
         DC    A(T00072)
         DC    F'6'
         DC    F'1'
P00197   DC    A(Q00042)
         DC    F'1'
         DC    F'1'
         DC    A(T00074)
         DC    F'4'
         DC    F'4'
P00198   DC    A(Q00043)
         DC    F'1'
         DC    F'2'
         DC    A(T00073)
         DC    F'4'
         DC    F'3'
P00199   DC    F'9'
         DC    A(Q00044)
         DC    F'3'
         DC    F'1'
         DC    F'1'
P00200   DC    A(Q00045)
         DC    F'1'
         DC    F'1'
         DC    A(T00068)
         DC    F'4'
         DC    F'1'
P00201   DC    A(Q00046)
         DC    F'1'
         DC    F'2'
         DC    A(T00075)
         DC    F'4'
         DC    F'1'
P00202   DC    A(Q00047)
         DC    F'1'
         DC    F'3'
         DC    A(T00070)
         DC    F'8'
         DC    F'1'
P00203   DC    A(Q00048)
         DC    F'1'
         DC    F'4'
         DC    A(T00071)
         DC    F'8'
         DC    F'1'
P00204   DC    A(Q00049)
         DC    F'1'
         DC    F'6'
         DC    A(T00069)
         DC    F'4'
         DC    F'1'
P00205   DC    A(Q00050)
         DC    F'1'
         DC    F'7'
         DC    A(T00072)
         DC    F'6'
         DC    F'1'
P00206   DC    A(Q00051)
         DC    F'1'
         DC    F'1'
         DC    A(T00074)
         DC    F'4'
         DC    F'4'
P00207   DC    A(Q00052)
         DC    F'1'
         DC    F'2'
         DC    A(T00073)
         DC    F'4'
         DC    F'3'
P00208   DC    F'6'
         DC    A(Q00053)
P00209   DC    A(Q00054)
         DC    F'6'
P00210   DC    F'10'
         DC    A(Q00021)
P00211   DC    A(Q00056)
         DC    F'21'
P00212   DC    F'10'
P00213   DC    F'10'
         DC    A(Q00057)
         DC    F'3'
         DC    F'1'
         DC    F'2'
P00214   DC    A(Q00058)
         DC    F'1'
         DC    F'1'
         DC    A(T00068)
         DC    F'4'
         DC    F'1'
P00215   DC    A(Q00059)
         DC    F'1'
         DC    F'2'
         DC    A(T00075)
         DC    F'4'
         DC    F'1'
P00216   DC    A(Q00060)
         DC    F'1'
         DC    F'3'
         DC    A(T00070)
         DC    F'8'
         DC    F'1'
P00217   DC    A(Q00061)
         DC    F'1'
         DC    F'4'
         DC    A(T00071)
         DC    F'8'
         DC    F'1'
P00218   DC    A(Q00062)
         DC    F'1'
         DC    F'6'
         DC    A(T00069)
         DC    F'4'
         DC    F'1'
P00219   DC    A(Q00063)
         DC    F'1'
         DC    F'7'
         DC    A(T00072)
         DC    F'6'
         DC    F'1'
P00220   DC    A(Q00064)
         DC    F'1'
         DC    F'1'
         DC    A(T00074)
         DC    F'4'
         DC    F'4'
P00221   DC    A(Q00065)
         DC    F'1'
         DC    F'2'
         DC    A(T00073)
         DC    F'4'
         DC    F'3'
P00226   DC    F'6'
         DC    A(Q00066)
P00228   DC    A(Q00055)
         DC    F'3'
C00117   DC    X'4419640000000000'
C00116   DC    X'40400000'
C00118   DC    X'40C00000'
C00119   DC    X'41200000'
C00121   DC    V(F77STRCP)
C00122   DC    F'4'
C00123   DC    X'3E418937'
C00124   DC    X'472625A0'
C00125   DC    X'00000000'
C00127   DC    V(F77NMLBG)
C00129   DC    V(F77NMLIT)
C00136   DC    V(F77NMLDM)
C00140   DC    V(F77NMLEN)
C00142   DC    V(F77REWND)
C00144   DC    V(F77RDBEG)
C00145   DC    F'1'
C00147   DC    V(F77RDS)
C00148   DC    V(F77RDEND)
C00150   DC    V(F77WRBEG)
C00151   DC    V(F77WRA)
C00152   DC    V(F77WREND)
C00154   DC    V(CLEAR)
C00166   DC    V(F77WRI)
C00168   DC    V(F77WRR)
C00170   DC    V(F77WRD)
C00171   DC    V(F77WRC)
C00172   DC    V(F77WRL)
C00174   DC    F'0'
C00223   DC    F'-1'
C00224   DC    F'2'
C00115   DC    H'-31'
C00227   DC    H'-1'
Q00021   DC    C'(A)'
Q00067   DC    C'('' >|'',A,''|'')'
Q00020   DC    C'('' >'',I4,F7.2,F10.4,2F6.2,L2,1X,A,4I5,'
         DC    C'3E11.3)'
Q00053   DC    C'('' >'',A)'
Q00066   DC    C'('' >IOSTAT'',I3,I4)'
Q00001   DC    C'OAK''S'
Q00002   DC    C'SET'
Q00003   DC    C'N'
Q00004   DC    C'X'
Q00005   DC    C'D'
Q00006   DC    C'C'
Q00007   DC    C'B'
Q00008   DC    C'T'
Q00009   DC    C'K'
Q00010   DC    C'Y'
Q00011   DC    C'SET'
Q00012   DC    C'N'
Q00013   DC    C'X'
Q00014   DC    C'D'
Q00015   DC    C'C'
Q00016   DC    C'B'
Q00017   DC    C'T'
Q00018   DC    C'K'
Q00019   DC    C'Y'
Q00022   DC    C' &&SET N=5, K(3)=33, B=.FALSE.,'
Q00023   DC    C'  Y=2*1.5, T=''FIR''''S'', D=1D-3 &&END'
Q00024   DC    C' &&OTHER N=99 &&END'
Q00025   DC    C' $SET X=7, K=2*,-8 $END'
Q00026   DC    C'SET'
Q00027   DC    C'N'
Q00028   DC    C'X'
Q00029   DC    C'D'
Q00030   DC    C'C'
Q00031   DC    C'B'
Q00032   DC    C'T'
Q00033   DC    C'K'
Q00034   DC    C'Y'
Q00035   DC    C'SET'
Q00036   DC    C'N'
Q00037   DC    C'X'
Q00038   DC    C'D'
Q00039   DC    C'C'
Q00040   DC    C'B'
Q00041   DC    C'T'
Q00042   DC    C'K'
Q00043   DC    C'Y'
Q00044   DC    C'SET'
Q00045   DC    C'N'
Q00046   DC    C'X'
Q00047   DC    C'D'
Q00048   DC    C'C'
Q00049   DC    C'B'
Q00050   DC    C'T'
Q00051   DC    C'K'
Q00052   DC    C'Y'
Q00054   DC    C'NO END'
Q00055   DC    C'END'
Q00056   DC    C' &&SET N=1, ELM=2 &&END'
Q00057   DC    C'SET'
Q00058   DC    C'N'
Q00059   DC    C'X'
Q00060   DC    C'D'
Q00061   DC    C'C'
Q00062   DC    C'B'
Q00063   DC    C'T'
Q00064   DC    C'K'
Q00065   DC    C'Y'
* CLEAR
CLEAR    CSECT
         USING *,15
         B     L00241
         DC    AL1(5),CL7'CLEAR'
L00241   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00242
L00243   DC    A(S00229)
L00242   L     15,L00243
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00229,13
         ST    1,S00229+72
L00231   DS    0H
         L     10,0(,1)
         L     9,4(,1)
         L     8,8(,1)
         L     7,12(,1)
         L     4,16(,1)
         L     6,20(,1)
         L     3,24(,1)
         L     2,28(,1)
         L     5,32(,1)
         LA    5,0(,5)
         LA    15,0
         ST    15,0(,10)
         MVC   0(4,9),C00244
         MVC   0(8,8),C00245
         MVC   0(4,7),C00244
         MVC   4(4,7),C00244
         LA    15,0
         ST    15,0(,4)
         LR    0,6
         ST    0,P00246+0
         LR    0,5
         ST    0,P00246+4
         LA    1,P00246
         L     15,C00247
         BALR  14,15
L00232   DS    0H
         AH    3,C00248
         LA    6,4
         LA    7,16
         LA    4,4
L00233   DS    0H
L00235   DS    0H
         LA    15,0
         ST    15,0(4,3)
         BXLE  4,6,L00233
L00234   DS    0H
L00236   DS    0H
         AH    2,C00248
         LE    0,C00244
         LA    4,4
         LA    5,12
         LA    3,4
L00237   DS    0H
L00239   DS    0H
         STE   0,0(3,2)
         BXLE  3,4,L00237
L00238   DS    0H
         LA    0,0
L00240   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00229   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00246   DC    A(0)
         DC    A(0)
         DC    A(Q00230)
         DC    F'1'
C00245   DC    X'0000000000000000'
C00244   DC    X'00000000'
C00247   DC    V(F77STRCP)
C00248   DC    H'-4'
Q00230   DC    C' '
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
