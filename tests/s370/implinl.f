C     ** A subprogram spliced in place of its call is typed by its own
C     rules, not its caller's.  The main program's IMPLICIT INTEGER
C     (A-Z) made the callee's Y = 2.5 store 2 when ISTEP was inlined
C     (and 2.5 when it was not); a caller's IMPLICIT NONE refused the
C     callee's undeclared names, and the error named the callee's
C     header (Marco Verpelli's SUCC, a typed INTEGER FUNCTION).  The
C     callee has no IMPLICIT of its own -- one that has is never
C     spliced -- so its rule is the default one.  NONE is tested by
C     JNEXT and the caller's IMPLICIT INTEGER by ISTEP; each subprogram
C     is small enough to be inlined.  Self-checking; success reaches
C     STOP 0.
      PROGRAM IMPINL
      IMPLICIT INTEGER (A-Z)
      X = 7
      CALL ISTEP (X)
      IF (X .NE. 12) STOP 1
      CALL INONE (N)
      IF (N .NE. 2) STOP 2
      WRITE (6, 100) X, N
  100 FORMAT (1X, '>IMPINL', 2I5)
      STOP 0
      END
C
      SUBROUTINE ISTEP (K)
      Y = 2.5
      K = K + 2*Y
      END
C
      SUBROUTINE INONE (N)
      IMPLICIT NONE
      INTEGER N, JNEXT
      N = JNEXT(1)
      END
C
      INTEGER FUNCTION JNEXT (J)
      INTEGER J
      JNEXT = J + 1
      RETURN
      END
