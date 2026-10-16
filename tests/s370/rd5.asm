* main
F77MAIN  CSECT
         USING *,15
         B     L00017
         DC    AL1(7),CL7'F77MAIN'
L00017   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00018
L00019   DC    A(S00000)
L00018   L     15,L00019
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00009   DS    0H
         LA    0,6
         ST    0,P00020+0
         L     0,C00021
         ST    0,P00020+4
         LA    1,P00020
         L     15,C00022
         BALR  14,15
         L     15,C00023
         BALR  14,15
L00010   DS    0H
         LA    0,5
         ST    0,P00020+0
         L     0,C00024
         ST    0,P00020+4
         LA    0,0
         ST    0,P00020+8
         LA    1,P00020
         L     15,C00025
         BALR  14,15
         LA    0,T00006
         ST    0,P00020+0
         LA    1,P00020
         L     15,C00026
         BALR  14,15
         LA    0,T00007
         ST    0,P00020+0
         LA    1,P00020
         L     15,C00026
         BALR  14,15
         L     15,C00027
         BALR  14,15
L00011   DS    0H
         LA    0,6
         ST    0,P00020+0
         L     0,C00028
         ST    0,P00020+4
         LA    1,P00020
         L     15,C00022
         BALR  14,15
         L     3,T00006
         LR    0,3
         ST    0,P00020+0
         LA    1,P00020
         L     15,C00029
         BALR  14,15
         L     3,T00007
         LR    0,3
         ST    0,P00020+0
         LA    1,P00020
         L     15,C00029
         BALR  14,15
         L     15,C00023
         BALR  14,15
L00012   DS    0H
         LA    0,5
         ST    0,P00020+0
         LA    0,0
         ST    0,P00020+4
         LA    0,0
         ST    0,P00020+8
         LA    1,P00020
         L     15,C00025
         BALR  14,15
         LA    0,T00008
         ST    0,P00020+0
         LA    1,P00020
         L     15,C00030
         BALR  14,15
         L     15,C00027
         BALR  14,15
         LA    0,6
         ST    0,P00020+0
         L     0,C00031
         ST    0,P00020+4
         LA    1,P00020
         L     15,C00022
         BALR  14,15
         LD    0,T00008
         STD   0,S00000+208
         LD    0,S00000+208
         STD   0,P00020+0
         LA    1,P00020
         L     15,C00032
         BALR  14,15
         L     15,C00023
         BALR  14,15
L00013   DS    0H
         LA    0,7
         ST    0,P00020+0
         L     0,C00033
         ST    0,P00020+4
         LA    1,P00020
         L     15,C00022
         BALR  14,15
         L     2,T00006
         A     2,T00007
         LR    0,2
         ST    0,P00020+0
         LA    1,P00020
         L     15,C00029
         BALR  14,15
         L     15,C00023
         BALR  14,15
L00014   DS    0H
         LA    0,0
         ST    0,P00020+0
         LA    1,P00020
         L     15,C00034
         BALR  14,15
         B     L00016
L00015   DS    0H
L00016   DS    0H
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
T00007   DS    XL8
T00008   DS    XL12
         DS    XL4
         DS    1D
P00020   DS    3F
         DS    XL4
C00021   DC    A(Q00001)
C00022   DC    V(F77WRBEG)
C00023   DC    V(F77WREND)
C00024   DC    A(Q00002)
C00025   DC    V(F77RDBEG)
C00026   DC    V(F77RDI)
C00027   DC    V(F77RDEND)
C00028   DC    A(Q00003)
C00029   DC    V(F77WRI)
C00030   DC    V(F77RDD)
C00031   DC    A(Q00004)
C00032   DC    V(F77WRD)
C00033   DC    A(Q00005)
C00034   DC    V(EXIT)
Q00001   DC    C'('' >RD5 START'')'
Q00002   DC    C'(2I5)'
Q00003   DC    C'('' >RD5 FORMATTED'',2I6)'
Q00004   DC    C'('' >RD5 LISTED '',D22.15)'
Q00005   DC    C'('' >RD5 PUNCH'',I6)'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
