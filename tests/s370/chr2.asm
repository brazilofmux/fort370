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
         LA    0,T00011
         ST    0,P00025+0
         LA    0,14
         ST    0,P00025+4
         L     0,C00026
         ST    0,P00025+8
         LA    0,3
         ST    0,P00025+12
         LA    1,P00025
         L     15,C00027
         BALR  14,15
         LA    0,T00010
         ST    0,P00025+0
         LA    0,3
         ST    0,P00025+4
         L     0,C00028
         ST    0,P00025+8
         LA    0,3
         ST    0,P00025+12
         LA    1,P00025
         L     15,C00027
         BALR  14,15
         LA    0,T00012
         ST    0,P00025+0
         LA    0,14
         ST    0,P00025+4
         L     0,C00029
         ST    0,P00025+8
         LA    0,3
         ST    0,P00025+12
         LA    1,P00025
         L     15,C00027
         BALR  14,15
         LA    0,T00011
         ST    0,P00025+0
         LA    0,14
         ST    0,P00025+4
         LA    0,T00010
         ST    0,P00025+8
         LA    0,3
         ST    0,P00025+12
         LA    1,P00025
         L     15,C00027
         BALR  14,15
         LA    0,T00011
         ST    0,P00025+0
         LA    0,14
         ST    0,P00025+4
         L     0,C00030
         ST    0,P00025+8
         LA    0,3
         ST    0,P00025+12
         LA    1,P00025
         L     15,C00031
         BALR  14,15
         LR    2,15
         C     2,C00032
         BC    7,L00015
L00014   DS    0H
         LA    0,6
         ST    0,P00025+0
         L     0,C00033
         ST    0,P00025+4
         LA    1,P00025
         L     15,C00034
         BALR  14,15
         L     0,C00035
         ST    0,P00025+0
         LA    0,2
         ST    0,P00025+4
         LA    1,P00025
         L     15,C00036
         BALR  14,15
         L     15,C00037
         BALR  14,15
L00015   DS    0H
         LA    0,T00011
         ST    0,P00025+0
         LA    0,14
         ST    0,P00025+4
         L     0,C00038
         ST    0,P00025+8
         LA    0,3
         ST    0,P00025+12
         LA    1,P00025
         L     15,C00031
         BALR  14,15
         LR    2,15
         C     2,C00032
         BC    8,L00017
L00016   DS    0H
         LA    0,6
         ST    0,P00025+0
         L     0,C00033
         ST    0,P00025+4
         LA    1,P00025
         L     15,C00034
         BALR  14,15
         L     0,C00039
         ST    0,P00025+0
         LA    0,2
         ST    0,P00025+4
         LA    1,P00025
         L     15,C00036
         BALR  14,15
         L     15,C00037
         BALR  14,15
L00017   DS    0H
         LA    0,6
         ST    0,P00025+0
         L     0,C00040
         ST    0,P00025+4
         LA    1,P00025
         L     15,C00034
         BALR  14,15
         LA    0,T00011
         ST    0,P00025+0
         LA    0,14
         ST    0,P00025+4
         LA    1,P00025
         L     15,C00036
         BALR  14,15
         LA    0,T00010
         ST    0,P00025+0
         LA    0,3
         ST    0,P00025+4
         LA    1,P00025
         L     15,C00036
         BALR  14,15
         LA    0,T00012
         ST    0,P00025+0
         LA    0,14
         ST    0,P00025+4
         LA    1,P00025
         L     15,C00036
         BALR  14,15
         L     15,C00037
         BALR  14,15
L00018   DS    0H
L00019   DS    0H
         LA    0,0
         ST    0,P00025+0
         LA    1,P00025
         L     15,C00041
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
P00025   DS    4F
C00026   DC    A(Q00001)
C00027   DC    V(F77STRCP)
C00028   DC    A(Q00002)
C00029   DC    A(Q00003)
C00030   DC    A(Q00004)
C00031   DC    V(F77STRCM)
C00032   DC    F'0'
C00033   DC    A(Q00005)
C00034   DC    V(F77WRBEG)
C00035   DC    A(Q00006)
C00036   DC    V(F77WRA)
C00037   DC    V(F77WREND)
C00038   DC    A(Q00007)
C00039   DC    A(Q00008)
C00040   DC    A(Q00009)
C00041   DC    V(EXIT)
Q00005   DC    C'('' >'',A2)'
Q00009   DC    C'('' >'',A14,''#'',A3,''#'',A14,''#'')'
Q00001   DC    C'   '
Q00002   DC    C'ABC'
Q00003   DC    C'ABC'
Q00004   DC    C'ABC'
Q00006   DC    C'EQ'
Q00007   DC    C'ABC'
Q00008   DC    C'NE'
         END
