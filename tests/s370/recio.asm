* main
F77MAIN  CSECT
         USING *,15
         B     L00091
         DC    AL1(7),CL7'F77MAIN'
L00091   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00092
L00093   DC    A(S00000)
L00092   L     15,L00093
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00060   DS    0H
         LA    15,0
         ST    15,T00049
         LA    1,P00094
         L     15,C00095
         BALR  14,15
L00061   DS    0H
         LA    6,100
         LA    7,500
         LA    2,100
         LA    3,10
         LA    4,1
L00062   DS    0H
         LR    0,4
         ST    0,P00096+0
         LA    1,P00096
         L     15,C00097
         BALR  14,15
         LA    1,P00098
         L     15,C00099
         BALR  14,15
         ST    4,T00050
         LA    1,P00100
         L     15,C00101
         BALR  14,15
         ST    3,T00044
         LA    1,P00102
         L     15,C00101
         BALR  14,15
         ST    2,T00045
         LA    1,P00103
         L     15,C00101
         BALR  14,15
         L     15,C00104
         BALR  14,15
L00064   DS    0H
         A     4,C00105
         A     3,C00106
         BXLE  2,6,L00062
L00063   DS    0H
         LA    1,P00107
         L     15,C00097
         BALR  14,15
         LA    1,P00098
         L     15,C00099
         BALR  14,15
         LA    15,9
         ST    15,T00026
         LA    1,P00108
         L     15,C00101
         BALR  14,15
         LA    15,90
         ST    15,T00027
         LA    1,P00109
         L     15,C00101
         BALR  14,15
         LA    15,900
         ST    15,T00028
         LA    1,P00110
         L     15,C00101
         BALR  14,15
         L     15,C00104
         BALR  14,15
         LA    1,P00111
         L     15,C00097
         BALR  14,15
         LA    1,P00098
         L     15,C00099
         BALR  14,15
         LH    15,C00112
         ST    15,T00029
         LA    1,P00113
         L     15,C00101
         BALR  14,15
         LH    15,C00114
         ST    15,T00030
         LA    1,P00115
         L     15,C00101
         BALR  14,15
         LH    15,C00116
         ST    15,T00031
         LA    1,P00117
         L     15,C00101
         BALR  14,15
         L     15,C00104
         BALR  14,15
         LA    1,P00107
         L     15,C00097
         BALR  14,15
         LA    1,P00118
         L     15,C00119
         BALR  14,15
         LA    2,4
         LA    3,3
L00065   DS    0H
         C     3,C00120
         BC    2,L00066
L00067   DS    0H
         L     15,C00121
         BALR  14,15
         L     3,T00058
         C     3,C00122
         LA    2,1
         BC    8,L00123
         SR    2,2
L00123   DS    0H
         L     4,T00058+8
         C     4,C00124
         LA    3,1
         BC    8,L00125
         SR    3,3
L00125   DS    0H
         NR    2,3
         ST    2,T00052
         LA    1,P00126
         L     15,C00127
         BALR  14,15
         LA    1,P00111
         L     15,C00097
         BALR  14,15
         LA    1,P00118
         L     15,C00119
         BALR  14,15
         LA    2,4
         LA    3,3
L00068   DS    0H
         C     3,C00120
         BC    2,L00069
L00070   DS    0H
         L     15,C00121
         BALR  14,15
         L     3,T00058
         C     3,C00128
         LA    2,1
         BC    8,L00129
         SR    2,2
L00129   DS    0H
         L     4,T00058+4
         C     4,C00130
         LA    3,1
         BC    8,L00131
         SR    3,3
L00131   DS    0H
         NR    2,3
         ST    2,T00053
         LA    1,P00132
         L     15,C00127
         BALR  14,15
         LA    1,P00133
         L     15,C00097
         BALR  14,15
         LA    1,P00118
         L     15,C00119
         BALR  14,15
         LA    2,4
         LA    3,3
L00071   DS    0H
         C     3,C00120
         BC    2,L00072
L00073   DS    0H
         L     15,C00121
         BALR  14,15
         L     3,T00058+4
         C     3,C00134
         LA    2,1
         BC    8,L00135
         SR    2,2
L00135   DS    0H
         ST    2,T00054
         LA    1,P00136
         L     15,C00127
         BALR  14,15
         LA    1,P00137
         L     15,C00138
         BALR  14,15
         LA    1,P00139
         L     15,C00140
         BALR  14,15
         L     3,T00048
         C     3,C00141
         LA    2,1
         BC    8,L00142
         SR    2,2
L00142   DS    0H
         ST    2,T00032
         LA    1,P00143
         L     15,C00127
         BALR  14,15
         LA    1,P00137
         L     15,C00144
         BALR  14,15
         LA    1,P00145
         L     15,C00095
         BALR  14,15
         LA    1,P00146
         L     15,C00097
         BALR  14,15
         LA    1,P00118
         L     15,C00119
         BALR  14,15
         LA    2,4
         LA    3,3
L00074   DS    0H
         C     3,C00120
         BC    2,L00075
L00076   DS    0H
         L     15,C00121
         BALR  14,15
         L     3,T00058+8
         C     3,C00147
         LA    2,1
         BC    8,L00148
         SR    2,2
L00148   DS    0H
         ST    2,T00055
         LA    1,P00149
         L     15,C00127
         BALR  14,15
         LA    1,P00107
         L     15,C00097
         BALR  14,15
         LA    1,P00118
         L     15,C00119
         BALR  14,15
         LA    2,4
         LA    3,3
L00077   DS    0H
         C     3,C00120
         BC    2,L00078
L00079   DS    0H
         L     15,C00121
         BALR  14,15
         L     3,T00058+4
         C     3,C00150
         LA    2,1
         BC    8,L00151
         SR    2,2
L00151   DS    0H
         ST    2,T00056
         LA    1,P00152
         L     15,C00127
         BALR  14,15
         LA    1,P00137
         L     15,C00144
         BALR  14,15
         LA    1,P00153
         L     15,C00095
         BALR  14,15
         LA    1,P00154
         L     15,C00097
         BALR  14,15
         LA    1,P00155
         L     15,C00156
         BALR  14,15
         LA    1,P00157
         L     15,C00158
         BALR  14,15
         LA    1,P00159
         L     15,C00158
         BALR  14,15
         L     15,C00160
         BALR  14,15
L00080   DS    0H
         LA    1,P00146
         L     15,C00097
         BALR  14,15
         LA    1,P00155
         L     15,C00156
         BALR  14,15
         LA    1,P00161
         L     15,C00158
         BALR  14,15
         L     15,C00160
         BALR  14,15
         LA    1,P00111
         L     15,C00097
         BALR  14,15
         LA    1,P00162
         L     15,C00163
         BALR  14,15
         LA    1,P00164
         L     15,C00165
         BALR  14,15
         L     15,C00166
         BALR  14,15
L00081   DS    0H
         LA    1,P00167
         L     15,C00168
         BALR  14,15
         LR    3,15
         C     3,C00120
         LA    2,1
         BC    8,L00169
         SR    2,2
L00169   DS    0H
         ST    2,T00033
         LA    1,P00170
         L     15,C00127
         BALR  14,15
         LA    4,1
         LR    0,4
         ST    0,P00096+0
         LA    1,P00096
         L     15,C00097
         BALR  14,15
         LA    1,P00162
         L     15,C00163
         BALR  14,15
         LA    1,P00164
         L     15,C00165
         BALR  14,15
         L     15,C00166
         BALR  14,15
         LA    1,P00171
         L     15,C00168
         BALR  14,15
         LR    3,15
         C     3,C00120
         LA    2,1
         BC    8,L00172
         SR    2,2
L00172   DS    0H
         ST    2,T00034
         LA    1,P00173
         L     15,C00127
         BALR  14,15
         LA    1,P00174
         L     15,C00138
         BALR  14,15
         LA    1,P00139
         L     15,C00140
         BALR  14,15
         L     3,T00048
         C     3,C00175
         LA    2,1
         BC    8,L00176
         SR    2,2
L00176   DS    0H
         ST    2,T00035
         LA    1,P00177
         L     15,C00127
         BALR  14,15
         LA    1,P00174
         L     15,C00144
         BALR  14,15
L00082   DS    0H
         LA    5,6
         LR    2,4
L00083   DS    0H
         LA    1,P00178
         L     15,C00099
         BALR  14,15
         ST    2,T00051
         LA    1,P00179
         L     15,C00101
         BALR  14,15
         LR    1,2
         MR    0,2
         LR    3,1
         ST    3,T00046
         LA    1,P00180
         L     15,C00101
         BALR  14,15
         L     15,C00104
         BALR  14,15
L00085   DS    0H
         BXLE  2,4,L00083
L00084   DS    0H
         LA    1,P00178
         L     15,C00181
         BALR  14,15
         LA    1,P00182
         L     15,C00119
         BALR  14,15
         LA    1,P00183
         L     15,C00184
         BALR  14,15
         LA    1,P00185
         L     15,C00184
         BALR  14,15
         L     15,C00121
         BALR  14,15
         LA    1,P00182
         L     15,C00119
         BALR  14,15
         LA    1,P00183
         L     15,C00184
         BALR  14,15
         LA    1,P00185
         L     15,C00184
         BALR  14,15
         L     15,C00121
         BALR  14,15
         L     3,T00057
         C     3,C00175
         LA    2,1
         BC    8,L00186
         SR    2,2
L00186   DS    0H
         L     4,T00047
         C     4,C00187
         LA    3,1
         BC    8,L00188
         SR    3,3
L00188   DS    0H
         NR    2,3
         ST    2,T00036
         LA    1,P00189
         L     15,C00127
         BALR  14,15
         LA    1,P00178
         L     15,C00190
         BALR  14,15
         LA    1,P00182
         L     15,C00119
         BALR  14,15
         LA    1,P00183
         L     15,C00184
         BALR  14,15
         LA    1,P00185
         L     15,C00184
         BALR  14,15
         L     15,C00121
         BALR  14,15
         L     3,T00057
         C     3,C00175
         LA    2,1
         BC    8,L00191
         SR    2,2
L00191   DS    0H
         ST    2,T00037
         LA    1,P00192
         L     15,C00127
         BALR  14,15
         LA    1,P00178
         L     15,C00190
         BALR  14,15
         LA    1,P00178
         L     15,C00099
         BALR  14,15
         LA    15,20
         ST    15,T00038
         LA    1,P00193
         L     15,C00101
         BALR  14,15
         LA    15,400
         ST    15,T00039
         LA    1,P00194
         L     15,C00101
         BALR  14,15
         L     15,C00104
         BALR  14,15
         LA    1,P00178
         L     15,C00195
         BALR  14,15
         LA    1,P00178
         L     15,C00181
         BALR  14,15
         LA    15,0
         ST    15,T00048
L00086   DS    0H
         LA    1,P00196
         L     15,C00119
         BALR  14,15
         LR    2,15
         C     2,C00105
         BC    8,L00088
L00087   DS    0H
         LA    1,P00183
         L     15,C00184
         BALR  14,15
         LA    1,P00185
         L     15,C00184
         BALR  14,15
         L     15,C00121
         BALR  14,15
         L     2,T00048
         A     2,C00105
         ST    2,T00048
         B     L00086
L00066   DS    0H
         LR    4,2
         AH    4,C00197
         LA    5,T00058
         AR    5,4
         LR    0,5
         ST    0,P00198+0
         LA    1,P00198
         L     15,C00184
         BALR  14,15
         AH    3,C00199
         A     2,C00187
         B     L00065
L00069   DS    0H
         LR    4,2
         AH    4,C00197
         LA    5,T00058
         AR    5,4
         LR    0,5
         ST    0,P00198+0
         LA    1,P00198
         L     15,C00184
         BALR  14,15
         AH    3,C00199
         A     2,C00187
         B     L00068
L00072   DS    0H
         LR    4,2
         AH    4,C00197
         LA    5,T00058
         AR    5,4
         LR    0,5
         ST    0,P00198+0
         LA    1,P00198
         L     15,C00184
         BALR  14,15
         AH    3,C00199
         A     2,C00187
         B     L00071
L00075   DS    0H
         LR    4,2
         AH    4,C00197
         LA    5,T00058
         AR    5,4
         LR    0,5
         ST    0,P00198+0
         LA    1,P00198
         L     15,C00184
         BALR  14,15
         AH    3,C00199
         A     2,C00187
         B     L00074
L00078   DS    0H
         LR    4,2
         AH    4,C00197
         LA    5,T00058
         AR    5,4
         LR    0,5
         ST    0,P00198+0
         LA    1,P00198
         L     15,C00184
         BALR  14,15
         AH    3,C00199
         A     2,C00187
         B     L00077
L00088   DS    0H
         L     3,T00048
         C     3,C00175
         LA    2,1
         BC    8,L00200
         SR    2,2
L00200   DS    0H
         L     4,T00057
         C     4,C00201
         LA    3,1
         BC    8,L00202
         SR    3,3
L00202   DS    0H
         NR    2,3
         ST    2,T00040
         LA    1,P00203
         L     15,C00127
         BALR  14,15
         LA    1,P00178
         L     15,C00190
         BALR  14,15
         LA    1,P00178
         L     15,C00099
         BALR  14,15
         LA    15,3
         ST    15,T00041
         LA    1,P00204
         L     15,C00101
         BALR  14,15
         LA    15,9
         ST    15,T00042
         LA    1,P00205
         L     15,C00101
         BALR  14,15
         L     15,C00104
         BALR  14,15
         LA    1,P00178
         L     15,C00195
         BALR  14,15
         LA    1,P00178
         L     15,C00181
         BALR  14,15
         LA    1,P00182
         L     15,C00119
         BALR  14,15
         LA    1,P00183
         L     15,C00184
         BALR  14,15
         L     15,C00121
         BALR  14,15
         LA    1,P00182
         L     15,C00119
         BALR  14,15
         LA    1,P00183
         L     15,C00184
         BALR  14,15
         L     15,C00121
         BALR  14,15
         LA    1,P00182
         L     15,C00119
         BALR  14,15
         LA    1,P00183
         L     15,C00184
         BALR  14,15
         LA    1,P00185
         L     15,C00184
         BALR  14,15
         L     15,C00121
         BALR  14,15
         L     3,T00057
         C     3,C00206
         LA    2,1
         BC    8,L00207
         SR    2,2
L00207   DS    0H
         L     4,T00047
         C     4,C00122
         LA    3,1
         BC    8,L00208
         SR    3,3
L00208   DS    0H
         NR    2,3
         ST    2,T00043
         LA    1,P00209
         L     15,C00127
         BALR  14,15
         LA    1,P00210
         L     15,C00156
         BALR  14,15
         L     3,T00049
         LR    0,3
         ST    0,P00096+0
         LA    1,P00096
         L     15,C00211
         BALR  14,15
         L     15,C00160
         BALR  14,15
L00089   DS    0H
L00090   DS    0H
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
T00026   DS    XL4
         DS    XL4
T00027   DS    XL4
         DS    XL4
T00028   DS    XL4
         DS    XL4
T00029   DS    XL4
         DS    XL4
T00030   DS    XL4
         DS    XL4
T00031   DS    XL4
         DS    XL4
T00032   DS    XL4
         DS    XL4
T00033   DS    XL4
         DS    XL4
T00034   DS    XL4
         DS    XL4
T00035   DS    XL4
         DS    XL4
T00036   DS    XL4
         DS    XL4
T00037   DS    XL4
         DS    XL4
T00038   DS    XL4
         DS    XL4
T00039   DS    XL4
         DS    XL4
T00040   DS    XL4
         DS    XL4
T00041   DS    XL4
         DS    XL4
T00042   DS    XL4
         DS    XL4
T00043   DS    XL4
         DS    XL4
T00044   DS    XL4
         DS    XL4
T00045   DS    XL4
         DS    XL4
T00046   DS    XL4
         DS    XL4
T00047   DS    XL8
T00048   DS    XL8
T00049   DS    XL8
T00050   DS    XL8
T00051   DS    XL8
T00052   DS    XL12
         DS    XL4
T00053   DS    XL12
         DS    XL4
T00054   DS    XL12
         DS    XL4
T00055   DS    XL12
         DS    XL4
T00056   DS    XL12
         DS    XL4
T00057   DS    XL16
T00058   DS    XL16
T00059   DS    XL24
P00094   DC    F'21'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    A(Q00001)
         DC    F'6'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'12'
         DC    F'0'
P00096   DC    A(0)
P00098   DC    F'21'
P00100   DC    A(T00050)
         DC    F'4'
P00102   DC    A(T00044)
         DC    F'4'
P00103   DC    A(T00045)
         DC    F'4'
P00107   DC    F'9'
P00108   DC    A(T00026)
         DC    F'4'
P00109   DC    A(T00027)
         DC    F'4'
P00110   DC    A(T00028)
         DC    F'4'
P00111   DC    F'3'
P00113   DC    A(T00029)
         DC    F'4'
P00115   DC    A(T00030)
         DC    F'4'
P00117   DC    A(T00031)
         DC    F'4'
P00118   DC    F'21'
         DC    F'0'
P00126   DC    A(Q00002)
         DC    A(T00052)
         DC    A(T00049)
         DC    XL1'80',FL3'13'
P00132   DC    A(Q00003)
         DC    A(T00053)
         DC    A(T00049)
         DC    XL1'80',FL3'12'
P00133   DC    F'5'
P00136   DC    A(Q00004)
         DC    A(T00054)
         DC    A(T00049)
         DC    XL1'80',FL3'13'
P00137   DC    F'21'
         DC    F'0'
         DC    F'0'
P00139   DC    F'13'
         DC    A(T00048)
         DC    F'0'
P00143   DC    A(Q00005)
         DC    A(T00032)
         DC    A(T00049)
         DC    XL1'80',FL3'12'
P00145   DC    F'21'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    A(Q00006)
         DC    F'6'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'12'
         DC    F'0'
P00146   DC    F'1'
P00149   DC    A(Q00007)
         DC    A(T00055)
         DC    A(T00049)
         DC    XL1'80',FL3'11'
P00152   DC    A(Q00008)
         DC    A(T00056)
         DC    A(T00049)
         DC    XL1'80',FL3'15'
P00153   DC    F'22'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    A(Q00009)
         DC    F'6'
         DC    A(Q00010)
         DC    F'9'
         DC    F'0'
         DC    F'0'
         DC    F'20'
         DC    F'0'
P00154   DC    F'2'
P00155   DC    F'22'
         DC    A(Q00011)
P00157   DC    A(Q00012)
         DC    F'6'
P00159   DC    A(Q00013)
         DC    F'5'
P00161   DC    A(Q00014)
         DC    F'5'
P00162   DC    F'22'
         DC    A(Q00015)
         DC    F'0'
P00164   DC    A(T00059)
         DC    F'20'
P00167   DC    A(T00059)
         DC    F'20'
         DC    A(Q00017)
         DC    F'5'
P00170   DC    A(Q00016)
         DC    A(T00033)
         DC    A(T00049)
         DC    XL1'80',FL3'10'
P00171   DC    A(T00059)
         DC    F'20'
         DC    A(Q00019)
         DC    F'5'
P00173   DC    A(Q00018)
         DC    A(T00034)
         DC    A(T00049)
         DC    XL1'80',FL3'10'
P00174   DC    F'22'
         DC    F'0'
         DC    F'0'
P00177   DC    A(Q00020)
         DC    A(T00035)
         DC    A(T00049)
         DC    XL1'80',FL3'12'
P00178   DC    F'23'
P00179   DC    A(T00051)
         DC    F'4'
P00180   DC    A(T00046)
         DC    F'4'
P00182   DC    F'23'
         DC    F'0'
P00183   DC    A(T00057)
         DC    F'4'
P00185   DC    A(T00047)
         DC    F'4'
P00189   DC    A(Q00021)
         DC    A(T00036)
         DC    A(T00049)
         DC    XL1'80',FL3'8'
P00192   DC    A(Q00022)
         DC    A(T00037)
         DC    A(T00049)
         DC    XL1'80',FL3'13'
P00193   DC    A(T00038)
         DC    F'4'
P00194   DC    A(T00039)
         DC    F'4'
P00196   DC    F'23'
         DC    F'1'
P00198   DC    A(0)
         DC    F'4'
P00203   DC    A(Q00023)
         DC    A(T00040)
         DC    A(T00049)
         DC    XL1'80',FL3'12'
P00204   DC    A(T00041)
         DC    F'4'
P00205   DC    A(T00042)
         DC    F'4'
P00209   DC    A(Q00024)
         DC    A(T00043)
         DC    A(T00049)
         DC    XL1'80',FL3'13'
P00210   DC    F'6'
         DC    A(Q00025)
         DS    XL4
C00095   DC    V(F77OPEN)
C00097   DC    V(F77SETRC)
C00099   DC    V(F77WUBEG)
C00101   DC    V(F77WU)
C00104   DC    V(F77WUEND)
C00105   DC    F'1'
C00106   DC    F'10'
C00119   DC    V(F77RUBEG)
C00120   DC    F'0'
C00121   DC    V(F77RUEND)
C00122   DC    F'9'
C00124   DC    F'900'
C00127   DC    V(CHK)
C00128   DC    F'-3'
C00130   DC    F'-30'
C00134   DC    F'50'
C00138   DC    V(F77INQR)
C00140   DC    V(F77INQ)
C00141   DC    F'6'
C00144   DC    V(F77CLOSE)
C00147   DC    F'100'
C00150   DC    F'90'
C00156   DC    V(F77WRBEG)
C00158   DC    V(F77WRA)
C00160   DC    V(F77WREND)
C00163   DC    V(F77RDBEG)
C00165   DC    V(F77RDS)
C00166   DC    V(F77RDEND)
C00168   DC    V(F77STRCM)
C00175   DC    F'2'
C00181   DC    V(F77REWND)
C00184   DC    V(F77RU)
C00187   DC    F'4'
C00190   DC    V(F77BKSP)
C00195   DC    V(F77ENDF)
C00201   DC    F'20'
C00206   DC    F'3'
C00211   DC    V(F77WRI)
C00112   DC    H'-3'
C00114   DC    H'-30'
C00116   DC    H'-300'
C00197   DC    H'-4'
C00199   DC    H'-1'
Q00011   DC    C'(A/A)'
Q00015   DC    C'(A)'
Q00025   DC    C'('' >BAD'',I3)'
Q00001   DC    C'DIRECT'
Q00002   DC    C'DIRU PAST END'
Q00003   DC    C'DIRU REWRITE'
Q00004   DC    C'DIRU IN PLACE'
Q00005   DC    C'DIRU NEXTREC'
Q00006   DC    C'DIRECT'
Q00007   DC    C'DIRU REOPEN'
Q00008   DC    C'DIRU REOPEN END'
Q00009   DC    C'DIRECT'
Q00010   DC    C'FORMATTED'
Q00012   DC    C'SECOND'
Q00013   DC    C'THIRD'
Q00014   DC    C'FIRST'
Q00016   DC    C'DIRF SLASH'
Q00017   DC    C'THIRD'
Q00018   DC    C'DIRF FIRST'
Q00019   DC    C'FIRST'
Q00020   DC    C'DIRF NEXTREC'
Q00021   DC    C'SEQ READ'
Q00022   DC    C'SEQ BACKSPACE'
Q00023   DC    C'SEQ TRUNCATE'
Q00024   DC    C'SEQ AFTER EOF'
* CHK
CHK      CSECT
         USING *,15
         B     L00222
         DC    AL1(3),CL7'CHK'
L00222   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00223
L00224   DC    A(S00212)
L00223   L     15,L00224
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00212,13
         ST    1,S00212+72
L00215   DS    0H
         L     6,0(,1)
         L     5,4(,1)
         L     4,8(,1)
         L     3,12(,1)
         LA    3,0(,3)
         L     2,0(,5)
         LTR   2,2
         BC    7,L00216
L00217   DS    0H
         LA    1,P00225
         L     15,C00226
         BALR  14,15
         LR    0,6
         ST    0,P00227+0
         LR    0,3
         ST    0,P00227+4
         LA    1,P00227
         L     15,C00228
         BALR  14,15
         L     15,C00229
         BALR  14,15
         L     2,0(,4)
         A     2,C00230
         ST    2,0(,4)
L00218   DS    0H
L00219   DS    0H
L00220   DS    0H
         LA    0,0
         B     L00221
L00216   DS    0H
         LA    1,P00231
         L     15,C00226
         BALR  14,15
         LR    0,6
         ST    0,P00227+0
         LR    0,3
         ST    0,P00227+4
         LA    1,P00227
         L     15,C00228
         BALR  14,15
         L     15,C00229
         BALR  14,15
         B     L00218
L00221   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00212   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00225   DC    F'6'
         DC    A(Q00214)
P00227   DC    A(0)
         DC    A(0)
P00231   DC    F'6'
         DC    A(Q00213)
C00226   DC    V(F77WRBEG)
C00228   DC    V(F77WRA)
C00229   DC    V(F77WREND)
C00230   DC    F'1'
Q00213   DC    C'('' >'',A,'' OK'')'
Q00214   DC    C'('' >'',A,'' BAD'')'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
