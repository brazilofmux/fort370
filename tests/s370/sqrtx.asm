* main
F77MAIN  CSECT
         USING *,15
         B     L00032
         DC    AL1(7),CL7'F77MAIN'
L00032   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00033
L00034   DC    A(S00000)
L00033   L     15,L00034
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00016   DS    0H
         LA    15,0
         ST    15,T00015
         LD    0,C00036
         STD   0,P00035+0
         LA    1,P00035
         L     15,C00037
         BALR  14,15
         CD    0,C00038
         LA    2,1
         BC    8,L00039
         SR    2,2
L00039   DS    0H
         ST    2,T00009
         LA    1,P00040
         L     15,C00041
         BALR  14,15
         LD    0,C00042
         STD   0,P00035+0
         LA    1,P00035
         L     15,C00037
         BALR  14,15
         CD    0,C00043
         LA    2,1
         BC    8,L00044
         SR    2,2
L00044   DS    0H
         ST    2,T00010
         LA    1,P00045
         L     15,C00041
         BALR  14,15
         LD    0,C00046
         STD   0,P00035+0
         LA    1,P00035
         L     15,C00037
         BALR  14,15
         CD    0,C00047
         LA    2,1
         BC    8,L00048
         SR    2,2
L00048   DS    0H
         ST    2,T00011
         LA    1,P00049
         L     15,C00041
         BALR  14,15
         LD    0,C00050
         STD   0,P00035+0
         LA    1,P00035
         L     15,C00037
         BALR  14,15
         CD    0,C00050
         LA    2,1
         BC    8,L00051
         SR    2,2
L00051   DS    0H
         ST    2,T00012
         LA    1,P00052
         L     15,C00041
         BALR  14,15
         LD    0,C00053
         STD   0,P00035+0
         LA    1,P00035
         L     15,C00037
         BALR  14,15
         CD    0,C00054
         LA    2,1
         BC    8,L00055
         SR    2,2
L00055   DS    0H
         ST    2,T00013
         LA    1,P00056
         L     15,C00041
         BALR  14,15
         LD    0,C00057
         STD   0,P00035+0
         LA    1,P00035
         L     15,C00037
         BALR  14,15
         CD    0,C00058
         LA    2,1
         BC    8,L00059
         SR    2,2
L00059   DS    0H
         ST    2,T00014
         LA    1,P00060
         L     15,C00041
         BALR  14,15
         LA    10,1
L00017   DS    0H
         LA    11,2
         LR    9,10
         LH    2,C00061
L00018   DS    0H
L00020   DS    0H
         C     9,C00062
         LA    8,1
         BC    8,L00063
         SR    8,8
L00063   DS    0H
         LH    6,C00064
         LA    7,0
         L     5,C00065
         LA    3,0
L00021   DS    0H
         LR    4,2
         SLL   4,13
         XR    2,4
         LR    4,2
         SRL   4,17
         XR    2,4
         LR    4,2
         SLL   4,5
         XR    2,4
L00023   DS    0H
         LR    4,2
         N     4,C00066
         L     14,C00068
         ST    4,0(,14)
         LTR   8,8
         BC    8,L00025
L00024   DS    0H
         L     14,C00068
         L     4,0(,14)
         O     4,C00069
         L     14,C00068
         ST    4,0(,14)
L00025   DS    0H
         LR    4,2
         SLL   4,13
         XR    2,4
         LR    4,2
         SRL   4,17
         XR    2,4
         LR    4,2
         SLL   4,5
         XR    2,4
L00026   DS    0H
         L     14,C00070
         ST    2,0(,14)
         L     14,C00068
         LD    0,0(,14)
         STD   0,S00000+312
         LD    0,S00000+312
         STD   0,P00035+0
         LA    1,P00035
         L     15,C00037
         BALR  14,15
         L     14,C00072
         STD   0,0(,14)
         LR    4,3
         SLL   4,5
         SRL   3,27
         OR    4,3
         L     15,C00072
         X     4,0(,15)
         LR    3,4
         SLL   3,7
         SRL   4,25
         OR    3,4
         L     15,C00072
         X     3,4(,15)
L00027   DS    0H
         BXH   5,6,L00021
L00022   DS    0H
         LA    1,P00073
         L     15,C00074
         BALR  14,15
         LR    0,9
         ST    0,P00075+0
         LA    1,P00075
         L     15,C00076
         BALR  14,15
         LR    0,3
         ST    0,P00075+0
         LA    1,P00075
         L     15,C00076
         BALR  14,15
         L     15,C00077
         BALR  14,15
L00028   DS    0H
L00029   DS    0H
         BXLE  9,10,L00018
L00019   DS    0H
         LA    1,P00078
         L     15,C00074
         BALR  14,15
         L     3,T00015
         LR    0,3
         ST    0,P00075+0
         LA    1,P00075
         L     15,C00076
         BALR  14,15
         L     15,C00077
         BALR  14,15
L00030   DS    0H
L00031   DS    0H
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
T00009   DS    XL4
         DS    XL4
T00010   DS    XL4
         DS    XL4
T00011   DS    XL4
         DS    XL4
T00012   DS    XL4
         DS    XL4
T00013   DS    XL4
         DS    XL4
T00014   DS    XL4
         DS    XL4
T00015   DS    XL88
         DS    1D
P00035   DC    A(0)
         DC    A(0)
P00040   DC    A(Q00001)
         DC    A(T00009)
         DC    A(T00015)
         DC    XL1'80',FL3'7'
P00045   DC    A(Q00002)
         DC    A(T00010)
         DC    A(T00015)
         DC    XL1'80',FL3'7'
P00049   DC    A(Q00003)
         DC    A(T00011)
         DC    A(T00015)
         DC    XL1'80',FL3'7'
P00052   DC    A(Q00004)
         DC    A(T00012)
         DC    A(T00015)
         DC    XL1'80',FL3'7'
P00056   DC    A(Q00005)
         DC    A(T00013)
         DC    A(T00015)
         DC    XL1'80',FL3'7'
P00060   DC    A(Q00006)
         DC    A(T00014)
         DC    A(T00015)
         DC    XL1'80',FL3'7'
P00073   DC    F'6'
         DC    A(Q00008)
P00075   DC    A(0)
P00078   DC    F'6'
         DC    A(Q00007)
         DS    XL4
C00036   DC    X'4140000000000000'
C00038   DC    X'4120000000000000'
C00042   DC    X'4040000000000000'
C00043   DC    X'4080000000000000'
C00046   DC    X'4310000000000000'
C00047   DC    X'4210000000000000'
C00050   DC    X'0000000000000000'
C00053   DC    X'7E3899162693736B'
C00054   DC    X'5F785EE10D5DA46E'
C00057   DC    X'03485EBBF9A41DDD'
C00058   DC    X'2222073A8515171D'
C00037   DC    V(DSQRT)
C00041   DC    V(CHK)
C00062   DC    F'1'
C00065   DC    F'100000'
C00066   DC    F'2147483647'
C00068   DC    A(G00067)
C00069   DC    F'1048576'
C00070   DC    A(G00067+4)
C00072   DC    A(G00071)
C00074   DC    V(F77WRBEG)
C00076   DC    V(F77WRI)
C00077   DC    V(F77WREND)
C00061   DC    H'12345'
C00064   DC    H'-1'
Q00008   DC    C'('' >HASH'',I1,1X,Z8)'
Q00007   DC    C'('' >BAD '',I2)'
Q00001   DC    C'FOUR   '
Q00002   DC    C'QUART  '
Q00003   DC    C'SIXTEEN'
Q00004   DC    C'ZERO   '
Q00005   DC    C'BIG    '
Q00006   DC    C'SMALL  '
* XSH
XSH      CSECT
         USING *,15
         B     L00082
         DC    AL1(3),CL7'XSH'
L00082   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00083
L00084   DC    A(S00079)
L00083   L     15,L00084
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00079,13
         ST    1,S00079+72
L00080   DS    0H
         L     4,0(,1)
         LA    4,0(,4)
         L     2,0(,4)
         LR    3,2
         SLL   3,13
         XR    2,3
         LR    3,2
         SRL   3,17
         XR    2,3
         LR    3,2
         SLL   3,5
         XR    2,3
         ST    2,0(,4)
         LA    0,0
L00081   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00079   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
* CHK
CHK      CSECT
         USING *,15
         B     L00095
         DC    AL1(3),CL7'CHK'
L00095   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00096
L00097   DC    A(S00085)
L00096   L     15,L00097
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00085,13
         ST    1,S00085+72
L00088   DS    0H
         L     5,0(,1)
         L     4,4(,1)
         L     3,8(,1)
         L     2,0(,4)
         LTR   2,2
         BC    7,L00089
L00090   DS    0H
         LA    1,P00098
         L     15,C00099
         BALR  14,15
         LR    0,5
         ST    0,P00100+0
         LA    1,P00100
         L     15,C00101
         BALR  14,15
         L     15,C00102
         BALR  14,15
L00093   DS    0H
         L     2,0(,3)
         A     2,C00103
         ST    2,0(,3)
L00091   DS    0H
         LA    0,0
         B     L00094
L00089   DS    0H
         LA    1,P00104
         L     15,C00099
         BALR  14,15
         LR    0,5
         ST    0,P00100+0
         LA    1,P00100
         L     15,C00101
         BALR  14,15
         L     15,C00102
         BALR  14,15
L00092   DS    0H
         B     L00091
L00094   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00085   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00098   DC    F'6'
         DC    A(Q00087)
P00100   DC    A(0)
         DC    F'7'
P00104   DC    F'6'
         DC    A(Q00086)
C00099   DC    V(F77WRBEG)
C00101   DC    V(F77WRA)
C00102   DC    V(F77WREND)
C00103   DC    F'1'
Q00086   DC    C'('' >'',A7,'' OK'')'
Q00087   DC    C'('' >'',A7,'' BAD'')'
G00067   CSECT
         DS    0D
         DS    XL8
G00071   CSECT
         DS    0D
         DS    XL8
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
