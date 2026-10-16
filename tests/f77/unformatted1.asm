* main
F77MAIN  CSECT
         USING *,15
         B     L00019
         DC    AL1(7),CL7'F77MAIN'
L00019   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00020
L00021   DC    A(S00000)
L00020   L     15,L00021
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00015   DS    0H
         LA    0,7
         ST    0,P00022+0
         LA    1,P00022
         L     15,C00023
         BALR  14,15
         LA    15,1
         ST    15,T00005
         LA    0,T00005
         ST    0,P00022+0
         LA    0,4
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00024
         BALR  14,15
         MVC   T00006(4),C00025
         LA    0,T00006
         ST    0,P00022+0
         LA    0,4
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00024
         BALR  14,15
         MVC   T00011(8),C00026
         LA    0,T00011
         ST    0,P00022+0
         LA    0,8
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00024
         BALR  14,15
         L     0,C00027
         ST    0,P00022+0
         LA    0,6
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00024
         BALR  14,15
         L     15,C00028
         BALR  14,15
         LA    0,7
         ST    0,P00022+0
         LA    1,P00022
         L     15,C00023
         BALR  14,15
         LA    15,4
         ST    15,T00007
         LA    0,T00007
         ST    0,P00022+0
         LA    0,4
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00024
         BALR  14,15
         MVC   T00008(4),C00029
         LA    0,T00008
         ST    0,P00022+0
         LA    0,4
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00024
         BALR  14,15
         MVC   T00012(8),C00030
         LA    0,T00012
         ST    0,P00022+0
         LA    0,8
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00024
         BALR  14,15
         L     0,C00031
         ST    0,P00022+0
         LA    0,6
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00024
         BALR  14,15
         L     15,C00028
         BALR  14,15
         LA    0,7
         ST    0,P00022+0
         LA    1,P00022
         L     15,C00032
         BALR  14,15
         LA    0,7
         ST    0,P00022+0
         LA    1,P00022
         L     15,C00033
         BALR  14,15
         LA    0,7
         ST    0,P00022+0
         LA    0,0
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00034
         BALR  14,15
         LA    0,T00009
         ST    0,P00022+0
         LA    0,4
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00035
         BALR  14,15
         LA    0,T00010
         ST    0,P00022+0
         LA    0,4
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00035
         BALR  14,15
         LA    0,T00013
         ST    0,P00022+0
         LA    0,8
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00035
         BALR  14,15
         LA    0,T00014
         ST    0,P00022+0
         LA    0,6
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00035
         BALR  14,15
         L     15,C00036
         BALR  14,15
         LA    0,6
         ST    0,P00022+0
         LA    0,0
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00037
         BALR  14,15
         L     3,T00009
         LR    0,3
         ST    0,P00022+0
         LA    1,P00022
         L     15,C00038
         BALR  14,15
         LE    0,T00010
         STE   0,S00000+272
         LE    0,S00000+272
         STE   0,P00022+0
         LA    1,P00022
         L     15,C00039
         BALR  14,15
         LD    0,T00013
         STD   0,S00000+272
         LD    0,S00000+272
         STD   0,P00022+0
         LA    1,P00022
         L     15,C00040
         BALR  14,15
         LA    0,T00014
         ST    0,P00022+0
         LA    0,6
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00041
         BALR  14,15
         L     15,C00042
         BALR  14,15
         LA    0,7
         ST    0,P00022+0
         LA    0,0
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00034
         BALR  14,15
         LA    0,T00009
         ST    0,P00022+0
         LA    0,4
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00035
         BALR  14,15
         LA    0,T00010
         ST    0,P00022+0
         LA    0,4
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00035
         BALR  14,15
         LA    0,T00013
         ST    0,P00022+0
         LA    0,8
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00035
         BALR  14,15
         LA    0,T00014
         ST    0,P00022+0
         LA    0,6
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00035
         BALR  14,15
         L     15,C00036
         BALR  14,15
         LA    0,6
         ST    0,P00022+0
         LA    0,0
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00037
         BALR  14,15
         L     3,T00009
         LR    0,3
         ST    0,P00022+0
         LA    1,P00022
         L     15,C00038
         BALR  14,15
         LE    0,T00010
         STE   0,S00000+272
         LE    0,S00000+272
         STE   0,P00022+0
         LA    1,P00022
         L     15,C00039
         BALR  14,15
         LD    0,T00013
         STD   0,S00000+272
         LD    0,S00000+272
         STD   0,P00022+0
         LA    1,P00022
         L     15,C00040
         BALR  14,15
         LA    0,T00014
         ST    0,P00022+0
         LA    0,6
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00041
         BALR  14,15
         L     15,C00042
         BALR  14,15
         LA    0,7
         ST    0,P00022+0
         LA    0,1
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00034
         BALR  14,15
         LR    2,15
         C     2,C00043
         BC    8,L00017
L00016   DS    0H
         LA    0,T00009
         ST    0,P00022+0
         LA    0,4
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00035
         BALR  14,15
         L     15,C00036
         BALR  14,15
         LA    0,6
         ST    0,P00022+0
         LA    0,0
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00037
         BALR  14,15
         L     0,C00044
         ST    0,P00022+0
         LA    0,6
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00041
         BALR  14,15
         L     15,C00042
         BALR  14,15
L00017   DS    0H
         LA    0,6
         ST    0,P00022+0
         LA    0,0
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00037
         BALR  14,15
         L     0,C00045
         ST    0,P00022+0
         LA    0,6
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00041
         BALR  14,15
         L     15,C00042
         BALR  14,15
         LA    0,7
         ST    0,P00022+0
         LA    1,P00022
         L     15,C00046
         BALR  14,15
         LA    0,7
         ST    0,P00022+0
         LA    1,P00022
         L     15,C00046
         BALR  14,15
         LA    0,7
         ST    0,P00022+0
         LA    0,0
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00034
         BALR  14,15
         LA    0,T00009
         ST    0,P00022+0
         LA    0,4
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00035
         BALR  14,15
         L     15,C00036
         BALR  14,15
         LA    0,6
         ST    0,P00022+0
         LA    0,0
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00037
         BALR  14,15
         L     3,T00009
         LR    0,3
         ST    0,P00022+0
         LA    1,P00022
         L     15,C00038
         BALR  14,15
         L     15,C00042
         BALR  14,15
L00018   DS    0H
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
T00005   DS    XL4
         DS    XL4
T00006   DS    XL4
         DS    XL4
T00007   DS    XL4
         DS    XL4
T00008   DS    XL4
         DS    XL4
T00009   DS    XL4
         DS    XL4
T00010   DS    XL4
         DS    XL4
T00011   DS    XL8
T00012   DS    XL8
T00013   DS    XL12
         DS    XL4
T00014   DS    XL12
         DS    XL4
         DS    1D
P00022   DS    2F
C00026   DC    X'4138000000000000'
C00030   DC    X'4168000000000000'
C00023   DC    V(F77WUBEG)
C00024   DC    V(F77WU)
C00025   DC    X'41280000'
C00027   DC    A(Q00001)
C00028   DC    V(F77WUEND)
C00029   DC    X'41580000'
C00031   DC    A(Q00002)
C00032   DC    V(F77ENDF)
C00033   DC    V(F77REWND)
C00034   DC    V(F77RUBEG)
C00035   DC    V(F77RU)
C00036   DC    V(F77RUEND)
C00037   DC    V(F77WRBEG)
C00038   DC    V(F77WRI)
C00039   DC    V(F77WRR)
C00040   DC    V(F77WRD)
C00041   DC    V(F77WRA)
C00042   DC    V(F77WREND)
C00043   DC    F'1'
C00044   DC    A(Q00003)
C00045   DC    A(Q00004)
C00046   DC    V(F77BKSP)
Q00001   DC    C'ABCDEF'
Q00002   DC    C'GHIJKL'
Q00003   DC    C'NO EOF'
Q00004   DC    C'EOF OK'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
