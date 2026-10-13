* main
F77MAIN  CSECT
         USING *,15
         B     L00042
         DC    AL1(7),CL7'F77MAIN'
L00042   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00043
L00044   DC    A(S00000)
L00043   L     15,L00044
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00006   DS    0H
L00008   DS    0H
         L     5,C00046
         AH    5,C00047
         L     14,C00046
         LE    0,0(,14)
         SE    0,C00048
         LPER  0,0
         LE    2,C00049
         CER   2,0
         BC    4,L00009
L00010   DS    0H
         LE    0,20(,5)
         SE    0,C00048
         LPER  0,0
         LE    2,C00049
         CER   2,0
         BC    4,L00011
L00012   DS    0H
         L     6,C00051
         AH    6,C00047
         L     14,C00051
         L     2,0(,14)
         C     2,C00052
         BC    7,L00013
L00014   DS    0H
         L     2,12(,6)
         C     2,C00053
         BC    7,L00015
L00016   DS    0H
         L     4,C00055
         AH    4,C00056
         LE    0,C00057
         L     15,C00055
         AE    0,0(,15)
         LPER  0,0
         LE    2,C00049
         CER   2,0
         BC    4,L00017
L00018   DS    0H
         LE    0,20(,4)
         SE    0,C00057
         LPER  0,0
         LE    2,C00049
         CER   2,0
         BC    4,L00019
L00020   DS    0H
         L     14,C00058
         LE    0,0(,14)
         LPER  0,0
         LE    2,C00049
         CER   2,0
         BC    4,L00021
L00022   DS    0H
         L     14,C00060
         LD    0,0(,14)
         SD    0,C00061
         LPDR  0,0
         LD    2,C00062
         CDR   2,0
         BC    4,L00023
L00024   DS    0H
         LE    0,C00063
         SE    0,C00063
         LPER  0,0
         LE    2,C00064
         CER   2,0
         BC    4,L00025
L00026   DS    0H
         LD    0,C00065
         MD    0,C00066
         SD    0,C00067
         LPDR  0,0
         LD    2,C00062
         CDR   2,0
         BC    4,L00027
L00028   DS    0H
         LA    0,T00005
         ST    0,P00068+0
         OI    P00068+0,X'80'
         LA    1,P00068
         L     15,C00069
         BALR  14,15
         LA    0,T00003
         ST    0,P00068+0
         OI    P00068+0,X'80'
         LA    1,P00068
         L     15,C00069
         BALR  14,15
         LA    0,T00004
         ST    0,P00068+0
         OI    P00068+0,X'80'
         LA    1,P00068
         L     15,C00069
         BALR  14,15
         L     2,T00005
         C     2,C00070
         BC    7,L00029
L00030   DS    0H
         L     2,T00003
         C     2,C00071
         BC    7,L00031
L00032   DS    0H
         L     2,T00004
         C     2,C00072
         BC    7,L00033
L00034   DS    0H
         LA    15,6
         ST    15,T00005
L00035   DS    0H
         L     2,T00005
         C     2,C00073
         BC    7,L00036
L00037   DS    0H
         LA    0,6
         ST    0,P00068+0
         L     0,C00074
         ST    0,P00068+4
         LA    1,P00068
         L     15,C00075
         BALR  14,15
         LA    0,11
         ST    0,P00068+0
         LA    1,P00068
         L     15,C00076
         BALR  14,15
         L     3,8(,6)
         LR    0,3
         ST    0,P00068+0
         LA    1,P00068
         L     15,C00076
         BALR  14,15
         L     3,T00004
         LR    0,3
         ST    0,P00068+0
         LA    1,P00068
         L     15,C00076
         BALR  14,15
         L     15,C00077
         BALR  14,15
L00038   DS    0H
         LA    0,6
         ST    0,P00068+0
         L     0,C00078
         ST    0,P00068+4
         LA    1,P00068
         L     15,C00075
         BALR  14,15
         LE    0,12(,5)
         STE   0,S00000+328
         LE    0,S00000+328
         STE   0,P00068+0
         LA    1,P00068
         L     15,C00079
         BALR  14,15
         LE    0,20(,4)
         STE   0,S00000+328
         LE    0,S00000+328
         STE   0,P00068+0
         LA    1,P00068
         L     15,C00079
         BALR  14,15
         L     14,C00060
         LD    0,0(,14)
         STD   0,S00000+328
         LD    0,S00000+328
         STD   0,P00068+0
         LA    1,P00068
         L     15,C00080
         BALR  14,15
         L     15,C00077
         BALR  14,15
L00039   DS    0H
         LA    0,0
         ST    0,P00068+0
         LA    1,P00068
         L     15,C00081
         BALR  14,15
         B     L00041
L00007   DS    0H
L00009   DS    0H
         LA    0,2
         ST    0,P00068+0
         LA    1,P00068
         L     15,C00081
         BALR  14,15
         B     L00041
L00011   DS    0H
         LA    0,3
         ST    0,P00068+0
         LA    1,P00068
         L     15,C00081
         BALR  14,15
         B     L00041
L00013   DS    0H
         LA    0,4
         ST    0,P00068+0
         LA    1,P00068
         L     15,C00081
         BALR  14,15
         B     L00041
L00015   DS    0H
         LA    0,5
         ST    0,P00068+0
         LA    1,P00068
         L     15,C00081
         BALR  14,15
         B     L00041
L00017   DS    0H
         LA    0,6
         ST    0,P00068+0
         LA    1,P00068
         L     15,C00081
         BALR  14,15
         B     L00041
L00019   DS    0H
         LA    0,7
         ST    0,P00068+0
         LA    1,P00068
         L     15,C00081
         BALR  14,15
         B     L00041
L00021   DS    0H
         LA    0,8
         ST    0,P00068+0
         LA    1,P00068
         L     15,C00081
         BALR  14,15
         B     L00041
L00023   DS    0H
         LA    0,9
         ST    0,P00068+0
         LA    1,P00068
         L     15,C00081
         BALR  14,15
         B     L00041
L00025   DS    0H
         LA    0,10
         ST    0,P00068+0
         LA    1,P00068
         L     15,C00081
         BALR  14,15
         B     L00041
L00027   DS    0H
         LA    0,11
         ST    0,P00068+0
         LA    1,P00068
         L     15,C00081
         BALR  14,15
         B     L00041
L00029   DS    0H
         LA    0,12
         ST    0,P00068+0
         LA    1,P00068
         L     15,C00081
         BALR  14,15
         B     L00041
L00031   DS    0H
         LA    0,13
         ST    0,P00068+0
         LA    1,P00068
         L     15,C00081
         BALR  14,15
         B     L00041
L00033   DS    0H
         LA    0,14
         ST    0,P00068+0
         LA    1,P00068
         L     15,C00081
         BALR  14,15
         B     L00041
L00036   DS    0H
         LA    0,15
         ST    0,P00068+0
         LA    1,P00068
         L     15,C00081
         BALR  14,15
         B     L00041
L00040   DS    0H
L00041   DS    0H
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
T00003   DS    XL8
T00004   DS    XL8
T00005   DS    XL132
         DS    XL4
         DS    1D
P00068   DS    2F
C00061   DC    X'4128000000000000'
C00062   DC    X'3944B82FA09B5A52'
C00065   DC    X'413243F6A8885A21'
C00066   DC    X'4120000000000000'
C00067   DC    X'416487ED5110B443'
C00046   DC    A(G00045)
C00048   DC    X'41180000'
C00049   DC    X'3D68DB8B'
C00051   DC    A(G00050)
C00052   DC    F'10'
C00053   DC    F'30'
C00055   DC    A(G00054)
C00057   DC    X'41280000'
C00058   DC    A(G00054+20)
C00060   DC    A(G00059)
C00063   DC    X'40400000'
C00064   DC    X'3C10C6F7'
C00069   DC    V(TICK)
C00070   DC    F'101'
C00071   DC    F'102'
C00072   DC    F'103'
C00073   DC    F'6'
C00074   DC    A(Q00001)
C00075   DC    V(F77WRBEG)
C00076   DC    V(F77WRI)
C00077   DC    V(F77WREND)
C00078   DC    A(Q00002)
C00079   DC    V(F77WRR)
C00080   DC    V(F77WRD)
C00081   DC    V(EXIT)
C00047   DC    H'-4'
C00056   DC    H'20'
Q00001   DC    C'(''OK'',3I5)'
Q00002   DC    C'(3F8.2)'
* TICK
TICK     CSECT
         USING *,15
         B     L00086
         DC    AL1(4),CL7'TICK'
L00086   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00087
L00088   DC    A(S00082)
L00087   L     15,L00088
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00082,13
         ST    1,S00082+72
L00083   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     14,C00090
         L     2,0(,14)
         A     2,C00091
         L     14,C00090
         ST    2,0(,14)
         ST    2,0(,3)
         LA    0,0
         B     L00085
L00084   DS    0H
L00085   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00082   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00090   DC    A(G00089)
C00091   DC    F'1'
* ADDT
ADDT     CSECT
         USING *,15
         B     L00096
         DC    AL1(4),CL7'ADDT'
L00096   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00097
L00098   DC    A(S00092)
L00097   L     15,L00098
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00092,13
         ST    1,S00092+72
L00093   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         L     2,0(,4)
         A     2,C00099
         ST    2,0(,3)
         LA    0,0
         B     L00095
L00094   DS    0H
L00095   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00092   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00099   DC    F'1'
G00045   CSECT
         DS    0D
         DC    X'4118000041180000411800004118000041180000'
G00054   CSECT
         DS    0D
         DC    X'C12800000000000000000000000000000000000000000000'
         DC    X'0000000000000000000000000000000041280000'
G00050   CSECT
         DS    0D
         DC    X'0000000A000000140000001E'
G00059   CSECT
         DS    0D
         DC    X'4128000000000000'
G00089   CSECT
         DS    0D
         DC    X'00000064'
         END
