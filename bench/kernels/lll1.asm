* main
F77MAIN  CSECT
         USING *,15
         B     L00029
         DC    AL1(7),CL7'F77MAIN'
L00029   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00030
L00031   DC    A(S00000)
L00030   L     15,L00031
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00005   DS    0H
         L     4,C00032
         L     3,C00033
         L     2,C00034
         LD    4,C00035
L00006   DS    0H
         LR    7,2
         AH    7,C00036
         LD    2,C00037
         LA    8,8
         LH    9,C00038
         LA    5,8
         LA    6,1
L00007   DS    0H
L00009   DS    0H
         LR    0,6
         X     0,C00039
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00040
         MDR   0,2
         STD   0,0(5,7)
         A     6,C00041
         BXLE  5,8,L00007
L00008   DS    0H
L00010   DS    0H
         LR    7,3
         AH    7,C00036
         LD    2,C00042
         LA    8,8
         LH    9,C00043
         LA    5,8
         LA    6,1
L00011   DS    0H
L00013   DS    0H
         LR    0,6
         X     0,C00039
         ST    0,S00000+84
         LD    6,S00000+80
         SD    6,C00040
         LDR   0,2
         DDR   0,6
         STD   0,0(5,7)
         A     6,C00041
         BXLE  5,8,L00011
L00012   DS    0H
         L     14,C00045
         L     5,0(,14)
         S     5,C00041
         A     5,C00041
L00014   DS    0H
         LH    10,C00046
         LA    11,0
         LR    7,4
         AH    7,C00036
         AH    3,C00036
         AH    2,C00036
         C     5,C00047
         BC    2,L00015
L00016   DS    0H
L00022   DS    0H
         AH    4,C00036
         LA    6,8
         LH    7,C00043
         LA    2,8
         LD    0,C00048
L00023   DS    0H
L00025   DS    0H
         AD    0,0(2,4)
         BXLE  2,6,L00023
         STD   0,S00000+176
L00024   DS    0H
         LA    1,P00049
         L     15,C00050
         BALR  14,15
         LD    0,S00000+176
         STD   0,P00051+0
         LA    1,P00051
         L     15,C00052
         BALR  14,15
         L     15,C00053
         BALR  14,15
L00026   DS    0H
         LA    1,P00054
         L     15,C00055
         BALR  14,15
         B     L00028
L00015   DS    0H
L00017   DS    0H
         LA    8,8
         LH    9,C00043
         LA    6,8
L00018   DS    0H
L00020   DS    0H
         LD    0,C00056
         MD    0,80(6,2)
         LD    2,88(6,2)
         MDR   2,4
         ADR   0,2
         MD    0,0(6,3)
         AD    0,C00057
         STD   0,0(6,7)
         BXLE  6,8,L00018
L00019   DS    0H
L00021   DS    0H
         BXH   5,10,L00015
         B     L00016
L00027   DS    0H
L00028   DS    0H
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
         DS    1D
P00049   DC    F'6'
         DC    A(Q00001)
P00051   DC    A(0)
         DC    A(0)
P00054   DC    F'0'
         DS    XL4
C00035   DC    X'4020000000000000'
C00037   DC    X'3E4189374BC6A7F0'
C00040   DC    X'4E00000080000000'
C00042   DC    X'4110000000000000'
C00048   DC    X'0000000000000000'
C00056   DC    X'4040000000000000'
C00057   DC    X'4080000000000000'
C00032   DC    A(T00002)
C00033   DC    A(T00003)
C00034   DC    A(T00004)
C00039   DC    F'-2147483648'
C00041   DC    F'1'
C00045   DC    A(G00044)
C00047   DC    F'0'
C00050   DC    V(F77WRBEG)
C00052   DC    V(F77WRD)
C00053   DC    V(F77WREND)
C00055   DC    V(EXIT)
C00036   DC    H'-8'
C00038   DC    H'8096'
C00043   DC    H'8000'
C00046   DC    H'-1'
Q00001   DC    C'('' LLL1 CHECKSUM '',D22.15)'
         DS    0D
T00002   DS    1002D
         DS    0D
T00003   DS    1002D
         DS    0D
T00004   DS    1013D
G00044   CSECT
         DS    0D
         DC    X'00030D40'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
