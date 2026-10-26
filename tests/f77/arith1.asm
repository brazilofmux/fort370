* main
F77MAIN  CSECT
         USING *,15
         B     L00045
         DC    AL1(7),CL7'F77MAIN'
L00045   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00046
L00047   DC    A(S00000)
L00046   L     15,L00047
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00003   DS    0H
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LR    2,15
         C     2,C00050
         BC    7,L00004
L00005   DS    0H
         LA    1,P00051
         L     15,C00049
         BALR  14,15
         LR    2,15
         C     2,C00052
         BC    7,L00006
L00007   DS    0H
         LA    1,P00053
         L     15,C00049
         BALR  14,15
         LR    2,15
         C     2,C00054
         BC    7,L00008
L00009   DS    0H
         LA    1,P00055
         L     15,C00049
         BALR  14,15
         LR    2,15
         C     2,C00052
         BC    7,L00010
L00011   DS    0H
         LA    1,P00056
         L     15,C00049
         BALR  14,15
         LR    2,15
         C     2,C00057
         BC    7,L00012
L00013   DS    0H
         LA    1,P00058
         L     15,C00049
         BALR  14,15
         LR    2,15
         C     2,C00059
         BC    7,L00014
L00015   DS    0H
         LA    1,P00060
         L     15,C00049
         BALR  14,15
         LR    3,15
         LCR   2,3
         C     2,C00061
         BC    7,L00016
L00017   DS    0H
         LA    1,P00062
         L     15,C00049
         BALR  14,15
         LR    3,15
         LR    0,3
         ST    0,P00063+4
         LA    1,P00063
         L     15,C00049
         BALR  14,15
         LR    2,15
         C     2,C00064
         BC    7,L00018
L00019   DS    0H
         LA    1,P00065
         L     15,C00049
         BALR  14,15
         LR    2,15
         C     2,C00066
         BC    7,L00020
L00021   DS    0H
         LE    0,C00068
         STE   0,P00067+0
         LA    1,P00067
         L     15,C00069
         BALR  14,15
         STE   0,S00000+176
         LE    0,C00071
         STE   0,P00070+0
         LA    1,P00070
         L     15,C00069
         BALR  14,15
         AE    0,S00000+176
         SE    0,C00072
         LPER  0,0
         LE    2,C00073
         CER   2,0
         BC    4,L00022
L00023   DS    0H
         LD    0,C00075
         STD   0,P00074+0
         LA    1,P00074
         L     15,C00076
         BALR  14,15
         STD   0,S00000+176
         LD    0,C00078
         STD   0,P00077+0
         LA    1,P00077
         L     15,C00076
         BALR  14,15
         LD    2,S00000+176
         ADR   2,0
         STD   2,S00000+184
         LD    0,S00000+184
         SD    0,C00079
         LPDR  0,0
         LD    2,C00080
         CDR   2,0
         BC    4,L00024
L00025   DS    0H
         LD    0,S00000+184
         STD   0,P00077+0
         LA    1,P00077
         L     15,C00076
         BALR  14,15
         LD    2,C00081
         DD    2,C00082
         SDR   0,2
         LPDR  0,0
         LD    2,C00083
         CDR   2,0
         BC    4,L00026
L00027   DS    0H
         LA    2,0
         LH    3,C00084
L00028   DS    0H
         C     3,C00054
         LA    4,1
         BC    8,L00085
         SR    4,4
L00085   DS    0H
         C     3,C00054
         BC    4,L00030
L00029   DS    0H
         LTR   4,4
         BC    7,L00031
L00032   DS    0H
         LR    1,2
         M     0,C00086
         LR    2,1
         A     2,C00087
         C     2,C00088
         BC    7,L00033
L00034   DS    0H
         LD    0,S00000+184
         SD    0,C00079
         CD    0,C00089
         LA    3,1
         BC    8,L00090
         SR    3,3
L00090   DS    0H
         CD    0,C00089
         BC    4,L00036
L00035   DS    0H
         LTR   3,3
         BC    7,L00037
L00036   DS    0H
         LA    1,P00091
         L     15,C00092
         BALR  14,15
         B     L00044
L00004   DS    0H
         LA    1,P00093
         L     15,C00092
         BALR  14,15
         B     L00044
L00006   DS    0H
         LA    1,P00094
         L     15,C00092
         BALR  14,15
         B     L00044
L00008   DS    0H
         LA    1,P00095
         L     15,C00092
         BALR  14,15
         B     L00044
L00010   DS    0H
         LA    1,P00096
         L     15,C00092
         BALR  14,15
         B     L00044
L00012   DS    0H
         LA    1,P00097
         L     15,C00092
         BALR  14,15
         B     L00044
L00014   DS    0H
         LA    1,P00098
         L     15,C00092
         BALR  14,15
         B     L00044
L00016   DS    0H
         LA    1,P00099
         L     15,C00092
         BALR  14,15
         B     L00044
L00018   DS    0H
         LA    1,P00100
         L     15,C00092
         BALR  14,15
         B     L00044
L00020   DS    0H
         LA    1,P00101
         L     15,C00092
         BALR  14,15
         B     L00044
L00022   DS    0H
         LA    1,P00102
         L     15,C00092
         BALR  14,15
         B     L00044
L00024   DS    0H
         LA    1,P00103
         L     15,C00092
         BALR  14,15
         B     L00044
L00026   DS    0H
         LA    1,P00104
         L     15,C00092
         BALR  14,15
         B     L00044
L00030   DS    0H
         LR    1,2
         M     0,C00086
         LR    2,1
         A     2,C00052
         A     3,C00087
         B     L00028
L00031   DS    0H
         LR    1,2
         M     0,C00086
         LR    2,1
         A     2,C00105
         A     3,C00087
         B     L00028
L00033   DS    0H
         LA    1,P00106
         L     15,C00092
         BALR  14,15
         B     L00044
L00037   DS    0H
         LE    0,C00107
         LCER  0,0
         STE   0,S00000+176
         LE    0,S00000+176
         CE    0,C00108
         BC    4,L00039
L00038   DS    0H
L00040   DS    0H
         LA    1,P00109
         L     15,C00092
         BALR  14,15
         B     L00044
L00039   DS    0H
         LA    1,P00110
         L     15,C00111
         BALR  14,15
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LR    4,15
         LR    0,4
         ST    0,P00112+0
         LA    1,P00112
         L     15,C00113
         BALR  14,15
         LA    1,P00060
         L     15,C00049
         BALR  14,15
         LR    3,15
         LCR   4,3
         LR    0,4
         ST    0,P00112+0
         LA    1,P00112
         L     15,C00113
         BALR  14,15
         LA    1,P00062
         L     15,C00049
         BALR  14,15
         LR    3,15
         LR    0,3
         ST    0,P00063+4
         LA    1,P00063
         L     15,C00049
         BALR  14,15
         LR    4,15
         LR    0,4
         ST    0,P00112+0
         LA    1,P00112
         L     15,C00113
         BALR  14,15
         LR    0,2
         ST    0,P00112+0
         LA    1,P00112
         L     15,C00113
         BALR  14,15
         L     15,C00114
         BALR  14,15
L00041   DS    0H
         LA    1,P00115
         L     15,C00111
         BALR  14,15
         LE    0,S00000+176
         STE   0,P00116+0
         LA    1,P00116
         L     15,C00117
         BALR  14,15
         LD    0,S00000+184
         STD   0,P00118+0
         LA    1,P00118
         L     15,C00119
         BALR  14,15
         L     15,C00114
         BALR  14,15
L00042   DS    0H
         LA    1,P00120
         L     15,C00092
         BALR  14,15
         B     L00044
L00043   DS    0H
L00044   DS    0H
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
         DS    2D
P00048   DC    F'2'
         DC    F'10'
P00051   DC    F'3'
         DC    F'0'
P00053   DC    F'2'
         DC    F'-1'
P00055   DC    F'1'
         DC    F'-5'
P00056   DC    F'-1'
         DC    F'-3'
P00058   DC    F'-2'
         DC    F'3'
P00060   DC    F'2'
         DC    F'2'
P00062   DC    F'3'
         DC    F'2'
P00063   DC    F'2'
         DC    A(0)
P00065   DC    F'2'
         DC    F'5'
P00067   DC    A(0)
         DC    F'2'
P00070   DC    A(0)
         DC    F'-2'
P00074   DC    A(0)
         DC    A(0)
         DC    F'3'
         DS    F
P00077   DC    A(0)
         DC    A(0)
         DC    F'-3'
P00091   DC    F'14'
P00093   DC    F'1'
P00094   DC    F'2'
P00095   DC    F'3'
P00096   DC    F'4'
P00097   DC    F'5'
P00098   DC    F'6'
P00099   DC    F'7'
P00100   DC    F'8'
P00101   DC    F'9'
P00102   DC    F'10'
P00103   DC    F'11'
P00104   DC    F'12'
P00106   DC    F'13'
P00109   DC    F'15'
P00110   DC    F'6'
         DC    A(Q00001)
P00112   DC    A(0)
P00115   DC    F'6'
         DC    A(Q00002)
         DS    F
P00116   DC    A(0)
         DS    F
P00118   DC    A(0)
         DC    A(0)
P00120   DC    F'0'
         DS    XL4
C00075   DC    X'4118000000000000'
C00078   DC    X'4120000000000000'
C00079   DC    X'4138000000000000'
C00080   DC    X'37119799812DEA11'
C00081   DC    X'4110000000000000'
C00082   DC    X'422AE00000000000'
C00083   DC    X'34480EBE7B9D5856'
C00089   DC    X'0000000000000000'
C00049   DC    V(F77IPOW)
C00050   DC    F'1024'
C00052   DC    F'1'
C00054   DC    F'0'
C00057   DC    F'-1'
C00059   DC    F'-8'
C00061   DC    F'-4'
C00064   DC    F'512'
C00066   DC    F'32'
C00068   DC    X'41180000'
C00069   DC    V(F77RPOWI)
C00071   DC    X'41200000'
C00072   DC    X'41280000'
C00073   DC    X'3C10C6F8'
C00076   DC    V(F77DPOWI)
C00086   DC    F'10'
C00087   DC    F'3'
C00088   DC    F'123'
C00092   DC    V(EXIT)
C00105   DC    F'2'
C00107   DC    X'40400000'
C00108   DC    X'00000000'
C00111   DC    V(F77WRBEG)
C00113   DC    V(F77WRI)
C00114   DC    V(F77WREND)
C00117   DC    V(F77WRR)
C00119   DC    V(F77WRD)
C00084   DC    H'-3'
Q00001   DC    C'(''OK'',4I7)'
Q00002   DC    C'(F8.3,F10.4)'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
