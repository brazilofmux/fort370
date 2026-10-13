* main
F77MAIN  CSECT
         USING *,15
         B     L00018
         DC    AL1(7),CL7'F77MAIN'
L00018   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00019
L00020   DC    A(S00000)
L00019   L     15,L00020
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00001   DS    0H
         LA    4,1
L00002   DS    0H
         LA    5,10
         LA    2,0
         LR    3,4
L00003   DS    0H
         AR    2,3
L00005   DS    0H
         BXLE  3,4,L00003
L00004   DS    0H
         C     2,C00021
         BC    7,L00006
L00007   DS    0H
L00008   DS    0H
         LH    6,C00022
         LA    7,0
         LA    4,10
         LA    3,0
         LA    2,1
L00009   DS    0H
         LR    1,2
         MR    0,2
         LR    5,1
         AR    3,5
L00011   DS    0H
         A     2,C00023
         BXH   4,6,L00009
L00010   DS    0H
         C     3,C00024
         BC    7,L00012
L00013   DS    0H
         C     2,C00025
         BC    7,L00014
L00015   DS    0H
         LA    0,0
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         B     L00017
L00006   DS    0H
         LA    0,11
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         B     L00017
L00012   DS    0H
         LA    0,12
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         B     L00017
L00014   DS    0H
         LA    0,13
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         B     L00017
L00016   DS    0H
L00017   DS    0H
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
P00026   DS    1F
         DS    XL4
C00021   DC    F'55'
C00023   DC    F'1'
C00024   DC    F'385'
C00025   DC    F'11'
C00027   DC    V(EXIT)
C00022   DC    H'-1'
         END
