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
         LA    1,P00017
         L     15,C00018
         BALR  14,15
         LA    1,P00019
         L     15,C00020
         BALR  14,15
         LA    1,P00021
         L     15,C00022
         BALR  14,15
         L     15,C00023
         BALR  14,15
L00010   DS    0H
         LA    1,P00024
         L     15,C00025
         BALR  14,15
         LD    0,T00007
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00026+0
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         L     15,C00028
         BALR  14,15
L00011   DS    0H
         LA    1,P00029
         L     15,C00030
         BALR  14,15
         LD    0,C00031
         STD   0,P00026+0
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         L     15,C00028
         BALR  14,15
L00012   DS    0H
         LA    1,P00032
         L     15,C00033
         BALR  14,15
         LA    1,P00034
         L     15,C00025
         BALR  14,15
         LA    1,P00035
         L     15,C00036
         BALR  14,15
         L     15,C00028
         BALR  14,15
         LA    3,T00008
         A     3,C00037
         LA    1,P00032
         L     15,C00033
         BALR  14,15
         LR    0,3
         ST    0,P00038+0
         LA    1,P00038
         L     15,C00020
         BALR  14,15
         LA    1,P00021
         L     15,C00022
         BALR  14,15
         L     15,C00023
         BALR  14,15
         LA    1,P00024
         L     15,C00025
         BALR  14,15
         LD    0,T00007
         STD   0,S00000+240
         LD    0,S00000+240
         STD   0,P00026+0
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         L     15,C00028
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
P00017   DC    A(T00008)
         DC    F'43'
         DC    A(Q00001)
         DC    F'24'
P00019   DC    A(T00008)
         DC    F'43'
         DC    F'1'
         DC    A(Q00002)
         DC    F'0'
P00021   DC    A(T00007)
P00024   DC    F'6'
         DC    A(Q00003)
P00026   DC    A(0)
         DC    A(0)
P00029   DC    A(T00008)
         DC    F'43'
         DC    F'1'
         DC    A(Q00004)
P00032   DC    F'7'
P00034   DC    F'6'
         DC    A(Q00005)
P00035   DC    A(T00008)
         DC    F'43'
P00038   DC    A(0)
         DC    F'30'
         DC    F'1'
         DC    A(Q00006)
         DC    F'0'
C00031   DC    X'4118000000000000'
C00018   DC    V(F77STRCP)
C00020   DC    V(F77RDBI)
C00022   DC    V(F77RDD)
C00023   DC    V(F77RDEND)
C00025   DC    V(F77WRBEG)
C00027   DC    V(F77WRD)
C00028   DC    V(F77WREND)
C00030   DC    V(F77WRBI)
C00033   DC    V(F77FMTLM)
C00036   DC    V(F77WRA)
C00037   DC    F'13'
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
