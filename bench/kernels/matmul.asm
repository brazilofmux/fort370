* main
F77MAIN  CSECT
         USING *,15
         B     L00038
         DC    AL1(7),CL7'F77MAIN'
L00038   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00039
L00040   DC    A(S00000)
L00039   L     15,L00040
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00005   DS    0H
L00006   DS    0H
         L     11,C00041
         LA    2,800
         LA    3,1
L00007   DS    0H
L00009   DS    0H
         LA    8,8
         LA    9,800
         LA    4,8
         LA    5,1
L00010   DS    0H
         LR    10,4
         AR    10,2
         L     7,C00042
         AH    7,C00043
         AR    7,10
         LR    6,5
         AR    6,3
         LR    0,6
         X     0,C00044
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00045
         LD    2,C00046
         MDR   0,2
         STD   0,0(,7)
         L     7,C00047
         AH    7,C00043
         AR    7,10
         LR    6,5
         SR    6,3
         LR    0,6
         X     0,C00044
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00045
         LD    2,C00046
         MDR   0,2
         STD   0,0(,7)
L00012   DS    0H
         LR    7,4
         AR    7,2
         L     6,C00048
         AH    6,C00043
         AR    6,7
         LD    0,C00049
         STD   0,0(,6)
         A     5,C00050
         BXLE  4,8,L00010
L00011   DS    0H
         A     3,C00050
         A     2,C00051
         CR    2,11
         BC    12,L00007
L00008   DS    0H
         L     14,C00053
         L     2,0(,14)
         S     2,C00050
         LR    14,2
         A     14,C00050
         ST    14,S00000+176
L00013   DS    0H
         L     14,C00047
         AH    14,C00043
         ST    14,S00000+184
         L     14,C00048
         AH    14,C00043
         ST    14,S00000+192
         L     14,C00042
         AH    14,C00043
         ST    14,S00000+200
         L     14,S00000+176
         C     14,C00054
         BC    2,L00055
         B     L00015
L00055   DS    0H
         L     14,S00000+176
         ST    14,S00000+208
         B     L00014
L00015   DS    0H
L00028   DS    0H
         LA    8,800
         L     9,C00041
         L     5,C00048
         AH    5,C00043
         LA    2,800
         LD    0,C00049
L00029   DS    0H
L00031   DS    0H
         LA    6,8
         LR    4,5
         AR    4,2
         LA    7,800
         LA    3,8
L00032   DS    0H
L00034   DS    0H
         AD    0,0(3,4)
         BXLE  3,6,L00032
L00033   DS    0H
         BXLE  2,8,L00029
         STD   0,S00000+176
L00030   DS    0H
         LA    1,P00056
         L     15,C00057
         BALR  14,15
         LD    0,S00000+176
         STD   0,P00058+0
         LA    1,P00058
         L     15,C00059
         BALR  14,15
         L     15,C00060
         BALR  14,15
L00035   DS    0H
         LA    1,P00061
         L     15,C00062
         BALR  14,15
         B     L00037
L00014   DS    0H
L00016   DS    0H
         LA    14,800
         ST    14,S00000+176
L00017   DS    0H
L00019   DS    0H
         LA    10,800
         L     9,S00000+184
         A     9,S00000+176
         L     11,C00041
         L     8,S00000+192
         A     8,S00000+176
         LA    2,800
         LA    3,8
L00020   DS    0H
         LD    2,0(3,9)
L00022   DS    0H
         LA    6,8
         L     5,S00000+200
         AR    5,2
         LA    7,800
         LA    4,8
L00023   DS    0H
L00025   DS    0H
         LD    0,0(4,5)
         MDR   0,2
         AD    0,0(4,8)
         STD   0,0(4,8)
         BXLE  4,6,L00023
L00024   DS    0H
L00026   DS    0H
         A     3,C00063
         BXLE  2,10,L00020
L00021   DS    0H
         L     14,S00000+176
         A     14,C00051
         ST    14,S00000+216
         L     14,S00000+216
         C     14,C00041
         BC    12,L00064
         B     L00018
L00064   DS    0H
         L     14,S00000+216
         ST    14,S00000+176
         B     L00017
L00018   DS    0H
L00027   DS    0H
         L     14,S00000+208
         A     14,C00065
         ST    14,S00000+176
         L     14,S00000+176
         C     14,C00054
         BC    2,L00066
         B     L00015
L00066   DS    0H
         L     14,S00000+176
         ST    14,S00000+208
         B     L00014
L00036   DS    0H
L00037   DS    0H
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
         DS    6D
P00056   DC    F'6'
         DC    A(Q00001)
P00058   DC    A(0)
         DC    A(0)
P00061   DC    F'0'
         DS    XL4
C00045   DC    X'4E00000080000000'
C00046   DC    X'3F28F5C28F5C28F6'
C00049   DC    X'0000000000000000'
C00041   DC    F'80000'
C00042   DC    A(T00002)
C00044   DC    F'-2147483648'
C00047   DC    A(T00003)
C00048   DC    A(T00004)
C00050   DC    F'1'
C00051   DC    F'800'
C00053   DC    A(G00052)
C00054   DC    F'0'
C00057   DC    V(F77WRBEG)
C00059   DC    V(F77WRD)
C00060   DC    V(F77WREND)
C00062   DC    V(EXIT)
C00063   DC    F'8'
C00065   DC    F'-1'
C00043   DC    H'-808'
Q00001   DC    C'('' MATMUL CHECKSUM '',D22.15)'
         DS    0D
T00002   DS    10001D
         DS    0D
T00003   DS    10001D
         DS    0D
T00004   DS    10001D
G00052   CSECT
         DS    0D
         DC    X'000000C8'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
