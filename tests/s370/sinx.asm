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
L00020   DS    0H
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
         LD    0,C00046
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00051
         BALR  14,15
         CD    0,C00052
         LA    2,1
         BC    8,L00053
         SR    2,2
L00053   DS    0H
         ST    2,T00011
         LA    1,P00054
         L     15,C00050
         BALR  14,15
         LD    0,C00055
         LCDR  0,0
         STD   0,S00000+336
         LD    0,S00000+336
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         STD   0,S00000+344
         LD    0,C00055
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         LCDR  0,0
         LD    2,S00000+344
         CDR   2,0
         LA    2,1
         BC    8,L00056
         SR    2,2
L00056   DS    0H
         ST    2,T00012
         LA    1,P00057
         L     15,C00050
         BALR  14,15
         LD    0,C00055
         LCDR  0,0
         STD   0,S00000+336
         LD    0,S00000+336
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00051
         BALR  14,15
         STD   0,S00000+344
         LD    0,C00055
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00051
         BALR  14,15
         LD    2,S00000+344
         CDR   2,0
         LA    2,1
         BC    8,L00058
         SR    2,2
L00058   DS    0H
         ST    2,T00013
         LA    1,P00059
         L     15,C00050
         BALR  14,15
         LD    0,C00060
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         STD   0,S00000+336
         LD    0,S00000+336
         STD   0,P00061+0
         LA    1,P00061
         L     15,C00062
         BALR  14,15
         STD   0,S00000+344
         LD    0,C00060
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00051
         BALR  14,15
         STD   0,S00000+336
         LD    0,S00000+336
         STD   0,P00061+0
         LA    1,P00061
         L     15,C00062
         BALR  14,15
         AD    0,S00000+344
         SD    0,C00052
         LPDR  0,0
         CD    0,C00063
         LA    2,1
         BC    4,L00064
         SR    2,2
L00064   DS    0H
         ST    2,T00014
         LA    1,P00065
         L     15,C00050
         BALR  14,15
         LD    0,C00066
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         CD    0,C00066
         LA    2,1
         BC    8,L00067
         SR    2,2
L00067   DS    0H
         ST    2,T00015
         LA    1,P00068
         L     15,C00050
         BALR  14,15
         LD    0,C00069
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         SD    0,C00070
         LPDR  0,0
         CD    0,C00063
         LA    2,1
         BC    4,L00071
         SR    2,2
L00071   DS    0H
         ST    2,T00016
         LA    1,P00072
         L     15,C00050
         BALR  14,15
         LD    0,C00073
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         AD    0,C00074
         LPDR  0,0
         CD    0,C00075
         LA    2,1
         BC    4,L00076
         SR    2,2
L00076   DS    0H
         ST    2,T00017
         LA    1,P00077
         L     15,C00050
         BALR  14,15
L00021   DS    0H
         LA    6,1
         LA    4,1
         LH    2,C00078
L00022   DS    0H
L00024   DS    0H
         C     4,C00079
         LA    9,1
         BC    8,L00080
         SR    9,9
L00080   DS    0H
         C     4,C00081
         LA    8,1
         BC    8,L00082
         SR    8,8
L00082   DS    0H
         L     7,C00083
         LR    5,6
         LA    3,0
L00025   DS    0H
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
         LR    10,2
         N     10,C00084
         LR    0,10
         SRDA  0,32
         D     0,C00085
         LR    10,0
         A     10,C00086
         SLL   10,24
         LR    11,2
         N     11,C00087
         OR    10,11
         L     14,C00089
         ST    10,0(,14)
         LR    10,2
         N     10,C00090
         C     10,C00091
         BC    8,L00029
L00028   DS    0H
         L     14,C00089
         L     10,0(,14)
         O     10,C00092
         L     14,C00089
         ST    10,0(,14)
L00029   DS    0H
         L     14,C00089
         L     10,0(,14)
         O     10,C00093
         L     14,C00089
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
L00030   DS    0H
         L     14,C00094
         ST    2,0(,14)
         LR    0,5
         SRDA  0,32
         D     0,C00095
         LR    10,0
         C     10,C00091
         BC    7,L00032
L00031   DS    0H
         LR    0,2
         SRDA  0,32
         D     0,C00096
         LR    10,0
         LR    0,10
         X     0,C00092
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00097
         L     15,C00089
         AD    0,0(,15)
         L     14,C00089
         STD   0,0(,14)
L00032   DS    0H
         LTR   9,9
         BC    8,L00034
L00033   DS    0H
         L     14,C00089
         LD    0,0(,14)
         STD   0,S00000+344
         LD    0,S00000+344
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00047
         BALR  14,15
         L     14,C00099
         STD   0,0(,14)
L00034   DS    0H
         LTR   8,8
         BC    8,L00036
L00035   DS    0H
         L     14,C00089
         LD    0,0(,14)
         STD   0,S00000+344
         LD    0,S00000+344
         STD   0,P00045+0
         LA    1,P00045
         L     15,C00051
         BALR  14,15
         L     14,C00099
         STD   0,0(,14)
L00036   DS    0H
         LR    10,3
         SLL   10,5
         SRL   3,27
         OR    10,3
         L     15,C00099
         X     10,0(,15)
         LR    3,10
         SLL   3,7
         SRL   10,25
         OR    3,10
         L     15,C00099
         X     3,4(,15)
L00037   DS    0H
         BXLE  5,6,L00025
         LR    14,3
         ST    14,S00000+336
L00026   DS    0H
         LA    1,P00100
         L     15,C00101
         BALR  14,15
         LR    0,4
         ST    0,P00102+0
         LA    1,P00102
         L     15,C00103
         BALR  14,15
         L     0,S00000+336
         ST    0,P00102+0
         LA    1,P00102
         L     15,C00103
         BALR  14,15
         L     15,C00104
         BALR  14,15
L00038   DS    0H
L00039   DS    0H
         A     4,C00079
         C     4,C00081
         BC    12,L00022
L00023   DS    0H
         LA    1,P00105
         L     15,C00101
         BALR  14,15
         L     3,T00019
         LR    0,3
         ST    0,P00102+0
         LA    1,P00102
         L     15,C00103
         BALR  14,15
         L     15,C00104
         BALR  14,15
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
P00054   DC    A(Q00002)
         DC    A(T00011)
         DC    A(T00019)
         DC    XL1'80',FL3'7'
P00057   DC    A(Q00003)
         DC    A(T00012)
         DC    A(T00019)
         DC    XL1'80',FL3'7'
P00059   DC    A(Q00004)
         DC    A(T00013)
         DC    A(T00019)
         DC    XL1'80',FL3'7'
P00061   DC    A(0)
         DC    A(0)
         DC    F'2'
P00065   DC    A(Q00005)
         DC    A(T00014)
         DC    A(T00019)
         DC    XL1'80',FL3'7'
P00068   DC    A(Q00006)
         DC    A(T00015)
         DC    A(T00019)
         DC    XL1'80',FL3'7'
P00072   DC    A(Q00007)
         DC    A(T00016)
         DC    A(T00019)
         DC    XL1'80',FL3'7'
P00077   DC    A(Q00008)
         DC    A(T00017)
         DC    A(T00019)
         DC    XL1'80',FL3'7'
P00100   DC    F'6'
         DC    A(Q00010)
P00102   DC    A(0)
P00105   DC    F'6'
         DC    A(Q00009)
C00046   DC    X'0000000000000000'
C00052   DC    X'4110000000000000'
C00055   DC    X'4080000000000000'
C00060   DC    X'40B3333333333333'
C00063   DC    X'34480EBE7B9D5856'
C00066   DC    X'1F8B61313BBABCE3'
C00069   DC    X'5156BC75E2D63100'
C00070   DC    X'40B504F333F9DE64'
C00073   DC    X'461E848000000000'
C00074   DC    X'40A7DCE4B4DD3775'
C00075   DC    X'361C25C268497682'
C00097   DC    X'4E00000080000000'
C00047   DC    V(DSIN)
C00050   DC    V(CHK)
C00051   DC    V(DCOS)
C00062   DC    V(F77DPOWI)
C00079   DC    F'1'
C00081   DC    F'2'
C00083   DC    F'100000'
C00084   DC    F'255'
C00085   DC    F'18'
C00086   DC    F'52'
C00087   DC    F'16777215'
C00089   DC    A(G00088)
C00090   DC    F'256'
C00091   DC    F'0'
C00092   DC    F'-2147483648'
C00093   DC    F'1048576'
C00094   DC    A(G00088+4)
C00095   DC    F'100'
C00096   DC    F'1000000'
C00099   DC    A(G00098)
C00101   DC    V(F77WRBEG)
C00103   DC    V(F77WRI)
C00104   DC    V(F77WREND)
C00078   DC    H'12345'
Q00010   DC    C'('' >HASH'',I1,1X,Z8)'
Q00009   DC    C'('' >BAD '',I2)'
Q00001   DC    C'SIN0   '
Q00002   DC    C'COS0   '
Q00003   DC    C'ODD    '
Q00004   DC    C'EVEN   '
Q00005   DC    C'PYTHAG '
Q00006   DC    C'TINY   '
Q00007   DC    C'HUGEARG'
Q00008   DC    C'BIGARG '
* XSH
XSH      CSECT
         USING *,15
         B     L00109
         DC    AL1(3),CL7'XSH'
L00109   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00110
L00111   DC    A(S00106)
L00110   L     15,L00111
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00106,13
         ST    1,S00106+72
L00107   DS    0H
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
L00108   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00106   DS    0D
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
         B     L00122
         DC    AL1(3),CL7'CHK'
L00122   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00123
L00124   DC    A(S00112)
L00123   L     15,L00124
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00112,13
         ST    1,S00112+72
L00115   DS    0H
         L     5,0(,1)
         L     4,4(,1)
         L     3,8(,1)
         L     2,0(,4)
         LTR   2,2
         BC    7,L00116
L00117   DS    0H
         LA    1,P00125
         L     15,C00126
         BALR  14,15
         LR    0,5
         ST    0,P00127+0
         LA    1,P00127
         L     15,C00128
         BALR  14,15
         L     15,C00129
         BALR  14,15
L00120   DS    0H
         L     2,0(,3)
         A     2,C00130
         ST    2,0(,3)
L00118   DS    0H
         LA    0,0
         B     L00121
L00116   DS    0H
         LA    1,P00131
         L     15,C00126
         BALR  14,15
         LR    0,5
         ST    0,P00127+0
         LA    1,P00127
         L     15,C00128
         BALR  14,15
         L     15,C00129
         BALR  14,15
L00119   DS    0H
         B     L00118
L00121   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00112   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00125   DC    F'6'
         DC    A(Q00114)
P00127   DC    A(0)
         DC    F'7'
P00131   DC    F'6'
         DC    A(Q00113)
C00126   DC    V(F77WRBEG)
C00128   DC    V(F77WRA)
C00129   DC    V(F77WREND)
C00130   DC    F'1'
Q00113   DC    C'('' >'',A7,'' OK'')'
Q00114   DC    C'('' >'',A7,'' BAD'')'
G00088   CSECT
         DS    0D
         DS    XL8
G00098   CSECT
         DS    0D
         DS    XL8
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
