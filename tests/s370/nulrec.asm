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
         LA    1,P00027
         L     15,C00028
         BALR  14,15
         LA    3,T00012
         A     3,C00029
         LA    15,0
         STC   15,T00014
         LA    15,0
         STC   15,T00008
         LA    1,P00030
         L     15,C00028
         BALR  14,15
         LA    1,P00031
         L     15,C00028
         BALR  14,15
         LA    15,0
         STC   15,T00010
         LA    1,P00032
         L     15,C00028
         BALR  14,15
         LA    1,P00033
         L     15,C00028
         BALR  14,15
         LR    0,3
         ST    0,P00034+0
         LA    1,P00034
         L     15,C00028
         BALR  14,15
         LA    3,T00012
         A     3,C00035
         LR    0,3
         ST    0,P00036+0
         LA    1,P00036
         L     15,C00028
         BALR  14,15
         LA    1,P00037
         L     15,C00038
         BALR  14,15
         LA    1,P00039
         L     15,C00040
         BALR  14,15
         L     15,C00041
         BALR  14,15
         LA    1,P00037
         L     15,C00038
         BALR  14,15
         LA    1,P00042
         L     15,C00040
         BALR  14,15
         LA    1,P00043
         L     15,C00040
         BALR  14,15
         L     15,C00041
         BALR  14,15
L00016   DS    0H
         L     5,C00045
         AH    5,C00046
         LA    6,4
         LA    7,8
         LA    2,4
L00017   DS    0H
         L     4,0(2,5)
         LR    0,4
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00038
         BALR  14,15
         LA    1,P00039
         L     15,C00040
         BALR  14,15
         L     15,C00041
         BALR  14,15
         L     4,0(2,5)
         LR    0,4
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LA    1,P00050
         L     15,C00028
         BALR  14,15
         L     4,0(2,5)
         LR    0,4
         ST    0,P00051+0
         LA    1,P00051
         L     15,C00052
         BALR  14,15
         LA    1,P00053
         L     15,C00054
         BALR  14,15
         L     15,C00055
         BALR  14,15
         LA    1,P00056
         L     15,C00038
         BALR  14,15
         L     4,0(2,5)
         LR    0,4
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00057
         BALR  14,15
         LA    1,P00058
         L     15,C00059
         BALR  14,15
         LR    3,15
         C     3,C00060
         LA    4,1
         BC    8,L00061
         SR    4,4
L00061   DS    0H
         LR    0,4
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00062
         BALR  14,15
         SR    4,4
         IC    4,T00013+2
         LR    0,4
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00057
         BALR  14,15
         SR    4,4
         IC    4,T00013+3
         LR    0,4
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00057
         BALR  14,15
         SR    4,4
         IC    4,T00013+4
         LR    0,4
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00057
         BALR  14,15
         L     15,C00041
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
P00027   DC    A(T00012)
         DC    F'12'
         DC    A(Q00001)
         DC    F'2'
P00030   DC    A(T00009)
         DC    F'1'
         DC    A(T00014)
         DC    F'1'
P00031   DC    A(T00009+1)
         DC    F'1'
         DC    A(T00008)
         DC    F'1'
P00032   DC    A(T00011)
         DC    F'2'
         DC    A(T00009)
         DC    F'2'
P00033   DC    A(T00011+2)
         DC    F'1'
         DC    A(T00010)
         DC    F'1'
P00034   DC    A(0)
         DC    F'3'
         DC    A(T00011)
         DC    F'3'
P00036   DC    A(0)
         DC    F'7'
         DC    A(Q00002)
         DC    F'7'
P00037   DC    F'6'
         DC    A(Q00003)
P00039   DC    A(T00012)
         DC    F'12'
P00042   DC    A(T00012)
         DC    F'5'
P00043   DC    A(Q00004)
         DC    F'2'
P00047   DC    A(0)
         DC    A(Q00005)
P00048   DC    A(0)
P00050   DC    A(T00013)
         DC    F'12'
         DC    A(Q00006)
         DC    F'1'
P00051   DC    A(0)
         DC    A(Q00005)
         DC    F'0'
P00053   DC    A(T00013)
         DC    F'12'
P00056   DC    F'6'
         DC    A(Q00007)
P00058   DC    A(T00013)
         DC    F'12'
         DC    A(T00012)
         DC    F'12'
C00028   DC    V(F77STRCP)
C00029   DC    F'2'
C00035   DC    F'5'
C00038   DC    V(F77WRBEG)
C00040   DC    V(F77WRA)
C00041   DC    V(F77WREND)
C00045   DC    A(G00044)
C00049   DC    V(F77REWND)
C00052   DC    V(F77RDBEG)
C00054   DC    V(F77RDS)
C00055   DC    V(F77RDEND)
C00057   DC    V(F77WRI)
C00059   DC    V(F77STRCM)
C00060   DC    F'0'
C00062   DC    V(F77WRL)
C00046   DC    H'-4'
Q00003   DC    C'(1X,A,A)'
Q00005   DC    C'(A)'
Q00007   DC    C'('' >F'',I3,L2,3I2)'
Q00001   DC    C'>N'
Q00002   DC    C'WXYZ 42'
Q00004   DC    C'>T'
Q00006   DC    C'?'
G00044   CSECT
         DS    0D
         DC    X'000000070000001F'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
