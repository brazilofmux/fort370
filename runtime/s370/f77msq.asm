*
* f77msq -- DSQRT in assembler (issue #3): f77math.c's square root,
* correctly rounded, without its three C calls.  The same steps, so
* the same root, which being correctly rounded is the only one:
*   x = F 16^e, F the 56-bit fraction, normalized a hex digit at a
*   time as integers (never by AD, which could underflow);
*   f = F 2^-56 for e even, F 2^-60 for e odd (e then e + 1), so
*   that sqrt(f) is in [1/16, 1) and its exponent is e/2;
*   an estimate within 0.9% from a line for each leading hex digit,
*   three Newton steps y = (y + f/y)/2 and a last as a correction;
*   then whole numbers settle it: the root's 56 bits R are those with
*   (2R-1)^2 < 4 F 2^k < (2R+1)^2, tested in the low 64 bits, where
*   the two sides differ while R is within a few units (m_sqrt_low).
*
* From C or Fortran: double DSQRT(double), cc370's convention: R1 to
* the argument, the root in FPR0, R2-R13 kept.  Zero gives zero; a
* negative argument goes to the C entry M@DSQRN, which gives FORTLIB's
* message and takes the root of its magnitude.  Nothing else here
* calls anything; the work areas are in the CSECT, as in f77xsum.
*
DSQRT    CSECT
         STM   14,12,12(13)
         BALR  12,0
         USING *,12
         LD    0,0(,1)
         LTDR  0,0
         BZ    SZERO
         BM    SNEG
         STD   0,SW
         LM    2,3,SW                R2:R3 the argument's words
         LR    15,2
         SRL   15,24                 its characteristic, e + 64
         N     2,=X'00FFFFFF'        R2:R3 the 56-bit fraction F
SNORM    LR    4,2                   normalized: a leading hex digit
         SRL   4,20
         LTR   4,4
         BNZ   SNORMD
         SLDL  2,4
         BCTR  15,0
         B     SNORM
SNORMD   STC   15,SW                 g = F 2^-56, for the estimate
         LR    6,2
         O     6,=X'40000000'
         ST    6,GW
         ST    3,GW+4
         LR    0,3                   n4h: 4 F 2^k mod 2^64, high
         TM    SW,X'01'              e odd: f = F 2^-60, and e + 1
         BZ    SEVEN
         AH    15,=H'1'
         O     2,=X'3F000000'
         ST    2,FW
         ST    3,FW+4
         N     0,=X'000003FF'
         SLL   0,22
         B     SEST
SEVEN    MVC   FW(8),GW              e even: f = g
         N     0,=X'0000003F'
         SLL   0,26
SEST     SLL   4,4                   the leading digit, by 16: a and b
         LD    4,STAB-16+8(4)        y = a + b g
         MD    4,GW
         AD    4,STAB-16(4)
         TM    SW,X'01'
         BZ    SNEWT
         MD    4,QUART               sqrt(f) = sqrt(g)/4 for e odd
SNEWT    LD    2,FW
         LA    5,3
SNLOOP   LDR   6,2                   y = (y + f/y)/2, three times
         DDR   6,4
         ADR   6,4
         HDR   4,6
         BCT   5,SNLOOP
         LDR   6,2                   y = y + (f/y - y)/2
         DDR   6,4
         SDR   6,4
         HDR   6,6
         ADR   4,6
         STD   4,YW                  R: y's 56 bits, in [1/16, 1)
         LM    4,5,YW
         LR    6,4
         SRL   6,24
         N     4,=X'00FFFFFF'
         CH    6,=H'65'
         BL    SUNDER
         L     4,=X'00FFFFFF'        rounded up to 1: the largest below
         L     5,=F'-1'
         B     SUP
SUNDER   CH    6,=H'64'
         BNL   SUP
         SRDL  4,4                   below 1/16: a digit at a time
         LA    6,1(,6)
         B     SUNDER
SUP      LR    6,4                   up while (2R + 1)^2 < 4N
         LR    7,5
         BAL   14,SLOW
         BNM   SDOWN
         AL    5,=F'1'
         BC    12,SUP
         AL    4,=F'1'
         B     SUP
SDOWN    LR    2,4                   down while (2R - 1)^2 is over it
         LR    3,5
         SL    3,=F'1'
         BC    11,SDOWN1
         BCTR  2,0
SDOWN1   LR    6,2
         LR    7,3
         BAL   14,SLOW
         BM    SDONE
         LR    4,2
         LR    5,3
         B     SDOWN
SDONE    S     15,=F'64'             the root's char, 64 + e/2
         SRA   15,1
         A     15,=F'64'
         SLL   15,24
         OR    4,15
         STM   4,5,RW
         LD    0,RW
SRET     L     14,12(,13)
         LM    2,12,28(13)
         BR    14
SZERO    SDR   0,0
         B     SRET
SNEG     L     15,=V(M@DSQRN)        FORTLIB's message, in C: its
         L     14,12(,13)            address while R12 is still ours,
         LM    0,12,20(13)           then the caller's registers
         BR    15
*
* SLOW: whether (2R + 1)^2 < 4N, R in R6:R7 and the high word of 4N
* mod 2^64 in R0 (its low word is zero): the condition code minus if
* so.  S = 2R + 1; S^2 mod 2^64 = sl^2 + 2 sh sl 2^32, of sl^2 only the
* high word, unsigned: MR's signed one plus 2 sl when sl is negative.
* R6-R11 are used.
*
SLOW     SLDL  6,1
         O     7,=F'1'
         LR    9,7
         MR    8,7                   sl^2, signed
         LTR   7,7
         BNM   SLOW1
         AR    8,7                   unsigned: + 2 sl 2^32
         AR    8,7
SLOW1    LR    11,6
         MR    10,7                  sh sl, its low word in R11
         SLL   11,1
         AR    8,11
         SR    8,0
         LTR   8,8
         BR    14
*
         LTORG
         DS    0D
SW       DS    D                     the argument; then its char
GW       DS    D                     g
FW       DS    D                     f
YW       DS    D                     the estimate
RW       DS    D                     the root
QUART    DC    X'4040000000000000'   0.25
* y = a + b g on [d/16, (d+1)/16), d the leading hex digit 1-F: a
* line within 0.9% of sqrt there
STAB     DC    X'40260F1200000000',X'411A827900000000'   1
         DC    X'4032155700000000',X'4114577200000000'   2
         DC    X'403B8F1400000000',X'4111261400000000'   3
         DC    X'4043ABFD00000000',X'40F1BBCD00000000'   4
         DC    X'404AE42200000000',X'40DA8B3C00000000'   5
         DC    X'405176A000000000',X'40C8F8CA00000000'   6
         DC    X'405789C000000000',X'40BB0F5E00000000'   7
         DC    X'405D36E400000000',X'40AFB0CC00000000'   8
         DC    X'40628FEF00000000',X'40A62C1D00000000'   9
         DC    X'4067A20D00000000',X'409E0D2C00000000'   A
         DC    X'406C774900000000',X'4097042A00000000'   B
         DC    X'4071178000000000',X'4090D82E00000000'   C
         DC    X'4075890000000000',X'408B5F6600000000'   D
         DC    X'4079D0EE00000000',X'40867A4F00000000'   E
         DC    X'407DF38B00000000',X'408210A700000000'   F
         END
