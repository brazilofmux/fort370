C     ** Format reversion past the second record.  The reversion point
C     was the format's outer parenthesis, so a reversion made the whole
C     format a group and its last ')' a group's end, not the format's;
C     where no NUL follows the format, as on MVS, the next reversion
C     read on into whatever did.  WRITE (6, '(1X,I3)') with five items
C     printed two lines and lost the rest, and READ with '(A)' and three
C     items left the third blank, silently (found 2026-10-16 from Marco
C     Verpelli's slash report).  Through internal files, self-checking:
C     success prints >REVERT and the checks passed and reaches STOP 0.
      CHARACTER*4 T(6), A, B, C, D
      INTEGER I, NOK, K(6)
      NOK = 0
      WRITE (T, 100) (I, I = 1, 5)
      IF (T(1) .NE. '   1' .OR. T(3) .NE. '   3') STOP 1
      IF (T(5) .NE. '   5') STOP 2
      NOK = NOK + 1
      READ (T, 100) (K(I), I = 1, 5)
      IF (K(1) .NE. 1 .OR. K(4) .NE. 4 .OR. K(5) .NE. 5) STOP 3
      NOK = NOK + 1
      T(1) = 'XA'
      T(2) = 'YB'
      T(3) = 'ZC'
      T(4) = 'PD'
      READ (T, 101) A, B, C, D
      IF (A .NE. 'XA' .OR. C .NE. 'ZC' .OR. D .NE. 'PD') STOP 4
      NOK = NOK + 1
      WRITE (T, 102) (I, I = 1, 6)
      IF (T(1) .NE. ' 1 2' .OR. T(3) .NE. ' 5 6') STOP 5
      NOK = NOK + 1
      WRITE (6, 103) NOK
      STOP 0
  100 FORMAT (I4)
  101 FORMAT (A)
  102 FORMAT (2I2)
  103 FORMAT (1X, '>REVERT', I3)
      END
