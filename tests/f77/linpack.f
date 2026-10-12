C     LINPACK: the real DAXPY / DSCAL / IDAMAX / DDOT / DGEFA / DGESL
C     shapes, in the form they actually take -- adjustable dimensions
C     A(LDA,1), by-reference arguments, DABS/DMAX1, and column-major
C     traversal.  Solves A*x = b for a matrix whose exact solution is
C     all ones, then checks the residual, which is what the benchmark
C     itself does.
      PROGRAM LINPK
      INTEGER LDA, N, IPVT(16), INFO, I, J
      DOUBLE PRECISION A(16,16), B(16), RESID, T
      LDA = 16
      N = 8
C     A well-conditioned matrix: diagonally dominant, and b chosen so
C     that the exact solution is x(i) = 1 for every i.
      DO 20 J = 1, N
         DO 10 I = 1, N
            A(I,J) = 1.0D0 / DBLE(I + J)
   10    CONTINUE
         A(J,J) = A(J,J) + DBLE(N)
   20 CONTINUE
      DO 40 I = 1, N
         T = 0.0D0
         DO 30 J = 1, N
            T = T + A(I,J)
   30    CONTINUE
         B(I) = T
   40 CONTINUE
      CALL DGEFA(A, LDA, N, IPVT, INFO)
      IF (INFO .NE. 0) STOP 151
      CALL DGESL(A, LDA, N, IPVT, B)
C     Every component of the solution should now be 1.
      RESID = 0.0D0
      DO 50 I = 1, N
         RESID = DMAX1(RESID, DABS(B(I) - 1.0D0))
   50 CONTINUE
      IF (RESID .GT. 1.0D-10) STOP 152
      STOP 0
      END

      SUBROUTINE DAXPY(N, DA, DX, INCX, DY, INCY)
      DOUBLE PRECISION DX(1), DY(1), DA
      INTEGER I, INCX, INCY, N
      IF (N .LE. 0) RETURN
      IF (DA .EQ. 0.0D0) RETURN
      DO 10 I = 1, N
         DY(I) = DY(I) + DA*DX(I)
   10 CONTINUE
      RETURN
      END

      SUBROUTINE DSCAL(N, DA, DX, INCX)
      DOUBLE PRECISION DA, DX(1)
      INTEGER I, INCX, N
      IF (N .LE. 0) RETURN
      DO 10 I = 1, N
         DX(I) = DA*DX(I)
   10 CONTINUE
      RETURN
      END

      DOUBLE PRECISION FUNCTION DDOT(N, DX, INCX, DY, INCY)
      DOUBLE PRECISION DX(1), DY(1), DTEMP
      INTEGER I, INCX, INCY, N
      DDOT = 0.0D0
      DTEMP = 0.0D0
      IF (N .LE. 0) RETURN
      DO 10 I = 1, N
         DTEMP = DTEMP + DX(I)*DY(I)
   10 CONTINUE
      DDOT = DTEMP
      RETURN
      END

      INTEGER FUNCTION IDAMAX(N, DX, INCX)
      DOUBLE PRECISION DX(1), DMAX
      INTEGER I, INCX, N
      IDAMAX = 0
      IF (N .LT. 1) RETURN
      IDAMAX = 1
      IF (N .EQ. 1) RETURN
      DMAX = DABS(DX(1))
      DO 10 I = 2, N
         IF (DABS(DX(I)) .LE. DMAX) GO TO 10
         IDAMAX = I
         DMAX = DABS(DX(I))
   10 CONTINUE
      RETURN
      END

      SUBROUTINE DGEFA(A, LDA, N, IPVT, INFO)
      INTEGER LDA, N, IPVT(1), INFO
      DOUBLE PRECISION A(LDA,1), T
      INTEGER IDAMAX, J, K, KP1, L, NM1
      INFO = 0
      NM1 = N - 1
      IF (NM1 .LT. 1) GO TO 70
      DO 60 K = 1, NM1
         KP1 = K + 1
         L = IDAMAX(N-K+1, A(K,K), 1) + K - 1
         IPVT(K) = L
         IF (A(L,K) .EQ. 0.0D0) GO TO 40
         IF (L .EQ. K) GO TO 10
         T = A(L,K)
         A(L,K) = A(K,K)
         A(K,K) = T
   10    CONTINUE
         T = -1.0D0/A(K,K)
         CALL DSCAL(N-K, T, A(K+1,K), 1)
         DO 30 J = KP1, N
            T = A(L,J)
            IF (L .EQ. K) GO TO 20
            A(L,J) = A(K,J)
            A(K,J) = T
   20       CONTINUE
            CALL DAXPY(N-K, T, A(K+1,K), 1, A(K+1,J), 1)
   30    CONTINUE
         GO TO 50
   40    CONTINUE
         INFO = K
   50    CONTINUE
   60 CONTINUE
   70 CONTINUE
      IPVT(N) = N
      IF (A(N,N) .EQ. 0.0D0) INFO = N
      RETURN
      END

      SUBROUTINE DGESL(A, LDA, N, IPVT, B)
      INTEGER LDA, N, IPVT(1)
      DOUBLE PRECISION A(LDA,1), B(1), T
      INTEGER K, KB, L, NM1
      NM1 = N - 1
      IF (NM1 .LT. 1) GO TO 30
      DO 20 K = 1, NM1
         L = IPVT(K)
         T = B(L)
         IF (L .EQ. K) GO TO 10
         B(L) = B(K)
         B(K) = T
   10    CONTINUE
         CALL DAXPY(N-K, T, A(K+1,K), 1, B(K+1), 1)
   20 CONTINUE
   30 CONTINUE
      DO 40 KB = 1, N
         K = N + 1 - KB
         B(K) = B(K)/A(K,K)
         T = -B(K)
         CALL DAXPY(K-1, T, A(1,K), 1, B(1), 1)
   40 CONTINUE
      RETURN
      END
