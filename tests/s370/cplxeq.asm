* main
F77MAIN  CSECT
         USING *,15
         B     L00013
         DC    AL1(7),CL7'F77MAIN'
L00013   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00014
L00015   DC    A(S00000)
L00014   L     15,L00015
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00010   DS    0H
         L     14,C00018
         MVC   0(4,14),C00016
         L     14,C00019
         MVC   0(4,14),C00016
         MVC   T00009(4),C00020
         MVC   T00002(4),C00021
         LA    1,P00022
         L     15,C00023
         BALR  14,15
         STE   0,S00000+336
         LER   0,2
         L     14,C00018
         MVC   0(4,14),S00000+336
         L     14,C00018
         STE   0,4(,14)
         LA    1,P00024
         L     15,C00025
         BALR  14,15
         L     14,C00018
         LE    0,0(,14)
         STE   0,S00000+336
         LE    0,S00000+336
         STE   0,P00026+0
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         L     14,C00019
         LE    0,0(,14)
         STE   0,S00000+336
         LE    0,S00000+336
         STE   0,P00026+0
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         L     15,C00028
         BALR  14,15
         LE    0,C00029
         LCER  0,0
         STE   0,S00000+336
         LE    0,C00030
         LCER  0,0
         STE   0,S00000+344
         LE    0,S00000+336
         STE   0,P00031+4
         LE    0,S00000+344
         STE   0,P00031+8
         LA    1,P00031
         L     15,C00032
         BALR  14,15
         LE    0,T00003
         STE   0,S00000+336
         LE    0,T00003+4
         STE   0,S00000+344
         LA    0,1
         X     0,C00033
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00034
         LER   0,0
         STE   0,S00000+352
         LE    0,S00000+352
         STE   0,P00035+4
         LE    0,C00016
         STE   0,P00035+8
         LE    0,S00000+336
         STE   0,P00035+12
         LE    0,S00000+344
         STE   0,P00035+16
         LA    1,P00035
         L     15,C00036
         BALR  14,15
         LE    0,S00000+336
         AE    0,T00004
         STE   0,S00000+352
         LE    0,S00000+344
         AE    0,T00004+4
         STE   0,S00000+360
         LE    0,S00000+352
         STE   0,P00037+4
         LE    0,S00000+360
         STE   0,P00037+8
         LE    0,C00021
         STE   0,P00037+12
         LE    0,C00016
         STE   0,P00037+16
         LA    1,P00037
         L     15,C00036
         BALR  14,15
         LE    0,T00005
         STE   0,S00000+352
         LE    0,T00005+4
         STE   0,S00000+360
         LE    0,C00029
         LCER  0,0
         LE    4,C00020
         LCER  4,4
         LE    6,C00030
         MER   6,4
         LE    2,C00016
         MER   2,0
         STD   4,S00000+96
         LER   4,6
         SER   4,2
         STE   4,S00000+368
         LD    4,S00000+96
         LE    2,C00030
         ME    2,C00016
         MER   0,4
         LER   4,2
         AER   4,0
         STE   4,S00000+376
         LE    0,S00000+368
         STE   0,P00038+4
         LE    0,S00000+376
         STE   0,P00038+8
         LA    1,P00038
         L     15,C00039
         BALR  14,15
         LE    2,S00000+352
         SE    2,T00006
         LE    0,S00000+360
         SE    0,T00006+4
         L     14,C00041
         STE   2,0(,14)
         L     14,C00042
         STE   0,0(,14)
         LA    1,P00024
         L     15,C00025
         BALR  14,15
         L     14,C00041
         LE    0,0(,14)
         STE   0,S00000+368
         LE    0,S00000+368
         STE   0,P00026+0
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         L     14,C00042
         LE    0,0(,14)
         STE   0,S00000+368
         LE    0,S00000+368
         STE   0,P00026+0
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         L     15,C00028
         BALR  14,15
         LA    0,1
         X     0,C00033
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00034
         LER   0,0
         STE   0,S00000+368
         LE    0,S00000+368
         STE   0,P00043+4
         LE    0,C00016
         STE   0,P00043+8
         LE    0,S00000+336
         STE   0,P00043+12
         LE    0,S00000+344
         STE   0,P00043+16
         LA    1,P00043
         L     15,C00036
         BALR  14,15
         LE    2,T00007
         LE    0,T00007+4
         L     14,C00041
         STE   2,0(,14)
         L     14,C00042
         STE   0,0(,14)
         LA    1,P00024
         L     15,C00025
         BALR  14,15
         L     14,C00041
         LE    0,0(,14)
         STE   0,S00000+368
         LE    0,S00000+368
         STE   0,P00026+0
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         L     14,C00042
         LE    0,0(,14)
         STE   0,S00000+368
         LE    0,S00000+368
         STE   0,P00026+0
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         L     15,C00028
         BALR  14,15
         LA    0,1
         X     0,C00033
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00034
         LER   0,0
         STE   0,S00000+368
         LE    0,S00000+368
         STE   0,P00044+4
         LE    0,C00016
         STE   0,P00044+8
         LE    0,S00000+336
         STE   0,P00044+12
         LE    0,S00000+344
         STE   0,P00044+16
         LA    1,P00044
         L     15,C00036
         BALR  14,15
         LE    2,S00000+336
         AE    2,T00008
         LE    0,S00000+344
         AE    0,T00008+4
         L     14,C00041
         STE   2,0(,14)
         L     14,C00042
         STE   0,0(,14)
         LA    1,P00024
         L     15,C00025
         BALR  14,15
         L     14,C00041
         LE    0,0(,14)
         STE   0,S00000+336
         LE    0,S00000+336
         STE   0,P00026+0
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         L     14,C00042
         LE    0,0(,14)
         STE   0,S00000+336
         LE    0,S00000+336
         STE   0,P00026+0
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         L     15,C00028
         BALR  14,15
         L     14,C00041
         MVC   0(4,14),S00000+352
         L     14,C00042
         MVC   0(4,14),S00000+360
         LA    1,P00024
         L     15,C00025
         BALR  14,15
         L     14,C00041
         LE    0,0(,14)
         STE   0,S00000+336
         LE    0,S00000+336
         STE   0,P00026+0
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         L     14,C00042
         LE    0,0(,14)
         STE   0,S00000+336
         LE    0,S00000+336
         STE   0,P00026+0
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         L     15,C00028
         BALR  14,15
L00011   DS    0H
L00012   DS    0H
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
T00003   DS    XL8
T00004   DS    XL8
T00005   DS    XL8
T00006   DS    XL8
T00007   DS    XL8
T00008   DS    XL8
T00009   DS    XL104
         DS    6D
P00022   DC    A(T00009)
         DC    XL1'80',AL3(T00002)
P00024   DC    F'6'
         DC    A(Q00001)
P00026   DC    A(0)
         DS    F
P00031   DC    A(T00003)
         DC    A(0)
         DC    A(0)
         DS    F
P00035   DC    A(T00004)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DS    F
P00037   DC    A(T00005)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DS    F
P00038   DC    A(T00006)
         DC    A(0)
         DC    A(0)
         DS    F
P00043   DC    A(T00007)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DS    F
P00044   DC    A(T00008)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DS    XL4
C00034   DC    X'4E00000080000000'
C00016   DC    X'00000000'
C00018   DC    A(G00017)
C00019   DC    A(G00017+4)
C00020   DC    X'41100000'
C00021   DC    X'41200000'
C00023   DC    V(ZF724)
C00025   DC    V(F77WRBEG)
C00027   DC    V(F77WRR)
C00028   DC    V(F77WREND)
C00029   DC    X'41180000'
C00030   DC    X'412C0000'
C00032   DC    V(F77CEXP)
C00033   DC    F'-2147483648'
C00036   DC    V(F77CDIV)
C00039   DC    V(F77CCOS)
C00041   DC    A(G00040)
C00042   DC    A(G00040+4)
Q00001   DC    C'('' >'',2F12.5)'
* ZF724
ZF724    CSECT
         USING *,15
         B     L00049
         DC    AL1(5),CL7'ZF724'
L00049   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00050
L00051   DC    A(S00045)
L00050   L     15,L00051
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00045,13
         ST    1,S00045+72
L00046   DS    0H
         L     3,0(,1)
         L     2,4(,1)
         LA    2,0(,2)
         LE    0,0(,2)
         LE    2,0(,3)
         AER   2,0
         AER   0,0
         LER   4,0
         LER   0,2
         LER   2,4
         B     L00048
L00047   DS    0H
L00048   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00045   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
G00040   CSECT
         DS    0D
         DS    XL8
G00017   CSECT
         DS    0D
         DS    XL8
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
