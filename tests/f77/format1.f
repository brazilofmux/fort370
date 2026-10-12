C     FORMAT: field widths, literals, X, /, repeat counts, nested
C     groups, format reversion, implied-DO, and the E/F/G descriptors.
      PROGRAM FORM1
      INTEGER I, V(5)
      REAL R
      DOUBLE PRECISION D
      WRITE (6,100)
  100 FORMAT ('PLAIN TEXT')
      WRITE (6,110) 42, -7
  110 FORMAT ('I:', I5, I5)
      WRITE (6,120) 3.25
  120 FORMAT ('F:', F9.3)
      D = 1234.5678D0
      WRITE (6,130) D
  130 FORMAT ('D:', F12.4)
      WRITE (6,140) 1, 2, 3, 4, 5, 6
  140 FORMAT (3I3)
      WRITE (6,150) 7, 8
  150 FORMAT ('A', I3, /, 'B', I3)
      WRITE (6,160) 1, 2, 3, 4
  160 FORMAT (2(I2, '-'))
      WRITE (6,170) 9
  170 FORMAT (5X, 'INDENTED', I3)
      DO 10 I = 1, 5
         V(I) = I * 11
   10 CONTINUE
      WRITE (6,180) (V(I), I = 1, 5)
  180 FORMAT ('V:', 5I4)
      WRITE (6,190) (V(I), I = 1, 3)
  190 FORMAT (I4)
      R = 0.5
      WRITE (6,200) R
  200 FORMAT ('R:', F6.2)
      STOP 0
      END
