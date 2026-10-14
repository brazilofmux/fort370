* main
F77MAIN  CSECT
         USING *,15
         B     L00021
         DC    AL1(7),CL7'F77MAIN'
L00021   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00022
L00023   DC    A(S00000)
L00022   L     15,L00023
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00005   DS    0H
         LA    15,6
         ST    15,T00003
         L     0,C00026
         ST    0,P00024+0
         LA    0,T00004
         ST    0,P00024+4
         LA    0,T00002
         ST    0,P00024+8
         LA    0,T00003
         ST    0,P00024+12
         OI    P00024+12,X'80'
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LA    0,6
         ST    0,P00024+0
         L     0,C00028
         ST    0,P00024+4
         LA    1,P00024
         L     15,C00029
         BALR  14,15
         LA    2,4
         LA    3,6
L00006   DS    0H
         C     3,C00030
         BC    2,L00007
L00008   DS    0H
         LA    2,4
         LA    3,6
L00009   DS    0H
         C     3,C00030
         BC    2,L00010
L00011   DS    0H
         L     15,C00031
         BALR  14,15
L00012   DS    0H
L00013   DS    0H
         L     6,C00033
         AH    6,C00034
         LA    4,4
         LA    5,24
         LA    2,4
L00014   DS    0H
         L     3,T00002-4(2)
         C     3,0(2,6)
         BC    7,L00016
L00017   DS    0H
L00018   DS    0H
         BXLE  2,4,L00014
L00015   DS    0H
         LA    0,0
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00035
         BALR  14,15
         B     L00020
L00007   DS    0H
         LE    0,T00004-4(2)
         STE   0,S00000+296
         LE    0,S00000+296
         STE   0,P00024+0
         LA    1,P00024
         L     15,C00036
         BALR  14,15
         AH    3,C00037
         A     2,C00038
         B     L00006
L00010   DS    0H
         L     5,T00002-4(2)
         LR    0,5
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00039
         BALR  14,15
         AH    3,C00037
         A     2,C00038
         B     L00009
L00016   DS    0H
         LA    0,1
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00035
         BALR  14,15
         B     L00020
L00019   DS    0H
L00020   DS    0H
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
T00002   DS    XL28
         DS    XL4
T00003   DS    XL32
T00004   DS    XL56
         DS    1D
P00024   DS    4F
C00026   DC    A(G00025)
C00027   DC    V(SEL)
C00028   DC    A(Q00001)
C00029   DC    V(F77WRBEG)
C00030   DC    F'0'
C00031   DC    V(F77WREND)
C00033   DC    A(G00032)
C00035   DC    V(EXIT)
C00036   DC    V(F77WRR)
C00038   DC    F'4'
C00039   DC    V(F77WRI)
C00034   DC    H'-4'
C00037   DC    H'-1'
Q00001   DC    C'(1X,''>PHIUNDEF'',6F5.1,6I2)'
* SEL
SEL      CSECT
         USING *,15
         B     L00054
         DC    AL1(3),CL7'SEL'
L00054   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00055
L00056   DC    A(S00040)
L00055   L     15,L00056
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00040,13
         ST    1,S00040+72
L00042   DS    0H
         L     6,0(,1)
         L     14,4(,1)
         ST    14,S00040+200
         L     14,8(,1)
         ST    14,S00040+208
         L     3,12(,1)
         LA    3,0(,3)
         L     2,0(,3)
         S     2,C00057
         LR    14,2
         A     14,C00057
         ST    14,S00040+216
L00043   DS    0H
         LE    2,C00058
         LCER  2,2
         L     2,0(,3)
         S     2,C00057
         LR    14,2
         A     14,C00057
         ST    14,S00040+224
         L     14,S00040+224
         C     14,C00059
         LA    14,1
         BC    2,L00060
         SR    14,14
L00060   DS    0H
         ST    14,S00040+232
         L     14,S00040+208
         AH    14,C00061
         ST    14,S00040+240
         L     10,S00040+200
         AH    10,C00061
         LR    7,6
         AH    7,C00061
         LE    4,C00058
         LCER  4,4
         LA    8,4
         L     14,S00040+216
         SLL   14,2
         ST    14,S00040+200
         LA    9,0
         A     9,S00040+200
         AH    6,C00061
         L     14,S00040+224
         SLL   14,2
         ST    14,S00040+200
         LA    5,0
         A     5,S00040+200
         L     14,S00040+216
         C     14,C00059
         BC    2,L00062
         B     L00045
L00062   DS    0H
         LA    2,4
         B     L00044
L00045   DS    0H
         LA    0,0
         B     L00053
L00044   DS    0H
L00046   DS    0H
         LA    4,4
         L     14,S00040+232
         LTR   14,14
         BC    7,L00063
         LER   0,2
         B     L00048
L00063   DS    0H
         LA    3,4
         LA    11,1
         LER   0,2
         B     L00047
L00048   DS    0H
         L     3,T00041
         L     14,S00040+240
         ST    3,0(2,14)
         STE   0,0(2,10)
L00052   DS    0H
         L     3,T00041
         SLL   3,2
         STE   4,0(3,7)
         BXLE  2,8,L00044
         B     L00045
L00047   DS    0H
         LE    6,0(3,6)
         CER   6,0
         BC    12,L00049
L00050   DS    0H
         LE    0,0(3,6)
         ST    11,T00041
L00051   DS    0H
         A     11,C00057
         BXLE  3,4,L00047
         B     L00048
L00049   DS    0H
         B     L00051
L00053   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00040   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00041   DS    XL24
         DS    6D
C00057   DC    F'1'
C00058   DC    X'41100000'
C00059   DC    F'0'
C00061   DC    H'-4'
G00025   CSECT
         DS    0D
         DC    X'413000004110000041400000411800004150000041200000'
G00032   CSECT
         DS    0D
         DC    X'000000050000000300000001000000060000000400000002'
         END
