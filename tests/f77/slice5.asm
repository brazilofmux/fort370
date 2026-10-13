* main
F77MAIN  CSECT
         USING *,15
         B     L00055
         DC    AL1(7),CL7'F77MAIN'
L00055   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00056
L00057   DC    A(S00000)
L00056   L     15,L00057
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00006   DS    0H
L00007   DS    0H
         LA    6,4
         LA    7,40
         LA    2,4
         LA    3,1
L00008   DS    0H
         LR    1,3
         MR    0,3
         LR    4,1
         ST    4,T00002-4(2)
L00010   DS    0H
         A     3,C00058
         BXLE  2,6,L00008
L00009   DS    0H
         L     2,T00002
         C     2,C00058
         BC    7,L00011
L00012   DS    0H
         L     2,T00002+36
         C     2,C00059
         BC    7,L00013
L00014   DS    0H
L00015   DS    0H
         LA    4,4
         LA    5,40
         LA    3,4
         LA    2,0
L00016   DS    0H
         A     2,T00002-4(3)
L00018   DS    0H
         BXLE  3,4,L00016
L00017   DS    0H
         C     2,C00060
         BC    7,L00019
L00020   DS    0H
L00021   DS    0H
         LA    10,10
         LA    11,40
         LA    2,10
         LA    3,12
L00022   DS    0H
L00024   DS    0H
         LA    7,T00004-16
         LA    8,4
         AR    7,3
         LA    9,12
         LA    4,4
         LA    5,1
L00025   DS    0H
         LR    6,5
         AR    6,2
         ST    6,0(4,7)
L00027   DS    0H
         A     5,C00058
         BXLE  4,8,L00025
L00026   DS    0H
L00028   DS    0H
         A     3,C00061
         BXLE  2,10,L00022
L00023   DS    0H
         L     2,T00004
         C     2,C00062
         BC    7,L00029
L00030   DS    0H
         L     2,T00004+44
         C     2,C00063
         BC    7,L00031
L00032   DS    0H
         L     2,T00004+28
         C     2,C00064
         BC    7,L00033
L00034   DS    0H
L00035   DS    0H
         LA    4,4
         LA    5,36
         LA    2,0
         LA    3,0
L00036   DS    0H
         LR    0,3
         X     0,C00065
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00066
         LER   0,0
         STE   0,T00003(2)
L00038   DS    0H
         A     3,C00058
         BXLE  2,4,L00036
L00037   DS    0H
         LE    0,C00067
         CE    0,T00003
         LA    3,1
         BC    8,L00068
         SR    3,3
L00068   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00069
         SR    2,2
L00069   DS    0H
         LTR   2,2
         BC    7,L00039
L00040   DS    0H
         LE    0,C00070
         CE    0,T00003+36
         LA    3,1
         BC    8,L00071
         SR    3,3
L00071   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00072
         SR    2,2
L00072   DS    0H
         LTR   2,2
         BC    7,L00041
L00042   DS    0H
L00043   DS    0H
         LD    2,C00073
         LA    4,8
         LA    5,40
         LA    2,8
         LA    3,1
L00044   DS    0H
         LR    0,3
         X     0,C00065
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00066
         MDR   0,2
         STD   0,T00005-8(2)
L00046   DS    0H
         A     3,C00058
         BXLE  2,4,L00044
L00045   DS    0H
         LD    0,C00073
         CD    0,T00005
         LA    3,1
         BC    8,L00074
         SR    3,3
L00074   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00075
         SR    2,2
L00075   DS    0H
         LTR   2,2
         BC    7,L00047
L00048   DS    0H
         LD    0,C00076
         CD    0,T00005+32
         LA    3,1
         BC    8,L00077
         SR    3,3
L00077   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00078
         SR    2,2
L00078   DS    0H
         LTR   2,2
         BC    7,L00049
L00050   DS    0H
         LA    15,7
         ST    15,T00001
         LA    15,9
         ST    15,T00001+12
L00052   DS    0H
         LA    0,0
         ST    0,P00079+0
         LA    1,P00079
         L     15,C00080
         BALR  14,15
         B     L00054
L00011   DS    0H
         LA    0,61
         ST    0,P00079+0
         LA    1,P00079
         L     15,C00080
         BALR  14,15
         B     L00054
L00013   DS    0H
         LA    0,62
         ST    0,P00079+0
         LA    1,P00079
         L     15,C00080
         BALR  14,15
         B     L00054
L00019   DS    0H
         LA    0,63
         ST    0,P00079+0
         LA    1,P00079
         L     15,C00080
         BALR  14,15
         B     L00054
L00029   DS    0H
         LA    0,64
         ST    0,P00079+0
         LA    1,P00079
         L     15,C00080
         BALR  14,15
         B     L00054
L00031   DS    0H
         LA    0,65
         ST    0,P00079+0
         LA    1,P00079
         L     15,C00080
         BALR  14,15
         B     L00054
L00033   DS    0H
         LA    0,66
         ST    0,P00079+0
         LA    1,P00079
         L     15,C00080
         BALR  14,15
         B     L00054
L00039   DS    0H
         LA    0,67
         ST    0,P00079+0
         LA    1,P00079
         L     15,C00080
         BALR  14,15
         B     L00054
L00041   DS    0H
         LA    0,68
         ST    0,P00079+0
         LA    1,P00079
         L     15,C00080
         BALR  14,15
         B     L00054
L00047   DS    0H
         LA    0,69
         ST    0,P00079+0
         LA    1,P00079
         L     15,C00080
         BALR  14,15
         B     L00054
L00049   DS    0H
         LA    0,70
         ST    0,P00079+0
         LA    1,P00079
         L     15,C00080
         BALR  14,15
         B     L00054
L00051   DS    0H
L00053   DS    0H
L00054   DS    0H
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
T00001   DS    XL36
         DS    XL4
T00002   DS    XL44
         DS    XL4
T00003   DS    XL44
         DS    XL4
T00004   DS    XL52
         DS    XL4
T00005   DS    XL68
         DS    XL4
P00079   DS    1F
         DS    XL4
C00066   DC    X'4E00000080000000'
C00073   DC    X'4118000000000000'
C00076   DC    X'4178000000000000'
C00058   DC    F'1'
C00059   DC    F'100'
C00060   DC    F'385'
C00061   DC    F'12'
C00062   DC    F'11'
C00063   DC    F'43'
C00064   DC    F'32'
C00065   DC    F'-2147483648'
C00067   DC    X'00000000'
C00070   DC    X'41900000'
C00080   DC    V(EXIT)
         END
