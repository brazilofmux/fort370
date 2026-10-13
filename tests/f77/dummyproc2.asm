* main
F77MAIN  CSECT
         USING *,15
         B     L00005
         DC    AL1(7),CL7'F77MAIN'
L00005   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00006
L00007   DC    A(S00000)
L00006   L     15,L00007
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00002   DS    0H
         MVC   T00001(8),C00008
         LA    0,6
         ST    0,P00009+0
         LA    0,0
         ST    0,P00009+4
         LA    1,P00009
         L     15,C00010
         BALR  14,15
         LA    0,T00001
         ST    0,P00009+0
         OI    P00009+0,X'80'
         LA    1,P00009
         L     15,C00011
         BALR  14,15
         STD   0,S00000+200
         LD    0,S00000+200
         STD   0,P00009+0
         LA    1,P00009
         L     15,C00012
         BALR  14,15
         L     15,C00013
         BALR  14,15
L00003   DS    0H
L00004   DS    0H
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
T00001   DS    XL20
         DS    XL4
         DS    1D
P00009   DS    2F
C00008   DC    X'4120000000000000'
C00010   DC    V(F77WRBEG)
C00011   DC    V(DF)
C00012   DC    V(F77WRD)
C00013   DC    V(F77WREND)
* S
S        CSECT
         USING *,15
         B     L00017
         DC    AL1(1),CL7'S'
L00017   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00018
L00019   DC    A(S00014)
L00018   L     15,L00019
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00014,13
         ST    1,S00014+72
L00015   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         LA    0,6
         ST    0,P00020+0
         LA    0,0
         ST    0,P00020+4
         LA    1,P00020
         L     15,C00021
         BALR  14,15
         LR    0,3
         ST    0,P00020+0
         OI    P00020+0,X'80'
         LA    1,P00020
         LR    15,4
         BALR  14,15
         STD   0,S00014+176
         LD    0,S00014+176
         STD   0,P00020+0
         LA    1,P00020
         L     15,C00022
         BALR  14,15
         L     15,C00023
         BALR  14,15
         LA    0,0
L00016   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00014   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
         DS    1D
P00020   DS    2F
C00021   DC    V(F77WRBEG)
C00022   DC    V(F77WRD)
C00023   DC    V(F77WREND)
* DF
DF       CSECT
         USING *,15
         B     L00027
         DC    AL1(2),CL7'DF'
L00027   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00028
L00029   DC    A(S00024)
L00028   L     15,L00029
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00024,13
         ST    1,S00024+72
L00025   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         LD    0,C00030
         MD    0,0(,2)
L00026   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00024   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00030   DC    X'4130000000000000'
         END
