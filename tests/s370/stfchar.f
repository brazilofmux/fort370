C     A CHARACTER actual of a statement function is copied to its
C     dummy, cut to the dummy's length (F77 15.4.2; an actual shorter
C     than its dummy is not standard): a substring, an element, a
C     constant and a whole variable.  The dummy got the low byte of
C     the actual's address instead.
      PROGRAM STFCHR
      CHARACTER*12 S
      CHARACTER C, D*3, W(2)*5
      LOGICAL SOLID
      INTEGER NQ, NB
      SOLID(C) = C .NE. ' ' .AND. C .NE. ','
      NQ(D) = INDEX(D, 'Q')
      NB(D) = INDEX(D, ' ')
      S = 'MX ,Q7 ZQ'
      W(1) = 'RQTSV'
      W(2) = 'KL'
      N = 0
      DO 10 I = 1, 12
         IF (SOLID(S(I:I))) N = N + 1
   10 CONTINUE
      I = 5
      WRITE (6, 100) N, SOLID(S(3:3)), SOLID(S(I:I)), SOLID('Y')
      WRITE (6, 101) NQ(S(4:9)), NQ(W(1)), NQ(S), NB(W(2)), NB('A BC')
  100 FORMAT (' >S ', I3, 3L2)
  101 FORMAT (' >Q ', 5I3)
      END
