* main
F77MAIN  CSECT
         USING *,15
         B     L00050
         DC    AL1(7),CL7'F77MAIN'
L00050   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00051
L00052   DC    A(S00000)
L00051   L     15,L00052
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00047   DS    0H
         MVC   T00046(4),C00053
         MVC   T00046+4(4),C00054
         MVC   T00044(8),C00055
         MVC   T00044+8(8),C00056
         LA    15,0
         ST    15,T00045
         L     0,C00058
         ST    0,P00057+0
         LA    0,T00046
         ST    0,P00057+4
         OI    P00057+4,X'80'
         LA    1,P00057
         L     15,C00059
         BALR  14,15
         STE   0,S00000+576
         STE   2,S00000+584
         LE    0,T00046
         STE   0,S00000+592
         LE    0,T00046+4
         STE   0,S00000+600
         LA    0,T00034
         ST    0,P00057+0
         LE    0,S00000+592
         STE   0,P00057+4
         LE    0,S00000+600
         STE   0,P00057+8
         LA    1,P00057
         L     15,C00060
         BALR  14,15
         LE    0,T00034+4
         LE    2,S00000+576
         CE    2,T00034
         LA    2,1
         BC    8,L00061
         SR    2,2
L00061   DS    0H
         LE    2,S00000+584
         CER   2,0
         LA    3,1
         BC    8,L00062
         SR    3,3
L00062   DS    0H
         NR    2,3
         ST    2,T00018
         L     0,C00063
         ST    0,P00057+0
         LA    0,T00018
         ST    0,P00057+4
         LA    0,T00045
         ST    0,P00057+8
         LA    0,6
         ST    0,P00057+12
         OI    P00057+12,X'80'
         LA    1,P00057
         L     15,C00064
         BALR  14,15
         L     0,C00065
         ST    0,P00057+0
         LA    0,T00046
         ST    0,P00057+4
         OI    P00057+4,X'80'
         LA    1,P00057
         L     15,C00059
         BALR  14,15
         STE   0,S00000+576
         STE   2,S00000+584
         LE    0,T00046
         STE   0,S00000+592
         LE    0,T00046+4
         STE   0,S00000+600
         LA    0,T00035
         ST    0,P00057+0
         LE    0,S00000+592
         STE   0,P00057+4
         LE    0,S00000+600
         STE   0,P00057+8
         LA    1,P00057
         L     15,C00066
         BALR  14,15
         LE    0,T00035+4
         LE    2,S00000+576
         CE    2,T00035
         LA    2,1
         BC    8,L00067
         SR    2,2
L00067   DS    0H
         LE    2,S00000+584
         CER   2,0
         LA    3,1
         BC    8,L00068
         SR    3,3
L00068   DS    0H
         NR    2,3
         ST    2,T00019
         L     0,C00069
         ST    0,P00057+0
         LA    0,T00019
         ST    0,P00057+4
         LA    0,T00045
         ST    0,P00057+8
         LA    0,6
         ST    0,P00057+12
         OI    P00057+12,X'80'
         LA    1,P00057
         L     15,C00064
         BALR  14,15
         L     0,C00070
         ST    0,P00057+0
         LA    0,T00046
         ST    0,P00057+4
         OI    P00057+4,X'80'
         LA    1,P00057
         L     15,C00059
         BALR  14,15
         STE   0,S00000+576
         STE   2,S00000+584
         LE    0,T00046
         STE   0,S00000+592
         LE    0,T00046+4
         STE   0,S00000+600
         LA    0,T00036
         ST    0,P00057+0
         LE    0,S00000+592
         STE   0,P00057+4
         LE    0,S00000+600
         STE   0,P00057+8
         LA    1,P00057
         L     15,C00071
         BALR  14,15
         LE    0,T00036+4
         LE    2,S00000+576
         CE    2,T00036
         LA    2,1
         BC    8,L00072
         SR    2,2
L00072   DS    0H
         LE    2,S00000+584
         CER   2,0
         LA    3,1
         BC    8,L00073
         SR    3,3
L00073   DS    0H
         NR    2,3
         ST    2,T00020
         L     0,C00074
         ST    0,P00057+0
         LA    0,T00020
         ST    0,P00057+4
         LA    0,T00045
         ST    0,P00057+8
         LA    0,6
         ST    0,P00057+12
         OI    P00057+12,X'80'
         LA    1,P00057
         L     15,C00064
         BALR  14,15
         L     0,C00075
         ST    0,P00057+0
         LA    0,T00046
         ST    0,P00057+4
         OI    P00057+4,X'80'
         LA    1,P00057
         L     15,C00059
         BALR  14,15
         STE   0,S00000+576
         STE   2,S00000+584
         LE    0,T00046
         STE   0,S00000+592
         LE    0,T00046+4
         STE   0,S00000+600
         LA    0,T00037
         ST    0,P00057+0
         LE    0,S00000+592
         STE   0,P00057+4
         LE    0,S00000+600
         STE   0,P00057+8
         LA    1,P00057
         L     15,C00076
         BALR  14,15
         LE    0,T00037+4
         LE    2,S00000+576
         CE    2,T00037
         LA    2,1
         BC    8,L00077
         SR    2,2
L00077   DS    0H
         LE    2,S00000+584
         CER   2,0
         LA    3,1
         BC    8,L00078
         SR    3,3
L00078   DS    0H
         NR    2,3
         ST    2,T00021
         L     0,C00079
         ST    0,P00057+0
         LA    0,T00021
         ST    0,P00057+4
         LA    0,T00045
         ST    0,P00057+8
         LA    0,6
         ST    0,P00057+12
         OI    P00057+12,X'80'
         LA    1,P00057
         L     15,C00064
         BALR  14,15
         L     0,C00080
         ST    0,P00057+0
         LA    0,T00046
         ST    0,P00057+4
         OI    P00057+4,X'80'
         LA    1,P00057
         L     15,C00059
         BALR  14,15
         STE   0,S00000+576
         STE   2,S00000+584
         LE    0,T00046
         STE   0,S00000+592
         LE    0,T00046+4
         STE   0,S00000+600
         LA    0,T00038
         ST    0,P00057+0
         LE    0,S00000+592
         STE   0,P00057+4
         LE    0,S00000+600
         STE   0,P00057+8
         LA    1,P00057
         L     15,C00081
         BALR  14,15
         LE    0,T00038+4
         LE    2,S00000+576
         CE    2,T00038
         LA    2,1
         BC    8,L00082
         SR    2,2
L00082   DS    0H
         LE    2,S00000+584
         CER   2,0
         LA    3,1
         BC    8,L00083
         SR    3,3
L00083   DS    0H
         NR    2,3
         ST    2,T00022
         L     0,C00084
         ST    0,P00057+0
         LA    0,T00022
         ST    0,P00057+4
         LA    0,T00045
         ST    0,P00057+8
         LA    0,6
         ST    0,P00057+12
         OI    P00057+12,X'80'
         LA    1,P00057
         L     15,C00064
         BALR  14,15
         L     0,C00085
         ST    0,P00057+0
         LA    0,T00046
         ST    0,P00057+4
         OI    P00057+4,X'80'
         LA    1,P00057
         L     15,C00059
         BALR  14,15
         STE   0,S00000+576
         LE    0,T00046+4
         LCER  0,0
         LE    4,S00000+576
         CE    4,T00046
         LA    2,1
         BC    8,L00086
         SR    2,2
L00086   DS    0H
         CER   2,0
         LA    3,1
         BC    8,L00087
         SR    3,3
L00087   DS    0H
         NR    2,3
         ST    2,T00023
         L     0,C00088
         ST    0,P00057+0
         LA    0,T00023
         ST    0,P00057+4
         LA    0,T00045
         ST    0,P00057+8
         LA    0,6
         ST    0,P00057+12
         OI    P00057+12,X'80'
         LA    1,P00057
         L     15,C00064
         BALR  14,15
         L     0,C00089
         ST    0,P00057+0
         LA    0,T00046
         ST    0,P00057+4
         OI    P00057+4,X'80'
         LA    1,P00057
         L     15,C00090
         BALR  14,15
         STE   0,S00000+576
         LE    0,T00046
         STE   0,S00000+584
         LE    0,T00046+4
         STE   0,S00000+592
         LE    0,S00000+584
         STE   0,P00057+0
         LE    0,S00000+592
         STE   0,P00057+4
         LA    1,P00057
         L     15,C00091
         BALR  14,15
         LE    2,S00000+576
         CER   2,0
         LA    2,1
         BC    8,L00092
         SR    2,2
L00092   DS    0H
         ST    2,T00024
         L     0,C00093
         ST    0,P00057+0
         LA    0,T00024
         ST    0,P00057+4
         LA    0,T00045
         ST    0,P00057+8
         LA    0,6
         ST    0,P00057+12
         OI    P00057+12,X'80'
         LA    1,P00057
         L     15,C00064
         BALR  14,15
         L     0,C00094
         ST    0,P00057+0
         LA    0,T00046
         ST    0,P00057+4
         OI    P00057+4,X'80'
         LA    1,P00057
         L     15,C00090
         BALR  14,15
         CE    0,T00046+4
         LA    2,1
         BC    8,L00095
         SR    2,2
L00095   DS    0H
         ST    2,T00025
         L     0,C00096
         ST    0,P00057+0
         LA    0,T00025
         ST    0,P00057+4
         LA    0,T00045
         ST    0,P00057+8
         LA    0,6
         ST    0,P00057+12
         OI    P00057+12,X'80'
         LA    1,P00057
         L     15,C00064
         BALR  14,15
         L     0,C00097
         ST    0,P00057+0
         LA    0,T00044
         ST    0,P00057+4
         OI    P00057+4,X'80'
         LA    1,P00057
         L     15,C00098
         BALR  14,15
         STD   0,S00000+576
         STD   2,S00000+584
         LD    0,T00044
         STD   0,S00000+592
         LD    0,T00044+8
         STD   0,S00000+600
         LD    0,S00000+592
         STD   0,P00057+0
         LD    0,S00000+600
         STD   0,P00057+8
         LA    0,T00039
         ST    0,P00057+16
         LA    1,P00057
         L     15,C00099
         BALR  14,15
         LD    0,T00039+8
         LD    2,S00000+576
         CD    2,T00039
         LA    2,1
         BC    8,L00100
         SR    2,2
L00100   DS    0H
         LD    2,S00000+584
         CDR   2,0
         LA    3,1
         BC    8,L00101
         SR    3,3
L00101   DS    0H
         NR    2,3
         ST    2,T00026
         L     0,C00102
         ST    0,P00057+0
         LA    0,T00026
         ST    0,P00057+4
         LA    0,T00045
         ST    0,P00057+8
         LA    0,6
         ST    0,P00057+12
         OI    P00057+12,X'80'
         LA    1,P00057
         L     15,C00064
         BALR  14,15
         L     0,C00103
         ST    0,P00057+0
         LA    0,T00044
         ST    0,P00057+4
         OI    P00057+4,X'80'
         LA    1,P00057
         L     15,C00098
         BALR  14,15
         STD   0,S00000+576
         STD   2,S00000+584
         LD    0,T00044
         STD   0,S00000+592
         LD    0,T00044+8
         STD   0,S00000+600
         LD    0,S00000+592
         STD   0,P00057+0
         LD    0,S00000+600
         STD   0,P00057+8
         LA    0,T00040
         ST    0,P00057+16
         LA    1,P00057
         L     15,C00104
         BALR  14,15
         LD    0,T00040+8
         LD    2,S00000+576
         CD    2,T00040
         LA    2,1
         BC    8,L00105
         SR    2,2
L00105   DS    0H
         LD    2,S00000+584
         CDR   2,0
         LA    3,1
         BC    8,L00106
         SR    3,3
L00106   DS    0H
         NR    2,3
         ST    2,T00027
         L     0,C00107
         ST    0,P00057+0
         LA    0,T00027
         ST    0,P00057+4
         LA    0,T00045
         ST    0,P00057+8
         LA    0,6
         ST    0,P00057+12
         OI    P00057+12,X'80'
         LA    1,P00057
         L     15,C00064
         BALR  14,15
         L     0,C00108
         ST    0,P00057+0
         LA    0,T00044
         ST    0,P00057+4
         OI    P00057+4,X'80'
         LA    1,P00057
         L     15,C00098
         BALR  14,15
         STD   0,S00000+576
         STD   2,S00000+584
         LD    0,T00044
         STD   0,S00000+592
         LD    0,T00044+8
         STD   0,S00000+600
         LD    0,S00000+592
         STD   0,P00057+0
         LD    0,S00000+600
         STD   0,P00057+8
         LA    0,T00041
         ST    0,P00057+16
         LA    1,P00057
         L     15,C00109
         BALR  14,15
         LD    0,T00041+8
         LD    2,S00000+576
         CD    2,T00041
         LA    2,1
         BC    8,L00110
         SR    2,2
L00110   DS    0H
         LD    2,S00000+584
         CDR   2,0
         LA    3,1
         BC    8,L00111
         SR    3,3
L00111   DS    0H
         NR    2,3
         ST    2,T00028
         L     0,C00112
         ST    0,P00057+0
         LA    0,T00028
         ST    0,P00057+4
         LA    0,T00045
         ST    0,P00057+8
         LA    0,6
         ST    0,P00057+12
         OI    P00057+12,X'80'
         LA    1,P00057
         L     15,C00064
         BALR  14,15
         L     0,C00113
         ST    0,P00057+0
         LA    0,T00044
         ST    0,P00057+4
         OI    P00057+4,X'80'
         LA    1,P00057
         L     15,C00098
         BALR  14,15
         STD   0,S00000+576
         STD   2,S00000+584
         LD    0,T00044
         STD   0,S00000+592
         LD    0,T00044+8
         STD   0,S00000+600
         LD    0,S00000+592
         STD   0,P00057+0
         LD    0,S00000+600
         STD   0,P00057+8
         LA    0,T00042
         ST    0,P00057+16
         LA    1,P00057
         L     15,C00114
         BALR  14,15
         LD    0,T00042+8
         LD    2,S00000+576
         CD    2,T00042
         LA    2,1
         BC    8,L00115
         SR    2,2
L00115   DS    0H
         LD    2,S00000+584
         CDR   2,0
         LA    3,1
         BC    8,L00116
         SR    3,3
L00116   DS    0H
         NR    2,3
         ST    2,T00029
         L     0,C00117
         ST    0,P00057+0
         LA    0,T00029
         ST    0,P00057+4
         LA    0,T00045
         ST    0,P00057+8
         LA    0,6
         ST    0,P00057+12
         OI    P00057+12,X'80'
         LA    1,P00057
         L     15,C00064
         BALR  14,15
         L     0,C00118
         ST    0,P00057+0
         LA    0,T00044
         ST    0,P00057+4
         OI    P00057+4,X'80'
         LA    1,P00057
         L     15,C00098
         BALR  14,15
         STD   0,S00000+576
         STD   2,S00000+584
         LD    0,T00044
         STD   0,S00000+592
         LD    0,T00044+8
         STD   0,S00000+600
         LD    0,S00000+592
         STD   0,P00057+0
         LD    0,S00000+600
         STD   0,P00057+8
         LA    0,T00043
         ST    0,P00057+16
         LA    1,P00057
         L     15,C00119
         BALR  14,15
         LD    0,T00043+8
         LD    2,S00000+576
         CD    2,T00043
         LA    2,1
         BC    8,L00120
         SR    2,2
L00120   DS    0H
         LD    2,S00000+584
         CDR   2,0
         LA    3,1
         BC    8,L00121
         SR    3,3
L00121   DS    0H
         NR    2,3
         ST    2,T00030
         L     0,C00122
         ST    0,P00057+0
         LA    0,T00030
         ST    0,P00057+4
         LA    0,T00045
         ST    0,P00057+8
         LA    0,6
         ST    0,P00057+12
         OI    P00057+12,X'80'
         LA    1,P00057
         L     15,C00064
         BALR  14,15
         L     0,C00123
         ST    0,P00057+0
         LA    0,T00044
         ST    0,P00057+4
         OI    P00057+4,X'80'
         LA    1,P00057
         L     15,C00098
         BALR  14,15
         STD   0,S00000+576
         LD    0,T00044+8
         LCDR  0,0
         LD    4,S00000+576
         CD    4,T00044
         LA    2,1
         BC    8,L00124
         SR    2,2
L00124   DS    0H
         CDR   2,0
         LA    3,1
         BC    8,L00125
         SR    3,3
L00125   DS    0H
         NR    2,3
         ST    2,T00031
         L     0,C00126
         ST    0,P00057+0
         LA    0,T00031
         ST    0,P00057+4
         LA    0,T00045
         ST    0,P00057+8
         LA    0,6
         ST    0,P00057+12
         OI    P00057+12,X'80'
         LA    1,P00057
         L     15,C00064
         BALR  14,15
         L     0,C00127
         ST    0,P00057+0
         LA    0,T00044
         ST    0,P00057+4
         OI    P00057+4,X'80'
         LA    1,P00057
         L     15,C00128
         BALR  14,15
         STD   0,S00000+576
         LD    0,T00044
         STD   0,S00000+584
         LD    0,T00044+8
         STD   0,S00000+592
         LD    0,S00000+584
         STD   0,P00057+0
         LD    0,S00000+592
         STD   0,P00057+8
         LA    1,P00057
         L     15,C00129
         BALR  14,15
         LD    2,S00000+576
         CDR   2,0
         LA    2,1
         BC    8,L00130
         SR    2,2
L00130   DS    0H
         ST    2,T00032
         L     0,C00131
         ST    0,P00057+0
         LA    0,T00032
         ST    0,P00057+4
         LA    0,T00045
         ST    0,P00057+8
         LA    0,6
         ST    0,P00057+12
         OI    P00057+12,X'80'
         LA    1,P00057
         L     15,C00064
         BALR  14,15
         L     0,C00132
         ST    0,P00057+0
         LA    0,T00044
         ST    0,P00057+4
         OI    P00057+4,X'80'
         LA    1,P00057
         L     15,C00128
         BALR  14,15
         CD    0,T00044+8
         LA    2,1
         BC    8,L00133
         SR    2,2
L00133   DS    0H
         ST    2,T00033
         L     0,C00134
         ST    0,P00057+0
         LA    0,T00033
         ST    0,P00057+4
         LA    0,T00045
         ST    0,P00057+8
         LA    0,6
         ST    0,P00057+12
         OI    P00057+12,X'80'
         LA    1,P00057
         L     15,C00064
         BALR  14,15
         LA    0,T00045
         ST    0,P00057+0
         OI    P00057+0,X'80'
         LA    1,P00057
         L     15,C00135
         BALR  14,15
         LA    0,T00045
         ST    0,P00057+0
         OI    P00057+0,X'80'
         LA    1,P00057
         L     15,C00136
         BALR  14,15
         LA    0,6
         ST    0,P00057+0
         L     0,C00137
         ST    0,P00057+4
         LA    1,P00057
         L     15,C00138
         BALR  14,15
         L     3,T00045
         LR    0,3
         ST    0,P00057+0
         LA    1,P00057
         L     15,C00139
         BALR  14,15
         L     15,C00140
         BALR  14,15
L00048   DS    0H
L00049   DS    0H
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
T00018   DS    XL4
         DS    XL4
T00019   DS    XL4
         DS    XL4
T00020   DS    XL4
         DS    XL4
T00021   DS    XL4
         DS    XL4
T00022   DS    XL4
         DS    XL4
T00023   DS    XL4
         DS    XL4
T00024   DS    XL4
         DS    XL4
T00025   DS    XL4
         DS    XL4
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
T00034   DS    XL8
T00035   DS    XL8
T00036   DS    XL8
T00037   DS    XL8
T00038   DS    XL8
T00039   DS    XL16
T00040   DS    XL16
T00041   DS    XL16
T00042   DS    XL16
T00043   DS    XL16
T00044   DS    XL32
T00045   DS    XL40
T00046   DS    XL76
         DS    XL4
         DS    4D
P00057   DS    5F
         DS    XL4
C00055   DC    X'4080000000000000'
C00056   DC    X'4114000000000000'
C00053   DC    X'40800000'
C00054   DC    X'41140000'
C00058   DC    V(I#CSQRT)
C00059   DC    V(CAPPLY)
C00060   DC    V(F77CSQRT)
C00063   DC    A(Q00001)
C00064   DC    V(CHK)
C00065   DC    V(I#CEXP)
C00066   DC    V(F77CEXP)
C00069   DC    A(Q00002)
C00070   DC    V(I#CLOG)
C00071   DC    V(F77CLOG)
C00074   DC    A(Q00003)
C00075   DC    V(I#CSIN)
C00076   DC    V(F77CSIN)
C00079   DC    A(Q00004)
C00080   DC    V(I#CCOS)
C00081   DC    V(F77CCOS)
C00084   DC    A(Q00005)
C00085   DC    V(I#CONJG)
C00088   DC    A(Q00006)
C00089   DC    V(I#CABS)
C00090   DC    V(RAPPLY)
C00091   DC    V(F77CABS)
C00093   DC    A(Q00007)
C00094   DC    V(I#AIMAG)
C00096   DC    A(Q00008)
C00097   DC    V(I#CDSQRT)
C00098   DC    V(ZAPPLY)
C00099   DC    V(F77ZSQRT)
C00102   DC    A(Q00009)
C00103   DC    V(I#CDEXP)
C00104   DC    V(F77ZEXP)
C00107   DC    A(Q00010)
C00108   DC    V(I#CDLOG)
C00109   DC    V(F77ZLOG)
C00112   DC    A(Q00011)
C00113   DC    V(I#CDSIN)
C00114   DC    V(F77ZSIN)
C00117   DC    A(Q00012)
C00118   DC    V(I#CDCOS)
C00119   DC    V(F77ZCOS)
C00122   DC    A(Q00013)
C00123   DC    V(I#DCONJG)
C00126   DC    A(Q00014)
C00127   DC    V(I#CDABS)
C00128   DC    V(DAPPLY)
C00129   DC    V(F77ZABS)
C00131   DC    A(Q00015)
C00132   DC    V(I#DIMAG)
C00134   DC    A(Q00016)
C00135   DC    V(REALS)
C00136   DC    V(OLDWAY)
C00137   DC    A(Q00017)
C00138   DC    V(F77WRBEG)
C00139   DC    V(F77WRI)
C00140   DC    V(F77WREND)
Q00017   DC    C'('' >BAD '',I2)'
Q00001   DC    C'CSQRT '
Q00002   DC    C'CEXP  '
Q00003   DC    C'CLOG  '
Q00004   DC    C'CSIN  '
Q00005   DC    C'CCOS  '
Q00006   DC    C'CONJG '
Q00007   DC    C'CABS  '
Q00008   DC    C'AIMAG '
Q00009   DC    C'CDSQRT'
Q00010   DC    C'CDEXP '
Q00011   DC    C'CDLOG '
Q00012   DC    C'CDSIN '
Q00013   DC    C'CDCOS '
Q00014   DC    C'DCONJG'
Q00015   DC    C'CDABS '
Q00016   DC    C'DIMAG '
* REALS
REALS    CSECT
         USING *,15
         B     L00207
         DC    AL1(5),CL7'REALS'
L00207   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00208
L00209   DC    A(S00141)
L00208   L     15,L00209
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00141,13
         ST    1,S00141+72
L00170   DS    0H
         L     6,0(,1)
         LA    6,0(,6)
L00171   DS    0H
         LA    4,4
         LA    5,52
         LA    2,4
L00172   DS    0H
         LA    15,0
         ST    15,T00169-4(2)
L00174   DS    0H
         BXLE  2,4,L00172
L00173   DS    0H
         LA    4,1
L00175   DS    0H
         LA    5,10
         LR    2,4
L00176   DS    0H
         LE    0,C00210
         LR    0,2
         X     0,C00211
         ST    0,S00141+84
         LD    2,S00141+80
         SD    2,C00212
         LER   2,2
         MER   0,2
         STE   0,T00167
         L     0,C00214
         ST    0,P00213+0
         LA    0,T00167
         ST    0,P00213+4
         OI    P00213+4,X'80'
         LA    1,P00213
         L     15,C00215
         BALR  14,15
         STE   0,S00141+416
         LE    0,T00167
         STE   0,S00141+424
         LE    0,S00141+424
         STE   0,P00213+0
         XC    P00213+4(4),P00213+4
         LA    1,P00213
         L     15,C00216
         BALR  14,15
         LE    2,S00141+416
         CER   2,0
         LA    7,1
         BC    8,L00217
         SR    7,7
L00217   DS    0H
         LTR   7,7
         LA    3,1
         BC    8,L00218
         SR    3,3
L00218   DS    0H
         LTR   3,3
         BC    8,L00179
L00178   DS    0H
         L     3,T00169
         A     3,C00219
         ST    3,T00169
L00179   DS    0H
         L     0,C00220
         ST    0,P00213+0
         LA    0,T00167
         ST    0,P00213+4
         OI    P00213+4,X'80'
         LA    1,P00213
         L     15,C00215
         BALR  14,15
         STE   0,S00141+416
         LE    0,T00167
         STE   0,S00141+424
         LE    0,S00141+424
         STE   0,P00213+0
         XC    P00213+4(4),P00213+4
         LA    1,P00213
         L     15,C00221
         BALR  14,15
         LE    2,S00141+416
         CER   2,0
         LA    7,1
         BC    8,L00222
         SR    7,7
L00222   DS    0H
         LTR   7,7
         LA    3,1
         BC    8,L00223
         SR    3,3
L00223   DS    0H
         LTR   3,3
         BC    8,L00181
L00180   DS    0H
         L     3,T00169+4
         A     3,C00219
         ST    3,T00169+4
L00181   DS    0H
         L     0,C00224
         ST    0,P00213+0
         LA    0,T00167
         ST    0,P00213+4
         OI    P00213+4,X'80'
         LA    1,P00213
         L     15,C00215
         BALR  14,15
         STE   0,S00141+416
         LE    0,T00167
         STE   0,S00141+424
         LE    0,S00141+424
         STE   0,P00213+0
         XC    P00213+4(4),P00213+4
         LA    1,P00213
         L     15,C00225
         BALR  14,15
         LE    2,S00141+416
         CER   2,0
         LA    7,1
         BC    8,L00226
         SR    7,7
L00226   DS    0H
         LTR   7,7
         LA    3,1
         BC    8,L00227
         SR    3,3
L00227   DS    0H
         LTR   3,3
         BC    8,L00183
L00182   DS    0H
         L     3,T00169+8
         A     3,C00219
         ST    3,T00169+8
L00183   DS    0H
         L     0,C00228
         ST    0,P00213+0
         LA    0,T00167
         ST    0,P00213+4
         OI    P00213+4,X'80'
         LA    1,P00213
         L     15,C00215
         BALR  14,15
         STE   0,S00141+416
         LE    0,T00167
         STE   0,S00141+424
         LE    0,S00141+424
         STE   0,P00213+0
         XC    P00213+4(4),P00213+4
         LA    1,P00213
         L     15,C00229
         BALR  14,15
         LE    2,S00141+416
         CER   2,0
         LA    7,1
         BC    8,L00230
         SR    7,7
L00230   DS    0H
         LTR   7,7
         LA    3,1
         BC    8,L00231
         SR    3,3
L00231   DS    0H
         LTR   3,3
         BC    8,L00185
L00184   DS    0H
         L     3,T00169+12
         A     3,C00219
         ST    3,T00169+12
L00185   DS    0H
         L     0,C00232
         ST    0,P00213+0
         LA    0,T00167
         ST    0,P00213+4
         OI    P00213+4,X'80'
         LA    1,P00213
         L     15,C00215
         BALR  14,15
         STE   0,S00141+416
         LE    0,T00167
         STE   0,S00141+424
         LE    0,S00141+424
         STE   0,P00213+0
         XC    P00213+4(4),P00213+4
         LA    1,P00213
         L     15,C00233
         BALR  14,15
         LE    2,S00141+416
         CER   2,0
         LA    7,1
         BC    8,L00234
         SR    7,7
L00234   DS    0H
         LTR   7,7
         LA    3,1
         BC    8,L00235
         SR    3,3
L00235   DS    0H
         LTR   3,3
         BC    8,L00187
L00186   DS    0H
         L     3,T00169+16
         A     3,C00219
         ST    3,T00169+16
L00187   DS    0H
         L     0,C00236
         ST    0,P00213+0
         LA    0,T00167
         ST    0,P00213+4
         OI    P00213+4,X'80'
         LA    1,P00213
         L     15,C00215
         BALR  14,15
         STE   0,S00141+416
         LE    0,T00167
         STE   0,S00141+424
         LE    0,S00141+424
         STE   0,P00213+0
         XC    P00213+4(4),P00213+4
         LA    1,P00213
         L     15,C00237
         BALR  14,15
         LE    2,S00141+416
         CER   2,0
         LA    7,1
         BC    8,L00238
         SR    7,7
L00238   DS    0H
         LTR   7,7
         LA    3,1
         BC    8,L00239
         SR    3,3
L00239   DS    0H
         LTR   3,3
         BC    8,L00189
L00188   DS    0H
         L     3,T00169+20
         A     3,C00219
         ST    3,T00169+20
L00189   DS    0H
         L     0,C00240
         ST    0,P00213+0
         LA    0,T00167
         ST    0,P00213+4
         OI    P00213+4,X'80'
         LA    1,P00213
         L     15,C00215
         BALR  14,15
         STE   0,S00141+416
         LE    0,T00167
         STE   0,S00141+424
         LE    0,S00141+424
         STE   0,P00213+0
         XC    P00213+4(4),P00213+4
         LA    1,P00213
         L     15,C00241
         BALR  14,15
         LE    2,S00141+416
         CER   2,0
         LA    7,1
         BC    8,L00242
         SR    7,7
L00242   DS    0H
         LTR   7,7
         LA    3,1
         BC    8,L00243
         SR    3,3
L00243   DS    0H
         LTR   3,3
         BC    8,L00191
L00190   DS    0H
         L     3,T00169+24
         A     3,C00219
         ST    3,T00169+24
L00191   DS    0H
         L     0,C00244
         ST    0,P00213+0
         LA    0,T00167
         ST    0,P00213+4
         OI    P00213+4,X'80'
         LA    1,P00213
         L     15,C00215
         BALR  14,15
         STE   0,S00141+416
         LE    0,T00167
         STE   0,S00141+424
         LE    0,S00141+424
         STE   0,P00213+0
         XC    P00213+4(4),P00213+4
         LA    1,P00213
         L     15,C00245
         BALR  14,15
         LE    2,S00141+416
         CER   2,0
         LA    7,1
         BC    8,L00246
         SR    7,7
L00246   DS    0H
         LTR   7,7
         LA    3,1
         BC    8,L00247
         SR    3,3
L00247   DS    0H
         LTR   3,3
         BC    8,L00193
L00192   DS    0H
         L     3,T00169+28
         A     3,C00219
         ST    3,T00169+28
L00193   DS    0H
         L     0,C00248
         ST    0,P00213+0
         LA    0,T00167
         ST    0,P00213+4
         OI    P00213+4,X'80'
         LA    1,P00213
         L     15,C00215
         BALR  14,15
         STE   0,S00141+416
         LE    0,T00167
         STE   0,S00141+424
         LE    0,S00141+424
         STE   0,P00213+0
         XC    P00213+4(4),P00213+4
         LA    1,P00213
         L     15,C00249
         BALR  14,15
         LE    2,S00141+416
         CER   2,0
         LA    7,1
         BC    8,L00250
         SR    7,7
L00250   DS    0H
         LTR   7,7
         LA    3,1
         BC    8,L00251
         SR    3,3
L00251   DS    0H
         LTR   3,3
         BC    8,L00195
L00194   DS    0H
         L     3,T00169+32
         A     3,C00219
         ST    3,T00169+32
L00195   DS    0H
         L     0,C00252
         ST    0,P00213+0
         LA    0,T00167
         ST    0,P00213+4
         OI    P00213+4,X'80'
         LA    1,P00213
         L     15,C00215
         BALR  14,15
         STE   0,S00141+416
         LE    0,T00167
         STE   0,S00141+424
         LE    0,S00141+424
         STE   0,P00213+0
         XC    P00213+4(4),P00213+4
         LA    1,P00213
         L     15,C00253
         BALR  14,15
         LE    2,S00141+416
         CER   2,0
         LA    7,1
         BC    8,L00254
         SR    7,7
L00254   DS    0H
         LTR   7,7
         LA    3,1
         BC    8,L00255
         SR    3,3
L00255   DS    0H
         LTR   3,3
         BC    8,L00197
L00196   DS    0H
         L     3,T00169+36
         A     3,C00219
         ST    3,T00169+36
L00197   DS    0H
         L     0,C00256
         ST    0,P00213+0
         LA    0,T00167
         ST    0,P00213+4
         OI    P00213+4,X'80'
         LA    1,P00213
         L     15,C00215
         BALR  14,15
         STE   0,S00141+416
         LE    0,T00167
         STE   0,S00141+424
         LE    0,S00141+424
         STE   0,P00213+0
         XC    P00213+4(4),P00213+4
         LA    1,P00213
         L     15,C00257
         BALR  14,15
         LE    2,S00141+416
         CER   2,0
         LA    7,1
         BC    8,L00258
         SR    7,7
L00258   DS    0H
         LTR   7,7
         LA    3,1
         BC    8,L00259
         SR    3,3
L00259   DS    0H
         LTR   3,3
         BC    8,L00199
L00198   DS    0H
         L     3,T00169+40
         A     3,C00219
         ST    3,T00169+40
L00199   DS    0H
         L     0,C00260
         ST    0,P00213+0
         LA    0,T00167
         ST    0,P00213+4
         OI    P00213+4,X'80'
         LA    1,P00213
         L     15,C00215
         BALR  14,15
         STE   0,S00141+416
         LE    0,T00167
         STE   0,S00141+424
         LE    0,S00141+424
         STE   0,P00213+0
         XC    P00213+4(4),P00213+4
         LA    1,P00213
         L     15,C00261
         BALR  14,15
         LE    2,S00141+416
         CER   2,0
         LA    7,1
         BC    8,L00262
         SR    7,7
L00262   DS    0H
         LTR   7,7
         LA    3,1
         BC    8,L00263
         SR    3,3
L00263   DS    0H
         LTR   3,3
         BC    8,L00201
L00200   DS    0H
         L     3,T00169+44
         A     3,C00219
         ST    3,T00169+44
L00201   DS    0H
         L     0,C00264
         ST    0,P00213+0
         LA    0,T00167
         ST    0,P00213+4
         OI    P00213+4,X'80'
         LA    1,P00213
         L     15,C00215
         BALR  14,15
         STE   0,S00141+416
         LE    0,T00167
         STE   0,S00141+424
         LE    0,S00141+424
         STE   0,P00213+0
         XC    P00213+4(4),P00213+4
         LA    1,P00213
         L     15,C00265
         BALR  14,15
         LE    2,S00141+416
         CER   2,0
         LA    7,1
         BC    8,L00266
         SR    7,7
L00266   DS    0H
         LTR   7,7
         LA    3,1
         BC    8,L00267
         SR    3,3
L00267   DS    0H
         LTR   3,3
         BC    8,L00203
L00202   DS    0H
         L     3,T00169+48
         A     3,C00219
         ST    3,T00169+48
L00203   DS    0H
L00204   DS    0H
         BXLE  2,4,L00176
L00177   DS    0H
         L     3,T00169
         C     3,C00268
         LA    2,1
         BC    8,L00269
         SR    2,2
L00269   DS    0H
         ST    2,T00168
         L     0,C00270
         ST    0,P00213+0
         LA    0,T00168
         ST    0,P00213+4
         LR    0,6
         ST    0,P00213+8
         LA    0,6
         ST    0,P00213+12
         OI    P00213+12,X'80'
         LA    1,P00213
         L     15,C00271
         BALR  14,15
         L     3,T00169+4
         C     3,C00268
         LA    2,1
         BC    8,L00272
         SR    2,2
L00272   DS    0H
         ST    2,T00155
         L     0,C00273
         ST    0,P00213+0
         LA    0,T00155
         ST    0,P00213+4
         LR    0,6
         ST    0,P00213+8
         LA    0,6
         ST    0,P00213+12
         OI    P00213+12,X'80'
         LA    1,P00213
         L     15,C00271
         BALR  14,15
         L     3,T00169+8
         C     3,C00268
         LA    2,1
         BC    8,L00274
         SR    2,2
L00274   DS    0H
         ST    2,T00156
         L     0,C00275
         ST    0,P00213+0
         LA    0,T00156
         ST    0,P00213+4
         LR    0,6
         ST    0,P00213+8
         LA    0,6
         ST    0,P00213+12
         OI    P00213+12,X'80'
         LA    1,P00213
         L     15,C00271
         BALR  14,15
         L     3,T00169+12
         C     3,C00268
         LA    2,1
         BC    8,L00276
         SR    2,2
L00276   DS    0H
         ST    2,T00157
         L     0,C00277
         ST    0,P00213+0
         LA    0,T00157
         ST    0,P00213+4
         LR    0,6
         ST    0,P00213+8
         LA    0,6
         ST    0,P00213+12
         OI    P00213+12,X'80'
         LA    1,P00213
         L     15,C00271
         BALR  14,15
         L     3,T00169+16
         C     3,C00268
         LA    2,1
         BC    8,L00278
         SR    2,2
L00278   DS    0H
         ST    2,T00158
         L     0,C00279
         ST    0,P00213+0
         LA    0,T00158
         ST    0,P00213+4
         LR    0,6
         ST    0,P00213+8
         LA    0,6
         ST    0,P00213+12
         OI    P00213+12,X'80'
         LA    1,P00213
         L     15,C00271
         BALR  14,15
         L     3,T00169+20
         C     3,C00268
         LA    2,1
         BC    8,L00280
         SR    2,2
L00280   DS    0H
         ST    2,T00159
         L     0,C00281
         ST    0,P00213+0
         LA    0,T00159
         ST    0,P00213+4
         LR    0,6
         ST    0,P00213+8
         LA    0,6
         ST    0,P00213+12
         OI    P00213+12,X'80'
         LA    1,P00213
         L     15,C00271
         BALR  14,15
         L     3,T00169+24
         C     3,C00268
         LA    2,1
         BC    8,L00282
         SR    2,2
L00282   DS    0H
         ST    2,T00160
         L     0,C00283
         ST    0,P00213+0
         LA    0,T00160
         ST    0,P00213+4
         LR    0,6
         ST    0,P00213+8
         LA    0,6
         ST    0,P00213+12
         OI    P00213+12,X'80'
         LA    1,P00213
         L     15,C00271
         BALR  14,15
         L     3,T00169+28
         C     3,C00268
         LA    2,1
         BC    8,L00284
         SR    2,2
L00284   DS    0H
         ST    2,T00161
         L     0,C00285
         ST    0,P00213+0
         LA    0,T00161
         ST    0,P00213+4
         LR    0,6
         ST    0,P00213+8
         LA    0,6
         ST    0,P00213+12
         OI    P00213+12,X'80'
         LA    1,P00213
         L     15,C00271
         BALR  14,15
         L     3,T00169+32
         C     3,C00268
         LA    2,1
         BC    8,L00286
         SR    2,2
L00286   DS    0H
         ST    2,T00162
         L     0,C00287
         ST    0,P00213+0
         LA    0,T00162
         ST    0,P00213+4
         LR    0,6
         ST    0,P00213+8
         LA    0,6
         ST    0,P00213+12
         OI    P00213+12,X'80'
         LA    1,P00213
         L     15,C00271
         BALR  14,15
         L     3,T00169+36
         C     3,C00268
         LA    2,1
         BC    8,L00288
         SR    2,2
L00288   DS    0H
         ST    2,T00163
         L     0,C00289
         ST    0,P00213+0
         LA    0,T00163
         ST    0,P00213+4
         LR    0,6
         ST    0,P00213+8
         LA    0,6
         ST    0,P00213+12
         OI    P00213+12,X'80'
         LA    1,P00213
         L     15,C00271
         BALR  14,15
         L     3,T00169+40
         C     3,C00268
         LA    2,1
         BC    8,L00290
         SR    2,2
L00290   DS    0H
         ST    2,T00164
         L     0,C00291
         ST    0,P00213+0
         LA    0,T00164
         ST    0,P00213+4
         LR    0,6
         ST    0,P00213+8
         LA    0,6
         ST    0,P00213+12
         OI    P00213+12,X'80'
         LA    1,P00213
         L     15,C00271
         BALR  14,15
         L     3,T00169+44
         C     3,C00268
         LA    2,1
         BC    8,L00292
         SR    2,2
L00292   DS    0H
         ST    2,T00165
         L     0,C00293
         ST    0,P00213+0
         LA    0,T00165
         ST    0,P00213+4
         LR    0,6
         ST    0,P00213+8
         LA    0,6
         ST    0,P00213+12
         OI    P00213+12,X'80'
         LA    1,P00213
         L     15,C00271
         BALR  14,15
         L     3,T00169+48
         C     3,C00268
         LA    2,1
         BC    8,L00294
         SR    2,2
L00294   DS    0H
         ST    2,T00166
         L     0,C00295
         ST    0,P00213+0
         LA    0,T00166
         ST    0,P00213+4
         LR    0,6
         ST    0,P00213+8
         LA    0,6
         ST    0,P00213+12
         OI    P00213+12,X'80'
         LA    1,P00213
         L     15,C00271
         BALR  14,15
         LA    0,0
         B     L00206
L00205   DS    0H
L00206   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00141   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00155   DS    XL4
         DS    XL4
T00156   DS    XL4
         DS    XL4
T00157   DS    XL4
         DS    XL4
T00158   DS    XL4
         DS    XL4
T00159   DS    XL4
         DS    XL4
T00160   DS    XL4
         DS    XL4
T00161   DS    XL4
         DS    XL4
T00162   DS    XL4
         DS    XL4
T00163   DS    XL4
         DS    XL4
T00164   DS    XL4
         DS    XL4
T00165   DS    XL4
         DS    XL4
T00166   DS    XL4
         DS    XL4
T00167   DS    XL8
T00168   DS    XL12
         DS    XL4
T00169   DS    XL116
         DS    XL4
         DS    2D
P00213   DS    4F
C00212   DC    X'4E00000080000000'
C00210   DC    X'4017FCB9'
C00211   DC    F'-2147483648'
C00214   DC    V(I#SQRT)
C00215   DC    V(RAPPLY1)
C00216   DC    V(SQRT)
C00219   DC    F'1'
C00220   DC    V(I#EXP)
C00221   DC    V(EXP)
C00224   DC    V(I#ALOG)
C00225   DC    V(LOG)
C00228   DC    V(I#ALOG10)
C00229   DC    V(LOG10)
C00232   DC    V(I#SIN)
C00233   DC    V(SIN)
C00236   DC    V(I#COS)
C00237   DC    V(COS)
C00240   DC    V(I#TAN)
C00241   DC    V(TAN)
C00244   DC    V(I#ASIN)
C00245   DC    V(ASIN)
C00248   DC    V(I#ACOS)
C00249   DC    V(ACOS)
C00252   DC    V(I#ATAN)
C00253   DC    V(ATAN)
C00256   DC    V(I#SINH)
C00257   DC    V(SINH)
C00260   DC    V(I#COSH)
C00261   DC    V(COSH)
C00264   DC    V(I#TANH)
C00265   DC    V(TANH)
C00268   DC    F'0'
C00270   DC    A(Q00142)
C00271   DC    V(CHK)
C00273   DC    A(Q00143)
C00275   DC    A(Q00144)
C00277   DC    A(Q00145)
C00279   DC    A(Q00146)
C00281   DC    A(Q00147)
C00283   DC    A(Q00148)
C00285   DC    A(Q00149)
C00287   DC    A(Q00150)
C00289   DC    A(Q00151)
C00291   DC    A(Q00152)
C00293   DC    A(Q00153)
C00295   DC    A(Q00154)
Q00142   DC    C'SQRT  '
Q00143   DC    C'EXP   '
Q00144   DC    C'ALOG  '
Q00145   DC    C'ALOG10'
Q00146   DC    C'SIN   '
Q00147   DC    C'COS   '
Q00148   DC    C'TAN   '
Q00149   DC    C'ASIN  '
Q00150   DC    C'ACOS  '
Q00151   DC    C'ATAN  '
Q00152   DC    C'SINH  '
Q00153   DC    C'COSH  '
Q00154   DC    C'TANH  '
* OLDWAY
OLDWAY   CSECT
         USING *,15
         B     L00311
         DC    AL1(6),CL7'OLDWAY'
L00311   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00312
L00313   DC    A(S00296)
L00312   L     15,L00313
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00296,13
         ST    1,S00296+72
L00308   DS    0H
         L     4,0(,1)
         LA    4,0(,4)
         MVC   T00306(4),C00314
         MVC   T00306+4(4),C00315
         MVC   T00307(4),C00316
         L     0,C00318
         ST    0,P00317+0
         LA    0,T00307
         ST    0,P00317+4
         OI    P00317+4,X'80'
         LA    1,P00317
         L     15,C00319
         BALR  14,15
         STE   0,S00296+272
         LE    0,C00316
         STE   0,P00317+0
         XC    P00317+4(4),P00317+4
         LA    1,P00317
         L     15,C00320
         BALR  14,15
         LE    2,S00296+272
         CER   2,0
         LA    2,1
         BC    8,L00321
         SR    2,2
L00321   DS    0H
         LE    0,C00316
         STE   0,P00317+0
         XC    P00317+4(4),P00317+4
         LA    1,P00317
         L     15,C00320
         BALR  14,15
         SE    0,C00322
         LPER  0,0
         CE    0,C00323
         LA    3,1
         BC    4,L00324
         SR    3,3
L00324   DS    0H
         NR    2,3
         ST    2,T00300
         L     0,C00325
         ST    0,P00317+0
         LA    0,T00300
         ST    0,P00317+4
         LR    0,4
         ST    0,P00317+8
         LA    0,6
         ST    0,P00317+12
         OI    P00317+12,X'80'
         LA    1,P00317
         L     15,C00326
         BALR  14,15
         MVC   T00301(4),C00314
         L     0,C00327
         ST    0,P00317+0
         LA    0,T00301
         ST    0,P00317+4
         OI    P00317+4,X'80'
         LA    1,P00317
         L     15,C00319
         BALR  14,15
         STE   0,S00296+272
         LE    0,C00314
         STE   0,P00317+0
         XC    P00317+4(4),P00317+4
         LA    1,P00317
         L     15,C00328
         BALR  14,15
         LE    2,S00296+272
         CER   2,0
         LA    2,1
         BC    8,L00329
         SR    2,2
L00329   DS    0H
         LE    0,C00314
         STE   0,P00317+0
         XC    P00317+4(4),P00317+4
         LA    1,P00317
         L     15,C00328
         BALR  14,15
         SE    0,C00330
         LPER  0,0
         CE    0,C00323
         LA    3,1
         BC    4,L00331
         SR    3,3
L00331   DS    0H
         NR    2,3
         ST    2,T00302
         L     0,C00332
         ST    0,P00317+0
         LA    0,T00302
         ST    0,P00317+4
         LR    0,4
         ST    0,P00317+8
         LA    0,6
         ST    0,P00317+12
         OI    P00317+12,X'80'
         LA    1,P00317
         L     15,C00326
         BALR  14,15
         L     0,C00333
         ST    0,P00317+0
         LA    0,T00306
         ST    0,P00317+4
         OI    P00317+4,X'80'
         LA    1,P00317
         L     15,C00334
         BALR  14,15
         STE   0,S00296+272
         STE   2,S00296+280
         LE    0,T00306
         STE   0,S00296+288
         LE    0,T00306+4
         STE   0,S00296+296
         LA    0,T00304
         ST    0,P00317+0
         LE    0,S00296+288
         STE   0,P00317+4
         LE    0,S00296+296
         STE   0,P00317+8
         LA    1,P00317
         L     15,C00335
         BALR  14,15
         LE    0,T00304+4
         LE    2,S00296+272
         CE    2,T00304
         LA    2,1
         BC    8,L00336
         SR    2,2
L00336   DS    0H
         LE    2,S00296+280
         CER   2,0
         LA    3,1
         BC    8,L00337
         SR    3,3
L00337   DS    0H
         NR    2,3
         LE    0,T00306
         STE   0,S00296+272
         LE    0,T00306+4
         STE   0,S00296+280
         LA    0,T00305
         ST    0,P00317+0
         LE    0,S00296+272
         STE   0,P00317+4
         LE    0,S00296+280
         STE   0,P00317+8
         LA    1,P00317
         L     15,C00335
         BALR  14,15
         LE    0,T00305
         SE    0,C00338
         LPER  0,0
         CE    0,C00323
         LA    3,1
         BC    4,L00339
         SR    3,3
L00339   DS    0H
         NR    2,3
         ST    2,T00303
         L     0,C00340
         ST    0,P00317+0
         LA    0,T00303
         ST    0,P00317+4
         LR    0,4
         ST    0,P00317+8
         LA    0,6
         ST    0,P00317+12
         OI    P00317+12,X'80'
         LA    1,P00317
         L     15,C00326
         BALR  14,15
         LA    0,0
         B     L00310
L00309   DS    0H
L00310   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00296   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00300   DS    XL4
         DS    XL4
T00301   DS    XL4
         DS    XL4
T00302   DS    XL4
         DS    XL4
T00303   DS    XL4
         DS    XL4
T00304   DS    XL8
T00305   DS    XL8
T00306   DS    XL24
T00307   DS    XL24
         DS    4D
P00317   DS    4F
C00314   DC    X'40800000'
C00315   DC    X'41140000'
C00316   DC    X'41200000'
C00318   DC    V(I#SQRT)
C00319   DC    V(RAPPLY1)
C00320   DC    V(SQRT)
C00322   DC    X'4116A09E'
C00323   DC    X'3C10C6F8'
C00325   DC    A(Q00297)
C00326   DC    V(CHK)
C00327   DC    V(I#SIN)
C00328   DC    V(SIN)
C00330   DC    X'407ABBA2'
C00332   DC    A(Q00298)
C00333   DC    V(I#CSQRT)
C00334   DC    V(CAPPLY)
C00335   DC    V(F77CSQRT)
C00338   DC    X'40F5F74C'
C00340   DC    A(Q00299)
Q00297   DC    C'XSQRT '
Q00298   DC    C'XSIN  '
Q00299   DC    C'XCSQRT'
* CAPPLY
CAPPLY   CSECT
         USING *,15
         B     L00344
         DC    AL1(6),CL7'CAPPLY'
L00344   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00345
L00346   DC    A(S00341)
L00345   L     15,L00346
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00341,13
         ST    1,S00341+72
L00342   DS    0H
         L     3,0(,1)
         L     2,4(,1)
         LA    2,0(,2)
         LR    0,2
         ST    0,P00347+0
         OI    P00347+0,X'80'
         LA    1,P00347
         LR    15,3
         BALR  14,15
         STE   0,S00341+176
         LER   0,2
         LER   2,0
         LE    0,S00341+176
L00343   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00341   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
         DS    1D
P00347   DS    1F
         DS    XL4
* ZAPPLY
ZAPPLY   CSECT
         USING *,15
         B     L00351
         DC    AL1(6),CL7'ZAPPLY'
L00351   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00352
L00353   DC    A(S00348)
L00352   L     15,L00353
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00348,13
         ST    1,S00348+72
L00349   DS    0H
         L     3,0(,1)
         L     2,4(,1)
         LA    2,0(,2)
         LR    0,2
         ST    0,P00354+0
         OI    P00354+0,X'80'
         LA    1,P00354
         LR    15,3
         BALR  14,15
         STD   0,S00348+176
         LDR   0,2
         LDR   2,0
         LD    0,S00348+176
L00350   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00348   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
         DS    1D
P00354   DS    1F
         DS    XL4
* RAPPLY
RAPPLY   CSECT
         USING *,15
         B     L00358
         DC    AL1(6),CL7'RAPPLY'
L00358   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00359
L00360   DC    A(S00355)
L00359   L     15,L00360
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00355,13
         ST    1,S00355+72
L00356   DS    0H
         L     3,0(,1)
         L     2,4(,1)
         LA    2,0(,2)
         LR    0,2
         ST    0,P00361+0
         OI    P00361+0,X'80'
         LA    1,P00361
         LR    15,3
         BALR  14,15
L00357   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00355   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00361   DS    1F
         DS    XL4
* RAPPLY1
RAPPLY1  CSECT
         USING *,15
         B     L00365
         DC    AL1(7),CL7'RAPPLY1'
L00365   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00366
L00367   DC    A(S00362)
L00366   L     15,L00367
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00362,13
         ST    1,S00362+72
L00363   DS    0H
         L     3,0(,1)
         L     2,4(,1)
         LA    2,0(,2)
         LR    0,2
         ST    0,P00368+0
         OI    P00368+0,X'80'
         LA    1,P00368
         LR    15,3
         BALR  14,15
L00364   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00362   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00368   DS    1F
         DS    XL4
* DAPPLY
DAPPLY   CSECT
         USING *,15
         B     L00372
         DC    AL1(6),CL7'DAPPLY'
L00372   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00373
L00374   DC    A(S00369)
L00373   L     15,L00374
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00369,13
         ST    1,S00369+72
L00370   DS    0H
         L     3,0(,1)
         L     2,4(,1)
         LA    2,0(,2)
         LR    0,2
         ST    0,P00375+0
         OI    P00375+0,X'80'
         LA    1,P00375
         LR    15,3
         BALR  14,15
L00371   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00369   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00375   DS    1F
         DS    XL4
* CHK
CHK      CSECT
         USING *,15
         B     L00386
         DC    AL1(3),CL7'CHK'
L00386   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00387
L00388   DC    A(S00376)
L00387   L     15,L00388
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00376,13
         ST    1,S00376+72
L00379   DS    0H
         L     5,0(,1)
         L     4,4(,1)
         L     3,8(,1)
         L     2,0(,4)
         LTR   2,2
         BC    7,L00380
L00381   DS    0H
         LA    0,6
         ST    0,P00389+0
         L     0,C00390
         ST    0,P00389+4
         LA    1,P00389
         L     15,C00391
         BALR  14,15
         LR    0,5
         ST    0,P00389+0
         LA    0,6
         ST    0,P00389+4
         LA    1,P00389
         L     15,C00392
         BALR  14,15
         L     15,C00393
         BALR  14,15
L00384   DS    0H
         L     2,0(,3)
         A     2,C00394
         ST    2,0(,3)
L00382   DS    0H
         LA    0,0
         B     L00385
L00380   DS    0H
         LA    0,6
         ST    0,P00389+0
         L     0,C00395
         ST    0,P00389+4
         LA    1,P00389
         L     15,C00391
         BALR  14,15
         LR    0,5
         ST    0,P00389+0
         LA    0,6
         ST    0,P00389+4
         LA    1,P00389
         L     15,C00392
         BALR  14,15
         L     15,C00393
         BALR  14,15
L00383   DS    0H
         B     L00382
L00385   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00376   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00389   DS    2F
C00390   DC    A(Q00378)
C00391   DC    V(F77WRBEG)
C00392   DC    V(F77WRA)
C00393   DC    V(F77WREND)
C00394   DC    F'1'
C00395   DC    A(Q00377)
Q00377   DC    C'('' >'',A6,'' OK'')'
Q00378   DC    C'('' >'',A6,'' BAD'')'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
