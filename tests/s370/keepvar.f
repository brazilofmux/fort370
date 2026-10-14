C     ** A subprogram's local keeps its value from one call to the next,
C     with no SAVE: FORTRAN H's storage is static, and so are IBM's
C     later compilers', and old programs count on it.  GRIGNO in Rene
C     Ferland's ADDAD/ANCORR sets its file table's count on the first
C     call (a DATA flag) and reads it on later ones; N here is the same.
C     It was promoted to a register, and read on the second call
C     whatever that register held.  M, an array, was always in storage.
C     Self-checking; success reaches STOP 0.
      INTEGER K
      DO 10 I = 1, 3
         CALL KEEP (I, K)
   10 CONTINUE
      WRITE (6, 100) K
  100 FORMAT (1X, '>KEEPVAR', I6)
      IF (K .NE. 3) STOP 1
      STOP 0
      END
      SUBROUTINE KEEP (I, K)
      INTEGER N, M(3)
      LOGICAL FIRST
      DATA FIRST /.TRUE./
      IF (.NOT. FIRST) GO TO 10
      FIRST = .FALSE.
      N = 0
   10 N = N + 1
      M(N) = I*10
      K = N
      IF (M(N) .NE. N*10) STOP 2
      END
