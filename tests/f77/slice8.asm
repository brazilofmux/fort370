* main
F77MAIN  CSECT
         USING *,15
         B     L00012
         DC    AL1(7),CL7'F77MAIN'
L00012   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00013
L00014   DC    A(S00000)
L00013   L     15,L00014
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00001   DS    0H
L00002   DS    0H
L00004   DS    0H
L00005   DS    0H
L00007   DS    0H
L00009   DS    0H
         LA    1,P00015
         L     15,C00016
         BALR  14,15
         B     L00011
L00003   DS    0H
L00006   DS    0H
L00008   DS    0H
L00010   DS    0H
L00011   DS    0H
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
P00015   DC    F'0'
         DS    XL4
C00016   DC    V(EXIT)
* TEN
TEN      CSECT
         USING *,15
         B     L00021
         DC    AL1(3),CL7'TEN'
L00021   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00022
L00023   DC    A(S00017)
L00022   L     15,L00023
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00017,13
         ST    1,S00017+72
L00018   DS    0H
         L     11,0(,1)
         L     14,4(,1)
         ST    14,S00017+176
         L     14,8(,1)
         ST    14,S00017+184
         L     10,12(,1)
         L     9,16(,1)
         L     8,20(,1)
         L     7,24(,1)
         L     6,28(,1)
         L     5,32(,1)
         L     4,36(,1)
         L     3,40(,1)
         LA    3,0(,3)
         L     2,0(,11)
         L     15,S00017+176
         A     2,0(,15)
         L     15,S00017+184
         A     2,0(,15)
         A     2,0(,10)
         A     2,0(,9)
         A     2,0(,8)
         A     2,0(,7)
         A     2,0(,6)
         A     2,0(,5)
         A     2,0(,4)
         ST    2,0(,3)
         LA    0,0
         B     L00020
L00019   DS    0H
L00020   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00017   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
         DS    2D
* SWAP
SWAP     CSECT
         USING *,15
         B     L00028
         DC    AL1(4),CL7'SWAP'
L00028   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00029
L00030   DC    A(S00024)
L00029   L     15,L00030
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00024,13
         ST    1,S00024+72
L00025   DS    0H
         L     5,0(,1)
         L     4,4(,1)
         LA    4,0(,4)
         L     3,0(,5)
         L     2,0(,4)
         ST    2,0(,5)
         ST    3,0(,4)
         LA    0,0
         B     L00027
L00026   DS    0H
L00027   DS    0H
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
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
