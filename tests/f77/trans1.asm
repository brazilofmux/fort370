* main
F77MAIN  CSECT
         USING *,15
         B     L00048
         DC    AL1(7),CL7'F77MAIN'
L00048   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00049
L00050   DC    A(S00000)
L00049   L     15,L00050
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00004   DS    0H
         LD    0,C00052
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00053
         BALR  14,15
         LD    2,C00054
         MDR   2,0
         STD   2,S00000+176
         LD    0,S00000+176
         SD    0,C00055
         LPDR  0,0
         LD    2,C00056
         CDR   2,0
         BC    4,L00005
L00006   DS    0H
         LD    0,C00052
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00057
         BALR  14,15
         STD   0,S00000+184
         LD    0,S00000+184
         SD    0,C00058
         LPDR  0,0
         LD    2,C00056
         CDR   2,0
         BC    4,L00007
L00008   DS    0H
         LD    0,S00000+184
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00059
         BALR  14,15
         SD    0,C00052
         LPDR  0,0
         LD    2,C00056
         CDR   2,0
         BC    4,L00009
L00010   DS    0H
         LD    0,C00060
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00061
         BALR  14,15
         SD    0,C00062
         LPDR  0,0
         LD    2,C00056
         CDR   2,0
         BC    4,L00011
L00012   DS    0H
         LD    0,C00063
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00057
         BALR  14,15
         STD   0,S00000+192
         LD    0,S00000+192
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00059
         BALR  14,15
         SD    0,C00063
         LPDR  0,0
         LD    2,C00056
         CDR   2,0
         BC    4,L00013
L00014   DS    0H
         LD    0,C00063
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00064
         BALR  14,15
         STD   0,S00000+192
         LD    0,C00063
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00065
         BALR  14,15
         STD   0,S00000+200
         LD    0,S00000+192
         MD    0,S00000+192
         LD    2,S00000+200
         MD    2,S00000+200
         ADR   0,2
         SD    0,C00052
         LPDR  0,0
         LD    2,C00056
         CDR   2,0
         BC    4,L00015
L00016   DS    0H
         LD    0,C00063
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00066
         BALR  14,15
         LD    2,S00000+192
         DD    2,S00000+200
         SDR   0,2
         LPDR  0,0
         LD    2,C00056
         CDR   2,0
         BC    4,L00017
L00018   DS    0H
         LD    0,S00000+192
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00067
         BALR  14,15
         SD    0,C00063
         LPDR  0,0
         LD    2,C00056
         CDR   2,0
         BC    4,L00019
L00020   DS    0H
         LD    0,S00000+200
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00068
         BALR  14,15
         SD    0,C00063
         LPDR  0,0
         LD    2,C00056
         CDR   2,0
         BC    4,L00021
L00022   DS    0H
         LD    0,C00063
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00069
         BALR  14,15
         STD   0,S00000+192
         LD    0,C00063
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00069
         BALR  14,15
         LD    2,S00000+192
         MDR   2,0
         STD   2,S00000+200
         LD    0,C00063
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00070
         BALR  14,15
         STD   0,S00000+192
         LD    0,C00063
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00070
         BALR  14,15
         LD    2,S00000+192
         MDR   2,0
         LD    0,S00000+200
         SDR   0,2
         SD    0,C00052
         LPDR  0,0
         LD    2,C00056
         CDR   2,0
         BC    4,L00023
L00024   DS    0H
         LD    0,C00063
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00071
         BALR  14,15
         STD   0,S00000+192
         LD    0,C00063
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00070
         BALR  14,15
         STD   0,S00000+200
         LD    0,C00063
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00069
         BALR  14,15
         LD    2,S00000+200
         DDR   2,0
         LD    0,S00000+192
         SDR   0,2
         LPDR  0,0
         LD    2,C00056
         CDR   2,0
         BC    4,L00025
L00026   DS    0H
         LE    0,C00072
         STE   0,P00051+0
         XC    P00051+4(4),P00051+4
         LE    0,C00073
         STE   0,P00051+8
         XC    P00051+12(4),P00051+12
         LA    1,P00051
         L     15,C00074
         BALR  14,15
         LE    2,C00075
         MER   2,0
         STE   2,S00000+192
         LE    0,S00000+192
         SE    0,C00076
         LPER  0,0
         LE    2,C00077
         CER   2,0
         BC    4,L00027
L00028   DS    0H
         LD    0,C00052
         LCDR  0,0
         STD   0,S00000+200
         LD    0,C00052
         LCDR  0,0
         STD   0,S00000+208
         LD    0,S00000+200
         STD   0,P00051+0
         LD    0,S00000+208
         STD   0,P00051+8
         LA    1,P00051
         L     15,C00074
         BALR  14,15
         LD    2,C00078
         MD    2,S00000+176
         ADR   0,2
         LPDR  0,0
         LD    2,C00056
         CDR   2,0
         BC    4,L00029
L00030   DS    0H
         LE    0,C00075
         STE   0,P00051+0
         XC    P00051+4(4),P00051+4
         LE    0,C00079
         STE   0,P00051+8
         XC    P00051+12(4),P00051+12
         LA    1,P00051
         L     15,C00080
         BALR  14,15
         STE   0,S00000+200
         LE    0,C00075
         STE   0,P00051+0
         XC    P00051+4(4),P00051+4
         LA    1,P00051
         L     15,C00081
         BALR  14,15
         LER   2,0
         LE    0,S00000+200
         SER   0,2
         LPER  0,0
         LE    2,C00077
         CER   2,0
         BC    4,L00031
L00032   DS    0H
         LD    0,C00052
         DD    0,C00082
         STD   0,S00000+208
         LD    0,C00083
         STD   0,P00051+0
         LD    0,S00000+208
         STD   0,P00051+8
         LA    1,P00051
         L     15,C00080
         BALR  14,15
         STD   0,S00000+216
         LD    0,S00000+216
         SD    0,C00062
         LPDR  0,0
         LD    2,C00056
         CDR   2,0
         BC    4,L00033
L00034   DS    0H
         LA    0,2
         X     0,C00084
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00085
         LER   0,0
         STE   0,S00000+208
         LE    0,S00000+208
         STE   0,P00051+0
         XC    P00051+4(4),P00051+4
         LE    0,C00079
         STE   0,P00051+8
         XC    P00051+12(4),P00051+12
         LA    1,P00051
         L     15,C00080
         BALR  14,15
         SE    0,S00000+200
         LPER  0,0
         LE    2,C00077
         CER   2,0
         BC    4,L00035
L00036   DS    0H
         LE    0,C00072
         STE   0,P00051+0
         XC    P00051+4(4),P00051+4
         LA    1,P00051
         L     15,C00057
         BALR  14,15
         SE    0,C00086
         LPER  0,0
         LE    2,C00077
         CER   2,0
         BC    4,L00037
L00038   DS    0H
         LE    0,C00086
         STE   0,P00051+0
         XC    P00051+4(4),P00051+4
         LA    1,P00051
         L     15,C00059
         BALR  14,15
         SE    0,C00072
         LPER  0,0
         LE    2,C00077
         CER   2,0
         BC    4,L00039
L00040   DS    0H
         LE    0,C00087
         STE   0,P00051+0
         XC    P00051+4(4),P00051+4
         LA    1,P00051
         L     15,C00061
         BALR  14,15
         SE    0,C00088
         LPER  0,0
         LE    2,C00077
         CER   2,0
         BC    4,L00041
L00042   DS    0H
         LA    0,6
         ST    0,P00051+0
         L     0,C00089
         ST    0,P00051+4
         LA    1,P00051
         L     15,C00090
         BALR  14,15
         LD    0,S00000+176
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00091
         BALR  14,15
         LD    0,S00000+184
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00091
         BALR  14,15
         LE    0,S00000+192
         STE   0,P00051+0
         LA    1,P00051
         L     15,C00092
         BALR  14,15
         L     15,C00093
         BALR  14,15
L00043   DS    0H
         LA    0,6
         ST    0,P00051+0
         L     0,C00094
         ST    0,P00051+4
         LA    1,P00051
         L     15,C00090
         BALR  14,15
         LD    0,S00000+176
         DD    0,C00095
         STD   0,S00000+184
         LD    0,S00000+184
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00064
         BALR  14,15
         STD   0,S00000+192
         LD    0,S00000+192
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00091
         BALR  14,15
         LD    0,S00000+176
         DD    0,C00082
         STD   0,S00000+184
         LD    0,S00000+184
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00065
         BALR  14,15
         STD   0,S00000+192
         LD    0,S00000+192
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00091
         BALR  14,15
         LD    0,S00000+176
         DD    0,C00054
         STD   0,S00000+184
         LD    0,S00000+184
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00066
         BALR  14,15
         STD   0,S00000+176
         LD    0,S00000+176
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00091
         BALR  14,15
         L     15,C00093
         BALR  14,15
L00044   DS    0H
         LA    0,6
         ST    0,P00051+0
         L     0,C00096
         ST    0,P00051+4
         LA    1,P00051
         L     15,C00090
         BALR  14,15
         LE    0,S00000+200
         STE   0,P00051+0
         LA    1,P00051
         L     15,C00092
         BALR  14,15
         LD    0,S00000+216
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00091
         BALR  14,15
         LD    0,C00052
         DD    0,C00082
         STD   0,S00000+176
         LD    0,C00097
         STD   0,P00051+0
         LD    0,S00000+176
         STD   0,P00051+8
         LA    1,P00051
         L     15,C00080
         BALR  14,15
         STD   0,S00000+184
         LD    0,S00000+184
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00091
         BALR  14,15
         L     15,C00093
         BALR  14,15
L00045   DS    0H
         LA    0,0
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00098
         BALR  14,15
         B     L00047
L00005   DS    0H
         LA    0,1
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00098
         BALR  14,15
         B     L00047
L00007   DS    0H
         LA    0,2
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00098
         BALR  14,15
         B     L00047
L00009   DS    0H
         LA    0,3
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00098
         BALR  14,15
         B     L00047
L00011   DS    0H
         LA    0,4
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00098
         BALR  14,15
         B     L00047
L00013   DS    0H
         LA    0,5
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00098
         BALR  14,15
         B     L00047
L00015   DS    0H
         LA    0,6
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00098
         BALR  14,15
         B     L00047
L00017   DS    0H
         LA    0,7
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00098
         BALR  14,15
         B     L00047
L00019   DS    0H
         LA    0,8
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00098
         BALR  14,15
         B     L00047
L00021   DS    0H
         LA    0,9
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00098
         BALR  14,15
         B     L00047
L00023   DS    0H
         LA    0,10
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00098
         BALR  14,15
         B     L00047
L00025   DS    0H
         LA    0,11
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00098
         BALR  14,15
         B     L00047
L00027   DS    0H
         LA    0,12
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00098
         BALR  14,15
         B     L00047
L00029   DS    0H
         LA    0,13
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00098
         BALR  14,15
         B     L00047
L00031   DS    0H
         LA    0,14
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00098
         BALR  14,15
         B     L00047
L00033   DS    0H
         LA    0,15
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00098
         BALR  14,15
         B     L00047
L00035   DS    0H
         LA    0,16
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00098
         BALR  14,15
         B     L00047
L00037   DS    0H
         LA    0,17
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00098
         BALR  14,15
         B     L00047
L00039   DS    0H
         LA    0,18
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00098
         BALR  14,15
         B     L00047
L00041   DS    0H
         LA    0,19
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00098
         BALR  14,15
         B     L00047
L00046   DS    0H
L00047   DS    0H
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
         DS    6D
P00051   DS    4F
C00052   DC    X'4110000000000000'
C00054   DC    X'4140000000000000'
C00055   DC    X'413243F6A8885A22'
C00056   DC    X'3944B82FA09B5A53'
C00058   DC    X'412B7E151628AEE8'
C00060   DC    X'4264000000000000'
C00062   DC    X'4120000000000000'
C00063   DC    X'40B3333333333333'
C00078   DC    X'40C0000000000000'
C00082   DC    X'4130000000000000'
C00083   DC    X'4180000000000000'
C00085   DC    X'4E00000080000000'
C00095   DC    X'4160000000000000'
C00097   DC    X'421B000000000000'
C00053   DC    V(ATAN)
C00057   DC    V(EXP)
C00059   DC    V(LOG)
C00061   DC    V(LOG10)
C00064   DC    V(SIN)
C00065   DC    V(COS)
C00066   DC    V(TAN)
C00067   DC    V(ASIN)
C00068   DC    V(ACOS)
C00069   DC    V(COSH)
C00070   DC    V(SINH)
C00071   DC    V(TANH)
C00072   DC    X'41100000'
C00073   DC    X'00000000'
C00074   DC    V(ATAN2)
C00075   DC    X'41200000'
C00076   DC    X'413243F7'
C00077   DC    X'3CA7C5AC'
C00079   DC    X'40800000'
C00080   DC    V(POW)
C00081   DC    V(SQRT)
C00084   DC    F'-2147483648'
C00086   DC    X'412B7E15'
C00087   DC    X'433E8000'
C00088   DC    X'41300000'
C00089   DC    A(Q00001)
C00090   DC    V(F77WRBEG)
C00091   DC    V(F77WRD)
C00092   DC    V(F77WRR)
C00093   DC    V(F77WREND)
C00094   DC    A(Q00002)
C00096   DC    A(Q00003)
C00098   DC    V(EXIT)
Q00001   DC    C'(F10.6,F10.6,F10.6)'
Q00002   DC    C'(3F10.6)'
Q00003   DC    C'(3F10.6)'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
