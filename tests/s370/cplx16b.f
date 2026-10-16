C     ** COMPLEX*16, the forms gfortran does not take or this test needs
C     to check by itself: COMPLEX Z*16, IMPLICIT DOUBLE COMPLEX, DOUBLE
C     COMPLEX FUNCTION, COMPLEX*16 against COMPLEX in EQUIVALENCE,
C     unformatted I/O, a PARAMETER from another, an array through a
C     loop and an argument.  Success prints >CPLX16B and the checks passed
C     and reaches STOP 0.
      IMPLICIT DOUBLE COMPLEX (P-Q)
      COMPLEX Z*16, Y*16, C, CC(2), ZZ*16, X(4)*16
      DOUBLE PRECISION D(2), E(4)
      DOUBLE COMPLEX DF
      INTEGER NOK, I
      EQUIVALENCE (ZZ, D(1)), (ZZ, CC(1))
      PARAMETER (PA = (2.D0, 3.D0), PB = PA * 2)
      NOK = 0
      P = (0.25D0, -0.5D0)
      IF (DREAL(P) .NE. 0.25D0 .OR. DIMAG(P) .NE. -0.5D0) STOP 1
      Z = PB
      IF (Z .NE. (4.D0, 6.D0)) STOP 2
      NOK = NOK + 2
      ZZ = (1.D0, -1.D0)
      IF (D(1) .NE. 1.D0 .OR. D(2) .NE. -1.D0) STOP 3
      NOK = NOK + 1
      DO 10 I = 1, 4
         X(I) = DCMPLX(DBLE(I), -DBLE(I)) * (0.D0, 1.D0)
   10 CONTINUE
      CALL ZSUM(X, 4, Y)
      IF (Y .NE. (10.D0, 10.D0)) STOP 4
      Y = DF(X(2))
      IF (Y .NE. (2.D0, 0.D0) + X(2)) STOP 5
      NOK = NOK + 2
      OPEN (1, FORM='UNFORMATTED', STATUS='SCRATCH')
      WRITE (1) X
      REWIND 1
      X(1) = (0.D0, 0.D0)
      X(3) = (0.D0, 0.D0)
      READ (1) X
      IF (X(1) .NE. (1.D0, 1.D0) .OR. X(3) .NE. (3.D0, 3.D0)) STOP 6
      NOK = NOK + 1
      C = (0.5, 0.25)
      Z = C
      IF (Z .NE. C .OR. Z .NE. (0.5D0, 0.25D0)) STOP 7
      Z = (1.D0, 0.D0) / 3.D0
      C = Z
      IF (DREAL(Z) .EQ. DBLE(REAL(C))) STOP 8
      IF (INT((2.5D0, 1.D0)) .NE. 2) STOP 9
      IF (DCMPLX(3.D0) .NE. (3.D0, 0.D0)) STOP 10
      NOK = NOK + 4
      WRITE (6, 100) NOK
  100 FORMAT (1X, '>CPLX16B', I4)
      STOP 0
      END
      SUBROUTINE ZSUM(A, N, S)
      COMPLEX*16 A(N), S
      INTEGER N, I
      S = (0.D0, 0.D0)
      DO 10 I = 1, N
         S = S + A(I)
   10 CONTINUE
      END
      DOUBLE COMPLEX FUNCTION DF(A)
      COMPLEX*16 A
      DF = A + 2
      END
