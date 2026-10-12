C     Self-checking: every wrong answer exits with its own code, so a
C     miscompile changes the exit status.  Success falls through to 0.
      PROGRAM SLICE1
      INTEGER I, S, T
      S = 0
      DO 10 I = 1, 10
         S = S + I
   10 CONTINUE
      IF (S .NE. 55) STOP 11
      T = 0
      DO 20 I = 1, 10
         T = T + I*I
   20 CONTINUE
      IF (T .NE. 385) STOP 12
      IF (I .NE. 11) STOP 13
      STOP 0
      END
