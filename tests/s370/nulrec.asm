* main
F77MAIN  CSECT
         USING *,15
         B     L00024
         DC    AL1(7),CL7'F77MAIN'
L00024   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00025
L00026   DC    A(S00000)
L00025   L     15,L00026
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00015   DS    0H
         LA    0,T00012
         ST    0,P00027+0
         LA    0,12
         ST    0,P00027+4
         L     0,C00028
         ST    0,P00027+8
         LA    0,2
         ST    0,P00027+12
         LA    1,P00027
         L     15,C00029
         BALR  14,15
         LA    4,T00012
         A     4,C00030
         LA    15,0
         STC   15,T00014
         LA    15,0
         STC   15,T00008
         LA    0,T00009
         ST    0,P00027+0
         LA    0,1
         ST    0,P00027+4
         LA    0,T00014
         ST    0,P00027+8
         LA    0,1
         ST    0,P00027+12
         LA    1,P00027
         L     15,C00029
         BALR  14,15
         LA    3,T00009+1
         LR    0,3
         ST    0,P00027+0
         LA    0,1
         ST    0,P00027+4
         LA    0,T00008
         ST    0,P00027+8
         LA    0,1
         ST    0,P00027+12
         LA    1,P00027
         L     15,C00029
         BALR  14,15
         LA    15,0
         STC   15,T00010
         LA    0,T00011
         ST    0,P00027+0
         LA    0,2
         ST    0,P00027+4
         LA    0,T00009
         ST    0,P00027+8
         LA    0,2
         ST    0,P00027+12
         LA    1,P00027
         L     15,C00029
         BALR  14,15
         LA    3,T00011+2
         LR    0,3
         ST    0,P00027+0
         LA    0,1
         ST    0,P00027+4
         LA    0,T00010
         ST    0,P00027+8
         LA    0,1
         ST    0,P00027+12
         LA    1,P00027
         L     15,C00029
         BALR  14,15
         LR    0,4
         ST    0,P00027+0
         LA    0,3
         ST    0,P00027+4
         LA    0,T00011
         ST    0,P00027+8
         LA    0,3
         ST    0,P00027+12
         LA    1,P00027
         L     15,C00029
         BALR  14,15
         LA    3,T00012
         A     3,C00031
         LR    0,3
         ST    0,P00027+0
         LA    0,7
         ST    0,P00027+4
         L     0,C00032
         ST    0,P00027+8
         LA    0,7
         ST    0,P00027+12
         LA    1,P00027
         L     15,C00029
         BALR  14,15
         LA    0,6
         ST    0,P00027+0
         L     0,C00033
         ST    0,P00027+4
         LA    1,P00027
         L     15,C00034
         BALR  14,15
         LA    0,T00012
         ST    0,P00027+0
         LA    0,12
         ST    0,P00027+4
         LA    1,P00027
         L     15,C00035
         BALR  14,15
         L     15,C00036
         BALR  14,15
         LA    0,6
         ST    0,P00027+0
         L     0,C00033
         ST    0,P00027+4
         LA    1,P00027
         L     15,C00034
         BALR  14,15
         LA    0,T00012
         ST    0,P00027+0
         LA    0,5
         ST    0,P00027+4
         LA    1,P00027
         L     15,C00035
         BALR  14,15
         L     0,C00037
         ST    0,P00027+0
         LA    0,2
         ST    0,P00027+4
         LA    1,P00027
         L     15,C00035
         BALR  14,15
         L     15,C00036
         BALR  14,15
L00016   DS    0H
         L     5,C00039
         AH    5,C00040
         LA    6,4
         LA    7,8
         LA    2,4
L00017   DS    0H
         L     4,0(2,5)
         LR    0,4
         ST    0,P00027+0
         L     0,C00041
         ST    0,P00027+4
         LA    1,P00027
         L     15,C00034
         BALR  14,15
         LA    0,T00012
         ST    0,P00027+0
         LA    0,12
         ST    0,P00027+4
         LA    1,P00027
         L     15,C00035
         BALR  14,15
         L     15,C00036
         BALR  14,15
         L     4,0(2,5)
         LR    0,4
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00042
         BALR  14,15
         LA    0,T00013
         ST    0,P00027+0
         LA    0,12
         ST    0,P00027+4
         L     0,C00043
         ST    0,P00027+8
         LA    0,1
         ST    0,P00027+12
         LA    1,P00027
         L     15,C00029
         BALR  14,15
         L     4,0(2,5)
         LR    0,4
         ST    0,P00027+0
         L     0,C00041
         ST    0,P00027+4
         LA    0,0
         ST    0,P00027+8
         LA    1,P00027
         L     15,C00044
         BALR  14,15
         LA    0,T00013
         ST    0,P00027+0
         LA    0,12
         ST    0,P00027+4
         LA    1,P00027
         L     15,C00045
         BALR  14,15
         L     15,C00046
         BALR  14,15
         LA    0,6
         ST    0,P00027+0
         L     0,C00047
         ST    0,P00027+4
         LA    1,P00027
         L     15,C00034
         BALR  14,15
         L     4,0(2,5)
         LR    0,4
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00048
         BALR  14,15
         LA    0,T00013
         ST    0,P00027+0
         LA    0,12
         ST    0,P00027+4
         LA    0,T00012
         ST    0,P00027+8
         LA    0,12
         ST    0,P00027+12
         LA    1,P00027
         L     15,C00049
         BALR  14,15
         LR    3,15
         C     3,C00050
         LA    4,1
         BC    8,L00051
         SR    4,4
L00051   DS    0H
         LR    0,4
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00052
         BALR  14,15
         SR    4,4
         IC    4,T00013+2
         LR    0,4
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00048
         BALR  14,15
         SR    4,4
         IC    4,T00013+3
         LR    0,4
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00048
         BALR  14,15
         SR    4,4
         IC    4,T00013+4
         LR    0,4
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00048
         BALR  14,15
         L     15,C00036
         BALR  14,15
L00019   DS    0H
         BXLE  2,6,L00017
L00018   DS    0H
L00020   DS    0H
L00021   DS    0H
L00022   DS    0H
L00023   DS    0H
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
T00008   DS    XL4
         DS    XL4
T00009   DS    XL4
         DS    XL4
T00010   DS    XL4
         DS    XL4
T00011   DS    XL4
         DS    XL4
T00012   DS    XL16
T00013   DS    XL16
T00014   DS    XL24
P00027   DS    4F
C00028   DC    A(Q00001)
C00029   DC    V(F77STRCP)
C00030   DC    F'2'
C00031   DC    F'5'
C00032   DC    A(Q00002)
C00033   DC    A(Q00003)
C00034   DC    V(F77WRBEG)
C00035   DC    V(F77WRA)
C00036   DC    V(F77WREND)
C00037   DC    A(Q00004)
C00039   DC    A(G00038)
C00041   DC    A(Q00005)
C00042   DC    V(F77REWND)
C00043   DC    A(Q00006)
C00044   DC    V(F77RDBEG)
C00045   DC    V(F77RDS)
C00046   DC    V(F77RDEND)
C00047   DC    A(Q00007)
C00048   DC    V(F77WRI)
C00049   DC    V(F77STRCM)
C00050   DC    F'0'
C00052   DC    V(F77WRL)
C00040   DC    H'-4'
Q00003   DC    C'(1X,A,A)'
Q00005   DC    C'(A)'
Q00007   DC    C'('' >F'',I3,L2,3I2)'
Q00001   DC    C'>N'
Q00002   DC    C'WXYZ 42'
Q00004   DC    C'>T'
Q00006   DC    C'?'
G00038   CSECT
         DS    0D
         DC    X'000000070000001F'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
