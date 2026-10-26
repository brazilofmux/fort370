* main
F77MAIN  CSECT
         USING *,15
         B     L00044
         DC    AL1(7),CL7'F77MAIN'
L00044   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00045
L00046   DC    A(S00000)
L00045   L     15,L00046
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00017   DS    0H
         LA    4,1
L00018   DS    0H
         LA    5,4
         LR    2,4
L00019   DS    0H
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         C     2,T00015
         BC    7,L00021
L00022   DS    0H
L00023   DS    0H
         BXLE  2,4,L00019
L00020   DS    0H
         LA    15,7
         ST    15,T00016
         LA    15,1
         ST    15,T00002
         LA    1,P00049
         L     15,C00050
         BALR  14,15
         LA    15,9
         ST    15,T00003
         LA    15,0
         ST    15,T00004
         LA    1,P00051
         L     15,C00050
         BALR  14,15
         L     2,T00013
         C     2,C00052
         BC    7,L00024
L00025   DS    0H
         MVC   T00005(4),C00053
         LA    15,1
         ST    15,T00006
         LA    1,P00054
         L     15,C00055
         BALR  14,15
         MVC   T00007(4),C00056
         LA    15,0
         ST    15,T00008
         LA    1,P00057
         L     15,C00055
         BALR  14,15
         MVC   T00009(4),C00058
         LA    15,0
         ST    15,T00010
         LA    1,P00059
         L     15,C00055
         BALR  14,15
         STE   0,S00000+328
         LE    0,S00000+328
         CE    0,C00060
         LA    3,1
         BC    8,L00061
         SR    3,3
L00061   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00062
         SR    2,2
L00062   DS    0H
         LTR   2,2
         BC    7,L00026
L00027   DS    0H
         LA    15,1
         ST    15,T00011
         LA    1,P00063
         L     15,C00064
         BALR  14,15
         LA    15,0
         ST    15,T00012
         LA    1,P00065
         L     15,C00064
         BALR  14,15
         L     2,T00014
         C     2,C00066
         BC    7,L00028
L00029   DS    0H
L00031   DS    0H
L00033   DS    0H
L00030   DS    0H
L00035   DS    0H
L00038   DS    0H
L00039   DS    0H
L00036   DS    0H
L00041   DS    0H
         LA    1,P00067
         L     15,C00068
         BALR  14,15
         L     3,T00015
         LR    0,3
         ST    0,P00069+0
         LA    1,P00069
         L     15,C00070
         BALR  14,15
         L     3,T00013
         LR    0,3
         ST    0,P00069+0
         LA    1,P00069
         L     15,C00070
         BALR  14,15
         LE    0,S00000+328
         STE   0,P00071+0
         LA    1,P00071
         L     15,C00072
         BALR  14,15
         L     3,T00014
         LR    0,3
         ST    0,P00069+0
         LA    1,P00069
         L     15,C00070
         BALR  14,15
         LA    1,P00073
         L     15,C00070
         BALR  14,15
         L     15,C00074
         BALR  14,15
L00042   DS    0H
         B     L00043
L00021   DS    0H
         LA    1,P00075
         L     15,C00076
         BALR  14,15
         B     L00043
L00024   DS    0H
         LA    1,P00077
         L     15,C00076
         BALR  14,15
         B     L00043
L00026   DS    0H
         LA    1,P00078
         L     15,C00076
         BALR  14,15
         B     L00043
L00028   DS    0H
         LA    1,P00079
         L     15,C00076
         BALR  14,15
         B     L00043
L00032   DS    0H
L00034   DS    0H
L00037   DS    0H
L00040   DS    0H
L00043   DS    0H
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
T00002   DS    XL4
         DS    XL4
T00003   DS    XL4
         DS    XL4
T00004   DS    XL4
         DS    XL4
T00005   DS    XL4
         DS    XL4
T00006   DS    XL4
         DS    XL4
T00007   DS    XL4
         DS    XL4
T00008   DS    XL4
         DS    XL4
T00009   DS    XL4
         DS    XL4
T00010   DS    XL4
         DS    XL4
T00011   DS    XL4
         DS    XL4
T00012   DS    XL4
         DS    XL4
T00013   DS    XL8
T00014   DS    XL8
T00015   DS    XL16
T00016   DS    XL32
         DS    1D
P00047   DC    XL1'80',AL3(T00015)
P00049   DC    A(T00016)
         DC    A(T00002)
         DC    XL1'80',AL3(T00013)
P00051   DC    A(T00003)
         DC    A(T00004)
         DC    XL1'80',AL3(T00013)
P00054   DC    A(T00005)
         DC    XL1'80',AL3(T00006)
P00057   DC    A(T00007)
         DC    XL1'80',AL3(T00008)
P00059   DC    A(T00009)
         DC    XL1'80',AL3(T00010)
P00063   DC    A(T00011)
         DC    XL1'80',AL3(T00014)
P00065   DC    A(T00012)
         DC    XL1'80',AL3(T00014)
P00067   DC    F'6'
         DC    A(Q00001)
P00069   DC    A(0)
P00071   DC    A(0)
P00073   DC    F'22'
P00075   DC    F'1'
P00077   DC    F'2'
P00078   DC    F'3'
P00079   DC    F'4'
C00048   DC    V(NEXTID)
C00050   DC    V(LAST)
C00052   DC    F'7'
C00053   DC    X'00000000'
C00055   DC    V(TOTAL)
C00056   DC    X'41280000'
C00058   DC    X'41180000'
C00060   DC    X'41400000'
C00064   DC    V(PAIRS)
C00066   DC    F'5'
C00068   DC    V(F77WRBEG)
C00070   DC    V(F77WRI)
C00072   DC    V(F77WRR)
C00074   DC    V(F77WREND)
C00076   DC    V(EXIT)
Q00001   DC    C'(1X,''>'',2I4,F6.1,2I4)'
* NEXTID
NEXTID   CSECT
         USING *,15
         B     L00084
         DC    AL1(6),CL7'NEXTID'
L00084   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00085
L00086   DC    A(S00080)
L00085   L     15,L00086
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00080,13
         ST    1,S00080+72
L00082   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,T00081
         A     2,C00087
         ST    2,T00081
         ST    2,0(,3)
         LA    0,0
L00083   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00080   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00081   DS    XL8
C00087   DC    F'1'
* LAST
LAST     CSECT
         USING *,15
         B     L00094
         DC    AL1(4),CL7'LAST'
L00094   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00095
L00096   DC    A(S00088)
L00095   L     15,L00096
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00088,13
         ST    1,S00088+72
L00090   DS    0H
         L     5,0(,1)
         L     4,4(,1)
         L     3,8(,1)
         LA    3,0(,3)
         L     2,0(,4)
         C     2,C00097
         BC    7,L00092
L00091   DS    0H
         L     2,0(,5)
         ST    2,T00089
L00092   DS    0H
         L     2,T00089
         ST    2,0(,3)
         LA    0,0
L00093   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00088   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00089   DS    XL8
C00097   DC    F'1'
* TOTAL
TOTAL    CSECT
         USING *,15
         B     L00104
         DC    AL1(5),CL7'TOTAL'
L00104   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00105
L00106   DC    A(S00098)
L00105   L     15,L00106
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00098,13
         ST    1,S00098+72
L00100   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         L     2,0(,3)
         C     2,C00107
         BC    7,L00102
L00101   DS    0H
         MVC   T00099(4),C00108
L00102   DS    0H
         LE    0,T00099
         AE    0,0(,4)
         STE   0,T00099
L00103   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00098   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00099   DS    XL8
C00107   DC    F'1'
C00108   DC    X'00000000'
* PAIRS
PAIRS    CSECT
         USING *,15
         B     L00116
         DC    AL1(5),CL7'PAIRS'
L00116   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00117
L00118   DC    A(S00109)
L00117   L     15,L00118
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00109,13
         ST    1,S00109+72
L00111   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         L     2,0(,4)
         C     2,C00119
         BC    8,L00112
L00113   DS    0H
L00114   DS    0H
         L     2,T00110
         A     2,T00110+4
         ST    2,0(,3)
         LA    0,0
         B     L00115
L00112   DS    0H
         LA    15,2
         ST    15,T00110
         LA    15,3
         ST    15,T00110+4
         B     L00114
L00115   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00109   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00110   DS    XL12
         DS    XL4
C00119   DC    F'1'
* BOTH
BOTH     CSECT
         USING *,15
         B     L00126
         DC    AL1(4),CL7'BOTH'
L00126   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00127
L00128   DC    A(S00120)
L00127   L     15,L00128
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00120,13
         ST    1,S00120+72
L00121   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         L     2,0(,4)
         C     2,C00129
         BC    8,L00122
L00123   DS    0H
         LA    2,22
L00124   DS    0H
         ST    2,0(,3)
         LA    0,0
         B     L00125
L00122   DS    0H
         LA    2,11
         B     L00124
L00125   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00120   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00129   DC    F'1'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
