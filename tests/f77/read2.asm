* main
F77MAIN  CSECT
         USING *,15
         B     L00053
         DC    AL1(7),CL7'F77MAIN'
L00053   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00054
L00055   DC    A(S00000)
L00054   L     15,L00055
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00010   DS    0H
         LA    0,5
         ST    0,P00056+0
         LA    0,0
         ST    0,P00056+4
         LA    0,0
         ST    0,P00056+8
         LA    1,P00056
         L     15,C00057
         BALR  14,15
         LA    15,1
         ST    15,T00003
         LA    4,T00009-4
         LA    2,5
L00011   DS    0H
         C     2,C00058
         BC    2,L00012
L00013   DS    0H
         L     15,C00059
         BALR  14,15
         LE    0,T00009
         SE    0,C00060
         LPER  0,0
         LE    2,C00061
         CER   2,0
         BC    4,L00014
L00015   DS    0H
         LE    0,T00009+4
         SE    0,C00062
         LPER  0,0
         LE    2,C00061
         CER   2,0
         BC    4,L00016
L00017   DS    0H
         LE    0,T00009+8
         SE    0,C00062
         LPER  0,0
         LE    2,C00061
         CER   2,0
         BC    4,L00018
L00019   DS    0H
         LE    0,C00063
         AE    0,T00009+12
         LPER  0,0
         LE    2,C00061
         CER   2,0
         BC    4,L00020
L00021   DS    0H
         LE    0,T00009+16
         SE    0,C00064
         LPER  0,0
         LE    2,C00061
         CER   2,0
         BC    4,L00022
L00023   DS    0H
         LA    0,5
         ST    0,P00056+0
         LA    0,0
         ST    0,P00056+4
         LA    0,0
         ST    0,P00056+8
         LA    1,P00056
         L     15,C00057
         BALR  14,15
         LA    2,4
         LA    3,4
L00024   DS    0H
         C     3,C00058
         BC    2,L00025
L00026   DS    0H
         L     15,C00059
         BALR  14,15
         L     2,T00008
         C     2,C00065
         BC    7,L00027
L00028   DS    0H
         L     2,T00008+12
         C     2,C00065
         BC    7,L00029
L00030   DS    0H
         LA    15,42
         ST    15,T00006
         LA    0,5
         ST    0,P00056+0
         LA    0,0
         ST    0,P00056+4
         LA    0,0
         ST    0,P00056+8
         LA    1,P00056
         L     15,C00057
         BALR  14,15
         LA    0,T00004
         ST    0,P00056+0
         LA    1,P00056
         L     15,C00066
         BALR  14,15
         LA    0,T00005
         ST    0,P00056+0
         LA    1,P00056
         L     15,C00066
         BALR  14,15
         LA    0,T00006
         ST    0,P00056+0
         LA    1,P00056
         L     15,C00066
         BALR  14,15
         L     15,C00059
         BALR  14,15
         L     2,T00004
         C     2,C00067
         BC    7,L00031
L00032   DS    0H
         L     2,T00005
         C     2,C00068
         BC    7,L00033
L00034   DS    0H
         L     2,T00006
         C     2,C00069
         BC    7,L00035
L00036   DS    0H
         LA    0,5
         ST    0,P00056+0
         LA    0,0
         ST    0,P00056+4
         LA    0,0
         ST    0,P00056+8
         LA    1,P00056
         L     15,C00057
         BALR  14,15
         LA    0,T00003
         ST    0,P00056+0
         LA    1,P00056
         L     15,C00066
         BALR  14,15
         L     15,C00059
         BALR  14,15
         L     2,T00003
         C     2,C00070
         BC    7,L00037
L00038   DS    0H
         MVC   S00000+288(8),C00071
         LA    4,0
L00039   DS    0H
         LA    0,5
         ST    0,P00056+0
         LA    0,0
         ST    0,P00056+4
         LA    0,1
         ST    0,P00056+8
         LA    1,P00056
         L     15,C00057
         BALR  14,15
         LR    2,15
         C     2,C00072
         BC    8,L00041
L00040   DS    0H
         LA    0,T00007
         ST    0,P00056+0
         LA    1,P00056
         L     15,C00073
         BALR  14,15
         L     15,C00059
         BALR  14,15
         A     4,C00072
         LD    0,S00000+288
         AD    0,T00007
         STD   0,S00000+288
         B     L00039
L00012   DS    0H
         L     3,T00003
         SLL   3,2
         AR    3,4
         LR    0,3
         ST    0,P00056+0
         LA    1,P00056
         L     15,C00074
         BALR  14,15
         L     3,T00003
         A     3,C00072
         ST    3,T00003
         AH    2,C00075
         B     L00011
L00014   DS    0H
         LA    0,1
         ST    0,P00056+0
         LA    1,P00056
         L     15,C00076
         BALR  14,15
         B     L00052
L00016   DS    0H
         LA    0,2
         ST    0,P00056+0
         LA    1,P00056
         L     15,C00076
         BALR  14,15
         B     L00052
L00018   DS    0H
         LA    0,3
         ST    0,P00056+0
         LA    1,P00056
         L     15,C00076
         BALR  14,15
         B     L00052
L00020   DS    0H
         LA    0,4
         ST    0,P00056+0
         LA    1,P00056
         L     15,C00076
         BALR  14,15
         B     L00052
L00022   DS    0H
         LA    0,5
         ST    0,P00056+0
         LA    1,P00056
         L     15,C00076
         BALR  14,15
         B     L00052
L00025   DS    0H
         LR    4,2
         AH    4,C00077
         LA    5,T00008
         AR    5,4
         LR    0,5
         ST    0,P00056+0
         LA    1,P00056
         L     15,C00066
         BALR  14,15
         AH    3,C00075
         A     2,C00078
         B     L00024
L00027   DS    0H
         LA    0,6
         ST    0,P00056+0
         LA    1,P00056
         L     15,C00076
         BALR  14,15
         B     L00052
L00029   DS    0H
         LA    0,7
         ST    0,P00056+0
         LA    1,P00056
         L     15,C00076
         BALR  14,15
         B     L00052
L00031   DS    0H
         LA    0,8
         ST    0,P00056+0
         LA    1,P00056
         L     15,C00076
         BALR  14,15
         B     L00052
L00033   DS    0H
         LA    0,9
         ST    0,P00056+0
         LA    1,P00056
         L     15,C00076
         BALR  14,15
         B     L00052
L00035   DS    0H
         LA    0,10
         ST    0,P00056+0
         LA    1,P00056
         L     15,C00076
         BALR  14,15
         B     L00052
L00037   DS    0H
         LA    0,11
         ST    0,P00056+0
         LA    1,P00056
         L     15,C00076
         BALR  14,15
         B     L00052
L00041   DS    0H
         C     4,C00079
         BC    7,L00042
L00043   DS    0H
         LD    0,S00000+288
         SD    0,C00080
         LPDR  0,0
         LD    2,C00081
         CDR   2,0
         BC    4,L00044
L00045   DS    0H
         LA    0,6
         ST    0,P00056+0
         L     0,C00082
         ST    0,P00056+4
         LA    1,P00056
         L     15,C00083
         BALR  14,15
         LA    15,1
         ST    15,T00003
         LA    2,5
L00046   DS    0H
         C     2,C00058
         BC    2,L00047
L00048   DS    0H
         L     15,C00084
         BALR  14,15
L00049   DS    0H
         LA    0,6
         ST    0,P00056+0
         L     0,C00085
         ST    0,P00056+4
         LA    1,P00056
         L     15,C00083
         BALR  14,15
         LR    0,4
         ST    0,P00056+0
         LA    1,P00056
         L     15,C00086
         BALR  14,15
         LD    0,S00000+288
         STD   0,P00056+0
         LA    1,P00056
         L     15,C00087
         BALR  14,15
         L     15,C00084
         BALR  14,15
L00050   DS    0H
         LA    0,0
         ST    0,P00056+0
         LA    1,P00056
         L     15,C00076
         BALR  14,15
         B     L00052
L00042   DS    0H
         LA    0,12
         ST    0,P00056+0
         LA    1,P00056
         L     15,C00076
         BALR  14,15
         B     L00052
L00044   DS    0H
         LA    0,13
         ST    0,P00056+0
         LA    1,P00056
         L     15,C00076
         BALR  14,15
         B     L00052
L00047   DS    0H
         L     3,T00003
         SLL   3,2
         LE    0,T00009-4(3)
         STE   0,S00000+296
         LE    0,S00000+296
         STE   0,P00056+0
         LA    1,P00056
         L     15,C00088
         BALR  14,15
         L     3,T00003
         A     3,C00072
         ST    3,T00003
         AH    2,C00075
         B     L00046
L00051   DS    0H
L00052   DS    0H
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
T00003   DS    XL8
T00004   DS    XL8
T00005   DS    XL8
T00006   DS    XL8
T00007   DS    XL12
         DS    XL4
T00008   DS    XL20
         DS    XL4
T00009   DS    XL36
         DS    XL4
         DS    2D
P00056   DS    3F
         DS    XL4
C00071   DC    X'0000000000000000'
C00080   DC    X'4190000000000000'
C00081   DC    X'3944B82FA09B5A52'
C00057   DC    V(F77RDBEG)
C00058   DC    F'0'
C00059   DC    V(F77RDEND)
C00060   DC    X'41180000'
C00061   DC    X'3D68DB8B'
C00062   DC    X'41280000'
C00063   DC    X'41300000'
C00064   DC    X'41C80000'
C00065   DC    F'6'
C00066   DC    V(F77RDI)
C00067   DC    F'7'
C00068   DC    F'8'
C00069   DC    F'42'
C00070   DC    F'555'
C00072   DC    F'1'
C00073   DC    V(F77RDD)
C00074   DC    V(F77RDR)
C00076   DC    V(EXIT)
C00078   DC    F'4'
C00079   DC    F'3'
C00082   DC    A(Q00001)
C00083   DC    V(F77WRBEG)
C00084   DC    V(F77WREND)
C00085   DC    A(Q00002)
C00086   DC    V(F77WRI)
C00087   DC    V(F77WRD)
C00088   DC    V(F77WRR)
C00075   DC    H'-1'
C00077   DC    H'-4'
Q00001   DC    C'(5F8.2)'
Q00002   DC    C'(''N='',I3,'' SUM='',F12.4)'
         END
