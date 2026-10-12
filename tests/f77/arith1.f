      PROGRAM ARITH1
C     ** with INTEGER exponents, and the arithmetic IF.  The power
C     values are chosen to be exact in binary so both compilers must
C     agree to the bit; -2**2 pins the precedence fix (negation binds
C     looser than **, so it is -(2**2) = -4, not (-2)**2 = +4);
C     2**3**2 pins right-associativity (2**9, not 8**2).  The
C     arithmetic IFs walk all three branches on INTEGER, take the
C     zero branch on an exact DOUBLE difference, and the negative
C     branch on REAL.  Self-checking; success reaches STOP 0.
      INTEGER N, K, SIG
      DOUBLE PRECISION D
      REAL R

      IF (2**10 .NE. 1024) STOP 1
      IF (3**0 .NE. 1) STOP 2
      IF (2**(-1) .NE. 0) STOP 3
      IF (1**(-5) .NE. 1) STOP 4
      IF ((-1)**(-3) .NE. -1) STOP 5
      IF ((-2)**3 .NE. -8) STOP 6
      IF (-2**2 .NE. -4) STOP 7
      IF (2**3**2 .NE. 512) STOP 8
      N = 5
      IF (2**N .NE. 32) STOP 9

      R = 1.5**2 + 2.0**(-2)
      IF (ABS(R - 2.5) .GT. 1.0E-6) STOP 10
      D = 1.5D0**3 + 2.0D0**(-3)
      IF (ABS(D - 3.5D0) .GT. 1.0D-12) STOP 11
      K = -3
      IF (ABS(D**K - 1.0D0/42.875D0) .GT. 1.0D-15) STOP 12

C     Arithmetic IF: walk negative, zero, positive on INTEGER.
      SIG = 0
      K = -3
   10 IF (K) 20, 30, 40
   20 SIG = SIG * 10 + 1
      K = K + 3
      GOTO 10
   30 SIG = SIG * 10 + 2
      K = K + 3
      GOTO 10
   40 SIG = SIG * 10 + 3
      IF (SIG .NE. 123) STOP 13

C     DOUBLE difference of exactly zero takes the middle label.
      IF (D - 3.5D0) 50, 60, 50
   50 STOP 14
   60 CONTINUE

C     REAL negative takes the first label.
      R = -0.25
      IF (R) 70, 80, 80
   80 STOP 15
   70 CONTINUE

      WRITE (6, 100) 2**10, -2**2, 2**3**2, SIG
  100 FORMAT ('OK', 4I7)
      WRITE (6, 110) R, D
  110 FORMAT (F8.3, F10.4)
      STOP 0
      END
