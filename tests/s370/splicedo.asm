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
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         L     14,C00018
         L     3,0(,14)
         LR    0,3
         ST    0,P00028+0
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         L     15,C00030
         BALR  14,15
L00012   DS    0H
         LA    1,P00031
         L     15,C00032
         BALR  14,15
         B     L00014
L00010   DS    0H
         LA    1,P00033
         L     15,C00032
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
P00023   DC    A(T00002)
         DC    XL1'80',AL3(T00003)
P00026   DC    F'6'
         DC    A(Q00001)
P00028   DC    A(0)
P00031   DC    F'0'
P00033   DC    F'1'
         DS    XL4
C00022   DC    X'4E00000080000000'
C00018   DC    A(TOT)
C00020   DC    F'1'
C00021   DC    F'-2147483648'
C00024   DC    V(SHOWV)
C00025   DC    F'34'
C00027   DC    V(F77WRBEG)
C00029   DC    V(F77WRI)
C00030   DC    V(F77WREND)
C00032   DC    V(EXIT)
C00019   DC    H'-1'
Q00001   DC    C'(1X,''>SPLICEDO'',I5)'
* NEXTV
NEXTV    CSECT
         USING *,15
         B     L00038
         DC    AL1(5),CL7'NEXTV'
L00038   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00039
L00040   DC    A(S00034)
L00039   L     15,L00040
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00034,13
         ST    1,S00034+72
L00035   DS    0H
         L     4,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         LA    1,3
         M     0,0(,4)
         LR    2,1
         A     2,C00041
         LR    0,2
         X     0,C00042
         ST    0,S00034+84
         LD    2,S00034+80
         SD    2,C00043
         LER   2,2
         STE   2,S00034+88
         LD    0,S00034+88
         STD   0,0(,3)
         LA    0,0
         B     L00037
L00036   DS    0H
L00037   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00034   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00043   DC    X'4E00000080000000'
C00041   DC    F'1'
C00042   DC    F'-2147483648'
* SHOWV
SHOWV    CSECT
         USING *,15
         B     L00050
         DC    AL1(5),CL7'SHOWV'
L00050   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00051
L00052   DC    A(S00044)
L00051   L     15,L00052
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00044,13
         ST    1,S00044+72
L00045   DS    0H
         L     3,0(,1)
         L     2,4(,1)
         LA    2,0(,2)
         LD    0,0(,2)
         L     14,C00054
         STD   0,0(,14)
         L     2,0(,3)
         C     2,C00055
         BC    13,L00047
L00046   DS    0H
         L     14,C00054
         LD    0,0(,14)
         LDR   2,0
         LTDR  2,2
         LPDR  2,2
         AW    2,C00056
         STD   2,S00044+168
         L     2,S00044+172
         LTDR  0,0
         BC    10,L00057
         LCR   2,2
L00057   DS    0H
         L     15,C00058
         A     2,0(,15)
         L     14,C00058
         ST    2,0(,14)
L00047   DS    0H
         LA    0,0
         B     L00049
L00048   DS    0H
L00049   DS    0H
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
C00056   DC    X'4E00000000000000'
C00054   DC    A(G00053)
C00055   DC    F'0'
C00058   DC    A(TOT)
TOT      CSECT
         DS    0D
         DS    XL4
G00053   CSECT
         DS    0D
         DS    XL8
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
