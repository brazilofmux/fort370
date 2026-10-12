      PROGRAM FILE1
C     OPEN/CLOSE/REWIND on a real file.  Write three records, close,
C     reopen OLD and read them back with the END= loop, REWIND and
C     reread the first, CLOSE with STATUS='DELETE' -- proven by the
C     STATUS='NEW' open of the same name succeeding right after --
C     then round-trip one more record.  The harness runs each side in
C     scratch space, and the sequence is deliberately re-runnable in
C     the same directory (the harness executes the binary twice).
C     Self-checking; success reaches STOP 0.
      INTEGER I, N
      DOUBLE PRECISION X, SUM

      OPEN (8, FILE='scratch1.dat')
      DO 10 I = 1, 3
      X = I * 1.5D0
      WRITE (8, 100) I, X
  100 FORMAT (I4, F10.3)
   10 CONTINUE
      CLOSE (8)

      OPEN (8, FILE='scratch1.dat', STATUS='OLD')
      N = 0
      SUM = 0.0D0
   20 READ (8, 100, END=30) I, X
      N = N + 1
      SUM = SUM + X
      GOTO 20
   30 IF (N .NE. 3) STOP 1
      IF (ABS(SUM - 9.0D0) .GT. 1.0D-9) STOP 2
      WRITE (6, 110) N, SUM
  110 FORMAT ('N=', I3, ' SUM=', F10.3)

      REWIND 8
      READ (8, 100) I, X
      IF (I .NE. 1) STOP 3
      IF (ABS(X - 1.5D0) .GT. 1.0D-9) STOP 4
      WRITE (6, 120) I, X
  120 FORMAT ('FIRST', I3, F10.3)
      CLOSE (8, STATUS='DELETE')

C     NEW succeeds only because the DELETE really removed the file.
      OPEN (9, FILE='scratch1.dat', STATUS='NEW')
      WRITE (9, 130) 77
  130 FORMAT (I6)
      CLOSE (9)
      OPEN (9, FILE='scratch1.dat', STATUS='OLD')
      READ (9, 130) I
      IF (I .NE. 77) STOP 5
      WRITE (6, 140) I
  140 FORMAT ('BACK', I4)
      CLOSE (9, STATUS='DELETE')
      STOP 0
      END
