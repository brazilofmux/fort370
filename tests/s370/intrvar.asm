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
L00003   DS    0H
         L     4,C00018
L00004   DS    0H
         LA    6,4
         LA    7,12
         LA    2,4
         LA    3,1
L00005   DS    0H
         LR    1,3
         M     0,0(,4)
         LR    5,1
         ST    5,T00002-4(2)
L00007   DS    0H
         A     3,C00019
         BXLE  2,6,L00005
L00006   DS    0H
         L     14,C00018
         L     3,0(,14)
         S     3,C00019
         A     3,C00019
L00008   DS    0H
         LH    6,C00020
         LA    7,0
         C     3,C00021
         BC    2,L00022
         LA    2,0
         B     L00010
L00022   DS    0H
         LA    2,0
         B     L00009
L00010   DS    0H
         LA    0,6
         ST    0,P00023+0
         L     0,C00024
         ST    0,P00023+4
         LA    1,P00023
         L     15,C00025
         BALR  14,15
         L     14,C00018
         L     5,0(,14)
         LR    0,5
         ST    0,P00023+0
         LA    1,P00023
         L     15,C00026
         BALR  14,15
         LR    0,2
         ST    0,P00023+0
         LA    1,P00023
         L     15,C00026
         BALR  14,15
         L     3,T00002+8
         LR    0,3
         ST    0,P00023+0
         LA    1,P00023
         L     15,C00026
         BALR  14,15
         L     14,C00018
         L     3,0(,14)
         L     2,T00002+4
         CR    3,2
         LA    5,1
         BC    4,L00027
         SR    5,5
L00027   DS    0H
         LCR   4,5
         XR    3,2
         NR    3,4
         XR    2,3
         LR    0,2
         ST    0,P00023+0
         LA    1,P00023
         L     15,C00026
         BALR  14,15
         L     15,C00028
         BALR  14,15
L00012   DS    0H
         B     L00013
L00009   DS    0H
         A     2,C00019
L00011   DS    0H
         BXH   3,6,L00009
         B     L00010
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
T00002   DS    XL24
P00023   DS    2F
C00018   DC    A(G00017)
C00019   DC    F'1'
C00021   DC    F'0'
C00024   DC    A(Q00001)
C00025   DC    V(F77WRBEG)
C00026   DC    V(F77WRI)
C00028   DC    V(F77WREND)
C00020   DC    H'-1'
Q00001   DC    C'(1X,''>INTRVAR'',4I5)'
G00017   CSECT
         DS    0D
         DC    X'0000001E'
         END
