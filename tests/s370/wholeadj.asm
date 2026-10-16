* main
F77MAIN  CSECT
         USING *,15
         B     L00008
         DC    AL1(7),CL7'F77MAIN'
L00008   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00009
L00010   DC    A(S00000)
L00009   L     15,L00010
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00006   DS    0H
         LA    15,2
         ST    15,T00005
         LA    15,3
         ST    15,T00001
         LA    15,0
         ST    15,T00002
         LA    15,4
         ST    15,T00003
         LA    15,3
         ST    15,T00004
         L     0,C00013
         ST    0,P00011+0
         LA    0,T00005
         ST    0,P00011+4
         LA    0,T00001
         ST    0,P00011+8
         L     0,C00015
         ST    0,P00011+12
         LA    0,T00002
         ST    0,P00011+16
         LA    0,T00003
         ST    0,P00011+20
         L     0,C00017
         ST    0,P00011+24
         LA    0,T00004
         ST    0,P00011+28
         LA    0,3
         ST    0,P00011+32
         OI    P00011+32,X'80'
         LA    1,P00011
         L     15,C00018
         BALR  14,15
L00007   DS    0H
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
T00001   DS    XL4
         DS    XL4
T00002   DS    XL4
         DS    XL4
T00003   DS    XL4
         DS    XL4
T00004   DS    XL4
         DS    XL4
T00005   DS    XL72
P00011   DS    9F
         DS    XL4
C00013   DC    A(G00012)
C00015   DC    A(G00014)
C00017   DC    A(G00016)
C00018   DC    V(P)
* P
P        CSECT
         USING *,15
         B     L00073
         DC    AL1(1),CL7'P'
L00073   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00074
L00075   DC    A(S00019)
L00074   L     15,L00075
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00019,13
         ST    1,S00019+72
L00029   DS    0H
         L     9,0(,1)
         L     14,4(,1)
         ST    14,S00019+224
         L     14,8(,1)
         ST    14,S00019+232
         L     8,12(,1)
         L     14,16(,1)
         ST    14,S00019+240
         L     14,20(,1)
         ST    14,S00019+248
         L     14,24(,1)
         ST    14,S00019+256
         L     14,28(,1)
         ST    14,S00019+264
         L     14,S00019+224
         L     4,0(,14)
         S     4,C00076
         AH    4,C00077
         L     15,S00019+232
         L     14,0(,15)
         ST    14,S00019+224
         L     14,S00019+224
         S     14,C00076
         ST    14,S00019+232
         L     14,S00019+232
         AH    14,C00077
         ST    14,S00019+224
         L     15,S00019+240
         L     14,0(,15)
         ST    14,S00019+232
         L     14,S00019+248
         L     7,0(,14)
         S     7,S00019+232
         AH    7,C00077
         L     14,S00019+264
         L     6,0(,14)
         S     6,C00076
         AH    6,C00077
         L     5,S00019+72
         L     5,32(,5)
         LA    5,0(,5)
         LA    0,6
         ST    0,P00078+0
         L     0,C00079
         ST    0,P00078+4
         LA    1,P00078
         L     15,C00080
         BALR  14,15
         LR    1,4
         M     0,S00019+224
         LR    4,1
         LA    2,0
         LA    3,0
L00030   DS    0H
         CR    3,4
         BC    4,L00031
L00032   DS    0H
         L     15,C00081
         BALR  14,15
         LA    0,6
         ST    0,P00078+0
         L     0,C00082
         ST    0,P00078+4
         LA    1,P00078
         L     15,C00080
         BALR  14,15
         LA    2,0
         LA    3,0
L00033   DS    0H
         CR    3,7
         BC    4,L00034
L00035   DS    0H
         L     15,C00081
         BALR  14,15
         LA    0,6
         ST    0,P00078+0
         L     0,C00083
         ST    0,P00078+4
         LA    1,P00078
         L     15,C00080
         BALR  14,15
         LA    1,0
         MR    0,5
         LR    2,1
         LA    1,1
         MR    0,5
         LR    10,1
         LA    3,0
L00036   DS    0H
         CR    3,6
         BC    4,L00037
L00038   DS    0H
         L     15,C00081
         BALR  14,15
         LA    0,T00028
         ST    0,P00078+0
         LA    0,40
         ST    0,P00078+4
         L     0,C00084
         ST    0,P00078+8
         LA    0,9
         ST    0,P00078+12
         LA    1,P00078
         L     15,C00085
         BALR  14,15
         LA    0,T00028
         ST    0,P00078+0
         LA    0,40
         ST    0,P00078+4
         LA    0,1
         ST    0,P00078+8
         LA    0,0
         ST    0,P00078+12
         LA    0,0
         ST    0,P00078+16
         LA    1,P00078
         L     15,C00086
         BALR  14,15
         LA    2,0
         LA    3,0
L00039   DS    0H
         CR    3,7
         BC    4,L00040
L00041   DS    0H
         L     15,C00087
         BALR  14,15
         LA    0,6
         ST    0,P00078+0
         L     0,C00082
         ST    0,P00078+4
         LA    1,P00078
         L     15,C00080
         BALR  14,15
         LA    2,0
         LA    3,0
L00042   DS    0H
         CR    3,7
         BC    4,L00043
L00044   DS    0H
         L     15,C00081
         BALR  14,15
         LA    0,T00028
         ST    0,P00078+0
         LA    0,40
         ST    0,P00078+4
         L     0,C00088
         ST    0,P00078+8
         LA    0,24
         ST    0,P00078+12
         LA    1,P00078
         L     15,C00085
         BALR  14,15
         LA    0,T00028
         ST    0,P00078+0
         LA    0,40
         ST    0,P00078+4
         LA    0,1
         ST    0,P00078+8
         L     0,C00089
         ST    0,P00078+12
         LA    0,0
         ST    0,P00078+16
         LA    1,P00078
         L     15,C00086
         BALR  14,15
         LA    2,0
         LA    3,0
L00045   DS    0H
         CR    3,4
         BC    4,L00046
L00047   DS    0H
         L     15,C00087
         BALR  14,15
         LA    0,6
         ST    0,P00078+0
         L     0,C00079
         ST    0,P00078+4
         LA    1,P00078
         L     15,C00080
         BALR  14,15
         LA    2,0
         LA    3,0
L00048   DS    0H
         CR    3,4
         BC    4,L00049
L00050   DS    0H
         L     15,C00081
         BALR  14,15
         LA    0,1
         ST    0,P00078+0
         LA    0,0
         ST    0,P00078+4
         LA    0,0
         ST    0,P00078+8
         L     0,C00090
         ST    0,P00078+12
         LA    0,7
         ST    0,P00078+16
         LA    0,0
         ST    0,P00078+20
         LA    0,0
         ST    0,P00078+24
         L     0,C00091
         ST    0,P00078+28
         LA    0,11
         ST    0,P00078+32
         LA    0,0
         ST    0,P00078+36
         LA    0,0
         ST    0,P00078+40
         LA    0,0
         ST    0,P00078+44
         LA    0,0
         ST    0,P00078+48
         LA    1,P00078
         L     15,C00092
         BALR  14,15
         LA    0,1
         ST    0,P00078+0
         LA    1,P00078
         L     15,C00093
         BALR  14,15
         LA    2,0
         LA    3,0
L00051   DS    0H
         CR    3,4
         BC    4,L00052
L00053   DS    0H
         LA    2,0
         LA    3,0
L00054   DS    0H
         CR    3,7
         BC    4,L00055
L00056   DS    0H
         L     15,C00094
         BALR  14,15
         LA    0,1
         ST    0,P00078+0
         LA    1,P00078
         L     15,C00095
         BALR  14,15
         MVC   0(4,9),C00096
         L     14,S00019+240
         L     2,0(,14)
         S     2,S00019+232
         SLL   2,2
         LA    15,0
         ST    15,0(2,8)
         LA    0,1
         ST    0,P00078+0
         LA    0,0
         ST    0,P00078+4
         LA    1,P00078
         L     15,C00097
         BALR  14,15
         LA    2,0
         LA    3,0
L00057   DS    0H
         CR    3,4
         BC    4,L00058
L00059   DS    0H
         LA    2,0
         LA    3,0
L00060   DS    0H
         CR    3,7
         BC    4,L00061
L00062   DS    0H
         L     15,C00098
         BALR  14,15
         LA    0,6
         ST    0,P00078+0
         L     0,C00079
         ST    0,P00078+4
         LA    1,P00078
         L     15,C00080
         BALR  14,15
         LA    2,0
         LA    3,0
L00063   DS    0H
         CR    3,4
         BC    4,L00064
L00065   DS    0H
         L     15,C00081
         BALR  14,15
         LA    0,6
         ST    0,P00078+0
         L     0,C00082
         ST    0,P00078+4
         LA    1,P00078
         L     15,C00080
         BALR  14,15
         LA    2,0
         LA    3,0
L00066   DS    0H
         CR    3,7
         BC    4,L00067
L00068   DS    0H
         L     15,C00081
         BALR  14,15
L00069   DS    0H
L00070   DS    0H
L00071   DS    0H
         LA    0,0
         B     L00072
L00031   DS    0H
         LE    0,0(2,9)
         STE   0,S00019+224
         LE    0,S00019+224
         STE   0,P00078+0
         LA    1,P00078
         L     15,C00099
         BALR  14,15
         AH    3,C00077
         A     2,C00100
         B     L00030
L00034   DS    0H
         L     10,0(2,8)
         LR    0,10
         ST    0,P00078+0
         LA    1,P00078
         L     15,C00101
         BALR  14,15
         AH    3,C00077
         A     2,C00100
         B     L00033
L00037   DS    0H
         L     11,S00019+256
         AR    11,2
         LR    0,11
         ST    0,P00078+0
         LR    0,5
         ST    0,P00078+4
         LA    1,P00078
         L     15,C00102
         BALR  14,15
         AH    3,C00077
         AR    2,10
         B     L00036
L00040   DS    0H
         LR    5,8
         AR    5,2
         LR    0,5
         ST    0,P00078+0
         LA    1,P00078
         L     15,C00103
         BALR  14,15
         AH    3,C00077
         A     2,C00100
         B     L00039
L00043   DS    0H
         L     6,0(2,8)
         LR    0,6
         ST    0,P00078+0
         LA    1,P00078
         L     15,C00101
         BALR  14,15
         AH    3,C00077
         A     2,C00100
         B     L00042
L00046   DS    0H
         LR    5,9
         AR    5,2
         LR    0,5
         ST    0,P00078+0
         LA    1,P00078
         L     15,C00104
         BALR  14,15
         AH    3,C00077
         A     2,C00100
         B     L00045
L00049   DS    0H
         LE    0,0(2,9)
         STE   0,S00019+224
         LE    0,S00019+224
         STE   0,P00078+0
         LA    1,P00078
         L     15,C00099
         BALR  14,15
         AH    3,C00077
         A     2,C00100
         B     L00048
L00052   DS    0H
         LR    5,9
         AR    5,2
         LR    0,5
         ST    0,P00078+0
         LA    0,4
         ST    0,P00078+4
         LA    1,P00078
         L     15,C00105
         BALR  14,15
         AH    3,C00077
         A     2,C00100
         B     L00051
L00055   DS    0H
         LR    5,8
         AR    5,2
         LR    0,5
         ST    0,P00078+0
         LA    0,4
         ST    0,P00078+4
         LA    1,P00078
         L     15,C00105
         BALR  14,15
         AH    3,C00077
         A     2,C00100
         B     L00054
L00058   DS    0H
         LR    5,9
         AR    5,2
         LR    0,5
         ST    0,P00078+0
         LA    0,4
         ST    0,P00078+4
         LA    1,P00078
         L     15,C00106
         BALR  14,15
         AH    3,C00077
         A     2,C00100
         B     L00057
L00061   DS    0H
         LR    5,8
         AR    5,2
         LR    0,5
         ST    0,P00078+0
         LA    0,4
         ST    0,P00078+4
         LA    1,P00078
         L     15,C00106
         BALR  14,15
         AH    3,C00077
         A     2,C00100
         B     L00060
L00064   DS    0H
         LE    0,0(2,9)
         STE   0,S00019+224
         LE    0,S00019+224
         STE   0,P00078+0
         LA    1,P00078
         L     15,C00099
         BALR  14,15
         AH    3,C00077
         A     2,C00100
         B     L00063
L00067   DS    0H
         L     5,0(2,8)
         LR    0,5
         ST    0,P00078+0
         LA    1,P00078
         L     15,C00101
         BALR  14,15
         AH    3,C00077
         A     2,C00100
         B     L00066
L00072   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00019   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00028   DS    XL44
         DS    XL4
         DS    6D
P00078   DS    13F
         DS    XL4
C00076   DC    F'1'
C00079   DC    A(Q00020)
C00080   DC    V(F77WRBEG)
C00081   DC    V(F77WREND)
C00082   DC    A(Q00021)
C00083   DC    A(Q00022)
C00084   DC    A(Q00023)
C00085   DC    V(F77STRCP)
C00086   DC    V(F77RDBI)
C00087   DC    V(F77RDEND)
C00088   DC    A(Q00024)
C00089   DC    A(Q00025)
C00090   DC    A(Q00027)
C00091   DC    A(Q00026)
C00092   DC    V(F77OPEN)
C00093   DC    V(F77WUBEG)
C00094   DC    V(F77WUEND)
C00095   DC    V(F77REWND)
C00096   DC    X'00000000'
C00097   DC    V(F77RUBEG)
C00098   DC    V(F77RUEND)
C00099   DC    V(F77WRR)
C00100   DC    F'4'
C00101   DC    V(F77WRI)
C00102   DC    V(F77WRA)
C00103   DC    V(F77RDI)
C00104   DC    V(F77RDR)
C00105   DC    V(F77WU)
C00106   DC    V(F77RU)
C00077   DC    H'1'
Q00020   DC    C'(1X,''>'',6F6.1)'
Q00021   DC    C'(1X,''>'',5I4)'
Q00022   DC    C'(1X,''>'',3(1X,A))'
Q00023   DC    C'9 8 7 6 5'
Q00024   DC    C' 0.5 1.5 2.5 3.5 4.5 5.5'
Q00025   DC    C'(6F4.1)'
Q00026   DC    C'UNFORMATTED'
Q00027   DC    C'SCRATCH'
G00012   CSECT
         DS    0D
         DC    X'411000004120000041300000414000004150000041600000'
G00014   CSECT
         DS    0D
         DC    X'0000000A0000000B0000000C0000000D0000000E'
G00016   CSECT
         DS    0D
         DC    X'C1C240C3C440C5C640'
         END
