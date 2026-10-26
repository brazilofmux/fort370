*
* f77mexp -- DEXP, DLOG, DLOG10, DPOW (X**Y), DSINH, DCOSH and DTANH
* in assembler (issue #3): f77mchk.c's checks and f77math.c's
* f77m_exp, f77m_log, f77m_log10, f77m_pow, f77m_sinh, f77m_cosh,
* f77m_tanh, m_hyp, m_exp_terms, m_log_terms, m_frexp, m_ddiv,
* sum_frame and m_hex as cc370 compiles them, the same floating-point
* instructions in the same order, so the same bits, without the C
* calls and the Sums' arrays.  A Sum is its running total, an
* extended number in storage, each entry added by AXR as it is formed,
* as M@XSUM adds its entries in order from zero: a b 2^s, the product
* by MXD, 2^s by MXD (a plain entry) or MXR (a product), as M@XSUM
* takes them; the roundings are M@XSUM's (XRND).  The exponential's
* k is known before its entries are formed, so sum_frame's 2^(k mod 4)
* is in each as it is added, and its 16^q applied after (MHEX); m_hyp
* frames the same entries two ways, so they go to two totals.
*
* DPOW's check (f77c_pow) takes log x as f77m_log does, and f77m_pow
* then takes it again: the same sum rounded the same way, so here it
* is taken once.  m_frexp normalizes an unnormalized argument a hex
* digit at a time, as f77math.c now does (it called itself forever).
*
* What gives a message goes to the C entries: DEXP past 174.673
* (M@DEXPC), DLOG and DLOG10 of zero or less (M@DLOGC, M@DLG10C),
* X**Y with X zero or negative or the power past the exponential's
* range (M@DPOWC), DSINH and DCOSH past 175.366 (M@DSINHC, M@DCOSHC).
*
* From C or Fortran: double DEXP(double), DLOG(double), DLOG10(double),
* DPOW(double, double), DSINH, DCOSH and DTANH(double), cc370's
* convention: R1 to the arguments, the result in FPR0, R2-R13 kept.
* The work areas are in the CSECT, as in f77xsum, and R13 a frame on
* the C stack, as a C function's.
*
* Registers: R12 the base; R2 the Sum an operation works on, R3 the
* long a product takes, R4 the power of two of an entry (XADDS,
* XADDMS); links R10 (XADDP, XADDM, XADDS, XADDMS, XRND, MHEX, FREXP),
* R11 (EXPF, EXPK, EXPADD, LOGT), R7 (DDIV, HYP); R8-R9 XRND's.
*
F77MEXP  CSECT
         USING F77MEXP,12            R12 the CSECT's, at each entry
*
* DEXP (f77c_exp, f77m_exp)
*
         ENTRY DEXP
DEXP     STM   14,12,12(13)
         USING DEXP,15
         L     12,=A(F77MEXP)
         DROP  15
         BAL   10,FRAME
         LD    0,0(,1)
         STD   0,TX
         CD    0,=D'1.746730804443359375E+2'
         BNL   EXC
         CD    0,=D'1.75E+2'
         BNH   E1
         LD    0,KHUGE
         B     RET
E1       SDR   2,2
         CD    0,=D'-1.8019999999999999928946E+2'
         BNL   E2
         LDR   0,2
         B     RET
E2       STD   2,TXL                 xl = 0
         BAL   11,EXPF
         LA    2,SACC
         BAL   10,XRND
         L     4,TQF
         BAL   10,MHEX
RET      L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
EXC      L     15,=V(M@DEXPC)        FORTLIB's message, in C
         B     TOC
TOC      L     13,4(,13)             the caller's registers, and C's
         L     14,12(,13)            entry, whose address R15 has
         LM    0,12,20(13)
         BR    15
*
* DLOG and DLOG10 (f77c_log, f77c_log10, f77m_log, f77m_log10)
*
         ENTRY DLOG
DLOG     STM   14,12,12(13)
         USING DLOG,15
         L     12,=A(F77MEXP)
         DROP  15
         BAL   10,FRAME
         LD    0,0(,1)
         LTDR  0,0
         BNP   LGC
         STD   0,TX
         BAL   11,LOGT
         LA    2,SACC
         BAL   10,XRND
         B     RET
LGC      L     15,=V(M@DLOGC)
         B     TOC
         ENTRY DLOG10
DLOG10   STM   14,12,12(13)
         USING DLOG10,15
         L     12,=A(F77MEXP)
         DROP  15
         BAL   10,FRAME
         LD    0,0(,1)
         LTDR  0,0
         BNP   LG10C
         STD   0,TX
         BAL   11,LOGT
         LA    2,SACC
         BAL   10,XRND               r and its residue, times 1/ln 10
         STD   0,TR                  in two parts
         MVC   TRS(8),TRES
         BAL   10,XZERO
         LD    0,TR
         LA    3,KRLN10
         BAL   10,XADDM
         LD    0,TR
         LA    3,KRLN10L
         BAL   10,XADDM
         LD    0,TRS
         LA    3,KRLN10
         BAL   10,XADDM
         BAL   10,XRND
         B     RET
LG10C    L     15,=V(M@DLG10C)
         B     TOC
*
* DPOW: x**y (f77c_pow's checks, f77m_pow)
*
         ENTRY DPOW
DPOW     STM   14,12,12(13)
         USING DPOW,15
         L     12,=A(F77MEXP)
         DROP  15
         BAL   10,FRAME
         LD    0,0(,1)
         LTDR  0,0
         BNP   PWC                   zero or negative: C
         STD   0,TX
         MVC   TY(8),8(1)
         BAL   11,LOGT               log x: lh, ll
         LA    2,SACC
         BAL   10,XRND
         STD   0,TLH
         MVC   TLL(8),TRES
* f77c_pow: y log x past EXP's limit is EXP's message
         LTDR  0,0
         BZ    PW1
         SR    15,15                 (y > 0) == (lx > 0)?
         LD    2,TY
         LTDR  2,2
         BNH   PC1
         LA    15,1
PC1      X     15,=F'1'
         SR    4,4
         LTDR  0,0
         BNH   PC2
         LA    4,1
PC2      CLR   15,4
         BE    PW1
         LD    2,TY
         LPDR  4,2                   ay
         LPDR  2,0                   al
         LD    0,=D'1.746730804443359375E+2'
         DDR   0,2
         CDR   0,4
         BH    PW1
         LD    0,=D'6.999999999999999987947E+75'
         DDR   0,2
         CDR   0,4
         BL    PWC                   ay al past the largest: C
         LDR   0,4
         MDR   0,2
         CD    0,=D'1.746730804443359375E+2'
         BNL   PWC
* f77m_pow
PW1      LD    0,=D'1.0E+0'          y = 0: 1
         LD    4,TY
         LTDR  4,4
         BZ    RET
         LD    2,TLH                 |y| > 1 and |lh| > 200/|y|: past
         LD    0,TY                  the exponential's range
         LTDR  0,0
         BNL   PW2
         CD    0,=D'-1.0E+0'
         BL    PW3
         B     PW5
PW2      CD    4,=D'1.0E+0'
         BNH   PW5
PW3      LPDR  4,2
         LD    0,TY
         LTDR  0,0
         BNL   PW4
         LD    0,=D'-2.0E+2'
         DD    0,TY
         CDR   4,0
         BH    PW6
         B     PW5
PW4      LD    0,=D'2.0E+2'
         DD    0,TY
         CDR   4,0
         BNH   PW5
PW6      SR    2,2                   (y < 0) == (lh < 0): the largest,
         LD    4,TY                  else zero
         LTDR  4,4
         BNL   PW7
         LA    2,1
PW7      X     2,=F'1'
         SR    3,3
         LD    0,TLH
         LTDR  0,0
         BNL   PW8
         LA    3,1
PW8      SDR   0,0
         CLR   2,3
         BE    RET
         LD    0,KHUGE
         B     RET
PW5      LA    2,SACC                y lh + y ll: xh, xl
         BAL   10,XZERO
         LD    0,TY
         LA    3,TLH
         BAL   10,XADDM
         LD    0,TY
         LA    3,TLL
         BAL   10,XADDM
         BAL   10,XRND
         CD    0,=D'1.75E+2'
         BNH   PW9
         LD    0,KHUGE
         B     RET
PW9      SDR   2,2
         CD    0,=D'-1.8019999999999999928946E+2'
         BNL   PW10
         LDR   0,2
         B     RET
PW10     STD   0,TX
         MVC   TXL(8),TRES
         BAL   11,EXPF
         LA    2,SACC
         BAL   10,XRND
         L     4,TQF
         BAL   10,MHEX
         B     RET
PWC      L     15,=V(M@DPOWC)
         B     TOC
*
* DSINH and DCOSH (f77c_sinh, f77c_cosh, f77m_sinh, f77m_cosh): past
* 175.366 FORTLIB's message, in C (M@DSINHC, M@DCOSHC); DSINH below
* 1/8 its series, else (exp a - 1/exp a)/2 with x's sign; DCOSH (exp a
* + 1/exp a)/2
*
         ENTRY DSINH
DSINH    STM   14,12,12(13)
         USING DSINH,15
         L     12,=A(F77MEXP)
         DROP  15
         BAL   10,FRAME
         LD    0,0(,1)
         STD   0,TX0
         CD    0,=D'-1.753662261962890625E+2'
         BNH   SHC
         CD    0,=D'1.753662261962890625E+2'
         BNL   SHC
         LPDR  0,0
         STD   0,TA
         CD    0,=D'1.76E+2'
         BNH   SH1
         LD    0,KHUGE
         B     SH9
SH1      CD    0,=D'1.25E-1'
         BNL   SH2
         LD    0,TX0                 x + x^3 p, the series to x^13
         MD    0,TX0
         STD   0,TX2
         LDR   2,0
         MD    2,=D'1.6059043836821614633333E-10'
         AD    2,=D'2.5052108385441718569505E-8'
         MDR   2,0
         AD    2,=D'2.7557319223985890393368E-6'
         MDR   2,0
         AD    2,=D'1.9841269841269841252632E-4'
         MDR   2,0
         AD    2,=D'8.3333333333333332176851E-3'
         MDR   2,0
         AD    2,=D'1.66666666666666671292596E-1'
         STD   2,TP2
         LA    2,SACC
         BAL   10,XZERO
         LD    0,TX0
         BAL   10,XADDP
         LD    0,TX2
         MD    0,TX0
         MD    0,TP2
         BAL   10,XADDP
         BAL   10,XRND
         B     RET
SH2      MVC   TSGN(8),=D'-1.0E+0'
         SR    4,4                   a corrected division below .8814
         LD    0,TA
         CD    0,=D'8.81400000000000002908784E-1'
         BNL   SH3
         LA    4,1
SH3      ST    4,TEX
         BAL   7,HYP
SH9      LD    2,TX0
         LTDR  2,2
         BNL   RET
         LCDR  0,0
         B     RET
SHC      L     15,=V(M@DSINHC)
         B     TOC
         ENTRY DCOSH
DCOSH    STM   14,12,12(13)
         USING DCOSH,15
         L     12,=A(F77MEXP)
         DROP  15
         BAL   10,FRAME
         LD    0,0(,1)
         CD    0,=D'-1.753662261962890625E+2'
         BNH   CHC
         CD    0,=D'1.753662261962890625E+2'
         BNL   CHC
         LPDR  0,0
         STD   0,TA
         CD    0,=D'1.76E+2'
         BNH   CH1
         LD    0,KHUGE
         B     RET
CH1      MVC   TSGN(8),=D'1.0E+0'
         MVC   TEX,=F'0'
         BAL   7,HYP
         B     RET
CHC      L     15,=V(M@DCOSHC)
         B     TOC
*
* DTANH (f77m_tanh, which has no check): past 22, 1; below 1/4096
* x - x^3/3 + 2x^5/15; else u = exp(2a) - 1 framed, u/(u + 2) by a
* corrected division, from 1.75 on 1 - 2/(u + 2); x's sign
*
         ENTRY DTANH
DTANH    STM   14,12,12(13)
         USING DTANH,15
         L     12,=A(F77MEXP)
         DROP  15
         BAL   10,FRAME
         LD    0,0(,1)
         STD   0,TX0
         LPDR  0,0
         STD   0,TA
         CD    0,=D'2.2E+1'
         BNH   TH1
         LD    0,=D'-1.0E+0'
         LD    4,TX0
         LTDR  4,4
         BL    RET
         LD    0,=D'1.0E+0'
         B     RET
TH1      CD    0,=D'2.44140625E-4'
         BNL   TH2
         LD    2,TX0                 the series
         MDR   2,2
         LD    0,TX0
         MDR   0,2
         MD    2,=D'1.33333333333333331482962E-1'
         AD    2,=D'-3.33333333333333328707404E-1'
         MDR   0,2
         STD   0,TP2
         LA    2,SACC
         BAL   10,XZERO
         LD    0,TX0
         BAL   10,XADDP
         LD    0,TP2
         BAL   10,XADDP
         BAL   10,XRND
         B     RET
TH2      MVC   TX(8),TA              exp(2a), framed
         MVC   TXL(8),=D'0.0'
         MVC   TSC,=F'1'
         BAL   11,EXPK
         LA    2,SACC
         BAL   10,XZERO
         L     5,TKE
         BAL   11,EXPADD
         MVC   TQU,TQF
         L     4,TQU
         SLL   4,2
         LCR   4,4
         ST    4,TSU                 -4q
         LD    0,TA
         CD    0,=D'1.75E+0'
         BL    TH4
         LA    2,SACC                1.75 on: + 1, dh + dl
         L     4,TSU
         LD    0,=D'1.0E+0'
         BAL   10,XADDS
         BAL   10,XRND
         L     4,TQU
         BAL   10,MHEX
         STD   0,TDH
         LD    0,TRES
         L     4,TQU
         BAL   10,MHEX
         STD   0,TDL
         LD    2,=D'2.0E+0'          q = 2/dh; 1 - q + q q dl 2^-1
         DD    2,TDH
         STD   2,TQ2
         LA    2,ECC
         BAL   10,XZERO
         LD    0,=D'1.0E+0'
         BAL   10,XADDP
         LD    0,TQ2
         LCDR  0,0
         BAL   10,XADDP
         LD    0,TQ2
         MD    0,TQ2
         MD    0,TDL
         L     4,=F'-1'
         BAL   10,XADDS
         BAL   10,XRND
         B     TH9
TH4      LA    2,SACC                below: u - 1, and u + 1 in two
         L     4,TSU
         LD    0,=D'-1.0E+0'
         BAL   10,XADDS
         MVC   ECC(16),SACC
         LA    2,ECC
         L     4,TSU
         LD    0,=D'2.0E+0'
         BAL   10,XADDS
         BAL   10,XRND
         L     4,TQU
         BAL   10,MHEX
         STD   0,TB
         LD    0,TRES
         L     4,TQU
         BAL   10,MHEX
         STD   0,TBL
         LA    2,SACC                (u - 1)/(u + 1), corrected
         MVC   TDQ,TQU
         BAL   7,DDIV
         LA    2,ECC
         BAL   10,XZERO
         LD    0,DQH
         BAL   10,XADDP
         LD    0,DQL
         BAL   10,XADDP
         BAL   10,XRND
TH9      LD    2,TX0
         LTDR  2,2
         BNL   RET
         LCDR  0,0
         B     RET
*
* HYP: (exp a + sg / exp a) / 2 (m_hyp): TA a, TSGN sg, TEX 1 for
* 1/exp a by a corrected division.  exp a's entries in two frames, k
* (exp a: eh + el) and k - 1 (its half: the sum); past 16^49 the half
* alone; else sg/exp a added to the half in its frame, 2^(-1 - 4q),
* and the half rounded.  The result in FPR0.  Return by R7, kept in
* THLINK across DDIV.
*
HYP      ST    7,THLINK
         MVC   TX(8),TA
         MVC   TXL(8),=D'0.0'
         MVC   TSC,=F'0'
         BAL   11,EXPK
         LA    2,SACC                exp a in k's frame
         BAL   10,XZERO
         L     5,TKE
         BAL   11,EXPADD
         MVC   TQE,TQF
         LA    2,TACC2               its half in k - 1's
         BAL   10,XZERO
         L     5,TKE
         BCTR  5,0
         BAL   11,EXPADD
         MVC   TQT,TQF
         LA    2,SACC                eh, el
         BAL   10,XRND
         L     4,TQE
         BAL   10,MHEX
         STD   0,TEH
         LD    0,TRES
         L     4,TQE
         BAL   10,MHEX
         STD   0,TEL
         L     4,TQT
         CH    4,=H'49'
         BNH   HY1
         LA    2,TACC2
         BAL   10,XRND
         L     4,TQT
         BAL   10,MHEX
         B     HYRET
HY1      SLL   4,2                   1/exp a's 2^s: -1 - 4q
         X     4,=F'-1'
         ST    4,TSN
         CLC   TEX,=F'0'
         BE    HY3
         LA    2,ECC                 1 / (eh + el), corrected
         BAL   10,XZERO
         LD    0,=D'1.0E+0'
         BAL   10,XADDP
         MVC   TB(8),TEH
         MVC   TBL(8),TEL
         MVC   TDQ,=F'0'
         BAL   7,DDIV
         LA    2,TACC2
         L     4,TSN
         LD    0,TSGN
         MD    0,DQH
         BAL   10,XADDS
         L     4,TSN
         LD    0,TSGN
         MD    0,DQL
         BAL   10,XADDS
         B     HY4
HY3      LD    0,=D'1.0E+0'          qh = 1/eh, and -sg qh qh el
         DD    0,TEH
         STD   0,DQH
         LA    2,TACC2
         L     4,TSN
         LD    0,TSGN
         MD    0,DQH
         BAL   10,XADDS
         LD    0,TSGN
         LCDR  2,0
         LD    0,DQH
         MD    0,DQH
         MD    0,TEL
         MDR   2,0
         LDR   0,2
         L     4,TSN
         BAL   10,XADDS
HY4      LA    2,TACC2
         BAL   10,XRND
         L     4,TQT
         BAL   10,MHEX
HYRET    L     7,THLINK
         BR    7
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
* EXPF: exp(TX + TXL) into SACC from zero in k's frame (m_exp_terms
* with sc 0, sum_frame): EXPK and EXPADD.  Return by R11.
*
EXPF     ST    11,TFLINK
         MVC   TSC,=F'0'
         BAL   11,EXPK
         LA    2,SACC
         BAL   10,XZERO
         L     5,TKE
         BAL   11,EXPADD
         L     11,TFLINK
         BR    11
*
* EXPK: m_exp_terms' values for exp(TX + TXL), TSC its sc (0, or 1
* for exp(2x)): k the nearest whole number to x/ln 2 (2x/ln 2) in TKE;
* h = x - k ln2_hi (ln2_hi/2), exact; rl = xl - k ln2_lo; r = h + rl
* (2h + rl); the series' p.  Return by R11.
*
EXPK     LD    4,TX
         LDR   2,4                   k = (int)(x/ln 2 +- 1/2)
         MD    2,KRLN2
         CLC   TSC,=F'0'
         BE    EK0
         ADR   2,2
EK0      LTDR  2,2
         BNL   EX1
         SD    2,=D'5.0E-1'
         B     EX2
EX1      AD    2,=D'5.0E-1'
EX2      LDR   0,2
         AD    0,=XL8'4F08000000000000'
         STD   0,TT
         L     5,TT+4                k
         ST    5,TKE
         BAL   10,KDBL
         CLC   TSC,=F'0'
         BE    EK1
         MD    0,KLN2HH
         B     EK2
EK1      MD    0,KLN2HI
EK2      SDR   4,0                   h
         STD   4,TH
         BAL   10,KDBL
         MD    0,KLN2LO
         LD    2,TXL
         SDR   2,0                   rl
         STD   2,TRL
         LDR   6,4                   r
         CLC   TSC,=F'0'
         BE    EK3
         ADR   6,4
EK3      ADR   6,2
         STD   6,TRR
         LDR   2,6                   p
         MD    2,=D'1.6059043836821614633333E-10'
         AD    2,=D'2.0876756987868099152579E-9'
         MDR   2,6
         AD    2,=D'2.5052108385441718569505E-8'
         MDR   2,6
         AD    2,=D'2.7557319223985890922764E-7'
         MDR   2,6
         AD    2,=D'2.7557319223985890393368E-6'
         MDR   2,6
         AD    2,=D'2.480158730158730156579E-5'
         MDR   2,6
         AD    2,=D'1.9841269841269841252632E-4'
         MDR   2,6
         AD    2,=D'1.3888888888888888876842E-3'
         MDR   2,6
         AD    2,=D'8.3333333333333332176851E-3'
         MDR   2,6
         AD    2,=D'4.1666666666666666955787E-2'
         MDR   2,6
         AD    2,=D'1.66666666666666671292596E-1'
         STD   2,TP
         BR    11
*
* EXPADD: EXPK's entries added to the Sum R2 names in the frame R5
* (sum_frame): f mod 4 into each entry's power of two, TQF = (f - f
* mod 4)/4 the sum's 16^q.  The entries 1, h 2^sc, rl (1 + r), h h
* 2^(2sc - 1) and r^3 p.  Return by R11.
*
EXPADD   LR    4,5
         N     4,=F'3'
         ST    4,TRF
         LR    6,5
         SR    6,4
         SRA   6,2
         ST    6,TQF
         L     4,TRF
         LD    0,=D'1.0E+0'
         BAL   10,XADDS
         L     4,TRF
         A     4,TSC
         LD    0,TH
         BAL   10,XADDS
         L     4,TRF
         LD    0,TRR                 rl (r + 1)
         AD    0,=D'1.0E+0'
         STD   0,TT
         LD    0,TRL
         MD    0,TT
         BAL   10,XADDS
         L     4,TSC                 h h 2^(2sc - 1)
         AR    4,4
         BCTR  4,0
         A     4,TRF
         LD    0,TH
         LA    3,TH
         BAL   10,XADDMS
         L     4,TRF
         LD    0,TRR                 r^3 p
         MD    0,TRR
         MD    0,TRR
         MD    0,TP
         BAL   10,XADDS
         BR    11
*
* DDIV: (the Sum R2 names, in its frame TDQ) / (TB + TBL) as DQH +
* DQL (m_ddiv): the quotient of its rounding, then the remainder's,
* the products in the frame.  Return by R7.
*
DDIV     BAL   10,XRND
         L     4,TDQ
         BAL   10,MHEX
         DD    0,TB
         STD   0,DQH
         L     4,TDQ
         SLL   4,2
         LCR   4,4
         ST    4,TDS                 -4q
         LD    0,DQH
         LCDR  0,0
         LA    3,TB
         BAL   10,XADDMS
         L     4,TDS
         LD    0,DQH
         LCDR  0,0
         LA    3,TBL
         BAL   10,XADDMS
         BAL   10,XRND
         L     4,TDQ
         BAL   10,MHEX
         DD    0,TB
         STD   0,DQL
         BR    7
*
* KDBL: R5 as a double in FPR0, as cc370 converts.  Return by R10.
KDBL     MVC   TT(4),=XL4'4E000000'
         ST    5,TT+4
         XI    TT+4,128
         LD    0,TT
         SD    0,=XL8'4E00000080000000'
         BR    10
*
* LOGT: log TX into SACC from zero (m_log_terms): x = m 2^e, m in
* [0.5, 1); k the nearest whole number to 64/m, inv = k/64; f = m inv
* - 1 in two parts, fh from m's first seven hex digits; the entries
* e ln2_hi - log(k/64)'s first part, e ln2_lo and its second, fh,
* fl, -fh fh 2^-1, -fh fl, -fl fl 2^-1 and f^3 p.  Return by R11.
*
LOGT     BAL   10,FREXP              m in FPR0, e in TE
         LDR   6,0
         STD   0,TM
         LD    2,=D'6.4E+1'          k = (int)(64/m + 1/2), inv = k/64
         DDR   2,0
         AD    2,=D'5.0E-1'
         LDR   0,2
         AD    0,=XL8'4F08000000000000'
         STD   0,TT
         L     5,TT+4
         ST    5,TK
         BAL   10,KDBL
         MD    0,=D'1.5625E-2'       inv
         MVC   TT(8),TM              mh: m's first seven hex digits
         NI    TT+4,X'F0'
         XC    TT+5(3),TT+5
         LD    2,TT
         LD    4,TT
         MDR   4,0                   fh = mh inv - 1
         SD    4,=D'1.0E+0'
         STD   4,TFH
         SDR   6,2                   fl = (m - mh) inv
         MDR   6,0
         STD   6,TFL
         ADR   4,6                   f
         STD   4,TF
         LDR   2,4                   p
         MD    2,=D'9.09090909090909116141432E-2'
         SD    2,=D'1.00000000000000005551115E-1'
         MDR   2,4
         AD    2,=D'1.11111111111111104943205E-1'
         MDR   2,4
         SD    2,=D'1.25E-1'
         MDR   2,4
         AD    2,=D'1.4285714285714286309048E-1'
         MDR   2,4
         SD    2,=D'1.66666666666666671292596E-1'
         MDR   2,4
         AD    2,=D'1.99999999999999997224442E-1'
         MDR   2,4
         SD    2,=D'2.5E-1'
         MDR   2,4
         AD    2,=D'3.33333333333333328707404E-1'
         STD   2,TP
         LA    2,SACC
         BAL   10,XZERO
         L     5,TE                  e ln2_hi + log(k/64)'s first part
         BAL   10,KDBL
         MD    0,KLN2HI
         L     3,TK
         SLL   3,4
         LA    3,KLOGT-1024(3)
         AD    0,0(,3)
         BAL   10,XADDP
         L     5,TE                  e ln2_lo + its second
         BAL   10,KDBL
         MD    0,KLN2LO
         L     3,TK
         SLL   3,4
         LA    3,KLOGT-1016(3)
         AD    0,0(,3)
         BAL   10,XADDP
         LD    0,TFH
         BAL   10,XADDP
         LD    0,TFL
         BAL   10,XADDP
         L     4,=F'-1'              -fh fh 2^-1
         LD    0,TFH
         LCDR  0,0
         LA    3,TFH
         BAL   10,XADDMS
         LD    0,TFH                 -fh fl
         LCDR  0,0
         LA    3,TFL
         BAL   10,XADDM
         L     4,=F'-1'              -fl fl 2^-1
         LD    0,TFL
         LCDR  0,0
         LA    3,TFL
         BAL   10,XADDMS
         LD    0,TF                  f^3 p
         MD    0,TF
         MD    0,TF
         MD    0,TP
         BAL   10,XADDP
         BR    11
*
* FREXP: TX = m 2^e, m in [0.5, 1), into FPR0 and TE (m_frexp; TX
* not zero).  Return by R10.
*
FREXP    LM    4,5,TX
         LR    6,4                   e = 4 (char - 64)
         SRL   6,24
         N     6,=F'127'
         S     6,=F'64'
         SLL   6,2
         N     4,=X'80FFFFFF'        m16 in [1/16, 1)
         O     4,=X'40000000'
FR1      LR    7,4                   the leading hex digit
         SRL   7,20
         N     7,=F'15'
         BNZ   FR2
         LR    8,4                   none: a digit at a time
         N     8,=X'FF000000'
         SLL   4,4
         N     4,=X'00FFFFFF'
         OR    4,8
         LR    8,5
         SRL   8,28
         OR    4,8
         SLL   5,4
         S     6,=F'4'
         B     FR1
FR2      ST    6,TE
         STM   4,5,TT
         LD    0,TT
         CH    7,=H'7'
         BHR   10
         CH    7,=H'3'
         BNH   FR3
         S     6,=F'1'
         ST    6,TE
         ADR   0,0
         BR    10
FR3      CH    7,=H'1'
         BNH   FR4
         S     6,=F'2'
         ST    6,TE
         MD    0,=D'4.0E+0'
         BR    10
FR4      S     6,=F'3'
         ST    6,TE
         MD    0,=D'8.0E+0'
         BR    10
*
* MHEX: FPR0 times 16^R4, exactly, or the largest magnitude, or zero
* (m_hex).  Return by R10.
*
MHEX     LTR   4,4
         BZR   10
         LTDR  0,0
         BZR   10
         STD   0,TT
         SR    5,5
         IC    5,TT
         LR    6,5
         N     5,=F'127'             the characteristic
         N     6,=F'128'             and the sign
         AR    5,4
         CH    5,=H'127'
         BH    MH1
         LTR   5,5
         BM    MH2
         OR    5,6
         STC   5,TT
         LD    0,TT
         BR    10
MH1      LD    0,KHUGE               the largest, with the sign
         LTR   6,6
         BZR   10
         LCDR  0,0
         BR    10
MH2      SDR   0,0
         BR    10
*
* XZERO: the Sum R2 names to zero.  XADDP: FPR0 added to it, an entry
* a.  XADDM: FPR0 times the long R3 names, an entry a b.  XADDS: FPR0
* by 2^R4, an entry a 2^s (by MXD when s is not zero, as M@XSUM).
* XADDMS: FPR0 times the long R3 names, by 2^R4, an entry a b 2^s (by
* MXR when s is not zero, as M@XSUM).  Return by R10.
*
XZERO    SDR   0,0
         STD   0,0(,2)
         STD   0,8(,2)
         BR    10
XADDS    LTR   4,4
         BZ    XADDP
         BAL   9,XMKCON
         MXD   0,TCON
         B     XADD
XADDP    SDR   2,2
         B     XADD
XADDMS   MXD   0,0(,3)
         LTR   4,4
         BZ    XADD
         BAL   9,XMKCON
         LD    4,TCON
         SDR   6,6
         MXR   0,4
         B     XADD
XADDM    MXD   0,0(,3)
XADD     LD    4,0(,2)
         LD    6,8(,2)
         AXR   4,0
         STD   4,0(,2)
         STD   6,8(,2)
         BR    10
* XMKCON: TCON = 2^s, s in R4, as M@XSUM makes it (R6, R8, R9 used,
* not R7, DDIV's link; return by R9; TCON's second word stays zero)
XMKCON   LR    8,4
         SRA   8,2                   q = floor(s/4)
         LR    6,4
         N     6,=F'3'               r = s - 4q
         ST    9,TLINK
         LA    9,X'10'
         SLL   9,0(6)                the fraction's first byte, 2^r/16
         SLL   9,16
         A     8,=F'65'              the characteristic, 16^(q+1)
         SLL   8,24
         OR    8,9
         ST    8,TCON
         L     9,TLINK
         BR    9
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
         ST    8,TRCON
         LD    0,TRCON
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
SACC     DS    2D                    the Sums
TACC2    DS    2D
ECC      DS    2D
TACC     DS    2D                    XRND's
TX       DS    D                     the argument, or exp's x
TXL      DS    D                     and its second part
TY       DS    D                     DPOW's y
TLH      DS    D                     log x in two parts
TLL      DS    D
TR       DS    D                     DLOG10's log and its residue
TRS      DS    D
TH       DS    D                     EXPK's h, rl, r
TRL      DS    D
TRR      DS    D
TP       DS    D                     a series' value
TM       DS    D                     LOGT's m, fh, fl, f
TFH      DS    D
TFL      DS    D
TF       DS    D
TT       DS    D                     conversions
TX0      DS    D                     the hyperbolics' argument
TA       DS    D                     and |x|
TX2      DS    D
TP2      DS    D
TSGN     DS    D                     HYP's sign of 1/exp a
TEH      DS    D                     exp a in two parts
TEL      DS    D
TB       DS    D                     DDIV's divisor in two parts
TBL      DS    D
DQH      DS    D                     its quotient in two parts
DQL      DS    D
TDH      DS    D
TDL      DS    D
TQ2      DS    D
TOUT     DS    D
TRES     DS    D
TCON     DC    F'0',F'0'             2^s
TRCON    DC    F'0',F'0'             half a unit
TE       DS    F                     m_frexp's e
TK       DS    F                     LOGT's k
TLINK    DS    F
TSC      DS    F                     EXPK's sc
TKE      DS    F                     its k
TRF      DS    F                     EXPADD's 2^(f mod 4)
TQF      DS    F                     and 16^q
TFLINK   DS    F
THLINK   DS    F
TDQ      DS    F                     DDIV's frame, and its -4q
TDS      DS    F
TQE      DS    F                     HYP's frames: exp a's
TQT      DS    F                     and its half's
TSN      DS    F                     1/exp a's 2^s there
TEX      DS    F                     HYP: the corrected division
TQU      DS    F                     DTANH's frame, and its -4q
TSU      DS    F
         DS    0D
KHUGE    DC    X'7FFFFFFFFFFFFFFF'
KRLN2    DC    X'41171547652B82FE'   1/ln 2
KLN2HI   DC    X'40B17217F7D00000'   ln 2: its first 36 bits
KLN2LO   DC    X'371CF79ABC9E3B39'   and the rest
KLN2HH   DC    X'4058B90BFBE80000'   ln2_hi/2
KRLN10   DC    X'406F2DEC549B9438'   1/ln 10
KRLN10L  DC    X'32CA9AADD557D69A'   and the rest
* -log(k/64), k = 64..128, in two parts (f77math.c's)
KLOGT    DC    X'0000000000000000',X'0000000000000000'
         DC    X'BF3F815161000000',X'B7F807C79F3DB4EA'
         DC    X'BF7E0A6C39000000',X'B7E0CC0133E3F04F'
         DC    X'BFBBA2C7B1000000',X'B796E7E231A7950F'
         DC    X'BFF8518600000000',X'B78B15330BE64B8B'
         DC    X'C01341D796100000',X'B7BD1D0929983761'
         DC    X'C016F0D28AE00000',X'B756B4B9BE499B9F'
         DC    X'C01A926D3A400000',X'B7AD563650BD22AA'
         DC    X'C01E27076E200000',X'B7AF2E5E9EA87FFE'
         DC    X'C021AEFCF9A00000',X'B711CB2CD2EE2F48'
         DC    X'C0252AA5F0300000',X'B7FEA46980BB8E20'
         DC    X'C0289A56D9900000',X'B76FA3CCFA7B2A1F'
         DC    X'C02BFE60E1400000',X'B7F27A790E7C4141'
         DC    X'C02F571204200000',X'B71B21237C6D65AD'
         DC    X'C032A4B539E00000',X'B78AD68EC8260EA7'
         DC    X'C035E7929D000000',X'B717FE5B19CC0327'
         DC    X'C0391FEF8F300000',X'B753443584BB03DE'
         DC    X'C03C4E0EDC500000',X'B75E5CBD3D50FFFC'
         DC    X'C03F7230DAB00000',X'B7C7C551AAA8CD87'
         DC    X'C0428C9389C00000',X'B7E438D7DCFDE806'
         DC    X'C0459D72AEA00000',X'B7E98380E731F55C'
         DC    X'C048A507EF300000',X'B7DE596890A14F6A'
         DC    X'C04BA38AEB800000',X'B7474C270B3246A1'
         DC    X'C04E993155A00000',X'B7517A71CBCD735D'
         DC    X'C051862F08700000',X'B717B09F42DECDED'
         DC    X'C0546AB61CB00000',X'B77E0B42724F5834'
         DC    X'C05746F6FD600000',X'B627294236383DC8'
         DC    X'C05A1B207A600000',X'B7C52BB110AF8405'
         DC    X'C05CE75FDAE00000',X'B7F401A7389314FF'
         DC    X'C05FABE0EE000000',X'B7ABF0D92CE979ED'
         DC    X'C06268CE1B000000',X'B75096AD69C62044'
         DC    X'C0651E5070800000',X'B745BEAE9337451F'
         DC    X'C067CC8FB2F00000',X'B7E612FCADA35D9C'
         DC    X'C06A73B26A600000',X'B78212635213FD4C'
         DC    X'C06D13DDEF300000',X'B723D8A32FBB6ABA'
         DC    X'C06FAD3676900000',X'B7C6DEFDE1874DEB'
         DC    X'C0723FDF1E600000',X'B7A6886B097607BD'
         DC    X'C074CBF9F8000000',X'B73AF55877B232FB'
         DC    X'C07751A813000000',X'B771282FB989A927'
         DC    X'C079D10987500000',X'B7A1E1F8DF68DBCF'
         DC    X'C07C4A3D7EB00000',X'B7C1BB2CD720EC45'
         DC    X'C07EBD623DE00000',X'B73CC7B66BECF93B'
         DC    X'C0812A952D200000',X'B7E87F634E34AEBF'
         DC    X'C08391F2E0E00000',X'B76FA0272BCB1C49'
         DC    X'C085F39721200000',X'B795415B4C4BDD9A'
         DC    X'C0884F9CF1600000',X'B7A64B7EF1F64D86'
         DC    X'C08AA61E97A00000',X'B76AF4D4C799D1CB'
         DC    X'C08CF735A3300000',X'B7E4B7662E5EEBBC'
         DC    X'C08F42FAF3800000',X'B720681EF62CD2FA'
         DC    X'C0918986BDF00000',X'B75FA1416F1B4391'
         DC    X'C093CAF094400000',X'B7D88D75BC1F9EDD'
         DC    X'C096074F6A200000',X'B74745DCBD4E18DD'
         DC    X'C0983EB99A700000',X'B7885F0FDAC850FB'
         DC    X'C09A7144ECE00000',X'B770E98B75C96C43'
         DC    X'C09C9F069AB00000',X'B7150CD4E221301B'
         DC    X'C09EC81353800000',X'B7AB7D5202131E85'
         DC    X'C0A0EC7F42300000',X'B7395732325E617A'
         DC    X'C0A30C5E10E00000',X'B72F613E85BD9BDA'
         DC    X'C0A527C2ED800000',X'B71F5D8113DFA3D3'
         DC    X'C0A73EC08DB00000',X'B7ADD84E584C2B23'
         DC    X'C0A9516932D00000',X'B7E2D5773BE4578B'
         DC    X'C0AB5FCEAD900000',X'B7F9CCA08E310B9B'
         DC    X'C0AD6A0261A00000',X'B7CF967D94D552F8'
         DC    X'C0AF701549200000',X'B6B3AB86B04AFE92'
         DC    X'C0B17217F7D00000',X'B71CF79ABC9E3B39'
         END
