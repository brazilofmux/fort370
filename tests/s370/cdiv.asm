* main
F77MAIN  CSECT
         USING *,15
         B     L00010
         DC    AL1(7),CL7'F77MAIN'
L00010   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00011
L00012   DC    A(S00000)
L00011   L     15,L00012
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00007   DS    0H
         LE    0,C00013
         AE    0,C00014
         STE   0,S00000+280
         LE    0,C00014
         AE    0,C00015
         STE   0,S00000+288
         LA    0,T00006
         ST    0,P00016+0
         LE    0,S00000+280
         STE   0,P00016+4
         LE    0,S00000+288
         STE   0,P00016+8
         LA    1,P00016
         L     15,C00017
         BALR  14,15
         LE    0,C00018
         DE    0,C00019
         STE   0,S00000+280
         LA    0,T00002
         ST    0,P00016+0
         LE    0,C00014
         STE   0,P00016+4
         LE    0,S00000+280
         STE   0,P00016+8
         LA    1,P00016
         L     15,C00017
         BALR  14,15
         LE    0,T00002
         STE   0,S00000+280
         LE    0,T00002+4
         STE   0,S00000+288
         LE    0,C00020
         STE   0,P00016+0
         XC    P00016+4(4),P00016+4
         LA    1,P00016
         L     15,C00021
         BALR  14,15
         STE   0,S00000+296
         LE    0,C00022
         AE    0,C00023
         STE   0,S00000+304
         LE    0,S00000+304
         STE   0,P00016+0
         XC    P00016+4(4),P00016+4
         LA    1,P00016
         L     15,C00024
         BALR  14,15
         LER   4,0
         LE    2,S00000+280
         SE    2,S00000+296
         LE    0,S00000+288
         SER   0,4
         L     14,C00026
         STE   2,0(,14)
         L     14,C00027
         STE   0,0(,14)
         LA    0,6
         ST    0,P00016+0
         L     0,C00028
         ST    0,P00016+4
         LA    1,P00016
         L     15,C00029
         BALR  14,15
         L     14,C00026
         LE    0,0(,14)
         STE   0,S00000+280
         LE    0,S00000+280
         STE   0,P00016+0
         LA    1,P00016
         L     15,C00030
         BALR  14,15
         L     14,C00027
         LE    0,0(,14)
         STE   0,S00000+280
         LE    0,S00000+280
         STE   0,P00016+0
         LA    1,P00016
         L     15,C00030
         BALR  14,15
         L     15,C00031
         BALR  14,15
         LE    0,C00032
         LCER  0,0
         STE   0,S00000+280
         LE    0,C00022
         LCER  0,0
         STE   0,S00000+288
         LA    0,T00003
         ST    0,P00016+0
         LE    0,S00000+280
         STE   0,P00016+4
         LE    0,S00000+288
         STE   0,P00016+8
         LA    1,P00016
         L     15,C00017
         BALR  14,15
         LE    2,T00003
         LE    0,T00003+4
         LA    0,1
         X     0,C00033
         ST    0,S00000+84
         LD    4,S00000+80
         SD    4,C00034
         LER   4,4
         LER   6,2
         MER   6,2
         STE   6,S00000+280
         LER   6,0
         MER   6,0
         AE    6,S00000+280
         STD   6,S00000+96
         LER   6,4
         MER   6,2
         STE   6,S00000+280
         LD    6,S00000+96
         STD   6,S00000+96
         LE    6,C00014
         MER   6,0
         STE   6,S00000+288
         LD    6,S00000+96
         STD   6,S00000+96
         LE    6,S00000+280
         AE    6,S00000+288
         STE   6,S00000+296
         LD    6,S00000+96
         STD   4,S00000+96
         LE    4,S00000+296
         DER   4,6
         STE   4,S00000+280
         LD    4,S00000+96
         STD   6,S00000+96
         LE    6,C00014
         MER   6,2
         STE   6,S00000+288
         LD    6,S00000+96
         STD   6,S00000+96
         LER   6,4
         MER   6,0
         STE   6,S00000+296
         LD    6,S00000+96
         LE    4,S00000+288
         SE    4,S00000+296
         DER   4,6
         AE    2,S00000+280
         AER   0,4
         LE    4,C00035
         ME    4,C00035
         LE    6,C00014
         ME    6,C00014
         AER   4,6
         LE    6,C00035
         MER   6,2
         STE   6,S00000+280
         LE    6,C00014
         MER   6,0
         AE    6,S00000+280
         STD   2,S00000+96
         LER   2,6
         DER   2,4
         STE   2,S00000+280
         LD    2,S00000+96
         ME    0,C00035
         ME    2,C00014
         SER   0,2
         LER   2,0
         DER   2,4
         STE   2,S00000+288
         LE    0,C00032
         LCER  0,0
         LE    4,C00023
         LCER  4,4
         LE    6,C00022
         MER   6,4
         LE    2,C00014
         MER   2,0
         STD   4,S00000+96
         LER   4,6
         SER   4,2
         STE   4,S00000+296
         LD    4,S00000+96
         LE    2,C00022
         ME    2,C00014
         MER   0,4
         LER   4,2
         AER   4,0
         STE   4,S00000+304
         LA    0,T00004
         ST    0,P00016+0
         LE    0,S00000+296
         STE   0,P00016+4
         LE    0,S00000+304
         STE   0,P00016+8
         LA    1,P00016
         L     15,C00036
         BALR  14,15
         LE    2,S00000+280
         SE    2,T00004
         LE    0,S00000+288
         SE    0,T00004+4
         L     14,C00026
         STE   2,0(,14)
         L     14,C00027
         STE   0,0(,14)
         LA    0,6
         ST    0,P00016+0
         L     0,C00028
         ST    0,P00016+4
         LA    1,P00016
         L     15,C00029
         BALR  14,15
         L     14,C00026
         LE    0,0(,14)
         STE   0,S00000+280
         LE    0,S00000+280
         STE   0,P00016+0
         LA    1,P00016
         L     15,C00030
         BALR  14,15
         L     14,C00027
         LE    0,0(,14)
         STE   0,S00000+280
         LE    0,S00000+280
         STE   0,P00016+0
         LA    1,P00016
         L     15,C00030
         BALR  14,15
         L     15,C00031
         BALR  14,15
         LE    0,C00037
         SE    0,C00037
         STE   0,S00000+280
         LE    0,C00037
         SE    0,C00014
         STE   0,S00000+288
         LA    0,T00005
         ST    0,P00016+0
         LE    0,S00000+280
         STE   0,P00016+4
         LE    0,S00000+288
         STE   0,P00016+8
         LA    1,P00016
         L     15,C00017
         BALR  14,15
         LE    0,T00005
         STE   0,S00000+280
         LE    0,T00005+4
         STE   0,S00000+288
         LE    0,S00000+280
         STE   0,P00016+0
         LE    0,S00000+288
         STE   0,P00016+4
         LA    1,P00016
         L     15,C00038
         BALR  14,15
         STE   0,S00000+296
         LE    0,C00014
         STE   0,P00016+0
         XC    P00016+4(4),P00016+4
         LA    1,P00016
         L     15,C00021
         BALR  14,15
         LER   2,0
         LE    0,S00000+296
         SER   0,2
         L     14,C00026
         STE   0,0(,14)
         L     14,C00027
         MVC   0(4,14),C00014
         LA    0,6
         ST    0,P00016+0
         L     0,C00028
         ST    0,P00016+4
         LA    1,P00016
         L     15,C00029
         BALR  14,15
         L     14,C00026
         LE    0,0(,14)
         STE   0,S00000+280
         LE    0,S00000+280
         STE   0,P00016+0
         LA    1,P00016
         L     15,C00030
         BALR  14,15
         L     14,C00027
         LE    0,0(,14)
         STE   0,S00000+280
         LE    0,S00000+280
         STE   0,P00016+0
         LA    1,P00016
         L     15,C00030
         BALR  14,15
         L     15,C00031
         BALR  14,15
L00008   DS    0H
L00009   DS    0H
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
T00003   DS    XL8
T00004   DS    XL8
T00005   DS    XL8
T00006   DS    XL68
         DS    XL4
         DS    4D
P00016   DS    3F
         DS    XL4
C00034   DC    X'4E00000080000000'
C00013   DC    X'40100000'
C00014   DC    X'00000000'
C00015   DC    X'41120000'
C00017   DC    V(F77CEXP)
C00018   DC    X'42258000'
C00019   DC    X'41A00000'
C00020   DC    X'413C0000'
C00021   DC    V(COS)
C00022   DC    X'412C0000'
C00023   DC    X'41100000'
C00024   DC    V(SIN)
C00026   DC    A(G00025)
C00027   DC    A(G00025+4)
C00028   DC    A(Q00001)
C00029   DC    V(F77WRBEG)
C00030   DC    V(F77WRR)
C00031   DC    V(F77WREND)
C00032   DC    X'41180000'
C00033   DC    F'-2147483648'
C00035   DC    X'41200000'
C00036   DC    V(F77CCOS)
C00037   DC    X'41340000'
C00038   DC    V(F77CABS)
Q00001   DC    C'('' >'',2F12.5)'
G00025   CSECT
         DS    0D
         DS    XL8
         END
