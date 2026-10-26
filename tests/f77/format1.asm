* main
F77MAIN  CSECT
         USING *,15
         B     L00037
         DC    AL1(7),CL7'F77MAIN'
L00037   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00038
L00039   DC    A(S00000)
L00038   L     15,L00039
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00013   DS    0H
         LA    1,P00040
         L     15,C00041
         BALR  14,15
         L     15,C00042
         BALR  14,15
L00014   DS    0H
         LA    1,P00043
         L     15,C00041
         BALR  14,15
         LA    1,P00044
         L     15,C00045
         BALR  14,15
         LA    1,P00046
         L     15,C00045
         BALR  14,15
         L     15,C00042
         BALR  14,15
L00015   DS    0H
         LA    1,P00047
         L     15,C00041
         BALR  14,15
         LE    0,C00049
         STE   0,P00048+0
         LA    1,P00048
         L     15,C00050
         BALR  14,15
         L     15,C00042
         BALR  14,15
L00016   DS    0H
         LA    1,P00051
         L     15,C00041
         BALR  14,15
         LD    0,C00053
         STD   0,P00052+0
         LA    1,P00052
         L     15,C00054
         BALR  14,15
         L     15,C00042
         BALR  14,15
L00017   DS    0H
         LA    1,P00055
         L     15,C00041
         BALR  14,15
         LA    1,P00056
         L     15,C00045
         BALR  14,15
         LA    1,P00057
         L     15,C00045
         BALR  14,15
         LA    1,P00058
         L     15,C00045
         BALR  14,15
         LA    1,P00059
         L     15,C00045
         BALR  14,15
         LA    1,P00060
         L     15,C00045
         BALR  14,15
         LA    1,P00061
         L     15,C00045
         BALR  14,15
         L     15,C00042
         BALR  14,15
L00018   DS    0H
         LA    1,P00062
         L     15,C00041
         BALR  14,15
         LA    1,P00063
         L     15,C00045
         BALR  14,15
         LA    1,P00064
         L     15,C00045
         BALR  14,15
         L     15,C00042
         BALR  14,15
L00019   DS    0H
         LA    1,P00065
         L     15,C00041
         BALR  14,15
         LA    1,P00056
         L     15,C00045
         BALR  14,15
         LA    1,P00057
         L     15,C00045
         BALR  14,15
         LA    1,P00058
         L     15,C00045
         BALR  14,15
         LA    1,P00059
         L     15,C00045
         BALR  14,15
         L     15,C00042
         BALR  14,15
L00020   DS    0H
         LA    1,P00066
         L     15,C00041
         BALR  14,15
         LA    1,P00067
         L     15,C00045
         BALR  14,15
         L     15,C00042
         BALR  14,15
L00021   DS    0H
L00022   DS    0H
         LA    4,11
         LA    5,55
         LA    2,11
         LA    3,4
L00023   DS    0H
         ST    2,T00012-4(3)
L00025   DS    0H
         A     3,C00068
         BXLE  2,4,L00023
L00024   DS    0H
         LA    1,P00069
         L     15,C00041
         BALR  14,15
         LA    2,4
         LA    3,5
L00026   DS    0H
         C     3,C00070
         BC    2,L00027
L00028   DS    0H
         L     15,C00042
         BALR  14,15
L00029   DS    0H
         LA    1,P00071
         L     15,C00041
         BALR  14,15
         LA    2,4
         LA    3,3
L00030   DS    0H
         C     3,C00070
         BC    2,L00031
L00032   DS    0H
         L     15,C00042
         BALR  14,15
L00033   DS    0H
         LA    1,P00072
         L     15,C00041
         BALR  14,15
         LE    0,C00073
         STE   0,P00048+0
         LA    1,P00048
         L     15,C00050
         BALR  14,15
         L     15,C00042
         BALR  14,15
L00034   DS    0H
         LA    1,P00074
         L     15,C00075
         BALR  14,15
         B     L00036
L00027   DS    0H
         L     5,T00012-4(2)
         LR    0,5
         ST    0,P00076+0
         LA    1,P00076
         L     15,C00045
         BALR  14,15
         AH    3,C00077
         A     2,C00068
         B     L00026
L00031   DS    0H
         L     5,T00012-4(2)
         LR    0,5
         ST    0,P00076+0
         LA    1,P00076
         L     15,C00045
         BALR  14,15
         AH    3,C00077
         A     2,C00068
         B     L00030
L00035   DS    0H
L00036   DS    0H
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
T00012   DS    XL32
P00040   DC    F'6'
         DC    A(Q00001)
P00043   DC    F'6'
         DC    A(Q00002)
P00044   DC    F'42'
P00046   DC    F'-7'
P00047   DC    F'6'
         DC    A(Q00003)
P00048   DC    A(0)
P00051   DC    F'6'
         DC    A(Q00004)
         DS    F
P00052   DC    A(0)
         DC    A(0)
P00055   DC    F'6'
         DC    A(Q00005)
P00056   DC    F'1'
P00057   DC    F'2'
P00058   DC    F'3'
P00059   DC    F'4'
P00060   DC    F'5'
P00061   DC    F'6'
P00062   DC    F'6'
         DC    A(Q00006)
P00063   DC    F'7'
P00064   DC    F'8'
P00065   DC    F'6'
         DC    A(Q00007)
P00066   DC    F'6'
         DC    A(Q00008)
P00067   DC    F'9'
P00069   DC    F'6'
         DC    A(Q00009)
P00071   DC    F'6'
         DC    A(Q00010)
P00072   DC    F'6'
         DC    A(Q00011)
P00074   DC    F'0'
P00076   DC    A(0)
         DS    XL4
C00053   DC    X'434D2915B573EAB3'
C00041   DC    V(F77WRBEG)
C00042   DC    V(F77WREND)
C00045   DC    V(F77WRI)
C00049   DC    X'41340000'
C00050   DC    V(F77WRR)
C00054   DC    V(F77WRD)
C00068   DC    F'4'
C00070   DC    F'0'
C00073   DC    X'40800000'
C00075   DC    V(EXIT)
C00077   DC    H'-1'
Q00001   DC    C'(''PLAIN TEXT'')'
Q00002   DC    C'(''I:'',I5,I5)'
Q00003   DC    C'(''F:'',F9.3)'
Q00004   DC    C'(''D:'',F12.4)'
Q00005   DC    C'(3I3)'
Q00006   DC    C'(''A'',I3,/,''B'',I3)'
Q00007   DC    C'(2(I2,''-''))'
Q00008   DC    C'(5X,''INDENTED'',I3)'
Q00009   DC    C'(''V:'',5I4)'
Q00010   DC    C'(I4)'
Q00011   DC    C'(''R:'',F6.2)'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
