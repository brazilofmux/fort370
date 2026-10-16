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
L00004   DS    0H
         LA    15,1
         ST    15,T00002
L00005   DS    0H
         LH    4,C00017
         LA    5,0
         LA    2,3
L00006   DS    0H
         LA    0,T00002
         ST    0,P00018+0
         LA    0,T00003
         ST    0,P00018+4
         OI    P00018+4,X'80'
         LA    1,P00018
         L     15,C00019
         BALR  14,15
L00008   DS    0H
         L     3,T00002
         A     3,C00020
         ST    3,T00002
         BXH   2,4,L00006
L00007   DS    0H
         LA    0,6
         ST    0,P00018+0
         L     0,C00021
         ST    0,P00018+4
         LA    1,P00018
         L     15,C00022
         BALR  14,15
         L     3,T00003
         LR    0,3
         ST    0,P00018+0
         LA    1,P00018
         L     15,C00023
         BALR  14,15
         L     15,C00024
         BALR  14,15
L00009   DS    0H
         L     2,T00003
         C     2,C00025
         BC    7,L00010
L00011   DS    0H
         LA    0,0
         ST    0,P00018+0
         LA    1,P00018
         L     15,C00026
         BALR  14,15
         B     L00013
L00010   DS    0H
         LA    0,1
         ST    0,P00018+0
         LA    1,P00018
         L     15,C00026
         BALR  14,15
         B     L00013
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
T00002   DS    XL4
         DS    XL4
T00003   DS    XL8
P00018   DS    2F
C00019   DC    V(KEEP)
C00020   DC    F'1'
C00021   DC    A(Q00001)
C00022   DC    V(F77WRBEG)
C00023   DC    V(F77WRI)
C00024   DC    V(F77WREND)
C00025   DC    F'3'
C00026   DC    V(EXIT)
C00017   DC    H'-1'
Q00001   DC    C'(1X,''>KEEPVAR'',I6)'
* KEEP
KEEP     CSECT
         USING *,15
         B     L00037
         DC    AL1(4),CL7'KEEP'
L00037   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00038
L00039   DC    A(S00027)
L00038   L     15,L00039
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00027,13
         ST    1,S00027+72
L00030   DS    0H
         L     5,0(,1)
         L     4,4(,1)
         LA    4,0(,4)
         L     14,C00041
         L     3,0(,14)
         LTR   3,3
         LA    2,1
         BC    8,L00042
         SR    2,2
L00042   DS    0H
         LTR   2,2
         BC    7,L00031
L00032   DS    0H
         LA    15,0
         L     14,C00041
         ST    15,0(,14)
         LA    15,0
         ST    15,T00028
L00033   DS    0H
         L     3,T00028
         A     3,C00043
         ST    3,T00028
         SLL   3,2
         L     2,0(,5)
         LR    1,2
         M     0,C00044
         LR    2,1
         ST    2,T00029-4(3)
         L     2,T00028
         ST    2,0(,4)
         L     2,T00028
         LR    3,2
         SLL   3,2
         LR    1,2
         M     0,C00044
         LR    2,1
         C     2,T00029-4(3)
         BC    7,L00034
L00035   DS    0H
         LA    0,0
         B     L00036
L00031   DS    0H
         B     L00033
L00034   DS    0H
         LA    0,2
         ST    0,P00045+0
         LA    1,P00045
         L     15,C00046
         BALR  14,15
         LA    0,2
L00036   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00027   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00028   DS    XL8
T00029   DS    XL16
P00045   DS    1F
         DS    XL4
C00041   DC    A(G00040)
C00043   DC    F'1'
C00044   DC    F'10'
C00046   DC    V(EXIT)
G00040   CSECT
         DS    0D
         DC    X'00000001'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
