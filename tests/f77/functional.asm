* main
F77MAIN  CSECT
         USING *,15
         B     L00020
         DC    AL1(7),CL7'F77MAIN'
L00020   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00021
L00022   DC    A(S00000)
L00021   L     15,L00022
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00002   DS    0H
L00003   DS    0H
L00005   DS    0H
L00007   DS    0H
         LE    0,C00023
         CE    0,C00023
         LA    3,1
         BC    8,L00024
         SR    3,3
L00024   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00025
         SR    2,2
L00025   DS    0H
         LTR   2,2
         BC    7,L00009
L00010   DS    0H
L00008   DS    0H
L00013   DS    0H
L00011   DS    0H
         LD    0,C00026
         CD    0,C00026
         LA    3,1
         BC    8,L00027
         SR    3,3
L00027   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00028
         SR    2,2
L00028   DS    0H
         LTR   2,2
         BC    7,L00015
L00016   DS    0H
L00014   DS    0H
         L     15,C00029
         BALR  14,15
         LA    0,6
         ST    0,P00030+0
         L     0,C00031
         ST    0,P00030+4
         LA    1,P00030
         L     15,C00032
         BALR  14,15
         LA    0,42
         ST    0,P00030+0
         LA    1,P00030
         L     15,C00033
         BALR  14,15
         L     15,C00034
         BALR  14,15
L00017   DS    0H
         LA    0,0
         ST    0,P00030+0
         LA    1,P00030
         L     15,C00035
         BALR  14,15
         B     L00019
L00004   DS    0H
L00006   DS    0H
L00009   DS    0H
         LA    0,3
         ST    0,P00030+0
         LA    1,P00030
         L     15,C00035
         BALR  14,15
         B     L00019
L00012   DS    0H
L00015   DS    0H
         LA    0,5
         ST    0,P00030+0
         LA    1,P00030
         L     15,C00035
         BALR  14,15
         B     L00019
L00018   DS    0H
L00019   DS    0H
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
P00030   DS    2F
C00026   DC    X'4120000000000000'
C00023   DC    X'41180000'
C00029   DC    V(TARR)
C00031   DC    A(Q00001)
C00032   DC    V(F77WRBEG)
C00033   DC    V(F77WRI)
C00034   DC    V(F77WREND)
C00035   DC    V(EXIT)
Q00001   DC    C'(I4)'
* ISQ
ISQ      CSECT
         USING *,15
         B     L00040
         DC    AL1(3),CL7'ISQ'
L00040   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00041
L00042   DC    A(S00036)
L00041   L     15,L00042
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00036,13
         ST    1,S00036+72
L00037   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         LR    1,2
         MR    0,2
         LR    2,1
         LR    0,2
         B     L00039
L00038   DS    0H
L00039   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00036   DS    0D
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
         B     L00049
         DC    AL1(5),CL7'TREAL'
L00049   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00050
L00051   DC    A(S00043)
L00050   L     15,L00051
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00043,13
         ST    1,S00043+72
L00044   DS    0H
         LE    0,C00052
         CE    0,C00052
         LA    3,1
         BC    8,L00053
         SR    3,3
L00053   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00054
         SR    2,2
L00054   DS    0H
         LTR   2,2
         BC    7,L00045
L00046   DS    0H
         LA    0,0
         B     L00048
L00045   DS    0H
         LA    0,3
         ST    0,P00055+0
         LA    1,P00055
         L     15,C00056
         BALR  14,15
         LA    0,3
         B     L00048
L00047   DS    0H
L00048   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00043   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00055   DS    1F
         DS    XL4
C00052   DC    X'41180000'
C00056   DC    V(EXIT)
* TLOG
TLOG     CSECT
         USING *,15
         B     L00063
         DC    AL1(4),CL7'TLOG'
L00063   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00064
L00065   DC    A(S00057)
L00064   L     15,L00065
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00057,13
         ST    1,S00057+72
L00058   DS    0H
L00060   DS    0H
         LA    0,0
         B     L00062
L00059   DS    0H
L00061   DS    0H
L00062   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00057   DS    0D
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
         B     L00072
         DC    AL1(6),CL7'TDPREC'
L00072   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00073
L00074   DC    A(S00066)
L00073   L     15,L00074
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00066,13
         ST    1,S00066+72
L00067   DS    0H
         LD    0,C00075
         CD    0,C00075
         LA    3,1
         BC    8,L00076
         SR    3,3
L00076   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00077
         SR    2,2
L00077   DS    0H
         LTR   2,2
         BC    7,L00068
L00069   DS    0H
         LA    0,0
         B     L00071
L00068   DS    0H
         LA    0,5
         ST    0,P00078+0
         LA    1,P00078
         L     15,C00079
         BALR  14,15
         LA    0,5
         B     L00071
L00070   DS    0H
L00071   DS    0H
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
P00078   DS    1F
         DS    XL4
C00075   DC    X'4120000000000000'
C00079   DC    V(EXIT)
* TARR
TARR     CSECT
         USING *,15
         B     L00087
         DC    AL1(4),CL7'TARR'
L00087   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00088
L00089   DC    A(S00080)
L00088   L     15,L00089
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00080,13
         ST    1,S00080+72
L00082   DS    0H
         LA    15,10
         ST    15,T00081
         LA    15,20
         ST    15,T00081+4
         LA    15,30
         ST    15,T00081+8
L00084   DS    0H
         LA    0,0
         B     L00086
L00083   DS    0H
L00085   DS    0H
L00086   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00080   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00081   DS    XL16
         END
