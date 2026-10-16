* main
F77MAIN  CSECT
         USING *,15
         B     L00039
         DC    AL1(7),CL7'F77MAIN'
L00039   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00040
L00041   DC    A(S00000)
L00040   L     15,L00041
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00003   DS    0H
L00004   DS    0H
         LA    10,12
         LA    11,48
         LA    2,12
         LA    3,1
L00005   DS    0H
L00007   DS    0H
         LA    7,T00001-16
         LA    8,10
         AR    7,2
         LA    9,30
         LA    4,10
         LA    5,4
L00008   DS    0H
         LR    6,4
         AR    6,3
         ST    6,0(5,7)
L00010   DS    0H
         A     5,C00042
         BXLE  4,8,L00008
L00009   DS    0H
L00011   DS    0H
         A     3,C00043
         BXLE  2,10,L00005
L00006   DS    0H
L00013   DS    0H
         LA    4,4
         LA    5,48
         LA    2,4
L00014   DS    0H
         L     3,T00001-4(2)
         ST    3,T00002-4(2)
L00016   DS    0H
         BXLE  2,4,L00014
L00015   DS    0H
L00012   DS    0H
         L     2,T00002
         C     2,C00044
         BC    7,L00017
L00018   DS    0H
         L     2,T00002+4
         C     2,C00045
         BC    7,L00019
L00020   DS    0H
         L     2,T00002+8
         C     2,C00046
         BC    7,L00021
L00022   DS    0H
         L     2,T00002+12
         C     2,C00047
         BC    7,L00023
L00024   DS    0H
         L     2,T00002+44
         C     2,C00048
         BC    7,L00025
L00026   DS    0H
L00027   DS    0H
L00029   DS    0H
L00031   DS    0H
         LA    4,4
         LA    5,48
         LA    3,4
         LA    2,0
L00032   DS    0H
         A     2,T00001-4(3)
L00034   DS    0H
         BXLE  3,4,L00032
L00033   DS    0H
L00030   DS    0H
         C     2,C00049
         BC    7,L00035
L00036   DS    0H
         LA    0,0
         ST    0,P00050+0
         LA    1,P00050
         L     15,C00051
         BALR  14,15
         B     L00038
L00017   DS    0H
         LA    0,81
         ST    0,P00050+0
         LA    1,P00050
         L     15,C00051
         BALR  14,15
         B     L00038
L00019   DS    0H
         LA    0,82
         ST    0,P00050+0
         LA    1,P00050
         L     15,C00051
         BALR  14,15
         B     L00038
L00021   DS    0H
         LA    0,83
         ST    0,P00050+0
         LA    1,P00050
         L     15,C00051
         BALR  14,15
         B     L00038
L00023   DS    0H
         LA    0,84
         ST    0,P00050+0
         LA    1,P00050
         L     15,C00051
         BALR  14,15
         B     L00038
L00025   DS    0H
         LA    0,85
         ST    0,P00050+0
         LA    1,P00050
         L     15,C00051
         BALR  14,15
         B     L00038
L00028   DS    0H
L00035   DS    0H
         LA    0,87
         ST    0,P00050+0
         LA    1,P00050
         L     15,C00051
         BALR  14,15
         B     L00038
L00037   DS    0H
L00038   DS    0H
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
T00001   DS    XL52
         DS    XL4
T00002   DS    XL52
         DS    XL4
P00050   DS    1F
         DS    XL4
C00042   DC    F'4'
C00043   DC    F'1'
C00044   DC    F'11'
C00045   DC    F'21'
C00046   DC    F'31'
C00047   DC    F'12'
C00048   DC    F'34'
C00049   DC    F'270'
C00051   DC    V(EXIT)
* COPY12
COPY12   CSECT
         USING *,15
         B     L00060
         DC    AL1(6),CL7'COPY12'
L00060   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00061
L00062   DC    A(S00052)
L00061   L     15,L00062
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00052,13
         ST    1,S00052+72
L00053   DS    0H
         L     3,0(,1)
         L     4,4(,1)
         LA    4,0(,4)
L00054   DS    0H
         AH    4,C00063
         AH    3,C00063
         LA    6,4
         LA    7,48
         LA    2,4
L00055   DS    0H
         L     5,0(2,3)
         ST    5,0(2,4)
L00057   DS    0H
         BXLE  2,6,L00055
L00056   DS    0H
         LA    0,0
         B     L00059
L00058   DS    0H
L00059   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00052   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00063   DC    H'-4'
* DOUBLE
DOUBLE   CSECT
         USING *,15
         B     L00068
         DC    AL1(6),CL7'DOUBLE'
L00068   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00069
L00070   DC    A(S00064)
L00069   L     15,L00070
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00064,13
         ST    1,S00064+72
L00065   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         SLL   2,1
         ST    2,0(,3)
         LA    0,0
         B     L00067
L00066   DS    0H
L00067   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00064   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
* ADDUP
ADDUP    CSECT
         USING *,15
         B     L00079
         DC    AL1(5),CL7'ADDUP'
L00079   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00080
L00081   DC    A(S00071)
L00080   L     15,L00081
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00071,13
         ST    1,S00071+72
L00072   DS    0H
         L     4,0(,1)
         L     2,4(,1)
         L     5,8(,1)
         LA    5,0(,5)
         LA    15,0
         ST    15,0(,5)
         L     3,0(,2)
         S     3,C00082
         A     3,C00082
L00073   DS    0H
         AH    4,C00083
         LA    6,4
         LR    2,3
         SLL   2,2
         LA    7,0
         AR    7,2
         C     3,C00084
         BC    2,L00085
         B     L00075
L00085   DS    0H
         LA    2,4
         B     L00074
L00075   DS    0H
         LA    0,0
         B     L00078
L00074   DS    0H
         L     3,0(,5)
         A     3,0(2,4)
         ST    3,0(,5)
L00076   DS    0H
         BXLE  2,6,L00074
         B     L00075
L00077   DS    0H
L00078   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00071   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00082   DC    F'1'
C00084   DC    F'0'
C00083   DC    H'-4'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
