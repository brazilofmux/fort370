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
L00006   DS    0H
         LA    1,P00013
         L     15,C00014
         BALR  14,15
         LA    1,P00015
         L     15,C00016
         BALR  14,15
         LA    1,P00017
         L     15,C00018
         BALR  14,15
         LR    3,15
         LR    0,3
         ST    0,P00019+0
         LA    1,P00019
         L     15,C00020
         BALR  14,15
         L     15,C00021
         BALR  14,15
L00007   DS    0H
         LA    1,P00022
         L     15,C00016
         BALR  14,15
         L     15,C00021
         BALR  14,15
L00008   DS    0H
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
T00005   DS    XL84
         DS    XL4
P00013   DC    A(T00005)
         DC    F'80'
         DC    A(Q00001)
         DC    F'63'
P00015   DC    F'6'
         DC    A(Q00002)
P00017   DC    A(T00005)
         DC    F'80'
         DC    A(Q00003)
         DC    F'2'
P00019   DC    A(0)
P00022   DC    F'6'
         DC    A(Q00004)
         DS    XL4
C00014   DC    V(F77STRCP)
C00016   DC    V(F77WRBEG)
C00018   DC    V(F77INDEX)
C00020   DC    V(F77WRI)
C00021   DC    V(F77WREND)
Q00002   DC    C'(1X,''>CONTSTR'',I4)'
Q00004   DC    C'(1X,''XY                                '
         DC    C'                  Z'',''<'')'
Q00001   DC    C'AB                                      '
         DC    C'                     CD'
Q00003   DC    C'CD'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
