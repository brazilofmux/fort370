C     ** The floating-point repairs of 2026-10-15, self-checking: DSQRT
C     correctly rounded (the root of 2 is 4116A09E667F3BCD, its digits
C     after ...CC being 908B...); SIN and COS of arguments past 2**20,
C     where the reduction by pi/2 takes the bits of 2/pi (it abended
C     with S0CC at 1E20, which is now past FORTLIB's PI*2**50 and its
C     error, tests/s370/mathchk.f); ATAN2 and ** where a quotient or a
C     product would overflow; IBM's ARSIN and DARCOS; and a constant read from
C     a record the same number as the one in the source, both rounded
C     (REAL READ rounded and the constant truncated, before).  Success
C     prints >FPROUND and the checks passed and reaches STOP 0.
      DOUBLE PRECISION D, E, PI
      REAL X, Y
      INTEGER ID(2), NOK
      CHARACTER*12 T
      EQUIVALENCE (D, ID(1))
      NOK = 0
      PI = 3.14159265358979324D0
      D = DSQRT(2.D0)
      IF (ID(1) .NE. 1092001950 .OR. ID(2) .NE. 1719614413) STOP 1
      NOK = NOK + 1
      E = 1.D15
      IF (DABS(DSIN(E) - 0.8582727931702358D0) .GT. 1.D-15) STOP 2
      IF (DABS(DCOS(E) + 0.5131937377869703D0) .GT. 1.D-15) STOP 3
      E = 3.D6
      IF (DABS(DCOS(E) - 0.4777606280773224D0) .GT. 1.D-15) STOP 4
      NOK = NOK + 3
      E = 1.D70
      IF (DABS(DATAN2(E, 1.D-10) - PI / 2.D0) .GT. 1.D-15) STOP 5
      IF (2.D0 ** E .LT. 1.D75) STOP 6
      IF (DABS(2.D0 ** 3.D0 - 8.D0) .GT. 1.D-14) STOP 7
      NOK = NOK + 3
      X = 0.5
      IF (ABS(ARSIN(X) - 0.5235988) .GT. 1.E-6) STOP 8
      D = 0.5D0
      IF (DABS(DARCOS(D) - PI / 3.D0) .GT. 1.D-15) STOP 9
      NOK = NOK + 2
      T = '0.1'
      READ (T, '(E12.0)') X
      IF (X .NE. 0.1) STOP 10
      T = '7.1E-1'
      READ (T, '(E12.0)') Y
      IF (Y .NE. 0.71) STOP 11
      T = '0.1'
      READ (T, '(D12.0)') E
      IF (E .NE. 0.1D0) STOP 12
      NOK = NOK + 3
      WRITE (6, 100) NOK
  100 FORMAT (1X, '>FPROUND', I4)
      STOP 0
      END
