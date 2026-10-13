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
         L     3,C00028
         AH    3,C00029
         L     14,C00028
         MVC   0(8,14),C00030
         LA    15,30
         L     14,C00031
         ST    15,0(,14)
L00004   DS    0H
         L     5,C00028
         AH    5,C00032
         LE    2,C00033
         LA    6,4
         LA    7,16
         LA    2,4
         LA    4,1
L00005   DS    0H
         LR    0,4
         X     0,C00034
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00035
         LER   0,0
         MER   0,2
         STE   0,0(2,5)
L00007   DS    0H
         A     4,C00036
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
         L     2,C00028
         AH    2,C00032
         LE    0,0(,3)
         SE    0,C00041
         LPER  0,0
         LE    2,C00042
         CER   2,0
         BC    4,L00012
L00013   DS    0H
         LE    0,16(,2)
         SE    0,C00043
         LPER  0,0
         LE    2,C00042
         CER   2,0
         BC    4,L00014
L00015   DS    0H
         LA    15,12
         L     14,C00044
         ST    15,0(,14)
         L     14,C00046
         MVC   0(4,14),C00045
         L     15,C00047
         BALR  14,15
         L     14,C00044
         L     3,0(,14)
         C     3,C00048
         BC    7,L00016
L00017   DS    0H
         L     14,C00046
         LE    0,0(,14)
         SE    0,C00049
         LPER  0,0
         LE    2,C00042
         CER   2,0
         BC    4,L00018
L00019   DS    0H
         LA    0,T00002
         ST    0,P00050+0
         OI    P00050+0,X'80'
         LA    1,P00050
         L     15,C00051
         BALR  14,15
         LA    0,T00002
         ST    0,P00050+0
         OI    P00050+0,X'80'
         LA    1,P00050
         L     15,C00051
         BALR  14,15
         LA    0,T00002
         ST    0,P00050+0
         OI    P00050+0,X'80'
         LA    1,P00050
         L     15,C00051
         BALR  14,15
         L     3,T00002
         C     3,C00052
         BC    7,L00020
L00021   DS    0H
         LA    0,6
         ST    0,P00050+0
         L     0,C00053
         ST    0,P00050+4
         LA    1,P00050
         L     15,C00054
         BALR  14,15
         L     14,C00031
         L     4,0(,14)
         LR    0,4
         ST    0,P00050+0
         LA    1,P00050
         L     15,C00055
         BALR  14,15
         LE    0,4(,2)
         STE   0,S00000+248
         LE    0,S00000+248
         STE   0,P00050+0
         LA    1,P00050
         L     15,C00056
         BALR  14,15
         L     14,C00044
         L     3,0(,14)
         LR    0,3
         ST    0,P00050+0
         LA    1,P00050
         L     15,C00055
         BALR  14,15
         L     15,C00057
         BALR  14,15
L00022   DS    0H
         LA    0,0
         ST    0,P00050+0
         LA    1,P00050
         L     15,C00058
         BALR  14,15
         B     L00024
L00008   DS    0H
         LA    0,1
         ST    0,P00050+0
         LA    1,P00050
         L     15,C00058
         BALR  14,15
         B     L00024
L00010   DS    0H
         LA    0,2
         ST    0,P00050+0
         LA    1,P00050
         L     15,C00058
         BALR  14,15
         B     L00024
L00012   DS    0H
         LA    0,3
         ST    0,P00050+0
         LA    1,P00050
         L     15,C00058
         BALR  14,15
         B     L00024
L00014   DS    0H
         LA    0,4
         ST    0,P00050+0
         LA    1,P00050
         L     15,C00058
         BALR  14,15
         B     L00024
L00016   DS    0H
         LA    0,5
         ST    0,P00050+0
         LA    1,P00050
         L     15,C00058
         BALR  14,15
         B     L00024
L00018   DS    0H
         LA    0,6
         ST    0,P00050+0
         LA    1,P00050
         L     15,C00058
         BALR  14,15
         B     L00024
L00020   DS    0H
         LA    0,7
         ST    0,P00050+0
         LA    1,P00050
         L     15,C00058
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
P00050   DS    2F
C00030   DC    X'4128000000000000'
C00035   DC    X'4E00000080000000'
C00038   DC    X'4150000000000000'
C00039   DC    X'3944B82FA09B5A52'
C00028   DC    A(MIX)
C00031   DC    A(MIX+8)
C00033   DC    X'41140000'
C00034   DC    F'-2147483648'
C00036   DC    F'1'
C00037   DC    V(PEEK)
C00040   DC    F'61'
C00041   DC    X'42654000'
C00042   DC    X'3D68DB8B'
C00043   DC    X'41500000'
C00044   DC    A(#BLANK)
C00045   DC    X'40C00000'
C00046   DC    A(#BLANK+4)
C00047   DC    V(BLANKQ)
C00048   DC    F'24'
C00049   DC    X'41180000'
C00051   DC    V(STEPS)
C00052   DC    F'33'
C00053   DC    A(Q00001)
C00054   DC    V(F77WRBEG)
C00055   DC    V(F77WRI)
C00056   DC    V(F77WRR)
C00057   DC    V(F77WREND)
C00058   DC    V(EXIT)
C00029   DC    H'12'
C00032   DC    H'8'
Q00001   DC    C'(''OK'',I4,F8.2,I4)'
* PEEK
PEEK     CSECT
         USING *,15
         B     L00065
         DC    AL1(4),CL7'PEEK'
L00065   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00066
L00067   DC    A(S00059)
L00066   L     15,L00067
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00059,13
         ST    1,S00059+72
L00060   DS    0H
         L     14,C00068
         L     2,8(,14)
         C     2,C00069
         BC    7,L00061
L00062   DS    0H
         L     15,C00070
         BALR  14,15
         LA    0,0
         B     L00064
L00061   DS    0H
         LA    0,11
         ST    0,P00071+0
         LA    1,P00071
         L     15,C00072
         BALR  14,15
         LA    0,11
         B     L00064
L00063   DS    0H
L00064   DS    0H
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
P00071   DS    1F
         DS    XL4
C00068   DC    A(MIX)
C00069   DC    F'30'
C00070   DC    V(REMIX)
C00072   DC    V(EXIT)
* REMIX
REMIX    CSECT
         USING *,15
         B     L00077
         DC    AL1(5),CL7'REMIX'
L00077   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00078
L00079   DC    A(S00073)
L00078   L     15,L00079
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00073,13
         ST    1,S00073+72
L00074   DS    0H
         LD    0,C00080
         L     15,C00081
         MD    0,0(,15)
         L     14,C00081
         STD   0,0(,14)
         L     14,C00082
         L     2,0(,14)
         A     2,C00083
         L     14,C00082
         ST    2,0(,14)
         LE    0,C00084
         L     15,C00081
         AE    0,12(,15)
         L     14,C00081
         STE   0,12(,14)
         L     14,C00081
         LE    0,24(,14)
         L     14,C00081
         STE   0,24(,14)
         LA    0,0
         B     L00076
L00075   DS    0H
L00076   DS    0H
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
C00080   DC    X'4120000000000000'
C00081   DC    A(MIX)
C00082   DC    A(MIX+8)
C00083   DC    F'31'
C00084   DC    X'42640000'
* BLANKQ
BLANKQ   CSECT
         USING *,15
         B     L00089
         DC    AL1(6),CL7'BLANKQ'
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
         L     14,C00092
         L     2,0(,14)
         SLL   2,1
         L     14,C00092
         ST    2,0(,14)
         LE    0,C00093
         L     15,C00092
         ME    0,4(,15)
         L     14,C00094
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
C00092   DC    A(#BLANK)
C00093   DC    X'41200000'
C00094   DC    A(#BLANK+4)
* STEPS
STEPS    CSECT
         USING *,15
         B     L00099
         DC    AL1(5),CL7'STEPS'
L00099   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00100
L00101   DC    A(S00095)
L00100   L     15,L00101
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00095,13
         ST    1,S00095+72
L00096   DS    0H
         L     4,0(,1)
         LA    4,0(,4)
         L     14,C00103
         L     2,0(,14)
         A     2,C00104
         L     14,C00103
         ST    2,0(,14)
         L     14,C00106
         L     3,0(,14)
         A     3,C00107
         L     14,C00106
         ST    3,0(,14)
         AR    2,3
         ST    2,0(,4)
         LA    0,0
         B     L00098
L00097   DS    0H
L00098   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00095   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00103   DC    A(G00102)
C00104   DC    F'1'
C00106   DC    A(G00105)
C00107   DC    F'10'
MIX      CSECT
         DS    0D
         DS    XL32
#BLANK   CSECT
         DS    0D
         DS    XL8
G00102   CSECT
         DS    0D
         DS    XL4
G00105   CSECT
         DS    0D
         DS    XL4
         END
