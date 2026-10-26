* main
F77MAIN  CSECT
         USING *,15
         B     L00012
         DC    AL1(7),CL7'F77MAIN'
L00012   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00013
L00014   DC    A(S00000)
L00013   L     15,L00014
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00009   DS    0H
         LE    0,C00015
         AE    0,C00016
         STE   0,S00000+296
         LE    0,C00016
         AE    0,C00017
         STE   0,S00000+304
         LE    0,S00000+296
         STE   0,P00018+4
         LE    0,S00000+304
         STE   0,P00018+8
         LA    1,P00018
         L     15,C00019
         BALR  14,15
         LE    0,C00020
         DE    0,C00021
         STE   0,S00000+296
         LE    0,C00016
         STE   0,P00022+4
         LE    0,S00000+296
         STE   0,P00022+8
         LA    1,P00022
         L     15,C00019
         BALR  14,15
         LE    0,T00002
         STE   0,S00000+296
         LE    0,T00002+4
         STE   0,S00000+304
         LE    0,C00024
         STE   0,P00023+0
         LA    1,P00023
         L     15,C00025
         BALR  14,15
         STE   0,S00000+312
         LE    0,C00026
         AE    0,C00027
         STE   0,S00000+320
         LE    0,S00000+320
         STE   0,P00023+0
         LA    1,P00023
         L     15,C00028
         BALR  14,15
         LER   4,0
         LE    2,S00000+296
         SE    2,S00000+312
         LE    0,S00000+304
         SER   0,4
         L     14,C00030
         STE   2,0(,14)
         L     14,C00031
         STE   0,0(,14)
         LA    1,P00032
         L     15,C00033
         BALR  14,15
         L     14,C00030
         LE    0,0(,14)
         STE   0,S00000+296
         LE    0,S00000+296
         STE   0,P00034+0
         LA    1,P00034
         L     15,C00035
         BALR  14,15
         L     14,C00031
         LE    0,0(,14)
         STE   0,S00000+296
         LE    0,S00000+296
         STE   0,P00034+0
         LA    1,P00034
         L     15,C00035
         BALR  14,15
         L     15,C00036
         BALR  14,15
         LE    0,C00037
         LCER  0,0
         STE   0,S00000+296
         LE    0,C00026
         LCER  0,0
         STE   0,S00000+304
         LE    0,S00000+296
         STE   0,P00038+4
         LE    0,S00000+304
         STE   0,P00038+8
         LA    1,P00038
         L     15,C00019
         BALR  14,15
         LE    0,T00003
         STE   0,S00000+296
         LE    0,T00003+4
         STE   0,S00000+304
         LA    0,1
         X     0,C00039
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00040
         LER   0,0
         STE   0,S00000+312
         LE    0,S00000+312
         STE   0,P00041+4
         LE    0,C00016
         STE   0,P00041+8
         LE    0,S00000+296
         STE   0,P00041+12
         LE    0,S00000+304
         STE   0,P00041+16
         LA    1,P00041
         L     15,C00042
         BALR  14,15
         LE    0,S00000+296
         AE    0,T00004
         STE   0,S00000+312
         LE    0,S00000+304
         AE    0,T00004+4
         STE   0,S00000+296
         LE    0,S00000+312
         STE   0,P00043+4
         LE    0,S00000+296
         STE   0,P00043+8
         LE    0,C00044
         STE   0,P00043+12
         LE    0,C00016
         STE   0,P00043+16
         LA    1,P00043
         L     15,C00042
         BALR  14,15
         LE    0,T00005
         STE   0,S00000+296
         LE    0,T00005+4
         STE   0,S00000+304
         LE    0,C00037
         LCER  0,0
         LE    4,C00027
         LCER  4,4
         LE    6,C00026
         MER   6,4
         LE    2,C00016
         MER   2,0
         STD   4,S00000+96
         LER   4,6
         SER   4,2
         STE   4,S00000+312
         LD    4,S00000+96
         LE    2,C00026
         ME    2,C00016
         MER   0,4
         LER   4,2
         AER   4,0
         STE   4,S00000+320
         LE    0,S00000+312
         STE   0,P00045+4
         LE    0,S00000+320
         STE   0,P00045+8
         LA    1,P00045
         L     15,C00046
         BALR  14,15
         LE    2,S00000+296
         SE    2,T00006
         LE    0,S00000+304
         SE    0,T00006+4
         L     14,C00030
         STE   2,0(,14)
         L     14,C00031
         STE   0,0(,14)
         LA    1,P00032
         L     15,C00033
         BALR  14,15
         L     14,C00030
         LE    0,0(,14)
         STE   0,S00000+296
         LE    0,S00000+296
         STE   0,P00034+0
         LA    1,P00034
         L     15,C00035
         BALR  14,15
         L     14,C00031
         LE    0,0(,14)
         STE   0,S00000+296
         LE    0,S00000+296
         STE   0,P00034+0
         LA    1,P00034
         L     15,C00035
         BALR  14,15
         L     15,C00036
         BALR  14,15
         LE    0,C00047
         SE    0,C00047
         STE   0,S00000+296
         LE    0,C00047
         SE    0,C00016
         STE   0,S00000+304
         LE    0,S00000+296
         STE   0,P00048+4
         LE    0,S00000+304
         STE   0,P00048+8
         LA    1,P00048
         L     15,C00019
         BALR  14,15
         LE    0,T00007
         STE   0,S00000+296
         LE    0,T00007+4
         STE   0,S00000+304
         LE    0,S00000+296
         STE   0,P00049+0
         LE    0,S00000+304
         STE   0,P00049+4
         LA    1,P00049
         L     15,C00050
         BALR  14,15
         STE   0,S00000+312
         LE    0,C00016
         STE   0,P00023+0
         LA    1,P00023
         L     15,C00025
         BALR  14,15
         LER   2,0
         LE    0,S00000+312
         SER   0,2
         L     14,C00030
         STE   0,0(,14)
         L     14,C00031
         MVC   0(4,14),C00016
         LA    1,P00032
         L     15,C00033
         BALR  14,15
         L     14,C00030
         LE    0,0(,14)
         STE   0,S00000+296
         LE    0,S00000+296
         STE   0,P00034+0
         LA    1,P00034
         L     15,C00035
         BALR  14,15
         L     14,C00031
         LE    0,0(,14)
         STE   0,S00000+296
         LE    0,S00000+296
         STE   0,P00034+0
         LA    1,P00034
         L     15,C00035
         BALR  14,15
         L     15,C00036
         BALR  14,15
L00010   DS    0H
L00011   DS    0H
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
T00002   DS    XL8
T00003   DS    XL8
T00004   DS    XL8
T00005   DS    XL8
T00006   DS    XL8
T00007   DS    XL8
T00008   DS    XL68
         DS    XL4
         DS    4D
P00018   DC    A(T00008)
         DC    A(0)
         DC    A(0)
         DS    F
P00022   DC    A(T00002)
         DC    A(0)
         DC    A(0)
         DS    F
P00023   DC    A(0)
         DC    F'0'
P00032   DC    F'6'
         DC    A(Q00001)
P00034   DC    A(0)
         DS    F
P00038   DC    A(T00003)
         DC    A(0)
         DC    A(0)
         DS    F
P00041   DC    A(T00004)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DS    F
P00043   DC    A(T00005)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DS    F
P00045   DC    A(T00006)
         DC    A(0)
         DC    A(0)
         DS    F
P00048   DC    A(T00007)
         DC    A(0)
         DC    A(0)
         DS    F
P00049   DC    A(0)
         DC    A(0)
C00040   DC    X'4E00000080000000'
C00015   DC    X'40100000'
C00016   DC    X'00000000'
C00017   DC    X'41120000'
C00019   DC    V(F77CEXP)
C00020   DC    X'42258000'
C00021   DC    X'41A00000'
C00024   DC    X'413C0000'
C00025   DC    V(COS)
C00026   DC    X'412C0000'
C00027   DC    X'41100000'
C00028   DC    V(SIN)
C00030   DC    A(G00029)
C00031   DC    A(G00029+4)
C00033   DC    V(F77WRBEG)
C00035   DC    V(F77WRR)
C00036   DC    V(F77WREND)
C00037   DC    X'41180000'
C00039   DC    F'-2147483648'
C00042   DC    V(F77CDIV)
C00044   DC    X'41200000'
C00046   DC    V(F77CCOS)
C00047   DC    X'41340000'
C00050   DC    V(F77CABS)
Q00001   DC    C'('' >'',2F12.5)'
G00029   CSECT
         DS    0D
         DS    XL8
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
