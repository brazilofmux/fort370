* main
F77MAIN  CSECT
         USING *,15
         B     L00020
         DC    AL1(7),CL7'F77MAIN'
L00020   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00021
L00022   DC    A(S00000)
L00021   L     15,L00022
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00012   DS    0H
         LA    15,187
         ST    15,T00002
         L     15,C00023
         ST    15,T00003
         LA    15,3
         ST    15,T00004
         LA    15,3
         ST    15,T00005
         LA    15,46
         ST    15,T00006
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         L     3,T00002
         LR    0,3
         ST    0,P00030+0
         LA    1,P00030
         L     15,C00031
         BALR  14,15
         L     3,T00007
         LR    0,3
         ST    0,P00030+0
         LA    1,P00030
         L     15,C00031
         BALR  14,15
         LA    1,P00032
         L     15,C00033
         BALR  14,15
         L     15,C00034
         BALR  14,15
L00013   DS    0H
         L     2,T00002
         C     2,C00035
         BC    7,L00014
L00015   DS    0H
         L     2,T00007
         C     2,C00036
         BC    7,L00016
L00017   DS    0H
         LA    1,P00037
         L     15,C00038
         BALR  14,15
         B     L00019
L00014   DS    0H
         LA    1,P00039
         L     15,C00038
         BALR  14,15
         B     L00019
L00016   DS    0H
         LA    1,P00040
         L     15,C00038
         BALR  14,15
         B     L00019
L00018   DS    0H
L00019   DS    0H
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
T00008   DS    XL16
T00009   DS    XL32
T00010   DS    XL40
T00011   DS    XL340
         DS    XL4
P00026   DC    A(T00009)
         DC    A(T00008)
         DC    A(G00024)
         DC    A(G00025)
         DC    A(T00010)
         DC    A(T00011)
         DC    A(T00002)
         DC    A(T00003)
         DC    A(T00004)
         DC    A(T00005)
         DC    A(T00006)
         DC    A(T00007)
         DC    F'4'
         DC    XL1'80',FL3'4'
P00028   DC    F'6'
         DC    A(Q00001)
P00030   DC    A(0)
P00032   DC    A(T00009)
         DC    F'4'
P00037   DC    F'0'
P00039   DC    F'1'
P00040   DC    F'2'
C00023   DC    F'500000'
C00027   DC    V(LECAFC)
C00029   DC    V(F77WRBEG)
C00031   DC    V(F77WRI)
C00033   DC    V(F77WRA)
C00034   DC    V(F77WREND)
C00035   DC    F'187'
C00036   DC    F'9'
C00038   DC    V(EXIT)
Q00001   DC    C'(1X,''>CMPSCR'',2I8,1X,A4)'
* LECAFC
LECAFC   CSECT
         USING *,15
         B     L00079
         DC    AL1(6),CL7'LECAFC'
L00079   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00080
L00081   DC    A(S00041)
L00080   L     15,L00081
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00041,13
         ST    1,S00041+72
L00063   DS    0H
         L     14,0(,1)
         ST    14,S00041+472
         L     14,4(,1)
         ST    14,S00041+480
         L     8,8(,1)
         L     4,12(,1)
         L     14,16(,1)
         ST    14,S00041+488
         L     14,20(,1)
         ST    14,S00041+496
         L     14,24(,1)
         ST    14,S00041+504
         L     14,28(,1)
         ST    14,S00041+512
         L     14,32(,1)
         ST    14,S00041+520
         L     14,36(,1)
         ST    14,S00041+528
         L     14,40(,1)
         ST    14,S00041+536
         L     11,44(,1)
         L     14,S00041+528
         L     10,0(,14)
         S     10,C00082
         AH    10,C00083
         LA    15,0
         ST    15,0(,11)
         LA    1,P00084
         L     15,C00085
         BALR  14,15
         LA    15,1
         ST    15,T00047
         LA    15,1
         ST    15,T00049
         LA    15,201
         ST    15,T00052
         LA    15,4
         ST    15,T00053
         L     0,S00041+520
         ST    0,P00086+12
         L     0,S00041+480
         ST    0,P00086+16
         LA    1,P00086
         L     15,C00087
         BALR  14,15
         LA    1,P00088
         L     15,C00085
         BALR  14,15
         LA    15,1
         ST    15,T00056
         LA    15,1
         ST    15,T00057
         LA    15,201
         ST    15,T00058
         LA    15,5
         ST    15,T00059
         L     0,S00041+496
         ST    0,P00089+16
         LA    1,P00089
         L     15,C00087
         BALR  14,15
         L     14,S00041+520
         L     2,0(,14)
         S     2,C00082
         A     2,C00082
L00064   DS    0H
         L     9,S00041+472
         AH    9,C00090
         AH    8,C00090
         AH    4,C00090
         LA    6,4
         LR    14,2
         SLL   14,2
         ST    14,S00041+472
         LA    7,0
         A     7,S00041+472
         C     2,C00091
         BC    2,L00092
         B     L00066
L00092   DS    0H
         LA    2,4
         B     L00065
L00066   DS    0H
         L     15,S00041+504
         L     14,0(,15)
         ST    14,S00041+472
         L     14,S00041+536
         L     2,0(,14)
         L     14,S00041+472
         CR    14,2
         LA    14,1
         BC    2,L00093
         SR    14,14
L00093   DS    0H
         ST    14,S00041+480
         L     14,S00041+480
         LCR   14,14
         ST    14,S00041+496
         L     14,S00041+472
         XR    14,2
         ST    14,S00041+480
         L     14,S00041+480
         N     14,S00041+496
         ST    14,S00041+472
         LR    14,2
         X     14,S00041+472
         ST    14,S00041+480
         L     15,S00041+480
         L     14,S00041+504
         ST    15,0(,14)
         L     14,S00041+480
         L     15,S00041+512
         C     14,0(,15)
         BC    2,L00068
L00069   DS    0H
         L     15,S00041+528
         L     14,0(,15)
         ST    14,S00041+472
         L     14,S00041+472
         S     14,C00082
         ST    14,S00041+480
         L     14,S00041+480
         A     14,C00082
         ST    14,S00041+472
L00070   DS    0H
         LA    6,1
         L     15,S00041+528
         L     14,0(,15)
         ST    14,S00041+480
         L     14,S00041+480
         SR    14,6
         ST    14,S00041+496
         L     14,S00041+496
         AR    14,6
         ST    14,S00041+480
         L     14,S00041+480
         C     14,C00091
         LA    14,1
         BC    2,L00094
         SR    14,14
L00094   DS    0H
         ST    14,S00041+496
         LA    8,4
         L     14,S00041+472
         SLL   14,2
         ST    14,S00041+504
         LA    9,0
         A     9,S00041+504
         L     14,S00041+488
         AH    14,C00090
         ST    14,S00041+504
         L     14,S00041+480
         SLL   14,0
         ST    14,S00041+488
         LA    7,0
         A     7,S00041+488
         L     14,S00041+472
         C     14,C00091
         BC    2,L00095
         B     L00072
L00095   DS    0H
         LA    2,4
         B     L00071
L00072   DS    0H
         LA    0,0
         B     L00078
L00065   DS    0H
         LR    5,9
         AR    5,2
         L     3,0(2,8)
         SLL   3,2
         AR    3,4
         LR    0,5
         ST    0,P00096+0
         LR    0,3
         ST    0,P00096+8
         LA    1,P00096
         L     15,C00085
         BALR  14,15
L00067   DS    0H
         BXLE  2,6,L00065
         B     L00066
L00068   DS    0H
         LA    0,0
         B     L00078
L00071   DS    0H
L00073   DS    0H
         LE    0,C00097
         L     5,S00041+504
         AR    5,2
         L     14,S00041+496
         LTR   14,14
         BC    7,L00098
         B     L00075
L00098   DS    0H
         LR    3,6
         B     L00074
L00075   DS    0H
         BXLE  2,8,L00071
         B     L00072
L00074   DS    0H
         LR    4,3
         AH    4,C00099
         LR    1,4
         MR    0,10
         LR    4,1
         SLL   4,2
         STE   0,0(4,5)
L00076   DS    0H
         L     4,0(,11)
         A     4,C00082
         ST    4,0(,11)
         BXLE  3,6,L00074
         B     L00075
L00077   DS    0H
L00078   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00041   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00046   DS    XL4
         DS    XL4
T00047   DS    XL4
         DS    XL4
T00048   DS    XL4
         DS    XL4
T00049   DS    XL4
         DS    XL4
T00050   DS    XL4
         DS    XL4
T00051   DS    XL4
         DS    XL4
T00052   DS    XL4
         DS    XL4
T00053   DS    XL4
         DS    XL4
T00054   DS    XL4
         DS    XL4
T00055   DS    XL4
         DS    XL4
T00056   DS    XL4
         DS    XL4
T00057   DS    XL4
         DS    XL4
T00058   DS    XL4
         DS    XL4
T00059   DS    XL4
         DS    XL4
T00060   DS    XL8
T00061   DS    XL84
         DS    XL4
T00062   DS    XL84
         DS    XL4
         DS    10D
P00084   DC    A(T00062)
         DC    F'80'
         DC    A(Q00042)
         DC    F'67'
P00086   DC    A(Q00043)
         DC    A(T00046)
         DC    A(T00062)
         DC    A(0)
         DC    A(0)
         DC    A(T00047)
         DC    A(T00048)
         DC    A(T00049)
         DC    A(T00060)
         DC    A(T00061)
         DC    A(T00050)
         DC    A(T00051)
         DC    A(T00052)
         DC    A(T00053)
         DC    A(T00054)
         DC    F'4'
         DC    F'80'
         DC    F'4'
         DC    XL1'80',FL3'80'
P00088   DC    A(T00062)
         DC    F'80'
         DC    A(Q00044)
         DC    F'70'
P00089   DC    A(Q00045)
         DC    A(T00046)
         DC    A(T00062)
         DC    A(T00055)
         DC    A(0)
         DC    A(T00056)
         DC    A(T00048)
         DC    A(T00057)
         DC    A(T00060)
         DC    A(T00061)
         DC    A(T00050)
         DC    A(T00051)
         DC    A(T00058)
         DC    A(T00059)
         DC    A(T00054)
         DC    F'4'
         DC    F'80'
         DC    F'4'
         DC    XL1'80',FL3'80'
P00096   DC    A(0)
         DC    F'4'
         DC    A(0)
         DC    F'4'
C00082   DC    F'1'
C00085   DC    V(F77STRCP)
C00087   DC    V(LECPAR)
C00091   DC    F'0'
C00097   DC    X'00000000'
C00083   DC    H'1'
C00090   DC    H'-4'
C00099   DC    H'-1'
Q00042   DC    C'FIRST PROMPT, A STAND-IN TEXT LONG ENOUG'
         DC    C'H TO CROSS THECARD EDGE :  '
Q00043   DC    C'80I1'
Q00044   DC    C'SECOND PROMPT, ANOTHER STAND-IN THAT RUN'
         DC    C'S PAST THE CA RD EDGE AS WELL '
Q00045   DC    C'80I1'
* LECPAR
LECPAR   CSECT
         USING *,15
         B     L00103
         DC    AL1(6),CL7'LECPAR'
L00103   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00104
L00105   DC    A(S00100)
L00104   L     15,L00105
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00100,13
         ST    1,S00100+72
L00101   DS    0H
         L     2,56(,1)
         LA    15,0
         ST    15,0(,2)
         LA    0,0
L00102   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00100   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
G00025   CSECT
         DS    0D
         DC    X'E5F14040E5F24040E5F34040'
G00024   CSECT
         DS    0D
         DC    X'000000030000000100000002'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
