* main
F77MAIN  CSECT
         USING *,15
         B     L00013
         DC    AL1(7),CL7'F77MAIN'
L00013   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00014
L00015   DC    A(S00000)
L00014   L     15,L00015
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00006   DS    0H
         LE    0,C00016
         ME    0,C00016
         STE   0,S00000+176
         LE    2,C00016
         LCER  2,2
         LE    0,C00016
         ME    0,C00017
         LER   4,2
         MER   4,0
         STE   4,S00000+184
         LA    0,6
         ST    0,P00018+0
         L     0,C00019
         ST    0,P00018+4
         LA    1,P00018
         L     15,C00020
         BALR  14,15
         LE    0,S00000+176
         STE   0,P00018+0
         LA    1,P00018
         L     15,C00021
         BALR  14,15
         LE    0,S00000+184
         STE   0,P00018+0
         LA    1,P00018
         L     15,C00021
         BALR  14,15
         LE    0,C00022
         AE    0,C00022
         STE   0,S00000+176
         LE    0,S00000+176
         STE   0,P00018+0
         LA    1,P00018
         L     15,C00021
         BALR  14,15
         L     15,C00023
         BALR  14,15
         LD    0,C00024
         MD    0,C00024
         STD   0,S00000+176
         LA    0,6
         ST    0,P00018+0
         L     0,C00025
         ST    0,P00018+4
         LA    1,P00018
         L     15,C00020
         BALR  14,15
         LD    0,S00000+176
         STD   0,P00018+0
         LA    1,P00018
         L     15,C00026
         BALR  14,15
         L     15,C00023
         BALR  14,15
         LE    0,C00027
         ME    0,C00027
         STE   0,S00000+176
         LA    0,6
         ST    0,P00018+0
         L     0,C00028
         ST    0,P00018+4
         LA    1,P00018
         L     15,C00020
         BALR  14,15
         LE    0,S00000+176
         STE   0,P00018+0
         LA    1,P00018
         L     15,C00021
         BALR  14,15
         L     15,C00023
         BALR  14,15
         LA    0,6
         ST    0,P00018+0
         L     0,C00029
         ST    0,P00018+4
         LA    1,P00018
         L     15,C00020
         BALR  14,15
         LE    0,C00017
         DE    0,C00030
         STE   0,S00000+176
         LE    0,S00000+176
         STE   0,P00018+0
         LA    1,P00018
         L     15,C00021
         BALR  14,15
         MVC   S00000+88(4),C00030
         LD    0,S00000+88
         LD    2,C00031
         DDR   2,0
         STD   2,S00000+176
         LD    0,S00000+176
         STD   0,P00018+0
         LA    1,P00018
         L     15,C00026
         BALR  14,15
         L     15,C00023
         BALR  14,15
         LA    0,9
         SRDA  0,32
         D     0,C00032
         LR    4,1
         LA    0,9
         SRDA  0,32
         D     0,C00032
         LR    2,0
         S     2,C00033
         LA    0,6
         ST    0,P00018+0
         L     0,C00034
         ST    0,P00018+4
         LA    1,P00018
         L     15,C00020
         BALR  14,15
         LR    0,4
         ST    0,P00018+0
         LA    1,P00018
         L     15,C00035
         BALR  14,15
         LR    0,2
         ST    0,P00018+0
         LA    1,P00018
         L     15,C00035
         BALR  14,15
         L     15,C00023
         BALR  14,15
L00007   DS    0H
L00008   DS    0H
L00009   DS    0H
L00010   DS    0H
L00011   DS    0H
L00012   DS    0H
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
         DS    2D
P00018   DS    2F
C00024   DC    X'7D1B2AC2F3CBE57B'
C00031   DC    X'4160000000000000'
C00016   DC    X'7976B1D1'
C00017   DC    X'41400000'
C00019   DC    A(Q00001)
C00020   DC    V(F77WRBEG)
C00021   DC    V(F77WRR)
C00022   DC    X'7FE5EDEA'
C00023   DC    V(F77WREND)
C00025   DC    A(Q00002)
C00026   DC    V(F77WRD)
C00027   DC    X'0A35EB7E'
C00028   DC    A(Q00003)
C00029   DC    A(Q00004)
C00030   DC    X'00000000'
C00032   DC    F'0'
C00033   DC    F'9'
C00034   DC    A(Q00005)
C00035   DC    V(F77WRI)
Q00001   DC    C'('' >O '',3E15.7)'
Q00002   DC    C'('' >Q '',D23.16)'
Q00003   DC    C'('' >U '',E15.7)'
Q00004   DC    C'('' >Z '',E15.7,D23.16)'
Q00005   DC    C'('' >J '',2I12)'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
