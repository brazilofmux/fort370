* main
F77MAIN  CSECT
         USING *,15
         B     L00043
         DC    AL1(7),CL7'F77MAIN'
L00043   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00044
L00045   DC    A(S00000)
L00044   L     15,L00045
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00022   DS    0H
         LA    15,0
         ST    15,T00021
         LD    0,C00047
         STD   0,P00046+0
         LA    1,P00046
         L     15,C00048
         BALR  14,15
         CD    0,C00047
         LA    2,1
         BC    8,L00049
         SR    2,2
L00049   DS    0H
         ST    2,T00012
         LA    1,P00050
         L     15,C00051
         BALR  14,15
         LD    0,C00047
         STD   0,P00046+0
         LA    1,P00046
         L     15,C00052
         BALR  14,15
         CD    0,C00053
         LA    2,1
         BC    8,L00054
         SR    2,2
L00054   DS    0H
         ST    2,T00013
         LA    1,P00055
         L     15,C00051
         BALR  14,15
         LD    0,C00047
         STD   0,P00046+0
         LA    1,P00046
         L     15,C00056
         BALR  14,15
         CD    0,C00047
         LA    2,1
         BC    8,L00057
         SR    2,2
L00057   DS    0H
         ST    2,T00014
         LA    1,P00058
         L     15,C00051
         BALR  14,15
         LD    0,C00059
         LCDR  0,0
         STD   0,S00000+352
         LD    0,S00000+352
         STD   0,P00046+0
         LA    1,P00046
         L     15,C00056
         BALR  14,15
         LDR   2,0
         LD    0,C00053
         LCDR  0,0
         CDR   2,0
         LA    2,1
         BC    8,L00060
         SR    2,2
L00060   DS    0H
         ST    2,T00015
         LA    1,P00061
         L     15,C00051
         BALR  14,15
         LD    0,C00053
         STD   0,P00046+0
         LA    1,P00046
         L     15,C00048
         BALR  14,15
         SD    0,C00062
         LPDR  0,0
         CD    0,C00063
         LA    2,1
         BC    4,L00064
         SR    2,2
L00064   DS    0H
         ST    2,T00016
         LA    1,P00065
         L     15,C00051
         BALR  14,15
         LD    0,C00053
         STD   0,P00046+0
         LA    1,P00046
         L     15,C00052
         BALR  14,15
         SD    0,C00066
         LPDR  0,0
         CD    0,C00063
         LA    2,1
         BC    4,L00067
         SR    2,2
L00067   DS    0H
         ST    2,T00017
         LA    1,P00068
         L     15,C00051
         BALR  14,15
         LD    0,C00053
         STD   0,P00046+0
         LA    1,P00046
         L     15,C00056
         BALR  14,15
         SD    0,C00069
         LPDR  0,0
         CD    0,C00063
         LA    2,1
         BC    4,L00070
         SR    2,2
L00070   DS    0H
         ST    2,T00018
         LA    1,P00071
         L     15,C00051
         BALR  14,15
         LD    0,C00072
         LCDR  0,0
         STD   0,S00000+352
         LD    0,S00000+352
         STD   0,P00046+0
         LA    1,P00046
         L     15,C00048
         BALR  14,15
         LD    2,C00073
         CDR   2,0
         LA    2,1
         BC    4,L00074
         SR    2,2
L00074   DS    0H
         ST    2,T00019
         LA    1,P00075
         L     15,C00051
         BALR  14,15
         LD    0,C00072
         STD   0,P00046+0
         LA    1,P00046
         L     15,C00052
         BALR  14,15
         LD    2,C00073
         CDR   2,0
         LA    2,1
         BC    4,L00076
         SR    2,2
L00076   DS    0H
         ST    2,T00020
         LA    1,P00077
         L     15,C00051
         BALR  14,15
L00023   DS    0H
         LA    11,1
         LH    2,C00078
L00024   DS    0H
L00026   DS    0H
         LD    0,C00079
         LDR   2,0
         LCDR  2,2
         STD   2,S00000+352
         C     11,C00080
         LA    10,1
         BC    8,L00081
         SR    10,10
L00081   DS    0H
         C     11,C00082
         LA    9,1
         BC    8,L00083
         SR    9,9
L00083   DS    0H
         C     11,C00084
         LA    8,1
         BC    8,L00085
         SR    8,8
L00085   DS    0H
         LH    6,C00086
         LA    7,0
         L     5,C00087
         LA    4,0
L00027   DS    0H
         LR    3,2
         SLL   3,13
         XR    2,3
         LR    3,2
         SRL   3,17
         XR    2,3
         LR    3,2
         SLL   3,5
         XR    2,3
L00029   DS    0H
         LR    3,2
         N     3,C00088
         LR    0,3
         X     0,C00089
         ST    0,S00000+84
         LD    2,S00000+80
         SD    2,C00090
         LD    0,C00091
         DDR   2,0
         LD    0,C00092
         MDR   0,2
         LD    2,S00000+352
         ADR   2,0
         STD   2,S00000+368
         LD    0,C00094
         STD   0,P00093+0
         LD    0,S00000+368
         STD   0,P00093+8
         LA    1,P00093
         L     15,C00095
         BALR  14,15
         L     14,C00097
         STD   0,0(,14)
         C     2,C00098
         BC    11,L00031
L00030   DS    0H
         L     14,C00097
         LD    0,0(,14)
         LCDR  0,0
         L     14,C00097
         STD   0,0(,14)
L00031   DS    0H
         LTR   10,10
         BC    8,L00033
L00032   DS    0H
         L     14,C00097
         LD    0,0(,14)
         STD   0,S00000+368
         LD    0,S00000+368
         STD   0,P00046+0
         LA    1,P00046
         L     15,C00048
         BALR  14,15
         L     14,C00100
         STD   0,0(,14)
L00033   DS    0H
         LTR   9,9
         BC    8,L00035
L00034   DS    0H
         L     14,C00097
         LD    0,0(,14)
         STD   0,S00000+368
         LD    0,S00000+368
         STD   0,P00046+0
         LA    1,P00046
         L     15,C00052
         BALR  14,15
         L     14,C00100
         STD   0,0(,14)
L00035   DS    0H
         LTR   8,8
         BC    8,L00037
L00036   DS    0H
         L     14,C00097
         LD    0,0(,14)
         STD   0,S00000+368
         LD    0,S00000+368
         STD   0,P00046+0
         LA    1,P00046
         L     15,C00056
         BALR  14,15
         L     14,C00100
         STD   0,0(,14)
L00037   DS    0H
         LR    3,4
         SLL   3,5
         SRL   4,27
         OR    3,4
         L     15,C00100
         X     3,0(,15)
         LR    4,3
         SLL   4,7
         SRL   3,25
         OR    4,3
         L     15,C00100
         X     4,4(,15)
L00038   DS    0H
         BXH   5,6,L00027
         LR    14,4
         ST    14,S00000+360
L00028   DS    0H
         LA    1,P00101
         L     15,C00102
         BALR  14,15
         LR    0,11
         ST    0,P00103+0
         LA    1,P00103
         L     15,C00104
         BALR  14,15
         L     0,S00000+360
         ST    0,P00103+0
         LA    1,P00103
         L     15,C00104
         BALR  14,15
         L     15,C00105
         BALR  14,15
L00039   DS    0H
L00040   DS    0H
         A     11,C00080
         C     11,C00084
         BC    12,L00024
L00025   DS    0H
         LA    1,P00106
         L     15,C00102
         BALR  14,15
         L     3,T00021
         LR    0,3
         ST    0,P00103+0
         LA    1,P00103
         L     15,C00104
         BALR  14,15
         L     15,C00105
         BALR  14,15
L00041   DS    0H
L00042   DS    0H
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
T00017   DS    XL4
         DS    XL4
T00018   DS    XL4
         DS    XL4
T00019   DS    XL4
         DS    XL4
T00020   DS    XL4
         DS    XL4
T00021   DS    XL100
         DS    XL4
         DS    3D
P00046   DC    A(0)
         DC    A(0)
P00050   DC    A(Q00001)
         DC    A(T00012)
         DC    A(T00021)
         DC    XL1'80',FL3'7'
P00055   DC    A(Q00002)
         DC    A(T00013)
         DC    A(T00021)
         DC    XL1'80',FL3'7'
P00058   DC    A(Q00003)
         DC    A(T00014)
         DC    A(T00021)
         DC    XL1'80',FL3'7'
P00061   DC    A(Q00004)
         DC    A(T00015)
         DC    A(T00021)
         DC    XL1'80',FL3'7'
P00065   DC    A(Q00005)
         DC    A(T00016)
         DC    A(T00021)
         DC    XL1'80',FL3'7'
P00068   DC    A(Q00006)
         DC    A(T00017)
         DC    A(T00021)
         DC    XL1'80',FL3'7'
P00071   DC    A(Q00007)
         DC    A(T00018)
         DC    A(T00021)
         DC    XL1'80',FL3'7'
P00075   DC    A(Q00008)
         DC    A(T00019)
         DC    A(T00021)
         DC    XL1'80',FL3'7'
P00077   DC    A(Q00009)
         DC    A(T00020)
         DC    A(T00021)
         DC    XL1'80',FL3'7'
P00093   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
P00101   DC    F'6'
         DC    A(Q00011)
P00103   DC    A(0)
P00106   DC    F'6'
         DC    A(Q00010)
         DS    XL4
C00047   DC    X'0000000000000000'
C00053   DC    X'4110000000000000'
C00059   DC    X'421E000000000000'
C00062   DC    X'4112CD9FC44EB982'
C00063   DC    X'34480EBE7B9D5856'
C00066   DC    X'4118B07551D9F550'
C00069   DC    X'40C2F7D5A8A79CA2'
C00072   DC    X'42C8000000000000'
C00073   DC    X'7FF79DC0E8C518F3'
C00079   DC    X'4160000000000000'
C00090   DC    X'4E00000080000000'
C00091   DC    X'4880000000000000'
C00092   DC    X'4183D70A3D70A3D7'
C00094   DC    X'41A0000000000000'
C00048   DC    V(DSINH)
C00051   DC    V(CHK)
C00052   DC    V(DCOSH)
C00056   DC    V(DTANH)
C00080   DC    F'1'
C00082   DC    F'2'
C00084   DC    F'3'
C00087   DC    F'100000'
C00088   DC    F'2147483647'
C00089   DC    F'-2147483648'
C00095   DC    V(DPOW)
C00097   DC    A(G00096)
C00098   DC    F'0'
C00100   DC    A(G00099)
C00102   DC    V(F77WRBEG)
C00104   DC    V(F77WRI)
C00105   DC    V(F77WREND)
C00078   DC    H'12345'
C00086   DC    H'-1'
Q00011   DC    C'('' >HASH'',I1,1X,Z8)'
Q00010   DC    C'('' >BAD '',I2)'
Q00001   DC    C'SINH0  '
Q00002   DC    C'COSH0  '
Q00003   DC    C'TANH0  '
Q00004   DC    C'TANH30 '
Q00005   DC    C'SINH1  '
Q00006   DC    C'COSH1  '
Q00007   DC    C'TANH1  '
Q00008   DC    C'SINHBIG'
Q00009   DC    C'COSHBIG'
* XSH
XSH      CSECT
         USING *,15
         B     L00110
         DC    AL1(3),CL7'XSH'
L00110   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00111
L00112   DC    A(S00107)
L00111   L     15,L00112
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00107,13
         ST    1,S00107+72
L00108   DS    0H
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
L00109   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00107   DS    0D
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
         B     L00123
         DC    AL1(3),CL7'CHK'
L00123   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00124
L00125   DC    A(S00113)
L00124   L     15,L00125
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00113,13
         ST    1,S00113+72
L00116   DS    0H
         L     5,0(,1)
         L     4,4(,1)
         L     3,8(,1)
         L     2,0(,4)
         LTR   2,2
         BC    7,L00117
L00118   DS    0H
         LA    1,P00126
         L     15,C00127
         BALR  14,15
         LR    0,5
         ST    0,P00128+0
         LA    1,P00128
         L     15,C00129
         BALR  14,15
         L     15,C00130
         BALR  14,15
L00121   DS    0H
         L     2,0(,3)
         A     2,C00131
         ST    2,0(,3)
L00119   DS    0H
         LA    0,0
         B     L00122
L00117   DS    0H
         LA    1,P00132
         L     15,C00127
         BALR  14,15
         LR    0,5
         ST    0,P00128+0
         LA    1,P00128
         L     15,C00129
         BALR  14,15
         L     15,C00130
         BALR  14,15
L00120   DS    0H
         B     L00119
L00122   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00113   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00126   DC    F'6'
         DC    A(Q00115)
P00128   DC    A(0)
         DC    F'7'
P00132   DC    F'6'
         DC    A(Q00114)
C00127   DC    V(F77WRBEG)
C00129   DC    V(F77WRA)
C00130   DC    V(F77WREND)
C00131   DC    F'1'
Q00114   DC    C'('' >'',A7,'' OK'')'
Q00115   DC    C'('' >'',A7,'' BAD'')'
G00096   CSECT
         DS    0D
         DS    XL8
G00099   CSECT
         DS    0D
         DS    XL8
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
