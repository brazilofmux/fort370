* main
F77MAIN  CSECT
         USING *,15
         B     L00015
         DC    AL1(7),CL7'F77MAIN'
L00015   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00016
L00017   DC    A(S00000)
L00016   L     15,L00017
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00004   DS    0H
         LA    15,0
         L     14,C00018
         ST    15,0(,14)
         LA    15,1
         ST    15,T00002
L00005   DS    0H
         LH    4,C00019
         LA    5,0
         LA    2,4
L00006   DS    0H
         LA    1,3
         M     0,T00002
         LR    3,1
         A     3,C00020
         LR    0,3
         X     0,C00021
         ST    0,S00000+84
         LD    2,S00000+80
         SD    2,C00022
         LER   2,2
         STE   2,S00000+88
         LD    0,S00000+88
         STD   0,T00003
L00008   DS    0H
         LA    0,T00002
         ST    0,P00023+0
         LA    0,T00003
         ST    0,P00023+4
         OI    P00023+4,X'80'
         LA    1,P00023
         L     15,C00024
         BALR  14,15
L00009   DS    0H
         L     3,T00002
         A     3,C00020
         ST    3,T00002
         BXH   2,4,L00006
L00007   DS    0H
         L     14,C00018
         L     2,0(,14)
         C     2,C00025
         BC    7,L00010
L00011   DS    0H
         LA    0,6
         ST    0,P00023+0
         L     0,C00026
         ST    0,P00023+4
         LA    1,P00023
         L     15,C00027
         BALR  14,15
         L     14,C00018
         L     3,0(,14)
         LR    0,3
         ST    0,P00023+0
         LA    1,P00023
         L     15,C00028
         BALR  14,15
         L     15,C00029
         BALR  14,15
L00012   DS    0H
         LA    0,0
         ST    0,P00023+0
         LA    1,P00023
         L     15,C00030
         BALR  14,15
         B     L00014
L00010   DS    0H
         LA    0,1
         ST    0,P00023+0
         LA    1,P00023
         L     15,C00030
         BALR  14,15
         B     L00014
L00013   DS    0H
L00014   DS    0H
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
T00002   DS    XL8
T00003   DS    XL20
         DS    XL4
P00023   DS    2F
C00022   DC    X'4E00000080000000'
C00018   DC    A(TOT)
C00020   DC    F'1'
C00021   DC    F'-2147483648'
C00024   DC    V(SHOWV)
C00025   DC    F'34'
C00026   DC    A(Q00001)
C00027   DC    V(F77WRBEG)
C00028   DC    V(F77WRI)
C00029   DC    V(F77WREND)
C00030   DC    V(EXIT)
C00019   DC    H'-1'
Q00001   DC    C'(1X,''>SPLICEDO'',I5)'
* NEXTV
NEXTV    CSECT
         USING *,15
         B     L00035
         DC    AL1(5),CL7'NEXTV'
L00035   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00036
L00037   DC    A(S00031)
L00036   L     15,L00037
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00031,13
         ST    1,S00031+72
L00032   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         LA    1,3
         M     0,0(,4)
         LR    2,1
         A     2,C00038
         LR    0,2
         X     0,C00039
         ST    0,S00031+84
         LD    2,S00031+80
         SD    2,C00040
         LER   2,2
         STE   2,S00031+88
         LD    0,S00031+88
         STD   0,0(,3)
         LA    0,0
         B     L00034
L00033   DS    0H
L00034   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00031   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00040   DC    X'4E00000080000000'
C00038   DC    F'1'
C00039   DC    F'-2147483648'
* SHOWV
SHOWV    CSECT
         USING *,15
         B     L00047
         DC    AL1(5),CL7'SHOWV'
L00047   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00048
L00049   DC    A(S00041)
L00048   L     15,L00049
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00041,13
         ST    1,S00041+72
L00042   DS    0H
         L     3,0(,1)
         L     2,4(,1)
         LA    2,0(,2)
         LD    0,0(,2)
         L     14,C00051
         STD   0,0(,14)
         L     2,0(,3)
         C     2,C00052
         BC    13,L00044
L00043   DS    0H
         L     14,C00051
         LD    0,0(,14)
         LDR   2,0
         LTDR  2,2
         LPDR  2,2
         AW    2,C00053
         STD   2,S00041+168
         L     2,S00041+172
         LTDR  0,0
         BC    10,L00054
         LCR   2,2
L00054   DS    0H
         L     15,C00055
         A     2,0(,15)
         L     14,C00055
         ST    2,0(,14)
L00044   DS    0H
         LA    0,0
         B     L00046
L00045   DS    0H
L00046   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00041   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00053   DC    X'4E00000000000000'
C00051   DC    A(G00050)
C00052   DC    F'0'
C00055   DC    A(TOT)
TOT      CSECT
         DS    0D
         DS    XL4
G00050   CSECT
         DS    0D
         DS    XL8
         END
