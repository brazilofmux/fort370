* main
F77MAIN  CSECT
         USING *,15
         B     L00024
         DC    AL1(7),CL7'F77MAIN'
L00024   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00025
L00026   DC    A(S00000)
L00025   L     15,L00026
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00003   DS    0H
L00004   DS    0H
L00006   DS    0H
L00008   DS    0H
         LE    0,C00027
         CE    0,C00027
         LA    3,1
         BC    8,L00028
         SR    3,3
L00028   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00029
         SR    2,2
L00029   DS    0H
         LTR   2,2
         BC    7,L00010
L00011   DS    0H
L00009   DS    0H
L00014   DS    0H
L00012   DS    0H
         LD    0,C00030
         CD    0,C00030
         LA    3,1
         BC    8,L00031
         SR    3,3
L00031   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00032
         SR    2,2
L00032   DS    0H
         LTR   2,2
         BC    7,L00016
L00017   DS    0H
L00015   DS    0H
         LA    15,10
         ST    15,T00002
         LA    15,20
         ST    15,T00002+4
         LA    15,30
         ST    15,T00002+8
         L     2,T00002+4
         C     2,C00033
         BC    7,L00019
L00020   DS    0H
L00018   DS    0H
         LA    0,6
         ST    0,P00034+0
         L     0,C00035
         ST    0,P00034+4
         LA    1,P00034
         L     15,C00036
         BALR  14,15
         LA    0,42
         ST    0,P00034+0
         LA    1,P00034
         L     15,C00037
         BALR  14,15
         L     15,C00038
         BALR  14,15
L00021   DS    0H
         LA    0,0
         ST    0,P00034+0
         LA    1,P00034
         L     15,C00039
         BALR  14,15
         B     L00023
L00005   DS    0H
L00007   DS    0H
L00010   DS    0H
         LA    0,3
         ST    0,P00034+0
         LA    1,P00034
         L     15,C00039
         BALR  14,15
         B     L00023
L00013   DS    0H
L00016   DS    0H
         LA    0,5
         ST    0,P00034+0
         LA    1,P00034
         L     15,C00039
         BALR  14,15
         B     L00023
L00019   DS    0H
         LA    0,6
         ST    0,P00034+0
         LA    1,P00034
         L     15,C00039
         BALR  14,15
         B     L00023
L00022   DS    0H
L00023   DS    0H
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
T00002   DS    XL72
P00034   DS    2F
C00030   DC    X'4120000000000000'
C00027   DC    X'41180000'
C00033   DC    F'20'
C00035   DC    A(Q00001)
C00036   DC    V(F77WRBEG)
C00037   DC    V(F77WRI)
C00038   DC    V(F77WREND)
C00039   DC    V(EXIT)
Q00001   DC    C'(I4)'
* ISQ
ISQ      CSECT
         USING *,15
         B     L00044
         DC    AL1(3),CL7'ISQ'
L00044   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00045
L00046   DC    A(S00040)
L00045   L     15,L00046
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00040,13
         ST    1,S00040+72
L00041   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         LR    1,2
         MR    0,2
         LR    2,1
         LR    0,2
         B     L00043
L00042   DS    0H
L00043   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00040   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
* TREAL
TREAL    CSECT
         USING *,15
         B     L00053
         DC    AL1(5),CL7'TREAL'
L00053   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00054
L00055   DC    A(S00047)
L00054   L     15,L00055
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00047,13
         ST    1,S00047+72
L00048   DS    0H
         LE    0,C00056
         CE    0,C00056
         LA    3,1
         BC    8,L00057
         SR    3,3
L00057   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00058
         SR    2,2
L00058   DS    0H
         LTR   2,2
         BC    7,L00049
L00050   DS    0H
         LA    0,0
         B     L00052
L00049   DS    0H
         LA    0,3
         ST    0,P00059+0
         LA    1,P00059
         L     15,C00060
         BALR  14,15
         LA    0,3
         B     L00052
L00051   DS    0H
L00052   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00047   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00059   DS    1F
         DS    XL4
C00056   DC    X'41180000'
C00060   DC    V(EXIT)
* TLOG
TLOG     CSECT
         USING *,15
         B     L00067
         DC    AL1(4),CL7'TLOG'
L00067   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00068
L00069   DC    A(S00061)
L00068   L     15,L00069
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00061,13
         ST    1,S00061+72
L00062   DS    0H
L00064   DS    0H
         LA    0,0
         B     L00066
L00063   DS    0H
L00065   DS    0H
L00066   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00061   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
* TDPREC
TDPREC   CSECT
         USING *,15
         B     L00076
         DC    AL1(6),CL7'TDPREC'
L00076   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00077
L00078   DC    A(S00070)
L00077   L     15,L00078
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00070,13
         ST    1,S00070+72
L00071   DS    0H
         LD    0,C00079
         CD    0,C00079
         LA    3,1
         BC    8,L00080
         SR    3,3
L00080   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00081
         SR    2,2
L00081   DS    0H
         LTR   2,2
         BC    7,L00072
L00073   DS    0H
         LA    0,0
         B     L00075
L00072   DS    0H
         LA    0,5
         ST    0,P00082+0
         LA    1,P00082
         L     15,C00083
         BALR  14,15
         LA    0,5
         B     L00075
L00074   DS    0H
L00075   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00070   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00082   DS    1F
         DS    XL4
C00079   DC    X'4120000000000000'
C00083   DC    V(EXIT)
* TARR
TARR     CSECT
         USING *,15
         B     L00091
         DC    AL1(4),CL7'TARR'
L00091   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00092
L00093   DC    A(S00084)
L00092   L     15,L00093
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00084,13
         ST    1,S00084+72
L00086   DS    0H
         LA    15,10
         ST    15,T00085
         LA    15,20
         ST    15,T00085+4
         LA    15,30
         ST    15,T00085+8
         L     2,T00085+4
         C     2,C00094
         BC    7,L00087
L00088   DS    0H
         LA    0,0
         B     L00090
L00087   DS    0H
         LA    0,6
         ST    0,P00095+0
         LA    1,P00095
         L     15,C00096
         BALR  14,15
         LA    0,6
         B     L00090
L00089   DS    0H
L00090   DS    0H
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
T00085   DS    XL16
P00095   DS    1F
         DS    XL4
C00094   DC    F'20'
C00096   DC    V(EXIT)
         END
