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
         LA    0,6
         ST    0,P00014+0
         L     0,C00015
         ST    0,P00014+4
         LA    1,P00014
         L     15,C00016
         BALR  14,15
         L     14,C00012
         L     3,0(,14)
         LR    0,3
         ST    0,P00014+0
         LA    1,P00014
         L     15,C00017
         BALR  14,15
         L     14,C00013
         L     3,0(,14)
         LR    0,3
         ST    0,P00014+0
         LA    1,P00014
         L     15,C00017
         BALR  14,15
         L     15,C00018
         BALR  14,15
L00005   DS    0H
         L     15,C00019
         BALR  14,15
         LA    0,6
         ST    0,P00014+0
         L     0,C00020
         ST    0,P00014+4
         LA    1,P00014
         L     15,C00016
         BALR  14,15
         LA    15,1
         ST    15,T00003
         LA    0,T00003
         ST    0,P00014+0
         OI    P00014+0,X'80'
         LA    1,P00014
         L     15,C00021
         BALR  14,15
         LR    3,0
         LR    0,3
         ST    0,P00014+0
         LA    1,P00014
         L     15,C00017
         BALR  14,15
         L     15,C00018
         BALR  14,15
L00006   DS    0H
         LA    0,0
         ST    0,P00014+0
         LA    1,P00014
         L     15,C00022
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
P00014   DS    2F
C00012   DC    A(INCB)
C00013   DC    A(INCB+4)
C00015   DC    A(Q00001)
C00016   DC    V(F77WRBEG)
C00017   DC    V(F77WRI)
C00018   DC    V(F77WREND)
C00019   DC    V(SUB)
C00020   DC    A(Q00002)
C00021   DC    V(NF)
C00022   DC    V(EXIT)
Q00001   DC    C'('' >N '',2I5)'
Q00002   DC    C'('' >F '',I5)'
* SUB
SUB      CSECT
         USING *,15
         B     L00029
         DC    AL1(3),CL7'SUB'
L00029   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00030
L00031   DC    A(S00023)
L00030   L     15,L00031
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00023,13
         ST    1,S00023+72
L00025   DS    0H
         LA    0,6
         ST    0,P00032+0
         L     0,C00033
         ST    0,P00032+4
         LA    1,P00032
         L     15,C00034
         BALR  14,15
         L     14,C00035
         L     3,0(,14)
         LR    0,3
         ST    0,P00032+0
         LA    1,P00032
         L     15,C00036
         BALR  14,15
         L     14,C00037
         L     3,0(,14)
         LR    0,3
         ST    0,P00032+0
         LA    1,P00032
         L     15,C00036
         BALR  14,15
         LA    0,40
         ST    0,P00032+0
         LA    1,P00032
         L     15,C00036
         BALR  14,15
         L     15,C00038
         BALR  14,15
L00026   DS    0H
         LA    0,0
         B     L00028
L00027   DS    0H
L00028   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00023   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00032   DS    2F
C00033   DC    A(Q00024)
C00034   DC    V(F77WRBEG)
C00035   DC    A(INCB)
C00036   DC    V(F77WRI)
C00037   DC    A(INCB+4)
C00038   DC    V(F77WREND)
Q00024   DC    C'('' >S '',3I5)'
* NF
NF       CSECT
         USING *,15
         B     L00043
         DC    AL1(2),CL7'NF'
L00043   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00044
L00045   DC    A(S00039)
L00044   L     15,L00045
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00039,13
         ST    1,S00039+72
L00040   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     14,C00046
         L     2,0(,14)
         L     15,C00046
         A     2,4(,15)
         A     2,0(,3)
         S     2,C00047
         LR    0,2
         B     L00042
L00041   DS    0H
L00042   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00039   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00046   DC    A(INCB)
C00047   DC    F'1'
INCB     CSECT
         DS    0D
         DS    XL8
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
