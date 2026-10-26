* main
F77MAIN  CSECT
         USING *,15
         B     L00016
         DC    AL1(7),CL7'F77MAIN'
L00016   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00017
L00018   DC    A(S00000)
L00017   L     15,L00018
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00005   DS    0H
         LA    1,P00019
         L     15,C00020
         BALR  14,15
         LA    1,P00021
         L     15,C00022
         BALR  14,15
         LA    1,P00023
         L     15,C00022
         BALR  14,15
         LA    1,P00024
         L     15,C00022
         BALR  14,15
         LA    1,P00025
         L     15,C00022
         BALR  14,15
         LA    1,P00026
         L     15,C00022
         BALR  14,15
         LA    1,P00027
         L     15,C00022
         BALR  14,15
         LA    1,P00028
         L     15,C00022
         BALR  14,15
         LA    1,P00029
         L     15,C00022
         BALR  14,15
         LA    1,P00030
         L     15,C00022
         BALR  14,15
         L     15,C00031
         BALR  14,15
L00006   DS    0H
         LA    1,P00032
         L     15,C00020
         BALR  14,15
         LA    1,P00033
         L     15,C00034
         BALR  14,15
         LA    1,P00035
         L     15,C00034
         BALR  14,15
         LA    1,P00033
         L     15,C00034
         BALR  14,15
         L     15,C00031
         BALR  14,15
L00007   DS    0H
L00008   DS    0H
         L     11,C00037
         AH    11,C00038
         L     10,C00040
         AH    10,C00038
         L     14,C00042
         AH    14,C00038
         ST    14,S00000+176
         LA    8,4
         LA    9,36
         LA    2,4
L00009   DS    0H
         LA    1,P00043
         L     15,C00020
         BALR  14,15
         L     14,0(2,11)
         ST    14,S00000+184
         L     0,S00000+184
         ST    0,P00044+0
         LA    1,P00044
         L     15,C00022
         BALR  14,15
         L     14,0(2,10)
         ST    14,S00000+184
         L     0,S00000+184
         ST    0,P00044+0
         LA    1,P00044
         L     15,C00022
         BALR  14,15
         L     15,S00000+176
         L     14,0(2,15)
         ST    14,S00000+184
         L     0,S00000+184
         ST    0,P00044+0
         LA    1,P00044
         L     15,C00022
         BALR  14,15
         L     3,0(2,11)
         L     4,0(2,10)
         LR    14,3
         SLL   14,0(4)
         ST    14,S00000+184
         LCR   14,4
         ST    14,S00000+192
         L     15,S00000+192
         SRL   3,0(15)
         C     4,C00045
         LA    14,1
         BC    10,L00046
         SR    14,14
L00046   DS    0H
         ST    14,S00000+192
         L     14,S00000+192
         LCR   14,14
         ST    14,S00000+200
         L     14,S00000+184
         XR    14,3
         ST    14,S00000+192
         L     14,S00000+192
         N     14,S00000+200
         ST    14,S00000+184
         LR    14,3
         X     14,S00000+184
         ST    14,S00000+192
         L     0,S00000+192
         ST    0,P00044+0
         LA    1,P00044
         L     15,C00022
         BALR  14,15
         L     4,0(2,11)
         L     5,0(2,10)
         L     14,S00000+176
         L     7,0(2,14)
         LA    14,32
         SR    14,7
         ST    14,S00000+184
         LH    6,C00047
         L     15,S00000+184
         SRL   6,0(15)
         C     5,C00045
         LA    14,1
         BC    4,L00048
         SR    14,14
L00048   DS    0H
         ST    14,S00000+184
         LR    14,5
         AR    14,7
         ST    14,S00000+192
         L     14,S00000+184
         LCR   14,14
         ST    14,S00000+200
         L     14,S00000+192
         XR    14,5
         ST    14,S00000+184
         L     14,S00000+184
         N     14,S00000+200
         ST    14,S00000+192
         X     5,S00000+192
         CR    5,7
         LA    14,1
         BC    8,L00049
         SR    14,14
L00049   DS    0H
         ST    14,S00000+184
         L     14,S00000+184
         LCR   14,14
         ST    14,S00000+192
         LR    14,5
         N     14,S00000+192
         ST    14,S00000+184
         X     5,S00000+184
         LR    3,4
         NR    3,6
         LR    14,3
         SLL   14,0(5)
         ST    14,S00000+184
         LR    14,7
         SR    14,5
         ST    14,S00000+192
         LR    14,3
         L     15,S00000+192
         SRL   14,0(15)
         ST    14,S00000+200
         L     7,S00000+184
         O     7,S00000+200
         C     5,C00045
         LA    14,1
         BC    8,L00050
         SR    14,14
L00050   DS    0H
         ST    14,S00000+184
         L     14,S00000+184
         LCR   14,14
         ST    14,S00000+192
         LR    14,3
         XR    14,7
         ST    14,S00000+184
         L     14,S00000+184
         N     14,S00000+192
         ST    14,S00000+200
         LR    14,7
         X     14,S00000+200
         ST    14,S00000+184
         L     14,S00000+184
         NR    14,6
         ST    14,S00000+192
         LR    14,6
         X     14,C00051
         ST    14,S00000+184
         LR    14,4
         N     14,S00000+184
         ST    14,S00000+200
         L     14,S00000+200
         O     14,S00000+192
         ST    14,S00000+184
         L     0,S00000+184
         ST    0,P00044+0
         LA    1,P00044
         L     15,C00022
         BALR  14,15
         L     15,C00031
         BALR  14,15
L00012   DS    0H
L00011   DS    0H
L00013   DS    0H
         BXLE  2,8,L00009
L00010   DS    0H
         L     14,C00053
         L     3,0(,14)
         LR    2,3
         N     2,C00054
         LR    4,2
         N     4,C00054
         O     4,C00055
         N     4,C00055
         SRL   3,4
         N     3,C00056
         SLL   3,20
         N     2,C00057
         OR    2,3
         LA    1,P00058
         L     15,C00020
         BALR  14,15
         L     14,C00053
         L     5,0(,14)
         LR    0,5
         ST    0,P00044+0
         LA    1,P00044
         L     15,C00022
         BALR  14,15
         LR    3,2
         N     3,C00054
         LR    0,3
         ST    0,P00044+0
         LA    1,P00044
         L     15,C00022
         BALR  14,15
         LR    0,4
         ST    0,P00044+0
         LA    1,P00044
         L     15,C00022
         BALR  14,15
         N     2,C00055
         LR    0,2
         ST    0,P00044+0
         LA    1,P00044
         L     15,C00022
         BALR  14,15
         L     15,C00031
         BALR  14,15
L00014   DS    0H
L00015   DS    0H
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
         DS    4D
P00019   DC    F'6'
         DC    A(Q00001)
P00021   DC    F'2'
P00023   DC    F'7'
P00024   DC    F'5'
P00025   DC    F'-7'
P00026   DC    F'48'
P00027   DC    F'15'
P00028   DC    F'3'
P00029   DC    F'-2147483642'
P00030   DC    F'4'
P00032   DC    F'6'
         DC    A(Q00002)
P00033   DC    F'1'
P00035   DC    F'0'
P00043   DC    F'6'
         DC    A(Q00003)
P00044   DC    A(0)
P00058   DC    F'6'
         DC    A(Q00004)
C00020   DC    V(F77WRBEG)
C00022   DC    V(F77WRI)
C00031   DC    V(F77WREND)
C00034   DC    V(F77WRL)
C00037   DC    A(G00036)
C00040   DC    A(G00039)
C00042   DC    A(G00041)
C00045   DC    F'0'
C00051   DC    F'-1'
C00053   DC    A(G00052)
C00054   DC    F'65535'
C00055   DC    F'-65536'
C00056   DC    F'255'
C00057   DC    F'-267386881'
C00038   DC    H'-4'
C00047   DC    H'-1'
Q00001   DC    C'('' >C '',5I12)'
Q00002   DC    C'('' >L '',3L2)'
Q00004   DC    C'('' >M '',4I12)'
Q00003   DC    C'('' >V '',5I12)'
* SHIFTS
SHIFTS   CSECT
         USING *,15
         B     L00063
         DC    AL1(6),CL7'SHIFTS'
L00063   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00064
L00065   DC    A(S00059)
L00064   L     15,L00065
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00059,13
         ST    1,S00059+72
L00060   DS    0H
         L     7,0(,1)
         L     6,4(,1)
         L     5,8(,1)
         LA    5,0(,5)
         LA    1,P00066
         L     15,C00067
         BALR  14,15
         L     3,0(,7)
         LR    0,3
         ST    0,P00068+0
         LA    1,P00068
         L     15,C00069
         BALR  14,15
         L     3,0(,6)
         LR    0,3
         ST    0,P00068+0
         LA    1,P00068
         L     15,C00069
         BALR  14,15
         L     3,0(,5)
         LR    0,3
         ST    0,P00068+0
         LA    1,P00068
         L     15,C00069
         BALR  14,15
         L     2,0(,7)
         L     9,0(,6)
         LR    3,2
         SLL   3,0(9)
         LCR   4,9
         SRL   2,0(4)
         C     9,C00070
         LA    8,1
         BC    10,L00071
         SR    8,8
L00071   DS    0H
         LCR   4,8
         XR    3,2
         NR    3,4
         XR    2,3
         LR    0,2
         ST    0,P00068+0
         LA    1,P00068
         L     15,C00069
         BALR  14,15
         L     4,0(,7)
         L     2,0(,6)
         L     3,0(,5)
         LA    5,32
         SR    5,3
         LH    7,C00072
         SRL   7,0(5)
         C     2,C00070
         LA    8,1
         BC    4,L00073
         SR    8,8
L00073   DS    0H
         LR    5,2
         AR    5,3
         LCR   6,8
         XR    5,2
         NR    5,6
         XR    2,5
         CR    2,3
         LA    6,1
         BC    8,L00074
         SR    6,6
L00074   DS    0H
         LCR   5,6
         NR    5,2
         XR    2,5
         LR    6,4
         NR    6,7
         LR    5,6
         SLL   5,0(2)
         SR    3,2
         LR    8,6
         SRL   8,0(3)
         OR    5,8
         C     2,C00070
         LA    3,1
         BC    8,L00075
         SR    3,3
L00075   DS    0H
         LCR   2,3
         XR    6,5
         NR    6,2
         XR    5,6
         NR    5,7
         LR    2,7
         X     2,C00076
         NR    4,2
         OR    4,5
         LR    0,4
         ST    0,P00068+0
         LA    1,P00068
         L     15,C00069
         BALR  14,15
         L     15,C00077
         BALR  14,15
L00061   DS    0H
         LA    0,0
L00062   DS    0H
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
P00066   DC    F'6'
         DC    A(Q00003)
P00068   DC    A(0)
         DS    XL4
C00067   DC    V(F77WRBEG)
C00069   DC    V(F77WRI)
C00070   DC    F'0'
C00076   DC    F'-1'
C00077   DC    V(F77WREND)
C00072   DC    H'-1'
G00036   CSECT
         DS    0D
         DC    X'00000006FFFFFFFC00000006FFFFFFFC1234567812345678'
         DC    X'FFFFFFFFFFFFFFFF00000001'
G00039   CSECT
         DS    0D
         DC    X'00000003FFFFFFE4FFFFFFFF00000003FFFFFFF800000004'
         DC    X'0000001FFFFFFFE100000000'
G00041   CSECT
         DS    0D
         DC    X'000000030000002000000003000000200000001000000008'
         DC    X'000000200000002000000001'
G00052   CSECT
         DS    0D
         DC    X'12345678'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
