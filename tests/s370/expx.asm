* main
F77MAIN  CSECT
         USING *,15
         B     L00053
         DC    AL1(7),CL7'F77MAIN'
L00053   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00054
L00055   DC    A(S00000)
L00054   L     15,L00055
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00028   DS    0H
         LA    15,0
         ST    15,T00027
         LD    0,C00057
         STD   0,P00056+0
         LA    1,P00056
         L     15,C00058
         BALR  14,15
         CD    0,C00059
         LA    2,1
         BC    8,L00060
         SR    2,2
L00060   DS    0H
         ST    2,T00015
         LA    1,P00061
         L     15,C00062
         BALR  14,15
         LD    0,C00059
         STD   0,P00056+0
         LA    1,P00056
         L     15,C00058
         BALR  14,15
         SD    0,C00063
         LPDR  0,0
         CD    0,C00064
         LA    2,1
         BC    4,L00065
         SR    2,2
L00065   DS    0H
         ST    2,T00016
         LA    1,P00066
         L     15,C00062
         BALR  14,15
         LD    0,C00067
         LCDR  0,0
         STD   0,S00000+384
         LD    0,S00000+384
         STD   0,P00056+0
         LA    1,P00056
         L     15,C00058
         BALR  14,15
         CD    0,C00057
         LA    2,1
         BC    8,L00068
         SR    2,2
L00068   DS    0H
         ST    2,T00017
         LA    1,P00069
         L     15,C00062
         BALR  14,15
         LD    0,C00059
         STD   0,P00056+0
         LA    1,P00056
         L     15,C00070
         BALR  14,15
         CD    0,C00057
         LA    2,1
         BC    8,L00071
         SR    2,2
L00071   DS    0H
         ST    2,T00018
         LA    1,P00072
         L     15,C00062
         BALR  14,15
         LD    0,C00073
         STD   0,P00056+0
         LA    1,P00056
         L     15,C00074
         BALR  14,15
         SD    0,C00075
         LPDR  0,0
         CD    0,C00064
         LA    2,1
         BC    4,L00076
         SR    2,2
L00076   DS    0H
         ST    2,T00019
         LA    1,P00077
         L     15,C00062
         BALR  14,15
         LD    0,C00075
         STD   0,P00078+0
         LD    0,C00079
         STD   0,P00078+8
         LA    1,P00078
         L     15,C00080
         BALR  14,15
         CD    0,C00081
         LA    2,1
         BC    8,L00082
         SR    2,2
L00082   DS    0H
         ST    2,T00020
         LA    1,P00083
         L     15,C00062
         BALR  14,15
         LD    0,C00075
         STD   0,P00078+0
         LD    0,C00057
         STD   0,P00078+8
         LA    1,P00078
         L     15,C00080
         BALR  14,15
         CD    0,C00059
         LA    2,1
         BC    8,L00084
         SR    2,2
L00084   DS    0H
         ST    2,T00021
         LA    1,P00085
         L     15,C00062
         BALR  14,15
         L     15,C00086
         L     14,C00088
         ST    15,0(,14)
         LA    15,0
         L     14,C00089
         ST    15,0(,14)
         L     14,C00088
         LD    0,0(,14)
         STD   0,S00000+384
         LD    0,S00000+384
         STD   0,P00056+0
         LA    1,P00056
         L     15,C00070
         BALR  14,15
         STD   0,S00000+392
         LD    0,C00090
         STD   0,P00056+0
         LA    1,P00056
         L     15,C00070
         BALR  14,15
         LD    2,S00000+392
         CDR   2,0
         LA    2,1
         BC    8,L00091
         SR    2,2
L00091   DS    0H
         ST    2,T00022
         LA    1,P00092
         L     15,C00062
         BALR  14,15
         LD    0,C00067
         STD   0,P00056+0
         LA    1,P00056
         L     15,C00058
         BALR  14,15
         LD    2,C00093
         CDR   2,0
         LA    2,1
         BC    4,L00094
         SR    2,2
L00094   DS    0H
         ST    2,T00023
         LA    1,P00095
         L     15,C00062
         BALR  14,15
         LD    0,C00073
         LCDR  0,0
         STD   0,S00000+384
         LD    0,S00000+384
         STD   0,P00056+0
         LA    1,P00056
         L     15,C00070
         BALR  14,15
         STD   0,S00000+392
         LD    0,C00073
         STD   0,P00056+0
         LA    1,P00056
         L     15,C00070
         BALR  14,15
         LDR   2,0
         LD    0,S00000+392
         SDR   0,2
         LPDR  0,0
         CD    0,C00057
         LA    2,1
         BC    8,L00096
         SR    2,2
L00096   DS    0H
         ST    2,T00024
         LA    1,P00097
         L     15,C00062
         BALR  14,15
         LD    0,C00057
         STD   0,P00078+0
         LD    0,C00075
         STD   0,P00078+8
         LA    1,P00078
         L     15,C00080
         BALR  14,15
         CD    0,C00057
         LA    2,1
         BC    8,L00098
         SR    2,2
L00098   DS    0H
         ST    2,T00025
         LA    1,P00099
         L     15,C00062
         BALR  14,15
         LD    0,C00079
         STD   0,P00078+0
         LD    0,C00073
         STD   0,P00078+8
         LA    1,P00078
         L     15,C00080
         BALR  14,15
         LD    2,C00093
         CDR   2,0
         LA    2,1
         BC    4,L00100
         SR    2,2
L00100   DS    0H
         ST    2,T00026
         LA    1,P00101
         L     15,C00062
         BALR  14,15
         LA    10,1
L00029   DS    0H
         LA    11,4
         LR    9,10
         LH    2,C00102
L00030   DS    0H
L00032   DS    0H
         C     9,C00103
         LA    8,1
         BC    8,L00104
         SR    8,8
L00104   DS    0H
         LH    6,C00105
         LA    7,0
         L     5,C00106
         LA    3,0
L00033   DS    0H
         LR    4,2
         SLL   4,13
         XR    2,4
         LR    4,2
         SRL   4,17
         XR    2,4
         LR    4,2
         SLL   4,5
         XR    2,4
L00035   DS    0H
         LTR   8,8
         BC    7,L00036
L00037   DS    0H
         C     9,C00107
         BC    12,L00040
L00041   DS    0H
         LR    4,2
         N     4,C00108
         LR    0,4
         X     0,C00109
         ST    0,S00000+84
         LD    2,S00000+80
         SD    2,C00110
         LD    0,C00111
         DDR   2,0
         L     14,C00088
         STD   2,0(,14)
         LD    0,C00079
         MDR   0,2
         LD    2,C00112
         LDR   4,0
         SDR   4,2
         STD   4,S00000+384
         LD    0,C00079
         STD   0,P00078+0
         LD    0,S00000+384
         STD   0,P00078+8
         LA    1,P00078
         L     15,C00080
         BALR  14,15
         STD   0,S00000+392
         LR    4,2
         SLL   4,13
         XR    2,4
         LR    4,2
         SRL   4,17
         XR    2,4
         LR    4,2
         SLL   4,5
         XR    2,4
L00047   DS    0H
         LR    4,2
         N     4,C00108
         LR    0,4
         X     0,C00109
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00110
         LD    2,C00111
         DDR   0,2
         LD    2,C00113
         SDR   0,2
         LD    2,C00114
         LDR   4,0
         MDR   4,2
         STD   4,S00000+384
         LD    0,S00000+392
         STD   0,P00078+0
         LD    0,S00000+384
         STD   0,P00078+8
         LA    1,P00078
         L     15,C00080
         BALR  14,15
         L     14,C00116
         STD   0,0(,14)
L00038   DS    0H
         LR    4,3
         SLL   4,5
         SRL   3,27
         OR    4,3
         L     15,C00116
         X     4,0(,15)
         LR    3,4
         SLL   3,7
         SRL   4,25
         OR    3,4
         L     15,C00116
         X     3,4(,15)
L00048   DS    0H
         BXH   5,6,L00033
L00034   DS    0H
         LA    1,P00117
         L     15,C00118
         BALR  14,15
         LR    0,9
         ST    0,P00119+0
         LA    1,P00119
         L     15,C00120
         BALR  14,15
         LR    0,3
         ST    0,P00119+0
         LA    1,P00119
         L     15,C00120
         BALR  14,15
         L     15,C00121
         BALR  14,15
L00049   DS    0H
L00050   DS    0H
         BXLE  9,10,L00030
L00031   DS    0H
         LA    1,P00122
         L     15,C00118
         BALR  14,15
         L     3,T00027
         LR    0,3
         ST    0,P00119+0
         LA    1,P00119
         L     15,C00120
         BALR  14,15
         L     15,C00121
         BALR  14,15
L00051   DS    0H
         B     L00052
L00036   DS    0H
         LR    4,2
         N     4,C00108
         LR    0,4
         X     0,C00109
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00110
         LD    2,C00111
         DDR   0,2
         L     14,C00088
         STD   0,0(,14)
         LR    4,2
         SLL   4,13
         XR    2,4
         LR    4,2
         SRL   4,17
         XR    2,4
         LR    4,2
         SLL   4,5
         XR    2,4
L00039   DS    0H
         LR    4,2
         N     4,C00123
         LR    0,4
         X     0,C00109
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00110
         LD    2,C00124
         DDR   0,2
         L     15,C00088
         AD    0,0(,15)
         LD    2,C00125
         MDR   0,2
         LD    2,C00126
         LDR   4,0
         SDR   4,2
         STD   4,S00000+384
         L     14,C00088
         MVC   0(8,14),S00000+384
         LD    0,S00000+384
         STD   0,P00056+0
         LA    1,P00056
         L     15,C00058
         BALR  14,15
         L     14,C00116
         STD   0,0(,14)
         B     L00038
L00040   DS    0H
         LR    4,2
         N     4,C00108
         O     4,C00127
         L     14,C00088
         ST    4,0(,14)
         LR    4,2
         SLL   4,13
         XR    2,4
         LR    4,2
         SRL   4,17
         XR    2,4
         LR    4,2
         SLL   4,5
         XR    2,4
L00042   DS    0H
         L     14,C00089
         ST    2,0(,14)
         C     9,C00128
         BC    7,L00044
L00043   DS    0H
         L     14,C00088
         LD    0,0(,14)
         STD   0,S00000+384
         LD    0,S00000+384
         STD   0,P00056+0
         LA    1,P00056
         L     15,C00070
         BALR  14,15
         L     14,C00116
         STD   0,0(,14)
L00044   DS    0H
         C     9,C00107
         BC    7,L00046
L00045   DS    0H
         L     14,C00088
         LD    0,0(,14)
         STD   0,S00000+384
         LD    0,S00000+384
         STD   0,P00056+0
         LA    1,P00056
         L     15,C00074
         BALR  14,15
         L     14,C00116
         STD   0,0(,14)
L00046   DS    0H
         B     L00038
L00052   DS    0H
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
T00015   DS    XL4
         DS    XL4
T00016   DS    XL4
         DS    XL4
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
T00027   DS    XL112
         DS    2D
P00056   DC    A(0)
         DC    A(0)
P00061   DC    A(Q00001)
         DC    A(T00015)
         DC    A(T00027)
         DC    XL1'80',FL3'7'
P00066   DC    A(Q00002)
         DC    A(T00016)
         DC    A(T00027)
         DC    XL1'80',FL3'7'
P00069   DC    A(Q00003)
         DC    A(T00017)
         DC    A(T00027)
         DC    XL1'80',FL3'7'
P00072   DC    A(Q00004)
         DC    A(T00018)
         DC    A(T00027)
         DC    XL1'80',FL3'7'
P00077   DC    A(Q00005)
         DC    A(T00019)
         DC    A(T00027)
         DC    XL1'80',FL3'7'
P00078   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
P00083   DC    A(Q00006)
         DC    A(T00020)
         DC    A(T00027)
         DC    XL1'80',FL3'7'
P00085   DC    A(Q00007)
         DC    A(T00021)
         DC    A(T00027)
         DC    XL1'80',FL3'7'
P00092   DC    A(Q00008)
         DC    A(T00022)
         DC    A(T00027)
         DC    XL1'80',FL3'7'
P00095   DC    A(Q00009)
         DC    A(T00023)
         DC    A(T00027)
         DC    XL1'80',FL3'7'
P00097   DC    A(Q00010)
         DC    A(T00024)
         DC    A(T00027)
         DC    XL1'80',FL3'7'
P00099   DC    A(Q00011)
         DC    A(T00025)
         DC    A(T00027)
         DC    XL1'80',FL3'7'
P00101   DC    A(Q00012)
         DC    A(T00026)
         DC    A(T00027)
         DC    XL1'80',FL3'7'
P00117   DC    F'6'
         DC    A(Q00014)
P00119   DC    A(0)
P00122   DC    F'6'
         DC    A(Q00013)
         DS    XL4
C00057   DC    X'0000000000000000'
C00059   DC    X'4110000000000000'
C00063   DC    X'412B7E151628AED2'
C00064   DC    X'34480EBE7B9D5856'
C00067   DC    X'42C8000000000000'
C00073   DC    X'4264000000000000'
C00075   DC    X'4120000000000000'
C00079   DC    X'41A0000000000000'
C00081   DC    X'4340000000000000'
C00090   DC    X'4010000000000000'
C00093   DC    X'7FF79DC0E8C518F3'
C00110   DC    X'4E00000080000000'
C00111   DC    X'4880000000000000'
C00112   DC    X'4150000000000000'
C00113   DC    X'4080000000000000'
C00114   DC    X'421C000000000000'
C00124   DC    X'4AE8D4A510000000'
C00125   DC    X'431629999999999A'
C00126   DC    X'42B4000000000000'
C00058   DC    V(DEXP)
C00062   DC    V(CHK)
C00070   DC    V(DLOG)
C00074   DC    V(DLOG10)
C00080   DC    V(DPOW)
C00086   DC    F'1090584576'
C00088   DC    A(G00087)
C00089   DC    A(G00087+4)
C00103   DC    F'1'
C00106   DC    F'100000'
C00107   DC    F'3'
C00108   DC    F'2147483647'
C00109   DC    F'-2147483648'
C00116   DC    A(G00115)
C00118   DC    V(F77WRBEG)
C00120   DC    V(F77WRI)
C00121   DC    V(F77WREND)
C00123   DC    F'1048575'
C00127   DC    F'1048576'
C00128   DC    F'2'
C00102   DC    H'12345'
C00105   DC    H'-1'
Q00014   DC    C'('' >HASH'',I1,1X,Z8)'
Q00013   DC    C'('' >BAD '',I2)'
Q00001   DC    C'EXP0   '
Q00002   DC    C'EXP1   '
Q00003   DC    C'EXPLOW '
Q00004   DC    C'LOG1   '
Q00005   DC    C'LOG10  '
Q00006   DC    C'POW2   '
Q00007   DC    C'POW0   '
Q00008   DC    C'UNNORM '
Q00009   DC    C'EXPBIG '
Q00010   DC    C'LOGNEG '
Q00011   DC    C'POWZERO'
Q00012   DC    C'POWBIG '
* XSH
XSH      CSECT
         USING *,15
         B     L00132
         DC    AL1(3),CL7'XSH'
L00132   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00133
L00134   DC    A(S00129)
L00133   L     15,L00134
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00129,13
         ST    1,S00129+72
L00130   DS    0H
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
L00131   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00129   DS    0D
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
         B     L00145
         DC    AL1(3),CL7'CHK'
L00145   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00146
L00147   DC    A(S00135)
L00146   L     15,L00147
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00135,13
         ST    1,S00135+72
L00138   DS    0H
         L     5,0(,1)
         L     4,4(,1)
         L     3,8(,1)
         L     2,0(,4)
         LTR   2,2
         BC    7,L00139
L00140   DS    0H
         LA    1,P00148
         L     15,C00149
         BALR  14,15
         LR    0,5
         ST    0,P00150+0
         LA    1,P00150
         L     15,C00151
         BALR  14,15
         L     15,C00152
         BALR  14,15
L00143   DS    0H
         L     2,0(,3)
         A     2,C00153
         ST    2,0(,3)
L00141   DS    0H
         LA    0,0
         B     L00144
L00139   DS    0H
         LA    1,P00154
         L     15,C00149
         BALR  14,15
         LR    0,5
         ST    0,P00150+0
         LA    1,P00150
         L     15,C00151
         BALR  14,15
         L     15,C00152
         BALR  14,15
L00142   DS    0H
         B     L00141
L00144   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00135   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00148   DC    F'6'
         DC    A(Q00137)
P00150   DC    A(0)
         DC    F'7'
P00154   DC    F'6'
         DC    A(Q00136)
C00149   DC    V(F77WRBEG)
C00151   DC    V(F77WRA)
C00152   DC    V(F77WREND)
C00153   DC    F'1'
Q00136   DC    C'('' >'',A7,'' OK'')'
Q00137   DC    C'('' >'',A7,'' BAD'')'
G00087   CSECT
         DS    0D
         DS    XL8
G00115   CSECT
         DS    0D
         DS    XL8
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
