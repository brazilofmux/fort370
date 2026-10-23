* main
F77MAIN  CSECT
         USING *,15
         B     L00044
         DC    AL1(7),CL7'F77MAIN'
L00044   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00045
L00046   DC    A(S00000)
L00045   L     15,L00046
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00025   DS    0H
         LA    0,6
         ST    0,P00047+0
         L     0,C00048
         ST    0,P00047+4
         LA    1,P00047
         L     15,C00049
         BALR  14,15
         LA    15,7
         ST    15,T00024
         LH    15,C00050
         ST    15,T00002
         LA    0,T00024
         ST    0,P00047+0
         LA    0,T00002
         ST    0,P00047+4
         OI    P00047+4,X'80'
         LA    1,P00047
         L     15,C00051
         BALR  14,15
         LR    3,0
L00026   DS    0H
         LR    0,3
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00052
         BALR  14,15
         LH    15,C00053
         ST    15,T00009
         LA    15,3
         ST    15,T00003
         LA    0,T00009
         ST    0,P00047+0
         LA    0,T00003
         ST    0,P00047+4
         OI    P00047+4,X'80'
         LA    1,P00047
         L     15,C00051
         BALR  14,15
         LR    3,0
L00027   DS    0H
         LR    0,3
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00052
         BALR  14,15
         LH    15,C00053
         ST    15,T00010
         LH    15,C00050
         ST    15,T00004
         LA    0,T00010
         ST    0,P00047+0
         LA    0,T00004
         ST    0,P00047+4
         OI    P00047+4,X'80'
         LA    1,P00047
         L     15,C00051
         BALR  14,15
         LR    3,0
L00028   DS    0H
         LR    0,3
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00052
         BALR  14,15
         LA    15,9
         ST    15,T00011
         LA    15,4
         ST    15,T00005
         LA    0,T00011
         ST    0,P00047+0
         LA    0,T00005
         ST    0,P00047+4
         OI    P00047+4,X'80'
         LA    1,P00047
         L     15,C00054
         BALR  14,15
         LR    3,0
L00029   DS    0H
         LR    0,3
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00052
         BALR  14,15
         LA    15,4
         ST    15,T00012
         LA    15,9
         ST    15,T00006
         LA    0,T00012
         ST    0,P00047+0
         LA    0,T00006
         ST    0,P00047+4
         OI    P00047+4,X'80'
         LA    1,P00047
         L     15,C00054
         BALR  14,15
         LR    3,0
L00030   DS    0H
         LR    0,3
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00052
         BALR  14,15
         LA    15,17
         ST    15,T00013
         LA    15,5
         ST    15,T00007
         LA    0,T00013
         ST    0,P00047+0
         LA    0,T00007
         ST    0,P00047+4
         OI    P00047+4,X'80'
         LA    1,P00047
         L     15,C00055
         BALR  14,15
         LR    3,0
L00031   DS    0H
         LR    0,3
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00052
         BALR  14,15
         LH    15,C00056
         ST    15,T00014
         LA    15,5
         ST    15,T00008
         LA    0,T00014
         ST    0,P00047+0
         LA    0,T00008
         ST    0,P00047+4
         OI    P00047+4,X'80'
         LA    1,P00047
         L     15,C00055
         BALR  14,15
         LR    3,0
L00032   DS    0H
         LR    0,3
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00052
         BALR  14,15
         LH    15,C00057
         ST    15,T00015
         LA    0,T00015
         ST    0,P00047+0
         OI    P00047+0,X'80'
         LA    1,P00047
         L     15,C00058
         BALR  14,15
         LR    3,0
L00033   DS    0H
         LR    0,3
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00052
         BALR  14,15
         L     15,C00059
         BALR  14,15
         LA    0,6
         ST    0,P00047+0
         L     0,C00048
         ST    0,P00047+4
         LA    1,P00047
         L     15,C00049
         BALR  14,15
         MVC   T00016(4),C00060
         LA    0,T00016
         ST    0,P00047+0
         OI    P00047+0,X'80'
         LA    1,P00047
         L     15,C00061
         BALR  14,15
         LR    3,0
L00034   DS    0H
         LR    0,3
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00052
         BALR  14,15
         LE    0,C00060
         LCER  0,0
         STE   0,T00017
         LA    0,T00017
         ST    0,P00047+0
         OI    P00047+0,X'80'
         LA    1,P00047
         L     15,C00061
         BALR  14,15
         LR    3,0
L00035   DS    0H
         LR    0,3
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00052
         BALR  14,15
         MVC   T00018(4),C00062
         LA    0,T00018
         ST    0,P00047+0
         OI    P00047+0,X'80'
         LA    1,P00047
         L     15,C00061
         BALR  14,15
         LR    3,0
L00036   DS    0H
         LR    0,3
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00052
         BALR  14,15
         LE    0,C00062
         LCER  0,0
         STE   0,T00019
         LA    0,T00019
         ST    0,P00047+0
         OI    P00047+0,X'80'
         LA    1,P00047
         L     15,C00061
         BALR  14,15
         LR    3,0
L00037   DS    0H
         LR    0,3
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00052
         BALR  14,15
         LE    0,C00063
         LCER  0,0
         STE   0,T00020
         LA    0,T00020
         ST    0,P00047+0
         OI    P00047+0,X'80'
         LA    1,P00047
         L     15,C00061
         BALR  14,15
         LR    3,0
L00038   DS    0H
         LR    0,3
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00052
         BALR  14,15
         LD    0,C00064
         LCDR  0,0
         STD   0,T00021
         LA    0,T00021
         ST    0,P00047+0
         OI    P00047+0,X'80'
         LA    1,P00047
         L     15,C00065
         BALR  14,15
         LR    3,0
L00039   DS    0H
         LR    0,3
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00052
         BALR  14,15
         MVC   T00022(8),C00066
         LA    0,T00022
         ST    0,P00047+0
         OI    P00047+0,X'80'
         LA    1,P00047
         L     15,C00065
         BALR  14,15
         LR    3,0
L00040   DS    0H
         LR    0,3
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00052
         BALR  14,15
         LD    0,C00066
         LCDR  0,0
         STD   0,T00023
         LA    0,T00023
         ST    0,P00047+0
         OI    P00047+0,X'80'
         LA    1,P00047
         L     15,C00065
         BALR  14,15
         LR    3,0
L00041   DS    0H
         LR    0,3
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00052
         BALR  14,15
         L     15,C00059
         BALR  14,15
L00042   DS    0H
L00043   DS    0H
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
T00004   DS    XL4
         DS    XL4
T00005   DS    XL4
         DS    XL4
T00006   DS    XL4
         DS    XL4
T00007   DS    XL4
         DS    XL4
T00008   DS    XL4
         DS    XL4
T00009   DS    XL12
         DS    XL4
T00010   DS    XL12
         DS    XL4
T00011   DS    XL12
         DS    XL4
T00012   DS    XL12
         DS    XL4
T00013   DS    XL12
         DS    XL4
T00014   DS    XL12
         DS    XL4
T00015   DS    XL12
         DS    XL4
T00016   DS    XL12
         DS    XL4
T00017   DS    XL12
         DS    XL4
T00018   DS    XL12
         DS    XL4
T00019   DS    XL12
         DS    XL4
T00020   DS    XL12
         DS    XL4
T00021   DS    XL16
T00022   DS    XL16
T00023   DS    XL16
T00024   DS    XL60
         DS    XL4
P00047   DS    2F
C00064   DC    X'412999999999999A'
C00066   DC    X'4178000000000000'
C00048   DC    A(Q00001)
C00049   DC    V(F77WRBEG)
C00051   DC    V(I#ISIGN)
C00052   DC    V(F77WRI)
C00054   DC    V(I#IDIM)
C00055   DC    V(I#MOD)
C00058   DC    V(I#IABS)
C00059   DC    V(F77WREND)
C00060   DC    X'4129999A'
C00061   DC    V(I#NINT)
C00062   DC    X'41280000'
C00063   DC    X'40666666'
C00065   DC    V(I#IDNINT)
C00050   DC    H'-3'
C00053   DC    H'-7'
C00056   DC    H'-17'
C00057   DC    H'-8'
Q00001   DC    C'('' >S '',8I5)'
* F2
F2       CSECT
         USING *,15
         B     L00070
         DC    AL1(2),CL7'F2'
L00070   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00071
L00072   DC    A(S00067)
L00071   L     15,L00072
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00067,13
         ST    1,S00067+72
L00068   DS    0H
         L     5,0(,1)
         L     4,4(,1)
         L     3,8(,1)
         LA    3,0(,3)
         LR    0,4
         ST    0,P00073+0
         LR    0,3
         ST    0,P00073+4
         OI    P00073+4,X'80'
         LA    1,P00073
         LR    15,5
         BALR  14,15
         LR    2,0
         LR    0,2
L00069   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00067   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00073   DS    2F
* F1
F1       CSECT
         USING *,15
         B     L00077
         DC    AL1(2),CL7'F1'
L00077   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00078
L00079   DC    A(S00074)
L00078   L     15,L00079
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00074,13
         ST    1,S00074+72
L00075   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         LR    0,3
         ST    0,P00080+0
         OI    P00080+0,X'80'
         LA    1,P00080
         LR    15,4
         BALR  14,15
         LR    2,0
         LR    0,2
L00076   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00074   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00080   DS    1F
         DS    XL4
* G1
G1       CSECT
         USING *,15
         B     L00084
         DC    AL1(2),CL7'G1'
L00084   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00085
L00086   DC    A(S00081)
L00085   L     15,L00086
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00081,13
         ST    1,S00081+72
L00082   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         LR    0,3
         ST    0,P00087+0
         OI    P00087+0,X'80'
         LA    1,P00087
         LR    15,4
         BALR  14,15
         LR    2,0
         LR    0,2
L00083   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00081   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00087   DS    1F
         DS    XL4
* H1
H1       CSECT
         USING *,15
         B     L00091
         DC    AL1(2),CL7'H1'
L00091   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00092
L00093   DC    A(S00088)
L00092   L     15,L00093
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00088,13
         ST    1,S00088+72
L00089   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         LR    0,3
         ST    0,P00094+0
         OI    P00094+0,X'80'
         LA    1,P00094
         LR    15,4
         BALR  14,15
         LR    2,0
         LR    0,2
L00090   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00088   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00094   DS    1F
         DS    XL4
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
