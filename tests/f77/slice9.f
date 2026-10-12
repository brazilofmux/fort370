C     Adjustable dimensions -- the shape LINPACK is built on: the array
C     is a dummy argument whose leading dimension is another dummy
C     argument, so the column stride is only known at run time.
      PROGRAM SLICE9
      DOUBLE PRECISION A(5,5), S
      INTEGER I, J
      DO 20 J = 1, 5
         DO 10 I = 1, 5
            A(I,J) = I + 10*J
   10    CONTINUE
   20 CONTINUE
      CALL DIAG(A, 5, 5, S)
      IF (S .NE. 165.0D0) STOP 111
C     Same array, a smaller logical order: the leading dimension stays 5
      CALL DIAG(A, 5, 3, S)
      IF (S .NE. 66.0D0) STOP 112
      CALL SCALE(A, 5, 5, 2.0D0)
      CALL DIAG(A, 5, 5, S)
      IF (S .NE. 330.0D0) STOP 113
      STOP 0
      END

      SUBROUTINE DIAG(A, LDA, N, S)
      INTEGER LDA, N, I
      DOUBLE PRECISION A(LDA,1), S
      S = 0.0D0
      DO 10 I = 1, N
         S = S + A(I,I)
   10 CONTINUE
      RETURN
      END

      SUBROUTINE SCALE(A, LDA, N, F)
      INTEGER LDA, N, I, J
      DOUBLE PRECISION A(LDA,1), F
      DO 20 J = 1, N
         DO 10 I = 1, N
            A(I,J) = A(I,J) * F
   10    CONTINUE
   20 CONTINUE
      RETURN
      END
