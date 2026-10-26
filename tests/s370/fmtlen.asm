* main
F77MAIN  CSECT
         USING *,15
         B     L00023
         DC    AL1(7),CL7'F77MAIN'
L00023   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00024
L00025   DC    A(S00000)
L00024   L     15,L00025
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00017   DS    0H
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         LA    1,P00028
         L     15,C00027
         BALR  14,15
         LA    1,P00029
         L     15,C00027
         BALR  14,15
         LA    15,0
         ST    15,T00011
         LA    1,P00030
         L     15,C00031
         BALR  14,15
         LA    1,P00032
         L     15,C00033
         BALR  14,15
         LR    3,15
         C     3,C00034
         LA    2,1
         BC    8,L00035
         SR    2,2
L00035   DS    0H
         LCR   4,2
         LR    2,3
         X     2,C00036
         NR    2,4
         XR    2,3
         C     3,C00037
         LA    5,1
         BC    8,L00038
         SR    5,5
L00038   DS    0H
         LCR   4,5
         LA    3,1
         XR    3,2
         NR    3,4
         XR    2,3
         LTR   5,5
         BC    7,L00019
L00018   DS    0H
         LA    1,P00039
         L     15,C00040
         BALR  14,15
         L     15,C00041
         BALR  14,15
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         B     L00022
L00019   DS    0H
         LA    1,P00044
         L     15,C00045
         BALR  14,15
         LR    0,2
         ST    0,P00046+0
         LA    1,P00046
         L     15,C00047
         BALR  14,15
         L     3,T00011
         LR    0,3
         ST    0,P00046+0
         LA    1,P00046
         L     15,C00047
         BALR  14,15
         L     15,C00048
         BALR  14,15
         LA    1,P00049
         L     15,C00027
         BALR  14,15
         LA    1,P00050
         L     15,C00027
         BALR  14,15
         LA    1,P00051
         L     15,C00031
         BALR  14,15
         LA    1,P00052
         L     15,C00033
         BALR  14,15
         LA    1,P00039
         L     15,C00040
         BALR  14,15
         L     15,C00041
         BALR  14,15
         LA    1,P00053
         L     15,C00045
         BALR  14,15
         L     3,T00011
         LR    0,3
         ST    0,P00046+0
         LA    1,P00046
         L     15,C00047
         BALR  14,15
         L     15,C00048
         BALR  14,15
         LA    1,P00054
         L     15,C00027
         BALR  14,15
         LA    1,P00055
         L     15,C00031
         BALR  14,15
         LA    1,P00056
         L     15,C00045
         BALR  14,15
         L     3,T00011
         LR    0,3
         ST    0,P00046+0
         LA    1,P00046
         L     15,C00047
         BALR  14,15
         L     15,C00048
         BALR  14,15
         LA    1,P00057
         L     15,C00027
         BALR  14,15
         LA    1,P00058
         L     15,C00027
         BALR  14,15
         LA    15,2
         ST    15,T00013
         LA    1,P00059
         L     15,C00060
         BALR  14,15
         LA    1,P00061
         L     15,C00062
         BALR  14,15
         LA    1,P00061
         L     15,C00063
         BALR  14,15
L00020   DS    0H
L00021   DS    0H
L00022   DS    0H
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
T00011   DS    XL8
T00012   DS    XL12
         DS    XL4
T00013   DS    XL12
         DS    XL4
T00014   DS    XL16
T00015   DS    XL20
         DS    XL4
T00016   DS    XL28
         DS    XL4
P00026   DC    A(FMTS)
         DC    F'4'
         DC    A(Q00001)
         DC    F'4'
P00028   DC    A(FMTS+4)
         DC    F'2'
         DC    A(Q00002)
         DC    F'2'
P00029   DC    A(T00012)
         DC    F'8'
         DC    A(Q00003)
         DC    F'8'
P00030   DC    F'4'
P00032   DC    A(T00012)
         DC    F'8'
         DC    F'1'
         DC    A(FMTS)
         DC    F'2'
P00039   DC    A(T00011)
P00042   DC    F'1'
P00044   DC    F'6'
         DC    A(Q00004)
P00046   DC    A(0)
P00049   DC    A(T00016)
         DC    F'3'
         DC    A(Q00005)
         DC    F'3'
P00050   DC    A(T00016+3)
         DC    F'3'
         DC    A(Q00006)
         DC    F'1'
P00051   DC    F'6'
P00052   DC    A(T00012)
         DC    F'8'
         DC    F'1'
         DC    A(T00016)
         DC    F'0'
P00053   DC    F'6'
         DC    A(Q00007)
P00054   DC    A(T00015)
         DC    F'14'
         DC    A(Q00008)
         DC    F'13'
P00055   DC    F'10'
P00056   DC    F'6'
         DC    A(T00015)
P00057   DC    A(T00014)
         DC    F'6'
         DC    A(Q00009)
         DC    F'6'
P00058   DC    A(T00014+6)
         DC    F'6'
         DC    A(Q00010)
         DC    F'6'
P00059   DC    A(T00014)
         DC    A(T00013)
         DC    XL1'80',FL3'6'
P00061   DC    A(T00014)
         DC    XL1'80',FL3'6'
         DS    XL4
C00027   DC    V(F77STRCP)
C00031   DC    V(F77FMTLM)
C00033   DC    V(F77RDBI)
C00034   DC    F'1'
C00036   DC    F'-1'
C00037   DC    F'2'
C00040   DC    V(F77RDI)
C00041   DC    V(F77RDEND)
C00043   DC    V(EXIT)
C00045   DC    V(F77WRBEG)
C00047   DC    V(F77WRI)
C00048   DC    V(F77WREND)
C00060   DC    V(SHOWA)
C00062   DC    V(SHOWS)
C00063   DC    V(SHOW1)
Q00004   DC    C'('' >ERR '',2I3)'
Q00007   DC    C'('' >W '',I4)'
Q00001   DC    C'(I5 '
Q00002   DC    C' )'
Q00003   DC    C'   67   '
Q00005   DC    C'(I4'
Q00006   DC    C')'
Q00008   DC    C'('' >S'',I3)XYZ'
Q00009   DC    C'('' >A'''
Q00010   DC    C',2I3) '
* SHOWA
SHOWA    CSECT
         USING *,15
         B     L00067
         DC    AL1(5),CL7'SHOWA'
L00067   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00068
L00069   DC    A(S00064)
L00068   L     15,L00069
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00064,13
         ST    1,S00064+72
L00065   DS    0H
         L     3,0(,1)
         LR    0,3
         ST    0,P00070+4
         LA    1,P00070
         L     15,C00071
         BALR  14,15
         LA    1,P00072
         L     15,C00073
         BALR  14,15
         LA    1,P00074
         L     15,C00073
         BALR  14,15
         L     15,C00075
         BALR  14,15
         LA    0,0
L00066   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00064   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00070   DC    F'6'
         DC    A(0)
P00072   DC    F'12'
P00074   DC    F'34'
C00071   DC    V(F77WRBEG)
C00073   DC    V(F77WRI)
C00075   DC    V(F77WREND)
* SHOWS
SHOWS    CSECT
         USING *,15
         B     L00079
         DC    AL1(5),CL7'SHOWS'
L00079   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00080
L00081   DC    A(S00076)
L00080   L     15,L00081
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00076,13
         ST    1,S00076+72
L00077   DS    0H
         L     3,0(,1)
         LR    0,3
         ST    0,P00082+4
         LA    1,P00082
         L     15,C00083
         BALR  14,15
         LA    1,P00084
         L     15,C00085
         BALR  14,15
         LA    1,P00086
         L     15,C00085
         BALR  14,15
         L     15,C00087
         BALR  14,15
         LA    0,0
L00078   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00076   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00082   DC    F'6'
         DC    A(0)
P00084   DC    F'56'
P00086   DC    F'78'
C00083   DC    V(F77WRBEG)
C00085   DC    V(F77WRI)
C00087   DC    V(F77WREND)
* SHOW1
SHOW1    CSECT
         USING *,15
         B     L00091
         DC    AL1(5),CL7'SHOW1'
L00091   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00092
L00093   DC    A(S00088)
L00092   L     15,L00093
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00088,13
         ST    1,S00088+72
L00089   DS    0H
         L     3,0(,1)
         LR    0,3
         ST    0,P00094+4
         LA    1,P00094
         L     15,C00095
         BALR  14,15
         LA    1,P00096
         L     15,C00097
         BALR  14,15
         LA    1,P00098
         L     15,C00097
         BALR  14,15
         L     15,C00099
         BALR  14,15
         LA    0,0
L00090   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00088   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00094   DC    F'6'
         DC    A(0)
P00096   DC    F'90'
P00098   DC    F'11'
C00095   DC    V(F77WRBEG)
C00097   DC    V(F77WRI)
C00099   DC    V(F77WREND)
FMTS     CSECT
         DS    0D
         DS    XL6
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
