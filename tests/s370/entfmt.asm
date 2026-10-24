* main
F77MAIN  CSECT
         USING *,15
         B     L00006
         DC    AL1(7),CL7'F77MAIN'
L00006   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00007
L00008   DC    A(S00000)
L00007   L     15,L00008
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00003   DS    0H
         LA    15,3
         ST    15,T00001
         LA    0,T00001
         ST    0,P00009+0
         OI    P00009+0,X'80'
         LA    1,P00009
         L     15,C00010
         BALR  14,15
         LA    15,4
         ST    15,T00002
         LA    0,T00002
         ST    0,P00009+0
         OI    P00009+0,X'80'
         LA    1,P00009
         L     15,C00011
         BALR  14,15
         LA    0,0
         ST    0,P00009+0
         LA    1,P00009
         L     15,C00012
         BALR  14,15
         B     L00005
L00004   DS    0H
L00005   DS    0H
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
T00001   DS    XL4
         DS    XL4
T00002   DS    XL4
         DS    XL4
P00009   DS    1F
         DS    XL4
C00010   DC    V(E2)
C00011   DC    V(S1)
C00012   DC    V(EXIT)
* S1
S1       CSECT
         USING *,15
         B     L00022
         DC    AL1(2),CL7'S1'
L00022   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00023
L00024   DC    A(S00013)
L00023   L     15,L00024
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
         ST    0,P00025+0
         L     0,C00026
         ST    0,P00025+4
         LA    1,P00025
         L     15,C00027
         BALR  14,15
         L     3,0(,4)
         LR    0,3
         ST    0,P00025+0
         LA    1,P00025
         L     15,C00028
         BALR  14,15
         L     15,C00029
         BALR  14,15
L00016   DS    0H
         LA    0,0
         B     L00021
L00017   DS    0H
L00018   DS    0H
L00019   DS    0H
L00020   DS    0H
L00021   DS    0H
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
P00025   DS    2F
C00026   DC    A(Q00014)
C00027   DC    V(F77WRBEG)
C00028   DC    V(F77WRI)
C00029   DC    V(F77WREND)
Q00014   DC    C'('' >S1 '',I4)'
* E2
E2       CSECT
         USING *,15
         B     L00044
         DC    AL1(2),CL7'E2'
L00044   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00045
L00046   DC    A(S00030)
L00045   L     15,L00046
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00030,13
         ST    1,S00030+72
L00035   DS    0H
         L     4,0(,1)
         LA    4,0(,4)
L00036   DS    0H
         LA    0,6
         ST    0,P00047+0
         L     0,C00048
         ST    0,P00047+4
         LA    1,P00047
         L     15,C00049
         BALR  14,15
         L     3,0(,4)
         LR    0,3
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00050
         BALR  14,15
         L     15,C00051
         BALR  14,15
L00040   DS    0H
         MVC   T00033(8),C00052
         LA    0,21
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00053
         BALR  14,15
         LD    0,T00033
         STD   0,T00034
         LA    0,T00034
         ST    0,P00047+0
         LA    0,8
         ST    0,P00047+4
         LA    1,P00047
         L     15,C00054
         BALR  14,15
         L     15,C00055
         BALR  14,15
         LA    0,21
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00056
         BALR  14,15
         MVC   T00033(8),C00057
         LA    0,21
         ST    0,P00047+0
         LA    0,0
         ST    0,P00047+4
         LA    1,P00047
         L     15,C00058
         BALR  14,15
         LA    0,T00033
         ST    0,P00047+0
         LA    0,8
         ST    0,P00047+4
         LA    1,P00047
         L     15,C00059
         BALR  14,15
         L     15,C00060
         BALR  14,15
         LA    0,6
         ST    0,P00047+0
         L     0,C00061
         ST    0,P00047+4
         LA    1,P00047
         L     15,C00049
         BALR  14,15
         LD    0,T00033
         STD   0,S00030+208
         LD    0,S00030+208
         STD   0,P00047+0
         LA    1,P00047
         L     15,C00062
         BALR  14,15
         L     15,C00051
         BALR  14,15
L00041   DS    0H
         LA    0,0
         B     L00043
L00037   DS    0H
L00038   DS    0H
L00039   DS    0H
L00042   DS    0H
L00043   DS    0H
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
T00033   DS    XL12
         DS    XL4
T00034   DS    XL12
         DS    XL4
         DS    1D
P00047   DS    2F
C00052   DC    X'4128000000000000'
C00057   DC    X'0000000000000000'
C00048   DC    A(Q00031)
C00049   DC    V(F77WRBEG)
C00050   DC    V(F77WRI)
C00051   DC    V(F77WREND)
C00053   DC    V(F77WUBEG)
C00054   DC    V(F77WU)
C00055   DC    V(F77WUEND)
C00056   DC    V(F77REWND)
C00058   DC    V(F77RUBEG)
C00059   DC    V(F77RU)
C00060   DC    V(F77RUEND)
C00061   DC    A(Q00032)
C00062   DC    V(F77WRD)
Q00031   DC    C'('' >E2 '',I4)'
Q00032   DC    C'('' >D '',F8.4)'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
