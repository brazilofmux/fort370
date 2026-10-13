      COMPLEX A, B, C, D, E, ZF
      REAL X, Y, R1, R2, R3
      X = 1.0
      Y = 2.0
      A = ZF(X, Y)
      WRITE(6,10) A
      B = CEXP((-1.5, -2.75))
      WRITE(6,10) B
      C = (B + 1.0 / B) / (2.0, 0.0)
      WRITE(6,10) C
      A = CCOS((2.75,-1.5) * (-1.0, 0.0))
      WRITE(6,10) A
      A = CMPLX(X, Y) + CMPLX(Y, Y)
      WRITE(6,10) A
      C = CSQRT((3.0,4.0))
      D = CLOG((1.0,1.0))
      E = CSIN((1.0,2.0))
      WRITE(6,10) C, D, E
      R1 = CABS((3.0,4.0))
      R2 = REAL(A)
      R3 = AIMAG(A)
      WRITE(6,11) R1, R2, R3
      A = (1.0,2.0) * (3.0,4.0)
      C = A / (3.0,4.0)
      D = CONJG(A)
      WRITE(6,10) A, C, D
   10 FORMAT(' >', 3('(',F10.5,',',F10.5,')'))
   11 FORMAT(' >', 3F10.5)
      END
      COMPLEX FUNCTION ZF(X, Y)
      ZF = CMPLX(X, Y) + CMPLX(Y, Y)
      RETURN
      END
