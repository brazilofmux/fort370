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
L00003   DS    0H
L00004   DS    0H
         L     14,C00019
         AH    14,C00020
         ST    14,S00000+176
         L     14,C00022
         AH    14,C00020
         ST    14,S00000+184
         L     14,C00019
         AH    14,C00020
         ST    14,S00000+192
         L     14,C00022
         AH    14,C00020
         ST    14,S00000+200
         L     10,C00019
         AH    10,C00020
         L     7,C00022
         AH    7,C00020
         LA    8,4
         LA    9,16
         LA    3,4
         LA    2,0
L00005   DS    0H
         L     14,S00000+176
         L     5,0(3,14)
         L     14,S00000+184
         L     4,0(3,14)
         LR    0,5
         SRDA  0,32
         DR    0,4
         LR    14,0
         ST    14,S00000+208
         LR    14,1
         ST    14,S00000+216
         A     4,C00023
         LR    0,5
         SRDA  0,32
         DR    0,4
         LR    14,0
         ST    14,S00000+224
         A     2,C00024
L00007   DS    0H
         L     14,S00000+192
         L     5,0(3,14)
         L     14,S00000+200
         L     4,0(3,14)
         LR    6,4
         A     6,C00023
         LR    0,5
         SRDA  0,32
         DR    0,6
         LR    14,1
         ST    14,S00000+232
         LR    11,4
         S     11,C00023
         LR    0,5
         SRDA  0,32
         DR    0,11
         LR    14,0
         ST    14,S00000+240
         LR    0,5
         SRDA  0,32
         D     0,C00025
         LR    6,1
         AR    2,6
         LR    0,5
         SRDA  0,32
         DR    0,11
         LR    6,1
         A     5,C00023
         LR    0,5
         SRDA  0,32
         DR    0,4
         LR    5,0
         C     2,C00026
         BC    4,L00008
L00009   DS    0H
L00010   DS    0H
         L     4,0(3,10)
         A     4,C00023
         LR    0,4
         SRDA  0,32
         D     0,0(3,7)
         LR    4,1
         LA    0,6
         ST    0,P00027+0
         L     0,C00028
         ST    0,P00027+4
         LA    1,P00027
         L     15,C00029
         BALR  14,15
         L     11,0(3,10)
         LR    0,11
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00030
         BALR  14,15
         L     11,0(3,7)
         LR    0,11
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00030
         BALR  14,15
         L     0,S00000+216
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00030
         BALR  14,15
         L     0,S00000+208
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00030
         BALR  14,15
         L     0,S00000+232
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00030
         BALR  14,15
         L     0,S00000+224
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00030
         BALR  14,15
         LR    0,6
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00030
         BALR  14,15
         L     0,S00000+240
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00030
         BALR  14,15
         LR    0,4
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00030
         BALR  14,15
         LR    0,5
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00030
         BALR  14,15
         L     15,C00031
         BALR  14,15
L00011   DS    0H
         BXLE  3,8,L00005
L00006   DS    0H
         LA    0,6
         ST    0,P00027+0
         L     0,C00032
         ST    0,P00027+4
         LA    1,P00027
         L     15,C00029
         BALR  14,15
         LR    0,2
         ST    0,P00027+0
         LA    1,P00027
         L     15,C00030
         BALR  14,15
         L     15,C00031
         BALR  14,15
L00012   DS    0H
L00013   DS    0H
         B     L00014
L00008   DS    0H
         B     L00010
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
         DS    10D
P00027   DS    2F
C00019   DC    A(G00018)
C00022   DC    A(G00021)
C00023   DC    F'1'
C00024   DC    F'1000'
C00025   DC    F'3'
C00026   DC    F'-1000'
C00028   DC    A(Q00001)
C00029   DC    V(F77WRBEG)
C00030   DC    V(F77WRI)
C00031   DC    V(F77WREND)
C00032   DC    A(Q00002)
C00020   DC    H'-4'
Q00001   DC    C'(1X,''>DIVREM'',2I4,8I4)'
Q00002   DC    C'(1X,''>DIVREM K'',I6)'
* BUMP
BUMP     CSECT
         USING *,15
         B     L00036
         DC    AL1(4),CL7'BUMP'
L00036   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00037
L00038   DC    A(S00033)
L00037   L     15,L00038
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00033,13
         ST    1,S00033+72
L00034   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         A     2,C00039
         ST    2,0(,3)
         LA    0,0
L00035   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00033   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00039   DC    F'1000'
G00018   CSECT
         DS    0D
         DC    X'0000002FFFFFFFD10000002FFFFFFFD1'
G00021   CSECT
         DS    0D
         DC    X'0000000500000005FFFFFFFBFFFFFFFB'
         END
