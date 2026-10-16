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
         LA    0,T00009
         ST    0,P00024+0
         LA    0,T00008
         ST    0,P00024+4
         L     0,C00026
         ST    0,P00024+8
         L     0,C00028
         ST    0,P00024+12
         LA    0,T00010
         ST    0,P00024+16
         LA    0,T00011
         ST    0,P00024+20
         LA    0,T00002
         ST    0,P00024+24
         LA    0,T00003
         ST    0,P00024+28
         LA    0,T00004
         ST    0,P00024+32
         LA    0,T00005
         ST    0,P00024+36
         LA    0,T00006
         ST    0,P00024+40
         LA    0,T00007
         ST    0,P00024+44
         LA    0,4
         ST    0,P00024+48
         LA    0,4
         ST    0,P00024+52
         OI    P00024+52,X'80'
         LA    1,P00024
         L     15,C00029
         BALR  14,15
         LA    0,6
         ST    0,P00024+0
         L     0,C00030
         ST    0,P00024+4
         LA    1,P00024
         L     15,C00031
         BALR  14,15
         L     3,T00002
         LR    0,3
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00032
         BALR  14,15
         L     3,T00007
         LR    0,3
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00032
         BALR  14,15
         LA    0,T00009
         ST    0,P00024+0
         LA    0,4
         ST    0,P00024+4
         LA    1,P00024
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
         LA    0,0
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00037
         BALR  14,15
         B     L00019
L00014   DS    0H
         LA    0,1
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00037
         BALR  14,15
         B     L00019
L00016   DS    0H
         LA    0,2
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00037
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
P00024   DS    14F
C00023   DC    F'500000'
C00026   DC    A(G00025)
C00028   DC    A(G00027)
C00029   DC    V(LECAFC)
C00030   DC    A(Q00001)
C00031   DC    V(F77WRBEG)
C00032   DC    V(F77WRI)
C00033   DC    V(F77WRA)
C00034   DC    V(F77WREND)
C00035   DC    F'187'
C00036   DC    F'9'
C00037   DC    V(EXIT)
Q00001   DC    C'(1X,''>CMPSCR'',2I8,1X,A4)'
* LECAFC
LECAFC   CSECT
         USING *,15
         B     L00076
         DC    AL1(6),CL7'LECAFC'
L00076   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00077
L00078   DC    A(S00038)
L00077   L     15,L00078
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00038,13
         ST    1,S00038+72
L00060   DS    0H
         L     14,0(,1)
         ST    14,S00038+472
         L     14,4(,1)
         ST    14,S00038+480
         L     8,8(,1)
         L     4,12(,1)
         L     14,16(,1)
         ST    14,S00038+488
         L     14,20(,1)
         ST    14,S00038+496
         L     14,24(,1)
         ST    14,S00038+504
         L     14,28(,1)
         ST    14,S00038+512
         L     14,32(,1)
         ST    14,S00038+520
         L     14,36(,1)
         ST    14,S00038+528
         L     14,40(,1)
         ST    14,S00038+536
         L     11,44(,1)
         L     14,S00038+528
         L     10,0(,14)
         S     10,C00079
         AH    10,C00080
         LA    15,0
         ST    15,0(,11)
         LA    0,T00059
         ST    0,P00081+0
         LA    0,80
         ST    0,P00081+4
         L     0,C00082
         ST    0,P00081+8
         LA    0,67
         ST    0,P00081+12
         LA    1,P00081
         L     15,C00083
         BALR  14,15
         LA    15,1
         ST    15,T00044
         LA    15,1
         ST    15,T00046
         LA    15,201
         ST    15,T00049
         LA    15,4
         ST    15,T00050
         L     0,C00084
         ST    0,P00081+0
         LA    0,T00043
         ST    0,P00081+4
         LA    0,T00059
         ST    0,P00081+8
         L     0,S00038+520
         ST    0,P00081+12
         L     0,S00038+480
         ST    0,P00081+16
         LA    0,T00044
         ST    0,P00081+20
         LA    0,T00045
         ST    0,P00081+24
         LA    0,T00046
         ST    0,P00081+28
         LA    0,T00057
         ST    0,P00081+32
         LA    0,T00058
         ST    0,P00081+36
         LA    0,T00047
         ST    0,P00081+40
         LA    0,T00048
         ST    0,P00081+44
         LA    0,T00049
         ST    0,P00081+48
         LA    0,T00050
         ST    0,P00081+52
         LA    0,T00051
         ST    0,P00081+56
         LA    0,4
         ST    0,P00081+60
         LA    0,80
         ST    0,P00081+64
         LA    0,4
         ST    0,P00081+68
         LA    0,80
         ST    0,P00081+72
         OI    P00081+72,X'80'
         LA    1,P00081
         L     15,C00085
         BALR  14,15
         LA    0,T00059
         ST    0,P00081+0
         LA    0,80
         ST    0,P00081+4
         L     0,C00086
         ST    0,P00081+8
         LA    0,70
         ST    0,P00081+12
         LA    1,P00081
         L     15,C00083
         BALR  14,15
         LA    15,1
         ST    15,T00053
         LA    15,1
         ST    15,T00054
         LA    15,201
         ST    15,T00055
         LA    15,5
         ST    15,T00056
         L     0,C00087
         ST    0,P00081+0
         LA    0,T00043
         ST    0,P00081+4
         LA    0,T00059
         ST    0,P00081+8
         LA    0,T00052
         ST    0,P00081+12
         L     0,S00038+496
         ST    0,P00081+16
         LA    0,T00053
         ST    0,P00081+20
         LA    0,T00045
         ST    0,P00081+24
         LA    0,T00054
         ST    0,P00081+28
         LA    0,T00057
         ST    0,P00081+32
         LA    0,T00058
         ST    0,P00081+36
         LA    0,T00047
         ST    0,P00081+40
         LA    0,T00048
         ST    0,P00081+44
         LA    0,T00055
         ST    0,P00081+48
         LA    0,T00056
         ST    0,P00081+52
         LA    0,T00051
         ST    0,P00081+56
         LA    0,4
         ST    0,P00081+60
         LA    0,80
         ST    0,P00081+64
         LA    0,4
         ST    0,P00081+68
         LA    0,80
         ST    0,P00081+72
         OI    P00081+72,X'80'
         LA    1,P00081
         L     15,C00085
         BALR  14,15
         L     14,S00038+520
         L     2,0(,14)
         S     2,C00079
         A     2,C00079
L00061   DS    0H
         L     9,S00038+472
         AH    9,C00088
         AH    8,C00088
         AH    4,C00088
         LA    6,4
         LR    14,2
         SLL   14,2
         ST    14,S00038+472
         LA    7,0
         A     7,S00038+472
         C     2,C00089
         BC    2,L00090
         B     L00063
L00090   DS    0H
         LA    2,4
         B     L00062
L00063   DS    0H
         L     15,S00038+504
         L     14,0(,15)
         ST    14,S00038+472
         L     14,S00038+536
         L     2,0(,14)
         L     14,S00038+472
         CR    14,2
         LA    14,1
         BC    2,L00091
         SR    14,14
L00091   DS    0H
         ST    14,S00038+480
         L     14,S00038+480
         LCR   14,14
         ST    14,S00038+496
         L     14,S00038+472
         XR    14,2
         ST    14,S00038+480
         L     14,S00038+480
         N     14,S00038+496
         ST    14,S00038+472
         LR    14,2
         X     14,S00038+472
         ST    14,S00038+480
         L     15,S00038+480
         L     14,S00038+504
         ST    15,0(,14)
         L     14,S00038+480
         L     15,S00038+512
         C     14,0(,15)
         BC    2,L00065
L00066   DS    0H
         L     15,S00038+528
         L     14,0(,15)
         ST    14,S00038+472
         L     14,S00038+472
         S     14,C00079
         ST    14,S00038+480
         L     14,S00038+480
         A     14,C00079
         ST    14,S00038+472
L00067   DS    0H
         LA    6,1
         L     15,S00038+528
         L     14,0(,15)
         ST    14,S00038+480
         L     14,S00038+480
         SR    14,6
         ST    14,S00038+496
         L     14,S00038+496
         AR    14,6
         ST    14,S00038+480
         L     14,S00038+480
         C     14,C00089
         LA    14,1
         BC    2,L00092
         SR    14,14
L00092   DS    0H
         ST    14,S00038+496
         LA    8,4
         L     14,S00038+472
         SLL   14,2
         ST    14,S00038+504
         LA    9,0
         A     9,S00038+504
         L     14,S00038+488
         AH    14,C00088
         ST    14,S00038+504
         L     14,S00038+480
         SLL   14,0
         ST    14,S00038+488
         LA    7,0
         A     7,S00038+488
         L     14,S00038+472
         C     14,C00089
         BC    2,L00093
         B     L00069
L00093   DS    0H
         LA    2,4
         B     L00068
L00069   DS    0H
         LA    0,0
         B     L00075
L00062   DS    0H
         LR    5,9
         AR    5,2
         L     3,0(2,8)
         SLL   3,2
         AR    3,4
         LR    0,5
         ST    0,P00081+0
         LA    0,4
         ST    0,P00081+4
         LR    0,3
         ST    0,P00081+8
         LA    0,4
         ST    0,P00081+12
         LA    1,P00081
         L     15,C00083
         BALR  14,15
L00064   DS    0H
         BXLE  2,6,L00062
         B     L00063
L00065   DS    0H
         LA    0,0
         B     L00075
L00068   DS    0H
L00070   DS    0H
         LE    0,C00094
         L     5,S00038+504
         AR    5,2
         L     14,S00038+496
         LTR   14,14
         BC    7,L00095
         B     L00072
L00095   DS    0H
         LR    3,6
         B     L00071
L00072   DS    0H
         BXLE  2,8,L00068
         B     L00069
L00071   DS    0H
         LR    4,3
         AH    4,C00096
         LR    1,4
         MR    0,10
         LR    4,1
         SLL   4,2
         STE   0,0(4,5)
L00073   DS    0H
         L     4,0(,11)
         A     4,C00079
         ST    4,0(,11)
         BXLE  3,6,L00071
         B     L00072
L00074   DS    0H
L00075   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00038   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00043   DS    XL4
         DS    XL4
T00044   DS    XL4
         DS    XL4
T00045   DS    XL4
         DS    XL4
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
T00057   DS    XL8
T00058   DS    XL84
         DS    XL4
T00059   DS    XL84
         DS    XL4
         DS    10D
P00081   DS    19F
         DS    XL4
C00079   DC    F'1'
C00082   DC    A(Q00039)
C00083   DC    V(F77STRCP)
C00084   DC    A(Q00040)
C00085   DC    V(LECPAR)
C00086   DC    A(Q00041)
C00087   DC    A(Q00042)
C00089   DC    F'0'
C00094   DC    X'00000000'
C00080   DC    H'1'
C00088   DC    H'-4'
C00096   DC    H'-1'
Q00039   DC    C'FIRST PROMPT, A STAND-IN TEXT LONG ENOUG'
         DC    C'H TO CROSS THECARD EDGE :  '
Q00040   DC    C'80I1'
Q00041   DC    C'SECOND PROMPT, ANOTHER STAND-IN THAT RUN'
         DC    C'S PAST THE CA RD EDGE AS WELL '
Q00042   DC    C'80I1'
* LECPAR
LECPAR   CSECT
         USING *,15
         B     L00100
         DC    AL1(6),CL7'LECPAR'
L00100   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00101
L00102   DC    A(S00097)
L00101   L     15,L00102
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00097,13
         ST    1,S00097+72
L00098   DS    0H
         L     2,56(,1)
         LA    15,0
         ST    15,0(,2)
         LA    0,0
L00099   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00097   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
G00027   CSECT
         DS    0D
         DC    X'E5F14040E5F24040E5F34040'
G00025   CSECT
         DS    0D
         DC    X'000000030000000100000002'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
