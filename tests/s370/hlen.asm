* main
F77MAIN  CSECT
         USING *,15
         B     L00010
         DC    AL1(7),CL7'F77MAIN'
L00010   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00011
L00012   DC    A(S00000)
L00011   L     15,L00012
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00004   DS    0H
         L     4,C00014
         LA    0,1
         X     0,C00015
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00016
         LD    2,C00017
         ADR   2,0
         STD   2,S00000+216
         LA    1,P00018
         L     15,C00019
         BALR  14,15
         LA    1,P00020
         L     15,C00021
         BALR  14,15
         LD    0,C00017
         STD   0,P00022+0
         LA    1,P00022
         L     15,C00023
         BALR  14,15
         LD    0,S00000+216
         STD   0,P00022+0
         LA    1,P00022
         L     15,C00023
         BALR  14,15
         LA    1,P00024
         L     15,C00025
         BALR  14,15
         LD    0,C00027
         STD   0,P00026+0
         LD    0,C00028
         STD   0,P00026+8
         LA    1,P00026
         L     15,C00029
         BALR  14,15
         AH    4,C00030
         LA    2,4
         LA    3,2
L00005   DS    0H
         C     3,C00031
         BC    2,L00006
L00007   DS    0H
         L     15,C00032
         BALR  14,15
L00008   DS    0H
         B     L00009
L00006   DS    0H
         L     6,0(2,4)
         LR    0,6
         ST    0,P00033+0
         LA    1,P00033
         L     15,C00034
         BALR  14,15
         AH    3,C00035
         A     2,C00036
         B     L00005
L00009   DS    0H
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
T00003   DS    XL36
         DS    XL4
         DS    1D
P00018   DC    A(T00003)
         DC    F'8'
         DC    A(Q00001)
         DC    F'3'
P00020   DC    F'6'
         DC    A(Q00002)
P00022   DC    A(0)
         DC    A(0)
P00024   DC    A(T00003)
         DC    F'8'
P00026   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
P00033   DC    A(0)
         DS    XL4
C00016   DC    X'4E00000080000000'
C00017   DC    X'4118000000000000'
C00027   DC    X'4110000000000000'
C00028   DC    X'4120000000000000'
C00014   DC    A(G00013)
C00015   DC    F'-2147483648'
C00019   DC    V(F77STRCP)
C00021   DC    V(F77WRBEG)
C00023   DC    V(F77WRD)
C00025   DC    V(F77WRA)
C00029   DC    V(F77WRZ)
C00031   DC    F'0'
C00032   DC    V(F77WREND)
C00034   DC    V(F77WRI)
C00036   DC    F'4'
C00030   DC    H'-4'
C00035   DC    H'-1'
Q00002   DC    C'(1X,''>'',2F6.2,1X,A8,2F6.2,1X,2A4)'
Q00001   DC    C'ABC'
G00013   CSECT
         DS    0D
         DC    X'C1C2C3C4C1C2C3C4'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
