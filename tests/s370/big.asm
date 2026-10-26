* main
F77MAIN  CSECT
         USING *,15
         B     L00637
         DC    AL1(7),CL7'F77MAIN'
L00637   STM   14,12,12(13)
         BALR  12,0
         USING *,12
         DROP  15
L00638   DS    0H
         LA    11,2048(,12)
         LA    11,2048(,11)
         USING L00638+4096,11
         B     L00639
L00640   DC    A(S00000)
L00639   L     15,L00640
         ST    13,4(,15)
         ST    15,8(,13)
         MVC   76(4,15),76(13)
         LR    13,15
         USING S00000,13
         ST    1,S00000+72
L00004   DS    0H
L00005   DS    0H
         LD    2,C00641
         LA    4,8
         LA    5,800
         LA    2,8
         LA    3,1
L00006   DS    0H
L00008   DS    0H
         LR    0,3
         X     0,C00642
         ST    0,S00000+84
         LD    0,S00000+80
         SD    0,C00643
         MDR   0,2
         STD   0,T00003-8(2)
         A     3,C00644
         BXLE  2,4,L00006
L00007   DS    0H
         LA    3,0
         LD    0,C00645
L00009   DS    0H
         A     3,C00644
         LD    2,C00646
         CD    2,T00003+56
         BC    11,L00011
L00010   DS    0H
         LD    2,C00647
         MD    2,T00003+56
         ADR   0,2
L00011   DS    0H
         LD    2,C00648
         CD    2,T00003+112
         BC    11,L00013
L00012   DS    0H
         LD    2,C00649
         MD    2,T00003+112
         ADR   0,2
L00013   DS    0H
         LD    2,C00650
         CD    2,T00003+168
         BC    11,L00015
L00014   DS    0H
         LD    2,C00651
         MD    2,T00003+168
         ADR   0,2
L00015   DS    0H
         LD    2,C00652
         CD    2,T00003+224
         BC    11,L00017
L00016   DS    0H
         LD    2,C00653
         MD    2,T00003+224
         ADR   0,2
L00017   DS    0H
         LD    2,C00654
         CD    2,T00003+280
         BC    11,L00019
L00018   DS    0H
         LD    2,C00655
         MD    2,T00003+280
         ADR   0,2
L00019   DS    0H
         LD    2,C00656
         CD    2,T00003+336
         BC    11,L00021
L00020   DS    0H
         LD    2,C00657
         MD    2,T00003+336
         ADR   0,2
L00021   DS    0H
         LD    2,C00658
         CD    2,T00003+392
         BC    11,L00023
L00022   DS    0H
         LD    2,C00659
         MD    2,T00003+392
         ADR   0,2
L00023   DS    0H
         LD    2,C00660
         CD    2,T00003+448
         BC    11,L00025
L00024   DS    0H
         LD    2,C00647
         MD    2,T00003+448
         ADR   0,2
L00025   DS    0H
         LD    2,C00661
         CD    2,T00003+504
         BC    11,L00027
L00026   DS    0H
         LD    2,C00649
         MD    2,T00003+504
         ADR   0,2
L00027   DS    0H
         LD    2,C00662
         CD    2,T00003+560
         BC    11,L00029
L00028   DS    0H
         LD    2,C00651
         MD    2,T00003+560
         ADR   0,2
L00029   DS    0H
         LD    2,C00663
         CD    2,T00003+616
         BC    11,L00031
L00030   DS    0H
         LD    2,C00653
         MD    2,T00003+616
         ADR   0,2
L00031   DS    0H
         LD    2,C00664
         CD    2,T00003+672
         BC    11,L00033
L00032   DS    0H
         LD    2,C00655
         MD    2,T00003+672
         ADR   0,2
L00033   DS    0H
         LD    2,C00665
         CD    2,T00003+728
         BC    11,L00035
L00034   DS    0H
         LD    2,C00657
         MD    2,T00003+728
         ADR   0,2
L00035   DS    0H
         LD    2,C00646
         CD    2,T00003+784
         BC    11,L00037
L00036   DS    0H
         LD    2,C00659
         MD    2,T00003+784
         ADR   0,2
L00037   DS    0H
         LD    2,C00648
         CD    2,T00003+40
         BC    11,L00039
L00038   DS    0H
         LD    2,C00647
         MD    2,T00003+40
         ADR   0,2
L00039   DS    0H
         LD    2,C00650
         CD    2,T00003+96
         BC    11,L00041
L00040   DS    0H
         LD    2,C00649
         MD    2,T00003+96
         ADR   0,2
L00041   DS    0H
         LD    2,C00652
         CD    2,T00003+152
         BC    11,L00043
L00042   DS    0H
         LD    2,C00651
         MD    2,T00003+152
         ADR   0,2
L00043   DS    0H
         LD    2,C00654
         CD    2,T00003+208
         BC    11,L00045
L00044   DS    0H
         LD    2,C00653
         MD    2,T00003+208
         ADR   0,2
L00045   DS    0H
         LD    2,C00656
         CD    2,T00003+264
         BC    11,L00047
L00046   DS    0H
         LD    2,C00655
         MD    2,T00003+264
         ADR   0,2
L00047   DS    0H
         LD    2,C00658
         CD    2,T00003+320
         BC    11,L00049
L00048   DS    0H
         LD    2,C00657
         MD    2,T00003+320
         ADR   0,2
L00049   DS    0H
         LD    2,C00660
         CD    2,T00003+376
         BC    11,L00051
L00050   DS    0H
         LD    2,C00659
         MD    2,T00003+376
         ADR   0,2
L00051   DS    0H
         LD    2,C00661
         CD    2,T00003+432
         BC    11,L00053
L00052   DS    0H
         LD    2,C00647
         MD    2,T00003+432
         ADR   0,2
L00053   DS    0H
         LD    2,C00662
         CD    2,T00003+488
         BC    11,L00055
L00054   DS    0H
         LD    2,C00649
         MD    2,T00003+488
         ADR   0,2
L00055   DS    0H
         LD    2,C00663
         CD    2,T00003+544
         BC    11,L00057
L00056   DS    0H
         LD    2,C00651
         MD    2,T00003+544
         ADR   0,2
L00057   DS    0H
         LD    2,C00664
         CD    2,T00003+600
         BC    11,L00059
L00058   DS    0H
         LD    2,C00653
         MD    2,T00003+600
         ADR   0,2
L00059   DS    0H
         LD    2,C00665
         CD    2,T00003+656
         BC    11,L00061
L00060   DS    0H
         LD    2,C00655
         MD    2,T00003+656
         ADR   0,2
L00061   DS    0H
         LD    2,C00646
         CD    2,T00003+712
         BC    11,L00063
L00062   DS    0H
         LD    2,C00657
         MD    2,T00003+712
         ADR   0,2
L00063   DS    0H
         LD    2,C00648
         CD    2,T00003+768
         BC    11,L00065
L00064   DS    0H
         LD    2,C00659
         MD    2,T00003+768
         ADR   0,2
L00065   DS    0H
         LD    2,C00650
         CD    2,T00003+24
         BC    11,L00067
L00066   DS    0H
         LD    2,C00647
         MD    2,T00003+24
         ADR   0,2
L00067   DS    0H
         LD    2,C00652
         CD    2,T00003+80
         BC    11,L00069
L00068   DS    0H
         LD    2,C00649
         MD    2,T00003+80
         ADR   0,2
L00069   DS    0H
         LD    2,C00654
         CD    2,T00003+136
         BC    11,L00071
L00070   DS    0H
         LD    2,C00651
         MD    2,T00003+136
         ADR   0,2
L00071   DS    0H
         LD    2,C00656
         CD    2,T00003+192
         BC    11,L00073
L00072   DS    0H
         LD    2,C00653
         MD    2,T00003+192
         ADR   0,2
L00073   DS    0H
         LD    2,C00658
         CD    2,T00003+248
         BC    11,L00075
L00074   DS    0H
         LD    2,C00655
         MD    2,T00003+248
         ADR   0,2
L00075   DS    0H
         LD    2,C00660
         CD    2,T00003+304
         BC    11,L00077
L00076   DS    0H
         LD    2,C00657
         MD    2,T00003+304
         ADR   0,2
L00077   DS    0H
         LD    2,C00661
         CD    2,T00003+360
         BC    11,L00079
L00078   DS    0H
         LD    2,C00659
         MD    2,T00003+360
         ADR   0,2
L00079   DS    0H
         LD    2,C00662
         CD    2,T00003+416
         BC    11,L00081
L00080   DS    0H
         LD    2,C00647
         MD    2,T00003+416
         ADR   0,2
L00081   DS    0H
         LD    2,C00663
         CD    2,T00003+472
         BC    11,L00083
L00082   DS    0H
         LD    2,C00649
         MD    2,T00003+472
         ADR   0,2
L00083   DS    0H
         LD    2,C00664
         CD    2,T00003+528
         BC    11,L00085
L00084   DS    0H
         LD    2,C00651
         MD    2,T00003+528
         ADR   0,2
L00085   DS    0H
         LD    2,C00665
         CD    2,T00003+584
         BC    11,L00087
L00086   DS    0H
         LD    2,C00653
         MD    2,T00003+584
         ADR   0,2
L00087   DS    0H
         LD    2,C00646
         CD    2,T00003+640
         BC    11,L00089
L00088   DS    0H
         LD    2,C00655
         MD    2,T00003+640
         ADR   0,2
L00089   DS    0H
         LD    2,C00648
         CD    2,T00003+696
         BC    11,L00091
L00090   DS    0H
         LD    2,C00657
         MD    2,T00003+696
         ADR   0,2
L00091   DS    0H
         LD    2,C00650
         CD    2,T00003+752
         BC    11,L00093
L00092   DS    0H
         LD    2,C00659
         MD    2,T00003+752
         ADR   0,2
L00093   DS    0H
         LD    2,C00652
         CD    2,T00003+8
         BC    11,L00095
L00094   DS    0H
         LD    2,C00647
         MD    2,T00003+8
         ADR   0,2
L00095   DS    0H
         LD    2,C00654
         CD    2,T00003+64
         BC    11,L00097
L00096   DS    0H
         LD    2,C00649
         MD    2,T00003+64
         ADR   0,2
L00097   DS    0H
         LD    2,C00656
         CD    2,T00003+120
         BC    11,L00099
L00098   DS    0H
         LD    2,C00651
         MD    2,T00003+120
         ADR   0,2
L00099   DS    0H
         LD    2,C00658
         CD    2,T00003+176
         BC    11,L00101
L00100   DS    0H
         LD    2,C00653
         MD    2,T00003+176
         ADR   0,2
L00101   DS    0H
         LD    2,C00660
         CD    2,T00003+232
         BC    11,L00103
L00102   DS    0H
         LD    2,C00655
         MD    2,T00003+232
         ADR   0,2
L00103   DS    0H
         LD    2,C00661
         CD    2,T00003+288
         BC    11,L00105
L00104   DS    0H
         LD    2,C00657
         MD    2,T00003+288
         ADR   0,2
L00105   DS    0H
         LD    2,C00662
         CD    2,T00003+344
         BC    11,L00107
L00106   DS    0H
         LD    2,C00659
         MD    2,T00003+344
         ADR   0,2
L00107   DS    0H
         LD    2,C00663
         CD    2,T00003+400
         BC    11,L00109
L00108   DS    0H
         LD    2,C00647
         MD    2,T00003+400
         ADR   0,2
L00109   DS    0H
         LD    2,C00645
         CDR   0,2
         BC    4,L00110
L00111   DS    0H
         LD    2,C00664
         CD    2,T00003+456
         BC    11,L00114
L00113   DS    0H
         LD    2,C00649
         MD    2,T00003+456
         ADR   0,2
L00114   DS    0H
         LD    2,C00665
         CD    2,T00003+512
         BC    11,L00116
L00115   DS    0H
         LD    2,C00651
         MD    2,T00003+512
         ADR   0,2
L00116   DS    0H
         LD    2,C00646
         CD    2,T00003+568
         BC    11,L00118
L00117   DS    0H
         LD    2,C00653
         MD    2,T00003+568
         ADR   0,2
L00118   DS    0H
         LD    2,C00648
         CD    2,T00003+624
         BC    11,L00120
L00119   DS    0H
         LD    2,C00655
         MD    2,T00003+624
         ADR   0,2
L00120   DS    0H
         LD    2,C00650
         CD    2,T00003+680
         BC    11,L00122
L00121   DS    0H
         LD    2,C00657
         MD    2,T00003+680
         ADR   0,2
L00122   DS    0H
         LD    2,C00652
         CD    2,T00003+736
         BC    11,L00124
L00123   DS    0H
         LD    2,C00659
         MD    2,T00003+736
         ADR   0,2
L00124   DS    0H
         LD    2,C00654
         CD    2,T00003+792
         BC    11,L00126
L00125   DS    0H
         LD    2,C00647
         MD    2,T00003+792
         ADR   0,2
L00126   DS    0H
         LD    2,C00656
         CD    2,T00003+48
         BC    11,L00128
L00127   DS    0H
         LD    2,C00649
         MD    2,T00003+48
         ADR   0,2
L00128   DS    0H
         LD    2,C00658
         CD    2,T00003+104
         BC    11,L00130
L00129   DS    0H
         LD    2,C00651
         MD    2,T00003+104
         ADR   0,2
L00130   DS    0H
         LD    2,C00660
         CD    2,T00003+160
         BC    11,L00132
L00131   DS    0H
         LD    2,C00653
         MD    2,T00003+160
         ADR   0,2
L00132   DS    0H
         LD    2,C00661
         CD    2,T00003+216
         BC    11,L00134
L00133   DS    0H
         LD    2,C00655
         MD    2,T00003+216
         ADR   0,2
L00134   DS    0H
         LD    2,C00662
         CD    2,T00003+272
         BC    11,L00136
L00135   DS    0H
         LD    2,C00657
         MD    2,T00003+272
         ADR   0,2
L00136   DS    0H
         LD    2,C00663
         CD    2,T00003+328
         BC    11,L00138
L00137   DS    0H
         LD    2,C00659
         MD    2,T00003+328
         ADR   0,2
L00138   DS    0H
         LD    2,C00664
         CD    2,T00003+384
         BC    11,L00140
L00139   DS    0H
         LD    2,C00647
         MD    2,T00003+384
         ADR   0,2
L00140   DS    0H
         LD    2,C00665
         CD    2,T00003+440
         BC    11,L00142
L00141   DS    0H
         LD    2,C00649
         MD    2,T00003+440
         ADR   0,2
L00142   DS    0H
         LD    2,C00646
         CD    2,T00003+496
         BC    11,L00144
L00143   DS    0H
         LD    2,C00651
         MD    2,T00003+496
         ADR   0,2
L00144   DS    0H
         LD    2,C00648
         CD    2,T00003+552
         BC    11,L00146
L00145   DS    0H
         LD    2,C00653
         MD    2,T00003+552
         ADR   0,2
L00146   DS    0H
         LD    2,C00650
         CD    2,T00003+608
         BC    11,L00148
L00147   DS    0H
         LD    2,C00655
         MD    2,T00003+608
         ADR   0,2
L00148   DS    0H
         LD    2,C00652
         CD    2,T00003+664
         BC    11,L00150
L00149   DS    0H
         LD    2,C00657
         MD    2,T00003+664
         ADR   0,2
L00150   DS    0H
         LD    2,C00654
         CD    2,T00003+720
         BC    11,L00152
L00151   DS    0H
         LD    2,C00659
         MD    2,T00003+720
         ADR   0,2
L00152   DS    0H
         LD    2,C00656
         CD    2,T00003+776
         BC    11,L00154
L00153   DS    0H
         LD    2,C00647
         MD    2,T00003+776
         ADR   0,2
L00154   DS    0H
         LD    2,C00658
         CD    2,T00003+32
         BC    11,L00156
L00155   DS    0H
         LD    2,C00649
         MD    2,T00003+32
         ADR   0,2
L00156   DS    0H
         LD    2,C00660
         CD    2,T00003+88
         BC    11,L00158
L00157   DS    0H
         LD    2,C00651
         MD    2,T00003+88
         ADR   0,2
L00158   DS    0H
         LD    2,C00661
         CD    2,T00003+144
         BC    11,L00160
L00159   DS    0H
         LD    2,C00653
         MD    2,T00003+144
         ADR   0,2
L00160   DS    0H
         LD    2,C00662
         CD    2,T00003+200
         BC    11,L00162
L00161   DS    0H
         LD    2,C00655
         MD    2,T00003+200
         ADR   0,2
L00162   DS    0H
         LD    2,C00663
         CD    2,T00003+256
         BC    11,L00164
L00163   DS    0H
         LD    2,C00657
         MD    2,T00003+256
         ADR   0,2
L00164   DS    0H
         LD    2,C00664
         CD    2,T00003+312
         BC    11,L00166
L00165   DS    0H
         LD    2,C00659
         MD    2,T00003+312
         ADR   0,2
L00166   DS    0H
         LD    2,C00665
         CD    2,T00003+368
         BC    11,L00168
L00167   DS    0H
         LD    2,C00647
         MD    2,T00003+368
         ADR   0,2
L00168   DS    0H
         LD    2,C00646
         CD    2,T00003+424
         BC    11,L00170
L00169   DS    0H
         LD    2,C00649
         MD    2,T00003+424
         ADR   0,2
L00170   DS    0H
         LD    2,C00648
         CD    2,T00003+480
         BC    11,L00172
L00171   DS    0H
         LD    2,C00651
         MD    2,T00003+480
         ADR   0,2
L00172   DS    0H
         LD    2,C00650
         CD    2,T00003+536
         BC    11,L00174
L00173   DS    0H
         LD    2,C00653
         MD    2,T00003+536
         ADR   0,2
L00174   DS    0H
         LD    2,C00652
         CD    2,T00003+592
         BC    11,L00176
L00175   DS    0H
         LD    2,C00655
         MD    2,T00003+592
         ADR   0,2
L00176   DS    0H
         LD    2,C00654
         CD    2,T00003+648
         BC    11,L00178
L00177   DS    0H
         LD    2,C00657
         MD    2,T00003+648
         ADR   0,2
L00178   DS    0H
         LD    2,C00656
         CD    2,T00003+704
         BC    11,L00180
L00179   DS    0H
         LD    2,C00659
         MD    2,T00003+704
         ADR   0,2
L00180   DS    0H
         LD    2,C00658
         CD    2,T00003+760
         BC    11,L00182
L00181   DS    0H
         LD    2,C00647
         MD    2,T00003+760
         ADR   0,2
L00182   DS    0H
         LD    2,C00660
         CD    2,T00003+16
         BC    11,L00184
L00183   DS    0H
         LD    2,C00649
         MD    2,T00003+16
         ADR   0,2
L00184   DS    0H
         LD    2,C00661
         CD    2,T00003+72
         BC    11,L00186
L00185   DS    0H
         LD    2,C00651
         MD    2,T00003+72
         ADR   0,2
L00186   DS    0H
         LD    2,C00662
         CD    2,T00003+128
         BC    11,L00188
L00187   DS    0H
         LD    2,C00653
         MD    2,T00003+128
         ADR   0,2
L00188   DS    0H
         LD    2,C00663
         CD    2,T00003+184
         BC    11,L00190
L00189   DS    0H
         LD    2,C00655
         MD    2,T00003+184
         ADR   0,2
L00190   DS    0H
         LD    2,C00664
         CD    2,T00003+240
         BC    11,L00192
L00191   DS    0H
         LD    2,C00657
         MD    2,T00003+240
         ADR   0,2
L00192   DS    0H
         LD    2,C00665
         CD    2,T00003+296
         BC    11,L00194
L00193   DS    0H
         LD    2,C00659
         MD    2,T00003+296
         ADR   0,2
L00194   DS    0H
         LD    2,C00646
         CD    2,T00003+352
         BC    11,L00196
L00195   DS    0H
         LD    2,C00647
         MD    2,T00003+352
         ADR   0,2
L00196   DS    0H
         LD    2,C00648
         CD    2,T00003+408
         BC    11,L00198
L00197   DS    0H
         LD    2,C00649
         MD    2,T00003+408
         ADR   0,2
L00198   DS    0H
         LD    2,C00650
         CD    2,T00003+464
         BC    11,L00200
L00199   DS    0H
         LD    2,C00651
         MD    2,T00003+464
         ADR   0,2
L00200   DS    0H
         LD    2,C00652
         CD    2,T00003+520
         BC    11,L00202
L00201   DS    0H
         LD    2,C00653
         MD    2,T00003+520
         ADR   0,2
L00202   DS    0H
         LD    2,C00654
         CD    2,T00003+576
         BC    11,L00204
L00203   DS    0H
         LD    2,C00655
         MD    2,T00003+576
         ADR   0,2
L00204   DS    0H
         LD    2,C00656
         CD    2,T00003+632
         BC    11,L00206
L00205   DS    0H
         LD    2,C00657
         MD    2,T00003+632
         ADR   0,2
L00206   DS    0H
         LD    2,C00658
         CD    2,T00003+688
         BC    11,L00208
L00207   DS    0H
         LD    2,C00659
         MD    2,T00003+688
         ADR   0,2
L00208   DS    0H
         LD    2,C00660
         CD    2,T00003+744
         BC    11,L00210
L00209   DS    0H
         LD    2,C00647
         MD    2,T00003+744
         ADR   0,2
L00210   DS    0H
         LD    2,C00661
         CD    2,T00003
         BC    11,L00212
L00211   DS    0H
         LD    2,C00649
         MD    2,T00003
         ADR   0,2
L00212   DS    0H
         LD    2,C00645
         CDR   0,2
         BC    4,L00213
L00214   DS    0H
         LD    2,C00662
         CD    2,T00003+56
         BC    11,L00216
L00215   DS    0H
         LD    2,C00651
         MD    2,T00003+56
         ADR   0,2
L00216   DS    0H
         LD    2,C00663
         CD    2,T00003+112
         BC    11,L00218
L00217   DS    0H
         LD    2,C00653
         MD    2,T00003+112
         ADR   0,2
L00218   DS    0H
         LD    2,C00664
         CD    2,T00003+168
         BC    11,L00220
L00219   DS    0H
         LD    2,C00655
         MD    2,T00003+168
         ADR   0,2
L00220   DS    0H
         LD    2,C00665
         CD    2,T00003+224
         BC    11,L00222
L00221   DS    0H
         LD    2,C00657
         MD    2,T00003+224
         ADR   0,2
L00222   DS    0H
         LD    2,C00646
         CD    2,T00003+280
         BC    11,L00224
L00223   DS    0H
         LD    2,C00659
         MD    2,T00003+280
         ADR   0,2
L00224   DS    0H
         LD    2,C00648
         CD    2,T00003+336
         BC    11,L00226
L00225   DS    0H
         LD    2,C00647
         MD    2,T00003+336
         ADR   0,2
L00226   DS    0H
         LD    2,C00650
         CD    2,T00003+392
         BC    11,L00228
L00227   DS    0H
         LD    2,C00649
         MD    2,T00003+392
         ADR   0,2
L00228   DS    0H
         LD    2,C00652
         CD    2,T00003+448
         BC    11,L00230
L00229   DS    0H
         LD    2,C00651
         MD    2,T00003+448
         ADR   0,2
L00230   DS    0H
         LD    2,C00654
         CD    2,T00003+504
         BC    11,L00232
L00231   DS    0H
         LD    2,C00653
         MD    2,T00003+504
         ADR   0,2
L00232   DS    0H
         LD    2,C00656
         CD    2,T00003+560
         BC    11,L00234
L00233   DS    0H
         LD    2,C00655
         MD    2,T00003+560
         ADR   0,2
L00234   DS    0H
         LD    2,C00658
         CD    2,T00003+616
         BC    11,L00236
L00235   DS    0H
         LD    2,C00657
         MD    2,T00003+616
         ADR   0,2
L00236   DS    0H
         LD    2,C00660
         CD    2,T00003+672
         BC    11,L00238
L00237   DS    0H
         LD    2,C00659
         MD    2,T00003+672
         ADR   0,2
L00238   DS    0H
         LD    2,C00661
         CD    2,T00003+728
         BC    11,L00240
L00239   DS    0H
         LD    2,C00647
         MD    2,T00003+728
         ADR   0,2
L00240   DS    0H
         LD    2,C00662
         CD    2,T00003+784
         BC    11,L00242
L00241   DS    0H
         LD    2,C00649
         MD    2,T00003+784
         ADR   0,2
L00242   DS    0H
         LD    2,C00663
         CD    2,T00003+40
         BC    11,L00244
L00243   DS    0H
         LD    2,C00651
         MD    2,T00003+40
         ADR   0,2
L00244   DS    0H
         LD    2,C00664
         CD    2,T00003+96
         BC    11,L00246
L00245   DS    0H
         LD    2,C00653
         MD    2,T00003+96
         ADR   0,2
L00246   DS    0H
         LD    2,C00665
         CD    2,T00003+152
         BC    11,L00248
L00247   DS    0H
         LD    2,C00655
         MD    2,T00003+152
         ADR   0,2
L00248   DS    0H
         LD    2,C00646
         CD    2,T00003+208
         BC    11,L00250
L00249   DS    0H
         LD    2,C00657
         MD    2,T00003+208
         ADR   0,2
L00250   DS    0H
         LD    2,C00648
         CD    2,T00003+264
         BC    11,L00252
L00251   DS    0H
         LD    2,C00659
         MD    2,T00003+264
         ADR   0,2
L00252   DS    0H
         LD    2,C00650
         CD    2,T00003+320
         BC    11,L00254
L00253   DS    0H
         LD    2,C00647
         MD    2,T00003+320
         ADR   0,2
L00254   DS    0H
         LD    2,C00652
         CD    2,T00003+376
         BC    11,L00256
L00255   DS    0H
         LD    2,C00649
         MD    2,T00003+376
         ADR   0,2
L00256   DS    0H
         LD    2,C00654
         CD    2,T00003+432
         BC    11,L00258
L00257   DS    0H
         LD    2,C00651
         MD    2,T00003+432
         ADR   0,2
L00258   DS    0H
         LD    2,C00656
         CD    2,T00003+488
         BC    11,L00260
L00259   DS    0H
         LD    2,C00653
         MD    2,T00003+488
         ADR   0,2
L00260   DS    0H
         LD    2,C00658
         CD    2,T00003+544
         BC    11,L00262
L00261   DS    0H
         LD    2,C00655
         MD    2,T00003+544
         ADR   0,2
L00262   DS    0H
         LD    2,C00660
         CD    2,T00003+600
         BC    11,L00264
L00263   DS    0H
         LD    2,C00657
         MD    2,T00003+600
         ADR   0,2
L00264   DS    0H
         LD    2,C00661
         CD    2,T00003+656
         BC    11,L00266
L00265   DS    0H
         LD    2,C00659
         MD    2,T00003+656
         ADR   0,2
L00266   DS    0H
         LD    2,C00662
         CD    2,T00003+712
         BC    11,L00268
L00267   DS    0H
         LD    2,C00647
         MD    2,T00003+712
         ADR   0,2
L00268   DS    0H
         LD    2,C00663
         CD    2,T00003+768
         BC    11,L00270
L00269   DS    0H
         LD    2,C00649
         MD    2,T00003+768
         ADR   0,2
L00270   DS    0H
         LD    2,C00664
         CD    2,T00003+24
         BC    11,L00272
L00271   DS    0H
         LD    2,C00651
         MD    2,T00003+24
         ADR   0,2
L00272   DS    0H
         LD    2,C00665
         CD    2,T00003+80
         BC    11,L00274
L00273   DS    0H
         LD    2,C00653
         MD    2,T00003+80
         ADR   0,2
L00274   DS    0H
         LD    2,C00646
         CD    2,T00003+136
         BC    11,L00276
L00275   DS    0H
         LD    2,C00655
         MD    2,T00003+136
         ADR   0,2
L00276   DS    0H
         LD    2,C00648
         CD    2,T00003+192
         BC    11,L00278
L00277   DS    0H
         LD    2,C00657
         MD    2,T00003+192
         ADR   0,2
L00278   DS    0H
         LD    2,C00650
         CD    2,T00003+248
         BC    11,L00280
L00279   DS    0H
         LD    2,C00659
         MD    2,T00003+248
         ADR   0,2
L00280   DS    0H
         LD    2,C00652
         CD    2,T00003+304
         BC    11,L00282
L00281   DS    0H
         LD    2,C00647
         MD    2,T00003+304
         ADR   0,2
L00282   DS    0H
         LD    2,C00654
         CD    2,T00003+360
         BC    11,L00284
L00283   DS    0H
         LD    2,C00649
         MD    2,T00003+360
         ADR   0,2
L00284   DS    0H
         LD    2,C00656
         CD    2,T00003+416
         BC    11,L00286
L00285   DS    0H
         LD    2,C00651
         MD    2,T00003+416
         ADR   0,2
L00286   DS    0H
         LD    2,C00658
         CD    2,T00003+472
         BC    11,L00288
L00287   DS    0H
         LD    2,C00653
         MD    2,T00003+472
         ADR   0,2
L00288   DS    0H
         LD    2,C00660
         CD    2,T00003+528
         BC    11,L00290
L00289   DS    0H
         LD    2,C00655
         MD    2,T00003+528
         ADR   0,2
L00290   DS    0H
         LD    2,C00661
         CD    2,T00003+584
         BC    11,L00292
L00291   DS    0H
         LD    2,C00657
         MD    2,T00003+584
         ADR   0,2
L00292   DS    0H
         LD    2,C00662
         CD    2,T00003+640
         BC    11,L00294
L00293   DS    0H
         LD    2,C00659
         MD    2,T00003+640
         ADR   0,2
L00294   DS    0H
         LD    2,C00663
         CD    2,T00003+696
         BC    11,L00296
L00295   DS    0H
         LD    2,C00647
         MD    2,T00003+696
         ADR   0,2
L00296   DS    0H
         LD    2,C00664
         CD    2,T00003+752
         BC    11,L00298
L00297   DS    0H
         LD    2,C00649
         MD    2,T00003+752
         ADR   0,2
L00298   DS    0H
         LD    2,C00665
         CD    2,T00003+8
         BC    11,L00300
L00299   DS    0H
         LD    2,C00651
         MD    2,T00003+8
         ADR   0,2
L00300   DS    0H
         LD    2,C00646
         CD    2,T00003+64
         BC    11,L00302
L00301   DS    0H
         LD    2,C00653
         MD    2,T00003+64
         ADR   0,2
L00302   DS    0H
         LD    2,C00648
         CD    2,T00003+120
         BC    11,L00304
L00303   DS    0H
         LD    2,C00655
         MD    2,T00003+120
         ADR   0,2
L00304   DS    0H
         LD    2,C00650
         CD    2,T00003+176
         BC    11,L00306
L00305   DS    0H
         LD    2,C00657
         MD    2,T00003+176
         ADR   0,2
L00306   DS    0H
         LD    2,C00652
         CD    2,T00003+232
         BC    11,L00308
L00307   DS    0H
         LD    2,C00659
         MD    2,T00003+232
         ADR   0,2
L00308   DS    0H
         LD    2,C00654
         CD    2,T00003+288
         BC    11,L00310
L00309   DS    0H
         LD    2,C00647
         MD    2,T00003+288
         ADR   0,2
L00310   DS    0H
         LD    2,C00656
         CD    2,T00003+344
         BC    11,L00312
L00311   DS    0H
         LD    2,C00649
         MD    2,T00003+344
         ADR   0,2
L00312   DS    0H
         LD    2,C00658
         CD    2,T00003+400
         BC    11,L00314
L00313   DS    0H
         LD    2,C00651
         MD    2,T00003+400
         ADR   0,2
L00314   DS    0H
         LD    2,C00645
         CDR   0,2
         BC    4,L00315
L00316   DS    0H
         LD    2,C00660
         CD    2,T00003+456
         BC    11,L00318
L00317   DS    0H
         LD    2,C00653
         MD    2,T00003+456
         ADR   0,2
L00318   DS    0H
         LD    2,C00661
         CD    2,T00003+512
         BC    11,L00320
L00319   DS    0H
         LD    2,C00655
         MD    2,T00003+512
         ADR   0,2
L00320   DS    0H
         LD    2,C00662
         CD    2,T00003+568
         BC    11,L00322
L00321   DS    0H
         LD    2,C00657
         MD    2,T00003+568
         ADR   0,2
L00322   DS    0H
         LD    2,C00663
         CD    2,T00003+624
         BC    11,L00324
L00323   DS    0H
         LD    2,C00659
         MD    2,T00003+624
         ADR   0,2
L00324   DS    0H
         LD    2,C00664
         CD    2,T00003+680
         BC    11,L00326
L00325   DS    0H
         LD    2,C00647
         MD    2,T00003+680
         ADR   0,2
L00326   DS    0H
         LD    2,C00665
         CD    2,T00003+736
         BC    11,L00328
L00327   DS    0H
         LD    2,C00649
         MD    2,T00003+736
         ADR   0,2
L00328   DS    0H
         LD    2,C00646
         CD    2,T00003+792
         BC    11,L00330
L00329   DS    0H
         LD    2,C00651
         MD    2,T00003+792
         ADR   0,2
L00330   DS    0H
         LD    2,C00648
         CD    2,T00003+48
         BC    11,L00332
L00331   DS    0H
         LD    2,C00653
         MD    2,T00003+48
         ADR   0,2
L00332   DS    0H
         LD    2,C00650
         CD    2,T00003+104
         BC    11,L00334
L00333   DS    0H
         LD    2,C00655
         MD    2,T00003+104
         ADR   0,2
L00334   DS    0H
         LD    2,C00652
         CD    2,T00003+160
         BC    11,L00336
L00335   DS    0H
         LD    2,C00657
         MD    2,T00003+160
         ADR   0,2
L00336   DS    0H
         LD    2,C00654
         CD    2,T00003+216
         BC    11,L00338
L00337   DS    0H
         LD    2,C00659
         MD    2,T00003+216
         ADR   0,2
L00338   DS    0H
         LD    2,C00656
         CD    2,T00003+272
         BC    11,L00340
L00339   DS    0H
         LD    2,C00647
         MD    2,T00003+272
         ADR   0,2
L00340   DS    0H
         LD    2,C00658
         CD    2,T00003+328
         BC    11,L00342
L00341   DS    0H
         LD    2,C00649
         MD    2,T00003+328
         ADR   0,2
L00342   DS    0H
         LD    2,C00660
         CD    2,T00003+384
         BC    11,L00344
L00343   DS    0H
         LD    2,C00651
         MD    2,T00003+384
         ADR   0,2
L00344   DS    0H
         LD    2,C00661
         CD    2,T00003+440
         BC    11,L00346
L00345   DS    0H
         LD    2,C00653
         MD    2,T00003+440
         ADR   0,2
L00346   DS    0H
         LD    2,C00662
         CD    2,T00003+496
         BC    11,L00348
L00347   DS    0H
         LD    2,C00655
         MD    2,T00003+496
         ADR   0,2
L00348   DS    0H
         LD    2,C00663
         CD    2,T00003+552
         BC    11,L00350
L00349   DS    0H
         LD    2,C00657
         MD    2,T00003+552
         ADR   0,2
L00350   DS    0H
         LD    2,C00664
         CD    2,T00003+608
         BC    11,L00352
L00351   DS    0H
         LD    2,C00659
         MD    2,T00003+608
         ADR   0,2
L00352   DS    0H
         LD    2,C00665
         CD    2,T00003+664
         BC    11,L00354
L00353   DS    0H
         LD    2,C00647
         MD    2,T00003+664
         ADR   0,2
L00354   DS    0H
         LD    2,C00646
         CD    2,T00003+720
         BC    11,L00356
L00355   DS    0H
         LD    2,C00649
         MD    2,T00003+720
         ADR   0,2
L00356   DS    0H
         LD    2,C00648
         CD    2,T00003+776
         BC    11,L00358
L00357   DS    0H
         LD    2,C00651
         MD    2,T00003+776
         ADR   0,2
L00358   DS    0H
         LD    2,C00650
         CD    2,T00003+32
         BC    11,L00360
L00359   DS    0H
         LD    2,C00653
         MD    2,T00003+32
         ADR   0,2
L00360   DS    0H
         LD    2,C00652
         CD    2,T00003+88
         BC    11,L00362
L00361   DS    0H
         LD    2,C00655
         MD    2,T00003+88
         ADR   0,2
L00362   DS    0H
         LD    2,C00654
         CD    2,T00003+144
         BC    11,L00364
L00363   DS    0H
         LD    2,C00657
         MD    2,T00003+144
         ADR   0,2
L00364   DS    0H
         LD    2,C00656
         CD    2,T00003+200
         BC    11,L00366
L00365   DS    0H
         LD    2,C00659
         MD    2,T00003+200
         ADR   0,2
L00366   DS    0H
         LD    2,C00658
         CD    2,T00003+256
         BC    11,L00368
L00367   DS    0H
         LD    2,C00647
         MD    2,T00003+256
         ADR   0,2
L00368   DS    0H
         LD    2,C00660
         CD    2,T00003+312
         BC    11,L00370
L00369   DS    0H
         LD    2,C00649
         MD    2,T00003+312
         ADR   0,2
L00370   DS    0H
         LD    2,C00661
         CD    2,T00003+368
         BC    11,L00372
L00371   DS    0H
         LD    2,C00651
         MD    2,T00003+368
         ADR   0,2
L00372   DS    0H
         LD    2,C00662
         CD    2,T00003+424
         BC    11,L00374
L00373   DS    0H
         LD    2,C00653
         MD    2,T00003+424
         ADR   0,2
L00374   DS    0H
         LD    2,C00663
         CD    2,T00003+480
         BC    11,L00376
L00375   DS    0H
         LD    2,C00655
         MD    2,T00003+480
         ADR   0,2
L00376   DS    0H
         LD    2,C00664
         CD    2,T00003+536
         BC    11,L00378
L00377   DS    0H
         LD    2,C00657
         MD    2,T00003+536
         ADR   0,2
L00378   DS    0H
         LD    2,C00665
         CD    2,T00003+592
         BC    11,L00380
L00379   DS    0H
         LD    2,C00659
         MD    2,T00003+592
         ADR   0,2
L00380   DS    0H
         LD    2,C00646
         CD    2,T00003+648
         BC    11,L00382
L00381   DS    0H
         LD    2,C00647
         MD    2,T00003+648
         ADR   0,2
L00382   DS    0H
         LD    2,C00648
         CD    2,T00003+704
         BC    11,L00384
L00383   DS    0H
         LD    2,C00649
         MD    2,T00003+704
         ADR   0,2
L00384   DS    0H
         LD    2,C00650
         CD    2,T00003+760
         BC    11,L00386
L00385   DS    0H
         LD    2,C00651
         MD    2,T00003+760
         ADR   0,2
L00386   DS    0H
         LD    2,C00652
         CD    2,T00003+16
         BC    11,L00388
L00387   DS    0H
         LD    2,C00653
         MD    2,T00003+16
         ADR   0,2
L00388   DS    0H
         LD    2,C00654
         CD    2,T00003+72
         BC    11,L00390
L00389   DS    0H
         LD    2,C00655
         MD    2,T00003+72
         ADR   0,2
L00390   DS    0H
         LD    2,C00656
         CD    2,T00003+128
         BC    11,L00392
L00391   DS    0H
         LD    2,C00657
         MD    2,T00003+128
         ADR   0,2
L00392   DS    0H
         LD    2,C00658
         CD    2,T00003+184
         BC    11,L00394
L00393   DS    0H
         LD    2,C00659
         MD    2,T00003+184
         ADR   0,2
L00394   DS    0H
         LD    2,C00660
         CD    2,T00003+240
         BC    11,L00396
L00395   DS    0H
         LD    2,C00647
         MD    2,T00003+240
         ADR   0,2
L00396   DS    0H
         LD    2,C00661
         CD    2,T00003+296
         BC    11,L00398
L00397   DS    0H
         LD    2,C00649
         MD    2,T00003+296
         ADR   0,2
L00398   DS    0H
         LD    2,C00662
         CD    2,T00003+352
         BC    11,L00400
L00399   DS    0H
         LD    2,C00651
         MD    2,T00003+352
         ADR   0,2
L00400   DS    0H
         LD    2,C00663
         CD    2,T00003+408
         BC    11,L00402
L00401   DS    0H
         LD    2,C00653
         MD    2,T00003+408
         ADR   0,2
L00402   DS    0H
         LD    2,C00664
         CD    2,T00003+464
         BC    11,L00404
L00403   DS    0H
         LD    2,C00655
         MD    2,T00003+464
         ADR   0,2
L00404   DS    0H
         LD    2,C00665
         CD    2,T00003+520
         BC    11,L00406
L00405   DS    0H
         LD    2,C00657
         MD    2,T00003+520
         ADR   0,2
L00406   DS    0H
         LD    2,C00646
         CD    2,T00003+576
         BC    11,L00408
L00407   DS    0H
         LD    2,C00659
         MD    2,T00003+576
         ADR   0,2
L00408   DS    0H
         LD    2,C00648
         CD    2,T00003+632
         BC    11,L00410
L00409   DS    0H
         LD    2,C00647
         MD    2,T00003+632
         ADR   0,2
L00410   DS    0H
         LD    2,C00650
         CD    2,T00003+688
         BC    11,L00412
L00411   DS    0H
         LD    2,C00649
         MD    2,T00003+688
         ADR   0,2
L00412   DS    0H
         LD    2,C00652
         CD    2,T00003+744
         BC    11,L00414
L00413   DS    0H
         LD    2,C00651
         MD    2,T00003+744
         ADR   0,2
L00414   DS    0H
         LD    2,C00654
         CD    2,T00003
         BC    11,L00416
L00415   DS    0H
         LD    2,C00653
         MD    2,T00003
         ADR   0,2
L00416   DS    0H
         LD    2,C00645
         CDR   0,2
         BC    4,L00417
L00418   DS    0H
         LD    2,C00656
         CD    2,T00003+56
         BC    11,L00420
L00419   DS    0H
         LD    2,C00655
         MD    2,T00003+56
         ADR   0,2
L00420   DS    0H
         LD    2,C00658
         CD    2,T00003+112
         BC    11,L00422
L00421   DS    0H
         LD    2,C00657
         MD    2,T00003+112
         ADR   0,2
L00422   DS    0H
         LD    2,C00660
         CD    2,T00003+168
         BC    11,L00424
L00423   DS    0H
         LD    2,C00659
         MD    2,T00003+168
         ADR   0,2
L00424   DS    0H
         LD    2,C00661
         CD    2,T00003+224
         BC    11,L00426
L00425   DS    0H
         LD    2,C00647
         MD    2,T00003+224
         ADR   0,2
L00426   DS    0H
         LD    2,C00662
         CD    2,T00003+280
         BC    11,L00428
L00427   DS    0H
         LD    2,C00649
         MD    2,T00003+280
         ADR   0,2
L00428   DS    0H
         LD    2,C00663
         CD    2,T00003+336
         BC    11,L00430
L00429   DS    0H
         LD    2,C00651
         MD    2,T00003+336
         ADR   0,2
L00430   DS    0H
         LD    2,C00664
         CD    2,T00003+392
         BC    11,L00432
L00431   DS    0H
         LD    2,C00653
         MD    2,T00003+392
         ADR   0,2
L00432   DS    0H
         LD    2,C00665
         CD    2,T00003+448
         BC    11,L00434
L00433   DS    0H
         LD    2,C00655
         MD    2,T00003+448
         ADR   0,2
L00434   DS    0H
         LD    2,C00646
         CD    2,T00003+504
         BC    11,L00436
L00435   DS    0H
         LD    2,C00657
         MD    2,T00003+504
         ADR   0,2
L00436   DS    0H
         LD    2,C00648
         CD    2,T00003+560
         BC    11,L00438
L00437   DS    0H
         LD    2,C00659
         MD    2,T00003+560
         ADR   0,2
L00438   DS    0H
         LD    2,C00650
         CD    2,T00003+616
         BC    11,L00440
L00439   DS    0H
         LD    2,C00647
         MD    2,T00003+616
         ADR   0,2
L00440   DS    0H
         LD    2,C00652
         CD    2,T00003+672
         BC    11,L00442
L00441   DS    0H
         LD    2,C00649
         MD    2,T00003+672
         ADR   0,2
L00442   DS    0H
         LD    2,C00654
         CD    2,T00003+728
         BC    11,L00444
L00443   DS    0H
         LD    2,C00651
         MD    2,T00003+728
         ADR   0,2
L00444   DS    0H
         LD    2,C00656
         CD    2,T00003+784
         BC    11,L00446
L00445   DS    0H
         LD    2,C00653
         MD    2,T00003+784
         ADR   0,2
L00446   DS    0H
         LD    2,C00658
         CD    2,T00003+40
         BC    11,L00448
L00447   DS    0H
         LD    2,C00655
         MD    2,T00003+40
         ADR   0,2
L00448   DS    0H
         LD    2,C00660
         CD    2,T00003+96
         BC    11,L00450
L00449   DS    0H
         LD    2,C00657
         MD    2,T00003+96
         ADR   0,2
L00450   DS    0H
         LD    2,C00661
         CD    2,T00003+152
         BC    11,L00452
L00451   DS    0H
         LD    2,C00659
         MD    2,T00003+152
         ADR   0,2
L00452   DS    0H
         LD    2,C00662
         CD    2,T00003+208
         BC    11,L00454
L00453   DS    0H
         LD    2,C00647
         MD    2,T00003+208
         ADR   0,2
L00454   DS    0H
         LD    2,C00663
         CD    2,T00003+264
         BC    11,L00456
L00455   DS    0H
         LD    2,C00649
         MD    2,T00003+264
         ADR   0,2
L00456   DS    0H
         LD    2,C00664
         CD    2,T00003+320
         BC    11,L00458
L00457   DS    0H
         LD    2,C00651
         MD    2,T00003+320
         ADR   0,2
L00458   DS    0H
         LD    2,C00665
         CD    2,T00003+376
         BC    11,L00460
L00459   DS    0H
         LD    2,C00653
         MD    2,T00003+376
         ADR   0,2
L00460   DS    0H
         LD    2,C00646
         CD    2,T00003+432
         BC    11,L00462
L00461   DS    0H
         LD    2,C00655
         MD    2,T00003+432
         ADR   0,2
L00462   DS    0H
         LD    2,C00648
         CD    2,T00003+488
         BC    11,L00464
L00463   DS    0H
         LD    2,C00657
         MD    2,T00003+488
         ADR   0,2
L00464   DS    0H
         LD    2,C00650
         CD    2,T00003+544
         BC    11,L00466
L00465   DS    0H
         LD    2,C00659
         MD    2,T00003+544
         ADR   0,2
L00466   DS    0H
         LD    2,C00652
         CD    2,T00003+600
         BC    11,L00468
L00467   DS    0H
         LD    2,C00647
         MD    2,T00003+600
         ADR   0,2
L00468   DS    0H
         LD    2,C00654
         CD    2,T00003+656
         BC    11,L00470
L00469   DS    0H
         LD    2,C00649
         MD    2,T00003+656
         ADR   0,2
L00470   DS    0H
         LD    2,C00656
         CD    2,T00003+712
         BC    11,L00472
L00471   DS    0H
         LD    2,C00651
         MD    2,T00003+712
         ADR   0,2
L00472   DS    0H
         LD    2,C00658
         CD    2,T00003+768
         BC    11,L00474
L00473   DS    0H
         LD    2,C00653
         MD    2,T00003+768
         ADR   0,2
L00474   DS    0H
         LD    2,C00660
         CD    2,T00003+24
         BC    11,L00476
L00475   DS    0H
         LD    2,C00655
         MD    2,T00003+24
         ADR   0,2
L00476   DS    0H
         LD    2,C00661
         CD    2,T00003+80
         BC    11,L00478
L00477   DS    0H
         LD    2,C00657
         MD    2,T00003+80
         ADR   0,2
L00478   DS    0H
         LD    2,C00662
         CD    2,T00003+136
         BC    11,L00480
L00479   DS    0H
         LD    2,C00659
         MD    2,T00003+136
         ADR   0,2
L00480   DS    0H
         LD    2,C00663
         CD    2,T00003+192
         BC    11,L00482
L00481   DS    0H
         LD    2,C00647
         MD    2,T00003+192
         ADR   0,2
L00482   DS    0H
         LD    2,C00664
         CD    2,T00003+248
         BC    11,L00484
L00483   DS    0H
         LD    2,C00649
         MD    2,T00003+248
         ADR   0,2
L00484   DS    0H
         LD    2,C00665
         CD    2,T00003+304
         BC    11,L00486
L00485   DS    0H
         LD    2,C00651
         MD    2,T00003+304
         ADR   0,2
L00486   DS    0H
         LD    2,C00646
         CD    2,T00003+360
         BC    11,L00488
L00487   DS    0H
         LD    2,C00653
         MD    2,T00003+360
         ADR   0,2
L00488   DS    0H
         LD    2,C00648
         CD    2,T00003+416
         BC    11,L00490
L00489   DS    0H
         LD    2,C00655
         MD    2,T00003+416
         ADR   0,2
L00490   DS    0H
         LD    2,C00650
         CD    2,T00003+472
         BC    11,L00492
L00491   DS    0H
         LD    2,C00657
         MD    2,T00003+472
         ADR   0,2
L00492   DS    0H
         LD    2,C00652
         CD    2,T00003+528
         BC    11,L00494
L00493   DS    0H
         LD    2,C00659
         MD    2,T00003+528
         ADR   0,2
L00494   DS    0H
         LD    2,C00654
         CD    2,T00003+584
         BC    11,L00496
L00495   DS    0H
         LD    2,C00647
         MD    2,T00003+584
         ADR   0,2
L00496   DS    0H
         LD    2,C00656
         CD    2,T00003+640
         BC    11,L00498
L00497   DS    0H
         LD    2,C00649
         MD    2,T00003+640
         ADR   0,2
L00498   DS    0H
         LD    2,C00658
         CD    2,T00003+696
         BC    11,L00500
L00499   DS    0H
         LD    2,C00651
         MD    2,T00003+696
         ADR   0,2
L00500   DS    0H
         LD    2,C00660
         CD    2,T00003+752
         BC    11,L00502
L00501   DS    0H
         LD    2,C00653
         MD    2,T00003+752
         ADR   0,2
L00502   DS    0H
         LD    2,C00661
         CD    2,T00003+8
         BC    11,L00504
L00503   DS    0H
         LD    2,C00655
         MD    2,T00003+8
         ADR   0,2
L00504   DS    0H
         LD    2,C00662
         CD    2,T00003+64
         BC    11,L00506
L00505   DS    0H
         LD    2,C00657
         MD    2,T00003+64
         ADR   0,2
L00506   DS    0H
         LD    2,C00663
         CD    2,T00003+120
         BC    11,L00508
L00507   DS    0H
         LD    2,C00659
         MD    2,T00003+120
         ADR   0,2
L00508   DS    0H
         LD    2,C00664
         CD    2,T00003+176
         BC    11,L00510
L00509   DS    0H
         LD    2,C00647
         MD    2,T00003+176
         ADR   0,2
L00510   DS    0H
         LD    2,C00665
         CD    2,T00003+232
         BC    11,L00512
L00511   DS    0H
         LD    2,C00649
         MD    2,T00003+232
         ADR   0,2
L00512   DS    0H
         LD    2,C00646
         CD    2,T00003+288
         BC    11,L00514
L00513   DS    0H
         LD    2,C00651
         MD    2,T00003+288
         ADR   0,2
L00514   DS    0H
         LD    2,C00648
         CD    2,T00003+344
         BC    11,L00516
L00515   DS    0H
         LD    2,C00653
         MD    2,T00003+344
         ADR   0,2
L00516   DS    0H
         LD    2,C00650
         CD    2,T00003+400
         BC    11,L00518
L00517   DS    0H
         LD    2,C00655
         MD    2,T00003+400
         ADR   0,2
L00518   DS    0H
         LD    2,C00645
         CDR   0,2
         BC    4,L00519
L00520   DS    0H
         LD    2,C00652
         CD    2,T00003+456
         BC    11,L00522
L00521   DS    0H
         LD    2,C00657
         MD    2,T00003+456
         ADR   0,2
L00522   DS    0H
         LD    2,C00654
         CD    2,T00003+512
         BC    11,L00524
L00523   DS    0H
         LD    2,C00659
         MD    2,T00003+512
         ADR   0,2
L00524   DS    0H
         LD    2,C00656
         CD    2,T00003+568
         BC    11,L00526
L00525   DS    0H
         LD    2,C00647
         MD    2,T00003+568
         ADR   0,2
L00526   DS    0H
         LD    2,C00658
         CD    2,T00003+624
         BC    11,L00528
L00527   DS    0H
         LD    2,C00649
         MD    2,T00003+624
         ADR   0,2
L00528   DS    0H
         LD    2,C00660
         CD    2,T00003+680
         BC    11,L00530
L00529   DS    0H
         LD    2,C00651
         MD    2,T00003+680
         ADR   0,2
L00530   DS    0H
         LD    2,C00661
         CD    2,T00003+736
         BC    11,L00532
L00531   DS    0H
         LD    2,C00653
         MD    2,T00003+736
         ADR   0,2
L00532   DS    0H
         LD    2,C00662
         CD    2,T00003+792
         BC    11,L00534
L00533   DS    0H
         LD    2,C00655
         MD    2,T00003+792
         ADR   0,2
L00534   DS    0H
         LD    2,C00663
         CD    2,T00003+48
         BC    11,L00536
L00535   DS    0H
         LD    2,C00657
         MD    2,T00003+48
         ADR   0,2
L00536   DS    0H
         LD    2,C00664
         CD    2,T00003+104
         BC    11,L00538
L00537   DS    0H
         LD    2,C00659
         MD    2,T00003+104
         ADR   0,2
L00538   DS    0H
         LD    2,C00665
         CD    2,T00003+160
         BC    11,L00540
L00539   DS    0H
         LD    2,C00647
         MD    2,T00003+160
         ADR   0,2
L00540   DS    0H
         LD    2,C00646
         CD    2,T00003+216
         BC    11,L00542
L00541   DS    0H
         LD    2,C00649
         MD    2,T00003+216
         ADR   0,2
L00542   DS    0H
         LD    2,C00648
         CD    2,T00003+272
         BC    11,L00544
L00543   DS    0H
         LD    2,C00651
         MD    2,T00003+272
         ADR   0,2
L00544   DS    0H
         LD    2,C00650
         CD    2,T00003+328
         BC    11,L00546
L00545   DS    0H
         LD    2,C00653
         MD    2,T00003+328
         ADR   0,2
L00546   DS    0H
         LD    2,C00652
         CD    2,T00003+384
         BC    11,L00548
L00547   DS    0H
         LD    2,C00655
         MD    2,T00003+384
         ADR   0,2
L00548   DS    0H
         LD    2,C00654
         CD    2,T00003+440
         BC    11,L00550
L00549   DS    0H
         LD    2,C00657
         MD    2,T00003+440
         ADR   0,2
L00550   DS    0H
         LD    2,C00656
         CD    2,T00003+496
         BC    11,L00552
L00551   DS    0H
         LD    2,C00659
         MD    2,T00003+496
         ADR   0,2
L00552   DS    0H
         LD    2,C00658
         CD    2,T00003+552
         BC    11,L00554
L00553   DS    0H
         LD    2,C00647
         MD    2,T00003+552
         ADR   0,2
L00554   DS    0H
         LD    2,C00660
         CD    2,T00003+608
         BC    11,L00556
L00555   DS    0H
         LD    2,C00649
         MD    2,T00003+608
         ADR   0,2
L00556   DS    0H
         LD    2,C00661
         CD    2,T00003+664
         BC    11,L00558
L00557   DS    0H
         LD    2,C00651
         MD    2,T00003+664
         ADR   0,2
L00558   DS    0H
         LD    2,C00662
         CD    2,T00003+720
         BC    11,L00560
L00559   DS    0H
         LD    2,C00653
         MD    2,T00003+720
         ADR   0,2
L00560   DS    0H
         LD    2,C00663
         CD    2,T00003+776
         BC    11,L00562
L00561   DS    0H
         LD    2,C00655
         MD    2,T00003+776
         ADR   0,2
L00562   DS    0H
         LD    2,C00664
         CD    2,T00003+32
         BC    11,L00564
L00563   DS    0H
         LD    2,C00657
         MD    2,T00003+32
         ADR   0,2
L00564   DS    0H
         LD    2,C00665
         CD    2,T00003+88
         BC    11,L00566
L00565   DS    0H
         LD    2,C00659
         MD    2,T00003+88
         ADR   0,2
L00566   DS    0H
         LD    2,C00646
         CD    2,T00003+144
         BC    11,L00568
L00567   DS    0H
         LD    2,C00647
         MD    2,T00003+144
         ADR   0,2
L00568   DS    0H
         LD    2,C00648
         CD    2,T00003+200
         BC    11,L00570
L00569   DS    0H
         LD    2,C00649
         MD    2,T00003+200
         ADR   0,2
L00570   DS    0H
         LD    2,C00650
         CD    2,T00003+256
         BC    11,L00572
L00571   DS    0H
         LD    2,C00651
         MD    2,T00003+256
         ADR   0,2
L00572   DS    0H
         LD    2,C00652
         CD    2,T00003+312
         BC    11,L00574
L00573   DS    0H
         LD    2,C00653
         MD    2,T00003+312
         ADR   0,2
L00574   DS    0H
         LD    2,C00654
         CD    2,T00003+368
         BC    11,L00576
L00575   DS    0H
         LD    2,C00655
         MD    2,T00003+368
         ADR   0,2
L00576   DS    0H
         LD    2,C00656
         CD    2,T00003+424
         BC    11,L00578
L00577   DS    0H
         LD    2,C00657
         MD    2,T00003+424
         ADR   0,2
L00578   DS    0H
         LD    2,C00658
         CD    2,T00003+480
         BC    11,L00580
L00579   DS    0H
         LD    2,C00659
         MD    2,T00003+480
         ADR   0,2
L00580   DS    0H
         LD    2,C00660
         CD    2,T00003+536
         BC    11,L00582
L00581   DS    0H
         LD    2,C00647
         MD    2,T00003+536
         ADR   0,2
L00582   DS    0H
         LD    2,C00661
         CD    2,T00003+592
         BC    11,L00584
L00583   DS    0H
         LD    2,C00649
         MD    2,T00003+592
         ADR   0,2
L00584   DS    0H
         LD    2,C00662
         CD    2,T00003+648
         BC    11,L00586
L00585   DS    0H
         LD    2,C00651
         MD    2,T00003+648
         ADR   0,2
L00586   DS    0H
         LD    2,C00663
         CD    2,T00003+704
         BC    11,L00588
L00587   DS    0H
         LD    2,C00653
         MD    2,T00003+704
         ADR   0,2
L00588   DS    0H
         LD    2,C00664
         CD    2,T00003+760
         BC    11,L00590
L00589   DS    0H
         LD    2,C00655
         MD    2,T00003+760
         ADR   0,2
L00590   DS    0H
         LD    2,C00665
         CD    2,T00003+16
         BC    11,L00592
L00591   DS    0H
         LD    2,C00657
         MD    2,T00003+16
         ADR   0,2
L00592   DS    0H
         LD    2,C00646
         CD    2,T00003+72
         BC    11,L00594
L00593   DS    0H
         LD    2,C00659
         MD    2,T00003+72
         ADR   0,2
L00594   DS    0H
         LD    2,C00648
         CD    2,T00003+128
         BC    11,L00596
L00595   DS    0H
         LD    2,C00647
         MD    2,T00003+128
         ADR   0,2
L00596   DS    0H
         LD    2,C00650
         CD    2,T00003+184
         BC    11,L00598
L00597   DS    0H
         LD    2,C00649
         MD    2,T00003+184
         ADR   0,2
L00598   DS    0H
         LD    2,C00652
         CD    2,T00003+240
         BC    11,L00600
L00599   DS    0H
         LD    2,C00651
         MD    2,T00003+240
         ADR   0,2
L00600   DS    0H
         LD    2,C00654
         CD    2,T00003+296
         BC    11,L00602
L00601   DS    0H
         LD    2,C00653
         MD    2,T00003+296
         ADR   0,2
L00602   DS    0H
         LD    2,C00656
         CD    2,T00003+352
         BC    11,L00604
L00603   DS    0H
         LD    2,C00655
         MD    2,T00003+352
         ADR   0,2
L00604   DS    0H
         LD    2,C00658
         CD    2,T00003+408
         BC    11,L00606
L00605   DS    0H
         LD    2,C00657
         MD    2,T00003+408
         ADR   0,2
L00606   DS    0H
         LD    2,C00660
         CD    2,T00003+464
         BC    11,L00608
L00607   DS    0H
         LD    2,C00659
         MD    2,T00003+464
         ADR   0,2
L00608   DS    0H
         LD    2,C00661
         CD    2,T00003+520
         BC    11,L00610
L00609   DS    0H
         LD    2,C00647
         MD    2,T00003+520
         ADR   0,2
L00610   DS    0H
         LD    2,C00662
         CD    2,T00003+576
         BC    11,L00612
L00611   DS    0H
         LD    2,C00649
         MD    2,T00003+576
         ADR   0,2
L00612   DS    0H
         LD    2,C00663
         CD    2,T00003+632
         BC    11,L00614
L00613   DS    0H
         LD    2,C00651
         MD    2,T00003+632
         ADR   0,2
L00614   DS    0H
         LD    2,C00664
         CD    2,T00003+688
         BC    11,L00616
L00615   DS    0H
         LD    2,C00653
         MD    2,T00003+688
         ADR   0,2
L00616   DS    0H
         LD    2,C00665
         CD    2,T00003+744
         BC    11,L00618
L00617   DS    0H
         LD    2,C00655
         MD    2,T00003+744
         ADR   0,2
L00618   DS    0H
         LD    2,C00646
         CD    2,T00003
         BC    11,L00620
L00619   DS    0H
         LD    2,C00657
         MD    2,T00003
         ADR   0,2
L00620   DS    0H
         LD    2,C00645
         CDR   0,2
         BC    4,L00621
L00622   DS    0H
         LD    2,C00645
L00623   DS    0H
         LH    8,C00666
         LA    9,0
         LA    2,3
L00624   DS    0H
L00626   DS    0H
         LD    4,C00659
         LA    6,8
         LA    7,800
         LA    4,8
L00627   DS    0H
L00629   DS    0H
         LD    6,T00003-8(4)
         MDR   6,4
         ADR   2,6
         BXLE  4,6,L00627
L00628   DS    0H
L00630   DS    0H
         BXH   2,8,L00624
L00625   DS    0H
         LDR   4,0
         ADR   4,2
         STD   4,S00000+984
         C     3,C00667
         BC    4,L00631
L00632   DS    0H
         LA    1,P00668
         L     15,C00669
         BALR  14,15
         LD    0,S00000+984
         STD   0,P00670+0
         LA    1,P00670
         L     15,C00671
         BALR  14,15
         LR    0,3
         ST    0,P00672+0
         LA    1,P00672
         L     15,C00673
         BALR  14,15
         L     15,C00674
         BALR  14,15
L00633   DS    0H
         LA    1,P00675
         L     15,C00676
         BALR  14,15
         B     L00636
L00110   DS    0H
L00112   DS    0H
         LA    1,P00677
         L     15,C00669
         BALR  14,15
         L     15,C00674
         BALR  14,15
L00634   DS    0H
         LA    1,P00675
         L     15,C00676
         BALR  14,15
         B     L00636
L00213   DS    0H
         B     L00112
L00315   DS    0H
         B     L00112
L00417   DS    0H
         B     L00112
L00519   DS    0H
         B     L00112
L00621   DS    0H
         B     L00112
L00631   DS    0H
         LD    0,S00000+984
         B     L00009
L00635   DS    0H
L00636   DS    0H
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
         DROP  12
         DROP  11
S00000   DS    0D
         DS    18F
         DS    F
         DS    F
         DC    X'4E000000',F'0'
         DC    D'0'
         DS    D
         DS    8D
         DS    D
T00003   DS    XL804
         DS    XL4
         DS    1D
P00668   DC    F'6'
         DC    A(Q00001)
P00670   DC    A(0)
         DC    A(0)
P00672   DC    A(0)
P00675   DC    F'0'
P00677   DC    F'6'
         DC    A(Q00002)
C00641   DC    X'4080000000000000'
C00643   DC    X'4E00000080000000'
C00645   DC    X'0000000000000000'
C00646   DC    X'4114000000000000'
C00647   DC    X'3E83126E978D4FDF'
C00648   DC    X'4124000000000000'
C00649   DC    X'3EC49BA5E353F7CF'
C00650   DC    X'4134000000000000'
C00651   DC    X'3F10624DD2F1A9FC'
C00652   DC    X'4144000000000000'
C00653   DC    X'3F147AE147AE147B'
C00654   DC    X'4154000000000000'
C00655   DC    X'3F189374BC6A7EFA'
C00656   DC    X'4164000000000000'
C00657   DC    X'3F1CAC083126E979'
C00658   DC    X'4174000000000000'
C00659   DC    X'3E4189374BC6A7F0'
C00660   DC    X'4184000000000000'
C00661   DC    X'4194000000000000'
C00662   DC    X'41A4000000000000'
C00663   DC    X'41B4000000000000'
C00664   DC    X'41C4000000000000'
C00665   DC    X'4040000000000000'
C00642   DC    F'-2147483648'
C00644   DC    F'1'
C00667   DC    F'3'
C00669   DC    V(F77WRBEG)
C00671   DC    V(F77WRD)
C00673   DC    V(F77WRI)
C00674   DC    V(F77WREND)
C00676   DC    V(EXIT)
C00666   DC    H'-1'
Q00001   DC    C'('' >BIG '',D22.15,I3)'
Q00002   DC    C'('' >BIG NEGATIVE'')'
F77@GO   CSECT
         L     15,8(,15)
         BR    15
         DS    0F
         DC    V(@@CRT0)
         END   F77@GO
