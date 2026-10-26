* main
F77MAIN  CSECT
         USING *,15
         B     L00154
         DC    AL1(7),CL7'F77MAIN'
L00154   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00155
L00156   DC    A(S00000)
L00155   L     15,L00156
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00042   DS    0H
         LA    1,P00157
         L     15,C00158
         BALR  14,15
         LA    1,P00159
         L     15,C00158
         BALR  14,15
         LA    1,P00160
         L     15,C00158
         BALR  14,15
         LA    1,P00161
         L     15,C00158
         BALR  14,15
         LH    15,C00162
         ST    15,T00036
         LA    1,P00163
         L     15,C00164
         BALR  14,15
         L     3,T00036
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     15,C00167
         BALR  14,15
L00043   DS    0H
         LA    1,P00168
         L     15,C00169
         BALR  14,15
         LR    2,15
         C     2,C00170
         BC    8,L00045
L00044   DS    0H
         LA    1,P00171
         L     15,C00164
         BALR  14,15
         L     15,C00167
         BALR  14,15
         LA    1,P00172
         L     15,C00173
         BALR  14,15
L00045   DS    0H
L00046   DS    0H
         LA    1,P00163
         L     15,C00164
         BALR  14,15
         L     3,T00036
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     15,C00167
         BALR  14,15
         LA    15,11
         ST    15,T00033
         LA    15,22
         ST    15,T00034
         LA    1,P00174
         L     15,C00169
         BALR  14,15
         LR    2,15
         C     2,C00170
         BC    8,L00048
L00047   DS    0H
         LA    1,P00175
         L     15,C00164
         BALR  14,15
         L     3,T00033
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     3,T00034
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     15,C00167
         BALR  14,15
         LA    1,P00172
         L     15,C00173
         BALR  14,15
L00048   DS    0H
L00049   DS    0H
         LA    1,P00163
         L     15,C00164
         BALR  14,15
         L     3,T00036
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     15,C00167
         BALR  14,15
         LA    1,P00176
         L     15,C00169
         BALR  14,15
         LR    2,15
         C     2,C00170
         BC    8,L00051
L00050   DS    0H
         LA    1,P00177
         L     15,C00178
         BALR  14,15
         LA    2,4
         LA    3,5
L00052   DS    0H
         C     3,C00170
         BC    2,L00053
L00054   DS    0H
         L     15,C00179
         BALR  14,15
         LA    1,P00172
         L     15,C00173
         BALR  14,15
L00051   DS    0H
L00055   DS    0H
         LA    1,P00180
         L     15,C00164
         BALR  14,15
         L     3,T00036
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         LA    2,4
         LA    3,5
L00056   DS    0H
         C     3,C00170
         BC    2,L00057
L00058   DS    0H
         L     15,C00167
         BALR  14,15
L00059   DS    0H
         LA    1,P00181
         L     15,C00169
         BALR  14,15
         LR    2,15
         C     2,C00170
         BC    8,L00061
L00060   DS    0H
         LA    1,P00182
         L     15,C00178
         BALR  14,15
         LA    1,P00183
         L     15,C00184
         BALR  14,15
         LA    1,P00185
         L     15,C00184
         BALR  14,15
         L     15,C00179
         BALR  14,15
         LA    1,P00172
         L     15,C00173
         BALR  14,15
L00061   DS    0H
L00062   DS    0H
         LA    1,P00186
         L     15,C00164
         BALR  14,15
         L     3,T00036
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     3,T00033
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     3,T00034
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     15,C00167
         BALR  14,15
L00063   DS    0H
         LA    1,P00187
         L     15,C00169
         BALR  14,15
         LA    1,P00163
         L     15,C00164
         BALR  14,15
         L     3,T00036
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     15,C00167
         BALR  14,15
         LA    15,4
         ST    15,T00032
         LA    1,P00188
         L     15,C00169
         BALR  14,15
         LR    2,15
         C     2,C00170
         BC    8,L00065
L00064   DS    0H
         LA    1,P00177
         L     15,C00178
         BALR  14,15
         LA    2,4
         LA    3,5
L00066   DS    0H
         C     3,C00170
         BC    2,L00067
L00068   DS    0H
         L     15,C00179
         BALR  14,15
         LA    1,P00172
         L     15,C00173
         BALR  14,15
L00065   DS    0H
         LA    1,P00180
         L     15,C00164
         BALR  14,15
         L     3,T00036
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         LA    2,4
         LA    3,5
L00069   DS    0H
         C     3,C00170
         BC    2,L00070
L00071   DS    0H
         L     15,C00167
         BALR  14,15
         LH    15,C00189
         ST    15,T00030
         LH    15,C00190
         ST    15,T00033
         LH    15,C00191
         ST    15,T00034
         LA    1,P00192
         L     15,C00169
         BALR  14,15
         LR    2,15
         C     2,C00170
         BC    8,L00073
L00072   DS    0H
         LA    1,P00193
         L     15,C00194
         BALR  14,15
         LA    1,P00195
         L     15,C00196
         BALR  14,15
         LA    1,P00197
         L     15,C00196
         BALR  14,15
         L     15,C00198
         BALR  14,15
         LA    1,P00199
         L     15,C00173
         BALR  14,15
L00073   DS    0H
         LA    1,P00200
         L     15,C00164
         BALR  14,15
         L     3,T00030
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     3,T00033
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     3,T00034
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     15,C00167
         BALR  14,15
L00074   DS    0H
         LA    15,1
         ST    15,T00033
         LA    15,2
         ST    15,T00034
         LA    15,3
         ST    15,T00032
         LA    1,P00201
         L     15,C00169
         BALR  14,15
         LR    2,15
         C     2,C00170
         BC    8,L00076
L00075   DS    0H
         LA    1,P00199
         L     15,C00202
         BALR  14,15
         L     2,T00033
         ST    2,T00039
         LA    1,P00203
         L     15,C00204
         BALR  14,15
         L     2,T00034
         ST    2,T00027
         LA    1,P00205
         L     15,C00204
         BALR  14,15
         L     2,T00032
         ST    2,T00028
         LA    1,P00206
         L     15,C00204
         BALR  14,15
         L     15,C00207
         BALR  14,15
         LA    1,P00199
         L     15,C00173
         BALR  14,15
L00076   DS    0H
         LA    1,P00208
         L     15,C00164
         BALR  14,15
         L     3,T00030
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     15,C00167
         BALR  14,15
L00077   DS    0H
         LA    1,P00209
         L     15,C00169
         BALR  14,15
         LR    2,15
         C     2,C00170
         BC    8,L00079
L00078   DS    0H
         LA    1,P00193
         L     15,C00194
         BALR  14,15
         LA    1,P00195
         L     15,C00196
         BALR  14,15
         LA    1,P00197
         L     15,C00196
         BALR  14,15
         L     15,C00198
         BALR  14,15
         LA    1,P00199
         L     15,C00173
         BALR  14,15
L00079   DS    0H
         LA    1,P00210
         L     15,C00164
         BALR  14,15
         L     3,T00030
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     3,T00033
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     3,T00034
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     15,C00167
         BALR  14,15
L00080   DS    0H
         LA    1,P00211
         L     15,C00169
         BALR  14,15
         LR    2,15
         C     2,C00170
         BC    8,L00082
L00081   DS    0H
         LA    1,P00193
         L     15,C00194
         BALR  14,15
         LA    1,P00195
         L     15,C00196
         BALR  14,15
         LA    1,P00197
         L     15,C00196
         BALR  14,15
         L     15,C00198
         BALR  14,15
         LA    1,P00199
         L     15,C00173
         BALR  14,15
L00082   DS    0H
         LA    1,P00210
         L     15,C00164
         BALR  14,15
         L     3,T00030
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     3,T00033
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     3,T00034
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     15,C00167
         BALR  14,15
         LA    1,P00209
         L     15,C00169
         BALR  14,15
         LR    2,15
         C     2,C00170
         BC    8,L00084
L00083   DS    0H
         LA    1,P00193
         L     15,C00194
         BALR  14,15
         LA    2,4
         LA    3,8
L00085   DS    0H
         C     3,C00170
         BC    2,L00086
L00087   DS    0H
         L     15,C00198
         BALR  14,15
         LA    1,P00199
         L     15,C00173
         BALR  14,15
L00084   DS    0H
         LA    1,P00212
         L     15,C00164
         BALR  14,15
         L     3,T00030
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         LA    2,4
         LA    3,8
L00088   DS    0H
         C     3,C00170
         BC    2,L00089
L00090   DS    0H
         L     15,C00167
         BALR  14,15
L00091   DS    0H
         LA    15,4
         ST    15,T00036
         LA    1,P00213
         L     15,C00169
         BALR  14,15
         LR    2,15
         C     2,C00170
         BC    8,L00093
L00092   DS    0H
         LA    1,P00177
         L     15,C00178
         BALR  14,15
         LA    2,4
         LA    3,5
L00094   DS    0H
         C     3,C00170
         BC    2,L00095
L00096   DS    0H
         L     15,C00179
         BALR  14,15
         LA    1,P00172
         L     15,C00173
         BALR  14,15
L00093   DS    0H
         LA    1,P00214
         L     15,C00164
         BALR  14,15
         L     3,T00036
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     15,C00167
         BALR  14,15
L00097   DS    0H
         LA    15,5
         ST    15,T00036
         LA    1,P00215
         L     15,C00169
         BALR  14,15
         LR    2,15
         C     2,C00170
         BC    8,L00099
L00098   DS    0H
         LA    1,P00171
         L     15,C00164
         BALR  14,15
         L     15,C00167
         BALR  14,15
         LA    1,P00172
         L     15,C00173
         BALR  14,15
L00099   DS    0H
         LA    1,P00214
         L     15,C00164
         BALR  14,15
         L     3,T00036
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     15,C00167
         BALR  14,15
         LA    1,P00216
         L     15,C00169
         BALR  14,15
         LA    1,P00214
         L     15,C00164
         BALR  14,15
         L     3,T00036
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     15,C00167
         BALR  14,15
         LA    1,P00217
         L     15,C00169
         BALR  14,15
         LR    2,15
         C     2,C00170
         BC    8,L00101
L00100   DS    0H
         LA    1,P00218
         L     15,C00164
         BALR  14,15
         L     15,C00167
         BALR  14,15
         LA    1,P00172
         L     15,C00173
         BALR  14,15
L00101   DS    0H
L00102   DS    0H
         LA    1,P00219
         L     15,C00169
         BALR  14,15
         LR    2,15
         C     2,C00170
         BC    8,L00104
L00103   DS    0H
         LA    1,P00220
         L     15,C00178
         BALR  14,15
         LA    2,4
         LA    3,8
L00105   DS    0H
         C     3,C00170
         BC    2,L00106
L00107   DS    0H
         L     15,C00179
         BALR  14,15
         LA    1,P00172
         L     15,C00173
         BALR  14,15
L00104   DS    0H
L00108   DS    0H
         LA    1,P00221
         L     15,C00164
         BALR  14,15
         L     3,T00036
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         LA    2,4
         LA    3,8
L00109   DS    0H
         C     3,C00170
         BC    2,L00110
L00111   DS    0H
         L     15,C00167
         BALR  14,15
L00112   DS    0H
         L     2,T00037+16
         ST    2,T00037
         LA    1,P00222
         L     15,C00169
         BALR  14,15
         LR    2,15
         C     2,C00170
         BC    8,L00114
L00113   DS    0H
         LA    1,P00223
         L     15,C00178
         BALR  14,15
         LA    1,P00224
         L     15,C00184
         BALR  14,15
         L     15,C00179
         BALR  14,15
         LA    1,P00225
         L     15,C00173
         BALR  14,15
L00114   DS    0H
L00115   DS    0H
         L     2,T00038+20
         ST    2,T00037
         LH    15,C00226
         ST    15,T00033
         MVC   T00035(4),C00227
         LA    1,P00228
         L     15,C00169
         BALR  14,15
         LR    2,15
         C     2,C00170
         BC    8,L00117
L00116   DS    0H
         LA    1,P00225
         L     15,C00202
         BALR  14,15
         L     2,T00033
         ST    2,T00041
         LA    1,P00229
         L     15,C00204
         BALR  14,15
         LE    0,T00035
         STE   0,T00029
         LA    1,P00230
         L     15,C00204
         BALR  14,15
         L     15,C00207
         BALR  14,15
         LA    1,P00225
         L     15,C00173
         BALR  14,15
L00117   DS    0H
         LA    1,P00231
         L     15,C00164
         BALR  14,15
         L     3,T00031
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     15,C00167
         BALR  14,15
L00118   DS    0H
         LA    15,0
         ST    15,T00033
         MVC   T00035(4),C00232
         LA    1,P00233
         L     15,C00169
         BALR  14,15
         LR    2,15
         C     2,C00170
         BC    8,L00120
L00119   DS    0H
         LA    1,P00234
         L     15,C00194
         BALR  14,15
         LA    1,P00195
         L     15,C00196
         BALR  14,15
         LA    1,P00235
         L     15,C00196
         BALR  14,15
         L     15,C00198
         BALR  14,15
         LA    1,P00225
         L     15,C00173
         BALR  14,15
L00120   DS    0H
         LA    1,P00236
         L     15,C00169
         BALR  14,15
         LR    2,15
         C     2,C00170
         BC    8,L00122
L00121   DS    0H
         LA    1,P00237
         L     15,C00164
         BALR  14,15
         L     15,C00167
         BALR  14,15
         LA    1,P00225
         L     15,C00173
         BALR  14,15
L00122   DS    0H
L00123   DS    0H
         LA    1,P00238
         L     15,C00169
         BALR  14,15
         LR    2,15
         C     2,C00170
         BC    8,L00125
L00124   DS    0H
         LA    1,P00223
         L     15,C00178
         BALR  14,15
         LA    1,P00239
         L     15,C00184
         BALR  14,15
         L     15,C00179
         BALR  14,15
         LA    1,P00225
         L     15,C00173
         BALR  14,15
L00125   DS    0H
         LA    1,P00240
         L     15,C00164
         BALR  14,15
         L     3,T00031
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     3,T00033
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         LE    0,T00035
         STE   0,S00000+456
         LE    0,S00000+456
         STE   0,P00241+0
         LA    1,P00241
         L     15,C00242
         BALR  14,15
         L     3,T00037+8
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     15,C00167
         BALR  14,15
L00126   DS    0H
         L     15,C00243
         BALR  14,15
         L     14,C00244
         L     2,0(,14)
         S     2,C00245
         LR    0,2
         ST    0,P00246+4
         LA    1,P00246
         L     15,C00169
         BALR  14,15
         LR    3,15
         C     3,C00170
         BC    8,L00128
L00127   DS    0H
         LA    1,P00247
         L     15,C00178
         BALR  14,15
         LA    1,P00183
         L     15,C00184
         BALR  14,15
         L     15,C00179
         BALR  14,15
         LA    1,P00248
         L     15,C00173
         BALR  14,15
L00128   DS    0H
L00129   DS    0H
         LA    1,P00249
         L     15,C00164
         BALR  14,15
         L     14,C00244
         L     3,0(,14)
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     3,T00033
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     15,C00167
         BALR  14,15
L00130   DS    0H
L00131   DS    0H
         LH    15,C00190
         ST    15,T00032
L00132   DS    0H
         LA    1,P00250
         L     15,C00169
         BALR  14,15
         LR    2,15
         C     2,C00170
         BC    8,L00135
L00134   DS    0H
         LA    1,P00251
         L     15,C00202
         BALR  14,15
         LA    2,4
         LA    3,9
L00136   DS    0H
         C     3,C00170
         BC    2,L00137
L00138   DS    0H
         L     15,C00207
         BALR  14,15
         LA    1,P00251
         L     15,C00173
         BALR  14,15
L00135   DS    0H
L00133   DS    0H
         LA    1,P00252
         L     15,C00164
         BALR  14,15
         L     3,T00032
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     15,C00167
         BALR  14,15
L00139   DS    0H
         L     2,T00032
         C     2,C00170
         BC    13,L00141
L00140   DS    0H
         LA    1,P00253
         L     15,C00169
         BALR  14,15
L00141   DS    0H
         LA    1,P00254
         L     15,C00164
         BALR  14,15
         L     3,T00036
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     15,C00167
         BALR  14,15
L00142   DS    0H
         LA    15,42
         ST    15,T00033
         LA    1,P00255
         L     15,C00164
         BALR  14,15
         L     3,T00033
         LR    0,3
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         L     15,C00167
         BALR  14,15
L00143   DS    0H
         LA    1,P00256
         L     15,C00257
         BALR  14,15
         LA    1,P00258
         L     15,C00178
         BALR  14,15
         LA    2,4
         LA    3,5
L00144   DS    0H
         C     3,C00170
         BC    2,L00145
L00146   DS    0H
         L     15,C00179
         BALR  14,15
L00147   DS    0H
         LA    1,P00259
         L     15,C00164
         BALR  14,15
         LA    2,4
         LA    3,5
L00148   DS    0H
         C     3,C00170
         BC    2,L00149
L00150   DS    0H
         L     15,C00167
         BALR  14,15
L00151   DS    0H
         LA    1,P00260
         L     15,C00261
         BALR  14,15
         B     L00153
L00053   DS    0H
         LR    4,2
         AH    4,C00262
         LA    5,T00037
         AR    5,4
         LR    0,5
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00184
         BALR  14,15
         AH    3,C00190
         A     2,C00263
         B     L00052
L00057   DS    0H
         L     5,T00037-4(2)
         LR    0,5
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         AH    3,C00190
         A     2,C00263
         B     L00056
L00067   DS    0H
         LR    4,2
         AH    4,C00262
         LA    5,T00037
         AR    5,4
         LR    0,5
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00184
         BALR  14,15
         AH    3,C00190
         A     2,C00263
         B     L00066
L00070   DS    0H
         L     5,T00037-4(2)
         LR    0,5
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         AH    3,C00190
         A     2,C00263
         B     L00069
L00086   DS    0H
         LR    4,2
         AH    4,C00262
         LA    5,T00038
         AR    5,4
         LR    0,5
         ST    0,P00264+0
         LA    1,P00264
         L     15,C00196
         BALR  14,15
         AH    3,C00190
         A     2,C00263
         B     L00085
L00089   DS    0H
         L     5,T00038-4(2)
         LR    0,5
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         AH    3,C00190
         A     2,C00263
         B     L00088
L00095   DS    0H
         LR    4,2
         AH    4,C00262
         LA    5,T00037
         AR    5,4
         LR    0,5
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00184
         BALR  14,15
         AH    3,C00190
         A     2,C00263
         B     L00094
L00106   DS    0H
         LR    4,2
         AH    4,C00262
         LA    5,T00038
         AR    5,4
         LR    0,5
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00184
         BALR  14,15
         AH    3,C00190
         A     2,C00263
         B     L00105
L00110   DS    0H
         L     5,T00038-4(2)
         LR    0,5
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         AH    3,C00190
         A     2,C00263
         B     L00109
L00137   DS    0H
         LR    4,2
         AH    4,C00262
         LA    5,T00040
         AR    5,4
         LR    0,5
         ST    0,P00264+0
         LA    1,P00264
         L     15,C00204
         BALR  14,15
         AH    3,C00190
         A     2,C00263
         B     L00136
L00145   DS    0H
         LR    4,2
         AH    4,C00262
         LA    5,T00037
         AR    5,4
         LR    0,5
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00184
         BALR  14,15
         AH    3,C00190
         A     2,C00263
         B     L00144
L00149   DS    0H
         L     5,T00037-4(2)
         LR    0,5
         ST    0,P00165+0
         LA    1,P00165
         L     15,C00166
         BALR  14,15
         AH    3,C00190
         A     2,C00263
         B     L00148
L00152   DS    0H
L00153   DS    0H
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
T00027   DS    XL4
         DS    XL4
T00028   DS    XL4
         DS    XL4
T00029   DS    XL4
         DS    XL4
T00030   DS    XL8
T00031   DS    XL8
T00032   DS    XL8
T00033   DS    XL8
T00034   DS    XL8
T00035   DS    XL8
T00036   DS    XL12
         DS    XL4
T00037   DS    XL24
T00038   DS    XL36
         DS    XL4
T00039   DS    XL36
         DS    XL4
T00040   DS    XL40
T00041   DS    XL44
         DS    XL4
         DS    1D
P00157   DC    F'21'
         DC    F'10'
         DC    F'20'
         DC    F'0'
         DC    A(T00036)
P00159   DC    F'22'
         DC    F'5'
         DC    F'2'
         DC    F'1'
         DC    A(T00030)
P00160   DC    F'23'
         DC    F'6'
         DC    F'12'
         DC    F'2'
         DC    A(T00031)
P00161   DC    F'25'
         DC    F'4'
         DC    F'9'
         DC    F'1'
         DC    A(T00032)
P00163   DC    F'6'
         DC    A(Q00001)
P00165   DC    A(0)
P00168   DC    F'21'
         DC    F'3'
         DC    F'1'
P00171   DC    F'21'
         DC    A(Q00002)
P00172   DC    F'21'
P00174   DC    F'21'
         DC    F'1'
         DC    F'1'
P00175   DC    F'21'
         DC    A(Q00003)
P00176   DC    F'21'
         DC    F'3'
         DC    F'0'
P00177   DC    F'21'
         DC    A(Q00004)
         DC    F'0'
P00180   DC    F'6'
         DC    A(Q00005)
P00181   DC    F'21'
         DC    F'1'
         DC    F'0'
P00182   DC    F'21'
         DC    A(Q00006)
         DC    F'0'
P00183   DC    A(T00033)
P00185   DC    A(T00034)
P00186   DC    F'6'
         DC    A(Q00007)
P00187   DC    F'21'
         DC    F'7'
         DC    F'2'
P00188   DC    F'21'
         DC    F'5'
         DC    F'0'
P00192   DC    F'22'
         DC    F'3'
         DC    F'0'
P00193   DC    F'22'
         DC    F'0'
P00195   DC    A(T00033)
         DC    F'4'
P00197   DC    A(T00034)
         DC    F'4'
P00199   DC    F'22'
P00200   DC    F'6'
         DC    A(Q00008)
P00201   DC    F'22'
         DC    F'1'
         DC    F'1'
P00203   DC    A(T00039)
         DC    F'4'
P00205   DC    A(T00027)
         DC    F'4'
P00206   DC    A(T00028)
         DC    F'4'
P00208   DC    F'6'
         DC    A(Q00009)
P00209   DC    F'22'
         DC    F'1'
         DC    F'0'
P00210   DC    F'6'
         DC    A(Q00010)
P00211   DC    F'22'
         DC    F'2'
         DC    F'0'
P00212   DC    F'6'
         DC    A(Q00011)
P00213   DC    F'21'
         DC    F'11'
         DC    F'0'
P00214   DC    F'6'
         DC    A(Q00012)
P00215   DC    F'21'
         DC    F'0'
         DC    F'1'
P00216   DC    F'21'
         DC    F'12'
         DC    F'2'
P00217   DC    F'21'
         DC    F'2'
         DC    F'1'
P00218   DC    F'21'
         DC    A(Q00013)
P00219   DC    F'21'
         DC    F'2'
         DC    F'0'
P00220   DC    F'21'
         DC    A(Q00014)
         DC    F'0'
P00221   DC    F'6'
         DC    A(Q00015)
P00222   DC    F'23'
         DC    F'2'
         DC    F'0'
P00223   DC    F'23'
         DC    A(Q00016)
         DC    F'0'
P00224   DC    A(T00037)
P00225   DC    F'23'
P00228   DC    F'23'
         DC    F'5'
         DC    F'1'
P00229   DC    A(T00041)
         DC    F'4'
P00230   DC    A(T00029)
         DC    F'4'
P00231   DC    F'6'
         DC    A(Q00017)
P00233   DC    F'23'
         DC    F'5'
         DC    F'0'
P00234   DC    F'23'
         DC    F'0'
P00235   DC    A(T00035)
         DC    F'4'
P00236   DC    F'23'
         DC    F'4'
         DC    F'1'
P00237   DC    F'23'
         DC    A(Q00018)
P00238   DC    F'23'
         DC    F'4'
         DC    F'0'
P00239   DC    A(T00037+8)
P00240   DC    F'6'
         DC    A(Q00019)
P00241   DC    A(0)
P00246   DC    F'24'
         DC    A(0)
         DC    F'0'
P00247   DC    F'24'
         DC    A(Q00020)
         DC    F'0'
P00248   DC    F'24'
P00249   DC    F'6'
         DC    A(Q00021)
P00250   DC    F'25'
         DC    F'1'
         DC    F'1'
P00251   DC    F'25'
P00252   DC    F'6'
         DC    A(Q00022)
P00253   DC    F'21'
         DC    F'10'
         DC    F'2'
P00254   DC    F'6'
         DC    A(Q00023)
P00255   DC    F'7'
         DC    A(Q00024)
P00256   DC    F'7'
P00258   DC    F'7'
         DC    A(Q00025)
         DC    F'0'
P00259   DC    F'6'
         DC    A(Q00026)
P00260   DC    F'0'
P00264   DC    A(0)
         DC    F'4'
C00158   DC    V(F77DFILE)
C00164   DC    V(F77WRBEG)
C00166   DC    V(F77WRI)
C00167   DC    V(F77WREND)
C00169   DC    V(F77DAREC)
C00170   DC    F'0'
C00173   DC    V(F77DADON)
C00178   DC    V(F77RDBEG)
C00179   DC    V(F77RDEND)
C00184   DC    V(F77RDI)
C00194   DC    V(F77RUBEG)
C00196   DC    V(F77RU)
C00198   DC    V(F77RUEND)
C00202   DC    V(F77WUBEG)
C00204   DC    V(F77WU)
C00207   DC    V(F77WUEND)
C00227   DC    X'41280000'
C00232   DC    X'00000000'
C00242   DC    V(F77WRR)
C00243   DC    V(DSUB)
C00244   DC    A(DA)
C00245   DC    F'1'
C00257   DC    V(F77REWND)
C00261   DC    V(EXIT)
C00263   DC    F'4'
C00162   DC    H'-7'
C00189   DC    H'-5'
C00190   DC    H'-1'
C00191   DC    H'-2'
C00226   DC    H'12345'
C00262   DC    H'-4'
Q00001   DC    C'('' >A '',I6)'
Q00002   DC    C'(''GHI3'')'
Q00003   DC    C'(I5/I5)'
Q00004   DC    C'(5A4)'
Q00005   DC    C'('' >B '',I6,'' |'',5A4,''|'')'
Q00006   DC    C'(I5)'
Q00007   DC    C'('' >C '',3I6)'
Q00008   DC    C'('' >D '',3I6)'
Q00009   DC    C'('' >E '',I6)'
Q00010   DC    C'('' >F '',I6,2(1X,Z8))'
Q00011   DC    C'('' >G '',I6,8(1X,Z8))'
Q00012   DC    C'('' >H '',I6)'
Q00013   DC    C'(''ABCDEFGHIJKLMNOPQRSTUVWXYZ'')'
Q00014   DC    C'(8A4)'
Q00015   DC    C'('' >I '',I6,'' |'',8A4,''|'')'
Q00016   DC    C'(A2)'
Q00017   DC    C'('' >J '',I6)'
Q00018   DC    C'(''XY'')'
Q00019   DC    C'('' >K '',2I6,F6.2,'' |'',A2,''|'')'
Q00020   DC    C'(I4)'
Q00021   DC    C'('' >L '',2I6)'
Q00022   DC    C'('' >M '',I6)'
Q00023   DC    C'('' >N '',I6)'
Q00024   DC    C'('' PUNCHED'',I5)'
Q00025   DC    C'(5A4)'
Q00026   DC    C'('' >P '',5A4)'
* DSUB
DSUB     CSECT
         USING *,15
         B     L00273
         DC    AL1(4),CL7'DSUB'
L00273   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00274
L00275   DC    A(S00265)
L00274   L     15,L00275
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00265,13
         ST    1,S00265+72
L00267   DS    0H
         LA    1,P00276
         L     15,C00277
         BALR  14,15
         LA    1,P00278
         L     15,C00279
         BALR  14,15
         LR    2,15
         C     2,C00280
         BC    8,L00269
L00268   DS    0H
         LA    1,P00281
         L     15,C00282
         BALR  14,15
         L     15,C00283
         BALR  14,15
         LA    1,P00284
         L     15,C00285
         BALR  14,15
L00269   DS    0H
L00270   DS    0H
         LA    0,0
         B     L00272
L00271   DS    0H
L00272   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00265   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00276   DC    F'24'
         DC    F'3'
         DC    F'4'
         DC    F'0'
         DC    A(DA)
P00278   DC    F'24'
         DC    F'2'
         DC    F'1'
P00281   DC    F'24'
         DC    A(Q00266)
P00284   DC    F'24'
         DS    XL4
C00277   DC    V(F77DFILE)
C00279   DC    V(F77DAREC)
C00280   DC    F'0'
C00282   DC    V(F77WRBEG)
C00283   DC    V(F77WREND)
C00285   DC    V(F77DADON)
Q00266   DC    C'(''  77'')'
DA       CSECT
         DS    0D
         DS    XL4
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
