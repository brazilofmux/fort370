* main
F77MAIN  CSECT
         USING *,15
         B     L00025
         DC    AL1(7),CL7'F77MAIN'
L00025   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00026
L00027   DC    A(S00000)
L00026   L     15,L00027
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00003   DS    0H
         L     5,C00028
         AH    5,C00029
         L     14,C00028
         MVC   0(8,14),C00030
         LA    15,30
         L     14,C00031
         ST    15,0(,14)
L00004   DS    0H
         L     4,C00028
         AH    4,C00032
         LE    2,C00033
         LA    6,4
         LA    7,16
         LA    2,4
         LA    3,1
L00005   DS    0H
         LR    0,3
         X     0,C00034
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00035
         LER   0,0
         MER   0,2
         STE   0,0(2,4)
L00007   DS    0H
         A     3,C00036
         BXLE  2,6,L00005
L00006   DS    0H
         L     15,C00037
         BALR  14,15
         L     14,C00028
         LD    0,0(,14)
         SD    0,C00038
         LPDR  0,0
         LD    2,C00039
         CDR   2,0
         BC    4,L00008
L00009   DS    0H
         L     14,C00031
         L     2,0(,14)
         C     2,C00040
         BC    7,L00010
L00011   DS    0H
         L     14,C00041
         LE    0,0(,14)
         SE    0,C00042
         LPER  0,0
         LE    2,C00043
         CER   2,0
         BC    4,L00012
L00013   DS    0H
         L     14,C00044
         LE    0,0(,14)
         SE    0,C00045
         LPER  0,0
         LE    2,C00043
         CER   2,0
         BC    4,L00014
L00015   DS    0H
         LA    15,12
         L     14,C00046
         ST    15,0(,14)
         L     14,C00048
         MVC   0(4,14),C00047
         L     15,C00049
         BALR  14,15
         L     14,C00046
         L     2,0(,14)
         C     2,C00050
         BC    7,L00016
L00017   DS    0H
         L     14,C00048
         LE    0,0(,14)
         SE    0,C00051
         LPER  0,0
         LE    2,C00043
         CER   2,0
         BC    4,L00018
L00019   DS    0H
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         L     2,T00002
         C     2,C00054
         BC    7,L00020
L00021   DS    0H
         LA    1,P00055
         L     15,C00056
         BALR  14,15
         L     14,C00031
         L     3,0(,14)
         LR    0,3
         ST    0,P00057+0
         LA    1,P00057
         L     15,C00058
         BALR  14,15
         L     14,C00041
         LE    0,0(,14)
         STE   0,S00000+248
         LE    0,S00000+248
         STE   0,P00059+0
         LA    1,P00059
         L     15,C00060
         BALR  14,15
         L     14,C00046
         L     3,0(,14)
         LR    0,3
         ST    0,P00057+0
         LA    1,P00057
         L     15,C00058
         BALR  14,15
         L     15,C00061
         BALR  14,15
L00022   DS    0H
         LA    1,P00062
         L     15,C00063
         BALR  14,15
         B     L00024
L00008   DS    0H
         LA    1,P00064
         L     15,C00063
         BALR  14,15
         B     L00024
L00010   DS    0H
         LA    1,P00065
         L     15,C00063
         BALR  14,15
         B     L00024
L00012   DS    0H
         LA    1,P00066
         L     15,C00063
         BALR  14,15
         B     L00024
L00014   DS    0H
         LA    1,P00067
         L     15,C00063
         BALR  14,15
         B     L00024
L00016   DS    0H
         LA    1,P00068
         L     15,C00063
         BALR  14,15
         B     L00024
L00018   DS    0H
         LA    1,P00069
         L     15,C00063
         BALR  14,15
         B     L00024
L00020   DS    0H
         LA    1,P00070
         L     15,C00063
         BALR  14,15
         B     L00024
L00023   DS    0H
L00024   DS    0H
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
T00002   DS    XL72
         DS    1D
P00052   DC    XL1'80',AL3(T00002)
P00055   DC    F'6'
         DC    A(Q00001)
P00057   DC    A(0)
P00059   DC    A(0)
P00062   DC    F'0'
P00064   DC    F'1'
P00065   DC    F'2'
P00066   DC    F'3'
P00067   DC    F'4'
P00068   DC    F'5'
P00069   DC    F'6'
P00070   DC    F'7'
         DS    XL4
C00030   DC    X'4128000000000000'
C00035   DC    X'4E00000080000000'
C00038   DC    X'4150000000000000'
C00039   DC    X'3944B82FA09B5A53'
C00028   DC    A(MIX)
C00031   DC    A(MIX+8)
C00033   DC    X'41140000'
C00034   DC    F'-2147483648'
C00036   DC    F'1'
C00037   DC    V(PEEK)
C00040   DC    F'61'
C00041   DC    A(MIX+12)
C00042   DC    X'42654000'
C00043   DC    X'3D68DB8C'
C00044   DC    A(MIX+24)
C00045   DC    X'41500000'
C00046   DC    A(#BLANK)
C00047   DC    X'40C00000'
C00048   DC    A(#BLANK+4)
C00049   DC    V(BLANKQ)
C00050   DC    F'24'
C00051   DC    X'41180000'
C00053   DC    V(STEPS)
C00054   DC    F'33'
C00056   DC    V(F77WRBEG)
C00058   DC    V(F77WRI)
C00060   DC    V(F77WRR)
C00061   DC    V(F77WREND)
C00063   DC    V(EXIT)
C00029   DC    H'12'
C00032   DC    H'8'
Q00001   DC    C'(''OK'',I4,F8.2,I4)'
* PEEK
PEEK     CSECT
         USING *,15
         B     L00077
         DC    AL1(4),CL7'PEEK'
L00077   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00078
L00079   DC    A(S00071)
L00078   L     15,L00079
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00071,13
         ST    1,S00071+72
L00072   DS    0H
         L     14,C00080
         L     2,0(,14)
         C     2,C00081
         BC    7,L00073
L00074   DS    0H
         L     15,C00082
         BALR  14,15
         LA    0,0
         B     L00076
L00073   DS    0H
         LA    1,P00083
         L     15,C00084
         BALR  14,15
         LA    0,11
         B     L00076
L00075   DS    0H
L00076   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00071   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00083   DC    F'11'
         DS    XL4
C00080   DC    A(MIX+8)
C00081   DC    F'30'
C00082   DC    V(REMIX)
C00084   DC    V(EXIT)
* REMIX
REMIX    CSECT
         USING *,15
         B     L00089
         DC    AL1(5),CL7'REMIX'
L00089   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00090
L00091   DC    A(S00085)
L00090   L     15,L00091
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00085,13
         ST    1,S00085+72
L00086   DS    0H
         LD    0,C00092
         L     15,C00093
         MD    0,0(,15)
         L     14,C00093
         STD   0,0(,14)
         L     14,C00094
         L     2,0(,14)
         A     2,C00095
         L     14,C00094
         ST    2,0(,14)
         LE    0,C00096
         L     15,C00093
         AE    0,12(,15)
         L     14,C00097
         STE   0,0(,14)
         LA    0,0
         B     L00088
L00087   DS    0H
L00088   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00085   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00092   DC    X'4120000000000000'
C00093   DC    A(MIX)
C00094   DC    A(MIX+8)
C00095   DC    F'31'
C00096   DC    X'42640000'
C00097   DC    A(MIX+12)
* BLANKQ
BLANKQ   CSECT
         USING *,15
         B     L00102
         DC    AL1(6),CL7'BLANKQ'
L00102   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00103
L00104   DC    A(S00098)
L00103   L     15,L00104
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00098,13
         ST    1,S00098+72
L00099   DS    0H
         L     14,C00105
         L     2,0(,14)
         SLL   2,1
         L     14,C00105
         ST    2,0(,14)
         LE    0,C00106
         L     15,C00105
         ME    0,4(,15)
         L     14,C00107
         STE   0,0(,14)
         LA    0,0
         B     L00101
L00100   DS    0H
L00101   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00098   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00105   DC    A(#BLANK)
C00106   DC    X'41200000'
C00107   DC    A(#BLANK+4)
* STEPS
STEPS    CSECT
         USING *,15
         B     L00112
         DC    AL1(5),CL7'STEPS'
L00112   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00113
L00114   DC    A(S00108)
L00113   L     15,L00114
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00108,13
         ST    1,S00108+72
L00109   DS    0H
         L     4,0(,1)
         LA    4,0(,4)
         L     14,C00116
         L     2,0(,14)
         A     2,C00117
         L     14,C00116
         ST    2,0(,14)
         L     14,C00119
         L     3,0(,14)
         A     3,C00120
         L     14,C00119
         ST    3,0(,14)
         AR    2,3
         ST    2,0(,4)
         LA    0,0
         B     L00111
L00110   DS    0H
L00111   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00108   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00116   DC    A(G00115)
C00117   DC    F'1'
C00119   DC    A(G00118)
C00120   DC    F'10'
MIX      CSECT
         DS    0D
         DS    XL32
#BLANK   CSECT
         DS    0D
         DS    XL8
G00115   CSECT
         DS    0D
         DS    XL4
G00118   CSECT
         DS    0D
         DS    XL4
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
