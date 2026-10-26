* main
F77MAIN  CSECT
         USING *,15
         B     L00025
         DC    AL1(7),CL7'F77MAIN'
L00025   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00026
L00027   DC    A(S00000)
L00026   L     15,L00027
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00012   DS    0H
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         LE    0,C00031
         STE   0,P00030+0
         LA    1,P00030
         L     15,C00032
         BALR  14,15
         L     15,C00033
         BALR  14,15
L00013   DS    0H
         LA    1,P00034
         L     15,C00029
         BALR  14,15
         LE    0,C00031
         STE   0,P00030+0
         LA    1,P00030
         L     15,C00032
         BALR  14,15
         L     15,C00033
         BALR  14,15
L00014   DS    0H
         LA    1,P00035
         L     15,C00029
         BALR  14,15
         LE    0,C00031
         STE   0,P00030+0
         LA    1,P00030
         L     15,C00032
         BALR  14,15
         L     15,C00033
         BALR  14,15
L00015   DS    0H
         LA    1,P00036
         L     15,C00029
         BALR  14,15
         LD    0,C00038
         STD   0,P00037+0
         LA    1,P00037
         L     15,C00039
         BALR  14,15
         L     15,C00033
         BALR  14,15
L00016   DS    0H
         LA    1,P00040
         L     15,C00029
         BALR  14,15
         LD    0,C00038
         STD   0,P00037+0
         LA    1,P00037
         L     15,C00039
         BALR  14,15
         L     15,C00033
         BALR  14,15
L00017   DS    0H
         LA    1,P00041
         L     15,C00029
         BALR  14,15
         LE    0,C00031
         STE   0,P00030+0
         LA    1,P00030
         L     15,C00032
         BALR  14,15
         L     15,C00033
         BALR  14,15
L00018   DS    0H
         LA    1,P00042
         L     15,C00029
         BALR  14,15
         LE    0,C00031
         STE   0,P00030+0
         LA    1,P00030
         L     15,C00032
         BALR  14,15
         LE    0,C00031
         STE   0,P00030+0
         LA    1,P00030
         L     15,C00032
         BALR  14,15
         L     15,C00033
         BALR  14,15
L00019   DS    0H
         LA    1,P00043
         L     15,C00029
         BALR  14,15
         LE    0,C00031
         STE   0,P00030+0
         LA    1,P00030
         L     15,C00032
         BALR  14,15
         L     15,C00033
         BALR  14,15
L00020   DS    0H
         LA    1,P00044
         L     15,C00029
         BALR  14,15
         LE    0,C00031
         STE   0,P00030+0
         LA    1,P00030
         L     15,C00032
         BALR  14,15
         L     15,C00033
         BALR  14,15
L00021   DS    0H
         LA    1,P00045
         L     15,C00029
         BALR  14,15
         LE    0,C00046
         STE   0,P00030+0
         LA    1,P00030
         L     15,C00032
         BALR  14,15
         L     15,C00033
         BALR  14,15
L00022   DS    0H
         LA    1,P00047
         L     15,C00029
         BALR  14,15
         LE    0,C00046
         STE   0,P00030+0
         LA    1,P00030
         L     15,C00032
         BALR  14,15
         L     15,C00033
         BALR  14,15
L00023   DS    0H
L00024   DS    0H
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
P00028   DC    F'6'
         DC    A(Q00001)
P00030   DC    A(0)
P00034   DC    F'6'
         DC    A(Q00002)
P00035   DC    F'6'
         DC    A(Q00003)
P00036   DC    F'6'
         DC    A(Q00004)
         DS    F
P00037   DC    A(0)
         DC    A(0)
P00040   DC    F'6'
         DC    A(Q00005)
P00041   DC    F'6'
         DC    A(Q00006)
P00042   DC    F'6'
         DC    A(Q00007)
P00043   DC    F'6'
         DC    A(Q00008)
P00044   DC    F'6'
         DC    A(Q00009)
P00045   DC    F'6'
         DC    A(Q00010)
P00047   DC    F'6'
         DC    A(Q00011)
C00038   DC    X'3E1DEE279067C1B0'
C00029   DC    V(F77WRBEG)
C00031   DC    X'41C80000'
C00032   DC    V(F77WRR)
C00033   DC    V(F77WREND)
C00039   DC    V(F77WRD)
C00046   DC    X'3E51EB85'
Q00001   DC    C'(E12.4)'
Q00002   DC    C'(1PE12.4)'
Q00003   DC    C'(2PE13.4)'
Q00004   DC    C'(D14.5)'
Q00005   DC    C'(1PD14.5)'
Q00006   DC    C'(-1PE13.4)'
Q00007   DC    C'(1P,E12.4,E12.4)'
Q00008   DC    C'(2PF10.2)'
Q00009   DC    C'(1PG12.4)'
Q00010   DC    C'(1PG12.4)'
Q00011   DC    C'(G12.4)'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
