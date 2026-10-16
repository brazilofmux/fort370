* main
F77MAIN  CSECT
         USING *,15
         B     L00040
         DC    AL1(7),CL7'F77MAIN'
L00040   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00041
L00042   DC    A(S00000)
L00041   L     15,L00042
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00012   DS    0H
         LD    0,C00044
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         L     14,C00047
         STD   0,0(,14)
         L     14,C00047
         L     3,0(,14)
         C     3,C00048
         LA    2,1
         BC    7,L00049
         SR    2,2
L00049   DS    0H
         L     14,C00050
         L     4,0(,14)
         C     4,C00051
         LA    3,1
         BC    7,L00052
         SR    3,3
L00052   DS    0H
         OR    2,3
         LTR   2,2
         BC    7,L00013
L00014   DS    0H
         MVC   T00010(8),C00053
         LD    0,C00053
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00054
         BALR  14,15
         AD    0,C00055
         LPDR  0,0
         LD    2,C00056
         CDR   2,0
         BC    4,L00015
L00016   DS    0H
         LD    0,T00010
         STD   0,S00000+272
         LD    0,S00000+272
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00057
         BALR  14,15
         SD    0,C00058
         LPDR  0,0
         LD    2,C00056
         CDR   2,0
         BC    4,L00017
L00018   DS    0H
         MVC   T00010(8),C00059
         LD    0,C00059
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00057
         BALR  14,15
         SD    0,C00060
         LPDR  0,0
         LD    2,C00056
         CDR   2,0
         BC    4,L00019
L00020   DS    0H
         MVC   T00010(8),C00061
         LD    0,C00061
         STD   0,P00043+0
         LD    0,C00062
         STD   0,P00043+8
         LA    1,P00043
         L     15,C00063
         BALR  14,15
         LD    2,C00064
         DD    2,C00044
         SDR   0,2
         LPDR  0,0
         LD    2,C00056
         CDR   2,0
         BC    4,L00021
L00022   DS    0H
         LD    0,T00010
         STD   0,S00000+272
         LD    0,C00044
         STD   0,P00043+0
         LD    0,S00000+272
         STD   0,P00043+8
         LA    1,P00043
         L     15,C00065
         BALR  14,15
         CD    0,C00066
         BC    4,L00023
L00024   DS    0H
         LD    0,C00044
         LCDR  0,0
         STD   0,S00000+272
         LD    0,S00000+272
         STD   0,P00043+0
         LD    0,C00067
         STD   0,P00043+8
         LA    1,P00043
         L     15,C00065
         BALR  14,15
         AD    0,C00068
         LD    2,C00069
         CDR   2,0
         BC    4,L00025
L00026   DS    0H
         MVC   T00009(4),C00070
         LE    0,C00070
         STE   0,P00043+0
         XC    P00043+4(4),P00043+4
         LA    1,P00043
         L     15,C00071
         BALR  14,15
         SE    0,C00072
         LPER  0,0
         LE    2,C00073
         CER   2,0
         BC    4,L00027
L00028   DS    0H
         L     14,C00047
         MVC   0(8,14),C00074
         LD    0,C00074
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00075
         BALR  14,15
         LD    2,C00064
         DD    2,C00067
         SDR   0,2
         LPDR  0,0
         LD    2,C00056
         CDR   2,0
         BC    4,L00029
L00030   DS    0H
         LA    0,T00011
         ST    0,P00043+0
         LA    0,12
         ST    0,P00043+4
         L     0,C00076
         ST    0,P00043+8
         LA    0,3
         ST    0,P00043+12
         LA    1,P00043
         L     15,C00077
         BALR  14,15
         LA    0,T00011
         ST    0,P00043+0
         LA    0,12
         ST    0,P00043+4
         LA    0,1
         ST    0,P00043+8
         L     0,C00078
         ST    0,P00043+12
         LA    0,0
         ST    0,P00043+16
         LA    1,P00043
         L     15,C00079
         BALR  14,15
         LA    0,T00009
         ST    0,P00043+0
         LA    1,P00043
         L     15,C00080
         BALR  14,15
         L     15,C00081
         BALR  14,15
         LE    0,C00082
         CE    0,T00009
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
         BC    7,L00031
L00032   DS    0H
         LA    0,T00011
         ST    0,P00043+0
         LA    0,12
         ST    0,P00043+4
         L     0,C00085
         ST    0,P00043+8
         LA    0,6
         ST    0,P00043+12
         LA    1,P00043
         L     15,C00077
         BALR  14,15
         LA    0,T00011
         ST    0,P00043+0
         LA    0,12
         ST    0,P00043+4
         LA    0,1
         ST    0,P00043+8
         L     0,C00086
         ST    0,P00043+12
         LA    0,0
         ST    0,P00043+16
         LA    1,P00043
         L     15,C00079
         BALR  14,15
         LA    0,T00008
         ST    0,P00043+0
         LA    1,P00043
         L     15,C00080
         BALR  14,15
         L     15,C00081
         BALR  14,15
         LE    0,C00087
         CE    0,T00008
         LA    3,1
         BC    8,L00088
         SR    3,3
L00088   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00089
         SR    2,2
L00089   DS    0H
         LTR   2,2
         BC    7,L00033
L00034   DS    0H
         LA    0,T00011
         ST    0,P00043+0
         LA    0,12
         ST    0,P00043+4
         L     0,C00090
         ST    0,P00043+8
         LA    0,3
         ST    0,P00043+12
         LA    1,P00043
         L     15,C00077
         BALR  14,15
         LA    0,T00011
         ST    0,P00043+0
         LA    0,12
         ST    0,P00043+4
         LA    0,1
         ST    0,P00043+8
         L     0,C00091
         ST    0,P00043+12
         LA    0,0
         ST    0,P00043+16
         LA    1,P00043
         L     15,C00079
         BALR  14,15
         LA    0,T00010
         ST    0,P00043+0
         LA    1,P00043
         L     15,C00092
         BALR  14,15
         L     15,C00081
         BALR  14,15
         LD    0,C00093
         CD    0,T00010
         LA    3,1
         BC    8,L00094
         SR    3,3
L00094   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00095
         SR    2,2
L00095   DS    0H
         LTR   2,2
         BC    7,L00035
L00036   DS    0H
         LA    0,6
         ST    0,P00043+0
         L     0,C00096
         ST    0,P00043+4
         LA    1,P00043
         L     15,C00097
         BALR  14,15
         LA    0,12
         ST    0,P00043+0
         LA    1,P00043
         L     15,C00098
         BALR  14,15
         L     15,C00099
         BALR  14,15
L00037   DS    0H
         LA    0,0
         ST    0,P00043+0
         LA    1,P00043
         L     15,C00100
         BALR  14,15
         B     L00039
L00013   DS    0H
         LA    0,1
         ST    0,P00043+0
         LA    1,P00043
         L     15,C00100
         BALR  14,15
         B     L00039
L00015   DS    0H
         LA    0,2
         ST    0,P00043+0
         LA    1,P00043
         L     15,C00100
         BALR  14,15
         B     L00039
L00017   DS    0H
         LA    0,3
         ST    0,P00043+0
         LA    1,P00043
         L     15,C00100
         BALR  14,15
         B     L00039
L00019   DS    0H
         LA    0,4
         ST    0,P00043+0
         LA    1,P00043
         L     15,C00100
         BALR  14,15
         B     L00039
L00021   DS    0H
         LA    0,5
         ST    0,P00043+0
         LA    1,P00043
         L     15,C00100
         BALR  14,15
         B     L00039
L00023   DS    0H
         LA    0,6
         ST    0,P00043+0
         LA    1,P00043
         L     15,C00100
         BALR  14,15
         B     L00039
L00025   DS    0H
         LA    0,7
         ST    0,P00043+0
         LA    1,P00043
         L     15,C00100
         BALR  14,15
         B     L00039
L00027   DS    0H
         LA    0,8
         ST    0,P00043+0
         LA    1,P00043
         L     15,C00100
         BALR  14,15
         B     L00039
L00029   DS    0H
         LA    0,9
         ST    0,P00043+0
         LA    1,P00043
         L     15,C00100
         BALR  14,15
         B     L00039
L00031   DS    0H
         LA    0,10
         ST    0,P00043+0
         LA    1,P00043
         L     15,C00100
         BALR  14,15
         B     L00039
L00033   DS    0H
         LA    0,11
         ST    0,P00043+0
         LA    1,P00043
         L     15,C00100
         BALR  14,15
         B     L00039
L00035   DS    0H
         LA    0,12
         ST    0,P00043+0
         LA    1,P00043
         L     15,C00100
         BALR  14,15
         B     L00039
L00038   DS    0H
L00039   DS    0H
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
T00008   DS    XL8
T00009   DS    XL20
         DS    XL4
T00010   DS    XL24
T00011   DS    XL36
         DS    XL4
         DS    1D
P00043   DS    5F
         DS    XL4
C00044   DC    X'4120000000000000'
C00053   DC    X'5156BC75E2D63100'
C00055   DC    X'40A52F302FEB2280'
C00056   DC    X'34480EBE7B9D5856'
C00058   DC    X'40C393907E3069EB'
C00059   DC    X'462DC6C000000000'
C00060   DC    X'407A4E8540E894B5'
C00061   DC    X'7B172EBAD6DDC73D'
C00062   DC    X'386DF37F675EF6EB'
C00064   DC    X'413243F6A8885A31'
C00066   DC    X'7F235FADD81C2823'
C00067   DC    X'4130000000000000'
C00068   DC    X'4180000000000000'
C00069   DC    X'352D09370D425736'
C00074   DC    X'4080000000000000'
C00093   DC    X'401999999999999A'
C00045   DC    V(SQRT)
C00047   DC    A(G00046)
C00048   DC    F'1092001950'
C00050   DC    A(G00046+4)
C00051   DC    F'1719614413'
C00054   DC    V(SIN)
C00057   DC    V(COS)
C00063   DC    V(ATAN2)
C00065   DC    V(POW)
C00070   DC    X'40800000'
C00071   DC    V(ASIN)
C00072   DC    X'40860A92'
C00073   DC    X'3C10C6F8'
C00075   DC    V(ACOS)
C00076   DC    A(Q00001)
C00077   DC    V(F77STRCP)
C00078   DC    A(Q00002)
C00079   DC    V(F77RDBI)
C00080   DC    V(F77RDR)
C00081   DC    V(F77RDEND)
C00082   DC    X'4019999A'
C00085   DC    A(Q00003)
C00086   DC    A(Q00004)
C00087   DC    X'40B5C28F'
C00090   DC    A(Q00005)
C00091   DC    A(Q00006)
C00092   DC    V(F77RDD)
C00096   DC    A(Q00007)
C00097   DC    V(F77WRBEG)
C00098   DC    V(F77WRI)
C00099   DC    V(F77WREND)
C00100   DC    V(EXIT)
Q00007   DC    C'(1X,''>FPROUND'',I4)'
Q00001   DC    C'0.1'
Q00002   DC    C'(E12.0)'
Q00003   DC    C'7.1E-1'
Q00004   DC    C'(E12.0)'
Q00005   DC    C'0.1'
Q00006   DC    C'(D12.0)'
G00046   CSECT
         DS    0D
         DS    XL8
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
