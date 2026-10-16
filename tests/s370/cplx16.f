C     ** COMPLEX*16 (DOUBLE COMPLEX), IBM's: declarations, COMMON,
C     EQUIVALENCE, PARAMETER, DATA and a statement function; mixed mode
C     with COMPLEX and DOUBLE PRECISION (COMPLEX*16, as FORTRAN H makes
C     it); + - * / and **; FORTRAN H's DCMPLX, DCONJG, CDABS, CDSQRT,
C     CDEXP, CDLOG, CDSIN, CDCOS, later IBM's DIMAG and DREAL, and the
C     generic names; formatted, list-directed and internal I/O; a
C     COMPLEX*16 FUNCTION and a REAL*8 one.  The values agree with
C     gfortran's to 6E-16 (2026-10-16).
      PROGRAM Z16
      IMPLICIT COMPLEX*16 (Q)
      COMPLEX*16 Z, W, A(3), ZF, ZS, ZP, V
      DOUBLE COMPLEX DW
      COMPLEX C
      COMPLEX*16 C2
      DOUBLE PRECISION D, E(2), RF
      COMMON /ZC/ V, D2
      DOUBLE PRECISION D2
      CHARACTER*20 T
      EQUIVALENCE (W, E(1))
      PARAMETER (ZP = (1.D0, -2.D0))
      DATA A /(1.D0, 2.D0), (3.D0, -4.D0), (0.5D0, 0.25D0)/
      ZS(Q1) = Q1 * Q1 + ZP
      Z = (1.D0, 2.D0)
      C = (3.0, 4.0)
      D = 0.5D0
      WRITE (6, 100) 1, Z * C
      WRITE (6, 100) 2, C * D
      WRITE (6, 100) 3, (1.D0, 2.D0) / (3.D0, 4.D0)
      WRITE (6, 100) 4, Z / 2
      WRITE (6, 100) 5, Z ** 3
      WRITE (6, 100) 6, Z ** (-2)
      WRITE (6, 100) 7, Z ** ZP
      WRITE (6, 100) 8, -Z + A(2) - A(3)
      WRITE (6, 100) 9, DCMPLX(D, 2.D0)
      WRITE (6, 100) 10, DCONJG(Z), CONJG(A(2))
      WRITE (6, 101) 11, DIMAG(Z), DREAL(Z), DBLE(A(2)), REAL(A(2)),
     1   AIMAG(A(2))
      WRITE (6, 101) 12, CDABS(A(2)), ABS(Z)
      WRITE (6, 100) 13, CDSQRT(Z), SQRT(A(2))
      WRITE (6, 100) 14, CDEXP(Z), EXP(A(3))
      WRITE (6, 100) 15, CDLOG(Z), LOG(A(2))
      WRITE (6, 100) 16, CDSIN(Z), SIN(A(3))
      WRITE (6, 100) 17, CDCOS(Z), COS(A(3))
      C = Z
      C2 = C
      WRITE (6, 102) 18, CMPLX(A(2)), C
      WRITE (6, 100) 19, C2
      W = (1.5D0, -2.25D0)
      WRITE (6, 101) 20, E(1), E(2)
      DW = ZF(Z, 3)
      WRITE (6, 100) 21, DW
      CALL ZSUB(Z, V)
      WRITE (6, 100) 22, V
      WRITE (6, 100) 23, ZS(Z)
      QX = Z
      WRITE (6, 103) 24, QX .EQ. Z, QX .NE. Z, Z .EQ. A(1), Z .EQ. A(2)
      T = '(1.5D0, -2.25D0)'
      READ (T, *) W
      WRITE (6, 100) 25, W
      T = '   0.125D0  -8.5D0'
      READ (T, '(2D10.0)') W
      WRITE (6, 100) 26, W
      WRITE (6, *) '>', Z, A(3)
      D = RF(2.D0)
      WRITE (6, 101) 27, D
  100 FORMAT (1X, '>', I3, 4D24.16)
  101 FORMAT (1X, '>', I3, 5D24.16)
  102 FORMAT (1X, '>', I3, 4E15.7)
  103 FORMAT (1X, '>', I3, 4L2)
      END
      COMPLEX*16 FUNCTION ZF(X, N)
      COMPLEX*16 X
      ZF = X ** N - (0.D0, 1.D0)
      END
      SUBROUTINE ZSUB(X, Y)
      COMPLEX*16 X, Y
      Y = X * DCONJG(X) + (0.D0, 0.5D0)
      END
      REAL*8 FUNCTION RF(Y)
      REAL*8 Y
      RF = Y * 1.25D0
      END
