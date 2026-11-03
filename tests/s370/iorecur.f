C     ** An I/O statement in a function referenced in another's I/O list
C     is I/O inside I/O, which F77 forbids; the runtime has one set of
C     statement state, and the outer statement's record was lost without
C     a word (fort370 issue 39).  It now stops the program with a
C     message.  The same function in an assignment is fine, and so is a
C     READ that leaves by its END=, which has no end of its own: the
C     I/O after both goes on.  Expected: >ASSIGN, >ENDS 3, then the
C     message and no >AFTER.
      CHARACTER*8 FUNCTION KTOC(K)
      INTEGER K
      WRITE (KTOC, '(I8)') K
      END
      PROGRAM IORECR
      CHARACTER*8 KTOC
      CHARACTER*16 T
      INTEGER J, N
      T = 'K='//KTOC(4096)
      PRINT *, '>ASSIGN ', T
      DO 10 J = 1, 3
        WRITE (8, '(I4)') J
   10 CONTINUE
      REWIND 8
      N = 0
   20 READ (8, '(I4)', END=30) J
      N = N + 1
      GO TO 20
   30 PRINT *, '>ENDS', N
      PRINT *, '>NESTED ', KTOC(77)
      PRINT *, '>AFTER'
      END
