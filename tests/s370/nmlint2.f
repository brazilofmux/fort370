C     NAMELIST of INTEGER*2 and LOGICAL*1 items: each element is its
C     own width, a halfword or a byte, when the group is written, read
C     back and stepped through.  The fullwords on either side of them
C     must come through untouched.
      PROGRAM NMLI2
      INTEGER M, N
      INTEGER*2 H(3)
      LOGICAL*1 P, Q
      COMMON /BOX/ M, H, P, Q, N
      NAMELIST /PAIR/ H, P, Q
      M = 777
      N = -4242
      H(1) = 1
      H(2) = -2
      H(3) = 30003
      P = .TRUE.
      Q = .FALSE.
      WRITE (12, PAIR)
      REWIND 12
      H(1) = 0
      H(2) = 0
      H(3) = 0
      P = .FALSE.
      Q = .TRUE.
      READ (12, PAIR)
      IF (M .NE. 777) STOP 1
      IF (N .NE. -4242) STOP 2
      IF (H(1) .NE. 1 .OR. H(2) .NE. -2 .OR. H(3) .NE. 30003) STOP 3
      IF (.NOT. P .OR. Q) STOP 4
      WRITE (9, 101) ' &PAIR H(2)=-7, Q=T, P=F &END'
      REWIND 9
      READ (9, PAIR)
      IF (M .NE. 777 .OR. N .NE. -4242) STOP 5
      WRITE (6, 102) H, P, Q
  101 FORMAT (A)
  102 FORMAT (' >NL ', 3I7, 2L2)
      END
