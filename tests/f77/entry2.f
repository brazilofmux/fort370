C     ENTRY2 -- the body of a later ENTRY is dead code in the units
C     that come before it, and it must stay dead.  In EA, everything
C     after RETURN (the ENTRY EB statement and K = F(J)) is parsed with
C     phantom dummies; the call through F must not run when EA returns.
C     FCVS FM509 found the 2026-10-11 re-sync letting it run: the front
C     end had emitted the dead statements into the block RETURN closed,
C     and the backend drops a RET's jump to the block laid out next.
      PROGRAM ENTRY2
      EXTERNAL DBL
      INTEGER IV
      IV = 0
      CALL EA(IV)
      IF (IV .NE. 7) STOP 1
      CALL EB(3, IV, DBL)
      IF (IV .NE. 6) STOP 2
      CALL EA(IV)
      IF (IV .NE. 7) STOP 3
      WRITE (*, '(A)') 'ENTRY2 OK'
      STOP 0
      END
      SUBROUTINE EA(I)
      INTEGER I, J, K
      EXTERNAL F
      INTEGER F
      I = 7
      RETURN
      ENTRY EB(J, K, F)
      K = F(J)
      RETURN
      END
      INTEGER FUNCTION DBL(N)
      INTEGER N
      DBL = 2 * N
      END
