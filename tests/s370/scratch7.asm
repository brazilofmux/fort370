* main
F77MAIN  CSECT
         USING *,15
         B     L00020
         DC    AL1(7),CL7'F77MAIN'
L00020   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00021
L00022   DC    A(S00000)
L00021   L     15,L00022
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00005   DS    0H
         LA    15,1
         ST    15,T00003
L00006   DS    0H
         LH    4,C00023
         LA    5,0
         LA    2,31
L00007   DS    0H
         LA    0,7
         ST    0,P00024+0
         L     0,C00025
         ST    0,P00024+4
         LA    1,P00024
         L     15,C00026
         BALR  14,15
         L     6,T00003
         LR    0,6
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         L     3,T00003
         SLL   3,1
         LR    0,3
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LA    1,3
         M     0,T00003
         LR    6,1
         LR    0,6
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LA    0,44
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LA    0,55
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LA    0,66
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LH    0,C00028
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LA    0,1
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LA    0,2
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LA    0,3
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LA    0,4
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LA    0,5
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LA    0,6
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LA    0,7
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LA    0,8
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LA    0,9
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LA    0,0
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LA    0,11
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LA    0,22
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LA    0,333
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LA    0,444
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LH    0,C00029
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LH    0,C00030
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LH    0,C00028
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LH    0,C00031
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LH    0,C00032
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LH    0,C00033
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LH    0,C00034
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LH    0,C00035
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         LH    0,C00036
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         L     15,C00037
         BALR  14,15
L00009   DS    0H
         L     3,T00003
         A     3,C00038
         ST    3,T00003
         BXH   2,4,L00007
L00008   DS    0H
L00010   DS    0H
         LA    0,7
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00039
         BALR  14,15
L00011   DS    0H
         LH    6,C00023
         LA    7,0
         LA    3,31
         LA    2,0
L00012   DS    0H
         LA    0,7
         ST    0,P00024+0
         L     0,C00025
         ST    0,P00024+4
         LA    0,1
         ST    0,P00024+8
         LA    1,P00024
         L     15,C00040
         BALR  14,15
         LR    4,15
         C     4,C00038
         BC    8,L00015
L00014   DS    0H
         LA    0,T00003
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00041
         BALR  14,15
         LA    0,T00004
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00041
         BALR  14,15
         L     15,C00042
         BALR  14,15
         A     2,C00038
L00016   DS    0H
         BXH   3,6,L00012
L00013   DS    0H
L00015   DS    0H
         LA    0,6
         ST    0,P00024+0
         L     0,C00043
         ST    0,P00024+4
         LA    1,P00024
         L     15,C00026
         BALR  14,15
         LR    0,2
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         L     3,T00003
         LR    0,3
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         L     3,T00004
         LR    0,3
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00027
         BALR  14,15
         L     15,C00037
         BALR  14,15
L00017   DS    0H
         LA    0,0
         ST    0,P00024+0
         LA    1,P00024
         L     15,C00044
         BALR  14,15
         B     L00019
L00018   DS    0H
L00019   DS    0H
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
T00003   DS    XL8
T00004   DS    XL8
P00024   DS    3F
         DS    XL4
C00025   DC    A(Q00001)
C00026   DC    V(F77WRBEG)
C00027   DC    V(F77WRI)
C00037   DC    V(F77WREND)
C00038   DC    F'1'
C00039   DC    V(F77REWND)
C00040   DC    V(F77RDBEG)
C00041   DC    V(F77RDI)
C00042   DC    V(F77RDEND)
C00043   DC    A(Q00002)
C00044   DC    V(EXIT)
C00023   DC    H'-1'
C00028   DC    H'7777'
C00029   DC    H'5555'
C00030   DC    H'6666'
C00031   DC    H'8888'
C00032   DC    H'9999'
C00033   DC    H'32764'
C00034   DC    H'32765'
C00035   DC    H'32766'
C00036   DC    H'32767'
Q00001   DC    C'(I3,I2,I2,I3,I3,I3,I4,I1,I1,I1,I1,I1,I1,'
         DC    C'I1,I1,I1,I1,I2,I2,I3,I3,I4,I4,I4,I4,I4,I'
         DC    C'5,I5,I5,I5)'
Q00002   DC    C'('' >SCR7'',3I6)'
         END
