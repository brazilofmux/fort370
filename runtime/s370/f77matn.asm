*
* f77matn -- DATAN, DASIN and DACOS in assembler (issue #3):
* f77math.c's f77m_atan, m_asincos, m_atan2_terms, m_atan_terms,
* m_ddiv, m_pi_less, m_pio2r and m_pir as cc370 compiles them, the
* same floating-point instructions in the same order, so the same
* bits, without the C calls and the Sums' arrays.  A Sum here is its
* running total, an extended number in storage, each entry added by
* AXR as it is formed, as M@XSUM adds its entries in order from zero;
* the roundings are M@XSUM's (XRND).  sqrt(1 - x^2) is DSQRT's, the
* assembler one, which gives f77m_sqrt's bits.
*
* DASIN and DACOS of an argument past 1 go to the C entries M@DASINC
* and M@DACOSC (f77c_asin, f77c_acos: FORTLIB's message).  DATAN has
* no check, as f77mld.c's had none.
*
* From C or Fortran: double DATAN(double), DASIN(double),
* DACOS(double), cc370's convention: R1 to the argument, the result in
* FPR0, R2-R13 kept.  The work areas are in the CSECT, as in f77xsum,
* and R13 a frame on the C stack, as a C function's.
*
* Registers: R12 the base; R2 the Sum an operation works on, R3 the
* long a product takes; links R10 (XADDP, XADDM, XRND), R7 (DDIV),
* R11 (ATANT); R8-R9 XRND's.
*
F77MATN  CSECT
         USING F77MATN,12            R12 the CSECT's, at each entry
*
* DATAN: zero is zero; atan2(|x|, 1) and x's sign (f77m_atan)
*
         ENTRY DATAN
DATAN    STM   14,12,12(13)
         USING DATAN,15
         L     12,=A(F77MATN)
         DROP  15
         BAL   10,FRAME
         LD    0,0(,1)
         STD   0,TX
         LTDR  0,0
         BZ    ARET
         LA    2,SACC
         BAL   10,XZERO              (which takes FPR0)
         LD    0,TX
         LPDR  0,0
         STD   0,TAY
         MVC   TAX(8),=D'1.0E+0'
         BAL   11,ATAN2T
         LA    2,SACC
         BAL   10,XRND
         LD    2,TX
         LTDR  2,2
         BNL   ARET
         LCDR  0,0
ARET     L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*
* DASIN and DACOS (m_asincos): R4 0 for DASIN, 1 for DACOS
*
         ENTRY DASIN
DASIN    STM   14,12,12(13)
         USING DASIN,15
         L     12,=A(F77MATN)
         DROP  15
         BAL   10,FRAME
         SR    4,4
         B     ACIN
         ENTRY DACOS
DACOS    STM   14,12,12(13)
         USING DACOS,15
         L     12,=A(F77MATN)
         DROP  15
         BAL   10,FRAME
         LA    4,1
ACIN     LD    0,0(,1)
         STD   0,TX
         LPDR  2,0                   a = |x|
         STD   2,TA
         CD    2,=D'1.0E+0'
         BL    AC1
         BH    ACBAD                 past 1: FORTLIB's message, in C
         LTR   4,4                   |x| = 1
         BNZ   ACONE
         BAL   11,PIO2R              DASIN: pi/2 rounded, x's sign
         LD    2,TX
         LTDR  2,2
         BNL   ARET
         LCDR  0,0
         B     ARET
ACONE    SDR   0,0                   DACOS: 0, or pi rounded
         LD    2,TX
         LTDR  2,2
         BH    ARET
         BAL   11,PIR
         B     ARET
ACBAD    L     15,=V(M@DASINC)
         LTR   4,4
         BZ    ACBAD1
         L     15,=V(M@DACOSC)
ACBAD1   L     13,4(,13)
         L     14,12(,13)
         LM    0,12,20(13)
         BR    15
* 1 - x^2 exactly: 2d - d^2, d = 1 - a, from 0.5 on; else 1 - a a
AC1      LA    2,SACC
         BAL   10,XZERO
         LD    0,TA
         CD    0,=D'5.0E-1'
         BL    AC2
         LD    2,=D'1.0E+0'
         SDR   2,0
         STD   2,TD
         LDR   0,2                   d 2^1: by MXD, as M@XSUM takes it
         LA    3,=X'4120000000000000'
         BAL   10,XADDM
         LD    0,TD
         LCDR  0,0
         LA    3,TD
         BAL   10,XADDM
         B     AC3
AC2      LD    0,=D'1.0E+0'
         BAL   10,XADDP
         LD    0,TA
         LCDR  0,0
         LA    3,TA
         BAL   10,XADDM
AC3      BAL   10,XRND               wh, wl
         STD   0,TWH
         MVC   TWL(8),TRES
         LA    1,TWH                 sh = sqrt(wh), DSQRT's
         L     15,=V(DSQRT)
         BALR  14,15
         STD   0,TSH
         LA    2,SACC                sl = (wh + wl - sh^2) / (2 sh)
         BAL   10,XZERO
         LD    0,TWH
         BAL   10,XADDP
         LD    0,TWL
         BAL   10,XADDP
         LD    0,TSH
         LCDR  0,0
         LA    3,TSH
         BAL   10,XADDM
         BAL   10,XRND
         LD    2,TSH
         ADR   2,2
         DDR   0,2
         STD   0,TSL
         LA    2,SACC                t and q from zero
         BAL   10,XZERO
         LA    2,QACC
         BAL   10,XZERO
         LTR   4,4
         BNZ   ACACOS
* DASIN: atan2(a, s), s = sh + sl
         LD    2,TA
         CD    2,TSH
         BH    AS2
         LD    0,TA                  a <= sh: atan(a / s)
         LA    2,QACC
         BAL   10,XADDP
         MVC   TB(8),TSH
         MVC   TBL(8),TSL
         BAL   7,DDIV
         MVC   TSG(8),=D'1.0E+0'
         B     AS3
AS2      LD    0,TSH                 else pi/2 - atan(s / a)
         LA    2,QACC
         BAL   10,XADDP
         LD    0,TSL
         BAL   10,XADDP
         MVC   TB(8),TA
         MVC   TBL(8),=D'0.0'
         BAL   7,DDIV
         LA    2,SACC
         LD    0,KPIO2
         BAL   10,XADDP
         LD    0,KPIO2L
         BAL   10,XADDP
         MVC   TSG(8),=D'-1.0E+0'
AS3      MVC   TZH(8),DQH
         MVC   TZL(8),DQL
         LA    2,SACC
         BAL   11,ATANT
         LA    2,SACC
         BAL   10,XRND
         LD    2,TX
         LTDR  2,2
         BNL   ARET
         LCDR  0,0
         B     ARET
* DACOS: atan2(s, a), and pi less it for x < 0
ACACOS   LD    4,TSH
         CD    4,TA
         BH    AK2
         LD    0,TSH                 sh <= a: atan(s / a)
         LA    2,QACC
         BAL   10,XADDP
         LD    0,TSL
         BAL   10,XADDP
         MVC   TB(8),TA
         MVC   TBL(8),=D'0.0'
         BAL   7,DDIV
         MVC   TSG(8),=D'1.0E+0'
         B     AK3
AK2      LD    0,TA                  else pi/2 - atan(a / s)
         LA    2,QACC
         BAL   10,XADDP
         MVC   TB(8),TSH
         MVC   TBL(8),TSL
         BAL   7,DDIV
         LA    2,SACC
         LD    0,KPIO2
         BAL   10,XADDP
         LD    0,KPIO2L
         BAL   10,XADDP
         MVC   TSG(8),=D'-1.0E+0'
AK3      MVC   TZH(8),DQH
         MVC   TZL(8),DQL
         LA    2,SACC
         BAL   11,ATANT
         LD    0,TX
         LTDR  0,0
         BNL   AK4
         LD    4,SACC                pi less the sum (m_pi_less): the
         LD    6,SACC+8              entries negated are the sum
         LCDR  4,4                   negated, HFP being symmetric
         LCDR  6,6
         STD   4,SACC
         STD   6,SACC+8
         LA    2,SACC
         LD    0,KPI
         BAL   10,XADDP
         LD    0,KPIL
         BAL   10,XADDP
AK4      LA    2,SACC
         BAL   10,XRND
         B     ARET
*
* FRAME: R13 a frame on the C stack, as a C function's: the program-
* interrupt exit takes an underflow there for the runtime's, zero
* without a word.  Return by R10.
*
FRAME    L     15,76(,13)
         ST    13,4(,15)
         ST    15,8(,13)
         LR    13,15
         LA    15,96(,15)
         ST    15,76(,13)
         BR    10
*
* PIO2R, PIR: pi/2 and pi rounded, the constants' two parts summed;
* into FPR0.  Return by R11.
*
PIO2R    LA    2,QACC
         BAL   10,XZERO
         LD    0,KPIO2
         BAL   10,XADDP
         LD    0,KPIO2L
         BAL   10,XADDP
         BAL   10,XRND
         BR    11
PIR      LA    2,QACC
         BAL   10,XZERO
         LD    0,KPI
         BAL   10,XADDP
         LD    0,KPIL
         BAL   10,XADDP
         BAL   10,XRND
         BR    11
*
* ATAN2T: atan2(TAY, TAX), both positive, into SACC (m_atan2_terms).
* Return by R11 (ATANT's, which it goes on to).
*
ATAN2T   LA    2,QACC
         BAL   10,XZERO
         LD    2,TAY
         LD    0,TAX
         CDR   2,0
         BH    AT2
         LDR   0,2                   ay <= ax: atan(ay / ax)
         BAL   10,XADDP
         MVC   TB(8),TAX
         MVC   TBL(8),=D'0.0'
         BAL   7,DDIV
         MVC   TSG(8),=D'1.0E+0'
         B     AT3
AT2      BAL   10,XADDP              else pi/2 - atan(ax / ay)
         MVC   TB(8),TAY
         MVC   TBL(8),=D'0.0'
         BAL   7,DDIV
         LA    2,SACC
         LD    0,KPIO2
         BAL   10,XADDP
         LD    0,KPIO2L
         BAL   10,XADDP
         MVC   TSG(8),=D'-1.0E+0'
AT3      MVC   TZH(8),DQH
         MVC   TZL(8),DQL
         LA    2,SACC
*
* ATANT: sg atan(zh + zl), 0 <= z <= 1, added to the Sum R2 names
* (m_atan_terms): atan(k/8) + atan u, k the nearest whole number to
* 8z, u = (z - k/8) / (1 + z k/8); atan u by its series to u^17.
* TZH, TZL, TSG in.  Return by R11.
*
ATANT    LR    5,2
         LD    2,TZH                 k = (int)(8 zh + 1/2), c = k/8
         MD    2,=D'8.0E+0'
         AD    2,=D'5.0E-1'
         LDR   0,2
         AD    0,=XL8'4F08000000000000'
         STD   0,TT
         L     6,TT+4
         MVC   TT(4),=XL4'4E000000'
         ST    6,TT+4
         XI    TT+4,128
         LD    0,TT
         SD    0,=XL8'4E00000080000000'
         MD    0,=D'1.25E-1'
         STD   0,TC
         LTR   6,6
         BNZ   ATK
         MVC   TUH(8),TZH            k = 0: u = z
         MVC   TUL(8),TZL
         B     ATU
ATK      LA    2,DACC                1 + c zh + c zl
         BAL   10,XZERO
         LD    0,=D'1.0E+0'
         BAL   10,XADDP
         LD    0,TC
         LA    3,TZH
         BAL   10,XADDM
         LD    0,TC
         LA    3,TZL
         BAL   10,XADDM
         BAL   10,XRND
         STD   0,TB                  dh, dl
         MVC   TBL(8),TRES
         BAL   10,XZERO              (zh - c + zl) / (dh + dl)
         LD    0,TZH
         SD    0,TC
         BAL   10,XADDP
         LD    0,TZL
         BAL   10,XADDP
         BAL   7,DDIV
         MVC   TUH(8),DQH
         MVC   TUL(8),DQL
ATU      LD    4,TUH                 u2, and the series' p
         MDR   4,4
         STD   4,TU2
         LDR   0,4
         MD    0,=D'5.8823529411764705933374E-2'
         SD    0,=D'6.66666666666666657414808E-2'
         MDR   0,4
         AD    0,=D'7.69230769230769273470116E-2'
         MDR   0,4
         SD    0,=D'9.09090909090909116141432E-2'
         MDR   0,4
         AD    0,=D'1.11111111111111104943205E-1'
         MDR   0,4
         SD    0,=D'1.4285714285714286309048E-1'
         MDR   0,4
         AD    0,=D'1.99999999999999997224442E-1'
         MDR   0,4
         SD    0,=D'3.33333333333333328707404E-1'
         STD   0,TP
         LR    2,5                   the terms, each times sg
         SLL   6,4
         LA    3,KATANT(6)
         LD    0,TSG
         MD    0,0(,3)
         BAL   10,XADDP
         LD    0,TSG
         MD    0,8(,3)
         BAL   10,XADDP
         LD    0,TSG
         MD    0,TUH
         BAL   10,XADDP
         LD    0,TSG
         MD    0,TUL
         BAL   10,XADDP
         LD    0,TU2                 (uh u2) p
         MD    0,TUH
         MD    0,TP
         MD    0,TSG
         BAL   10,XADDP
         BR    11
*
* DDIV: (the Sum R2 names) / (TB + TBL) as DQH + DQL (m_ddiv): the
* quotient of its rounding, then the remainder's.  Return by R7.
*
DDIV     BAL   10,XRND
         DD    0,TB
         STD   0,DQH
         LCDR  0,0
         LA    3,TB
         BAL   10,XADDM
         LD    0,DQH
         LCDR  0,0
         LA    3,TBL
         BAL   10,XADDM
         BAL   10,XRND
         DD    0,TB
         STD   0,DQL
         BR    7
*
* XZERO: the Sum R2 names to zero.  XADDP: FPR0 added to it, an
* entry a.  XADDM: FPR0 times the long R3 names added, an entry a b.
* Return by R10.
*
XZERO    SDR   0,0
         STD   0,0(,2)
         STD   0,8(,2)
         BR    10
XADDP    SDR   2,2
         B     XADD
XADDM    MXD   0,0(,3)
XADD     LD    4,0(,2)
         LD    6,8(,2)
         AXR   4,0
         STD   4,0(,2)
         STD   6,8(,2)
         BR    10
*
* XRND: the Sum R2 names rounded once to nearest, as M@XSUM rounds:
* half a unit in the 15th digit added, the high part kept (below
* 16^-50, cut); the result in FPR0 and in TRES what the rounding
* left.  FPR0-6, R8 and R9 used; the Sum kept.  Return by R10.
*
XRND     LD    4,0(,2)
         LD    6,8(,2)
         STD   4,TACC
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
SACC     DS    2D                    the Sums: t
QACC     DS    2D                    q
DACC     DS    2D                    m_atan_terms' d
TACC     DS    2D                    XRND's
TX       DS    D                     the argument
TA       DS    D                     |x|
TD       DS    D                     1 - a
TAY      DS    D
TAX      DS    D
TWH      DS    D                     1 - x^2 in two parts
TWL      DS    D
TSH      DS    D                     its root in two parts
TSL      DS    D
TB       DS    D                     DDIV's divisor in two parts
TBL      DS    D
DQH      DS    D                     its quotient in two parts
DQL      DS    D
TZH      DS    D                     ATANT's z in two parts
TZL      DS    D
TSG      DS    D                     and its sign
TC       DS    D
TUH      DS    D
TUL      DS    D
TU2      DS    D
TP       DS    D
TT       DS    D
TOUT     DS    D
TRES     DS    D
TCON     DC    F'0',F'0'
KPIO2    DC    X'411921FB54442D18'   pi/2
KPIO2L   DC    X'33469898CC51701C'   pi/2 less it
KPI      DC    X'413243F6A8885A30'   pi
KPIL     DC    X'338D313198A2E037'   pi less it
* atan(k/8), k = 0..8, in two parts (f77math.c's)
KATANT   DC    X'0000000000000000',X'0000000000000000'
         DC    X'401FD5BA9AAC2F6D',X'32C65912F313E7D1'
         DC    X'403EB6EBF25901BA',X'32C55B71E7BD7DE9'
         DC    X'405BD86507937BC2',X'3239C55190916E7F'
         DC    X'4076B19C1586ED3D',X'32A2B7F222F65E1D'
         DC    X'408F005D5EF7F59F',X'329B5C835E1665C4'
         DC    X'40A4BC7D1934F709',X'322419A87F2A457E'
         DC    X'40B8053E2BC2319E',X'3273CB2DA55210A4'
         DC    X'40C90FDAA22168C2',X'3234C4C6628B80DC'
         END
