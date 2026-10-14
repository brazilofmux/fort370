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
L00005   DS    0H
         LA    15,0
         ST    15,T00004
         LA    0,T00004
         ST    0,P00017+0
         OI    P00017+0,X'80'
         LA    1,P00017
         L     15,C00018
         BALR  14,15
         L     2,T00004
         C     2,C00019
         BC    7,L00006
L00007   DS    0H
         LA    15,3
         ST    15,T00003
         LA    0,T00003
         ST    0,P00017+0
         LA    0,T00004
         ST    0,P00017+4
         L     0,C00020
         ST    0,P00017+8
         OI    P00017+8,X'80'
         LA    1,P00017
         L     15,C00021
         BALR  14,15
         L     2,T00004
         C     2,C00022
         BC    7,L00008
L00009   DS    0H
         LA    0,T00004
         ST    0,P00017+0
         OI    P00017+0,X'80'
         LA    1,P00017
         L     15,C00018
         BALR  14,15
         L     2,T00004
         C     2,C00019
         BC    7,L00010
L00011   DS    0H
         LA    0,6
         ST    0,P00017+0
         L     0,C00023
         ST    0,P00017+4
         LA    1,P00017
         L     15,C00024
         BALR  14,15
         L     0,C00025
         ST    0,P00017+0
         LA    0,9
         ST    0,P00017+4
         LA    1,P00017
         L     15,C00026
         BALR  14,15
         L     15,C00027
         BALR  14,15
         LA    0,0
         ST    0,P00017+0
         LA    1,P00017
         L     15,C00028
         BALR  14,15
         B     L00013
L00006   DS    0H
         LA    0,1
         ST    0,P00017+0
         LA    1,P00017
         L     15,C00028
         BALR  14,15
         B     L00013
L00008   DS    0H
         LA    0,2
         ST    0,P00017+0
         LA    1,P00017
         L     15,C00028
         BALR  14,15
         B     L00013
L00010   DS    0H
         LA    0,3
         ST    0,P00017+0
         LA    1,P00017
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
T00003   DS    XL4
         DS    XL4
T00004   DS    XL12
         DS    XL4
P00017   DS    3F
         DS    XL4
C00018   DC    V(EA)
C00019   DC    F'7'
C00020   DC    V(DBL)
C00021   DC    V(EB)
C00022   DC    F'6'
C00023   DC    A(Q00001)
C00024   DC    V(F77WRBEG)
C00025   DC    A(Q00002)
C00026   DC    V(F77WRA)
C00027   DC    V(F77WREND)
C00028   DC    V(EXIT)
Q00001   DC    C'(A)'
Q00002   DC    C'ENTRY2 OK'
* EA
EA       CSECT
         USING *,15
         B     L00034
         DC    AL1(2),CL7'EA'
L00034   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00035
L00036   DC    A(S00029)
L00035   L     15,L00036
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00029,13
         ST    1,S00029+72
L00030   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         LA    15,7
         ST    15,0(,2)
         LA    0,0
         B     L00033
L00031   DS    0H
L00032   DS    0H
L00033   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00029   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
* DBL
DBL      CSECT
         USING *,15
         B     L00040
         DC    AL1(3),CL7'DBL'
L00040   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00041
L00042   DC    A(S00037)
L00041   L     15,L00042
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00037,13
         ST    1,S00037+72
L00038   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         SLL   2,1
         LR    0,2
L00039   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00037   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
* EB
EB       CSECT
         USING *,15
         B     L00050
         DC    AL1(2),CL7'EB'
L00050   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00051
L00052   DC    A(S00043)
L00051   L     15,L00052
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00043,13
         ST    1,S00043+72
L00044   DS    0H
         L     5,0(,1)
         L     4,4(,1)
         L     3,8(,1)
         LA    3,0(,3)
L00045   DS    0H
         LR    0,5
         ST    0,P00053+0
         OI    P00053+0,X'80'
         LA    1,P00053
         LR    15,3
         BALR  14,15
         LR    2,0
         ST    2,0(,4)
         LA    0,0
         B     L00049
L00046   DS    0H
L00047   DS    0H
L00048   DS    0H
L00049   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00043   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00053   DS    1F
         DS    XL4
         END
