* main
F77MAIN  CSECT
         USING *,15
         B     L00016
         DC    AL1(7),CL7'F77MAIN'
L00016   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00017
L00018   DC    A(S00000)
L00017   L     15,L00018
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00002   DS    0H
L00003   DS    0H
         LH    6,C00019
         LA    7,0
         LA    2,5
         LA    3,6
         LA    4,5
         LE    6,C00020
         LE    4,C00021
         LE    2,C00022
         LE    0,C00023
L00004   DS    0H
L00006   DS    0H
         BXH   2,6,L00024
         STE   4,S00000+200
         STE   6,S00000+192
         STE   0,S00000+184
         STE   2,S00000+176
         B     L00005
L00024   DS    0H
         LR    0,3
         LR    3,4
         LR    4,0
         STD   6,S00000+160
         LER   6,4
         LD    4,S00000+160
         STD   2,S00000+160
         LER   2,0
         LD    0,S00000+160
         B     L00004
L00005   DS    0H
         LA    0,6
         ST    0,P00025+0
         L     0,C00026
         ST    0,P00025+4
         LA    1,P00025
         L     15,C00027
         BALR  14,15
         LE    0,S00000+176
         STE   0,P00025+0
         LA    1,P00025
         L     15,C00028
         BALR  14,15
         LE    0,S00000+184
         STE   0,P00025+0
         LA    1,P00025
         L     15,C00028
         BALR  14,15
         LE    0,S00000+192
         STE   0,P00025+0
         LA    1,P00025
         L     15,C00028
         BALR  14,15
         LE    0,S00000+200
         STE   0,P00025+0
         LA    1,P00025
         L     15,C00028
         BALR  14,15
         LR    0,3
         ST    0,P00025+0
         LA    1,P00025
         L     15,C00029
         BALR  14,15
         LR    0,4
         ST    0,P00025+0
         LA    1,P00025
         L     15,C00029
         BALR  14,15
         L     15,C00030
         BALR  14,15
L00007   DS    0H
         LE    0,S00000+176
         CE    0,C00022
         LA    5,1
         BC    8,L00031
         SR    5,5
L00031   DS    0H
         LTR   5,5
         LA    2,1
         BC    8,L00032
         SR    2,2
L00032   DS    0H
         LE    0,S00000+184
         CE    0,C00023
         LA    6,1
         BC    8,L00033
         SR    6,6
L00033   DS    0H
         LTR   6,6
         LA    5,1
         BC    8,L00034
         SR    5,5
L00034   DS    0H
         OR    2,5
         LTR   2,2
         BC    7,L00008
L00009   DS    0H
         LE    0,S00000+192
         CE    0,C00020
         LA    5,1
         BC    8,L00035
         SR    5,5
L00035   DS    0H
         LTR   5,5
         LA    2,1
         BC    8,L00036
         SR    2,2
L00036   DS    0H
         LE    0,S00000+200
         CE    0,C00021
         LA    6,1
         BC    8,L00037
         SR    6,6
L00037   DS    0H
         LTR   6,6
         LA    5,1
         BC    8,L00038
         SR    5,5
L00038   DS    0H
         OR    2,5
         LTR   2,2
         BC    7,L00010
L00011   DS    0H
         C     3,C00039
         LA    2,1
         BC    7,L00040
         SR    2,2
L00040   DS    0H
         C     4,C00041
         LA    3,1
         BC    7,L00042
         SR    3,3
L00042   DS    0H
         OR    2,3
         LTR   2,2
         BC    7,L00012
L00013   DS    0H
         LA    0,0
         ST    0,P00025+0
         LA    1,P00025
         L     15,C00043
         BALR  14,15
         B     L00015
L00008   DS    0H
         LA    0,1
         ST    0,P00025+0
         LA    1,P00025
         L     15,C00043
         BALR  14,15
         B     L00015
L00010   DS    0H
         LA    0,2
         ST    0,P00025+0
         LA    1,P00025
         L     15,C00043
         BALR  14,15
         B     L00015
L00012   DS    0H
         LA    0,3
         ST    0,P00025+0
         LA    1,P00025
         L     15,C00043
         BALR  14,15
         B     L00015
L00014   DS    0H
L00015   DS    0H
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
         DS    4D
P00025   DS    2F
C00020   DC    X'41400000'
C00021   DC    X'41300000'
C00022   DC    X'41200000'
C00023   DC    X'41100000'
C00026   DC    A(Q00001)
C00027   DC    V(F77WRBEG)
C00028   DC    V(F77WRR)
C00029   DC    V(F77WRI)
C00030   DC    V(F77WREND)
C00039   DC    F'6'
C00041   DC    F'5'
C00043   DC    V(EXIT)
C00019   DC    H'-1'
Q00001   DC    C'(1X,''>PHISWAP'',4F5.1,2I3)'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
