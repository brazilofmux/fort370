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
         LA    1,P00014
         L     15,C00015
         BALR  14,15
         LE    0,C00017
         STE   0,P00016+0
         LE    0,C00018
         STE   0,P00016+4
         LA    1,P00016
         L     15,C00019
         BALR  14,15
         LE    0,C00020
         STE   0,P00016+0
         LE    0,C00021
         STE   0,P00016+4
         LA    1,P00016
         L     15,C00019
         BALR  14,15
         LE    0,C00022
         STE   0,P00016+0
         LE    0,C00023
         STE   0,P00016+4
         LA    1,P00016
         L     15,C00019
         BALR  14,15
         L     15,C00024
         BALR  14,15
         LA    1,P00014
         L     15,C00015
         BALR  14,15
         LE    0,C00025
         STE   0,P00016+0
         LE    0,C00026
         STE   0,P00016+4
         LA    1,P00016
         L     15,C00019
         BALR  14,15
         LE    0,C00027
         STE   0,P00016+0
         LE    0,C00028
         STE   0,P00016+4
         LA    1,P00016
         L     15,C00019
         BALR  14,15
         LE    0,C00029
         STE   0,P00016+0
         LE    0,C00030
         STE   0,P00016+4
         LA    1,P00016
         L     15,C00019
         BALR  14,15
         L     15,C00024
         BALR  14,15
         LA    1,P00014
         L     15,C00015
         BALR  14,15
         LE    0,C00031
         STE   0,P00016+0
         LE    0,C00032
         STE   0,P00016+4
         LA    1,P00016
         L     15,C00019
         BALR  14,15
         L     14,C00034
         LE    0,0(,14)
         STE   0,S00000+384
         L     14,C00035
         LE    0,0(,14)
         STE   0,S00000+392
         LE    0,S00000+384
         STE   0,P00016+0
         LE    0,S00000+392
         STE   0,P00016+4
         LA    1,P00016
         L     15,C00019
         BALR  14,15
         L     15,C00024
         BALR  14,15
         LA    1,P00036
         L     15,C00015
         BALR  14,15
         LD    0,C00038
         STD   0,P00037+0
         LD    0,C00039
         STD   0,P00037+8
         LA    1,P00037
         L     15,C00040
         BALR  14,15
         LD    0,C00041
         STD   0,P00037+0
         LD    0,C00039
         STD   0,P00037+8
         LA    1,P00037
         L     15,C00040
         BALR  14,15
         L     15,C00024
         BALR  14,15
         LA    1,P00042
         L     15,C00015
         BALR  14,15
         LA    1,P00043
         L     15,C00044
         BALR  14,15
         LA    1,P00045
         L     15,C00044
         BALR  14,15
         LA    1,P00046
         L     15,C00044
         BALR  14,15
         LA    1,P00047
         L     15,C00044
         BALR  14,15
         LA    15,8
         ST    15,T00004+28
L00006   DS    0H
         LA    1,P00048
         L     15,C00044
         BALR  14,15
         L     15,C00024
         BALR  14,15
         LA    1,P00014
         L     15,C00015
         BALR  14,15
         LE    0,C00050
         STE   0,P00049+0
         LA    1,P00049
         L     15,C00051
         BALR  14,15
         LE    0,C00052
         STE   0,P00049+0
         LA    1,P00049
         L     15,C00051
         BALR  14,15
         LE    0,C00053
         STE   0,P00016+0
         LE    0,C00031
         STE   0,P00016+4
         LA    1,P00016
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
P00014   DC    F'6'
         DC    A(Q00001)
P00016   DC    A(0)
         DC    A(0)
P00036   DC    F'6'
         DC    A(Q00002)
P00037   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
P00042   DC    F'6'
         DC    A(Q00003)
P00043   DC    F'1024'
P00045   DC    F'-4'
P00046   DC    F'512'
P00047   DC    F'0'
P00048   DC    F'8'
         DS    F
P00049   DC    A(0)
         DS    XL4
C00038   DC    X'4150000000000000'
C00039   DC    X'4128000000000000'
C00041   DC    X'4160000000000000'
C00015   DC    V(F77WRBEG)
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
C00040   DC    V(F77WRZ)
C00044   DC    V(F77WRI)
C00050   DC    X'41240000'
C00051   DC    V(F77WRR)
C00052   DC    X'40400000'
C00053   DC    X'00000000'
Q00001   DC    C'(1X,''>'',6F9.4)'
Q00002   DC    C'(1X,''>'',4F12.6)'
Q00003   DC    C'(1X,''>'',5I6)'
* SIZE8
SIZE8    CSECT
         USING *,15
         B     L00057
         DC    AL1(5),CL7'SIZE8'
L00057   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00058
L00059   DC    A(S00054)
L00058   L     15,L00059
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00054,13
         ST    1,S00054+72
L00055   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         LA    15,8
         ST    15,28(,2)
         LA    0,8
L00056   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00054   DS    0D
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
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
