C     ** Complex arithmetic in constant expressions: the evaluator took
C     a complex value's real parts alone, so PARAMETER (Z = (1.0,2.0) *
C     (3.0,4.0)) was (3.0,4.0) where it is (-5.0,10.0) (fort370 issue
C     11).  Products, quotients, sums and differences,
C     with REAL and INTEGER operands mixed in, COMPLEX*16, a PARAMETER
C     made from others, and one in DATA.  And ** with an INTEGER power,
C     which a constant expression may have and the evaluator refused:
C     right to left, -2**2 as -(2**2), negative powers, a complex base,
C     and an array bound.
      COMPLEX Z1, Z2, Z3, Z4, Z5, Z6, Z7, W
      COMPLEX*16 D1, D2
      PARAMETER (Z1 = (1.0, 2.0) * (3.0, 4.0))
      PARAMETER (Z2 = (1.0, 2.0) / (3.0, 4.0))
      PARAMETER (Z3 = (1.0, 2.0) + (3.0, 4.0) - (0.5, 0.25))
      PARAMETER (Z4 = 2 * (1.5, -1.0) + 1.0)
      PARAMETER (Z5 = Z1 * Z2 - Z3)
      PARAMETER (Z6 = (1.0, 2.0) / 2)
      PARAMETER (Z7 = -(1.0, 2.0) * (0.0, 1.0))
      PARAMETER (D1 = (1.D0, 2.D0) * (3.D0, 4.D0) / (0.D0, 2.D0))
      PARAMETER (D2 = D1 + 1.D0)
      INTEGER N1, N2, N3, N4, A(2**3), SIZE8
      REAL X1, X2
      COMPLEX Z8
      PARAMETER (N1 = 2**10, N2 = -2**2, N3 = 2**3**2, N4 = 2**(-1))
      PARAMETER (X1 = 1.5**2, X2 = 2.0**(-2), Z8 = (1.0, 1.0)**2)
      DATA W /Z1/
      WRITE (6, 100) Z1, Z2, Z3
      WRITE (6, 100) Z4, Z5, Z6
      WRITE (6, 100) Z7, W
      WRITE (6, 101) D1, D2
      WRITE (6, 102) N1, N2, N3, N4, SIZE8(A)
      WRITE (6, 100) X1, X2, Z8
  100 FORMAT (1X, '>', 6F9.4)
  101 FORMAT (1X, '>', 4F12.6)
  102 FORMAT (1X, '>', 5I6)
      END
      INTEGER FUNCTION SIZE8(A)
      INTEGER A(8)
      A(8) = 8
      SIZE8 = A(8)
      END
