* main
F77MAIN  CSECT
         USING *,15
         B     L00038
         DC    AL1(7),CL7'F77MAIN'
L00038   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00039
L00040   DC    A(S00000)
L00039   L     15,L00040
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00030   DS    0H
         LA    1,P00041
         L     15,C00042
         BALR  14,15
         LA    1,P00043
         L     15,C00042
         BALR  14,15
         LA    3,T00024
         A     3,C00044
         LR    0,3
         ST    0,P00045+8
         LA    1,P00045
         L     15,C00042
         BALR  14,15
         LA    1,P00046
         L     15,C00042
         BALR  14,15
         LA    1,P00047
         L     15,C00042
         BALR  14,15
         LA    1,P00048
         L     15,C00042
         BALR  14,15
         LA    1,P00049
         L     15,C00042
         BALR  14,15
         LA    1,P00050
         L     15,C00042
         BALR  14,15
         LA    1,P00051
         L     15,C00052
         BALR  14,15
         LA    1,P00053
         L     15,C00054
         BALR  14,15
         LA    1,P00055
         L     15,C00054
         BALR  14,15
         LA    1,P00056
         L     15,C00054
         BALR  14,15
         LA    1,P00057
         L     15,C00054
         BALR  14,15
         L     15,C00058
         BALR  14,15
L00031   DS    0H
         LA    1,P00059
         L     15,C00052
         BALR  14,15
         LA    1,P00061
         L     15,C00054
         BALR  14,15
         L     2,C00062
         AH    2,C00063
         LA    1,P00064
         L     15,C00054
         BALR  14,15
         LA    1,P00065
         L     15,C00054
         BALR  14,15
         A     2,C00044
         LR    0,2
         ST    0,P00066+0
         LA    1,P00066
         L     15,C00054
         BALR  14,15
         L     15,C00058
         BALR  14,15
L00032   DS    0H
         LA    1,P00067
         L     15,C00068
         BALR  14,15
         LR    2,15
         C     2,C00069
         LA    3,1
         BC    8,L00070
         SR    3,3
L00070   DS    0H
         LA    1,P00071
         L     15,C00052
         BALR  14,15
         LR    0,3
         ST    0,P00072+0
         LA    1,P00072
         L     15,C00073
         BALR  14,15
         LA    1,P00074
         L     15,C00068
         BALR  14,15
         LR    2,15
         C     2,C00069
         LA    3,1
         BC    4,L00075
         SR    3,3
L00075   DS    0H
         LR    0,3
         ST    0,P00072+0
         LA    1,P00072
         L     15,C00073
         BALR  14,15
         LA    1,P00076
         L     15,C00068
         BALR  14,15
         LR    2,15
         C     2,C00069
         LA    3,1
         BC    8,L00077
         SR    3,3
L00077   DS    0H
         LR    0,3
         ST    0,P00072+0
         LA    1,P00072
         L     15,C00073
         BALR  14,15
         LA    1,P00078
         L     15,C00079
         BALR  14,15
         LA    1,P00080
         L     15,C00079
         BALR  14,15
         LA    1,P00081
         L     15,C00054
         BALR  14,15
         L     15,C00058
         BALR  14,15
         LA    1,P00071
         L     15,C00052
         BALR  14,15
         LA    1,P00082
         L     15,C00083
         BALR  14,15
         LR    3,15
         LR    0,3
         ST    0,P00072+0
         LA    1,P00072
         L     15,C00079
         BALR  14,15
         L     14,C00084
         SR    3,3
         IC    3,0(,14)
         LR    0,3
         ST    0,P00072+0
         LA    1,P00072
         L     15,C00079
         BALR  14,15
         LA    15,66
         STC   15,T00027
         LA    1,P00085
         L     15,C00054
         BALR  14,15
         LA    1,P00086
         L     15,C00087
         BALR  14,15
         LR    2,15
         C     2,C00069
         LA    3,1
         BC    10,L00088
         SR    3,3
L00088   DS    0H
         LR    0,3
         ST    0,P00072+0
         LA    1,P00072
         L     15,C00073
         BALR  14,15
         L     15,C00058
         BALR  14,15
         LA    15,65
         ST    15,T00028
         LA    15,65
         STC   15,T00022
         LA    15,66
         STC   15,T00018
         LA    1,P00089
         L     15,C00042
         BALR  14,15
         LA    1,P00090
         L     15,C00042
         BALR  14,15
         LA    1,P00091
         L     15,C00042
         BALR  14,15
         LA    1,P00092
         L     15,C00052
         BALR  14,15
         LA    1,P00065
         L     15,C00054
         BALR  14,15
         LA    1,P00093
         L     15,C00094
         BALR  14,15
         LA    1,P00095
         L     15,C00054
         BALR  14,15
         L     15,C00058
         BALR  14,15
L00033   DS    0H
         LA    1,P00096
         L     15,C00097
         BALR  14,15
         LA    1,P00071
         L     15,C00052
         BALR  14,15
         LA    1,P00053
         L     15,C00054
         BALR  14,15
         LA    1,P00061
         L     15,C00054
         BALR  14,15
         L     15,C00058
         BALR  14,15
         LA    1,P00098
         L     15,C00099
         BALR  14,15
         LA    1,P00053
         L     15,C00100
         BALR  14,15
         LA    1,P00056
         L     15,C00100
         BALR  14,15
         L     15,C00101
         BALR  14,15
L00034   DS    0H
         LA    1,P00102
         L     15,C00052
         BALR  14,15
         LA    1,P00053
         L     15,C00054
         BALR  14,15
         LA    1,P00056
         L     15,C00054
         BALR  14,15
         LA    3,T00024
         A     3,C00103
         LR    0,3
         ST    0,P00104+0
         LA    1,P00104
         L     15,C00054
         BALR  14,15
         LA    1,P00105
         L     15,C00054
         BALR  14,15
         L     15,C00058
         BALR  14,15
L00035   DS    0H
         LA    1,P00106
         L     15,C00099
         BALR  14,15
         LA    1,P00055
         L     15,C00100
         BALR  14,15
         LA    1,P00107
         L     15,C00108
         BALR  14,15
         L     15,C00101
         BALR  14,15
         LA    1,P00071
         L     15,C00052
         BALR  14,15
         LA    1,P00055
         L     15,C00054
         BALR  14,15
         L     3,T00028
         LR    0,3
         ST    0,P00072+0
         LA    1,P00072
         L     15,C00079
         BALR  14,15
         L     15,C00058
         BALR  14,15
         LA    1,P00109
         L     15,C00110
         BALR  14,15
         B     L00037
L00036   DS    0H
L00037   DS    0H
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
T00020   DS    XL8
T00021   DS    XL8
T00022   DS    XL8
T00023   DS    XL8
T00024   DS    XL12
         DS    XL4
T00025   DS    XL12
         DS    XL4
T00026   DS    XL16
T00027   DS    XL20
         DS    XL4
T00028   DS    XL28
         DS    XL4
T00029   DS    XL32
P00041   DC    A(T00024)
         DC    F'5'
         DC    A(Q00001)
         DC    F'3'
P00043   DC    A(T00025)
         DC    F'5'
         DC    A(Q00002)
         DC    F'7'
P00045   DC    A(T00020)
         DC    F'3'
         DC    A(0)
         DC    F'2'
P00046   DC    A(T00026)
         DC    F'5'
         DC    A(T00024)
         DC    F'5'
P00047   DC    A(T00026+5)
         DC    F'2'
         DC    A(T00025)
         DC    F'2'
P00048   DC    A(T00021)
         DC    F'7'
         DC    A(T00026)
         DC    F'7'
P00049   DC    A(T00021+7)
         DC    F'1'
         DC    A(Q00003)
         DC    F'1'
P00050   DC    A(T00029)
         DC    F'10'
         DC    A(T00021)
         DC    F'8'
P00051   DC    F'6'
         DC    A(Q00004)
P00053   DC    A(T00024)
         DC    F'5'
P00055   DC    A(T00025)
         DC    F'5'
P00056   DC    A(T00020)
         DC    F'3'
P00057   DC    A(T00029)
         DC    F'10'
P00059   DC    F'6'
         DC    A(Q00005)
P00061   DC    A(G00060)
         DC    F'4'
P00064   DC    A(G00060+4)
         DC    F'4'
P00065   DC    A(G00060+8)
         DC    F'4'
P00066   DC    A(0)
         DC    F'2'
P00067   DC    A(T00024)
         DC    F'5'
         DC    A(Q00006)
         DC    F'3'
P00071   DC    F'6'
         DC    F'0'
P00072   DC    A(0)
P00074   DC    A(T00024)
         DC    F'5'
         DC    A(T00025)
         DC    F'5'
P00076   DC    A(Q00007)
         DC    F'3'
         DC    A(Q00008)
         DC    F'5'
P00078   DC    F'10'
P00080   DC    F'5'
P00081   DC    A(Q00009)
         DC    F'5'
P00082   DC    A(T00029)
         DC    F'10'
         DC    A(Q00010)
         DC    F'3'
P00085   DC    A(T00027)
         DC    F'1'
P00086   DC    A(Q00012)
         DC    F'1'
         DC    A(Q00013)
         DC    F'1'
P00089   DC    A(T00019)
         DC    F'1'
         DC    A(T00022)
         DC    F'1'
P00090   DC    A(T00019+1)
         DC    F'1'
         DC    A(T00018)
         DC    F'1'
P00091   DC    A(G00060+8)
         DC    F'4'
         DC    A(T00019)
         DC    F'2'
P00092   DC    F'6'
         DC    A(Q00014)
P00093   DC    A(T00023)
         DC    F'6'
         DC    A(T00024)
         DC    A(T00025)
         DC    F'5'
         DC    XL1'80',FL3'5'
P00095   DC    A(T00023)
         DC    F'6'
P00096   DC    A(T00024)
         DC    A(Q00015)
         DC    A(G00060)
         DC    F'5'
         DC    F'3'
         DC    XL1'80',FL3'4'
P00098   DC    F'5'
         DC    A(Q00016)
         DC    F'0'
P00102   DC    F'6'
         DC    A(Q00017)
P00104   DC    A(0)
         DC    F'1'
P00105   DC    A(T00020)
         DC    F'1'
P00106   DC    F'5'
         DC    F'0'
         DC    F'0'
P00107   DC    A(T00028)
P00109   DC    F'0'
         DS    XL4
C00042   DC    V(F77STRCP)
C00044   DC    F'1'
C00052   DC    V(F77WRBEG)
C00054   DC    V(F77WRA)
C00058   DC    V(F77WREND)
C00062   DC    A(G00060)
C00068   DC    V(F77STRCM)
C00069   DC    F'0'
C00073   DC    V(F77WRL)
C00079   DC    V(F77WRI)
C00083   DC    V(F77INDEX)
C00084   DC    A(Q00011)
C00087   DC    V(F77LSTRC)
C00094   DC    V(F6)
C00097   DC    V(SUB1)
C00099   DC    V(F77RDBEG)
C00100   DC    V(F77RDS)
C00101   DC    V(F77RDEND)
C00103   DC    F'4'
C00108   DC    V(F77RDI)
C00110   DC    V(EXIT)
C00063   DC    H'4'
Q00004   DC    C'(1X,A,''|'',A5,''|'',A,''|'',A10,''|'')'
Q00005   DC    C'(1X,4(A,''|''))'
Q00014   DC    C'(1X,A4,''/'',A6,''/'')'
Q00016   DC    C'(A5,A3)'
Q00017   DC    C'(1X,A,''|'',A,''|'',A,''|'',A)'
Q00009   DC    C'HELLO'
Q00001   DC    C'ABC'
Q00002   DC    C'ABCDEFG'
Q00003   DC    C'X'
Q00006   DC    C'ABC'
Q00007   DC    C'ABC'
Q00008   DC    C'ABC  '
Q00010   DC    C'CAB'
Q00011   DC    C'A'
Q00012   DC    C'B'
Q00013   DC    C'A'
Q00015   DC    C'XYZ'
* F6
F6       CSECT
         USING *,15
         B     L00115
         DC    AL1(2),CL7'F6'
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
L00112   DS    0H
         L     6,8(,1)
         L     3,12(,1)
         L     5,0(,1)
         L     2,16(,1)
         LR    0,3
         ST    0,P00118+0
         LR    0,6
         ST    0,P00118+8
         LR    0,2
         ST    0,P00118+12
         LA    1,P00118
         L     15,C00119
         BALR  14,15
         LR    4,15
         LA    3,2
         AR    3,2
         LR    0,5
         ST    0,P00120+0
         LR    0,4
         ST    0,P00120+8
         LR    0,3
         ST    0,P00120+12
         LA    1,P00120
         L     15,C00121
         BALR  14,15
         ICM   2,8,0(5)
         SRA   2,24
         LR    0,2
         B     L00114
L00113   DS    0H
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
P00118   DC    A(0)
         DC    F'2'
         DC    A(0)
         DC    A(0)
P00120   DC    A(0)
         DC    F'6'
         DC    A(0)
         DC    A(0)
C00119   DC    V(F77CAT)
C00121   DC    V(F77STRCP)
* SUB1
SUB1     CSECT
         USING *,15
         B     L00129
         DC    AL1(4),CL7'SUB1'
L00129   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00130
L00131   DC    A(S00122)
L00130   L     15,L00131
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00122,13
         ST    1,S00122+72
L00124   DS    0H
         L     9,0(,1)
         L     2,4(,1)
         L     8,8(,1)
         L     5,12(,1)
         L     4,16(,1)
         LR    0,2
         ST    0,P00132+0
         LR    0,4
         ST    0,P00132+4
         LR    0,9
         ST    0,P00132+8
         LR    0,5
         ST    0,P00132+12
         LA    1,P00132
         L     15,C00133
         BALR  14,15
         LR    7,15
         LR    3,4
         AR    3,5
         LR    0,9
         ST    0,P00132+0
         LR    0,5
         ST    0,P00132+4
         LR    0,7
         ST    0,P00132+8
         LR    0,3
         ST    0,P00132+12
         LA    1,P00132
         L     15,C00134
         BALR  14,15
         A     2,C00135
         LR    0,8
         ST    0,P00136+0
         LR    0,2
         ST    0,P00136+8
         LA    1,P00136
         L     15,C00134
         BALR  14,15
         C     5,C00137
         LA    2,1
         BC    7,L00138
         SR    2,2
L00138   DS    0H
         C     4,C00139
         LA    3,1
         BC    7,L00140
         SR    3,3
L00140   DS    0H
         OR    2,3
         LTR   2,2
         BC    8,L00126
L00125   DS    0H
         LA    1,P00141
         L     15,C00142
         BALR  14,15
         LA    1,P00143
         L     15,C00144
         BALR  14,15
         LR    0,5
         ST    0,P00145+0
         LA    1,P00145
         L     15,C00146
         BALR  14,15
         LR    0,4
         ST    0,P00145+0
         LA    1,P00145
         L     15,C00146
         BALR  14,15
         L     15,C00147
         BALR  14,15
L00126   DS    0H
         LA    0,0
         B     L00128
L00127   DS    0H
L00128   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00122   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00132   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
P00136   DC    A(0)
         DC    F'4'
         DC    A(0)
         DC    F'2'
P00141   DC    F'6'
         DC    F'0'
P00143   DC    A(Q00123)
         DC    F'7'
P00145   DC    A(0)
         DS    XL4
C00133   DC    V(F77CAT)
C00134   DC    V(F77STRCP)
C00135   DC    F'1'
C00137   DC    F'5'
C00139   DC    F'3'
C00142   DC    V(F77WRBEG)
C00144   DC    V(F77WRA)
C00146   DC    V(F77WRI)
C00147   DC    V(F77WREND)
Q00123   DC    C'BAD LEN'
G00060   CSECT
         DS    0D
         DC    X'C1C24040C3C4C5C6C9D1D2D3'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
