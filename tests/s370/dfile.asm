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
         LA    0,21
         ST    0,P00157+0
         LA    0,10
         ST    0,P00157+4
         LA    0,20
         ST    0,P00157+8
         LA    0,0
         ST    0,P00157+12
         LA    0,T00036
         ST    0,P00157+16
         LA    1,P00157
         L     15,C00158
         BALR  14,15
         LA    0,22
         ST    0,P00157+0
         LA    0,5
         ST    0,P00157+4
         LA    0,2
         ST    0,P00157+8
         LA    0,1
         ST    0,P00157+12
         LA    0,T00030
         ST    0,P00157+16
         LA    1,P00157
         L     15,C00158
         BALR  14,15
         LA    0,23
         ST    0,P00157+0
         LA    0,6
         ST    0,P00157+4
         LA    0,12
         ST    0,P00157+8
         LA    0,2
         ST    0,P00157+12
         LA    0,T00031
         ST    0,P00157+16
         LA    1,P00157
         L     15,C00158
         BALR  14,15
         LA    0,25
         ST    0,P00157+0
         LA    0,4
         ST    0,P00157+4
         LA    0,9
         ST    0,P00157+8
         LA    0,1
         ST    0,P00157+12
         LA    0,T00032
         ST    0,P00157+16
         LA    1,P00157
         L     15,C00158
         BALR  14,15
         LH    15,C00159
         ST    15,T00036
         LA    0,6
         ST    0,P00157+0
         L     0,C00160
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     3,T00036
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     15,C00163
         BALR  14,15
L00043   DS    0H
         LA    0,21
         ST    0,P00157+0
         LA    0,3
         ST    0,P00157+4
         LA    0,1
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00164
         BALR  14,15
         LR    2,15
         C     2,C00165
         BC    8,L00045
L00044   DS    0H
         LA    0,21
         ST    0,P00157+0
         L     0,C00166
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     15,C00163
         BALR  14,15
         LA    0,21
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00167
         BALR  14,15
L00045   DS    0H
L00046   DS    0H
         LA    0,6
         ST    0,P00157+0
         L     0,C00160
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     3,T00036
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     15,C00163
         BALR  14,15
         LA    15,11
         ST    15,T00033
         LA    15,22
         ST    15,T00034
         LA    0,21
         ST    0,P00157+0
         LA    0,1
         ST    0,P00157+4
         LA    0,1
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00164
         BALR  14,15
         LR    2,15
         C     2,C00165
         BC    8,L00048
L00047   DS    0H
         LA    0,21
         ST    0,P00157+0
         L     0,C00168
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     3,T00033
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     3,T00034
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     15,C00163
         BALR  14,15
         LA    0,21
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00167
         BALR  14,15
L00048   DS    0H
L00049   DS    0H
         LA    0,6
         ST    0,P00157+0
         L     0,C00160
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     3,T00036
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     15,C00163
         BALR  14,15
         LA    0,21
         ST    0,P00157+0
         LA    0,3
         ST    0,P00157+4
         LA    0,0
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00164
         BALR  14,15
         LR    2,15
         C     2,C00165
         BC    8,L00051
L00050   DS    0H
         LA    0,21
         ST    0,P00157+0
         L     0,C00169
         ST    0,P00157+4
         LA    0,0
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00170
         BALR  14,15
         LA    2,4
         LA    3,5
L00052   DS    0H
         C     3,C00165
         L     15,C00171
         BC    2,0(,15)
L00054   DS    0H
         L     15,C00172
         BALR  14,15
         LA    0,21
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00167
         BALR  14,15
L00051   DS    0H
L00055   DS    0H
         LA    0,6
         ST    0,P00157+0
         L     0,C00173
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     3,T00036
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         LA    2,4
         LA    3,5
L00056   DS    0H
         C     3,C00165
         L     15,C00174
         BC    2,0(,15)
L00058   DS    0H
         L     15,C00163
         BALR  14,15
L00059   DS    0H
         LA    0,21
         ST    0,P00157+0
         LA    0,1
         ST    0,P00157+4
         LA    0,0
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00164
         BALR  14,15
         LR    2,15
         C     2,C00165
         BC    8,L00061
L00060   DS    0H
         LA    0,21
         ST    0,P00157+0
         L     0,C00175
         ST    0,P00157+4
         LA    0,0
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00170
         BALR  14,15
         LA    0,T00033
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00176
         BALR  14,15
         LA    0,T00034
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00176
         BALR  14,15
         L     15,C00172
         BALR  14,15
         LA    0,21
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00167
         BALR  14,15
L00061   DS    0H
L00062   DS    0H
         LA    0,6
         ST    0,P00157+0
         L     0,C00177
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     3,T00036
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     3,T00033
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     3,T00034
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     15,C00163
         BALR  14,15
L00063   DS    0H
         LA    0,21
         ST    0,P00157+0
         LA    0,7
         ST    0,P00157+4
         LA    0,2
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00164
         BALR  14,15
         LA    0,6
         ST    0,P00157+0
         L     0,C00160
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     3,T00036
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     15,C00163
         BALR  14,15
         LA    15,4
         ST    15,T00032
         LA    0,21
         ST    0,P00157+0
         LA    0,5
         ST    0,P00157+4
         LA    0,0
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00164
         BALR  14,15
         LR    2,15
         C     2,C00165
         BC    8,L00065
L00064   DS    0H
         LA    0,21
         ST    0,P00157+0
         L     0,C00169
         ST    0,P00157+4
         LA    0,0
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00170
         BALR  14,15
         LA    2,4
         LA    3,5
L00066   DS    0H
         C     3,C00165
         L     15,C00178
         BC    2,0(,15)
L00068   DS    0H
         L     15,C00172
         BALR  14,15
         LA    0,21
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00167
         BALR  14,15
L00065   DS    0H
         LA    0,6
         ST    0,P00157+0
         L     0,C00173
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     3,T00036
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         LA    2,4
         LA    3,5
L00069   DS    0H
         C     3,C00165
         L     15,C00179
         BC    2,0(,15)
L00071   DS    0H
         L     15,C00163
         BALR  14,15
         LH    15,C00180
         ST    15,T00030
         LH    15,C00181
         ST    15,T00033
         LH    15,C00182
         ST    15,T00034
         LA    0,22
         ST    0,P00157+0
         LA    0,3
         ST    0,P00157+4
         LA    0,0
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00164
         BALR  14,15
         LR    2,15
         C     2,C00165
         BC    8,L00073
L00072   DS    0H
         LA    0,22
         ST    0,P00157+0
         LA    0,0
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00183
         BALR  14,15
         LA    0,T00033
         ST    0,P00157+0
         LA    0,4
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00184
         BALR  14,15
         LA    0,T00034
         ST    0,P00157+0
         LA    0,4
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00184
         BALR  14,15
         L     15,C00185
         BALR  14,15
         LA    0,22
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00167
         BALR  14,15
L00073   DS    0H
         LA    0,6
         ST    0,P00157+0
         L     0,C00186
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     3,T00030
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     3,T00033
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     3,T00034
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     15,C00163
         BALR  14,15
L00074   DS    0H
         LA    15,1
         ST    15,T00033
         LA    15,2
         ST    15,T00034
         LA    15,3
         ST    15,T00032
         LA    0,22
         ST    0,P00157+0
         LA    0,1
         ST    0,P00157+4
         LA    0,1
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00164
         BALR  14,15
         LR    2,15
         C     2,C00165
         BC    8,L00076
L00075   DS    0H
         LA    0,22
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00187
         BALR  14,15
         L     2,T00033
         ST    2,T00039
         LA    0,T00039
         ST    0,P00157+0
         LA    0,4
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00188
         BALR  14,15
         L     2,T00034
         ST    2,T00027
         LA    0,T00027
         ST    0,P00157+0
         LA    0,4
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00188
         BALR  14,15
         L     2,T00032
         ST    2,T00028
         LA    0,T00028
         ST    0,P00157+0
         LA    0,4
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00188
         BALR  14,15
         L     15,C00189
         BALR  14,15
         LA    0,22
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00167
         BALR  14,15
L00076   DS    0H
         LA    0,6
         ST    0,P00157+0
         L     0,C00190
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     3,T00030
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     15,C00163
         BALR  14,15
L00077   DS    0H
         LA    0,22
         ST    0,P00157+0
         LA    0,1
         ST    0,P00157+4
         LA    0,0
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00164
         BALR  14,15
         LR    2,15
         C     2,C00165
         BC    8,L00079
L00078   DS    0H
         LA    0,22
         ST    0,P00157+0
         LA    0,0
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00183
         BALR  14,15
         LA    0,T00033
         ST    0,P00157+0
         LA    0,4
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00184
         BALR  14,15
         LA    0,T00034
         ST    0,P00157+0
         LA    0,4
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00184
         BALR  14,15
         L     15,C00185
         BALR  14,15
         LA    0,22
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00167
         BALR  14,15
L00079   DS    0H
         LA    0,6
         ST    0,P00157+0
         L     0,C00191
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     3,T00030
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     3,T00033
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     3,T00034
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     15,C00163
         BALR  14,15
L00080   DS    0H
         LA    0,22
         ST    0,P00157+0
         LA    0,2
         ST    0,P00157+4
         LA    0,0
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00164
         BALR  14,15
         LR    2,15
         C     2,C00165
         BC    8,L00082
L00081   DS    0H
         LA    0,22
         ST    0,P00157+0
         LA    0,0
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00183
         BALR  14,15
         LA    0,T00033
         ST    0,P00157+0
         LA    0,4
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00184
         BALR  14,15
         LA    0,T00034
         ST    0,P00157+0
         LA    0,4
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00184
         BALR  14,15
         L     15,C00185
         BALR  14,15
         LA    0,22
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00167
         BALR  14,15
L00082   DS    0H
         LA    0,6
         ST    0,P00157+0
         L     0,C00191
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     3,T00030
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     3,T00033
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     3,T00034
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     15,C00163
         BALR  14,15
         LA    0,22
         ST    0,P00157+0
         LA    0,1
         ST    0,P00157+4
         LA    0,0
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00164
         BALR  14,15
         LR    2,15
         C     2,C00165
         BC    8,L00084
L00083   DS    0H
         LA    0,22
         ST    0,P00157+0
         LA    0,0
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00183
         BALR  14,15
         LA    2,4
         LA    3,8
L00085   DS    0H
         C     3,C00165
         L     15,C00192
         BC    2,0(,15)
L00087   DS    0H
         L     15,C00185
         BALR  14,15
         LA    0,22
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00167
         BALR  14,15
L00084   DS    0H
         LA    0,6
         ST    0,P00157+0
         L     0,C00193
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     3,T00030
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         LA    2,4
         LA    3,8
L00088   DS    0H
         C     3,C00165
         L     15,C00194
         BC    2,0(,15)
L00090   DS    0H
         L     15,C00163
         BALR  14,15
L00091   DS    0H
         LA    15,4
         ST    15,T00036
         LA    0,21
         ST    0,P00157+0
         LA    0,11
         ST    0,P00157+4
         LA    0,0
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00164
         BALR  14,15
         LR    2,15
         C     2,C00165
         BC    8,L00093
L00092   DS    0H
         LA    0,21
         ST    0,P00157+0
         L     0,C00169
         ST    0,P00157+4
         LA    0,0
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00170
         BALR  14,15
         LA    2,4
         LA    3,5
L00094   DS    0H
         C     3,C00165
         L     15,C00195
         BC    2,0(,15)
L00096   DS    0H
         L     15,C00172
         BALR  14,15
         LA    0,21
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00167
         BALR  14,15
L00093   DS    0H
         LA    0,6
         ST    0,P00157+0
         L     0,C00196
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     3,T00036
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     15,C00163
         BALR  14,15
L00097   DS    0H
         LA    15,5
         ST    15,T00036
         LA    0,21
         ST    0,P00157+0
         LA    0,0
         ST    0,P00157+4
         LA    0,1
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00164
         BALR  14,15
         LR    2,15
         C     2,C00165
         BC    8,L00099
L00098   DS    0H
         LA    0,21
         ST    0,P00157+0
         L     0,C00166
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     15,C00163
         BALR  14,15
         LA    0,21
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00167
         BALR  14,15
L00099   DS    0H
         LA    0,6
         ST    0,P00157+0
         L     0,C00196
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     3,T00036
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     15,C00163
         BALR  14,15
         LA    0,21
         ST    0,P00157+0
         LA    0,12
         ST    0,P00157+4
         LA    0,2
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00164
         BALR  14,15
         LA    0,6
         ST    0,P00157+0
         L     0,C00196
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     3,T00036
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     15,C00163
         BALR  14,15
         LA    0,21
         ST    0,P00157+0
         LA    0,2
         ST    0,P00157+4
         LA    0,1
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00164
         BALR  14,15
         LR    2,15
         C     2,C00165
         BC    8,L00101
L00100   DS    0H
         LA    0,21
         ST    0,P00157+0
         L     0,C00197
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     15,C00163
         BALR  14,15
         LA    0,21
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00167
         BALR  14,15
L00101   DS    0H
L00102   DS    0H
         LA    0,21
         ST    0,P00157+0
         LA    0,2
         ST    0,P00157+4
         LA    0,0
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00164
         BALR  14,15
         LR    2,15
         C     2,C00165
         BC    8,L00104
L00103   DS    0H
         LA    0,21
         ST    0,P00157+0
         L     0,C00198
         ST    0,P00157+4
         LA    0,0
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00170
         BALR  14,15
         LA    2,4
         LA    3,8
L00105   DS    0H
         C     3,C00165
         L     15,C00199
         BC    2,0(,15)
L00107   DS    0H
         L     15,C00172
         BALR  14,15
         LA    0,21
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00167
         BALR  14,15
L00104   DS    0H
L00108   DS    0H
         LA    0,6
         ST    0,P00157+0
         L     0,C00200
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     3,T00036
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         LA    2,4
         LA    3,8
L00109   DS    0H
         C     3,C00165
         L     15,C00201
         BC    2,0(,15)
L00111   DS    0H
         L     15,C00163
         BALR  14,15
L00112   DS    0H
         L     2,T00037+16
         ST    2,T00037
         LA    0,23
         ST    0,P00157+0
         LA    0,2
         ST    0,P00157+4
         LA    0,0
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00164
         BALR  14,15
         LR    2,15
         C     2,C00165
         BC    8,L00114
L00113   DS    0H
         LA    0,23
         ST    0,P00157+0
         L     0,C00202
         ST    0,P00157+4
         LA    0,0
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00170
         BALR  14,15
         LA    0,T00037
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00176
         BALR  14,15
         L     15,C00172
         BALR  14,15
         LA    0,23
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00167
         BALR  14,15
L00114   DS    0H
L00115   DS    0H
         L     2,T00038+20
         ST    2,T00037
         LH    15,C00203
         ST    15,T00033
         MVC   T00035(4),C00204
         LA    0,23
         ST    0,P00157+0
         LA    0,5
         ST    0,P00157+4
         LA    0,1
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00164
         BALR  14,15
         LR    2,15
         C     2,C00165
         BC    8,L00117
L00116   DS    0H
         LA    0,23
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00187
         BALR  14,15
         L     2,T00033
         ST    2,T00041
         LA    0,T00041
         ST    0,P00157+0
         LA    0,4
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00188
         BALR  14,15
         LE    0,T00035
         STE   0,T00029
         LA    0,T00029
         ST    0,P00157+0
         LA    0,4
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00188
         BALR  14,15
         L     15,C00189
         BALR  14,15
         LA    0,23
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00167
         BALR  14,15
L00117   DS    0H
         LA    0,6
         ST    0,P00157+0
         L     0,C00205
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     3,T00031
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     15,C00163
         BALR  14,15
L00118   DS    0H
         LA    15,0
         ST    15,T00033
         MVC   T00035(4),C00206
         LA    0,23
         ST    0,P00157+0
         LA    0,5
         ST    0,P00157+4
         LA    0,0
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00164
         BALR  14,15
         LR    2,15
         C     2,C00165
         BC    8,L00120
L00119   DS    0H
         LA    0,23
         ST    0,P00157+0
         LA    0,0
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00183
         BALR  14,15
         LA    0,T00033
         ST    0,P00157+0
         LA    0,4
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00184
         BALR  14,15
         LA    0,T00035
         ST    0,P00157+0
         LA    0,4
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00184
         BALR  14,15
         L     15,C00185
         BALR  14,15
         LA    0,23
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00167
         BALR  14,15
L00120   DS    0H
         LA    0,23
         ST    0,P00157+0
         LA    0,4
         ST    0,P00157+4
         LA    0,1
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00164
         BALR  14,15
         LR    2,15
         C     2,C00165
         BC    8,L00122
L00121   DS    0H
         LA    0,23
         ST    0,P00157+0
         L     0,C00207
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     15,C00163
         BALR  14,15
         LA    0,23
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00167
         BALR  14,15
L00122   DS    0H
L00123   DS    0H
         LA    0,23
         ST    0,P00157+0
         LA    0,4
         ST    0,P00157+4
         LA    0,0
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00164
         BALR  14,15
         LR    2,15
         C     2,C00165
         BC    8,L00125
L00124   DS    0H
         LA    0,23
         ST    0,P00157+0
         L     0,C00202
         ST    0,P00157+4
         LA    0,0
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00170
         BALR  14,15
         LA    3,T00037+8
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00176
         BALR  14,15
         L     15,C00172
         BALR  14,15
         LA    0,23
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00167
         BALR  14,15
L00125   DS    0H
         LA    0,6
         ST    0,P00157+0
         L     0,C00208
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     3,T00031
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     3,T00033
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         LE    0,T00035
         STE   0,S00000+456
         LE    0,S00000+456
         STE   0,P00157+0
         LA    1,P00157
         L     15,C00209
         BALR  14,15
         L     3,T00037+8
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     15,C00163
         BALR  14,15
L00126   DS    0H
         L     15,C00210
         BALR  14,15
         L     14,C00211
         L     2,0(,14)
         S     2,C00212
         LA    0,24
         ST    0,P00157+0
         LR    0,2
         ST    0,P00157+4
         LA    0,0
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00164
         BALR  14,15
         LR    3,15
         C     3,C00165
         L     15,C00213
         BC    8,0(,15)
L00127   DS    0H
         LA    0,24
         ST    0,P00157+0
         L     0,C00214
         ST    0,P00157+4
         LA    0,0
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00170
         BALR  14,15
         LA    0,T00033
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00176
         BALR  14,15
         L     15,C00172
         BALR  14,15
         LA    0,24
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00167
         BALR  14,15
L00128   DS    0H
L00129   DS    0H
         LA    0,6
         ST    0,P00157+0
         L     0,C00215
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     14,C00211
         L     3,0(,14)
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     3,T00033
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     15,C00163
         BALR  14,15
L00130   DS    0H
L00131   DS    0H
         LH    15,C00181
         ST    15,T00032
L00132   DS    0H
         LA    0,25
         ST    0,P00157+0
         LA    0,1
         ST    0,P00157+4
         LA    0,1
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00164
         BALR  14,15
         LR    2,15
         C     2,C00165
         L     15,C00216
         BC    8,0(,15)
L00134   DS    0H
         LA    0,25
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00187
         BALR  14,15
         LA    2,4
         LA    3,9
L00136   DS    0H
         C     3,C00165
         L     15,C00217
         BC    2,0(,15)
L00138   DS    0H
         L     15,C00189
         BALR  14,15
         LA    0,25
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00167
         BALR  14,15
L00135   DS    0H
L00133   DS    0H
         LA    0,6
         ST    0,P00157+0
         L     0,C00218
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     3,T00032
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     15,C00163
         BALR  14,15
L00139   DS    0H
         L     2,T00032
         C     2,C00165
         L     15,C00219
         BC    13,0(,15)
L00140   DS    0H
         LA    0,21
         ST    0,P00157+0
         LA    0,10
         ST    0,P00157+4
         LA    0,2
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00164
         BALR  14,15
L00141   DS    0H
         LA    0,6
         ST    0,P00157+0
         L     0,C00220
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     3,T00036
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     15,C00163
         BALR  14,15
L00142   DS    0H
         LA    15,42
         ST    15,T00033
         LA    0,7
         ST    0,P00157+0
         L     0,C00221
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         L     3,T00033
         LR    0,3
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         L     15,C00163
         BALR  14,15
L00143   DS    0H
         LA    0,7
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00222
         BALR  14,15
         LA    0,7
         ST    0,P00157+0
         L     0,C00223
         ST    0,P00157+4
         LA    0,0
         ST    0,P00157+8
         LA    1,P00157
         L     15,C00170
         BALR  14,15
         LA    2,4
         LA    3,5
L00144   DS    0H
         C     3,C00165
         L     15,C00224
         BC    2,0(,15)
L00146   DS    0H
         L     15,C00172
         BALR  14,15
L00147   DS    0H
         LA    0,6
         ST    0,P00157+0
         L     0,C00225
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00161
         BALR  14,15
         LA    2,4
         LA    3,5
L00148   DS    0H
         C     3,C00165
         L     15,C00226
         BC    2,0(,15)
L00150   DS    0H
         L     15,C00163
         BALR  14,15
L00151   DS    0H
         LA    0,0
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00227
         BALR  14,15
         L     15,C00228
         B     0(,15)
L00053   DS    0H
         LR    4,2
         AH    4,C00229
         LA    5,T00037
         AR    5,4
         LR    0,5
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00176
         BALR  14,15
         AH    3,C00181
         A     2,C00230
         B     L00052
L00057   DS    0H
         L     5,T00037-4(2)
         LR    0,5
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         AH    3,C00181
         A     2,C00230
         B     L00056
L00067   DS    0H
         LR    4,2
         AH    4,C00229
         LA    5,T00037
         AR    5,4
         LR    0,5
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00176
         BALR  14,15
         AH    3,C00181
         A     2,C00230
         B     L00066
L00070   DS    0H
         L     5,T00037-4(2)
         LR    0,5
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         AH    3,C00181
         A     2,C00230
         B     L00069
L00086   DS    0H
         LR    4,2
         AH    4,C00229
         LA    5,T00038
         AR    5,4
         LR    0,5
         ST    0,P00157+0
         LA    0,4
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00184
         BALR  14,15
         AH    3,C00181
         A     2,C00230
         B     L00085
L00089   DS    0H
         L     5,T00038-4(2)
         LR    0,5
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         AH    3,C00181
         A     2,C00230
         B     L00088
L00095   DS    0H
         LR    4,2
         AH    4,C00229
         LA    5,T00037
         AR    5,4
         LR    0,5
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00176
         BALR  14,15
         AH    3,C00181
         A     2,C00230
         B     L00094
L00106   DS    0H
         LR    4,2
         AH    4,C00229
         LA    5,T00038
         AR    5,4
         LR    0,5
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00176
         BALR  14,15
         AH    3,C00181
         A     2,C00230
         B     L00105
L00110   DS    0H
         L     5,T00038-4(2)
         LR    0,5
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         AH    3,C00181
         A     2,C00230
         B     L00109
L00137   DS    0H
         LR    4,2
         AH    4,C00229
         LA    5,T00040
         AR    5,4
         LR    0,5
         ST    0,P00157+0
         LA    0,4
         ST    0,P00157+4
         LA    1,P00157
         L     15,C00188
         BALR  14,15
         AH    3,C00181
         A     2,C00230
         L     15,C00231
         B     0(,15)
L00145   DS    0H
         LR    4,2
         AH    4,C00229
         LA    5,T00037
         AR    5,4
         LR    0,5
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00176
         BALR  14,15
         AH    3,C00181
         A     2,C00230
         L     15,C00232
         B     0(,15)
L00149   DS    0H
         L     5,T00037-4(2)
         LR    0,5
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00162
         BALR  14,15
         AH    3,C00181
         A     2,C00230
         L     15,C00233
         B     0(,15)
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
P00157   DS    5F
         DS    XL4
C00158   DC    V(F77DFILE)
C00160   DC    A(Q00001)
C00161   DC    V(F77WRBEG)
C00162   DC    V(F77WRI)
C00163   DC    V(F77WREND)
C00164   DC    V(F77DAREC)
C00165   DC    F'0'
C00166   DC    A(Q00002)
C00167   DC    V(F77DADON)
C00168   DC    A(Q00003)
C00169   DC    A(Q00004)
C00170   DC    V(F77RDBEG)
C00171   DC    A(L00053)
C00172   DC    V(F77RDEND)
C00173   DC    A(Q00005)
C00174   DC    A(L00057)
C00175   DC    A(Q00006)
C00176   DC    V(F77RDI)
C00177   DC    A(Q00007)
C00178   DC    A(L00067)
C00179   DC    A(L00070)
C00183   DC    V(F77RUBEG)
C00184   DC    V(F77RU)
C00185   DC    V(F77RUEND)
C00186   DC    A(Q00008)
C00187   DC    V(F77WUBEG)
C00188   DC    V(F77WU)
C00189   DC    V(F77WUEND)
C00190   DC    A(Q00009)
C00191   DC    A(Q00010)
C00192   DC    A(L00086)
C00193   DC    A(Q00011)
C00194   DC    A(L00089)
C00195   DC    A(L00095)
C00196   DC    A(Q00012)
C00197   DC    A(Q00013)
C00198   DC    A(Q00014)
C00199   DC    A(L00106)
C00200   DC    A(Q00015)
C00201   DC    A(L00110)
C00202   DC    A(Q00016)
C00204   DC    X'41280000'
C00205   DC    A(Q00017)
C00206   DC    X'00000000'
C00207   DC    A(Q00018)
C00208   DC    A(Q00019)
C00209   DC    V(F77WRR)
C00210   DC    V(DSUB)
C00211   DC    A(DA)
C00212   DC    F'1'
C00213   DC    A(L00128)
C00214   DC    A(Q00020)
C00215   DC    A(Q00021)
C00216   DC    A(L00135)
C00217   DC    A(L00137)
C00218   DC    A(Q00022)
C00219   DC    A(L00141)
C00220   DC    A(Q00023)
C00221   DC    A(Q00024)
C00222   DC    V(F77REWND)
C00223   DC    A(Q00025)
C00224   DC    A(L00145)
C00225   DC    A(Q00026)
C00226   DC    A(L00149)
C00227   DC    V(EXIT)
C00228   DC    A(L00153)
C00230   DC    F'4'
C00231   DC    A(L00136)
C00232   DC    A(L00144)
C00233   DC    A(L00148)
C00159   DC    H'-7'
C00180   DC    H'-5'
C00181   DC    H'-1'
C00182   DC    H'-2'
C00203   DC    H'12345'
C00229   DC    H'-4'
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
         B     L00242
         DC    AL1(4),CL7'DSUB'
L00242   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00243
L00244   DC    A(S00234)
L00243   L     15,L00244
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00234,13
         ST    1,S00234+72
L00236   DS    0H
         LA    0,24
         ST    0,P00245+0
         LA    0,3
         ST    0,P00245+4
         LA    0,4
         ST    0,P00245+8
         LA    0,0
         ST    0,P00245+12
         L     0,C00246
         ST    0,P00245+16
         LA    1,P00245
         L     15,C00247
         BALR  14,15
         LA    0,24
         ST    0,P00245+0
         LA    0,2
         ST    0,P00245+4
         LA    0,1
         ST    0,P00245+8
         LA    1,P00245
         L     15,C00248
         BALR  14,15
         LR    2,15
         C     2,C00249
         BC    8,L00238
L00237   DS    0H
         LA    0,24
         ST    0,P00245+0
         L     0,C00250
         ST    0,P00245+4
         LA    1,P00245
         L     15,C00251
         BALR  14,15
         L     15,C00252
         BALR  14,15
         LA    0,24
         ST    0,P00245+0
         LA    1,P00245
         L     15,C00253
         BALR  14,15
L00238   DS    0H
L00239   DS    0H
         LA    0,0
         B     L00241
L00240   DS    0H
L00241   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00234   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00245   DS    5F
         DS    XL4
C00246   DC    A(DA)
C00247   DC    V(F77DFILE)
C00248   DC    V(F77DAREC)
C00249   DC    F'0'
C00250   DC    A(Q00235)
C00251   DC    V(F77WRBEG)
C00252   DC    V(F77WREND)
C00253   DC    V(F77DADON)
Q00235   DC    C'(''  77'')'
DA       CSECT
         DS    0D
         DS    XL4
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
