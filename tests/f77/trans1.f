      PROGRAM TRANS1
C     The transcendentals: SIN/COS/TAN, ASIN/ACOS/ATAN/ATAN2,
C     EXP/LOG/LOG10, SINH/COSH/TANH, generic and D-specific names,
C     ALOG/ALOG10, and ** with a real exponent (pow/powf).  These are
C     REAL calls by their libm names: slow32 and slow32-fast execute
C     the Newton-series SLOW-32 code from libs32, slow32-dbt and
C     qemu-tcg substitute native host routines found via the .s32x
C     symbol table -- same binary, both paths must agree with the
C     oracle at the printed precision.  Self-checking against
C     mathematical identities; success reaches STOP 0.
      DOUBLE PRECISION PI, E, X, S, C
      REAL RPI, R

      PI = 4.0D0 * DATAN(1.0D0)
      IF (ABS(PI - 3.14159265358979D0) .GT. 1.0D-9) STOP 1
      E = DEXP(1.0D0)
      IF (ABS(E - 2.71828182845905D0) .GT. 1.0D-9) STOP 2
      IF (ABS(DLOG(E) - 1.0D0) .GT. 1.0D-9) STOP 3
      IF (ABS(DLOG10(100.0D0) - 2.0D0) .GT. 1.0D-9) STOP 4

C     Round trip and the Pythagorean identity.
      X = 0.7D0
      IF (ABS(DLOG(DEXP(X)) - X) .GT. 1.0D-9) STOP 5
      S = DSIN(X)
      C = DCOS(X)
      IF (ABS(S*S + C*C - 1.0D0) .GT. 1.0D-9) STOP 6
      IF (ABS(DTAN(X) - S/C) .GT. 1.0D-9) STOP 7
      IF (ABS(DASIN(S) - X) .GT. 1.0D-9) STOP 8
      IF (ABS(DACOS(C) - X) .GT. 1.0D-9) STOP 9
      IF (ABS(DCOSH(X)*DCOSH(X) - DSINH(X)*DSINH(X) - 1.0D0)
     +    .GT. 1.0D-9) STOP 10
      IF (ABS(DTANH(X) - DSINH(X)/DCOSH(X)) .GT. 1.0D-9) STOP 11

C     ATAN2 quadrants, REAL and DOUBLE.
      RPI = 2.0 * ATAN2(1.0, 0.0)
      IF (ABS(RPI - 3.1415927) .GT. 1.0E-5) STOP 12
      IF (ABS(DATAN2(-1.0D0, -1.0D0) + 0.75D0*PI) .GT. 1.0D-9) STOP 13

C     Real-exponent **: pow and powf by name.
      R = 2.0**0.5
      IF (ABS(R - SQRT(2.0)) .GT. 1.0E-5) STOP 14
      X = 8.0D0**(1.0D0/3.0D0)
      IF (ABS(X - 2.0D0) .GT. 1.0D-9) STOP 15
      IF (ABS(2**0.5 - R) .GT. 1.0E-5) STOP 16

C     REAL generics and the ALOG names.
      IF (ABS(EXP(1.0) - 2.7182817) .GT. 1.0E-5) STOP 17
      IF (ABS(ALOG(2.7182818) - 1.0) .GT. 1.0E-5) STOP 18
      IF (ABS(ALOG10(1000.0) - 3.0) .GT. 1.0E-5) STOP 19

      WRITE (6, 100) PI, E, RPI
  100 FORMAT (F10.6, F10.6, F10.6)
      WRITE (6, 110) DSIN(PI/6.0D0), DCOS(PI/3.0D0), DTAN(PI/4.0D0)
  110 FORMAT (3F10.6)
      WRITE (6, 120) R, X, 27.0D0**(1.0D0/3.0D0)
  120 FORMAT (3F10.6)
      STOP 0
      END
