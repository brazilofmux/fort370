C     ** An ENTRY is compiled from its parent's whole text.  Entered
C     at Q, the loop below goes back through the text before the ENTRY
C     statement, where K is stored: compiled from the ENTRY onward
C     alone, GO TO 5 had no statement 5 to reach (S=1, no message,
C     until undefined labels were refused).  The SAVEd K is shared by
C     P and Q, and its load must stay in the loop: a static local of a
C     unit with ENTRY points is not read-only.  Self-checking; success
C     reaches STOP 0.
      INTEGER S
      CALL Q(4, S)
      WRITE (6, 100) S
100   FORMAT (1X, '>ENTRY3', I6)
      IF (S .NE. 10) STOP 1
      CALL P(3, S)
      WRITE (6, 100) S
      IF (S .NE. 21) STOP 2
      STOP 0
      END
      SUBROUTINE P(N, S)
      INTEGER K, N, S, I
      SAVE K
      DATA K /1/
      I = 0
      S = 0
    5 K = K + 1
      IF (I .GE. N) RETURN
      GO TO 10
      ENTRY Q(N, S)
      I = 0
      S = 0
   10 I = I + 1
      S = S + K
      GO TO 5
      END
