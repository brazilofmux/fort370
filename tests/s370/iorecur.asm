* KTOC
KTOC     CSECT
         USING *,15
         B     L00004
         DC    AL1(4),CL7'KTOC'
L00004   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00005
L00006   DC    A(S00000)
L00005   L     15,L00006
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00002   DS    0H
         L     5,8(,1)
         LA    5,0(,5)
         L     4,0(,1)
         LA    1,P00007
         L     15,C00008
         BALR  14,15
         LR    0,4
         ST    0,P00009+0
         LA    1,P00009
         L     15,C00010
         BALR  14,15
         L     3,0(,5)
         LR    0,3
         ST    0,P00011+0
         LA    1,P00011
         L     15,C00012
         BALR  14,15
         L     15,C00013
         BALR  14,15
         ICM   2,8,0(4)
         SRA   2,24
         LR    0,2
L00003   DS    0H
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
P00007   DC    F'4'
P00009   DC    A(0)
         DC    F'8'
         DC    F'1'
         DC    A(Q00001)
P00011   DC    A(0)
C00008   DC    V(F77FMTLM)
C00010   DC    V(F77WRBI)
C00012   DC    V(F77WRI)
C00013   DC    V(F77WREND)
Q00001   DC    C'(I8)'
* main
F77MAIN  CSECT
         USING *,15
         B     L00038
         DC    AL1(7),CL7'F77MAIN'
L00038   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00039
L00040   DC    A(S00014)
L00039   L     15,L00040
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00014,13
         ST    1,S00014+72
L00029   DS    0H
         LH    15,C00041
         ST    15,T00026
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         LA    1,P00044
         L     15,C00045
         BALR  14,15
         LA    1,P00046
         L     15,C00045
         BALR  14,15
         LA    1,P00047
         L     15,C00045
         BALR  14,15
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LA    1,P00050
         L     15,C00051
         BALR  14,15
         LA    1,P00052
         L     15,C00051
         BALR  14,15
         L     15,C00053
         BALR  14,15
         LA    15,1
         ST    15,T00022               J
L00030   DS    0H
         LH    6,C00054
         LA    7,0
         LA    2,3
L00031   DS    0H
         LA    1,P00055
         L     15,C00056
         BALR  14,15
         LA    1,P00057
         L     15,C00049
         BALR  14,15
         L     4,T00022                J
         LR    0,4
         ST    0,P00058+0
         LA    1,P00058
         L     15,C00059
         BALR  14,15
         L     15,C00053
         BALR  14,15
L00033   DS    0H
         L     3,T00022                J
         A     3,C00060
         ST    3,T00022                J
         BXH   2,6,L00031
L00032   DS    0H
         LA    1,P00061
         L     15,C00062
         BALR  14,15
         LA    2,0
L00034   DS    0H
         LA    1,P00055
         L     15,C00056
         BALR  14,15
         LA    1,P00063
         L     15,C00064
         BALR  14,15
         LR    3,15
         C     3,C00060
         BC    8,L00036
L00035   DS    0H
         LA    1,P00065
         L     15,C00066
         BALR  14,15
         L     15,C00067
         BALR  14,15
         A     2,C00060
         B     L00034
L00036   DS    0H
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LA    1,P00068
         L     15,C00051
         BALR  14,15
         LR    0,2
         ST    0,P00058+0
         LA    1,P00058
         L     15,C00059
         BALR  14,15
         L     15,C00053
         BALR  14,15
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LA    1,P00069
         L     15,C00051
         BALR  14,15
         LA    15,77
         ST    15,T00024
         LA    1,P00070
         L     15,C00043
         BALR  14,15
         LA    1,P00071
         L     15,C00051
         BALR  14,15
         L     15,C00053
         BALR  14,15
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LA    1,P00072
         L     15,C00051
         BALR  14,15
         L     15,C00053
         BALR  14,15
L00037   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00014   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00022   DS    XL8
T00023   DS    XL8
T00024   DS    XL8
T00025   DS    XL8
T00026   DS    XL12
         DS    XL4
T00027   DS    XL12
         DS    XL4
T00028   DS    XL32
P00042   DC    A(T00023)
         DC    F'8'
         DC    XL1'80',AL3(T00026)
P00044   DC    A(T00027)
         DC    F'2'
         DC    A(Q00015)
         DC    F'2'
P00046   DC    A(T00027+2)
         DC    F'8'
         DC    A(T00023)
         DC    F'8'
P00047   DC    A(T00028)
         DC    F'16'
         DC    A(T00027)
         DC    F'10'
P00048   DC    F'6'
         DC    F'0'
P00050   DC    A(Q00016)
         DC    F'8'
P00052   DC    A(T00028)
         DC    F'16'
P00055   DC    F'4'
P00057   DC    F'8'
         DC    A(Q00020)
P00058   DC    A(0)
P00061   DC    F'8'
P00063   DC    F'8'
         DC    A(Q00021)
         DC    F'1'
P00065   DC    A(T00022)
P00068   DC    A(Q00017)
         DC    F'5'
P00069   DC    A(Q00018)
         DC    F'8'
P00070   DC    A(T00025)
         DC    F'8'
         DC    XL1'80',AL3(T00024)
P00071   DC    A(T00025)
         DC    F'8'
P00072   DC    A(Q00019)
         DC    F'6'
         DS    XL4
C00043   DC    V(KTOC)
C00045   DC    V(F77STRCP)
C00049   DC    V(F77WRBEG)
C00051   DC    V(F77WRA)
C00053   DC    V(F77WREND)
C00056   DC    V(F77FMTLM)
C00059   DC    V(F77WRI)
C00060   DC    F'1'
C00062   DC    V(F77REWND)
C00064   DC    V(F77RDBEG)
C00066   DC    V(F77RDI)
C00067   DC    V(F77RDEND)
C00041   DC    H'4096'
C00054   DC    H'-1'
Q00015   DC    C'K='
Q00016   DC    C'>ASSIGN '
Q00020   DC    C'(I4)'
Q00021   DC    C'(I4)'
Q00017   DC    C'>ENDS'
Q00018   DC    C'>NESTED '
Q00019   DC    C'>AFTER'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
