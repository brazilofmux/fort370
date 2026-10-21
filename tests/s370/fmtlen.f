C     A CHARACTER format is its declared length (F77 13.1.1), not the
C     bytes that follow it in storage: F lacks its closing ) and the )
C     that G holds right after it in COMMON must not complete it.  An
C     array named whole is all its elements; a substring, its own.  A
C     dummy array's extents are not its size, so F(N), F(*) and F(1)
C     are read to their ) as H reads them.
      PROGRAM FMTLEN
      CHARACTER*4 F
      CHARACTER*2 G
      CHARACTER*3 W(2)
      CHARACTER*6 V(2)
      CHARACTER*8 REC
      CHARACTER*14 S
      INTEGER K, IOS
      COMMON /FMTS/ F, G
      F = '(I5 '
      G = ' )'
      REC = '   67   '
      K = 0
      IOS = 0
      READ (REC, F, ERR=10, IOSTAT=IOS) K
      STOP 1
   10 WRITE (6, 100) IOS, K
      W(1) = '(I4'
      W(2) = ')'
      READ (REC, W) K
      WRITE (6, 101) K
      S = '('' >S'',I3)XYZ'
      WRITE (6, S(1:10)) K
      V(1) = '('' >A'''
      V(2) = ',2I3) '
      CALL SHOWA(V, 2)
      CALL SHOWS(V)
      CALL SHOW1(V)
  100 FORMAT (' >ERR ', 2I3)
  101 FORMAT (' >W ', I4)
      END
      SUBROUTINE SHOWA(F, N)
      INTEGER N
      CHARACTER*6 F(N)
      WRITE (6, F) 12, 34
      END
      SUBROUTINE SHOWS(F)
      CHARACTER*6 F(*)
      WRITE (6, F) 56, 78
      END
      SUBROUTINE SHOW1(F)
      CHARACTER*6 F(1)
      WRITE (6, F) 90, 11
      END
