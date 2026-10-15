C     ** A spliced subprogram's dummy is not invariant in its caller's
C     loop.  A load of a dummy is taken as loop-invariant, since
C     nothing else may change it while its own unit runs; spliced in
C     place of the CALL, the callee runs inside the caller, whose DO
C     changes the actual.  NEXTV's V = 3*K + 1 was hoisted out of the
C     loop and every V was the first one's -- found in a floating-point
C     survey, where a generator inlined into a DO returned the same
C     value 300 times.  SHOWV keeps its CALL (its EQUIVALENCE is never
C     spliced), and passing it K keeps K in storage, where the hoisted
C     load read it once.  Self-checking; success reaches STOP 0.
      INTEGER K, ISUM
      DOUBLE PRECISION V
      COMMON /TOT/ ISUM
      ISUM = 0
      DO 10 K = 1, 4
         CALL NEXTV(K, V)
         CALL SHOWV(K, V)
   10 CONTINUE
      IF (ISUM .NE. 34) STOP 1
      WRITE (6, 100) ISUM
  100 FORMAT (1X, '>SPLICEDO', I5)
      STOP 0
      END
C
      SUBROUTINE NEXTV(K, V)
      INTEGER K
      DOUBLE PRECISION V
      V = DBLE(FLOAT(3 * K + 1))
      RETURN
      END
C
      SUBROUTINE SHOWV(K, X)
      INTEGER K, IX(2), ISUM
      DOUBLE PRECISION X, XX
      COMMON /TOT/ ISUM
      EQUIVALENCE (XX, IX(1))
      XX = X
      IF (K .GT. 0) ISUM = ISUM + IDINT(XX)
      RETURN
      END
