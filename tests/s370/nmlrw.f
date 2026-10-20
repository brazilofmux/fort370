C     NAMELIST (fort370 issue 4): a group written to card images, 80
C     bytes, packs its records to 80 columns and reads back the same;
C     then records written by hand: a subscript, r*value, $...$END,
C     a quoted string with its quote doubled, a name left out, END=,
C     and IOSTAT= for a name that is no item of the group.
      PROGRAM NMLRW
      INTEGER N, K(4), IOS, I
      REAL X, Y(3)
      DOUBLE PRECISION D
      COMPLEX C
      LOGICAL B
      CHARACTER*6 T
      CHARACTER*80 LINE
      NAMELIST /SET/ N, X, D, C, B, T, K, Y
      N = -31
      X = 0.25
      D = -6.5D3
      C = (2.0, -0.75)
      B = .TRUE.
      T = 'OAK''S'
      DO 5 I = 1, 4
    5 K(I) = 100 * I
      Y(1) = 1.0E-3
      Y(2) = 4.0E7
      Y(3) = 0.0
      WRITE (31, SET)
      REWIND 31
   10 READ (31, 101, END=20) LINE
      WRITE (6, 102) LINE
      GO TO 10
   20 REWIND 31
      CALL CLEAR(N, X, D, C, B, T, K, Y)
      READ (31, SET)
      WRITE (6, 103) N, X, D, C, B, T, K, Y
      WRITE (9, 101) ' &SET N=5, K(3)=33, B=.FALSE.,'
      WRITE (9, 101) '  Y=2*1.5, T=''FIR''''S'', D=1D-3 &END'
      WRITE (9, 101) ' &OTHER N=99 &END'
      WRITE (9, 101) ' $SET X=7, K=2*,-8 $END'
      REWIND 9
      READ (9, SET)
      WRITE (6, 103) N, X, D, C, B, T, K, Y
      READ (9, SET)
      WRITE (6, 103) N, X, D, C, B, T, K, Y
      READ (9, SET, END=30)
      WRITE (6, 104) 'NO END'
      GO TO 40
   30 WRITE (6, 104) 'END'
   40 WRITE (10, 101) ' &SET N=1, ELM=2 &END'
      REWIND 10
      READ (10, SET, IOSTAT=IOS)
      WRITE (6, 105) IOS, N
  101 FORMAT (A)
  102 FORMAT (' >|', A, '|')
  103 FORMAT (' >', I4, F7.2, F10.4, 2F6.2, L2, 1X, A, 4I5, 3E11.3)
  104 FORMAT (' >', A)
  105 FORMAT (' >IOSTAT', I3, I4)
      END
      SUBROUTINE CLEAR(N, X, D, C, B, T, K, Y)
      INTEGER N, K(4)
      REAL X, Y(3)
      DOUBLE PRECISION D
      COMPLEX C
      LOGICAL B
      CHARACTER*(*) T
      N = 0
      X = 0.0
      D = 0.0D0
      C = (0.0, 0.0)
      B = .FALSE.
      T = ' '
      DO 5 I = 1, 4
    5 K(I) = 0
      DO 6 I = 1, 3
    6 Y(I) = 0.0
      END
