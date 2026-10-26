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
         LA    1,P00022
         L     15,C00023
         BALR  14,15
         LA    15,1
         ST    15,T00005
         LA    1,P00024
         L     15,C00025
         BALR  14,15
         MVC   T00006(4),C00026
         LA    1,P00027
         L     15,C00025
         BALR  14,15
         MVC   T00011(8),C00028
         LA    1,P00029
         L     15,C00025
         BALR  14,15
         LA    1,P00030
         L     15,C00025
         BALR  14,15
         L     15,C00031
         BALR  14,15
         LA    1,P00022
         L     15,C00023
         BALR  14,15
         LA    15,4
         ST    15,T00007
         LA    1,P00032
         L     15,C00025
         BALR  14,15
         MVC   T00008(4),C00033
         LA    1,P00034
         L     15,C00025
         BALR  14,15
         MVC   T00012(8),C00035
         LA    1,P00036
         L     15,C00025
         BALR  14,15
         LA    1,P00037
         L     15,C00025
         BALR  14,15
         L     15,C00031
         BALR  14,15
         LA    1,P00022
         L     15,C00038
         BALR  14,15
         LA    1,P00022
         L     15,C00039
         BALR  14,15
         LA    1,P00040
         L     15,C00041
         BALR  14,15
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         LA    1,P00044
         L     15,C00043
         BALR  14,15
         LA    1,P00045
         L     15,C00043
         BALR  14,15
         LA    1,P00046
         L     15,C00043
         BALR  14,15
         L     15,C00047
         BALR  14,15
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     3,T00009
         LR    0,3
         ST    0,P00050+0
         LA    1,P00050
         L     15,C00051
         BALR  14,15
         LE    0,T00010
         STE   0,S00000+272
         LE    0,S00000+272
         STE   0,P00052+0
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         LD    0,T00013
         STD   0,S00000+272
         LD    0,S00000+272
         STD   0,P00054+0
         LA    1,P00054
         L     15,C00055
         BALR  14,15
         LA    1,P00046
         L     15,C00056
         BALR  14,15
         L     15,C00057
         BALR  14,15
         LA    1,P00040
         L     15,C00041
         BALR  14,15
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         LA    1,P00044
         L     15,C00043
         BALR  14,15
         LA    1,P00045
         L     15,C00043
         BALR  14,15
         LA    1,P00046
         L     15,C00043
         BALR  14,15
         L     15,C00047
         BALR  14,15
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     3,T00009
         LR    0,3
         ST    0,P00050+0
         LA    1,P00050
         L     15,C00051
         BALR  14,15
         LE    0,T00010
         STE   0,S00000+272
         LE    0,S00000+272
         STE   0,P00052+0
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         LD    0,T00013
         STD   0,S00000+272
         LD    0,S00000+272
         STD   0,P00054+0
         LA    1,P00054
         L     15,C00055
         BALR  14,15
         LA    1,P00046
         L     15,C00056
         BALR  14,15
         L     15,C00057
         BALR  14,15
         LA    1,P00058
         L     15,C00041
         BALR  14,15
         LR    2,15
         C     2,C00059
         BC    8,L00017
L00016   DS    0H
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         L     15,C00047
         BALR  14,15
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LA    1,P00060
         L     15,C00056
         BALR  14,15
         L     15,C00057
         BALR  14,15
L00017   DS    0H
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LA    1,P00061
         L     15,C00056
         BALR  14,15
         L     15,C00057
         BALR  14,15
         LA    1,P00022
         L     15,C00062
         BALR  14,15
         LA    1,P00022
         L     15,C00062
         BALR  14,15
         LA    1,P00040
         L     15,C00041
         BALR  14,15
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         L     15,C00047
         BALR  14,15
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     3,T00009
         LR    0,3
         ST    0,P00050+0
         LA    1,P00050
         L     15,C00051
         BALR  14,15
         L     15,C00057
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
P00022   DC    F'7'
P00024   DC    A(T00005)
         DC    F'4'
P00027   DC    A(T00006)
         DC    F'4'
P00029   DC    A(T00011)
         DC    F'8'
P00030   DC    A(Q00001)
         DC    F'6'
P00032   DC    A(T00007)
         DC    F'4'
P00034   DC    A(T00008)
         DC    F'4'
P00036   DC    A(T00012)
         DC    F'8'
P00037   DC    A(Q00002)
         DC    F'6'
P00040   DC    F'7'
         DC    F'0'
P00042   DC    A(T00009)
         DC    F'4'
P00044   DC    A(T00010)
         DC    F'4'
P00045   DC    A(T00013)
         DC    F'8'
P00046   DC    A(T00014)
         DC    F'6'
P00048   DC    F'6'
         DC    F'0'
P00050   DC    A(0)
P00052   DC    A(0)
         DS    F
P00054   DC    A(0)
         DC    A(0)
P00058   DC    F'7'
         DC    F'1'
P00060   DC    A(Q00003)
         DC    F'6'
P00061   DC    A(Q00004)
         DC    F'6'
C00028   DC    X'4138000000000000'
C00035   DC    X'4168000000000000'
C00023   DC    V(F77WUBEG)
C00025   DC    V(F77WU)
C00026   DC    X'41280000'
C00031   DC    V(F77WUEND)
C00033   DC    X'41580000'
C00038   DC    V(F77ENDF)
C00039   DC    V(F77REWND)
C00041   DC    V(F77RUBEG)
C00043   DC    V(F77RU)
C00047   DC    V(F77RUEND)
C00049   DC    V(F77WRBEG)
C00051   DC    V(F77WRI)
C00053   DC    V(F77WRR)
C00055   DC    V(F77WRD)
C00056   DC    V(F77WRA)
C00057   DC    V(F77WREND)
C00059   DC    F'1'
C00062   DC    V(F77BKSP)
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
