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
L00001   DS    0H
         LD    0,C00037
         AD    0,C00038
         CD    0,C00039
         LA    3,1
         BC    8,L00040
         SR    3,3
L00040   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00041
         SR    2,2
L00041   DS    0H
         LTR   2,2
         BC    7,L00002
L00003   DS    0H
         LD    0,C00038
         SD    0,C00037
         CD    0,C00042
         LA    3,1
         BC    8,L00043
         SR    3,3
L00043   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00044
         SR    2,2
L00044   DS    0H
         LTR   2,2
         BC    7,L00004
L00005   DS    0H
         LD    0,C00037
         MD    0,C00038
         CD    0,C00045
         LA    3,1
         BC    8,L00046
         SR    3,3
L00046   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00047
         SR    2,2
L00047   DS    0H
         LTR   2,2
         BC    7,L00006
L00007   DS    0H
         LD    0,C00038
         DD    0,C00037
         CD    0,C00048
         BC    12,L00008
L00009   DS    0H
         LD    2,C00049
         CDR   2,0
         BC    12,L00010
L00011   DS    0H
         LD    2,C00037
         LCDR  2,2
         LD    0,C00037
         LCDR  0,0
         CDR   2,0
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
         BC    7,L00012
L00013   DS    0H
         LD    0,C00037
         CD    0,C00038
         LA    3,1
         BC    4,L00052
         SR    3,3
L00052   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00053
         SR    2,2
L00053   DS    0H
         LTR   2,2
         BC    7,L00014
L00015   DS    0H
         LD    0,C00038
         CD    0,C00037
         BC    4,L00016
L00017   DS    0H
         LD    0,C00037
         CD    0,C00037
         LA    3,1
         BC    12,L00054
         SR    3,3
L00054   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00055
         SR    2,2
L00055   DS    0H
         LTR   2,2
         BC    7,L00018
L00019   DS    0H
         LA    0,3
         X     0,C00056
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00057
         CD    0,C00058
         LA    3,1
         BC    8,L00059
         SR    3,3
L00059   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00060
         SR    2,2
L00060   DS    0H
         LTR   2,2
         BC    7,L00020
L00021   DS    0H
         MVC   S00000+88(4),C00061
         LD    0,S00000+88
         CD    0,C00062
         LA    3,1
         BC    8,L00063
         SR    3,3
L00063   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00064
         SR    2,2
L00064   DS    0H
         LTR   2,2
         BC    7,L00022
L00023   DS    0H
         LD    0,C00065
         LTDR  0,0
         LPDR  0,0
         AW    0,C00066
         STD   0,S00000+168
         L     2,S00000+172
         LD    0,C00065
         LTDR  0,0
         BC    10,L00067
         LCR   2,2
L00067   DS    0H
         C     2,C00068
         BC    7,L00024
L00025   DS    0H
L00026   DS    0H
         LD    2,C00069
         LH    4,C00070
         LA    5,0
         LA    2,10
         LD    0,C00042
L00027   DS    0H
         MDR   0,2
L00029   DS    0H
         BXH   2,4,L00027
L00028   DS    0H
         CD    0,C00071
         LA    3,1
         BC    8,L00072
         SR    3,3
L00072   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00073
         SR    2,2
L00073   DS    0H
         LTR   2,2
         BC    7,L00030
L00031   DS    0H
         LA    0,0
         ST    0,P00074+0
         LA    1,P00074
         L     15,C00075
         BALR  14,15
         B     L00033
L00002   DS    0H
         LA    0,41
         ST    0,P00074+0
         LA    1,P00074
         L     15,C00075
         BALR  14,15
         B     L00033
L00004   DS    0H
         LA    0,42
         ST    0,P00074+0
         LA    1,P00074
         L     15,C00075
         BALR  14,15
         B     L00033
L00006   DS    0H
         LA    0,43
         ST    0,P00074+0
         LA    1,P00074
         L     15,C00075
         BALR  14,15
         B     L00033
L00008   DS    0H
         LA    0,44
         ST    0,P00074+0
         LA    1,P00074
         L     15,C00075
         BALR  14,15
         B     L00033
L00010   DS    0H
         LA    0,45
         ST    0,P00074+0
         LA    1,P00074
         L     15,C00075
         BALR  14,15
         B     L00033
L00012   DS    0H
         LA    0,46
         ST    0,P00074+0
         LA    1,P00074
         L     15,C00075
         BALR  14,15
         B     L00033
L00014   DS    0H
         LA    0,47
         ST    0,P00074+0
         LA    1,P00074
         L     15,C00075
         BALR  14,15
         B     L00033
L00016   DS    0H
         LA    0,48
         ST    0,P00074+0
         LA    1,P00074
         L     15,C00075
         BALR  14,15
         B     L00033
L00018   DS    0H
         LA    0,49
         ST    0,P00074+0
         LA    1,P00074
         L     15,C00075
         BALR  14,15
         B     L00033
L00020   DS    0H
         LA    0,50
         ST    0,P00074+0
         LA    1,P00074
         L     15,C00075
         BALR  14,15
         B     L00033
L00022   DS    0H
         LA    0,51
         ST    0,P00074+0
         LA    1,P00074
         L     15,C00075
         BALR  14,15
         B     L00033
L00024   DS    0H
         LA    0,52
         ST    0,P00074+0
         LA    1,P00074
         L     15,C00075
         BALR  14,15
         B     L00033
L00030   DS    0H
         LA    0,53
         ST    0,P00074+0
         LA    1,P00074
         L     15,C00075
         BALR  14,15
         B     L00033
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
P00074   DS    1F
         DS    XL4
C00037   DC    X'4118000000000000'
C00038   DC    X'4128000000000000'
C00039   DC    X'4140000000000000'
C00042   DC    X'4110000000000000'
C00045   DC    X'413C000000000000'
C00048   DC    X'411A8F5C28F5C28F'
C00049   DC    X'411AB851EB851EB8'
C00057   DC    X'4E00000080000000'
C00058   DC    X'4130000000000000'
C00062   DC    X'4080000000000000'
C00065   DC    X'417E666666666666'
C00066   DC    X'4E00000000000000'
C00069   DC    X'4120000000000000'
C00071   DC    X'4340000000000000'
C00056   DC    F'-2147483648'
C00061   DC    X'40800000'
C00068   DC    F'7'
C00075   DC    V(EXIT)
C00070   DC    H'-1'
         END
