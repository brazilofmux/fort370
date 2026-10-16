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
         LA    0,21
         ST    0,P00094+0
         LA    0,0
         ST    0,P00094+4
         LA    0,0
         ST    0,P00094+8
         LA    0,0
         ST    0,P00094+12
         LA    0,0
         ST    0,P00094+16
         L     0,C00095
         ST    0,P00094+20
         LA    0,6
         ST    0,P00094+24
         LA    0,0
         ST    0,P00094+28
         LA    0,0
         ST    0,P00094+32
         LA    0,0
         ST    0,P00094+36
         LA    0,0
         ST    0,P00094+40
         LA    0,12
         ST    0,P00094+44
         LA    0,0
         ST    0,P00094+48
         LA    1,P00094
         L     15,C00096
         BALR  14,15
L00061   DS    0H
         LA    6,100
         LA    7,500
         LA    2,100
         LA    3,10
         LA    4,1
L00062   DS    0H
         LR    0,4
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00097
         BALR  14,15
         LA    0,21
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00098
         BALR  14,15
         ST    4,T00050
         LA    0,T00050
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00099
         BALR  14,15
         ST    3,T00044
         LA    0,T00044
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00099
         BALR  14,15
         ST    2,T00045
         LA    0,T00045
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00099
         BALR  14,15
         L     15,C00100
         BALR  14,15
L00064   DS    0H
         A     4,C00101
         A     3,C00102
         BXLE  2,6,L00062
L00063   DS    0H
         LA    0,9
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00097
         BALR  14,15
         LA    0,21
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00098
         BALR  14,15
         LA    15,9
         ST    15,T00026
         LA    0,T00026
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00099
         BALR  14,15
         LA    15,90
         ST    15,T00027
         LA    0,T00027
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00099
         BALR  14,15
         LA    15,900
         ST    15,T00028
         LA    0,T00028
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00099
         BALR  14,15
         L     15,C00100
         BALR  14,15
         LA    0,3
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00097
         BALR  14,15
         LA    0,21
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00098
         BALR  14,15
         LH    15,C00103
         ST    15,T00029
         LA    0,T00029
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00099
         BALR  14,15
         LH    15,C00104
         ST    15,T00030
         LA    0,T00030
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00099
         BALR  14,15
         LH    15,C00105
         ST    15,T00031
         LA    0,T00031
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00099
         BALR  14,15
         L     15,C00100
         BALR  14,15
         LA    0,9
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00097
         BALR  14,15
         LA    0,21
         ST    0,P00094+0
         LA    0,0
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00106
         BALR  14,15
         LA    2,4
         LA    3,3
L00065   DS    0H
         C     3,C00107
         BC    2,L00066
L00067   DS    0H
         L     15,C00108
         BALR  14,15
         L     3,T00058
         C     3,C00109
         LA    2,1
         BC    8,L00110
         SR    2,2
L00110   DS    0H
         L     4,T00058+8
         C     4,C00111
         LA    3,1
         BC    8,L00112
         SR    3,3
L00112   DS    0H
         NR    2,3
         ST    2,T00052
         L     0,C00113
         ST    0,P00094+0
         LA    0,T00052
         ST    0,P00094+4
         LA    0,T00049
         ST    0,P00094+8
         LA    0,13
         ST    0,P00094+12
         OI    P00094+12,X'80'
         LA    1,P00094
         L     15,C00114
         BALR  14,15
         LA    0,3
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00097
         BALR  14,15
         LA    0,21
         ST    0,P00094+0
         LA    0,0
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00106
         BALR  14,15
         LA    2,4
         LA    3,3
L00068   DS    0H
         C     3,C00107
         BC    2,L00069
L00070   DS    0H
         L     15,C00108
         BALR  14,15
         L     3,T00058
         C     3,C00115
         LA    2,1
         BC    8,L00116
         SR    2,2
L00116   DS    0H
         L     4,T00058+4
         C     4,C00117
         LA    3,1
         BC    8,L00118
         SR    3,3
L00118   DS    0H
         NR    2,3
         ST    2,T00053
         L     0,C00119
         ST    0,P00094+0
         LA    0,T00053
         ST    0,P00094+4
         LA    0,T00049
         ST    0,P00094+8
         LA    0,12
         ST    0,P00094+12
         OI    P00094+12,X'80'
         LA    1,P00094
         L     15,C00114
         BALR  14,15
         LA    0,5
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00097
         BALR  14,15
         LA    0,21
         ST    0,P00094+0
         LA    0,0
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00106
         BALR  14,15
         LA    2,4
         LA    3,3
L00071   DS    0H
         C     3,C00107
         BC    2,L00072
L00073   DS    0H
         L     15,C00108
         BALR  14,15
         L     3,T00058+4
         C     3,C00120
         LA    2,1
         BC    8,L00121
         SR    2,2
L00121   DS    0H
         ST    2,T00054
         L     0,C00122
         ST    0,P00094+0
         LA    0,T00054
         ST    0,P00094+4
         LA    0,T00049
         ST    0,P00094+8
         LA    0,13
         ST    0,P00094+12
         OI    P00094+12,X'80'
         LA    1,P00094
         L     15,C00114
         BALR  14,15
         LA    0,21
         ST    0,P00094+0
         LA    0,0
         ST    0,P00094+4
         LA    0,0
         ST    0,P00094+8
         LA    1,P00094
         L     15,C00123
         BALR  14,15
         LA    0,13
         ST    0,P00094+0
         LA    0,T00048
         ST    0,P00094+4
         LA    0,0
         ST    0,P00094+8
         LA    1,P00094
         L     15,C00124
         BALR  14,15
         L     3,T00048
         C     3,C00125
         LA    2,1
         BC    8,L00126
         SR    2,2
L00126   DS    0H
         ST    2,T00032
         L     0,C00127
         ST    0,P00094+0
         LA    0,T00032
         ST    0,P00094+4
         LA    0,T00049
         ST    0,P00094+8
         LA    0,12
         ST    0,P00094+12
         OI    P00094+12,X'80'
         LA    1,P00094
         L     15,C00114
         BALR  14,15
         LA    0,21
         ST    0,P00094+0
         LA    0,0
         ST    0,P00094+4
         LA    0,0
         ST    0,P00094+8
         LA    1,P00094
         L     15,C00128
         BALR  14,15
         LA    0,21
         ST    0,P00094+0
         LA    0,0
         ST    0,P00094+4
         LA    0,0
         ST    0,P00094+8
         LA    0,0
         ST    0,P00094+12
         LA    0,0
         ST    0,P00094+16
         L     0,C00129
         ST    0,P00094+20
         LA    0,6
         ST    0,P00094+24
         LA    0,0
         ST    0,P00094+28
         LA    0,0
         ST    0,P00094+32
         LA    0,0
         ST    0,P00094+36
         LA    0,0
         ST    0,P00094+40
         LA    0,12
         ST    0,P00094+44
         LA    0,0
         ST    0,P00094+48
         LA    1,P00094
         L     15,C00096
         BALR  14,15
         LA    0,1
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00097
         BALR  14,15
         LA    0,21
         ST    0,P00094+0
         LA    0,0
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00106
         BALR  14,15
         LA    2,4
         LA    3,3
L00074   DS    0H
         C     3,C00107
         BC    2,L00075
L00076   DS    0H
         L     15,C00108
         BALR  14,15
         L     3,T00058+8
         C     3,C00130
         LA    2,1
         BC    8,L00131
         SR    2,2
L00131   DS    0H
         ST    2,T00055
         L     0,C00132
         ST    0,P00094+0
         LA    0,T00055
         ST    0,P00094+4
         LA    0,T00049
         ST    0,P00094+8
         LA    0,11
         ST    0,P00094+12
         OI    P00094+12,X'80'
         LA    1,P00094
         L     15,C00114
         BALR  14,15
         LA    0,9
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00097
         BALR  14,15
         LA    0,21
         ST    0,P00094+0
         LA    0,0
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00106
         BALR  14,15
         LA    2,4
         LA    3,3
L00077   DS    0H
         C     3,C00107
         BC    2,L00078
L00079   DS    0H
         L     15,C00108
         BALR  14,15
         L     3,T00058+4
         C     3,C00133
         LA    2,1
         BC    8,L00134
         SR    2,2
L00134   DS    0H
         ST    2,T00056
         L     0,C00135
         ST    0,P00094+0
         LA    0,T00056
         ST    0,P00094+4
         LA    0,T00049
         ST    0,P00094+8
         LA    0,15
         ST    0,P00094+12
         OI    P00094+12,X'80'
         LA    1,P00094
         L     15,C00114
         BALR  14,15
         LA    0,21
         ST    0,P00094+0
         LA    0,0
         ST    0,P00094+4
         LA    0,0
         ST    0,P00094+8
         LA    1,P00094
         L     15,C00128
         BALR  14,15
         LA    0,22
         ST    0,P00094+0
         LA    0,0
         ST    0,P00094+4
         LA    0,0
         ST    0,P00094+8
         LA    0,0
         ST    0,P00094+12
         LA    0,0
         ST    0,P00094+16
         L     0,C00136
         ST    0,P00094+20
         LA    0,6
         ST    0,P00094+24
         L     0,C00137
         ST    0,P00094+28
         LA    0,9
         ST    0,P00094+32
         LA    0,0
         ST    0,P00094+36
         LA    0,0
         ST    0,P00094+40
         LA    0,20
         ST    0,P00094+44
         LA    0,0
         ST    0,P00094+48
         LA    1,P00094
         L     15,C00096
         BALR  14,15
         LA    0,2
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00097
         BALR  14,15
         LA    0,22
         ST    0,P00094+0
         L     0,C00138
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00139
         BALR  14,15
         L     0,C00140
         ST    0,P00094+0
         LA    0,6
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00141
         BALR  14,15
         L     0,C00142
         ST    0,P00094+0
         LA    0,5
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00141
         BALR  14,15
         L     15,C00143
         BALR  14,15
L00080   DS    0H
         LA    0,1
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00097
         BALR  14,15
         LA    0,22
         ST    0,P00094+0
         L     0,C00138
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00139
         BALR  14,15
         L     0,C00144
         ST    0,P00094+0
         LA    0,5
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00141
         BALR  14,15
         L     15,C00143
         BALR  14,15
         LA    0,3
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00097
         BALR  14,15
         LA    0,22
         ST    0,P00094+0
         L     0,C00145
         ST    0,P00094+4
         LA    0,0
         ST    0,P00094+8
         LA    1,P00094
         L     15,C00146
         BALR  14,15
         LA    0,T00059
         ST    0,P00094+0
         LA    0,20
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00147
         BALR  14,15
         L     15,C00148
         BALR  14,15
L00081   DS    0H
         LA    0,T00059
         ST    0,P00094+0
         LA    0,20
         ST    0,P00094+4
         L     0,C00149
         ST    0,P00094+8
         LA    0,5
         ST    0,P00094+12
         LA    1,P00094
         L     15,C00150
         BALR  14,15
         LR    3,15
         C     3,C00107
         LA    2,1
         BC    8,L00151
         SR    2,2
L00151   DS    0H
         ST    2,T00033
         L     0,C00152
         ST    0,P00094+0
         LA    0,T00033
         ST    0,P00094+4
         LA    0,T00049
         ST    0,P00094+8
         LA    0,10
         ST    0,P00094+12
         OI    P00094+12,X'80'
         LA    1,P00094
         L     15,C00114
         BALR  14,15
         LA    4,1
         LR    0,4
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00097
         BALR  14,15
         LA    0,22
         ST    0,P00094+0
         L     0,C00145
         ST    0,P00094+4
         LA    0,0
         ST    0,P00094+8
         LA    1,P00094
         L     15,C00146
         BALR  14,15
         LA    0,T00059
         ST    0,P00094+0
         LA    0,20
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00147
         BALR  14,15
         L     15,C00148
         BALR  14,15
         LA    0,T00059
         ST    0,P00094+0
         LA    0,20
         ST    0,P00094+4
         L     0,C00153
         ST    0,P00094+8
         LA    0,5
         ST    0,P00094+12
         LA    1,P00094
         L     15,C00150
         BALR  14,15
         LR    3,15
         C     3,C00107
         LA    2,1
         BC    8,L00154
         SR    2,2
L00154   DS    0H
         ST    2,T00034
         L     0,C00155
         ST    0,P00094+0
         LA    0,T00034
         ST    0,P00094+4
         LA    0,T00049
         ST    0,P00094+8
         LA    0,10
         ST    0,P00094+12
         OI    P00094+12,X'80'
         LA    1,P00094
         L     15,C00114
         BALR  14,15
         LA    0,22
         ST    0,P00094+0
         LA    0,0
         ST    0,P00094+4
         LA    0,0
         ST    0,P00094+8
         LA    1,P00094
         L     15,C00123
         BALR  14,15
         LA    0,13
         ST    0,P00094+0
         LA    0,T00048
         ST    0,P00094+4
         LA    0,0
         ST    0,P00094+8
         LA    1,P00094
         L     15,C00124
         BALR  14,15
         L     3,T00048
         C     3,C00156
         LA    2,1
         BC    8,L00157
         SR    2,2
L00157   DS    0H
         ST    2,T00035
         L     0,C00158
         ST    0,P00094+0
         LA    0,T00035
         ST    0,P00094+4
         LA    0,T00049
         ST    0,P00094+8
         LA    0,12
         ST    0,P00094+12
         OI    P00094+12,X'80'
         LA    1,P00094
         L     15,C00114
         BALR  14,15
         LA    0,22
         ST    0,P00094+0
         LA    0,0
         ST    0,P00094+4
         LA    0,0
         ST    0,P00094+8
         LA    1,P00094
         L     15,C00128
         BALR  14,15
L00082   DS    0H
         LA    5,6
         LR    2,4
L00083   DS    0H
         LA    0,23
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00098
         BALR  14,15
         ST    2,T00051
         LA    0,T00051
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00099
         BALR  14,15
         LR    1,2
         MR    0,2
         LR    3,1
         ST    3,T00046
         LA    0,T00046
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00099
         BALR  14,15
         L     15,C00100
         BALR  14,15
L00085   DS    0H
         BXLE  2,4,L00083
L00084   DS    0H
         LA    0,23
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00159
         BALR  14,15
         LA    0,23
         ST    0,P00094+0
         LA    0,0
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00106
         BALR  14,15
         LA    0,T00057
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00160
         BALR  14,15
         LA    0,T00047
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00160
         BALR  14,15
         L     15,C00108
         BALR  14,15
         LA    0,23
         ST    0,P00094+0
         LA    0,0
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00106
         BALR  14,15
         LA    0,T00057
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00160
         BALR  14,15
         LA    0,T00047
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00160
         BALR  14,15
         L     15,C00108
         BALR  14,15
         L     3,T00057
         C     3,C00156
         LA    2,1
         BC    8,L00161
         SR    2,2
L00161   DS    0H
         L     4,T00047
         C     4,C00162
         LA    3,1
         BC    8,L00163
         SR    3,3
L00163   DS    0H
         NR    2,3
         ST    2,T00036
         L     0,C00164
         ST    0,P00094+0
         LA    0,T00036
         ST    0,P00094+4
         LA    0,T00049
         ST    0,P00094+8
         LA    0,8
         ST    0,P00094+12
         OI    P00094+12,X'80'
         LA    1,P00094
         L     15,C00114
         BALR  14,15
         LA    0,23
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00165
         BALR  14,15
         LA    0,23
         ST    0,P00094+0
         LA    0,0
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00106
         BALR  14,15
         LA    0,T00057
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00160
         BALR  14,15
         LA    0,T00047
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00160
         BALR  14,15
         L     15,C00108
         BALR  14,15
         L     3,T00057
         C     3,C00156
         LA    2,1
         BC    8,L00166
         SR    2,2
L00166   DS    0H
         ST    2,T00037
         L     0,C00167
         ST    0,P00094+0
         LA    0,T00037
         ST    0,P00094+4
         LA    0,T00049
         ST    0,P00094+8
         LA    0,13
         ST    0,P00094+12
         OI    P00094+12,X'80'
         LA    1,P00094
         L     15,C00114
         BALR  14,15
         LA    0,23
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00165
         BALR  14,15
         LA    0,23
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00098
         BALR  14,15
         LA    15,20
         ST    15,T00038
         LA    0,T00038
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00099
         BALR  14,15
         LA    15,400
         ST    15,T00039
         LA    0,T00039
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00099
         BALR  14,15
         L     15,C00100
         BALR  14,15
         LA    0,23
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00168
         BALR  14,15
         LA    0,23
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00159
         BALR  14,15
         LA    15,0
         ST    15,T00048
L00086   DS    0H
         LA    0,23
         ST    0,P00094+0
         LA    0,1
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00106
         BALR  14,15
         LR    2,15
         C     2,C00101
         BC    8,L00088
L00087   DS    0H
         LA    0,T00057
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00160
         BALR  14,15
         LA    0,T00047
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00160
         BALR  14,15
         L     15,C00108
         BALR  14,15
         L     2,T00048
         A     2,C00101
         ST    2,T00048
         B     L00086
L00066   DS    0H
         LR    4,2
         AH    4,C00169
         LA    5,T00058
         AR    5,4
         LR    0,5
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00160
         BALR  14,15
         AH    3,C00170
         A     2,C00162
         B     L00065
L00069   DS    0H
         LR    4,2
         AH    4,C00169
         LA    5,T00058
         AR    5,4
         LR    0,5
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00160
         BALR  14,15
         AH    3,C00170
         A     2,C00162
         B     L00068
L00072   DS    0H
         LR    4,2
         AH    4,C00169
         LA    5,T00058
         AR    5,4
         LR    0,5
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00160
         BALR  14,15
         AH    3,C00170
         A     2,C00162
         B     L00071
L00075   DS    0H
         LR    4,2
         AH    4,C00169
         LA    5,T00058
         AR    5,4
         LR    0,5
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00160
         BALR  14,15
         AH    3,C00170
         A     2,C00162
         B     L00074
L00078   DS    0H
         LR    4,2
         AH    4,C00169
         LA    5,T00058
         AR    5,4
         LR    0,5
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00160
         BALR  14,15
         AH    3,C00170
         A     2,C00162
         B     L00077
L00088   DS    0H
         L     3,T00048
         C     3,C00156
         LA    2,1
         BC    8,L00171
         SR    2,2
L00171   DS    0H
         L     4,T00057
         C     4,C00172
         LA    3,1
         BC    8,L00173
         SR    3,3
L00173   DS    0H
         NR    2,3
         ST    2,T00040
         L     0,C00174
         ST    0,P00094+0
         LA    0,T00040
         ST    0,P00094+4
         LA    0,T00049
         ST    0,P00094+8
         LA    0,12
         ST    0,P00094+12
         OI    P00094+12,X'80'
         LA    1,P00094
         L     15,C00114
         BALR  14,15
         LA    0,23
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00165
         BALR  14,15
         LA    0,23
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00098
         BALR  14,15
         LA    15,3
         ST    15,T00041
         LA    0,T00041
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00099
         BALR  14,15
         LA    15,9
         ST    15,T00042
         LA    0,T00042
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00099
         BALR  14,15
         L     15,C00100
         BALR  14,15
         LA    0,23
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00168
         BALR  14,15
         LA    0,23
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00159
         BALR  14,15
         LA    0,23
         ST    0,P00094+0
         LA    0,0
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00106
         BALR  14,15
         LA    0,T00057
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00160
         BALR  14,15
         L     15,C00108
         BALR  14,15
         LA    0,23
         ST    0,P00094+0
         LA    0,0
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00106
         BALR  14,15
         LA    0,T00057
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00160
         BALR  14,15
         L     15,C00108
         BALR  14,15
         LA    0,23
         ST    0,P00094+0
         LA    0,0
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00106
         BALR  14,15
         LA    0,T00057
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00160
         BALR  14,15
         LA    0,T00047
         ST    0,P00094+0
         LA    0,4
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00160
         BALR  14,15
         L     15,C00108
         BALR  14,15
         L     3,T00057
         C     3,C00175
         LA    2,1
         BC    8,L00176
         SR    2,2
L00176   DS    0H
         L     4,T00047
         C     4,C00109
         LA    3,1
         BC    8,L00177
         SR    3,3
L00177   DS    0H
         NR    2,3
         ST    2,T00043
         L     0,C00178
         ST    0,P00094+0
         LA    0,T00043
         ST    0,P00094+4
         LA    0,T00049
         ST    0,P00094+8
         LA    0,13
         ST    0,P00094+12
         OI    P00094+12,X'80'
         LA    1,P00094
         L     15,C00114
         BALR  14,15
         LA    0,6
         ST    0,P00094+0
         L     0,C00179
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00139
         BALR  14,15
         L     3,T00049
         LR    0,3
         ST    0,P00094+0
         LA    1,P00094
         L     15,C00180
         BALR  14,15
         L     15,C00143
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
P00094   DS    13F
         DS    XL4
C00095   DC    A(Q00001)
C00096   DC    V(F77OPEN)
C00097   DC    V(F77SETRC)
C00098   DC    V(F77WUBEG)
C00099   DC    V(F77WU)
C00100   DC    V(F77WUEND)
C00101   DC    F'1'
C00102   DC    F'10'
C00106   DC    V(F77RUBEG)
C00107   DC    F'0'
C00108   DC    V(F77RUEND)
C00109   DC    F'9'
C00111   DC    F'900'
C00113   DC    A(Q00002)
C00114   DC    V(CHK)
C00115   DC    F'-3'
C00117   DC    F'-30'
C00119   DC    A(Q00003)
C00120   DC    F'50'
C00122   DC    A(Q00004)
C00123   DC    V(F77INQR)
C00124   DC    V(F77INQ)
C00125   DC    F'6'
C00127   DC    A(Q00005)
C00128   DC    V(F77CLOSE)
C00129   DC    A(Q00006)
C00130   DC    F'100'
C00132   DC    A(Q00007)
C00133   DC    F'90'
C00135   DC    A(Q00008)
C00136   DC    A(Q00009)
C00137   DC    A(Q00010)
C00138   DC    A(Q00011)
C00139   DC    V(F77WRBEG)
C00140   DC    A(Q00012)
C00141   DC    V(F77WRA)
C00142   DC    A(Q00013)
C00143   DC    V(F77WREND)
C00144   DC    A(Q00014)
C00145   DC    A(Q00015)
C00146   DC    V(F77RDBEG)
C00147   DC    V(F77RDS)
C00148   DC    V(F77RDEND)
C00149   DC    A(Q00017)
C00150   DC    V(F77STRCM)
C00152   DC    A(Q00016)
C00153   DC    A(Q00019)
C00155   DC    A(Q00018)
C00156   DC    F'2'
C00158   DC    A(Q00020)
C00159   DC    V(F77REWND)
C00160   DC    V(F77RU)
C00162   DC    F'4'
C00164   DC    A(Q00021)
C00165   DC    V(F77BKSP)
C00167   DC    A(Q00022)
C00168   DC    V(F77ENDF)
C00172   DC    F'20'
C00174   DC    A(Q00023)
C00175   DC    F'3'
C00178   DC    A(Q00024)
C00179   DC    A(Q00025)
C00180   DC    V(F77WRI)
C00103   DC    H'-3'
C00104   DC    H'-30'
C00105   DC    H'-300'
C00169   DC    H'-4'
C00170   DC    H'-1'
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
         B     L00191
         DC    AL1(3),CL7'CHK'
L00191   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00192
L00193   DC    A(S00181)
L00192   L     15,L00193
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00181,13
         ST    1,S00181+72
L00184   DS    0H
         L     6,0(,1)
         L     5,4(,1)
         L     4,8(,1)
         L     3,12(,1)
         LA    3,0(,3)
         L     2,0(,5)
         LTR   2,2
         BC    7,L00185
L00186   DS    0H
         LA    0,6
         ST    0,P00194+0
         L     0,C00195
         ST    0,P00194+4
         LA    1,P00194
         L     15,C00196
         BALR  14,15
         LR    0,6
         ST    0,P00194+0
         LR    0,3
         ST    0,P00194+4
         LA    1,P00194
         L     15,C00197
         BALR  14,15
         L     15,C00198
         BALR  14,15
         L     2,0(,4)
         A     2,C00199
         ST    2,0(,4)
L00187   DS    0H
L00188   DS    0H
L00189   DS    0H
         LA    0,0
         B     L00190
L00185   DS    0H
         LA    0,6
         ST    0,P00194+0
         L     0,C00200
         ST    0,P00194+4
         LA    1,P00194
         L     15,C00196
         BALR  14,15
         LR    0,6
         ST    0,P00194+0
         LR    0,3
         ST    0,P00194+4
         LA    1,P00194
         L     15,C00197
         BALR  14,15
         L     15,C00198
         BALR  14,15
         B     L00187
L00190   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00181   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00194   DS    2F
C00195   DC    A(Q00183)
C00196   DC    V(F77WRBEG)
C00197   DC    V(F77WRA)
C00198   DC    V(F77WREND)
C00199   DC    F'1'
C00200   DC    A(Q00182)
Q00182   DC    C'('' >'',A,'' OK'')'
Q00183   DC    C'('' >'',A,'' BAD'')'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
