* main
F77MAIN  CSECT
         USING *,15
         B     L00012
         DC    AL1(7),CL7'F77MAIN'
L00012   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00013
L00014   DC    A(S00000)
L00013   L     15,L00014
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00003   DS    0H
         LA    0,2
         X     0,C00015
         ST    0,S00000+84
         LD    2,S00000+80
         SD    2,C00016
         LER   2,2
         ME    2,C00017
         LA    0,7
         X     0,C00015
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00016
         LER   0,0
         AER   0,2
         LDR   2,0
         STE   2,S00000+88
         LD    2,S00000+88
         LTDR  2,2
         LPDR  2,2
         AW    2,C00018
         STD   2,S00000+168
         L     3,S00000+172
         LTDR  0,0
         BC    10,L00019
         LCR   3,3
L00019   DS    0H
L00004   DS    0H
         C     3,C00020
         BC    7,L00005
L00006   DS    0H
         LA    0,T00002
         ST    0,P00021+0
         OI    P00021+0,X'80'
         LA    1,P00021
         L     15,C00022
         BALR  14,15
         L     2,T00002
         C     2,C00023
         BC    7,L00007
L00008   DS    0H
         LA    0,6
         ST    0,P00021+0
         L     0,C00024
         ST    0,P00021+4
         LA    1,P00021
         L     15,C00025
         BALR  14,15
         LR    0,3
         ST    0,P00021+0
         LA    1,P00021
         L     15,C00026
         BALR  14,15
         L     3,T00002
         LR    0,3
         ST    0,P00021+0
         LA    1,P00021
         L     15,C00026
         BALR  14,15
         L     15,C00027
         BALR  14,15
L00009   DS    0H
         LA    0,0
         ST    0,P00021+0
         LA    1,P00021
         L     15,C00028
         BALR  14,15
         B     L00011
L00005   DS    0H
         LA    0,1
         ST    0,P00021+0
         LA    1,P00021
         L     15,C00028
         BALR  14,15
         B     L00011
L00007   DS    0H
         LA    0,2
         ST    0,P00021+0
         LA    1,P00021
         L     15,C00028
         BALR  14,15
         B     L00011
L00010   DS    0H
L00011   DS    0H
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
T00002   DS    XL12
         DS    XL4
P00021   DS    2F
C00016   DC    X'4E00000080000000'
C00018   DC    X'4E00000000000000'
C00015   DC    F'-2147483648'
C00017   DC    X'41280000'
C00020   DC    F'12'
C00022   DC    V(INONE)
C00023   DC    F'2'
C00024   DC    A(Q00001)
C00025   DC    V(F77WRBEG)
C00026   DC    V(F77WRI)
C00027   DC    V(F77WREND)
C00028   DC    V(EXIT)
Q00001   DC    C'(1X,''>IMPINL'',2I5)'
* ISTEP
ISTEP    CSECT
         USING *,15
         B     L00032
         DC    AL1(5),CL7'ISTEP'
L00032   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00033
L00034   DC    A(S00029)
L00033   L     15,L00034
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00029,13
         ST    1,S00029+72
L00030   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         LA    0,2
         X     0,C00035
         ST    0,S00029+84
         LD    2,S00029+80
         SD    2,C00036
         LER   2,2
         ME    2,C00037
         LR    0,2
         X     0,C00035
         ST    0,S00029+84
         LD    0,S00029+80
         SD    0,C00036
         LER   0,0
         AER   0,2
         LDR   2,0
         STE   2,S00029+88
         LD    2,S00029+88
         LTDR  2,2
         LPDR  2,2
         AW    2,C00038
         STD   2,S00029+168
         L     2,S00029+172
         LTDR  0,0
         BC    10,L00039
         LCR   2,2
L00039   DS    0H
         ST    2,0(,3)
         LA    0,0
L00031   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00029   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00036   DC    X'4E00000080000000'
C00038   DC    X'4E00000000000000'
C00035   DC    F'-2147483648'
C00037   DC    X'41280000'
* INONE
INONE    CSECT
         USING *,15
         B     L00044
         DC    AL1(5),CL7'INONE'
L00044   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00045
L00046   DC    A(S00040)
L00045   L     15,L00046
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00040,13
         ST    1,S00040+72
L00041   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
L00042   DS    0H
         LA    15,2
         ST    15,0(,2)
         LA    0,0
L00043   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00040   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
* JNEXT
JNEXT    CSECT
         USING *,15
         B     L00051
         DC    AL1(5),CL7'JNEXT'
L00051   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00052
L00053   DC    A(S00047)
L00052   L     15,L00053
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00047,13
         ST    1,S00047+72
L00048   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         A     2,C00054
         LR    0,2
         B     L00050
L00049   DS    0H
L00050   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00047   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00054   DC    F'1'
         END
