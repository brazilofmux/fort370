* main
F77MAIN  CSECT
         USING *,15
         B     L00020
         DC    AL1(7),CL7'F77MAIN'
L00020   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00021
L00022   DC    A(S00000)
L00021   L     15,L00022
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00013   DS    0H
         LA    15,3
         ST    15,T00012
         LA    1,P00023
         L     15,C00024
         BALR  14,15
         LA    1,P00025
         L     15,C00026
         BALR  14,15
         L     3,T00004
         LR    0,3
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00028
         BALR  14,15
         L     15,C00029
         BALR  14,15
         LA    15,5
         ST    15,T00005
         LA    1,P00030
         L     15,C00031
         BALR  14,15
         LA    1,P00025
         L     15,C00026
         BALR  14,15
         L     3,T00006
         LR    0,3
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00028
         BALR  14,15
         L     15,C00029
         BALR  14,15
         MVC   T00007(4),C00032
         LA    1,P00033
         L     15,C00034
         BALR  14,15
         LA    1,P00025
         L     15,C00026
         BALR  14,15
         LE    0,T00008
         STE   0,S00000+256
         LE    0,S00000+256
         STE   0,P00035+0
         LA    1,P00035
         L     15,C00036
         BALR  14,15
         L     15,C00029
         BALR  14,15
         LA    15,1
         ST    15,T00009
         LA    1,P00037
         L     15,C00038
         BALR  14,15
         LR    2,0
         C     2,C00039
         BC    8,L00015
L00014   DS    0H
         C     2,C00040
         BC    8,L00017
L00016   DS    0H
         LA    1,P00025
         L     15,C00026
         BALR  14,15
         LA    1,P00041
         L     15,C00042
         BALR  14,15
         L     15,C00029
         BALR  14,15
L00018   DS    0H
         LA    1,P00025
         L     15,C00026
         BALR  14,15
         MVC   T00010(4),C00032
         LA    1,P00043
         L     15,C00044
         BALR  14,15
         STE   0,S00000+256
         LE    0,S00000+256
         STE   0,P00035+0
         LA    1,P00035
         L     15,C00036
         BALR  14,15
         MVC   T00011(4),C00032
         LA    1,P00045
         L     15,C00046
         BALR  14,15
         STE   0,S00000+256
         LE    0,S00000+256
         STE   0,P00035+0
         LA    1,P00035
         L     15,C00036
         BALR  14,15
         L     15,C00029
         BALR  14,15
         B     L00019
L00015   DS    0H
         LA    1,P00025
         L     15,C00026
         BALR  14,15
         LA    1,P00047
         L     15,C00042
         BALR  14,15
         L     15,C00029
         BALR  14,15
         B     L00018
L00017   DS    0H
         LA    1,P00025
         L     15,C00026
         BALR  14,15
         LA    1,P00048
         L     15,C00042
         BALR  14,15
         L     15,C00029
         BALR  14,15
         B     L00018
L00019   DS    0H
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
T00004   DS    XL4
         DS    XL4
T00005   DS    XL4
         DS    XL4
T00006   DS    XL4
         DS    XL4
T00007   DS    XL4
         DS    XL4
T00008   DS    XL4
         DS    XL4
T00009   DS    XL4
         DS    XL4
T00010   DS    XL8
T00011   DS    XL8
T00012   DS    XL12
         DS    XL4
         DS    1D
P00023   DC    A(T00012)
         DC    XL1'80',AL3(T00004)
P00025   DC    F'6'
         DC    F'0'
P00027   DC    A(0)
P00030   DC    A(T00005)
         DC    XL1'80',AL3(T00006)
P00033   DC    A(T00007)
         DC    A(T00008)
         DC    XL1'80',VL3(SQ)
P00035   DC    A(0)
P00037   DC    XL1'80',AL3(T00009)
P00041   DC    A(Q00001)
         DC    F'4'
P00043   DC    XL1'80',AL3(T00010)
P00045   DC    XL1'80',AL3(T00011)
P00047   DC    A(Q00002)
         DC    F'4'
P00048   DC    A(Q00003)
         DC    F'4'
C00024   DC    V(SUB)
C00026   DC    V(F77WRBEG)
C00028   DC    V(F77WRI)
C00029   DC    V(F77WREND)
C00031   DC    V(E1)
C00032   DC    X'41200000'
C00034   DC    V(E2)
C00036   DC    V(F77WRR)
C00038   DC    V(E3)
C00039   DC    F'1'
C00040   DC    F'2'
C00042   DC    V(F77WRA)
C00044   DC    V(RF)
C00046   DC    V(EF)
Q00001   DC    C'FELL'
Q00002   DC    C'ALT1'
Q00003   DC    C'ALT2'
* SUB
SUB      CSECT
         USING *,15
         B     L00058
         DC    AL1(3),CL7'SUB'
L00058   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00059
L00060   DC    A(S00049)
L00059   L     15,L00060
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00049,13
         ST    1,S00049+72
L00050   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         L     2,0(,4)
         A     2,C00061
         ST    2,0(,3)
         LA    0,0
         B     L00057
L00051   DS    0H
L00052   DS    0H
L00053   DS    0H
L00054   DS    0H
L00055   DS    0H
L00056   DS    0H
L00057   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00049   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00061   DC    F'10'
* SQ
SQ       CSECT
         USING *,15
         B     L00065
         DC    AL1(2),CL7'SQ'
L00065   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00066
L00067   DC    A(S00062)
L00066   L     15,L00067
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00062,13
         ST    1,S00062+72
L00063   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         LE    0,0(,2)
         MER   0,0
L00064   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00062   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
* RF
RF       CSECT
         USING *,15
         B     L00072
         DC    AL1(2),CL7'RF'
L00072   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00073
L00074   DC    A(S00068)
L00073   L     15,L00074
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00068,13
         ST    1,S00068+72
L00069   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         LE    0,C00075
         AE    0,0(,2)
         B     L00071
L00070   DS    0H
L00071   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00068   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00075   DC    X'41100000'
* E1
E1       CSECT
         USING *,15
         B     L00087
         DC    AL1(2),CL7'E1'
L00087   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00088
L00089   DC    A(S00076)
L00088   L     15,L00089
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00076,13
         ST    1,S00076+72
L00077   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
L00078   DS    0H
         L     2,0(,4)
         LR    1,2
         M     0,C00090
         LR    2,1
         ST    2,0(,3)
         LA    0,0
         B     L00086
L00079   DS    0H
L00080   DS    0H
L00081   DS    0H
L00082   DS    0H
L00083   DS    0H
L00084   DS    0H
L00085   DS    0H
L00086   DS    0H
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
C00090   DC    F'100'
* E2
E2       CSECT
         USING *,15
         B     L00102
         DC    AL1(2),CL7'E2'
L00102   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00103
L00104   DC    A(S00091)
L00103   L     15,L00104
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00091,13
         ST    1,S00091+72
L00092   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         L     2,8(,1)
         LA    2,0(,2)
L00093   DS    0H
         LR    0,4
         ST    0,P00105+0
         OI    P00105+0,X'80'
         LA    1,P00105
         LR    15,2
         BALR  14,15
         AE    0,C00106
         STE   0,0(,3)
         LA    0,0
         B     L00101
L00094   DS    0H
L00095   DS    0H
L00096   DS    0H
L00097   DS    0H
L00098   DS    0H
L00099   DS    0H
L00100   DS    0H
L00101   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00091   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00105   DC    XL1'80',AL3(0)
         DS    XL4
C00106   DC    X'40800000'
* E3
E3       CSECT
         USING *,15
         B     L00118
         DC    AL1(2),CL7'E3'
L00118   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00119
L00120   DC    A(S00107)
L00119   L     15,L00120
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00107,13
         ST    1,S00107+72
L00108   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
L00109   DS    0H
         L     2,0(,3)
         C     2,C00121
         BC    8,L00114
L00115   DS    0H
         LA    0,1
         B     L00117
L00110   DS    0H
L00111   DS    0H
L00112   DS    0H
L00113   DS    0H
L00114   DS    0H
         LA    0,2
         B     L00117
L00116   DS    0H
L00117   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00107   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00121   DC    F'1'
* EF
EF       CSECT
         USING *,15
         B     L00128
         DC    AL1(2),CL7'EF'
L00128   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00129
L00130   DC    A(S00122)
L00129   L     15,L00130
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00122,13
         ST    1,S00122+72
L00123   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
L00124   DS    0H
         LE    0,C00131
         AE    0,0(,2)
         B     L00127
L00125   DS    0H
L00126   DS    0H
L00127   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00122   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00131   DC    X'41200000'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
