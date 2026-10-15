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
         LA    0,8
         ST    0,P00045+0
         L     0,C00046
         ST    0,P00045+4
         LA    0,12
         ST    0,P00045+8
         LA    0,0
         ST    0,P00045+12
         LA    0,0
         ST    0,P00045+16
         LA    0,0
         ST    0,P00045+20
         LA    0,0
         ST    0,P00045+24
         LA    0,0
         ST    0,P00045+28
         LA    0,0
         ST    0,P00045+32
         LA    0,0
         ST    0,P00045+36
         LA    0,0
         ST    0,P00045+40
         LA    0,0
         ST    0,P00045+44
         LA    0,0
         ST    0,P00045+48
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         LA    15,1
         ST    15,T00015
L00018   DS    0H
         LD    0,C00048
         STD   0,S00000+208
         LH    6,C00049
         LA    7,0
         LA    2,3
L00019   DS    0H
         L     3,T00015
         LR    0,3
         X     0,C00050
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00051
         MD    0,C00048
         STD   0,T00016
         LA    0,8
         ST    0,P00045+0
         L     0,C00052
         ST    0,P00045+4
         LA    1,P00045
         L     15,C00053
         BALR  14,15
         L     4,T00015
         LR    0,4
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00054
         BALR  14,15
         LD    0,T00016
         STD   0,S00000+216
         LD    0,S00000+216
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00055
         BALR  14,15
         L     15,C00056
         BALR  14,15
L00021   DS    0H
L00022   DS    0H
         L     3,T00015
         A     3,C00057
         ST    3,T00015
         BXH   2,6,L00019
L00020   DS    0H
         LA    0,8
         ST    0,P00045+0
         LA    0,0
         ST    0,P00045+4
         LA    0,0
         ST    0,P00045+8
         LA    1,P00045
         L     15,C00058
         BALR  14,15
         LA    0,8
         ST    0,P00045+0
         L     0,C00059
         ST    0,P00045+4
         LA    0,12
         ST    0,P00045+8
         L     0,C00060
         ST    0,P00045+12
         LA    0,3
         ST    0,P00045+16
         LA    0,0
         ST    0,P00045+20
         LA    0,0
         ST    0,P00045+24
         LA    0,0
         ST    0,P00045+28
         LA    0,0
         ST    0,P00045+32
         LA    0,0
         ST    0,P00045+36
         LA    0,0
         ST    0,P00045+40
         LA    0,0
         ST    0,P00045+44
         LA    0,0
         ST    0,P00045+48
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         MVC   S00000+208(8),C00061
         LA    2,0
L00023   DS    0H
         LA    0,8
         ST    0,P00045+0
         L     0,C00052
         ST    0,P00045+4
         LA    0,1
         ST    0,P00045+8
         LA    1,P00045
         L     15,C00062
         BALR  14,15
         LR    3,15
         C     3,C00057
         BC    8,L00025
L00024   DS    0H
         LA    0,T00015
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00063
         BALR  14,15
         LA    0,T00016
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00064
         BALR  14,15
         L     15,C00065
         BALR  14,15
         A     2,C00057
         LD    0,S00000+208
         AD    0,T00016
         STD   0,S00000+208
         B     L00023
L00025   DS    0H
         C     2,C00066
         BC    7,L00026
L00027   DS    0H
         LD    0,S00000+208
         SD    0,C00067
         LPDR  0,0
         LD    2,C00068
         CDR   2,0
         BC    4,L00028
L00029   DS    0H
         LA    0,6
         ST    0,P00045+0
         L     0,C00069
         ST    0,P00045+4
         LA    1,P00045
         L     15,C00053
         BALR  14,15
         LR    0,2
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00054
         BALR  14,15
         LD    0,S00000+208
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00055
         BALR  14,15
         L     15,C00056
         BALR  14,15
L00030   DS    0H
         LA    0,8
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00070
         BALR  14,15
         LA    0,8
         ST    0,P00045+0
         L     0,C00052
         ST    0,P00045+4
         LA    0,0
         ST    0,P00045+8
         LA    1,P00045
         L     15,C00062
         BALR  14,15
         LA    0,T00015
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00063
         BALR  14,15
         LA    0,T00016
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00064
         BALR  14,15
         L     15,C00065
         BALR  14,15
         L     2,T00015
         C     2,C00057
         BC    7,L00031
L00032   DS    0H
         LD    0,T00016
         SD    0,C00048
         LPDR  0,0
         LD    2,C00068
         CDR   2,0
         BC    4,L00033
L00034   DS    0H
         LA    0,6
         ST    0,P00045+0
         L     0,C00071
         ST    0,P00045+4
         LA    1,P00045
         L     15,C00053
         BALR  14,15
         L     3,T00015
         LR    0,3
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00054
         BALR  14,15
         LD    0,T00016
         STD   0,S00000+208
         LD    0,S00000+208
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00055
         BALR  14,15
         L     15,C00056
         BALR  14,15
L00035   DS    0H
         LA    0,8
         ST    0,P00045+0
         L     0,C00072
         ST    0,P00045+4
         LA    0,6
         ST    0,P00045+8
         LA    1,P00045
         L     15,C00058
         BALR  14,15
         LA    0,9
         ST    0,P00045+0
         L     0,C00073
         ST    0,P00045+4
         LA    0,12
         ST    0,P00045+8
         L     0,C00074
         ST    0,P00045+12
         LA    0,3
         ST    0,P00045+16
         LA    0,0
         ST    0,P00045+20
         LA    0,0
         ST    0,P00045+24
         LA    0,0
         ST    0,P00045+28
         LA    0,0
         ST    0,P00045+32
         LA    0,0
         ST    0,P00045+36
         LA    0,0
         ST    0,P00045+40
         LA    0,0
         ST    0,P00045+44
         LA    0,0
         ST    0,P00045+48
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         LA    0,9
         ST    0,P00045+0
         L     0,C00075
         ST    0,P00045+4
         LA    1,P00045
         L     15,C00053
         BALR  14,15
         LA    0,77
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00054
         BALR  14,15
         L     15,C00056
         BALR  14,15
L00036   DS    0H
         LA    0,9
         ST    0,P00045+0
         LA    0,0
         ST    0,P00045+4
         LA    0,0
         ST    0,P00045+8
         LA    1,P00045
         L     15,C00058
         BALR  14,15
         LA    0,9
         ST    0,P00045+0
         L     0,C00076
         ST    0,P00045+4
         LA    0,12
         ST    0,P00045+8
         L     0,C00077
         ST    0,P00045+12
         LA    0,3
         ST    0,P00045+16
         LA    0,0
         ST    0,P00045+20
         LA    0,0
         ST    0,P00045+24
         LA    0,0
         ST    0,P00045+28
         LA    0,0
         ST    0,P00045+32
         LA    0,0
         ST    0,P00045+36
         LA    0,0
         ST    0,P00045+40
         LA    0,0
         ST    0,P00045+44
         LA    0,0
         ST    0,P00045+48
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         LA    0,9
         ST    0,P00045+0
         L     0,C00075
         ST    0,P00045+4
         LA    0,0
         ST    0,P00045+8
         LA    1,P00045
         L     15,C00062
         BALR  14,15
         LA    0,T00015
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00063
         BALR  14,15
         L     15,C00065
         BALR  14,15
         L     2,T00015
         C     2,C00078
         BC    7,L00037
L00038   DS    0H
         LA    0,6
         ST    0,P00045+0
         L     0,C00079
         ST    0,P00045+4
         LA    1,P00045
         L     15,C00053
         BALR  14,15
         L     3,T00015
         LR    0,3
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00054
         BALR  14,15
         L     15,C00056
         BALR  14,15
L00039   DS    0H
         LA    0,9
         ST    0,P00045+0
         L     0,C00080
         ST    0,P00045+4
         LA    0,6
         ST    0,P00045+8
         LA    1,P00045
         L     15,C00058
         BALR  14,15
         LA    0,0
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00081
         BALR  14,15
         B     L00041
L00026   DS    0H
         LA    0,1
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00081
         BALR  14,15
         B     L00041
L00028   DS    0H
         LA    0,2
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00081
         BALR  14,15
         B     L00041
L00031   DS    0H
         LA    0,3
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00081
         BALR  14,15
         B     L00041
L00033   DS    0H
         LA    0,4
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00081
         BALR  14,15
         B     L00041
L00037   DS    0H
         LA    0,5
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00081
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
P00045   DS    13F
         DS    XL4
C00048   DC    X'4118000000000000'
C00051   DC    X'4E00000080000000'
C00061   DC    X'0000000000000000'
C00067   DC    X'4190000000000000'
C00068   DC    X'3944B82FA09B5A53'
C00046   DC    A(Q00001)
C00047   DC    V(F77OPEN)
C00050   DC    F'-2147483648'
C00052   DC    A(Q00005)
C00053   DC    V(F77WRBEG)
C00054   DC    V(F77WRI)
C00055   DC    V(F77WRD)
C00056   DC    V(F77WREND)
C00057   DC    F'1'
C00058   DC    V(F77CLOSE)
C00059   DC    A(Q00002)
C00060   DC    A(Q00003)
C00062   DC    V(F77RDBEG)
C00063   DC    V(F77RDI)
C00064   DC    V(F77RDD)
C00065   DC    V(F77RDEND)
C00066   DC    F'3'
C00069   DC    A(Q00004)
C00070   DC    V(F77REWND)
C00071   DC    A(Q00006)
C00072   DC    A(Q00007)
C00073   DC    A(Q00008)
C00074   DC    A(Q00009)
C00075   DC    A(Q00010)
C00076   DC    A(Q00011)
C00077   DC    A(Q00012)
C00078   DC    F'77'
C00079   DC    A(Q00013)
C00080   DC    A(Q00014)
C00081   DC    V(EXIT)
C00049   DC    H'-1'
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
         END
