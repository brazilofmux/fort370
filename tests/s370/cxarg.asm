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
         LA    1,P00057
         L     15,C00058
         BALR  14,15
         STE   0,S00000+576
         STE   2,S00000+584
         LE    0,T00046
         STE   0,S00000+592
         LE    0,T00046+4
         STE   0,S00000+600
         LE    0,S00000+592
         STE   0,P00059+4
         LE    0,S00000+600
         STE   0,P00059+8
         LA    1,P00059
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
         LA    1,P00063
         L     15,C00064
         BALR  14,15
         LA    1,P00065
         L     15,C00058
         BALR  14,15
         STE   0,S00000+576
         STE   2,S00000+584
         LE    0,T00046
         STE   0,S00000+592
         LE    0,T00046+4
         STE   0,S00000+600
         LE    0,S00000+592
         STE   0,P00066+4
         LE    0,S00000+600
         STE   0,P00066+8
         LA    1,P00066
         L     15,C00067
         BALR  14,15
         LE    0,T00035+4
         LE    2,S00000+576
         CE    2,T00035
         LA    2,1
         BC    8,L00068
         SR    2,2
L00068   DS    0H
         LE    2,S00000+584
         CER   2,0
         LA    3,1
         BC    8,L00069
         SR    3,3
L00069   DS    0H
         NR    2,3
         ST    2,T00019
         LA    1,P00070
         L     15,C00064
         BALR  14,15
         LA    1,P00071
         L     15,C00058
         BALR  14,15
         STE   0,S00000+576
         STE   2,S00000+584
         LE    0,T00046
         STE   0,S00000+592
         LE    0,T00046+4
         STE   0,S00000+600
         LE    0,S00000+592
         STE   0,P00072+4
         LE    0,S00000+600
         STE   0,P00072+8
         LA    1,P00072
         L     15,C00073
         BALR  14,15
         LE    0,T00036+4
         LE    2,S00000+576
         CE    2,T00036
         LA    2,1
         BC    8,L00074
         SR    2,2
L00074   DS    0H
         LE    2,S00000+584
         CER   2,0
         LA    3,1
         BC    8,L00075
         SR    3,3
L00075   DS    0H
         NR    2,3
         ST    2,T00020
         LA    1,P00076
         L     15,C00064
         BALR  14,15
         LA    1,P00077
         L     15,C00058
         BALR  14,15
         STE   0,S00000+576
         STE   2,S00000+584
         LE    0,T00046
         STE   0,S00000+592
         LE    0,T00046+4
         STE   0,S00000+600
         LE    0,S00000+592
         STE   0,P00078+4
         LE    0,S00000+600
         STE   0,P00078+8
         LA    1,P00078
         L     15,C00079
         BALR  14,15
         LE    0,T00037+4
         LE    2,S00000+576
         CE    2,T00037
         LA    2,1
         BC    8,L00080
         SR    2,2
L00080   DS    0H
         LE    2,S00000+584
         CER   2,0
         LA    3,1
         BC    8,L00081
         SR    3,3
L00081   DS    0H
         NR    2,3
         ST    2,T00021
         LA    1,P00082
         L     15,C00064
         BALR  14,15
         LA    1,P00083
         L     15,C00058
         BALR  14,15
         STE   0,S00000+576
         STE   2,S00000+584
         LE    0,T00046
         STE   0,S00000+592
         LE    0,T00046+4
         STE   0,S00000+600
         LE    0,S00000+592
         STE   0,P00084+4
         LE    0,S00000+600
         STE   0,P00084+8
         LA    1,P00084
         L     15,C00085
         BALR  14,15
         LE    0,T00038+4
         LE    2,S00000+576
         CE    2,T00038
         LA    2,1
         BC    8,L00086
         SR    2,2
L00086   DS    0H
         LE    2,S00000+584
         CER   2,0
         LA    3,1
         BC    8,L00087
         SR    3,3
L00087   DS    0H
         NR    2,3
         ST    2,T00022
         LA    1,P00088
         L     15,C00064
         BALR  14,15
         LA    1,P00089
         L     15,C00058
         BALR  14,15
         STE   0,S00000+576
         LE    0,T00046+4
         LCER  0,0
         LE    4,S00000+576
         CE    4,T00046
         LA    2,1
         BC    8,L00090
         SR    2,2
L00090   DS    0H
         CER   2,0
         LA    3,1
         BC    8,L00091
         SR    3,3
L00091   DS    0H
         NR    2,3
         ST    2,T00023
         LA    1,P00092
         L     15,C00064
         BALR  14,15
         LA    1,P00093
         L     15,C00094
         BALR  14,15
         STE   0,S00000+576
         LE    0,T00046
         STE   0,S00000+584
         LE    0,T00046+4
         STE   0,S00000+592
         LE    0,S00000+584
         STE   0,P00095+0
         LE    0,S00000+592
         STE   0,P00095+4
         LA    1,P00095
         L     15,C00096
         BALR  14,15
         LE    2,S00000+576
         CER   2,0
         LA    2,1
         BC    8,L00097
         SR    2,2
L00097   DS    0H
         ST    2,T00024
         LA    1,P00098
         L     15,C00064
         BALR  14,15
         LA    1,P00099
         L     15,C00094
         BALR  14,15
         CE    0,T00046+4
         LA    2,1
         BC    8,L00100
         SR    2,2
L00100   DS    0H
         ST    2,T00025
         LA    1,P00101
         L     15,C00064
         BALR  14,15
         LA    1,P00102
         L     15,C00103
         BALR  14,15
         STD   0,S00000+576
         STD   2,S00000+584
         LD    0,T00044
         STD   0,S00000+592
         LD    0,T00044+8
         STD   0,S00000+600
         LD    0,S00000+592
         STD   0,P00104+0
         LD    0,S00000+600
         STD   0,P00104+8
         LA    1,P00104
         L     15,C00105
         BALR  14,15
         LD    0,T00039+8
         LD    2,S00000+576
         CD    2,T00039
         LA    2,1
         BC    8,L00106
         SR    2,2
L00106   DS    0H
         LD    2,S00000+584
         CDR   2,0
         LA    3,1
         BC    8,L00107
         SR    3,3
L00107   DS    0H
         NR    2,3
         ST    2,T00026
         LA    1,P00108
         L     15,C00064
         BALR  14,15
         LA    1,P00109
         L     15,C00103
         BALR  14,15
         STD   0,S00000+576
         STD   2,S00000+584
         LD    0,T00044
         STD   0,S00000+592
         LD    0,T00044+8
         STD   0,S00000+600
         LD    0,S00000+592
         STD   0,P00110+0
         LD    0,S00000+600
         STD   0,P00110+8
         LA    1,P00110
         L     15,C00111
         BALR  14,15
         LD    0,T00040+8
         LD    2,S00000+576
         CD    2,T00040
         LA    2,1
         BC    8,L00112
         SR    2,2
L00112   DS    0H
         LD    2,S00000+584
         CDR   2,0
         LA    3,1
         BC    8,L00113
         SR    3,3
L00113   DS    0H
         NR    2,3
         ST    2,T00027
         LA    1,P00114
         L     15,C00064
         BALR  14,15
         LA    1,P00115
         L     15,C00103
         BALR  14,15
         STD   0,S00000+576
         STD   2,S00000+584
         LD    0,T00044
         STD   0,S00000+592
         LD    0,T00044+8
         STD   0,S00000+600
         LD    0,S00000+592
         STD   0,P00116+0
         LD    0,S00000+600
         STD   0,P00116+8
         LA    1,P00116
         L     15,C00117
         BALR  14,15
         LD    0,T00041+8
         LD    2,S00000+576
         CD    2,T00041
         LA    2,1
         BC    8,L00118
         SR    2,2
L00118   DS    0H
         LD    2,S00000+584
         CDR   2,0
         LA    3,1
         BC    8,L00119
         SR    3,3
L00119   DS    0H
         NR    2,3
         ST    2,T00028
         LA    1,P00120
         L     15,C00064
         BALR  14,15
         LA    1,P00121
         L     15,C00103
         BALR  14,15
         STD   0,S00000+576
         STD   2,S00000+584
         LD    0,T00044
         STD   0,S00000+592
         LD    0,T00044+8
         STD   0,S00000+600
         LD    0,S00000+592
         STD   0,P00122+0
         LD    0,S00000+600
         STD   0,P00122+8
         LA    1,P00122
         L     15,C00123
         BALR  14,15
         LD    0,T00042+8
         LD    2,S00000+576
         CD    2,T00042
         LA    2,1
         BC    8,L00124
         SR    2,2
L00124   DS    0H
         LD    2,S00000+584
         CDR   2,0
         LA    3,1
         BC    8,L00125
         SR    3,3
L00125   DS    0H
         NR    2,3
         ST    2,T00029
         LA    1,P00126
         L     15,C00064
         BALR  14,15
         LA    1,P00127
         L     15,C00103
         BALR  14,15
         STD   0,S00000+576
         STD   2,S00000+584
         LD    0,T00044
         STD   0,S00000+592
         LD    0,T00044+8
         STD   0,S00000+600
         LD    0,S00000+592
         STD   0,P00128+0
         LD    0,S00000+600
         STD   0,P00128+8
         LA    1,P00128
         L     15,C00129
         BALR  14,15
         LD    0,T00043+8
         LD    2,S00000+576
         CD    2,T00043
         LA    2,1
         BC    8,L00130
         SR    2,2
L00130   DS    0H
         LD    2,S00000+584
         CDR   2,0
         LA    3,1
         BC    8,L00131
         SR    3,3
L00131   DS    0H
         NR    2,3
         ST    2,T00030
         LA    1,P00132
         L     15,C00064
         BALR  14,15
         LA    1,P00133
         L     15,C00103
         BALR  14,15
         STD   0,S00000+576
         LD    0,T00044+8
         LCDR  0,0
         LD    4,S00000+576
         CD    4,T00044
         LA    2,1
         BC    8,L00134
         SR    2,2
L00134   DS    0H
         CDR   2,0
         LA    3,1
         BC    8,L00135
         SR    3,3
L00135   DS    0H
         NR    2,3
         ST    2,T00031
         LA    1,P00136
         L     15,C00064
         BALR  14,15
         LA    1,P00137
         L     15,C00138
         BALR  14,15
         STD   0,S00000+576
         LD    0,T00044
         STD   0,S00000+584
         LD    0,T00044+8
         STD   0,S00000+592
         LD    0,S00000+584
         STD   0,P00139+0
         LD    0,S00000+592
         STD   0,P00139+8
         LA    1,P00139
         L     15,C00140
         BALR  14,15
         LD    2,S00000+576
         CDR   2,0
         LA    2,1
         BC    8,L00141
         SR    2,2
L00141   DS    0H
         ST    2,T00032
         LA    1,P00142
         L     15,C00064
         BALR  14,15
         LA    1,P00143
         L     15,C00138
         BALR  14,15
         CD    0,T00044+8
         LA    2,1
         BC    8,L00144
         SR    2,2
L00144   DS    0H
         ST    2,T00033
         LA    1,P00145
         L     15,C00064
         BALR  14,15
         LA    1,P00146
         L     15,C00147
         BALR  14,15
         LA    1,P00146
         L     15,C00148
         BALR  14,15
         LA    1,P00149
         L     15,C00150
         BALR  14,15
         L     3,T00045
         LR    0,3
         ST    0,P00151+0
         LA    1,P00151
         L     15,C00152
         BALR  14,15
         L     15,C00153
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
P00057   DC    V(I#CSQRT)
         DC    XL1'80',AL3(T00046)
P00059   DC    A(T00034)
         DC    A(0)
         DC    A(0)
P00063   DC    A(Q00001)
         DC    A(T00018)
         DC    A(T00045)
         DC    XL1'80',FL3'6'
P00065   DC    V(I#CEXP)
         DC    XL1'80',AL3(T00046)
         DS    F
P00066   DC    A(T00035)
         DC    A(0)
         DC    A(0)
P00070   DC    A(Q00002)
         DC    A(T00019)
         DC    A(T00045)
         DC    XL1'80',FL3'6'
P00071   DC    V(I#CLOG)
         DC    XL1'80',AL3(T00046)
         DS    F
P00072   DC    A(T00036)
         DC    A(0)
         DC    A(0)
P00076   DC    A(Q00003)
         DC    A(T00020)
         DC    A(T00045)
         DC    XL1'80',FL3'6'
P00077   DC    V(I#CSIN)
         DC    XL1'80',AL3(T00046)
         DS    F
P00078   DC    A(T00037)
         DC    A(0)
         DC    A(0)
P00082   DC    A(Q00004)
         DC    A(T00021)
         DC    A(T00045)
         DC    XL1'80',FL3'6'
P00083   DC    V(I#CCOS)
         DC    XL1'80',AL3(T00046)
         DS    F
P00084   DC    A(T00038)
         DC    A(0)
         DC    A(0)
P00088   DC    A(Q00005)
         DC    A(T00022)
         DC    A(T00045)
         DC    XL1'80',FL3'6'
P00089   DC    V(I#CONJG)
         DC    XL1'80',AL3(T00046)
P00092   DC    A(Q00006)
         DC    A(T00023)
         DC    A(T00045)
         DC    XL1'80',FL3'6'
P00093   DC    V(I#CABS)
         DC    XL1'80',AL3(T00046)
         DS    F
P00095   DC    A(0)
         DC    A(0)
P00098   DC    A(Q00007)
         DC    A(T00024)
         DC    A(T00045)
         DC    XL1'80',FL3'6'
P00099   DC    V(I#AIMAG)
         DC    XL1'80',AL3(T00046)
P00101   DC    A(Q00008)
         DC    A(T00025)
         DC    A(T00045)
         DC    XL1'80',FL3'6'
P00102   DC    V(I#CDSQRT)
         DC    XL1'80',AL3(T00044)
P00104   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00039)
P00108   DC    A(Q00009)
         DC    A(T00026)
         DC    A(T00045)
         DC    XL1'80',FL3'6'
P00109   DC    V(I#CDEXP)
         DC    XL1'80',AL3(T00044)
         DS    F
P00110   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00040)
P00114   DC    A(Q00010)
         DC    A(T00027)
         DC    A(T00045)
         DC    XL1'80',FL3'6'
P00115   DC    V(I#CDLOG)
         DC    XL1'80',AL3(T00044)
         DS    F
P00116   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00041)
P00120   DC    A(Q00011)
         DC    A(T00028)
         DC    A(T00045)
         DC    XL1'80',FL3'6'
P00121   DC    V(I#CDSIN)
         DC    XL1'80',AL3(T00044)
         DS    F
P00122   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00042)
P00126   DC    A(Q00012)
         DC    A(T00029)
         DC    A(T00045)
         DC    XL1'80',FL3'6'
P00127   DC    V(I#CDCOS)
         DC    XL1'80',AL3(T00044)
         DS    F
P00128   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00043)
P00132   DC    A(Q00013)
         DC    A(T00030)
         DC    A(T00045)
         DC    XL1'80',FL3'6'
P00133   DC    V(I#DCONJG)
         DC    XL1'80',AL3(T00044)
P00136   DC    A(Q00014)
         DC    A(T00031)
         DC    A(T00045)
         DC    XL1'80',FL3'6'
P00137   DC    V(I#CDABS)
         DC    XL1'80',AL3(T00044)
         DS    F
P00139   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
P00142   DC    A(Q00015)
         DC    A(T00032)
         DC    A(T00045)
         DC    XL1'80',FL3'6'
P00143   DC    V(I#DIMAG)
         DC    XL1'80',AL3(T00044)
P00145   DC    A(Q00016)
         DC    A(T00033)
         DC    A(T00045)
         DC    XL1'80',FL3'6'
P00146   DC    XL1'80',AL3(T00045)
P00149   DC    F'6'
         DC    A(Q00017)
P00151   DC    A(0)
C00055   DC    X'4080000000000000'
C00056   DC    X'4114000000000000'
C00053   DC    X'40800000'
C00054   DC    X'41140000'
C00058   DC    V(CAPPLY)
C00060   DC    V(F77CSQRT)
C00064   DC    V(CHK)
C00067   DC    V(F77CEXP)
C00073   DC    V(F77CLOG)
C00079   DC    V(F77CSIN)
C00085   DC    V(F77CCOS)
C00094   DC    V(RAPPLY)
C00096   DC    V(F77CABS)
C00103   DC    V(ZAPPLY)
C00105   DC    V(F77ZSQRT)
C00111   DC    V(F77ZEXP)
C00117   DC    V(F77ZLOG)
C00123   DC    V(F77ZSIN)
C00129   DC    V(F77ZCOS)
C00138   DC    V(DAPPLY)
C00140   DC    V(F77ZABS)
C00147   DC    V(REALS)
C00148   DC    V(OLDWAY)
C00150   DC    V(F77WRBEG)
C00152   DC    V(F77WRI)
C00153   DC    V(F77WREND)
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
         B     L00220
         DC    AL1(5),CL7'REALS'
L00220   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00221
L00222   DC    A(S00154)
L00221   L     15,L00222
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00154,13
         ST    1,S00154+72
L00183   DS    0H
         L     6,0(,1)
         LA    6,0(,6)
L00184   DS    0H
         LA    4,4
         LA    5,52
         LA    2,4
L00185   DS    0H
         LA    15,0
         ST    15,T00182-4(2)
L00187   DS    0H
         BXLE  2,4,L00185
L00186   DS    0H
         LA    4,1
L00188   DS    0H
         LA    5,10
         LR    2,4
L00189   DS    0H
         LE    0,C00223
         LR    0,2
         X     0,C00224
         ST    0,S00154+84
         LD    2,S00154+80
         SD    2,C00225
         LER   2,2
         MER   0,2
         STE   0,T00180
         LA    1,P00226
         L     15,C00227
         BALR  14,15
         STE   0,S00154+416
         LE    0,T00180
         STE   0,S00154+424
         LE    0,S00154+424
         STE   0,P00228+0
         LA    1,P00228
         L     15,C00229
         BALR  14,15
         LE    2,S00154+416
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
         BC    8,L00192
L00191   DS    0H
         L     3,T00182
         A     3,C00232
         ST    3,T00182
L00192   DS    0H
         LA    1,P00233
         L     15,C00227
         BALR  14,15
         STE   0,S00154+416
         LE    0,T00180
         STE   0,S00154+424
         LE    0,S00154+424
         STE   0,P00228+0
         LA    1,P00228
         L     15,C00234
         BALR  14,15
         LE    2,S00154+416
         CER   2,0
         LA    7,1
         BC    8,L00235
         SR    7,7
L00235   DS    0H
         LTR   7,7
         LA    3,1
         BC    8,L00236
         SR    3,3
L00236   DS    0H
         LTR   3,3
         BC    8,L00194
L00193   DS    0H
         L     3,T00182+4
         A     3,C00232
         ST    3,T00182+4
L00194   DS    0H
         LA    1,P00237
         L     15,C00227
         BALR  14,15
         STE   0,S00154+416
         LE    0,T00180
         STE   0,S00154+424
         LE    0,S00154+424
         STE   0,P00228+0
         LA    1,P00228
         L     15,C00238
         BALR  14,15
         LE    2,S00154+416
         CER   2,0
         LA    7,1
         BC    8,L00239
         SR    7,7
L00239   DS    0H
         LTR   7,7
         LA    3,1
         BC    8,L00240
         SR    3,3
L00240   DS    0H
         LTR   3,3
         BC    8,L00196
L00195   DS    0H
         L     3,T00182+8
         A     3,C00232
         ST    3,T00182+8
L00196   DS    0H
         LA    1,P00241
         L     15,C00227
         BALR  14,15
         STE   0,S00154+416
         LE    0,T00180
         STE   0,S00154+424
         LE    0,S00154+424
         STE   0,P00228+0
         LA    1,P00228
         L     15,C00242
         BALR  14,15
         LE    2,S00154+416
         CER   2,0
         LA    7,1
         BC    8,L00243
         SR    7,7
L00243   DS    0H
         LTR   7,7
         LA    3,1
         BC    8,L00244
         SR    3,3
L00244   DS    0H
         LTR   3,3
         BC    8,L00198
L00197   DS    0H
         L     3,T00182+12
         A     3,C00232
         ST    3,T00182+12
L00198   DS    0H
         LA    1,P00245
         L     15,C00227
         BALR  14,15
         STE   0,S00154+416
         LE    0,T00180
         STE   0,S00154+424
         LE    0,S00154+424
         STE   0,P00228+0
         LA    1,P00228
         L     15,C00246
         BALR  14,15
         LE    2,S00154+416
         CER   2,0
         LA    7,1
         BC    8,L00247
         SR    7,7
L00247   DS    0H
         LTR   7,7
         LA    3,1
         BC    8,L00248
         SR    3,3
L00248   DS    0H
         LTR   3,3
         BC    8,L00200
L00199   DS    0H
         L     3,T00182+16
         A     3,C00232
         ST    3,T00182+16
L00200   DS    0H
         LA    1,P00249
         L     15,C00227
         BALR  14,15
         STE   0,S00154+416
         LE    0,T00180
         STE   0,S00154+424
         LE    0,S00154+424
         STE   0,P00228+0
         LA    1,P00228
         L     15,C00250
         BALR  14,15
         LE    2,S00154+416
         CER   2,0
         LA    7,1
         BC    8,L00251
         SR    7,7
L00251   DS    0H
         LTR   7,7
         LA    3,1
         BC    8,L00252
         SR    3,3
L00252   DS    0H
         LTR   3,3
         BC    8,L00202
L00201   DS    0H
         L     3,T00182+20
         A     3,C00232
         ST    3,T00182+20
L00202   DS    0H
         LA    1,P00253
         L     15,C00227
         BALR  14,15
         STE   0,S00154+416
         LE    0,T00180
         STE   0,S00154+424
         LE    0,S00154+424
         STE   0,P00228+0
         LA    1,P00228
         L     15,C00254
         BALR  14,15
         LE    2,S00154+416
         CER   2,0
         LA    7,1
         BC    8,L00255
         SR    7,7
L00255   DS    0H
         LTR   7,7
         LA    3,1
         BC    8,L00256
         SR    3,3
L00256   DS    0H
         LTR   3,3
         BC    8,L00204
L00203   DS    0H
         L     3,T00182+24
         A     3,C00232
         ST    3,T00182+24
L00204   DS    0H
         LA    1,P00257
         L     15,C00227
         BALR  14,15
         STE   0,S00154+416
         LE    0,T00180
         STE   0,S00154+424
         LE    0,S00154+424
         STE   0,P00228+0
         LA    1,P00228
         L     15,C00258
         BALR  14,15
         LE    2,S00154+416
         CER   2,0
         LA    7,1
         BC    8,L00259
         SR    7,7
L00259   DS    0H
         LTR   7,7
         LA    3,1
         BC    8,L00260
         SR    3,3
L00260   DS    0H
         LTR   3,3
         BC    8,L00206
L00205   DS    0H
         L     3,T00182+28
         A     3,C00232
         ST    3,T00182+28
L00206   DS    0H
         LA    1,P00261
         L     15,C00227
         BALR  14,15
         STE   0,S00154+416
         LE    0,T00180
         STE   0,S00154+424
         LE    0,S00154+424
         STE   0,P00228+0
         LA    1,P00228
         L     15,C00262
         BALR  14,15
         LE    2,S00154+416
         CER   2,0
         LA    7,1
         BC    8,L00263
         SR    7,7
L00263   DS    0H
         LTR   7,7
         LA    3,1
         BC    8,L00264
         SR    3,3
L00264   DS    0H
         LTR   3,3
         BC    8,L00208
L00207   DS    0H
         L     3,T00182+32
         A     3,C00232
         ST    3,T00182+32
L00208   DS    0H
         LA    1,P00265
         L     15,C00227
         BALR  14,15
         STE   0,S00154+416
         LE    0,T00180
         STE   0,S00154+424
         LE    0,S00154+424
         STE   0,P00228+0
         LA    1,P00228
         L     15,C00266
         BALR  14,15
         LE    2,S00154+416
         CER   2,0
         LA    7,1
         BC    8,L00267
         SR    7,7
L00267   DS    0H
         LTR   7,7
         LA    3,1
         BC    8,L00268
         SR    3,3
L00268   DS    0H
         LTR   3,3
         BC    8,L00210
L00209   DS    0H
         L     3,T00182+36
         A     3,C00232
         ST    3,T00182+36
L00210   DS    0H
         LA    1,P00269
         L     15,C00227
         BALR  14,15
         STE   0,S00154+416
         LE    0,T00180
         STE   0,S00154+424
         LE    0,S00154+424
         STE   0,P00228+0
         LA    1,P00228
         L     15,C00270
         BALR  14,15
         LE    2,S00154+416
         CER   2,0
         LA    7,1
         BC    8,L00271
         SR    7,7
L00271   DS    0H
         LTR   7,7
         LA    3,1
         BC    8,L00272
         SR    3,3
L00272   DS    0H
         LTR   3,3
         BC    8,L00212
L00211   DS    0H
         L     3,T00182+40
         A     3,C00232
         ST    3,T00182+40
L00212   DS    0H
         LA    1,P00273
         L     15,C00227
         BALR  14,15
         STE   0,S00154+416
         LE    0,T00180
         STE   0,S00154+424
         LE    0,S00154+424
         STE   0,P00228+0
         LA    1,P00228
         L     15,C00274
         BALR  14,15
         LE    2,S00154+416
         CER   2,0
         LA    7,1
         BC    8,L00275
         SR    7,7
L00275   DS    0H
         LTR   7,7
         LA    3,1
         BC    8,L00276
         SR    3,3
L00276   DS    0H
         LTR   3,3
         BC    8,L00214
L00213   DS    0H
         L     3,T00182+44
         A     3,C00232
         ST    3,T00182+44
L00214   DS    0H
         LA    1,P00277
         L     15,C00227
         BALR  14,15
         STE   0,S00154+416
         LE    0,T00180
         STE   0,S00154+424
         LE    0,S00154+424
         STE   0,P00228+0
         LA    1,P00228
         L     15,C00278
         BALR  14,15
         LE    2,S00154+416
         CER   2,0
         LA    7,1
         BC    8,L00279
         SR    7,7
L00279   DS    0H
         LTR   7,7
         LA    3,1
         BC    8,L00280
         SR    3,3
L00280   DS    0H
         LTR   3,3
         BC    8,L00216
L00215   DS    0H
         L     3,T00182+48
         A     3,C00232
         ST    3,T00182+48
L00216   DS    0H
L00217   DS    0H
         BXLE  2,4,L00189
L00190   DS    0H
         L     3,T00182
         C     3,C00281
         LA    2,1
         BC    8,L00282
         SR    2,2
L00282   DS    0H
         ST    2,T00181
         LR    0,6
         ST    0,P00283+8
         LA    1,P00283
         L     15,C00284
         BALR  14,15
         L     3,T00182+4
         C     3,C00281
         LA    2,1
         BC    8,L00285
         SR    2,2
L00285   DS    0H
         ST    2,T00168
         LR    0,6
         ST    0,P00286+8
         LA    1,P00286
         L     15,C00284
         BALR  14,15
         L     3,T00182+8
         C     3,C00281
         LA    2,1
         BC    8,L00287
         SR    2,2
L00287   DS    0H
         ST    2,T00169
         LR    0,6
         ST    0,P00288+8
         LA    1,P00288
         L     15,C00284
         BALR  14,15
         L     3,T00182+12
         C     3,C00281
         LA    2,1
         BC    8,L00289
         SR    2,2
L00289   DS    0H
         ST    2,T00170
         LR    0,6
         ST    0,P00290+8
         LA    1,P00290
         L     15,C00284
         BALR  14,15
         L     3,T00182+16
         C     3,C00281
         LA    2,1
         BC    8,L00291
         SR    2,2
L00291   DS    0H
         ST    2,T00171
         LR    0,6
         ST    0,P00292+8
         LA    1,P00292
         L     15,C00284
         BALR  14,15
         L     3,T00182+20
         C     3,C00281
         LA    2,1
         BC    8,L00293
         SR    2,2
L00293   DS    0H
         ST    2,T00172
         LR    0,6
         ST    0,P00294+8
         LA    1,P00294
         L     15,C00284
         BALR  14,15
         L     3,T00182+24
         C     3,C00281
         LA    2,1
         BC    8,L00295
         SR    2,2
L00295   DS    0H
         ST    2,T00173
         LR    0,6
         ST    0,P00296+8
         LA    1,P00296
         L     15,C00284
         BALR  14,15
         L     3,T00182+28
         C     3,C00281
         LA    2,1
         BC    8,L00297
         SR    2,2
L00297   DS    0H
         ST    2,T00174
         LR    0,6
         ST    0,P00298+8
         LA    1,P00298
         L     15,C00284
         BALR  14,15
         L     3,T00182+32
         C     3,C00281
         LA    2,1
         BC    8,L00299
         SR    2,2
L00299   DS    0H
         ST    2,T00175
         LR    0,6
         ST    0,P00300+8
         LA    1,P00300
         L     15,C00284
         BALR  14,15
         L     3,T00182+36
         C     3,C00281
         LA    2,1
         BC    8,L00301
         SR    2,2
L00301   DS    0H
         ST    2,T00176
         LR    0,6
         ST    0,P00302+8
         LA    1,P00302
         L     15,C00284
         BALR  14,15
         L     3,T00182+40
         C     3,C00281
         LA    2,1
         BC    8,L00303
         SR    2,2
L00303   DS    0H
         ST    2,T00177
         LR    0,6
         ST    0,P00304+8
         LA    1,P00304
         L     15,C00284
         BALR  14,15
         L     3,T00182+44
         C     3,C00281
         LA    2,1
         BC    8,L00305
         SR    2,2
L00305   DS    0H
         ST    2,T00178
         LR    0,6
         ST    0,P00306+8
         LA    1,P00306
         L     15,C00284
         BALR  14,15
         L     3,T00182+48
         C     3,C00281
         LA    2,1
         BC    8,L00307
         SR    2,2
L00307   DS    0H
         ST    2,T00179
         LR    0,6
         ST    0,P00308+8
         LA    1,P00308
         L     15,C00284
         BALR  14,15
         LA    0,0
         B     L00219
L00218   DS    0H
L00219   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00154   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00168   DS    XL4
         DS    XL4
T00169   DS    XL4
         DS    XL4
T00170   DS    XL4
         DS    XL4
T00171   DS    XL4
         DS    XL4
T00172   DS    XL4
         DS    XL4
T00173   DS    XL4
         DS    XL4
T00174   DS    XL4
         DS    XL4
T00175   DS    XL4
         DS    XL4
T00176   DS    XL4
         DS    XL4
T00177   DS    XL4
         DS    XL4
T00178   DS    XL4
         DS    XL4
T00179   DS    XL4
         DS    XL4
T00180   DS    XL8
T00181   DS    XL12
         DS    XL4
T00182   DS    XL116
         DS    XL4
         DS    2D
P00226   DC    V(I#SQRT)
         DC    XL1'80',AL3(T00180)
P00228   DC    A(0)
         DC    F'0'
P00233   DC    V(I#EXP)
         DC    XL1'80',AL3(T00180)
P00237   DC    V(I#ALOG)
         DC    XL1'80',AL3(T00180)
P00241   DC    V(I#ALOG10)
         DC    XL1'80',AL3(T00180)
P00245   DC    V(I#SIN)
         DC    XL1'80',AL3(T00180)
P00249   DC    V(I#COS)
         DC    XL1'80',AL3(T00180)
P00253   DC    V(I#TAN)
         DC    XL1'80',AL3(T00180)
P00257   DC    V(I#ASIN)
         DC    XL1'80',AL3(T00180)
P00261   DC    V(I#ACOS)
         DC    XL1'80',AL3(T00180)
P00265   DC    V(I#ATAN)
         DC    XL1'80',AL3(T00180)
P00269   DC    V(I#SINH)
         DC    XL1'80',AL3(T00180)
P00273   DC    V(I#COSH)
         DC    XL1'80',AL3(T00180)
P00277   DC    V(I#TANH)
         DC    XL1'80',AL3(T00180)
P00283   DC    A(Q00155)
         DC    A(T00181)
         DC    A(0)
         DC    XL1'80',FL3'6'
P00286   DC    A(Q00156)
         DC    A(T00168)
         DC    A(0)
         DC    XL1'80',FL3'6'
P00288   DC    A(Q00157)
         DC    A(T00169)
         DC    A(0)
         DC    XL1'80',FL3'6'
P00290   DC    A(Q00158)
         DC    A(T00170)
         DC    A(0)
         DC    XL1'80',FL3'6'
P00292   DC    A(Q00159)
         DC    A(T00171)
         DC    A(0)
         DC    XL1'80',FL3'6'
P00294   DC    A(Q00160)
         DC    A(T00172)
         DC    A(0)
         DC    XL1'80',FL3'6'
P00296   DC    A(Q00161)
         DC    A(T00173)
         DC    A(0)
         DC    XL1'80',FL3'6'
P00298   DC    A(Q00162)
         DC    A(T00174)
         DC    A(0)
         DC    XL1'80',FL3'6'
P00300   DC    A(Q00163)
         DC    A(T00175)
         DC    A(0)
         DC    XL1'80',FL3'6'
P00302   DC    A(Q00164)
         DC    A(T00176)
         DC    A(0)
         DC    XL1'80',FL3'6'
P00304   DC    A(Q00165)
         DC    A(T00177)
         DC    A(0)
         DC    XL1'80',FL3'6'
P00306   DC    A(Q00166)
         DC    A(T00178)
         DC    A(0)
         DC    XL1'80',FL3'6'
P00308   DC    A(Q00167)
         DC    A(T00179)
         DC    A(0)
         DC    XL1'80',FL3'6'
C00225   DC    X'4E00000080000000'
C00223   DC    X'4017FCB9'
C00224   DC    F'-2147483648'
C00227   DC    V(RAPPLY1)
C00229   DC    V(SQRT)
C00232   DC    F'1'
C00234   DC    V(EXP)
C00238   DC    V(LOG)
C00242   DC    V(LOG10)
C00246   DC    V(SIN)
C00250   DC    V(COS)
C00254   DC    V(TAN)
C00258   DC    V(ASIN)
C00262   DC    V(ACOS)
C00266   DC    V(ATAN)
C00270   DC    V(SINH)
C00274   DC    V(COSH)
C00278   DC    V(TANH)
C00281   DC    F'0'
C00284   DC    V(CHK)
Q00155   DC    C'SQRT  '
Q00156   DC    C'EXP   '
Q00157   DC    C'ALOG  '
Q00158   DC    C'ALOG10'
Q00159   DC    C'SIN   '
Q00160   DC    C'COS   '
Q00161   DC    C'TAN   '
Q00162   DC    C'ASIN  '
Q00163   DC    C'ACOS  '
Q00164   DC    C'ATAN  '
Q00165   DC    C'SINH  '
Q00166   DC    C'COSH  '
Q00167   DC    C'TANH  '
* OLDWAY
OLDWAY   CSECT
         USING *,15
         B     L00324
         DC    AL1(6),CL7'OLDWAY'
L00324   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00325
L00326   DC    A(S00309)
L00325   L     15,L00326
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00309,13
         ST    1,S00309+72
L00321   DS    0H
         L     4,0(,1)
         LA    4,0(,4)
         MVC   T00319(4),C00327
         MVC   T00319+4(4),C00328
         MVC   T00320(4),C00329
         LA    1,P00330
         L     15,C00331
         BALR  14,15
         STE   0,S00309+272
         LE    0,C00329
         STE   0,P00332+0
         LA    1,P00332
         L     15,C00333
         BALR  14,15
         LE    2,S00309+272
         CER   2,0
         LA    2,1
         BC    8,L00334
         SR    2,2
L00334   DS    0H
         LE    0,C00329
         STE   0,P00332+0
         LA    1,P00332
         L     15,C00333
         BALR  14,15
         SE    0,C00335
         LPER  0,0
         CE    0,C00336
         LA    3,1
         BC    4,L00337
         SR    3,3
L00337   DS    0H
         NR    2,3
         ST    2,T00313
         LR    0,4
         ST    0,P00338+8
         LA    1,P00338
         L     15,C00339
         BALR  14,15
         MVC   T00314(4),C00327
         LA    1,P00340
         L     15,C00331
         BALR  14,15
         STE   0,S00309+272
         LE    0,C00327
         STE   0,P00332+0
         LA    1,P00332
         L     15,C00341
         BALR  14,15
         LE    2,S00309+272
         CER   2,0
         LA    2,1
         BC    8,L00342
         SR    2,2
L00342   DS    0H
         LE    0,C00327
         STE   0,P00332+0
         LA    1,P00332
         L     15,C00341
         BALR  14,15
         SE    0,C00343
         LPER  0,0
         CE    0,C00336
         LA    3,1
         BC    4,L00344
         SR    3,3
L00344   DS    0H
         NR    2,3
         ST    2,T00315
         LR    0,4
         ST    0,P00345+8
         LA    1,P00345
         L     15,C00339
         BALR  14,15
         LA    1,P00346
         L     15,C00347
         BALR  14,15
         STE   0,S00309+272
         STE   2,S00309+280
         LE    0,T00319
         STE   0,S00309+288
         LE    0,T00319+4
         STE   0,S00309+296
         LE    0,S00309+288
         STE   0,P00348+4
         LE    0,S00309+296
         STE   0,P00348+8
         LA    1,P00348
         L     15,C00349
         BALR  14,15
         LE    0,T00317+4
         LE    2,S00309+272
         CE    2,T00317
         LA    2,1
         BC    8,L00350
         SR    2,2
L00350   DS    0H
         LE    2,S00309+280
         CER   2,0
         LA    3,1
         BC    8,L00351
         SR    3,3
L00351   DS    0H
         NR    2,3
         LE    0,T00319
         STE   0,S00309+272
         LE    0,T00319+4
         STE   0,S00309+280
         LE    0,S00309+272
         STE   0,P00352+4
         LE    0,S00309+280
         STE   0,P00352+8
         LA    1,P00352
         L     15,C00349
         BALR  14,15
         LE    0,T00318
         SE    0,C00353
         LPER  0,0
         CE    0,C00336
         LA    3,1
         BC    4,L00354
         SR    3,3
L00354   DS    0H
         NR    2,3
         ST    2,T00316
         LR    0,4
         ST    0,P00355+8
         LA    1,P00355
         L     15,C00339
         BALR  14,15
         LA    0,0
         B     L00323
L00322   DS    0H
L00323   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00309   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00313   DS    XL4
         DS    XL4
T00314   DS    XL4
         DS    XL4
T00315   DS    XL4
         DS    XL4
T00316   DS    XL4
         DS    XL4
T00317   DS    XL8
T00318   DS    XL8
T00319   DS    XL24
T00320   DS    XL24
         DS    4D
P00330   DC    V(I#SQRT)
         DC    XL1'80',AL3(T00320)
P00332   DC    A(0)
         DC    F'0'
P00338   DC    A(Q00310)
         DC    A(T00313)
         DC    A(0)
         DC    XL1'80',FL3'6'
P00340   DC    V(I#SIN)
         DC    XL1'80',AL3(T00314)
P00345   DC    A(Q00311)
         DC    A(T00315)
         DC    A(0)
         DC    XL1'80',FL3'6'
P00346   DC    V(I#CSQRT)
         DC    XL1'80',AL3(T00319)
P00348   DC    A(T00317)
         DC    A(0)
         DC    A(0)
         DS    F
P00352   DC    A(T00318)
         DC    A(0)
         DC    A(0)
P00355   DC    A(Q00312)
         DC    A(T00316)
         DC    A(0)
         DC    XL1'80',FL3'6'
         DS    XL4
C00327   DC    X'40800000'
C00328   DC    X'41140000'
C00329   DC    X'41200000'
C00331   DC    V(RAPPLY1)
C00333   DC    V(SQRT)
C00335   DC    X'4116A09E'
C00336   DC    X'3C10C6F8'
C00339   DC    V(CHK)
C00341   DC    V(SIN)
C00343   DC    X'407ABBA2'
C00347   DC    V(CAPPLY)
C00349   DC    V(F77CSQRT)
C00353   DC    X'40F5F74C'
Q00310   DC    C'XSQRT '
Q00311   DC    C'XSIN  '
Q00312   DC    C'XCSQRT'
* CAPPLY
CAPPLY   CSECT
         USING *,15
         B     L00359
         DC    AL1(6),CL7'CAPPLY'
L00359   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00360
L00361   DC    A(S00356)
L00360   L     15,L00361
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00356,13
         ST    1,S00356+72
L00357   DS    0H
         L     3,0(,1)
         L     2,4(,1)
         LA    2,0(,2)
         LR    0,2
         ST    0,P00362+0
         OI    P00362+0,X'80'
         LA    1,P00362
         LR    15,3
         BALR  14,15
         STE   0,S00356+176
         LER   0,2
         LER   2,0
         LE    0,S00356+176
L00358   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00356   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
         DS    1D
P00362   DC    XL1'80',AL3(0)
         DS    XL4
* ZAPPLY
ZAPPLY   CSECT
         USING *,15
         B     L00366
         DC    AL1(6),CL7'ZAPPLY'
L00366   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00367
L00368   DC    A(S00363)
L00367   L     15,L00368
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00363,13
         ST    1,S00363+72
L00364   DS    0H
         L     3,0(,1)
         L     2,4(,1)
         LA    2,0(,2)
         LR    0,2
         ST    0,P00369+0
         OI    P00369+0,X'80'
         LA    1,P00369
         LR    15,3
         BALR  14,15
         STD   0,S00363+176
         LDR   0,2
         LDR   2,0
         LD    0,S00363+176
L00365   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00363   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
         DS    1D
P00369   DC    XL1'80',AL3(0)
         DS    XL4
* RAPPLY
RAPPLY   CSECT
         USING *,15
         B     L00373
         DC    AL1(6),CL7'RAPPLY'
L00373   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00374
L00375   DC    A(S00370)
L00374   L     15,L00375
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00370,13
         ST    1,S00370+72
L00371   DS    0H
         L     3,0(,1)
         L     2,4(,1)
         LA    2,0(,2)
         LR    0,2
         ST    0,P00376+0
         OI    P00376+0,X'80'
         LA    1,P00376
         LR    15,3
         BALR  14,15
L00372   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00370   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00376   DC    XL1'80',AL3(0)
         DS    XL4
* RAPPLY1
RAPPLY1  CSECT
         USING *,15
         B     L00380
         DC    AL1(7),CL7'RAPPLY1'
L00380   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00381
L00382   DC    A(S00377)
L00381   L     15,L00382
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00377,13
         ST    1,S00377+72
L00378   DS    0H
         L     3,0(,1)
         L     2,4(,1)
         LA    2,0(,2)
         LR    0,2
         ST    0,P00383+0
         OI    P00383+0,X'80'
         LA    1,P00383
         LR    15,3
         BALR  14,15
L00379   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00377   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00383   DC    XL1'80',AL3(0)
         DS    XL4
* DAPPLY
DAPPLY   CSECT
         USING *,15
         B     L00387
         DC    AL1(6),CL7'DAPPLY'
L00387   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00388
L00389   DC    A(S00384)
L00388   L     15,L00389
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00384,13
         ST    1,S00384+72
L00385   DS    0H
         L     3,0(,1)
         L     2,4(,1)
         LA    2,0(,2)
         LR    0,2
         ST    0,P00390+0
         OI    P00390+0,X'80'
         LA    1,P00390
         LR    15,3
         BALR  14,15
L00386   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00384   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00390   DC    XL1'80',AL3(0)
         DS    XL4
* CHK
CHK      CSECT
         USING *,15
         B     L00401
         DC    AL1(3),CL7'CHK'
L00401   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00402
L00403   DC    A(S00391)
L00402   L     15,L00403
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00391,13
         ST    1,S00391+72
L00394   DS    0H
         L     5,0(,1)
         L     4,4(,1)
         L     3,8(,1)
         L     2,0(,4)
         LTR   2,2
         BC    7,L00395
L00396   DS    0H
         LA    1,P00404
         L     15,C00405
         BALR  14,15
         LR    0,5
         ST    0,P00406+0
         LA    1,P00406
         L     15,C00407
         BALR  14,15
         L     15,C00408
         BALR  14,15
L00399   DS    0H
         L     2,0(,3)
         A     2,C00409
         ST    2,0(,3)
L00397   DS    0H
         LA    0,0
         B     L00400
L00395   DS    0H
         LA    1,P00410
         L     15,C00405
         BALR  14,15
         LR    0,5
         ST    0,P00406+0
         LA    1,P00406
         L     15,C00407
         BALR  14,15
         L     15,C00408
         BALR  14,15
L00398   DS    0H
         B     L00397
L00400   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00391   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00404   DC    F'6'
         DC    A(Q00393)
P00406   DC    A(0)
         DC    F'6'
P00410   DC    F'6'
         DC    A(Q00392)
C00405   DC    V(F77WRBEG)
C00407   DC    V(F77WRA)
C00408   DC    V(F77WREND)
C00409   DC    F'1'
Q00392   DC    C'('' >'',A6,'' OK'')'
Q00393   DC    C'('' >'',A6,'' BAD'')'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
