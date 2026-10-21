* main
F77MAIN  CSECT
         USING *,15
         B     L00024
         DC    AL1(7),CL7'F77MAIN'
L00024   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00025
L00026   DC    A(S00000)
L00025   L     15,L00026
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00006   DS    0H
         LA    10,1
         L     14,C00028
         L     2,0(,14)
         SR    2,10
         LR    14,2
         AR    14,10
         ST    14,S00000+328
L00007   DS    0H
         L     15,C00028
         L     14,0(,15)
         ST    14,S00000+336
         L     14,S00000+328
         SLL   14,0
         ST    14,S00000+344
         LA    14,0
         A     14,S00000+344
         ST    14,S00000+352
         L     14,S00000+328
         C     14,C00029
         BC    2,L00030
         LA    14,0
         ST    14,S00000+384
         LA    14,0
         ST    14,S00000+368
         LA    5,0
         LA    4,0
         LA    3,0
         B     L00009
L00030   DS    0H
         LA    14,0
         ST    14,S00000+376
         LA    14,0
         ST    14,S00000+360
         LA    14,0
         ST    14,S00000+344
         LA    4,0
         LA    3,0
         LR    7,10
         B     L00008
L00009   DS    0H
         LA    15,1
         L     14,C00032
         ST    15,0(,14)
L00015   DS    0H
         LH    8,C00033
         LA    9,0
         LA    6,3
         LA    2,0
L00016   DS    0H
L00018   DS    0H
         LH    10,C00033
         LA    11,0
         LA    7,2
L00019   DS    0H
         L     15,C00032
         A     2,0(,15)
L00021   DS    0H
         BXH   7,10,L00019
L00020   DS    0H
         L     14,C00032
         L     7,0(,14)
         A     7,C00034
         L     14,C00032
         ST    7,0(,14)
         BXH   6,8,L00016
L00017   DS    0H
         LA    0,6
         ST    0,P00035+0
         L     0,C00036
         ST    0,P00035+4
         LA    1,P00035
         L     15,C00037
         BALR  14,15
         LR    0,3
         ST    0,P00035+0
         LA    1,P00035
         L     15,C00038
         BALR  14,15
         LR    0,4
         ST    0,P00035+0
         LA    1,P00035
         L     15,C00038
         BALR  14,15
         LR    0,5
         ST    0,P00035+0
         LA    1,P00035
         L     15,C00038
         BALR  14,15
         L     0,S00000+368
         ST    0,P00035+0
         LA    1,P00035
         L     15,C00038
         BALR  14,15
         L     0,S00000+384
         ST    0,P00035+0
         LA    1,P00035
         L     15,C00038
         BALR  14,15
         LR    0,2
         ST    0,P00035+0
         LA    1,P00035
         L     15,C00038
         BALR  14,15
         L     15,C00039
         BALR  14,15
L00022   DS    0H
         B     L00023
L00008   DS    0H
         A     3,S00000+336
         L     14,C00041
         L     2,0(,14)
         AR    4,2
         LR    14,2
         A     14,C00034
         ST    14,S00000+328
         L     15,S00000+328
         L     14,C00041
         ST    15,0(,14)
L00010   DS    0H
         L     5,S00000+344
         L     15,C00043
         A     5,0(,15)
         L     15,C00043
         L     14,0(,15)
         ST    14,S00000+328
         L     14,S00000+328
         A     14,C00044
         ST    14,S00000+392
         L     15,S00000+392
         L     14,C00043
         ST    15,0(,14)
         L     9,S00000+360
         L     15,C00046
         A     9,0(,15)
         LA    0,4
         ST    0,P00035+0
         LA    1,P00035
         L     15,C00047
         BALR  14,15
         LA    0,T00005
         ST    0,P00035+0
         LA    0,2
         ST    0,P00035+4
         LA    0,1
         ST    0,P00035+8
         L     0,C00048
         ST    0,P00035+12
         LA    1,P00035
         L     15,C00049
         BALR  14,15
         LR    14,7
         A     14,C00050
         ST    14,S00000+328
         L     0,S00000+328
         ST    0,P00035+0
         LA    1,P00035
         L     15,C00038
         BALR  14,15
         L     15,C00039
         BALR  14,15
         LA    0,4
         ST    0,P00035+0
         LA    1,P00035
         L     15,C00047
         BALR  14,15
         LA    0,T00005
         ST    0,P00035+0
         LA    0,2
         ST    0,P00035+4
         LA    0,1
         ST    0,P00035+8
         L     0,C00051
         ST    0,P00035+12
         LA    0,0
         ST    0,P00035+16
         LA    1,P00035
         L     15,C00052
         BALR  14,15
         L     0,C00046
         ST    0,P00035+0
         LA    1,P00035
         L     15,C00053
         BALR  14,15
         L     15,C00054
         BALR  14,15
         L     8,S00000+376
         L     15,C00056
         A     8,0(,15)
         LA    0,5
         ST    0,P00035+0
         LA    1,P00035
         L     15,C00047
         BALR  14,15
         LA    0,T00005
         ST    0,P00035+0
         LA    0,2
         ST    0,P00035+4
         LA    0,1
         ST    0,P00035+8
         L     0,C00057
         ST    0,P00035+12
         LA    1,P00035
         L     15,C00049
         BALR  14,15
         LA    15,1
         L     14,C00056
         ST    15,0(,14)
         LA    2,2
L00011   DS    0H
         C     2,C00029
         BC    2,L00012
L00013   DS    0H
         L     15,C00039
         BALR  14,15
L00014   DS    0H
         AR    7,10
         C     7,S00000+352
         BC    12,L00058
         LR    14,8
         ST    14,S00000+384
         LR    14,9
         ST    14,S00000+368
         B     L00009
L00058   DS    0H
         LR    14,8
         ST    14,S00000+376
         LR    14,9
         ST    14,S00000+360
         LR    14,5
         ST    14,S00000+344
         B     L00008
L00012   DS    0H
         L     14,C00056
         L     11,0(,14)
         LR    0,11
         ST    0,P00035+0
         LA    1,P00035
         L     15,C00038
         BALR  14,15
         L     14,C00056
         L     6,0(,14)
         A     6,C00034
         L     14,C00056
         ST    6,0(,14)
         AH    2,C00033
         B     L00011
L00023   DS    0H
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
T00005   DS    XL148
         DS    XL4
         DS    9D
P00035   DS    5F
         DS    XL4
C00028   DC    A(G00027)
C00029   DC    F'0'
C00032   DC    A(G00031)
C00034   DC    F'1'
C00036   DC    A(Q00004)
C00037   DC    V(F77WRBEG)
C00038   DC    V(F77WRI)
C00039   DC    V(F77WREND)
C00041   DC    A(G00040)
C00043   DC    A(G00042)
C00044   DC    F'2'
C00046   DC    A(G00045)
C00047   DC    V(F77FMTLM)
C00048   DC    A(Q00001)
C00049   DC    V(F77WRBI)
C00050   DC    F'10'
C00051   DC    A(Q00002)
C00052   DC    V(F77RDBI)
C00053   DC    V(F77RDI)
C00054   DC    V(F77RDEND)
C00056   DC    A(G00055)
C00057   DC    A(Q00003)
C00033   DC    H'-1'
Q00004   DC    C'(1X,''>LDRO'',6I5)'
Q00001   DC    C'(I2)'
Q00002   DC    C'(I2)'
Q00003   DC    C'(2I1)'
* INC
INC      CSECT
         USING *,15
         B     L00062
         DC    AL1(3),CL7'INC'
L00062   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00063
L00064   DC    A(S00059)
L00063   L     15,L00064
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00059,13
         ST    1,S00059+72
L00060   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         A     2,C00065
         ST    2,0(,3)
         LA    0,0
L00061   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00059   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00065   DC    F'1'
G00042   CSECT
         DS    0D
         DC    X'00000001'
G00027   CSECT
         DS    0D
         DC    X'00000004'
G00040   CSECT
         DS    0D
         DC    X'00000001'
G00045   CSECT
         DS    0D
         DC    X'00000001'
G00055   CSECT
         DS    0D
         DC    X'00000001'
G00031   CSECT
         DS    0D
         DC    X'00000001'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
