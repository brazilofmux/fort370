* main
F77MAIN  CSECT
         USING *,15
         B     L00038
         DC    AL1(7),CL7'F77MAIN'
L00038   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00039
L00040   DC    A(S00000)
L00039   L     15,L00040
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00020   DS    0H
         L     7,C00042
         L     6,C00044
         L     5,C00044
         LA    15,0
         ST    15,T00019
         LD    0,C00046
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         CD    0,C00046
         LA    2,1
         BC    8,L00048
         SR    2,2
L00048   DS    0H
         ST    2,T00018
         LA    1,P00049
         L     15,C00050
         BALR  14,15
         LD    0,C00051
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         SD    0,C00052
         LPDR  0,0
         CD    0,C00053
         LA    2,1
         BC    4,L00054
         SR    2,2
L00054   DS    0H
         ST    2,T00011
         LA    1,P00055
         L     15,C00050
         BALR  14,15
         LD    0,C00056
         LCDR  0,0
         STD   0,S00000+336
         LD    0,S00000+336
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         STD   0,S00000+344
         LD    0,C00056
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         LCDR  0,0
         LD    2,S00000+344
         CDR   2,0
         LA    2,1
         BC    8,L00057
         SR    2,2
L00057   DS    0H
         ST    2,T00012
         LA    1,P00058
         L     15,C00050
         BALR  14,15
         LD    0,C00059
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         CD    0,C00059
         LA    2,1
         BC    8,L00060
         SR    2,2
L00060   DS    0H
         ST    2,T00013
         LA    1,P00061
         L     15,C00050
         BALR  14,15
         LD    0,C00062
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         STD   0,S00000+336
         LD    0,C00062
         SD    0,C00063
         STD   0,S00000+344
         LD    0,S00000+344
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         LDR   2,0
         LD    0,S00000+336
         SDR   0,2
         LPDR  0,0
         CD    0,C00064
         LA    2,1
         BC    4,L00065
         SR    2,2
L00065   DS    0H
         ST    2,T00014
         LA    1,P00066
         L     15,C00050
         BALR  14,15
         LD    0,C00067
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         CD    0,C00052
         LA    2,1
         BC    8,L00068
         SR    2,2
L00068   DS    0H
         ST    2,T00015
         LA    1,P00069
         L     15,C00050
         BALR  14,15
         LD    0,C00070
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         LD    2,C00071
         CDR   2,0
         LA    2,1
         BC    4,L00072
         SR    2,2
L00072   DS    0H
         ST    2,T00016
         LA    1,P00073
         L     15,C00050
         BALR  14,15
         LD    0,C00074
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         AD    0,C00075
         LPDR  0,0
         CD    0,C00053
         LA    2,1
         BC    4,L00076
         SR    2,2
L00076   DS    0H
         ST    2,T00017
         LA    1,P00077
         L     15,C00050
         BALR  14,15
         LA    8,1
L00021   DS    0H
         L     9,C00078
         LR    4,8
         LA    3,0
         LH    2,C00079
L00022   DS    0H
         LR    10,2
         SLL   10,13
         XR    2,10
         LR    10,2
         SRL   10,17
         XR    2,10
         LR    10,2
         SLL   10,5
         XR    2,10
L00024   DS    0H
         LR    10,2
         N     10,C00080
         LR    0,10
         SRDA  0,32
         D     0,C00081
         LR    10,0
         A     10,C00082
         SLL   10,24
         LR    11,2
         N     11,C00083
         OR    10,11
         L     14,C00042
         ST    10,0(,14)
         LR    10,2
         N     10,C00084
         C     10,C00085
         BC    8,L00026
L00025   DS    0H
         L     14,C00042
         L     10,0(,14)
         O     10,C00086
         L     14,C00042
         ST    10,0(,14)
L00026   DS    0H
         L     14,C00042
         L     10,0(,14)
         O     10,C00087
         L     14,C00042
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
L00027   DS    0H
         L     14,C00088
         ST    2,0(,14)
         LR    0,4
         SRDA  0,32
         D     0,C00089
         LR    10,0
         C     10,C00085
         BC    7,L00029
L00028   DS    0H
         LR    0,2
         SRDA  0,32
         D     0,C00090
         LR    10,0
         LR    0,10
         X     0,C00086
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00091
         L     15,C00042
         AD    0,0(,15)
         L     14,C00042
         STD   0,0(,14)
L00029   DS    0H
         L     14,C00042
         LD    0,0(,14)
         STD   0,S00000+336
         LD    0,S00000+336
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         L     14,C00044
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
L00030   DS    0H
         BXLE  4,8,L00022
L00023   DS    0H
         LA    1,P00092
         L     15,C00093
         BALR  14,15
         LA    1,P00094
         L     15,C00095
         BALR  14,15
         LR    0,3
         ST    0,P00096+0
         LA    1,P00096
         L     15,C00095
         BALR  14,15
         L     15,C00097
         BALR  14,15
L00031   DS    0H
         LD    0,C00098
         LCDR  0,0
         L     14,C00042
         STD   0,0(,14)
L00032   DS    0H
         LD    0,C00099
         STD   0,S00000+336
         LH    8,C00100
         LA    9,0
         L     3,C00078
         LA    2,0
L00033   DS    0H
         LD    0,C00099
         L     15,C00042
         AD    0,0(,15)
         STD   0,S00000+344
         L     14,C00042
         MVC   0(8,14),S00000+344
         LD    0,S00000+344
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         L     14,C00044
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
L00035   DS    0H
         BXH   3,8,L00033
L00034   DS    0H
         LA    1,P00092
         L     15,C00093
         BALR  14,15
         LA    1,P00101
         L     15,C00095
         BALR  14,15
         LR    0,2
         ST    0,P00096+0
         LA    1,P00096
         L     15,C00095
         BALR  14,15
         L     15,C00097
         BALR  14,15
         LA    1,P00102
         L     15,C00093
         BALR  14,15
         L     3,T00019
         LR    0,3
         ST    0,P00096+0
         LA    1,P00096
         L     15,C00095
         BALR  14,15
         L     15,C00097
         BALR  14,15
L00036   DS    0H
L00037   DS    0H
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
T00016   DS    XL4
         DS    XL4
T00017   DS    XL4
         DS    XL4
T00018   DS    XL12
         DS    XL4
T00019   DS    XL88
         DS    2D
P00045   DC    A(0)
         DC    A(0)
P00049   DC    A(Q00001)
         DC    A(T00018)
         DC    A(T00019)
         DC    XL1'80',FL3'7'
P00055   DC    A(Q00002)
         DC    A(T00011)
         DC    A(T00019)
         DC    XL1'80',FL3'7'
P00058   DC    A(Q00003)
         DC    A(T00012)
         DC    A(T00019)
         DC    XL1'80',FL3'7'
P00061   DC    A(Q00004)
         DC    A(T00013)
         DC    A(T00019)
         DC    XL1'80',FL3'7'
P00066   DC    A(Q00005)
         DC    A(T00014)
         DC    A(T00019)
         DC    XL1'80',FL3'7'
P00069   DC    A(Q00006)
         DC    A(T00015)
         DC    A(T00019)
         DC    XL1'80',FL3'7'
P00073   DC    A(Q00007)
         DC    A(T00016)
         DC    A(T00019)
         DC    XL1'80',FL3'7'
P00077   DC    A(Q00008)
         DC    A(T00017)
         DC    A(T00019)
         DC    XL1'80',FL3'7'
P00092   DC    F'6'
         DC    A(Q00009)
P00094   DC    F'1'
P00096   DC    A(0)
P00101   DC    F'2'
P00102   DC    F'6'
         DC    A(Q00010)
         DS    XL4
C00046   DC    X'0000000000000000'
C00051   DC    X'40C90FDAA22168C2'
C00052   DC    X'4110000000000000'
C00053   DC    X'34480EBE7B9D5856'
C00056   DC    X'4080000000000000'
C00059   DC    X'1F8B61313BBABCE3'
C00062   DC    X'4130000000000000'
C00063   DC    X'413243F6A8885A2F'
C00064   DC    X'352D09370D425736'
C00067   DC    X'5156BC75E2D63100'
C00070   DC    X'411921FB54442D18'
C00071   DC    X'7FF79DC0E8C518F3'
C00074   DC    X'461E848000000000'
C00075   DC    X'40DE550DC5B2B225'
C00091   DC    X'4E00000080000000'
C00098   DC    X'411999999999999A'
C00099   DC    X'3D218DEF416BDB1A'
C00042   DC    A(G00041)
C00044   DC    A(G00043)
C00047   DC    V(DTAN)
C00050   DC    V(CHK)
C00078   DC    F'100000'
C00080   DC    F'255'
C00081   DC    F'18'
C00082   DC    F'52'
C00083   DC    F'16777215'
C00084   DC    F'256'
C00085   DC    F'0'
C00086   DC    F'-2147483648'
C00087   DC    F'1048576'
C00088   DC    A(G00041+4)
C00089   DC    F'100'
C00090   DC    F'1000000'
C00093   DC    V(F77WRBEG)
C00095   DC    V(F77WRI)
C00097   DC    V(F77WREND)
C00079   DC    H'12345'
C00100   DC    H'-1'
Q00009   DC    C'('' >HASH'',I1,1X,Z8)'
Q00010   DC    C'('' >BAD '',I2)'
Q00001   DC    C'ZERO   '
Q00002   DC    C'QUARTER'
Q00003   DC    C'ODD    '
Q00004   DC    C'TINY   '
Q00005   DC    C'PERIOD '
Q00006   DC    C'HUGEARG'
Q00007   DC    C'POLE   '
Q00008   DC    C'BIGARG '
* XSH
XSH      CSECT
         USING *,15
         B     L00106
         DC    AL1(3),CL7'XSH'
L00106   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00107
L00108   DC    A(S00103)
L00107   L     15,L00108
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00103,13
         ST    1,S00103+72
L00104   DS    0H
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
L00105   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00103   DS    0D
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
         B     L00119
         DC    AL1(3),CL7'CHK'
L00119   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00120
L00121   DC    A(S00109)
L00120   L     15,L00121
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00109,13
         ST    1,S00109+72
L00112   DS    0H
         L     5,0(,1)
         L     4,4(,1)
         L     3,8(,1)
         L     2,0(,4)
         LTR   2,2
         BC    7,L00113
L00114   DS    0H
         LA    1,P00122
         L     15,C00123
         BALR  14,15
         LR    0,5
         ST    0,P00124+0
         LA    1,P00124
         L     15,C00125
         BALR  14,15
         L     15,C00126
         BALR  14,15
L00117   DS    0H
         L     2,0(,3)
         A     2,C00127
         ST    2,0(,3)
L00115   DS    0H
         LA    0,0
         B     L00118
L00113   DS    0H
         LA    1,P00128
         L     15,C00123
         BALR  14,15
         LR    0,5
         ST    0,P00124+0
         LA    1,P00124
         L     15,C00125
         BALR  14,15
         L     15,C00126
         BALR  14,15
L00116   DS    0H
         B     L00115
L00118   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00109   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00122   DC    F'6'
         DC    A(Q00111)
P00124   DC    A(0)
         DC    F'7'
P00128   DC    F'6'
         DC    A(Q00110)
C00123   DC    V(F77WRBEG)
C00125   DC    V(F77WRA)
C00126   DC    V(F77WREND)
C00127   DC    F'1'
Q00110   DC    C'('' >'',A7,'' OK'')'
Q00111   DC    C'('' >'',A7,'' BAD'')'
G00041   CSECT
         DS    0D
         DS    XL8
G00043   CSECT
         DS    0D
         DS    XL8
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
