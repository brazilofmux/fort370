C     ** A WRITE whose items run out inside a repeated data descriptor
C     ends its record there: in 3('!',3A1) five items make !***!** and
C     the third '!' is not written (six make !***!***!, the literal
C     coming before the next data descriptor).  The runtime started the
C     format afresh when the items ran out, and wrote it: Rene
C     Ferland's ADDAD/ANCORR drew its histogram bars, 4('!',15A1), with
C     a '!' at the end that VS FORTRAN does not write.  Self-checking;
C     success reaches STOP 0.
      CHARACTER*12 L
      WRITE (L, 100) ('*', K = 1, 5)
  100 FORMAT (3('!', 3A1))
      WRITE (6, 200) L
  200 FORMAT (1X, '>FMTEND ', A)
      IF (L .NE. '!***!**') STOP 1
      WRITE (L, 100) ('*', K = 1, 6)
      IF (L .NE. '!***!***!') STOP 2
      STOP 0
      END
