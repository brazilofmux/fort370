* main
F77MAIN  CSECT
         USING *,15
         B     L00034
         DC    AL1(7),CL7'F77MAIN'
L00034   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00035
L00036   DC    A(S00000)
L00035   L     15,L00036
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00005   DS    0H
         LD    0,C00037
         DD    0,C00038
         MD    0,C00038
         SD    0,C00037
         LPDR  0,0
         LD    2,C00039
         CDR   2,0
         BC    4,L00006
L00007   DS    0H
         LE    0,C00040
         CE    0,C00041
         BC    4,L00008
L00009   DS    0H
         LE    0,C00040
L00010   DS    0H
         LDR   2,0
         STE   2,S00000+88
         LD    2,S00000+88
         LTDR  2,2
         LPDR  2,2
         AW    2,C00042
         STD   2,S00000+168
         L     2,S00000+172
         LTDR  0,0
         BC    10,L00043
         LCR   2,2
L00043   DS    0H
         LR    0,2
         X     0,C00044
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00045
         LER   0,0
         CE    0,C00046
         LA    3,1
         BC    8,L00047
         SR    3,3
L00047   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00048
         SR    2,2
L00048   DS    0H
         LTR   2,2
         BC    7,L00011
L00012   DS    0H
         LA    0,9
         X     0,C00044
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00045
         LER   0,0
         CE    0,C00049
         LA    3,1
         BC    8,L00050
         SR    3,3
L00050   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00051
         SR    2,2
L00051   DS    0H
         LTR   2,2
         BC    7,L00013
L00014   DS    0H
         LE    2,C00052
         LE    0,C00053
         SE    0,C00046
         AER   0,2
         DER   0,2
         LDR   4,0
         STE   4,S00000+88
         LD    4,S00000+88
         LTDR  4,4
         LPDR  4,4
         AW    4,C00042
         STD   4,S00000+168
         L     3,S00000+172
         LTDR  0,0
         BC    10,L00054
         LCR   3,3
L00054   DS    0H
L00015   DS    0H
         LH    4,C00055
         LA    5,0
         C     3,C00056
         BC    2,L00057
         LA    2,0
         B     L00017
L00057   DS    0H
         LE    0,C00046
         LA    2,0
         B     L00016
L00017   DS    0H
         C     2,C00058
         BC    7,L00019
L00020   DS    0H
L00021   DS    0H
         LA    4,4
         LA    5,16
         LA    2,4
         LA    3,1
L00022   DS    0H
         ST    3,T00004-4(2)
L00024   DS    0H
         A     3,C00059
         BXLE  2,4,L00022
L00023   DS    0H
         LA    1,P00060
         L     15,C00061
         BALR  14,15
         LA    2,4
         LA    3,4
L00025   DS    0H
         C     3,C00056
         BC    2,L00026
L00027   DS    0H
         L     15,C00062
         BALR  14,15
L00028   DS    0H
         LA    1,P00063
         L     15,C00061
         BALR  14,15
         LA    1,P00064
         L     15,C00065
         BALR  14,15
         LA    1,P00066
         L     15,C00065
         BALR  14,15
         L     15,C00062
         BALR  14,15
L00029   DS    0H
         LA    1,P00067
         L     15,C00061
         BALR  14,15
         LE    0,C00069
         STE   0,P00068+0
         LA    1,P00068
         L     15,C00070
         BALR  14,15
         L     15,C00062
         BALR  14,15
L00030   DS    0H
         LA    1,P00066
         L     15,C00071
         BALR  14,15
         B     L00033
L00006   DS    0H
         LA    1,P00072
         L     15,C00071
         BALR  14,15
         B     L00033
L00008   DS    0H
         LE    0,C00041
         B     L00010
L00011   DS    0H
         LA    1,P00073
         L     15,C00071
         BALR  14,15
         B     L00033
L00013   DS    0H
         LA    1,P00074
         L     15,C00071
         BALR  14,15
         B     L00033
L00016   DS    0H
         A     2,C00059
L00018   DS    0H
         AER   0,2
         BXH   3,4,L00016
         B     L00017
L00019   DS    0H
         LA    1,P00075
         L     15,C00071
         BALR  14,15
         B     L00033
L00026   DS    0H
         L     5,T00004-4(2)
         LR    0,5
         ST    0,P00076+0
         LA    1,P00076
         L     15,C00077
         BALR  14,15
         AH    3,C00055
         A     2,C00078
         B     L00025
L00031   DS    0H
L00032   DS    0H
L00033   DS    0H
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
T00004   DS    XL80
P00060   DC    F'6'
         DC    A(Q00001)
P00063   DC    F'6'
         DC    A(Q00002)
P00064   DC    F'1'
P00066   DC    F'0'
P00067   DC    F'6'
         DC    A(Q00003)
P00068   DC    A(0)
P00072   DC    F'151'
P00073   DC    F'152'
P00074   DC    F'153'
P00075   DC    F'154'
P00076   DC    A(0)
C00037   DC    X'4110000000000000'
C00038   DC    X'4130000000000000'
C00039   DC    X'37119799812DEA11'
C00042   DC    X'4E00000000000000'
C00045   DC    X'4E00000080000000'
C00040   DC    X'411CCCCD'
C00041   DC    X'41133333'
C00044   DC    F'-2147483648'
C00046   DC    X'41100000'
C00049   DC    X'41900000'
C00052   DC    X'40800000'
C00053   DC    X'41200000'
C00056   DC    F'0'
C00058   DC    F'3'
C00059   DC    F'1'
C00061   DC    V(F77WRBEG)
C00062   DC    V(F77WREND)
C00065   DC    V(F77WRL)
C00069   DC    X'41C80000'
C00070   DC    V(F77WRR)
C00071   DC    V(EXIT)
C00077   DC    V(F77WRI)
C00078   DC    F'4'
C00055   DC    H'-1'
Q00001   DC    C'(4I2)'
Q00002   DC    C'(2L2)'
Q00003   DC    C'(G12.4)'
* S
S        CSECT
         USING *,15
         B     L00083
         DC    AL1(1),CL7'S'
L00083   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00084
L00085   DC    A(S00079)
L00084   L     15,L00085
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00079,13
         ST    1,S00079+72
L00080   DS    0H
         LA    1,P00086
         L     15,C00087
         BALR  14,15
         LA    0,0
         B     L00082
L00081   DS    0H
L00082   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00079   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00086   DC    F'0'
         DS    XL4
C00087   DC    V(EXIT)
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
