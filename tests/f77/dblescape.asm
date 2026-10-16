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
         LA    0,5
         ST    0,P00011+0
         LA    0,0
         ST    0,P00011+4
         LA    0,0
         ST    0,P00011+8
         LA    1,P00011
         L     15,C00012
         BALR  14,15
         LA    0,T00002
         ST    0,P00011+0
         LA    1,P00011
         L     15,C00013
         BALR  14,15
         L     15,C00014
         BALR  14,15
         LD    0,C00015
         AD    0,C00016
         STD   0,S00000+192
L00004   DS    0H
         LA    0,6
         ST    0,P00011+0
         L     0,C00017
         ST    0,P00011+4
         LA    1,P00011
         L     15,C00018
         BALR  14,15
         LD    0,T00002
         STD   0,S00000+200
         LD    0,S00000+200
         STD   0,P00011+0
         LA    1,P00011
         L     15,C00019
         BALR  14,15
         LD    0,S00000+192
         STD   0,P00011+0
         LA    1,P00011
         L     15,C00019
         BALR  14,15
         L     15,C00020
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
P00011   DS    3F
         DS    XL4
C00010   DC    X'4118000000000000'
C00015   DC    X'4128000000000000'
C00016   DC    X'4110000000000000'
C00012   DC    V(F77RDBEG)
C00013   DC    V(F77RDD)
C00014   DC    V(F77RDEND)
C00017   DC    A(Q00001)
C00018   DC    V(F77WRBEG)
C00019   DC    V(F77WRD)
C00020   DC    V(F77WREND)
Q00001   DC    C'(1X,2F10.3)'
* BUMP
BUMP     CSECT
         USING *,15
         B     L00024
         DC    AL1(4),CL7'BUMP'
L00024   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00025
L00026   DC    A(S00021)
L00025   L     15,L00026
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00021,13
         ST    1,S00021+72
L00022   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         LD    0,C00027
         AD    0,0(,2)
         STD   0,0(,2)
         LA    0,0
L00023   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00021   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00027   DC    X'4110000000000000'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
