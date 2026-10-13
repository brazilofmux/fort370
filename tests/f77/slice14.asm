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
         LA    0,6
         ST    0,P00028+0
         L     0,C00029
         ST    0,P00028+4
         LA    1,P00028
         L     15,C00030
         BALR  14,15
         LE    0,C00031
         STE   0,P00028+0
         LA    1,P00028
         L     15,C00032
         BALR  14,15
         L     15,C00033
         BALR  14,15
L00013   DS    0H
         LA    0,6
         ST    0,P00028+0
         L     0,C00034
         ST    0,P00028+4
         LA    1,P00028
         L     15,C00030
         BALR  14,15
         LE    0,C00031
         STE   0,P00028+0
         LA    1,P00028
         L     15,C00032
         BALR  14,15
         L     15,C00033
         BALR  14,15
L00014   DS    0H
         LA    0,6
         ST    0,P00028+0
         L     0,C00035
         ST    0,P00028+4
         LA    1,P00028
         L     15,C00030
         BALR  14,15
         LE    0,C00031
         STE   0,P00028+0
         LA    1,P00028
         L     15,C00032
         BALR  14,15
         L     15,C00033
         BALR  14,15
L00015   DS    0H
         LA    0,6
         ST    0,P00028+0
         L     0,C00036
         ST    0,P00028+4
         LA    1,P00028
         L     15,C00030
         BALR  14,15
         LD    0,C00037
         STD   0,P00028+0
         LA    1,P00028
         L     15,C00038
         BALR  14,15
         L     15,C00033
         BALR  14,15
L00016   DS    0H
         LA    0,6
         ST    0,P00028+0
         L     0,C00039
         ST    0,P00028+4
         LA    1,P00028
         L     15,C00030
         BALR  14,15
         LD    0,C00037
         STD   0,P00028+0
         LA    1,P00028
         L     15,C00038
         BALR  14,15
         L     15,C00033
         BALR  14,15
L00017   DS    0H
         LA    0,6
         ST    0,P00028+0
         L     0,C00040
         ST    0,P00028+4
         LA    1,P00028
         L     15,C00030
         BALR  14,15
         LE    0,C00031
         STE   0,P00028+0
         LA    1,P00028
         L     15,C00032
         BALR  14,15
         L     15,C00033
         BALR  14,15
L00018   DS    0H
         LA    0,6
         ST    0,P00028+0
         L     0,C00041
         ST    0,P00028+4
         LA    1,P00028
         L     15,C00030
         BALR  14,15
         LE    0,C00031
         STE   0,P00028+0
         LA    1,P00028
         L     15,C00032
         BALR  14,15
         LE    0,C00031
         STE   0,P00028+0
         LA    1,P00028
         L     15,C00032
         BALR  14,15
         L     15,C00033
         BALR  14,15
L00019   DS    0H
         LA    0,6
         ST    0,P00028+0
         L     0,C00042
         ST    0,P00028+4
         LA    1,P00028
         L     15,C00030
         BALR  14,15
         LE    0,C00031
         STE   0,P00028+0
         LA    1,P00028
         L     15,C00032
         BALR  14,15
         L     15,C00033
         BALR  14,15
L00020   DS    0H
         LA    0,6
         ST    0,P00028+0
         L     0,C00043
         ST    0,P00028+4
         LA    1,P00028
         L     15,C00030
         BALR  14,15
         LE    0,C00031
         STE   0,P00028+0
         LA    1,P00028
         L     15,C00032
         BALR  14,15
         L     15,C00033
         BALR  14,15
L00021   DS    0H
         LA    0,6
         ST    0,P00028+0
         L     0,C00044
         ST    0,P00028+4
         LA    1,P00028
         L     15,C00030
         BALR  14,15
         LE    0,C00045
         STE   0,P00028+0
         LA    1,P00028
         L     15,C00032
         BALR  14,15
         L     15,C00033
         BALR  14,15
L00022   DS    0H
         LA    0,6
         ST    0,P00028+0
         L     0,C00046
         ST    0,P00028+4
         LA    1,P00028
         L     15,C00030
         BALR  14,15
         LE    0,C00045
         STE   0,P00028+0
         LA    1,P00028
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
P00028   DS    2F
C00037   DC    X'3E1DEE279067C1B0'
C00029   DC    A(Q00001)
C00030   DC    V(F77WRBEG)
C00031   DC    X'41C80000'
C00032   DC    V(F77WRR)
C00033   DC    V(F77WREND)
C00034   DC    A(Q00002)
C00035   DC    A(Q00003)
C00036   DC    A(Q00004)
C00038   DC    V(F77WRD)
C00039   DC    A(Q00005)
C00040   DC    A(Q00006)
C00041   DC    A(Q00007)
C00042   DC    A(Q00008)
C00043   DC    A(Q00009)
C00044   DC    A(Q00010)
C00045   DC    X'3E51EB85'
C00046   DC    A(Q00011)
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
         END
