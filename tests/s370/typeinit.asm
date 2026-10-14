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
L00002   DS    0H
         L     5,C00015
         L     3,C00017
         LA    0,6
         ST    0,P00018+0
         L     0,C00019
         ST    0,P00018+4
         LA    1,P00018
         L     15,C00020
         BALR  14,15
         L     14,C00022
         L     4,0(,14)
         LR    0,4
         ST    0,P00018+0
         LA    1,P00018
         L     15,C00023
         BALR  14,15
         AH    5,C00024
         LA    2,4
         LA    4,3
L00003   DS    0H
         C     4,C00025
         BC    2,L00004
L00005   DS    0H
         LA    0,1
         ST    0,P00018+0
         LA    1,P00018
         L     15,C00023
         BALR  14,15
         L     0,C00027
         ST    0,P00018+0
         LA    0,4
         ST    0,P00018+4
         LA    1,P00018
         L     15,C00028
         BALR  14,15
         AH    3,C00024
         LA    2,4
         LA    4,2
L00006   DS    0H
         C     4,C00025
         BC    2,L00007
L00008   DS    0H
         L     15,C00029
         BALR  14,15
L00009   DS    0H
         B     L00010
L00004   DS    0H
         L     7,0(2,5)
         LR    0,7
         ST    0,P00018+0
         LA    1,P00018
         L     15,C00023
         BALR  14,15
         AH    4,C00030
         A     2,C00031
         B     L00003
L00007   DS    0H
         LE    0,0(2,3)
         STE   0,S00000+176
         LE    0,S00000+176
         STE   0,P00018+0
         LA    1,P00018
         L     15,C00032
         BALR  14,15
         AH    4,C00030
         A     2,C00031
         B     L00006
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
         DS    1D
P00018   DS    2F
C00015   DC    A(G00014)
C00017   DC    A(G00016)
C00019   DC    A(Q00001)
C00020   DC    V(F77WRBEG)
C00022   DC    A(G00021)
C00023   DC    V(F77WRI)
C00025   DC    F'0'
C00027   DC    A(G00026)
C00028   DC    V(F77WRA)
C00029   DC    V(F77WREND)
C00031   DC    F'4'
C00032   DC    V(F77WRR)
C00024   DC    H'-4'
C00030   DC    H'-1'
Q00001   DC    C'(1X,''>TYPEINIT'',I6,3I3,I2,1X,A4,2F5.1)'
G00021   CSECT
         DS    0D
         DC    X'00003039'
G00014   CSECT
         DS    0D
         DC    X'000000010000000700000007'
G00026   CSECT
         DS    0D
         DC    X'C1C2C3C4'
G00016   CSECT
         DS    0D
         DC    X'4118000041280000'
         END
