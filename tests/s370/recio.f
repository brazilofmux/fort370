C     RECIO -- the record layer of fort370's runtime on MVS
C     (runtime/s370/f77rec.c), checking itself: direct access written
C     out of order (records past the end, then filler, then rewritten in
C     place), formatted and unformatted; an unformatted sequential file
C     with REWIND, BACKSPACE, a WRITE after BACKSPACE, ENDFILE and END=.
C     Prints one line per check, " >name OK" or " >name BAD", then the
C     count of bad ones.  Units 21-23 are scratch DDs FT21F001-FT23F001.
      INTEGER I, J, K, N, NBAD, IV(3)
      CHARACTER*20 C
      NBAD = 0
C     --- unformatted direct, RECL=12 (three INTEGERs)
      OPEN (21, ACCESS='DIRECT', RECL=12)
      DO 10 I = 1, 5
        WRITE (21, REC=I) I, 10*I, 100*I
   10 CONTINUE
      WRITE (21, REC=9) 9, 90, 900
      WRITE (21, REC=3) -3, -30, -300
      READ (21, REC=9) IV
      CALL CHK('DIRU PAST END', IV(1).EQ.9 .AND. IV(3).EQ.900, NBAD)
      READ (21, REC=3) IV
      CALL CHK('DIRU REWRITE', IV(1).EQ.-3 .AND. IV(2).EQ.-30, NBAD)
      READ (21, REC=5) IV
      CALL CHK('DIRU IN PLACE', IV(2).EQ.50, NBAD)
      INQUIRE (21, NEXTREC=N)
      CALL CHK('DIRU NEXTREC', N.EQ.6, NBAD)
      CLOSE (21)
      OPEN (21, ACCESS='DIRECT', RECL=12)
      READ (21, REC=1) IV
      CALL CHK('DIRU REOPEN', IV(3).EQ.100, NBAD)
      READ (21, REC=9) IV
      CALL CHK('DIRU REOPEN END', IV(2).EQ.90, NBAD)
      CLOSE (21)
C     --- formatted direct, RECL=20, two records per WRITE
      OPEN (22, ACCESS='DIRECT', RECL=20, FORM='FORMATTED')
      WRITE (22, 20, REC=2) 'SECOND', 'THIRD'
   20 FORMAT (A/A)
      WRITE (22, 20, REC=1) 'FIRST'
      READ (22, 21, REC=3) C
   21 FORMAT (A)
      CALL CHK('DIRF SLASH', C.EQ.'THIRD', NBAD)
      READ (22, 21, REC=1) C
      CALL CHK('DIRF FIRST', C.EQ.'FIRST', NBAD)
      INQUIRE (22, NEXTREC=N)
      CALL CHK('DIRF NEXTREC', N.EQ.2, NBAD)
      CLOSE (22)
C     --- unformatted sequential
      DO 30 I = 1, 6
        WRITE (23) I, I*I
   30 CONTINUE
      REWIND 23
      READ (23) J, K
      READ (23) J, K
      CALL CHK('SEQ READ', J.EQ.2 .AND. K.EQ.4, NBAD)
      BACKSPACE 23
      READ (23) J, K
      CALL CHK('SEQ BACKSPACE', J.EQ.2, NBAD)
      BACKSPACE 23
      WRITE (23) 20, 400
      ENDFILE 23
      REWIND 23
      N = 0
   31 READ (23, END=32) J, K
      N = N + 1
      GO TO 31
   32 CALL CHK('SEQ TRUNCATE', N.EQ.2 .AND. J.EQ.20, NBAD)
      BACKSPACE 23
      WRITE (23) 3, 9
      ENDFILE 23
      REWIND 23
      READ (23) J
      READ (23) J
      READ (23) J, K
      CALL CHK('SEQ AFTER EOF', J.EQ.3 .AND. K.EQ.9, NBAD)
      WRITE (6, 90) NBAD
   90 FORMAT (' >BAD', I3)
      END
      SUBROUTINE CHK(NAME, OK, NBAD)
      CHARACTER*(*) NAME
      LOGICAL OK
      INTEGER NBAD
      IF (OK) THEN
        WRITE (6, 1) NAME
      ELSE
        WRITE (6, 2) NAME
        NBAD = NBAD + 1
      END IF
    1 FORMAT (' >', A, ' OK')
    2 FORMAT (' >', A, ' BAD')
      END
