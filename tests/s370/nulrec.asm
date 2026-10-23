* main
F77MAIN  CSECT
         USING *,15
         B     L00014
         DC    AL1(7),CL7'F77MAIN'
L00014   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00015
L00016   DC    A(S00000)
L00015   L     15,L00016
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00011   DS    0H
         LA    0,T00010
         ST    0,P00017+0
         LA    0,12
         ST    0,P00017+4
         L     0,C00018
         ST    0,P00017+8
         LA    0,2
         ST    0,P00017+12
         LA    1,P00017
         L     15,C00019
         BALR  14,15
         LA    4,T00010
         A     4,C00020
         LA    15,0
         STC   15,T00005
         LA    15,0
         STC   15,T00006
         LA    0,T00007
         ST    0,P00017+0
         LA    0,1
         ST    0,P00017+4
         LA    0,T00005
         ST    0,P00017+8
         LA    0,1
         ST    0,P00017+12
         LA    1,P00017
         L     15,C00019
         BALR  14,15
         LA    3,T00007+1
         LR    0,3
         ST    0,P00017+0
         LA    0,1
         ST    0,P00017+4
         LA    0,T00006
         ST    0,P00017+8
         LA    0,1
         ST    0,P00017+12
         LA    1,P00017
         L     15,C00019
         BALR  14,15
         LA    15,0
         STC   15,T00008
         LA    0,T00009
         ST    0,P00017+0
         LA    0,2
         ST    0,P00017+4
         LA    0,T00007
         ST    0,P00017+8
         LA    0,2
         ST    0,P00017+12
         LA    1,P00017
         L     15,C00019
         BALR  14,15
         LA    3,T00009+2
         LR    0,3
         ST    0,P00017+0
         LA    0,1
         ST    0,P00017+4
         LA    0,T00008
         ST    0,P00017+8
         LA    0,1
         ST    0,P00017+12
         LA    1,P00017
         L     15,C00019
         BALR  14,15
         LR    0,4
         ST    0,P00017+0
         LA    0,3
         ST    0,P00017+4
         LA    0,T00009
         ST    0,P00017+8
         LA    0,3
         ST    0,P00017+12
         LA    1,P00017
         L     15,C00019
         BALR  14,15
         LA    3,T00010
         A     3,C00021
         LR    0,3
         ST    0,P00017+0
         LA    0,7
         ST    0,P00017+4
         L     0,C00022
         ST    0,P00017+8
         LA    0,7
         ST    0,P00017+12
         LA    1,P00017
         L     15,C00019
         BALR  14,15
         LA    0,6
         ST    0,P00017+0
         L     0,C00023
         ST    0,P00017+4
         LA    1,P00017
         L     15,C00024
         BALR  14,15
         LA    0,T00010
         ST    0,P00017+0
         LA    0,12
         ST    0,P00017+4
         LA    1,P00017
         L     15,C00025
         BALR  14,15
         L     15,C00026
         BALR  14,15
         LA    0,6
         ST    0,P00017+0
         L     0,C00023
         ST    0,P00017+4
         LA    1,P00017
         L     15,C00024
         BALR  14,15
         LA    0,T00010
         ST    0,P00017+0
         LA    0,5
         ST    0,P00017+4
         LA    1,P00017
         L     15,C00025
         BALR  14,15
         L     0,C00027
         ST    0,P00017+0
         LA    0,2
         ST    0,P00017+4
         LA    1,P00017
         L     15,C00025
         BALR  14,15
         L     15,C00026
         BALR  14,15
L00012   DS    0H
L00013   DS    0H
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
T00005   DS    XL4
         DS    XL4
T00006   DS    XL4
         DS    XL4
T00007   DS    XL4
         DS    XL4
T00008   DS    XL4
         DS    XL4
T00009   DS    XL4
         DS    XL4
T00010   DS    XL16
P00017   DS    4F
C00018   DC    A(Q00001)
C00019   DC    V(F77STRCP)
C00020   DC    F'2'
C00021   DC    F'5'
C00022   DC    A(Q00002)
C00023   DC    A(Q00003)
C00024   DC    V(F77WRBEG)
C00025   DC    V(F77WRA)
C00026   DC    V(F77WREND)
C00027   DC    A(Q00004)
Q00003   DC    C'(1X,A,A)'
Q00001   DC    C'>N'
Q00002   DC    C'WXYZ 42'
Q00004   DC    C'>T'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
