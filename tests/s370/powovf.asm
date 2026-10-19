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
         LH    0,C00031
         ST    0,P00029+4
         LA    1,P00029
         L     15,C00032
         BALR  14,15
         L     14,C00034
         STE   0,0(,14)
         LA    0,6
         ST    0,P00029+0
         L     0,C00035
         ST    0,P00029+4
         LA    1,P00029
         L     15,C00036
         BALR  14,15
         L     0,C00037
         ST    0,P00029+0
         LA    0,9
         ST    0,P00029+4
         LA    1,P00029
         L     15,C00038
         BALR  14,15
         L     14,C00034
         L     4,0(,14)
         LR    0,4
         ST    0,P00029+0
         LA    1,P00029
         L     15,C00039
         BALR  14,15
         L     15,C00040
         BALR  14,15
         LD    0,C00041
         STD   0,P00029+0
         LH    0,C00031
         ST    0,P00029+8
         LA    1,P00029
         L     15,C00042
         BALR  14,15
         L     14,C00028
         STD   0,0(,14)
         LA    0,6
         ST    0,P00029+0
         L     0,C00035
         ST    0,P00029+4
         LA    1,P00029
         L     15,C00036
         BALR  14,15
         L     0,C00043
         ST    0,P00029+0
         LA    0,9
         ST    0,P00029+4
         LA    1,P00029
         L     15,C00038
         BALR  14,15
         LR    5,2
         AH    5,C00044
         LA    3,4
         LA    4,2
L00012   DS    0H
         C     4,C00045
         BC    2,L00013
L00014   DS    0H
         L     15,C00040
         BALR  14,15
         LE    0,C00030
         STE   0,P00029+0
         LA    0,62
         ST    0,P00029+4
         LA    1,P00029
         L     15,C00032
         BALR  14,15
         L     14,C00034
         STE   0,0(,14)
         LA    0,6
         ST    0,P00029+0
         L     0,C00035
         ST    0,P00029+4
         LA    1,P00029
         L     15,C00036
         BALR  14,15
         L     0,C00046
         ST    0,P00029+0
         LA    0,9
         ST    0,P00029+4
         LA    1,P00029
         L     15,C00038
         BALR  14,15
         L     14,C00034
         L     4,0(,14)
         LR    0,4
         ST    0,P00029+0
         LA    1,P00029
         L     15,C00039
         BALR  14,15
         L     15,C00040
         BALR  14,15
         LD    0,C00041
         STD   0,P00029+0
         LA    0,62
         ST    0,P00029+8
         LA    1,P00029
         L     15,C00042
         BALR  14,15
         L     14,C00028
         STD   0,0(,14)
         LA    0,6
         ST    0,P00029+0
         L     0,C00035
         ST    0,P00029+4
         LA    1,P00029
         L     15,C00036
         BALR  14,15
         L     0,C00047
         ST    0,P00029+0
         LA    0,9
         ST    0,P00029+4
         LA    1,P00029
         L     15,C00038
         BALR  14,15
         LR    5,2
         AH    5,C00044
         LA    3,4
         LA    4,2
L00015   DS    0H
         C     4,C00045
         BC    2,L00016
L00017   DS    0H
         L     15,C00040
         BALR  14,15
         LE    0,C00048
         STE   0,P00029+0
         LH    0,C00049
         ST    0,P00029+4
         LA    1,P00029
         L     15,C00032
         BALR  14,15
         L     14,C00034
         STE   0,0(,14)
         LA    0,6
         ST    0,P00029+0
         L     0,C00035
         ST    0,P00029+4
         LA    1,P00029
         L     15,C00036
         BALR  14,15
         L     0,C00050
         ST    0,P00029+0
         LA    0,9
         ST    0,P00029+4
         LA    1,P00029
         L     15,C00038
         BALR  14,15
         L     14,C00034
         L     4,0(,14)
         LR    0,4
         ST    0,P00029+0
         LA    1,P00029
         L     15,C00039
         BALR  14,15
         L     15,C00040
         BALR  14,15
         LD    0,C00051
         STD   0,P00029+0
         LH    0,C00052
         ST    0,P00029+8
         LA    1,P00029
         L     15,C00042
         BALR  14,15
         L     14,C00028
         STD   0,0(,14)
         LA    0,6
         ST    0,P00029+0
         L     0,C00035
         ST    0,P00029+4
         LA    1,P00029
         L     15,C00036
         BALR  14,15
         L     0,C00053
         ST    0,P00029+0
         LA    0,9
         ST    0,P00029+4
         LA    1,P00029
         L     15,C00038
         BALR  14,15
         AH    2,C00044
         LA    3,4
         LA    4,2
L00018   DS    0H
         C     4,C00045
         BC    2,L00019
L00020   DS    0H
         L     15,C00040
         BALR  14,15
         LE    0,C00054
         STE   0,P00029+0
         LH    0,C00055
         ST    0,P00029+4
         LA    1,P00029
         L     15,C00032
         BALR  14,15
         L     14,C00034
         STE   0,0(,14)
         LA    0,6
         ST    0,P00029+0
         L     0,C00056
         ST    0,P00029+4
         LA    1,P00029
         L     15,C00036
         BALR  14,15
         L     0,C00057
         ST    0,P00029+0
         LA    0,9
         ST    0,P00029+4
         LA    1,P00029
         L     15,C00038
         BALR  14,15
         L     14,C00034
         LE    0,0(,14)
         STE   0,S00000+176
         LE    0,S00000+176
         STE   0,P00029+0
         LA    1,P00029
         L     15,C00058
         BALR  14,15
         L     14,C00034
         L     3,0(,14)
         LR    0,3
         ST    0,P00029+0
         LA    1,P00029
         L     15,C00039
         BALR  14,15
         L     15,C00040
         BALR  14,15
         LA    0,6
         ST    0,P00029+0
         L     0,C00035
         ST    0,P00029+4
         LA    1,P00029
         L     15,C00036
         BALR  14,15
         L     0,C00059
         ST    0,P00029+0
         LA    0,9
         ST    0,P00029+4
         LA    1,P00029
         L     15,C00038
         BALR  14,15
         LA    0,3
         ST    0,P00029+0
         LA    0,19
         ST    0,P00029+4
         LA    1,P00029
         L     15,C00060
         BALR  14,15
         LR    3,15
         LR    0,3
         ST    0,P00029+0
         LA    1,P00029
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
         ST    0,P00029+0
         LA    1,P00029
         L     15,C00039
         BALR  14,15
         AH    4,C00061
         A     3,C00062
         B     L00012
L00016   DS    0H
         L     7,0(3,5)
         LR    0,7
         ST    0,P00029+0
         LA    1,P00029
         L     15,C00039
         BALR  14,15
         AH    4,C00061
         A     3,C00062
         B     L00015
L00019   DS    0H
         L     6,0(3,2)
         LR    0,6
         ST    0,P00029+0
         LA    1,P00029
         L     15,C00039
         BALR  14,15
         AH    4,C00061
         A     3,C00062
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
P00029   DS    3F
         DS    XL4
C00041   DC    X'4210000000000000'
C00051   DC    X'4080000000000000'
C00028   DC    A(G00027)
C00030   DC    X'42100000'
C00032   DC    V(F77RPOWI)
C00034   DC    A(G00033)
C00035   DC    A(Q00001)
C00036   DC    V(F77WRBEG)
C00037   DC    A(Q00002)
C00038   DC    V(F77WRA)
C00039   DC    V(F77WRI)
C00040   DC    V(F77WREND)
C00042   DC    V(F77DPOWI)
C00043   DC    A(Q00003)
C00045   DC    F'0'
C00046   DC    A(Q00004)
C00047   DC    A(Q00005)
C00048   DC    X'41200000'
C00050   DC    A(Q00006)
C00053   DC    A(Q00007)
C00054   DC    X'41300000'
C00056   DC    A(Q00008)
C00057   DC    A(Q00009)
C00058   DC    V(F77WRR)
C00059   DC    A(Q00010)
C00060   DC    V(F77IPOW)
C00062   DC    F'4'
C00031   DC    H'-65'
C00044   DC    H'-4'
C00049   DC    H'-258'
C00052   DC    H'-62'
C00055   DC    H'-7'
C00061   DC    H'-1'
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
G00033   CSECT
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
