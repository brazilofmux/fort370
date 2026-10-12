C     DOUBLE PRECISION: the pair protocol end to end.
      PROGRAM SLICE4
      DOUBLE PRECISION D, E, F
      INTEGER I, K
      REAL R
      D = 1.5D0
      E = 2.5D0
      F = D + E
      IF (F .NE. 4.0D0) STOP 41
      F = E - D
      IF (F .NE. 1.0D0) STOP 42
      F = D * E
      IF (F .NE. 3.75D0) STOP 43
      F = E / D
      IF (F .LE. 1.66D0) STOP 44
      IF (F .GE. 1.67D0) STOP 45
      F = -D
      IF (F .NE. -1.5D0) STOP 46
      IF (.NOT. (D .LT. E)) STOP 47
      IF (D .GT. E) STOP 48
      IF (.NOT. (D .LE. D)) STOP 49
      K = 0
      I = 3
      D = I
      IF (D .NE. 3.0D0) STOP 50
      R = 0.5
      D = R
      IF (D .NE. 0.5D0) STOP 51
      D = 7.9D0
      I = D
      IF (I .NE. 7) STOP 52
      D = 1.0D0
      DO 10 K = 1, 10
         D = D * 2.0D0
   10 CONTINUE
      IF (D .NE. 1024.0D0) STOP 53
      STOP 0
      END
