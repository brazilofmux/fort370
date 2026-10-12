C     Subprograms: by-reference arguments, and the layout test that
C     slice5 could not do -- SHOW receives a 2-D array as 1-D, so the
C     column-major order becomes observable.
      PROGRAM SLICE6
      INTEGER M(3,4), FLAT(12), I, J, K
      DO 20 J = 1, 4
         DO 10 I = 1, 3
            M(I,J) = I*10 + J
   10    CONTINUE
   20 CONTINUE
      CALL COPY12(M, FLAT)
C     Column-major: M(1,1) M(2,1) M(3,1) M(1,2) ... so FLAT(4) is M(1,2)
      IF (FLAT(1) .NE. 11) STOP 81
      IF (FLAT(2) .NE. 21) STOP 82
      IF (FLAT(3) .NE. 31) STOP 83
      IF (FLAT(4) .NE. 12) STOP 84
      IF (FLAT(12) .NE. 34) STOP 85
C     By-reference: the callee writes through the argument
      K = 5
      CALL DOUBLE(K)
      IF (K .NE. 10) STOP 86
      CALL ADDUP(M, 12, K)
      IF (K .NE. 270) STOP 87
      STOP 0
      END

      SUBROUTINE COPY12(A, B)
      INTEGER A(12), B(12), I
      DO 10 I = 1, 12
         B(I) = A(I)
   10 CONTINUE
      RETURN
      END

      SUBROUTINE DOUBLE(X)
      INTEGER X
      X = X * 2
      RETURN
      END

      SUBROUTINE ADDUP(A, N, S)
      INTEGER A(12), N, S, I
      S = 0
      DO 10 I = 1, N
         S = S + A(I)
   10 CONTINUE
      RETURN
      END
