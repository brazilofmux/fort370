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
         LA    1,P00021
         L     15,C00022
         BALR  14,15
         L     2,T00002
         C     2,C00023
         BC    7,L00007
L00008   DS    0H
         LA    1,P00024
         L     15,C00025
         BALR  14,15
         LR    0,3
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         L     3,T00002
         LR    0,3
         ST    0,P00026+0
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         L     15,C00028
         BALR  14,15
L00009   DS    0H
         LA    1,P00029
         L     15,C00030
         BALR  14,15
         B     L00011
L00005   DS    0H
         LA    1,P00031
         L     15,C00030
         BALR  14,15
         B     L00011
L00007   DS    0H
         LA    1,P00032
         L     15,C00030
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
P00021   DC    XL1'80',AL3(T00002)
P00024   DC    F'6'
         DC    A(Q00001)
P00026   DC    A(0)
P00029   DC    F'0'
P00031   DC    F'1'
P00032   DC    F'2'
         DS    XL4
C00016   DC    X'4E00000080000000'
C00018   DC    X'4E00000000000000'
C00015   DC    F'-2147483648'
C00017   DC    X'41280000'
C00020   DC    F'12'
C00022   DC    V(INONE)
C00023   DC    F'2'
C00025   DC    V(F77WRBEG)
C00027   DC    V(F77WRI)
C00028   DC    V(F77WREND)
C00030   DC    V(EXIT)
Q00001   DC    C'(1X,''>IMPINL'',2I5)'
* ISTEP
ISTEP    CSECT
         USING *,15
         B     L00036
         DC    AL1(5),CL7'ISTEP'
L00036   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00037
L00038   DC    A(S00033)
L00037   L     15,L00038
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00033,13
         ST    1,S00033+72
L00034   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         LA    0,2
         X     0,C00039
         ST    0,S00033+84
         LD    2,S00033+80
         SD    2,C00040
         LER   2,2
         ME    2,C00041
         LR    0,2
         X     0,C00039
         ST    0,S00033+84
         LD    0,S00033+80
         SD    0,C00040
         LER   0,0
         AER   0,2
         LDR   2,0
         STE   2,S00033+88
         LD    2,S00033+88
         LTDR  2,2
         LPDR  2,2
         AW    2,C00042
         STD   2,S00033+168
         L     2,S00033+172
         LTDR  0,0
         BC    10,L00043
         LCR   2,2
L00043   DS    0H
         ST    2,0(,3)
         LA    0,0
L00035   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00033   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00040   DC    X'4E00000080000000'
C00042   DC    X'4E00000000000000'
C00039   DC    F'-2147483648'
C00041   DC    X'41280000'
* INONE
INONE    CSECT
         USING *,15
         B     L00048
         DC    AL1(5),CL7'INONE'
L00048   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00049
L00050   DC    A(S00044)
L00049   L     15,L00050
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00044,13
         ST    1,S00044+72
L00045   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
L00046   DS    0H
         LA    15,2
         ST    15,0(,2)
         LA    0,0
L00047   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00044   DS    0D
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
         B     L00055
         DC    AL1(5),CL7'JNEXT'
L00055   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00056
L00057   DC    A(S00051)
L00056   L     15,L00057
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00051,13
         ST    1,S00051+72
L00052   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         A     2,C00058
         LR    0,2
         B     L00054
L00053   DS    0H
L00054   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00051   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00058   DC    F'1'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
