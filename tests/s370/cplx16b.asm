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
L00010   DS    0H
         LD    2,C00053
         LCDR  2,2
         MVC   T00009(8),C00054
         STD   2,T00009+8
         LD    0,C00054
         CD    0,C00054
         LA    3,1
         BC    8,L00055
         SR    3,3
L00055   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00056
         SR    2,2
L00056   DS    0H
         LD    0,C00053
         LCDR  0,0
         CDR   2,0
         LA    4,1
         BC    8,L00057
         SR    4,4
L00057   DS    0H
         LTR   4,4
         LA    3,1
         BC    8,L00058
         SR    3,3
L00058   DS    0H
         OR    2,3
         LTR   2,2
         BC    7,L00011
L00012   DS    0H
         MVC   T00005(8),C00059
         MVC   T00005+8(8),C00060
         LD    0,C00059
         CD    0,C00059
         LA    2,1
         BC    8,L00061
         SR    2,2
L00061   DS    0H
         LD    0,C00060
         CD    0,C00060
         LA    3,1
         BC    8,L00062
         SR    3,3
L00062   DS    0H
         NR    2,3
         LTR   2,2
         LA    3,1
         BC    8,L00063
         SR    3,3
L00063   DS    0H
         LTR   3,3
         BC    7,L00013
L00014   DS    0H
         LD    0,C00064
         LCDR  0,0
         L     14,C00066
         MVC   0(8,14),C00064
         L     14,C00067
         STD   0,0(,14)
         LD    0,C00064
         L     15,C00066
         CD    0,0(,15)
         LA    3,1
         BC    8,L00068
         SR    3,3
L00068   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00069
         SR    2,2
L00069   DS    0H
         LD    0,C00064
         LCDR  0,0
         L     15,C00066
         CD    0,8(,15)
         LA    4,1
         BC    8,L00070
         SR    4,4
L00070   DS    0H
         LTR   4,4
         LA    3,1
         BC    8,L00071
         SR    3,3
L00071   DS    0H
         OR    2,3
         LTR   2,2
         BC    7,L00015
L00016   DS    0H
L00017   DS    0H
         LA    4,16
         LA    5,64
         LA    2,16
         LA    3,1
L00018   DS    0H
         LR    0,3
         X     0,C00072
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00073
         LR    0,3
         X     0,C00072
         ST    0,S00000+84
         LD    2,S00000+80
         SD    2,C00073
         LCDR  2,2
         LD    4,C00074
         MDR   4,0
         LD    6,C00064
         MDR   6,2
         SDR   4,6
         MD    0,C00064
         MD    2,C00074
         ADR   0,2
         STD   4,T00008-16(2)
         STD   0,T00008-8(2)
L00020   DS    0H
         A     3,C00075
         BXLE  2,4,L00018
L00019   DS    0H
         MVC   T00006(8),C00074
         MVC   T00006+8(8),C00074
L00022   DS    0H
         LA    4,16
         LA    5,64
         LA    2,16
L00023   DS    0H
         LD    2,T00006
         LD    0,T00006+8
         AD    2,T00008-16(2)
         AD    0,T00008-8(2)
         STD   2,T00006
         STD   0,T00006+8
L00025   DS    0H
         BXLE  2,4,L00023
L00024   DS    0H
L00021   DS    0H
         LD    0,C00076
         CD    0,T00006
         LA    2,1
         BC    8,L00077
         SR    2,2
L00077   DS    0H
         LD    0,C00076
         CD    0,T00006+8
         LA    3,1
         BC    8,L00078
         SR    3,3
L00078   DS    0H
         NR    2,3
         LTR   2,2
         LA    3,1
         BC    8,L00079
         SR    3,3
L00079   DS    0H
         LTR   3,3
         BC    7,L00026
L00027   DS    0H
         LA    0,2
         X     0,C00072
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00073
         LD    6,T00008+16
         ADR   6,0
         LD    4,C00074
         AD    4,T00008+24
L00028   DS    0H
         STD   6,T00006
         STD   4,T00006+8
         LD    2,C00080
         AD    2,T00008+16
         LD    0,C00074
         AD    0,T00008+24
         CDR   6,2
         LA    2,1
         BC    8,L00081
         SR    2,2
L00081   DS    0H
         CDR   4,0
         LA    3,1
         BC    8,L00082
         SR    3,3
L00082   DS    0H
         NR    2,3
         LTR   2,2
         LA    3,1
         BC    8,L00083
         SR    3,3
L00083   DS    0H
         LTR   3,3
         BC    7,L00029
L00030   DS    0H
         LA    0,1
         ST    0,P00084+0
         LA    0,0
         ST    0,P00084+4
         LA    0,0
         ST    0,P00084+8
         L     0,C00085
         ST    0,P00084+12
         LA    0,7
         ST    0,P00084+16
         LA    0,0
         ST    0,P00084+20
         LA    0,0
         ST    0,P00084+24
         L     0,C00086
         ST    0,P00084+28
         LA    0,11
         ST    0,P00084+32
         LA    0,0
         ST    0,P00084+36
         LA    0,0
         ST    0,P00084+40
         LA    0,0
         ST    0,P00084+44
         LA    0,0
         ST    0,P00084+48
         LA    1,P00084
         L     15,C00087
         BALR  14,15
         LA    0,1
         ST    0,P00084+0
         LA    1,P00084
         L     15,C00088
         BALR  14,15
         LA    2,16
         LA    3,4
L00031   DS    0H
         C     3,C00089
         BC    2,L00032
L00033   DS    0H
         L     15,C00090
         BALR  14,15
         LA    0,1
         ST    0,P00084+0
         LA    1,P00084
         L     15,C00091
         BALR  14,15
         MVC   T00008(8),C00074
         MVC   T00008+8(8),C00074
         MVC   T00008+32(8),C00074
         MVC   T00008+40(8),C00074
         LA    0,1
         ST    0,P00084+0
         LA    0,0
         ST    0,P00084+4
         LA    1,P00084
         L     15,C00092
         BALR  14,15
         LA    2,16
         LA    3,4
L00034   DS    0H
         C     3,C00089
         BC    2,L00035
L00036   DS    0H
         L     15,C00093
         BALR  14,15
         LD    0,C00064
         CD    0,T00008
         LA    3,1
         BC    8,L00094
         SR    3,3
L00094   DS    0H
         LD    0,C00064
         CD    0,T00008+8
         LA    2,1
         BC    8,L00095
         SR    2,2
L00095   DS    0H
         NR    3,2
         LTR   3,3
         LA    2,1
         BC    8,L00096
         SR    2,2
L00096   DS    0H
         LD    0,C00097
         CD    0,T00008+32
         LA    3,1
         BC    8,L00098
         SR    3,3
L00098   DS    0H
         LD    0,C00097
         CD    0,T00008+40
         LA    4,1
         BC    8,L00099
         SR    4,4
L00099   DS    0H
         NR    3,4
         LTR   3,3
         LA    4,1
         BC    8,L00100
         SR    4,4
L00100   DS    0H
         OR    2,4
         LTR   2,2
         BC    7,L00037
L00038   DS    0H
         MVC   T00004(4),C00101
         MVC   T00004+4(4),C00102
         MVC   S00000+88(4),C00102
         LD    6,S00000+88
         MVC   S00000+88(4),C00101
         LD    4,S00000+88
         STD   4,T00005
         STD   6,T00005+8
         MVC   S00000+88(4),C00102
         LD    2,S00000+88
         MVC   S00000+88(4),C00101
         LD    0,S00000+88
         CDR   4,0
         LA    3,1
         BC    8,L00103
         SR    3,3
L00103   DS    0H
         CDR   6,2
         LA    2,1
         BC    8,L00104
         SR    2,2
L00104   DS    0H
         NR    3,2
         LTR   3,3
         LA    2,1
         BC    8,L00105
         SR    2,2
L00105   DS    0H
         CD    4,C00053
         LA    3,1
         BC    8,L00106
         SR    3,3
L00106   DS    0H
         CD    6,C00054
         LA    4,1
         BC    8,L00107
         SR    4,4
L00107   DS    0H
         NR    3,4
         LTR   3,3
         LA    4,1
         BC    8,L00108
         SR    4,4
L00108   DS    0H
         OR    2,4
         LTR   2,2
         BC    7,L00039
L00040   DS    0H
         LD    0,C00064
         STD   0,P00084+0
         LD    0,C00074
         STD   0,P00084+8
         LD    0,C00097
         STD   0,P00084+16
         LD    0,C00074
         STD   0,P00084+24
         LA    0,T00007
         ST    0,P00084+32
         LA    1,P00084
         L     15,C00109
         BALR  14,15
         LD    4,T00007
         LD    2,T00007+8
         STD   4,T00005
         STD   2,T00005+8
         LDR   0,2
         LER   0,0
         LDR   2,4
         LER   2,2
         STE   2,T00004
         STE   0,T00004+4
         STE   2,S00000+88
         LD    0,S00000+88
         CDR   4,0
         BC    8,L00041
L00042   DS    0H
         LD    0,C00110
         LTDR  0,0
         LPDR  0,0
         AW    0,C00111
         STD   0,S00000+168
         L     2,S00000+172
         LD    0,C00110
         LTDR  0,0
         BC    10,L00112
         LCR   2,2
L00112   DS    0H
         C     2,C00113
         BC    7,L00043
L00044   DS    0H
         LD    0,C00097
         CD    0,C00097
         LA    2,1
         BC    8,L00114
         SR    2,2
L00114   DS    0H
         LD    0,C00074
         CD    0,C00074
         LA    3,1
         BC    8,L00115
         SR    3,3
L00115   DS    0H
         NR    2,3
         LTR   2,2
         LA    3,1
         BC    8,L00116
         SR    3,3
L00116   DS    0H
         LTR   3,3
         BC    7,L00045
L00046   DS    0H
         LA    0,6
         ST    0,P00084+0
         L     0,C00117
         ST    0,P00084+4
         LA    1,P00084
         L     15,C00118
         BALR  14,15
         LA    0,10
         ST    0,P00084+0
         LA    1,P00084
         L     15,C00119
         BALR  14,15
         L     15,C00120
         BALR  14,15
L00047   DS    0H
         LA    0,0
         ST    0,P00084+0
         LA    1,P00084
         L     15,C00121
         BALR  14,15
         B     L00049
L00011   DS    0H
         LA    0,1
         ST    0,P00084+0
         LA    1,P00084
         L     15,C00121
         BALR  14,15
         B     L00049
L00013   DS    0H
         LA    0,2
         ST    0,P00084+0
         LA    1,P00084
         L     15,C00121
         BALR  14,15
         B     L00049
L00015   DS    0H
         LA    0,3
         ST    0,P00084+0
         LA    1,P00084
         L     15,C00121
         BALR  14,15
         B     L00049
L00026   DS    0H
         LA    0,4
         ST    0,P00084+0
         LA    1,P00084
         L     15,C00121
         BALR  14,15
         B     L00049
L00029   DS    0H
         LA    0,5
         ST    0,P00084+0
         LA    1,P00084
         L     15,C00121
         BALR  14,15
         B     L00049
L00032   DS    0H
         LR    4,2
         AH    4,C00122
         LA    5,T00008
         AR    5,4
         LR    0,5
         ST    0,P00084+0
         LA    0,16
         ST    0,P00084+4
         LA    1,P00084
         L     15,C00123
         BALR  14,15
         AH    3,C00124
         A     2,C00125
         B     L00031
L00035   DS    0H
         LR    4,2
         AH    4,C00122
         LA    5,T00008
         AR    5,4
         LR    0,5
         ST    0,P00084+0
         LA    0,16
         ST    0,P00084+4
         LA    1,P00084
         L     15,C00126
         BALR  14,15
         AH    3,C00124
         A     2,C00125
         B     L00034
L00037   DS    0H
         LA    0,6
         ST    0,P00084+0
         LA    1,P00084
         L     15,C00121
         BALR  14,15
         B     L00049
L00039   DS    0H
         LA    0,7
         ST    0,P00084+0
         LA    1,P00084
         L     15,C00121
         BALR  14,15
         B     L00049
L00041   DS    0H
         LA    0,8
         ST    0,P00084+0
         LA    1,P00084
         L     15,C00121
         BALR  14,15
         B     L00049
L00043   DS    0H
         LA    0,9
         ST    0,P00084+0
         LA    1,P00084
         L     15,C00121
         BALR  14,15
         B     L00049
L00045   DS    0H
         LA    0,10
         ST    0,P00084+0
         LA    1,P00084
         L     15,C00121
         BALR  14,15
         B     L00049
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
T00004   DS    XL12
         DS    XL4
T00005   DS    XL20
         DS    XL4
T00006   DS    XL20
         DS    XL4
T00007   DS    XL72
T00008   DS    XL108
         DS    XL4
T00009   DS    XL140
         DS    XL4
P00084   DS    13F
         DS    XL4
C00053   DC    X'4080000000000000'
C00054   DC    X'4040000000000000'
C00059   DC    X'4140000000000000'
C00060   DC    X'4160000000000000'
C00064   DC    X'4110000000000000'
C00073   DC    X'4E00000080000000'
C00074   DC    X'0000000000000000'
C00076   DC    X'41A0000000000000'
C00080   DC    X'4120000000000000'
C00097   DC    X'4130000000000000'
C00110   DC    X'4128000000000000'
C00111   DC    X'4E00000000000000'
C00066   DC    A(G00065)
C00067   DC    A(G00065+8)
C00072   DC    F'-2147483648'
C00075   DC    F'1'
C00085   DC    A(Q00002)
C00086   DC    A(Q00001)
C00087   DC    V(F77OPEN)
C00088   DC    V(F77WUBEG)
C00089   DC    F'0'
C00090   DC    V(F77WUEND)
C00091   DC    V(F77REWND)
C00092   DC    V(F77RUBEG)
C00093   DC    V(F77RUEND)
C00101   DC    X'40800000'
C00102   DC    X'40400000'
C00109   DC    V(F77ZDIV)
C00113   DC    F'2'
C00117   DC    A(Q00003)
C00118   DC    V(F77WRBEG)
C00119   DC    V(F77WRI)
C00120   DC    V(F77WREND)
C00121   DC    V(EXIT)
C00123   DC    V(F77WU)
C00125   DC    F'16'
C00126   DC    V(F77RU)
C00122   DC    H'-16'
C00124   DC    H'-1'
Q00003   DC    C'(1X,''>CPLX16B'',I4)'
Q00001   DC    C'UNFORMATTED'
Q00002   DC    C'SCRATCH'
* ZSUM
ZSUM     CSECT
         USING *,15
         B     L00134
         DC    AL1(4),CL7'ZSUM'
L00134   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00135
L00136   DC    A(S00127)
L00135   L     15,L00136
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00127,13
         ST    1,S00127+72
L00128   DS    0H
         L     4,0(,1)
         L     2,4(,1)
         L     5,8(,1)
         LA    5,0(,5)
         MVC   0(8,5),C00137
         MVC   8(8,5),C00137
         L     3,0(,2)
         S     3,C00138
         A     3,C00138
L00129   DS    0H
         AH    4,C00139
         LA    6,16
         LR    2,3
         SLL   2,4
         LA    7,0
         AR    7,2
         C     3,C00140
         BC    2,L00141
         B     L00131
L00141   DS    0H
         LA    2,16
         B     L00130
L00131   DS    0H
         LA    0,0
         B     L00133
L00130   DS    0H
         LD    2,0(,5)
         LD    0,8(,5)
         AD    2,0(2,4)
         AD    0,8(2,4)
         STD   2,0(,5)
         STD   0,8(,5)
L00132   DS    0H
         BXLE  2,6,L00130
         B     L00131
L00133   DS    0H
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
C00137   DC    X'0000000000000000'
C00138   DC    F'1'
C00140   DC    F'0'
C00139   DC    H'-16'
* DF
DF       CSECT
         USING *,15
         B     L00145
         DC    AL1(2),CL7'DF'
L00145   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00146
L00147   DC    A(S00142)
L00146   L     15,L00147
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00142,13
         ST    1,S00142+72
L00143   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         LA    0,2
         X     0,C00148
         ST    0,S00142+84
         LD    0,S00142+80
         SD    0,C00149
         LD    2,0(,2)
         ADR   2,0
         LD    0,C00150
         AD    0,8(,2)
         LDR   4,0
         LDR   0,2
         LDR   2,4
L00144   DS    0H
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
C00149   DC    X'4E00000080000000'
C00150   DC    X'0000000000000000'
C00148   DC    F'-2147483648'
G00065   CSECT
         DS    0D
         DS    XL16
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
