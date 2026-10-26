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
L00002   DS    0H
         L     2,C00028
         L     3,C00030
         LE    2,C00031
L00004   DS    0H
         LR    11,2
         AH    11,C00032
         LE    6,C00033
         LCER  6,6
         LR    10,2
         AH    10,C00032
         LR    9,3
         AH    9,C00032
         LER   4,2
         LCER  4,4
         LR    8,3
         AH    8,C00032
         LA    6,4
         LA    7,16
         LA    4,4
L00005   DS    0H
         LE    0,0(4,11)
         CER   0,6
         BC    11,L00008
L00007   DS    0H
         LR    5,2
         AH    5,C00032
         AR    5,4
         LE    0,C00033
         LCER  0,0
         STE   0,0(,5)
L00008   DS    0H
         LE    0,C00033
         CE    0,0(4,10)
         BC    11,L00010
L00009   DS    0H
         LR    5,2
         AH    5,C00032
         AR    5,4
         MVC   0(4,5),C00033
L00010   DS    0H
         LE    0,0(4,9)
         CER   0,4
         BC    11,L00012
L00011   DS    0H
         LR    5,3
         AH    5,C00032
         AR    5,4
         LER   0,2
         LCER  0,0
         STE   0,0(,5)
L00012   DS    0H
         CE    2,0(4,8)
         BC    11,L00014
L00013   DS    0H
         LR    5,3
         AH    5,C00032
         AR    5,4
         STE   2,0(,5)
L00014   DS    0H
L00015   DS    0H
         BXLE  4,6,L00005
L00006   DS    0H
L00003   DS    0H
         LA    1,P00034
         L     15,C00035
         BALR  14,15
         AH    2,C00032
         LA    4,4
         LA    5,4
L00016   DS    0H
         C     5,C00036
         BC    2,L00017
L00018   DS    0H
         AH    3,C00032
         LA    2,4
         LA    4,4
L00019   DS    0H
         C     4,C00036
         BC    2,L00020
L00021   DS    0H
         L     15,C00037
         BALR  14,15
L00022   DS    0H
         B     L00023
L00017   DS    0H
         LE    0,0(4,2)
         STE   0,S00000+176
         LE    0,S00000+176
         STE   0,P00038+0
         LA    1,P00038
         L     15,C00039
         BALR  14,15
         AH    5,C00040
         A     4,C00041
         B     L00016
L00020   DS    0H
         LE    0,0(2,3)
         STE   0,S00000+176
         LE    0,S00000+176
         STE   0,P00038+0
         LA    1,P00038
         L     15,C00039
         BALR  14,15
         AH    4,C00040
         A     2,C00041
         B     L00019
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
         DS    1D
P00034   DC    F'6'
         DC    A(Q00001)
P00038   DC    A(0)
         DS    XL4
C00028   DC    A(G00027)
C00030   DC    A(G00029)
C00031   DC    X'41100000'
C00033   DC    X'41200000'
C00035   DC    V(F77WRBEG)
C00036   DC    F'0'
C00037   DC    V(F77WREND)
C00039   DC    V(F77WRR)
C00041   DC    F'4'
C00032   DC    H'-4'
C00040   DC    H'-1'
Q00001   DC    C'(1X,''>MVCIDX'',8F6.2)'
* CLIP
CLIP     CSECT
         USING *,15
         B     L00057
         DC    AL1(4),CL7'CLIP'
L00057   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00058
L00059   DC    A(S00042)
L00058   L     15,L00059
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00042,13
         ST    1,S00042+72
L00043   DS    0H
         L     2,0(,1)
         L     5,4(,1)
         L     4,8(,1)
         L     7,12(,1)
         L     6,16(,1)
         LA    6,0(,6)
         L     3,0(,2)
         S     3,C00060
         A     3,C00060
L00044   DS    0H
         AH    5,C00061
         LE    0,0(,7)
         STE   0,S00042+176
         LE    0,S00042+176
         LCER  0,0
         STE   0,S00042+184
         LE    4,0(,7)
         AH    4,C00061
         LE    0,0(,6)
         LCER  0,0
         LE    6,0(,6)
         LA    8,4
         LR    2,3
         SLL   2,2
         LA    9,0
         AR    9,2
         C     3,C00062
         BC    2,L00063
         B     L00046
L00063   DS    0H
         LA    2,4
         B     L00045
L00046   DS    0H
         LA    0,0
         B     L00056
L00045   DS    0H
         LE    2,0(2,5)
         CE    2,S00042+184
         BC    11,L00048
L00047   DS    0H
         LE    2,0(,7)
         STE   2,S00042+176
         LE    2,S00042+176
         LCER  2,2
         STE   2,S00042+192
         LA    14,0(2,5)
         MVC   0(4,14),S00042+192
L00048   DS    0H
         CE    4,0(2,5)
         BC    11,L00050
L00049   DS    0H
         LE    2,0(,7)
         STE   2,S00042+176
         LA    14,0(2,5)
         MVC   0(4,14),S00042+176
L00050   DS    0H
         LE    2,0(2,4)
         CER   2,0
         BC    11,L00052
L00051   DS    0H
         LE    2,0(,6)
         STE   2,S00042+176
         LE    2,S00042+176
         LCER  2,2
         STE   2,S00042+192
         LA    14,0(2,4)
         MVC   0(4,14),S00042+192
L00052   DS    0H
         CE    6,0(2,4)
         BC    11,L00054
L00053   DS    0H
         LE    2,0(,6)
         STE   2,S00042+176
         LA    14,0(2,4)
         MVC   0(4,14),S00042+176
L00054   DS    0H
L00055   DS    0H
         BXLE  2,8,L00045
         B     L00046
L00056   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00042   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
         DS    3D
C00060   DC    F'1'
C00062   DC    F'0'
C00061   DC    H'-4'
G00027   CSECT
         DS    0D
         DC    X'C1900000C08000004080000041900000'
G00029   CSECT
         DS    0D
         DC    X'4190000040400000C0400000C1900000'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
