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
         L     3,C00026
         AH    3,C00027
         L     0,C00026
         ST    0,P00028+0
         LA    0,4
         ST    0,P00028+4
         L     0,C00029
         ST    0,P00028+8
         LA    0,4
         ST    0,P00028+12
         LA    1,P00028
         L     15,C00030
         BALR  14,15
         LR    0,3
         ST    0,P00028+0
         LA    0,2
         ST    0,P00028+4
         L     0,C00031
         ST    0,P00028+8
         LA    0,2
         ST    0,P00028+12
         LA    1,P00028
         L     15,C00030
         BALR  14,15
         LA    0,T00012
         ST    0,P00028+0
         LA    0,8
         ST    0,P00028+4
         L     0,C00032
         ST    0,P00028+8
         LA    0,8
         ST    0,P00028+12
         LA    1,P00028
         L     15,C00030
         BALR  14,15
         LA    15,0
         ST    15,T00011
         LA    0,4
         ST    0,P00028+0
         LA    1,P00028
         L     15,C00033
         BALR  14,15
         LA    0,T00012
         ST    0,P00028+0
         LA    0,8
         ST    0,P00028+4
         LA    0,1
         ST    0,P00028+8
         L     0,C00026
         ST    0,P00028+12
         LA    0,2
         ST    0,P00028+16
         LA    1,P00028
         L     15,C00034
         BALR  14,15
         LR    3,15
         C     3,C00035
         LA    2,1
         BC    8,L00036
         SR    2,2
L00036   DS    0H
         LCR   4,2
         LR    2,3
         X     2,C00037
         NR    2,4
         XR    2,3
         C     3,C00038
         LA    5,1
         BC    8,L00039
         SR    5,5
L00039   DS    0H
         LCR   4,5
         LA    3,1
         XR    3,2
         NR    3,4
         XR    2,3
         LTR   5,5
         BC    7,L00019
L00018   DS    0H
         LA    0,T00011
         ST    0,P00028+0
         LA    1,P00028
         L     15,C00040
         BALR  14,15
         L     15,C00041
         BALR  14,15
         LA    0,1
         ST    0,P00028+0
         LA    1,P00028
         L     15,C00042
         BALR  14,15
         B     L00022
L00019   DS    0H
         LA    0,6
         ST    0,P00028+0
         L     0,C00043
         ST    0,P00028+4
         LA    1,P00028
         L     15,C00044
         BALR  14,15
         LR    0,2
         ST    0,P00028+0
         LA    1,P00028
         L     15,C00045
         BALR  14,15
         L     3,T00011
         LR    0,3
         ST    0,P00028+0
         LA    1,P00028
         L     15,C00045
         BALR  14,15
         L     15,C00046
         BALR  14,15
         LA    0,T00016
         ST    0,P00028+0
         LA    0,3
         ST    0,P00028+4
         L     0,C00047
         ST    0,P00028+8
         LA    0,3
         ST    0,P00028+12
         LA    1,P00028
         L     15,C00030
         BALR  14,15
         LA    3,T00016+3
         LR    0,3
         ST    0,P00028+0
         LA    0,3
         ST    0,P00028+4
         L     0,C00048
         ST    0,P00028+8
         LA    0,1
         ST    0,P00028+12
         LA    1,P00028
         L     15,C00030
         BALR  14,15
         LA    0,6
         ST    0,P00028+0
         LA    1,P00028
         L     15,C00033
         BALR  14,15
         LA    0,T00012
         ST    0,P00028+0
         LA    0,8
         ST    0,P00028+4
         LA    0,1
         ST    0,P00028+8
         LA    0,T00016
         ST    0,P00028+12
         LA    0,0
         ST    0,P00028+16
         LA    1,P00028
         L     15,C00034
         BALR  14,15
         LA    0,T00011
         ST    0,P00028+0
         LA    1,P00028
         L     15,C00040
         BALR  14,15
         L     15,C00041
         BALR  14,15
         LA    0,6
         ST    0,P00028+0
         L     0,C00049
         ST    0,P00028+4
         LA    1,P00028
         L     15,C00044
         BALR  14,15
         L     3,T00011
         LR    0,3
         ST    0,P00028+0
         LA    1,P00028
         L     15,C00045
         BALR  14,15
         L     15,C00046
         BALR  14,15
         LA    0,T00015
         ST    0,P00028+0
         LA    0,14
         ST    0,P00028+4
         L     0,C00050
         ST    0,P00028+8
         LA    0,13
         ST    0,P00028+12
         LA    1,P00028
         L     15,C00030
         BALR  14,15
         LA    0,10
         ST    0,P00028+0
         LA    1,P00028
         L     15,C00033
         BALR  14,15
         LA    0,6
         ST    0,P00028+0
         LA    0,T00015
         ST    0,P00028+4
         LA    1,P00028
         L     15,C00044
         BALR  14,15
         L     3,T00011
         LR    0,3
         ST    0,P00028+0
         LA    1,P00028
         L     15,C00045
         BALR  14,15
         L     15,C00046
         BALR  14,15
         LA    0,T00014
         ST    0,P00028+0
         LA    0,6
         ST    0,P00028+4
         L     0,C00051
         ST    0,P00028+8
         LA    0,6
         ST    0,P00028+12
         LA    1,P00028
         L     15,C00030
         BALR  14,15
         LA    3,T00014+6
         LR    0,3
         ST    0,P00028+0
         LA    0,6
         ST    0,P00028+4
         L     0,C00052
         ST    0,P00028+8
         LA    0,6
         ST    0,P00028+12
         LA    1,P00028
         L     15,C00030
         BALR  14,15
         LA    15,2
         ST    15,T00013
         LA    0,T00014
         ST    0,P00028+0
         LA    0,T00013
         ST    0,P00028+4
         LA    0,6
         ST    0,P00028+8
         OI    P00028+8,X'80'
         LA    1,P00028
         L     15,C00053
         BALR  14,15
         LA    0,T00014
         ST    0,P00028+0
         LA    0,6
         ST    0,P00028+4
         OI    P00028+4,X'80'
         LA    1,P00028
         L     15,C00054
         BALR  14,15
         LA    0,T00014
         ST    0,P00028+0
         LA    0,6
         ST    0,P00028+4
         OI    P00028+4,X'80'
         LA    1,P00028
         L     15,C00055
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
P00028   DS    5F
         DS    XL4
C00026   DC    A(FMTS)
C00029   DC    A(Q00001)
C00030   DC    V(F77STRCP)
C00031   DC    A(Q00002)
C00032   DC    A(Q00003)
C00033   DC    V(F77FMTLM)
C00034   DC    V(F77RDBI)
C00035   DC    F'1'
C00037   DC    F'-1'
C00038   DC    F'2'
C00040   DC    V(F77RDI)
C00041   DC    V(F77RDEND)
C00042   DC    V(EXIT)
C00043   DC    A(Q00004)
C00044   DC    V(F77WRBEG)
C00045   DC    V(F77WRI)
C00046   DC    V(F77WREND)
C00047   DC    A(Q00005)
C00048   DC    A(Q00006)
C00049   DC    A(Q00007)
C00050   DC    A(Q00008)
C00051   DC    A(Q00009)
C00052   DC    A(Q00010)
C00053   DC    V(SHOWA)
C00054   DC    V(SHOWS)
C00055   DC    V(SHOW1)
C00027   DC    H'4'
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
         B     L00059
         DC    AL1(5),CL7'SHOWA'
L00059   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00060
L00061   DC    A(S00056)
L00060   L     15,L00061
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00056,13
         ST    1,S00056+72
L00057   DS    0H
         L     3,0(,1)
         LA    0,6
         ST    0,P00062+0
         LR    0,3
         ST    0,P00062+4
         LA    1,P00062
         L     15,C00063
         BALR  14,15
         LA    0,12
         ST    0,P00062+0
         LA    1,P00062
         L     15,C00064
         BALR  14,15
         LA    0,34
         ST    0,P00062+0
         LA    1,P00062
         L     15,C00064
         BALR  14,15
         L     15,C00065
         BALR  14,15
         LA    0,0
L00058   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00056   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00062   DS    2F
C00063   DC    V(F77WRBEG)
C00064   DC    V(F77WRI)
C00065   DC    V(F77WREND)
* SHOWS
SHOWS    CSECT
         USING *,15
         B     L00069
         DC    AL1(5),CL7'SHOWS'
L00069   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00070
L00071   DC    A(S00066)
L00070   L     15,L00071
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00066,13
         ST    1,S00066+72
L00067   DS    0H
         L     3,0(,1)
         LA    0,6
         ST    0,P00072+0
         LR    0,3
         ST    0,P00072+4
         LA    1,P00072
         L     15,C00073
         BALR  14,15
         LA    0,56
         ST    0,P00072+0
         LA    1,P00072
         L     15,C00074
         BALR  14,15
         LA    0,78
         ST    0,P00072+0
         LA    1,P00072
         L     15,C00074
         BALR  14,15
         L     15,C00075
         BALR  14,15
         LA    0,0
L00068   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00066   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00072   DS    2F
C00073   DC    V(F77WRBEG)
C00074   DC    V(F77WRI)
C00075   DC    V(F77WREND)
* SHOW1
SHOW1    CSECT
         USING *,15
         B     L00079
         DC    AL1(5),CL7'SHOW1'
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
         LA    0,6
         ST    0,P00082+0
         LR    0,3
         ST    0,P00082+4
         LA    1,P00082
         L     15,C00083
         BALR  14,15
         LA    0,90
         ST    0,P00082+0
         LA    1,P00082
         L     15,C00084
         BALR  14,15
         LA    0,11
         ST    0,P00082+0
         LA    1,P00082
         L     15,C00084
         BALR  14,15
         L     15,C00085
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
P00082   DS    2F
C00083   DC    V(F77WRBEG)
C00084   DC    V(F77WRI)
C00085   DC    V(F77WREND)
FMTS     CSECT
         DS    0D
         DS    XL6
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
