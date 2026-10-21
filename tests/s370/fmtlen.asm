* main
F77MAIN  CSECT
         USING *,15
         B     L00019
         DC    AL1(7),CL7'F77MAIN'
L00019   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00020
L00021   DC    A(S00000)
L00020   L     15,L00021
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00013   DS    0H
         L     3,C00022
         AH    3,C00023
         L     0,C00022
         ST    0,P00024+0
         LA    0,4
         ST    0,P00024+4
         L     0,C00025
         ST    0,P00024+8
         LA    0,4
         ST    0,P00024+12
         LA    1,P00024
         L     15,C00026
         BALR  14,15
         LR    0,3
         ST    0,P00024+0
         LA    0,2
         ST    0,P00024+4
         L     0,C00027
         ST    0,P00024+8
         LA    0,2
         ST    0,P00024+12
         LA    1,P00024
         L     15,C00026
         BALR  14,15
         LA    0,T00010
         ST    0,P00024+0
         LA    0,8
         ST    0,P00024+4
         L     0,C00028
         ST    0,P00024+8
         LA    0,8
         ST    0,P00024+12
         LA    1,P00024
         L     15,C00026
         BALR  14,15
         LA    15,0
         ST    15,T00009
         LA    0,4
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00029
         BALR  14,15
         LA    0,T00010
         ST    0,P00024+0
         LA    0,8
         ST    0,P00024+4
         LA    0,1
         ST    0,P00024+8
         L     0,C00022
         ST    0,P00024+12
         LA    0,2
         ST    0,P00024+16
         LA    1,P00024
         L     15,C00030
         BALR  14,15
         LR    3,15
         C     3,C00031
         LA    2,1
         BC    8,L00032
         SR    2,2
L00032   DS    0H
         LCR   4,2
         LR    2,3
         X     2,C00033
         NR    2,4
         XR    2,3
         C     3,C00034
         LA    5,1
         BC    8,L00035
         SR    5,5
L00035   DS    0H
         LCR   4,5
         LA    3,1
         XR    3,2
         NR    3,4
         XR    2,3
         LTR   5,5
         BC    7,L00015
L00014   DS    0H
         LA    0,T00009
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00036
         BALR  14,15
         L     15,C00037
         BALR  14,15
         LA    0,1
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00038
         BALR  14,15
         B     L00018
L00015   DS    0H
         LA    0,6
         ST    0,P00024+0
         L     0,C00039
         ST    0,P00024+4
         LA    1,P00024
         L     15,C00040
         BALR  14,15
         LR    0,2
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00041
         BALR  14,15
         L     3,T00009
         LR    0,3
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00041
         BALR  14,15
         L     15,C00042
         BALR  14,15
         LA    0,T00012
         ST    0,P00024+0
         LA    0,3
         ST    0,P00024+4
         L     0,C00043
         ST    0,P00024+8
         LA    0,3
         ST    0,P00024+12
         LA    1,P00024
         L     15,C00026
         BALR  14,15
         LA    3,T00012+3
         LR    0,3
         ST    0,P00024+0
         LA    0,3
         ST    0,P00024+4
         L     0,C00044
         ST    0,P00024+8
         LA    0,1
         ST    0,P00024+12
         LA    1,P00024
         L     15,C00026
         BALR  14,15
         LA    0,6
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00029
         BALR  14,15
         LA    0,T00010
         ST    0,P00024+0
         LA    0,8
         ST    0,P00024+4
         LA    0,1
         ST    0,P00024+8
         LA    0,T00012
         ST    0,P00024+12
         LA    0,0
         ST    0,P00024+16
         LA    1,P00024
         L     15,C00030
         BALR  14,15
         LA    0,T00009
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00036
         BALR  14,15
         L     15,C00037
         BALR  14,15
         LA    0,6
         ST    0,P00024+0
         L     0,C00045
         ST    0,P00024+4
         LA    1,P00024
         L     15,C00040
         BALR  14,15
         L     3,T00009
         LR    0,3
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00041
         BALR  14,15
         L     15,C00042
         BALR  14,15
         LA    0,T00011
         ST    0,P00024+0
         LA    0,14
         ST    0,P00024+4
         L     0,C00046
         ST    0,P00024+8
         LA    0,13
         ST    0,P00024+12
         LA    1,P00024
         L     15,C00026
         BALR  14,15
         LA    0,10
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00029
         BALR  14,15
         LA    0,6
         ST    0,P00024+0
         LA    0,T00011
         ST    0,P00024+4
         LA    1,P00024
         L     15,C00040
         BALR  14,15
         L     3,T00009
         LR    0,3
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00041
         BALR  14,15
         L     15,C00042
         BALR  14,15
L00016   DS    0H
L00017   DS    0H
L00018   DS    0H
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
T00009   DS    XL8
T00010   DS    XL12
         DS    XL4
T00011   DS    XL20
         DS    XL4
T00012   DS    XL28
         DS    XL4
P00024   DS    5F
         DS    XL4
C00022   DC    A(FMTS)
C00025   DC    A(Q00001)
C00026   DC    V(F77STRCP)
C00027   DC    A(Q00002)
C00028   DC    A(Q00003)
C00029   DC    V(F77FMTLM)
C00030   DC    V(F77RDBI)
C00031   DC    F'1'
C00033   DC    F'-1'
C00034   DC    F'2'
C00036   DC    V(F77RDI)
C00037   DC    V(F77RDEND)
C00038   DC    V(EXIT)
C00039   DC    A(Q00004)
C00040   DC    V(F77WRBEG)
C00041   DC    V(F77WRI)
C00042   DC    V(F77WREND)
C00043   DC    A(Q00005)
C00044   DC    A(Q00006)
C00045   DC    A(Q00007)
C00046   DC    A(Q00008)
C00023   DC    H'4'
Q00004   DC    C'('' >ERR '',2I3)'
Q00007   DC    C'('' >W '',I4)'
Q00001   DC    C'(I5 '
Q00002   DC    C' )'
Q00003   DC    C'   67   '
Q00005   DC    C'(I4'
Q00006   DC    C')'
Q00008   DC    C'('' >S'',I3)XYZ'
FMTS     CSECT
         DS    0D
         DS    XL6
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
