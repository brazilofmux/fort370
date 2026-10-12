C     Caller uses unprefixed FUNCTION F typed DOUBLE PRECISION in the
C     callee.  F(3) must be 9, not an integer ABI miss.
      PROGRAM SLICE12
      DOUBLE PRECISION F, Y
      Y = F(3.0D0)
      IF (Y .NE. 9.0D0) STOP 161
      STOP 0
      END
      FUNCTION F(X)
      DOUBLE PRECISION F, X
      F = X * X
      END
