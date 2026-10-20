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
         LA    0,9
         ST    0,P00038+0
         L     0,C00039
         ST    0,P00038+4
         LA    1,P00038
         L     15,C00040
         BALR  14,15
         L     0,C00041
         ST    0,P00038+0
         LA    0,6
         ST    0,P00038+4
         LA    1,P00038
         L     15,C00042
         BALR  14,15
         L     15,C00043
         BALR  14,15
         LA    0,9
         ST    0,P00038+0
         L     0,C00039
         ST    0,P00038+4
         LA    1,P00038
         L     15,C00040
         BALR  14,15
         L     0,C00044
         ST    0,P00038+0
         LA    0,33
         ST    0,P00038+4
         LA    1,P00038
         L     15,C00042
         BALR  14,15
         L     0,C00045
         ST    0,P00038+0
         LA    0,20
         ST    0,P00038+4
         LA    1,P00038
         L     15,C00042
         BALR  14,15
         L     0,C00046
         ST    0,P00038+0
         LA    0,60
         ST    0,P00038+4
         LA    1,P00038
         L     15,C00042
         BALR  14,15
         L     15,C00043
         BALR  14,15
         LA    0,9
         ST    0,P00038+0
         L     0,C00039
         ST    0,P00038+4
         LA    1,P00038
         L     15,C00040
         BALR  14,15
         L     0,C00047
         ST    0,P00038+0
         LA    0,37
         ST    0,P00038+4
         LA    1,P00038
         L     15,C00042
         BALR  14,15
         L     0,C00048
         ST    0,P00038+0
         LA    0,18
         ST    0,P00038+4
         LA    1,P00038
         L     15,C00042
         BALR  14,15
         L     0,C00049
         ST    0,P00038+0
         LA    0,23
         ST    0,P00038+4
         LA    1,P00038
         L     15,C00042
         BALR  14,15
         L     15,C00043
         BALR  14,15
         LA    0,9
         ST    0,P00038+0
         L     0,C00039
         ST    0,P00038+4
         LA    1,P00038
         L     15,C00040
         BALR  14,15
         L     0,C00050
         ST    0,P00038+0
         LA    0,5
         ST    0,P00038+4
         LA    1,P00038
         L     15,C00042
         BALR  14,15
         L     15,C00043
         BALR  14,15
         LA    0,9
         ST    0,P00038+0
         LA    1,P00038
         L     15,C00051
         BALR  14,15
         LA    0,9
         ST    0,P00038+0
         L     0,C00052
         ST    0,P00038+4
         LA    0,4
         ST    0,P00038+8
         LA    0,1
         ST    0,P00038+12
         LA    0,0
         ST    0,P00038+16
         LA    1,P00038
         L     15,C00053
         BALR  14,15
         L     0,C00054
         ST    0,P00038+0
         LA    0,1
         ST    0,P00038+4
         LA    0,1
         ST    0,P00038+8
         LA    0,T00020
         ST    0,P00038+12
         LA    0,4
         ST    0,P00038+16
         LA    0,1
         ST    0,P00038+20
         LA    1,P00038
         L     15,C00055
         BALR  14,15
         L     0,C00056
         ST    0,P00038+0
         LA    0,1
         ST    0,P00038+4
         LA    0,2
         ST    0,P00038+8
         LA    0,T00021
         ST    0,P00038+12
         LA    0,4
         ST    0,P00038+16
         LA    0,1
         ST    0,P00038+20
         LA    1,P00038
         L     15,C00055
         BALR  14,15
         L     0,C00057
         ST    0,P00038+0
         LA    0,1
         ST    0,P00038+4
         LA    0,2
         ST    0,P00038+8
         LA    0,T00022
         ST    0,P00038+12
         LA    0,4
         ST    0,P00038+16
         LA    0,1
         ST    0,P00038+20
         LA    1,P00038
         L     15,C00055
         BALR  14,15
         L     0,C00058
         ST    0,P00038+0
         LA    0,1
         ST    0,P00038+4
         LA    0,3
         ST    0,P00038+8
         LA    0,T00024
         ST    0,P00038+12
         LA    0,8
         ST    0,P00038+16
         LA    0,1
         ST    0,P00038+20
         LA    1,P00038
         L     15,C00055
         BALR  14,15
         L     0,C00059
         ST    0,P00038+0
         LA    0,1
         ST    0,P00038+4
         LA    0,4
         ST    0,P00038+8
         LA    0,T00025
         ST    0,P00038+12
         LA    0,8
         ST    0,P00038+16
         LA    0,1
         ST    0,P00038+20
         LA    1,P00038
         L     15,C00055
         BALR  14,15
         L     0,C00060
         ST    0,P00038+0
         LA    0,1
         ST    0,P00038+4
         LA    0,4
         ST    0,P00038+8
         LA    0,T00026
         ST    0,P00038+12
         LA    0,8
         ST    0,P00038+16
         LA    0,1
         ST    0,P00038+20
         LA    1,P00038
         L     15,C00055
         BALR  14,15
         L     0,C00061
         ST    0,P00038+0
         LA    0,1
         ST    0,P00038+4
         LA    0,6
         ST    0,P00038+8
         LA    0,T00023
         ST    0,P00038+12
         LA    0,4
         ST    0,P00038+16
         LA    0,1
         ST    0,P00038+20
         LA    1,P00038
         L     15,C00055
         BALR  14,15
         LA    0,1
         ST    0,P00038+0
         LA    0,3
         ST    0,P00038+4
         LA    1,P00038
         L     15,C00062
         BALR  14,15
         L     0,C00063
         ST    0,P00038+0
         LA    0,1
         ST    0,P00038+4
         LA    0,1
         ST    0,P00038+8
         LA    0,T00027
         ST    0,P00038+12
         LA    0,4
         ST    0,P00038+16
         LA    0,3
         ST    0,P00038+20
         LA    1,P00038
         L     15,C00055
         BALR  14,15
         L     15,C00064
         BALR  14,15
         LA    0,6
         ST    0,P00038+0
         L     0,C00065
         ST    0,P00038+4
         LA    1,P00038
         L     15,C00040
         BALR  14,15
         L     3,T00020
         LR    0,3
         ST    0,P00038+0
         LA    1,P00038
         L     15,C00066
         BALR  14,15
         LE    0,T00021
         STE   0,S00000+272
         LE    0,S00000+272
         STE   0,P00038+0
         LA    1,P00038
         L     15,C00067
         BALR  14,15
         LE    0,T00022
         STE   0,S00000+272
         LE    0,S00000+272
         STE   0,P00038+0
         LA    1,P00038
         L     15,C00067
         BALR  14,15
         LD    0,T00024
         STD   0,S00000+272
         LD    0,S00000+272
         STD   0,P00038+0
         LA    1,P00038
         L     15,C00068
         BALR  14,15
         LE    0,T00025
         STE   0,S00000+272
         LE    0,T00025+4
         STE   0,S00000+280
         LE    0,S00000+272
         STE   0,P00038+0
         LE    0,S00000+280
         STE   0,P00038+4
         LA    1,P00038
         L     15,C00069
         BALR  14,15
         LE    0,T00026
         STE   0,S00000+272
         LE    0,T00026+4
         STE   0,S00000+280
         LE    0,S00000+272
         STE   0,P00038+0
         LE    0,S00000+280
         STE   0,P00038+4
         LA    1,P00038
         L     15,C00069
         BALR  14,15
         L     3,T00023
         LR    0,3
         ST    0,P00038+0
         LA    1,P00038
         L     15,C00070
         BALR  14,15
         LA    2,4
         LA    3,3
L00029   DS    0H
         C     3,C00071
         BC    2,L00030
L00031   DS    0H
         L     15,C00043
         BALR  14,15
L00032   DS    0H
L00033   DS    0H
         B     L00034
L00030   DS    0H
         L     5,T00027-4(2)
         LR    0,5
         ST    0,P00038+0
         LA    1,P00038
         L     15,C00066
         BALR  14,15
         AH    3,C00072
         A     2,C00073
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
P00038   DS    6F
C00039   DC    A(Q00001)
C00040   DC    V(F77WRBEG)
C00041   DC    A(Q00002)
C00042   DC    V(F77WRA)
C00043   DC    V(F77WREND)
C00044   DC    A(Q00003)
C00045   DC    A(Q00004)
C00046   DC    A(Q00005)
C00047   DC    A(Q00006)
C00048   DC    A(Q00007)
C00049   DC    A(Q00008)
C00050   DC    A(Q00009)
C00051   DC    V(F77REWND)
C00052   DC    A(Q00010)
C00053   DC    V(F77NMLBG)
C00054   DC    A(Q00011)
C00055   DC    V(F77NMLIT)
C00056   DC    A(Q00012)
C00057   DC    A(Q00013)
C00058   DC    A(Q00014)
C00059   DC    A(Q00015)
C00060   DC    A(Q00016)
C00061   DC    A(Q00017)
C00062   DC    V(F77NMLDM)
C00063   DC    A(Q00018)
C00064   DC    V(F77NMLEN)
C00065   DC    A(Q00019)
C00066   DC    V(F77WRI)
C00067   DC    V(F77WRR)
C00068   DC    V(F77WRD)
C00069   DC    V(F77WRC)
C00070   DC    V(F77WRL)
C00071   DC    F'0'
C00073   DC    F'4'
C00072   DC    H'-1'
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
