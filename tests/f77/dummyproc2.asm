* main
F77MAIN  CSECT
         USING *,15
         B     L00005
         DC    AL1(7),CL7'F77MAIN'
L00005   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00006
L00007   DC    A(S00000)
L00006   L     15,L00007
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00002   DS    0H
         MVC   T00001(8),C00008
         LA    1,P00009
         L     15,C00010
         BALR  14,15
         LA    1,P00011
         L     15,C00012
         BALR  14,15
         STD   0,S00000+200
         LD    0,S00000+200
         STD   0,P00013+0
         LA    1,P00013
         L     15,C00014
         BALR  14,15
         L     15,C00015
         BALR  14,15
L00003   DS    0H
L00004   DS    0H
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
T00001   DS    XL20
         DS    XL4
         DS    1D
P00009   DC    F'6'
         DC    F'0'
P00011   DC    XL1'80',AL3(T00001)
         DS    F
P00013   DC    A(0)
         DC    A(0)
C00008   DC    X'4120000000000000'
C00010   DC    V(F77WRBEG)
C00012   DC    V(DF)
C00014   DC    V(F77WRD)
C00015   DC    V(F77WREND)
* S
S        CSECT
         USING *,15
         B     L00019
         DC    AL1(1),CL7'S'
L00019   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00020
L00021   DC    A(S00016)
L00020   L     15,L00021
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00016,13
         ST    1,S00016+72
L00017   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         LA    1,P00022
         L     15,C00023
         BALR  14,15
         LR    0,3
         ST    0,P00024+0
         OI    P00024+0,X'80'
         LA    1,P00024
         LR    15,4
         BALR  14,15
         STD   0,S00016+176
         LD    0,S00016+176
         STD   0,P00025+0
         LA    1,P00025
         L     15,C00026
         BALR  14,15
         L     15,C00027
         BALR  14,15
         LA    0,0
L00018   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00016   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
         DS    1D
P00022   DC    F'6'
         DC    F'0'
P00024   DC    XL1'80',AL3(0)
         DS    F
P00025   DC    A(0)
         DC    A(0)
C00023   DC    V(F77WRBEG)
C00026   DC    V(F77WRD)
C00027   DC    V(F77WREND)
* DF
DF       CSECT
         USING *,15
         B     L00031
         DC    AL1(2),CL7'DF'
L00031   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00032
L00033   DC    A(S00028)
L00032   L     15,L00033
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00028,13
         ST    1,S00028+72
L00029   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         LD    0,C00034
         MD    0,0(,2)
L00030   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00028   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00034   DC    X'4130000000000000'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
