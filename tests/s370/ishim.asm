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
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         LA    15,7
         ST    15,T00024
         LH    15,C00049
         ST    15,T00002
         LA    1,P00050
         L     15,C00051
         BALR  14,15
         LR    3,0
L00026   DS    0H
         LR    0,3
         ST    0,P00052+0
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         LH    15,C00054
         ST    15,T00009
         LA    15,3
         ST    15,T00003
         LA    1,P00055
         L     15,C00051
         BALR  14,15
         LR    3,0
L00027   DS    0H
         LR    0,3
         ST    0,P00052+0
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         LH    15,C00054
         ST    15,T00010
         LH    15,C00049
         ST    15,T00004
         LA    1,P00056
         L     15,C00051
         BALR  14,15
         LR    3,0
L00028   DS    0H
         LR    0,3
         ST    0,P00052+0
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         LA    15,9
         ST    15,T00011
         LA    15,4
         ST    15,T00005
         LA    1,P00057
         L     15,C00058
         BALR  14,15
         LR    3,0
L00029   DS    0H
         LR    0,3
         ST    0,P00052+0
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         LA    15,4
         ST    15,T00012
         LA    15,9
         ST    15,T00006
         LA    1,P00059
         L     15,C00058
         BALR  14,15
         LR    3,0
L00030   DS    0H
         LR    0,3
         ST    0,P00052+0
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         LA    15,17
         ST    15,T00013
         LA    15,5
         ST    15,T00007
         LA    1,P00060
         L     15,C00061
         BALR  14,15
         LR    3,0
L00031   DS    0H
         LR    0,3
         ST    0,P00052+0
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         LH    15,C00062
         ST    15,T00014
         LA    15,5
         ST    15,T00008
         LA    1,P00063
         L     15,C00061
         BALR  14,15
         LR    3,0
L00032   DS    0H
         LR    0,3
         ST    0,P00052+0
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         LH    15,C00064
         ST    15,T00015
         LA    1,P00065
         L     15,C00066
         BALR  14,15
         LR    3,0
L00033   DS    0H
         LR    0,3
         ST    0,P00052+0
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         L     15,C00067
         BALR  14,15
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         MVC   T00016(4),C00068
         LA    1,P00069
         L     15,C00070
         BALR  14,15
         LR    3,0
L00034   DS    0H
         LR    0,3
         ST    0,P00052+0
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         LE    0,C00068
         LCER  0,0
         STE   0,T00017
         LA    1,P00071
         L     15,C00070
         BALR  14,15
         LR    3,0
L00035   DS    0H
         LR    0,3
         ST    0,P00052+0
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         MVC   T00018(4),C00072
         LA    1,P00073
         L     15,C00070
         BALR  14,15
         LR    3,0
L00036   DS    0H
         LR    0,3
         ST    0,P00052+0
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         LE    0,C00072
         LCER  0,0
         STE   0,T00019
         LA    1,P00074
         L     15,C00070
         BALR  14,15
         LR    3,0
L00037   DS    0H
         LR    0,3
         ST    0,P00052+0
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         LE    0,C00075
         LCER  0,0
         STE   0,T00020
         LA    1,P00076
         L     15,C00070
         BALR  14,15
         LR    3,0
L00038   DS    0H
         LR    0,3
         ST    0,P00052+0
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         LD    0,C00077
         LCDR  0,0
         STD   0,T00021
         LA    1,P00078
         L     15,C00079
         BALR  14,15
         LR    3,0
L00039   DS    0H
         LR    0,3
         ST    0,P00052+0
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         MVC   T00022(8),C00080
         LA    1,P00081
         L     15,C00079
         BALR  14,15
         LR    3,0
L00040   DS    0H
         LR    0,3
         ST    0,P00052+0
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         LD    0,C00080
         LCDR  0,0
         STD   0,T00023
         LA    1,P00082
         L     15,C00079
         BALR  14,15
         LR    3,0
L00041   DS    0H
         LR    0,3
         ST    0,P00052+0
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         L     15,C00067
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
P00047   DC    F'6'
         DC    A(Q00001)
P00050   DC    A(T00024)
         DC    XL1'80',AL3(T00002)
P00052   DC    A(0)
P00055   DC    A(T00009)
         DC    XL1'80',AL3(T00003)
P00056   DC    A(T00010)
         DC    XL1'80',AL3(T00004)
P00057   DC    A(T00011)
         DC    XL1'80',AL3(T00005)
P00059   DC    A(T00012)
         DC    XL1'80',AL3(T00006)
P00060   DC    A(T00013)
         DC    XL1'80',AL3(T00007)
P00063   DC    A(T00014)
         DC    XL1'80',AL3(T00008)
P00065   DC    XL1'80',AL3(T00015)
P00069   DC    XL1'80',AL3(T00016)
P00071   DC    XL1'80',AL3(T00017)
P00073   DC    XL1'80',AL3(T00018)
P00074   DC    XL1'80',AL3(T00019)
P00076   DC    XL1'80',AL3(T00020)
P00078   DC    XL1'80',AL3(T00021)
P00081   DC    XL1'80',AL3(T00022)
P00082   DC    XL1'80',AL3(T00023)
C00077   DC    X'412999999999999A'
C00080   DC    X'4178000000000000'
C00048   DC    V(F77WRBEG)
C00051   DC    V(I#ISIGN)
C00053   DC    V(F77WRI)
C00058   DC    V(I#IDIM)
C00061   DC    V(I#MOD)
C00066   DC    V(I#IABS)
C00067   DC    V(F77WREND)
C00068   DC    X'4129999A'
C00070   DC    V(I#NINT)
C00072   DC    X'41280000'
C00075   DC    X'40666666'
C00079   DC    V(I#IDNINT)
C00049   DC    H'-3'
C00054   DC    H'-7'
C00062   DC    H'-17'
C00064   DC    H'-8'
Q00001   DC    C'('' >S '',8I5)'
* F2
F2       CSECT
         USING *,15
         B     L00086
         DC    AL1(2),CL7'F2'
L00086   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00087
L00088   DC    A(S00083)
L00087   L     15,L00088
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00083,13
         ST    1,S00083+72
L00084   DS    0H
         L     5,0(,1)
         L     4,4(,1)
         L     3,8(,1)
         LA    3,0(,3)
         LR    0,4
         ST    0,P00089+0
         LR    0,3
         ST    0,P00089+4
         OI    P00089+4,X'80'
         LA    1,P00089
         LR    15,5
         BALR  14,15
         LR    2,0
         LR    0,2
L00085   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00083   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00089   DC    A(0)
         DC    XL1'80',AL3(0)
* F1
F1       CSECT
         USING *,15
         B     L00093
         DC    AL1(2),CL7'F1'
L00093   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00094
L00095   DC    A(S00090)
L00094   L     15,L00095
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00090,13
         ST    1,S00090+72
L00091   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         LR    0,3
         ST    0,P00096+0
         OI    P00096+0,X'80'
         LA    1,P00096
         LR    15,4
         BALR  14,15
         LR    2,0
         LR    0,2
L00092   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00090   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00096   DC    XL1'80',AL3(0)
         DS    XL4
* G1
G1       CSECT
         USING *,15
         B     L00100
         DC    AL1(2),CL7'G1'
L00100   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00101
L00102   DC    A(S00097)
L00101   L     15,L00102
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00097,13
         ST    1,S00097+72
L00098   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         LR    0,3
         ST    0,P00103+0
         OI    P00103+0,X'80'
         LA    1,P00103
         LR    15,4
         BALR  14,15
         LR    2,0
         LR    0,2
L00099   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00097   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00103   DC    XL1'80',AL3(0)
         DS    XL4
* H1
H1       CSECT
         USING *,15
         B     L00107
         DC    AL1(2),CL7'H1'
L00107   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00108
L00109   DC    A(S00104)
L00108   L     15,L00109
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00104,13
         ST    1,S00104+72
L00105   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         LR    0,3
         ST    0,P00110+0
         OI    P00110+0,X'80'
         LA    1,P00110
         LR    15,4
         BALR  14,15
         LR    2,0
         LR    0,2
L00106   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00104   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00110   DC    XL1'80',AL3(0)
         DS    XL4
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
