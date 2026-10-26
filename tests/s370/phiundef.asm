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
         LA    1,P00025
         L     15,C00026
         BALR  14,15
         LA    1,P00027
         L     15,C00028
         BALR  14,15
         LA    2,4
         LA    3,6
L00006   DS    0H
         C     3,C00029
         BC    2,L00007
L00008   DS    0H
         LA    2,4
         LA    3,6
L00009   DS    0H
         C     3,C00029
         BC    2,L00010
L00011   DS    0H
         L     15,C00030
         BALR  14,15
L00012   DS    0H
L00013   DS    0H
         L     6,C00032
         AH    6,C00033
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
         LA    1,P00034
         L     15,C00035
         BALR  14,15
         B     L00020
L00007   DS    0H
         LE    0,T00004-4(2)
         STE   0,S00000+296
         LE    0,S00000+296
         STE   0,P00036+0
         LA    1,P00036
         L     15,C00037
         BALR  14,15
         AH    3,C00038
         A     2,C00039
         B     L00006
L00010   DS    0H
         L     5,T00002-4(2)
         LR    0,5
         ST    0,P00040+0
         LA    1,P00040
         L     15,C00041
         BALR  14,15
         AH    3,C00038
         A     2,C00039
         B     L00009
L00016   DS    0H
         LA    1,P00042
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
P00025   DC    A(G00024)
         DC    A(T00004)
         DC    A(T00002)
         DC    XL1'80',AL3(T00003)
P00027   DC    F'6'
         DC    A(Q00001)
P00034   DC    F'0'
         DS    F
P00036   DC    A(0)
P00040   DC    A(0)
P00042   DC    F'1'
         DS    XL4
C00026   DC    V(SEL)
C00028   DC    V(F77WRBEG)
C00029   DC    F'0'
C00030   DC    V(F77WREND)
C00032   DC    A(G00031)
C00035   DC    V(EXIT)
C00037   DC    V(F77WRR)
C00039   DC    F'4'
C00041   DC    V(F77WRI)
C00033   DC    H'-4'
C00038   DC    H'-1'
Q00001   DC    C'(1X,''>PHIUNDEF'',6F5.1,6I2)'
* SEL
SEL      CSECT
         USING *,15
         B     L00057
         DC    AL1(3),CL7'SEL'
L00057   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00058
L00059   DC    A(S00043)
L00058   L     15,L00059
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00043,13
         ST    1,S00043+72
L00045   DS    0H
         L     6,0(,1)
         L     14,4(,1)
         ST    14,S00043+200
         L     14,8(,1)
         ST    14,S00043+208
         L     3,12(,1)
         LA    3,0(,3)
         L     2,0(,3)
         S     2,C00060
         LR    14,2
         A     14,C00060
         ST    14,S00043+216
L00046   DS    0H
         LE    2,C00061
         LCER  2,2
         L     2,0(,3)
         S     2,C00060
         LR    14,2
         A     14,C00060
         ST    14,S00043+224
         L     14,S00043+224
         C     14,C00062
         LA    14,1
         BC    2,L00063
         SR    14,14
L00063   DS    0H
         ST    14,S00043+232
         L     14,S00043+208
         AH    14,C00064
         ST    14,S00043+240
         L     10,S00043+200
         AH    10,C00064
         LR    7,6
         AH    7,C00064
         LE    4,C00061
         LCER  4,4
         LA    8,4
         L     14,S00043+216
         SLL   14,2
         ST    14,S00043+200
         LA    9,0
         A     9,S00043+200
         AH    6,C00064
         L     14,S00043+224
         SLL   14,2
         ST    14,S00043+200
         LA    5,0
         A     5,S00043+200
         L     14,S00043+216
         C     14,C00062
         BC    2,L00065
         B     L00048
L00065   DS    0H
         LA    2,4
         B     L00047
L00048   DS    0H
         LA    0,0
         B     L00056
L00047   DS    0H
L00049   DS    0H
         LA    4,4
         L     14,S00043+232
         LTR   14,14
         BC    7,L00066
         LER   0,2
         B     L00051
L00066   DS    0H
         LA    3,4
         LA    11,1
         LER   0,2
         B     L00050
L00051   DS    0H
         L     3,T00044
         L     14,S00043+240
         ST    3,0(2,14)
         STE   0,0(2,10)
L00055   DS    0H
         L     3,T00044
         SLL   3,2
         STE   4,0(3,7)
         BXLE  2,8,L00047
         B     L00048
L00050   DS    0H
         LE    6,0(3,6)
         CER   6,0
         BC    12,L00052
L00053   DS    0H
         LE    0,0(3,6)
         ST    11,T00044
L00054   DS    0H
         A     11,C00060
         BXLE  3,4,L00050
         B     L00051
L00052   DS    0H
         B     L00054
L00056   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00043   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00044   DS    XL24
         DS    6D
C00060   DC    F'1'
C00061   DC    X'41100000'
C00062   DC    F'0'
C00064   DC    H'-4'
G00024   CSECT
         DS    0D
         DC    X'413000004110000041400000411800004150000041200000'
G00031   CSECT
         DS    0D
         DC    X'000000050000000300000001000000060000000400000002'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
