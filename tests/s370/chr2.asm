* main
F77MAIN  CSECT
         USING *,15
         B     L00022
         DC    AL1(7),CL7'F77MAIN'
L00022   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00023
L00024   DC    A(S00000)
L00023   L     15,L00024
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00013   DS    0H
         LA    1,P00025
         L     15,C00026
         BALR  14,15
         LA    1,P00027
         L     15,C00026
         BALR  14,15
         LA    1,P00028
         L     15,C00026
         BALR  14,15
         LA    1,P00029
         L     15,C00026
         BALR  14,15
         LA    1,P00030
         L     15,C00031
         BALR  14,15
         LR    2,15
         C     2,C00032
         BC    7,L00015
L00014   DS    0H
         LA    1,P00033
         L     15,C00034
         BALR  14,15
         LA    1,P00035
         L     15,C00036
         BALR  14,15
         L     15,C00037
         BALR  14,15
L00015   DS    0H
         LA    1,P00038
         L     15,C00031
         BALR  14,15
         LR    2,15
         C     2,C00032
         BC    8,L00017
L00016   DS    0H
         LA    1,P00033
         L     15,C00034
         BALR  14,15
         LA    1,P00039
         L     15,C00036
         BALR  14,15
         L     15,C00037
         BALR  14,15
L00017   DS    0H
         LA    1,P00040
         L     15,C00034
         BALR  14,15
         LA    1,P00041
         L     15,C00036
         BALR  14,15
         LA    1,P00042
         L     15,C00036
         BALR  14,15
         LA    1,P00043
         L     15,C00036
         BALR  14,15
         L     15,C00037
         BALR  14,15
L00018   DS    0H
L00019   DS    0H
         LA    1,P00044
         L     15,C00045
         BALR  14,15
         B     L00021
L00020   DS    0H
L00021   DS    0H
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
T00010   DS    XL8
T00011   DS    XL16
T00012   DS    XL16
P00025   DC    A(T00011)
         DC    F'14'
         DC    A(Q00001)
         DC    F'3'
P00027   DC    A(T00010)
         DC    F'3'
         DC    A(Q00002)
         DC    F'3'
P00028   DC    A(T00012)
         DC    F'14'
         DC    A(Q00003)
         DC    F'3'
P00029   DC    A(T00011)
         DC    F'14'
         DC    A(T00010)
         DC    F'3'
P00030   DC    A(T00011)
         DC    F'14'
         DC    A(Q00004)
         DC    F'3'
P00033   DC    F'6'
         DC    A(Q00005)
P00035   DC    A(Q00006)
         DC    F'2'
P00038   DC    A(T00011)
         DC    F'14'
         DC    A(Q00007)
         DC    F'3'
P00039   DC    A(Q00008)
         DC    F'2'
P00040   DC    F'6'
         DC    A(Q00009)
P00041   DC    A(T00011)
         DC    F'14'
P00042   DC    A(T00010)
         DC    F'3'
P00043   DC    A(T00012)
         DC    F'14'
P00044   DC    F'0'
         DS    XL4
C00026   DC    V(F77STRCP)
C00031   DC    V(F77STRCM)
C00032   DC    F'0'
C00034   DC    V(F77WRBEG)
C00036   DC    V(F77WRA)
C00037   DC    V(F77WREND)
C00045   DC    V(EXIT)
Q00005   DC    C'('' >'',A2)'
Q00009   DC    C'('' >'',A14,''#'',A3,''#'',A14,''#'')'
Q00001   DC    C'   '
Q00002   DC    C'ABC'
Q00003   DC    C'ABC'
Q00004   DC    C'ABC'
Q00006   DC    C'EQ'
Q00007   DC    C'ABC'
Q00008   DC    C'NE'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
