* main
F77MAIN  CSECT
         USING *,15
         B     L00020
         DC    AL1(7),CL7'F77MAIN'
L00020   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00021
L00022   DC    A(S00000)
L00021   L     15,L00022
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00006   DS    0H
L00007   DS    0H
         LD    2,C00023
         LD    4,C00024
         LA    4,8
         LA    5,32
         LA    2,8
         LA    3,1
L00008   DS    0H
         LR    0,3
         X     0,C00025
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00026
         DDR   0,4
         ADR   0,2
         STD   0,T00005-8(2)
L00010   DS    0H
         A     3,C00027
         BXLE  2,4,L00008
L00009   DS    0H
         LA    1,P00028
         L     15,C00029
         BALR  14,15
         L     15,C00030
         BALR  14,15
L00011   DS    0H
         LA    1,P00031
         L     15,C00029
         BALR  14,15
         LD    0,C00033
         STD   0,P00032+0
         LA    1,P00032
         L     15,C00034
         BALR  14,15
         LD    0,C00035
         STD   0,P00032+0
         LA    1,P00032
         L     15,C00034
         BALR  14,15
         LD    0,C00036
         STD   0,P00032+0
         LA    1,P00032
         L     15,C00034
         BALR  14,15
         L     15,C00030
         BALR  14,15
L00012   DS    0H
         LA    1,P00037
         L     15,C00029
         BALR  14,15
         LA    2,8
         LA    3,4
L00013   DS    0H
         C     3,C00038
         BC    2,L00014
L00015   DS    0H
         L     15,C00030
         BALR  14,15
L00016   DS    0H
         LA    1,P00039
         L     15,C00029
         BALR  14,15
         LA    1,P00040
         L     15,C00041
         BALR  14,15
         LD    0,C00033
         STD   0,P00032+0
         LA    1,P00032
         L     15,C00034
         BALR  14,15
         L     15,C00030
         BALR  14,15
L00017   DS    0H
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         B     L00019
L00014   DS    0H
         LD    0,T00005-8(2)
         STD   0,S00000+232
         LD    0,S00000+232
         STD   0,P00032+0
         LA    1,P00032
         L     15,C00034
         BALR  14,15
         AH    3,C00044
         A     2,C00045
         B     L00013
L00018   DS    0H
L00019   DS    0H
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
T00005   DS    XL52
         DS    XL4
         DS    1D
P00028   DC    F'6'
         DC    A(Q00001)
P00031   DC    F'6'
         DC    A(Q00002)
P00032   DC    A(0)
         DC    A(0)
P00037   DC    F'6'
         DC    A(Q00003)
P00039   DC    F'6'
         DC    A(Q00004)
P00040   DC    F'4'
P00042   DC    F'0'
C00023   DC    X'4110000000000000'
C00024   DC    X'4180000000000000'
C00026   DC    X'4E00000080000000'
C00033   DC    X'3B218DEF416BDB1A'
C00035   DC    X'4020000000000000'
C00036   DC    X'41C8000000000000'
C00025   DC    F'-2147483648'
C00027   DC    F'1'
C00029   DC    V(F77WRBEG)
C00030   DC    V(F77WREND)
C00034   DC    V(F77WRD)
C00038   DC    F'0'
C00041   DC    V(F77WRI)
C00043   DC    V(EXIT)
C00045   DC    F'8'
C00044   DC    H'-1'
Q00001   DC    C'(''     NORM. RESID      TIME       MFLO'
         DC    C'PS'')'
Q00002   DC    C'(2X,E14.7,2X,F8.4,2X,F10.3)'
Q00003   DC    C'('' X ='',4F9.4)'
Q00004   DC    C'('' N ='',I4,''  RESID ='',E12.5)'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
