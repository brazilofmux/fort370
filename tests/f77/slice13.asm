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
L00003   DS    0H
         LA    0,6
         ST    0,P00012+0
         L     0,C00013
         ST    0,P00012+4
         LA    1,P00012
         L     15,C00014
         BALR  14,15
         L     15,C00015
         BALR  14,15
L00004   DS    0H
         LA    0,6
         ST    0,P00012+0
         L     0,C00016
         ST    0,P00012+4
         LA    1,P00012
         L     15,C00014
         BALR  14,15
         L     15,C00015
         BALR  14,15
L00006   DS    0H
L00005   DS    0H
         LA    0,0
         ST    0,P00012+0
         LA    1,P00012
         L     15,C00017
         BALR  14,15
         B     L00008
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
P00012   DS    2F
C00013   DC    A(Q00001)
C00014   DC    V(F77WRBEG)
C00015   DC    V(F77WREND)
C00016   DC    A(Q00002)
C00017   DC    V(EXIT)
Q00001   DC    C'(''MAIN'')'
Q00002   DC    C'(''SUB'')'
* T
T        CSECT
         USING *,15
         B     L00022
         DC    AL1(1),CL7'T'
L00022   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00023
L00024   DC    A(S00018)
L00023   L     15,L00024
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00018,13
         ST    1,S00018+72
L00019   DS    0H
         LA    0,6
         ST    0,P00025+0
         L     0,C00026
         ST    0,P00025+4
         LA    1,P00025
         L     15,C00027
         BALR  14,15
         L     15,C00028
         BALR  14,15
L00020   DS    0H
         LA    0,0
L00021   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00018   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00025   DS    2F
C00026   DC    A(Q00002)
C00027   DC    V(F77WRBEG)
C00028   DC    V(F77WREND)
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
