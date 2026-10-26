* main
F77MAIN  CSECT
         USING *,15
         B     L00018
         DC    AL1(7),CL7'F77MAIN'
L00018   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00019
L00020   DC    A(S00000)
L00019   L     15,L00020
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00007   DS    0H
         LA    1,P00021
         L     15,C00022
         BALR  14,15
         LA    1,P00023
         L     15,C00024
         BALR  14,15
         L     15,C00025
         BALR  14,15
L00009   DS    0H
L00008   DS    0H
         LA    1,P00026
         L     15,C00022
         BALR  14,15
         LE    0,C00028
         STE   0,P00027+0
         LA    1,P00027
         L     15,C00029
         BALR  14,15
         L     15,C00025
         BALR  14,15
L00011   DS    0H
L00010   DS    0H
         LA    1,P00030
         L     15,C00022
         BALR  14,15
         LA    1,P00031
         L     15,C00032
         BALR  14,15
L00012   DS    0H
         LA    1,P00033
         L     15,C00024
         BALR  14,15
         L     15,C00025
         BALR  14,15
         LA    1,P00030
         L     15,C00022
         BALR  14,15
         LA    1,P00034
         L     15,C00032
         BALR  14,15
L00013   DS    0H
         LA    1,P00035
         L     15,C00024
         BALR  14,15
         L     15,C00025
         BALR  14,15
         LA    1,P00036
         L     15,C00022
         BALR  14,15
         L     15,C00025
         BALR  14,15
L00015   DS    0H
L00014   DS    0H
L00016   DS    0H
L00017   DS    0H
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
P00021   DC    F'6'
         DC    A(Q00001)
P00023   DC    F'3'
P00026   DC    F'6'
         DC    A(Q00002)
         DS    F
P00027   DC    A(0)
P00030   DC    F'6'
         DC    A(Q00003)
P00031   DC    A(Q00004)
         DC    F'6'
P00033   DC    F'70'
P00034   DC    A(Q00005)
         DC    F'6'
P00035   DC    F'800'
P00036   DC    F'6'
         DC    A(Q00006)
         DS    XL4
C00022   DC    V(F77WRBEG)
C00024   DC    V(F77WRI)
C00025   DC    V(F77WREND)
C00028   DC    X'41480000'
C00029   DC    V(F77WRR)
C00032   DC    V(F77WRA)
Q00003   DC    C'('' >'',A,I4)'
Q00001   DC    C'('' >FOPEN MODE'',I3)'
Q00002   DC    C'('' >FREE'',F6.2)'
Q00006   DC    C'('' >WTO, A FORTRAN SUBROUTINE'')'
Q00004   DC    C'STRLEN'
Q00005   DC    C'MALLOC'
* FOPEN
FOPEN    CSECT
         USING *,15
         B     L00041
         DC    AL1(5),CL7'FOPEN'
L00041   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00042
L00043   DC    A(S00037)
L00042   L     15,L00043
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00037,13
         ST    1,S00037+72
L00038   DS    0H
         L     4,0(,1)
         LA    4,0(,4)
         LA    1,P00044
         L     15,C00045
         BALR  14,15
         L     3,0(,4)
         LR    0,3
         ST    0,P00046+0
         LA    1,P00046
         L     15,C00047
         BALR  14,15
         L     15,C00048
         BALR  14,15
L00039   DS    0H
         LA    0,0
L00040   DS    0H
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
P00044   DC    F'6'
         DC    A(Q00001)
P00046   DC    A(0)
         DS    XL4
C00045   DC    V(F77WRBEG)
C00047   DC    V(F77WRI)
C00048   DC    V(F77WREND)
* FREE
FREE     CSECT
         USING *,15
         B     L00053
         DC    AL1(4),CL7'FREE'
L00053   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00054
L00055   DC    A(S00049)
L00054   L     15,L00055
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00049,13
         ST    1,S00049+72
L00050   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         LA    1,P00056
         L     15,C00057
         BALR  14,15
         LE    0,0(,3)
         STE   0,S00049+176
         LE    0,S00049+176
         STE   0,P00058+0
         LA    1,P00058
         L     15,C00059
         BALR  14,15
         L     15,C00060
         BALR  14,15
L00051   DS    0H
         LA    0,0
L00052   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00049   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
         DS    1D
P00056   DC    F'6'
         DC    A(Q00002)
P00058   DC    A(0)
         DS    XL4
C00057   DC    V(F77WRBEG)
C00059   DC    V(F77WRR)
C00060   DC    V(F77WREND)
* STRLEN
STRLEN   CSECT
         USING *,15
         B     L00064
         DC    AL1(6),CL7'STRLEN'
L00064   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00065
L00066   DC    A(S00061)
L00065   L     15,L00066
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00061,13
         ST    1,S00061+72
L00062   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         LR    1,2
         M     0,C00067
         LR    2,1
         LR    0,2
L00063   DS    0H
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
C00067   DC    F'10'
* MALLOC
MALLOC   CSECT
         USING *,15
         B     L00071
         DC    AL1(6),CL7'MALLOC'
L00071   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00072
L00073   DC    A(S00068)
L00072   L     15,L00073
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00068,13
         ST    1,S00068+72
L00069   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         LR    1,2
         M     0,C00074
         LR    2,1
         LR    0,2
L00070   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00068   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00074   DC    F'100'
* WTO
WTO      CSECT
         USING *,15
         B     L00079
         DC    AL1(3),CL7'WTO'
L00079   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00080
L00081   DC    A(S00075)
L00080   L     15,L00081
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00075,13
         ST    1,S00075+72
L00076   DS    0H
         LA    1,P00082
         L     15,C00083
         BALR  14,15
         L     15,C00084
         BALR  14,15
L00077   DS    0H
         LA    0,0
L00078   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00075   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00082   DC    F'6'
         DC    A(Q00006)
C00083   DC    V(F77WRBEG)
C00084   DC    V(F77WREND)
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
