* main
F77MAIN  CSECT
         USING *,15
         B     L00068
         DC    AL1(7),CL7'F77MAIN'
L00068   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00069
L00070   DC    A(S00000)
L00069   L     15,L00070
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00024   DS    0H
         L     5,C00072
         L     2,C00074
         LH    15,C00075
         STH   15,T00016
         LA    0,6
         ST    0,P00076+0
         L     0,C00077
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00078
         BALR  14,15
         LH    4,T00016
         LR    0,4
         ST    0,P00076+0
         LA    0,2
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00079
         BALR  14,15
         L     15,C00080
         BALR  14,15
L00025   DS    0H
         LA    15,1
         L     14,C00072
         STH   15,0(,14)
         LA    15,2
         L     14,C00081
         STH   15,0(,14)
         LA    15,3
         L     14,C00082
         STH   15,0(,14)
         LA    15,4
         L     14,C00083
         STH   15,0(,14)
         LA    0,6
         ST    0,P00076+0
         L     0,C00084
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00078
         BALR  14,15
         AH    5,C00085
         LA    3,4
         LA    4,2
L00026   DS    0H
         C     4,C00086
         BC    2,L00027
L00028   DS    0H
         L     15,C00080
         BALR  14,15
L00029   DS    0H
         LA    15,0
         L     14,C00088
         ST    15,0(,14)
         LA    15,1
         L     14,C00088
         STC   15,0(,14)
         LA    15,0
         L     14,C00089
         STC   15,0(,14)
         LA    15,1
         L     14,C00090
         STC   15,0(,14)
         LA    0,6
         ST    0,P00076+0
         L     0,C00084
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00078
         BALR  14,15
         L     14,C00088
         L     4,0(,14)
         LR    0,4
         ST    0,P00076+0
         LA    1,P00076
         L     15,C00091
         BALR  14,15
         L     15,C00080
         BALR  14,15
         LA    15,1
         STC   15,T00018
         LA    15,0
         STC   15,T00017
         LA    0,6
         ST    0,P00076+0
         L     0,C00092
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00078
         BALR  14,15
         SR    4,4
         IC    4,T00018
         LR    0,4
         ST    0,P00076+0
         LA    1,P00076
         L     15,C00093
         BALR  14,15
         SR    4,4
         IC    4,T00017
         LR    0,4
         ST    0,P00076+0
         LA    1,P00076
         L     15,C00093
         BALR  14,15
         LA    0,1
         ST    0,P00076+0
         LA    1,P00076
         L     15,C00093
         BALR  14,15
         L     14,C00088
         SR    4,4
         IC    4,0(,14)
         LR    0,4
         ST    0,P00076+0
         LA    1,P00076
         L     15,C00093
         BALR  14,15
         L     14,C00094
         SR    4,4
         IC    4,0(,14)
         LR    0,4
         ST    0,P00076+0
         LA    1,P00076
         L     15,C00093
         BALR  14,15
         L     15,C00080
         BALR  14,15
L00030   DS    0H
         LA    15,300
         L     14,C00095
         STH   15,0(,14)
         LH    15,C00096
         STH   15,T00016
         LA    0,6
         ST    0,P00076+0
         L     0,C00097
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00078
         BALR  14,15
         L     0,C00098
         ST    0,P00076+0
         LA    1,P00076
         L     15,C00091
         BALR  14,15
         LH    4,T00016
         LR    0,4
         ST    0,P00076+0
         LA    0,2
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00079
         BALR  14,15
         L     15,C00080
         BALR  14,15
L00031   DS    0H
         LH    15,C00099
         L     14,C00100
         STH   15,0(,14)
         LA    0,T00023
         ST    0,P00076+0
         OI    P00076+0,X'80'
         LA    1,P00076
         L     15,C00101
         BALR  14,15
         LA    0,6
         ST    0,P00076+0
         L     0,C00084
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00078
         BALR  14,15
         L     4,T00023
         LR    0,4
         ST    0,P00076+0
         LA    1,P00076
         L     15,C00091
         BALR  14,15
         L     15,C00080
         BALR  14,15
         LA    0,6
         ST    0,P00076+0
         L     0,C00102
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00078
         BALR  14,15
         L     14,C00104
         LH    4,0(,14)
         LR    0,4
         ST    0,P00076+0
         LA    0,2
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00079
         BALR  14,15
         LR    5,2
         AH    5,C00099
         LA    3,2
         LA    4,3
L00032   DS    0H
         C     4,C00086
         BC    2,L00033
L00034   DS    0H
         L     15,C00080
         BALR  14,15
L00035   DS    0H
         LA    15,1
         STH   15,T00016
L00036   DS    0H
         LH    6,C00105
         LA    7,0
         LA    3,3
L00037   DS    0H
         LA    0,6
         ST    0,P00076+0
         L     0,C00077
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00078
         BALR  14,15
         LH    5,T00016
         LR    0,5
         ST    0,P00076+0
         LA    0,2
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00079
         BALR  14,15
         L     15,C00080
         BALR  14,15
L00039   DS    0H
         LH    4,T00016
         SLL   4,16
         A     4,C00106
         SRA   4,16
         STH   4,T00016
         BXH   3,6,L00037
L00038   DS    0H
         LA    0,T00019
         ST    0,P00076+0
         LA    0,12
         ST    0,P00076+4
         L     0,C00107
         ST    0,P00076+8
         LA    0,12
         ST    0,P00076+12
         LA    1,P00076
         L     15,C00108
         BALR  14,15
         LA    0,T00019
         ST    0,P00076+0
         LA    0,12
         ST    0,P00076+4
         LA    0,1
         ST    0,P00076+8
         L     0,C00109
         ST    0,P00076+12
         LA    0,0
         ST    0,P00076+16
         LA    1,P00076
         L     15,C00110
         BALR  14,15
         LA    0,T00016
         ST    0,P00076+0
         LA    0,2
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00111
         BALR  14,15
         L     0,C00104
         ST    0,P00076+0
         LA    0,2
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00111
         BALR  14,15
         L     15,C00112
         BALR  14,15
         LA    0,6
         ST    0,P00076+0
         L     0,C00102
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00078
         BALR  14,15
         LH    4,T00016
         LR    0,4
         ST    0,P00076+0
         LA    0,2
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00079
         BALR  14,15
         L     14,C00104
         LH    4,0(,14)
         LR    0,4
         ST    0,P00076+0
         LA    0,2
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00079
         BALR  14,15
         L     15,C00080
         BALR  14,15
         LH    15,C00113
         STH   15,T00016
L00041   DS    0H
         LR    8,2
         AH    8,C00099
         LA    6,2
         LA    7,6
         LA    3,2
         LA    4,1
L00042   DS    0H
         LH    5,0(3,8)
         LR    1,5
         MR    0,4
         LR    5,1
         SLL   5,16
         SRA   5,16
         STH   5,0(3,8)
L00044   DS    0H
         A     4,C00114
         BXLE  3,6,L00042
L00043   DS    0H
L00040   DS    0H
         LA    0,6
         ST    0,P00076+0
         L     0,C00102
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00078
         BALR  14,15
         LH    4,T00016
         LR    0,4
         ST    0,P00076+0
         LA    0,2
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00079
         BALR  14,15
         AH    2,C00099
         LA    3,2
         LA    4,3
L00045   DS    0H
         C     4,C00086
         BC    2,L00046
L00047   DS    0H
         L     15,C00080
         BALR  14,15
         MVC   T00021(8),C00115
         MVC   T00021+8(8),C00116
         MVC   T00021+16(8),C00117
         MVC   T00021+24(8),C00118
L00049   DS    0H
         L     6,C00106
         L     7,C00119
         L     2,C00106
         LA    3,2
L00050   DS    0H
         LR    4,2
         A     4,C00120
         SRA   4,16
         STH   4,T00021-2(3)
L00052   DS    0H
         A     3,C00121
         BXLE  2,6,L00050
L00051   DS    0H
L00048   DS    0H
         LA    0,6
         ST    0,P00076+0
         L     0,C00122
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00078
         BALR  14,15
         LD    0,T00021+16
         STD   0,S00000+512
         LD    0,S00000+512
         STD   0,P00076+0
         LA    1,P00076
         L     15,C00123
         BALR  14,15
         LD    0,T00021+24
         STD   0,S00000+512
         LD    0,S00000+512
         STD   0,P00076+0
         LA    1,P00076
         L     15,C00123
         BALR  14,15
         L     15,C00080
         BALR  14,15
L00053   DS    0H
L00055   DS    0H
         LA    6,2
         LA    7,16
         LA    3,2
         LA    2,0
L00056   DS    0H
         LH    4,T00021-2(3)
         AR    2,4
L00058   DS    0H
         BXLE  3,6,L00056
L00057   DS    0H
L00054   DS    0H
         LA    0,6
         ST    0,P00076+0
         L     0,C00084
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00078
         BALR  14,15
         LR    0,2
         ST    0,P00076+0
         LA    1,P00076
         L     15,C00091
         BALR  14,15
         L     15,C00080
         BALR  14,15
         LH    3,T00016
         L     14,C00104
         LH    2,0(,14)
         CR    3,2
         BC    13,L00060
L00059   DS    0H
         LA    0,6
         ST    0,P00076+0
         L     0,C00077
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00078
         BALR  14,15
         LH    3,T00016
         LR    0,3
         ST    0,P00076+0
         LA    0,2
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00079
         BALR  14,15
         L     15,C00080
         BALR  14,15
L00060   DS    0H
         LH    15,C00075
         STH   15,T00022
L00061   DS    0H
         LH    3,T00022
         LA    0,6
         ST    0,P00076+0
         L     0,C00097
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00078
         BALR  14,15
         LR    0,3
         ST    0,P00076+0
         LA    1,P00076
         L     15,C00091
         BALR  14,15
         LH    15,C00124
         ST    15,T00013
         LA    0,T00013
         ST    0,P00076+0
         OI    P00076+0,X'80'
         LA    1,P00076
         L     15,C00125
         BALR  14,15
         LR    3,0
         LR    0,3
         ST    0,P00076+0
         LA    1,P00076
         L     15,C00091
         BALR  14,15
         L     15,C00080
         BALR  14,15
         LA    0,6
         ST    0,P00076+0
         L     0,C00126
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00078
         BALR  14,15
         LA    15,1
         ST    15,T00014
         LA    0,T00015
         ST    0,P00076+0
         LA    0,3
         ST    0,P00076+4
         LA    0,T00014
         ST    0,P00076+8
         OI    P00076+8,X'80'
         LA    1,P00076
         L     15,C00127
         BALR  14,15
         LA    0,T00015
         ST    0,P00076+0
         LA    0,3
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00128
         BALR  14,15
         L     15,C00080
         BALR  14,15
         LA    0,T00019
         ST    0,P00076+0
         LA    0,12
         ST    0,P00076+4
         L     0,C00129
         ST    0,P00076+8
         LA    0,4
         ST    0,P00076+12
         LA    1,P00076
         L     15,C00108
         BALR  14,15
         LA    0,T00019
         ST    0,P00076+0
         LA    0,12
         ST    0,P00076+4
         LA    0,1
         ST    0,P00076+8
         L     0,C00130
         ST    0,P00076+12
         LA    0,0
         ST    0,P00076+16
         LA    1,P00076
         L     15,C00110
         BALR  14,15
         LA    2,2
         LA    3,2
L00062   DS    0H
         C     3,C00086
         BC    2,L00063
L00064   DS    0H
         L     15,C00112
         BALR  14,15
         LA    0,6
         ST    0,P00076+0
         L     0,C00131
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00078
         BALR  14,15
         LH    3,T00020+2
         LR    0,3
         ST    0,P00076+0
         LA    0,2
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00079
         BALR  14,15
         LH    3,T00020
         LR    0,3
         ST    0,P00076+0
         LA    0,2
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00079
         BALR  14,15
         L     14,C00133
         LH    3,0(,14)
         LR    0,3
         ST    0,P00076+0
         LA    0,2
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00079
         BALR  14,15
         L     15,C00080
         BALR  14,15
L00065   DS    0H
L00066   DS    0H
         B     L00067
L00027   DS    0H
         L     7,0(3,5)
         LR    0,7
         ST    0,P00076+0
         LA    1,P00076
         L     15,C00091
         BALR  14,15
         AH    4,C00105
         A     3,C00134
         B     L00026
L00033   DS    0H
         LH    7,0(3,5)
         LR    0,7
         ST    0,P00076+0
         LA    0,2
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00079
         BALR  14,15
         AH    4,C00105
         A     3,C00121
         B     L00032
L00046   DS    0H
         LH    6,0(3,2)
         LR    0,6
         ST    0,P00076+0
         LA    0,2
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00079
         BALR  14,15
         AH    4,C00105
         A     3,C00121
         B     L00045
L00063   DS    0H
         LR    4,2
         AH    4,C00099
         LA    5,T00020
         AR    5,4
         LR    0,5
         ST    0,P00076+0
         LA    0,2
         ST    0,P00076+4
         LA    1,P00076
         L     15,C00111
         BALR  14,15
         AH    3,C00105
         A     2,C00121
         B     L00062
L00067   DS    0H
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
T00016   DS    XL8
T00017   DS    XL8
T00018   DS    XL16
T00019   DS    XL16
T00020   DS    XL32
T00021   DS    XL60
         DS    XL4
T00022   DS    XL76
         DS    XL4
T00023   DS    XL84
         DS    XL4
         DS    1D
P00076   DS    5F
         DS    XL4
C00115   DC    X'4118000000000000'
C00116   DC    X'4128000000000000'
C00117   DC    X'4138000000000000'
C00118   DC    X'4148000000000000'
C00072   DC    A(G00071)
C00074   DC    A(G00073)
C00077   DC    A(Q00001)
C00078   DC    V(F77WRBEG)
C00079   DC    V(F77WRIN)
C00080   DC    V(F77WREND)
C00081   DC    A(G00071+2)
C00082   DC    A(G00071+4)
C00083   DC    A(G00071+6)
C00084   DC    A(Q00002)
C00086   DC    F'0'
C00088   DC    A(G00087)
C00089   DC    A(G00087+2)
C00090   DC    A(G00087+3)
C00091   DC    V(F77WRI)
C00092   DC    A(Q00003)
C00093   DC    V(F77WRL)
C00094   DC    A(G00087+1)
C00095   DC    A(C)
C00097   DC    A(Q00004)
C00098   DC    F'90000'
C00100   DC    A(C+6)
C00101   DC    V(SUB)
C00102   DC    A(Q00005)
C00104   DC    A(G00103)
C00106   DC    F'65536'
C00107   DC    A(Q00006)
C00108   DC    V(F77STRCP)
C00109   DC    A(Q00007)
C00110   DC    V(F77RDBI)
C00111   DC    V(F77RDIN)
C00112   DC    V(F77RDEND)
C00114   DC    F'1'
C00119   DC    F'524288'
C00120   DC    F'6553600'
C00121   DC    F'2'
C00122   DC    A(Q00008)
C00123   DC    V(F77WRD)
C00125   DC    V(IH)
C00126   DC    A(Q00009)
C00127   DC    V(C3)
C00128   DC    V(F77WRA)
C00129   DC    A(Q00010)
C00130   DC    A(Q00011)
C00131   DC    A(Q00012)
C00133   DC    A(G00132)
C00134   DC    F'4'
C00075   DC    H'-25536'
C00085   DC    H'-4'
C00096   DC    H'24464'
C00099   DC    H'-2'
C00105   DC    H'-1'
C00113   DC    H'-32760'
C00124   DC    H'-3'
Q00001   DC    C'('' >K '',I8)'
Q00002   DC    C'('' >IW '',2I12)'
Q00003   DC    C'('' >L '',5L3)'
Q00004   DC    C'('' >MM '',2I10)'
Q00005   DC    C'('' >KD '',4I6)'
Q00008   DC    C'('' >Z '',2F6.2)'
Q00012   DC    C'('' >A '',2A2,1X,A2)'
Q00009   DC    C'('' >C3 '',A)'
Q00006   DC    C'  1234 70000'
Q00007   DC    C'(2I6)'
Q00010   DC    C'ELMS'
Q00011   DC    C'(2A2)'
* JH
JH       CSECT
         USING *,15
         B     L00139
         DC    AL1(2),CL7'JH'
L00139   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00140
L00141   DC    A(S00135)
L00140   L     15,L00141
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00135,13
         ST    1,S00135+72
L00137   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         SLL   2,1
         SLL   2,16
         SRA   2,16
         STH   2,T00136
         LR    0,2
L00138   DS    0H
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
T00136   DS    XL8
* IH
IH       CSECT
         USING *,15
         B     L00146
         DC    AL1(2),CL7'IH'
L00146   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00147
L00148   DC    A(S00142)
L00147   L     15,L00148
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00142,13
         ST    1,S00142+72
L00144   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         LR    1,2
         M     0,C00149
         LR    2,1
         SLL   2,16
         SRA   2,16
         STH   2,T00143
         LR    0,2
L00145   DS    0H
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
T00143   DS    XL8
C00149   DC    F'30000'
* C3
C3       CSECT
         USING *,15
         B     L00154
         DC    AL1(2),CL7'C3'
L00154   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00155
L00156   DC    A(S00150)
L00155   L     15,L00156
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00150,13
         ST    1,S00150+72
L00152   DS    0H
         L     3,0(,1)
         LR    0,3
         ST    0,P00157+0
         LA    0,3
         ST    0,P00157+4
         L     0,C00158
         ST    0,P00157+8
         LA    0,3
         ST    0,P00157+12
         LA    1,P00157
         L     15,C00159
         BALR  14,15
         ICM   2,8,0(3)
         SRA   2,24
         LR    0,2
L00153   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00150   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00157   DS    4F
C00158   DC    A(Q00151)
C00159   DC    V(F77STRCP)
Q00151   DC    C'OAK'
* SUB
SUB      CSECT
         USING *,15
         B     L00163
         DC    AL1(3),CL7'SUB'
L00163   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00164
L00165   DC    A(S00160)
L00164   L     15,L00165
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00160,13
         ST    1,S00160+72
L00161   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     14,C00166
         L     2,0(,14)
         ST    2,0(,3)
         LA    0,0
L00162   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00160   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00166   DC    A(C)
* BUMP
BUMP     CSECT
         USING *,15
         B     L00174
         DC    AL1(4),CL7'BUMP'
L00174   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00175
L00176   DC    A(S00167)
L00175   L     15,L00176
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00167,13
         ST    1,S00167+72
L00168   DS    0H
         L     3,0(,1)
         L     5,4(,1)
         L     4,8(,1)
         LA    4,0(,4)
         LH    2,0(,3)
         SLL   2,16
         A     2,C00177
         SRA   2,16
         STH   2,0(,3)
         L     3,0(,4)
         S     3,C00178
         A     3,C00178
L00169   DS    0H
         AH    5,C00179
         LA    6,2
         LR    2,3
         SLL   2,1
         LA    7,0
         AR    7,2
         C     3,C00180
         BC    2,L00181
         B     L00171
L00181   DS    0H
         LA    2,2
         LA    3,1
         B     L00170
L00171   DS    0H
         LA    0,0
         B     L00173
L00170   DS    0H
         LH    4,0(2,5)
         LR    1,4
         MR    0,3
         LR    4,1
         SLL   4,16
         SRA   4,16
         STH   4,0(2,5)
L00172   DS    0H
         A     3,C00178
         BXLE  2,6,L00170
         B     L00171
L00173   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00167   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00177   DC    F'2147418112'
C00178   DC    F'1'
C00180   DC    F'0'
C00179   DC    H'-2'
* PACK
PACK     CSECT
         USING *,15
         B     L00189
         DC    AL1(4),CL7'PACK'
L00189   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00190
L00191   DC    A(S00182)
L00190   L     15,L00191
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00182,13
         ST    1,S00182+72
L00183   DS    0H
         L     5,0(,1)
         L     2,4(,1)
         LA    2,0(,2)
         L     3,0(,2)
         S     3,C00192
         A     3,C00192
L00184   DS    0H
         AH    5,C00193
         L     6,C00194
         LR    2,3
         SLL   2,16
         LA    7,0
         AR    7,2
         C     3,C00195
         BC    2,L00196
         B     L00186
L00196   DS    0H
         L     2,C00194
         LA    3,2
         B     L00185
L00186   DS    0H
         LA    0,0
         B     L00188
L00185   DS    0H
         LR    4,2
         A     4,C00197
         SRA   4,16
         STH   4,0(3,5)
L00187   DS    0H
         A     3,C00198
         BXLE  2,6,L00185
         B     L00186
L00188   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00182   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00192   DC    F'1'
C00194   DC    F'65536'
C00195   DC    F'0'
C00197   DC    F'6553600'
C00198   DC    F'2'
C00193   DC    H'-2'
* UNPK
UNPK     CSECT
         USING *,15
         B     L00206
         DC    AL1(4),CL7'UNPK'
L00206   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00207
L00208   DC    A(S00199)
L00207   L     15,L00208
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00199,13
         ST    1,S00199+72
L00200   DS    0H
         L     4,0(,1)
         L     2,4(,1)
         L     5,8(,1)
         LA    5,0(,5)
         LA    15,0
         ST    15,0(,5)
         L     3,0(,2)
         S     3,C00209
         A     3,C00209
L00201   DS    0H
         AH    4,C00210
         LA    6,2
         LR    2,3
         SLL   2,1
         LA    7,0
         AR    7,2
         C     3,C00211
         BC    2,L00212
         B     L00203
L00212   DS    0H
         LA    2,2
         B     L00202
L00203   DS    0H
         LA    0,0
         B     L00205
L00202   DS    0H
         LH    3,0(2,4)
         A     3,0(,5)
         ST    3,0(,5)
L00204   DS    0H
         BXLE  2,6,L00202
         B     L00203
L00205   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00199   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00209   DC    F'1'
C00211   DC    F'0'
C00210   DC    H'-2'
C        CSECT
         DS    0D
         DS    XL8
G00071   CSECT
         DS    0D
         DS    XL8
G00087   CSECT
         DS    0D
         DS    XL4
G00103   CSECT
         DS    0D
         DC    X'FFF9'
G00073   CSECT
         DS    0D
         DC    X'000500050005'
G00132   CSECT
         DS    0D
         DC    X'D7D8'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
