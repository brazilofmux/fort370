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
         L     5,C00014
         LA    1,P00015
         L     15,C00016
         BALR  14,15
         LA    1,P00017
         L     15,C00018
         BALR  14,15
         LA    1,P00020
         L     15,C00021
         BALR  14,15
         LA    1,P00022
         L     15,C00021
         BALR  14,15
         AH    5,C00023
         LA    2,3
         LA    3,2
L00005   DS    0H
         C     3,C00024
         BC    2,L00006
L00007   DS    0H
         L     15,C00025
         BALR  14,15
L00008   DS    0H
         B     L00009
L00006   DS    0H
         LR    4,5
         AR    4,2
         LR    0,4
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00021
         BALR  14,15
         AH    3,C00027
         A     2,C00028
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
T00003   DS    XL24
P00015   DC    A(T00003)
         DC    F'7'
         DC    A(Q00001)
         DC    F'7'
P00017   DC    F'6'
         DC    A(Q00002)
P00020   DC    A(G00019)
         DC    F'7'
P00022   DC    A(T00003)
         DC    F'7'
P00026   DC    A(0)
         DC    F'3'
C00014   DC    A(G00013)
C00016   DC    V(F77STRCP)
C00018   DC    V(F77WRBEG)
C00021   DC    V(F77WRA)
C00024   DC    F'0'
C00025   DC    V(F77WREND)
C00028   DC    F'3'
C00023   DC    H'-3'
C00027   DC    H'-1'
Q00002   DC    C'(1X,''>'',A7,1X,A7,1X,2A3)'
Q00001   DC    C'GHIJKLM'
G00019   CSECT
         DS    0D
         DC    X'D6D5C54EE3E6D6'
G00013   CSECT
         DS    0D
         DC    X'C1C2C3C4C5C6'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
