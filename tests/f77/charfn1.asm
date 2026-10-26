* main
F77MAIN  CSECT
         USING *,15
         B     L00021
         DC    AL1(7),CL7'F77MAIN'
L00021   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00022
L00023   DC    A(S00000)
L00022   L     15,L00023
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00008   DS    0H
         LA    15,1
         ST    15,T00005
L00009   DS    0H
         LH    4,C00024
         LA    5,0
         LA    2,3
L00010   DS    0H
         LA    1,P00025
         L     15,C00026
         BALR  14,15
         LA    1,P00027
         L     15,C00028
         BALR  14,15
         L     6,T00005
         C     6,C00029
         LA    3,1
         BC    8,L00030
         SR    3,3
L00030   DS    0H
         LA    1,P00031
         L     15,C00032
         BALR  14,15
         LR    7,15
         C     7,C00033
         LA    6,1
         BC    7,L00034
         SR    6,6
L00034   DS    0H
         NR    3,6
         LTR   3,3
         BC    7,L00012
L00013   DS    0H
         L     6,T00005
         C     6,C00035
         LA    3,1
         BC    8,L00036
         SR    3,3
L00036   DS    0H
         LA    1,P00037
         L     15,C00032
         BALR  14,15
         LR    7,15
         C     7,C00033
         LA    6,1
         BC    7,L00038
         SR    6,6
L00038   DS    0H
         NR    3,6
         LTR   3,3
         BC    7,L00014
L00015   DS    0H
         L     6,T00005
         C     6,C00039
         LA    3,1
         BC    8,L00040
         SR    3,3
L00040   DS    0H
         LA    1,P00041
         L     15,C00032
         BALR  14,15
         LR    7,15
         C     7,C00033
         LA    6,1
         BC    7,L00042
         SR    6,6
L00042   DS    0H
         NR    3,6
         LTR   3,3
         BC    7,L00016
L00017   DS    0H
         LA    1,P00043
         L     15,C00044
         BALR  14,15
         LA    1,P00045
         L     15,C00046
         BALR  14,15
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         L     15,C00049
         BALR  14,15
L00018   DS    0H
         L     3,T00005
         A     3,C00029
         ST    3,T00005
         BXH   2,4,L00010
L00011   DS    0H
         LA    1,P00050
         L     15,C00051
         BALR  14,15
         B     L00020
L00012   DS    0H
         LA    1,P00052
         L     15,C00051
         BALR  14,15
         B     L00020
L00014   DS    0H
         LA    1,P00053
         L     15,C00051
         BALR  14,15
         B     L00020
L00016   DS    0H
         LA    1,P00043
         L     15,C00051
         BALR  14,15
         B     L00020
L00019   DS    0H
L00020   DS    0H
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
T00005   DS    XL8
T00006   DS    XL16
T00007   DS    XL32
P00025   DC    A(T00006)
         DC    F'10'
         DC    XL1'80',AL3(T00005)
P00027   DC    A(T00007)
         DC    F'10'
         DC    A(T00006)
         DC    F'10'
P00031   DC    A(T00007)
         DC    F'10'
         DC    A(Q00001)
         DC    F'9'
P00037   DC    A(T00007)
         DC    F'10'
         DC    A(Q00002)
         DC    F'10'
P00041   DC    A(T00007)
         DC    F'10'
         DC    A(Q00003)
         DC    F'10'
P00043   DC    F'3'
P00045   DC    F'6'
         DC    A(Q00004)
P00047   DC    A(T00007)
         DC    F'10'
P00050   DC    F'0'
P00052   DC    F'1'
P00053   DC    F'2'
         DS    XL4
C00026   DC    V(CF)
C00028   DC    V(F77STRCP)
C00029   DC    F'1'
C00032   DC    V(F77STRCM)
C00033   DC    F'0'
C00035   DC    F'2'
C00039   DC    F'3'
C00044   DC    V(F77FMTLM)
C00046   DC    V(F77WRBEG)
C00048   DC    V(F77WRA)
C00049   DC    V(F77WREND)
C00051   DC    V(EXIT)
C00024   DC    H'-1'
Q00001   DC    C'FIRST AID'
Q00002   DC    C'SECONDRATE'
Q00003   DC    C'THIRDCLASS'
Q00004   DC    C'(A)'
* CF
CF       CSECT
         USING *,15
         B     L00065
         DC    AL1(2),CL7'CF'
L00065   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00066
L00067   DC    A(S00054)
L00066   L     15,L00067
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00054,13
         ST    1,S00054+72
L00058   DS    0H
         L     3,8(,1)
         LA    3,0(,3)
         L     4,0(,1)
         L     2,0(,3)
         S     2,C00068
         C     2,C00069
         LA    3,1
         BC    8,L00070
         SR    3,3
L00070   DS    0H
         C     2,C00069
         BC    4,L00060
L00059   DS    0H
         LTR   3,3
         BC    7,L00061
L00062   DS    0H
         LR    0,4
         ST    0,P00071+0
         LA    1,P00071
         L     15,C00072
         BALR  14,15
         ICM   2,8,0(4)
         SRA   2,24
         LR    0,2
         B     L00064
L00060   DS    0H
         LR    0,4
         ST    0,P00073+0
         LA    1,P00073
         L     15,C00072
         BALR  14,15
         ICM   2,8,0(4)
         SRA   2,24
         LR    0,2
         B     L00064
L00061   DS    0H
         LR    0,4
         ST    0,P00074+0
         LA    1,P00074
         L     15,C00072
         BALR  14,15
         ICM   2,8,0(4)
         SRA   2,24
         LR    0,2
         B     L00064
L00063   DS    0H
L00064   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00054   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00071   DC    A(0)
         DC    F'10'
         DC    A(Q00057)
         DC    F'10'
P00073   DC    A(0)
         DC    F'10'
         DC    A(Q00055)
         DC    F'9'
P00074   DC    A(0)
         DC    F'10'
         DC    A(Q00056)
         DC    F'10'
C00068   DC    F'2'
C00069   DC    F'0'
C00072   DC    V(F77STRCP)
Q00055   DC    C'FIRST AID'
Q00056   DC    C'SECONDRATE'
Q00057   DC    C'THIRDCLASS'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
