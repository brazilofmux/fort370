C     Unprefixed FUNCTION type, REAL*8, MAX1, STOP in a subroutine,
C     REAL DO, whole-array WRITE, LOGICAL L, Gw.d.
      PROGRAM SLICE11
      INTEGER I, K
      REAL X, Y
      REAL*8 D
      LOGICAL L1, L2
      INTEGER V(4)
      D = 1.0D0 / 3.0D0
      IF (ABS(D * 3.0D0 - 1.0D0) .GT. 1.0D-12) STOP 151
      X = MAX1(1.2, 1.8)
      IF (X .NE. 1.0) STOP 152
      Y = AMAX0(3, 9)
      IF (Y .NE. 9.0) STOP 153
      K = 0
      DO 10 X = 1.0, 2.0, 0.5
         K = K + 1
   10 CONTINUE
      IF (K .NE. 3) STOP 154
      DO 20 I = 1, 4
         V(I) = I
   20 CONTINUE
      WRITE (6,100) V
  100 FORMAT (4I2)
      L1 = .TRUE.
      L2 = .FALSE.
      WRITE (6,110) L1, L2
  110 FORMAT (2L2)
      WRITE (6,120) 12.5
  120 FORMAT (G12.4)
      CALL S
      STOP 1
      END
      SUBROUTINE S
      STOP 0
      END
