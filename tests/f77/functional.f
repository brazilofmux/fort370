C     GitHub issue 25: INTEGER FUNCTIONAL is a type-statement for the
C     name FUNCTIONAL, not INTEGER FUNCTION AL.  Same shape for REAL /
C     LOGICAL / DOUBLE PRECISION.  The no-space spelling
C     INTEGERFUNCTIONF(X) must still open a FUNCTION unit -- that is
C     the squeeze INTEGER FUNCTION F was chosen for.  FUNCTIONAL(3)
C     is an array, not FUNCTION AL with dummy 3.
      PROGRAM P
      INTEGER FUNCTIONAL, N
      FUNCTIONAL = 42
      N = ISQ(7)
      IF (FUNCTIONAL .NE. 42) STOP 1
      IF (N .NE. 49) STOP 2
      CALL TREAL
      CALL TLOG
      CALL TDPREC
      CALL TARR
      WRITE (6, 10) FUNCTIONAL
   10 FORMAT (I4)
      STOP 0
      END
      INTEGERFUNCTIONISQ(K)
      INTEGER K
      ISQ = K * K
      RETURN
      END
      SUBROUTINE TREAL
      REAL FUNCTIONAL
      FUNCTIONAL = 1.5
      IF (FUNCTIONAL .NE. 1.5) STOP 3
      RETURN
      END
      SUBROUTINE TLOG
      LOGICAL FUNCTIONAL
      FUNCTIONAL = .TRUE.
      IF (.NOT. FUNCTIONAL) STOP 4
      RETURN
      END
      SUBROUTINE TDPREC
      DOUBLE PRECISION FUNCTIONAL
      FUNCTIONAL = 2.0D0
      IF (FUNCTIONAL .NE. 2.0D0) STOP 5
      RETURN
      END
      SUBROUTINE TARR
      INTEGER FUNCTIONAL(3)
      FUNCTIONAL(1) = 10
      FUNCTIONAL(2) = 20
      FUNCTIONAL(3) = 30
      IF (FUNCTIONAL(2) .NE. 20) STOP 6
      RETURN
      END
