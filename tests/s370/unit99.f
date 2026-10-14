C     ** Units are 0-99, as IBM's Fortran numbers them: 55 and 66 are
C     Rene Ferland's ADDAD parameter and output files, refused as
C     beyond unit 31 until 2026-10-14.1.  Unit 99 here is OPENed onto
C     DD FT01F001 (FILE= names a DD on MVS, a file on a host), written,
C     rewound and read back.  Unit 0 goes to DD FT00F001 when the job
C     has one, SYSTERM otherwise.  Self-checking; success reaches STOP 0.
      INTEGER I, J, K
      OPEN (99, FILE='FT01F001', STATUS='UNKNOWN')
      DO 10 I = 1, 3
         WRITE (99, 100) I, I*I
   10 CONTINUE
  100 FORMAT (2I5)
      REWIND 99
      K = 0
      DO 20 I = 1, 3
         READ (99, 100) J, K
         IF (J .NE. I .OR. K .NE. I*I) STOP 1
   20 CONTINUE
      CLOSE (99)
      WRITE (0, 200)
  200 FORMAT (' UNIT 0')
      WRITE (6, 300) J, K
  300 FORMAT (1X, '>UNIT99', 2I5)
      STOP 0
      END
