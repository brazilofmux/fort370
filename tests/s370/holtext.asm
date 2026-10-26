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
L00005   DS    0H
         L     3,C00015
         LA    1,P00016
         L     15,C00017
         BALR  14,15
         LA    1,P00019
         L     15,C00020
         BALR  14,15
         LA    1,P00021
         L     15,C00022
         BALR  14,15
         LA    1,P00023
         L     15,C00022
         BALR  14,15
         L     15,C00024
         BALR  14,15
         LA    1,P00025
         L     15,C00026
         BALR  14,15
         L     14,C00028
         L     4,0(,14)
         LR    0,4
         ST    0,P00029+0
         LA    1,P00029
         L     15,C00030
         BALR  14,15
         AH    3,C00031
         LA    2,4
         LA    4,2
L00006   DS    0H
         C     4,C00032
         BC    2,L00007
L00008   DS    0H
         L     14,C00033
         L     3,0(,14)
         LR    0,3
         ST    0,P00029+0
         LA    1,P00029
         L     15,C00030
         BALR  14,15
         L     14,C00035
         LE    0,0(,14)
         STE   0,S00000+216
         LE    0,S00000+216
         STE   0,P00036+0
         LA    1,P00036
         L     15,C00037
         BALR  14,15
         L     14,C00039
         LD    0,0(,14)
         STD   0,S00000+216
         LD    0,S00000+216
         STD   0,P00040+0
         LA    1,P00040
         L     15,C00041
         BALR  14,15
         L     3,T00004
         LR    0,3
         ST    0,P00029+0
         LA    1,P00029
         L     15,C00030
         BALR  14,15
         L     3,T00004
         LR    0,3
         ST    0,P00029+0
         LA    1,P00029
         L     15,C00030
         BALR  14,15
         L     3,T00003
         LR    0,3
         ST    0,P00029+0
         LA    1,P00029
         L     15,C00030
         BALR  14,15
         L     15,C00042
         BALR  14,15
L00009   DS    0H
         B     L00010
L00007   DS    0H
         L     6,0(2,3)
         LR    0,6
         ST    0,P00029+0
         LA    1,P00029
         L     15,C00030
         BALR  14,15
         AH    4,C00043
         A     2,C00044
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
T00003   DS    XL8
T00004   DS    XL28
         DS    XL4
         DS    1D
P00016   DC    F'7'
P00019   DC    A(G00018)
         DC    F'10'
         DC    F'1'
         DC    A(Q00001)
         DC    F'0'
P00021   DC    A(T00004)
P00023   DC    A(T00003)
P00025   DC    F'6'
         DC    A(Q00002)
P00029   DC    A(0)
         DS    F
P00036   DC    A(0)
         DS    F
P00040   DC    A(0)
         DC    A(0)
C00015   DC    A(G00014)
C00017   DC    V(F77FMTLM)
C00020   DC    V(F77RDBI)
C00022   DC    V(F77RDI)
C00024   DC    V(F77RDEND)
C00026   DC    V(F77WRBEG)
C00028   DC    A(G00027)
C00030   DC    V(F77WRI)
C00032   DC    F'0'
C00033   DC    A(G00014+4)
C00035   DC    A(G00034)
C00037   DC    V(F77WRR)
C00039   DC    A(G00038)
C00041   DC    V(F77WRD)
C00042   DC    V(F77WREND)
C00044   DC    F'4'
C00031   DC    H'-4'
C00043   DC    H'-1'
Q00002   DC    C'(1X,''>HOLTEXT '',A1,A1,A4,A2,1X,A4,1X,A'
         DC    C'8,1X,A4,1X,A6,1X,A4)'
Q00001   DC    C'(A4,A6)'
G00027   CSECT
         DS    0D
         DC    X'F5404040'
G00014   CSECT
         DS    0D
         DC    X'C1404040E6E7E8E9'
G00034   CSECT
         DS    0D
         DC    X'C1C2C3C4'
G00038   CSECT
         DS    0D
         DC    X'C1C2C3C4C5C6C7C8'
G00018   CSECT
         DS    0D
         DC    X'D8D9E2E3E4E5E6E7E8E9'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
