* main
F77MAIN  CSECT
         USING *,15
         B     L00014
         DC    AL1(7),CL7'F77MAIN'
L00014   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00015
L00016   DC    A(S00000)
L00015   L     15,L00016
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00009   DS    0H
         LA    0,T00008
         ST    0,P00017+0
         LA    0,43
         ST    0,P00017+4
         L     0,C00018
         ST    0,P00017+8
         LA    0,24
         ST    0,P00017+12
         LA    1,P00017
         L     15,C00019
         BALR  14,15
         LA    0,T00008
         ST    0,P00017+0
         LA    0,43
         ST    0,P00017+4
         LA    0,1
         ST    0,P00017+8
         L     0,C00020
         ST    0,P00017+12
         LA    0,0
         ST    0,P00017+16
         LA    1,P00017
         L     15,C00021
         BALR  14,15
         LA    0,T00007
         ST    0,P00017+0
         LA    1,P00017
         L     15,C00022
         BALR  14,15
         L     15,C00023
         BALR  14,15
L00010   DS    0H
         LA    0,6
         ST    0,P00017+0
         L     0,C00024
         ST    0,P00017+4
         LA    1,P00017
         L     15,C00025
         BALR  14,15
         LD    0,T00007
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00017+0
         LA    1,P00017
         L     15,C00026
         BALR  14,15
         L     15,C00027
         BALR  14,15
L00011   DS    0H
         LA    0,T00008
         ST    0,P00017+0
         LA    0,43
         ST    0,P00017+4
         LA    0,1
         ST    0,P00017+8
         L     0,C00028
         ST    0,P00017+12
         LA    1,P00017
         L     15,C00029
         BALR  14,15
         LD    0,C00030
         STD   0,P00017+0
         LA    1,P00017
         L     15,C00026
         BALR  14,15
         L     15,C00027
         BALR  14,15
L00012   DS    0H
         LA    0,7
         ST    0,P00017+0
         LA    1,P00017
         L     15,C00031
         BALR  14,15
         LA    0,6
         ST    0,P00017+0
         L     0,C00032
         ST    0,P00017+4
         LA    1,P00017
         L     15,C00025
         BALR  14,15
         LA    0,T00008
         ST    0,P00017+0
         LA    0,43
         ST    0,P00017+4
         LA    1,P00017
         L     15,C00033
         BALR  14,15
         L     15,C00027
         BALR  14,15
         LA    3,T00008
         A     3,C00034
         LA    0,7
         ST    0,P00017+0
         LA    1,P00017
         L     15,C00031
         BALR  14,15
         LR    0,3
         ST    0,P00017+0
         LA    0,30
         ST    0,P00017+4
         LA    0,1
         ST    0,P00017+8
         L     0,C00035
         ST    0,P00017+12
         LA    0,0
         ST    0,P00017+16
         LA    1,P00017
         L     15,C00021
         BALR  14,15
         LA    0,T00007
         ST    0,P00017+0
         LA    1,P00017
         L     15,C00022
         BALR  14,15
         L     15,C00023
         BALR  14,15
         LA    0,6
         ST    0,P00017+0
         L     0,C00024
         ST    0,P00017+4
         LA    1,P00017
         L     15,C00025
         BALR  14,15
         LD    0,T00007
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00017+0
         LA    1,P00017
         L     15,C00026
         BALR  14,15
         L     15,C00027
         BALR  14,15
L00013   DS    0H
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
T00007   DS    XL12
         DS    XL4
T00008   DS    XL48
         DS    1D
P00017   DS    5F
         DS    XL4
C00030   DC    X'4118000000000000'
C00018   DC    A(Q00001)
C00019   DC    V(F77STRCP)
C00020   DC    A(Q00002)
C00021   DC    V(F77RDBI)
C00022   DC    V(F77RDD)
C00023   DC    V(F77RDEND)
C00024   DC    A(Q00003)
C00025   DC    V(F77WRBEG)
C00026   DC    V(F77WRD)
C00027   DC    V(F77WREND)
C00028   DC    A(Q00004)
C00029   DC    V(F77WRBI)
C00031   DC    V(F77FMTLM)
C00032   DC    A(Q00005)
C00033   DC    V(F77WRA)
C00034   DC    F'13'
C00035   DC    A(Q00006)
Q00002   DC    C'(13X,D10.5)'
Q00003   DC    C'(1X,F12.3)'
Q00004   DC    C'(13X,D10.5)'
Q00001   DC    C'             0.23456D+05'
Q00005   DC    C'(1X, A)'
Q00006   DC    C'(D10.5)'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
