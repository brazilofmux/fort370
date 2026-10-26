* main
F77MAIN  CSECT
         USING *,15
         B     L00065
         DC    AL1(7),CL7'F77MAIN'
L00065   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00066
L00067   DC    A(S00000)
L00066   L     15,L00067
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00001   DS    0H
L00003   DS    0H
L00005   DS    0H
         LE    0,C00068
         LCER  0,0
         LPER  0,0
         CE    0,C00068
         LA    3,1
         BC    8,L00069
         SR    3,3
L00069   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00070
         SR    2,2
L00070   DS    0H
         LTR   2,2
         BC    7,L00006
L00007   DS    0H
         LD    0,C00071
         LCDR  0,0
         LDR   2,0
         LPDR  2,2
         CD    2,C00071
         LA    3,1
         BC    8,L00072
         SR    3,3
L00072   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00073
         SR    2,2
L00073   DS    0H
         LTR   2,2
         BC    7,L00008
L00009   DS    0H
         LCDR  0,0
         LPDR  0,0
         CD    0,C00071
         LA    3,1
         BC    8,L00074
         SR    3,3
L00074   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00075
         SR    2,2
L00075   DS    0H
         LTR   2,2
         BC    7,L00010
L00011   DS    0H
L00013   DS    0H
L00015   DS    0H
L00017   DS    0H
L00019   DS    0H
         LE    0,C00068
         CE    0,C00076
         BC    4,L00020
L00021   DS    0H
         LE    0,C00068
L00022   DS    0H
         CE    0,C00068
         LA    3,1
         BC    8,L00077
         SR    3,3
L00077   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00078
         SR    2,2
L00078   DS    0H
         LTR   2,2
         BC    7,L00023
L00024   DS    0H
         LD    0,C00079
         CD    0,C00080
         BC    4,L00025
L00026   DS    0H
         LD    0,C00079
L00027   DS    0H
         CD    0,C00079
         LA    3,1
         BC    8,L00081
         SR    3,3
L00081   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00082
         SR    2,2
L00082   DS    0H
         LTR   2,2
         BC    7,L00028
L00029   DS    0H
         LD    0,C00080
         CD    0,C00079
         BC    4,L00030
L00031   DS    0H
         LD    0,C00079
L00032   DS    0H
         CD    0,C00080
         LA    3,1
         BC    8,L00083
         SR    3,3
L00083   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00084
         SR    2,2
L00084   DS    0H
         LTR   2,2
         BC    7,L00033
L00034   DS    0H
         LD    0,C00080
         LCDR  0,0
         LD    2,C00079
         LCDR  2,2
         CDR   2,0
         BC    4,L00035
L00036   DS    0H
         LDR   0,2
L00037   DS    0H
         LD    2,C00080
         LCDR  2,2
         CDR   0,2
         LA    3,1
         BC    8,L00085
         SR    3,3
L00085   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00086
         SR    2,2
L00086   DS    0H
         LTR   2,2
         BC    7,L00038
L00039   DS    0H
L00041   DS    0H
L00043   DS    0H
         LE    0,C00087
         STE   0,S00000+88
         LD    0,S00000+88
         LTDR  0,0
         LPDR  0,0
         AW    0,C00088
         STD   0,S00000+168
         L     2,S00000+172
         LE    0,C00087
         LTDR  0,0
         BC    10,L00089
         LCR   2,2
L00089   DS    0H
         C     2,C00090
         BC    7,L00044
L00045   DS    0H
         LD    0,C00091
         LTDR  0,0
         LPDR  0,0
         AW    0,C00088
         STD   0,S00000+168
         L     2,S00000+172
         LD    0,C00091
         LTDR  0,0
         BC    10,L00092
         LCR   2,2
L00092   DS    0H
         C     2,C00090
         BC    7,L00046
L00047   DS    0H
         LA    0,3
         X     0,C00093
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00094
         CD    0,C00095
         LA    3,1
         BC    8,L00096
         SR    3,3
L00096   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00097
         SR    2,2
L00097   DS    0H
         LTR   2,2
         BC    7,L00048
L00049   DS    0H
         LA    0,7
         X     0,C00093
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00094
         LER   0,0
         CE    0,C00098
         LA    3,1
         BC    8,L00099
         SR    3,3
L00099   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00100
         SR    2,2
L00100   DS    0H
         LTR   2,2
         BC    7,L00050
L00051   DS    0H
L00053   DS    0H
         LD    4,C00101
         LCDR  4,4
         LD    2,C00095
         LPDR  2,2
         LDR   0,2
         LCDR  0,0
         CD    4,C00102
         BC    4,L00054
L00055   DS    0H
         LDR   0,2
L00056   DS    0H
         LD    2,C00095
         LCDR  2,2
         CDR   0,2
         LA    3,1
         BC    8,L00103
         SR    3,3
L00103   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00104
         SR    2,2
L00104   DS    0H
         LTR   2,2
         BC    7,L00057
L00058   DS    0H
         LE    0,C00106
         STE   0,P00105+0
         LA    1,P00105
         L     15,C00107
         BALR  14,15
         CE    0,C00108
         LA    3,1
         BC    8,L00109
         SR    3,3
L00109   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00110
         SR    2,2
L00110   DS    0H
         LTR   2,2
         BC    7,L00059
L00060   DS    0H
         LD    0,C00112
         STD   0,P00111+0
         LA    1,P00111
         L     15,C00113
         BALR  14,15
         CD    0,C00095
         LA    3,1
         BC    8,L00114
         SR    3,3
L00114   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00115
         SR    2,2
L00115   DS    0H
         LTR   2,2
         BC    7,L00061
L00062   DS    0H
         LA    1,P00116
         L     15,C00117
         BALR  14,15
         B     L00064
L00002   DS    0H
L00004   DS    0H
L00006   DS    0H
         LA    1,P00118
         L     15,C00117
         BALR  14,15
         B     L00064
L00008   DS    0H
         LA    1,P00119
         L     15,C00117
         BALR  14,15
         B     L00064
L00010   DS    0H
         LA    1,P00120
         L     15,C00117
         BALR  14,15
         B     L00064
L00012   DS    0H
L00014   DS    0H
L00016   DS    0H
L00018   DS    0H
L00020   DS    0H
         LE    0,C00076
         B     L00022
L00023   DS    0H
         LA    1,P00121
         L     15,C00117
         BALR  14,15
         B     L00064
L00025   DS    0H
         LD    0,C00080
         B     L00027
L00028   DS    0H
         LA    1,P00122
         L     15,C00117
         BALR  14,15
         B     L00064
L00030   DS    0H
         LD    0,C00080
         B     L00032
L00033   DS    0H
         LA    1,P00123
         L     15,C00117
         BALR  14,15
         B     L00064
L00035   DS    0H
         B     L00037
L00038   DS    0H
         LA    1,P00124
         L     15,C00117
         BALR  14,15
         B     L00064
L00040   DS    0H
L00042   DS    0H
L00044   DS    0H
         LA    1,P00125
         L     15,C00117
         BALR  14,15
         B     L00064
L00046   DS    0H
         LA    1,P00126
         L     15,C00117
         BALR  14,15
         B     L00064
L00048   DS    0H
         LA    1,P00127
         L     15,C00117
         BALR  14,15
         B     L00064
L00050   DS    0H
         LA    1,P00128
         L     15,C00117
         BALR  14,15
         B     L00064
L00052   DS    0H
L00054   DS    0H
         B     L00056
L00057   DS    0H
         LA    1,P00129
         L     15,C00117
         BALR  14,15
         B     L00064
L00059   DS    0H
         LA    1,P00130
         L     15,C00117
         BALR  14,15
         B     L00064
L00061   DS    0H
         LA    1,P00131
         L     15,C00117
         BALR  14,15
         B     L00064
L00063   DS    0H
L00064   DS    0H
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
P00105   DC    A(0)
         DC    F'0'
P00111   DC    A(0)
         DC    A(0)
P00116   DC    F'0'
P00118   DC    F'123'
P00119   DC    F'124'
P00120   DC    F'125'
P00121   DC    F'130'
P00122   DC    F'131'
P00123   DC    F'132'
P00124   DC    F'133'
P00125   DC    F'136'
P00126   DC    F'137'
P00127   DC    F'138'
P00128   DC    F'139'
P00129   DC    F'141'
P00130   DC    F'142'
P00131   DC    F'143'
         DS    XL4
C00071   DC    X'4138000000000000'
C00079   DC    X'4128000000000000'
C00080   DC    X'4118000000000000'
C00088   DC    X'4E00000000000000'
C00091   DC    X'413E666666666666'
C00094   DC    X'4E00000080000000'
C00095   DC    X'4130000000000000'
C00101   DC    X'4110000000000000'
C00102   DC    X'0000000000000000'
C00112   DC    X'4190000000000000'
C00068   DC    X'41280000'
C00076   DC    X'41180000'
C00087   DC    X'413E6666'
C00090   DC    F'3'
C00093   DC    F'-2147483648'
C00098   DC    X'41700000'
C00106   DC    X'42100000'
C00107   DC    V(SQRT)
C00108   DC    X'41400000'
C00113   DC    V(DSQRT)
C00117   DC    V(EXIT)
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
