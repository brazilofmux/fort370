* main
F77MAIN  CSECT
         USING *,15
         B     L00223
         DC    AL1(7),CL7'F77MAIN'
L00223   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
L00224   DS    0H
         LA    11,2048(,12)
         LA    11,2048(,11)
         USING L00224+4096,11
         B     L00225
L00226   DC    A(S00000)
L00225   L     15,L00226
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00075   DS    0H
         L     2,C00228
         L     3,C00230
         L     4,C00232
         MVC   T00042(4),C00233
         MVC   T00042+4(4),C00234
         LE    0,C00233
         STE   0,P00235+4
         LE    0,C00234
         STE   0,P00235+8
         LA    1,P00235
         L     15,C00236
         BALR  14,15
         LE    2,T00074
         LE    0,T00074+4
         L     14,C00228
         STE   2,0(,14)
         L     14,C00237
         STE   0,0(,14)
         LA    1,P00238
         L     15,C00239
         BALR  14,15
         LR    7,2
         AH    7,C00240
         LA    5,4
         LA    6,2
L00076   DS    0H
         C     6,C00241
         BC    2,L00077
L00078   DS    0H
         L     15,C00242
         BALR  14,15
L00079   DS    0H
         L     14,C00244
         LE    0,0(,14)
         STE   0,S00000+1064
         MVC   T00042(4),S00000+1064
         MVC   T00042+4(4),C00245
         LE    0,S00000+1064
         STE   0,P00246+4
         LE    0,C00245
         STE   0,P00246+8
         LA    1,P00246
         L     15,C00236
         BALR  14,15
         LE    2,T00043
         LE    0,T00043+4
         L     14,C00228
         STE   2,0(,14)
         L     14,C00237
         STE   0,0(,14)
         LA    1,P00247
         L     15,C00239
         BALR  14,15
         LR    7,2
         AH    7,C00240
         LA    5,4
         LA    6,2
L00080   DS    0H
         C     6,C00241
         BC    2,L00081
L00082   DS    0H
         L     15,C00242
         BALR  14,15
L00083   DS    0H
         L     14,C00248
         LE    0,0(,14)
         STE   0,S00000+1064
         MVC   T00042(4),S00000+1064
         MVC   T00042+4(4),C00245
         LE    0,S00000+1064
         STE   0,P00249+4
         LE    0,C00245
         STE   0,P00249+8
         LA    1,P00249
         L     15,C00236
         BALR  14,15
         LE    2,T00044
         LE    0,T00044+4
         L     14,C00228
         STE   2,0(,14)
         L     14,C00237
         STE   0,0(,14)
         LA    1,P00250
         L     15,C00239
         BALR  14,15
         LR    7,2
         AH    7,C00240
         LA    5,4
         LA    6,2
L00084   DS    0H
         C     6,C00241
         BC    2,L00085
L00086   DS    0H
         L     15,C00242
         BALR  14,15
L00087   DS    0H
         MVC   T00042(4),C00234
         MVC   T00042+4(4),C00251
         LE    0,C00234
         STE   0,P00252+4
         LE    0,C00251
         STE   0,P00252+8
         LA    1,P00252
         L     15,C00236
         BALR  14,15
         LE    2,T00045
         LE    0,T00045+4
         L     14,C00228
         STE   2,0(,14)
         L     14,C00237
         STE   0,0(,14)
         LA    1,P00253
         L     15,C00239
         BALR  14,15
         LR    7,2
         AH    7,C00240
         LA    5,4
         LA    6,2
L00088   DS    0H
         C     6,C00241
         BC    2,L00089
L00090   DS    0H
         L     15,C00242
         BALR  14,15
L00091   DS    0H
         L     14,C00254
         LE    0,0(,14)
         STE   0,S00000+1064
         MVC   T00042(4),C00234
         MVC   T00042+4(4),S00000+1064
         LE    0,C00234
         STE   0,P00255+4
         LE    0,S00000+1064
         STE   0,P00255+8
         LA    1,P00255
         L     15,C00236
         BALR  14,15
         LE    2,T00046
         LE    0,T00046+4
         L     14,C00228
         STE   2,0(,14)
         L     14,C00237
         STE   0,0(,14)
         LA    1,P00256
         L     15,C00239
         BALR  14,15
         LR    7,2
         AH    7,C00240
         LA    5,4
         LA    6,2
L00092   DS    0H
         C     6,C00241
         BC    2,L00093
L00094   DS    0H
         L     15,C00242
         BALR  14,15
L00095   DS    0H
         MVC   T00042(4),C00233
         MVC   T00042+4(4),C00257
         LE    0,C00233
         STE   0,P00258+4
         LE    0,C00257
         STE   0,P00258+8
         LA    1,P00258
         L     15,C00236
         BALR  14,15
         LE    2,T00047
         LE    0,T00047+4
         L     14,C00228
         STE   2,0(,14)
         L     14,C00237
         STE   0,0(,14)
         LA    1,P00259
         L     15,C00239
         BALR  14,15
         LR    7,2
         AH    7,C00240
         LA    5,4
         LA    6,2
L00096   DS    0H
         C     6,C00241
         BC    2,L00097
L00098   DS    0H
         L     15,C00242
         BALR  14,15
L00099   DS    0H
         MVC   T00042(4),C00245
         MVC   T00042+4(4),C00245
         LE    0,C00245
         STE   0,P00260+4
         LE    0,C00245
         STE   0,P00260+8
         LA    1,P00260
         L     15,C00261
         BALR  14,15
         LE    2,T00048
         LE    0,T00048+4
         L     14,C00228
         STE   2,0(,14)
         L     14,C00237
         STE   0,0(,14)
         LA    1,P00262
         L     15,C00239
         BALR  14,15
         LR    7,2
         AH    7,C00240
         LA    5,4
         LA    6,2
L00100   DS    0H
         C     6,C00241
         BC    2,L00101
L00102   DS    0H
         L     15,C00242
         BALR  14,15
L00103   DS    0H
         L     14,C00254
         LE    0,0(,14)
         STE   0,S00000+1064
         MVC   T00042(4),S00000+1064
         MVC   T00042+4(4),C00234
         LE    0,S00000+1064
         STE   0,P00263+4
         LE    0,C00234
         STE   0,P00263+8
         LA    1,P00263
         L     15,C00264
         BALR  14,15
         LE    2,T00049
         LE    0,T00049+4
         L     14,C00228
         STE   2,0(,14)
         L     14,C00237
         STE   0,0(,14)
         LA    1,P00265
         L     15,C00239
         BALR  14,15
         LR    7,2
         AH    7,C00240
         LA    5,4
         LA    6,2
L00104   DS    0H
         C     6,C00241
         BC    2,L00105
L00106   DS    0H
         L     15,C00242
         BALR  14,15
L00107   DS    0H
         MVC   T00042(4),C00251
         MVC   T00042+4(4),C00234
         LE    0,C00251
         STE   0,P00266+4
         LE    0,C00234
         STE   0,P00266+8
         LA    1,P00266
         L     15,C00264
         BALR  14,15
         LE    2,T00050
         LE    0,T00050+4
         L     14,C00228
         STE   2,0(,14)
         L     14,C00237
         STE   0,0(,14)
         LA    1,P00267
         L     15,C00239
         BALR  14,15
         LR    7,2
         AH    7,C00240
         LA    5,4
         LA    6,2
L00108   DS    0H
         C     6,C00241
         BC    2,L00109
L00110   DS    0H
         L     15,C00242
         BALR  14,15
L00111   DS    0H
         MVC   T00042(4),C00234
         MVC   T00042+4(4),C00233
         LE    0,C00234
         STE   0,P00268+4
         LE    0,C00233
         STE   0,P00268+8
         LA    1,P00268
         L     15,C00264
         BALR  14,15
         LE    2,T00051
         LE    0,T00051+4
         L     14,C00228
         STE   2,0(,14)
         L     14,C00237
         STE   0,0(,14)
         LA    1,P00269
         L     15,C00239
         BALR  14,15
         LR    7,2
         AH    7,C00240
         LA    5,4
         LA    6,2
L00112   DS    0H
         C     6,C00241
         BC    2,L00113
L00114   DS    0H
         L     15,C00242
         BALR  14,15
L00115   DS    0H
         LE    0,C00233
         LCER  0,0
         STE   0,S00000+1064
         MVC   T00042(4),C00270
         MVC   T00042+4(4),S00000+1064
         LE    0,C00270
         STE   0,P00271+4
         LE    0,S00000+1064
         STE   0,P00271+8
         LA    1,P00271
         L     15,C00264
         BALR  14,15
         LE    2,T00052
         LE    0,T00052+4
         L     14,C00228
         STE   2,0(,14)
         L     14,C00237
         STE   0,0(,14)
         LA    1,P00272
         L     15,C00239
         BALR  14,15
         LR    7,2
         AH    7,C00240
         LA    5,4
         LA    6,2
L00116   DS    0H
         C     6,C00241
         BC    2,L00117
L00118   DS    0H
         L     15,C00242
         BALR  14,15
L00119   DS    0H
         L     14,C00244
         LE    0,0(,14)
         STE   0,S00000+1064
         MVC   T00042(4),C00234
         MVC   T00042+4(4),S00000+1064
         LE    0,C00234
         STE   0,P00273+4
         LE    0,S00000+1064
         STE   0,P00273+8
         LA    1,P00273
         L     15,C00264
         BALR  14,15
         LE    2,T00053
         LE    0,T00053+4
         L     14,C00228
         STE   2,0(,14)
         L     14,C00237
         STE   0,0(,14)
         LA    1,P00274
         L     15,C00239
         BALR  14,15
         LR    7,2
         AH    7,C00240
         LA    5,4
         LA    6,2
L00120   DS    0H
         C     6,C00241
         BC    2,L00121
L00122   DS    0H
         L     15,C00242
         BALR  14,15
L00123   DS    0H
         MVC   T00042(4),C00257
         MVC   T00042+4(4),C00233
         LE    0,C00257
         STE   0,P00275+4
         LE    0,C00233
         STE   0,P00275+8
         LA    1,P00275
         L     15,C00264
         BALR  14,15
         LE    2,T00054
         LE    0,T00054+4
         L     14,C00228
         STE   2,0(,14)
         L     14,C00237
         STE   0,0(,14)
         LA    1,P00276
         L     15,C00239
         BALR  14,15
         LR    7,2
         AH    7,C00240
         LA    5,4
         LA    6,2
L00124   DS    0H
         C     6,C00241
         BC    2,L00125
L00126   DS    0H
         L     15,C00242
         BALR  14,15
L00127   DS    0H
         MVC   T00042(4),C00234
         MVC   T00042+4(4),C00233
         LE    0,C00234
         STE   0,P00277+4
         LE    0,C00233
         STE   0,P00277+8
         LA    1,P00277
         L     15,C00278
         BALR  14,15
         LE    2,T00055
         LE    0,T00055+4
         L     14,C00228
         STE   2,0(,14)
         L     14,C00237
         STE   0,0(,14)
         LA    1,P00279
         L     15,C00239
         BALR  14,15
         LR    7,2
         AH    7,C00240
         LA    5,4
         LA    6,2
L00128   DS    0H
         C     6,C00241
         BC    2,L00129
L00130   DS    0H
         L     15,C00242
         BALR  14,15
L00131   DS    0H
         LE    0,C00270
         LCER  0,0
         STE   0,S00000+1064
         LE    0,C00233
         LCER  0,0
         STE   0,S00000+1072
         MVC   T00042(4),S00000+1064
         MVC   T00042+4(4),S00000+1072
         LE    0,S00000+1064
         STE   0,P00280+4
         LE    0,S00000+1072
         STE   0,P00280+8
         LA    1,P00280
         L     15,C00278
         BALR  14,15
         LE    2,T00056
         LE    0,T00056+4
         L     14,C00228
         STE   2,0(,14)
         L     14,C00237
         STE   0,0(,14)
         LA    1,P00281
         L     15,C00239
         BALR  14,15
         LR    7,2
         AH    7,C00240
         LA    5,4
         LA    6,2
L00132   DS    0H
         C     6,C00241
         BC    2,L00133
L00134   DS    0H
         L     15,C00242
         BALR  14,15
L00135   DS    0H
         LE    0,C00282
         LCER  0,0
         STE   0,S00000+1064
         MVC   T00042(4),S00000+1064
         MVC   T00042+4(4),C00282
         LE    0,S00000+1064
         STE   0,P00283+4
         LE    0,C00282
         STE   0,P00283+8
         LA    1,P00283
         L     15,C00284
         BALR  14,15
         LE    2,T00057
         LE    0,T00057+4
         L     14,C00228
         STE   2,0(,14)
         L     14,C00237
         STE   0,0(,14)
         LA    1,P00285
         L     15,C00239
         BALR  14,15
         LR    7,2
         AH    7,C00240
         LA    5,4
         LA    6,2
L00136   DS    0H
         C     6,C00241
         BC    2,L00137
L00138   DS    0H
         L     15,C00242
         BALR  14,15
L00139   DS    0H
         LE    0,C00287
         STE   0,P00286+0
         LE    0,C00288
         STE   0,P00286+4
         LA    1,P00286
         L     15,C00289
         BALR  14,15
         L     14,C00291
         STE   0,0(,14)
         LA    1,P00292
         L     15,C00239
         BALR  14,15
         L     14,C00291
         L     6,0(,14)
         LR    0,6
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         L     15,C00242
         BALR  14,15
L00140   DS    0H
         MVC   T00042(4),C00245
         MVC   T00042+4(4),C00245
         LE    0,C00245
         STE   0,P00295+4
         LE    0,C00245
         STE   0,P00295+8
         LA    1,P00295
         L     15,C00296
         BALR  14,15
         LE    2,T00058
         LE    0,T00058+4
         L     14,C00228
         STE   2,0(,14)
         L     14,C00237
         STE   0,0(,14)
         LA    1,P00297
         L     15,C00239
         BALR  14,15
         LR    7,2
         AH    7,C00240
         LA    5,4
         LA    6,2
L00141   DS    0H
         C     6,C00241
         BC    2,L00142
L00143   DS    0H
         L     15,C00242
         BALR  14,15
L00144   DS    0H
         MVC   T00042(4),C00245
         MVC   T00042+4(4),C00245
         LE    0,C00245
         STE   0,P00298+4
         LE    0,C00245
         STE   0,P00298+8
         LA    1,P00298
         L     15,C00296
         BALR  14,15
         LE    2,T00059
         LE    0,T00059+4
         L     14,C00228
         STE   2,0(,14)
         L     14,C00237
         STE   0,0(,14)
         LA    1,P00299
         L     15,C00239
         BALR  14,15
         AH    2,C00240
         LA    5,4
         LA    6,2
L00145   DS    0H
         C     6,C00241
         BC    2,L00146
L00147   DS    0H
         L     15,C00242
         BALR  14,15
L00148   DS    0H
         MVC   T00073(8),C00300
         MVC   T00073+8(8),C00301
         LD    0,C00300
         STD   0,P00302+0
         LD    0,C00301
         STD   0,P00302+8
         LA    1,P00302
         L     15,C00303
         BALR  14,15
         LD    2,T00060
         LD    0,T00060+8
         L     14,C00230
         STD   2,0(,14)
         L     14,C00304
         STD   0,0(,14)
         LA    1,P00305
         L     15,C00239
         BALR  14,15
         LR    6,3
         AH    6,C00240
         LA    2,4
         LA    5,4
L00149   DS    0H
         C     5,C00241
         BC    2,L00150
L00151   DS    0H
         L     15,C00242
         BALR  14,15
L00152   DS    0H
         L     14,C00307
         LD    0,0(,14)
         STD   0,S00000+1064
         MVC   T00073(8),S00000+1064
         MVC   T00073+8(8),C00308
         LD    0,S00000+1064
         STD   0,P00309+0
         LD    0,C00308
         STD   0,P00309+8
         LA    1,P00309
         L     15,C00303
         BALR  14,15
         LD    2,T00061
         LD    0,T00061+8
         L     14,C00230
         STD   2,0(,14)
         L     14,C00304
         STD   0,0(,14)
         LA    1,P00310
         L     15,C00239
         BALR  14,15
         LR    6,3
         AH    6,C00240
         LA    2,4
         LA    5,4
L00153   DS    0H
         C     5,C00241
         BC    2,L00154
L00155   DS    0H
         L     15,C00242
         BALR  14,15
L00156   DS    0H
         L     14,C00311
         LD    0,0(,14)
         STD   0,S00000+1064
         MVC   T00073(8),S00000+1064
         MVC   T00073+8(8),C00308
         LD    0,S00000+1064
         STD   0,P00312+0
         LD    0,C00308
         STD   0,P00312+8
         LA    1,P00312
         L     15,C00303
         BALR  14,15
         LD    2,T00062
         LD    0,T00062+8
         L     14,C00230
         STD   2,0(,14)
         L     14,C00304
         STD   0,0(,14)
         LA    1,P00313
         L     15,C00239
         BALR  14,15
         LR    6,3
         AH    6,C00240
         LA    2,4
         LA    5,4
L00157   DS    0H
         C     5,C00241
         BC    2,L00158
L00159   DS    0H
         L     15,C00242
         BALR  14,15
L00160   DS    0H
         L     14,C00314
         LD    0,0(,14)
         STD   0,S00000+1064
         MVC   T00073(8),S00000+1064
         MVC   T00073+8(8),C00308
         LD    0,S00000+1064
         STD   0,P00315+0
         LD    0,C00308
         STD   0,P00315+8
         LA    1,P00315
         L     15,C00303
         BALR  14,15
         LD    2,T00063
         LD    0,T00063+8
         L     14,C00230
         STD   2,0(,14)
         L     14,C00304
         STD   0,0(,14)
         LA    1,P00316
         L     15,C00239
         BALR  14,15
         LR    6,3
         AH    6,C00240
         LA    2,4
         LA    5,4
L00161   DS    0H
         C     5,C00241
         BC    2,L00162
L00163   DS    0H
         L     15,C00242
         BALR  14,15
L00164   DS    0H
         L     14,C00317
         LD    0,0(,14)
         STD   0,S00000+1064
         MVC   T00073(8),C00301
         MVC   T00073+8(8),S00000+1064
         LD    0,C00301
         STD   0,P00318+0
         LD    0,S00000+1064
         STD   0,P00318+8
         LA    1,P00318
         L     15,C00303
         BALR  14,15
         LD    2,T00064
         LD    0,T00064+8
         L     14,C00230
         STD   2,0(,14)
         L     14,C00304
         STD   0,0(,14)
         LA    1,P00319
         L     15,C00239
         BALR  14,15
         LR    6,3
         AH    6,C00240
         LA    2,4
         LA    5,4
L00165   DS    0H
         C     5,C00241
         BC    2,L00166
L00167   DS    0H
         L     15,C00242
         BALR  14,15
L00168   DS    0H
         L     14,C00320
         LD    0,0(,14)
         STD   0,S00000+1064
         MVC   T00073(8),C00301
         MVC   T00073+8(8),S00000+1064
         LD    0,C00301
         STD   0,P00321+0
         LD    0,S00000+1064
         STD   0,P00321+8
         LA    1,P00321
         L     15,C00303
         BALR  14,15
         LD    2,T00065
         LD    0,T00065+8
         L     14,C00230
         STD   2,0(,14)
         L     14,C00304
         STD   0,0(,14)
         LA    1,P00322
         L     15,C00239
         BALR  14,15
         LR    6,3
         AH    6,C00240
         LA    2,4
         LA    5,4
L00169   DS    0H
         C     5,C00241
         BC    2,L00170
L00171   DS    0H
         L     15,C00242
         BALR  14,15
L00172   DS    0H
         MVC   T00073(8),C00308
         MVC   T00073+8(8),C00308
         LD    0,C00308
         STD   0,P00323+0
         LD    0,C00308
         STD   0,P00323+8
         LA    1,P00323
         L     15,C00324
         BALR  14,15
         LD    2,T00066
         LD    0,T00066+8
         L     14,C00230
         STD   2,0(,14)
         L     14,C00304
         STD   0,0(,14)
         LA    1,P00325
         L     15,C00239
         BALR  14,15
         LR    6,3
         AH    6,C00240
         LA    2,4
         LA    5,4
L00173   DS    0H
         C     5,C00241
         BC    2,L00174
L00175   DS    0H
         L     15,C00242
         BALR  14,15
L00176   DS    0H
         L     14,C00317
         LD    0,0(,14)
         STD   0,S00000+1064
         MVC   T00073(8),S00000+1064
         MVC   T00073+8(8),C00301
         LD    0,S00000+1064
         STD   0,P00326+0
         LD    0,C00301
         STD   0,P00326+8
         LA    1,P00326
         L     15,C00327
         BALR  14,15
         LD    2,T00067
         LD    0,T00067+8
         L     14,C00230
         STD   2,0(,14)
         L     14,C00304
         STD   0,0(,14)
         LA    1,P00328
         L     15,C00239
         BALR  14,15
         LR    6,3
         AH    6,C00240
         LA    2,4
         LA    5,4
L00177   DS    0H
         C     5,C00241
         BC    2,L00178
L00179   DS    0H
         L     15,C00242
         BALR  14,15
L00180   DS    0H
         MVC   T00073(8),C00301
         MVC   T00073+8(8),C00300
         LD    0,C00301
         STD   0,P00329+0
         LD    0,C00300
         STD   0,P00329+8
         LA    1,P00329
         L     15,C00327
         BALR  14,15
         LD    2,T00068
         LD    0,T00068+8
         L     14,C00230
         STD   2,0(,14)
         L     14,C00304
         STD   0,0(,14)
         LA    1,P00330
         L     15,C00239
         BALR  14,15
         LR    6,3
         AH    6,C00240
         LA    2,4
         LA    5,4
L00181   DS    0H
         C     5,C00241
         BC    2,L00182
L00183   DS    0H
         L     15,C00242
         BALR  14,15
L00184   DS    0H
         LD    0,C00300
         LCDR  0,0
         STD   0,S00000+1064
         MVC   T00073(8),C00301
         MVC   T00073+8(8),S00000+1064
         LD    0,C00301
         STD   0,P00331+0
         LD    0,S00000+1064
         STD   0,P00331+8
         LA    1,P00331
         L     15,C00327
         BALR  14,15
         LD    2,T00069
         LD    0,T00069+8
         L     14,C00230
         STD   2,0(,14)
         L     14,C00304
         STD   0,0(,14)
         LA    1,P00332
         L     15,C00239
         BALR  14,15
         LR    6,3
         AH    6,C00240
         LA    2,4
         LA    5,4
L00185   DS    0H
         C     5,C00241
         BC    2,L00186
L00187   DS    0H
         L     15,C00242
         BALR  14,15
L00188   DS    0H
         L     14,C00311
         LD    0,0(,14)
         STD   0,S00000+1064
         MVC   T00073(8),C00301
         MVC   T00073+8(8),S00000+1064
         LD    0,C00301
         STD   0,P00333+0
         LD    0,S00000+1064
         STD   0,P00333+8
         LA    1,P00333
         L     15,C00327
         BALR  14,15
         LD    2,T00070
         LD    0,T00070+8
         L     14,C00230
         STD   2,0(,14)
         L     14,C00304
         STD   0,0(,14)
         LA    1,P00334
         L     15,C00239
         BALR  14,15
         LR    6,3
         AH    6,C00240
         LA    2,4
         LA    5,4
L00189   DS    0H
         C     5,C00241
         BC    2,L00190
L00191   DS    0H
         L     15,C00242
         BALR  14,15
L00192   DS    0H
         MVC   T00073(8),C00335
         MVC   T00073+8(8),C00300
         LD    0,C00335
         STD   0,P00336+0
         LD    0,C00300
         STD   0,P00336+8
         LA    1,P00336
         L     15,C00337
         BALR  14,15
         LD    2,T00071
         LD    0,T00071+8
         L     14,C00230
         STD   2,0(,14)
         L     14,C00304
         STD   0,0(,14)
         LA    1,P00338
         L     15,C00239
         BALR  14,15
         LR    6,3
         AH    6,C00240
         LA    2,4
         LA    5,4
L00193   DS    0H
         C     5,C00241
         BC    2,L00194
L00195   DS    0H
         L     15,C00242
         BALR  14,15
L00196   DS    0H
         MVC   T00073(8),C00308
         MVC   T00073+8(8),C00308
         LD    0,C00308
         STD   0,P00339+0
         LD    0,C00308
         STD   0,P00339+8
         LA    1,P00339
         L     15,C00340
         BALR  14,15
         LD    2,T00072
         LD    0,T00072+8
         L     14,C00230
         STD   2,0(,14)
         L     14,C00304
         STD   0,0(,14)
         LA    1,P00341
         L     15,C00239
         BALR  14,15
         AH    3,C00240
         LA    2,4
         LA    5,4
L00197   DS    0H
         C     5,C00241
         BC    2,L00198
L00199   DS    0H
         L     15,C00242
         BALR  14,15
L00200   DS    0H
         L     14,C00244
         LE    0,0(,14)
         STE   0,S00000+1064
         LE    0,S00000+1064
         STE   0,P00342+0
         LA    1,P00342
         L     15,C00343
         BALR  14,15
         L     14,C00291
         STE   0,0(,14)
         LA    1,P00344
         L     15,C00239
         BALR  14,15
         L     14,C00291
         L     3,0(,14)
         LR    0,3
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         L     15,C00242
         BALR  14,15
L00201   DS    0H
         L     14,C00248
         LE    0,0(,14)
         STE   0,S00000+1064
         LE    0,S00000+1064
         STE   0,P00342+0
         LA    1,P00342
         L     15,C00343
         BALR  14,15
         L     14,C00291
         STE   0,0(,14)
         LA    1,P00345
         L     15,C00239
         BALR  14,15
         L     14,C00291
         L     3,0(,14)
         LR    0,3
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         L     15,C00242
         BALR  14,15
L00202   DS    0H
         L     14,C00346
         LE    0,0(,14)
         STE   0,S00000+1064
         LE    0,S00000+1064
         STE   0,P00342+0
         LA    1,P00342
         L     15,C00347
         BALR  14,15
         L     14,C00291
         STE   0,0(,14)
         LA    1,P00348
         L     15,C00239
         BALR  14,15
         L     14,C00291
         L     3,0(,14)
         LR    0,3
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         L     15,C00242
         BALR  14,15
L00203   DS    0H
         L     14,C00349
         LE    0,0(,14)
         STE   0,S00000+1064
         LE    0,S00000+1064
         STE   0,P00342+0
         LA    1,P00342
         L     15,C00347
         BALR  14,15
         L     14,C00291
         STE   0,0(,14)
         LA    1,P00350
         L     15,C00239
         BALR  14,15
         L     14,C00291
         L     3,0(,14)
         LR    0,3
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         L     15,C00242
         BALR  14,15
L00204   DS    0H
         L     14,C00351
         LE    0,0(,14)
         STE   0,S00000+1064
         LE    0,S00000+1064
         STE   0,P00342+0
         LA    1,P00342
         L     15,C00352
         BALR  14,15
         L     14,C00291
         STE   0,0(,14)
         LA    1,P00353
         L     15,C00239
         BALR  14,15
         L     14,C00291
         L     3,0(,14)
         LR    0,3
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         L     15,C00242
         BALR  14,15
L00205   DS    0H
         L     14,C00307
         LD    0,0(,14)
         STD   0,S00000+1064
         LD    0,S00000+1064
         STD   0,P00286+0
         LA    1,P00286
         L     15,C00354
         BALR  14,15
         L     14,C00232
         STD   0,0(,14)
         LA    1,P00355
         L     15,C00239
         BALR  14,15
         LR    5,4
         AH    5,C00240
         LA    2,4
         LA    3,2
L00206   DS    0H
         C     3,C00241
         BC    2,L00207
L00208   DS    0H
         L     15,C00242
         BALR  14,15
L00209   DS    0H
         L     14,C00311
         LD    0,0(,14)
         STD   0,S00000+1064
         LD    0,S00000+1064
         STD   0,P00286+0
         LA    1,P00286
         L     15,C00354
         BALR  14,15
         L     14,C00232
         STD   0,0(,14)
         LA    1,P00356
         L     15,C00239
         BALR  14,15
         LR    5,4
         AH    5,C00240
         LA    2,4
         LA    3,2
L00210   DS    0H
         C     3,C00241
         BC    2,L00211
L00212   DS    0H
         L     15,C00242
         BALR  14,15
L00213   DS    0H
         L     14,C00357
         LD    0,0(,14)
         STD   0,S00000+1064
         LD    0,S00000+1064
         STD   0,P00286+0
         LA    1,P00286
         L     15,C00358
         BALR  14,15
         L     14,C00232
         STD   0,0(,14)
         LA    1,P00359
         L     15,C00239
         BALR  14,15
         LR    5,4
         AH    5,C00240
         LA    2,4
         LA    3,2
L00214   DS    0H
         C     3,C00241
         BC    2,L00215
L00216   DS    0H
         L     15,C00242
         BALR  14,15
L00217   DS    0H
         L     14,C00317
         LD    0,0(,14)
         STD   0,S00000+1064
         LD    0,S00000+1064
         STD   0,P00286+0
         LA    1,P00286
         L     15,C00360
         BALR  14,15
         L     14,C00232
         STD   0,0(,14)
         LA    1,P00361
         L     15,C00239
         BALR  14,15
         AH    4,C00240
         LA    2,4
         LA    3,2
L00218   DS    0H
         C     3,C00241
         BC    2,L00219
L00220   DS    0H
         L     15,C00242
         BALR  14,15
L00221   DS    0H
         B     L00222
L00077   DS    0H
         L     9,0(5,7)
         LR    0,9
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    6,C00362
         A     5,C00363
         B     L00076
L00081   DS    0H
         L     9,0(5,7)
         LR    0,9
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    6,C00362
         A     5,C00363
         B     L00080
L00085   DS    0H
         L     9,0(5,7)
         LR    0,9
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    6,C00362
         A     5,C00363
         B     L00084
L00089   DS    0H
         L     9,0(5,7)
         LR    0,9
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    6,C00362
         A     5,C00363
         B     L00088
L00093   DS    0H
         L     9,0(5,7)
         LR    0,9
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    6,C00362
         A     5,C00363
         B     L00092
L00097   DS    0H
         L     9,0(5,7)
         LR    0,9
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    6,C00362
         A     5,C00363
         B     L00096
L00101   DS    0H
         L     9,0(5,7)
         LR    0,9
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    6,C00362
         A     5,C00363
         B     L00100
L00105   DS    0H
         L     9,0(5,7)
         LR    0,9
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    6,C00362
         A     5,C00363
         B     L00104
L00109   DS    0H
         L     9,0(5,7)
         LR    0,9
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    6,C00362
         A     5,C00363
         B     L00108
L00113   DS    0H
         L     9,0(5,7)
         LR    0,9
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    6,C00362
         A     5,C00363
         B     L00112
L00117   DS    0H
         L     9,0(5,7)
         LR    0,9
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    6,C00362
         A     5,C00363
         B     L00116
L00121   DS    0H
         L     9,0(5,7)
         LR    0,9
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    6,C00362
         A     5,C00363
         B     L00120
L00125   DS    0H
         L     9,0(5,7)
         LR    0,9
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    6,C00362
         A     5,C00363
         B     L00124
L00129   DS    0H
         L     9,0(5,7)
         LR    0,9
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    6,C00362
         A     5,C00363
         B     L00128
L00133   DS    0H
         L     9,0(5,7)
         LR    0,9
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    6,C00362
         A     5,C00363
         B     L00132
L00137   DS    0H
         L     9,0(5,7)
         LR    0,9
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    6,C00362
         A     5,C00363
         B     L00136
L00142   DS    0H
         L     9,0(5,7)
         LR    0,9
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    6,C00362
         A     5,C00363
         B     L00141
L00146   DS    0H
         L     8,0(5,2)
         LR    0,8
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    6,C00362
         A     5,C00363
         B     L00145
L00150   DS    0H
         L     8,0(2,6)
         LR    0,8
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    5,C00362
         A     2,C00363
         B     L00149
L00154   DS    0H
         L     8,0(2,6)
         LR    0,8
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    5,C00362
         A     2,C00363
         B     L00153
L00158   DS    0H
         L     8,0(2,6)
         LR    0,8
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    5,C00362
         A     2,C00363
         B     L00157
L00162   DS    0H
         L     8,0(2,6)
         LR    0,8
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    5,C00362
         A     2,C00363
         B     L00161
L00166   DS    0H
         L     8,0(2,6)
         LR    0,8
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    5,C00362
         A     2,C00363
         B     L00165
L00170   DS    0H
         L     8,0(2,6)
         LR    0,8
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    5,C00362
         A     2,C00363
         B     L00169
L00174   DS    0H
         L     8,0(2,6)
         LR    0,8
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    5,C00362
         A     2,C00363
         B     L00173
L00178   DS    0H
         L     8,0(2,6)
         LR    0,8
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    5,C00362
         A     2,C00363
         B     L00177
L00182   DS    0H
         L     8,0(2,6)
         LR    0,8
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    5,C00362
         A     2,C00363
         B     L00181
L00186   DS    0H
         L     8,0(2,6)
         LR    0,8
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    5,C00362
         A     2,C00363
         B     L00185
L00190   DS    0H
         L     8,0(2,6)
         LR    0,8
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    5,C00362
         A     2,C00363
         B     L00189
L00194   DS    0H
         L     8,0(2,6)
         LR    0,8
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    5,C00362
         A     2,C00363
         B     L00193
L00198   DS    0H
         L     7,0(2,3)
         LR    0,7
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    5,C00362
         A     2,C00363
         B     L00197
L00207   DS    0H
         L     7,0(2,5)
         LR    0,7
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    3,C00362
         A     2,C00363
         B     L00206
L00211   DS    0H
         L     7,0(2,5)
         LR    0,7
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    3,C00362
         A     2,C00363
         B     L00210
L00215   DS    0H
         L     7,0(2,5)
         LR    0,7
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    3,C00362
         A     2,C00363
         B     L00214
L00219   DS    0H
         L     6,0(2,4)
         LR    0,6
         ST    0,P00293+0
         LA    1,P00293
         L     15,C00294
         BALR  14,15
         AH    3,C00362
         A     2,C00363
         B     L00218
L00222   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
         DROP  11
S00000   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00042   DS    XL12
         DS    XL4
T00043   DS    XL16
T00044   DS    XL16
T00045   DS    XL16
T00046   DS    XL16
T00047   DS    XL16
T00048   DS    XL16
T00049   DS    XL16
T00050   DS    XL16
T00051   DS    XL16
T00052   DS    XL16
T00053   DS    XL16
T00054   DS    XL16
T00055   DS    XL16
T00056   DS    XL16
T00057   DS    XL16
T00058   DS    XL16
T00059   DS    XL16
T00060   DS    XL24
T00061   DS    XL24
T00062   DS    XL24
T00063   DS    XL24
T00064   DS    XL24
T00065   DS    XL24
T00066   DS    XL24
T00067   DS    XL24
T00068   DS    XL24
T00069   DS    XL24
T00070   DS    XL24
T00071   DS    XL24
T00072   DS    XL24
T00073   DS    XL32
T00074   DS    XL252
         DS    XL4
         DS    2D
P00235   DC    A(T00074)
         DC    A(0)
         DC    A(0)
P00238   DC    F'6'
         DC    A(Q00001)
         DS    F
P00246   DC    A(T00043)
         DC    A(0)
         DC    A(0)
P00247   DC    F'6'
         DC    A(Q00002)
         DS    F
P00249   DC    A(T00044)
         DC    A(0)
         DC    A(0)
P00250   DC    F'6'
         DC    A(Q00003)
         DS    F
P00252   DC    A(T00045)
         DC    A(0)
         DC    A(0)
P00253   DC    F'6'
         DC    A(Q00004)
         DS    F
P00255   DC    A(T00046)
         DC    A(0)
         DC    A(0)
P00256   DC    F'6'
         DC    A(Q00005)
         DS    F
P00258   DC    A(T00047)
         DC    A(0)
         DC    A(0)
P00259   DC    F'6'
         DC    A(Q00006)
         DS    F
P00260   DC    A(T00048)
         DC    A(0)
         DC    A(0)
P00262   DC    F'6'
         DC    A(Q00007)
         DS    F
P00263   DC    A(T00049)
         DC    A(0)
         DC    A(0)
P00265   DC    F'6'
         DC    A(Q00008)
         DS    F
P00266   DC    A(T00050)
         DC    A(0)
         DC    A(0)
P00267   DC    F'6'
         DC    A(Q00009)
         DS    F
P00268   DC    A(T00051)
         DC    A(0)
         DC    A(0)
P00269   DC    F'6'
         DC    A(Q00010)
         DS    F
P00271   DC    A(T00052)
         DC    A(0)
         DC    A(0)
P00272   DC    F'6'
         DC    A(Q00011)
         DS    F
P00273   DC    A(T00053)
         DC    A(0)
         DC    A(0)
P00274   DC    F'6'
         DC    A(Q00012)
         DS    F
P00275   DC    A(T00054)
         DC    A(0)
         DC    A(0)
P00276   DC    F'6'
         DC    A(Q00013)
         DS    F
P00277   DC    A(T00055)
         DC    A(0)
         DC    A(0)
P00279   DC    F'6'
         DC    A(Q00014)
         DS    F
P00280   DC    A(T00056)
         DC    A(0)
         DC    A(0)
P00281   DC    F'6'
         DC    A(Q00015)
         DS    F
P00283   DC    A(T00057)
         DC    A(0)
         DC    A(0)
P00285   DC    F'6'
         DC    A(Q00016)
         DS    F
P00286   DC    A(0)
         DC    A(0)
P00292   DC    F'6'
         DC    A(Q00017)
P00293   DC    A(0)
         DS    F
P00295   DC    A(T00058)
         DC    A(0)
         DC    A(0)
         DC    F'-1'
P00297   DC    F'6'
         DC    A(Q00018)
P00298   DC    A(T00059)
         DC    A(0)
         DC    A(0)
         DC    F'0'
P00299   DC    F'6'
         DC    A(Q00019)
P00302   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00060)
P00305   DC    F'6'
         DC    A(Q00020)
         DS    F
P00309   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00061)
P00310   DC    F'6'
         DC    A(Q00021)
         DS    F
P00312   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00062)
P00313   DC    F'6'
         DC    A(Q00022)
         DS    F
P00315   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00063)
P00316   DC    F'6'
         DC    A(Q00023)
         DS    F
P00318   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00064)
P00319   DC    F'6'
         DC    A(Q00024)
         DS    F
P00321   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00065)
P00322   DC    F'6'
         DC    A(Q00025)
         DS    F
P00323   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00066)
P00325   DC    F'6'
         DC    A(Q00026)
         DS    F
P00326   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00067)
P00328   DC    F'6'
         DC    A(Q00027)
         DS    F
P00329   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00068)
P00330   DC    F'6'
         DC    A(Q00028)
         DS    F
P00331   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00069)
P00332   DC    F'6'
         DC    A(Q00029)
         DS    F
P00333   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00070)
P00334   DC    F'6'
         DC    A(Q00030)
         DS    F
P00336   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00071)
P00338   DC    F'6'
         DC    A(Q00031)
         DS    F
P00339   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    F'-2'
         DC    A(T00072)
P00341   DC    F'6'
         DC    A(Q00032)
P00342   DC    A(0)
         DC    F'0'
P00344   DC    F'6'
         DC    A(Q00033)
P00345   DC    F'6'
         DC    A(Q00034)
P00348   DC    F'6'
         DC    A(Q00035)
P00350   DC    F'6'
         DC    A(Q00036)
P00353   DC    F'6'
         DC    A(Q00037)
P00355   DC    F'6'
         DC    A(Q00038)
P00356   DC    F'6'
         DC    A(Q00039)
P00359   DC    F'6'
         DC    A(Q00040)
P00361   DC    F'6'
         DC    A(Q00041)
C00300   DC    X'42C8000000000000'
C00301   DC    X'4110000000000000'
C00308   DC    X'0000000000000000'
C00335   DC    X'4120000000000000'
C00228   DC    A(G00227)
C00230   DC    A(G00229)
C00232   DC    A(G00231)
C00233   DC    X'42C80000'
C00234   DC    X'41100000'
C00236   DC    V(F77CEXP)
C00237   DC    A(G00227+4)
C00239   DC    V(F77WRBEG)
C00241   DC    F'0'
C00242   DC    V(F77WREND)
C00244   DC    A(G00243)
C00245   DC    X'00000000'
C00248   DC    A(G00243+4)
C00251   DC    X'45C8FF00'
C00254   DC    A(G00243+16)
C00257   DC    X'45F42400'
C00261   DC    V(F77CLOG)
C00264   DC    V(F77CSIN)
C00270   DC    X'41200000'
C00278   DC    V(F77CCOS)
C00282   DC    X'7F235FAE'
C00284   DC    V(F77CSQRT)
C00287   DC    X'7F6A1F0A'
C00288   DC    X'7F8D7EB7'
C00289   DC    V(F77CABS)
C00291   DC    A(G00290)
C00294   DC    V(F77WRI)
C00296   DC    V(F77CPOWI)
C00303   DC    V(F77ZEXP)
C00304   DC    A(G00229+8)
C00307   DC    A(G00306)
C00311   DC    A(G00306+8)
C00314   DC    A(G00306+16)
C00317   DC    A(G00306+32)
C00320   DC    A(G00306+40)
C00324   DC    V(F77ZLOG)
C00327   DC    V(F77ZSIN)
C00337   DC    V(F77ZCOS)
C00340   DC    V(F77ZPOWI)
C00343   DC    V(EXP)
C00346   DC    A(G00243+8)
C00347   DC    V(SINH)
C00349   DC    A(G00243+12)
C00351   DC    A(G00243+20)
C00352   DC    V(SIN)
C00354   DC    V(DEXP)
C00357   DC    A(G00306+24)
C00358   DC    V(DSINH)
C00360   DC    V(DSIN)
C00363   DC    F'4'
C00240   DC    H'-4'
C00362   DC    H'-1'
Q00001   DC    C'('' >CE1 '',Z8,1X,Z8)'
Q00002   DC    C'('' >CE2 '',Z8,1X,Z8)'
Q00003   DC    C'('' >CE3 '',Z8,1X,Z8)'
Q00004   DC    C'('' >CE4 '',Z8,1X,Z8)'
Q00005   DC    C'('' >CE5 '',Z8,1X,Z8)'
Q00006   DC    C'('' >CE6 '',Z8,1X,Z8)'
Q00007   DC    C'('' >CL1 '',Z8,1X,Z8)'
Q00008   DC    C'('' >CS1 '',Z8,1X,Z8)'
Q00009   DC    C'('' >CS2 '',Z8,1X,Z8)'
Q00010   DC    C'('' >CS3 '',Z8,1X,Z8)'
Q00011   DC    C'('' >CS4 '',Z8,1X,Z8)'
Q00012   DC    C'('' >CS5 '',Z8,1X,Z8)'
Q00013   DC    C'('' >CS6 '',Z8,1X,Z8)'
Q00014   DC    C'('' >CC1 '',Z8,1X,Z8)'
Q00015   DC    C'('' >CC2 '',Z8,1X,Z8)'
Q00016   DC    C'('' >CQ1 '',Z8,1X,Z8)'
Q00017   DC    C'('' >CA1 '',Z8)'
Q00018   DC    C'('' >CP1 '',Z8,1X,Z8)'
Q00019   DC    C'('' >CP2 '',Z8,1X,Z8)'
Q00020   DC    C'('' >ZE1 '',2Z8,1X,2Z8)'
Q00021   DC    C'('' >ZE2 '',2Z8,1X,2Z8)'
Q00022   DC    C'('' >ZE3 '',2Z8,1X,2Z8)'
Q00023   DC    C'('' >ZE4 '',2Z8,1X,2Z8)'
Q00024   DC    C'('' >ZE5 '',2Z8,1X,2Z8)'
Q00025   DC    C'('' >ZE6 '',2Z8,1X,2Z8)'
Q00026   DC    C'('' >ZL1 '',2Z8,1X,2Z8)'
Q00027   DC    C'('' >ZS1 '',2Z8,1X,2Z8)'
Q00028   DC    C'('' >ZS2 '',2Z8,1X,2Z8)'
Q00029   DC    C'('' >ZS3 '',2Z8,1X,2Z8)'
Q00030   DC    C'('' >ZS4 '',2Z8,1X,2Z8)'
Q00031   DC    C'('' >ZC1 '',2Z8,1X,2Z8)'
Q00032   DC    C'('' >ZP1 '',2Z8,1X,2Z8)'
Q00033   DC    C'('' >R1 '',Z8)'
Q00034   DC    C'('' >R2 '',Z8)'
Q00035   DC    C'('' >R3 '',Z8)'
Q00036   DC    C'('' >R4 '',Z8)'
Q00037   DC    C'('' >R5 '',Z8)'
Q00038   DC    C'('' >D1 '',2Z8)'
Q00039   DC    C'('' >D2 '',2Z8)'
Q00040   DC    C'('' >D3 '',2Z8)'
Q00041   DC    C'('' >D4 '',2Z8)'
G00227   CSECT
         DS    0D
         DS    XL8
G00229   CSECT
         DS    0D
         DS    XL16
G00306   CSECT
         DS    0D
         DC    X'42AEAC4EFFFFFFFF42AEAC4F0000000042AEAC5000000000'
         DC    X'42AF5DC1000000004DC90FDA000000004DC90FD9FFFFFFFF'
G00231   CSECT
         DS    0D
         DS    XL8
G00243   CSECT
         DS    0D
         DC    X'42AEAC4F42AEAC5042AF5DC042AF5DC145C9000045C90FDA'
G00290   CSECT
         DS    0D
         DS    XL4
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
