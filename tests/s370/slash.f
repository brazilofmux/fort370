C     ** An empty record -- a slash at the end of a format, two slashes,
C     FORMAT(/) -- is a record: libc370 writes none for an empty line,
C     so a printed blank line vanished, FORMAT(1X,'FIRST LINE',/) gave
C     no blank line before the next (Marco Verpelli, 2026-10-16), and
C     a file lost the record.  Written to a file and read back, three
C     records and five; on unit 6, the blank lines gfortran prints.
C     Success prints >SLASH and the checks passed and reaches STOP 0.
      CHARACTER*4 A, B, C, D, E
      INTEGER NOK
      NOK = 0
      OPEN (1, STATUS='SCRATCH', FORM='FORMATTED')
      WRITE (1, 100) 'X'
      WRITE (1, 101) 'Y'
      WRITE (1, 102) 'P', 'Q'
      WRITE (1, 103)
      REWIND 1
      READ (1, 101, END=90) A, B, C
      IF (A .NE. 'X' .OR. B .NE. ' ' .OR. C .NE. 'Y') STOP 1
      NOK = NOK + 1
      READ (1, 101, END=90) A, B, C, D, E
      IF (A .NE. 'P' .OR. B .NE. ' ' .OR. C .NE. 'Q') STOP 2
      IF (D .NE. ' ' .OR. E .NE. ' ') STOP 3
      NOK = NOK + 1
      WRITE (6, 104)
      WRITE (6, 105) NOK
      STOP 0
   90 STOP 9
  100 FORMAT (A, /)
  101 FORMAT (A)
  102 FORMAT (A, //, A)
  103 FORMAT (/)
  104 FORMAT (1X, 'FIRST LINE', /)
  105 FORMAT (1X, '>SLASH', I3)
      END
