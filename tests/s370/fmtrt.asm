* main
F77MAIN  CSECT
         USING *,15
         B     L00028
         DC    AL1(7),CL7'F77MAIN'
L00028   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00029
L00030   DC    A(S00000)
L00029   L     15,L00030
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00013   DS    0H
L00014   DS    0H
         LA    10,12
         LA    11,36
         LA    2,12
         LA    3,1
L00015   DS    0H
L00017   DS    0H
         LA    7,T00011-16
         LA    8,10
         AR    7,2
         LA    9,30
         LA    4,10
         LA    5,4
L00018   DS    0H
         LR    6,4
         AR    6,3
         ST    6,0(5,7)
L00020   DS    0H
         A     5,C00031
         BXLE  4,8,L00018
L00019   DS    0H
         A     3,C00032
         BXLE  2,10,L00015
L00016   DS    0H
         LA    0,6
         ST    0,P00033+0
         L     0,C00035
         ST    0,P00033+4
         LA    1,P00033
         L     15,C00036
         BALR  14,15
         LA    0,1
         ST    0,P00033+0
         LA    1,P00033
         L     15,C00037
         BALR  14,15
         LA    0,2
         ST    0,P00033+0
         LA    1,P00033
         L     15,C00037
         BALR  14,15
         LA    0,3
         ST    0,P00033+0
         LA    1,P00033
         L     15,C00037
         BALR  14,15
         LA    0,4
         ST    0,P00033+0
         LA    1,P00033
         L     15,C00037
         BALR  14,15
         LA    0,5
         ST    0,P00033+0
         LA    1,P00033
         L     15,C00037
         BALR  14,15
         LA    0,6
         ST    0,P00033+0
         LA    1,P00033
         L     15,C00037
         BALR  14,15
         L     15,C00038
         BALR  14,15
         LA    0,T00010
         ST    0,P00033+0
         LA    0,13
         ST    0,P00033+4
         L     0,C00039
         ST    0,P00033+8
         LA    0,6
         ST    0,P00033+12
         LA    1,P00033
         L     15,C00040
         BALR  14,15
         LA    3,T00010
         A     3,C00041
         LR    0,3
         ST    0,P00033+0
         LA    0,7
         ST    0,P00033+4
         LA    0,1
         ST    0,P00033+8
         L     0,C00042
         ST    0,P00033+12
         LA    1,P00033
         L     15,C00043
         BALR  14,15
         LA    0,3
         ST    0,P00033+0
         LA    1,P00033
         L     15,C00037
         BALR  14,15
         LA    0,4
         ST    0,P00033+0
         LA    1,P00033
         L     15,C00037
         BALR  14,15
         L     15,C00038
         BALR  14,15
         LA    0,6
         ST    0,P00033+0
         L     0,C00044
         ST    0,P00033+4
         LA    1,P00033
         L     15,C00036
         BALR  14,15
         L     0,C00045
         ST    0,P00033+0
         LA    0,2
         ST    0,P00033+4
         LA    1,P00033
         L     15,C00046
         BALR  14,15
         LA    0,T00010
         ST    0,P00033+0
         LA    0,13
         ST    0,P00033+4
         LA    1,P00033
         L     15,C00046
         BALR  14,15
         L     15,C00038
         BALR  14,15
         LA    0,6
         ST    0,P00033+0
         LA    0,T00010
         ST    0,P00033+4
         LA    1,P00033
         L     15,C00036
         BALR  14,15
         LA    6,3
         LA    7,3
L00021   DS    0H
         C     7,C00047
         BC    2,L00022
L00023   DS    0H
         L     15,C00038
         BALR  14,15
         LA    0,6
         ST    0,P00033+0
         L     0,C00049
         ST    0,P00033+4
         LA    1,P00033
         L     15,C00036
         BALR  14,15
         LA    0,7
         ST    0,P00033+0
         LA    1,P00033
         L     15,C00037
         BALR  14,15
         LA    0,8
         ST    0,P00033+0
         LA    1,P00033
         L     15,C00037
         BALR  14,15
         L     15,C00038
         BALR  14,15
         LA    0,6
         ST    0,P00033+0
         L     0,C00051
         ST    0,P00033+4
         LA    1,P00033
         L     15,C00036
         BALR  14,15
         LA    0,9
         ST    0,P00033+0
         LA    1,P00033
         L     15,C00037
         BALR  14,15
         L     15,C00038
         BALR  14,15
         LA    0,6
         ST    0,P00033+0
         L     0,C00052
         ST    0,P00033+4
         LA    1,P00033
         L     15,C00036
         BALR  14,15
         LA    0,5
         ST    0,P00033+0
         LA    1,P00033
         L     15,C00037
         BALR  14,15
         LA    0,6
         ST    0,P00033+0
         LA    1,P00033
         L     15,C00037
         BALR  14,15
         L     15,C00038
         BALR  14,15
         LA    0,T00012
         ST    0,P00033+0
         LA    0,8
         ST    0,P00033+4
         L     0,C00053
         ST    0,P00033+8
         LA    0,6
         ST    0,P00033+12
         LA    1,P00033
         L     15,C00040
         BALR  14,15
         LA    0,T00012
         ST    0,P00033+0
         LA    0,8
         ST    0,P00033+4
         LA    0,1
         ST    0,P00033+8
         L     0,C00055
         ST    0,P00033+12
         LA    0,0
         ST    0,P00033+16
         LA    1,P00033
         L     15,C00056
         BALR  14,15
         LA    0,T00008
         ST    0,P00033+0
         LA    1,P00033
         L     15,C00057
         BALR  14,15
         LA    0,T00009
         ST    0,P00033+0
         LA    1,P00033
         L     15,C00057
         BALR  14,15
         L     15,C00058
         BALR  14,15
         LA    0,6
         ST    0,P00033+0
         L     0,C00035
         ST    0,P00033+4
         LA    1,P00033
         L     15,C00036
         BALR  14,15
         L     3,T00008
         LR    0,3
         ST    0,P00033+0
         LA    1,P00033
         L     15,C00037
         BALR  14,15
         L     3,T00009
         LR    0,3
         ST    0,P00033+0
         LA    1,P00033
         L     15,C00037
         BALR  14,15
         L     15,C00038
         BALR  14,15
         LA    0,T00012
         ST    0,P00033+0
         LA    0,8
         ST    0,P00033+4
         LA    0,1
         ST    0,P00033+8
         L     0,C00060
         ST    0,P00033+12
         LA    0,2
         ST    0,P00033+16
         LA    1,P00033
         L     15,C00056
         BALR  14,15
         LR    3,15
         C     3,C00032
         LA    2,1
         BC    8,L00061
         SR    2,2
L00061   DS    0H
         LCR   4,2
         LR    2,3
         X     2,C00062
         NR    2,4
         XR    2,3
         C     3,C00063
         LA    5,1
         BC    8,L00064
         SR    5,5
L00064   DS    0H
         LCR   4,5
         LA    3,1
         XR    3,2
         NR    3,4
         XR    2,3
         LA    0,T00008
         ST    0,P00033+0
         LA    1,P00033
         L     15,C00057
         BALR  14,15
         L     15,C00058
         BALR  14,15
         LA    0,6
         ST    0,P00033+0
         L     0,C00065
         ST    0,P00033+4
         LA    1,P00033
         L     15,C00036
         BALR  14,15
         C     2,C00047
         LA    3,1
         BC    2,L00066
         SR    3,3
L00066   DS    0H
         LR    0,3
         ST    0,P00033+0
         LA    1,P00033
         L     15,C00067
         BALR  14,15
         L     15,C00038
         BALR  14,15
         B     L00027
L00022   DS    0H
         LR    5,6
         AH    5,C00068
         AH    5,C00069
         LA    2,3
         LA    3,1
L00024   DS    0H
         C     2,C00047
         BC    2,L00025
L00026   DS    0H
         AH    7,C00069
         A     6,C00070
         B     L00021
L00025   DS    0H
         LR    4,5
         AR    4,3
         SLL   4,2
         L     8,T00011(4)
         LR    0,8
         ST    0,P00033+0
         LA    1,P00033
         L     15,C00037
         BALR  14,15
         AH    3,C00071
         AH    2,C00069
         B     L00024
L00027   DS    0H
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
T00009   DS    XL8
T00010   DS    XL36
         DS    XL4
T00011   DS    XL52
         DS    XL4
T00012   DS    XL80
P00033   DS    5F
         DS    XL4
C00031   DC    F'4'
C00032   DC    F'1'
C00035   DC    A(G00034)
C00036   DC    V(F77WRBEG)
C00037   DC    V(F77WRI)
C00038   DC    V(F77WREND)
C00039   DC    A(Q00001)
C00040   DC    V(F77STRCP)
C00041   DC    F'6'
C00042   DC    A(Q00002)
C00043   DC    V(F77WRBI)
C00044   DC    A(Q00003)
C00045   DC    A(Q00004)
C00046   DC    V(F77WRA)
C00047   DC    F'0'
C00049   DC    A(G00048)
C00051   DC    A(G00050)
C00052   DC    A(Q00005)
C00053   DC    A(Q00006)
C00055   DC    A(G00054)
C00056   DC    V(F77RDBI)
C00057   DC    V(F77RDI)
C00058   DC    V(F77RDEND)
C00060   DC    A(G00059)
C00062   DC    F'-1'
C00063   DC    F'2'
C00065   DC    A(Q00007)
C00067   DC    V(F77WRL)
C00070   DC    F'3'
C00068   DC    H'-3'
C00069   DC    H'-1'
C00071   DC    H'1'
Q00001   DC    C'('' >'','
Q00002   DC    C'(I2,''I'',I3,'')'')'
Q00003   DC    C'(A,A)'
Q00004   DC    C' >'
Q00005   DC    C'( '' >'' , 2 I 4 )'
Q00006   DC    C' 12 34'
Q00007   DC    C'('' >BAD '',L1)'
G00034   CSECT
         DS    0D
         DC    X'4D7D406E7D406BF3C940F25D'
G00048   CSECT
         DS    0D
         DC    X'4DF1E76B40F440C86E40C1C26B40F240C940F35D4040'
G00050   CSECT
         DS    0D
         DC    X'4D7D406E407D7DD87D7D7D6B40C940F25D40'
G00054   CSECT
         DS    0D
         DC    X'4D40F2C940F35D91A4959240'
G00059   CSECT
         DS    0D
         DC    X'4DC8C95D40404040'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
