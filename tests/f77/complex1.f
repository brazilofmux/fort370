      PROGRAM CX1
      COMPLEX Z, W, ZA(3), CF, V
      REAL R
      INTEGER I
      PARAMETER (W = (1.5, -2.0))
      DATA ZA /(1.0, 2.0), (3.0, 4.0), (0.5, 0.0)/
      Z = (1.0, 2.0)
      WRITE (6, 100) Z, Z + W, Z - W, Z * W, Z / W, -Z
 100  FORMAT (1X, 6('(', F8.3, ',', F8.3, ') '))
      WRITE (6, 100) Z ** 3, Z ** 2.0, CONJG(Z), CMPLX(3.0, 4.0),
     1   CMPLX(2)
      WRITE (6, 101) REAL(Z), AIMAG(Z), CABS(CMPLX(3.0,4.0)), ABS(Z)
 101  FORMAT (1X, 4F10.4)
      WRITE (6, 100) CSQRT(Z), CEXP(Z), CLOG(Z), CSIN(Z), CCOS(Z)
      WRITE (6, 100) ZA(1), ZA(2), ZA(3), CF(Z, 2)
      WRITE (6, *) Z, Z .EQ. (1.0, 2.0), Z .NE. W
      R = Z
      I = Z * 2
      WRITE (6, *) R, I, Z + 1, 2 * Z, Z + 1.5
      READ (5, 102) Z
 102  FORMAT (2F5.1)
      READ (5, *) V
      WRITE (6, 100) Z, V
      CALL CS(Z, V)
      WRITE (6, 100) Z
      END
      COMPLEX FUNCTION CF(Z, N)
      COMPLEX Z
      CF = Z * N
      RETURN
      END
      SUBROUTINE CS(A, B)
      COMPLEX A, B
      A = A + B
      RETURN
      END
