C     ** A small subprogram that keeps a value in a local from one call
C     to the next, without SAVE, as programs written for FORTRAN H do.
C     The inliner spliced such a unit into its caller, where the local
C     was a fresh one at each splice, and the count came out wrong
C     (fort370 issue 15).  NEXTID counts in a local; LAST holds an
C     argument while a flag says to; TOTAL is a FUNCTION adding to its
C     own value; PAIRS reads a local array.  BOTH sets its local on
C     every path, and is still spliced.
      INTEGER I, ID, J, K, M
      REAL S, TOTAL
      DO 10 I = 1, 4
         CALL NEXTID(ID)
         IF (ID .NE. I) STOP 1
   10 CONTINUE
      CALL LAST(7, 1, J)
      CALL LAST(9, 0, J)
      IF (J .NE. 7) STOP 2
      S = TOTAL(0.0, 1)
      S = TOTAL(2.5, 0)
      S = TOTAL(1.5, 0)
      IF (S .NE. 4.0) STOP 3
      CALL PAIRS(1, K)
      CALL PAIRS(0, K)
      IF (K .NE. 5) STOP 4
      CALL BOTH(1, M)
      IF (M .NE. 11) STOP 5
      CALL BOTH(0, M)
      IF (M .NE. 22) STOP 6
      WRITE (6, 100) ID, J, S, K, M
  100 FORMAT (1X, '>', 2I4, F6.1, 2I4)
      END
      SUBROUTINE NEXTID(ID)
      INTEGER ID, KOUNT
      KOUNT = KOUNT + 1
      ID = KOUNT
      END
      SUBROUTINE LAST(IV, ISET, J)
      INTEGER IV, ISET, J, KEPT
      IF (ISET .EQ. 1) KEPT = IV
      J = KEPT
      END
      REAL FUNCTION TOTAL(X, INIT)
      REAL X
      INTEGER INIT
      IF (INIT .EQ. 1) TOTAL = 0.0
      TOTAL = TOTAL + X
      END
      SUBROUTINE PAIRS(ISET, K)
      INTEGER ISET, K, L(2)
      IF (ISET .EQ. 1) THEN
         L(1) = 2
         L(2) = 3
      END IF
      K = L(1) + L(2)
      END
      SUBROUTINE BOTH(IV, M)
      INTEGER IV, M, N
      IF (IV .EQ. 1) THEN
         N = 11
      ELSE
         N = 22
      END IF
      M = N
      END
