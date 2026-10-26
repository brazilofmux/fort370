* main
F77MAIN  CSECT
         USING *,15
         B     L00009
         DC    AL1(7),CL7'F77MAIN'
L00009   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00010
L00011   DC    A(S00000)
L00010   L     15,L00011
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00004   DS    0H
         LA    1,P00012
         L     15,C00013
         BALR  14,15
         LD    0,C00015
         STD   0,P00014+0
         LA    1,P00014
         L     15,C00016
         BALR  14,15
         LD    0,C00017
         STD   0,P00014+0
         LA    1,P00014
         L     15,C00016
         BALR  14,15
         LD    0,C00015
         STD   0,P00014+0
         LA    1,P00014
         L     15,C00016
         BALR  14,15
         LD    0,C00017
         STD   0,P00014+0
         LA    1,P00014
         L     15,C00016
         BALR  14,15
         L     15,C00018
         BALR  14,15
         LA    1,P00019
         L     15,C00013
         BALR  14,15
         LD    0,C00015
         STD   0,P00014+0
         LA    1,P00014
         L     15,C00016
         BALR  14,15
         LD    0,C00017
         STD   0,P00014+0
         LA    1,P00014
         L     15,C00016
         BALR  14,15
         L     15,C00018
         BALR  14,15
         LA    1,P00020
         L     15,C00013
         BALR  14,15
         LD    0,C00015
         STD   0,P00014+0
         LA    1,P00014
         L     15,C00016
         BALR  14,15
         LD    0,C00015
         STD   0,P00014+0
         LA    1,P00014
         L     15,C00016
         BALR  14,15
         L     15,C00018
         BALR  14,15
L00005   DS    0H
L00006   DS    0H
L00007   DS    0H
L00008   DS    0H
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
P00012   DC    F'6'
         DC    A(Q00001)
P00014   DC    A(0)
         DC    A(0)
P00019   DC    F'6'
         DC    A(Q00002)
P00020   DC    F'6'
         DC    A(Q00003)
C00015   DC    X'0000000000000000'
C00017   DC    X'4118000000000000'
C00013   DC    V(F77WRBEG)
C00016   DC    V(F77WRD)
C00018   DC    V(F77WREND)
Q00001   DC    C'('' >'',1PE10.2,E10.2,0PE10.2,E10.2)'
Q00002   DC    C'('' >'',2PE12.3,-1PE12.3)'
Q00003   DC    C'('' >'',1PD14.5,1PE12.3E3)'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
