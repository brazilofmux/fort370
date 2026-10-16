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
L00004   DS    0H
         L     5,C00027
         L     2,C00028
         LD    2,C00029
L00005   DS    0H
         LR    7,5
         AH    7,C00030
         LR    6,2
         AH    6,C00030
         LD    4,C00031
         LA    8,8
         LH    9,C00032
         LA    3,8
         LA    4,1
L00006   DS    0H
         LR    0,4
         X     0,C00033
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00034
         STD   0,0(3,7)
L00008   DS    0H
         STD   4,0(3,6)
         A     4,C00035
         BXLE  3,8,L00006
L00007   DS    0H
         L     14,C00037
         L     3,0(,14)
         S     3,C00035
         A     3,C00035
L00009   DS    0H
         LH    8,C00038
         LA    9,0
         LR    6,2
         AH    6,C00030
         AH    5,C00030
         C     3,C00039
         BC    2,L00010
L00011   DS    0H
L00017   DS    0H
         AH    2,C00030
         LA    4,8
         LH    5,C00032
         LA    3,8
         LD    0,C00031
L00018   DS    0H
L00020   DS    0H
         AD    0,0(3,2)
         BXLE  3,4,L00018
         STD   0,S00000+176
L00019   DS    0H
         LA    0,6
         ST    0,P00040+0
         L     0,C00041
         ST    0,P00040+4
         LA    1,P00040
         L     15,C00042
         BALR  14,15
         LD    0,S00000+176
         STD   0,P00040+0
         LA    1,P00040
         L     15,C00043
         BALR  14,15
         L     15,C00044
         BALR  14,15
L00021   DS    0H
         LA    0,0
         ST    0,P00040+0
         LA    1,P00040
         L     15,C00045
         BALR  14,15
         B     L00023
L00010   DS    0H
L00012   DS    0H
         LA    10,8
         LH    11,C00032
         LA    4,8
L00013   DS    0H
L00015   DS    0H
         LD    0,0(4,5)
         MDR   0,2
         AD    0,0(4,6)
         STD   0,0(4,6)
         BXLE  4,10,L00013
L00014   DS    0H
L00016   DS    0H
         BXH   3,8,L00010
         B     L00011
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
         DS    1D
P00040   DS    2F
C00029   DC    X'3C10C6F7A0B5ED8D'
C00031   DC    X'0000000000000000'
C00034   DC    X'4E00000080000000'
C00027   DC    A(T00002)
C00028   DC    A(T00003)
C00033   DC    F'-2147483648'
C00035   DC    F'1'
C00037   DC    A(G00036)
C00039   DC    F'0'
C00041   DC    A(Q00001)
C00042   DC    V(F77WRBEG)
C00043   DC    V(F77WRD)
C00044   DC    V(F77WREND)
C00045   DC    V(EXIT)
C00030   DC    H'-8'
C00032   DC    H'8000'
C00038   DC    H'-1'
Q00001   DC    C'('' DAXPY CHECKSUM '',D22.15)'
         DS    0D
T00002   DS    1001D
         DS    0D
T00003   DS    1001D
G00036   CSECT
         DS    0D
         DC    X'00030D40'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
