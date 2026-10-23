* main
F77MAIN  CSECT
         USING *,15
         B     L00029
         DC    AL1(7),CL7'F77MAIN'
L00029   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00030
L00031   DC    A(S00000)
L00030   L     15,L00031
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00006   DS    0H
         LE    0,C00032
         LCER  0,0
         STE   0,S00000+248
         LE    0,S00000+248
         STE   0,P00033+0
         XC    P00033+4(4),P00033+4
         LA    1,P00033
         L     15,C00034
         BALR  14,15
         STE   0,T00004
         LE    0,C00035
         STE   0,P00033+0
         XC    P00033+4(4),P00033+4
         LA    1,P00033
         L     15,C00036
         BALR  14,15
         STE   0,T00004+4
         LE    0,C00037
         LCER  0,0
         STE   0,S00000+248
         LE    0,S00000+248
         STE   0,P00033+0
         XC    P00033+4(4),P00033+4
         LA    1,P00033
         L     15,C00036
         BALR  14,15
         STE   0,T00004+8
         LE    0,C00038
         STE   0,P00033+0
         XC    P00033+4(4),P00033+4
         LA    1,P00033
         L     15,C00039
         BALR  14,15
         STE   0,T00004+12
         LA    0,6
         ST    0,P00033+0
         L     0,C00040
         ST    0,P00033+4
         LA    1,P00033
         L     15,C00041
         BALR  14,15
         LA    2,4
         LA    3,4
L00007   DS    0H
         C     3,C00042
         BC    2,L00008
L00009   DS    0H
         L     15,C00043
         BALR  14,15
         LE    0,C00044
         STE   0,P00033+0
         XC    P00033+4(4),P00033+4
         LA    1,P00033
         L     15,C00045
         BALR  14,15
         STE   0,T00004
         LE    0,C00046
         LCER  0,0
         STE   0,S00000+248
         LE    0,S00000+248
         STE   0,P00033+0
         XC    P00033+4(4),P00033+4
         LA    1,P00033
         L     15,C00047
         BALR  14,15
         STE   0,T00004+4
         LE    0,C00048
         STE   0,P00033+0
         XC    P00033+4(4),P00033+4
         LA    1,P00033
         L     15,C00047
         BALR  14,15
         STE   0,T00004+8
         LE    0,C00049
         LCER  0,0
         STE   0,S00000+248
         LE    0,S00000+248
         STE   0,P00033+0
         XC    P00033+4(4),P00033+4
         LA    1,P00033
         L     15,C00050
         BALR  14,15
         STE   0,T00004+12
         LA    0,6
         ST    0,P00033+0
         L     0,C00040
         ST    0,P00033+4
         LA    1,P00033
         L     15,C00041
         BALR  14,15
         LA    2,4
         LA    3,4
L00010   DS    0H
         C     3,C00042
         BC    2,L00011
L00012   DS    0H
         L     15,C00043
         BALR  14,15
         LE    0,C00035
         STE   0,P00033+0
         XC    P00033+4(4),P00033+4
         LE    0,C00035
         STE   0,P00033+8
         XC    P00033+12(4),P00033+12
         LA    1,P00033
         L     15,C00051
         BALR  14,15
         STE   0,T00004
         LE    0,C00052
         LCER  0,0
         STE   0,S00000+248
         LE    0,S00000+248
         STE   0,P00033+0
         XC    P00033+4(4),P00033+4
         LA    1,P00033
         L     15,C00053
         BALR  14,15
         STE   0,T00004+4
         LE    0,C00054
         LCER  0,0
         STE   0,S00000+248
         LE    0,C00035
         STE   0,P00033+0
         XC    P00033+4(4),P00033+4
         LE    0,S00000+248
         STE   0,P00033+8
         XC    P00033+12(4),P00033+12
         LA    1,P00033
         L     15,C00055
         BALR  14,15
         STE   0,T00004+8
         LE    0,C00056
         LCER  0,0
         STE   0,S00000+248
         LE    0,C00057
         LCER  0,0
         STE   0,S00000+256
         LE    0,S00000+248
         STE   0,P00033+0
         XC    P00033+4(4),P00033+4
         LE    0,S00000+256
         STE   0,P00033+8
         XC    P00033+12(4),P00033+12
         LA    1,P00033
         L     15,C00055
         BALR  14,15
         STE   0,T00004+12
         LA    0,6
         ST    0,P00033+0
         L     0,C00040
         ST    0,P00033+4
         LA    1,P00033
         L     15,C00041
         BALR  14,15
         LA    2,4
         LA    3,4
L00013   DS    0H
         C     3,C00042
         BC    2,L00014
L00015   DS    0H
         L     15,C00043
         BALR  14,15
         LD    0,C00058
         LCDR  0,0
         STD   0,S00000+248
         LD    0,S00000+248
         STD   0,P00033+0
         LA    1,P00033
         L     15,C00059
         BALR  14,15
         STD   0,T00005
         LD    0,C00060
         STD   0,P00033+0
         LA    1,P00033
         L     15,C00061
         BALR  14,15
         STD   0,T00005+8
         LA    0,6
         ST    0,P00033+0
         L     0,C00062
         ST    0,P00033+4
         LA    1,P00033
         L     15,C00041
         BALR  14,15
         LA    2,8
         LA    3,2
L00016   DS    0H
         C     3,C00042
         BC    2,L00017
L00018   DS    0H
         L     15,C00043
         BALR  14,15
         LD    0,C00063
         LCDR  0,0
         STD   0,S00000+248
         LD    0,S00000+248
         STD   0,P00033+0
         LA    1,P00033
         L     15,C00064
         BALR  14,15
         STD   0,T00005
         LD    0,C00065
         LCDR  0,0
         STD   0,S00000+248
         LD    0,S00000+248
         STD   0,P00033+0
         LA    1,P00033
         L     15,C00066
         BALR  14,15
         STD   0,T00005+8
         LA    0,6
         ST    0,P00033+0
         L     0,C00062
         ST    0,P00033+4
         LA    1,P00033
         L     15,C00041
         BALR  14,15
         LA    2,8
         LA    3,2
L00019   DS    0H
         C     3,C00042
         BC    2,L00020
L00021   DS    0H
         L     15,C00043
         BALR  14,15
         LD    0,C00067
         STD   0,P00033+0
         LA    1,P00033
         L     15,C00068
         BALR  14,15
         STD   0,T00005
         LD    0,C00069
         STD   0,P00033+0
         LA    1,P00033
         L     15,C00070
         BALR  14,15
         STD   0,T00005+8
         LA    0,6
         ST    0,P00033+0
         L     0,C00062
         ST    0,P00033+4
         LA    1,P00033
         L     15,C00041
         BALR  14,15
         LA    2,8
         LA    3,2
L00022   DS    0H
         C     3,C00042
         BC    2,L00023
L00024   DS    0H
         L     15,C00043
         BALR  14,15
         LE    0,C00035
         STE   0,P00033+0
         LH    0,C00071
         ST    0,P00033+4
         LA    1,P00033
         L     15,C00072
         BALR  14,15
         STE   0,S00000+248
         LD    0,C00060
         STD   0,P00033+0
         LH    0,C00071
         ST    0,P00033+8
         LA    1,P00033
         L     15,C00073
         BALR  14,15
         STD   0,S00000+256
         LA    0,6
         ST    0,P00033+0
         L     0,C00074
         ST    0,P00033+4
         LA    1,P00033
         L     15,C00041
         BALR  14,15
         LE    0,S00000+248
         STE   0,P00033+0
         LA    1,P00033
         L     15,C00075
         BALR  14,15
         LD    0,S00000+256
         STD   0,P00033+0
         LA    1,P00033
         L     15,C00076
         BALR  14,15
         LA    0,0
         ST    0,P00033+0
         LH    0,C00071
         ST    0,P00033+4
         LA    1,P00033
         L     15,C00077
         BALR  14,15
         LR    3,15
         LR    0,3
         ST    0,P00033+0
         LA    1,P00033
         L     15,C00078
         BALR  14,15
         L     15,C00043
         BALR  14,15
L00025   DS    0H
L00026   DS    0H
L00027   DS    0H
         B     L00028
L00008   DS    0H
         LE    0,T00004-4(2)
         STE   0,S00000+248
         LE    0,S00000+248
         STE   0,P00033+0
         LA    1,P00033
         L     15,C00075
         BALR  14,15
         AH    3,C00079
         A     2,C00080
         B     L00007
L00011   DS    0H
         LE    0,T00004-4(2)
         STE   0,S00000+248
         LE    0,S00000+248
         STE   0,P00033+0
         LA    1,P00033
         L     15,C00075
         BALR  14,15
         AH    3,C00079
         A     2,C00080
         B     L00010
L00014   DS    0H
         LE    0,T00004-4(2)
         STE   0,S00000+248
         LE    0,S00000+248
         STE   0,P00033+0
         LA    1,P00033
         L     15,C00075
         BALR  14,15
         AH    3,C00079
         A     2,C00080
         B     L00013
L00017   DS    0H
         LD    0,T00005-8(2)
         STD   0,S00000+248
         LD    0,S00000+248
         STD   0,P00033+0
         LA    1,P00033
         L     15,C00076
         BALR  14,15
         AH    3,C00079
         A     2,C00081
         B     L00016
L00020   DS    0H
         LD    0,T00005-8(2)
         STD   0,S00000+248
         LD    0,S00000+248
         STD   0,P00033+0
         LA    1,P00033
         L     15,C00076
         BALR  14,15
         AH    3,C00079
         A     2,C00081
         B     L00019
L00023   DS    0H
         LD    0,T00005-8(2)
         STD   0,S00000+248
         LD    0,S00000+248
         STD   0,P00033+0
         LA    1,P00033
         L     15,C00076
         BALR  14,15
         AH    3,C00079
         A     2,C00081
         B     L00022
L00028   DS    0H
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
T00004   DS    XL28
         DS    XL4
T00005   DS    XL36
         DS    XL4
         DS    2D
P00033   DS    4F
C00058   DC    X'4164000000000000'
C00060   DC    X'0000000000000000'
C00063   DC    X'41A0000000000000'
C00065   DC    X'42B5000000000000'
C00067   DC    X'4F10A741A4627800'
C00069   DC    X'4120000000000000'
C00032   DC    X'41900000'
C00034   DC    V(SQRT)
C00035   DC    X'00000000'
C00036   DC    V(LOG)
C00037   DC    X'41200000'
C00038   DC    X'42B58000'
C00039   DC    V(EXP)
C00040   DC    A(Q00001)
C00041   DC    V(F77WRBEG)
C00042   DC    F'0'
C00043   DC    V(F77WREND)
C00044   DC    X'462625A0'
C00045   DC    V(COS)
C00046   DC    X'471C9C38'
C00047   DC    V(TAN)
C00048   DC    X'414B65F2'
C00049   DC    X'41140000'
C00050   DC    V(ASIN)
C00051   DC    V(ATAN2)
C00052   DC    X'42BE0000'
C00053   DC    V(COSH)
C00054   DC    X'41280000'
C00055   DC    V(POW)
C00056   DC    X'41400000'
C00057   DC    X'40800000'
C00059   DC    V(DSQRT)
C00061   DC    V(DLOG10)
C00062   DC    A(Q00002)
C00064   DC    V(DLOG)
C00066   DC    V(DSINH)
C00068   DC    V(DSIN)
C00070   DC    V(DACOS)
C00072   DC    V(F77RPOWI)
C00073   DC    V(F77DPOWI)
C00074   DC    A(Q00003)
C00075   DC    V(F77WRR)
C00076   DC    V(F77WRD)
C00077   DC    V(F77IPOW)
C00078   DC    V(F77WRI)
C00080   DC    F'4'
C00081   DC    F'8'
C00071   DC    H'-3'
C00079   DC    H'-1'
Q00001   DC    C'('' >R '',4E15.7)'
Q00002   DC    C'('' >D '',2D24.16)'
Q00003   DC    C'('' >P '',E15.7,D24.16,I12)'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
