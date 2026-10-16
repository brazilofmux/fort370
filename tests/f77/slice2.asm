* main
F77MAIN  CSECT
         USING *,15
         B     L00028
         DC    AL1(7),CL7'F77MAIN'
L00028   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00029
L00030   DC    A(S00000)
L00029   L     15,L00030
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00002   DS    0H
         LA    8,1
L00003   DS    0H
         LA    6,1
         LA    9,5
         LA    2,0
         LR    3,8
L00004   DS    0H
         LR    5,3
         SR    5,6
         AR    5,6
L00006   DS    0H
         LR    4,5
         SLL   4,0
         LA    7,0
         AR    7,4
         C     5,C00031
         BC    2,L00032
         B     L00008
L00032   DS    0H
         LR    4,6
         B     L00007
L00008   DS    0H
L00010   DS    0H
         BXLE  3,8,L00004
L00005   DS    0H
         C     2,C00033
         BC    7,L00011
L00012   DS    0H
         C     2,C00034
         BC    2,L00013
L00014   DS    0H
         C     2,C00035
         BC    8,L00016
L00017   DS    0H
         LA    3,3
L00015   DS    0H
         C     3,C00036
         BC    7,L00018
L00019   DS    0H
         C     2,C00035
         BC    8,L00020
L00021   DS    0H
         LA    4,2
L00022   DS    0H
         C     4,C00037
         BC    7,L00023
L00024   DS    0H
         LA    0,6
         ST    0,P00038+0
         L     0,C00039
         ST    0,P00038+4
         LA    1,P00038
         L     15,C00040
         BALR  14,15
         AR    2,4
         LR    0,2
         ST    0,P00038+0
         LA    1,P00038
         L     15,C00041
         BALR  14,15
         L     15,C00042
         BALR  14,15
L00025   DS    0H
         LA    0,0
         ST    0,P00038+0
         LA    1,P00038
         L     15,C00043
         BALR  14,15
         B     L00027
L00007   DS    0H
         AR    2,4
L00009   DS    0H
         BXLE  4,6,L00007
         B     L00008
L00011   DS    0H
         LA    0,21
         ST    0,P00038+0
         LA    1,P00038
         L     15,C00043
         BALR  14,15
         B     L00027
L00013   DS    0H
         LA    3,1
         B     L00015
L00016   DS    0H
         LA    3,2
         B     L00015
L00018   DS    0H
         LA    0,22
         ST    0,P00038+0
         LA    1,P00038
         L     15,C00043
         BALR  14,15
         B     L00027
L00020   DS    0H
         LA    4,1
         B     L00022
L00023   DS    0H
         LA    0,23
         ST    0,P00038+0
         LA    1,P00038
         L     15,C00043
         BALR  14,15
         B     L00027
L00026   DS    0H
L00027   DS    0H
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
P00038   DS    2F
C00031   DC    F'0'
C00033   DC    F'35'
C00034   DC    F'30'
C00035   DC    F'25'
C00036   DC    F'1'
C00037   DC    F'2'
C00039   DC    A(Q00001)
C00040   DC    V(F77WRBEG)
C00041   DC    V(F77WRI)
C00042   DC    V(F77WREND)
C00043   DC    V(EXIT)
Q00001   DC    C'(''S'',I4)'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
