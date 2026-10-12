C     Inlining used to treat ENDIF as END (prefix match) and drop the
C     rest of the callee.  T is small enough to inline (threshold 12).
C     If the body stops at ENDIF, N is 2; the +100 after ENDIF makes 102.
      PROGRAM SLICE15
      INTEGER N
      N = 1
      CALL T(N)
      IF (N .NE. 102) STOP 1
      WRITE (6, 10) N
   10 FORMAT ('OK', I4)
      STOP 0
      END
      SUBROUTINE T(N)
      INTEGER N
      IF (N .GT. 0) THEN
         N = N + 1
      ENDIF
      N = N + 100
      RETURN
      END
