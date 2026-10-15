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
         L     14,C00046
         LE    0,0(,14)
         SE    0,C00047
         LPER  0,0
         LE    2,C00048
         CER   2,0
         BC    4,L00009
L00010   DS    0H
         L     14,C00049
         LE    0,0(,14)
         SE    0,C00047
         LPER  0,0
         LE    2,C00048
         CER   2,0
         BC    4,L00011
L00012   DS    0H
         L     14,C00051
         L     2,0(,14)
         C     2,C00052
         BC    7,L00013
L00014   DS    0H
         L     14,C00053
         L     2,0(,14)
         C     2,C00054
         BC    7,L00015
L00016   DS    0H
         LE    0,C00055
         L     15,C00057
         AE    0,0(,15)
         LPER  0,0
         LE    2,C00048
         CER   2,0
         BC    4,L00017
L00018   DS    0H
         L     14,C00058
         LE    0,0(,14)
         SE    0,C00055
         LPER  0,0
         LE    2,C00048
         CER   2,0
         BC    4,L00019
L00020   DS    0H
         L     14,C00059
         LE    0,0(,14)
         LPER  0,0
         LE    2,C00048
         CER   2,0
         BC    4,L00021
L00022   DS    0H
         L     14,C00061
         LD    0,0(,14)
         SD    0,C00062
         LPDR  0,0
         LD    2,C00063
         CDR   2,0
         BC    4,L00023
L00024   DS    0H
         LE    0,C00064
         SE    0,C00064
         LPER  0,0
         LE    2,C00065
         CER   2,0
         BC    4,L00025
L00026   DS    0H
         LD    0,C00066
         MD    0,C00067
         SD    0,C00068
         LPDR  0,0
         LD    2,C00063
         CDR   2,0
         BC    4,L00027
L00028   DS    0H
         LA    0,T00005
         ST    0,P00069+0
         OI    P00069+0,X'80'
         LA    1,P00069
         L     15,C00070
         BALR  14,15
         LA    0,T00003
         ST    0,P00069+0
         OI    P00069+0,X'80'
         LA    1,P00069
         L     15,C00070
         BALR  14,15
         LA    0,T00004
         ST    0,P00069+0
         OI    P00069+0,X'80'
         LA    1,P00069
         L     15,C00070
         BALR  14,15
         L     2,T00005
         C     2,C00071
         BC    7,L00029
L00030   DS    0H
         L     2,T00003
         C     2,C00072
         BC    7,L00031
L00032   DS    0H
         L     2,T00004
         C     2,C00073
         BC    7,L00033
L00034   DS    0H
         LA    15,6
         ST    15,T00005
L00035   DS    0H
         L     2,T00005
         C     2,C00074
         BC    7,L00036
L00037   DS    0H
         LA    0,6
         ST    0,P00069+0
         L     0,C00075
         ST    0,P00069+4
         LA    1,P00069
         L     15,C00076
         BALR  14,15
         LA    0,11
         ST    0,P00069+0
         LA    1,P00069
         L     15,C00077
         BALR  14,15
         L     14,C00078
         L     3,0(,14)
         LR    0,3
         ST    0,P00069+0
         LA    1,P00069
         L     15,C00077
         BALR  14,15
         L     3,T00004
         LR    0,3
         ST    0,P00069+0
         LA    1,P00069
         L     15,C00077
         BALR  14,15
         L     15,C00079
         BALR  14,15
L00038   DS    0H
         LA    0,6
         ST    0,P00069+0
         L     0,C00080
         ST    0,P00069+4
         LA    1,P00069
         L     15,C00076
         BALR  14,15
         L     14,C00081
         LE    0,0(,14)
         STE   0,S00000+328
         LE    0,S00000+328
         STE   0,P00069+0
         LA    1,P00069
         L     15,C00082
         BALR  14,15
         L     14,C00058
         LE    0,0(,14)
         STE   0,S00000+328
         LE    0,S00000+328
         STE   0,P00069+0
         LA    1,P00069
         L     15,C00082
         BALR  14,15
         L     14,C00061
         LD    0,0(,14)
         STD   0,S00000+328
         LD    0,S00000+328
         STD   0,P00069+0
         LA    1,P00069
         L     15,C00083
         BALR  14,15
         L     15,C00079
         BALR  14,15
L00039   DS    0H
         LA    0,0
         ST    0,P00069+0
         LA    1,P00069
         L     15,C00084
         BALR  14,15
         B     L00041
L00007   DS    0H
L00009   DS    0H
         LA    0,2
         ST    0,P00069+0
         LA    1,P00069
         L     15,C00084
         BALR  14,15
         B     L00041
L00011   DS    0H
         LA    0,3
         ST    0,P00069+0
         LA    1,P00069
         L     15,C00084
         BALR  14,15
         B     L00041
L00013   DS    0H
         LA    0,4
         ST    0,P00069+0
         LA    1,P00069
         L     15,C00084
         BALR  14,15
         B     L00041
L00015   DS    0H
         LA    0,5
         ST    0,P00069+0
         LA    1,P00069
         L     15,C00084
         BALR  14,15
         B     L00041
L00017   DS    0H
         LA    0,6
         ST    0,P00069+0
         LA    1,P00069
         L     15,C00084
         BALR  14,15
         B     L00041
L00019   DS    0H
         LA    0,7
         ST    0,P00069+0
         LA    1,P00069
         L     15,C00084
         BALR  14,15
         B     L00041
L00021   DS    0H
         LA    0,8
         ST    0,P00069+0
         LA    1,P00069
         L     15,C00084
         BALR  14,15
         B     L00041
L00023   DS    0H
         LA    0,9
         ST    0,P00069+0
         LA    1,P00069
         L     15,C00084
         BALR  14,15
         B     L00041
L00025   DS    0H
         LA    0,10
         ST    0,P00069+0
         LA    1,P00069
         L     15,C00084
         BALR  14,15
         B     L00041
L00027   DS    0H
         LA    0,11
         ST    0,P00069+0
         LA    1,P00069
         L     15,C00084
         BALR  14,15
         B     L00041
L00029   DS    0H
         LA    0,12
         ST    0,P00069+0
         LA    1,P00069
         L     15,C00084
         BALR  14,15
         B     L00041
L00031   DS    0H
         LA    0,13
         ST    0,P00069+0
         LA    1,P00069
         L     15,C00084
         BALR  14,15
         B     L00041
L00033   DS    0H
         LA    0,14
         ST    0,P00069+0
         LA    1,P00069
         L     15,C00084
         BALR  14,15
         B     L00041
L00036   DS    0H
         LA    0,15
         ST    0,P00069+0
         LA    1,P00069
         L     15,C00084
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
P00069   DS    2F
C00062   DC    X'4128000000000000'
C00063   DC    X'3944B82FA09B5A53'
C00066   DC    X'413243F6A8885A22'
C00067   DC    X'4120000000000000'
C00068   DC    X'416487ED5110B444'
C00046   DC    A(G00045)
C00047   DC    X'41180000'
C00048   DC    X'3D68DB8C'
C00049   DC    A(G00045+16)
C00051   DC    A(G00050)
C00052   DC    F'10'
C00053   DC    A(G00050+8)
C00054   DC    F'30'
C00055   DC    X'41280000'
C00057   DC    A(G00056)
C00058   DC    A(G00056+40)
C00059   DC    A(G00056+20)
C00061   DC    A(G00060)
C00064   DC    X'40400000'
C00065   DC    X'3C10C6F8'
C00070   DC    V(TICK)
C00071   DC    F'101'
C00072   DC    F'102'
C00073   DC    F'103'
C00074   DC    F'6'
C00075   DC    A(Q00001)
C00076   DC    V(F77WRBEG)
C00077   DC    V(F77WRI)
C00078   DC    A(G00050+4)
C00079   DC    V(F77WREND)
C00080   DC    A(Q00002)
C00081   DC    A(G00045+8)
C00082   DC    V(F77WRR)
C00083   DC    V(F77WRD)
C00084   DC    V(EXIT)
Q00001   DC    C'(''OK'',3I5)'
Q00002   DC    C'(3F8.2)'
* TICK
TICK     CSECT
         USING *,15
         B     L00089
         DC    AL1(4),CL7'TICK'
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
         L     3,0(,1)
         LA    3,0(,3)
         L     14,C00093
         L     2,0(,14)
         A     2,C00094
         L     14,C00093
         ST    2,0(,14)
         ST    2,0(,3)
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
C00093   DC    A(G00092)
C00094   DC    F'1'
* ADDT
ADDT     CSECT
         USING *,15
         B     L00099
         DC    AL1(4),CL7'ADDT'
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
         L     3,4(,1)
         LA    3,0(,3)
         L     2,0(,4)
         A     2,C00102
         ST    2,0(,3)
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
C00102   DC    F'1'
G00045   CSECT
         DS    0D
         DC    X'4118000041180000411800004118000041180000'
G00056   CSECT
         DS    0D
         DC    X'C12800000000000000000000000000000000000000000000'
         DC    X'0000000000000000000000000000000041280000'
G00050   CSECT
         DS    0D
         DC    X'0000000A000000140000001E'
G00060   CSECT
         DS    0D
         DC    X'4128000000000000'
G00092   CSECT
         DS    0D
         DC    X'00000064'
         END
