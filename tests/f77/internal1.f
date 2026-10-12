      PROGRAM INF
      CHARACTER*43 A
      DOUBLE PRECISION D
      A = '             0.23456D+05'
      READ (UNIT=A, FMT=10) D
 10   FORMAT (13X, D10.5)
      WRITE (6, 20) D
 20   FORMAT (1X, F12.3)
      WRITE (UNIT=A, FMT=30) 1.5D0
 30   FORMAT (13X, D10.5)
      WRITE (6, '(1X, A)') A
      READ (UNIT=A(14:), FMT='(D10.5)') D
      WRITE (6, 20) D
      END
