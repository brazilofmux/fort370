C     Arrays: column-major order, 1-based and arbitrary lower bounds,
C     2-D indexing, and DOUBLE PRECISION elements.
      PROGRAM SLICE5
      INTEGER V(10), M(3,4), K, I, J
      DOUBLE PRECISION D(5)
      REAL R(0:9)
      DIMENSION W(4)
      INTEGER W
C     1-D fill and read back
      DO 10 I = 1, 10
         V(I) = I*I
   10 CONTINUE
      IF (V(1) .NE. 1) STOP 61
      IF (V(10) .NE. 100) STOP 62
      K = 0
      DO 20 I = 1, 10
         K = K + V(I)
   20 CONTINUE
      IF (K .NE. 385) STOP 63
C     2-D: column-major means the FIRST subscript varies fastest
      DO 40 J = 1, 4
         DO 30 I = 1, 3
            M(I,J) = I + 10*J
   30    CONTINUE
   40 CONTINUE
      IF (M(1,1) .NE. 11) STOP 64
      IF (M(3,4) .NE. 43) STOP 65
      IF (M(2,3) .NE. 32) STOP 66
C     Zero lower bound
      DO 50 I = 0, 9
         R(I) = I
   50 CONTINUE
      IF (R(0) .NE. 0.0) STOP 67
      IF (R(9) .NE. 9.0) STOP 68
C     DOUBLE PRECISION elements
      DO 60 I = 1, 5
         D(I) = I * 1.5D0
   60 CONTINUE
      IF (D(1) .NE. 1.5D0) STOP 69
      IF (D(5) .NE. 7.5D0) STOP 70
C     DIMENSION statement
      W(1) = 7
      W(4) = 9
      IF (W(1)+W(4) .NE. 16) STOP 71
      STOP 0
      END
