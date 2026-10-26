* main
F77MAIN  CSECT
         USING *,15
         B     L00036
         DC    AL1(7),CL7'F77MAIN'
L00036   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00037
L00038   DC    A(S00000)
L00037   L     15,L00038
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00018   DS    0H
         L     7,C00040
         L     6,C00042
         L     5,C00042
         LA    15,0
         ST    15,T00017
         LD    0,C00044
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         CD    0,C00044
         LA    2,1
         BC    8,L00046
         SR    2,2
L00046   DS    0H
         ST    2,T00016
         LA    1,P00047
         L     15,C00048
         BALR  14,15
         LD    0,C00049
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         SD    0,C00050
         LPDR  0,0
         CD    0,C00051
         LA    2,1
         BC    4,L00052
         SR    2,2
L00052   DS    0H
         ST    2,T00010
         LA    1,P00053
         L     15,C00048
         BALR  14,15
         LD    0,C00054
         LCDR  0,0
         STD   0,S00000+328
         LD    0,S00000+328
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         STD   0,S00000+336
         LD    0,C00054
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         LCDR  0,0
         LD    2,S00000+336
         CDR   2,0
         LA    2,1
         BC    8,L00055
         SR    2,2
L00055   DS    0H
         ST    2,T00011
         LA    1,P00056
         L     15,C00048
         BALR  14,15
         LD    0,C00057
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         STD   0,S00000+328
         LD    0,C00057
         SD    0,C00058
         STD   0,S00000+336
         LD    0,S00000+336
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         LDR   2,0
         LD    0,S00000+328
         SDR   0,2
         LPDR  0,0
         CD    0,C00059
         LA    2,1
         BC    4,L00060
         SR    2,2
L00060   DS    0H
         ST    2,T00012
         LA    1,P00061
         L     15,C00048
         BALR  14,15
         LD    0,C00062
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         CD    0,C00050
         LA    2,1
         BC    8,L00063
         SR    2,2
L00063   DS    0H
         ST    2,T00013
         LA    1,P00064
         L     15,C00048
         BALR  14,15
         LD    0,C00065
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         LD    2,C00066
         CDR   2,0
         LA    2,1
         BC    4,L00067
         SR    2,2
L00067   DS    0H
         ST    2,T00014
         LA    1,P00068
         L     15,C00048
         BALR  14,15
         LD    0,C00069
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         AD    0,C00070
         LPDR  0,0
         CD    0,C00051
         LA    2,1
         BC    4,L00071
         SR    2,2
L00071   DS    0H
         ST    2,T00015
         LA    1,P00072
         L     15,C00048
         BALR  14,15
         LA    8,1
L00019   DS    0H
         L     9,C00073
         LR    4,8
         LA    3,0
         LH    2,C00074
L00020   DS    0H
         LR    10,2
         SLL   10,13
         XR    2,10
         LR    10,2
         SRL   10,17
         XR    2,10
         LR    10,2
         SLL   10,5
         XR    2,10
L00022   DS    0H
         LR    10,2
         N     10,C00075
         LR    0,10
         SRDA  0,32
         D     0,C00076
         LR    10,0
         A     10,C00077
         SLL   10,24
         LR    11,2
         N     11,C00078
         OR    10,11
         L     14,C00040
         ST    10,0(,14)
         LR    10,2
         N     10,C00079
         C     10,C00080
         BC    8,L00024
L00023   DS    0H
         L     14,C00040
         L     10,0(,14)
         O     10,C00081
         L     14,C00040
         ST    10,0(,14)
L00024   DS    0H
         L     14,C00040
         L     10,0(,14)
         O     10,C00082
         L     14,C00040
         ST    10,0(,14)
         LR    10,2
         SLL   10,13
         XR    2,10
         LR    10,2
         SRL   10,17
         XR    2,10
         LR    10,2
         SLL   10,5
         XR    2,10
L00025   DS    0H
         L     14,C00083
         ST    2,0(,14)
         LR    0,4
         SRDA  0,32
         D     0,C00084
         LR    10,0
         C     10,C00080
         BC    7,L00027
L00026   DS    0H
         LR    0,2
         SRDA  0,32
         D     0,C00085
         LR    10,0
         LR    0,10
         X     0,C00081
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00086
         L     15,C00040
         AD    0,0(,15)
         L     14,C00040
         STD   0,0(,14)
L00027   DS    0H
         L     14,C00040
         LD    0,0(,14)
         STD   0,S00000+328
         LD    0,S00000+328
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         L     14,C00042
         STD   0,0(,14)
         LR    10,3
         SLL   10,5
         SRL   3,27
         OR    10,3
         X     10,0(,5)
         LR    3,10
         SLL   3,7
         SRL   10,25
         OR    3,10
         X     3,4(,5)
L00028   DS    0H
         BXLE  4,8,L00020
L00021   DS    0H
         LA    1,P00087
         L     15,C00088
         BALR  14,15
         LA    1,P00089
         L     15,C00090
         BALR  14,15
         LR    0,3
         ST    0,P00091+0
         LA    1,P00091
         L     15,C00090
         BALR  14,15
         L     15,C00092
         BALR  14,15
L00029   DS    0H
         LD    0,C00093
         LCDR  0,0
         L     14,C00040
         STD   0,0(,14)
L00030   DS    0H
         LD    0,C00094
         STD   0,S00000+328
         LH    8,C00095
         LA    9,0
         L     3,C00073
         LA    2,0
L00031   DS    0H
         LD    0,C00094
         L     15,C00040
         AD    0,0(,15)
         STD   0,S00000+336
         L     14,C00040
         MVC   0(8,14),S00000+336
         LD    0,S00000+336
         STD   0,P00043+0
         LA    1,P00043
         L     15,C00045
         BALR  14,15
         L     14,C00042
         STD   0,0(,14)
         LR    4,2
         SLL   4,5
         SRL   2,27
         OR    4,2
         X     4,0(,5)
         LR    2,4
         SLL   2,7
         SRL   4,25
         OR    2,4
         X     2,4(,5)
L00033   DS    0H
         BXH   3,8,L00031
L00032   DS    0H
         LA    1,P00087
         L     15,C00088
         BALR  14,15
         LA    1,P00096
         L     15,C00090
         BALR  14,15
         LR    0,2
         ST    0,P00091+0
         LA    1,P00091
         L     15,C00090
         BALR  14,15
         L     15,C00092
         BALR  14,15
         LA    1,P00097
         L     15,C00088
         BALR  14,15
         L     3,T00017
         LR    0,3
         ST    0,P00091+0
         LA    1,P00091
         L     15,C00090
         BALR  14,15
         L     15,C00092
         BALR  14,15
L00034   DS    0H
L00035   DS    0H
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
T00010   DS    XL4
         DS    XL4
T00011   DS    XL4
         DS    XL4
T00012   DS    XL4
         DS    XL4
T00013   DS    XL4
         DS    XL4
T00014   DS    XL4
         DS    XL4
T00015   DS    XL4
         DS    XL4
T00016   DS    XL12
         DS    XL4
T00017   DS    XL88
         DS    2D
P00043   DC    A(0)
         DC    A(0)
P00047   DC    A(Q00001)
         DC    A(T00016)
         DC    A(T00017)
         DC    XL1'80',FL3'7'
P00053   DC    A(Q00002)
         DC    A(T00010)
         DC    A(T00017)
         DC    XL1'80',FL3'7'
P00056   DC    A(Q00003)
         DC    A(T00011)
         DC    A(T00017)
         DC    XL1'80',FL3'7'
P00061   DC    A(Q00004)
         DC    A(T00012)
         DC    A(T00017)
         DC    XL1'80',FL3'7'
P00064   DC    A(Q00005)
         DC    A(T00013)
         DC    A(T00017)
         DC    XL1'80',FL3'7'
P00068   DC    A(Q00006)
         DC    A(T00014)
         DC    A(T00017)
         DC    XL1'80',FL3'7'
P00072   DC    A(Q00007)
         DC    A(T00015)
         DC    A(T00017)
         DC    XL1'80',FL3'7'
P00087   DC    F'6'
         DC    A(Q00008)
P00089   DC    F'1'
P00091   DC    A(0)
P00096   DC    F'2'
P00097   DC    F'6'
         DC    A(Q00009)
         DS    XL4
C00044   DC    X'0000000000000000'
C00049   DC    X'40C90FDAA22168C2'
C00050   DC    X'4110000000000000'
C00051   DC    X'34480EBE7B9D5856'
C00054   DC    X'4080000000000000'
C00057   DC    X'4130000000000000'
C00058   DC    X'413243F6A8885A2F'
C00059   DC    X'352D09370D425736'
C00062   DC    X'5156BC75E2D63100'
C00065   DC    X'411921FB54442D18'
C00066   DC    X'7FF79DC0E8C518F3'
C00069   DC    X'461E848000000000'
C00070   DC    X'40DE550DC5B2B225'
C00086   DC    X'4E00000080000000'
C00093   DC    X'411999999999999A'
C00094   DC    X'3D218DEF416BDB1A'
C00040   DC    A(G00039)
C00042   DC    A(G00041)
C00045   DC    V(DTAN)
C00048   DC    V(CHK)
C00073   DC    F'100000'
C00075   DC    F'255'
C00076   DC    F'18'
C00077   DC    F'52'
C00078   DC    F'16777215'
C00079   DC    F'256'
C00080   DC    F'0'
C00081   DC    F'-2147483648'
C00082   DC    F'1048576'
C00083   DC    A(G00039+4)
C00084   DC    F'100'
C00085   DC    F'1000000'
C00088   DC    V(F77WRBEG)
C00090   DC    V(F77WRI)
C00092   DC    V(F77WREND)
C00074   DC    H'12345'
C00095   DC    H'-1'
Q00008   DC    C'('' >HASH'',I1,1X,Z8)'
Q00009   DC    C'('' >BAD '',I2)'
Q00001   DC    C'ZERO   '
Q00002   DC    C'QUARTER'
Q00003   DC    C'ODD    '
Q00004   DC    C'PERIOD '
Q00005   DC    C'HUGEARG'
Q00006   DC    C'POLE   '
Q00007   DC    C'BIGARG '
* XSH
XSH      CSECT
         USING *,15
         B     L00101
         DC    AL1(3),CL7'XSH'
L00101   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00102
L00103   DC    A(S00098)
L00102   L     15,L00103
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00098,13
         ST    1,S00098+72
L00099   DS    0H
         L     4,0(,1)
         LA    4,0(,4)
         L     2,0(,4)
         LR    3,2
         SLL   3,13
         XR    2,3
         LR    3,2
         SRL   3,17
         XR    2,3
         LR    3,2
         SLL   3,5
         XR    2,3
         ST    2,0(,4)
         LA    0,0
L00100   DS    0H
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
* CHK
CHK      CSECT
         USING *,15
         B     L00114
         DC    AL1(3),CL7'CHK'
L00114   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00115
L00116   DC    A(S00104)
L00115   L     15,L00116
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00104,13
         ST    1,S00104+72
L00107   DS    0H
         L     5,0(,1)
         L     4,4(,1)
         L     3,8(,1)
         L     2,0(,4)
         LTR   2,2
         BC    7,L00108
L00109   DS    0H
         LA    1,P00117
         L     15,C00118
         BALR  14,15
         LR    0,5
         ST    0,P00119+0
         LA    1,P00119
         L     15,C00120
         BALR  14,15
         L     15,C00121
         BALR  14,15
L00112   DS    0H
         L     2,0(,3)
         A     2,C00122
         ST    2,0(,3)
L00110   DS    0H
         LA    0,0
         B     L00113
L00108   DS    0H
         LA    1,P00123
         L     15,C00118
         BALR  14,15
         LR    0,5
         ST    0,P00119+0
         LA    1,P00119
         L     15,C00120
         BALR  14,15
         L     15,C00121
         BALR  14,15
L00111   DS    0H
         B     L00110
L00113   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00104   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00117   DC    F'6'
         DC    A(Q00106)
P00119   DC    A(0)
         DC    F'7'
P00123   DC    F'6'
         DC    A(Q00105)
C00118   DC    V(F77WRBEG)
C00120   DC    V(F77WRA)
C00121   DC    V(F77WREND)
C00122   DC    F'1'
Q00105   DC    C'('' >'',A7,'' OK'')'
Q00106   DC    C'('' >'',A7,'' BAD'')'
G00039   CSECT
         DS    0D
         DS    XL8
G00041   CSECT
         DS    0D
         DS    XL8
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
