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
         LA    0,T00002
         ST    0,P00049+0
         OI    P00049+0,X'80'
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
         LA    0,T00003
         ST    0,P00049+0
         OI    P00049+0,X'80'
         LA    1,P00049
         L     15,C00052
         BALR  14,15
         L     3,T00003
         C     3,C00053
         BC    7,L00028
L00029   DS    0H
         LA    0,6
         ST    0,P00049+0
         L     0,C00054
         ST    0,P00049+4
         LA    1,P00049
         L     15,C00055
         BALR  14,15
         LR    0,2
         ST    0,P00049+0
         LA    1,P00049
         L     15,C00056
         BALR  14,15
         LD    0,T00002
         STD   0,S00000+208
         LD    0,S00000+208
         STD   0,P00049+0
         LA    1,P00049
         L     15,C00057
         BALR  14,15
         L     15,C00058
         BALR  14,15
L00030   DS    0H
         LA    0,0
         ST    0,P00049+0
         LA    1,P00049
         L     15,C00059
         BALR  14,15
         B     L00032
L00005   DS    0H
         LA    0,1
         ST    0,P00049+0
         LA    1,P00049
         L     15,C00059
         BALR  14,15
         B     L00032
L00007   DS    0H
         LA    0,2
         ST    0,P00049+0
         LA    1,P00049
         L     15,C00059
         BALR  14,15
         B     L00032
L00010   DS    0H
         LR    1,2
         M     0,C00060
         LR    2,1
         A     2,C00044
         B     L00009
L00011   DS    0H
         LR    1,2
         M     0,C00060
         LR    2,1
         A     2,C00061
         B     L00009
L00012   DS    0H
         LR    1,2
         M     0,C00060
         LR    2,1
         A     2,C00062
         B     L00009
L00013   DS    0H
         LR    14,3
         SLL   14,2
         L     15,C00064
         L     15,0(14,15)
         BCR   15,15
L00016   DS    0H
         LA    0,3
         ST    0,P00049+0
         LA    1,P00049
         L     15,C00059
         BALR  14,15
         B     L00032
L00018   DS    0H
         LA    0,4
         ST    0,P00049+0
         LA    1,P00049
         L     15,C00059
         BALR  14,15
         B     L00032
L00020   DS    0H
L00021   DS    0H
L00024   DS    0H
         LA    0,6
         ST    0,P00049+0
         LA    1,P00049
         L     15,C00059
         BALR  14,15
         B     L00032
L00026   DS    0H
         LA    0,7
         ST    0,P00049+0
         LA    1,P00049
         L     15,C00059
         BALR  14,15
         B     L00032
L00028   DS    0H
         LA    0,8
         ST    0,P00049+0
         LA    1,P00049
         L     15,C00059
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
P00049   DS    2F
P00063   DC    A(L00010)
         DC    A(L00011)
         DC    A(L00012)
         DS    XL4
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
C00052   DC    V(NONECK)
C00053   DC    F'6'
C00054   DC    A(Q00001)
C00055   DC    V(F77WRBEG)
C00056   DC    V(F77WRI)
C00057   DC    V(F77WRD)
C00058   DC    V(F77WREND)
C00059   DC    V(EXIT)
C00060   DC    F'10'
C00061   DC    F'2'
C00062   DC    F'3'
C00064   DC    A(P00063)
C00045   DC    H'-1'
Q00001   DC    C'(''OK'',I5,F8.2)'
* DBUMP
DBUMP    CSECT
         USING *,15
         B     L00069
         DC    AL1(5),CL7'DBUMP'
L00069   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00070
L00071   DC    A(S00065)
L00070   L     15,L00071
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00065,13
         ST    1,S00065+72
L00066   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         LD    0,C00072
         AD    0,0(,2)
         STD   0,0(,2)
         LA    0,0
         B     L00068
L00067   DS    0H
L00068   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00065   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00072   DC    X'4110000000000000'
* NONECK
NONECK   CSECT
         USING *,15
         B     L00081
         DC    AL1(6),CL7'NONECK'
L00081   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00082
L00083   DC    A(S00073)
L00082   L     15,L00083
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00073,13
         ST    1,S00073+72
L00074   DS    0H
         L     6,0(,1)
         LA    6,0(,6)
         LA    15,0
         ST    15,0(,6)
         LA    4,1
L00075   DS    0H
         LA    5,3
         LR    2,4
L00076   DS    0H
         LR    3,2
         A     3,0(,6)
         ST    3,0(,6)
L00078   DS    0H
         BXLE  2,4,L00076
L00077   DS    0H
         LA    0,0
         B     L00080
L00079   DS    0H
L00080   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00073   DS    0D
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
