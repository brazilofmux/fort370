* main
F77MAIN  CSECT
         USING *,15
         B     L00028
         DC    AL1(7),CL7'F77MAIN'
L00028   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00029
L00030   DC    A(S00000)
L00029   L     15,L00030
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00001   DS    0H
         LE    0,C00031
         CE    0,C00032
         BC    4,L00002
         LA    2,0
         B     L00003
L00002   DS    0H
         LA    2,1
L00003   DS    0H
         LE    0,C00031
         ME    0,C00032
         LE    2,C00033
         CER   2,0
         BC    3,L00005
L00004   DS    0H
         A     2,C00034
L00005   DS    0H
         LE    0,C00031
         CE    0,C00032
         LA    4,1
         BC    8,L00035
         SR    4,4
L00035   DS    0H
         LTR   4,4
         LA    3,1
         BC    8,L00036
         SR    3,3
L00036   DS    0H
         LTR   3,3
         BC    8,L00007
L00006   DS    0H
         A     2,C00037
L00007   DS    0H
         C     2,C00038
         BC    7,L00008
L00009   DS    0H
         LA    0,2
         X     0,C00039
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00040
         LER   0,0
         AE    0,C00031
         CE    0,C00041
         LA    3,1
         BC    8,L00042
         SR    3,3
L00042   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00043
         SR    2,2
L00043   DS    0H
         LTR   2,2
         BC    7,L00010
L00011   DS    0H
         LE    0,C00032
         STE   0,S00000+88
         LD    0,S00000+88
         LTDR  0,0
         LPDR  0,0
         AW    0,C00044
         STD   0,S00000+168
         L     2,S00000+172
         LE    0,C00032
         LTDR  0,0
         BC    10,L00045
         LCR   2,2
L00045   DS    0H
         C     2,C00034
         BC    7,L00012
L00013   DS    0H
L00014   DS    0H
         LH    4,C00046
         LA    5,0
         LA    3,5
         LA    2,0
L00015   DS    0H
         A     2,C00047
L00017   DS    0H
         BXH   3,4,L00015
L00016   DS    0H
         C     2,C00048
         BC    7,L00018
L00019   DS    0H
L00020   DS    0H
L00022   DS    0H
L00025   DS    0H
         LA    0,0
         ST    0,P00049+0
         LA    1,P00049
         L     15,C00050
         BALR  14,15
         B     L00027
L00008   DS    0H
         LA    0,31
         ST    0,P00049+0
         LA    1,P00049
         L     15,C00050
         BALR  14,15
         B     L00027
L00010   DS    0H
         LA    0,32
         ST    0,P00049+0
         LA    1,P00049
         L     15,C00050
         BALR  14,15
         B     L00027
L00012   DS    0H
         LA    0,33
         ST    0,P00049+0
         LA    1,P00049
         L     15,C00050
         BALR  14,15
         B     L00027
L00018   DS    0H
         LA    0,34
         ST    0,P00049+0
         LA    1,P00049
         L     15,C00050
         BALR  14,15
         B     L00027
L00021   DS    0H
L00023   DS    0H
L00024   DS    0H
L00026   DS    0H
L00027   DS    0H
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
P00049   DS    1F
         DS    XL4
C00040   DC    X'4E00000080000000'
C00044   DC    X'4E00000000000000'
C00031   DC    X'41180000'
C00032   DC    X'41200000'
C00033   DC    X'41300000'
C00034   DC    F'2'
C00037   DC    F'4'
C00038   DC    F'7'
C00039   DC    F'-2147483648'
C00041   DC    X'41380000'
C00047   DC    F'1'
C00048   DC    F'5'
C00050   DC    V(EXIT)
C00046   DC    H'-1'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
