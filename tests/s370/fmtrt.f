C     Formats given at run time (fort370 issue 25): blanks in them are
C     not significant outside their strings, as in a FORMAT statement;
C     a format built by WRITE has them.  A format certainly wrong is
C     refused when it is used, here by READ's IOSTAT.
      PROGRAM FMTRT
      CHARACTER*12 F1
      CHARACTER*13 F2
      CHARACTER*22 F3
      CHARACTER*18 F4
      CHARACTER*12 F5
      CHARACTER*8 LINE, F6
      INTEGER M(3,3), N1, N2, IOS
      DATA F1 /'('' >'' ,3I 2)'/
      DATA F3 /'(1X, 4 H> AB, 2 I 3)'/
      DATA F4 /'('' > ''''Q'''''', I 2)'/
      DATA F5 /'( 2I 3)junk'/
      DATA F6 /'(HI)'/
      DO 10 J = 1, 3
      DO 10 I = 1, 3
         M(I,J) = 10*I + J
   10 CONTINUE
      WRITE (6, F1) 1, 2, 3, 4, 5, 6
C     count and width written at run time: (' >', 3I  4)
      F2 = '('' >'','
      WRITE (F2(7:13), '(I2,''I'',I3,'')'')') 3, 4
      WRITE (6, '(A,A)') ' >', F2
      WRITE (6, F2) M
      WRITE (6, F3) 7, 8
      WRITE (6, F4) 9
      WRITE (6, '( '' >'' , 2 I 4 )') 5, 6
      LINE = ' 12 34'
      READ (LINE, F5) N1, N2
      WRITE (6, F1) N1, N2
      IOS = 0
      READ (LINE, F6, IOSTAT=IOS) N1
      WRITE (6, '('' >BAD '',L1)') IOS .GT. 0
      END
