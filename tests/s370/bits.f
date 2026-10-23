C     MIL-STD-1753's bit functions (2.6), in line: on constants, on
C     arguments the compiler cannot see, and MVBITS.  Bit 0 is the
C     rightmost; a negative shift count shifts right, ISHFTC rotates
C     the rightmost IC bits.  The expected lines:
C       >C            2           7           5          -7          48
C       >C           15           3 -2147483642           4
C       >L  T F T
C       >V            6           3           3          48           6
C       >V           -4         -28          32          15         -49
C       >V            6          -1           3           3           3
C       >V           -4           3          32         -32         -25
C       >V    305419896          -8          16     1193046   305428566
C       >V    305419896           4           8   591751040   305419911
C       >V           -1          31          32 -2147483648          -1
C       >V           -1         -31          32           1          -1
C       >V            1           0           1           1           1
C       >M    305419896       22136      -65536   108003328
      PROGRAM BITS
      INTEGER MS(9), KS(9), ICS(9), I, N, M
      LOGICAL L1, L2
      DATA MS /6, -4, 6, -4, Z12345678, Z12345678, -1, -1, 1/
      DATA KS /3, -28, -1, 3, -8, 4, 31, -31, 0/
      DATA ICS /3, 32, 3, 32, 16, 8, 32, 32, 1/, M /Z12345678/
      WRITE (6, 1) IAND(6, 3), IOR(6, 3), IEOR(6, 3), NOT(6),
     1   ISHFT(6, 3), ISHFT(-4, -28), IBITS(-4, 30, 2), IBSET(6, 31),
     2   IBCLR(6, 1)
    1 FORMAT (' >C ', 5I12)
      L1 = BTEST(6, 2)
      L2 = BTEST(6, 0)
      WRITE (6, 2) L1, L2, BTEST(-1, 31)
    2 FORMAT (' >L ', 3L2)
      DO 10 I = 1, 9
      CALL SHIFTS(MS(I), KS(I), ICS(I))
   10 CONTINUE
      N = 0
      CALL MVBITS(M, 0, 16, N, 0)
      I = -1
      CALL MVBITS(N, 0, 0 + 16, I, 0)
      I = IAND(I, NOT(65535))
      CALL MVBITS(M, 4, 8, N, 20)
      WRITE (6, 3) M, IAND(N, 65535), I, IAND(N, NOT(65535))
    3 FORMAT (' >M ', 4I12)
      END
      SUBROUTINE SHIFTS(M, K, IC)
      INTEGER M, K, IC
      WRITE (6, 1) M, K, IC, ISHFT(M, K), ISHFTC(M, K, IC)
    1 FORMAT (' >V ', 5I12)
      END
