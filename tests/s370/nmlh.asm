* main
F77MAIN  CSECT
         USING *,15
         B     L00035
         DC    AL1(7),CL7'F77MAIN'
L00035   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00036
L00037   DC    A(S00000)
L00036   L     15,L00037
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00028   DS    0H
         LA    1,P00038
         L     15,C00039
         BALR  14,15
         LA    1,P00040
         L     15,C00041
         BALR  14,15
         L     15,C00042
         BALR  14,15
         LA    1,P00038
         L     15,C00039
         BALR  14,15
         LA    1,P00043
         L     15,C00041
         BALR  14,15
         LA    1,P00044
         L     15,C00041
         BALR  14,15
         LA    1,P00045
         L     15,C00041
         BALR  14,15
         L     15,C00042
         BALR  14,15
         LA    1,P00038
         L     15,C00039
         BALR  14,15
         LA    1,P00046
         L     15,C00041
         BALR  14,15
         LA    1,P00047
         L     15,C00041
         BALR  14,15
         LA    1,P00048
         L     15,C00041
         BALR  14,15
         L     15,C00042
         BALR  14,15
         LA    1,P00038
         L     15,C00039
         BALR  14,15
         LA    1,P00049
         L     15,C00041
         BALR  14,15
         L     15,C00042
         BALR  14,15
         LA    1,P00050
         L     15,C00051
         BALR  14,15
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         LA    1,P00054
         L     15,C00055
         BALR  14,15
         LA    1,P00056
         L     15,C00055
         BALR  14,15
         LA    1,P00057
         L     15,C00055
         BALR  14,15
         LA    1,P00058
         L     15,C00055
         BALR  14,15
         LA    1,P00059
         L     15,C00055
         BALR  14,15
         LA    1,P00060
         L     15,C00055
         BALR  14,15
         LA    1,P00061
         L     15,C00055
         BALR  14,15
         LA    1,P00062
         L     15,C00063
         BALR  14,15
         LA    1,P00064
         L     15,C00055
         BALR  14,15
         L     15,C00065
         BALR  14,15
         LA    1,P00066
         L     15,C00039
         BALR  14,15
         L     3,T00020
         LR    0,3
         ST    0,P00067+0
         LA    1,P00067
         L     15,C00068
         BALR  14,15
         LE    0,T00021
         STE   0,S00000+272
         LE    0,S00000+272
         STE   0,P00069+0
         LA    1,P00069
         L     15,C00070
         BALR  14,15
         LE    0,T00022
         STE   0,S00000+272
         LE    0,S00000+272
         STE   0,P00069+0
         LA    1,P00069
         L     15,C00070
         BALR  14,15
         LD    0,T00024
         STD   0,S00000+272
         LD    0,S00000+272
         STD   0,P00071+0
         LA    1,P00071
         L     15,C00072
         BALR  14,15
         LE    0,T00025
         STE   0,S00000+272
         LE    0,T00025+4
         STE   0,S00000+280
         LE    0,S00000+272
         STE   0,P00071+0
         LE    0,S00000+280
         STE   0,P00071+4
         LA    1,P00071
         L     15,C00073
         BALR  14,15
         LE    0,T00026
         STE   0,S00000+272
         LE    0,T00026+4
         STE   0,S00000+280
         LE    0,S00000+272
         STE   0,P00071+0
         LE    0,S00000+280
         STE   0,P00071+4
         LA    1,P00071
         L     15,C00073
         BALR  14,15
         L     3,T00023
         LR    0,3
         ST    0,P00067+0
         LA    1,P00067
         L     15,C00074
         BALR  14,15
         LA    2,4
         LA    3,3
L00029   DS    0H
         C     3,C00075
         BC    2,L00030
L00031   DS    0H
         L     15,C00042
         BALR  14,15
L00032   DS    0H
L00033   DS    0H
         B     L00034
L00030   DS    0H
         L     5,T00027-4(2)
         LR    0,5
         ST    0,P00067+0
         LA    1,P00067
         L     15,C00068
         BALR  14,15
         AH    3,C00076
         A     2,C00077
         B     L00029
L00034   DS    0H
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
T00020   DS    XL8
T00021   DS    XL8
T00022   DS    XL8
T00023   DS    XL8
T00024   DS    XL12
         DS    XL4
T00025   DS    XL12
         DS    XL4
T00026   DS    XL12
         DS    XL4
T00027   DS    XL16
         DS    2D
P00038   DC    F'9'
         DC    A(Q00001)
P00040   DC    A(Q00002)
         DC    F'6'
P00043   DC    A(Q00003)
         DC    F'33'
P00044   DC    A(Q00004)
         DC    F'20'
P00045   DC    A(Q00005)
         DC    F'60'
P00046   DC    A(Q00006)
         DC    F'37'
P00047   DC    A(Q00007)
         DC    F'18'
P00048   DC    A(Q00008)
         DC    F'23'
P00049   DC    A(Q00009)
         DC    F'5'
P00050   DC    F'9'
P00052   DC    F'9'
         DC    A(Q00010)
         DC    F'4'
         DC    F'1'
         DC    F'0'
P00054   DC    A(Q00011)
         DC    F'1'
         DC    F'1'
         DC    A(T00020)
         DC    F'4'
         DC    F'1'
P00056   DC    A(Q00012)
         DC    F'1'
         DC    F'2'
         DC    A(T00021)
         DC    F'4'
         DC    F'1'
P00057   DC    A(Q00013)
         DC    F'1'
         DC    F'2'
         DC    A(T00022)
         DC    F'4'
         DC    F'1'
P00058   DC    A(Q00014)
         DC    F'1'
         DC    F'3'
         DC    A(T00024)
         DC    F'8'
         DC    F'1'
P00059   DC    A(Q00015)
         DC    F'1'
         DC    F'4'
         DC    A(T00025)
         DC    F'8'
         DC    F'1'
P00060   DC    A(Q00016)
         DC    F'1'
         DC    F'4'
         DC    A(T00026)
         DC    F'8'
         DC    F'1'
P00061   DC    A(Q00017)
         DC    F'1'
         DC    F'6'
         DC    A(T00023)
         DC    F'4'
         DC    F'1'
P00062   DC    F'1'
         DC    F'3'
P00064   DC    A(Q00018)
         DC    F'1'
         DC    F'1'
         DC    A(T00027)
         DC    F'4'
         DC    F'3'
P00066   DC    F'6'
         DC    A(Q00019)
P00067   DC    A(0)
         DS    F
P00069   DC    A(0)
         DS    F
P00071   DC    A(0)
         DC    A(0)
C00039   DC    V(F77WRBEG)
C00041   DC    V(F77WRA)
C00042   DC    V(F77WREND)
C00051   DC    V(F77REWND)
C00053   DC    V(F77NMLBG)
C00055   DC    V(F77NMLIT)
C00063   DC    V(F77NMLDM)
C00065   DC    V(F77NMLEN)
C00068   DC    V(F77WRI)
C00070   DC    V(F77WRR)
C00072   DC    V(F77WRD)
C00073   DC    V(F77WRC)
C00074   DC    V(F77WRL)
C00075   DC    F'0'
C00077   DC    F'4'
C00076   DC    H'-1'
Q00001   DC    C'(A,A,A)'
Q00019   DC    C'('' >'',I4,2E12.4,D14.4,4E12.4,L2,3I3)'
Q00002   DC    C' &&HGRP'
Q00003   DC    C' J=        -64,P= 0.25000000E 10,'
Q00004   DC    C'Q= 0.0           ,E='
Q00005   DC    C'-0.3750000000000000D 12,Z=  (0.12500000E'
         DC    C'-04,0.50000000E 09),'
Q00006   DC    C' W=  (0.0           ,0.0           ),'
Q00007   DC    C'U=T,L=          3,'
Q00008   DC    C'          2,          1'
Q00009   DC    C' &&END'
Q00010   DC    C'HGRP'
Q00011   DC    C'J'
Q00012   DC    C'P'
Q00013   DC    C'Q'
Q00014   DC    C'E'
Q00015   DC    C'Z'
Q00016   DC    C'W'
Q00017   DC    C'U'
Q00018   DC    C'L'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
