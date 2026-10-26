* main
F77MAIN  CSECT
         USING *,15
         B     L00051
         DC    AL1(7),CL7'F77MAIN'
L00051   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00052
L00053   DC    A(S00000)
L00052   L     15,L00053
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00018   DS    0H
         LA    1,P00054
         L     15,C00055
         BALR  14,15
         LA    1,P00056
         L     15,C00057
         BALR  14,15
         LA    1,P00058
         L     15,C00057
         BALR  14,15
         L     15,C00059
         BALR  14,15
L00019   DS    0H
         L     2,T00007
         C     2,C00060
         BC    7,L00020
L00021   DS    0H
         L     2,T00008
         C     2,C00061
         BC    7,L00022
L00023   DS    0H
         LA    1,P00062
         L     15,C00055
         BALR  14,15
         LA    1,P00063
         L     15,C00064
         BALR  14,15
         LA    1,P00065
         L     15,C00066
         BALR  14,15
         L     15,C00059
         BALR  14,15
L00024   DS    0H
         LD    0,T00016
         SD    0,C00067
         LPDR  0,0
         LD    2,C00068
         CDR   2,0
         BC    4,L00025
L00026   DS    0H
         LE    0,T00012
         SE    0,C00069
         LPER  0,0
         LE    2,C00070
         CER   2,0
         BC    4,L00027
L00028   DS    0H
         LA    1,P00071
         L     15,C00055
         BALR  14,15
         LA    1,P00072
         L     15,C00064
         BALR  14,15
         LA    1,P00073
         L     15,C00066
         BALR  14,15
         L     15,C00059
         BALR  14,15
L00029   DS    0H
         LD    0,T00017
         LD    2,C00074
         LCDR  2,2
         SDR   0,2
         LPDR  0,0
         LD    2,C00068
         CDR   2,0
         BC    4,L00030
L00031   DS    0H
         LE    0,T00013
         SE    0,C00075
         LPER  0,0
         LE    2,C00070
         CER   2,0
         BC    4,L00032
L00033   DS    0H
         LA    1,P00076
         L     15,C00055
         BALR  14,15
         LA    1,P00077
         L     15,C00057
         BALR  14,15
         LA    1,P00078
         L     15,C00057
         BALR  14,15
         LA    1,P00079
         L     15,C00057
         BALR  14,15
         L     15,C00059
         BALR  14,15
L00034   DS    0H
         L     3,T00014
         LTR   3,3
         LA    2,1
         BC    8,L00080
         SR    2,2
L00080   DS    0H
         LTR   2,2
         BC    7,L00035
L00036   DS    0H
         L     2,T00009
         C     2,C00081
         BC    7,L00037
L00038   DS    0H
         L     2,T00015
         LTR   2,2
         BC    7,L00039
L00040   DS    0H
         LA    1,P00082
         L     15,C00055
         BALR  14,15
         LA    1,P00083
         L     15,C00057
         BALR  14,15
         LA    1,P00084
         L     15,C00057
         BALR  14,15
         LA    1,P00056
         L     15,C00057
         BALR  14,15
         L     15,C00059
         BALR  14,15
L00041   DS    0H
         L     2,T00010
         C     2,C00085
         BC    7,L00042
L00043   DS    0H
         L     2,T00011
         C     2,C00086
         BC    7,L00044
L00045   DS    0H
         L     2,T00007
         C     2,C00087
         BC    7,L00046
L00047   DS    0H
         LA    1,P00088
         L     15,C00089
         BALR  14,15
         L     3,T00010
         LR    0,3
         ST    0,P00090+0
         LA    1,P00090
         L     15,C00091
         BALR  14,15
         L     3,T00011
         LR    0,3
         ST    0,P00090+0
         LA    1,P00090
         L     15,C00091
         BALR  14,15
         LD    0,T00016
         STD   0,S00000+280
         LD    0,S00000+280
         STD   0,P00092+0
         LA    1,P00092
         L     15,C00093
         BALR  14,15
         L     15,C00094
         BALR  14,15
L00048   DS    0H
         LA    1,P00095
         L     15,C00096
         BALR  14,15
         B     L00050
L00020   DS    0H
         LA    1,P00097
         L     15,C00096
         BALR  14,15
         B     L00050
L00022   DS    0H
         LA    1,P00098
         L     15,C00096
         BALR  14,15
         B     L00050
L00025   DS    0H
         LA    1,P00099
         L     15,C00096
         BALR  14,15
         B     L00050
L00027   DS    0H
         LA    1,P00100
         L     15,C00096
         BALR  14,15
         B     L00050
L00030   DS    0H
         LA    1,P00101
         L     15,C00096
         BALR  14,15
         B     L00050
L00032   DS    0H
         LA    1,P00102
         L     15,C00096
         BALR  14,15
         B     L00050
L00035   DS    0H
         LA    1,P00103
         L     15,C00096
         BALR  14,15
         B     L00050
L00037   DS    0H
         LA    1,P00104
         L     15,C00096
         BALR  14,15
         B     L00050
L00039   DS    0H
         LA    1,P00105
         L     15,C00096
         BALR  14,15
         B     L00050
L00042   DS    0H
         LA    1,P00106
         L     15,C00096
         BALR  14,15
         B     L00050
L00044   DS    0H
         LA    1,P00107
         L     15,C00096
         BALR  14,15
         B     L00050
L00046   DS    0H
         LA    1,P00108
         L     15,C00096
         BALR  14,15
         B     L00050
L00049   DS    0H
L00050   DS    0H
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
T00007   DS    XL8
T00008   DS    XL8
T00009   DS    XL8
T00010   DS    XL8
T00011   DS    XL8
T00012   DS    XL8
T00013   DS    XL8
T00014   DS    XL8
T00015   DS    XL8
T00016   DS    XL12
         DS    XL4
T00017   DS    XL12
         DS    XL4
         DS    1D
P00054   DC    F'5'
         DC    A(Q00001)
         DC    F'0'
P00056   DC    A(T00007)
P00058   DC    A(T00008)
P00062   DC    F'5'
         DC    A(Q00002)
         DC    F'0'
P00063   DC    A(T00016)
P00065   DC    A(T00012)
P00071   DC    F'5'
         DC    A(Q00003)
         DC    F'0'
P00072   DC    A(T00017)
P00073   DC    A(T00013)
P00076   DC    F'5'
         DC    A(Q00004)
         DC    F'0'
P00077   DC    A(T00014)
P00078   DC    A(T00009)
P00079   DC    A(T00015)
P00082   DC    F'5'
         DC    A(Q00005)
         DC    F'0'
P00083   DC    A(T00010)
P00084   DC    A(T00011)
P00088   DC    F'6'
         DC    A(Q00006)
P00090   DC    A(0)
         DS    F
P00092   DC    A(0)
         DC    A(0)
P00095   DC    F'0'
P00097   DC    F'1'
P00098   DC    F'2'
P00099   DC    F'3'
P00100   DC    F'4'
P00101   DC    F'5'
P00102   DC    F'6'
P00103   DC    F'7'
P00104   DC    F'8'
P00105   DC    F'9'
P00106   DC    F'10'
P00107   DC    F'11'
P00108   DC    F'12'
         DS    XL4
C00067   DC    X'43138C0000000000'
C00068   DC    X'3944B82FA09B5A53'
C00074   DC    X'427D000000000000'
C00055   DC    V(F77RDBEG)
C00057   DC    V(F77RDI)
C00059   DC    V(F77RDEND)
C00060   DC    F'123'
C00061   DC    F'-45'
C00064   DC    V(F77RDD)
C00066   DC    V(F77RDR)
C00069   DC    X'41C570A4'
C00070   DC    X'3D68DB8C'
C00075   DC    X'42190000'
C00081   DC    F'77'
C00085   DC    F'11'
C00086   DC    F'22'
C00087   DC    F'33'
C00089   DC    V(F77WRBEG)
C00091   DC    V(F77WRI)
C00093   DC    V(F77WRD)
C00094   DC    V(F77WREND)
C00096   DC    V(EXIT)
Q00001   DC    C'(I4,2X,I4)'
Q00002   DC    C'(F8.2,F6.2)'
Q00003   DC    C'(E10.3,1X,D9.2)'
Q00004   DC    C'(L2,I3,/,L4)'
Q00005   DC    C'(I3,I3)'
Q00006   DC    C'(''OK'',I4,I4,F10.2)'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
