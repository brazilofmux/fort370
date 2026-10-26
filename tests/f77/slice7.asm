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
L00001   DS    0H
L00002   DS    0H
L00004   DS    0H
L00005   DS    0H
L00006   DS    0H
L00008   DS    0H
L00009   DS    0H
L00010   DS    0H
L00012   DS    0H
         LE    0,C00027
         DE    0,C00028
L00013   DS    0H
         CE    0,C00029
         LA    3,1
         BC    8,L00030
         SR    3,3
L00030   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00031
         SR    2,2
L00031   DS    0H
         LTR   2,2
         BC    7,L00014
L00015   DS    0H
         LD    0,C00032
         MD    0,C00032
         MD    0,C00032
L00016   DS    0H
         CD    0,C00033
         LA    3,1
         BC    8,L00034
         SR    3,3
L00034   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00035
         SR    2,2
L00035   DS    0H
         LTR   2,2
         BC    7,L00017
L00018   DS    0H
         LD    0,C00036
         MD    0,C00036
         MD    0,C00036
L00019   DS    0H
         AD    0,C00037
         CD    0,C00038
         LA    3,1
         BC    8,L00039
         SR    3,3
L00039   DS    0H
         LTR   3,3
         LA    2,1
         BC    8,L00040
         SR    2,2
L00040   DS    0H
         LTR   2,2
         BC    7,L00020
L00021   DS    0H
         LA    1,P00041
         L     15,C00042
         BALR  14,15
         B     L00023
L00003   DS    0H
L00007   DS    0H
L00011   DS    0H
L00014   DS    0H
         LA    1,P00043
         L     15,C00042
         BALR  14,15
         B     L00023
L00017   DS    0H
         LA    1,P00044
         L     15,C00042
         BALR  14,15
         B     L00023
L00020   DS    0H
         LA    1,P00045
         L     15,C00042
         BALR  14,15
         B     L00023
L00022   DS    0H
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
P00041   DC    F'0'
P00043   DC    F'94'
P00044   DC    F'95'
P00045   DC    F'96'
C00032   DC    X'4130000000000000'
C00033   DC    X'421B000000000000'
C00036   DC    X'4120000000000000'
C00037   DC    X'4110000000000000'
C00038   DC    X'4190000000000000'
C00027   DC    X'41500000'
C00028   DC    X'41200000'
C00029   DC    X'41280000'
C00042   DC    V(EXIT)
* ISQ
ISQ      CSECT
         USING *,15
         B     L00050
         DC    AL1(3),CL7'ISQ'
L00050   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00051
L00052   DC    A(S00046)
L00051   L     15,L00052
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00046,13
         ST    1,S00046+72
L00047   DS    0H
         L     3,0(,1)
         LA    3,0(,3)
         L     2,0(,3)
         LR    1,2
         MR    0,2
         LR    2,1
         LR    0,2
         B     L00049
L00048   DS    0H
L00049   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00046   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
* RHALF
RHALF    CSECT
         USING *,15
         B     L00057
         DC    AL1(5),CL7'RHALF'
L00057   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00058
L00059   DC    A(S00053)
L00058   L     15,L00059
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00053,13
         ST    1,S00053+72
L00054   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         LE    0,0(,2)
         DE    0,C00060
         B     L00056
L00055   DS    0H
L00056   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00053   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00060   DC    X'41200000'
* DCUBE
DCUBE    CSECT
         USING *,15
         B     L00065
         DC    AL1(5),CL7'DCUBE'
L00065   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00066
L00067   DC    A(S00061)
L00066   L     15,L00067
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00061,13
         ST    1,S00061+72
L00062   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         LD    2,0(,2)
         LDR   0,2
         MDR   0,2
         MDR   0,2
         B     L00064
L00063   DS    0H
L00064   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00061   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
