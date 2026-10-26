* main
F77MAIN  CSECT
         USING *,15
         B     L00021
         DC    AL1(7),CL7'F77MAIN'
L00021   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00022
L00023   DC    A(S00000)
L00022   L     15,L00023
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00014   DS    0H
         MVC   T00006(4),C00024
         MVC   T00006+4(4),C00025
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         LE    0,T00006
         STE   0,S00000+400
         LE    0,T00006+4
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00028+0
         LE    0,S00000+408
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         LE    0,C00030
         AE    0,T00006
         STE   0,S00000+400
         LE    0,C00031
         AE    0,T00006+4
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00028+0
         LE    0,S00000+408
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         LE    2,T00006
         LE    0,T00006+4
         LER   4,2
         SE    4,C00030
         STE   4,S00000+400
         LER   2,0
         SE    2,C00031
         STE   2,S00000+408
         LE    0,S00000+400
         STE   0,P00028+0
         LE    0,S00000+408
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         LE    2,T00006
         LE    0,T00006+4
         LE    6,C00030
         MER   6,2
         LE    4,C00031
         MER   4,0
         STD   2,S00000+96
         LER   2,6
         SER   2,4
         STE   2,S00000+400
         LD    2,S00000+96
         ME    2,C00031
         ME    0,C00030
         LER   4,2
         AER   4,0
         STE   4,S00000+408
         LE    0,S00000+400
         STE   0,P00028+0
         LE    0,S00000+408
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         LE    0,T00006
         STE   0,S00000+400
         LE    0,T00006+4
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00032+4
         LE    0,S00000+408
         STE   0,P00032+8
         LE    0,C00030
         STE   0,P00032+12
         LE    0,C00031
         STE   0,P00032+16
         LA    1,P00032
         L     15,C00033
         BALR  14,15
         LE    0,T00011
         STE   0,S00000+400
         LE    0,T00011+4
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00028+0
         LE    0,S00000+408
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         LE    2,T00006
         LE    0,T00006+4
         LER   4,0
         LCER  4,4
         STE   4,S00000+400
         LER   0,2
         LCER  0,0
         STE   0,S00000+408
         LE    0,S00000+408
         STE   0,P00028+0
         LE    0,S00000+400
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         L     15,C00034
         BALR  14,15
L00015   DS    0H
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         LE    0,T00006
         STE   0,S00000+400
         LE    0,T00006+4
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00035+4
         LE    0,S00000+408
         STE   0,P00035+8
         LA    1,P00035
         L     15,C00036
         BALR  14,15
         LE    0,T00004
         STE   0,S00000+400
         LE    0,T00004+4
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00028+0
         LE    0,S00000+408
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         LE    0,T00006
         STE   0,S00000+400
         LE    0,T00006+4
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00037+4
         LE    0,S00000+408
         STE   0,P00037+8
         LE    0,C00025
         STE   0,P00037+12
         LE    0,C00038
         STE   0,P00037+16
         LA    1,P00037
         L     15,C00039
         BALR  14,15
         LE    0,T00005
         STE   0,S00000+400
         LE    0,T00005+4
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00028+0
         LE    0,S00000+408
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         LE    0,T00006
         STE   0,S00000+400
         LE    0,T00006+4
         LER   2,0
         LCER  2,2
         STE   2,S00000+408
         LE    0,S00000+400
         STE   0,P00028+0
         LE    0,S00000+408
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         LE    0,C00040
         STE   0,P00028+0
         LE    0,C00041
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         LA    0,2
         X     0,C00042
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00043
         LER   0,0
         STE   0,S00000+400
         LE    0,S00000+400
         STE   0,P00028+0
         LE    0,C00038
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         L     15,C00034
         BALR  14,15
         LA    1,P00044
         L     15,C00027
         BALR  14,15
         LE    0,T00006
         STE   0,S00000+400
         LE    0,S00000+400
         STE   0,P00045+0
         LA    1,P00045
         L     15,C00046
         BALR  14,15
         LE    0,T00006+4
         STE   0,S00000+400
         LE    0,S00000+400
         STE   0,P00045+0
         LA    1,P00045
         L     15,C00046
         BALR  14,15
         LE    0,C00040
         STE   0,P00028+0
         LE    0,C00041
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00047
         BALR  14,15
         STE   0,S00000+400
         LE    0,S00000+400
         STE   0,P00045+0
         LA    1,P00045
         L     15,C00046
         BALR  14,15
         LE    0,T00006
         STE   0,S00000+400
         LE    0,T00006+4
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00028+0
         LE    0,S00000+408
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00047
         BALR  14,15
         STE   0,S00000+416
         LE    0,S00000+416
         STE   0,P00045+0
         LA    1,P00045
         L     15,C00046
         BALR  14,15
         L     15,C00034
         BALR  14,15
L00016   DS    0H
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         LE    0,T00006
         STE   0,S00000+400
         LE    0,T00006+4
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00048+4
         LE    0,S00000+408
         STE   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         LE    0,T00012
         STE   0,S00000+400
         LE    0,T00012+4
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00028+0
         LE    0,S00000+408
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         LE    0,T00006
         STE   0,S00000+400
         LE    0,T00006+4
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00050+4
         LE    0,S00000+408
         STE   0,P00050+8
         LA    1,P00050
         L     15,C00051
         BALR  14,15
         LE    0,T00007
         STE   0,S00000+400
         LE    0,T00007+4
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00028+0
         LE    0,S00000+408
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         LE    0,T00006
         STE   0,S00000+400
         LE    0,T00006+4
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00052+4
         LE    0,S00000+408
         STE   0,P00052+8
         LA    1,P00052
         L     15,C00053
         BALR  14,15
         LE    0,T00008
         STE   0,S00000+400
         LE    0,T00008+4
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00028+0
         LE    0,S00000+408
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         LE    0,T00006
         STE   0,S00000+400
         LE    0,T00006+4
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00054+4
         LE    0,S00000+408
         STE   0,P00054+8
         LA    1,P00054
         L     15,C00055
         BALR  14,15
         LE    0,T00009
         STE   0,S00000+400
         LE    0,T00009+4
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00028+0
         LE    0,S00000+408
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         LE    0,T00006
         STE   0,S00000+400
         LE    0,T00006+4
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00056+4
         LE    0,S00000+408
         STE   0,P00056+8
         LA    1,P00056
         L     15,C00057
         BALR  14,15
         LE    0,T00010
         STE   0,S00000+400
         LE    0,T00010+4
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00028+0
         LE    0,S00000+408
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         L     15,C00034
         BALR  14,15
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         L     14,C00059
         LE    0,0(,14)
         STE   0,S00000+400
         L     14,C00060
         LE    0,0(,14)
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00028+0
         LE    0,S00000+408
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         L     14,C00061
         LE    0,0(,14)
         STE   0,S00000+400
         L     14,C00062
         LE    0,0(,14)
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00028+0
         LE    0,S00000+408
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         L     14,C00063
         LE    0,0(,14)
         STE   0,S00000+400
         L     14,C00064
         LE    0,0(,14)
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00028+0
         LE    0,S00000+408
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         LE    2,T00006
         LE    0,T00006+4
         LA    0,2
         X     0,C00042
         ST    0,S00000+84
         LD    4,S00000+80
         SD    4,C00043
         LER   4,4
         LER   6,2
         MER   6,4
         STE   6,S00000+400
         LE    6,C00038
         MER   6,0
         STD   4,S00000+96
         LE    4,S00000+400
         SER   4,6
         STE   4,S00000+408
         LD    4,S00000+96
         ME    2,C00038
         MER   0,4
         LER   4,2
         AER   4,0
         STE   4,S00000+400
L00017   DS    0H
         LE    0,S00000+408
         STE   0,P00028+0
         LE    0,S00000+400
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         L     15,C00034
         BALR  14,15
         LA    1,P00065
         L     15,C00027
         BALR  14,15
         LE    0,T00006
         STE   0,S00000+400
         LE    0,T00006+4
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00028+0
         LE    0,S00000+408
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         LE    0,C00024
         CE    0,T00006
         LA    2,1
         BC    8,L00066
         SR    2,2
L00066   DS    0H
         LE    0,C00025
         CE    0,T00006+4
         LA    3,1
         BC    8,L00067
         SR    3,3
L00067   DS    0H
         NR    2,3
         LR    0,2
         ST    0,P00068+0
         LA    1,P00068
         L     15,C00069
         BALR  14,15
         LE    0,C00030
         CE    0,T00006
         LA    2,1
         BC    8,L00070
         SR    2,2
L00070   DS    0H
         LE    0,C00031
         CE    0,T00006+4
         LA    3,1
         BC    8,L00071
         SR    3,3
L00071   DS    0H
         NR    2,3
         LTR   2,2
         LA    3,1
         BC    8,L00072
         SR    3,3
L00072   DS    0H
         LR    0,3
         ST    0,P00068+0
         LA    1,P00068
         L     15,C00069
         BALR  14,15
         L     15,C00034
         BALR  14,15
         LE    0,T00006
         STE   0,S00000+400
         LA    0,2
         X     0,C00042
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00043
         LER   0,0
         ME    0,S00000+400
         LE    2,C00038
         ME    2,T00006+4
         SER   0,2
         LDR   2,0
         STE   2,S00000+88
         LD    2,S00000+88
         LTDR  2,2
         LPDR  2,2
         AW    2,C00073
         STD   2,S00000+168
         L     3,S00000+172
         LTDR  0,0
         BC    10,L00074
         LCR   3,3
L00074   DS    0H
         LA    1,P00065
         L     15,C00027
         BALR  14,15
         LE    0,S00000+400
         STE   0,P00045+0
         LA    1,P00045
         L     15,C00046
         BALR  14,15
         LR    0,3
         ST    0,P00068+0
         LA    1,P00068
         L     15,C00075
         BALR  14,15
         LA    0,1
         X     0,C00042
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00043
         LER   0,0
         LE    2,T00006
         AER   2,0
         STE   2,S00000+400
         LE    0,C00038
         AE    0,T00006+4
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00028+0
         LE    0,S00000+408
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         LE    4,T00006
         LE    6,T00006+4
         LA    0,2
         X     0,C00042
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00043
         LER   0,0
         LER   2,0
         MER   2,4
         STE   2,S00000+400
         LE    2,C00038
         MER   2,6
         STD   6,S00000+96
         LE    6,S00000+400
         SER   6,2
         STE   6,S00000+408
         LD    6,S00000+96
         MER   0,6
         LE    2,C00038
         MER   2,4
         LER   4,0
         AER   4,2
         STE   4,S00000+400
         LE    0,S00000+408
         STE   0,P00028+0
         LE    0,S00000+400
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         LE    0,C00030
         AE    0,T00006
         STE   0,S00000+400
         LE    0,C00038
         AE    0,T00006+4
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00028+0
         LE    0,S00000+408
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         L     15,C00034
         BALR  14,15
         LA    1,P00076
         L     15,C00077
         BALR  14,15
         LA    1,P00078
         L     15,C00079
         BALR  14,15
         L     15,C00080
         BALR  14,15
L00018   DS    0H
         LA    1,P00081
         L     15,C00077
         BALR  14,15
         LA    1,P00082
         L     15,C00079
         BALR  14,15
         L     15,C00080
         BALR  14,15
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         LE    0,T00006
         STE   0,S00000+400
         LE    0,T00006+4
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00028+0
         LE    0,S00000+408
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         LE    0,T00013
         STE   0,S00000+400
         LE    0,T00013+4
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00028+0
         LE    0,S00000+408
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         L     15,C00034
         BALR  14,15
         LE    2,T00006
         LE    0,T00006+4
         AE    2,T00013
         AE    0,T00013+4
         STE   2,T00006
         STE   0,T00006+4
L00019   DS    0H
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         LE    0,T00006
         STE   0,S00000+400
         LE    0,T00006+4
         STE   0,S00000+408
         LE    0,S00000+400
         STE   0,P00028+0
         LE    0,S00000+408
         STE   0,P00028+4
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         L     15,C00034
         BALR  14,15
L00020   DS    0H
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
T00004   DS    XL8
T00005   DS    XL8
T00006   DS    XL12
         DS    XL4
T00007   DS    XL12
         DS    XL4
T00008   DS    XL12
         DS    XL4
T00009   DS    XL12
         DS    XL4
T00010   DS    XL12
         DS    XL4
T00011   DS    XL24
T00012   DS    XL36
         DS    XL4
T00013   DS    XL64
         DS    3D
P00026   DC    F'6'
         DC    A(Q00001)
P00028   DC    A(0)
         DC    A(0)
P00032   DC    A(T00011)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DS    F
P00035   DC    A(T00004)
         DC    A(0)
         DC    A(0)
         DC    F'3'
P00037   DC    A(T00005)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
P00044   DC    F'6'
         DC    A(Q00002)
         DS    F
P00045   DC    A(0)
         DS    F
P00048   DC    A(T00012)
         DC    A(0)
         DC    A(0)
         DS    F
P00050   DC    A(T00007)
         DC    A(0)
         DC    A(0)
         DS    F
P00052   DC    A(T00008)
         DC    A(0)
         DC    A(0)
         DS    F
P00054   DC    A(T00009)
         DC    A(0)
         DC    A(0)
         DS    F
P00056   DC    A(T00010)
         DC    A(0)
         DC    A(0)
P00065   DC    F'6'
         DC    F'0'
P00068   DC    A(0)
P00076   DC    F'5'
         DC    A(Q00003)
         DC    F'0'
P00078   DC    A(T00006)
P00081   DC    F'5'
         DC    F'0'
         DC    F'0'
P00082   DC    A(T00013)
C00043   DC    X'4E00000080000000'
C00073   DC    X'4E00000000000000'
C00024   DC    X'41100000'
C00025   DC    X'41200000'
C00027   DC    V(F77WRBEG)
C00029   DC    V(F77WRC)
C00030   DC    X'41180000'
C00031   DC    X'C1200000'
C00033   DC    V(F77CDIV)
C00034   DC    V(F77WREND)
C00036   DC    V(F77CPOWI)
C00038   DC    X'00000000'
C00039   DC    V(F77CPOWC)
C00040   DC    X'41300000'
C00041   DC    X'41400000'
C00042   DC    F'-2147483648'
C00046   DC    V(F77WRR)
C00047   DC    V(F77CABS)
C00049   DC    V(F77CSQRT)
C00051   DC    V(F77CEXP)
C00053   DC    V(F77CLOG)
C00055   DC    V(F77CSIN)
C00057   DC    V(F77CCOS)
C00059   DC    A(G00058)
C00060   DC    A(G00058+4)
C00061   DC    A(G00058+8)
C00062   DC    A(G00058+12)
C00063   DC    A(G00058+16)
C00064   DC    A(G00058+20)
C00069   DC    V(F77WRL)
C00075   DC    V(F77WRI)
C00077   DC    V(F77RDBEG)
C00079   DC    V(F77RDC)
C00080   DC    V(F77RDEND)
Q00001   DC    C'(1X,6(''('',F8.3,'','',F8.3,'') ''))'
Q00002   DC    C'(1X,4F10.4)'
Q00003   DC    C'(2F5.1)'
* CF
CF       CSECT
         USING *,15
         B     L00087
         DC    AL1(2),CL7'CF'
L00087   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00088
L00089   DC    A(S00083)
L00088   L     15,L00089
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00083,13
         ST    1,S00083+72
L00084   DS    0H
         L     2,0(,1)
         L     3,4(,1)
         LA    3,0(,3)
         LE    0,0(,2)
         LE    2,4(,2)
         L     2,0(,3)
         LR    0,2
         X     0,C00090
         ST    0,S00083+84
         LD    6,S00083+80
         SD    6,C00091
         LER   6,6
         LER   4,0
         MER   4,6
         STD   6,S00083+96
         LE    6,C00092
         MER   6,2
         STE   6,S00083+176
         LD    6,S00083+96
         SE    4,S00083+176
         ME    0,C00092
         MER   2,6
         AER   0,2
         LER   2,0
         LER   0,4
         B     L00086
L00085   DS    0H
L00086   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00083   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
         DS    1D
C00091   DC    X'4E00000080000000'
C00090   DC    F'-2147483648'
C00092   DC    X'00000000'
* CS
CS       CSECT
         USING *,15
         B     L00097
         DC    AL1(2),CL7'CS'
L00097   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00098
L00099   DC    A(S00093)
L00098   L     15,L00099
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00093,13
         ST    1,S00093+72
L00094   DS    0H
         L     3,0(,1)
         L     2,4(,1)
         LA    2,0(,2)
         LE    2,0(,3)
         LE    0,4(,3)
         AE    2,0(,2)
         AE    0,4(,2)
         STE   2,0(,3)
         STE   0,4(,3)
         LA    0,0
         B     L00096
L00095   DS    0H
L00096   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00093   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
G00058   CSECT
         DS    0D
         DC    X'411000004120000041300000414000004080000000000000'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
