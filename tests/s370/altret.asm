* main
F77MAIN  CSECT
         USING *,15
         B     L00027
         DC    AL1(7),CL7'F77MAIN'
L00027   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00028
L00029   DC    A(S00000)
L00028   L     15,L00029
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00006   DS    0H
         LA    15,1
         ST    15,T00005
         LA    1,P00030
         L     15,C00031
         BALR  14,15
         LR    2,0
         C     2,C00032
         BC    8,L00008
L00007   DS    0H
         C     2,C00033
         BC    8,L00010
L00009   DS    0H
         LA    2,100
L00011   DS    0H
         LA    15,2
         ST    15,T00002
         LA    1,P00034
         L     15,C00031
         BALR  14,15
         LR    3,0
         C     3,C00032
         BC    8,L00013
L00012   DS    0H
         C     3,C00033
         BC    8,L00015
L00014   DS    0H
         A     2,C00035
L00016   DS    0H
         LA    15,3
         ST    15,T00003
         LA    1,P00036
         L     15,C00031
         BALR  14,15
         LR    3,0
         C     3,C00032
         BC    8,L00018
L00017   DS    0H
         C     3,C00033
         BC    8,L00020
L00019   DS    0H
         A     2,C00035
L00021   DS    0H
         LA    15,2
         ST    15,T00004
         LA    1,P00037
         L     15,C00038
         BALR  14,15
         LR    3,0
         C     3,C00032
         BC    8,L00023
L00022   DS    0H
         A     2,C00039
L00023   DS    0H
         LA    1,P00040
         L     15,C00041
         BALR  14,15
         LR    0,2
         ST    0,P00042+0
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         L     15,C00044
         BALR  14,15
L00024   DS    0H
         LA    1,P00045
         L     15,C00046
         BALR  14,15
         B     L00026
L00008   DS    0H
         LA    2,1
         B     L00011
L00010   DS    0H
         LA    2,2
         B     L00011
L00013   DS    0H
         A     2,C00047
         B     L00016
L00015   DS    0H
         A     2,C00048
         B     L00016
L00018   DS    0H
         A     2,C00049
         B     L00021
L00020   DS    0H
         A     2,C00050
         B     L00021
L00025   DS    0H
L00026   DS    0H
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
T00002   DS    XL4
         DS    XL4
T00003   DS    XL4
         DS    XL4
T00004   DS    XL4
         DS    XL4
T00005   DS    XL12
         DS    XL4
P00030   DC    XL1'80',AL3(T00005)
P00034   DC    XL1'80',AL3(T00002)
P00036   DC    XL1'80',AL3(T00003)
P00037   DC    XL1'80',AL3(T00004)
P00040   DC    F'6'
         DC    A(Q00001)
P00042   DC    A(0)
P00045   DC    F'0'
C00031   DC    V(SA)
C00032   DC    F'1'
C00033   DC    F'2'
C00035   DC    F'100'
C00038   DC    V(SB)
C00039   DC    F'5'
C00041   DC    V(F77WRBEG)
C00043   DC    V(F77WRI)
C00044   DC    V(F77WREND)
C00046   DC    V(EXIT)
C00047   DC    F'10'
C00048   DC    F'20'
C00049   DC    F'1000'
C00050   DC    F'2000'
Q00001   DC    C'('' >ALTRET'',I8)'
* SA
SA       CSECT
         USING *,15
         B     L00059
         DC    AL1(2),CL7'SA'
L00059   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00060
L00061   DC    A(S00051)
L00060   L     15,L00061
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00051,13
         ST    1,S00051+72
L00052   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         C     2,C00062
         BC    8,L00053
L00054   DS    0H
         L     2,0(,3)
         C     2,C00063
         BC    8,L00055
L00056   DS    0H
         LA    0,0
         B     L00058
L00053   DS    0H
         LA    0,1
         B     L00058
L00055   DS    0H
         LA    0,2
         B     L00058
L00057   DS    0H
L00058   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00051   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00062   DC    F'1'
C00063   DC    F'2'
* SB
SB       CSECT
         USING *,15
         B     L00071
         DC    AL1(2),CL7'SB'
L00071   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00072
L00073   DC    A(S00064)
L00072   L     15,L00073
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00064,13
         ST    1,S00064+72
L00065   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         LR    0,3
         ST    0,P00074+0
         OI    P00074+0,X'80'
         LA    1,P00074
         L     15,C00075
         BALR  14,15
         LR    2,0
         C     2,C00076
         BC    8,L00067
L00066   DS    0H
         C     2,C00077
         BC    8,L00067
L00068   DS    0H
         LA    0,0
         B     L00070
L00067   DS    0H
         LA    0,1
         B     L00070
L00069   DS    0H
L00070   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00064   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00074   DC    XL1'80',AL3(0)
         DS    XL4
C00075   DC    V(SA)
C00076   DC    F'1'
C00077   DC    F'2'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
