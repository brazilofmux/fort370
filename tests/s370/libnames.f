C     A program's subprograms may have the names of the C library's
C     own routines, which the runtime calls: FOPEN, FREE, MALLOC,
C     STRLEN, WTO.  At link time such a name was the program's, and
C     the library's calls went to it: MINOS has a SUBROUTINE FOPEN,
C     and its run stopped before the first statement, libc370 unable
C     to open SYSPRINT (Rene Ferland, 2026-10-19).
      PROGRAM LIBNAM
      INTEGER STRLEN, MALLOC
      CALL FOPEN(3)
      CALL FREE(4.5)
      WRITE (6, 100) 'STRLEN', STRLEN(7)
      WRITE (6, 100) 'MALLOC', MALLOC(8)
      CALL WTO
  100 FORMAT (' >', A, I4)
      END
      SUBROUTINE FOPEN(MODE)
      WRITE (6, 100) MODE
  100 FORMAT (' >FOPEN MODE', I3)
      END
      SUBROUTINE FREE(X)
      WRITE (6, 100) X
  100 FORMAT (' >FREE', F6.2)
      END
      INTEGER FUNCTION STRLEN(N)
      STRLEN = N * 10
      END
      INTEGER FUNCTION MALLOC(N)
      MALLOC = N * 100
      END
      SUBROUTINE WTO
      WRITE (6, 100)
  100 FORMAT (' >WTO, A FORTRAN SUBROUTINE')
      END
