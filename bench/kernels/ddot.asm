* main
F77MAIN  CSECT
         USING *,15
         B     L00020
         DC    AL1(7),CL7'F77MAIN'
L00020   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00021
L00022   DC    A(S00000)
L00021   L     15,L00022
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00004   DS    0H
         L     5,C00023
         L     4,C00024
L00005   DS    0H
         LR    7,5
         AH    7,C00025
         LD    4,C00026
         LR    6,4
         AH    6,C00025
         LD    2,C00027
         LA    8,8
         LH    9,C00028
         LA    2,8
         LA    3,1
L00006   DS    0H
         LR    0,3
         X     0,C00029
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00030
         MDR   0,4
         STD   0,0(2,7)
L00008   DS    0H
         LR    0,3
         X     0,C00029
         ST    0,S00000+84
         LD    6,S00000+80
         SD    6,C00030
         LDR   0,2
         DDR   0,6
         STD   0,0(2,6)
         A     3,C00031
         BXLE  2,8,L00006
L00007   DS    0H
         L     14,C00033
         L     2,0(,14)
         S     2,C00031
         A     2,C00031
L00009   DS    0H
         LH    6,C00034
         LA    7,0
         AH    5,C00025
         AH    4,C00025
         C     2,C00035
         BC    2,L00036
         MVC   S00000+176(8),C00037
         B     L00011
L00036   DS    0H
         LD    0,C00037
         B     L00010
L00011   DS    0H
         LA    0,6
         ST    0,P00038+0
         L     0,C00039
         ST    0,P00038+4
         LA    1,P00038
         L     15,C00040
         BALR  14,15
         LD    0,S00000+176
         STD   0,P00038+0
         LA    1,P00038
         L     15,C00041
         BALR  14,15
         L     15,C00042
         BALR  14,15
L00017   DS    0H
         LA    0,0
         ST    0,P00038+0
         LA    1,P00038
         L     15,C00043
         BALR  14,15
         B     L00019
L00010   DS    0H
L00012   DS    0H
         LA    8,8
         LH    9,C00028
         LA    3,8
L00013   DS    0H
L00015   DS    0H
         LD    2,0(3,5)
         MD    2,0(3,4)
         ADR   0,2
         BXLE  3,8,L00013
L00014   DS    0H
L00016   DS    0H
         BXH   2,6,L00010
         STD   0,S00000+176
         B     L00011
L00018   DS    0H
L00019   DS    0H
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
P00038   DS    2F
C00026   DC    X'3E4189374BC6A7F0'
C00027   DC    X'4110000000000000'
C00030   DC    X'4E00000080000000'
C00037   DC    X'0000000000000000'
C00023   DC    A(T00002)
C00024   DC    A(T00003)
C00029   DC    F'-2147483648'
C00031   DC    F'1'
C00033   DC    A(G00032)
C00035   DC    F'0'
C00039   DC    A(Q00001)
C00040   DC    V(F77WRBEG)
C00041   DC    V(F77WRD)
C00042   DC    V(F77WREND)
C00043   DC    V(EXIT)
C00025   DC    H'-8'
C00028   DC    H'8000'
C00034   DC    H'-1'
Q00001   DC    C'('' DDOT CHECKSUM '',D22.15)'
         DS    0D
T00002   DS    1001D
         DS    0D
T00003   DS    1001D
G00032   CSECT
         DS    0D
         DC    X'00030D40'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
