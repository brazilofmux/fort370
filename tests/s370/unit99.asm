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
         LA    1,P00027
         L     15,C00028
         BALR  14,15
         LA    4,1
L00009   DS    0H
         LA    5,3
         LR    2,4
L00010   DS    0H
         LA    1,P00029
         L     15,C00030
         BALR  14,15
         LR    0,2
         ST    0,P00031+0
         LA    1,P00031
         L     15,C00032
         BALR  14,15
         LR    1,2
         MR    0,2
         LR    3,1
         LR    0,3
         ST    0,P00031+0
         LA    1,P00031
         L     15,C00032
         BALR  14,15
         L     15,C00033
         BALR  14,15
L00012   DS    0H
         BXLE  2,4,L00010
L00011   DS    0H
L00013   DS    0H
         LA    1,P00034
         L     15,C00035
         BALR  14,15
         LA    15,0
         ST    15,T00006
         LA    6,1
L00014   DS    0H
         LA    7,3
         LR    2,6
L00015   DS    0H
         LA    1,P00036
         L     15,C00037
         BALR  14,15
         LA    1,P00038
         L     15,C00039
         BALR  14,15
         LA    1,P00040
         L     15,C00039
         BALR  14,15
         L     15,C00041
         BALR  14,15
         C     2,T00007
         LA    3,1
         BC    7,L00042
         SR    3,3
L00042   DS    0H
         LR    1,2
         MR    0,2
         LR    4,1
         C     4,T00006
         LA    5,1
         BC    7,L00043
         SR    5,5
L00043   DS    0H
         OR    3,5
         LTR   3,3
         BC    7,L00017
L00018   DS    0H
L00019   DS    0H
         BXLE  2,6,L00015
L00016   DS    0H
         LA    1,P00044
         L     15,C00045
         BALR  14,15
         LA    1,P00046
         L     15,C00030
         BALR  14,15
         L     15,C00033
         BALR  14,15
L00020   DS    0H
         LA    1,P00047
         L     15,C00030
         BALR  14,15
         L     3,T00007
         LR    0,3
         ST    0,P00031+0
         LA    1,P00031
         L     15,C00032
         BALR  14,15
         L     3,T00006
         LR    0,3
         ST    0,P00031+0
         LA    1,P00031
         L     15,C00032
         BALR  14,15
         L     15,C00033
         BALR  14,15
L00021   DS    0H
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         B     L00023
L00017   DS    0H
         LA    1,P00050
         L     15,C00049
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
P00027   DC    F'99'
         DC    A(Q00001)
         DC    F'8'
         DC    A(Q00002)
         DC    F'7'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
         DC    F'0'
P00029   DC    F'99'
         DC    A(Q00005)
P00031   DC    A(0)
P00034   DC    F'99'
P00036   DC    F'99'
         DC    A(Q00005)
         DC    F'0'
P00038   DC    A(T00007)
P00040   DC    A(T00006)
P00044   DC    F'99'
         DC    F'0'
         DC    F'0'
P00046   DC    F'0'
         DC    A(Q00003)
P00047   DC    F'6'
         DC    A(Q00004)
P00048   DC    F'0'
P00050   DC    F'1'
         DS    XL4
C00028   DC    V(F77OPEN)
C00030   DC    V(F77WRBEG)
C00032   DC    V(F77WRI)
C00033   DC    V(F77WREND)
C00035   DC    V(F77REWND)
C00037   DC    V(F77RDBEG)
C00039   DC    V(F77RDI)
C00041   DC    V(F77RDEND)
C00045   DC    V(F77CLOSE)
C00049   DC    V(EXIT)
Q00005   DC    C'(2I5)'
Q00003   DC    C'('' UNIT 0'')'
Q00004   DC    C'(1X,''>UNIT99'',2I5)'
Q00001   DC    C'FT01F001'
Q00002   DC    C'UNKNOWN'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
