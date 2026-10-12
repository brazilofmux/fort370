      PROGRAM DATA1
C     PARAMETER and DATA.  PARAMETER folds constant expressions at
C     compile time (2*N+1, 1.0/4.0, a DOUBLE pi) and serves as array
C     bounds, including a lower bound, and as a DATA repeat count.
C     DATA initializes STATIC storage at load: the subroutine counter
C     seeded by DATA must keep counting across calls -- initialized
C     once, not per call.  Self-checking; success reaches STOP 0.
      INTEGER N, M
      PARAMETER (N = 5, M = 2*N + 1)
      DOUBLE PRECISION PI
      PARAMETER (PI = 3.14159265358979D0)
      REAL SCALE
      PARAMETER (SCALE = 1.0 / 4.0)
      REAL A(N), B(-N:N)
      INTEGER COUNTS(3), K1, K2, K3
      DOUBLE PRECISION D
      DATA A /N*1.5/, COUNTS /10, 20, 30/
      DATA B(-N) /-2.5/, B(N) /2.5/, D /2.5D0/

      IF (M .NE. 11) STOP 1
      IF (ABS(A(1) - 1.5) .GT. 1.0E-4) STOP 2
      IF (ABS(A(N) - 1.5) .GT. 1.0E-4) STOP 3
      IF (COUNTS(1) .NE. 10) STOP 4
      IF (COUNTS(3) .NE. 30) STOP 5
      IF (ABS(B(-N) + 2.5) .GT. 1.0E-4) STOP 6
      IF (ABS(B(N) - 2.5) .GT. 1.0E-4) STOP 7
      IF (ABS(B(0)) .GT. 1.0E-4) STOP 8
      IF (ABS(D - 2.5D0) .GT. 1.0D-9) STOP 9
      IF (ABS(SCALE - 0.25) .GT. 1.0E-6) STOP 10
      IF (ABS(PI * 2.0D0 - 6.28318530717958D0) .GT. 1.0D-9) STOP 11

C     DATA in a subprogram: initialized once, then it counts.
      CALL TICK(K1)
      CALL TICK(K2)
      CALL TICK(K3)
      IF (K1 .NE. 101) STOP 12
      IF (K2 .NE. 102) STOP 13
      IF (K3 .NE. 103) STOP 14

C     A PARAMETER as an actual is a named constant, not a variable:
C     the callee must see 5, not whatever sat in PARAMETER's leftover
C     alloca.  N+0 already took the temp path; the bare name must too.
      CALL ADDT(N, K1)
      IF (K1 .NE. 6) STOP 15

      WRITE (6, 100) M, COUNTS(2), K3
  100 FORMAT ('OK', 3I5)
      WRITE (6, 110) A(3), B(N), D
  110 FORMAT (3F8.2)
      STOP 0
      END

      SUBROUTINE TICK(K)
      INTEGER K, KOUNT
      DATA KOUNT /100/
      KOUNT = KOUNT + 1
      K = KOUNT
      RETURN
      END

      SUBROUTINE ADDT(A, B)
      INTEGER A, B
      B = A + 1
      RETURN
      END
