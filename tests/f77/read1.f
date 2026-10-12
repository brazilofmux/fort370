      PROGRAM READ1
C     Formatted READ: I, F (explicit and implied decimal point), E and
C     D fields, L, X skipping, multi-record via / and via format
C     reversion.  Self-checking: each wrong value stops with its own
C     code, success falls through to STOP 0.
      INTEGER I, J, K1, K2, K3
      DOUBLE PRECISION X, Y
      REAL R1, R2
      LOGICAL P, Q

      READ (5, 100) I, J
  100 FORMAT (I4, 2X, I4)
      IF (I .NE. 123) STOP 1
      IF (J .NE. -45) STOP 2

C     F8.2 with an explicit point takes it as written; F6.2 with no
C     point in the field puts the implied point two digits in.
      READ (5, 110) X, R1
  110 FORMAT (F8.2, F6.2)
      IF (ABS(X - 312.75D0) .GT. 1.0D-9) STOP 3
      IF (ABS(R1 - 12.34) .GT. 1.0E-4) STOP 4

C     E and D input fields, including a D exponent.
      READ (5, 120) Y, R2
  120 FORMAT (E10.3, 1X, D9.2)
      IF (ABS(Y - (-125.0D0)) .GT. 1.0D-9) STOP 5
      IF (ABS(R2 - 25.0) .GT. 1.0E-4) STOP 6

C     Logicals, and / taking the rest from a new record.
      READ (5, 130) P, K1, Q
  130 FORMAT (L2, I3, / , L4)
      IF (.NOT. P) STOP 7
      IF (K1 .NE. 77) STOP 8
      IF (Q) STOP 9

C     Three items against a two-descriptor format: reversion takes a
C     fresh record for the third.
      READ (5, 140) K2, K3, I
  140 FORMAT (I3, I3)
      IF (K2 .NE. 11) STOP 10
      IF (K3 .NE. 22) STOP 11
      IF (I .NE. 33) STOP 12

      WRITE (6, 200) K2, K3, X
  200 FORMAT ('OK', I4, I4, F10.2)
      STOP 0
      END
