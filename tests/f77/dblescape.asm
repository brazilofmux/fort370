* main
F77MAIN  CSECT
         USING *,15
         B     L00007
         DC    AL1(7),CL7'F77MAIN'
L00007   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00008
L00009   DC    A(S00000)
L00008   L     15,L00009
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00003   DS    0H
         MVC   T00002(8),C00010
         LA    1,P00011
         L     15,C00012
         BALR  14,15
         LA    1,P00013
         L     15,C00014
         BALR  14,15
         L     15,C00015
         BALR  14,15
         LD    0,C00016
         AD    0,C00017
         STD   0,S00000+192
L00004   DS    0H
         LA    1,P00018
         L     15,C00019
         BALR  14,15
         LD    0,T00002
         STD   0,S00000+200
         LD    0,S00000+200
         STD   0,P00020+0
         LA    1,P00020
         L     15,C00021
         BALR  14,15
         LD    0,S00000+192
         STD   0,P00020+0
         LA    1,P00020
         L     15,C00021
         BALR  14,15
         L     15,C00022
         BALR  14,15
L00005   DS    0H
L00006   DS    0H
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
T00002   DS    XL12
         DS    XL4
         DS    2D
P00011   DC    F'5'
         DC    F'0'
         DC    F'0'
P00013   DC    A(T00002)
P00018   DC    F'6'
         DC    A(Q00001)
P00020   DC    A(0)
         DC    A(0)
C00010   DC    X'4118000000000000'
C00016   DC    X'4128000000000000'
C00017   DC    X'4110000000000000'
C00012   DC    V(F77RDBEG)
C00014   DC    V(F77RDD)
C00015   DC    V(F77RDEND)
C00019   DC    V(F77WRBEG)
C00021   DC    V(F77WRD)
C00022   DC    V(F77WREND)
Q00001   DC    C'(1X,2F10.3)'
* BUMP
BUMP     CSECT
         USING *,15
         B     L00026
         DC    AL1(4),CL7'BUMP'
L00026   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00027
L00028   DC    A(S00023)
L00027   L     15,L00028
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00023,13
         ST    1,S00023+72
L00024   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         LD    0,C00029
         AD    0,0(,2)
         STD   0,0(,2)
         LA    0,0
L00025   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00023   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00029   DC    X'4110000000000000'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
