* main
F77MAIN  CSECT
         USING *,15
         B     L00024
         DC    AL1(7),CL7'F77MAIN'
L00024   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00025
L00026   DC    A(S00000)
L00025   L     15,L00026
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00011   DS    0H
         L     2,C00028
         LE    0,C00030
         STE   0,P00029+0
         LA    1,P00029
         L     15,C00031
         BALR  14,15
         L     14,C00033
         STE   0,0(,14)
         LA    1,P00034
         L     15,C00035
         BALR  14,15
         LA    1,P00036
         L     15,C00037
         BALR  14,15
         L     14,C00033
         L     4,0(,14)
         LR    0,4
         ST    0,P00038+0
         LA    1,P00038
         L     15,C00039
         BALR  14,15
         L     15,C00040
         BALR  14,15
         LD    0,C00042
         STD   0,P00041+0
         LA    1,P00041
         L     15,C00043
         BALR  14,15
         L     14,C00028
         STD   0,0(,14)
         LA    1,P00034
         L     15,C00035
         BALR  14,15
         LA    1,P00044
         L     15,C00037
         BALR  14,15
         LR    5,2
         AH    5,C00045
         LA    3,4
         LA    4,2
L00012   DS    0H
         C     4,C00046
         BC    2,L00013
L00014   DS    0H
         L     15,C00040
         BALR  14,15
         LE    0,C00030
         STE   0,P00047+0
         LA    1,P00047
         L     15,C00031
         BALR  14,15
         L     14,C00033
         STE   0,0(,14)
         LA    1,P00034
         L     15,C00035
         BALR  14,15
         LA    1,P00048
         L     15,C00037
         BALR  14,15
         L     14,C00033
         L     4,0(,14)
         LR    0,4
         ST    0,P00038+0
         LA    1,P00038
         L     15,C00039
         BALR  14,15
         L     15,C00040
         BALR  14,15
         LD    0,C00042
         STD   0,P00049+0
         LA    1,P00049
         L     15,C00043
         BALR  14,15
         L     14,C00028
         STD   0,0(,14)
         LA    1,P00034
         L     15,C00035
         BALR  14,15
         LA    1,P00050
         L     15,C00037
         BALR  14,15
         LR    5,2
         AH    5,C00045
         LA    3,4
         LA    4,2
L00015   DS    0H
         C     4,C00046
         BC    2,L00016
L00017   DS    0H
         L     15,C00040
         BALR  14,15
         LE    0,C00052
         STE   0,P00051+0
         LA    1,P00051
         L     15,C00031
         BALR  14,15
         L     14,C00033
         STE   0,0(,14)
         LA    1,P00034
         L     15,C00035
         BALR  14,15
         LA    1,P00053
         L     15,C00037
         BALR  14,15
         L     14,C00033
         L     4,0(,14)
         LR    0,4
         ST    0,P00038+0
         LA    1,P00038
         L     15,C00039
         BALR  14,15
         L     15,C00040
         BALR  14,15
         LD    0,C00055
         STD   0,P00054+0
         LA    1,P00054
         L     15,C00043
         BALR  14,15
         L     14,C00028
         STD   0,0(,14)
         LA    1,P00034
         L     15,C00035
         BALR  14,15
         LA    1,P00056
         L     15,C00037
         BALR  14,15
         AH    2,C00045
         LA    3,4
         LA    4,2
L00018   DS    0H
         C     4,C00046
         BC    2,L00019
L00020   DS    0H
         L     15,C00040
         BALR  14,15
         LE    0,C00058
         STE   0,P00057+0
         LA    1,P00057
         L     15,C00031
         BALR  14,15
         L     14,C00033
         STE   0,0(,14)
         LA    1,P00059
         L     15,C00035
         BALR  14,15
         LA    1,P00060
         L     15,C00037
         BALR  14,15
         L     14,C00033
         LE    0,0(,14)
         STE   0,S00000+176
         LE    0,S00000+176
         STE   0,P00061+0
         LA    1,P00061
         L     15,C00062
         BALR  14,15
         L     14,C00033
         L     3,0(,14)
         LR    0,3
         ST    0,P00038+0
         LA    1,P00038
         L     15,C00039
         BALR  14,15
         L     15,C00040
         BALR  14,15
         LA    1,P00034
         L     15,C00035
         BALR  14,15
         LA    1,P00063
         L     15,C00037
         BALR  14,15
         LA    1,P00064
         L     15,C00065
         BALR  14,15
         LR    3,15
         LR    0,3
         ST    0,P00038+0
         LA    1,P00038
         L     15,C00039
         BALR  14,15
         L     15,C00040
         BALR  14,15
L00021   DS    0H
L00022   DS    0H
         B     L00023
L00013   DS    0H
         L     7,0(3,5)
         LR    0,7
         ST    0,P00038+0
         LA    1,P00038
         L     15,C00039
         BALR  14,15
         AH    4,C00066
         A     3,C00067
         B     L00012
L00016   DS    0H
         L     7,0(3,5)
         LR    0,7
         ST    0,P00038+0
         LA    1,P00038
         L     15,C00039
         BALR  14,15
         AH    4,C00066
         A     3,C00067
         B     L00015
L00019   DS    0H
         L     6,0(3,2)
         LR    0,6
         ST    0,P00038+0
         LA    1,P00038
         L     15,C00039
         BALR  14,15
         AH    4,C00066
         A     3,C00067
         B     L00018
L00023   DS    0H
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
         DS    1D
P00029   DC    A(0)
         DC    F'-65'
P00034   DC    F'6'
         DC    A(Q00001)
P00036   DC    A(Q00002)
         DC    F'9'
P00038   DC    A(0)
         DS    F
P00041   DC    A(0)
         DC    A(0)
         DC    F'-65'
P00044   DC    A(Q00003)
         DC    F'9'
         DS    F
P00047   DC    A(0)
         DC    F'62'
P00048   DC    A(Q00004)
         DC    F'9'
P00049   DC    A(0)
         DC    A(0)
         DC    F'62'
P00050   DC    A(Q00005)
         DC    F'9'
         DS    F
P00051   DC    A(0)
         DC    F'-258'
P00053   DC    A(Q00006)
         DC    F'9'
P00054   DC    A(0)
         DC    A(0)
         DC    F'-62'
P00056   DC    A(Q00007)
         DC    F'9'
         DS    F
P00057   DC    A(0)
         DC    F'-7'
P00059   DC    F'6'
         DC    A(Q00008)
P00060   DC    A(Q00009)
         DC    F'9'
P00061   DC    A(0)
P00063   DC    A(Q00010)
         DC    F'9'
P00064   DC    F'3'
         DC    F'19'
         DS    XL4
C00042   DC    X'4210000000000000'
C00055   DC    X'4080000000000000'
C00028   DC    A(G00027)
C00030   DC    X'42100000'
C00031   DC    V(F77RPOWI)
C00033   DC    A(G00032)
C00035   DC    V(F77WRBEG)
C00037   DC    V(F77WRA)
C00039   DC    V(F77WRI)
C00040   DC    V(F77WREND)
C00043   DC    V(F77DPOWI)
C00046   DC    F'0'
C00052   DC    X'41200000'
C00058   DC    X'41300000'
C00062   DC    V(F77WRR)
C00065   DC    V(F77IPOW)
C00067   DC    F'4'
C00045   DC    H'-4'
C00066   DC    H'-1'
Q00001   DC    C'('' >'',A,2I12)'
Q00008   DC    C'('' >'',A,E14.7,I12)'
Q00002   DC    C'R 16**-65'
Q00003   DC    C'D 16**-65'
Q00004   DC    C'R 16**62 '
Q00005   DC    C'D 16**62 '
Q00006   DC    C'R 2**-258'
Q00007   DC    C'D .5**-62'
Q00009   DC    C'R 3**-7  '
Q00010   DC    C'I 3**19  '
G00032   CSECT
         DS    0D
         DS    XL4
G00027   CSECT
         DS    0D
         DS    XL8
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
