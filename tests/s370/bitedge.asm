* main
F77MAIN  CSECT
         USING *,15
         B     L00037
         DC    AL1(7),CL7'F77MAIN'
L00037   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00038
L00039   DC    A(S00000)
L00038   L     15,L00039
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00031   DS    0H
         LA    15,0
         ST    15,T00030
         LA    0,T00025
         ST    0,P00040+0
         LA    0,8
         ST    0,P00040+4
         L     0,C00041
         ST    0,P00040+8
         LA    0,8
         ST    0,P00040+12
         LA    1,P00040
         L     15,C00042
         BALR  14,15
         LA    0,5
         ST    0,P00040+0
         LA    1,P00040
         L     15,C00043
         BALR  14,15
         LA    0,T00025
         ST    0,P00040+0
         LA    0,8
         ST    0,P00040+4
         LA    0,1
         ST    0,P00040+8
         L     0,C00044
         ST    0,P00040+12
         LA    0,0
         ST    0,P00040+16
         LA    1,P00040
         L     15,C00045
         BALR  14,15
         LA    2,4
         LA    3,2
L00032   DS    0H
         C     3,C00046
         BC    2,L00033
L00034   DS    0H
         L     15,C00047
         BALR  14,15
         L     4,T00024+4
         LA    15,1
         ST    15,T00026
         L     0,C00048
         ST    0,P00040+0
         LA    0,T00026
         ST    0,P00040+4
         LA    0,T00030
         ST    0,P00040+8
         LA    0,6
         ST    0,P00040+12
         OI    P00040+12,X'80'
         LA    1,P00040
         L     15,C00049
         BALR  14,15
         LA    15,1
         ST    15,T00016
         L     0,C00050
         ST    0,P00040+0
         LA    0,T00016
         ST    0,P00040+4
         LA    0,T00030
         ST    0,P00040+8
         LA    0,6
         ST    0,P00040+12
         OI    P00040+12,X'80'
         LA    1,P00040
         L     15,C00049
         BALR  14,15
         LA    15,1
         ST    15,T00017
         L     0,C00051
         ST    0,P00040+0
         LA    0,T00017
         ST    0,P00040+4
         LA    0,T00030
         ST    0,P00040+8
         LA    0,6
         ST    0,P00040+12
         OI    P00040+12,X'80'
         LA    1,P00040
         L     15,C00049
         BALR  14,15
         LA    15,1
         ST    15,T00018
         L     0,C00052
         ST    0,P00040+0
         LA    0,T00018
         ST    0,P00040+4
         LA    0,T00030
         ST    0,P00040+8
         LA    0,6
         ST    0,P00040+12
         OI    P00040+12,X'80'
         LA    1,P00040
         L     15,C00049
         BALR  14,15
         L     7,T00024
         LH    3,C00053
         SLL   3,0(7)
         LCR   5,7
         LH    2,C00053
         SRL   2,0(5)
         C     7,C00046
         LA    6,1
         BC    10,L00054
         SR    6,6
L00054   DS    0H
         LCR   5,6
         XR    3,2
         NR    3,5
         XR    2,3
         C     2,C00046
         LA    3,1
         BC    8,L00055
         SR    3,3
L00055   DS    0H
         ST    3,T00019
         L     0,C00056
         ST    0,P00040+0
         LA    0,T00019
         ST    0,P00040+4
         LA    0,T00030
         ST    0,P00040+8
         LA    0,6
         ST    0,P00040+12
         OI    P00040+12,X'80'
         LA    1,P00040
         L     15,C00049
         BALR  14,15
         L     2,T00024
         LCR   7,2
         LH    3,C00053
         SLL   3,0(7)
         LCR   5,7
         LH    2,C00053
         SRL   2,0(5)
         C     7,C00046
         LA    6,1
         BC    10,L00057
         SR    6,6
L00057   DS    0H
         LCR   5,6
         XR    3,2
         NR    3,5
         XR    2,3
         C     2,C00046
         LA    3,1
         BC    8,L00058
         SR    3,3
L00058   DS    0H
         ST    3,T00020
         L     0,C00059
         ST    0,P00040+0
         LA    0,T00020
         ST    0,P00040+4
         LA    0,T00030
         ST    0,P00040+8
         LA    0,6
         ST    0,P00040+12
         OI    P00040+12,X'80'
         LA    1,P00040
         L     15,C00049
         BALR  14,15
         LA    15,1
         ST    15,T00021
         L     0,C00060
         ST    0,P00040+0
         LA    0,T00021
         ST    0,P00040+4
         LA    0,T00030
         ST    0,P00040+8
         LA    0,6
         ST    0,P00040+12
         OI    P00040+12,X'80'
         LA    1,P00040
         L     15,C00049
         BALR  14,15
         LA    15,1
         ST    15,T00022
         L     0,C00061
         ST    0,P00040+0
         LA    0,T00022
         ST    0,P00040+4
         LA    0,T00030
         ST    0,P00040+8
         LA    0,6
         ST    0,P00040+12
         OI    P00040+12,X'80'
         LA    1,P00040
         L     15,C00049
         BALR  14,15
         LA    3,32
         SR    3,4
         LH    2,C00062
         SRL   2,0(3)
         LA    4,1543
         NR    4,2
         C     4,C00046
         LA    3,1
         BC    8,L00063
         SR    3,3
L00063   DS    0H
         ST    3,T00023
         L     0,C00064
         ST    0,P00040+0
         LA    0,T00023
         ST    0,P00040+4
         LA    0,T00030
         ST    0,P00040+8
         LA    0,6
         ST    0,P00040+12
         OI    P00040+12,X'80'
         LA    1,P00040
         L     15,C00049
         BALR  14,15
         LA    15,1
         ST    15,T00029
         L     0,C00065
         ST    0,P00040+0
         LA    0,T00029
         ST    0,P00040+4
         LA    0,T00030
         ST    0,P00040+8
         LA    0,6
         ST    0,P00040+12
         OI    P00040+12,X'80'
         LA    1,P00040
         L     15,C00049
         BALR  14,15
         LA    15,1
         ST    15,T00027
         L     0,C00066
         ST    0,P00040+0
         LA    0,T00027
         ST    0,P00040+4
         LA    0,T00030
         ST    0,P00040+8
         LA    0,6
         ST    0,P00040+12
         OI    P00040+12,X'80'
         LA    1,P00040
         L     15,C00049
         BALR  14,15
         LH    3,C00053
         NR    3,2
         SLL   3,2
         SLL   2,2
         LR    4,2
         X     4,C00067
         LA    2,7
         NR    2,4
         OR    2,3
         C     2,C00068
         LA    3,1
         BC    8,L00069
         SR    3,3
L00069   DS    0H
         ST    3,T00028
         L     0,C00070
         ST    0,P00040+0
         LA    0,T00028
         ST    0,P00040+4
         LA    0,T00030
         ST    0,P00040+8
         LA    0,6
         ST    0,P00040+12
         OI    P00040+12,X'80'
         LA    1,P00040
         L     15,C00049
         BALR  14,15
         LA    0,6
         ST    0,P00040+0
         L     0,C00071
         ST    0,P00040+4
         LA    1,P00040
         L     15,C00072
         BALR  14,15
         L     3,T00030
         LR    0,3
         ST    0,P00040+0
         LA    1,P00040
         L     15,C00073
         BALR  14,15
         L     15,C00074
         BALR  14,15
L00035   DS    0H
         B     L00036
L00033   DS    0H
         LR    4,2
         AH    4,C00075
         LA    5,T00024
         AR    5,4
         LR    0,5
         ST    0,P00040+0
         LA    1,P00040
         L     15,C00076
         BALR  14,15
         AH    3,C00062
         A     2,C00077
         B     L00032
L00036   DS    0H
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
T00016   DS    XL4
         DS    XL4
T00017   DS    XL4
         DS    XL4
T00018   DS    XL4
         DS    XL4
T00019   DS    XL4
         DS    XL4
T00020   DS    XL4
         DS    XL4
T00021   DS    XL4
         DS    XL4
T00022   DS    XL4
         DS    XL4
T00023   DS    XL4
         DS    XL4
T00024   DS    XL12
         DS    XL4
T00025   DS    XL12
         DS    XL4
T00026   DS    XL12
         DS    XL4
T00027   DS    XL12
         DS    XL4
T00028   DS    XL12
         DS    XL4
T00029   DS    XL16
T00030   DS    XL56
P00040   DS    5F
         DS    XL4
C00041   DC    A(Q00001)
C00042   DC    V(F77STRCP)
C00043   DC    V(F77FMTLM)
C00044   DC    A(Q00002)
C00045   DC    V(F77RDBI)
C00046   DC    F'0'
C00047   DC    V(F77RDEND)
C00048   DC    A(Q00003)
C00049   DC    V(CHK)
C00050   DC    A(Q00004)
C00051   DC    A(Q00005)
C00052   DC    A(Q00006)
C00056   DC    A(Q00007)
C00059   DC    A(Q00008)
C00060   DC    A(Q00009)
C00061   DC    A(Q00010)
C00064   DC    A(Q00011)
C00065   DC    A(Q00012)
C00066   DC    A(Q00013)
C00067   DC    F'-1'
C00068   DC    F'7'
C00070   DC    A(Q00014)
C00071   DC    A(Q00015)
C00072   DC    V(F77WRBEG)
C00073   DC    V(F77WRI)
C00074   DC    V(F77WREND)
C00076   DC    V(F77RDI)
C00077   DC    F'4'
C00053   DC    H'12345'
C00062   DC    H'-1'
C00075   DC    H'-4'
Q00015   DC    C'('' >BAD '',I2)'
Q00001   DC    C'  32  00'
Q00002   DC    C'(2I4)'
Q00003   DC    C'SHC+32'
Q00004   DC    C'SHC-32'
Q00005   DC    C'SHV+32'
Q00006   DC    C'SHV-32'
Q00007   DC    C'SHR+32'
Q00008   DC    C'SHR-32'
Q00009   DC    C'IBITSC'
Q00010   DC    C'IBITSV'
Q00011   DC    C'IBITSR'
Q00012   DC    C'MVBITC'
Q00013   DC    C'MVBITV'
Q00014   DC    C'MVBITR'
* CHK
CHK      CSECT
         USING *,15
         B     L00088
         DC    AL1(3),CL7'CHK'
L00088   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00089
L00090   DC    A(S00078)
L00089   L     15,L00090
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00078,13
         ST    1,S00078+72
L00081   DS    0H
         L     5,0(,1)
         L     4,4(,1)
         L     3,8(,1)
         L     2,0(,4)
         LTR   2,2
         BC    7,L00082
L00083   DS    0H
         LA    0,6
         ST    0,P00091+0
         L     0,C00092
         ST    0,P00091+4
         LA    1,P00091
         L     15,C00093
         BALR  14,15
         LR    0,5
         ST    0,P00091+0
         LA    0,6
         ST    0,P00091+4
         LA    1,P00091
         L     15,C00094
         BALR  14,15
         L     15,C00095
         BALR  14,15
L00086   DS    0H
         L     2,0(,3)
         A     2,C00096
         ST    2,0(,3)
L00084   DS    0H
         LA    0,0
         B     L00087
L00082   DS    0H
         LA    0,6
         ST    0,P00091+0
         L     0,C00097
         ST    0,P00091+4
         LA    1,P00091
         L     15,C00093
         BALR  14,15
         LR    0,5
         ST    0,P00091+0
         LA    0,6
         ST    0,P00091+4
         LA    1,P00091
         L     15,C00094
         BALR  14,15
         L     15,C00095
         BALR  14,15
L00085   DS    0H
         B     L00084
L00087   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00078   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00091   DS    2F
C00092   DC    A(Q00080)
C00093   DC    V(F77WRBEG)
C00094   DC    V(F77WRA)
C00095   DC    V(F77WREND)
C00096   DC    F'1'
C00097   DC    A(Q00079)
Q00079   DC    C'('' >'',A6,'' OK'')'
Q00080   DC    C'('' >'',A6,'' BAD'')'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
