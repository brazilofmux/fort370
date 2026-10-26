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
         LA    1,P00009
         L     15,C00010
         BALR  14,15
         LA    15,4
         ST    15,T00002
         LA    1,P00011
         L     15,C00012
         BALR  14,15
         LA    1,P00013
         L     15,C00014
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
P00009   DC    XL1'80',AL3(T00001)
P00011   DC    XL1'80',AL3(T00002)
P00013   DC    F'0'
         DS    XL4
C00010   DC    V(E2)
C00012   DC    V(S1)
C00014   DC    V(EXIT)
* S1
S1       CSECT
         USING *,15
         B     L00029
         DC    AL1(2),CL7'S1'
L00029   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00030
L00031   DC    A(S00015)
L00030   L     15,L00031
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00015,13
         ST    1,S00015+72
L00017   DS    0H
         L     4,0(,1)
         LA    4,0(,4)
         LA    1,P00032
         L     15,C00033
         BALR  14,15
         L     3,0(,4)
         LR    0,3
         ST    0,P00034+0
         LA    1,P00034
         L     15,C00035
         BALR  14,15
         L     15,C00036
         BALR  14,15
L00018   DS    0H
         LA    0,0
         B     L00028
L00019   DS    0H
L00020   DS    0H
L00021   DS    0H
L00022   DS    0H
L00023   DS    0H
L00024   DS    0H
L00025   DS    0H
L00026   DS    0H
L00027   DS    0H
L00028   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00015   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00032   DC    F'6'
         DC    A(Q00016)
P00034   DC    A(0)
         DS    XL4
C00033   DC    V(F77WRBEG)
C00035   DC    V(F77WRI)
C00036   DC    V(F77WREND)
Q00016   DC    C'('' >S1 '',I4)'
* E2
E2       CSECT
         USING *,15
         B     L00057
         DC    AL1(2),CL7'E2'
L00057   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00058
L00059   DC    A(S00037)
L00058   L     15,L00059
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00037,13
         ST    1,S00037+72
L00043   DS    0H
         L     4,0(,1)
         LA    4,0(,4)
L00044   DS    0H
         LA    1,P00060
         L     15,C00061
         BALR  14,15
         L     3,0(,4)
         LR    0,3
         ST    0,P00062+0
         LA    1,P00062
         L     15,C00063
         BALR  14,15
         L     15,C00064
         BALR  14,15
L00048   DS    0H
         MVC   T00041(8),C00065
         LA    1,P00066
         L     15,C00067
         BALR  14,15
         LD    0,T00041
         STD   0,T00042
         LA    1,P00068
         L     15,C00069
         BALR  14,15
         L     15,C00070
         BALR  14,15
         LA    1,P00066
         L     15,C00071
         BALR  14,15
         MVC   T00041(8),C00072
         LA    1,P00073
         L     15,C00074
         BALR  14,15
         LA    1,P00075
         L     15,C00076
         BALR  14,15
         L     15,C00077
         BALR  14,15
         LA    1,P00078
         L     15,C00061
         BALR  14,15
         LD    0,T00041
         STD   0,S00037+216
         LD    0,S00037+216
         STD   0,P00079+0
         LA    1,P00079
         L     15,C00080
         BALR  14,15
         L     15,C00064
         BALR  14,15
L00049   DS    0H
         LA    1,P00066
         L     15,C00071
         BALR  14,15
L00050   DS    0H
         LH    4,C00081
         LA    5,0
         MVC   S00037+216(8),C00072
         LA    2,3
L00051   DS    0H
         LA    1,P00073
         L     15,C00074
         BALR  14,15
         LA    1,P00075
         L     15,C00076
         BALR  14,15
         L     15,C00077
         BALR  14,15
         LA    1,P00066
         L     15,C00071
         BALR  14,15
         LD    0,S00037+216
         AD    0,T00041
L00053   DS    0H
         BXH   2,4,L00082
         STD   0,S00037+224
         B     L00052
L00082   DS    0H
         STD   0,S00037+216
         B     L00051
L00052   DS    0H
         LA    1,P00083
         L     15,C00061
         BALR  14,15
         LD    0,S00037+224
         STD   0,P00079+0
         LA    1,P00079
         L     15,C00080
         BALR  14,15
         L     15,C00064
         BALR  14,15
L00054   DS    0H
         LA    0,0
         B     L00056
L00045   DS    0H
L00046   DS    0H
L00047   DS    0H
L00055   DS    0H
L00056   DS    0H
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
T00041   DS    XL12
         DS    XL4
T00042   DS    XL24
         DS    2D
P00060   DC    F'6'
         DC    A(Q00038)
P00062   DC    A(0)
P00066   DC    F'21'
P00068   DC    A(T00042)
         DC    F'8'
P00073   DC    F'21'
         DC    F'0'
P00075   DC    A(T00041)
         DC    F'8'
P00078   DC    F'6'
         DC    A(Q00039)
P00079   DC    A(0)
         DC    A(0)
P00083   DC    F'6'
         DC    A(Q00040)
C00065   DC    X'4128000000000000'
C00072   DC    X'0000000000000000'
C00061   DC    V(F77WRBEG)
C00063   DC    V(F77WRI)
C00064   DC    V(F77WREND)
C00067   DC    V(F77WUBEG)
C00069   DC    V(F77WU)
C00070   DC    V(F77WUEND)
C00071   DC    V(F77REWND)
C00074   DC    V(F77RUBEG)
C00076   DC    V(F77RU)
C00077   DC    V(F77RUEND)
C00080   DC    V(F77WRD)
C00081   DC    H'-1'
Q00038   DC    C'('' >E2 '',I4)'
Q00039   DC    C'('' >D '',F8.4)'
Q00040   DC    C'('' >Y '',F8.4)'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
