C     Nested DO, block IF with ELSE IF / ELSE, logical IF.
      PROGRAM SLICE2
      INTEGER I, J, N, ACC
      ACC = 0
      DO 20 I = 1, 5
         DO 10 J = 1, I
            ACC = ACC + J
   10    CONTINUE
   20 CONTINUE
      IF (ACC .NE. 35) STOP 21
      N = 0
      IF (ACC .GT. 30) THEN
         N = 1
      ELSE IF (ACC .EQ. 25) THEN
         N = 2
      ELSE
         N = 3
      ENDIF
      IF (N .NE. 1) STOP 22
      N = 0
      IF (ACC .EQ. 25) THEN
         N = 1
      ELSE
         N = 2
      ENDIF
      IF (N .NE. 2) STOP 23
C     Printed sentinel: the compiler once silently ended the unit at
C     the first ENDIF, and this test passed vacuously (both sides
C     exited 0 with empty stdout).  Output after the ENDIFs makes any
C     recurrence visible in the diff.
      WRITE (6, 90) ACC + N
   90 FORMAT ('S', I4)
      STOP 0
      END
