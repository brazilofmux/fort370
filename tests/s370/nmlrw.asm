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
         LA    0,T00072
         ST    0,P00120+0
         LA    0,6
         ST    0,P00120+4
         L     0,C00121
         ST    0,P00120+8
         LA    0,5
         ST    0,P00120+12
         LA    1,P00120
         L     15,C00122
         BALR  14,15
L00078   DS    0H
         LA    4,100
         LA    5,400
         LA    2,100
         LA    3,4
L00079   DS    0H
L00081   DS    0H
         ST    2,T00074-4(3)
         A     3,C00123
         BXLE  2,4,L00079
L00080   DS    0H
         MVC   T00073(4),C00124
         MVC   T00073+4(4),C00125
         MVC   T00073+8(4),C00126
         LA    0,31
         ST    0,P00120+0
         L     0,C00127
         ST    0,P00120+4
         LA    0,3
         ST    0,P00120+8
         LA    0,0
         ST    0,P00120+12
         LA    0,0
         ST    0,P00120+16
         LA    1,P00120
         L     15,C00128
         BALR  14,15
         L     0,C00129
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,1
         ST    0,P00120+8
         LA    0,T00068
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00131
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,2
         ST    0,P00120+8
         LA    0,T00075
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00132
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,3
         ST    0,P00120+8
         LA    0,T00070
         ST    0,P00120+12
         LA    0,8
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00133
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,4
         ST    0,P00120+8
         LA    0,T00071
         ST    0,P00120+12
         LA    0,8
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00134
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,6
         ST    0,P00120+8
         LA    0,T00069
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00135
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,7
         ST    0,P00120+8
         LA    0,T00072
         ST    0,P00120+12
         LA    0,6
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         LA    0,1
         ST    0,P00120+0
         LA    0,4
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00136
         BALR  14,15
         L     0,C00137
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,1
         ST    0,P00120+8
         LA    0,T00074
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,4
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         LA    0,1
         ST    0,P00120+0
         LA    0,3
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00136
         BALR  14,15
         L     0,C00138
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,2
         ST    0,P00120+8
         LA    0,T00073
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,3
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     15,C00139
         BALR  14,15
         LA    0,31
         ST    0,P00120+0
         LA    1,P00120
         L     15,C00140
         BALR  14,15
L00082   DS    0H
         LA    0,31
         ST    0,P00120+0
         L     0,C00141
         ST    0,P00120+4
         LA    0,1
         ST    0,P00120+8
         LA    1,P00120
         L     15,C00142
         BALR  14,15
         LR    2,15
         C     2,C00143
         BC    8,L00084
L00083   DS    0H
         LA    0,T00076
         ST    0,P00120+0
         LA    0,80
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00144
         BALR  14,15
         L     15,C00145
         BALR  14,15
         LA    0,6
         ST    0,P00120+0
         L     0,C00146
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00147
         BALR  14,15
         LA    0,T00076
         ST    0,P00120+0
         LA    0,80
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00148
         BALR  14,15
         L     15,C00149
         BALR  14,15
         B     L00082
L00084   DS    0H
         LA    0,31
         ST    0,P00120+0
         LA    1,P00120
         L     15,C00140
         BALR  14,15
         LA    0,T00068
         ST    0,P00120+0
         LA    0,T00075
         ST    0,P00120+4
         LA    0,T00070
         ST    0,P00120+8
         LA    0,T00071
         ST    0,P00120+12
         LA    0,T00069
         ST    0,P00120+16
         LA    0,T00072
         ST    0,P00120+20
         LA    0,T00074
         ST    0,P00120+24
         LA    0,T00073
         ST    0,P00120+28
         LA    0,6
         ST    0,P00120+32
         OI    P00120+32,X'80'
         LA    1,P00120
         L     15,C00150
         BALR  14,15
         LA    0,31
         ST    0,P00120+0
         L     0,C00151
         ST    0,P00120+4
         LA    0,3
         ST    0,P00120+8
         LA    0,1
         ST    0,P00120+12
         LA    0,0
         ST    0,P00120+16
         LA    1,P00120
         L     15,C00128
         BALR  14,15
         L     0,C00152
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,1
         ST    0,P00120+8
         LA    0,T00068
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00153
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,2
         ST    0,P00120+8
         LA    0,T00075
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00154
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,3
         ST    0,P00120+8
         LA    0,T00070
         ST    0,P00120+12
         LA    0,8
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00155
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,4
         ST    0,P00120+8
         LA    0,T00071
         ST    0,P00120+12
         LA    0,8
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00156
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,6
         ST    0,P00120+8
         LA    0,T00069
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00157
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,7
         ST    0,P00120+8
         LA    0,T00072
         ST    0,P00120+12
         LA    0,6
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         LA    0,1
         ST    0,P00120+0
         LA    0,4
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00136
         BALR  14,15
         L     0,C00158
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,1
         ST    0,P00120+8
         LA    0,T00074
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,4
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         LA    0,1
         ST    0,P00120+0
         LA    0,3
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00136
         BALR  14,15
         L     0,C00159
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,2
         ST    0,P00120+8
         LA    0,T00073
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,3
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     15,C00139
         BALR  14,15
         LA    0,6
         ST    0,P00120+0
         L     0,C00160
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00147
         BALR  14,15
         L     3,T00068
         LR    0,3
         ST    0,P00120+0
         LA    1,P00120
         L     15,C00161
         BALR  14,15
         LE    0,T00075
         STE   0,S00000+392
         LE    0,S00000+392
         STE   0,P00120+0
         LA    1,P00120
         L     15,C00162
         BALR  14,15
         LD    0,T00070
         STD   0,S00000+392
         LD    0,S00000+392
         STD   0,P00120+0
         LA    1,P00120
         L     15,C00163
         BALR  14,15
         LE    0,T00071
         STE   0,S00000+392
         LE    0,T00071+4
         STE   0,S00000+400
         LE    0,S00000+392
         STE   0,P00120+0
         LE    0,S00000+400
         STE   0,P00120+4
         LA    1,P00120
         L     15,C00164
         BALR  14,15
         L     3,T00069
         LR    0,3
         ST    0,P00120+0
         LA    1,P00120
         L     15,C00165
         BALR  14,15
         LA    0,T00072
         ST    0,P00120+0
         LA    0,6
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00148
         BALR  14,15
         LA    2,4
         LA    3,4
L00085   DS    0H
         C     3,C00166
         L     15,C00167
         BC    2,0(,15)
L00087   DS    0H
         LA    2,4
         LA    3,3
L00088   DS    0H
         C     3,C00166
         L     15,C00168
         BC    2,0(,15)
L00090   DS    0H
         L     15,C00149
         BALR  14,15
         LA    0,9
         ST    0,P00120+0
         L     0,C00141
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00147
         BALR  14,15
         L     0,C00169
         ST    0,P00120+0
         LA    0,30
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00148
         BALR  14,15
         L     15,C00149
         BALR  14,15
         LA    0,9
         ST    0,P00120+0
         L     0,C00141
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00147
         BALR  14,15
         L     0,C00170
         ST    0,P00120+0
         LA    0,34
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00148
         BALR  14,15
         L     15,C00149
         BALR  14,15
         LA    0,9
         ST    0,P00120+0
         L     0,C00141
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00147
         BALR  14,15
         L     0,C00171
         ST    0,P00120+0
         LA    0,17
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00148
         BALR  14,15
         L     15,C00149
         BALR  14,15
         LA    0,9
         ST    0,P00120+0
         L     0,C00141
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00147
         BALR  14,15
         L     0,C00172
         ST    0,P00120+0
         LA    0,23
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00148
         BALR  14,15
         L     15,C00149
         BALR  14,15
         LA    0,9
         ST    0,P00120+0
         LA    1,P00120
         L     15,C00140
         BALR  14,15
         LA    0,9
         ST    0,P00120+0
         L     0,C00173
         ST    0,P00120+4
         LA    0,3
         ST    0,P00120+8
         LA    0,1
         ST    0,P00120+12
         LA    0,0
         ST    0,P00120+16
         LA    1,P00120
         L     15,C00128
         BALR  14,15
         L     0,C00174
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,1
         ST    0,P00120+8
         LA    0,T00068
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00175
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,2
         ST    0,P00120+8
         LA    0,T00075
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00176
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,3
         ST    0,P00120+8
         LA    0,T00070
         ST    0,P00120+12
         LA    0,8
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00177
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,4
         ST    0,P00120+8
         LA    0,T00071
         ST    0,P00120+12
         LA    0,8
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00178
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,6
         ST    0,P00120+8
         LA    0,T00069
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00179
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,7
         ST    0,P00120+8
         LA    0,T00072
         ST    0,P00120+12
         LA    0,6
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         LA    0,1
         ST    0,P00120+0
         LA    0,4
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00136
         BALR  14,15
         L     0,C00180
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,1
         ST    0,P00120+8
         LA    0,T00074
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,4
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         LA    0,1
         ST    0,P00120+0
         LA    0,3
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00136
         BALR  14,15
         L     0,C00181
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,2
         ST    0,P00120+8
         LA    0,T00073
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,3
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     15,C00139
         BALR  14,15
         LA    0,6
         ST    0,P00120+0
         L     0,C00160
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00147
         BALR  14,15
         L     3,T00068
         LR    0,3
         ST    0,P00120+0
         LA    1,P00120
         L     15,C00161
         BALR  14,15
         LE    0,T00075
         STE   0,S00000+392
         LE    0,S00000+392
         STE   0,P00120+0
         LA    1,P00120
         L     15,C00162
         BALR  14,15
         LD    0,T00070
         STD   0,S00000+392
         LD    0,S00000+392
         STD   0,P00120+0
         LA    1,P00120
         L     15,C00163
         BALR  14,15
         LE    0,T00071
         STE   0,S00000+392
         LE    0,T00071+4
         STE   0,S00000+400
         LE    0,S00000+392
         STE   0,P00120+0
         LE    0,S00000+400
         STE   0,P00120+4
         LA    1,P00120
         L     15,C00164
         BALR  14,15
         L     3,T00069
         LR    0,3
         ST    0,P00120+0
         LA    1,P00120
         L     15,C00165
         BALR  14,15
         LA    0,T00072
         ST    0,P00120+0
         LA    0,6
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00148
         BALR  14,15
         LA    2,4
         LA    3,4
L00091   DS    0H
         C     3,C00166
         L     15,C00182
         BC    2,0(,15)
L00093   DS    0H
         LA    2,4
         LA    3,3
L00094   DS    0H
         C     3,C00166
         L     15,C00183
         BC    2,0(,15)
L00096   DS    0H
         L     15,C00149
         BALR  14,15
         LA    0,9
         ST    0,P00120+0
         L     0,C00184
         ST    0,P00120+4
         LA    0,3
         ST    0,P00120+8
         LA    0,1
         ST    0,P00120+12
         LA    0,0
         ST    0,P00120+16
         LA    1,P00120
         L     15,C00128
         BALR  14,15
         L     0,C00185
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,1
         ST    0,P00120+8
         LA    0,T00068
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00186
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,2
         ST    0,P00120+8
         LA    0,T00075
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00187
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,3
         ST    0,P00120+8
         LA    0,T00070
         ST    0,P00120+12
         LA    0,8
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00188
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,4
         ST    0,P00120+8
         LA    0,T00071
         ST    0,P00120+12
         LA    0,8
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00189
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,6
         ST    0,P00120+8
         LA    0,T00069
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00190
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,7
         ST    0,P00120+8
         LA    0,T00072
         ST    0,P00120+12
         LA    0,6
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         LA    0,1
         ST    0,P00120+0
         LA    0,4
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00136
         BALR  14,15
         L     0,C00191
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,1
         ST    0,P00120+8
         LA    0,T00074
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,4
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         LA    0,1
         ST    0,P00120+0
         LA    0,3
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00136
         BALR  14,15
         L     0,C00192
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,2
         ST    0,P00120+8
         LA    0,T00073
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,3
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     15,C00139
         BALR  14,15
         LA    0,6
         ST    0,P00120+0
         L     0,C00160
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00147
         BALR  14,15
         L     3,T00068
         LR    0,3
         ST    0,P00120+0
         LA    1,P00120
         L     15,C00161
         BALR  14,15
         LE    0,T00075
         STE   0,S00000+392
         LE    0,S00000+392
         STE   0,P00120+0
         LA    1,P00120
         L     15,C00162
         BALR  14,15
         LD    0,T00070
         STD   0,S00000+392
         LD    0,S00000+392
         STD   0,P00120+0
         LA    1,P00120
         L     15,C00163
         BALR  14,15
         LE    0,T00071
         STE   0,S00000+392
         LE    0,T00071+4
         STE   0,S00000+400
         LE    0,S00000+392
         STE   0,P00120+0
         LE    0,S00000+400
         STE   0,P00120+4
         LA    1,P00120
         L     15,C00164
         BALR  14,15
         L     3,T00069
         LR    0,3
         ST    0,P00120+0
         LA    1,P00120
         L     15,C00165
         BALR  14,15
         LA    0,T00072
         ST    0,P00120+0
         LA    0,6
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00148
         BALR  14,15
         LA    2,4
         LA    3,4
L00097   DS    0H
         C     3,C00166
         L     15,C00193
         BC    2,0(,15)
L00099   DS    0H
         LA    2,4
         LA    3,3
L00100   DS    0H
         C     3,C00166
         L     15,C00194
         BC    2,0(,15)
L00102   DS    0H
         L     15,C00149
         BALR  14,15
         LA    0,9
         ST    0,P00120+0
         L     0,C00195
         ST    0,P00120+4
         LA    0,3
         ST    0,P00120+8
         LA    0,1
         ST    0,P00120+12
         LA    0,1
         ST    0,P00120+16
         LA    1,P00120
         L     15,C00128
         BALR  14,15
         L     0,C00196
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,1
         ST    0,P00120+8
         LA    0,T00068
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00197
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,2
         ST    0,P00120+8
         LA    0,T00075
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00198
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,3
         ST    0,P00120+8
         LA    0,T00070
         ST    0,P00120+12
         LA    0,8
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00199
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,4
         ST    0,P00120+8
         LA    0,T00071
         ST    0,P00120+12
         LA    0,8
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00200
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,6
         ST    0,P00120+8
         LA    0,T00069
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00201
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,7
         ST    0,P00120+8
         LA    0,T00072
         ST    0,P00120+12
         LA    0,6
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         LA    0,1
         ST    0,P00120+0
         LA    0,4
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00136
         BALR  14,15
         L     0,C00202
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,1
         ST    0,P00120+8
         LA    0,T00074
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,4
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         LA    0,1
         ST    0,P00120+0
         LA    0,3
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00136
         BALR  14,15
         L     0,C00203
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,2
         ST    0,P00120+8
         LA    0,T00073
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,3
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     15,C00139
         BALR  14,15
         LR    2,15
         C     2,C00143
         L     15,C00204
         BC    8,0(,15)
L00103   DS    0H
         LA    0,6
         ST    0,P00120+0
         L     0,C00205
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00147
         BALR  14,15
         L     0,C00206
         ST    0,P00120+0
         LA    0,6
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00148
         BALR  14,15
         L     15,C00149
         BALR  14,15
L00105   DS    0H
         LA    0,10
         ST    0,P00120+0
         L     0,C00141
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00147
         BALR  14,15
         L     0,C00207
         ST    0,P00120+0
         LA    0,21
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00148
         BALR  14,15
         L     15,C00149
         BALR  14,15
         LA    0,10
         ST    0,P00120+0
         LA    1,P00120
         L     15,C00140
         BALR  14,15
         LA    0,10
         ST    0,P00120+0
         L     0,C00208
         ST    0,P00120+4
         LA    0,3
         ST    0,P00120+8
         LA    0,1
         ST    0,P00120+12
         LA    0,2
         ST    0,P00120+16
         LA    1,P00120
         L     15,C00128
         BALR  14,15
         L     0,C00209
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,1
         ST    0,P00120+8
         LA    0,T00068
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00210
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,2
         ST    0,P00120+8
         LA    0,T00075
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00211
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,3
         ST    0,P00120+8
         LA    0,T00070
         ST    0,P00120+12
         LA    0,8
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00212
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,4
         ST    0,P00120+8
         LA    0,T00071
         ST    0,P00120+12
         LA    0,8
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00213
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,6
         ST    0,P00120+8
         LA    0,T00069
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     0,C00214
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,7
         ST    0,P00120+8
         LA    0,T00072
         ST    0,P00120+12
         LA    0,6
         ST    0,P00120+16
         LA    0,1
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         LA    0,1
         ST    0,P00120+0
         LA    0,4
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00136
         BALR  14,15
         L     0,C00215
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,1
         ST    0,P00120+8
         LA    0,T00074
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,4
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         LA    0,1
         ST    0,P00120+0
         LA    0,3
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00136
         BALR  14,15
         L     0,C00216
         ST    0,P00120+0
         LA    0,1
         ST    0,P00120+4
         LA    0,2
         ST    0,P00120+8
         LA    0,T00073
         ST    0,P00120+12
         LA    0,4
         ST    0,P00120+16
         LA    0,3
         ST    0,P00120+20
         LA    1,P00120
         L     15,C00130
         BALR  14,15
         L     15,C00139
         BALR  14,15
         LR    3,15
         C     3,C00143
         LA    2,1
         L     15,C00218
         BC    8,0(,15)
         SR    2,2
L00217   DS    0H
         LCR   4,2
         LR    2,3
         X     2,C00219
         NR    2,4
         XR    2,3
         C     3,C00220
         LA    5,1
         L     15,C00222
         BC    8,0(,15)
         SR    5,5
L00221   DS    0H
         LCR   4,5
         LA    3,1
         XR    3,2
         NR    3,4
         XR    2,3
         LA    0,6
         ST    0,P00120+0
         L     0,C00223
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00147
         BALR  14,15
         LR    0,2
         ST    0,P00120+0
         LA    1,P00120
         L     15,C00161
         BALR  14,15
         L     3,T00068
         LR    0,3
         ST    0,P00120+0
         LA    1,P00120
         L     15,C00161
         BALR  14,15
         L     15,C00149
         BALR  14,15
L00106   DS    0H
L00107   DS    0H
L00108   DS    0H
L00109   DS    0H
L00110   DS    0H
         L     15,C00224
         B     0(,15)
L00086   DS    0H
         L     5,T00074-4(2)
         LR    0,5
         ST    0,P00120+0
         LA    1,P00120
         L     15,C00161
         BALR  14,15
         AH    3,C00225
         A     2,C00123
         B     L00085
L00089   DS    0H
         LE    0,T00073-4(2)
         STE   0,S00000+392
         LE    0,S00000+392
         STE   0,P00120+0
         LA    1,P00120
         L     15,C00162
         BALR  14,15
         AH    3,C00225
         A     2,C00123
         B     L00088
L00092   DS    0H
         L     5,T00074-4(2)
         LR    0,5
         ST    0,P00120+0
         LA    1,P00120
         L     15,C00161
         BALR  14,15
         AH    3,C00225
         A     2,C00123
         B     L00091
L00095   DS    0H
         LE    0,T00073-4(2)
         STE   0,S00000+392
         LE    0,S00000+392
         STE   0,P00120+0
         LA    1,P00120
         L     15,C00162
         BALR  14,15
         AH    3,C00225
         A     2,C00123
         B     L00094
L00098   DS    0H
         L     5,T00074-4(2)
         LR    0,5
         ST    0,P00120+0
         LA    1,P00120
         L     15,C00161
         BALR  14,15
         AH    3,C00225
         A     2,C00123
         B     L00097
L00101   DS    0H
         LE    0,T00073-4(2)
         STE   0,S00000+392
         LE    0,S00000+392
         STE   0,P00120+0
         LA    1,P00120
         L     15,C00162
         BALR  14,15
         AH    3,C00225
         A     2,C00123
         B     L00100
L00104   DS    0H
         LA    0,6
         ST    0,P00120+0
         L     0,C00205
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00147
         BALR  14,15
         L     0,C00226
         ST    0,P00120+0
         LA    0,3
         ST    0,P00120+4
         LA    1,P00120
         L     15,C00148
         BALR  14,15
         L     15,C00149
         BALR  14,15
         L     15,C00227
         B     0(,15)
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
P00120   DS    9F
         DS    XL4
C00117   DC    X'4419640000000000'
C00116   DC    X'40400000'
C00118   DC    X'40C00000'
C00119   DC    X'41200000'
C00121   DC    A(Q00001)
C00122   DC    V(F77STRCP)
C00123   DC    F'4'
C00124   DC    X'3E418937'
C00125   DC    X'472625A0'
C00126   DC    X'00000000'
C00127   DC    A(Q00002)
C00128   DC    V(F77NMLBG)
C00129   DC    A(Q00003)
C00130   DC    V(F77NMLIT)
C00131   DC    A(Q00004)
C00132   DC    A(Q00005)
C00133   DC    A(Q00006)
C00134   DC    A(Q00007)
C00135   DC    A(Q00008)
C00136   DC    V(F77NMLDM)
C00137   DC    A(Q00009)
C00138   DC    A(Q00010)
C00139   DC    V(F77NMLEN)
C00140   DC    V(F77REWND)
C00141   DC    A(Q00021)
C00142   DC    V(F77RDBEG)
C00143   DC    F'1'
C00144   DC    V(F77RDS)
C00145   DC    V(F77RDEND)
C00146   DC    A(Q00067)
C00147   DC    V(F77WRBEG)
C00148   DC    V(F77WRA)
C00149   DC    V(F77WREND)
C00150   DC    V(CLEAR)
C00151   DC    A(Q00011)
C00152   DC    A(Q00012)
C00153   DC    A(Q00013)
C00154   DC    A(Q00014)
C00155   DC    A(Q00015)
C00156   DC    A(Q00016)
C00157   DC    A(Q00017)
C00158   DC    A(Q00018)
C00159   DC    A(Q00019)
C00160   DC    A(Q00020)
C00161   DC    V(F77WRI)
C00162   DC    V(F77WRR)
C00163   DC    V(F77WRD)
C00164   DC    V(F77WRC)
C00165   DC    V(F77WRL)
C00166   DC    F'0'
C00167   DC    A(L00086)
C00168   DC    A(L00089)
C00169   DC    A(Q00022)
C00170   DC    A(Q00023)
C00171   DC    A(Q00024)
C00172   DC    A(Q00025)
C00173   DC    A(Q00026)
C00174   DC    A(Q00027)
C00175   DC    A(Q00028)
C00176   DC    A(Q00029)
C00177   DC    A(Q00030)
C00178   DC    A(Q00031)
C00179   DC    A(Q00032)
C00180   DC    A(Q00033)
C00181   DC    A(Q00034)
C00182   DC    A(L00092)
C00183   DC    A(L00095)
C00184   DC    A(Q00035)
C00185   DC    A(Q00036)
C00186   DC    A(Q00037)
C00187   DC    A(Q00038)
C00188   DC    A(Q00039)
C00189   DC    A(Q00040)
C00190   DC    A(Q00041)
C00191   DC    A(Q00042)
C00192   DC    A(Q00043)
C00193   DC    A(L00098)
C00194   DC    A(L00101)
C00195   DC    A(Q00044)
C00196   DC    A(Q00045)
C00197   DC    A(Q00046)
C00198   DC    A(Q00047)
C00199   DC    A(Q00048)
C00200   DC    A(Q00049)
C00201   DC    A(Q00050)
C00202   DC    A(Q00051)
C00203   DC    A(Q00052)
C00204   DC    A(L00104)
C00205   DC    A(Q00053)
C00206   DC    A(Q00054)
C00207   DC    A(Q00056)
C00208   DC    A(Q00057)
C00209   DC    A(Q00058)
C00210   DC    A(Q00059)
C00211   DC    A(Q00060)
C00212   DC    A(Q00061)
C00213   DC    A(Q00062)
C00214   DC    A(Q00063)
C00215   DC    A(Q00064)
C00216   DC    A(Q00065)
C00218   DC    A(L00217)
C00219   DC    F'-1'
C00220   DC    F'2'
C00222   DC    A(L00221)
C00223   DC    A(Q00066)
C00224   DC    A(L00111)
C00226   DC    A(Q00055)
C00227   DC    A(L00105)
C00115   DC    H'-31'
C00225   DC    H'-1'
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
         B     L00240
         DC    AL1(5),CL7'CLEAR'
L00240   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00241
L00242   DC    A(S00228)
L00241   L     15,L00242
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00228,13
         ST    1,S00228+72
L00230   DS    0H
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
         MVC   0(4,9),C00243
         MVC   0(8,8),C00244
         MVC   0(4,7),C00243
         MVC   4(4,7),C00243
         LA    15,0
         ST    15,0(,4)
         LR    0,6
         ST    0,P00245+0
         LR    0,5
         ST    0,P00245+4
         L     0,C00246
         ST    0,P00245+8
         LA    0,1
         ST    0,P00245+12
         LA    1,P00245
         L     15,C00247
         BALR  14,15
L00231   DS    0H
         AH    3,C00248
         LA    6,4
         LA    7,16
         LA    4,4
L00232   DS    0H
L00234   DS    0H
         LA    15,0
         ST    15,0(4,3)
         BXLE  4,6,L00232
L00233   DS    0H
L00235   DS    0H
         AH    2,C00248
         LE    0,C00243
         LA    4,4
         LA    5,12
         LA    3,4
L00236   DS    0H
L00238   DS    0H
         STE   0,0(3,2)
         BXLE  3,4,L00236
L00237   DS    0H
         LA    0,0
L00239   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00228   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00245   DS    4F
C00244   DC    X'0000000000000000'
C00243   DC    X'00000000'
C00246   DC    A(Q00229)
C00247   DC    V(F77STRCP)
C00248   DC    H'-4'
Q00229   DC    C' '
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
