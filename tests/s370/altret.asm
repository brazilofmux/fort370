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
         LA    0,T00005
         ST    0,P00030+0
         OI    P00030+0,X'80'
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
         LA    0,T00002
         ST    0,P00030+0
         OI    P00030+0,X'80'
         LA    1,P00030
         L     15,C00031
         BALR  14,15
         LR    3,0
         C     3,C00032
         BC    8,L00013
L00012   DS    0H
         C     3,C00033
         BC    8,L00015
L00014   DS    0H
         A     2,C00034
L00016   DS    0H
         LA    15,3
         ST    15,T00003
         LA    0,T00003
         ST    0,P00030+0
         OI    P00030+0,X'80'
         LA    1,P00030
         L     15,C00031
         BALR  14,15
         LR    3,0
         C     3,C00032
         BC    8,L00018
L00017   DS    0H
         C     3,C00033
         BC    8,L00020
L00019   DS    0H
         A     2,C00034
L00021   DS    0H
         LA    15,2
         ST    15,T00004
         LA    0,T00004
         ST    0,P00030+0
         OI    P00030+0,X'80'
         LA    1,P00030
         L     15,C00035
         BALR  14,15
         LR    3,0
         C     3,C00032
         BC    8,L00023
L00022   DS    0H
         A     2,C00036
L00023   DS    0H
         LA    0,6
         ST    0,P00030+0
         L     0,C00037
         ST    0,P00030+4
         LA    1,P00030
         L     15,C00038
         BALR  14,15
         LR    0,2
         ST    0,P00030+0
         LA    1,P00030
         L     15,C00039
         BALR  14,15
         L     15,C00040
         BALR  14,15
L00024   DS    0H
         LA    0,0
         ST    0,P00030+0
         LA    1,P00030
         L     15,C00041
         BALR  14,15
         B     L00026
L00008   DS    0H
         LA    2,1
         B     L00011
L00010   DS    0H
         LA    2,2
         B     L00011
L00013   DS    0H
         A     2,C00042
         B     L00016
L00015   DS    0H
         A     2,C00043
         B     L00016
L00018   DS    0H
         A     2,C00044
         B     L00021
L00020   DS    0H
         A     2,C00045
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
P00030   DS    2F
C00031   DC    V(SA)
C00032   DC    F'1'
C00033   DC    F'2'
C00034   DC    F'100'
C00035   DC    V(SB)
C00036   DC    F'5'
C00037   DC    A(Q00001)
C00038   DC    V(F77WRBEG)
C00039   DC    V(F77WRI)
C00040   DC    V(F77WREND)
C00041   DC    V(EXIT)
C00042   DC    F'10'
C00043   DC    F'20'
C00044   DC    F'1000'
C00045   DC    F'2000'
Q00001   DC    C'('' >ALTRET'',I8)'
* SA
SA       CSECT
         USING *,15
         B     L00054
         DC    AL1(2),CL7'SA'
L00054   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00055
L00056   DC    A(S00046)
L00055   L     15,L00056
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00046,13
         ST    1,S00046+72
L00047   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         C     2,C00057
         BC    8,L00048
L00049   DS    0H
         L     2,0(,3)
         C     2,C00058
         BC    8,L00050
L00051   DS    0H
         LA    0,0
         B     L00053
L00048   DS    0H
         LA    0,1
         B     L00053
L00050   DS    0H
         LA    0,2
         B     L00053
L00052   DS    0H
L00053   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00046   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00057   DC    F'1'
C00058   DC    F'2'
* SB
SB       CSECT
         USING *,15
         B     L00066
         DC    AL1(2),CL7'SB'
L00066   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00067
L00068   DC    A(S00059)
L00067   L     15,L00068
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00059,13
         ST    1,S00059+72
L00060   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         LR    0,3
         ST    0,P00069+0
         OI    P00069+0,X'80'
         LA    1,P00069
         L     15,C00070
         BALR  14,15
         LR    2,0
         C     2,C00071
         BC    8,L00062
L00061   DS    0H
         C     2,C00072
         BC    8,L00062
L00063   DS    0H
         LA    0,0
         B     L00065
L00062   DS    0H
         LA    0,1
         B     L00065
L00064   DS    0H
L00065   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00059   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00069   DS    1F
         DS    XL4
C00070   DC    V(SA)
C00071   DC    F'1'
C00072   DC    F'2'
         END
