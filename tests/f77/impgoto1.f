      PROGRAM IMPG1
C     IMPLICIT letter ranges and computed GOTO.  DY = 1/3 round-trips
C     at 1D-12 only if IMPLICIT really made it DOUBLE PRECISION --
C     single precision fails that check by ~1E-8, so the retyping has
C     teeth.  The computed GOTO builds a digit signature (123) across
C     its arms and must fall through when the index is 4 or 0.
C     Self-checking; success reaches STOP 0.
      IMPLICIT DOUBLE PRECISION (D), INTEGER (W-Z)
      INTEGER SIG, K, NVAL
      DX = 2.5D0
      WCOUNT = 3
      DX = DX * WCOUNT
      IF (ABS(DX - 7.5D0) .GT. 1.0D-9) STOP 1
      DY = 1.0D0 / 3.0D0
      IF (ABS(DY * 3.0D0 - 1.0D0) .GT. 1.0D-12) STOP 2

      SIG = 0
      K = 0
   20 K = K + 1
      GOTO (30, 40, 50), K
      GOTO 60
   30 SIG = SIG * 10 + 1
      GOTO 20
   40 SIG = SIG * 10 + 2
      GOTO 20
   50 SIG = SIG * 10 + 3
      GOTO 20
   60 IF (SIG .NE. 123) STOP 3
      IF (K .NE. 4) STOP 4

C     Index of 0 falls through too.
      K = 0
      GOTO (70), K
      SIG = SIG + 1
      GOTO 80
   70 STOP 5
   80 IF (SIG .NE. 124) STOP 6

C     IMPLICIT retypes a dummy in the callee.
      CALL DBUMP(DX)
      IF (ABS(DX - 8.5D0) .GT. 1.0D-9) STOP 7

C     IMPLICIT NONE with everything declared.
      CALL NONECK(NVAL)
      IF (NVAL .NE. 6) STOP 8

      WRITE (6, 100) SIG, DX
  100 FORMAT ('OK', I5, F8.2)
      STOP 0
      END

      SUBROUTINE DBUMP(DVAL)
      IMPLICIT DOUBLE PRECISION (D)
      DVAL = DVAL + 1.0D0
      RETURN
      END

      SUBROUTINE NONECK(N)
      IMPLICIT NONE
      INTEGER N, I
      N = 0
      DO 10 I = 1, 3
      N = N + I
   10 CONTINUE
      RETURN
      END
