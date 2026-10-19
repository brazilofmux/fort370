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
         LA    0,6
         ST    0,P00021+0
         L     0,C00022
         ST    0,P00021+4
         LA    1,P00021
         L     15,C00023
         BALR  14,15
         LA    0,3
         ST    0,P00021+0
         LA    1,P00021
         L     15,C00024
         BALR  14,15
         L     15,C00025
         BALR  14,15
L00009   DS    0H
L00008   DS    0H
         LA    0,6
         ST    0,P00021+0
         L     0,C00026
         ST    0,P00021+4
         LA    1,P00021
         L     15,C00023
         BALR  14,15
         LE    0,C00027
         STE   0,P00021+0
         LA    1,P00021
         L     15,C00028
         BALR  14,15
         L     15,C00025
         BALR  14,15
L00011   DS    0H
L00010   DS    0H
         LA    0,6
         ST    0,P00021+0
         L     0,C00029
         ST    0,P00021+4
         LA    1,P00021
         L     15,C00023
         BALR  14,15
         L     0,C00030
         ST    0,P00021+0
         LA    0,6
         ST    0,P00021+4
         LA    1,P00021
         L     15,C00031
         BALR  14,15
L00012   DS    0H
         LA    0,70
         ST    0,P00021+0
         LA    1,P00021
         L     15,C00024
         BALR  14,15
         L     15,C00025
         BALR  14,15
         LA    0,6
         ST    0,P00021+0
         L     0,C00029
         ST    0,P00021+4
         LA    1,P00021
         L     15,C00023
         BALR  14,15
         L     0,C00032
         ST    0,P00021+0
         LA    0,6
         ST    0,P00021+4
         LA    1,P00021
         L     15,C00031
         BALR  14,15
L00013   DS    0H
         LA    0,800
         ST    0,P00021+0
         LA    1,P00021
         L     15,C00024
         BALR  14,15
         L     15,C00025
         BALR  14,15
         LA    0,6
         ST    0,P00021+0
         L     0,C00033
         ST    0,P00021+4
         LA    1,P00021
         L     15,C00023
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
P00021   DS    2F
C00022   DC    A(Q00001)
C00023   DC    V(F77WRBEG)
C00024   DC    V(F77WRI)
C00025   DC    V(F77WREND)
C00026   DC    A(Q00002)
C00027   DC    X'41480000'
C00028   DC    V(F77WRR)
C00029   DC    A(Q00003)
C00030   DC    A(Q00004)
C00031   DC    V(F77WRA)
C00032   DC    A(Q00005)
C00033   DC    A(Q00006)
Q00003   DC    C'('' >'',A,I4)'
Q00001   DC    C'('' >FOPEN MODE'',I3)'
Q00002   DC    C'('' >FREE'',F6.2)'
Q00006   DC    C'('' >WTO, A FORTRAN SUBROUTINE'')'
Q00004   DC    C'STRLEN'
Q00005   DC    C'MALLOC'
* FOPEN
FOPEN    CSECT
         USING *,15
         B     L00038
         DC    AL1(5),CL7'FOPEN'
L00038   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00039
L00040   DC    A(S00034)
L00039   L     15,L00040
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00034,13
         ST    1,S00034+72
L00035   DS    0H
         L     4,0(,1)
         LA    4,0(,4)
         LA    0,6
         ST    0,P00041+0
         L     0,C00042
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00043
         BALR  14,15
         L     3,0(,4)
         LR    0,3
         ST    0,P00041+0
         LA    1,P00041
         L     15,C00044
         BALR  14,15
         L     15,C00045
         BALR  14,15
L00036   DS    0H
         LA    0,0
L00037   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00034   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00041   DS    2F
C00042   DC    A(Q00001)
C00043   DC    V(F77WRBEG)
C00044   DC    V(F77WRI)
C00045   DC    V(F77WREND)
* FREE
FREE     CSECT
         USING *,15
         B     L00050
         DC    AL1(4),CL7'FREE'
L00050   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00051
L00052   DC    A(S00046)
L00051   L     15,L00052
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00046,13
         ST    1,S00046+72
L00047   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         LA    0,6
         ST    0,P00053+0
         L     0,C00054
         ST    0,P00053+4
         LA    1,P00053
         L     15,C00055
         BALR  14,15
         LE    0,0(,3)
         STE   0,S00046+176
         LE    0,S00046+176
         STE   0,P00053+0
         LA    1,P00053
         L     15,C00056
         BALR  14,15
         L     15,C00057
         BALR  14,15
L00048   DS    0H
         LA    0,0
L00049   DS    0H
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
         DS    1D
P00053   DS    2F
C00054   DC    A(Q00002)
C00055   DC    V(F77WRBEG)
C00056   DC    V(F77WRR)
C00057   DC    V(F77WREND)
* STRLEN
STRLEN   CSECT
         USING *,15
         B     L00061
         DC    AL1(6),CL7'STRLEN'
L00061   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00062
L00063   DC    A(S00058)
L00062   L     15,L00063
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00058,13
         ST    1,S00058+72
L00059   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         LR    1,2
         M     0,C00064
         LR    2,1
         LR    0,2
L00060   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00058   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00064   DC    F'10'
* MALLOC
MALLOC   CSECT
         USING *,15
         B     L00068
         DC    AL1(6),CL7'MALLOC'
L00068   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00069
L00070   DC    A(S00065)
L00069   L     15,L00070
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00065,13
         ST    1,S00065+72
L00066   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         LR    1,2
         M     0,C00071
         LR    2,1
         LR    0,2
L00067   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00065   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00071   DC    F'100'
* WTO
WTO      CSECT
         USING *,15
         B     L00076
         DC    AL1(3),CL7'WTO'
L00076   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00077
L00078   DC    A(S00072)
L00077   L     15,L00078
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00072,13
         ST    1,S00072+72
L00073   DS    0H
         LA    0,6
         ST    0,P00079+0
         L     0,C00080
         ST    0,P00079+4
         LA    1,P00079
         L     15,C00081
         BALR  14,15
         L     15,C00082
         BALR  14,15
L00074   DS    0H
         LA    0,0
L00075   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00072   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00079   DS    2F
C00080   DC    A(Q00006)
C00081   DC    V(F77WRBEG)
C00082   DC    V(F77WREND)
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
