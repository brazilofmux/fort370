* main
F77MAIN  CSECT
         USING *,15
         B     L00028
         DC    AL1(7),CL7'F77MAIN'
L00028   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
         B     L00029
L00030   DC    A(S00000)
L00029   L     15,L00030
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00014   DS    0H
L00015   DS    0H
         L     8,C00032
         AH    8,C00033
         L     5,C00035
         AH    5,C00033
         LA    6,8
         LA    7,400
         LA    2,8
         LA    3,1
L00016   DS    0H
         LD    2,0(2,8)
         LD    0,0(2,5)
         STD   2,T00012
         STD   0,T00012+8
         LA    0,6
         ST    0,P00036+0
         L     0,C00037
         ST    0,P00036+4
         LA    1,P00036
         L     15,C00038
         BALR  14,15
         LR    0,3
         ST    0,P00036+0
         LA    1,P00036
         L     15,C00039
         BALR  14,15
         LD    0,T00012
         STD   0,S00000+1128
         LD    0,T00012+8
         STD   0,S00000+1136
         LD    0,S00000+1128
         STD   0,P00036+0
         LD    0,S00000+1136
         STD   0,P00036+8
         LA    1,P00036
         L     15,C00040
         BALR  14,15
         L     15,C00041
         BALR  14,15
         LD    0,T00012
         STD   0,S00000+1128
         LD    0,T00012+8
         STD   0,S00000+1136
         LD    0,S00000+1128
         STD   0,P00036+0
         LD    0,S00000+1136
         STD   0,P00036+8
         LA    0,T00013
         ST    0,P00036+16
         LA    1,P00036
         L     15,C00042
         BALR  14,15
         LD    0,T00013
         STD   0,S00000+1128
         LD    0,T00013+8
         STD   0,S00000+1136
         LA    0,6
         ST    0,P00036+0
         L     0,C00043
         ST    0,P00036+4
         LA    1,P00036
         L     15,C00038
         BALR  14,15
         LR    0,3
         ST    0,P00036+0
         LA    1,P00036
         L     15,C00039
         BALR  14,15
         LD    0,S00000+1128
         STD   0,P00036+0
         LD    0,S00000+1136
         STD   0,P00036+8
         LA    1,P00036
         L     15,C00040
         BALR  14,15
         L     15,C00041
         BALR  14,15
         LD    0,T00012
         STD   0,S00000+1128
         LD    0,T00012+8
         STD   0,S00000+1136
         LD    0,S00000+1128
         STD   0,P00036+0
         LD    0,S00000+1136
         STD   0,P00036+8
         LA    0,T00008
         ST    0,P00036+16
         LA    1,P00036
         L     15,C00044
         BALR  14,15
         LD    0,T00008
         STD   0,S00000+1128
         LD    0,T00008+8
         STD   0,S00000+1136
         LA    0,6
         ST    0,P00036+0
         L     0,C00045
         ST    0,P00036+4
         LA    1,P00036
         L     15,C00038
         BALR  14,15
         LR    0,3
         ST    0,P00036+0
         LA    1,P00036
         L     15,C00039
         BALR  14,15
         LD    0,S00000+1128
         STD   0,P00036+0
         LD    0,S00000+1136
         STD   0,P00036+8
         LA    1,P00036
         L     15,C00040
         BALR  14,15
         L     15,C00041
         BALR  14,15
         LD    0,T00012
         STD   0,S00000+1128
         LD    0,T00012+8
         STD   0,S00000+1136
         LD    0,S00000+1128
         STD   0,P00036+0
         LD    0,S00000+1136
         STD   0,P00036+8
         LA    0,T00009
         ST    0,P00036+16
         LA    1,P00036
         L     15,C00046
         BALR  14,15
         LD    0,T00009
         STD   0,S00000+1128
         LD    0,T00009+8
         STD   0,S00000+1136
         LA    0,6
         ST    0,P00036+0
         L     0,C00047
         ST    0,P00036+4
         LA    1,P00036
         L     15,C00038
         BALR  14,15
         LR    0,3
         ST    0,P00036+0
         LA    1,P00036
         L     15,C00039
         BALR  14,15
         LD    0,S00000+1128
         STD   0,P00036+0
         LD    0,S00000+1136
         STD   0,P00036+8
         LA    1,P00036
         L     15,C00040
         BALR  14,15
         L     15,C00041
         BALR  14,15
         LD    0,T00012
         STD   0,S00000+1128
         LD    0,T00012+8
         STD   0,S00000+1136
         LD    0,S00000+1128
         STD   0,P00036+0
         LD    0,S00000+1136
         STD   0,P00036+8
         LA    0,T00010
         ST    0,P00036+16
         LA    1,P00036
         L     15,C00048
         BALR  14,15
         LD    0,T00010
         STD   0,S00000+1128
         LD    0,T00010+8
         STD   0,S00000+1136
         LA    0,6
         ST    0,P00036+0
         L     0,C00049
         ST    0,P00036+4
         LA    1,P00036
         L     15,C00038
         BALR  14,15
         LR    0,3
         ST    0,P00036+0
         LA    1,P00036
         L     15,C00039
         BALR  14,15
         LD    0,S00000+1128
         STD   0,P00036+0
         LD    0,S00000+1136
         STD   0,P00036+8
         LA    1,P00036
         L     15,C00040
         BALR  14,15
         L     15,C00041
         BALR  14,15
         LD    0,T00012
         STD   0,S00000+1128
         LD    0,T00012+8
         STD   0,S00000+1136
         LD    0,S00000+1128
         STD   0,P00036+0
         LD    0,S00000+1136
         STD   0,P00036+8
         LA    0,T00011
         ST    0,P00036+16
         LA    1,P00036
         L     15,C00050
         BALR  14,15
         LD    0,T00011
         STD   0,S00000+1128
         LD    0,T00011+8
         STD   0,S00000+1136
         LA    0,6
         ST    0,P00036+0
         L     0,C00051
         ST    0,P00036+4
         LA    1,P00036
         L     15,C00038
         BALR  14,15
         LR    0,3
         ST    0,P00036+0
         LA    1,P00036
         L     15,C00039
         BALR  14,15
         LD    0,S00000+1128
         STD   0,P00036+0
         LD    0,S00000+1136
         STD   0,P00036+8
         LA    1,P00036
         L     15,C00040
         BALR  14,15
         L     15,C00041
         BALR  14,15
         LD    0,T00012
         STD   0,S00000+1128
         LD    0,T00012+8
         STD   0,S00000+1136
         LD    0,S00000+1128
         STD   0,P00036+0
         LD    0,S00000+1136
         STD   0,P00036+8
         LA    1,P00036
         L     15,C00052
         BALR  14,15
         STD   0,S00000+1144
         LA    0,6
         ST    0,P00036+0
         L     0,C00053
         ST    0,P00036+4
         LA    1,P00036
         L     15,C00038
         BALR  14,15
         LR    0,3
         ST    0,P00036+0
         LA    1,P00036
         L     15,C00039
         BALR  14,15
         LD    0,S00000+1144
         STD   0,P00036+0
         LA    1,P00036
         L     15,C00054
         BALR  14,15
         L     15,C00041
         BALR  14,15
L00018   DS    0H
         A     3,C00055
         BXLE  2,6,L00016
L00017   DS    0H
L00019   DS    0H
L00020   DS    0H
L00021   DS    0H
L00022   DS    0H
L00023   DS    0H
L00024   DS    0H
L00025   DS    0H
         LA    0,0
         ST    0,P00036+0
         LA    1,P00036
         L     15,C00056
         BALR  14,15
         B     L00027
L00026   DS    0H
L00027   DS    0H
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
T00008   DS    XL16
T00009   DS    XL16
T00010   DS    XL16
T00011   DS    XL16
T00012   DS    XL20
         DS    XL4
T00013   DS    XL864
         DS    3D
P00036   DS    5F
         DS    XL4
C00032   DC    A(G00031)
C00035   DC    A(G00034)
C00037   DC    A(Q00001)
C00038   DC    V(F77WRBEG)
C00039   DC    V(F77WRI)
C00040   DC    V(F77WRZ)
C00041   DC    V(F77WREND)
C00042   DC    V(F77ZSQRT)
C00043   DC    A(Q00002)
C00044   DC    V(F77ZEXP)
C00045   DC    A(Q00003)
C00046   DC    V(F77ZLOG)
C00047   DC    A(Q00004)
C00048   DC    V(F77ZSIN)
C00049   DC    A(Q00005)
C00050   DC    V(F77ZCOS)
C00051   DC    A(Q00006)
C00052   DC    V(F77ZABS)
C00053   DC    A(Q00007)
C00054   DC    V(F77WRD)
C00055   DC    F'1'
C00056   DC    V(EXIT)
C00033   DC    H'-8'
Q00001   DC    C'('' >ARG  '',I3,2(1X,Z16))'
Q00002   DC    C'('' >SQRT '',I3,2(1X,Z16))'
Q00003   DC    C'('' >EXP  '',I3,2(1X,Z16))'
Q00004   DC    C'('' >LOG  '',I3,2(1X,Z16))'
Q00005   DC    C'('' >SIN  '',I3,2(1X,Z16))'
Q00006   DC    C'('' >COS  '',I3,2(1X,Z16))'
Q00007   DC    C'('' >ABS  '',I3,1X,Z16)'
G00031   CSECT
         DS    0D
         DC    X'411109E87C3BD578C124D0FAC06C3E6240503A47CCB7A3C0'
         DC    X'412E84D7FFB46E10C11F00AC42F0CEE841528A8A17A16AE0'
         DC    X'414F2BF1805391A8C14151F375D1C4F4C0C86E6FA77D9800'
         DC    X'4154D90093EE2490C119211457F3D338413FDCBB7109CB30'
         DC    X'414425514973DE48C124615D0E919A16C146793EC1850EB0'
         DC    X'C14F3CCA4F2AF8984110000079C83B5340FFFFF798843B80'
         DC    X'40FFFFF79C84436040F490FDEA8737E840F490EE9DA60A18'
         DC    X'40F490EEA178557840C3CCBED1C815E840C3CCB291EDB9D0'
         DC    X'40C3CCB294FCF2B8405CC3801D258C60405CC37A4F7AD968'
         DC    X'405CC37A50EDEA38C0F890C666257418C0F890B6D937C370'
         DC    X'C0F890B6DD1A0E10C080000000000000C080000000000000'
         DC    X'C080000000000000C130000000000000C130000000000000'
         DC    X'C130000000000000C5186A0000000000C5186A0000000000'
         DC    X'C5186A000000000040C000000000000040C0000000000000'
         DC    X'40C000000000000040C00000000000001F8B61313BBABCE0'
         DC    X'8F336C0955594C4C6A446C3B15F992687BA2471BE01072A8'
         DC    X'3CA7C5AC471B47880000000000000000'
G00034   CSECT
         DS    0D
         DC    X'412B676CA1C81DE8C15C64F9BB67BE48413374BA117A2450'
         DC    X'40B42BA5A15EED004025AE0C4735F3003F9BC426B7F9F800'
         DC    X'C1137F4DBBEF30D4C13E8BE40CA6F0C2C028CB96A0190680'
         DC    X'C12CB39319E6F068C1292FAF6E2909064141BCDED210E310'
         DC    X'C144FC4CC3527D383F78BB23E4AB40004151C704565AE260'
         DC    X'C131E7369FC312D43E41893AAD1992D03E418936938004AC'
         DC    X'3E41893694862B94404BA73B115E4E3C404BA73655BC4BF4'
         DC    X'404BA73656EAEB2840A4EB7D98E8026040A4EB73479D1FF0'
         DC    X'40A4EB734A30D2E840EE9A2BFA747F3040EE9A1D0D1845A8'
         DC    X'40EE9A1D10D2B598403D3F7580877C90403D3F71AB9B6400'
         DC    X'403D3F71AC9063B03944B82FA09B5A54B7119799812DEA11'
         DC    X'2814484BFEEBC2A03944B82FA09B5A54B7119799812DEA11'
         DC    X'2814484BFEEBC2A03944B82FA09B5A54B7119799812DEA11'
         DC    X'2814484BFEEBC2A0421E0000000000004264000000000000'
         DC    X'42AA00000000000045186A00000000001F29D05B91EB38AA'
         DC    X'0E29233AAAADD6A4EA1486DE8697ABEC7B2E5D75ADBB8E7A'
         DC    X'45186A00000000004128000000000000'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
