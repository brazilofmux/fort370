* f77bd_BD_0
F77BD@BD CSECT
         USING *,15
         B     L00003
         DC    AL1(8),CL7'F77BD@BD'
L00003   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00004
L00005   DC    A(S00000)
L00004   L     15,L00005
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00001   DS    0H
         LA    0,0
L00002   DS    0H
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
* INC
INC      CSECT
         USING *,15
         B     L00009
         DC    AL1(3),CL7'INC'
L00009   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00010
L00011   DC    A(S00006)
L00010   L     15,L00011
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00006,13
         ST    1,S00006+72
L00007   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         A     2,C00012
         LR    0,2
L00008   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00006   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00012   DC    F'1'
* PRINTIT
PRINTIT  CSECT
         USING *,15
         B     L00019
         DC    AL1(7),CL7'PRINTIT'
L00019   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00020
L00021   DC    A(S00013)
L00020   L     15,L00021
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00013,13
         ST    1,S00013+72
L00015   DS    0H
         L     4,0(,1)
         LA    4,0(,4)
         LA    0,6
         ST    0,P00022+0
         L     0,C00023
         ST    0,P00022+4
         LA    1,P00022
         L     15,C00024
         BALR  14,15
         L     3,0(,4)
         LR    0,3
         ST    0,P00022+0
         LA    1,P00022
         L     15,C00025
         BALR  14,15
         L     15,C00026
         BALR  14,15
L00016   DS    0H
         LA    0,0
         B     L00018
L00017   DS    0H
L00018   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00013   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00022   DS    2F
C00023   DC    A(Q00014)
C00024   DC    V(F77WRBEG)
C00025   DC    V(F77WRI)
C00026   DC    V(F77WREND)
Q00014   DC    C'(1X,''>MAINLAST '',I3)'
* main
F77MAIN  CSECT
         USING *,15
         B     L00036
         DC    AL1(7),CL7'F77MAIN'
L00036   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00037
L00038   DC    A(S00027)
L00037   L     15,L00038
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00027,13
         ST    1,S00027+72
L00029   DS    0H
L00030   DS    0H
         L     14,C00039
         L     2,0(,14)
         A     2,C00040
L00031   DS    0H
         LA    0,6
         ST    0,P00041+0
         L     0,C00042
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00043
         BALR  14,15
         LR    0,2
         ST    0,P00041+0
         LA    1,P00041
         L     15,C00044
         BALR  14,15
         L     15,C00045
         BALR  14,15
L00033   DS    0H
L00032   DS    0H
         LA    0,6
         ST    0,P00041+0
         L     0,C00046
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00043
         BALR  14,15
         L     15,C00045
         BALR  14,15
         LA    0,0
         ST    0,P00041+0
         LA    1,P00041
         L     15,C00047
         BALR  14,15
         B     L00035
L00034   DS    0H
L00035   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00027   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00041   DS    2F
C00039   DC    A(C)
C00040   DC    F'1'
C00042   DC    A(Q00014)
C00043   DC    V(F77WRBEG)
C00044   DC    V(F77WRI)
C00045   DC    V(F77WREND)
C00046   DC    A(Q00028)
C00047   DC    V(EXIT)
Q00028   DC    C'(1X,''>MAINLAST OK'')'
C        CSECT
         DS    0D
         DC    X'00000029'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
