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
         LA    0,T00005
         ST    0,P00013+0
         LA    0,80
         ST    0,P00013+4
         L     0,C00014
         ST    0,P00013+8
         LA    0,63
         ST    0,P00013+12
         LA    1,P00013
         L     15,C00015
         BALR  14,15
         LA    0,6
         ST    0,P00013+0
         L     0,C00016
         ST    0,P00013+4
         LA    1,P00013
         L     15,C00017
         BALR  14,15
         LA    0,T00005
         ST    0,P00013+0
         LA    0,80
         ST    0,P00013+4
         L     0,C00018
         ST    0,P00013+8
         LA    0,2
         ST    0,P00013+12
         LA    1,P00013
         L     15,C00019
         BALR  14,15
         LR    3,15
         LR    0,3
         ST    0,P00013+0
         LA    1,P00013
         L     15,C00020
         BALR  14,15
         L     15,C00021
         BALR  14,15
L00007   DS    0H
         LA    0,6
         ST    0,P00013+0
         L     0,C00022
         ST    0,P00013+4
         LA    1,P00013
         L     15,C00017
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
P00013   DS    4F
C00014   DC    A(Q00001)
C00015   DC    V(F77STRCP)
C00016   DC    A(Q00002)
C00017   DC    V(F77WRBEG)
C00018   DC    A(Q00003)
C00019   DC    V(F77INDEX)
C00020   DC    V(F77WRI)
C00021   DC    V(F77WREND)
C00022   DC    A(Q00004)
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
