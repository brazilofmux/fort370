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
         LA    0,7
         ST    0,P00016+0
         LA    1,P00016
         L     15,C00017
         BALR  14,15
         L     0,C00019
         ST    0,P00016+0
         LA    0,10
         ST    0,P00016+4
         LA    0,1
         ST    0,P00016+8
         L     0,C00020
         ST    0,P00016+12
         LA    0,0
         ST    0,P00016+16
         LA    1,P00016
         L     15,C00021
         BALR  14,15
         LA    0,T00004
         ST    0,P00016+0
         LA    1,P00016
         L     15,C00022
         BALR  14,15
         LA    0,T00003
         ST    0,P00016+0
         LA    1,P00016
         L     15,C00022
         BALR  14,15
         L     15,C00023
         BALR  14,15
         LA    0,6
         ST    0,P00016+0
         L     0,C00024
         ST    0,P00016+4
         LA    1,P00016
         L     15,C00025
         BALR  14,15
         L     14,C00027
         L     4,0(,14)
         LR    0,4
         ST    0,P00016+0
         LA    1,P00016
         L     15,C00028
         BALR  14,15
         AH    3,C00029
         LA    2,4
         LA    4,2
L00006   DS    0H
         C     4,C00030
         BC    2,L00007
L00008   DS    0H
         L     14,C00031
         L     3,0(,14)
         LR    0,3
         ST    0,P00016+0
         LA    1,P00016
         L     15,C00028
         BALR  14,15
         L     14,C00033
         LE    0,0(,14)
         STE   0,S00000+216
         LE    0,S00000+216
         STE   0,P00016+0
         LA    1,P00016
         L     15,C00034
         BALR  14,15
         L     14,C00036
         LD    0,0(,14)
         STD   0,S00000+216
         LD    0,S00000+216
         STD   0,P00016+0
         LA    1,P00016
         L     15,C00037
         BALR  14,15
         L     3,T00004
         LR    0,3
         ST    0,P00016+0
         LA    1,P00016
         L     15,C00028
         BALR  14,15
         L     3,T00004
         LR    0,3
         ST    0,P00016+0
         LA    1,P00016
         L     15,C00028
         BALR  14,15
         L     3,T00003
         LR    0,3
         ST    0,P00016+0
         LA    1,P00016
         L     15,C00028
         BALR  14,15
         L     15,C00038
         BALR  14,15
L00009   DS    0H
         B     L00010
L00007   DS    0H
         L     6,0(2,3)
         LR    0,6
         ST    0,P00016+0
         LA    1,P00016
         L     15,C00028
         BALR  14,15
         AH    4,C00039
         A     2,C00040
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
P00016   DS    5F
         DS    XL4
C00015   DC    A(G00014)
C00017   DC    V(F77FMTLM)
C00019   DC    A(G00018)
C00020   DC    A(Q00001)
C00021   DC    V(F77RDBI)
C00022   DC    V(F77RDI)
C00023   DC    V(F77RDEND)
C00024   DC    A(Q00002)
C00025   DC    V(F77WRBEG)
C00027   DC    A(G00026)
C00028   DC    V(F77WRI)
C00030   DC    F'0'
C00031   DC    A(G00014+4)
C00033   DC    A(G00032)
C00034   DC    V(F77WRR)
C00036   DC    A(G00035)
C00037   DC    V(F77WRD)
C00038   DC    V(F77WREND)
C00040   DC    F'4'
C00029   DC    H'-4'
C00039   DC    H'-1'
Q00002   DC    C'(1X,''>HOLTEXT '',A1,A1,A4,A2,1X,A4,1X,A'
         DC    C'8,1X,A4,1X,A6,1X,A4)'
Q00001   DC    C'(A4,A6)'
G00026   CSECT
         DS    0D
         DC    X'F5404040'
G00014   CSECT
         DS    0D
         DC    X'C1404040E6E7E8E9'
G00032   CSECT
         DS    0D
         DC    X'C1C2C3C4'
G00035   CSECT
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
