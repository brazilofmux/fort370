* main
F77MAIN  CSECT
         USING *,15
         B     L00030
         DC    AL1(7),CL7'F77MAIN'
L00030   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00031
L00032   DC    A(S00000)
L00031   L     15,L00032
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00006   DS    0H
         L     3,C00033
         L     4,C00034
         L     2,C00035
L00007   DS    0H
         LR    7,2
         AH    7,C00036
         LD    2,C00037
         LA    8,8
         LH    9,C00038
         LA    5,8
         LA    6,1
L00008   DS    0H
L00010   DS    0H
         LR    0,6
         X     0,C00039
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00040
         MDR   0,2
         STD   0,0(5,7)
         A     6,C00041
         BXLE  5,8,L00008
L00009   DS    0H
L00011   DS    0H
         LR    10,3
         AH    10,C00036
         LD    4,C00042
         LR    7,4
         AH    7,C00036
         LD    2,C00043
         LA    8,8
         LH    9,C00044
         LA    5,8
         LA    6,1
L00012   DS    0H
         LR    0,6
         X     0,C00039
         ST    0,S00000+84
         LD    6,S00000+80
         SD    6,C00040
         LDR   0,4
         DDR   0,6
         STD   0,0(5,10)
L00014   DS    0H
         LR    0,6
         X     0,C00039
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00040
         MDR   0,2
         STD   0,0(5,7)
         A     6,C00041
         BXLE  5,8,L00012
L00013   DS    0H
         L     14,C00046
         L     5,0(,14)
         S     5,C00041
         A     5,C00041
L00015   DS    0H
         LH    10,C00047
         LA    11,0
         L     7,C00048
         AH    7,C00036
         AH    2,C00036
         AH    4,C00036
         AH    3,C00036
         C     5,C00049
         BC    2,L00016
L00017   DS    0H
L00023   DS    0H
         L     3,C00048
         AH    3,C00036
         LA    4,8
         LH    5,C00050
         LA    2,8
         LD    0,C00051
L00024   DS    0H
L00026   DS    0H
         AD    0,0(2,3)
         BXLE  2,4,L00024
         STD   0,S00000+176
L00025   DS    0H
         LA    0,6
         ST    0,P00052+0
         L     0,C00053
         ST    0,P00052+4
         LA    1,P00052
         L     15,C00054
         BALR  14,15
         LD    0,S00000+176
         STD   0,P00052+0
         LA    1,P00052
         L     15,C00055
         BALR  14,15
         L     15,C00056
         BALR  14,15
L00027   DS    0H
         LA    0,0
         ST    0,P00052+0
         LA    1,P00052
         L     15,C00057
         BALR  14,15
         B     L00029
L00016   DS    0H
L00018   DS    0H
         LA    8,8
         LH    9,C00050
         LA    6,8
L00019   DS    0H
         LD    0,C00058
         MD    0,0(6,3)
         AD    0,0(6,4)
         MD    0,C00058
         LD    2,0(6,2)
         ADR   2,0
         LD    0,C00058
         MD    0,8(6,2)
         AD    0,16(6,2)
         MD    0,C00058
         AD    0,24(6,2)
         LD    4,C00059
         MD    4,32(6,2)
         AD    4,40(6,2)
         MD    4,C00059
         AD    4,48(6,2)
         MD    4,C00060
         ADR   0,4
         MD    0,C00060
         ADR   2,0
         STD   2,0(6,7)
L00021   DS    0H
         BXLE  6,8,L00019
L00020   DS    0H
L00022   DS    0H
         BXH   5,10,L00016
         B     L00017
L00028   DS    0H
L00029   DS    0H
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
P00052   DS    2F
C00037   DC    X'3E4189374BC6A7F0'
C00040   DC    X'4E00000080000000'
C00042   DC    X'4110000000000000'
C00043   DC    X'3E83126E978D4FDF'
C00051   DC    X'0000000000000000'
C00058   DC    X'4040000000000000'
C00059   DC    X'4080000000000000'
C00060   DC    X'4020000000000000'
C00033   DC    A(T00003)
C00034   DC    A(T00004)
C00035   DC    A(T00005)
C00039   DC    F'-2147483648'
C00041   DC    F'1'
C00046   DC    A(G00045)
C00048   DC    A(T00002)
C00049   DC    F'0'
C00053   DC    A(Q00001)
C00054   DC    V(F77WRBEG)
C00055   DC    V(F77WRD)
C00056   DC    V(F77WREND)
C00057   DC    V(EXIT)
C00036   DC    H'-8'
C00038   DC    H'8056'
C00044   DC    H'8008'
C00047   DC    H'-1'
C00050   DC    H'8000'
Q00001   DC    C'('' >LLL7S '',D22.15)'
         DS    0D
T00002   DS    1002D
         DS    0D
T00003   DS    1002D
         DS    0D
T00004   DS    1002D
         DS    0D
T00005   DS    1008D
G00045   CSECT
         DS    0D
         DC    X'00000002'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
