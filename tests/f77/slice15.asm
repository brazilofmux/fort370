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
         LA    0,6
         ST    0,P00015+0
         L     0,C00016
         ST    0,P00015+4
         LA    1,P00015
         L     15,C00017
         BALR  14,15
         LA    0,102
         ST    0,P00015+0
         LA    1,P00015
         L     15,C00018
         BALR  14,15
         L     15,C00019
         BALR  14,15
L00009   DS    0H
         LA    0,0
         ST    0,P00015+0
         LA    1,P00015
         L     15,C00020
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
P00015   DS    2F
C00016   DC    A(Q00001)
C00017   DC    V(F77WRBEG)
C00018   DC    V(F77WRI)
C00019   DC    V(F77WREND)
C00020   DC    V(EXIT)
Q00001   DC    C'(''OK'',I4)'
* T
T        CSECT
         USING *,15
         B     L00028
         DC    AL1(1),CL7'T'
L00028   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00029
L00030   DC    A(S00021)
L00029   L     15,L00030
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00021,13
         ST    1,S00021+72
L00022   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         C     2,C00031
         BC    2,L00023
L00024   DS    0H
L00025   DS    0H
         L     2,0(,3)
         A     2,C00032
         ST    2,0(,3)
         LA    0,0
         B     L00027
L00023   DS    0H
         L     2,0(,3)
         A     2,C00033
         ST    2,0(,3)
         B     L00025
L00026   DS    0H
L00027   DS    0H
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
C00031   DC    F'0'
C00032   DC    F'100'
C00033   DC    F'1'
         END
