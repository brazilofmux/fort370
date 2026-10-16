C     ** A type's length before a name that begins with H: squeezed,
C     REAL*8 H reads REAL*8H, which was taken for a Hollerith count
C     (found in SLOW-32, 2026-10-16).  A DATA repeat count before a
C     Hollerith constant keeps it.
      REAL*8 H, X
      CHARACTER*8 HUE
      COMPLEX*16 HZ
      INTEGER N(2)
      DATA N /2*4HABCD/
      H = 1.5D0
      X = H + 1
      HUE = 'ABC'
      HZ = (1.D0, 2.D0)
      WRITE (6, 100) H, X, HUE, HZ, N
  100 FORMAT (1X, '>', 2F6.2, 1X, A8, 2F6.2, 1X, 2A4)
      END
