* main
F77MAIN  CSECT
         USING *,15
         B     L00042
         DC    AL1(7),CL7'F77MAIN'
L00042   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00043
L00044   DC    A(S00000)
L00043   L     15,L00044
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00017   DS    0H
         LA    1,P00045
         L     15,C00046
         BALR  14,15
         LA    15,1
         ST    15,T00015
L00018   DS    0H
         LD    0,C00047
         STD   0,S00000+208
         LH    6,C00048
         LA    7,0
         LA    2,3
L00019   DS    0H
         L     3,T00015
         LR    0,3
         X     0,C00049
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00050
         MD    0,C00047
         STD   0,T00016
         LA    1,P00051
         L     15,C00052
         BALR  14,15
         L     4,T00015
         LR    0,4
         ST    0,P00053+0
         LA    1,P00053
         L     15,C00054
         BALR  14,15
         LD    0,T00016
         STD   0,S00000+216
         LD    0,S00000+216
         STD   0,P00055+0
         LA    1,P00055
         L     15,C00056
         BALR  14,15
         L     15,C00057
         BALR  14,15
L00021   DS    0H
L00022   DS    0H
         L     3,T00015
         A     3,C00058
         ST    3,T00015
         BXH   2,6,L00019
L00020   DS    0H
         LA    1,P00059
         L     15,C00060
         BALR  14,15
         LA    1,P00061
         L     15,C00046
         BALR  14,15
         MVC   S00000+208(8),C00062
         LA    2,0
L00023   DS    0H
         LA    1,P00063
         L     15,C00064
         BALR  14,15
         LR    3,15
         C     3,C00058
         BC    8,L00025
L00024   DS    0H
         LA    1,P00065
         L     15,C00066
         BALR  14,15
         LA    1,P00067
         L     15,C00068
         BALR  14,15
         L     15,C00069
         BALR  14,15
         A     2,C00058
         LD    0,S00000+208
         AD    0,T00016
         STD   0,S00000+208
         B     L00023
L00025   DS    0H
         C     2,C00070
         BC    7,L00026
L00027   DS    0H
         LD    0,S00000+208
         SD    0,C00071
         LPDR  0,0
         LD    2,C00072
         CDR   2,0
         BC    4,L00028
L00029   DS    0H
         LA    1,P00073
         L     15,C00052
         BALR  14,15
         LR    0,2
         ST    0,P00053+0
         LA    1,P00053
         L     15,C00054
         BALR  14,15
         LD    0,S00000+208
         STD   0,P00055+0
         LA    1,P00055
         L     15,C00056
         BALR  14,15
         L     15,C00057
         BALR  14,15
L00030   DS    0H
         LA    1,P00074
         L     15,C00075
         BALR  14,15
         LA    1,P00076
         L     15,C00064
         BALR  14,15
         LA    1,P00065
         L     15,C00066
         BALR  14,15
         LA    1,P00067
         L     15,C00068
         BALR  14,15
         L     15,C00069
         BALR  14,15
         L     2,T00015
         C     2,C00058
         BC    7,L00031
L00032   DS    0H
         LD    0,T00016
         SD    0,C00047
         LPDR  0,0
         LD    2,C00072
         CDR   2,0
         BC    4,L00033
L00034   DS    0H
         LA    1,P00077
         L     15,C00052
         BALR  14,15
         L     3,T00015
         LR    0,3
         ST    0,P00053+0
         LA    1,P00053
         L     15,C00054
         BALR  14,15
         LD    0,T00016
         STD   0,S00000+208
         LD    0,S00000+208
         STD   0,P00055+0
         LA    1,P00055
         L     15,C00056
         BALR  14,15
         L     15,C00057
         BALR  14,15
L00035   DS    0H
         LA    1,P00078
         L     15,C00060
         BALR  14,15
         LA    1,P00079
         L     15,C00046
         BALR  14,15
         LA    1,P00080
         L     15,C00052
         BALR  14,15
         LA    1,P00081
         L     15,C00054
         BALR  14,15
         L     15,C00057
         BALR  14,15
L00036   DS    0H
         LA    1,P00082
         L     15,C00060
         BALR  14,15
         LA    1,P00083
         L     15,C00046
         BALR  14,15
         LA    1,P00084
         L     15,C00064
         BALR  14,15
         LA    1,P00065
         L     15,C00066
         BALR  14,15
         L     15,C00069
         BALR  14,15
         L     2,T00015
         C     2,C00085
         BC    7,L00037
L00038   DS    0H
         LA    1,P00086
         L     15,C00052
         BALR  14,15
         L     3,T00015
         LR    0,3
         ST    0,P00053+0
         LA    1,P00053
         L     15,C00054
         BALR  14,15
         L     15,C00057
         BALR  14,15
L00039   DS    0H
         LA    1,P00087
         L     15,C00060
         BALR  14,15
         LA    1,P00088
         L     15,C00089
         BALR  14,15
         B     L00041
L00026   DS    0H
         LA    1,P00090
         L     15,C00089
         BALR  14,15
         B     L00041
L00028   DS    0H
         LA    1,P00091
         L     15,C00089
         BALR  14,15
         B     L00041
L00031   DS    0H
         LA    1,P00092
         L     15,C00089
         BALR  14,15
         B     L00041
L00033   DS    0H
         LA    1,P00093
         L     15,C00089
         BALR  14,15
         B     L00041
L00037   DS    0H
         LA    1,P00094
         L     15,C00089
         BALR  14,15
         B     L00041
L00040   DS    0H
L00041   DS    0H
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
T00015   DS    XL8
T00016   DS    XL20
         DS    XL4
         DS    2D
P00045   DC    F'8'
         DC    A(Q00001)
         DC    F'12'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
P00051   DC    F'8'
         DC    A(Q00005)
P00053   DC    A(0)
P00055   DC    A(0)
         DC    A(0)
P00059   DC    F'8'
         DC    F'0'
         DC    F'0'
P00061   DC    F'8'
         DC    A(Q00002)
         DC    F'12'
         DC    A(Q00003)
         DC    F'3'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
P00063   DC    F'8'
         DC    A(Q00005)
         DC    F'1'
P00065   DC    A(T00015)
P00067   DC    A(T00016)
P00073   DC    F'6'
         DC    A(Q00004)
P00074   DC    F'8'
P00076   DC    F'8'
         DC    A(Q00005)
         DC    F'0'
P00077   DC    F'6'
         DC    A(Q00006)
P00078   DC    F'8'
         DC    A(Q00007)
         DC    F'6'
P00079   DC    F'9'
         DC    A(Q00008)
         DC    F'12'
         DC    A(Q00009)
         DC    F'3'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
P00080   DC    F'9'
         DC    A(Q00010)
P00081   DC    F'77'
P00082   DC    F'9'
         DC    F'0'
         DC    F'0'
P00083   DC    F'9'
         DC    A(Q00011)
         DC    F'12'
         DC    A(Q00012)
         DC    F'3'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
P00084   DC    F'9'
         DC    A(Q00010)
         DC    F'0'
P00086   DC    F'6'
         DC    A(Q00013)
P00087   DC    F'9'
         DC    A(Q00014)
         DC    F'6'
P00088   DC    F'0'
P00090   DC    F'1'
P00091   DC    F'2'
P00092   DC    F'3'
P00093   DC    F'4'
P00094   DC    F'5'
C00047   DC    X'4118000000000000'
C00050   DC    X'4E00000080000000'
C00062   DC    X'0000000000000000'
C00071   DC    X'4190000000000000'
C00072   DC    X'3944B82FA09B5A53'
C00046   DC    V(F77OPEN)
C00049   DC    F'-2147483648'
C00052   DC    V(F77WRBEG)
C00054   DC    V(F77WRI)
C00056   DC    V(F77WRD)
C00057   DC    V(F77WREND)
C00058   DC    F'1'
C00060   DC    V(F77CLOSE)
C00064   DC    V(F77RDBEG)
C00066   DC    V(F77RDI)
C00068   DC    V(F77RDD)
C00069   DC    V(F77RDEND)
C00070   DC    F'3'
C00075   DC    V(F77REWND)
C00085   DC    F'77'
C00089   DC    V(EXIT)
C00048   DC    H'-1'
Q00005   DC    C'(I4,F10.3)'
Q00004   DC    C'(''N='',I3,'' SUM='',F10.3)'
Q00006   DC    C'(''FIRST'',I3,F10.3)'
Q00010   DC    C'(I6)'
Q00013   DC    C'(''BACK'',I4)'
Q00001   DC    C'scratch1.dat'
Q00002   DC    C'scratch1.dat'
Q00003   DC    C'OLD'
Q00007   DC    C'DELETE'
Q00008   DC    C'scratch1.dat'
Q00009   DC    C'NEW'
Q00011   DC    C'scratch1.dat'
Q00012   DC    C'OLD'
Q00014   DC    C'DELETE'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
