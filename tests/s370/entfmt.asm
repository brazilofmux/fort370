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
         B     L00027
         DC    AL1(2),CL7'S1'
L00027   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00028
L00029   DC    A(S00013)
L00028   L     15,L00029
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
         ST    0,P00030+0
         L     0,C00031
         ST    0,P00030+4
         LA    1,P00030
         L     15,C00032
         BALR  14,15
         L     3,0(,4)
         LR    0,3
         ST    0,P00030+0
         LA    1,P00030
         L     15,C00033
         BALR  14,15
         L     15,C00034
         BALR  14,15
L00016   DS    0H
         LA    0,0
         B     L00026
L00017   DS    0H
L00018   DS    0H
L00019   DS    0H
L00020   DS    0H
L00021   DS    0H
L00022   DS    0H
L00023   DS    0H
L00024   DS    0H
L00025   DS    0H
L00026   DS    0H
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
P00030   DS    2F
C00031   DC    A(Q00014)
C00032   DC    V(F77WRBEG)
C00033   DC    V(F77WRI)
C00034   DC    V(F77WREND)
Q00014   DC    C'('' >S1 '',I4)'
* E2
E2       CSECT
         USING *,15
         B     L00055
         DC    AL1(2),CL7'E2'
L00055   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00056
L00057   DC    A(S00035)
L00056   L     15,L00057
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00035,13
         ST    1,S00035+72
L00041   DS    0H
         L     4,0(,1)
         LA    4,0(,4)
L00042   DS    0H
         LA    0,6
         ST    0,P00058+0
         L     0,C00059
         ST    0,P00058+4
         LA    1,P00058
         L     15,C00060
         BALR  14,15
         L     3,0(,4)
         LR    0,3
         ST    0,P00058+0
         LA    1,P00058
         L     15,C00061
         BALR  14,15
         L     15,C00062
         BALR  14,15
L00046   DS    0H
         MVC   T00039(8),C00063
         LA    0,21
         ST    0,P00058+0
         LA    1,P00058
         L     15,C00064
         BALR  14,15
         LD    0,T00039
         STD   0,T00040
         LA    0,T00040
         ST    0,P00058+0
         LA    0,8
         ST    0,P00058+4
         LA    1,P00058
         L     15,C00065
         BALR  14,15
         L     15,C00066
         BALR  14,15
         LA    0,21
         ST    0,P00058+0
         LA    1,P00058
         L     15,C00067
         BALR  14,15
         MVC   T00039(8),C00068
         LA    0,21
         ST    0,P00058+0
         LA    0,0
         ST    0,P00058+4
         LA    1,P00058
         L     15,C00069
         BALR  14,15
         LA    0,T00039
         ST    0,P00058+0
         LA    0,8
         ST    0,P00058+4
         LA    1,P00058
         L     15,C00070
         BALR  14,15
         L     15,C00071
         BALR  14,15
         LA    0,6
         ST    0,P00058+0
         L     0,C00072
         ST    0,P00058+4
         LA    1,P00058
         L     15,C00060
         BALR  14,15
         LD    0,T00039
         STD   0,S00035+216
         LD    0,S00035+216
         STD   0,P00058+0
         LA    1,P00058
         L     15,C00073
         BALR  14,15
         L     15,C00062
         BALR  14,15
L00047   DS    0H
         LA    0,21
         ST    0,P00058+0
         LA    1,P00058
         L     15,C00067
         BALR  14,15
L00048   DS    0H
         LH    4,C00074
         LA    5,0
         MVC   S00035+216(8),C00068
         LA    2,3
L00049   DS    0H
         LA    0,21
         ST    0,P00058+0
         LA    0,0
         ST    0,P00058+4
         LA    1,P00058
         L     15,C00069
         BALR  14,15
         LA    0,T00039
         ST    0,P00058+0
         LA    0,8
         ST    0,P00058+4
         LA    1,P00058
         L     15,C00070
         BALR  14,15
         L     15,C00071
         BALR  14,15
         LA    0,21
         ST    0,P00058+0
         LA    1,P00058
         L     15,C00067
         BALR  14,15
         LD    0,S00035+216
         AD    0,T00039
L00051   DS    0H
         BXH   2,4,L00075
         STD   0,S00035+224
         B     L00050
L00075   DS    0H
         STD   0,S00035+216
         B     L00049
L00050   DS    0H
         LA    0,6
         ST    0,P00058+0
         L     0,C00076
         ST    0,P00058+4
         LA    1,P00058
         L     15,C00060
         BALR  14,15
         LD    0,S00035+224
         STD   0,P00058+0
         LA    1,P00058
         L     15,C00073
         BALR  14,15
         L     15,C00062
         BALR  14,15
L00052   DS    0H
         LA    0,0
         B     L00054
L00043   DS    0H
L00044   DS    0H
L00045   DS    0H
L00053   DS    0H
L00054   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00035   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00039   DS    XL12
         DS    XL4
T00040   DS    XL24
         DS    2D
P00058   DS    2F
C00063   DC    X'4128000000000000'
C00068   DC    X'0000000000000000'
C00059   DC    A(Q00036)
C00060   DC    V(F77WRBEG)
C00061   DC    V(F77WRI)
C00062   DC    V(F77WREND)
C00064   DC    V(F77WUBEG)
C00065   DC    V(F77WU)
C00066   DC    V(F77WUEND)
C00067   DC    V(F77REWND)
C00069   DC    V(F77RUBEG)
C00070   DC    V(F77RU)
C00071   DC    V(F77RUEND)
C00072   DC    A(Q00037)
C00073   DC    V(F77WRD)
C00076   DC    A(Q00038)
C00074   DC    H'-1'
Q00036   DC    C'('' >E2 '',I4)'
Q00037   DC    C'('' >D '',F8.4)'
Q00038   DC    C'('' >Y '',F8.4)'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
