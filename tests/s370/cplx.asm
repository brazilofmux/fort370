* main
F77MAIN  CSECT
         USING *,15
         B     L00017
         DC    AL1(7),CL7'F77MAIN'
L00017   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00018
L00019   DC    A(S00000)
L00018   L     15,L00019
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00012   DS    0H
         LE    2,C00020
         AE    2,C00021
         LE    0,C00021
         AE    0,C00021
L00013   DS    0H
         STE   2,T00010
         STE   0,T00010+4
         LA    1,P00022
         L     15,C00023
         BALR  14,15
         LE    0,T00010
         STE   0,S00000+368
         LE    0,T00010+4
         STE   0,S00000+376
         LE    0,S00000+368
         STE   0,P00024+0
         LE    0,S00000+376
         STE   0,P00024+4
         LA    1,P00024
         L     15,C00025
         BALR  14,15
         L     15,C00026
         BALR  14,15
         LE    0,C00027
         LCER  0,0
         STE   0,S00000+368
         LE    0,C00028
         LCER  0,0
         STE   0,S00000+376
         LE    0,S00000+368
         STE   0,P00029+4
         LE    0,S00000+376
         STE   0,P00029+8
         LA    1,P00029
         L     15,C00030
         BALR  14,15
         LE    0,T00011
         STE   0,S00000+368
         LE    0,T00011+4
         STE   0,S00000+376
         LA    1,P00022
         L     15,C00023
         BALR  14,15
         LE    0,S00000+368
         STE   0,P00024+0
         LE    0,S00000+376
         STE   0,P00024+4
         LA    1,P00024
         L     15,C00025
         BALR  14,15
         L     15,C00026
         BALR  14,15
         LE    0,C00020
         STE   0,P00031+4
         LE    0,C00032
         STE   0,P00031+8
         LE    0,S00000+368
         STE   0,P00031+12
         LE    0,S00000+376
         STE   0,P00031+16
         LA    1,P00031
         L     15,C00033
         BALR  14,15
         LE    0,S00000+368
         AE    0,T00003
         STE   0,S00000+384
         LE    0,S00000+376
         AE    0,T00003+4
         STE   0,S00000+368
         LE    0,S00000+384
         STE   0,P00034+4
         LE    0,S00000+368
         STE   0,P00034+8
         LE    0,C00021
         STE   0,P00034+12
         LE    0,C00032
         STE   0,P00034+16
         LA    1,P00034
         L     15,C00033
         BALR  14,15
         LE    0,T00004
         STE   0,S00000+368
         LE    0,T00004+4
         STE   0,S00000+376
         LA    1,P00022
         L     15,C00023
         BALR  14,15
         LE    0,S00000+368
         STE   0,P00024+0
         LE    0,S00000+376
         STE   0,P00024+4
         LA    1,P00024
         L     15,C00025
         BALR  14,15
         L     15,C00026
         BALR  14,15
         LE    0,C00027
         LCER  0,0
         LE    4,C00020
         LCER  4,4
         LE    6,C00028
         MER   6,4
         LE    2,C00032
         MER   2,0
         STD   4,S00000+96
         LER   4,6
         SER   4,2
         STE   4,S00000+368
         LD    4,S00000+96
         LE    2,C00028
         ME    2,C00032
         MER   0,4
         LER   4,2
         AER   4,0
         STE   4,S00000+376
         LE    0,S00000+368
         STE   0,P00035+4
         LE    0,S00000+376
         STE   0,P00035+8
         LA    1,P00035
         L     15,C00036
         BALR  14,15
         LE    2,T00005
         LE    0,T00005+4
         STE   2,T00010
         STE   0,T00010+4
         LA    1,P00022
         L     15,C00023
         BALR  14,15
         LE    0,T00010
         STE   0,S00000+368
         LE    0,T00010+4
         STE   0,S00000+376
         LE    0,S00000+368
         STE   0,P00024+0
         LE    0,S00000+376
         STE   0,P00024+4
         LA    1,P00024
         L     15,C00025
         BALR  14,15
         L     15,C00026
         BALR  14,15
         LE    2,C00020
         AE    2,C00021
         LE    0,C00021
         AE    0,C00021
         STE   2,T00010
         STE   0,T00010+4
         LA    1,P00022
         L     15,C00023
         BALR  14,15
         LE    0,T00010
         STE   0,S00000+368
         LE    0,T00010+4
         STE   0,S00000+376
         LE    0,S00000+368
         STE   0,P00024+0
         LE    0,S00000+376
         STE   0,P00024+4
         LA    1,P00024
         L     15,C00025
         BALR  14,15
         L     15,C00026
         BALR  14,15
         LE    0,C00038
         STE   0,P00037+4
         LE    0,C00039
         STE   0,P00037+8
         LA    1,P00037
         L     15,C00040
         BALR  14,15
         LE    0,T00006
         STE   0,S00000+368
         LE    0,T00006+4
         STE   0,S00000+376
         LE    0,C00020
         STE   0,P00041+4
         LE    0,C00020
         STE   0,P00041+8
         LA    1,P00041
         L     15,C00042
         BALR  14,15
         LE    0,T00007
         STE   0,S00000+384
         LE    0,T00007+4
         STE   0,S00000+392
         LE    0,C00020
         STE   0,P00043+4
         LE    0,C00021
         STE   0,P00043+8
         LA    1,P00043
         L     15,C00044
         BALR  14,15
         LE    0,T00008
         STE   0,S00000+400
         LE    0,T00008+4
         STE   0,S00000+408
         LA    1,P00022
         L     15,C00023
         BALR  14,15
         LE    0,S00000+368
         STE   0,P00024+0
         LE    0,S00000+376
         STE   0,P00024+4
         LA    1,P00024
         L     15,C00025
         BALR  14,15
         LE    0,S00000+384
         STE   0,P00024+0
         LE    0,S00000+392
         STE   0,P00024+4
         LA    1,P00024
         L     15,C00025
         BALR  14,15
         LE    0,S00000+400
         STE   0,P00024+0
         LE    0,S00000+408
         STE   0,P00024+4
         LA    1,P00024
         L     15,C00025
         BALR  14,15
         L     15,C00026
         BALR  14,15
         LE    0,C00038
         STE   0,P00024+0
         LE    0,C00039
         STE   0,P00024+4
         LA    1,P00024
         L     15,C00045
         BALR  14,15
         STE   0,S00000+368
         LE    0,T00010
         STE   0,S00000+376
         LE    0,T00010+4
         STE   0,S00000+384
         LA    1,P00046
         L     15,C00023
         BALR  14,15
         LE    0,S00000+368
         STE   0,P00047+0
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         LE    0,S00000+376
         STE   0,P00047+0
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         LE    0,S00000+384
         STE   0,P00047+0
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         L     15,C00026
         BALR  14,15
         LE    2,C00020
         ME    2,C00038
         LE    0,C00021
         ME    0,C00039
         LER   4,2
         SER   4,0
         STE   4,S00000+368
         LE    2,C00020
         ME    2,C00039
         LE    0,C00021
         ME    0,C00038
         LER   4,2
         AER   4,0
         STE   4,S00000+376
         MVC   T00010(4),S00000+368
         MVC   T00010+4(4),S00000+376
         LE    0,S00000+368
         STE   0,P00049+4
         LE    0,S00000+376
         STE   0,P00049+8
         LE    0,C00038
         STE   0,P00049+12
         LE    0,C00039
         STE   0,P00049+16
         LA    1,P00049
         L     15,C00033
         BALR  14,15
         LE    0,T00009
         STE   0,S00000+368
         LE    0,T00009+4
         STE   0,S00000+376
         LE    0,T00010
         STE   0,S00000+384
         LE    0,T00010+4
         LER   2,0
         LCER  2,2
         STE   2,S00000+392
         LA    1,P00022
         L     15,C00023
         BALR  14,15
         LE    0,T00010
         STE   0,S00000+400
         LE    0,T00010+4
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00024+0
         LE    0,S00000+408
         STE   0,P00024+4
         LA    1,P00024
         L     15,C00025
         BALR  14,15
         LE    0,S00000+368
         STE   0,P00024+0
         LE    0,S00000+376
         STE   0,P00024+4
         LA    1,P00024
         L     15,C00025
         BALR  14,15
         LE    0,S00000+384
         STE   0,P00024+0
         LE    0,S00000+392
         STE   0,P00024+4
         LA    1,P00024
         L     15,C00025
         BALR  14,15
         L     15,C00026
         BALR  14,15
L00014   DS    0H
L00015   DS    0H
L00016   DS    0H
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
T00003   DS    XL8
T00004   DS    XL8
T00005   DS    XL8
T00006   DS    XL8
T00007   DS    XL8
T00008   DS    XL8
T00009   DS    XL8
T00010   DS    XL12
         DS    XL4
T00011   DS    XL120
         DS    6D
P00022   DC    F'6'
         DC    A(Q00001)
P00024   DC    A(0)
         DC    A(0)
P00029   DC    A(T00011)
         DC    A(0)
         DC    A(0)
         DS    F
P00031   DC    A(T00003)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DS    F
P00034   DC    A(T00004)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DS    F
P00035   DC    A(T00005)
         DC    A(0)
         DC    A(0)
         DS    F
P00037   DC    A(T00006)
         DC    A(0)
         DC    A(0)
         DS    F
P00041   DC    A(T00007)
         DC    A(0)
         DC    A(0)
         DS    F
P00043   DC    A(T00008)
         DC    A(0)
         DC    A(0)
P00046   DC    F'6'
         DC    A(Q00002)
         DS    F
P00047   DC    A(0)
         DS    F
P00049   DC    A(T00009)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DS    XL4
C00020   DC    X'41100000'
C00021   DC    X'41200000'
C00023   DC    V(F77WRBEG)
C00025   DC    V(F77WRC)
C00026   DC    V(F77WREND)
C00027   DC    X'41180000'
C00028   DC    X'412C0000'
C00030   DC    V(F77CEXP)
C00032   DC    X'00000000'
C00033   DC    V(F77CDIV)
C00036   DC    V(F77CCOS)
C00038   DC    X'41300000'
C00039   DC    X'41400000'
C00040   DC    V(F77CSQRT)
C00042   DC    V(F77CLOG)
C00044   DC    V(F77CSIN)
C00045   DC    V(F77CABS)
C00048   DC    V(F77WRR)
Q00001   DC    C'('' >'',3(''('',F10.5,'','',F10.5,'')'')'
         DC    C')'
Q00002   DC    C'('' >'',3F10.5)'
* ZF
ZF       CSECT
         USING *,15
         B     L00054
         DC    AL1(2),CL7'ZF'
L00054   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00055
L00056   DC    A(S00050)
L00055   L     15,L00056
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00050,13
         ST    1,S00050+72
L00051   DS    0H
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
         B     L00053
L00052   DS    0H
L00053   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00050   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
