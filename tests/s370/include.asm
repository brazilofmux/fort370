* main
F77MAIN  CSECT
         USING *,15
         B     L00009
         DC    AL1(7),CL7'F77MAIN'
L00009   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00010
L00011   DC    A(S00000)
L00010   L     15,L00011
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00004   DS    0H
         LA    15,41
         L     14,C00012
         ST    15,0(,14)
         LA    15,42
         L     14,C00013
         ST    15,0(,14)
         LA    1,P00014
         L     15,C00015
         BALR  14,15
         L     14,C00012
         L     3,0(,14)
         LR    0,3
         ST    0,P00016+0
         LA    1,P00016
         L     15,C00017
         BALR  14,15
         L     14,C00013
         L     3,0(,14)
         LR    0,3
         ST    0,P00016+0
         LA    1,P00016
         L     15,C00017
         BALR  14,15
         L     15,C00018
         BALR  14,15
L00005   DS    0H
         L     15,C00019
         BALR  14,15
         LA    1,P00020
         L     15,C00015
         BALR  14,15
         LA    15,1
         ST    15,T00003
         LA    1,P00021
         L     15,C00022
         BALR  14,15
         LR    3,0
         LR    0,3
         ST    0,P00016+0
         LA    1,P00016
         L     15,C00017
         BALR  14,15
         L     15,C00018
         BALR  14,15
L00006   DS    0H
         LA    1,P00023
         L     15,C00024
         BALR  14,15
         B     L00008
L00007   DS    0H
L00008   DS    0H
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
T00003   DS    XL32
P00014   DC    F'6'
         DC    A(Q00001)
P00016   DC    A(0)
P00020   DC    F'6'
         DC    A(Q00002)
P00021   DC    XL1'80',AL3(T00003)
P00023   DC    F'0'
         DS    XL4
C00012   DC    A(INCB)
C00013   DC    A(INCB+4)
C00015   DC    V(F77WRBEG)
C00017   DC    V(F77WRI)
C00018   DC    V(F77WREND)
C00019   DC    V(SUB)
C00022   DC    V(NF)
C00024   DC    V(EXIT)
Q00001   DC    C'('' >N '',2I5)'
Q00002   DC    C'('' >F '',I5)'
* SUB
SUB      CSECT
         USING *,15
         B     L00031
         DC    AL1(3),CL7'SUB'
L00031   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00032
L00033   DC    A(S00025)
L00032   L     15,L00033
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00025,13
         ST    1,S00025+72
L00027   DS    0H
         LA    1,P00034
         L     15,C00035
         BALR  14,15
         L     14,C00036
         L     3,0(,14)
         LR    0,3
         ST    0,P00037+0
         LA    1,P00037
         L     15,C00038
         BALR  14,15
         L     14,C00039
         L     3,0(,14)
         LR    0,3
         ST    0,P00037+0
         LA    1,P00037
         L     15,C00038
         BALR  14,15
         LA    1,P00040
         L     15,C00038
         BALR  14,15
         L     15,C00041
         BALR  14,15
L00028   DS    0H
         LA    0,0
         B     L00030
L00029   DS    0H
L00030   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00025   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00034   DC    F'6'
         DC    A(Q00026)
P00037   DC    A(0)
P00040   DC    F'40'
C00035   DC    V(F77WRBEG)
C00036   DC    A(INCB)
C00038   DC    V(F77WRI)
C00039   DC    A(INCB+4)
C00041   DC    V(F77WREND)
Q00026   DC    C'('' >S '',3I5)'
* NF
NF       CSECT
         USING *,15
         B     L00046
         DC    AL1(2),CL7'NF'
L00046   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00047
L00048   DC    A(S00042)
L00047   L     15,L00048
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00042,13
         ST    1,S00042+72
L00043   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     14,C00049
         L     2,0(,14)
         L     15,C00049
         A     2,4(,15)
         A     2,0(,3)
         S     2,C00050
         LR    0,2
         B     L00045
L00044   DS    0H
L00045   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00042   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00049   DC    A(INCB)
C00050   DC    F'1'
INCB     CSECT
         DS    0D
         DS    XL8
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
