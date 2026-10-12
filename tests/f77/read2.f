      PROGRAM READ2
C     List-directed READ: blank and comma separators, values spanning
C     records, r*c repeats, D exponents, the / terminator leaving the
C     rest of the list untouched, whole-array and implied-DO items,
C     the parenless READ *, form, and the read-until-EOF idiom with
C     END=.  Self-checking; success falls through to STOP 0.
      DOUBLE PRECISION X, SUM
      REAL A(5)
      INTEGER B(4)
      INTEGER K, M1, M2, M3, N

      READ (5, *) (A(K), K = 1, 5)
      IF (ABS(A(1) - 1.5) .GT. 1.0E-4) STOP 1
      IF (ABS(A(2) - 2.5) .GT. 1.0E-4) STOP 2
      IF (ABS(A(3) - 2.5) .GT. 1.0E-4) STOP 3
      IF (ABS(A(4) + 3.0) .GT. 1.0E-4) STOP 4
      IF (ABS(A(5) - 12.5) .GT. 1.0E-4) STOP 5

C     Whole array, fed by a repeat.
      READ (5, *) B
      IF (B(1) .NE. 6) STOP 6
      IF (B(4) .NE. 6) STOP 7

C     The / terminator: M3 must keep its prior value.
      M3 = 42
      READ (5, *) M1, M2, M3
      IF (M1 .NE. 7) STOP 8
      IF (M2 .NE. 8) STOP 9
      IF (M3 .NE. 42) STOP 10

C     Parenless form, unit 5 implied.
      READ *, K
      IF (K .NE. 555) STOP 11

C     Read until end of file, accumulating.
      N = 0
      SUM = 0.0D0
   10 READ (5, *, END=99) X
      N = N + 1
      SUM = SUM + X
      GOTO 10
   99 IF (N .NE. 3) STOP 12
      IF (ABS(SUM - 9.0D0) .GT. 1.0D-9) STOP 13

      WRITE (6, 200) (A(K), K = 1, 5)
  200 FORMAT (5F8.2)
      WRITE (6, 210) N, SUM
  210 FORMAT ('N=', I3, ' SUM=', F12.4)
      STOP 0
      END
