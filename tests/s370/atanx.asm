* main
F77MAIN  CSECT
         USING *,15
         B     L00066
         DC    AL1(7),CL7'F77MAIN'
L00066   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00067
L00068   DC    A(S00000)
L00067   L     15,L00068
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00032   DS    0H
         LA    15,0
         ST    15,T00031
         LD    0,C00070
         STD   0,P00069+0
         LA    1,P00069
         L     15,C00071
         BALR  14,15
         CD    0,C00070
         LA    2,1
         BC    8,L00072
         SR    2,2
L00072   DS    0H
         ST    2,T00017
         LA    1,P00073
         L     15,C00074
         BALR  14,15
         LD    0,C00075
         STD   0,P00069+0
         LA    1,P00069
         L     15,C00071
         BALR  14,15
         LD    2,C00076
         DD    2,C00077
         SDR   0,2
         LPDR  0,0
         CD    0,C00078
         LA    2,1
         BC    4,L00079
         SR    2,2
L00079   DS    0H
         ST    2,T00018
         LA    1,P00080
         L     15,C00074
         BALR  14,15
         LD    0,C00081
         LCDR  0,0
         STD   0,S00000+400
         LD    0,S00000+400
         STD   0,P00069+0
         LA    1,P00069
         L     15,C00071
         BALR  14,15
         LD    2,C00076
         DD    2,C00082
         ADR   0,2
         LPDR  0,0
         CD    0,C00078
         LA    2,1
         BC    4,L00083
         SR    2,2
L00083   DS    0H
         ST    2,T00019
         LA    1,P00084
         L     15,C00074
         BALR  14,15
         LD    0,C00075
         LCDR  0,0
         STD   0,S00000+400
         LD    0,S00000+400
         STD   0,P00069+0
         LA    1,P00069
         L     15,C00085
         BALR  14,15
         LD    2,C00076
         DD    2,C00082
         ADR   0,2
         LPDR  0,0
         CD    0,C00078
         LA    2,1
         BC    4,L00086
         SR    2,2
L00086   DS    0H
         ST    2,T00020
         LA    1,P00087
         L     15,C00074
         BALR  14,15
         LD    0,C00075
         STD   0,P00069+0
         LA    1,P00069
         L     15,C00088
         BALR  14,15
         CD    0,C00070
         LA    2,1
         BC    8,L00089
         SR    2,2
L00089   DS    0H
         ST    2,T00021
         LA    1,P00090
         L     15,C00074
         BALR  14,15
         LD    0,C00075
         LCDR  0,0
         STD   0,S00000+400
         LD    0,S00000+400
         STD   0,P00069+0
         LA    1,P00069
         L     15,C00088
         BALR  14,15
         SD    0,C00076
         LPDR  0,0
         CD    0,C00078
         LA    2,1
         BC    4,L00091
         SR    2,2
L00091   DS    0H
         ST    2,T00022
         LA    1,P00092
         L     15,C00074
         BALR  14,15
         LD    0,C00093
         STD   0,P00069+0
         LA    1,P00069
         L     15,C00085
         BALR  14,15
         LD    2,C00076
         DD    2,C00094
         SDR   0,2
         LPDR  0,0
         CD    0,C00078
         LA    2,1
         BC    4,L00095
         SR    2,2
L00095   DS    0H
         ST    2,T00023
         LA    1,P00096
         L     15,C00074
         BALR  14,15
         LD    0,C00093
         LCDR  0,0
         STD   0,S00000+400
         LD    0,S00000+400
         STD   0,P00069+0
         LA    1,P00069
         L     15,C00088
         BALR  14,15
         LD    2,C00076
         MD    2,C00082
         DD    2,C00097
         SDR   0,2
         LPDR  0,0
         CD    0,C00078
         LA    2,1
         BC    4,L00098
         SR    2,2
L00098   DS    0H
         ST    2,T00024
         LA    1,P00099
         L     15,C00074
         BALR  14,15
         LD    0,C00100
         STD   0,P00069+0
         LA    1,P00069
         L     15,C00085
         BALR  14,15
         CD    0,C00070
         LA    2,1
         BC    8,L00101
         SR    2,2
L00101   DS    0H
         ST    2,T00025
         LA    1,P00102
         L     15,C00074
         BALR  14,15
         LD    0,C00100
         LCDR  0,0
         STD   0,S00000+400
         LD    0,S00000+400
         STD   0,P00069+0
         LA    1,P00069
         L     15,C00088
         BALR  14,15
         CD    0,C00070
         LA    2,1
         BC    8,L00103
         SR    2,2
L00103   DS    0H
         ST    2,T00026
         LA    1,P00104
         L     15,C00074
         BALR  14,15
         LD    0,C00075
         STD   0,P00105+0
         LD    0,C00070
         STD   0,P00105+8
         LA    1,P00105
         L     15,C00106
         BALR  14,15
         LD    2,C00076
         DD    2,C00082
         SDR   0,2
         LPDR  0,0
         CD    0,C00078
         LA    2,1
         BC    4,L00107
         SR    2,2
L00107   DS    0H
         ST    2,T00027
         LA    1,P00108
         L     15,C00074
         BALR  14,15
         LD    0,C00075
         LCDR  0,0
         STD   0,S00000+400
         LD    0,C00070
         STD   0,P00105+0
         LD    0,S00000+400
         STD   0,P00105+8
         LA    1,P00105
         L     15,C00106
         BALR  14,15
         SD    0,C00076
         LPDR  0,0
         CD    0,C00078
         LA    2,1
         BC    4,L00109
         SR    2,2
L00109   DS    0H
         ST    2,T00028
         LA    1,P00110
         L     15,C00074
         BALR  14,15
         LD    0,C00075
         LCDR  0,0
         STD   0,S00000+400
         LD    0,C00075
         LCDR  0,0
         STD   0,S00000+408
         LD    0,S00000+400
         STD   0,P00105+0
         LD    0,S00000+408
         STD   0,P00105+8
         LA    1,P00105
         L     15,C00106
         BALR  14,15
         LD    2,C00076
         MD    2,C00111
         ADR   0,2
         LPDR  0,0
         CD    0,C00078
         LA    2,1
         BC    4,L00112
         SR    2,2
L00112   DS    0H
         ST    2,T00029
         LA    1,P00113
         L     15,C00074
         BALR  14,15
         LD    0,C00070
         STD   0,P00105+0
         LD    0,C00070
         STD   0,P00105+8
         LA    1,P00105
         L     15,C00106
         BALR  14,15
         CD    0,C00070
         LA    2,1
         BC    8,L00114
         SR    2,2
L00114   DS    0H
         ST    2,T00030
         LA    1,P00115
         L     15,C00074
         BALR  14,15
         LA    10,1
L00033   DS    0H
         LA    8,1
         LR    4,10
         LH    2,C00116
L00034   DS    0H
L00036   DS    0H
         C     4,C00117
         LA    7,1
         BC    8,L00118
         SR    7,7
L00118   DS    0H
         L     9,C00119
         LR    5,8
         LA    3,0
L00037   DS    0H
         LR    6,2
         SLL   6,13
         XR    2,6
         LR    6,2
         SRL   6,17
         XR    2,6
         LR    6,2
         SLL   6,5
         XR    2,6
L00039   DS    0H
         LTR   7,7
         BC    7,L00040
L00041   DS    0H
         C     4,C00120
         BC    8,L00044
L00045   DS    0H
         LR    6,2
         N     6,C00121
         LR    0,6
         X     0,C00122
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00123
         LD    2,C00124
         DDR   0,2
         L     14,C00126
         STD   0,0(,14)
         LR    6,2
         SLL   6,13
         XR    2,6
         LR    6,2
         SRL   6,17
         XR    2,6
         LR    6,2
         SLL   6,5
         XR    2,6
L00052   DS    0H
         LR    0,5
         SRDA  0,32
         D     0,C00127
         LR    6,0
         C     6,C00128
         BC    7,L00054
L00053   DS    0H
         LD    0,C00075
         LD    2,C00129
         L     15,C00126
         MD    2,0(,15)
         SDR   0,2
         L     14,C00126
         STD   0,0(,14)
L00054   DS    0H
         LR    6,2
         N     6,C00130
         LR    0,6
         X     0,C00122
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00123
         LD    2,C00131
         DDR   0,2
         L     15,C00126
         AD    0,0(,15)
         L     14,C00126
         STD   0,0(,14)
         C     2,C00128
         BC    11,L00056
L00055   DS    0H
         L     14,C00126
         LD    0,0(,14)
         LCDR  0,0
         L     14,C00126
         STD   0,0(,14)
L00056   DS    0H
         C     4,C00127
         BC    7,L00058
L00057   DS    0H
         L     14,C00126
         LD    0,0(,14)
         STD   0,S00000+400
         LD    0,S00000+400
         STD   0,P00069+0
         LA    1,P00069
         L     15,C00085
         BALR  14,15
         L     14,C00133
         STD   0,0(,14)
L00058   DS    0H
         C     4,C00134
         BC    7,L00060
L00059   DS    0H
         L     14,C00126
         LD    0,0(,14)
         STD   0,S00000+400
         LD    0,S00000+400
         STD   0,P00069+0
         LA    1,P00069
         L     15,C00088
         BALR  14,15
         L     14,C00133
         STD   0,0(,14)
L00060   DS    0H
L00042   DS    0H
         LR    6,3
         SLL   6,5
         SRL   3,27
         OR    6,3
         L     15,C00133
         X     6,0(,15)
         LR    3,6
         SLL   3,7
         SRL   6,25
         OR    3,6
         L     15,C00133
         X     3,4(,15)
L00061   DS    0H
         BXLE  5,8,L00037
L00038   DS    0H
         LA    1,P00135
         L     15,C00136
         BALR  14,15
         LR    0,4
         ST    0,P00137+0
         LA    1,P00137
         L     15,C00138
         BALR  14,15
         LR    0,3
         ST    0,P00137+0
         LA    1,P00137
         L     15,C00138
         BALR  14,15
         L     15,C00139
         BALR  14,15
L00062   DS    0H
L00063   DS    0H
         AR    4,10
         C     4,C00120
         BC    12,L00034
L00035   DS    0H
         LA    1,P00140
         L     15,C00136
         BALR  14,15
         L     3,T00031
         LR    0,3
         ST    0,P00137+0
         LA    1,P00137
         L     15,C00138
         BALR  14,15
         L     15,C00139
         BALR  14,15
L00064   DS    0H
         B     L00065
L00040   DS    0H
         LR    6,2
         O     6,C00141
         L     14,C00126
         ST    6,0(,14)
         LR    6,2
         SLL   6,13
         XR    2,6
         LR    6,2
         SRL   6,17
         XR    2,6
         LR    6,2
         SLL   6,5
         XR    2,6
L00043   DS    0H
         L     14,C00142
         ST    2,0(,14)
         L     14,C00126
         LD    0,0(,14)
         STD   0,S00000+400
         LD    0,S00000+400
         STD   0,P00069+0
         LA    1,P00069
         L     15,C00071
         BALR  14,15
         L     14,C00133
         STD   0,0(,14)
         B     L00042
L00044   DS    0H
         LR    6,2
         N     6,C00143
         LR    11,2
         N     11,C00144
         LR    0,11
         SRDA  0,32
         D     0,C00145
         LR    11,0
         A     11,C00146
         SLL   11,24
         OR    6,11
         O     6,C00141
         L     14,C00126
         ST    6,0(,14)
         LR    6,2
         SLL   6,13
         XR    2,6
         LR    6,2
         SRL   6,17
         XR    2,6
         LR    6,2
         SLL   6,5
         XR    2,6
L00046   DS    0H
         L     14,C00142
         ST    2,0(,14)
         LR    6,2
         SLL   6,13
         XR    2,6
         LR    6,2
         SRL   6,17
         XR    2,6
         LR    6,2
         SLL   6,5
         XR    2,6
L00047   DS    0H
         LR    6,2
         N     6,C00121
         LR    0,6
         X     0,C00122
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00123
         LD    2,C00147
         MDR   0,2
         LR    0,5
         SRDA  0,32
         D     0,C00134
         LR    6,0
         C     6,C00128
         BC    7,L00049
L00048   DS    0H
         LCDR  0,0
L00049   DS    0H
         LR    0,5
         SRDA  0,32
         D     0,C00148
         LR    6,0
         C     6,C00128
         BC    8,L00050
         STD   0,S00000+400
         B     L00051
L00050   DS    0H
         LD    0,C00070
         STD   0,S00000+400
L00051   DS    0H
         L     14,C00126
         LD    0,0(,14)
         STD   0,S00000+408
         LD    0,S00000+408
         STD   0,P00105+0
         LD    0,S00000+400
         STD   0,P00105+8
         LA    1,P00105
         L     15,C00106
         BALR  14,15
         L     14,C00133
         STD   0,0(,14)
         B     L00042
L00065   DS    0H
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
T00017   DS    XL4
         DS    XL4
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
T00031   DS    XL112
         DS    2D
P00069   DC    A(0)
         DC    A(0)
P00073   DC    A(Q00001)
         DC    A(T00017)
         DC    A(T00031)
         DC    XL1'80',FL3'7'
P00080   DC    A(Q00002)
         DC    A(T00018)
         DC    A(T00031)
         DC    XL1'80',FL3'7'
P00084   DC    A(Q00003)
         DC    A(T00019)
         DC    A(T00031)
         DC    XL1'80',FL3'7'
P00087   DC    A(Q00004)
         DC    A(T00020)
         DC    A(T00031)
         DC    XL1'80',FL3'7'
P00090   DC    A(Q00005)
         DC    A(T00021)
         DC    A(T00031)
         DC    XL1'80',FL3'7'
P00092   DC    A(Q00006)
         DC    A(T00022)
         DC    A(T00031)
         DC    XL1'80',FL3'7'
P00096   DC    A(Q00007)
         DC    A(T00023)
         DC    A(T00031)
         DC    XL1'80',FL3'7'
P00099   DC    A(Q00008)
         DC    A(T00024)
         DC    A(T00031)
         DC    XL1'80',FL3'7'
P00102   DC    A(Q00009)
         DC    A(T00025)
         DC    A(T00031)
         DC    XL1'80',FL3'7'
P00104   DC    A(Q00010)
         DC    A(T00026)
         DC    A(T00031)
         DC    XL1'80',FL3'7'
P00105   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
P00108   DC    A(Q00011)
         DC    A(T00027)
         DC    A(T00031)
         DC    XL1'80',FL3'7'
P00110   DC    A(Q00012)
         DC    A(T00028)
         DC    A(T00031)
         DC    XL1'80',FL3'7'
P00113   DC    A(Q00013)
         DC    A(T00029)
         DC    A(T00031)
         DC    XL1'80',FL3'7'
P00115   DC    A(Q00014)
         DC    A(T00030)
         DC    A(T00031)
         DC    XL1'80',FL3'7'
P00135   DC    F'6'
         DC    A(Q00016)
P00137   DC    A(0)
P00140   DC    F'6'
         DC    A(Q00015)
         DS    XL4
C00070   DC    X'0000000000000000'
C00075   DC    X'4110000000000000'
C00076   DC    X'413243F6A8885A2F'
C00077   DC    X'4140000000000000'
C00078   DC    X'34480EBE7B9D5856'
C00081   DC    X'7B172EBAD6DDC73D'
C00082   DC    X'4120000000000000'
C00093   DC    X'4080000000000000'
C00094   DC    X'4160000000000000'
C00097   DC    X'4130000000000000'
C00100   DC    X'4118000000000000'
C00111   DC    X'40C0000000000000'
C00123   DC    X'4E00000080000000'
C00124   DC    X'4880000000000000'
C00129   DC    X'3B101B2B29A4692B'
C00131   DC    X'526194049F30F720'
C00147   DC    X'3E4189374BC6A7F0'
C00071   DC    V(DATAN)
C00074   DC    V(CHK)
C00085   DC    V(DASIN)
C00088   DC    V(DACOS)
C00106   DC    V(DATAN2)
C00117   DC    F'1'
C00119   DC    F'100000'
C00120   DC    F'4'
C00121   DC    F'2147483647'
C00122   DC    F'-2147483648'
C00126   DC    A(G00125)
C00127   DC    F'2'
C00128   DC    F'0'
C00130   DC    F'1048575'
C00133   DC    A(G00132)
C00134   DC    F'3'
C00136   DC    V(F77WRBEG)
C00138   DC    V(F77WRI)
C00139   DC    V(F77WREND)
C00141   DC    F'1048576'
C00142   DC    A(G00125+4)
C00143   DC    F'-2130706433'
C00144   DC    F'1023'
C00145   DC    F'32'
C00146   DC    F'48'
C00148   DC    F'1000'
C00116   DC    H'12345'
Q00016   DC    C'('' >HASH'',I1,1X,Z8)'
Q00015   DC    C'('' >BAD '',I2)'
Q00001   DC    C'ATAN0  '
Q00002   DC    C'ATAN1  '
Q00003   DC    C'ATANBIG'
Q00004   DC    C'ASIN1  '
Q00005   DC    C'ACOS1  '
Q00006   DC    C'ACOSM1 '
Q00007   DC    C'ASINH  '
Q00008   DC    C'ACOSH  '
Q00009   DC    C'ASINBAD'
Q00010   DC    C'ACOSBAD'
Q00011   DC    C'ATAN2Y '
Q00012   DC    C'ATAN2PI'
Q00013   DC    C'ATAN2Q3'
Q00014   DC    C'ATAN200'
* XSH
XSH      CSECT
         USING *,15
         B     L00152
         DC    AL1(3),CL7'XSH'
L00152   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00153
L00154   DC    A(S00149)
L00153   L     15,L00154
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00149,13
         ST    1,S00149+72
L00150   DS    0H
         L     4,0(,1)
         LA    4,0(,4)
         L     2,0(,4)
         LR    3,2
         SLL   3,13
         XR    2,3
         LR    3,2
         SRL   3,17
         XR    2,3
         LR    3,2
         SLL   3,5
         XR    2,3
         ST    2,0(,4)
         LA    0,0
L00151   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00149   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
* CHK
CHK      CSECT
         USING *,15
         B     L00165
         DC    AL1(3),CL7'CHK'
L00165   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00166
L00167   DC    A(S00155)
L00166   L     15,L00167
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00155,13
         ST    1,S00155+72
L00158   DS    0H
         L     5,0(,1)
         L     4,4(,1)
         L     3,8(,1)
         L     2,0(,4)
         LTR   2,2
         BC    7,L00159
L00160   DS    0H
         LA    1,P00168
         L     15,C00169
         BALR  14,15
         LR    0,5
         ST    0,P00170+0
         LA    1,P00170
         L     15,C00171
         BALR  14,15
         L     15,C00172
         BALR  14,15
L00163   DS    0H
         L     2,0(,3)
         A     2,C00173
         ST    2,0(,3)
L00161   DS    0H
         LA    0,0
         B     L00164
L00159   DS    0H
         LA    1,P00174
         L     15,C00169
         BALR  14,15
         LR    0,5
         ST    0,P00170+0
         LA    1,P00170
         L     15,C00171
         BALR  14,15
         L     15,C00172
         BALR  14,15
L00162   DS    0H
         B     L00161
L00164   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00155   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00168   DC    F'6'
         DC    A(Q00157)
P00170   DC    A(0)
         DC    F'7'
P00174   DC    F'6'
         DC    A(Q00156)
C00169   DC    V(F77WRBEG)
C00171   DC    V(F77WRA)
C00172   DC    V(F77WREND)
C00173   DC    F'1'
Q00156   DC    C'('' >'',A7,'' OK'')'
Q00157   DC    C'('' >'',A7,'' BAD'')'
G00125   CSECT
         DS    0D
         DS    XL8
G00132   CSECT
         DS    0D
         DS    XL8
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
