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
         LA    0,8
         ST    0,P00026+0
         L     0,C00027
         ST    0,P00026+4
         LA    1,P00026
         L     15,C00028
         BALR  14,15
         LA    0,12
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00029
         BALR  14,15
         LA    0,34
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00029
         BALR  14,15
         L     15,C00030
         BALR  14,15
         LA    0,8
         ST    0,P00026+0
         L     0,C00027
         ST    0,P00026+4
         LA    1,P00026
         L     15,C00028
         BALR  14,15
         LA    0,56
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00029
         BALR  14,15
         LA    0,78
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00029
         BALR  14,15
         L     15,C00030
         BALR  14,15
L00013   DS    0H
         LA    0,8
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00031
         BALR  14,15
         LA    0,8
         ST    0,P00026+0
         L     0,C00027
         ST    0,P00026+4
         LA    0,0
         ST    0,P00026+8
         LA    1,P00026
         L     15,C00032
         BALR  14,15
         LA    0,T00009
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00033
         BALR  14,15
         LA    0,T00010
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00033
         BALR  14,15
         L     15,C00034
         BALR  14,15
         LA    0,8
         ST    0,P00026+0
         L     0,C00027
         ST    0,P00026+4
         LA    0,1
         ST    0,P00026+8
         LA    1,P00026
         L     15,C00032
         BALR  14,15
         LR    2,15
         C     2,C00035
         BC    8,L00015
L00014   DS    0H
         LA    0,T00011
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00033
         BALR  14,15
         LA    0,T00011
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00033
         BALR  14,15
         L     15,C00034
         BALR  14,15
         LA    0,6
         ST    0,P00026+0
         L     0,C00036
         ST    0,P00026+4
         LA    1,P00026
         L     15,C00028
         BALR  14,15
         L     0,C00037
         ST    0,P00026+0
         LA    0,4
         ST    0,P00026+4
         LA    1,P00026
         L     15,C00038
         BALR  14,15
         L     3,T00009
         LR    0,3
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00029
         BALR  14,15
         L     3,T00010
         LR    0,3
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00029
         BALR  14,15
         L     3,T00011
         LR    0,3
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00029
         BALR  14,15
         L     15,C00030
         BALR  14,15
         LA    0,8
         ST    0,P00026+0
         L     0,C00027
         ST    0,P00026+4
         LA    0,1
         ST    0,P00026+8
         LA    1,P00026
         L     15,C00032
         BALR  14,15
         LR    2,15
         C     2,C00035
         BC    8,L00017
L00016   DS    0H
         LA    0,T00009
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00033
         BALR  14,15
         LA    0,T00010
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00033
         BALR  14,15
         L     15,C00034
         BALR  14,15
         LA    0,6
         ST    0,P00026+0
         L     0,C00039
         ST    0,P00026+4
         LA    1,P00026
         L     15,C00028
         BALR  14,15
         L     0,C00040
         ST    0,P00026+0
         LA    0,5
         ST    0,P00026+4
         LA    1,P00026
         L     15,C00038
         BALR  14,15
         L     15,C00030
         BALR  14,15
L00018   DS    0H
         LA    0,8
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00031
         BALR  14,15
         LA    0,8
         ST    0,P00026+0
         L     0,C00027
         ST    0,P00026+4
         LA    1,P00026
         L     15,C00028
         BALR  14,15
         LA    0,1
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00029
         BALR  14,15
         LA    0,2
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00029
         BALR  14,15
         L     15,C00030
         BALR  14,15
         LA    0,8
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00041
         BALR  14,15
         LA    0,8
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00031
         BALR  14,15
         LA    0,8
         ST    0,P00026+0
         L     0,C00027
         ST    0,P00026+4
         LA    0,0
         ST    0,P00026+8
         LA    1,P00026
         L     15,C00032
         BALR  14,15
         LA    0,T00009
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00033
         BALR  14,15
         LA    0,T00010
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00033
         BALR  14,15
         L     15,C00034
         BALR  14,15
         LA    0,6
         ST    0,P00026+0
         L     0,C00036
         ST    0,P00026+4
         LA    1,P00026
         L     15,C00028
         BALR  14,15
         L     0,C00042
         ST    0,P00026+0
         LA    0,5
         ST    0,P00026+4
         LA    1,P00026
         L     15,C00038
         BALR  14,15
         L     3,T00009
         LR    0,3
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00029
         BALR  14,15
         L     3,T00010
         LR    0,3
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00029
         BALR  14,15
         LA    0,0
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00029
         BALR  14,15
         L     15,C00030
         BALR  14,15
L00019   DS    0H
L00020   DS    0H
         LA    0,0
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00043
         BALR  14,15
         B     L00022
L00015   DS    0H
         LA    0,6
         ST    0,P00026+0
         L     0,C00039
         ST    0,P00026+4
         LA    1,P00026
         L     15,C00028
         BALR  14,15
         L     0,C00044
         ST    0,P00026+0
         LA    0,9
         ST    0,P00026+4
         LA    1,P00026
         L     15,C00038
         BALR  14,15
         L     15,C00030
         BALR  14,15
         B     L00018
L00017   DS    0H
         LA    0,6
         ST    0,P00026+0
         L     0,C00039
         ST    0,P00026+4
         LA    1,P00026
         L     15,C00028
         BALR  14,15
         L     0,C00045
         ST    0,P00026+0
         LA    0,6
         ST    0,P00026+4
         LA    1,P00026
         L     15,C00038
         BALR  14,15
         L     15,C00030
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
P00026   DS    3F
         DS    XL4
C00027   DC    A(Q00001)
C00028   DC    V(F77WRBEG)
C00029   DC    V(F77WRI)
C00030   DC    V(F77WREND)
C00031   DC    V(F77REWND)
C00032   DC    V(F77RDBEG)
C00033   DC    V(F77RDI)
C00034   DC    V(F77RDEND)
C00035   DC    F'1'
C00036   DC    A(Q00002)
C00037   DC    A(Q00003)
C00038   DC    V(F77WRA)
C00039   DC    A(Q00004)
C00040   DC    A(Q00005)
C00041   DC    V(F77ENDF)
C00042   DC    A(Q00008)
C00043   DC    V(EXIT)
C00044   DC    A(Q00007)
C00045   DC    A(Q00006)
Q00001   DC    C'(2I5)'
Q00002   DC    C'('' >'',A5,3I6)'
Q00004   DC    C'('' >'',A9)'
Q00003   DC    C'READ'
Q00005   DC    C'NOEOF'
Q00006   DC    C'EOF OK'
Q00007   DC    C'EARLY EOF'
Q00008   DC    C'AGAIN'
         END
