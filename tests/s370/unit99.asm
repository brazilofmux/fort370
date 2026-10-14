* main
F77MAIN  CSECT
         USING *,15
         B     L00024
         DC    AL1(7),CL7'F77MAIN'
L00024   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00025
L00026   DC    A(S00000)
L00025   L     15,L00026
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00008   DS    0H
         LA    0,99
         ST    0,P00027+0
         L     0,C00028
         ST    0,P00027+4
         LA    0,8
         ST    0,P00027+8
         L     0,C00029
         ST    0,P00027+12
         LA    0,7
         ST    0,P00027+16
         LA    0,0
         ST    0,P00027+20
         LA    0,0
         ST    0,P00027+24
         LA    0,0
         ST    0,P00027+28
         LA    0,0
         ST    0,P00027+32
         LA    0,0
         ST    0,P00027+36
         LA    0,0
         ST    0,P00027+40
         LA    0,0
         ST    0,P00027+44
         LA    0,0
         ST    0,P00027+48
         LA    1,P00027
         L     15,C00030
         BALR  14,15
         LA    4,1
L00009   DS    0H
         LA    5,3
         LR    2,4
L00010   DS    0H
         LA    0,99
         ST    0,P00027+0
         L     0,C00031
         ST    0,P00027+4
         LA    1,P00027
         L     15,C00032
         BALR  14,15
         LR    0,2
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00033
         BALR  14,15
         LR    1,2
         MR    0,2
         LR    3,1
         LR    0,3
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00033
         BALR  14,15
         L     15,C00034
         BALR  14,15
L00012   DS    0H
         BXLE  2,4,L00010
L00011   DS    0H
L00013   DS    0H
         LA    0,99
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00035
         BALR  14,15
         LA    15,0
         ST    15,T00006
         LA    6,1
L00014   DS    0H
         LA    7,3
         LR    2,6
L00015   DS    0H
         LA    0,99
         ST    0,P00027+0
         L     0,C00031
         ST    0,P00027+4
         LA    0,0
         ST    0,P00027+8
         LA    1,P00027
         L     15,C00036
         BALR  14,15
         LA    0,T00007
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00037
         BALR  14,15
         LA    0,T00006
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00037
         BALR  14,15
         L     15,C00038
         BALR  14,15
         C     2,T00007
         LA    3,1
         BC    7,L00039
         SR    3,3
L00039   DS    0H
         LR    1,2
         MR    0,2
         LR    4,1
         C     4,T00006
         LA    5,1
         BC    7,L00040
         SR    5,5
L00040   DS    0H
         OR    3,5
         LTR   3,3
         BC    7,L00017
L00018   DS    0H
L00019   DS    0H
         BXLE  2,6,L00015
L00016   DS    0H
         LA    0,99
         ST    0,P00027+0
         LA    0,0
         ST    0,P00027+4
         LA    0,0
         ST    0,P00027+8
         LA    1,P00027
         L     15,C00041
         BALR  14,15
         LA    0,0
         ST    0,P00027+0
         L     0,C00042
         ST    0,P00027+4
         LA    1,P00027
         L     15,C00032
         BALR  14,15
         L     15,C00034
         BALR  14,15
L00020   DS    0H
         LA    0,6
         ST    0,P00027+0
         L     0,C00043
         ST    0,P00027+4
         LA    1,P00027
         L     15,C00032
         BALR  14,15
         L     3,T00007
         LR    0,3
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00033
         BALR  14,15
         L     3,T00006
         LR    0,3
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00033
         BALR  14,15
         L     15,C00034
         BALR  14,15
L00021   DS    0H
         LA    0,0
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00044
         BALR  14,15
         B     L00023
L00017   DS    0H
         LA    0,1
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00044
         BALR  14,15
         B     L00023
L00022   DS    0H
L00023   DS    0H
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
T00006   DS    XL8
T00007   DS    XL16
P00027   DS    13F
         DS    XL4
C00028   DC    A(Q00001)
C00029   DC    A(Q00002)
C00030   DC    V(F77OPEN)
C00031   DC    A(Q00005)
C00032   DC    V(F77WRBEG)
C00033   DC    V(F77WRI)
C00034   DC    V(F77WREND)
C00035   DC    V(F77REWND)
C00036   DC    V(F77RDBEG)
C00037   DC    V(F77RDI)
C00038   DC    V(F77RDEND)
C00041   DC    V(F77CLOSE)
C00042   DC    A(Q00003)
C00043   DC    A(Q00004)
C00044   DC    V(EXIT)
Q00005   DC    C'(2I5)'
Q00003   DC    C'('' UNIT 0'')'
Q00004   DC    C'(1X,''>UNIT99'',2I5)'
Q00001   DC    C'FT01F001'
Q00002   DC    C'UNKNOWN'
         END
