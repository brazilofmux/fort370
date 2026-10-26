* main
F77MAIN  CSECT
         USING *,15
         B     L00013
         DC    AL1(7),CL7'F77MAIN'
L00013   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00014
L00015   DC    A(S00000)
L00014   L     15,L00015
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00005   DS    0H
         LA    15,4
         ST    15,T00002
         LA    1,P00016
         L     15,C00017
         BALR  14,15
         LA    1,P00018
         L     15,C00019
         BALR  14,15
         L     3,T00004
         LR    0,3
         ST    0,P00020+0
         LA    1,P00020
         L     15,C00021
         BALR  14,15
         L     15,C00022
         BALR  14,15
L00006   DS    0H
         L     2,T00004
         C     2,C00023
         BC    7,L00007
L00008   DS    0H
         LA    15,3
         ST    15,T00003
         LA    1,P00024
         L     15,C00025
         BALR  14,15
         LA    1,P00018
         L     15,C00019
         BALR  14,15
         L     3,T00004
         LR    0,3
         ST    0,P00020+0
         LA    1,P00020
         L     15,C00021
         BALR  14,15
         L     15,C00022
         BALR  14,15
         L     2,T00004
         C     2,C00026
         BC    7,L00009
L00010   DS    0H
         LA    1,P00027
         L     15,C00028
         BALR  14,15
         B     L00012
L00007   DS    0H
         LA    1,P00029
         L     15,C00028
         BALR  14,15
         B     L00012
L00009   DS    0H
         LA    1,P00030
         L     15,C00028
         BALR  14,15
         B     L00012
L00011   DS    0H
L00012   DS    0H
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
T00003   DS    XL4
         DS    XL4
T00004   DS    XL8
P00016   DC    A(T00002)
         DC    XL1'80',AL3(T00004)
P00018   DC    F'6'
         DC    A(Q00001)
P00020   DC    A(0)
P00024   DC    A(T00003)
         DC    XL1'80',AL3(T00004)
P00027   DC    F'0'
P00029   DC    F'1'
P00030   DC    F'2'
C00017   DC    V(Q)
C00019   DC    V(F77WRBEG)
C00021   DC    V(F77WRI)
C00022   DC    V(F77WREND)
C00023   DC    F'10'
C00025   DC    V(P)
C00026   DC    F'21'
C00028   DC    V(EXIT)
Q00001   DC    C'(1X,''>ENTRY3'',I6)'
* P
P        CSECT
         USING *,15
         B     L00040
         DC    AL1(1),CL7'P'
L00040   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00041
L00042   DC    A(S00031)
L00041   L     15,L00042
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00031,13
         ST    1,S00031+72
L00032   DS    0H
         L     2,0(,1)
         L     6,4(,1)
         LA    6,0(,6)
         L     5,C00044
         LA    15,0
         ST    15,0(,6)
         L     4,0(,2)
         LA    3,0
L00033   DS    0H
         L     14,C00044
         L     2,0(,14)
         A     2,C00045
         L     14,C00044
         ST    2,0(,14)
         CR    3,4
         BC    10,L00034
L00035   DS    0H
L00036   DS    0H
         A     3,C00045
         L     2,0(,6)
         A     2,0(,5)
         ST    2,0(,6)
         B     L00033
L00034   DS    0H
         LA    0,0
         B     L00039
L00037   DS    0H
L00038   DS    0H
L00039   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00031   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00044   DC    A(G00043)
C00045   DC    F'1'
* Q
Q        CSECT
         USING *,15
         B     L00057
         DC    AL1(1),CL7'Q'
L00057   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00058
L00059   DC    A(S00046)
L00058   L     15,L00059
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00046,13
         ST    1,S00046+72
L00047   DS    0H
         L     2,0(,1)
         L     6,4(,1)
         LA    6,0(,6)
         L     5,C00060
L00048   DS    0H
         LA    15,0
         ST    15,0(,6)
         L     4,0(,2)
         LA    3,0
L00053   DS    0H
         A     3,C00061
         L     2,0(,6)
         A     2,0(,5)
         ST    2,0(,6)
L00050   DS    0H
         L     14,C00060
         L     2,0(,14)
         A     2,C00061
         L     14,C00060
         ST    2,0(,14)
         CR    3,4
         BC    10,L00051
L00052   DS    0H
         B     L00053
L00049   DS    0H
L00051   DS    0H
         LA    0,0
         B     L00056
L00054   DS    0H
L00055   DS    0H
L00056   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00046   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00060   DC    A(G00043)
C00061   DC    F'1'
G00043   CSECT
         DS    0D
         DC    X'00000001'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
