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
         LA    1,P00017
         L     15,C00018
         BALR  14,15
         L     2,T00004
         C     2,C00019
         BC    7,L00006
L00007   DS    0H
         LA    15,3
         ST    15,T00003
         LA    1,P00020
         L     15,C00021
         BALR  14,15
         L     2,T00004
         C     2,C00022
         BC    7,L00008
L00009   DS    0H
         LA    1,P00017
         L     15,C00018
         BALR  14,15
         L     2,T00004
         C     2,C00019
         BC    7,L00010
L00011   DS    0H
         LA    1,P00023
         L     15,C00024
         BALR  14,15
         LA    1,P00025
         L     15,C00026
         BALR  14,15
         LA    1,P00027
         L     15,C00028
         BALR  14,15
         L     15,C00029
         BALR  14,15
         LA    1,P00030
         L     15,C00031
         BALR  14,15
         B     L00013
L00006   DS    0H
         LA    1,P00032
         L     15,C00031
         BALR  14,15
         B     L00013
L00008   DS    0H
         LA    1,P00033
         L     15,C00031
         BALR  14,15
         B     L00013
L00010   DS    0H
         LA    1,P00023
         L     15,C00031
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
P00017   DC    XL1'80',AL3(T00004)
P00020   DC    A(T00003)
         DC    A(T00004)
         DC    XL1'80',VL3(DBL)
P00023   DC    F'3'
P00025   DC    F'6'
         DC    A(Q00001)
P00027   DC    A(Q00002)
         DC    F'9'
P00030   DC    F'0'
P00032   DC    F'1'
P00033   DC    F'2'
C00018   DC    V(EA)
C00019   DC    F'7'
C00021   DC    V(EB)
C00022   DC    F'6'
C00024   DC    V(F77FMTLM)
C00026   DC    V(F77WRBEG)
C00028   DC    V(F77WRA)
C00029   DC    V(F77WREND)
C00031   DC    V(EXIT)
Q00001   DC    C'(A)'
Q00002   DC    C'ENTRY2 OK'
* EA
EA       CSECT
         USING *,15
         B     L00039
         DC    AL1(2),CL7'EA'
L00039   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00040
L00041   DC    A(S00034)
L00040   L     15,L00041
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00034,13
         ST    1,S00034+72
L00035   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         LA    15,7
         ST    15,0(,2)
         LA    0,0
         B     L00038
L00036   DS    0H
L00037   DS    0H
L00038   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00034   DS    0D
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
         B     L00045
         DC    AL1(3),CL7'DBL'
L00045   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00046
L00047   DC    A(S00042)
L00046   L     15,L00047
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00042,13
         ST    1,S00042+72
L00043   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         SLL   2,1
         LR    0,2
L00044   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00042   DS    0D
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
         B     L00055
         DC    AL1(2),CL7'EB'
L00055   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00056
L00057   DC    A(S00048)
L00056   L     15,L00057
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00048,13
         ST    1,S00048+72
L00049   DS    0H
         L     5,0(,1)
         L     4,4(,1)
         L     3,8(,1)
         LA    3,0(,3)
L00050   DS    0H
         LR    0,5
         ST    0,P00058+0
         OI    P00058+0,X'80'
         LA    1,P00058
         LR    15,3
         BALR  14,15
         LR    2,0
         ST    2,0(,4)
         LA    0,0
         B     L00054
L00051   DS    0H
L00052   DS    0H
L00053   DS    0H
L00054   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00048   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00058   DC    XL1'80',AL3(0)
         DS    XL4
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
