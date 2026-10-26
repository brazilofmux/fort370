* main
F77MAIN  CSECT
         USING *,15
         B     L00058
         DC    AL1(7),CL7'F77MAIN'
L00058   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00059
L00060   DC    A(S00000)
L00059   L     15,L00060
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00023   DS    0H
         L     8,C00062
         L     5,C00064
         L     2,C00066
         L     7,C00068
         L     6,C00070
         LA    1,P00071
         L     15,C00072
         BALR  14,15
         AH    8,C00073
         LA    3,4
         LA    4,6
L00024   DS    0H
         C     4,C00074
         BC    2,L00025
L00026   DS    0H
         L     15,C00075
         BALR  14,15
L00027   DS    0H
         LA    1,P00076
         L     15,C00072
         BALR  14,15
         AH    5,C00073
         LA    3,4
         LA    4,3
L00028   DS    0H
         C     4,C00074
         BC    2,L00029
L00030   DS    0H
         L     15,C00075
         BALR  14,15
L00031   DS    0H
         LA    1,P00077
         L     15,C00072
         BALR  14,15
         AH    2,C00073
         LA    3,4
         LA    4,3
L00032   DS    0H
         C     4,C00074
         BC    2,L00033
L00034   DS    0H
         L     15,C00075
         BALR  14,15
L00035   DS    0H
         L     14,C00079
         LD    0,0(,14)
         STD   0,T00021
         LA    1,P00080
         L     15,C00072
         BALR  14,15
         LD    0,T00021
         STD   0,S00000+312
         LD    0,S00000+312
         STD   0,P00081+0
         LA    1,P00081
         L     15,C00082
         BALR  14,15
         LD    0,T00021
         STD   0,S00000+312
         LD    0,S00000+312
         STD   0,P00081+0
         LA    1,P00081
         L     15,C00082
         BALR  14,15
         L     15,C00075
         BALR  14,15
L00036   DS    0H
         LA    1,P00080
         L     15,C00072
         BALR  14,15
         L     14,C00083
         LD    0,0(,14)
         STD   0,S00000+312
         LD    0,S00000+312
         STD   0,P00081+0
         LA    1,P00081
         L     15,C00082
         BALR  14,15
         L     15,C00075
         BALR  14,15
         LA    1,P00080
         L     15,C00072
         BALR  14,15
         L     14,C00084
         LD    0,0(,14)
         STD   0,S00000+312
         LD    0,S00000+312
         STD   0,P00081+0
         LA    1,P00081
         L     15,C00082
         BALR  14,15
         L     15,C00075
         BALR  14,15
         LA    1,P00085
         L     15,C00072
         BALR  14,15
         LR    4,7
         AH    4,C00073
         LA    2,4
         LA    3,2
L00037   DS    0H
         C     3,C00074
         BC    2,L00038
L00039   DS    0H
         L     15,C00075
         BALR  14,15
L00040   DS    0H
         LA    1,P00086
         L     15,C00072
         BALR  14,15
         L     14,C00088
         LE    0,0(,14)
         STE   0,S00000+312
         L     14,C00089
         LE    0,0(,14)
         STE   0,S00000+320
         LE    0,S00000+312
         STE   0,P00081+0
         LE    0,S00000+320
         STE   0,P00081+4
         LA    1,P00081
         L     15,C00090
         BALR  14,15
         L     15,C00075
         BALR  14,15
L00041   DS    0H
         LA    1,P00091
         L     15,C00072
         BALR  14,15
         LR    4,6
         AH    4,C00092
         LA    2,2
         LA    3,2
L00042   DS    0H
         C     3,C00074
         BC    2,L00043
L00044   DS    0H
         L     15,C00075
         BALR  14,15
L00045   DS    0H
         LA    1,P00093
         L     15,C00072
         BALR  14,15
         LA    1,P00094
         L     15,C00095
         BALR  14,15
         LA    1,P00094
         L     15,C00095
         BALR  14,15
         LA    1,P00094
         L     15,C00095
         BALR  14,15
         LA    1,P00094
         L     15,C00095
         BALR  14,15
         L     15,C00075
         BALR  14,15
L00046   DS    0H
         MVC   T00020(4),C00096
         LD    0,C00097
         LCDR  0,0
         STD   0,T00021
         LA    1,P00098
         L     15,C00072
         BALR  14,15
         LE    0,T00020
         STE   0,S00000+312
         LE    0,S00000+312
         STE   0,P00099+0
         LA    1,P00099
         L     15,C00100
         BALR  14,15
         LE    0,T00020
         STE   0,S00000+312
         LE    0,S00000+312
         STE   0,P00099+0
         LA    1,P00099
         L     15,C00100
         BALR  14,15
         LD    0,T00021
         STD   0,S00000+312
         LD    0,S00000+312
         STD   0,P00081+0
         LA    1,P00081
         L     15,C00082
         BALR  14,15
         LD    0,T00021
         STD   0,S00000+312
         LD    0,S00000+312
         STD   0,P00081+0
         LA    1,P00081
         L     15,C00082
         BALR  14,15
         L     15,C00075
         BALR  14,15
L00047   DS    0H
         LA    1,P00101
         L     15,C00072
         BALR  14,15
         L     14,C00088
         LE    0,0(,14)
         STE   0,S00000+312
         L     14,C00089
         LE    0,0(,14)
         STE   0,S00000+320
         LE    0,S00000+312
         STE   0,P00081+0
         LE    0,S00000+320
         STE   0,P00081+4
         LA    1,P00081
         L     15,C00090
         BALR  14,15
         L     14,C00068
         L     3,0(,14)
         LR    0,3
         ST    0,P00102+0
         LA    1,P00102
         L     15,C00103
         BALR  14,15
         L     15,C00075
         BALR  14,15
L00048   DS    0H
         LA    1,P00105
         L     15,C00106
         BALR  14,15
         LA    1,P00107
         L     15,C00108
         BALR  14,15
         LA    1,P00109
         L     15,C00108
         BALR  14,15
         LA    1,P00110
         L     15,C00111
         BALR  14,15
         LA    1,P00112
         L     15,C00113
         BALR  14,15
         L     15,C00114
         BALR  14,15
L00049   DS    0H
         LA    1,P00115
         L     15,C00072
         BALR  14,15
         L     3,T00022
         LR    0,3
         ST    0,P00102+0
         LA    1,P00102
         L     15,C00095
         BALR  14,15
         L     3,T00019
         LR    0,3
         ST    0,P00102+0
         LA    1,P00102
         L     15,C00095
         BALR  14,15
         LE    0,T00020
         STE   0,S00000+312
         LE    0,S00000+312
         STE   0,P00099+0
         LA    1,P00099
         L     15,C00100
         BALR  14,15
         LD    0,T00021
         STD   0,S00000+312
         LD    0,S00000+312
         STD   0,P00081+0
         LA    1,P00081
         L     15,C00082
         BALR  14,15
         L     15,C00075
         BALR  14,15
L00050   DS    0H
         LA    1,P00116
         L     15,C00106
         BALR  14,15
         LA    1,P00107
         L     15,C00108
         BALR  14,15
         LA    1,P00109
         L     15,C00108
         BALR  14,15
         LA    1,P00110
         L     15,C00111
         BALR  14,15
         LA    1,P00112
         L     15,C00113
         BALR  14,15
         L     15,C00114
         BALR  14,15
         LA    1,P00117
         L     15,C00072
         BALR  14,15
         L     3,T00022
         LR    0,3
         ST    0,P00102+0
         LA    1,P00102
         L     15,C00095
         BALR  14,15
         L     3,T00019
         LR    0,3
         ST    0,P00102+0
         LA    1,P00102
         L     15,C00095
         BALR  14,15
         LE    0,T00020
         STE   0,S00000+312
         LE    0,S00000+312
         STE   0,P00099+0
         LA    1,P00099
         L     15,C00100
         BALR  14,15
         LD    0,T00021
         STD   0,S00000+312
         LD    0,S00000+312
         STD   0,P00081+0
         LA    1,P00081
         L     15,C00082
         BALR  14,15
         L     15,C00075
         BALR  14,15
L00051   DS    0H
         LA    1,P00118
         L     15,C00106
         BALR  14,15
         LA    1,P00107
         L     15,C00108
         BALR  14,15
         LA    1,P00109
         L     15,C00108
         BALR  14,15
         LA    1,P00112
         L     15,C00113
         BALR  14,15
         L     15,C00114
         BALR  14,15
L00052   DS    0H
         LA    1,P00119
         L     15,C00072
         BALR  14,15
         L     3,T00022
         LR    0,3
         ST    0,P00102+0
         LA    1,P00102
         L     15,C00095
         BALR  14,15
         L     3,T00019
         LR    0,3
         ST    0,P00102+0
         LA    1,P00102
         L     15,C00095
         BALR  14,15
         LD    0,T00021
         STD   0,S00000+312
         LD    0,S00000+312
         STD   0,P00081+0
         LA    1,P00081
         L     15,C00082
         BALR  14,15
         L     15,C00075
         BALR  14,15
L00053   DS    0H
         LA    1,P00120
         L     15,C00106
         BALR  14,15
         LA    1,P00107
         L     15,C00108
         BALR  14,15
         LA    1,P00121
         L     15,C00122
         BALR  14,15
         L     15,C00114
         BALR  14,15
L00054   DS    0H
         LA    1,P00123
         L     15,C00072
         BALR  14,15
         L     3,T00022
         LR    0,3
         ST    0,P00102+0
         LA    1,P00102
         L     15,C00095
         BALR  14,15
         L     14,C00070
         LH    3,0(,14)
         LR    0,3
         ST    0,P00124+0
         LA    1,P00124
         L     15,C00125
         BALR  14,15
         L     15,C00075
         BALR  14,15
L00055   DS    0H
         LA    1,P00126
         L     15,C00072
         BALR  14,15
         L     14,C00128
         LE    0,0(,14)
         STE   0,S00000+312
         L     14,C00129
         LE    0,0(,14)
         STE   0,S00000+320
         LE    0,S00000+312
         STE   0,P00081+0
         LE    0,S00000+320
         STE   0,P00081+4
         LA    1,P00081
         L     15,C00090
         BALR  14,15
         L     14,C00128
         LE    0,0(,14)
         STE   0,S00000+312
         L     14,C00129
         LE    0,0(,14)
         STE   0,S00000+320
         LE    0,S00000+312
         STE   0,P00081+0
         LE    0,S00000+320
         STE   0,P00081+4
         LA    1,P00081
         L     15,C00090
         BALR  14,15
         L     14,C00128
         LE    0,0(,14)
         STE   0,S00000+312
         L     14,C00129
         LE    0,0(,14)
         STE   0,S00000+320
         LE    0,S00000+312
         STE   0,P00081+0
         LE    0,S00000+320
         STE   0,P00081+4
         LA    1,P00081
         L     15,C00090
         BALR  14,15
         L     15,C00075
         BALR  14,15
L00056   DS    0H
         B     L00057
L00025   DS    0H
         L     10,0(3,8)
         LR    0,10
         ST    0,P00102+0
         LA    1,P00102
         L     15,C00095
         BALR  14,15
         AH    4,C00130
         A     3,C00131
         B     L00024
L00029   DS    0H
         L     9,0(3,5)
         LR    0,9
         ST    0,P00102+0
         LA    1,P00102
         L     15,C00095
         BALR  14,15
         AH    4,C00130
         A     3,C00131
         B     L00028
L00033   DS    0H
         LE    0,0(3,2)
         STE   0,S00000+312
         LE    0,S00000+312
         STE   0,P00099+0
         LA    1,P00099
         L     15,C00100
         BALR  14,15
         AH    4,C00130
         A     3,C00131
         B     L00032
L00038   DS    0H
         L     8,0(2,4)
         LR    0,8
         ST    0,P00102+0
         LA    1,P00102
         L     15,C00095
         BALR  14,15
         AH    3,C00130
         A     2,C00131
         B     L00037
L00043   DS    0H
         LH    8,0(2,4)
         LR    0,8
         ST    0,P00124+0
         LA    1,P00124
         L     15,C00125
         BALR  14,15
         AH    3,C00130
         A     2,C00132
         B     L00042
L00057   DS    0H
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
T00019   DS    XL8
T00020   DS    XL24
T00021   DS    XL40
T00022   DS    XL60
         DS    XL4
         DS    2D
P00071   DC    F'6'
         DC    A(Q00001)
P00076   DC    F'6'
         DC    A(Q00002)
P00077   DC    F'6'
         DC    A(Q00003)
P00080   DC    F'6'
         DC    A(Q00004)
P00081   DC    A(0)
         DC    A(0)
P00085   DC    F'6'
         DC    A(Q00005)
P00086   DC    F'6'
         DC    A(Q00006)
P00091   DC    F'6'
         DC    A(Q00007)
P00093   DC    F'6'
         DC    A(Q00008)
P00094   DC    F'-2'
P00098   DC    F'6'
         DC    A(Q00009)
         DS    F
P00099   DC    A(0)
P00101   DC    F'6'
         DC    A(Q00010)
P00102   DC    A(0)
P00105   DC    A(G00104)
         DC    F'44'
         DC    F'1'
         DC    A(Q00011)
         DC    F'0'
P00107   DC    A(T00022)
P00109   DC    A(T00019)
P00110   DC    A(T00020)
P00112   DC    A(T00021)
P00115   DC    F'6'
         DC    A(Q00012)
P00116   DC    A(G00104+44)
         DC    F'44'
         DC    F'1'
         DC    A(Q00011)
         DC    F'0'
P00117   DC    F'6'
         DC    A(Q00013)
P00118   DC    A(G00104+88)
         DC    F'44'
         DC    F'1'
         DC    A(Q00014)
         DC    F'0'
P00119   DC    F'6'
         DC    A(Q00015)
P00120   DC    A(G00104+132)
         DC    F'44'
         DC    F'1'
         DC    A(Q00016)
         DC    F'0'
P00121   DC    A(G00069)
         DC    F'2'
P00123   DC    F'6'
         DC    A(Q00017)
P00124   DC    A(0)
         DC    F'2'
P00126   DC    F'6'
         DC    A(Q00018)
C00097   DC    X'4110000000000000'
C00062   DC    A(G00061)
C00064   DC    A(G00063)
C00066   DC    A(G00065)
C00068   DC    A(G00067)
C00070   DC    A(G00069)
C00072   DC    V(F77WRBEG)
C00074   DC    F'0'
C00075   DC    V(F77WREND)
C00079   DC    A(G00078)
C00082   DC    V(F77WRD)
C00083   DC    A(G00078+8)
C00084   DC    A(G00078+16)
C00088   DC    A(G00087)
C00089   DC    A(G00087+4)
C00090   DC    V(F77WRC)
C00095   DC    V(F77WRI)
C00096   DC    X'41100000'
C00100   DC    V(F77WRR)
C00103   DC    V(F77WRL)
C00106   DC    V(F77RDBI)
C00108   DC    V(F77RDI)
C00111   DC    V(F77RDR)
C00113   DC    V(F77RDD)
C00114   DC    V(F77RDEND)
C00122   DC    V(F77RDIN)
C00125   DC    V(F77WRIN)
C00128   DC    A(G00127)
C00129   DC    A(G00127+4)
C00131   DC    F'4'
C00132   DC    F'2'
C00073   DC    H'-4'
C00092   DC    H'-2'
C00130   DC    H'-1'
Q00001   DC    C'('' >I '',6(1X,Z8))'
Q00002   DC    C'('' >J '',3(1X,Z8))'
Q00003   DC    C'('' >X '',3(1X,Z8))'
Q00004   DC    C'('' >D '',Z16,1X,D23.16)'
Q00005   DC    C'('' >L '',2(1X,Z8))'
Q00006   DC    C'('' >C '',2(1X,Z8))'
Q00007   DC    C'('' >H '',Z4,1X,Z4)'
Q00008   DC    C'('' >W '',Z2,''|'',Z4,''|'',Z10,''|'',Z1'
         DC    C'2,''|'')'
Q00009   DC    C'('' >R '',Z4,''|'',Z10,''|'',Z8,''|'',Z2'
         DC    C'0,''|'')'
Q00010   DC    C'('' >Q '',Z8,Z9,''|'',Z3,''|'')'
Q00011   DC    C'(Z8,Z4,Z8,Z16)'
Q00012   DC    C'('' >1 '',Z8,1X,Z8,1X,Z8,1X,Z16)'
Q00013   DC    C'('' >2 '',Z8,1X,Z8,1X,Z8,1X,Z16)'
Q00014   DC    C'(Z12,Z2,Z4)'
Q00015   DC    C'('' >3 '',Z8,1X,Z8,1X,Z16)'
Q00016   DC    C'(Z8,Z8)'
Q00017   DC    C'('' >4 '',Z8,1X,Z4)'
Q00018   DC    C'('' >A '',A4,''|'',A4,''|'',2A2,''|'',A6'
         DC    C',A8,''|'')'
G00127   CSECT
         DS    0D
         DC    X'C1C2C3C4C5C6C7C8'
G00061   CSECT
         DS    0D
         DC    X'00000001000000FF7FFFFFFFFFFFFFFF2345678900000012'
G00063   CSECT
         DS    0D
         DC    X'000000FF000001FFFFFFFFFF'
G00065   CSECT
         DS    0D
         DC    X'4110000000000001C1200000'
G00078   CSECT
         DS    0D
         DC    X'411000000000000000000000411000000000000000000001'
G00067   CSECT
         DS    0D
         DC    X'0000000100000000'
G00087   CSECT
         DS    0D
         DC    X'0000000041100000'
G00069   CSECT
         DS    0D
         DC    X'12346789'
G00104   CSECT
         DS    0D
         DC    X'F0F0F0F0C1C2C3C4F1F2F3F4F4F1F1F0F0F0F0F0F4F1F2F0'
         DC    X'F0F0F0F0F0F0F0F0F0F0F0F1F0F0F0F0F0F0F0404040F140'
         DC    X'F240F34040C640F140C3F1F1F0F0F0F0F040F44040404040'
         DC    X'40404040404040404040404040404040F1F2F3F4F5F6F7F8'
         DC    X'F9C1C2C3F1C6C1C2C3C44040404040404040404040404040'
         DC    X'40404040404040404040404060F0F0F0F0F0F0F140F1F2F3'
         DC    X'F4F5F6F74040404040404040404040404040404040404040'
         DC    X'4040404040404040'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
