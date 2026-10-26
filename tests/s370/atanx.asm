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
L00024   DS    0H
         LA    15,0
         ST    15,T00023
         LD    0,C00054
         STD   0,P00053+0
         LA    1,P00053
         L     15,C00055
         BALR  14,15
         CD    0,C00054
         LA    2,1
         BC    8,L00056
         SR    2,2
L00056   DS    0H
         ST    2,T00013
         LA    1,P00057
         L     15,C00058
         BALR  14,15
         LD    0,C00059
         STD   0,P00053+0
         LA    1,P00053
         L     15,C00055
         BALR  14,15
         LD    2,C00060
         DD    2,C00061
         SDR   0,2
         LPDR  0,0
         CD    0,C00062
         LA    2,1
         BC    4,L00063
         SR    2,2
L00063   DS    0H
         ST    2,T00014
         LA    1,P00064
         L     15,C00058
         BALR  14,15
         LD    0,C00065
         LCDR  0,0
         STD   0,S00000+360
         LD    0,S00000+360
         STD   0,P00053+0
         LA    1,P00053
         L     15,C00055
         BALR  14,15
         LD    2,C00060
         DD    2,C00066
         ADR   0,2
         LPDR  0,0
         CD    0,C00062
         LA    2,1
         BC    4,L00067
         SR    2,2
L00067   DS    0H
         ST    2,T00015
         LA    1,P00068
         L     15,C00058
         BALR  14,15
         LD    0,C00059
         LCDR  0,0
         STD   0,S00000+360
         LD    0,S00000+360
         STD   0,P00053+0
         LA    1,P00053
         L     15,C00069
         BALR  14,15
         LD    2,C00060
         DD    2,C00066
         ADR   0,2
         LPDR  0,0
         CD    0,C00062
         LA    2,1
         BC    4,L00070
         SR    2,2
L00070   DS    0H
         ST    2,T00016
         LA    1,P00071
         L     15,C00058
         BALR  14,15
         LD    0,C00059
         STD   0,P00053+0
         LA    1,P00053
         L     15,C00072
         BALR  14,15
         CD    0,C00054
         LA    2,1
         BC    8,L00073
         SR    2,2
L00073   DS    0H
         ST    2,T00017
         LA    1,P00074
         L     15,C00058
         BALR  14,15
         LD    0,C00059
         LCDR  0,0
         STD   0,S00000+360
         LD    0,S00000+360
         STD   0,P00053+0
         LA    1,P00053
         L     15,C00072
         BALR  14,15
         SD    0,C00060
         LPDR  0,0
         CD    0,C00062
         LA    2,1
         BC    4,L00075
         SR    2,2
L00075   DS    0H
         ST    2,T00018
         LA    1,P00076
         L     15,C00058
         BALR  14,15
         LD    0,C00077
         STD   0,P00053+0
         LA    1,P00053
         L     15,C00069
         BALR  14,15
         LD    2,C00060
         DD    2,C00078
         SDR   0,2
         LPDR  0,0
         CD    0,C00062
         LA    2,1
         BC    4,L00079
         SR    2,2
L00079   DS    0H
         ST    2,T00019
         LA    1,P00080
         L     15,C00058
         BALR  14,15
         LD    0,C00077
         LCDR  0,0
         STD   0,S00000+360
         LD    0,S00000+360
         STD   0,P00053+0
         LA    1,P00053
         L     15,C00072
         BALR  14,15
         LD    2,C00060
         MD    2,C00066
         DD    2,C00081
         SDR   0,2
         LPDR  0,0
         CD    0,C00062
         LA    2,1
         BC    4,L00082
         SR    2,2
L00082   DS    0H
         ST    2,T00020
         LA    1,P00083
         L     15,C00058
         BALR  14,15
         LD    0,C00084
         STD   0,P00053+0
         LA    1,P00053
         L     15,C00069
         BALR  14,15
         CD    0,C00054
         LA    2,1
         BC    8,L00085
         SR    2,2
L00085   DS    0H
         ST    2,T00021
         LA    1,P00086
         L     15,C00058
         BALR  14,15
         LD    0,C00084
         LCDR  0,0
         STD   0,S00000+360
         LD    0,S00000+360
         STD   0,P00053+0
         LA    1,P00053
         L     15,C00072
         BALR  14,15
         CD    0,C00054
         LA    2,1
         BC    8,L00087
         SR    2,2
L00087   DS    0H
         ST    2,T00022
         LA    1,P00088
         L     15,C00058
         BALR  14,15
         LA    10,1
L00025   DS    0H
         LA    6,1
         LA    11,3
         LR    9,10
         LH    2,C00089
L00026   DS    0H
L00028   DS    0H
         C     9,C00090
         LA    8,1
         BC    8,L00091
         SR    8,8
L00091   DS    0H
         L     7,C00092
         LR    5,6
         LA    3,0
L00029   DS    0H
         LR    4,2
         SLL   4,13
         XR    2,4
         LR    4,2
         SRL   4,17
         XR    2,4
         LR    4,2
         SLL   4,5
         XR    2,4
L00031   DS    0H
         LTR   8,8
         BC    7,L00032
L00033   DS    0H
         LR    4,2
         N     4,C00093
         LR    0,4
         X     0,C00094
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00095
         LD    2,C00096
         DDR   0,2
         L     14,C00098
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
L00036   DS    0H
         LR    0,5
         SRDA  0,32
         D     0,C00099
         LR    4,0
         C     4,C00100
         BC    7,L00038
L00037   DS    0H
         LD    0,C00059
         LD    2,C00101
         L     15,C00098
         MD    2,0(,15)
         SDR   0,2
         L     14,C00098
         STD   0,0(,14)
L00038   DS    0H
         LR    4,2
         N     4,C00102
         LR    0,4
         X     0,C00094
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00095
         LD    2,C00103
         DDR   0,2
         L     15,C00098
         AD    0,0(,15)
         L     14,C00098
         STD   0,0(,14)
         C     2,C00100
         BC    11,L00040
L00039   DS    0H
         L     14,C00098
         LD    0,0(,14)
         LCDR  0,0
         L     14,C00098
         STD   0,0(,14)
L00040   DS    0H
         C     9,C00099
         BC    7,L00042
L00041   DS    0H
         L     14,C00098
         LD    0,0(,14)
         STD   0,S00000+360
         LD    0,S00000+360
         STD   0,P00053+0
         LA    1,P00053
         L     15,C00069
         BALR  14,15
         L     14,C00105
         STD   0,0(,14)
L00042   DS    0H
         C     9,C00106
         BC    7,L00044
L00043   DS    0H
         L     14,C00098
         LD    0,0(,14)
         STD   0,S00000+360
         LD    0,S00000+360
         STD   0,P00053+0
         LA    1,P00053
         L     15,C00072
         BALR  14,15
         L     14,C00105
         STD   0,0(,14)
L00044   DS    0H
L00034   DS    0H
         LR    4,3
         SLL   4,5
         SRL   3,27
         OR    4,3
         L     15,C00105
         X     4,0(,15)
         LR    3,4
         SLL   3,7
         SRL   4,25
         OR    3,4
         L     15,C00105
         X     3,4(,15)
L00045   DS    0H
         BXLE  5,6,L00029
L00030   DS    0H
         LA    1,P00107
         L     15,C00108
         BALR  14,15
         LR    0,9
         ST    0,P00109+0
         LA    1,P00109
         L     15,C00110
         BALR  14,15
         LR    0,3
         ST    0,P00109+0
         LA    1,P00109
         L     15,C00110
         BALR  14,15
         L     15,C00111
         BALR  14,15
L00046   DS    0H
L00047   DS    0H
         BXLE  9,10,L00026
L00027   DS    0H
         LA    1,P00112
         L     15,C00108
         BALR  14,15
         L     3,T00023
         LR    0,3
         ST    0,P00109+0
         LA    1,P00109
         L     15,C00110
         BALR  14,15
         L     15,C00111
         BALR  14,15
L00048   DS    0H
         B     L00049
L00032   DS    0H
         LR    4,2
         O     4,C00113
         L     14,C00098
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
L00035   DS    0H
         L     14,C00114
         ST    2,0(,14)
         L     14,C00098
         LD    0,0(,14)
         STD   0,S00000+360
         LD    0,S00000+360
         STD   0,P00053+0
         LA    1,P00053
         L     15,C00055
         BALR  14,15
         L     14,C00105
         STD   0,0(,14)
         B     L00034
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
T00013   DS    XL4
         DS    XL4
T00014   DS    XL4
         DS    XL4
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
T00023   DS    XL100
         DS    XL4
         DS    1D
P00053   DC    A(0)
         DC    A(0)
P00057   DC    A(Q00001)
         DC    A(T00013)
         DC    A(T00023)
         DC    XL1'80',FL3'7'
P00064   DC    A(Q00002)
         DC    A(T00014)
         DC    A(T00023)
         DC    XL1'80',FL3'7'
P00068   DC    A(Q00003)
         DC    A(T00015)
         DC    A(T00023)
         DC    XL1'80',FL3'7'
P00071   DC    A(Q00004)
         DC    A(T00016)
         DC    A(T00023)
         DC    XL1'80',FL3'7'
P00074   DC    A(Q00005)
         DC    A(T00017)
         DC    A(T00023)
         DC    XL1'80',FL3'7'
P00076   DC    A(Q00006)
         DC    A(T00018)
         DC    A(T00023)
         DC    XL1'80',FL3'7'
P00080   DC    A(Q00007)
         DC    A(T00019)
         DC    A(T00023)
         DC    XL1'80',FL3'7'
P00083   DC    A(Q00008)
         DC    A(T00020)
         DC    A(T00023)
         DC    XL1'80',FL3'7'
P00086   DC    A(Q00009)
         DC    A(T00021)
         DC    A(T00023)
         DC    XL1'80',FL3'7'
P00088   DC    A(Q00010)
         DC    A(T00022)
         DC    A(T00023)
         DC    XL1'80',FL3'7'
P00107   DC    F'6'
         DC    A(Q00012)
P00109   DC    A(0)
P00112   DC    F'6'
         DC    A(Q00011)
         DS    XL4
C00054   DC    X'0000000000000000'
C00059   DC    X'4110000000000000'
C00060   DC    X'413243F6A8885A2F'
C00061   DC    X'4140000000000000'
C00062   DC    X'34480EBE7B9D5856'
C00065   DC    X'7B172EBAD6DDC73D'
C00066   DC    X'4120000000000000'
C00077   DC    X'4080000000000000'
C00078   DC    X'4160000000000000'
C00081   DC    X'4130000000000000'
C00084   DC    X'4118000000000000'
C00095   DC    X'4E00000080000000'
C00096   DC    X'4880000000000000'
C00101   DC    X'3B101B2B29A4692B'
C00103   DC    X'526194049F30F720'
C00055   DC    V(DATAN)
C00058   DC    V(CHK)
C00069   DC    V(DASIN)
C00072   DC    V(DACOS)
C00090   DC    F'1'
C00092   DC    F'100000'
C00093   DC    F'2147483647'
C00094   DC    F'-2147483648'
C00098   DC    A(G00097)
C00099   DC    F'2'
C00100   DC    F'0'
C00102   DC    F'1048575'
C00105   DC    A(G00104)
C00106   DC    F'3'
C00108   DC    V(F77WRBEG)
C00110   DC    V(F77WRI)
C00111   DC    V(F77WREND)
C00113   DC    F'1048576'
C00114   DC    A(G00097+4)
C00089   DC    H'12345'
Q00012   DC    C'('' >HASH'',I1,1X,Z8)'
Q00011   DC    C'('' >BAD '',I2)'
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
* XSH
XSH      CSECT
         USING *,15
         B     L00118
         DC    AL1(3),CL7'XSH'
L00118   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00119
L00120   DC    A(S00115)
L00119   L     15,L00120
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00115,13
         ST    1,S00115+72
L00116   DS    0H
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
L00117   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00115   DS    0D
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
         B     L00131
         DC    AL1(3),CL7'CHK'
L00131   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00132
L00133   DC    A(S00121)
L00132   L     15,L00133
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00121,13
         ST    1,S00121+72
L00124   DS    0H
         L     5,0(,1)
         L     4,4(,1)
         L     3,8(,1)
         L     2,0(,4)
         LTR   2,2
         BC    7,L00125
L00126   DS    0H
         LA    1,P00134
         L     15,C00135
         BALR  14,15
         LR    0,5
         ST    0,P00136+0
         LA    1,P00136
         L     15,C00137
         BALR  14,15
         L     15,C00138
         BALR  14,15
L00129   DS    0H
         L     2,0(,3)
         A     2,C00139
         ST    2,0(,3)
L00127   DS    0H
         LA    0,0
         B     L00130
L00125   DS    0H
         LA    1,P00140
         L     15,C00135
         BALR  14,15
         LR    0,5
         ST    0,P00136+0
         LA    1,P00136
         L     15,C00137
         BALR  14,15
         L     15,C00138
         BALR  14,15
L00128   DS    0H
         B     L00127
L00130   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00121   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00134   DC    F'6'
         DC    A(Q00123)
P00136   DC    A(0)
         DC    F'7'
P00140   DC    F'6'
         DC    A(Q00122)
C00135   DC    V(F77WRBEG)
C00137   DC    V(F77WRA)
C00138   DC    V(F77WREND)
C00139   DC    F'1'
Q00122   DC    C'('' >'',A7,'' OK'')'
Q00123   DC    C'('' >'',A7,'' BAD'')'
G00097   CSECT
         DS    0D
         DS    XL8
G00104   CSECT
         DS    0D
         DS    XL8
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
