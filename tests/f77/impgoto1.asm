* main
F77MAIN  CSECT
         USING *,15
         B     L00033
         DC    AL1(7),CL7'F77MAIN'
L00033   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00034
L00035   DC    A(S00000)
L00034   L     15,L00035
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00004   DS    0H
         LA    0,3
         X     0,C00036
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00037
         MD    0,C00038
         STD   0,T00002
         SD    0,C00039
         LPDR  0,0
         LD    2,C00040
         CDR   2,0
         BC    4,L00005
L00006   DS    0H
         LD    0,C00041
         DD    0,C00042
         MD    0,C00042
         SD    0,C00041
         LPDR  0,0
         LD    2,C00043
         CDR   2,0
         BC    4,L00007
L00008   DS    0H
         LA    4,0
         LA    2,0
L00009   DS    0H
         A     4,C00044
         LR    3,4
         AH    3,C00045
         LA    14,3
         CLR   14,3
         BC    2,L00013
L00014   DS    0H
L00015   DS    0H
         C     2,C00046
         BC    7,L00016
L00017   DS    0H
         C     4,C00047
         BC    7,L00018
L00019   DS    0H
L00022   DS    0H
         A     2,C00044
L00023   DS    0H
         C     2,C00048
         BC    7,L00024
L00025   DS    0H
         LA    1,P00049
         L     15,C00050
         BALR  14,15
         LD    0,T00002
         SD    0,C00051
         LPDR  0,0
         LD    2,C00040
         CDR   2,0
         BC    4,L00026
L00027   DS    0H
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         L     3,T00003
         C     3,C00054
         BC    7,L00028
L00029   DS    0H
         LA    1,P00055
         L     15,C00056
         BALR  14,15
         LR    0,2
         ST    0,P00057+0
         LA    1,P00057
         L     15,C00058
         BALR  14,15
         LD    0,T00002
         STD   0,S00000+208
         LD    0,S00000+208
         STD   0,P00059+0
         LA    1,P00059
         L     15,C00060
         BALR  14,15
         L     15,C00061
         BALR  14,15
L00030   DS    0H
         LA    1,P00062
         L     15,C00063
         BALR  14,15
         B     L00032
L00005   DS    0H
         LA    1,P00064
         L     15,C00063
         BALR  14,15
         B     L00032
L00007   DS    0H
         LA    1,P00065
         L     15,C00063
         BALR  14,15
         B     L00032
L00010   DS    0H
         LR    1,2
         M     0,C00066
         LR    2,1
         A     2,C00044
         B     L00009
L00011   DS    0H
         LR    1,2
         M     0,C00066
         LR    2,1
         A     2,C00067
         B     L00009
L00012   DS    0H
         LR    1,2
         M     0,C00066
         LR    2,1
         A     2,C00068
         B     L00009
L00013   DS    0H
         LR    14,3
         SLL   14,2
         L     15,C00070
         L     15,0(14,15)
         BCR   15,15
L00016   DS    0H
         LA    1,P00071
         L     15,C00063
         BALR  14,15
         B     L00032
L00018   DS    0H
         LA    1,P00072
         L     15,C00063
         BALR  14,15
         B     L00032
L00020   DS    0H
L00021   DS    0H
L00024   DS    0H
         LA    1,P00073
         L     15,C00063
         BALR  14,15
         B     L00032
L00026   DS    0H
         LA    1,P00074
         L     15,C00063
         BALR  14,15
         B     L00032
L00028   DS    0H
         LA    1,P00075
         L     15,C00063
         BALR  14,15
         B     L00032
L00031   DS    0H
L00032   DS    0H
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
T00002   DS    XL8
T00003   DS    XL24
         DS    1D
P00069   DC    A(L00010)
         DC    A(L00011)
         DC    A(L00012)
P00049   DC    XL1'80',AL3(T00002)
P00052   DC    XL1'80',AL3(T00003)
P00055   DC    F'6'
         DC    A(Q00001)
P00057   DC    A(0)
P00059   DC    A(0)
         DC    A(0)
P00062   DC    F'0'
P00064   DC    F'1'
P00065   DC    F'2'
P00071   DC    F'3'
P00072   DC    F'4'
P00073   DC    F'6'
P00074   DC    F'7'
P00075   DC    F'8'
C00037   DC    X'4E00000080000000'
C00038   DC    X'4128000000000000'
C00039   DC    X'4178000000000000'
C00040   DC    X'3944B82FA09B5A53'
C00041   DC    X'4110000000000000'
C00042   DC    X'4130000000000000'
C00043   DC    X'37119799812DEA11'
C00051   DC    X'4188000000000000'
C00036   DC    F'-2147483648'
C00044   DC    F'1'
C00046   DC    F'123'
C00047   DC    F'4'
C00048   DC    F'124'
C00050   DC    V(DBUMP)
C00053   DC    V(NONECK)
C00054   DC    F'6'
C00056   DC    V(F77WRBEG)
C00058   DC    V(F77WRI)
C00060   DC    V(F77WRD)
C00061   DC    V(F77WREND)
C00063   DC    V(EXIT)
C00066   DC    F'10'
C00067   DC    F'2'
C00068   DC    F'3'
C00070   DC    A(P00069)
C00045   DC    H'-1'
Q00001   DC    C'(''OK'',I5,F8.2)'
* DBUMP
DBUMP    CSECT
         USING *,15
         B     L00080
         DC    AL1(5),CL7'DBUMP'
L00080   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00081
L00082   DC    A(S00076)
L00081   L     15,L00082
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00076,13
         ST    1,S00076+72
L00077   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         LD    0,C00083
         AD    0,0(,2)
         STD   0,0(,2)
         LA    0,0
         B     L00079
L00078   DS    0H
L00079   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00076   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00083   DC    X'4110000000000000'
* NONECK
NONECK   CSECT
         USING *,15
         B     L00092
         DC    AL1(6),CL7'NONECK'
L00092   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00093
L00094   DC    A(S00084)
L00093   L     15,L00094
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00084,13
         ST    1,S00084+72
L00085   DS    0H
         L     6,0(,1)
         LA    6,0(,6)
         LA    15,0
         ST    15,0(,6)
         LA    4,1
L00086   DS    0H
         LA    5,3
         LR    2,4
L00087   DS    0H
         LR    3,2
         A     3,0(,6)
         ST    3,0(,6)
L00089   DS    0H
         BXLE  2,4,L00087
L00088   DS    0H
         LA    0,0
         B     L00091
L00090   DS    0H
L00091   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00084   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
