C     ** A FORMAT whose text is mostly apostrophes: each one is written
C     twice in the assembler's C'...' constant, and the compiler put
C     40 of the source's characters to a line, not 40 of its own, so
C     the line passed column 71 and the compile stopped (Marco
C     Verpelli, 2026-10-17).  The text it writes is a format, built
C     into a CHARACTER variable and printed.
      PROGRAM LONGFM
      CHARACTER*48 FMT
      WRITE (FMT, 100) 3
  100 FORMAT ('(''',' > toll(''',',','I3',',',''':''',',',I1,
     &       '(I3,'',''','),I3,',''') = ''',',','F5.3',')')
      WRITE (6, 101) FMT
  101 FORMAT (1X, '>', A)
      WRITE (6, 102)
  102 FORMAT (' >''''''''''''''''''''''''''''''''''''''''''''''''',
     &        '''''''''''''''''''''''''''''''''''''''''''''''''<')
      END
