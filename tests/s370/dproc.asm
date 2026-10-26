* main
F77MAIN  CSECT
         USING *,15
         B     L00015
         DC    AL1(7),CL7'F77MAIN'
L00015   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00016
L00017   DC    A(S00000)
L00016   L     15,L00017
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00010   DS    0H
         MVC   T00009(4),C00018
         LA    1,P00019
         L     15,C00020
         BALR  14,15
         LA    1,P00021
         L     15,C00022
         BALR  14,15
         LA    1,P00023
         L     15,C00024
         BALR  14,15
         L     14,C00025
         LE    0,0(,14)
         STE   0,S00000+224
         LE    0,S00000+224
         STE   0,P00026+0
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         L     15,C00028
         BALR  14,15
         LA    15,5
         ST    15,T00007
         LA    1,P00029
         L     15,C00030
         BALR  14,15
         LA    1,P00031
         L     15,C00022
         BALR  14,15
         LA    1,P00032
         L     15,C00024
         BALR  14,15
         L     14,C00033
         L     3,0(,14)
         LR    0,3
         ST    0,P00034+0
         LA    1,P00034
         L     15,C00035
         BALR  14,15
         L     15,C00028
         BALR  14,15
         LH    15,C00036
         ST    15,T00008
         LA    1,P00037
         L     15,C00030
         BALR  14,15
         LA    1,P00031
         L     15,C00022
         BALR  14,15
         LA    1,P00038
         L     15,C00024
         BALR  14,15
         L     14,C00033
         L     3,0(,14)
         LR    0,3
         ST    0,P00034+0
         LA    1,P00034
         L     15,C00035
         BALR  14,15
         L     15,C00028
         BALR  14,15
         LA    1,P00031
         L     15,C00022
         BALR  14,15
         LA    1,P00039
         L     15,C00024
         BALR  14,15
         LE    0,C00041
         STE   0,P00040+0
         LA    1,P00040
         L     15,C00042
         BALR  14,15
         LDR   2,0
         STE   2,S00000+88
         LD    2,S00000+88
         LTDR  2,2
         LPDR  2,2
         AW    2,C00043
         STD   2,S00000+168
         L     3,S00000+172
         LTDR  0,0
         BC    10,L00044
         LCR   3,3
L00044   DS    0H
         LR    0,3
         ST    0,P00034+0
         LA    1,P00034
         L     15,C00035
         BALR  14,15
         L     15,C00028
         BALR  14,15
L00011   DS    0H
L00012   DS    0H
         LA    1,P00045
         L     15,C00046
         BALR  14,15
         B     L00014
L00013   DS    0H
L00014   DS    0H
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
T00007   DS    XL4
         DS    XL4
T00008   DS    XL4
         DS    XL4
T00009   DS    XL28
         DS    XL4
         DS    1D
P00019   DC    V(FS335)
         DC    XL1'80',AL3(T00009)
P00021   DC    F'6'
         DC    A(Q00001)
P00023   DC    A(Q00002)
         DC    F'4'
P00026   DC    A(0)
P00029   DC    V(FF330)
         DC    XL1'80',AL3(T00007)
P00031   DC    F'6'
         DC    A(Q00003)
P00032   DC    A(Q00004)
         DC    F'4'
P00034   DC    A(0)
P00037   DC    V(I#IABS)
         DC    XL1'80',AL3(T00008)
P00038   DC    A(Q00005)
         DC    F'4'
P00039   DC    A(Q00006)
         DC    F'4'
P00040   DC    A(0)
         DC    F'0'
P00045   DC    F'0'
         DS    XL4
C00043   DC    X'4E00000000000000'
C00018   DC    X'41380000'
C00020   DC    V(FS334)
C00022   DC    V(F77WRBEG)
C00024   DC    V(F77WRA)
C00025   DC    A(BLK1+4)
C00027   DC    V(F77WRR)
C00028   DC    V(F77WREND)
C00030   DC    V(FS333)
C00033   DC    A(BLK1)
C00035   DC    V(F77WRI)
C00041   DC    X'4129999A'
C00042   DC    V(F77DNINT)
C00046   DC    V(EXIT)
C00036   DC    H'-7'
Q00001   DC    C'('' >'',A4,F8.3)'
Q00003   DC    C'('' >'',A4,I8)'
Q00002   DC    C'SUBR'
Q00004   DC    C'FUNC'
Q00005   DC    C'IABS'
Q00006   DC    C'NINT'
* FS334
FS334    CSECT
         USING *,15
         B     L00051
         DC    AL1(5),CL7'FS334'
L00051   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00052
L00053   DC    A(S00047)
L00052   L     15,L00053
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00047,13
         ST    1,S00047+72
L00048   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         LR    0,3
         ST    0,P00054+0
         OI    P00054+0,X'80'
         LA    1,P00054
         LR    15,4
         BALR  14,15
         LE    0,C00055
         AE    0,0(,3)
         L     14,C00056
         STE   0,0(,14)
         LA    0,0
         B     L00050
L00049   DS    0H
L00050   DS    0H
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
P00054   DC    XL1'80',AL3(0)
         DS    XL4
C00055   DC    X'41100000'
C00056   DC    A(BLK1+4)
* FS335
FS335    CSECT
         USING *,15
         B     L00061
         DC    AL1(5),CL7'FS335'
L00061   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00062
L00063   DC    A(S00057)
L00062   L     15,L00063
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00057,13
         ST    1,S00057+72
L00058   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         LE    0,C00064
         AE    0,0(,2)
         STE   0,0(,2)
         LA    0,0
         B     L00060
L00059   DS    0H
L00060   DS    0H
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
C00064   DC    X'41100000'
* FS333
FS333    CSECT
         USING *,15
         B     L00069
         DC    AL1(5),CL7'FS333'
L00069   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00070
L00071   DC    A(S00065)
L00070   L     15,L00071
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00065,13
         ST    1,S00065+72
L00066   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         LR    0,3
         ST    0,P00072+0
         OI    P00072+0,X'80'
         LA    1,P00072
         LR    15,4
         BALR  14,15
         LR    2,0
         A     2,C00073
         L     14,C00074
         ST    2,0(,14)
         LA    0,0
         B     L00068
L00067   DS    0H
L00068   DS    0H
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
P00072   DC    XL1'80',AL3(0)
         DS    XL4
C00073   DC    F'1'
C00074   DC    A(BLK1)
* FF330
FF330    CSECT
         USING *,15
         B     L00079
         DC    AL1(5),CL7'FF330'
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
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         A     2,C00082
         LR    0,2
         B     L00078
L00077   DS    0H
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
C00082   DC    F'1'
BLK1     CSECT
         DS    0D
         DS    XL8
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
