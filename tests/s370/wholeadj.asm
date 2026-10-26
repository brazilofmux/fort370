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
         LA    1,P00014
         L     15,C00015
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
P00014   DC    A(G00011)
         DC    A(T00005)
         DC    A(T00001)
         DC    A(G00012)
         DC    A(T00002)
         DC    A(T00003)
         DC    A(G00013)
         DC    A(T00004)
         DC    XL1'80',FL3'3'
         DS    XL4
C00015   DC    V(P)
* P
P        CSECT
         USING *,15
         B     L00070
         DC    AL1(1),CL7'P'
L00070   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00071
L00072   DC    A(S00016)
L00071   L     15,L00072
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00016,13
         ST    1,S00016+72
L00026   DS    0H
         L     9,0(,1)
         L     14,4(,1)
         ST    14,S00016+224
         L     14,8(,1)
         ST    14,S00016+232
         L     8,12(,1)
         L     14,16(,1)
         ST    14,S00016+240
         L     14,20(,1)
         ST    14,S00016+248
         L     14,24(,1)
         ST    14,S00016+256
         L     14,28(,1)
         ST    14,S00016+264
         L     14,S00016+224
         L     4,0(,14)
         S     4,C00073
         AH    4,C00074
         L     15,S00016+232
         L     14,0(,15)
         ST    14,S00016+224
         L     14,S00016+224
         S     14,C00073
         ST    14,S00016+232
         L     14,S00016+232
         AH    14,C00074
         ST    14,S00016+224
         L     15,S00016+240
         L     14,0(,15)
         ST    14,S00016+232
         L     14,S00016+248
         L     7,0(,14)
         S     7,S00016+232
         AH    7,C00074
         L     14,S00016+264
         L     6,0(,14)
         S     6,C00073
         AH    6,C00074
         L     5,S00016+72
         L     5,32(,5)
         LA    5,0(,5)
         LA    1,P00075
         L     15,C00076
         BALR  14,15
         LR    1,4
         M     0,S00016+224
         LR    4,1
         LA    2,0
         LA    3,0
L00027   DS    0H
         CR    3,4
         BC    4,L00028
L00029   DS    0H
         L     15,C00077
         BALR  14,15
         LA    1,P00078
         L     15,C00076
         BALR  14,15
         LA    2,0
         LA    3,0
L00030   DS    0H
         CR    3,7
         BC    4,L00031
L00032   DS    0H
         L     15,C00077
         BALR  14,15
         LA    1,P00079
         L     15,C00076
         BALR  14,15
         LA    1,0
         MR    0,5
         LR    2,1
         LA    1,1
         MR    0,5
         LR    10,1
         LA    3,0
L00033   DS    0H
         CR    3,6
         BC    4,L00034
L00035   DS    0H
         L     15,C00077
         BALR  14,15
         LA    1,P00080
         L     15,C00081
         BALR  14,15
         LA    1,P00082
         L     15,C00083
         BALR  14,15
         LA    2,0
         LA    3,0
L00036   DS    0H
         CR    3,7
         BC    4,L00037
L00038   DS    0H
         L     15,C00084
         BALR  14,15
         LA    1,P00078
         L     15,C00076
         BALR  14,15
         LA    2,0
         LA    3,0
L00039   DS    0H
         CR    3,7
         BC    4,L00040
L00041   DS    0H
         L     15,C00077
         BALR  14,15
         LA    1,P00085
         L     15,C00081
         BALR  14,15
         LA    1,P00086
         L     15,C00087
         BALR  14,15
         LA    1,P00088
         L     15,C00083
         BALR  14,15
         LA    2,0
         LA    3,0
L00042   DS    0H
         CR    3,4
         BC    4,L00043
L00044   DS    0H
         L     15,C00084
         BALR  14,15
         LA    1,P00075
         L     15,C00076
         BALR  14,15
         LA    2,0
         LA    3,0
L00045   DS    0H
         CR    3,4
         BC    4,L00046
L00047   DS    0H
         L     15,C00077
         BALR  14,15
         LA    1,P00089
         L     15,C00090
         BALR  14,15
         LA    1,P00091
         L     15,C00092
         BALR  14,15
         LA    2,0
         LA    3,0
L00048   DS    0H
         CR    3,4
         BC    4,L00049
L00050   DS    0H
         LA    2,0
         LA    3,0
L00051   DS    0H
         CR    3,7
         BC    4,L00052
L00053   DS    0H
         L     15,C00093
         BALR  14,15
         LA    1,P00091
         L     15,C00094
         BALR  14,15
         MVC   0(4,9),C00095
         L     14,S00016+240
         L     2,0(,14)
         S     2,S00016+232
         SLL   2,2
         LA    15,0
         ST    15,0(2,8)
         LA    1,P00096
         L     15,C00097
         BALR  14,15
         LA    2,0
         LA    3,0
L00054   DS    0H
         CR    3,4
         BC    4,L00055
L00056   DS    0H
         LA    2,0
         LA    3,0
L00057   DS    0H
         CR    3,7
         BC    4,L00058
L00059   DS    0H
         L     15,C00098
         BALR  14,15
         LA    1,P00075
         L     15,C00076
         BALR  14,15
         LA    2,0
         LA    3,0
L00060   DS    0H
         CR    3,4
         BC    4,L00061
L00062   DS    0H
         L     15,C00077
         BALR  14,15
         LA    1,P00078
         L     15,C00076
         BALR  14,15
         LA    2,0
         LA    3,0
L00063   DS    0H
         CR    3,7
         BC    4,L00064
L00065   DS    0H
         L     15,C00077
         BALR  14,15
L00066   DS    0H
L00067   DS    0H
L00068   DS    0H
         LA    0,0
         B     L00069
L00028   DS    0H
         LE    0,0(2,9)
         STE   0,S00016+224
         LE    0,S00016+224
         STE   0,P00099+0
         LA    1,P00099
         L     15,C00100
         BALR  14,15
         AH    3,C00074
         A     2,C00101
         B     L00027
L00031   DS    0H
         L     10,0(2,8)
         LR    0,10
         ST    0,P00102+0
         LA    1,P00102
         L     15,C00103
         BALR  14,15
         AH    3,C00074
         A     2,C00101
         B     L00030
L00034   DS    0H
         L     11,S00016+256
         AR    11,2
         LR    0,11
         ST    0,P00104+0
         LR    0,5
         ST    0,P00104+4
         LA    1,P00104
         L     15,C00105
         BALR  14,15
         AH    3,C00074
         AR    2,10
         B     L00033
L00037   DS    0H
         LR    5,8
         AR    5,2
         LR    0,5
         ST    0,P00102+0
         LA    1,P00102
         L     15,C00106
         BALR  14,15
         AH    3,C00074
         A     2,C00101
         B     L00036
L00040   DS    0H
         L     6,0(2,8)
         LR    0,6
         ST    0,P00102+0
         LA    1,P00102
         L     15,C00103
         BALR  14,15
         AH    3,C00074
         A     2,C00101
         B     L00039
L00043   DS    0H
         LR    5,9
         AR    5,2
         LR    0,5
         ST    0,P00102+0
         LA    1,P00102
         L     15,C00107
         BALR  14,15
         AH    3,C00074
         A     2,C00101
         B     L00042
L00046   DS    0H
         LE    0,0(2,9)
         STE   0,S00016+224
         LE    0,S00016+224
         STE   0,P00099+0
         LA    1,P00099
         L     15,C00100
         BALR  14,15
         AH    3,C00074
         A     2,C00101
         B     L00045
L00049   DS    0H
         LR    5,9
         AR    5,2
         LR    0,5
         ST    0,P00108+0
         LA    1,P00108
         L     15,C00109
         BALR  14,15
         AH    3,C00074
         A     2,C00101
         B     L00048
L00052   DS    0H
         LR    5,8
         AR    5,2
         LR    0,5
         ST    0,P00108+0
         LA    1,P00108
         L     15,C00109
         BALR  14,15
         AH    3,C00074
         A     2,C00101
         B     L00051
L00055   DS    0H
         LR    5,9
         AR    5,2
         LR    0,5
         ST    0,P00108+0
         LA    1,P00108
         L     15,C00110
         BALR  14,15
         AH    3,C00074
         A     2,C00101
         B     L00054
L00058   DS    0H
         LR    5,8
         AR    5,2
         LR    0,5
         ST    0,P00108+0
         LA    1,P00108
         L     15,C00110
         BALR  14,15
         AH    3,C00074
         A     2,C00101
         B     L00057
L00061   DS    0H
         LE    0,0(2,9)
         STE   0,S00016+224
         LE    0,S00016+224
         STE   0,P00099+0
         LA    1,P00099
         L     15,C00100
         BALR  14,15
         AH    3,C00074
         A     2,C00101
         B     L00060
L00064   DS    0H
         L     5,0(2,8)
         LR    0,5
         ST    0,P00102+0
         LA    1,P00102
         L     15,C00103
         BALR  14,15
         AH    3,C00074
         A     2,C00101
         B     L00063
L00069   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00016   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00025   DS    XL44
         DS    XL4
         DS    6D
P00075   DC    F'6'
         DC    A(Q00017)
P00078   DC    F'6'
         DC    A(Q00018)
P00079   DC    F'6'
         DC    A(Q00019)
P00080   DC    A(T00025)
         DC    F'40'
         DC    A(Q00020)
         DC    F'9'
P00082   DC    A(T00025)
         DC    F'40'
         DC    F'1'
         DC    F'0'
         DC    F'0'
P00085   DC    A(T00025)
         DC    F'40'
         DC    A(Q00021)
         DC    F'24'
P00086   DC    F'7'
P00088   DC    A(T00025)
         DC    F'40'
         DC    F'1'
         DC    A(Q00022)
         DC    F'0'
P00089   DC    F'1'
         DC    F'0'
         DC    F'0'
         DC    A(Q00024)
         DC    F'7'
         DC    F'0'
         DC    F'0'
         DC    A(Q00023)
         DC    F'11'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
P00091   DC    F'1'
P00096   DC    F'1'
         DC    F'0'
         DS    F
P00099   DC    A(0)
P00102   DC    A(0)
P00104   DC    A(0)
         DC    A(0)
P00108   DC    A(0)
         DC    F'4'
C00073   DC    F'1'
C00076   DC    V(F77WRBEG)
C00077   DC    V(F77WREND)
C00081   DC    V(F77STRCP)
C00083   DC    V(F77RDBI)
C00084   DC    V(F77RDEND)
C00087   DC    V(F77FMTLM)
C00090   DC    V(F77OPEN)
C00092   DC    V(F77WUBEG)
C00093   DC    V(F77WUEND)
C00094   DC    V(F77REWND)
C00095   DC    X'00000000'
C00097   DC    V(F77RUBEG)
C00098   DC    V(F77RUEND)
C00100   DC    V(F77WRR)
C00101   DC    F'4'
C00103   DC    V(F77WRI)
C00105   DC    V(F77WRA)
C00106   DC    V(F77RDI)
C00107   DC    V(F77RDR)
C00109   DC    V(F77WU)
C00110   DC    V(F77RU)
C00074   DC    H'1'
Q00017   DC    C'(1X,''>'',6F6.1)'
Q00018   DC    C'(1X,''>'',5I4)'
Q00019   DC    C'(1X,''>'',3(1X,A))'
Q00020   DC    C'9 8 7 6 5'
Q00021   DC    C' 0.5 1.5 2.5 3.5 4.5 5.5'
Q00022   DC    C'(6F4.1)'
Q00023   DC    C'UNFORMATTED'
Q00024   DC    C'SCRATCH'
G00011   CSECT
         DS    0D
         DC    X'411000004120000041300000414000004150000041600000'
G00012   CSECT
         DS    0D
         DC    X'0000000A0000000B0000000C0000000D0000000E'
G00013   CSECT
         DS    0D
         DC    X'C1C240C3C440C5C640'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
