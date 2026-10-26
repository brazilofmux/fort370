* main
F77MAIN  CSECT
         USING *,15
         B     L00023
         DC    AL1(7),CL7'F77MAIN'
L00023   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00024
L00025   DC    A(S00000)
L00024   L     15,L00025
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00008   DS    0H
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         LA    2,5
L00009   DS    0H
         C     2,C00028
         BC    2,L00010
L00011   DS    0H
         L     15,C00029
         BALR  14,15
L00012   DS    0H
         LA    1,P00030
         L     15,C00031
         BALR  14,15
         LA    1,P00032
         L     15,C00033
         BALR  14,15
         L     15,C00029
         BALR  14,15
L00013   DS    0H
         LA    1,P00034
         L     15,C00035
         BALR  14,15
         LR    2,15
         C     2,C00028
         BC    7,L00014
L00015   DS    0H
         LA    1,P00026
         L     15,C00027
         BALR  14,15
         LA    2,6
L00016   DS    0H
         C     2,C00028
         BC    2,L00017
L00018   DS    0H
         L     15,C00029
         BALR  14,15
         LA    1,P00036
         L     15,C00035
         BALR  14,15
         LR    2,15
         C     2,C00028
         BC    7,L00019
L00020   DS    0H
         LA    1,P00037
         L     15,C00038
         BALR  14,15
         B     L00022
L00010   DS    0H
         LA    1,P00039
         L     15,C00033
         BALR  14,15
         AH    2,C00040
         B     L00009
L00014   DS    0H
         LA    1,P00041
         L     15,C00038
         BALR  14,15
         B     L00022
L00017   DS    0H
         LA    1,P00042
         L     15,C00033
         BALR  14,15
         AH    2,C00040
         B     L00016
L00019   DS    0H
         LA    1,P00043
         L     15,C00038
         BALR  14,15
         B     L00022
L00021   DS    0H
L00022   DS    0H
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
T00007   DS    XL16
P00026   DC    A(T00007)
         DC    F'12'
         DC    F'1'
         DC    A(Q00001)
P00030   DC    F'6'
         DC    A(Q00002)
P00032   DC    A(T00007)
         DC    F'12'
P00034   DC    A(T00007)
         DC    F'12'
         DC    A(Q00003)
         DC    F'7'
P00036   DC    A(T00007)
         DC    F'12'
         DC    A(Q00004)
         DC    F'9'
P00037   DC    F'0'
P00039   DC    A(Q00005)
         DC    F'1'
P00041   DC    F'1'
P00042   DC    A(Q00006)
         DC    F'1'
P00043   DC    F'2'
         DS    XL4
C00027   DC    V(F77WRBI)
C00028   DC    F'0'
C00029   DC    V(F77WREND)
C00031   DC    V(F77WRBEG)
C00033   DC    V(F77WRA)
C00035   DC    V(F77STRCM)
C00038   DC    V(EXIT)
C00040   DC    H'-1'
Q00001   DC    C'(3(''!'',3A1))'
Q00002   DC    C'(1X,''>FMTEND '',A)'
Q00005   DC    C'*'
Q00003   DC    C'!***!**'
Q00006   DC    C'*'
Q00004   DC    C'!***!***!'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
