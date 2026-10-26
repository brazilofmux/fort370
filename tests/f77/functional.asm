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
         LA    1,P00030
         L     15,C00031
         BALR  14,15
         LA    1,P00032
         L     15,C00033
         BALR  14,15
         L     15,C00034
         BALR  14,15
L00017   DS    0H
         LA    1,P00035
         L     15,C00036
         BALR  14,15
         B     L00019
L00004   DS    0H
L00006   DS    0H
L00009   DS    0H
         LA    1,P00037
         L     15,C00036
         BALR  14,15
         B     L00019
L00012   DS    0H
L00015   DS    0H
         LA    1,P00038
         L     15,C00036
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
P00030   DC    F'6'
         DC    A(Q00001)
P00032   DC    F'42'
P00035   DC    F'0'
P00037   DC    F'3'
P00038   DC    F'5'
C00026   DC    X'4120000000000000'
C00023   DC    X'41180000'
C00029   DC    V(TARR)
C00031   DC    V(F77WRBEG)
C00033   DC    V(F77WRI)
C00034   DC    V(F77WREND)
C00036   DC    V(EXIT)
Q00001   DC    C'(I4)'
* ISQ
ISQ      CSECT
         USING *,15
         B     L00043
         DC    AL1(3),CL7'ISQ'
L00043   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00044
L00045   DC    A(S00039)
L00044   L     15,L00045
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00039,13
         ST    1,S00039+72
L00040   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         LR    1,2
         MR    0,2
         LR    2,1
         LR    0,2
         B     L00042
L00041   DS    0H
L00042   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00039   DS    0D
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
         B     L00052
         DC    AL1(5),CL7'TREAL'
L00052   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00053
L00054   DC    A(S00046)
L00053   L     15,L00054
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00046,13
         ST    1,S00046+72
L00047   DS    0H
         LE    0,C00055
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
         BC    7,L00048
L00049   DS    0H
         LA    0,0
         B     L00051
L00048   DS    0H
         LA    1,P00058
         L     15,C00059
         BALR  14,15
         LA    0,3
         B     L00051
L00050   DS    0H
L00051   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00046   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00058   DC    F'3'
         DS    XL4
C00055   DC    X'41180000'
C00059   DC    V(EXIT)
* TLOG
TLOG     CSECT
         USING *,15
         B     L00066
         DC    AL1(4),CL7'TLOG'
L00066   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00067
L00068   DC    A(S00060)
L00067   L     15,L00068
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00060,13
         ST    1,S00060+72
L00061   DS    0H
L00063   DS    0H
         LA    0,0
         B     L00065
L00062   DS    0H
L00064   DS    0H
L00065   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00060   DS    0D
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
         B     L00075
         DC    AL1(6),CL7'TDPREC'
L00075   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00076
L00077   DC    A(S00069)
L00076   L     15,L00077
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00069,13
         ST    1,S00069+72
L00070   DS    0H
         LD    0,C00078
         CD    0,C00078
         LA    3,1
         BC    8,L00079
         SR    3,3
L00079   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00080
         SR    2,2
L00080   DS    0H
         LTR   2,2
         BC    7,L00071
L00072   DS    0H
         LA    0,0
         B     L00074
L00071   DS    0H
         LA    1,P00081
         L     15,C00082
         BALR  14,15
         LA    0,5
         B     L00074
L00073   DS    0H
L00074   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00069   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00081   DC    F'5'
         DS    XL4
C00078   DC    X'4120000000000000'
C00082   DC    V(EXIT)
* TARR
TARR     CSECT
         USING *,15
         B     L00090
         DC    AL1(4),CL7'TARR'
L00090   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00091
L00092   DC    A(S00083)
L00091   L     15,L00092
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00083,13
         ST    1,S00083+72
L00085   DS    0H
         LA    15,10
         ST    15,T00084
         LA    15,20
         ST    15,T00084+4
         LA    15,30
         ST    15,T00084+8
L00087   DS    0H
         LA    0,0
         B     L00089
L00086   DS    0H
L00088   DS    0H
L00089   DS    0H
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
T00084   DS    XL16
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
