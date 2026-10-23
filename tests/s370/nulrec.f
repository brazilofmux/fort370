C     A record is all its characters, X'00' among them: a CHARACTER
C     item holding CHAR(0) cut the record there, and the text after
C     it was not written; read back, a record was cut at its first
C     X'00' too.  A printer shows X'00' as a blank.  Written to a
C     variable-length file (unit 7) and a card file (unit 31) and read
C     back, each record must come back whole: >F 7 T 0 0 0 and
C     >F 31 T 0 0 0.
      PROGRAM NULREC
      CHARACTER*12 L, M
      INTEGER U(2), K
      DATA U /7, 31/
      L = '>N'
      L(3:5) = CHAR(0) // CHAR(0) // CHAR(0)
      L(6:12) = 'WXYZ 42'
      WRITE (6, 100) L
      WRITE (6, 100) L(1:5), '>T'
      DO 10 K = 1, 2
         WRITE (U(K), 101) L
         REWIND U(K)
         M = '?'
         READ (U(K), 101) M
         WRITE (6, 102) U(K), M .EQ. L, ICHAR(M(3:3)), ICHAR(M(4:4)),
     1      ICHAR(M(5:5))
   10 CONTINUE
  100 FORMAT (1X, A, A)
  101 FORMAT (A)
  102 FORMAT (' >F', I3, L2, 3I2)
      END
