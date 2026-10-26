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
L00005   DS    0H
         L     4,C00028
         L     5,C00029
L00006   DS    0H
         LR    7,4
         AH    7,C00030
         LD    2,C00031
         LD    6,C00032
         LR    6,5
         AH    6,C00030
         LD    4,C00033
         LA    8,8
         LH    9,C00034
         LA    2,8
         LA    3,1
L00007   DS    0H
         LR    0,3
         X     0,C00035
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00036
         MDR   0,6
         ADR   0,2
         STD   0,0(2,7)
L00009   DS    0H
         STD   4,0(2,6)
         A     3,C00037
         BXLE  2,8,L00007
L00008   DS    0H
         L     14,C00039
         MVC   0(8,14),C00038
         L     14,C00041
         L     2,0(,14)
         S     2,C00037
         A     2,C00037
L00010   DS    0H
         LH    10,C00042
         LA    11,0
         L     9,C00039
         AH    9,C00030
         AH    5,C00030
         AH    4,C00030
         LR    8,9
         AH    8,C00030
         C     2,C00043
         BC    2,L00011
L00012   DS    0H
L00018   DS    0H
         L     3,C00039
         AH    3,C00030
         LA    4,8
         LH    5,C00044
         LA    2,8
         LD    0,C00038
L00019   DS    0H
L00021   DS    0H
         AD    0,0(2,3)
         BXLE  2,4,L00019
         STD   0,S00000+176
L00020   DS    0H
         LA    1,P00045
         L     15,C00046
         BALR  14,15
         LD    0,S00000+176
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
L00022   DS    0H
         LA    1,P00050
         L     15,C00051
         BALR  14,15
         B     L00024
L00011   DS    0H
L00013   DS    0H
         LA    6,8
         LH    7,C00044
         LA    3,16
L00014   DS    0H
L00016   DS    0H
         LD    0,0(3,4)
         SD    0,0(3,8)
         MD    0,0(3,5)
         STD   0,0(3,9)
         BXLE  3,6,L00014
L00015   DS    0H
L00017   DS    0H
         BXH   2,10,L00011
         B     L00012
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
         DS    1D
P00045   DC    F'6'
         DC    A(Q00001)
P00047   DC    A(0)
         DC    A(0)
P00050   DC    F'0'
         DS    XL4
C00031   DC    X'4110000000000000'
C00032   DC    X'3E4189374BC6A7F0'
C00033   DC    X'4080000000000000'
C00036   DC    X'4E00000080000000'
C00038   DC    X'0000000000000000'
C00028   DC    A(T00003)
C00029   DC    A(T00004)
C00035   DC    F'-2147483648'
C00037   DC    F'1'
C00039   DC    A(T00002)
C00041   DC    A(G00040)
C00043   DC    F'0'
C00046   DC    V(F77WRBEG)
C00048   DC    V(F77WRD)
C00049   DC    V(F77WREND)
C00051   DC    V(EXIT)
C00030   DC    H'-8'
C00034   DC    H'8008'
C00042   DC    H'-1'
C00044   DC    H'8000'
Q00001   DC    C'('' LLL5 CHECKSUM '',D22.15)'
         DS    0D
T00002   DS    1002D
         DS    0D
T00003   DS    1002D
         DS    0D
T00004   DS    1002D
G00040   CSECT
         DS    0D
         DC    X'00030D40'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
