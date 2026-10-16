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
         LA    0,T00012
         ST    0,P00023+0
         LA    0,T00004
         ST    0,P00023+4
         OI    P00023+4,X'80'
         LA    1,P00023
         L     15,C00024
         BALR  14,15
         LA    0,6
         ST    0,P00023+0
         LA    0,0
         ST    0,P00023+4
         LA    1,P00023
         L     15,C00025
         BALR  14,15
         L     3,T00004
         LR    0,3
         ST    0,P00023+0
         LA    1,P00023
         L     15,C00026
         BALR  14,15
         L     15,C00027
         BALR  14,15
         LA    15,5
         ST    15,T00005
         LA    0,T00005
         ST    0,P00023+0
         LA    0,T00006
         ST    0,P00023+4
         OI    P00023+4,X'80'
         LA    1,P00023
         L     15,C00028
         BALR  14,15
         LA    0,6
         ST    0,P00023+0
         LA    0,0
         ST    0,P00023+4
         LA    1,P00023
         L     15,C00025
         BALR  14,15
         L     3,T00006
         LR    0,3
         ST    0,P00023+0
         LA    1,P00023
         L     15,C00026
         BALR  14,15
         L     15,C00027
         BALR  14,15
         MVC   T00007(4),C00029
         LA    0,T00007
         ST    0,P00023+0
         LA    0,T00008
         ST    0,P00023+4
         L     0,C00030
         ST    0,P00023+8
         OI    P00023+8,X'80'
         LA    1,P00023
         L     15,C00031
         BALR  14,15
         LA    0,6
         ST    0,P00023+0
         LA    0,0
         ST    0,P00023+4
         LA    1,P00023
         L     15,C00025
         BALR  14,15
         LE    0,T00008
         STE   0,S00000+256
         LE    0,S00000+256
         STE   0,P00023+0
         LA    1,P00023
         L     15,C00032
         BALR  14,15
         L     15,C00027
         BALR  14,15
         LA    15,1
         ST    15,T00009
         LA    0,T00009
         ST    0,P00023+0
         OI    P00023+0,X'80'
         LA    1,P00023
         L     15,C00033
         BALR  14,15
         LR    2,0
         C     2,C00034
         BC    8,L00015
L00014   DS    0H
         C     2,C00035
         BC    8,L00017
L00016   DS    0H
         LA    0,6
         ST    0,P00023+0
         LA    0,0
         ST    0,P00023+4
         LA    1,P00023
         L     15,C00025
         BALR  14,15
         L     0,C00036
         ST    0,P00023+0
         LA    0,4
         ST    0,P00023+4
         LA    1,P00023
         L     15,C00037
         BALR  14,15
         L     15,C00027
         BALR  14,15
L00018   DS    0H
         LA    0,6
         ST    0,P00023+0
         LA    0,0
         ST    0,P00023+4
         LA    1,P00023
         L     15,C00025
         BALR  14,15
         MVC   T00010(4),C00029
         LA    0,T00010
         ST    0,P00023+0
         OI    P00023+0,X'80'
         LA    1,P00023
         L     15,C00038
         BALR  14,15
         STE   0,S00000+256
         LE    0,S00000+256
         STE   0,P00023+0
         LA    1,P00023
         L     15,C00032
         BALR  14,15
         MVC   T00011(4),C00029
         LA    0,T00011
         ST    0,P00023+0
         OI    P00023+0,X'80'
         LA    1,P00023
         L     15,C00039
         BALR  14,15
         STE   0,S00000+256
         LE    0,S00000+256
         STE   0,P00023+0
         LA    1,P00023
         L     15,C00032
         BALR  14,15
         L     15,C00027
         BALR  14,15
         B     L00019
L00015   DS    0H
         LA    0,6
         ST    0,P00023+0
         LA    0,0
         ST    0,P00023+4
         LA    1,P00023
         L     15,C00025
         BALR  14,15
         L     0,C00040
         ST    0,P00023+0
         LA    0,4
         ST    0,P00023+4
         LA    1,P00023
         L     15,C00037
         BALR  14,15
         L     15,C00027
         BALR  14,15
         B     L00018
L00017   DS    0H
         LA    0,6
         ST    0,P00023+0
         LA    0,0
         ST    0,P00023+4
         LA    1,P00023
         L     15,C00025
         BALR  14,15
         L     0,C00041
         ST    0,P00023+0
         LA    0,4
         ST    0,P00023+4
         LA    1,P00023
         L     15,C00037
         BALR  14,15
         L     15,C00027
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
P00023   DS    3F
         DS    XL4
C00024   DC    V(SUB)
C00025   DC    V(F77WRBEG)
C00026   DC    V(F77WRI)
C00027   DC    V(F77WREND)
C00028   DC    V(E1)
C00029   DC    X'41200000'
C00030   DC    V(SQ)
C00031   DC    V(E2)
C00032   DC    V(F77WRR)
C00033   DC    V(E3)
C00034   DC    F'1'
C00035   DC    F'2'
C00036   DC    A(Q00001)
C00037   DC    V(F77WRA)
C00038   DC    V(RF)
C00039   DC    V(EF)
C00040   DC    A(Q00002)
C00041   DC    A(Q00003)
Q00001   DC    C'FELL'
Q00002   DC    C'ALT1'
Q00003   DC    C'ALT2'
* SUB
SUB      CSECT
         USING *,15
         B     L00051
         DC    AL1(3),CL7'SUB'
L00051   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00052
L00053   DC    A(S00042)
L00052   L     15,L00053
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00042,13
         ST    1,S00042+72
L00043   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         L     2,0(,4)
         A     2,C00054
         ST    2,0(,3)
         LA    0,0
         B     L00050
L00044   DS    0H
L00045   DS    0H
L00046   DS    0H
L00047   DS    0H
L00048   DS    0H
L00049   DS    0H
L00050   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00042   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00054   DC    F'10'
* SQ
SQ       CSECT
         USING *,15
         B     L00058
         DC    AL1(2),CL7'SQ'
L00058   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00059
L00060   DC    A(S00055)
L00059   L     15,L00060
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00055,13
         ST    1,S00055+72
L00056   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         LE    0,0(,2)
         MER   0,0
L00057   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00055   DS    0D
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
         B     L00065
         DC    AL1(2),CL7'RF'
L00065   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00066
L00067   DC    A(S00061)
L00066   L     15,L00067
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00061,13
         ST    1,S00061+72
L00062   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         LE    0,C00068
         AE    0,0(,2)
         B     L00064
L00063   DS    0H
L00064   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00061   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00068   DC    X'41100000'
* E1
E1       CSECT
         USING *,15
         B     L00080
         DC    AL1(2),CL7'E1'
L00080   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00081
L00082   DC    A(S00069)
L00081   L     15,L00082
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00069,13
         ST    1,S00069+72
L00070   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
L00071   DS    0H
         L     2,0(,4)
         LR    1,2
         M     0,C00083
         LR    2,1
         ST    2,0(,3)
         LA    0,0
         B     L00079
L00072   DS    0H
L00073   DS    0H
L00074   DS    0H
L00075   DS    0H
L00076   DS    0H
L00077   DS    0H
L00078   DS    0H
L00079   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00069   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00083   DC    F'100'
* E2
E2       CSECT
         USING *,15
         B     L00095
         DC    AL1(2),CL7'E2'
L00095   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00096
L00097   DC    A(S00084)
L00096   L     15,L00097
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00084,13
         ST    1,S00084+72
L00085   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         L     2,8(,1)
         LA    2,0(,2)
L00086   DS    0H
         LR    0,4
         ST    0,P00098+0
         OI    P00098+0,X'80'
         LA    1,P00098
         LR    15,2
         BALR  14,15
         AE    0,C00099
         STE   0,0(,3)
         LA    0,0
         B     L00094
L00087   DS    0H
L00088   DS    0H
L00089   DS    0H
L00090   DS    0H
L00091   DS    0H
L00092   DS    0H
L00093   DS    0H
L00094   DS    0H
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
P00098   DS    1F
         DS    XL4
C00099   DC    X'40800000'
* E3
E3       CSECT
         USING *,15
         B     L00111
         DC    AL1(2),CL7'E3'
L00111   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00112
L00113   DC    A(S00100)
L00112   L     15,L00113
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00100,13
         ST    1,S00100+72
L00101   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
L00102   DS    0H
         L     2,0(,3)
         C     2,C00114
         BC    8,L00107
L00108   DS    0H
         LA    0,1
         B     L00110
L00103   DS    0H
L00104   DS    0H
L00105   DS    0H
L00106   DS    0H
L00107   DS    0H
         LA    0,2
         B     L00110
L00109   DS    0H
L00110   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00100   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00114   DC    F'1'
* EF
EF       CSECT
         USING *,15
         B     L00121
         DC    AL1(2),CL7'EF'
L00121   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00122
L00123   DC    A(S00115)
L00122   L     15,L00123
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00115,13
         ST    1,S00115+72
L00116   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
L00117   DS    0H
         LE    0,C00124
         AE    0,0(,2)
         B     L00120
L00118   DS    0H
L00119   DS    0H
L00120   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00115   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00124   DC    X'41200000'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
