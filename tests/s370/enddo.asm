* main
F77MAIN  CSECT
         USING *,15
         B     L00063
         DC    AL1(7),CL7'F77MAIN'
L00063   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00064
L00065   DC    A(S00000)
L00064   L     15,L00065
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00006   DS    0H
L00007   DS    0H
         LA    6,4
         LA    7,12
         LA    2,4
         LA    3,1
L00008   DS    0H
         LR    1,3
         MR    0,3
         LR    4,1
         ST    4,T00005-4(2)
         A     3,C00066
         BXLE  2,6,L00008
L00009   DS    0H
         LA    0,6
         ST    0,P00067+0
         L     0,C00068
         ST    0,P00067+4
         LA    1,P00067
         L     15,C00069
         BALR  14,15
         LA    2,4
         LA    3,3
L00010   DS    0H
         C     3,C00070
         BC    2,L00011
L00012   DS    0H
         L     15,C00071
         BALR  14,15
L00013   DS    0H
         LA    10,10
         LA    11,30
         LA    2,10
         LA    3,4
L00014   DS    0H
L00016   DS    0H
         LA    7,T00004-16
         LA    8,12
         AR    7,3
         LA    9,24
         LA    4,12
         LA    5,1
L00017   DS    0H
         LR    6,2
         AR    6,5
         ST    6,0(4,7)
         A     5,C00066
         BXLE  4,8,L00017
L00018   DS    0H
L00019   DS    0H
         A     3,C00072
         BXLE  2,10,L00014
L00015   DS    0H
         LA    0,6
         ST    0,P00067+0
         L     0,C00073
         ST    0,P00067+4
         LA    1,P00067
         L     15,C00069
         BALR  14,15
         LA    6,3
         LA    7,2
L00020   DS    0H
         C     7,C00070
         BC    2,L00021
L00022   DS    0H
         L     15,C00071
         BALR  14,15
         LA    8,1
L00026   DS    0H
         LA    9,4
         LA    2,0
         LR    3,8
L00027   DS    0H
         LA    4,1
         SR    4,3
         A     4,C00074
         LR    0,4
         SRDA  0,32
         D     0,C00074
         LR    4,1
L00029   DS    0H
         LH    6,C00075
         LA    7,0
         C     4,C00070
         BC    2,L00076
         B     L00031
L00076   DS    0H
         LR    5,3
         B     L00030
L00031   DS    0H
L00032   DS    0H
         BXLE  3,8,L00027
L00028   DS    0H
L00033   DS    0H
L00035   DS    0H
         LA    0,6
         ST    0,P00067+0
         L     0,C00077
         ST    0,P00067+4
         LA    1,P00067
         L     15,C00069
         BALR  14,15
         LR    0,2
         ST    0,P00067+0
         LA    1,P00067
         L     15,C00078
         BALR  14,15
         LA    0,0
         ST    0,P00067+0
         LA    1,P00067
         L     15,C00078
         BALR  14,15
         L     15,C00071
         BALR  14,15
         LA    2,1
L00036   DS    0H
         C     2,C00079
         BC    4,L00037
L00038   DS    0H
         LA    3,0
L00039   DS    0H
         C     3,C00080
         BC    4,L00040
L00041   DS    0H
         LA    0,6
         ST    0,P00067+0
         L     0,C00077
         ST    0,P00067+4
         LA    1,P00067
         L     15,C00069
         BALR  14,15
         LR    0,2
         ST    0,P00067+0
         LA    1,P00067
         L     15,C00078
         BALR  14,15
         LR    0,3
         ST    0,P00067+0
         LA    1,P00067
         L     15,C00078
         BALR  14,15
         L     15,C00071
         BALR  14,15
L00043   DS    0H
         LH    6,C00075
         LA    7,0
         LA    4,10
         LA    3,0
         LA    2,1
L00044   DS    0H
         LR    0,2
         SRDA  0,32
         D     0,C00081
         LR    5,0
         C     5,C00070
         BC    8,L00046
L00047   DS    0H
         C     2,C00082
         BC    2,L00049
L00050   DS    0H
L00048   DS    0H
         A     2,C00066
         BXH   4,6,L00044
L00045   DS    0H
L00051   DS    0H
         LA    0,6
         ST    0,P00067+0
         L     0,C00077
         ST    0,P00067+4
         LA    1,P00067
         L     15,C00069
         BALR  14,15
         LR    0,3
         ST    0,P00067+0
         LA    1,P00067
         L     15,C00078
         BALR  14,15
         LR    0,2
         ST    0,P00067+0
         LA    1,P00067
         L     15,C00078
         BALR  14,15
         L     15,C00071
         BALR  14,15
         LA    8,1
L00052   DS    0H
         LA    6,1
         LA    9,3
         LA    2,0
         LR    3,8
L00053   DS    0H
         LR    4,3
         SR    4,6
         AR    4,6
L00056   DS    0H
         LR    5,4
         SLL   5,0
         LA    7,0
         AR    7,5
         C     4,C00070
         BC    2,L00083
         B     L00058
L00083   DS    0H
         LR    4,6
         B     L00057
L00058   DS    0H
L00055   DS    0H
         BXLE  3,8,L00053
L00054   DS    0H
         LA    0,6
         ST    0,P00067+0
         L     0,C00077
         ST    0,P00067+4
         LA    1,P00067
         L     15,C00069
         BALR  14,15
         LR    0,2
         ST    0,P00067+0
         LA    1,P00067
         L     15,C00078
         BALR  14,15
         L     15,C00071
         BALR  14,15
L00059   DS    0H
L00060   DS    0H
L00061   DS    0H
         B     L00062
L00011   DS    0H
         L     5,T00005-4(2)
         LR    0,5
         ST    0,P00067+0
         LA    1,P00067
         L     15,C00078
         BALR  14,15
         AH    3,C00075
         A     2,C00072
         B     L00010
L00021   DS    0H
         LR    5,6
         AH    5,C00084
         AH    5,C00075
         LA    2,3
         LA    3,1
L00023   DS    0H
         C     2,C00070
         BC    2,L00024
L00025   DS    0H
         AH    7,C00075
         A     6,C00085
         B     L00020
L00024   DS    0H
         LR    4,5
         AR    4,3
         SLL   4,2
         L     8,T00004(4)
         LR    0,8
         ST    0,P00067+0
         LA    1,P00067
         L     15,C00078
         BALR  14,15
         AH    3,C00086
         AH    2,C00075
         B     L00023
L00030   DS    0H
         AR    2,5
         A     5,C00074
         BXH   4,6,L00030
         B     L00031
L00034   DS    0H
L00037   DS    0H
         LR    1,2
         M     0,C00085
         LR    2,1
         B     L00036
L00040   DS    0H
         A     3,C00081
L00042   DS    0H
         B     L00039
L00046   DS    0H
         AR    3,2
         B     L00048
L00049   DS    0H
         B     L00051
L00057   DS    0H
         AR    2,4
         BXLE  4,6,L00057
         B     L00058
L00062   DS    0H
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
T00004   DS    XL28
         DS    XL4
T00005   DS    XL48
P00067   DS    2F
C00066   DC    F'1'
C00068   DC    A(Q00001)
C00069   DC    V(F77WRBEG)
C00070   DC    F'0'
C00071   DC    V(F77WREND)
C00072   DC    F'4'
C00073   DC    A(Q00002)
C00074   DC    F'-1'
C00077   DC    A(Q00003)
C00078   DC    V(F77WRI)
C00079   DC    F'100'
C00080   DC    F'5'
C00081   DC    F'2'
C00082   DC    F'7'
C00085   DC    F'3'
C00075   DC    H'-1'
C00084   DC    H'-3'
C00086   DC    H'1'
Q00001   DC    C'(1X,''>'',3I5)'
Q00002   DC    C'(1X,''>'',6I4)'
Q00003   DC    C'(1X,''>'',2I6)'
* ADDN
ADDN     CSECT
         USING *,15
         B     L00093
         DC    AL1(4),CL7'ADDN'
L00093   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00094
L00095   DC    A(S00087)
L00094   L     15,L00095
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00087,13
         ST    1,S00087+72
L00088   DS    0H
         L     6,0(,1)
         L     2,4(,1)
         LA    2,0(,2)
         LA    4,1
         L     3,0(,2)
         SR    3,4
         AR    3,4
L00089   DS    0H
         LR    2,3
         SLL   2,0
         LA    5,0
         AR    5,2
         C     3,C00096
         BC    2,L00097
         B     L00091
L00097   DS    0H
         LR    2,4
         B     L00090
L00091   DS    0H
         LA    0,0
         B     L00092
L00090   DS    0H
         LR    3,2
         A     3,0(,6)
         ST    3,0(,6)
         BXLE  2,4,L00090
         B     L00091
L00092   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00087   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00096   DC    F'0'
         END
