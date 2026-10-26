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
         LA    1,P00024
         L     15,C00025
         BALR  14,15
         L     6,T00003
         LR    0,6
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         L     3,T00003
         SLL   3,1
         LR    0,3
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         LA    1,3
         M     0,T00003
         LR    6,1
         LR    0,6
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         LA    1,P00028
         L     15,C00027
         BALR  14,15
         LA    1,P00029
         L     15,C00027
         BALR  14,15
         LA    1,P00030
         L     15,C00027
         BALR  14,15
         LA    1,P00031
         L     15,C00027
         BALR  14,15
         LA    1,P00032
         L     15,C00027
         BALR  14,15
         LA    1,P00033
         L     15,C00027
         BALR  14,15
         LA    1,P00034
         L     15,C00027
         BALR  14,15
         LA    1,P00035
         L     15,C00027
         BALR  14,15
         LA    1,P00036
         L     15,C00027
         BALR  14,15
         LA    1,P00037
         L     15,C00027
         BALR  14,15
         LA    1,P00038
         L     15,C00027
         BALR  14,15
         LA    1,P00039
         L     15,C00027
         BALR  14,15
         LA    1,P00040
         L     15,C00027
         BALR  14,15
         LA    1,P00041
         L     15,C00027
         BALR  14,15
         LA    1,P00042
         L     15,C00027
         BALR  14,15
         LA    1,P00043
         L     15,C00027
         BALR  14,15
         LA    1,P00044
         L     15,C00027
         BALR  14,15
         LA    1,P00045
         L     15,C00027
         BALR  14,15
         LA    1,P00046
         L     15,C00027
         BALR  14,15
         LA    1,P00047
         L     15,C00027
         BALR  14,15
         LA    1,P00031
         L     15,C00027
         BALR  14,15
         LA    1,P00048
         L     15,C00027
         BALR  14,15
         LA    1,P00049
         L     15,C00027
         BALR  14,15
         LA    1,P00050
         L     15,C00027
         BALR  14,15
         LA    1,P00051
         L     15,C00027
         BALR  14,15
         LA    1,P00052
         L     15,C00027
         BALR  14,15
         LA    1,P00053
         L     15,C00027
         BALR  14,15
         L     15,C00054
         BALR  14,15
L00009   DS    0H
         L     3,T00003
         A     3,C00055
         ST    3,T00003
         BXH   2,4,L00007
L00008   DS    0H
L00010   DS    0H
         LA    1,P00038
         L     15,C00056
         BALR  14,15
L00011   DS    0H
         LH    6,C00023
         LA    7,0
         LA    3,31
         LA    2,0
L00012   DS    0H
         LA    1,P00057
         L     15,C00058
         BALR  14,15
         LR    4,15
         C     4,C00055
         BC    8,L00015
L00014   DS    0H
         LA    1,P00059
         L     15,C00060
         BALR  14,15
         LA    1,P00061
         L     15,C00060
         BALR  14,15
         L     15,C00062
         BALR  14,15
         A     2,C00055
L00016   DS    0H
         BXH   3,6,L00012
L00013   DS    0H
L00015   DS    0H
         LA    1,P00063
         L     15,C00025
         BALR  14,15
         LR    0,2
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         L     3,T00003
         LR    0,3
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         L     3,T00004
         LR    0,3
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         L     15,C00054
         BALR  14,15
L00017   DS    0H
         LA    1,P00041
         L     15,C00064
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
P00024   DC    F'7'
         DC    A(Q00001)
P00026   DC    A(0)
P00028   DC    F'44'
P00029   DC    F'55'
P00030   DC    F'66'
P00031   DC    F'7777'
P00032   DC    F'1'
P00033   DC    F'2'
P00034   DC    F'3'
P00035   DC    F'4'
P00036   DC    F'5'
P00037   DC    F'6'
P00038   DC    F'7'
P00039   DC    F'8'
P00040   DC    F'9'
P00041   DC    F'0'
P00042   DC    F'11'
P00043   DC    F'22'
P00044   DC    F'333'
P00045   DC    F'444'
P00046   DC    F'5555'
P00047   DC    F'6666'
P00048   DC    F'8888'
P00049   DC    F'9999'
P00050   DC    F'32764'
P00051   DC    F'32765'
P00052   DC    F'32766'
P00053   DC    F'32767'
P00057   DC    F'7'
         DC    A(Q00001)
         DC    F'1'
P00059   DC    A(T00003)
P00061   DC    A(T00004)
P00063   DC    F'6'
         DC    A(Q00002)
C00025   DC    V(F77WRBEG)
C00027   DC    V(F77WRI)
C00054   DC    V(F77WREND)
C00055   DC    F'1'
C00056   DC    V(F77REWND)
C00058   DC    V(F77RDBEG)
C00060   DC    V(F77RDI)
C00062   DC    V(F77RDEND)
C00064   DC    V(EXIT)
C00023   DC    H'-1'
Q00001   DC    C'(I3,I2,I2,I3,I3,I3,I4,I1,I1,I1,I1,I1,I1,'
         DC    C'I1,I1,I1,I1,I2,I2,I3,I3,I4,I4,I4,I4,I4,I'
         DC    C'5,I5,I5,I5)'
Q00002   DC    C'('' >SCR7'',3I6)'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
