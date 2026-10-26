* main
F77MAIN  CSECT
         USING *,15
         B     L00043
         DC    AL1(7),CL7'F77MAIN'
L00043   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00044
L00045   DC    A(S00000)
L00044   L     15,L00045
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00002   DS    0H
L00003   DS    0H
         LA    10,10
         LA    11,50
         LA    2,10
         LA    3,40
L00004   DS    0H
L00006   DS    0H
         LA    7,T00001-48
         LA    8,8
         AR    7,3
         LA    9,40
         LA    4,8
         LA    5,1
L00007   DS    0H
         LR    6,5
         AR    6,2
         LR    0,6
         X     0,C00046
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00047
         STD   0,0(4,7)
L00009   DS    0H
         A     5,C00048
         BXLE  4,8,L00007
L00008   DS    0H
L00010   DS    0H
         A     3,C00049
         BXLE  2,10,L00004
L00005   DS    0H
L00012   DS    0H
         LA    6,40
         LA    7,200
         LA    2,40
         LA    3,8
         LD    0,C00050
L00013   DS    0H
         LR    4,2
         AH    4,C00051
         AR    4,3
         AD    0,T00001-8(4)
L00015   DS    0H
         A     3,C00052
         BXLE  2,6,L00013
L00014   DS    0H
L00011   DS    0H
         CD    0,C00053
         LA    3,1
         BC    8,L00054
         SR    3,3
L00054   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00055
         SR    2,2
L00055   DS    0H
         LTR   2,2
         BC    7,L00016
L00017   DS    0H
L00019   DS    0H
         LA    6,40
         LA    7,120
         LA    2,40
         LA    3,8
         LD    0,C00050
L00020   DS    0H
         LR    4,2
         AH    4,C00051
         AR    4,3
         AD    0,T00001-8(4)
L00022   DS    0H
         A     3,C00052
         BXLE  2,6,L00020
L00021   DS    0H
L00018   DS    0H
         CD    0,C00056
         LA    3,1
         BC    8,L00057
         SR    3,3
L00057   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00058
         SR    2,2
L00058   DS    0H
         LTR   2,2
         BC    7,L00023
L00024   DS    0H
         LD    2,C00059
L00026   DS    0H
         LA    8,40
         LA    9,200
         LA    2,40
L00027   DS    0H
L00029   DS    0H
         LR    3,2
         AH    3,C00051
         LA    4,T00001-8
         LA    6,8
         AR    4,3
         LA    7,40
         LA    3,8
L00030   DS    0H
         LD    0,0(3,4)
         MDR   0,2
         STD   0,0(3,4)
L00032   DS    0H
         BXLE  3,6,L00030
L00031   DS    0H
L00033   DS    0H
         BXLE  2,8,L00027
L00028   DS    0H
L00025   DS    0H
L00035   DS    0H
         LA    6,40
         LA    7,200
         LA    2,40
         LA    3,8
         LD    0,C00050
L00036   DS    0H
         LR    4,2
         AH    4,C00051
         AR    4,3
         AD    0,T00001-8(4)
L00038   DS    0H
         A     3,C00052
         BXLE  2,6,L00036
L00037   DS    0H
L00034   DS    0H
         CD    0,C00060
         LA    3,1
         BC    8,L00061
         SR    3,3
L00061   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00062
         SR    2,2
L00062   DS    0H
         LTR   2,2
         BC    7,L00039
L00040   DS    0H
         LA    1,P00063
         L     15,C00064
         BALR  14,15
         B     L00042
L00016   DS    0H
         LA    1,P00065
         L     15,C00064
         BALR  14,15
         B     L00042
L00023   DS    0H
         LA    1,P00066
         L     15,C00064
         BALR  14,15
         B     L00042
L00039   DS    0H
         LA    1,P00067
         L     15,C00064
         BALR  14,15
         B     L00042
L00041   DS    0H
L00042   DS    0H
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
T00001   DS    XL204
         DS    XL4
P00063   DC    F'0'
P00065   DC    F'111'
P00066   DC    F'112'
P00067   DC    F'113'
C00047   DC    X'4E00000080000000'
C00050   DC    X'0000000000000000'
C00053   DC    X'42A5000000000000'
C00056   DC    X'4242000000000000'
C00059   DC    X'4120000000000000'
C00060   DC    X'4314A00000000000'
C00046   DC    F'-2147483648'
C00048   DC    F'1'
C00049   DC    F'40'
C00052   DC    F'8'
C00064   DC    V(EXIT)
C00051   DC    H'-40'
* DIAG
DIAG     CSECT
         USING *,15
         B     L00076
         DC    AL1(4),CL7'DIAG'
L00076   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00077
L00078   DC    A(S00068)
L00077   L     15,L00078
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00068,13
         ST    1,S00068+72
L00069   DS    0H
         L     5,0(,1)
         L     3,4(,1)
         L     2,8(,1)
         L     9,12(,1)
         LA    9,0(,9)
         L     8,0(,3)
         S     8,C00079
         AH    8,C00080
         MVC   0(8,9),C00081
         L     3,0(,2)
         S     3,C00079
         A     3,C00079
L00070   DS    0H
         AH    5,C00082
         LA    6,8
         LR    2,3
         SLL   2,3
         LA    7,0
         AR    7,2
         C     3,C00083
         BC    2,L00084
         B     L00072
L00084   DS    0H
         LA    2,8
         LA    3,1
         B     L00071
L00072   DS    0H
         LA    0,0
         B     L00075
L00071   DS    0H
         LD    0,0(,9)
         LR    4,3
         AH    4,C00085
         LR    1,4
         MR    0,8
         LR    4,1
         SLL   4,3
         AR    4,2
         AD    0,0(4,5)
         STD   0,0(,9)
L00073   DS    0H
         A     3,C00079
         BXLE  2,6,L00071
         B     L00072
L00074   DS    0H
L00075   DS    0H
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
C00081   DC    X'0000000000000000'
C00079   DC    F'1'
C00083   DC    F'0'
C00080   DC    H'1'
C00082   DC    H'-8'
C00085   DC    H'-1'
* SCALE
SCALE    CSECT
         USING *,15
         B     L00098
         DC    AL1(5),CL7'SCALE'
L00098   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00099
L00100   DC    A(S00086)
L00099   L     15,L00100
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00086,13
         ST    1,S00086+72
L00087   DS    0H
         L     14,0(,1)
         ST    14,S00086+176
         L     2,4(,1)
         L     14,8(,1)
         ST    14,S00086+184
         L     11,12(,1)
         LA    11,0(,11)
         L     14,0(,2)
         ST    14,S00086+192
         LA    8,1
         L     14,S00086+192
         SR    14,8
         ST    14,S00086+200
         L     14,S00086+200
         AH    14,C00101
         ST    14,S00086+192
         L     15,S00086+184
         L     14,0(,15)
         ST    14,S00086+200
         L     14,S00086+200
         SR    14,8
         ST    14,S00086+208
         L     14,S00086+208
         AR    14,8
         ST    14,S00086+200
L00088   DS    0H
         L     15,S00086+184
         L     14,0(,15)
         ST    14,S00086+208
         L     14,S00086+208
         S     14,C00102
         ST    14,S00086+184
         L     14,S00086+184
         A     14,C00102
         ST    14,S00086+208
         L     14,S00086+208
         C     14,C00103
         LA    10,1
         BC    2,L00104
         SR    10,10
L00104   DS    0H
         L     14,S00086+200
         SLL   14,0
         ST    14,S00086+184
         LA    9,0
         A     9,S00086+184
         L     5,S00086+176
         AH    5,C00105
         L     14,S00086+208
         SLL   14,3
         ST    14,S00086+176
         LA    7,0
         A     7,S00086+176
         L     14,S00086+200
         C     14,C00103
         BC    2,L00106
         B     L00090
L00106   DS    0H
         LR    2,8
         B     L00089
L00090   DS    0H
         LA    0,0
         B     L00097
L00089   DS    0H
L00091   DS    0H
         LR    3,2
         AH    3,C00107
         LR    1,3
         M     0,S00086+192
         LR    3,1
         SLL   3,3
         LD    2,0(,11)
         LA    6,8
         LR    4,5
         AR    4,3
         LTR   10,10
         BC    7,L00108
         B     L00093
L00108   DS    0H
         LA    3,8
         B     L00092
L00093   DS    0H
L00095   DS    0H
         BXLE  2,8,L00089
         B     L00090
L00092   DS    0H
         LD    0,0(3,4)
         MDR   0,2
         STD   0,0(3,4)
L00094   DS    0H
         BXLE  3,6,L00092
         B     L00093
L00096   DS    0H
L00097   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00086   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
         DS    5D
C00102   DC    F'1'
C00103   DC    F'0'
C00101   DC    H'1'
C00105   DC    H'-8'
C00107   DC    H'-1'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
