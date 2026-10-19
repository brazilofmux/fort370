C     ** with an INTEGER exponent near the ends of the range.  A
C     negative exponent is 1/X**N, and X**N may be too large to hold
C     when 1/X**N is not too small: 16.0**(-65), the smallest HFP
C     number, overflowed computing 16.0**65 (an S0CC in MINOS, Rene
C     Ferland, 2026-10-19).  And the last squaring, which no bit of the
C     exponent used, overflowed 16.0**62.  Each value is printed as
C     its bits, through an INTEGER that shares its storage.
      PROGRAM POWOVF
      REAL R
      DOUBLE PRECISION D
      INTEGER IR, ID(2), N, M, K
      EQUIVALENCE (R, IR), (D, ID(1))
      N = -65
      M = 62
      K = -258
      R = 16.0**N
      WRITE (6, 100) 'R 16**-65', IR
      D = 16.0D0**N
      WRITE (6, 100) 'D 16**-65', ID
      R = 16.0**M
      WRITE (6, 100) 'R 16**62 ', IR
      D = 16.0D0**M
      WRITE (6, 100) 'D 16**62 ', ID
      R = 2.0**K
      WRITE (6, 100) 'R 2**-258', IR
      D = 0.5D0**(-M)
      WRITE (6, 100) 'D .5**-62', ID
C     an ordinary one, 1/3**7 still
      R = 3.0**(-7)
      WRITE (6, 101) 'R 3**-7  ', R, IR
      K = 19
      WRITE (6, 100) 'I 3**19  ', 3**K
  100 FORMAT (' >', A, 2I12)
  101 FORMAT (' >', A, E14.7, I12)
      END
