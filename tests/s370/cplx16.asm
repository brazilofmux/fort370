* main
F77MAIN  CSECT
         USING *,15
         B     L00037
         DC    AL1(7),CL7'F77MAIN'
L00037   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00038
L00039   DC    A(S00000)
L00038   L     15,L00039
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00028   DS    0H
         MVC   T00013(8),C00040
         MVC   T00013+8(8),C00041
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         LA    1,P00044
         L     15,C00045
         BALR  14,15
         LD    2,T00013
         LD    0,T00013+8
         MVC   S00000+88(4),C00046
         LD    6,S00000+88
         MVC   S00000+88(4),C00047
         LD    4,S00000+88
         STD   6,S00000+96
         LDR   6,2
         MDR   6,4
         STD   6,S00000+960
         LD    6,S00000+96
         STD   4,S00000+96
         LDR   4,0
         MDR   4,6
         STD   4,S00000+968
         LD    4,S00000+96
         STD   6,S00000+96
         LD    6,S00000+960
         SD    6,S00000+968
         STD   6,S00000+976
         LD    6,S00000+96
         MDR   2,6
         MDR   0,4
         LDR   4,2
         ADR   4,0
         STD   4,S00000+960
         LD    0,S00000+976
         STD   0,P00048+0
         LD    0,S00000+960
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         LA    1,P00051
         L     15,C00045
         BALR  14,15
         MVC   S00000+88(4),C00046
         LD    0,S00000+88
         MVC   S00000+88(4),C00047
         LD    2,S00000+88
         LD    6,C00052
         MDR   6,2
         LD    4,C00053
         MDR   4,0
         STD   2,S00000+96
         LDR   2,6
         SDR   2,4
         STD   2,S00000+960
         LD    2,S00000+96
         MD    2,C00053
         MD    0,C00052
         LDR   4,2
         ADR   4,0
         STD   4,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         LA    1,P00054
         L     15,C00045
         BALR  14,15
         LD    0,C00040
         STD   0,P00055+0
         LD    0,C00041
         STD   0,P00055+8
         LD    0,C00056
         STD   0,P00055+16
         LD    0,C00057
         STD   0,P00055+24
         LA    1,P00055
         L     15,C00058
         BALR  14,15
         LD    0,T00023
         STD   0,S00000+960
         LD    0,T00023+8
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         LA    1,P00059
         L     15,C00045
         BALR  14,15
         LD    0,T00013
         STD   0,S00000+960
         LD    0,T00013+8
         STD   0,S00000+968
         LA    0,2
         X     0,C00060
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00061
         STD   0,S00000+976
         LD    0,S00000+960
         STD   0,P00062+0
         LD    0,S00000+968
         STD   0,P00062+8
         LD    0,S00000+976
         STD   0,P00062+16
         LD    0,C00053
         STD   0,P00062+24
         LA    1,P00062
         L     15,C00058
         BALR  14,15
         LD    0,T00009
         STD   0,S00000+960
         LD    0,T00009+8
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         LA    1,P00063
         L     15,C00045
         BALR  14,15
         LD    0,T00013
         STD   0,S00000+960
         LD    0,T00013+8
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00064+0
         LD    0,S00000+968
         STD   0,P00064+8
         LA    1,P00064
         L     15,C00065
         BALR  14,15
         LD    0,T00010
         STD   0,S00000+960
         LD    0,T00010+8
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         LA    1,P00066
         L     15,C00045
         BALR  14,15
         LD    0,T00013
         STD   0,S00000+960
         LD    0,T00013+8
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00067+0
         LD    0,S00000+968
         STD   0,P00067+8
         LA    1,P00067
         L     15,C00065
         BALR  14,15
         LD    0,T00011
         STD   0,S00000+960
         LD    0,T00011+8
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         LA    1,P00068
         L     15,C00045
         BALR  14,15
         LD    0,T00013
         STD   0,S00000+960
         LD    0,T00013+8
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00069+0
         LD    0,S00000+968
         STD   0,P00069+8
         LD    0,C00040
         STD   0,P00069+16
         LD    0,C00070
         STD   0,P00069+24
         LA    1,P00069
         L     15,C00071
         BALR  14,15
         LD    0,T00012
         STD   0,S00000+960
         LD    0,T00012+8
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         LA    1,P00072
         L     15,C00045
         BALR  14,15
         LD    2,T00013
         LD    0,T00013+8
         LCDR  0,0
         LCDR  2,2
         L     15,C00074
         AD    2,16(,15)
         L     15,C00074
         AD    0,24(,15)
         LDR   4,2
         L     15,C00074
         SD    4,32(,15)
         STD   4,S00000+960
         LDR   2,0
         L     15,C00074
         SD    2,40(,15)
         STD   2,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         LA    1,P00075
         L     15,C00045
         BALR  14,15
         LD    0,C00052
         STD   0,P00048+0
         LD    0,C00041
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         LA    1,P00076
         L     15,C00045
         BALR  14,15
         LD    0,T00013
         STD   0,S00000+960
         LD    0,T00013+8
         LDR   2,0
         LCDR  2,2
         STD   2,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     14,C00077
         LD    0,0(,14)
         STD   0,S00000+960
         L     14,C00078
         LD    0,0(,14)
         LDR   2,0
         LCDR  2,2
         STD   2,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LA    1,P00079
         L     15,C00043
         BALR  14,15
         LA    1,P00080
         L     15,C00045
         BALR  14,15
         LD    0,T00013+8
         STD   0,S00000+960
         LD    0,S00000+960
         STD   0,P00081+0
         LA    1,P00081
         L     15,C00082
         BALR  14,15
         LD    0,T00013
         STD   0,S00000+960
         LD    0,S00000+960
         STD   0,P00081+0
         LA    1,P00081
         L     15,C00082
         BALR  14,15
         L     14,C00077
         LD    0,0(,14)
         STD   0,S00000+960
         LD    0,S00000+960
         STD   0,P00081+0
         LA    1,P00081
         L     15,C00082
         BALR  14,15
         L     14,C00077
         LD    0,0(,14)
         STD   0,S00000+960
         LD    0,S00000+960
         STD   0,P00081+0
         LA    1,P00081
         L     15,C00082
         BALR  14,15
         L     14,C00078
         LD    0,0(,14)
         STD   0,S00000+960
         LD    0,S00000+960
         STD   0,P00081+0
         LA    1,P00081
         L     15,C00082
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LA    1,P00079
         L     15,C00043
         BALR  14,15
         LA    1,P00083
         L     15,C00045
         BALR  14,15
         L     14,C00077
         LD    0,0(,14)
         STD   0,S00000+960
         L     14,C00078
         LD    0,0(,14)
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00084
         BALR  14,15
         STD   0,S00000+976
         LD    0,S00000+976
         STD   0,P00081+0
         LA    1,P00081
         L     15,C00082
         BALR  14,15
         LD    0,T00013
         STD   0,S00000+960
         LD    0,T00013+8
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00084
         BALR  14,15
         STD   0,S00000+976
         LD    0,S00000+976
         STD   0,P00081+0
         LA    1,P00081
         L     15,C00082
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         LA    1,P00085
         L     15,C00045
         BALR  14,15
         LD    0,T00013
         STD   0,S00000+960
         LD    0,T00013+8
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00086+0
         LD    0,S00000+968
         STD   0,P00086+8
         LA    1,P00086
         L     15,C00087
         BALR  14,15
         LD    0,T00026
         STD   0,S00000+960
         LD    0,T00026+8
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     14,C00077
         LD    0,0(,14)
         STD   0,S00000+960
         L     14,C00078
         LD    0,0(,14)
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00088+0
         LD    0,S00000+968
         STD   0,P00088+8
         LA    1,P00088
         L     15,C00087
         BALR  14,15
         LD    0,T00014
         STD   0,S00000+960
         LD    0,T00014+8
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         LA    1,P00089
         L     15,C00045
         BALR  14,15
         LD    0,T00013
         STD   0,S00000+960
         LD    0,T00013+8
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00090+0
         LD    0,S00000+968
         STD   0,P00090+8
         LA    1,P00090
         L     15,C00091
         BALR  14,15
         LD    0,T00015
         STD   0,S00000+960
         LD    0,T00015+8
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     14,C00092
         LD    0,0(,14)
         STD   0,S00000+960
         L     14,C00093
         LD    0,0(,14)
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00094+0
         LD    0,S00000+968
         STD   0,P00094+8
         LA    1,P00094
         L     15,C00091
         BALR  14,15
         LD    0,T00016
         STD   0,S00000+960
         LD    0,T00016+8
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         LA    1,P00095
         L     15,C00045
         BALR  14,15
         LD    0,T00013
         STD   0,S00000+960
         LD    0,T00013+8
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00096+0
         LD    0,S00000+968
         STD   0,P00096+8
         LA    1,P00096
         L     15,C00097
         BALR  14,15
         LD    0,T00017
         STD   0,S00000+960
         LD    0,T00017+8
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     14,C00077
         LD    0,0(,14)
         STD   0,S00000+960
         L     14,C00078
         LD    0,0(,14)
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00098+0
         LD    0,S00000+968
         STD   0,P00098+8
         LA    1,P00098
         L     15,C00097
         BALR  14,15
         LD    0,T00018
         STD   0,S00000+960
         LD    0,T00018+8
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         LA    1,P00099
         L     15,C00045
         BALR  14,15
         LD    0,T00013
         STD   0,S00000+960
         LD    0,T00013+8
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00100+0
         LD    0,S00000+968
         STD   0,P00100+8
         LA    1,P00100
         L     15,C00101
         BALR  14,15
         LD    0,T00019
         STD   0,S00000+960
         LD    0,T00019+8
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     14,C00092
         LD    0,0(,14)
         STD   0,S00000+960
         L     14,C00093
         LD    0,0(,14)
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00102+0
         LD    0,S00000+968
         STD   0,P00102+8
         LA    1,P00102
         L     15,C00101
         BALR  14,15
         LD    0,T00020
         STD   0,S00000+960
         LD    0,T00020+8
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         LA    1,P00103
         L     15,C00045
         BALR  14,15
         LD    0,T00013
         STD   0,S00000+960
         LD    0,T00013+8
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00104+0
         LD    0,S00000+968
         STD   0,P00104+8
         LA    1,P00104
         L     15,C00105
         BALR  14,15
         LD    0,T00021
         STD   0,S00000+960
         LD    0,T00021+8
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     14,C00092
         LD    0,0(,14)
         STD   0,S00000+960
         L     14,C00093
         LD    0,0(,14)
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00106+0
         LD    0,S00000+968
         STD   0,P00106+8
         LA    1,P00106
         L     15,C00105
         BALR  14,15
         LD    0,T00022
         STD   0,S00000+960
         LD    0,T00022+8
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LD    2,T00013
         LD    0,T00013+8
         LDR   4,0
         LER   4,4
         STE   4,S00000+960
         LDR   0,2
         LER   0,0
         STE   0,S00000+968
         MVC   S00000+88(4),S00000+960
         LD    0,S00000+88
         STD   0,S00000+976
         MVC   S00000+88(4),S00000+968
         LD    0,S00000+88
         STD   0,S00000+984
         LA    1,P00107
         L     15,C00043
         BALR  14,15
         LA    1,P00108
         L     15,C00045
         BALR  14,15
         L     14,C00077
         LD    2,0(,14)
         L     14,C00078
         LD    0,0(,14)
         LDR   4,0
         LER   4,4
         STE   4,S00000+992
         LDR   0,2
         LER   0,0
         STE   0,S00000+1000
         LE    0,S00000+1000
         STE   0,P00081+0
         LE    0,S00000+992
         STE   0,P00081+4
         LA    1,P00081
         L     15,C00109
         BALR  14,15
         LE    0,S00000+968
         STE   0,P00081+0
         LE    0,S00000+960
         STE   0,P00081+4
         LA    1,P00081
         L     15,C00109
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         LA    1,P00110
         L     15,C00045
         BALR  14,15
         LD    0,S00000+984
         STD   0,P00048+0
         LD    0,S00000+976
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LD    0,C00111
         LCDR  0,0
         L     14,C00114
         MVC   0(8,14),C00112
         L     14,C00115
         STD   0,0(,14)
         LA    1,P00079
         L     15,C00043
         BALR  14,15
         LA    1,P00116
         L     15,C00045
         BALR  14,15
         L     14,C00114
         LD    0,0(,14)
         STD   0,S00000+960
         LD    0,S00000+960
         STD   0,P00081+0
         LA    1,P00081
         L     15,C00082
         BALR  14,15
         L     14,C00115
         LD    0,0(,14)
         STD   0,S00000+960
         LD    0,S00000+960
         STD   0,P00081+0
         LA    1,P00081
         L     15,C00082
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LD    0,T00013
         STD   0,S00000+960
         LD    0,T00013+8
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00117+0
         LD    0,S00000+968
         STD   0,P00117+8
         LA    1,P00117
         L     15,C00065
         BALR  14,15
         LD    2,T00024
         LD    0,T00024+8
         LDR   4,2
         SD    4,C00053
         STD   4,S00000+960
         LDR   2,0
         SD    2,C00040
         STD   2,S00000+968
L00029   DS    0H
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         LA    1,P00118
         L     15,C00045
         BALR  14,15
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LD    6,T00013
         LD    2,T00013+8
         LDR   4,2
         LCDR  4,4
         LDR   0,6
         MDR   0,6
         STD   6,S00000+96
         LDR   6,2
         MDR   6,4
         STD   6,S00000+960
         LD    6,S00000+96
         SD    0,S00000+960
         MDR   4,6
         MDR   2,6
         ADR   4,2
         AD    0,C00053
         AD    4,C00052
         L     14,C00119
         STD   0,0(,14)
         L     14,C00120
         STD   4,0(,14)
L00030   DS    0H
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         LA    1,P00121
         L     15,C00045
         BALR  14,15
         L     14,C00119
         LD    0,0(,14)
         STD   0,S00000+960
         L     14,C00120
         LD    0,0(,14)
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         LA    1,P00122
         L     15,C00045
         BALR  14,15
         LD    6,T00013
         LD    2,T00013+8
         LDR   4,6
         MDR   4,6
         LDR   0,2
         MDR   0,2
         SDR   4,0
         LDR   0,6
         MDR   0,2
         MDR   2,6
         ADR   0,2
         LD    2,C00040
         ADR   2,4
         STD   2,S00000+960
         LD    2,C00070
         ADR   2,0
         STD   2,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LD    2,T00013
         LD    0,T00013+8
         STD   2,T00025
         STD   0,T00025+8
         LA    1,P00123
         L     15,C00043
         BALR  14,15
         LA    1,P00124
         L     15,C00045
         BALR  14,15
         LD    2,T00025
         LD    0,T00025+8
         CD    2,T00013
         LA    2,1
         BC    8,L00125
         SR    2,2
L00125   DS    0H
         CD    0,T00013+8
         LA    3,1
         BC    8,L00126
         SR    3,3
L00126   DS    0H
         NR    2,3
         LR    0,2
         ST    0,P00127+0
         LA    1,P00127
         L     15,C00128
         BALR  14,15
         LD    2,T00025
         LD    0,T00025+8
         CD    2,T00013
         LA    2,1
         BC    8,L00129
         SR    2,2
L00129   DS    0H
         CD    0,T00013+8
         LA    3,1
         BC    8,L00130
         SR    3,3
L00130   DS    0H
         NR    2,3
         LTR   2,2
         LA    3,1
         BC    8,L00131
         SR    3,3
L00131   DS    0H
         LR    0,3
         ST    0,P00127+0
         LA    1,P00127
         L     15,C00128
         BALR  14,15
         LD    2,T00013
         LD    0,T00013+8
         L     15,C00074
         CD    2,0(,15)
         LA    2,1
         BC    8,L00132
         SR    2,2
L00132   DS    0H
         L     15,C00074
         CD    0,8(,15)
         LA    3,1
         BC    8,L00133
         SR    3,3
L00133   DS    0H
         NR    2,3
         LR    0,2
         ST    0,P00127+0
         LA    1,P00127
         L     15,C00128
         BALR  14,15
         LD    2,T00013
         LD    0,T00013+8
         L     15,C00074
         CD    2,16(,15)
         LA    2,1
         BC    8,L00134
         SR    2,2
L00134   DS    0H
         L     15,C00074
         CD    0,24(,15)
         LA    3,1
         BC    8,L00135
         SR    3,3
L00135   DS    0H
         NR    2,3
         LR    0,2
         ST    0,P00127+0
         LA    1,P00127
         L     15,C00128
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LA    1,P00136
         L     15,C00137
         BALR  14,15
         LA    1,P00138
         L     15,C00139
         BALR  14,15
         LA    1,P00140
         L     15,C00141
         BALR  14,15
         L     15,C00142
         BALR  14,15
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         LA    1,P00143
         L     15,C00045
         BALR  14,15
         L     14,C00114
         LD    0,0(,14)
         STD   0,S00000+960
         L     14,C00115
         LD    0,0(,14)
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LA    1,P00144
         L     15,C00137
         BALR  14,15
         LA    1,P00072
         L     15,C00145
         BALR  14,15
         LA    1,P00146
         L     15,C00139
         BALR  14,15
         LA    1,P00140
         L     15,C00141
         BALR  14,15
         L     15,C00142
         BALR  14,15
         LA    1,P00042
         L     15,C00043
         BALR  14,15
         LA    1,P00147
         L     15,C00045
         BALR  14,15
         L     14,C00114
         LD    0,0(,14)
         STD   0,S00000+960
         L     14,C00115
         LD    0,0(,14)
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LA    1,P00148
         L     15,C00043
         BALR  14,15
         LA    1,P00149
         L     15,C00150
         BALR  14,15
         LD    0,T00013
         STD   0,S00000+960
         LD    0,T00013+8
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     14,C00092
         LD    0,0(,14)
         STD   0,S00000+960
         L     14,C00093
         LD    0,0(,14)
         STD   0,S00000+968
         LD    0,S00000+960
         STD   0,P00048+0
         LD    0,S00000+968
         STD   0,P00048+8
         LA    1,P00048
         L     15,C00049
         BALR  14,15
         L     15,C00050
         BALR  14,15
         LD    0,C00041
         MD    0,C00151
         STD   0,S00000+960
L00031   DS    0H
         LA    1,P00079
         L     15,C00043
         BALR  14,15
         LA    1,P00152
         L     15,C00045
         BALR  14,15
         LD    0,S00000+960
         STD   0,P00081+0
         LA    1,P00081
         L     15,C00082
         BALR  14,15
         L     15,C00050
         BALR  14,15
L00032   DS    0H
L00033   DS    0H
L00034   DS    0H
L00035   DS    0H
L00036   DS    0H
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
T00009   DS    XL16
T00010   DS    XL16
T00011   DS    XL16
T00012   DS    XL16
T00013   DS    XL20
         DS    XL4
T00014   DS    XL20
         DS    XL4
T00015   DS    XL20
         DS    XL4
T00016   DS    XL20
         DS    XL4
T00017   DS    XL20
         DS    XL4
T00018   DS    XL20
         DS    XL4
T00019   DS    XL20
         DS    XL4
T00020   DS    XL20
         DS    XL4
T00021   DS    XL20
         DS    XL4
T00022   DS    XL20
         DS    XL4
T00023   DS    XL32
T00024   DS    XL44
         DS    XL4
T00025   DS    XL48
T00026   DS    XL60
         DS    XL4
T00027   DS    XL284
         DS    XL4
         DS    6D
P00042   DC    F'6'
         DC    A(Q00001)
P00044   DC    F'1'
         DS    F
P00048   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
P00051   DC    F'2'
P00054   DC    F'3'
P00055   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00023)
P00059   DC    F'4'
P00062   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00009)
P00063   DC    F'5'
P00064   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    F'3'
         DC    A(T00010)
P00066   DC    F'6'
         DS    F
P00067   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    F'-2'
         DC    A(T00011)
P00068   DC    F'7'
         DS    F
P00069   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00012)
P00072   DC    F'8'
P00075   DC    F'9'
P00076   DC    F'10'
P00079   DC    F'6'
         DC    A(Q00002)
P00080   DC    F'11'
         DS    F
P00081   DC    A(0)
         DC    A(0)
P00083   DC    F'12'
P00085   DC    F'13'
P00086   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00026)
         DS    F
P00088   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00014)
P00089   DC    F'14'
P00090   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00015)
         DS    F
P00094   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00016)
P00095   DC    F'15'
P00096   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00017)
         DS    F
P00098   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00018)
P00099   DC    F'16'
P00100   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00019)
         DS    F
P00102   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00020)
P00103   DC    F'17'
P00104   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00021)
         DS    F
P00106   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00022)
P00107   DC    F'6'
         DC    A(Q00003)
P00108   DC    F'18'
P00110   DC    F'19'
P00116   DC    F'20'
P00117   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    F'3'
         DC    A(T00024)
P00118   DC    F'21'
P00121   DC    F'22'
P00122   DC    F'23'
P00123   DC    F'6'
         DC    A(Q00004)
P00124   DC    F'24'
P00127   DC    A(0)
P00136   DC    A(T00027)
         DC    F'20'
         DC    A(Q00005)
         DC    F'16'
P00138   DC    A(T00027)
         DC    F'20'
         DC    F'1'
         DC    F'0'
         DC    F'0'
P00140   DC    A(G00113)
P00143   DC    F'25'
P00144   DC    A(T00027)
         DC    F'20'
         DC    A(Q00006)
         DC    F'18'
P00146   DC    A(T00027)
         DC    F'20'
         DC    F'1'
         DC    A(Q00007)
         DC    F'0'
P00147   DC    F'26'
P00148   DC    F'6'
         DC    F'0'
P00149   DC    A(Q00008)
         DC    F'1'
P00152   DC    F'27'
         DS    XL4
C00040   DC    X'4110000000000000'
C00041   DC    X'4120000000000000'
C00052   DC    X'4080000000000000'
C00053   DC    X'0000000000000000'
C00056   DC    X'4130000000000000'
C00057   DC    X'4140000000000000'
C00061   DC    X'4E00000080000000'
C00070   DC    X'C120000000000000'
C00111   DC    X'4124000000000000'
C00112   DC    X'4118000000000000'
C00151   DC    X'4114000000000000'
C00043   DC    V(F77WRBEG)
C00045   DC    V(F77WRI)
C00046   DC    X'41400000'
C00047   DC    X'41300000'
C00049   DC    V(F77WRZ)
C00050   DC    V(F77WREND)
C00058   DC    V(F77ZDIV)
C00060   DC    F'-2147483648'
C00065   DC    V(F77ZPOWI)
C00071   DC    V(F77ZPOWC)
C00074   DC    A(G00073)
C00077   DC    A(G00073+16)
C00078   DC    A(G00073+24)
C00082   DC    V(F77WRD)
C00084   DC    V(F77ZABS)
C00087   DC    V(F77ZSQRT)
C00091   DC    V(F77ZEXP)
C00092   DC    A(G00073+32)
C00093   DC    A(G00073+40)
C00097   DC    V(F77ZLOG)
C00101   DC    V(F77ZSIN)
C00105   DC    V(F77ZCOS)
C00109   DC    V(F77WRC)
C00114   DC    A(G00113)
C00115   DC    A(G00113+8)
C00119   DC    A(ZC)
C00120   DC    A(ZC+8)
C00128   DC    V(F77WRL)
C00137   DC    V(F77STRCP)
C00139   DC    V(F77RDBI)
C00141   DC    V(F77RDZ)
C00142   DC    V(F77RDEND)
C00145   DC    V(F77FMTLM)
C00150   DC    V(F77WRA)
Q00001   DC    C'(1X,''>'',I3,4D24.16)'
Q00002   DC    C'(1X,''>'',I3,5D24.16)'
Q00003   DC    C'(1X,''>'',I3,4E15.7)'
Q00004   DC    C'(1X,''>'',I3,4L2)'
Q00005   DC    C'(1.5D0, -2.25D0)'
Q00006   DC    C'   0.125D0  -8.5D0'
Q00007   DC    C'(2D10.0)'
Q00008   DC    C'>'
* ZF
ZF       CSECT
         USING *,15
         B     L00157
         DC    AL1(2),CL7'ZF'
L00157   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00158
L00159   DC    A(S00153)
L00158   L     15,L00159
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00153,13
         ST    1,S00153+72
L00155   DS    0H
         L     3,0(,1)
         L     2,4(,1)
         LA    2,0(,2)
         LD    0,0(,3)
         STD   0,S00153+216
         LD    0,8(,3)
         STD   0,S00153+224
         L     3,0(,2)
         LD    0,S00153+216
         STD   0,P00160+0
         LD    0,S00153+224
         STD   0,P00160+8
         LR    0,3
         ST    0,P00160+16
         LA    1,P00160
         L     15,C00161
         BALR  14,15
         LD    2,T00154
         LD    0,T00154+8
         SD    2,C00162
         SD    0,C00163
         LDR   4,0
         LDR   0,2
         LDR   2,4
L00156   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00153   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00154   DS    XL36
         DS    XL4
         DS    2D
P00160   DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(0)
         DC    A(T00154)
C00162   DC    X'0000000000000000'
C00163   DC    X'4110000000000000'
C00161   DC    V(F77ZPOWI)
* ZSUB
ZSUB     CSECT
         USING *,15
         B     L00167
         DC    AL1(4),CL7'ZSUB'
L00167   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00168
L00169   DC    A(S00164)
L00168   L     15,L00169
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00164,13
         ST    1,S00164+72
L00165   DS    0H
         L     3,0(,1)
         L     2,4(,1)
         LA    2,0(,2)
         LD    6,0(,3)
         LD    2,8(,3)
         LDR   4,2
         LCDR  4,4
         LDR   0,6
         MDR   0,6
         STD   6,S00164+96
         LDR   6,2
         MDR   6,4
         STD   6,S00164+176
         LD    6,S00164+96
         SD    0,S00164+176
         MDR   4,6
         MDR   2,6
         ADR   4,2
         AD    0,C00170
         AD    4,C00171
         STD   0,0(,2)
         STD   4,8(,2)
         LA    0,0
L00166   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00164   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
         DS    1D
C00170   DC    X'0000000000000000'
C00171   DC    X'4080000000000000'
* RF
RF       CSECT
         USING *,15
         B     L00175
         DC    AL1(2),CL7'RF'
L00175   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00176
L00177   DC    A(S00172)
L00176   L     15,L00177
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00172,13
         ST    1,S00172+72
L00173   DS    0H
         L     2,0(,1)
         LA    2,0(,2)
         LD    0,C00178
         MD    0,0(,2)
L00174   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
S00172   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
C00178   DC    X'4114000000000000'
ZC       CSECT
         DS    0D
         DS    XL24
G00113   CSECT
         DS    0D
         DS    XL16
G00073   CSECT
         DS    0D
         DC    X'411000000000000041200000000000004130000000000000'
         DC    X'C14000000000000040800000000000004040000000000000'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
