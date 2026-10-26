*
* f77mtan -- DTAN in assembler (issue #3): f77mchk.c's f77c_tan and
* f77math.c's f77m_tan and m_tan_pair as cc370 compiles them, the same
* floating-point instructions in the same order, so the same bits, but
* in registers and storage of its own, without the three C calls, the
* Sums' arrays and M@XSUM's loop.  Each sum is added up as it is
* formed, by AXR into FPR4:6 from zero, as M@XSUM adds its entries in
* order; the roundings are M@XSUM's (RND below).
*
*   the check (f77c_tan): x reduced as m_reduce does, in long, and if
*   k is odd, |r| 2 / (pi/2) below 2^-49 means a singularity: C;
*   the reduction (f77m_tan): k the nearest whole number to x/(pi/2),
*   x - k pi/2 in four parts, the first long, the rest exact in
*   extended, rounded to rh + rl;
*   the tangent (m_tan_pair): r = j/16 + d, |d| <= 1/32, sin r and cos
*   r each a sum of seven terms from the table of sin and cos (j/16)
*   in two parts and short series of d; one over the other by a
*   quotient corrected in extended; that rounded.
*
* An argument of 2^20 or more, or one at a singularity, goes to the C
* entry M@DTANC (f77c_tan: FORTLIB's messages, Payne and Hanek).
*
* From C or Fortran: double DTAN(double), cc370's convention: R1 to
* the argument, the result in FPR0, R2-R13 kept.  Nothing here calls
* anything; the work areas are in the CSECT, as in f77xsum, and R13 a
* frame on the C stack, as a C function's.
*
DTAN     CSECT
         STM   14,12,12(13)
         BALR  12,0
         USING *,12
         L     15,76(,13)            a frame on the C stack, as C's:
         ST    13,4(,15)             the program-interrupt exit takes
         ST    15,8(,13)             an underflow there for the
         LR    13,15                 runtime's, zero without a word
         LA    15,96(,15)
         ST    15,76(,13)
         LD    0,0(,1)
         STD   0,TX
         LTDR  0,0                   2^20 or more: C
         BNL   TPOS
         CD    0,=D'-1.048576E+6'
         BNH   TC
         B     TSMALL
TPOS     CD    0,=D'1.048576E+6'
         BNL   TC
TSMALL   LD    2,TX                  k = (long)(x/(pi/2) +- 1/2)
         DD    2,TPIO2
         LTDR  2,2
         BNL   TK1
         SD    2,=D'5.0E-1'
         B     TK2
TK1      AD    2,=D'5.0E-1'
TK2      LDR   0,2
         AD    0,=XL8'4F08000000000000'
         STD   0,TT
         L     2,TT+4
         ST    2,TKI                 k as an integer: its quadrant
         MVC   TT(4),=XL4'4E000000'
         ST    2,TT+4
         XI    TT+4,128
         LD    0,TT
         SD    0,=XL8'4E00000080000000'
         STD   0,TK                  k
* the check: m_reduce's r, and the gap when k is odd (f77m_tan_gap)
         TM    TKI+3,X'01'
         BZ    TRED
         LD    0,TK
         MD    0,TPIO21
         LD    4,TX
         SDR   4,0
         LD    0,TK
         MD    0,TPIO22
         SDR   4,0
         LD    2,TK
         MD    2,TPIO23
         LDR   0,4
         SDR   0,2
         LTDR  0,0
         BNL   TG1
         MD    0,=D'-2.0E+0'
         DD    0,TPIO2
         B     TG2
TG1      ADR   0,0
         DD    0,TPIO2
TG2      CD    0,=D'1.776356839400250513982E-15'
         BL    TC
* the reduction: x - k pi/2, the first part long, three exact
TRED     SDR   4,4
         SDR   6,6
         LD    0,TK
         MD    0,TPIO21
         LD    2,TX
         SDR   2,0
         LDR   0,2
         SDR   2,2
         AXR   4,0
         LD    0,TK
         LCDR  0,0
         MXD   0,TPIO22
         AXR   4,0
         LD    0,TK
         LCDR  0,0
         MXD   0,TPIO23
         AXR   4,0
         LD    0,TK
         LCDR  0,0
         MXD   0,TPIO24
         AXR   4,0
         BAL   10,RND
         STD   0,TRH                 rh, and rl what the rounding left
         MVC   TRL(8),TRES
* m_tan_pair(rh, rl, k & 3)
         LD    0,TRL
         LD    2,TRH
         LTDR  2,2
         BNL   TP1
         LCDR  4,2                   ah, al: |r|
         LCDR  0,0
         STD   0,TAL
         B     TP2
TP1      LD    4,TRH
         STD   0,TAL
TP2      LDR   2,4                   j = (int)(16 ah + 1/2), 13 at most
         MD    2,=D'1.6E+1'
         AD    2,=D'5.0E-1'
         LDR   0,2
         AD    0,=XL8'4F08000000000000'
         STD   0,TT
         L     2,TT+4
         LA    3,13
         CR    2,3
         BNH   TP3
         LR    2,3
TP3      MVC   TT(4),=XL4'4E000000'
         ST    2,TT+4
         XI    TT+4,128
         LD    0,TT
         SD    0,=XL8'4E00000080000000'
         MD    0,=D'6.25E-2'
         SDR   4,0                   dh = ah - j/16
         STD   4,TDH
         AD    4,TAL                 d = dh + al
         LDR   0,4
         MDR   0,4                   d2
         LDR   2,0                   sd = d d2 (the sine's series)
         MD    2,=D'2.7557319223985890393368E-6'
         SD    2,=D'1.9841269841269841252632E-4'
         MDR   2,0
         AD    2,=D'8.3333333333333332176851E-3'
         MDR   2,0
         SD    2,=D'1.66666666666666671292596E-1'
         MDR   4,0
         MDR   4,2
         STD   4,TSD
         LDR   2,0                   cm = d2 (the cosine's)
         MD    2,=D'2.480158730158730156579E-5'
         SD    2,=D'1.3888888888888888876842E-3'
         MDR   2,0
         AD    2,=D'4.1666666666666666955787E-2'
         MDR   2,0
         SD    2,=D'5.0E-1'
         MDR   0,2
         STD   0,TCM
         SLL   2,5                   sin and cos (j/16), in two parts
         LA    3,TSCT(2)
         MVC   TSH(32),0(3)
* which is over which: q odd, -cos over sin; and r < 0 negates the top
         SR    7,7                   R7 the top's sign: 1 minus
         TM    TKI+3,X'01'
         BZ    TP4
         LA    7,1
TP4      LD    2,TRH
         LTDR  2,2
         BNL   TP5
         X     7,=F'1'
TP5      TM    TKI+3,X'01'
         BO    TP6
         SR    6,6                   q even: cos r over sin r's sign
         BAL   11,SUMC
         B     TP7
TP6      SR    6,6                   q odd: sin r below
         BAL   11,SUMS
TP7      BAL   10,RND                eh, el
         LTDR  0,0
         BZ    THUGE
         STD   0,TEH
         MVC   TEL(8),TRES
         LR    6,7                   the numerator's sum
         TM    TKI+3,X'01'
         BO    TP8
         BAL   11,SUMS
         B     TP9
TP8      BAL   11,SUMC
TP9      STD   4,TNACC
         STD   6,TNACC+8
         BAL   10,RND                m_ddiv: q = it / eh
         DD    0,TEH
         STD   0,TQH
         LD    4,TNACC
         LD    6,TNACC+8
         LD    0,TQH                 less q eh, less q el
         LCDR  0,0
         MXD   0,TEH
         AXR   4,0
         LD    0,TQH
         LCDR  0,0
         MXD   0,TEL
         AXR   4,0
         BAL   10,RND                ql = that / eh
         DD    0,TEH
         STD   0,TQL
         SDR   4,4                   qh + ql, rounded
         SDR   6,6
         LD    0,TQH
         SDR   2,2
         AXR   4,0
         LD    0,TQL
         SDR   2,2
         AXR   4,0
         BAL   10,RND
TRET     L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
THUGE    LD    0,=X'7FFFFFFFFFFFFFFF'
         B     TRET
TC       L     15,=V(M@DTANC)        FORTLIB's checks etc., in C
         L     13,4(,13)
         L     14,12(,13)
         LM    0,12,20(13)
         BR    15
*
* SUMS: sin r = sh + sl + sh cm + ch dh + ch al + cl dh + ch sd, into
* FPR4:6 from zero; SUMC: cos r = ch + cl + ch cm - sh dh - sh al -
* sl dh - sh sd.  Each term's first factor negated when R6 is 1, as
* f77math.c negates the entries.  Return by R11; R10 kept.
*
SUMS     SDR   4,4
         SDR   6,6
         LD    0,TSH
         BAL   10,PLAIN
         LD    0,TSL
         BAL   10,PLAIN
         LD    0,TSH
         LA    9,TCM
         BAL   10,PROD
         LD    0,TCH
         LA    9,TDH
         BAL   10,PROD
         LD    0,TCH
         LA    9,TAL
         BAL   10,PROD
         LD    0,TCL
         LA    9,TDH
         BAL   10,PROD
         LD    0,TCH
         LA    9,TSD
         BAL   10,PROD
         BR    11
SUMC     SDR   4,4
         SDR   6,6
         LD    0,TCH
         BAL   10,PLAIN
         LD    0,TCL
         BAL   10,PLAIN
         LD    0,TCH
         LA    9,TCM
         BAL   10,PROD
         LD    0,TSH
         LCDR  0,0
         LA    9,TDH
         BAL   10,PROD
         LD    0,TSH
         LCDR  0,0
         LA    9,TAL
         BAL   10,PROD
         LD    0,TSL
         LCDR  0,0
         LA    9,TDH
         BAL   10,PROD
         LD    0,TSH
         LCDR  0,0
         LA    9,TSD
         BAL   10,PROD
         BR    11
* a plain term in FPR0; a product, FPR0 by the long R9 addresses;
* negated first when R6 is 1
PLAIN    LTR   6,6
         BZ    PLAIN1
         LCDR  0,0
PLAIN1   SDR   2,2
         AXR   4,0
         BR    10
PROD     LTR   6,6
         BZ    PROD1
         LCDR  0,0
PROD1    MXD   0,0(,9)
         AXR   4,0
         BR    10
*
* RND: FPR4:6 rounded once to nearest, as M@XSUM rounds: half a unit
* in the 15th digit added, the high part kept (below 16^-50, cut);
* the result in FPR0 and in TRES what the rounding left.  FPR0-6,
* R8 and R9 used; return by R10.
*
RND      STD   4,TACC
         STD   6,TACC+8
         LTDR  4,4
         BZ    RZERO
         SR    8,8
         IC    8,TACC                sign and characteristic
         LR    9,8
         N     8,=F'127'
         N     9,=F'128'
         S     8,=F'14'              half a unit: 8 in the 15th digit
         BM    RKEEP
         OR    8,9
         SLL   8,24
         O     8,=X'00800000'
         ST    8,TCON
         LD    0,TCON
         SDR   2,2
         AXR   4,0
RKEEP    STD   4,TOUT
         LD    4,TACC
         LD    6,TACC+8
         LD    0,TOUT
         SDR   2,2
         SXR   4,0
         STD   4,TRES
         LD    0,TOUT
         BR    10
RZERO    SDR   0,0
         STD   0,TRES
         BR    10
*
         LTORG
         DS    0D
TX       DS    D                     the argument
TT       DS    D                     conversions
TK       DS    D                     k
TKI      DS    F                     k as an integer
         DS    F
TRH      DS    D
TRL      DS    D
TAL      DS    D
TDH      DS    D
TSD      DS    D
TCM      DS    D
TSH      DS    D                     sh, sl, ch, cl from the table
TSL      DS    D
TCH      DS    D
TCL      DS    D
TEH      DS    D
TEL      DS    D
TQH      DS    D
TQL      DS    D
TNACC    DS    2D
TACC     DS    2D
TOUT     DS    D
TRES     DS    D
TCON     DC    F'0',F'0'
TPIO2    DC    X'411921FB54442D18'   pi/2
TPIO21   DC    X'411921FB54440000'   in four parts
TPIO22   DC    X'372D184698980000'
TPIO23   DC    X'2DCC51701B839A25'
TPIO24   DC    X'1F2049C1114CF98F'
* sin(j/16) and cos(j/16), j = 0..13, each in two (f77math.c's)
TSCT     DC    X'0000000000000000',X'0000000000000000'
         DC    X'4110000000000000',X'0000000000000000'
         DC    X'3FFFD557776A76D5',X'31A5D259B2F692D5'
         DC    X'40FF800AAA4FA69A',X'3265070F73284DE2'
         DC    X'401FEAAEEE86EE35',X'32CA069A86721F8A'
         DC    X'40FE00AA93EADE9B',X'326D1E6A129DF6F2'
         DC    X'402FB8205F75E56A',X'322B56A1C4792F85'
         DC    X'40FB835EFCF670DD',X'322CE6FE7924697F'
         DC    X'403F55DDA9E62AED',X'327513BD7B8E6A3D'
         DC    X'40F80AA4FBEF750B',X'32A783D33CB95F95'
         DC    X'404EB44A5DA74F60',X'31207AAA090F0735'
         DC    X'40F399F500C9E9FD',X'3237AE9957263DAC'
         DC    X'405DC40955D9084F',X'3248A94675A2498E'
         DC    X'40EE35BF5CCAC890',X'3252CD91DDB734D4'
         DC    X'406C760C14C8585A',X'3251DBD34660AE6C'
         DC    X'40E7E367D2956CFB',X'3216B6AA11E5419D'
         DC    X'407ABBA1D12C17BF',X'32A1D92F0D93F60E'
         DC    X'40E0A94032DBEA7C',X'32EDBDDD9DA2FAFB'
         DC    X'4088868625B4E1DB',X'32B2313310133022'
         DC    X'40D88E820B152631',X'321DD561EFBC0C1B'
         DC    X'4095C8EF544210EC',X'31B91C49BD2AA09F'
         DC    X'40CF9B476C897C25',X'32C5BFE750DD3F31'
         DC    X'40A2759C0E79C355',X'3282527C32B55F54'
         DC    X'40C5D882D2EE4803',X'31C7C07D28E981E3'
         DC    X'40AE7FE0B5FC786B',X'322D966E1D6AF141'
         DC    X'40BB4FF632A908F7',X'323EC151839CB9DA'
         DC    X'40B9DBB406F52BBE',X'32DDB7CF923ED5DF'
         DC    X'40B00C2937AB1EFA',X'328D94BC1C8659F9'
         END
