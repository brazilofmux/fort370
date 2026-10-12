      PROGRAM DBL
      DOUBLE PRECISION D, E
      D = 1.5D0
      E = 2.5D0
      READ (5, *) D
      CALL BUMP(E)
      WRITE (6, 100) D, E
 100  FORMAT (1X, 2F10.3)
      END
      SUBROUTINE BUMP(X)
      DOUBLE PRECISION X
      X = X + 1.0D0
      END
