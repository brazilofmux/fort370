      PROGRAM UNF
      DOUBLE PRECISION D
      CHARACTER*6 C
      WRITE (7) 1, 2.5, 3.5D0, 'ABCDEF'
      WRITE (7) 4, 5.5, 6.5D0, 'GHIJKL'
      ENDFILE 7
      REWIND 7
      READ (7) I, X, D, C
      WRITE (6, *) I, X, D, C
      READ (7) I, X, D, C
      WRITE (6, *) I, X, D, C
      READ (7, END=10) I
      WRITE (6, *) 'NO EOF'
 10   WRITE (6, *) 'EOF OK'
      BACKSPACE 7
      BACKSPACE 7
      READ (7) I
      WRITE (6, *) I
      END
