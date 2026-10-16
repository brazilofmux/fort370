* main
F77MAIN  CSECT
         USING *,15
         B     L00038
         DC    AL1(7),CL7'F77MAIN'
L00038   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00039
L00040   DC    A(S00000)
L00039   L     15,L00040
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00030   DS    0H
         LA    0,T00024
         ST    0,P00041+0
         LA    0,5
         ST    0,P00041+4
         L     0,C00042
         ST    0,P00041+8
         LA    0,3
         ST    0,P00041+12
         LA    1,P00041
         L     15,C00043
         BALR  14,15
         LA    0,T00025
         ST    0,P00041+0
         LA    0,5
         ST    0,P00041+4
         L     0,C00044
         ST    0,P00041+8
         LA    0,7
         ST    0,P00041+12
         LA    1,P00041
         L     15,C00043
         BALR  14,15
         LA    3,T00024
         A     3,C00045
         LA    0,T00020
         ST    0,P00041+0
         LA    0,3
         ST    0,P00041+4
         LR    0,3
         ST    0,P00041+8
         LA    0,2
         ST    0,P00041+12
         LA    1,P00041
         L     15,C00043
         BALR  14,15
         LA    0,T00026
         ST    0,P00041+0
         LA    0,5
         ST    0,P00041+4
         LA    0,T00024
         ST    0,P00041+8
         LA    0,5
         ST    0,P00041+12
         LA    1,P00041
         L     15,C00043
         BALR  14,15
         LA    3,T00026+5
         LR    0,3
         ST    0,P00041+0
         LA    0,2
         ST    0,P00041+4
         LA    0,T00025
         ST    0,P00041+8
         LA    0,2
         ST    0,P00041+12
         LA    1,P00041
         L     15,C00043
         BALR  14,15
         LA    0,T00021
         ST    0,P00041+0
         LA    0,7
         ST    0,P00041+4
         LA    0,T00026
         ST    0,P00041+8
         LA    0,7
         ST    0,P00041+12
         LA    1,P00041
         L     15,C00043
         BALR  14,15
         LA    3,T00021+7
         LR    0,3
         ST    0,P00041+0
         LA    0,1
         ST    0,P00041+4
         L     0,C00046
         ST    0,P00041+8
         LA    0,1
         ST    0,P00041+12
         LA    1,P00041
         L     15,C00043
         BALR  14,15
         LA    0,T00029
         ST    0,P00041+0
         LA    0,10
         ST    0,P00041+4
         LA    0,T00021
         ST    0,P00041+8
         LA    0,8
         ST    0,P00041+12
         LA    1,P00041
         L     15,C00043
         BALR  14,15
         LA    0,6
         ST    0,P00041+0
         L     0,C00047
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00048
         BALR  14,15
         LA    0,T00024
         ST    0,P00041+0
         LA    0,5
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00049
         BALR  14,15
         LA    0,T00025
         ST    0,P00041+0
         LA    0,5
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00049
         BALR  14,15
         LA    0,T00020
         ST    0,P00041+0
         LA    0,3
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00049
         BALR  14,15
         LA    0,T00029
         ST    0,P00041+0
         LA    0,10
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
L00031   DS    0H
         LA    0,6
         ST    0,P00041+0
         L     0,C00051
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00048
         BALR  14,15
         L     0,C00053
         ST    0,P00041+0
         LA    0,4
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00049
         BALR  14,15
         L     2,C00053
         AH    2,C00054
         LR    0,2
         ST    0,P00041+0
         LA    0,4
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00049
         BALR  14,15
         L     4,C00053
         AH    4,C00055
         LR    0,4
         ST    0,P00041+0
         LA    0,4
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00049
         BALR  14,15
         A     2,C00045
         LR    0,2
         ST    0,P00041+0
         LA    0,2
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
L00032   DS    0H
         LA    0,T00024
         ST    0,P00041+0
         LA    0,5
         ST    0,P00041+4
         L     0,C00056
         ST    0,P00041+8
         LA    0,3
         ST    0,P00041+12
         LA    1,P00041
         L     15,C00057
         BALR  14,15
         LR    2,15
         C     2,C00058
         LA    3,1
         BC    8,L00059
         SR    3,3
L00059   DS    0H
         LA    0,6
         ST    0,P00041+0
         LA    0,0
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00048
         BALR  14,15
         LR    0,3
         ST    0,P00041+0
         LA    1,P00041
         L     15,C00060
         BALR  14,15
         LA    0,T00024
         ST    0,P00041+0
         LA    0,5
         ST    0,P00041+4
         LA    0,T00025
         ST    0,P00041+8
         LA    0,5
         ST    0,P00041+12
         LA    1,P00041
         L     15,C00057
         BALR  14,15
         LR    2,15
         C     2,C00058
         LA    3,1
         BC    4,L00061
         SR    3,3
L00061   DS    0H
         LR    0,3
         ST    0,P00041+0
         LA    1,P00041
         L     15,C00060
         BALR  14,15
         L     0,C00062
         ST    0,P00041+0
         LA    0,3
         ST    0,P00041+4
         L     0,C00063
         ST    0,P00041+8
         LA    0,5
         ST    0,P00041+12
         LA    1,P00041
         L     15,C00057
         BALR  14,15
         LR    2,15
         C     2,C00058
         LA    3,1
         BC    8,L00064
         SR    3,3
L00064   DS    0H
         LR    0,3
         ST    0,P00041+0
         LA    1,P00041
         L     15,C00060
         BALR  14,15
         LA    0,10
         ST    0,P00041+0
         LA    1,P00041
         L     15,C00065
         BALR  14,15
         LA    0,5
         ST    0,P00041+0
         LA    1,P00041
         L     15,C00065
         BALR  14,15
         L     0,C00066
         ST    0,P00041+0
         LA    0,5
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LA    0,6
         ST    0,P00041+0
         LA    0,0
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00048
         BALR  14,15
         LA    0,T00029
         ST    0,P00041+0
         LA    0,10
         ST    0,P00041+4
         L     0,C00067
         ST    0,P00041+8
         LA    0,3
         ST    0,P00041+12
         LA    1,P00041
         L     15,C00068
         BALR  14,15
         LR    3,15
         LR    0,3
         ST    0,P00041+0
         LA    1,P00041
         L     15,C00065
         BALR  14,15
         L     14,C00069
         SR    3,3
         IC    3,0(,14)
         LR    0,3
         ST    0,P00041+0
         LA    1,P00041
         L     15,C00065
         BALR  14,15
         LA    15,66
         STC   15,T00027
         LA    0,T00027
         ST    0,P00041+0
         LA    0,1
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00049
         BALR  14,15
         L     0,C00070
         ST    0,P00041+0
         LA    0,1
         ST    0,P00041+4
         L     0,C00071
         ST    0,P00041+8
         LA    0,1
         ST    0,P00041+12
         LA    1,P00041
         L     15,C00072
         BALR  14,15
         LR    2,15
         C     2,C00058
         LA    3,1
         BC    10,L00073
         SR    3,3
L00073   DS    0H
         LR    0,3
         ST    0,P00041+0
         LA    1,P00041
         L     15,C00060
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LA    15,65
         ST    15,T00028
         L     4,C00053
         AH    4,C00055
         LA    15,65
         STC   15,T00022
         LA    15,66
         STC   15,T00018
         LA    0,T00019
         ST    0,P00041+0
         LA    0,1
         ST    0,P00041+4
         LA    0,T00022
         ST    0,P00041+8
         LA    0,1
         ST    0,P00041+12
         LA    1,P00041
         L     15,C00043
         BALR  14,15
         LA    3,T00019+1
         LR    0,3
         ST    0,P00041+0
         LA    0,1
         ST    0,P00041+4
         LA    0,T00018
         ST    0,P00041+8
         LA    0,1
         ST    0,P00041+12
         LA    1,P00041
         L     15,C00043
         BALR  14,15
         LR    0,4
         ST    0,P00041+0
         LA    0,4
         ST    0,P00041+4
         LA    0,T00019
         ST    0,P00041+8
         LA    0,2
         ST    0,P00041+12
         LA    1,P00041
         L     15,C00043
         BALR  14,15
         LA    0,6
         ST    0,P00041+0
         L     0,C00074
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00048
         BALR  14,15
         LR    0,4
         ST    0,P00041+0
         LA    0,4
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00049
         BALR  14,15
         LA    0,T00023
         ST    0,P00041+0
         LA    0,6
         ST    0,P00041+4
         LA    0,T00024
         ST    0,P00041+8
         LA    0,T00025
         ST    0,P00041+12
         LA    0,5
         ST    0,P00041+16
         LA    0,5
         ST    0,P00041+20
         OI    P00041+20,X'80'
         LA    1,P00041
         L     15,C00075
         BALR  14,15
         LA    0,T00023
         ST    0,P00041+0
         LA    0,6
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
L00033   DS    0H
         LA    0,T00024
         ST    0,P00041+0
         L     0,C00076
         ST    0,P00041+4
         L     0,C00053
         ST    0,P00041+8
         LA    0,5
         ST    0,P00041+12
         LA    0,3
         ST    0,P00041+16
         LA    0,4
         ST    0,P00041+20
         OI    P00041+20,X'80'
         LA    1,P00041
         L     15,C00077
         BALR  14,15
         LA    0,6
         ST    0,P00041+0
         LA    0,0
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00048
         BALR  14,15
         LA    0,T00024
         ST    0,P00041+0
         LA    0,5
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00049
         BALR  14,15
         L     0,C00053
         ST    0,P00041+0
         LA    0,4
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LA    0,5
         ST    0,P00041+0
         L     0,C00078
         ST    0,P00041+4
         LA    0,0
         ST    0,P00041+8
         LA    1,P00041
         L     15,C00079
         BALR  14,15
         LA    0,T00024
         ST    0,P00041+0
         LA    0,5
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00080
         BALR  14,15
         LA    0,T00020
         ST    0,P00041+0
         LA    0,3
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00080
         BALR  14,15
         L     15,C00081
         BALR  14,15
L00034   DS    0H
         LA    0,6
         ST    0,P00041+0
         L     0,C00082
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00048
         BALR  14,15
         LA    0,T00024
         ST    0,P00041+0
         LA    0,5
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00049
         BALR  14,15
         LA    0,T00020
         ST    0,P00041+0
         LA    0,3
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00049
         BALR  14,15
         LA    3,T00024
         A     3,C00083
         LR    0,3
         ST    0,P00041+0
         LA    0,1
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00049
         BALR  14,15
         LA    0,T00020
         ST    0,P00041+0
         LA    0,1
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
L00035   DS    0H
         LA    0,5
         ST    0,P00041+0
         LA    0,0
         ST    0,P00041+4
         LA    0,0
         ST    0,P00041+8
         LA    1,P00041
         L     15,C00079
         BALR  14,15
         LA    0,T00025
         ST    0,P00041+0
         LA    0,5
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00080
         BALR  14,15
         LA    0,T00028
         ST    0,P00041+0
         LA    1,P00041
         L     15,C00084
         BALR  14,15
         L     15,C00081
         BALR  14,15
         LA    0,6
         ST    0,P00041+0
         LA    0,0
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00048
         BALR  14,15
         LA    0,T00025
         ST    0,P00041+0
         LA    0,5
         ST    0,P00041+4
         LA    1,P00041
         L     15,C00049
         BALR  14,15
         L     3,T00028
         LR    0,3
         ST    0,P00041+0
         LA    1,P00041
         L     15,C00065
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LA    0,0
         ST    0,P00041+0
         LA    1,P00041
         L     15,C00085
         BALR  14,15
         B     L00037
L00036   DS    0H
L00037   DS    0H
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
T00018   DS    XL4
         DS    XL4
T00019   DS    XL4
         DS    XL4
T00020   DS    XL8
T00021   DS    XL8
T00022   DS    XL8
T00023   DS    XL8
T00024   DS    XL12
         DS    XL4
T00025   DS    XL12
         DS    XL4
T00026   DS    XL16
T00027   DS    XL20
         DS    XL4
T00028   DS    XL28
         DS    XL4
T00029   DS    XL32
P00041   DS    6F
C00042   DC    A(Q00001)
C00043   DC    V(F77STRCP)
C00044   DC    A(Q00002)
C00045   DC    F'1'
C00046   DC    A(Q00003)
C00047   DC    A(Q00004)
C00048   DC    V(F77WRBEG)
C00049   DC    V(F77WRA)
C00050   DC    V(F77WREND)
C00051   DC    A(Q00005)
C00053   DC    A(G00052)
C00056   DC    A(Q00006)
C00057   DC    V(F77STRCM)
C00058   DC    F'0'
C00060   DC    V(F77WRL)
C00062   DC    A(Q00007)
C00063   DC    A(Q00008)
C00065   DC    V(F77WRI)
C00066   DC    A(Q00009)
C00067   DC    A(Q00010)
C00068   DC    V(F77INDEX)
C00069   DC    A(Q00011)
C00070   DC    A(Q00012)
C00071   DC    A(Q00013)
C00072   DC    V(F77LSTRC)
C00074   DC    A(Q00014)
C00075   DC    V(F6)
C00076   DC    A(Q00015)
C00077   DC    V(SUB1)
C00078   DC    A(Q00016)
C00079   DC    V(F77RDBEG)
C00080   DC    V(F77RDS)
C00081   DC    V(F77RDEND)
C00082   DC    A(Q00017)
C00083   DC    F'4'
C00084   DC    V(F77RDI)
C00085   DC    V(EXIT)
C00054   DC    H'4'
C00055   DC    H'8'
Q00004   DC    C'(1X,A,''|'',A5,''|'',A,''|'',A10,''|'')'
Q00005   DC    C'(1X,4(A,''|''))'
Q00014   DC    C'(1X,A4,''/'',A6,''/'')'
Q00016   DC    C'(A5,A3)'
Q00017   DC    C'(1X,A,''|'',A,''|'',A,''|'',A)'
Q00009   DC    C'HELLO'
Q00001   DC    C'ABC'
Q00002   DC    C'ABCDEFG'
Q00003   DC    C'X'
Q00006   DC    C'ABC'
Q00007   DC    C'ABC'
Q00008   DC    C'ABC  '
Q00010   DC    C'CAB'
Q00011   DC    C'A'
Q00012   DC    C'B'
Q00013   DC    C'A'
Q00015   DC    C'XYZ'
* F6
F6       CSECT
         USING *,15
         B     L00090
         DC    AL1(2),CL7'F6'
L00090   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00091
L00092   DC    A(S00086)
L00091   L     15,L00092
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00086,13
         ST    1,S00086+72
L00087   DS    0H
         L     6,8(,1)
         L     3,12(,1)
         L     5,0(,1)
         L     2,16(,1)
         LR    0,3
         ST    0,P00093+0
         LA    0,2
         ST    0,P00093+4
         LR    0,6
         ST    0,P00093+8
         LR    0,2
         ST    0,P00093+12
         LA    1,P00093
         L     15,C00094
         BALR  14,15
         LR    4,15
         LA    3,2
         AR    3,2
         LR    0,5
         ST    0,P00093+0
         LA    0,6
         ST    0,P00093+4
         LR    0,4
         ST    0,P00093+8
         LR    0,3
         ST    0,P00093+12
         LA    1,P00093
         L     15,C00095
         BALR  14,15
         ICM   2,8,0(5)
         SRA   2,24
         LR    0,2
         B     L00089
L00088   DS    0H
L00089   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00086   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00093   DS    4F
C00094   DC    V(F77CAT)
C00095   DC    V(F77STRCP)
* SUB1
SUB1     CSECT
         USING *,15
         B     L00103
         DC    AL1(4),CL7'SUB1'
L00103   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00104
L00105   DC    A(S00096)
L00104   L     15,L00105
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00096,13
         ST    1,S00096+72
L00098   DS    0H
         L     9,0(,1)
         L     2,4(,1)
         L     8,8(,1)
         L     5,12(,1)
         L     4,16(,1)
         LR    0,2
         ST    0,P00106+0
         LR    0,4
         ST    0,P00106+4
         LR    0,9
         ST    0,P00106+8
         LR    0,5
         ST    0,P00106+12
         LA    1,P00106
         L     15,C00107
         BALR  14,15
         LR    7,15
         LR    3,4
         AR    3,5
         LR    0,9
         ST    0,P00106+0
         LR    0,5
         ST    0,P00106+4
         LR    0,7
         ST    0,P00106+8
         LR    0,3
         ST    0,P00106+12
         LA    1,P00106
         L     15,C00108
         BALR  14,15
         A     2,C00109
         LR    0,8
         ST    0,P00106+0
         LA    0,4
         ST    0,P00106+4
         LR    0,2
         ST    0,P00106+8
         LA    0,2
         ST    0,P00106+12
         LA    1,P00106
         L     15,C00108
         BALR  14,15
         C     5,C00110
         LA    2,1
         BC    7,L00111
         SR    2,2
L00111   DS    0H
         C     4,C00112
         LA    3,1
         BC    7,L00113
         SR    3,3
L00113   DS    0H
         OR    2,3
         LTR   2,2
         BC    8,L00100
L00099   DS    0H
         LA    0,6
         ST    0,P00106+0
         LA    0,0
         ST    0,P00106+4
         LA    1,P00106
         L     15,C00114
         BALR  14,15
         L     0,C00115
         ST    0,P00106+0
         LA    0,7
         ST    0,P00106+4
         LA    1,P00106
         L     15,C00116
         BALR  14,15
         LR    0,5
         ST    0,P00106+0
         LA    1,P00106
         L     15,C00117
         BALR  14,15
         LR    0,4
         ST    0,P00106+0
         LA    1,P00106
         L     15,C00117
         BALR  14,15
         L     15,C00118
         BALR  14,15
L00100   DS    0H
         LA    0,0
         B     L00102
L00101   DS    0H
L00102   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00096   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
P00106   DS    4F
C00107   DC    V(F77CAT)
C00108   DC    V(F77STRCP)
C00109   DC    F'1'
C00110   DC    F'5'
C00112   DC    F'3'
C00114   DC    V(F77WRBEG)
C00115   DC    A(Q00097)
C00116   DC    V(F77WRA)
C00117   DC    V(F77WRI)
C00118   DC    V(F77WREND)
Q00097   DC    C'BAD LEN'
G00052   CSECT
         DS    0D
         DC    X'C1C24040C3C4C5C6C9D1D2D3'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
