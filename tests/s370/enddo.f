C     ** END DO and DO WHILE, MIL-STD-1753's (1978): a DO without a
C     label ends at END DO; DO WHILE (e), labelled or not; END DO with
C     a labelled DO's label as its terminal statement; nested, mixed,
C     zero-trip, a negative step, a jump out, block IF inside, and a
C     subroutine of them small enough to be spliced into its caller.
C     Suggested by Marco Verpelli (2026-10-16).
      INTEGER I, J, K, N, V(3), M(3,2), S
      DO I = 1, 3
        V(I) = I * I
      END DO
      WRITE (6, 100) V
      DO 10 I = 1, 3
        DO J = 1, 2
          M(I, J) = 10 * I + J
        END DO
   10 END DO
      WRITE (6, 101) M
      S = 0
      DO 20, I = 1, 4
        DO J = I, 1, -1
          S = S + J
        END DO
   20 CONTINUE
      K = 0
      DO I = 5, 1
        K = K + 1
      END DO
      WRITE (6, 102) S, K
      N = 1
      DO WHILE (N .LT. 100)
        N = N * 3
      END DO
      K = 0
      DO 30 WHILE (K .LT. 5)
        K = K + 2
   30 CONTINUE
      WRITE (6, 102) N, K
      S = 0
      DO I = 1, 10
        IF (MOD(I, 2) .EQ. 0) THEN
          S = S + I
        ELSE
          IF (I .GT. 7) GO TO 40
        END IF
      END DO
   40 WRITE (6, 102) S, I
      S = 0
      DO I = 1, 3
        CALL ADDN(S, I)
      END DO
      WRITE (6, 102) S
  100 FORMAT (1X, '>', 3I5)
  101 FORMAT (1X, '>', 6I4)
  102 FORMAT (1X, '>', 2I6)
      END
      SUBROUTINE ADDN(S, N)
      INTEGER S, N, J
      DO J = 1, N
        S = S + J
      END DO
      END
