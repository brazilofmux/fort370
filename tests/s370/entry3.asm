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
         LA    0,T00002
         ST    0,P00016+0
         LA    0,T00004
         ST    0,P00016+4
         OI    P00016+4,X'80'
         LA    1,P00016
         L     15,C00017
         BALR  14,15
         LA    0,6
         ST    0,P00016+0
         L     0,C00018
         ST    0,P00016+4
         LA    1,P00016
         L     15,C00019
         BALR  14,15
         L     3,T00004
         LR    0,3
         ST    0,P00016+0
         LA    1,P00016
         L     15,C00020
         BALR  14,15
         L     15,C00021
         BALR  14,15
L00006   DS    0H
         L     2,T00004
         C     2,C00022
         BC    7,L00007
L00008   DS    0H
         LA    15,3
         ST    15,T00003
         LA    0,T00003
         ST    0,P00016+0
         LA    0,T00004
         ST    0,P00016+4
         OI    P00016+4,X'80'
         LA    1,P00016
         L     15,C00023
         BALR  14,15
         LA    0,6
         ST    0,P00016+0
         L     0,C00018
         ST    0,P00016+4
         LA    1,P00016
         L     15,C00019
         BALR  14,15
         L     3,T00004
         LR    0,3
         ST    0,P00016+0
         LA    1,P00016
         L     15,C00020
         BALR  14,15
         L     15,C00021
         BALR  14,15
         L     2,T00004
         C     2,C00024
         BC    7,L00009
L00010   DS    0H
         LA    0,0
         ST    0,P00016+0
         LA    1,P00016
         L     15,C00025
         BALR  14,15
         B     L00012
L00007   DS    0H
         LA    0,1
         ST    0,P00016+0
         LA    1,P00016
         L     15,C00025
         BALR  14,15
         B     L00012
L00009   DS    0H
         LA    0,2
         ST    0,P00016+0
         LA    1,P00016
         L     15,C00025
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
P00016   DS    2F
C00017   DC    V(Q)
C00018   DC    A(Q00001)
C00019   DC    V(F77WRBEG)
C00020   DC    V(F77WRI)
C00021   DC    V(F77WREND)
C00022   DC    F'10'
C00023   DC    V(P)
C00024   DC    F'21'
C00025   DC    V(EXIT)
Q00001   DC    C'(1X,''>ENTRY3'',I6)'
* P
P        CSECT
         USING *,15
         B     L00035
         DC    AL1(1),CL7'P'
L00035   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00036
L00037   DC    A(S00026)
L00036   L     15,L00037
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00026,13
         ST    1,S00026+72
L00027   DS    0H
         L     2,0(,1)
         L     6,4(,1)
         LA    6,0(,6)
         L     5,C00039
         LA    15,0
         ST    15,0(,6)
         L     4,0(,2)
         LA    3,0
L00028   DS    0H
         L     14,C00039
         L     2,0(,14)
         A     2,C00040
         L     14,C00039
         ST    2,0(,14)
         CR    3,4
         BC    10,L00029
L00030   DS    0H
L00031   DS    0H
         A     3,C00040
         L     2,0(,6)
         A     2,0(,5)
         ST    2,0(,6)
         B     L00028
L00029   DS    0H
         LA    0,0
         B     L00034
L00032   DS    0H
L00033   DS    0H
L00034   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00026   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00039   DC    A(G00038)
C00040   DC    F'1'
* Q
Q        CSECT
         USING *,15
         B     L00052
         DC    AL1(1),CL7'Q'
L00052   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00053
L00054   DC    A(S00041)
L00053   L     15,L00054
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00041,13
         ST    1,S00041+72
L00042   DS    0H
         L     2,0(,1)
         L     6,4(,1)
         LA    6,0(,6)
         L     5,C00055
L00043   DS    0H
         LA    15,0
         ST    15,0(,6)
         L     4,0(,2)
         LA    3,0
L00048   DS    0H
         A     3,C00056
         L     2,0(,6)
         A     2,0(,5)
         ST    2,0(,6)
L00045   DS    0H
         L     14,C00055
         L     2,0(,14)
         A     2,C00056
         L     14,C00055
         ST    2,0(,14)
         CR    3,4
         BC    10,L00046
L00047   DS    0H
         B     L00048
L00044   DS    0H
L00046   DS    0H
         LA    0,0
         B     L00051
L00049   DS    0H
L00050   DS    0H
L00051   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00041   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00055   DC    A(G00038)
C00056   DC    F'1'
G00038   CSECT
         DS    0D
         DC    X'00000001'
         END
