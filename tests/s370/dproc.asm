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
         L     0,C00020
         ST    0,P00019+0
         LA    0,T00009
         ST    0,P00019+4
         OI    P00019+4,X'80'
         LA    1,P00019
         L     15,C00021
         BALR  14,15
         LA    0,6
         ST    0,P00019+0
         L     0,C00022
         ST    0,P00019+4
         LA    1,P00019
         L     15,C00023
         BALR  14,15
         L     0,C00024
         ST    0,P00019+0
         LA    0,4
         ST    0,P00019+4
         LA    1,P00019
         L     15,C00025
         BALR  14,15
         L     14,C00026
         LE    0,0(,14)
         STE   0,S00000+224
         LE    0,S00000+224
         STE   0,P00019+0
         LA    1,P00019
         L     15,C00027
         BALR  14,15
         L     15,C00028
         BALR  14,15
         LA    15,5
         ST    15,T00007
         L     0,C00029
         ST    0,P00019+0
         LA    0,T00007
         ST    0,P00019+4
         OI    P00019+4,X'80'
         LA    1,P00019
         L     15,C00030
         BALR  14,15
         LA    0,6
         ST    0,P00019+0
         L     0,C00031
         ST    0,P00019+4
         LA    1,P00019
         L     15,C00023
         BALR  14,15
         L     0,C00032
         ST    0,P00019+0
         LA    0,4
         ST    0,P00019+4
         LA    1,P00019
         L     15,C00025
         BALR  14,15
         L     14,C00033
         L     3,0(,14)
         LR    0,3
         ST    0,P00019+0
         LA    1,P00019
         L     15,C00034
         BALR  14,15
         L     15,C00028
         BALR  14,15
         LH    15,C00035
         ST    15,T00008
         L     0,C00036
         ST    0,P00019+0
         LA    0,T00008
         ST    0,P00019+4
         OI    P00019+4,X'80'
         LA    1,P00019
         L     15,C00030
         BALR  14,15
         LA    0,6
         ST    0,P00019+0
         L     0,C00031
         ST    0,P00019+4
         LA    1,P00019
         L     15,C00023
         BALR  14,15
         L     0,C00037
         ST    0,P00019+0
         LA    0,4
         ST    0,P00019+4
         LA    1,P00019
         L     15,C00025
         BALR  14,15
         L     14,C00033
         L     3,0(,14)
         LR    0,3
         ST    0,P00019+0
         LA    1,P00019
         L     15,C00034
         BALR  14,15
         L     15,C00028
         BALR  14,15
         LA    0,6
         ST    0,P00019+0
         L     0,C00031
         ST    0,P00019+4
         LA    1,P00019
         L     15,C00023
         BALR  14,15
         L     0,C00038
         ST    0,P00019+0
         LA    0,4
         ST    0,P00019+4
         LA    1,P00019
         L     15,C00025
         BALR  14,15
         LE    0,C00039
         STE   0,P00019+0
         XC    P00019+4(4),P00019+4
         LA    1,P00019
         L     15,C00040
         BALR  14,15
         LDR   2,0
         STE   2,S00000+88
         LD    2,S00000+88
         LTDR  2,2
         LPDR  2,2
         AW    2,C00041
         STD   2,S00000+168
         L     3,S00000+172
         LTDR  0,0
         BC    10,L00042
         LCR   3,3
L00042   DS    0H
         LR    0,3
         ST    0,P00019+0
         LA    1,P00019
         L     15,C00034
         BALR  14,15
         L     15,C00028
         BALR  14,15
L00011   DS    0H
L00012   DS    0H
         LA    0,0
         ST    0,P00019+0
         LA    1,P00019
         L     15,C00043
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
P00019   DS    2F
C00041   DC    X'4E00000000000000'
C00018   DC    X'41380000'
C00020   DC    V(FS335)
C00021   DC    V(FS334)
C00022   DC    A(Q00001)
C00023   DC    V(F77WRBEG)
C00024   DC    A(Q00002)
C00025   DC    V(F77WRA)
C00026   DC    A(BLK1+4)
C00027   DC    V(F77WRR)
C00028   DC    V(F77WREND)
C00029   DC    V(FF330)
C00030   DC    V(FS333)
C00031   DC    A(Q00003)
C00032   DC    A(Q00004)
C00033   DC    A(BLK1)
C00034   DC    V(F77WRI)
C00036   DC    V(I#IABS)
C00037   DC    A(Q00005)
C00038   DC    A(Q00006)
C00039   DC    X'4129999A'
C00040   DC    V(F77DNINT)
C00043   DC    V(EXIT)
C00035   DC    H'-7'
Q00001   DC    C'('' >'',A4,F8.3)'
Q00003   DC    C'('' >'',A4,I8)'
Q00002   DC    C'SUBR'
Q00004   DC    C'FUNC'
Q00005   DC    C'IABS'
Q00006   DC    C'NINT'
* FS334
FS334    CSECT
         USING *,15
         B     L00048
         DC    AL1(5),CL7'FS334'
L00048   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00049
L00050   DC    A(S00044)
L00049   L     15,L00050
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00044,13
         ST    1,S00044+72
L00045   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         LR    0,3
         ST    0,P00051+0
         OI    P00051+0,X'80'
         LA    1,P00051
         LR    15,4
         BALR  14,15
         LE    0,C00052
         AE    0,0(,3)
         L     14,C00053
         STE   0,0(,14)
         LA    0,0
         B     L00047
L00046   DS    0H
L00047   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00044   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00051   DS    1F
         DS    XL4
C00052   DC    X'41100000'
C00053   DC    A(BLK1+4)
* FS335
FS335    CSECT
         USING *,15
         B     L00058
         DC    AL1(5),CL7'FS335'
L00058   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00059
L00060   DC    A(S00054)
L00059   L     15,L00060
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00054,13
         ST    1,S00054+72
L00055   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         LE    0,C00061
         AE    0,0(,2)
         STE   0,0(,2)
         LA    0,0
         B     L00057
L00056   DS    0H
L00057   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00054   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00061   DC    X'41100000'
* FS333
FS333    CSECT
         USING *,15
         B     L00066
         DC    AL1(5),CL7'FS333'
L00066   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00067
L00068   DC    A(S00062)
L00067   L     15,L00068
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00062,13
         ST    1,S00062+72
L00063   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         LR    0,3
         ST    0,P00069+0
         OI    P00069+0,X'80'
         LA    1,P00069
         LR    15,4
         BALR  14,15
         LR    2,0
         A     2,C00070
         L     14,C00071
         ST    2,0(,14)
         LA    0,0
         B     L00065
L00064   DS    0H
L00065   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00062   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00069   DS    1F
         DS    XL4
C00070   DC    F'1'
C00071   DC    A(BLK1)
* FF330
FF330    CSECT
         USING *,15
         B     L00076
         DC    AL1(5),CL7'FF330'
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
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         A     2,C00079
         LR    0,2
         B     L00075
L00074   DS    0H
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
C00079   DC    F'1'
BLK1     CSECT
         DS    0D
         DS    XL8
         END
