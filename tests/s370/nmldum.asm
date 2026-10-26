* main
F77MAIN  CSECT
         USING *,15
         B     L00010
         DC    AL1(7),CL7'F77MAIN'
L00010   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00011
L00012   DC    A(S00000)
L00011   L     15,L00012
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00004   DS    0H
L00005   DS    0H
         LE    2,C00013
         LA    4,4
         LA    5,24
         LA    2,4
         LA    3,1
L00006   DS    0H
L00008   DS    0H
         LR    0,3
         X     0,C00014
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00015
         LER   0,0
         MER   0,2
         STE   0,T00003-4(2)
         A     3,C00016
         BXLE  2,4,L00006
L00007   DS    0H
         LA    15,6
         ST    15,T00001
         LH    15,C00017
         ST    15,T00002
         LA    1,P00018
         L     15,C00019
         BALR  14,15
L00009   DS    0H
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
T00001   DS    XL8
T00002   DS    XL12
         DS    XL4
T00003   DS    XL28
         DS    XL4
P00018   DC    A(T00003)
         DC    A(T00001)
         DC    XL1'80',AL3(T00002)
         DS    XL4
C00015   DC    X'4E00000080000000'
C00013   DC    X'40800000'
C00014   DC    F'-2147483648'
C00016   DC    F'1'
C00019   DC    V(SHOW)
C00017   DC    H'-2'
* SHOW
SHOW     CSECT
         USING *,15
         B     L00043
         DC    AL1(4),CL7'SHOW'
L00043   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00044
L00045   DC    A(S00020)
L00044   L     15,L00045
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00020,13
         ST    1,S00020+72
L00032   DS    0H
         L     5,0(,1)
         L     6,4(,1)
         L     3,8(,1)
         LA    3,0(,3)
         L     2,0(,3)
         LR    4,2
         A     4,0(,6)
         S     4,C00046
         SR    4,2
         AH    4,C00047
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LR    0,6
         ST    0,P00050+12
         LA    1,P00050
         L     15,C00051
         BALR  14,15
         LR    0,2
         ST    0,P00052+0
         LR    0,4
         ST    0,P00052+4
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         LR    0,5
         ST    0,P00054+12
         LR    0,4
         ST    0,P00054+20
         LA    1,P00054
         L     15,C00051
         BALR  14,15
         L     15,C00055
         BALR  14,15
         LA    1,P00056
         L     15,C00057
         BALR  14,15
L00033   DS    0H
         LA    1,P00058
         L     15,C00059
         BALR  14,15
         LR    3,15
         C     3,C00046
         BC    8,L00035
L00034   DS    0H
         LA    1,P00060
         L     15,C00061
         BALR  14,15
         L     15,C00062
         BALR  14,15
         LA    1,P00063
         L     15,C00064
         BALR  14,15
         LA    1,P00060
         L     15,C00065
         BALR  14,15
         L     15,C00066
         BALR  14,15
         B     L00033
L00035   DS    0H
         LA    1,P00067
         L     15,C00064
         BALR  14,15
         LA    1,P00068
         L     15,C00065
         BALR  14,15
         L     15,C00066
         BALR  14,15
         LA    1,P00069
         L     15,C00057
         BALR  14,15
         LA    1,P00070
         L     15,C00049
         BALR  14,15
         LR    0,6
         ST    0,P00071+12
         LA    1,P00071
         L     15,C00051
         BALR  14,15
         LR    0,2
         ST    0,P00052+0
         LR    0,4
         ST    0,P00052+4
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         LR    0,5
         ST    0,P00072+12
         LR    0,4
         ST    0,P00072+20
         LA    1,P00072
         L     15,C00051
         BALR  14,15
         L     15,C00055
         BALR  14,15
         LA    1,P00073
         L     15,C00064
         BALR  14,15
         L     3,0(,6)
         LR    0,3
         ST    0,P00074+0
         LA    1,P00074
         L     15,C00075
         BALR  14,15
         LA    2,0
         LA    3,0
L00036   DS    0H
         CR    3,4
         BC    4,L00037
L00038   DS    0H
         L     15,C00066
         BALR  14,15
L00039   DS    0H
L00040   DS    0H
L00041   DS    0H
         LA    0,0
         B     L00042
L00037   DS    0H
         LE    0,0(2,5)
         STE   0,S00020+264
         LE    0,S00020+264
         STE   0,P00076+0
         LA    1,P00076
         L     15,C00077
         BALR  14,15
         AH    3,C00047
         A     2,C00078
         B     L00036
L00042   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00020   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00031   DS    XL84
         DS    XL4
         DS    1D
P00048   DC    F'31'
         DC    A(Q00021)
         DC    F'3'
         DC    F'0'
         DC    F'0'
P00050   DC    A(Q00022)
         DC    F'1'
         DC    F'1'
         DC    A(0)
         DC    F'4'
         DC    F'1'
P00052   DC    A(0)
         DC    A(0)
P00054   DC    A(Q00023)
         DC    F'1'
         DC    F'2'
         DC    A(0)
         DC    F'4'
         DC    A(0)
P00056   DC    F'31'
P00058   DC    F'31'
         DC    A(Q00024)
         DC    F'1'
P00060   DC    A(T00031)
         DC    F'80'
P00063   DC    F'6'
         DC    A(Q00030)
P00067   DC    F'9'
         DC    A(Q00024)
P00068   DC    A(Q00025)
         DC    F'27'
P00069   DC    F'9'
P00070   DC    F'9'
         DC    A(Q00026)
         DC    F'3'
         DC    F'1'
         DC    F'0'
P00071   DC    A(Q00027)
         DC    F'1'
         DC    F'1'
         DC    A(0)
         DC    F'4'
         DC    F'1'
P00072   DC    A(Q00028)
         DC    F'1'
         DC    F'2'
         DC    A(0)
         DC    F'4'
         DC    A(0)
P00073   DC    F'6'
         DC    A(Q00029)
P00074   DC    A(0)
P00076   DC    A(0)
         DS    XL4
C00046   DC    F'1'
C00049   DC    V(F77NMLBG)
C00051   DC    V(F77NMLIT)
C00053   DC    V(F77NMLDM)
C00055   DC    V(F77NMLEN)
C00057   DC    V(F77REWND)
C00059   DC    V(F77RDBEG)
C00061   DC    V(F77RDS)
C00062   DC    V(F77RDEND)
C00064   DC    V(F77WRBEG)
C00065   DC    V(F77WRA)
C00066   DC    V(F77WREND)
C00075   DC    V(F77WRI)
C00077   DC    V(F77WRR)
C00078   DC    F'4'
C00047   DC    H'1'
Q00024   DC    C'(A)'
Q00030   DC    C'('' >|'',A,''|'')'
Q00029   DC    C'('' >'',I3,6F6.2)'
Q00021   DC    C'ARR'
Q00022   DC    C'N'
Q00023   DC    C'A'
Q00025   DC    C' &&ARR A(0)=9.5, 2*7.25 &&END'
Q00026   DC    C'ARR'
Q00027   DC    C'N'
Q00028   DC    C'A'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
