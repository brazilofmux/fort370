C     REAL arithmetic, mixed mode, relationals, .NOT., negative step.
      PROGRAM SLICE3
      INTEGER I, K
      REAL X, Y, Z
      X = 1.5
      Y = 2.0
      K = 0
      IF (X .LT. Y) K = K + 1
      IF (X*Y .GE. 3.0) K = K + 2
      IF (.NOT. (X .EQ. Y)) K = K + 4
      IF (K .NE. 7) STOP 31
      Z = X + 2
      IF (Z .NE. 3.5) STOP 32
      I = Y
      IF (I .NE. 2) STOP 33
      K = 0
      DO 10 I = 10, 1, -2
         K = K + 1
   10 CONTINUE
      IF (K .NE. 5) STOP 34
      K = 0
      DO 20 I = 5, 1
         K = K + 1
   20 CONTINUE
      IF (K .NE. 0) STOP 35
      STOP 0
      END
