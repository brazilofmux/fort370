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
L00017   DS    0H
         LA    4,1
L00018   DS    0H
         LA    5,4
         LR    2,4
L00019   DS    0H
         LA    0,T00015
         ST    0,P00047+0
         OI    P00047+0,X'80'
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         C     2,T00015
         BC    7,L00021
L00022   DS    0H
L00023   DS    0H
         BXLE  2,4,L00019
L00020   DS    0H
         LA    15,7
         ST    15,T00016
         LA    15,1
         ST    15,T00002
         LA    0,T00016
         ST    0,P00047+0
         LA    0,T00002
         ST    0,P00047+4
         LA    0,T00013
         ST    0,P00047+8
         OI    P00047+8,X'80'
         LA    1,P00047
         L     15,C00049
         BALR  14,15
         LA    15,9
         ST    15,T00003
         LA    15,0
         ST    15,T00004
         LA    0,T00003
         ST    0,P00047+0
         LA    0,T00004
         ST    0,P00047+4
         LA    0,T00013
         ST    0,P00047+8
         OI    P00047+8,X'80'
         LA    1,P00047
         L     15,C00049
         BALR  14,15
         L     2,T00013
         C     2,C00050
         BC    7,L00024
L00025   DS    0H
         MVC   T00005(4),C00051
         LA    15,1
         ST    15,T00006
         LA    0,T00005
         ST    0,P00047+0
         LA    0,T00006
         ST    0,P00047+4
         OI    P00047+4,X'80'
         LA    1,P00047
         L     15,C00052
         BALR  14,15
         MVC   T00007(4),C00053
         LA    15,0
         ST    15,T00008
         LA    0,T00007
         ST    0,P00047+0
         LA    0,T00008
         ST    0,P00047+4
         OI    P00047+4,X'80'
         LA    1,P00047
         L     15,C00052
         BALR  14,15
         MVC   T00009(4),C00054
         LA    15,0
         ST    15,T00010
         LA    0,T00009
         ST    0,P00047+0
         LA    0,T00010
         ST    0,P00047+4
         OI    P00047+4,X'80'
         LA    1,P00047
         L     15,C00052
         BALR  14,15
         STE   0,S00000+328
         LE    0,S00000+328
         CE    0,C00055
         LA    3,1
         BC    8,L00056
         SR    3,3
L00056   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00057
         SR    2,2
L00057   DS    0H
         LTR   2,2
         BC    7,L00026
L00027   DS    0H
         LA    15,1
         ST    15,T00011
         LA    0,T00011
         ST    0,P00047+0
         LA    0,T00014
         ST    0,P00047+4
         OI    P00047+4,X'80'
         LA    1,P00047
         L     15,C00058
         BALR  14,15
         LA    15,0
         ST    15,T00012
         LA    0,T00012
         ST    0,P00047+0
         LA    0,T00014
         ST    0,P00047+4
         OI    P00047+4,X'80'
         LA    1,P00047
         L     15,C00058
         BALR  14,15
         L     2,T00014
         C     2,C00059
         BC    7,L00028
L00029   DS    0H
L00031   DS    0H
L00033   DS    0H
L00030   DS    0H
L00035   DS    0H
L00038   DS    0H
L00039   DS    0H
L00036   DS    0H
L00041   DS    0H
         LA    0,6
         ST    0,P00047+0
         L     0,C00060
         ST    0,P00047+4
         LA    1,P00047
         L     15,C00061
         BALR  14,15
         L     3,T00015
         LR    0,3
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00062
         BALR  14,15
         L     3,T00013
         LR    0,3
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00062
         BALR  14,15
         LE    0,S00000+328
         STE   0,P00047+0
         LA    1,P00047
         L     15,C00063
         BALR  14,15
         L     3,T00014
         LR    0,3
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00062
         BALR  14,15
         LA    0,22
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00062
         BALR  14,15
         L     15,C00064
         BALR  14,15
L00042   DS    0H
         B     L00043
L00021   DS    0H
         LA    0,1
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00065
         BALR  14,15
         B     L00043
L00024   DS    0H
         LA    0,2
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00065
         BALR  14,15
         B     L00043
L00026   DS    0H
         LA    0,3
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00065
         BALR  14,15
         B     L00043
L00028   DS    0H
         LA    0,4
         ST    0,P00047+0
         LA    1,P00047
         L     15,C00065
         BALR  14,15
         B     L00043
L00032   DS    0H
L00034   DS    0H
L00037   DS    0H
L00040   DS    0H
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
T00009   DS    XL4
         DS    XL4
T00010   DS    XL4
         DS    XL4
T00011   DS    XL4
         DS    XL4
T00012   DS    XL4
         DS    XL4
T00013   DS    XL8
T00014   DS    XL8
T00015   DS    XL16
T00016   DS    XL32
         DS    1D
P00047   DS    3F
         DS    XL4
C00048   DC    V(NEXTID)
C00049   DC    V(LAST)
C00050   DC    F'7'
C00051   DC    X'00000000'
C00052   DC    V(TOTAL)
C00053   DC    X'41280000'
C00054   DC    X'41180000'
C00055   DC    X'41400000'
C00058   DC    V(PAIRS)
C00059   DC    F'5'
C00060   DC    A(Q00001)
C00061   DC    V(F77WRBEG)
C00062   DC    V(F77WRI)
C00063   DC    V(F77WRR)
C00064   DC    V(F77WREND)
C00065   DC    V(EXIT)
Q00001   DC    C'(1X,''>'',2I4,F6.1,2I4)'
* NEXTID
NEXTID   CSECT
         USING *,15
         B     L00070
         DC    AL1(6),CL7'NEXTID'
L00070   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00071
L00072   DC    A(S00066)
L00071   L     15,L00072
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00066,13
         ST    1,S00066+72
L00068   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,T00067
         A     2,C00073
         ST    2,T00067
         ST    2,0(,3)
         LA    0,0
L00069   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00066   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00067   DS    XL8
C00073   DC    F'1'
* LAST
LAST     CSECT
         USING *,15
         B     L00080
         DC    AL1(4),CL7'LAST'
L00080   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00081
L00082   DC    A(S00074)
L00081   L     15,L00082
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00074,13
         ST    1,S00074+72
L00076   DS    0H
         L     5,0(,1)
         L     4,4(,1)
         L     3,8(,1)
         LA    3,0(,3)
         L     2,0(,4)
         C     2,C00083
         BC    7,L00078
L00077   DS    0H
         L     2,0(,5)
         ST    2,T00075
L00078   DS    0H
         L     2,T00075
         ST    2,0(,3)
         LA    0,0
L00079   DS    0H
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
T00075   DS    XL8
C00083   DC    F'1'
* TOTAL
TOTAL    CSECT
         USING *,15
         B     L00090
         DC    AL1(5),CL7'TOTAL'
L00090   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00091
L00092   DC    A(S00084)
L00091   L     15,L00092
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00084,13
         ST    1,S00084+72
L00086   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         L     2,0(,3)
         C     2,C00093
         BC    7,L00088
L00087   DS    0H
         MVC   T00085(4),C00094
L00088   DS    0H
         LE    0,T00085
         AE    0,0(,4)
         STE   0,T00085
L00089   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00084   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00085   DS    XL8
C00093   DC    F'1'
C00094   DC    X'00000000'
* PAIRS
PAIRS    CSECT
         USING *,15
         B     L00102
         DC    AL1(5),CL7'PAIRS'
L00102   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00103
L00104   DC    A(S00095)
L00103   L     15,L00104
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00095,13
         ST    1,S00095+72
L00097   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         L     2,0(,4)
         C     2,C00105
         BC    8,L00098
L00099   DS    0H
L00100   DS    0H
         L     2,T00096
         A     2,T00096+4
         ST    2,0(,3)
         LA    0,0
         B     L00101
L00098   DS    0H
         LA    15,2
         ST    15,T00096
         LA    15,3
         ST    15,T00096+4
         B     L00100
L00101   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00095   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00096   DS    XL12
         DS    XL4
C00105   DC    F'1'
* BOTH
BOTH     CSECT
         USING *,15
         B     L00112
         DC    AL1(4),CL7'BOTH'
L00112   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00113
L00114   DC    A(S00106)
L00113   L     15,L00114
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00106,13
         ST    1,S00106+72
L00107   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         L     2,0(,4)
         C     2,C00115
         BC    8,L00108
L00109   DS    0H
         LA    2,22
L00110   DS    0H
         ST    2,0(,3)
         LA    0,0
         B     L00111
L00108   DS    0H
         LA    2,11
         B     L00110
L00111   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00106   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00115   DC    F'1'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
