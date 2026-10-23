C     A record is all its characters, X'00' among them: a CHARACTER
C     item holding CHAR(0) cut the record there, and the text after
C     it was not written.  A printer shows X'00' as a blank.
      PROGRAM NULREC
      CHARACTER*12 L
      L = '>N'
      L(3:5) = CHAR(0) // CHAR(0) // CHAR(0)
      L(6:12) = 'WXYZ 42'
      WRITE (6, 100) L
      WRITE (6, 100) L(1:5), '>T'
  100 FORMAT (1X, A, A)
      END
