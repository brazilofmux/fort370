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
L00012   DS    0H
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         LA    1,P00030
         L     15,C00029
         BALR  14,15
         L     15,C00031
         BALR  14,15
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         LA    1,P00032
         L     15,C00029
         BALR  14,15
         LA    1,P00033
         L     15,C00029
         BALR  14,15
         L     15,C00031
         BALR  14,15
L00013   DS    0H
         LA    1,P00034
         L     15,C00035
         BALR  14,15
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
         LA    1,P00042
         L     15,C00037
         BALR  14,15
         LR    2,15
         C     2,C00043
         BC    8,L00015
L00014   DS    0H
         LA    1,P00044
         L     15,C00039
         BALR  14,15
         LA    1,P00044
         L     15,C00039
         BALR  14,15
         L     15,C00041
         BALR  14,15
         LA    1,P00045
         L     15,C00027
         BALR  14,15
         LA    1,P00046
         L     15,C00047
         BALR  14,15
         L     3,T00009
         LR    0,3
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00029
         BALR  14,15
         L     3,T00010
         LR    0,3
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00029
         BALR  14,15
         L     3,T00011
         LR    0,3
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00029
         BALR  14,15
         L     15,C00031
         BALR  14,15
         LA    1,P00042
         L     15,C00037
         BALR  14,15
         LR    2,15
         C     2,C00043
         BC    8,L00017
L00016   DS    0H
         LA    1,P00038
         L     15,C00039
         BALR  14,15
         LA    1,P00040
         L     15,C00039
         BALR  14,15
         L     15,C00041
         BALR  14,15
         LA    1,P00049
         L     15,C00027
         BALR  14,15
         LA    1,P00050
         L     15,C00047
         BALR  14,15
         L     15,C00031
         BALR  14,15
L00018   DS    0H
         LA    1,P00034
         L     15,C00035
         BALR  14,15
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         LA    1,P00051
         L     15,C00029
         BALR  14,15
         LA    1,P00052
         L     15,C00029
         BALR  14,15
         L     15,C00031
         BALR  14,15
         LA    1,P00034
         L     15,C00053
         BALR  14,15
         LA    1,P00034
         L     15,C00035
         BALR  14,15
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
         LA    1,P00045
         L     15,C00027
         BALR  14,15
         LA    1,P00054
         L     15,C00047
         BALR  14,15
         L     3,T00009
         LR    0,3
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00029
         BALR  14,15
         L     3,T00010
         LR    0,3
         ST    0,P00048+0
         LA    1,P00048
         L     15,C00029
         BALR  14,15
         LA    1,P00055
         L     15,C00029
         BALR  14,15
         L     15,C00031
         BALR  14,15
L00019   DS    0H
L00020   DS    0H
         LA    1,P00055
         L     15,C00056
         BALR  14,15
         B     L00022
L00015   DS    0H
         LA    1,P00049
         L     15,C00027
         BALR  14,15
         LA    1,P00057
         L     15,C00047
         BALR  14,15
         L     15,C00031
         BALR  14,15
         B     L00018
L00017   DS    0H
         LA    1,P00049
         L     15,C00027
         BALR  14,15
         LA    1,P00058
         L     15,C00047
         BALR  14,15
         L     15,C00031
         BALR  14,15
         B     L00018
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
T00009   DS    XL8
T00010   DS    XL8
T00011   DS    XL8
P00026   DC    F'8'
         DC    A(Q00001)
P00028   DC    F'12'
P00030   DC    F'34'
P00032   DC    F'56'
P00033   DC    F'78'
P00034   DC    F'8'
P00036   DC    F'8'
         DC    A(Q00001)
         DC    F'0'
P00038   DC    A(T00009)
P00040   DC    A(T00010)
P00042   DC    F'8'
         DC    A(Q00001)
         DC    F'1'
P00044   DC    A(T00011)
P00045   DC    F'6'
         DC    A(Q00002)
P00046   DC    A(Q00003)
         DC    F'4'
P00048   DC    A(0)
P00049   DC    F'6'
         DC    A(Q00004)
P00050   DC    A(Q00005)
         DC    F'5'
P00051   DC    F'1'
P00052   DC    F'2'
P00054   DC    A(Q00008)
         DC    F'5'
P00055   DC    F'0'
P00057   DC    A(Q00007)
         DC    F'9'
P00058   DC    A(Q00006)
         DC    F'6'
C00027   DC    V(F77WRBEG)
C00029   DC    V(F77WRI)
C00031   DC    V(F77WREND)
C00035   DC    V(F77REWND)
C00037   DC    V(F77RDBEG)
C00039   DC    V(F77RDI)
C00041   DC    V(F77RDEND)
C00043   DC    F'1'
C00047   DC    V(F77WRA)
C00053   DC    V(F77ENDF)
C00056   DC    V(EXIT)
Q00001   DC    C'(2I5)'
Q00002   DC    C'('' >'',A5,3I6)'
Q00004   DC    C'('' >'',A9)'
Q00003   DC    C'READ'
Q00005   DC    C'NOEOF'
Q00006   DC    C'EOF OK'
Q00007   DC    C'EARLY EOF'
Q00008   DC    C'AGAIN'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
