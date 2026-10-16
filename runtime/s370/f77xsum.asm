*
* f77xsum -- M@XSUM, the one sum f77math.c's functions round at
* their end, in the extended floating point that C cannot reach
* (cc370's long double is a double).  The sum is of entries a b 2^s:
* a plain term (b = 1) is a itself, or a times 2^s by MXD; a product
* MXD forms exactly, 28 hex digits, and MXR takes it by 2^s when s is
* not zero (exact but where the product used all 28 digits); AXR adds
* each in, its guard digit and truncation 28 digits down, far below
* the 14 kept.  The rounding is an AXR of half a unit in the 14th
* digit, the high part then kept: LRDR would do it in one, but
* Hercules (4.x, 2020 and since) rounds there by the low part's
* characteristic bit.
*
* From C: double m_xsum(Sum *t, double *res) -- R1 to the two
* words, the result in FPR0, R2-R13 kept; *res, when res is not
* null, gets what the rounding left, as a long cut from extended.
* The Sum's layout is f77math.c's (SN 20): a[] at 0, b[] at 160,
* s[] at 320, n at 400.  Nothing here calls anything; the work areas
* are in the CSECT, as in f77ishim.
*
M@XSUM   CSECT
         STM   14,12,12(13)
         BALR  12,0
         USING *,12
         L     2,0(,1)               the Sum
         L     3,4(,1)               where the residual goes, or 0
         SDR   4,4                   the sum, in FPR4:6 throughout
         SDR   6,6
         L     4,400(,2)             n
         LTR   4,4
         BNP   XZERO
         LR    5,2                   a[i] (b[i] 160 on)
         LA    7,320(,2)             s[i]
XLOOP    L     6,0(,7)               s
         LD    0,0(,5)               a
         CLC   160(8,5),XONE
         BNE   XPROD
         LTR   6,6                   a plain term, b = 1:
         BNZ   XPSC
         SDR   2,2                   a itself, extended
         B     XADD
XPSC     BAL   10,XMKCON             or a 2^s, exactly, by MXD
         MXD   0,XCON
         B     XADD
XPROD    MXD   0,160(,5)             a b, exactly, into FPR0:2
         LTR   6,6
         BZ    XADD
         BAL   10,XMKCON
         STD   4,XACC                the sum aside while MXR has 4:6
         STD   6,XACC+8
         LD    4,XCON                2^s; its low word is zero
         SDR   6,6
         MXR   0,4
         LD    4,XACC
         LD    6,XACC+8
XADD     AXR   4,0
         LA    5,8(,5)
         LA    7,4(,7)
         BCT   4,XLOOP
         STD   4,XACC
         STD   6,XACC+8
         LD    4,XACC
         LD    6,XACC+8
         LTDR  4,4
         BZ    XZERO
         SR    8,8
         IC    8,XACC                sign and characteristic
         LR    9,8
         N     8,=F'127'
         N     9,=F'128'
         S     8,=F'14'              half a unit: 8 in the 15th digit
         BM    XKEEP                 (below 16^-50: cut, not rounded)
         OR    8,9
         SLL   8,24
         O     8,=X'00800000'
         ST    8,XCON
         LD    0,XCON
         SDR   2,2
         AXR   4,0                   rounded; the high part is it
XKEEP    STD   4,XRES
         LTR   3,3
         BZ    XRET
         LD    4,XACC
         LD    6,XACC+8
         LD    0,XRES
         SDR   2,2
         SXR   4,0                   what the rounding left
         STD   4,0(,3)
XRET     LD    0,XRES
         LM    14,12,12(13)
         BR    14
* XCON = 2^s, s in R6 (R6, R8, R9 used; return by R10)
XMKCON   LR    8,6
         SRA   8,2                   q = floor(s/4)
         N     6,=F'3'               r = s - 4q
         LA    9,X'10'
         SLL   9,0(6)                the fraction's first byte, 2^r/16
         SLL   9,16
         A     8,=F'65'              the characteristic, 16^(q+1)
         SLL   8,24
         OR    8,9
         ST    8,XCON
         BR    10
XZERO    SDR   0,0
         LTR   3,3
         BZ    XZRET
         STD   0,0(,3)
XZRET    LM    14,12,12(13)
         BR    14
         LTORG
         DS    0D
XACC     DS    2D
XCON     DC    F'0',F'0'
XONE     DC    X'4110000000000000'   1.0
XRES     DS    D
         END
