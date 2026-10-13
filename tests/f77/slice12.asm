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
L00001   DS    0H
         LD    0,C00010
         MD    0,C00010
L00002   DS    0H
         CD    0,C00011
         LA    3,1
         BC    8,L00012
         SR    3,3
L00012   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00013
         SR    2,2
L00013   DS    0H
         LTR   2,2
         BC    7,L00003
L00004   DS    0H
         LA    0,0
         ST    0,P00014+0
         LA    1,P00014
         L     15,C00015
         BALR  14,15
         B     L00006
L00003   DS    0H
         LA    0,161
         ST    0,P00014+0
         LA    1,P00014
         L     15,C00015
         BALR  14,15
         B     L00006
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
P00014   DS    1F
         DS    XL4
C00010   DC    X'4130000000000000'
C00011   DC    X'4190000000000000'
C00015   DC    V(EXIT)
* F
F        CSECT
         USING *,15
         B     L00019
         DC    AL1(1),CL7'F'
L00019   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00020
L00021   DC    A(S00016)
L00020   L     15,L00021
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00016,13
         ST    1,S00016+72
L00017   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         LD    0,0(,2)
         MDR   0,0
L00018   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00016   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
         END
