* main
F77MAIN  CSECT
         USING *,15
         B     L00045
         DC    AL1(7),CL7'F77MAIN'
L00045   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00046
L00047   DC    A(S00000)
L00046   L     15,L00047
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00003   DS    0H
         LA    0,2
         ST    0,P00048+0
         LA    0,10
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LR    2,15
         C     2,C00050
         BC    7,L00004
L00005   DS    0H
         LA    0,3
         ST    0,P00048+0
         LA    0,0
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LR    2,15
         C     2,C00051
         BC    7,L00006
L00007   DS    0H
         LA    0,2
         ST    0,P00048+0
         LH    0,C00052
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LR    2,15
         C     2,C00053
         BC    7,L00008
L00009   DS    0H
         LA    0,1
         ST    0,P00048+0
         LH    0,C00054
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LR    2,15
         C     2,C00051
         BC    7,L00010
L00011   DS    0H
         LH    0,C00052
         ST    0,P00048+0
         LH    0,C00055
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LR    2,15
         C     2,C00056
         BC    7,L00012
L00013   DS    0H
         LH    0,C00057
         ST    0,P00048+0
         LA    0,3
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LR    2,15
         C     2,C00058
         BC    7,L00014
L00015   DS    0H
         LA    0,2
         ST    0,P00048+0
         LA    0,2
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LR    3,15
         LCR   2,3
         C     2,C00059
         BC    7,L00016
L00017   DS    0H
         LA    0,3
         ST    0,P00048+0
         LA    0,2
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LR    3,15
         LA    0,2
         ST    0,P00048+0
         LR    0,3
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LR    2,15
         C     2,C00060
         BC    7,L00018
L00019   DS    0H
         LA    0,2
         ST    0,P00048+0
         LA    0,5
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LR    2,15
         C     2,C00061
         BC    7,L00020
L00021   DS    0H
         LE    0,C00062
         STE   0,P00048+0
         LA    0,2
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00063
         BALR  14,15
         STE   0,S00000+176
         LE    0,C00064
         STE   0,P00048+0
         LH    0,C00057
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00063
         BALR  14,15
         AE    0,S00000+176
         SE    0,C00065
         LPER  0,0
         LE    2,C00066
         CER   2,0
         BC    4,L00022
L00023   DS    0H
         LD    0,C00067
         STD   0,P00048+0
         LA    0,3
         ST    0,P00048+8
         LA    1,P00048
         L     15,C00068
         BALR  14,15
         STD   0,S00000+176
         LD    0,C00069
         STD   0,P00048+0
         LH    0,C00055
         ST    0,P00048+8
         LA    1,P00048
         L     15,C00068
         BALR  14,15
         LD    2,S00000+176
         ADR   2,0
         STD   2,S00000+184
         LD    0,S00000+184
         SD    0,C00070
         LPDR  0,0
         LD    2,C00071
         CDR   2,0
         BC    4,L00024
L00025   DS    0H
         LD    0,S00000+184
         STD   0,P00048+0
         LH    0,C00055
         ST    0,P00048+8
         LA    1,P00048
         L     15,C00068
         BALR  14,15
         LD    2,C00072
         DD    2,C00073
         SDR   0,2
         LPDR  0,0
         LD    2,C00074
         CDR   2,0
         BC    4,L00026
L00027   DS    0H
         LA    2,0
         LH    3,C00055
L00028   DS    0H
         C     3,C00053
         LA    4,1
         BC    8,L00075
         SR    4,4
L00075   DS    0H
         C     3,C00053
         BC    4,L00030
L00029   DS    0H
         LTR   4,4
         BC    7,L00031
L00032   DS    0H
         LR    1,2
         M     0,C00076
         LR    2,1
         A     2,C00077
         C     2,C00078
         BC    7,L00033
L00034   DS    0H
         LD    0,S00000+184
         SD    0,C00070
         CD    0,C00079
         LA    3,1
         BC    8,L00080
         SR    3,3
L00080   DS    0H
         CD    0,C00079
         BC    4,L00036
L00035   DS    0H
         LTR   3,3
         BC    7,L00037
L00036   DS    0H
         LA    0,14
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00081
         BALR  14,15
         B     L00044
L00004   DS    0H
         LA    0,1
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00081
         BALR  14,15
         B     L00044
L00006   DS    0H
         LA    0,2
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00081
         BALR  14,15
         B     L00044
L00008   DS    0H
         LA    0,3
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00081
         BALR  14,15
         B     L00044
L00010   DS    0H
         LA    0,4
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00081
         BALR  14,15
         B     L00044
L00012   DS    0H
         LA    0,5
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00081
         BALR  14,15
         B     L00044
L00014   DS    0H
         LA    0,6
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00081
         BALR  14,15
         B     L00044
L00016   DS    0H
         LA    0,7
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00081
         BALR  14,15
         B     L00044
L00018   DS    0H
         LA    0,8
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00081
         BALR  14,15
         B     L00044
L00020   DS    0H
         LA    0,9
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00081
         BALR  14,15
         B     L00044
L00022   DS    0H
         LA    0,10
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00081
         BALR  14,15
         B     L00044
L00024   DS    0H
         LA    0,11
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00081
         BALR  14,15
         B     L00044
L00026   DS    0H
         LA    0,12
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00081
         BALR  14,15
         B     L00044
L00030   DS    0H
         LR    1,2
         M     0,C00076
         LR    2,1
         A     2,C00051
         A     3,C00077
         B     L00028
L00031   DS    0H
         LR    1,2
         M     0,C00076
         LR    2,1
         A     2,C00082
         A     3,C00077
         B     L00028
L00033   DS    0H
         LA    0,13
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00081
         BALR  14,15
         B     L00044
L00037   DS    0H
         LE    0,C00083
         LCER  0,0
         STE   0,S00000+176
         LE    0,S00000+176
         CE    0,C00084
         BC    4,L00039
L00038   DS    0H
L00040   DS    0H
         LA    0,15
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00081
         BALR  14,15
         B     L00044
L00039   DS    0H
         LA    0,6
         ST    0,P00048+0
         L     0,C00085
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00086
         BALR  14,15
         LA    0,2
         ST    0,P00048+0
         LA    0,10
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LR    4,15
         LR    0,4
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00087
         BALR  14,15
         LA    0,2
         ST    0,P00048+0
         LA    0,2
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LR    3,15
         LCR   4,3
         LR    0,4
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00087
         BALR  14,15
         LA    0,3
         ST    0,P00048+0
         LA    0,2
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LR    3,15
         LA    0,2
         ST    0,P00048+0
         LR    0,3
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LR    4,15
         LR    0,4
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00087
         BALR  14,15
         LR    0,2
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00087
         BALR  14,15
         L     15,C00088
         BALR  14,15
L00041   DS    0H
         LA    0,6
         ST    0,P00048+0
         L     0,C00089
         ST    0,P00048+4
         LA    1,P00048
         L     15,C00086
         BALR  14,15
         LE    0,S00000+176
         STE   0,P00048+0
         LA    1,P00048
         L     15,C00090
         BALR  14,15
         LD    0,S00000+184
         STD   0,P00048+0
         LA    1,P00048
         L     15,C00091
         BALR  14,15
         L     15,C00088
         BALR  14,15
L00042   DS    0H
         LA    0,0
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00081
         BALR  14,15
         B     L00044
L00043   DS    0H
L00044   DS    0H
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
         DS    2D
P00048   DS    3F
         DS    XL4
C00067   DC    X'4118000000000000'
C00069   DC    X'4120000000000000'
C00070   DC    X'4138000000000000'
C00071   DC    X'37119799812DEA11'
C00072   DC    X'4110000000000000'
C00073   DC    X'422AE00000000000'
C00074   DC    X'34480EBE7B9D5856'
C00079   DC    X'0000000000000000'
C00049   DC    V(F77IPOW)
C00050   DC    F'1024'
C00051   DC    F'1'
C00053   DC    F'0'
C00056   DC    F'-1'
C00058   DC    F'-8'
C00059   DC    F'-4'
C00060   DC    F'512'
C00061   DC    F'32'
C00062   DC    X'41180000'
C00063   DC    V(F77RPOWI)
C00064   DC    X'41200000'
C00065   DC    X'41280000'
C00066   DC    X'3C10C6F8'
C00068   DC    V(F77DPOWI)
C00076   DC    F'10'
C00077   DC    F'3'
C00078   DC    F'123'
C00081   DC    V(EXIT)
C00082   DC    F'2'
C00083   DC    X'40400000'
C00084   DC    X'00000000'
C00085   DC    A(Q00001)
C00086   DC    V(F77WRBEG)
C00087   DC    V(F77WRI)
C00088   DC    V(F77WREND)
C00089   DC    A(Q00002)
C00090   DC    V(F77WRR)
C00091   DC    V(F77WRD)
C00052   DC    H'-1'
C00054   DC    H'-5'
C00055   DC    H'-3'
C00057   DC    H'-2'
Q00001   DC    C'(''OK'',4I7)'
Q00002   DC    C'(F8.3,F10.4)'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
