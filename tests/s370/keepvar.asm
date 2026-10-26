* main
F77MAIN  CSECT
         USING *,15
         B     L00014
         DC    AL1(7),CL7'F77MAIN'
L00014   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00015
L00016   DC    A(S00000)
L00015   L     15,L00016
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00004   DS    0H
         LA    15,1
         ST    15,T00002
L00005   DS    0H
         LH    4,C00017
         LA    5,0
         LA    2,3
L00006   DS    0H
         LA    1,P00018
         L     15,C00019
         BALR  14,15
L00008   DS    0H
         L     3,T00002
         A     3,C00020
         ST    3,T00002
         BXH   2,4,L00006
L00007   DS    0H
         LA    1,P00021
         L     15,C00022
         BALR  14,15
         L     3,T00003
         LR    0,3
         ST    0,P00023+0
         LA    1,P00023
         L     15,C00024
         BALR  14,15
         L     15,C00025
         BALR  14,15
L00009   DS    0H
         L     2,T00003
         C     2,C00026
         BC    7,L00010
L00011   DS    0H
         LA    1,P00027
         L     15,C00028
         BALR  14,15
         B     L00013
L00010   DS    0H
         LA    1,P00029
         L     15,C00028
         BALR  14,15
         B     L00013
L00012   DS    0H
L00013   DS    0H
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
T00002   DS    XL4
         DS    XL4
T00003   DS    XL8
P00018   DC    A(T00002)
         DC    XL1'80',AL3(T00003)
P00021   DC    F'6'
         DC    A(Q00001)
P00023   DC    A(0)
P00027   DC    F'0'
P00029   DC    F'1'
         DS    XL4
C00019   DC    V(KEEP)
C00020   DC    F'1'
C00022   DC    V(F77WRBEG)
C00024   DC    V(F77WRI)
C00025   DC    V(F77WREND)
C00026   DC    F'3'
C00028   DC    V(EXIT)
C00017   DC    H'-1'
Q00001   DC    C'(1X,''>KEEPVAR'',I6)'
* KEEP
KEEP     CSECT
         USING *,15
         B     L00040
         DC    AL1(4),CL7'KEEP'
L00040   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00041
L00042   DC    A(S00030)
L00041   L     15,L00042
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00030,13
         ST    1,S00030+72
L00033   DS    0H
         L     5,0(,1)
         L     4,4(,1)
         LA    4,0(,4)
         L     14,C00044
         L     3,0(,14)
         LTR   3,3
         LA    2,1
         BC    8,L00045
         SR    2,2
L00045   DS    0H
         LTR   2,2
         BC    7,L00034
L00035   DS    0H
         LA    15,0
         L     14,C00044
         ST    15,0(,14)
         LA    15,0
         ST    15,T00031
L00036   DS    0H
         L     3,T00031
         A     3,C00046
         ST    3,T00031
         SLL   3,2
         L     2,0(,5)
         LR    1,2
         M     0,C00047
         LR    2,1
         ST    2,T00032-4(3)
         L     2,T00031
         ST    2,0(,4)
         L     2,T00031
         LR    3,2
         SLL   3,2
         LR    1,2
         M     0,C00047
         LR    2,1
         C     2,T00032-4(3)
         BC    7,L00037
L00038   DS    0H
         LA    0,0
         B     L00039
L00034   DS    0H
         B     L00036
L00037   DS    0H
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LA    0,2
L00039   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00030   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00031   DS    XL8
T00032   DS    XL16
P00048   DC    F'2'
         DS    XL4
C00044   DC    A(G00043)
C00046   DC    F'1'
C00047   DC    F'10'
C00049   DC    V(EXIT)
G00043   CSECT
         DS    0D
         DC    X'00000001'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
