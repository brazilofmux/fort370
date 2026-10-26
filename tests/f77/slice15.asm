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
L00002   DS    0H
L00004   DS    0H
L00006   DS    0H
L00003   DS    0H
L00008   DS    0H
         LA    1,P00015
         L     15,C00016
         BALR  14,15
         LA    1,P00017
         L     15,C00018
         BALR  14,15
         L     15,C00019
         BALR  14,15
L00009   DS    0H
         LA    1,P00020
         L     15,C00021
         BALR  14,15
         B     L00011
L00005   DS    0H
L00007   DS    0H
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
P00015   DC    F'6'
         DC    A(Q00001)
P00017   DC    F'102'
P00020   DC    F'0'
C00016   DC    V(F77WRBEG)
C00018   DC    V(F77WRI)
C00019   DC    V(F77WREND)
C00021   DC    V(EXIT)
Q00001   DC    C'(''OK'',I4)'
* T
T        CSECT
         USING *,15
         B     L00029
         DC    AL1(1),CL7'T'
L00029   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00030
L00031   DC    A(S00022)
L00030   L     15,L00031
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00022,13
         ST    1,S00022+72
L00023   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         C     2,C00032
         BC    2,L00024
L00025   DS    0H
L00026   DS    0H
         L     2,0(,3)
         A     2,C00033
         ST    2,0(,3)
         LA    0,0
         B     L00028
L00024   DS    0H
         L     2,0(,3)
         A     2,C00034
         ST    2,0(,3)
         B     L00026
L00027   DS    0H
L00028   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00022   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00032   DC    F'0'
C00033   DC    F'100'
C00034   DC    F'1'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
