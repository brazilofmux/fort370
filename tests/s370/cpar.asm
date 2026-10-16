* main
F77MAIN  CSECT
         USING *,15
         B     L00011
         DC    AL1(7),CL7'F77MAIN'
L00011   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00012
L00013   DC    A(S00000)
L00012   L     15,L00013
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00005   DS    0H
         LA    0,6
         ST    0,P00014+0
         L     0,C00015
         ST    0,P00014+4
         LA    1,P00014
         L     15,C00016
         BALR  14,15
         LE    0,C00017
         STE   0,P00014+0
         LE    0,C00018
         STE   0,P00014+4
         LA    1,P00014
         L     15,C00019
         BALR  14,15
         LE    0,C00020
         STE   0,P00014+0
         LE    0,C00021
         STE   0,P00014+4
         LA    1,P00014
         L     15,C00019
         BALR  14,15
         LE    0,C00022
         STE   0,P00014+0
         LE    0,C00023
         STE   0,P00014+4
         LA    1,P00014
         L     15,C00019
         BALR  14,15
         L     15,C00024
         BALR  14,15
         LA    0,6
         ST    0,P00014+0
         L     0,C00015
         ST    0,P00014+4
         LA    1,P00014
         L     15,C00016
         BALR  14,15
         LE    0,C00025
         STE   0,P00014+0
         LE    0,C00026
         STE   0,P00014+4
         LA    1,P00014
         L     15,C00019
         BALR  14,15
         LE    0,C00027
         STE   0,P00014+0
         LE    0,C00028
         STE   0,P00014+4
         LA    1,P00014
         L     15,C00019
         BALR  14,15
         LE    0,C00029
         STE   0,P00014+0
         LE    0,C00030
         STE   0,P00014+4
         LA    1,P00014
         L     15,C00019
         BALR  14,15
         L     15,C00024
         BALR  14,15
         LA    0,6
         ST    0,P00014+0
         L     0,C00015
         ST    0,P00014+4
         LA    1,P00014
         L     15,C00016
         BALR  14,15
         LE    0,C00031
         STE   0,P00014+0
         LE    0,C00032
         STE   0,P00014+4
         LA    1,P00014
         L     15,C00019
         BALR  14,15
         L     14,C00034
         LE    0,0(,14)
         STE   0,S00000+384
         L     14,C00035
         LE    0,0(,14)
         STE   0,S00000+392
         LE    0,S00000+384
         STE   0,P00014+0
         LE    0,S00000+392
         STE   0,P00014+4
         LA    1,P00014
         L     15,C00019
         BALR  14,15
         L     15,C00024
         BALR  14,15
         LA    0,6
         ST    0,P00014+0
         L     0,C00036
         ST    0,P00014+4
         LA    1,P00014
         L     15,C00016
         BALR  14,15
         LD    0,C00037
         STD   0,P00014+0
         LD    0,C00038
         STD   0,P00014+8
         LA    1,P00014
         L     15,C00039
         BALR  14,15
         LD    0,C00040
         STD   0,P00014+0
         LD    0,C00038
         STD   0,P00014+8
         LA    1,P00014
         L     15,C00039
         BALR  14,15
         L     15,C00024
         BALR  14,15
         LA    0,6
         ST    0,P00014+0
         L     0,C00041
         ST    0,P00014+4
         LA    1,P00014
         L     15,C00016
         BALR  14,15
         LA    0,1024
         ST    0,P00014+0
         LA    1,P00014
         L     15,C00042
         BALR  14,15
         LH    0,C00043
         ST    0,P00014+0
         LA    1,P00014
         L     15,C00042
         BALR  14,15
         LA    0,512
         ST    0,P00014+0
         LA    1,P00014
         L     15,C00042
         BALR  14,15
         LA    0,0
         ST    0,P00014+0
         LA    1,P00014
         L     15,C00042
         BALR  14,15
         LA    15,8
         ST    15,T00004+28
L00006   DS    0H
         LA    0,8
         ST    0,P00014+0
         LA    1,P00014
         L     15,C00042
         BALR  14,15
         L     15,C00024
         BALR  14,15
         LA    0,6
         ST    0,P00014+0
         L     0,C00015
         ST    0,P00014+4
         LA    1,P00014
         L     15,C00016
         BALR  14,15
         LE    0,C00044
         STE   0,P00014+0
         LA    1,P00014
         L     15,C00045
         BALR  14,15
         LE    0,C00046
         STE   0,P00014+0
         LA    1,P00014
         L     15,C00045
         BALR  14,15
         LE    0,C00047
         STE   0,P00014+0
         LE    0,C00031
         STE   0,P00014+4
         LA    1,P00014
         L     15,C00019
         BALR  14,15
         L     15,C00024
         BALR  14,15
L00007   DS    0H
L00008   DS    0H
L00009   DS    0H
L00010   DS    0H
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
T00004   DS    XL204
         DS    XL4
         DS    2D
P00014   DS    4F
C00037   DC    X'4150000000000000'
C00038   DC    X'4128000000000000'
C00040   DC    X'4160000000000000'
C00015   DC    A(Q00001)
C00016   DC    V(F77WRBEG)
C00017   DC    X'C1500000'
C00018   DC    X'41A00000'
C00019   DC    V(F77WRC)
C00020   DC    X'4070A3D7'
C00021   DC    X'40147AE1'
C00022   DC    X'41380000'
C00023   DC    X'415C0000'
C00024   DC    V(F77WREND)
C00025   DC    X'41400000'
C00026   DC    X'C1200000'
C00027   DC    X'C1680000'
C00028   DC    X'C11C0000'
C00029   DC    X'40800000'
C00030   DC    X'41100000'
C00031   DC    X'41200000'
C00032   DC    X'C1100000'
C00034   DC    A(G00033)
C00035   DC    A(G00033+4)
C00036   DC    A(Q00002)
C00039   DC    V(F77WRZ)
C00041   DC    A(Q00003)
C00042   DC    V(F77WRI)
C00044   DC    X'41240000'
C00045   DC    V(F77WRR)
C00046   DC    X'40400000'
C00047   DC    X'00000000'
C00043   DC    H'-4'
Q00001   DC    C'(1X,''>'',6F9.4)'
Q00002   DC    C'(1X,''>'',4F12.6)'
Q00003   DC    C'(1X,''>'',5I6)'
* SIZE8
SIZE8    CSECT
         USING *,15
         B     L00051
         DC    AL1(5),CL7'SIZE8'
L00051   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00052
L00053   DC    A(S00048)
L00052   L     15,L00053
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00048,13
         ST    1,S00048+72
L00049   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         LA    15,8
         ST    15,28(,2)
         LA    0,8
L00050   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00048   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
G00033   CSECT
         DS    0D
         DC    X'C150000041A00000'
         END
