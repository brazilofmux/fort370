* main
F77MAIN  CSECT
         USING *,15
         B     L00046
         DC    AL1(7),CL7'F77MAIN'
L00046   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00047
L00048   DC    A(S00000)
L00047   L     15,L00048
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00027   DS    0H
         LA    15,0
         ST    15,T00026
         LA    15,0
         L     14,C00049
         ST    15,0(,14)
L00028   DS    0H
         L     6,C00050
         AH    6,C00051
         LA    4,4
         LA    5,40
         LA    2,4
         LA    3,1
L00029   DS    0H
         LR    0,3
         X     0,C00052
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00053
         LER   0,0
         STE   0,0(2,6)
L00031   DS    0H
         A     3,C00054
         BXLE  2,4,L00029
L00030   DS    0H
L00032   DS    0H
         LA    6,10
         LA    7,50
         LA    2,10
         LA    3,4
         LA    4,1
L00033   DS    0H
         LR    0,2
         X     0,C00052
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00053
         LER   0,0
         STE   0,T00023-4(3)
         ST    4,T00025-4(3)
L00035   DS    0H
         A     4,C00054
         A     3,C00055
         BXLE  2,6,L00033
L00034   DS    0H
         LE    2,C00056
         AE    2,C00057
         LE    0,C00056
         AE    0,T00023+4
         L     15,C00050
         AE    0,8(,15)
         AE    0,C00058
         LER   4,0
         AER   4,2
         STE   4,S00000+440
         MVC   T00022(4),C00059
         LA    1,P00060
         L     15,C00061
         BALR  14,15
         LE    2,S00000+440
         AER   2,0
         STE   2,S00000+448
L00036   DS    0H
         LE    0,C00062
         AE    0,C00059
         AE    0,C00058
         AE    0,C00057
         AE    0,C00063
         LE    2,S00000+448
         CER   2,0
         LA    2,1
         BC    8,L00064
         SR    2,2
L00064   DS    0H
         ST    2,T00012
         LA    1,P00065
         L     15,C00066
         BALR  14,15
         LE    2,S00000+448
         AE    2,C00057
         LE    0,S00000+448
         AE    0,T00023+4
         L     15,C00050
         AE    0,8(,15)
         AE    0,C00058
         LER   4,0
         AER   4,2
         STE   4,S00000+440
         MVC   T00021(4),C00059
         LA    1,P00067
         L     15,C00061
         BALR  14,15
         LE    2,S00000+440
         AER   2,0
L00037   DS    0H
         LE    0,C00068
         AE    0,C00062
         AE    0,C00059
         AE    0,C00058
         AE    0,C00069
         AE    0,C00063
         CER   2,0
         LA    2,1
         BC    8,L00070
         SR    2,2
L00070   DS    0H
         ST    2,T00013
         LA    1,P00071
         L     15,C00066
         BALR  14,15
         LA    15,0
         ST    15,T00017
L00038   DS    0H
         LA    4,4
         LA    5,20
         LA    2,4
L00039   DS    0H
         L     3,T00017
         A     3,T00025-4(2)
         ST    3,T00017
L00041   DS    0H
L00042   DS    0H
         BXLE  2,4,L00039
L00040   DS    0H
         L     3,T00017
         C     3,C00072
         LA    2,1
         BC    8,L00073
         SR    2,2
L00073   DS    0H
         ST    2,T00020
         LA    1,P00074
         L     15,C00066
         BALR  14,15
         LA    15,0
         ST    15,T00017
         LA    1,P00075
         L     15,C00076
         BALR  14,15
         L     3,T00017
         C     3,C00077
         LA    2,1
         BC    8,L00078
         SR    2,2
L00078   DS    0H
         L     14,C00049
         L     4,0(,14)
         C     4,C00077
         LA    3,1
         BC    8,L00079
         SR    3,3
L00079   DS    0H
         NR    2,3
         ST    2,T00014
         LA    1,P00080
         L     15,C00066
         BALR  14,15
         LA    1,P00081
         L     15,C00082
         BALR  14,15
         LA    1,P00083
         L     15,C00084
         BALR  14,15
         L     15,C00085
         BALR  14,15
         LA    1,P00086
         L     15,C00082
         BALR  14,15
         LA    1,P00087
         L     15,C00084
         BALR  14,15
         L     15,C00085
         BALR  14,15
         LA    1,P00088
         L     15,C00082
         BALR  14,15
         LA    1,P00087
         L     15,C00084
         BALR  14,15
         L     15,C00085
         BALR  14,15
L00043   DS    0H
         LA    1,P00089
         L     15,C00090
         BALR  14,15
         LR    3,15
         C     3,C00091
         LA    2,1
         BC    8,L00092
         SR    2,2
L00092   DS    0H
         LA    1,P00093
         L     15,C00090
         BALR  14,15
         LR    4,15
         C     4,C00091
         LA    3,1
         BC    8,L00094
         SR    3,3
L00094   DS    0H
         NR    2,3
         LA    1,P00095
         L     15,C00090
         BALR  14,15
         LR    4,15
         C     4,C00091
         LA    3,1
         BC    8,L00096
         SR    3,3
L00096   DS    0H
         NR    2,3
         ST    2,T00015
         LA    1,P00097
         L     15,C00066
         BALR  14,15
         LE    0,C00099
         STE   0,P00098+0
         LA    1,P00098
         L     15,C00100
         BALR  14,15
         SE    0,C00101
         LPER  0,0
         CE    0,C00102
         LA    2,1
         BC    4,L00103
         SR    2,2
L00103   DS    0H
         LE    0,C00099
         AE    0,C00099
         STE   0,S00000+440
         LE    0,S00000+440
         STE   0,P00098+0
         LA    1,P00098
         L     15,C00104
         BALR  14,15
         SE    0,C00105
         LPER  0,0
         CE    0,C00102
         LA    3,1
         BC    4,L00106
         SR    3,3
L00106   DS    0H
         NR    2,3
         ST    2,T00016
         LA    1,P00107
         L     15,C00066
         BALR  14,15
         LA    1,P00108
         L     15,C00109
         BALR  14,15
         L     3,T00026
         LR    0,3
         ST    0,P00110+0
         LA    1,P00110
         L     15,C00084
         BALR  14,15
         L     15,C00085
         BALR  14,15
L00044   DS    0H
L00045   DS    0H
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
T00012   DS    XL4
         DS    XL4
T00013   DS    XL4
         DS    XL4
T00014   DS    XL4
         DS    XL4
T00015   DS    XL4
         DS    XL4
T00016   DS    XL4
         DS    XL4
T00017   DS    XL8
T00018   DS    XL8
T00019   DS    XL8
T00020   DS    XL8
T00021   DS    XL12
         DS    XL4
T00022   DS    XL20
         DS    XL4
T00023   DS    XL24
T00024   DS    XL24
T00025   DS    XL48
T00026   DS    XL56
         DS    2D
P00060   DC    XL1'80',AL3(T00022)
P00065   DC    A(Q00001)
         DC    A(T00012)
         DC    A(T00026)
         DC    XL1'80',FL3'6'
P00067   DC    XL1'80',AL3(T00021)
P00071   DC    A(Q00002)
         DC    A(T00013)
         DC    A(T00026)
         DC    XL1'80',FL3'6'
P00074   DC    A(Q00003)
         DC    A(T00020)
         DC    A(T00026)
         DC    XL1'80',FL3'6'
P00075   DC    A(T00017)
         DC    XL1'80',AL3(T00025+8)
P00080   DC    A(Q00004)
         DC    A(T00014)
         DC    A(T00026)
         DC    XL1'80',FL3'6'
P00081   DC    A(T00024)
         DC    F'4'
         DC    F'1'
         DC    A(Q00005)
P00083   DC    F'7'
P00086   DC    A(T00018)
         DC    F'4'
         DC    F'1'
         DC    A(Q00005)
P00087   DC    F'0'
P00088   DC    A(T00019)
         DC    F'4'
         DC    F'1'
         DC    A(Q00005)
P00089   DC    A(T00024)
         DC    F'4'
         DC    A(Q00007)
         DC    F'4'
P00093   DC    A(T00018)
         DC    F'4'
         DC    A(Q00008)
         DC    F'4'
P00095   DC    A(T00019)
         DC    F'4'
         DC    A(Q00009)
         DC    F'4'
P00097   DC    A(Q00006)
         DC    A(T00015)
         DC    A(T00026)
         DC    XL1'80',FL3'6'
P00098   DC    A(0)
         DC    F'0'
P00107   DC    A(Q00010)
         DC    A(T00016)
         DC    A(T00026)
         DC    XL1'80',FL3'6'
P00108   DC    F'6'
         DC    A(Q00011)
P00110   DC    A(0)
         DS    XL4
C00053   DC    X'4E00000080000000'
C00049   DC    A(PLC+40)
C00050   DC    A(PLC)
C00052   DC    F'-2147483648'
C00054   DC    F'1'
C00055   DC    F'4'
C00056   DC    X'00000000'
C00057   DC    X'41100000'
C00058   DC    X'41400000'
C00059   DC    X'41300000'
C00061   DC    V(ADDR)
C00062   DC    X'42140000'
C00063   DC    X'41700000'
C00066   DC    V(CHK)
C00068   DC    X'42230000'
C00069   DC    X'42240000'
C00072   DC    F'15'
C00076   DC    V(PASSON)
C00077   DC    F'3'
C00082   DC    V(F77WRBI)
C00084   DC    V(F77WRI)
C00085   DC    V(F77WREND)
C00090   DC    V(F77STRCM)
C00091   DC    F'0'
C00099   DC    X'40400000'
C00100   DC    V(SQRT)
C00101   DC    X'40800000'
C00102   DC    X'3C10C6F8'
C00104   DC    V(EXP)
C00105   DC    X'411A612A'
C00109   DC    V(F77WRBEG)
C00051   DC    H'-4'
Q00005   DC    C'(I4)'
Q00011   DC    C'('' >BAD '',I2)'
Q00001   DC    C'CONST '
Q00002   DC    C'AGAIN '
Q00003   DC    C'SUBSCR'
Q00004   DC    C'DUMMY '
Q00006   DC    C'WRITE '
Q00007   DC    C'   7'
Q00008   DC    C'   0'
Q00009   DC    C'   0'
Q00010   DC    C'WIDEN '
* SUM5
SUM5     CSECT
         USING *,15
         B     L00115
         DC    AL1(4),CL7'SUM5'
L00115   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00116
L00117   DC    A(S00111)
L00116   L     15,L00117
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00111,13
         ST    1,S00111+72
L00113   DS    0H
         L     7,0(,1)
         L     6,4(,1)
         L     5,8(,1)
         L     4,12(,1)
         L     3,16(,1)
         L     2,20(,1)
         LA    2,0(,2)
         LE    0,0(,7)
         AE    0,0(,6)
         AE    0,0(,5)
         AE    0,0(,4)
         LE    2,0(,3)
         AER   2,0
         STE   2,S00111+184
         MVC   T00112(4),C00118
         LA    1,P00119
         LR    15,2
         BALR  14,15
         AE    0,S00111+184
         STE   0,0(,7)
         LA    0,0
L00114   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00111   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00112   DS    XL4
         DS    XL4
         DS    1D
P00119   DC    XL1'80',AL3(T00112)
         DS    XL4
C00118   DC    X'41300000'
* ADDR
ADDR     CSECT
         USING *,15
         B     L00123
         DC    AL1(4),CL7'ADDR'
L00123   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00124
L00125   DC    A(S00120)
L00124   L     15,L00125
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00120,13
         ST    1,S00120+72
L00121   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         LE    0,C00126
         AE    0,0(,2)
L00122   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00120   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00126   DC    X'41400000'
* ADDK
ADDK     CSECT
         USING *,15
         B     L00130
         DC    AL1(4),CL7'ADDK'
L00130   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00131
L00132   DC    A(S00127)
L00131   L     15,L00132
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00127,13
         ST    1,S00127+72
L00128   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         L     2,0(,4)
         A     2,0(,3)
         ST    2,0(,4)
         LA    0,0
L00129   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00127   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
* PASSON
PASSON   CSECT
         USING *,15
         B     L00138
         DC    AL1(6),CL7'PASSON'
L00138   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00139
L00140   DC    A(S00133)
L00139   L     15,L00140
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00133,13
         ST    1,S00133+72
L00134   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         L     2,0(,4)
         A     2,0(,3)
         ST    2,0(,4)
L00135   DS    0H
         L     14,C00141
         L     2,0(,14)
         A     2,0(,3)
         L     14,C00141
         ST    2,0(,14)
L00136   DS    0H
         LA    0,0
L00137   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00133   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00141   DC    A(PLC+40)
* CHK
CHK      CSECT
         USING *,15
         B     L00152
         DC    AL1(3),CL7'CHK'
L00152   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00153
L00154   DC    A(S00142)
L00153   L     15,L00154
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00142,13
         ST    1,S00142+72
L00145   DS    0H
         L     5,0(,1)
         L     4,4(,1)
         L     3,8(,1)
         L     2,0(,4)
         LTR   2,2
         BC    7,L00146
L00147   DS    0H
         LA    1,P00155
         L     15,C00156
         BALR  14,15
         LR    0,5
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00158
         BALR  14,15
         L     15,C00159
         BALR  14,15
L00150   DS    0H
         L     2,0(,3)
         A     2,C00160
         ST    2,0(,3)
L00148   DS    0H
         LA    0,0
         B     L00151
L00146   DS    0H
         LA    1,P00161
         L     15,C00156
         BALR  14,15
         LR    0,5
         ST    0,P00157+0
         LA    1,P00157
         L     15,C00158
         BALR  14,15
         L     15,C00159
         BALR  14,15
L00149   DS    0H
         B     L00148
L00151   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00142   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00155   DC    F'6'
         DC    A(Q00144)
P00157   DC    A(0)
         DC    F'6'
P00161   DC    F'6'
         DC    A(Q00143)
C00156   DC    V(F77WRBEG)
C00158   DC    V(F77WRA)
C00159   DC    V(F77WREND)
C00160   DC    F'1'
Q00143   DC    C'('' >'',A6,'' OK'')'
Q00144   DC    C'('' >'',A6,'' BAD'')'
PLC      CSECT
         DS    0D
         DS    XL44
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
