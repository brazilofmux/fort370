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
L00008   DS    0H
         LA    15,1
         ST    15,T00005
L00009   DS    0H
         LH    4,C00024
         LA    5,0
         LA    2,3
L00010   DS    0H
         LA    0,T00006
         ST    0,P00025+0
         LA    0,10
         ST    0,P00025+4
         LA    0,T00005
         ST    0,P00025+8
         OI    P00025+8,X'80'
         LA    1,P00025
         L     15,C00026
         BALR  14,15
         LA    0,T00007
         ST    0,P00025+0
         LA    0,10
         ST    0,P00025+4
         LA    0,T00006
         ST    0,P00025+8
         LA    0,10
         ST    0,P00025+12
         LA    1,P00025
         L     15,C00027
         BALR  14,15
         L     6,T00005
         C     6,C00028
         LA    3,1
         BC    8,L00029
         SR    3,3
L00029   DS    0H
         LA    0,T00007
         ST    0,P00025+0
         LA    0,10
         ST    0,P00025+4
         L     0,C00030
         ST    0,P00025+8
         LA    0,9
         ST    0,P00025+12
         LA    1,P00025
         L     15,C00031
         BALR  14,15
         LR    7,15
         C     7,C00032
         LA    6,1
         BC    7,L00033
         SR    6,6
L00033   DS    0H
         NR    3,6
         LTR   3,3
         BC    7,L00012
L00013   DS    0H
         L     6,T00005
         C     6,C00034
         LA    3,1
         BC    8,L00035
         SR    3,3
L00035   DS    0H
         LA    0,T00007
         ST    0,P00025+0
         LA    0,10
         ST    0,P00025+4
         L     0,C00036
         ST    0,P00025+8
         LA    0,10
         ST    0,P00025+12
         LA    1,P00025
         L     15,C00031
         BALR  14,15
         LR    7,15
         C     7,C00032
         LA    6,1
         BC    7,L00037
         SR    6,6
L00037   DS    0H
         NR    3,6
         LTR   3,3
         BC    7,L00014
L00015   DS    0H
         L     6,T00005
         C     6,C00038
         LA    3,1
         BC    8,L00039
         SR    3,3
L00039   DS    0H
         LA    0,T00007
         ST    0,P00025+0
         LA    0,10
         ST    0,P00025+4
         L     0,C00040
         ST    0,P00025+8
         LA    0,10
         ST    0,P00025+12
         LA    1,P00025
         L     15,C00031
         BALR  14,15
         LR    7,15
         C     7,C00032
         LA    6,1
         BC    7,L00041
         SR    6,6
L00041   DS    0H
         NR    3,6
         LTR   3,3
         BC    7,L00016
L00017   DS    0H
         LA    0,3
         ST    0,P00025+0
         LA    1,P00025
         L     15,C00042
         BALR  14,15
         LA    0,6
         ST    0,P00025+0
         L     0,C00043
         ST    0,P00025+4
         LA    1,P00025
         L     15,C00044
         BALR  14,15
         LA    0,T00007
         ST    0,P00025+0
         LA    0,10
         ST    0,P00025+4
         LA    1,P00025
         L     15,C00045
         BALR  14,15
         L     15,C00046
         BALR  14,15
L00018   DS    0H
         L     3,T00005
         A     3,C00028
         ST    3,T00005
         BXH   2,4,L00010
L00011   DS    0H
         LA    0,0
         ST    0,P00025+0
         LA    1,P00025
         L     15,C00047
         BALR  14,15
         B     L00020
L00012   DS    0H
         LA    0,1
         ST    0,P00025+0
         LA    1,P00025
         L     15,C00047
         BALR  14,15
         B     L00020
L00014   DS    0H
         LA    0,2
         ST    0,P00025+0
         LA    1,P00025
         L     15,C00047
         BALR  14,15
         B     L00020
L00016   DS    0H
         LA    0,3
         ST    0,P00025+0
         LA    1,P00025
         L     15,C00047
         BALR  14,15
         B     L00020
L00019   DS    0H
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
T00005   DS    XL8
T00006   DS    XL16
T00007   DS    XL32
P00025   DS    4F
C00026   DC    V(CF)
C00027   DC    V(F77STRCP)
C00028   DC    F'1'
C00030   DC    A(Q00001)
C00031   DC    V(F77STRCM)
C00032   DC    F'0'
C00034   DC    F'2'
C00036   DC    A(Q00002)
C00038   DC    F'3'
C00040   DC    A(Q00003)
C00042   DC    V(F77FMTLM)
C00043   DC    A(Q00004)
C00044   DC    V(F77WRBEG)
C00045   DC    V(F77WRA)
C00046   DC    V(F77WREND)
C00047   DC    V(EXIT)
C00024   DC    H'-1'
Q00001   DC    C'FIRST AID'
Q00002   DC    C'SECONDRATE'
Q00003   DC    C'THIRDCLASS'
Q00004   DC    C'(A)'
* CF
CF       CSECT
         USING *,15
         B     L00059
         DC    AL1(2),CL7'CF'
L00059   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00060
L00061   DC    A(S00048)
L00060   L     15,L00061
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00048,13
         ST    1,S00048+72
L00052   DS    0H
         L     3,8(,1)
         LA    3,0(,3)
         L     4,0(,1)
         L     2,0(,3)
         S     2,C00062
         C     2,C00063
         LA    3,1
         BC    8,L00064
         SR    3,3
L00064   DS    0H
         C     2,C00063
         BC    4,L00054
L00053   DS    0H
         LTR   3,3
         BC    7,L00055
L00056   DS    0H
         LR    0,4
         ST    0,P00065+0
         LA    0,10
         ST    0,P00065+4
         L     0,C00066
         ST    0,P00065+8
         LA    0,10
         ST    0,P00065+12
         LA    1,P00065
         L     15,C00067
         BALR  14,15
         ICM   2,8,0(4)
         SRA   2,24
         LR    0,2
         B     L00058
L00054   DS    0H
         LR    0,4
         ST    0,P00065+0
         LA    0,10
         ST    0,P00065+4
         L     0,C00068
         ST    0,P00065+8
         LA    0,9
         ST    0,P00065+12
         LA    1,P00065
         L     15,C00067
         BALR  14,15
         ICM   2,8,0(4)
         SRA   2,24
         LR    0,2
         B     L00058
L00055   DS    0H
         LR    0,4
         ST    0,P00065+0
         LA    0,10
         ST    0,P00065+4
         L     0,C00069
         ST    0,P00065+8
         LA    0,10
         ST    0,P00065+12
         LA    1,P00065
         L     15,C00067
         BALR  14,15
         ICM   2,8,0(4)
         SRA   2,24
         LR    0,2
         B     L00058
L00057   DS    0H
L00058   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00048   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00065   DS    4F
C00062   DC    F'2'
C00063   DC    F'0'
C00066   DC    A(Q00051)
C00067   DC    V(F77STRCP)
C00068   DC    A(Q00049)
C00069   DC    A(Q00050)
Q00049   DC    C'FIRST AID'
Q00050   DC    C'SECONDRATE'
Q00051   DC    C'THIRDCLASS'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
