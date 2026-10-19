C     Zero in E editing has the exponent 0 whatever the scale factor:
C     1PE10.2 is 0.00E+00 under IBM's library, and fort370 wrote
C     0.00E-01, subtracting k from zero's exponent as from any other
C     (MINOS's iteration log, Rene Ferland, 2026-10-19).
      PROGRAM EZERO
      DOUBLE PRECISION Z, X
      Z = 0.0D0
      X = 1.5D0
      WRITE (6, 100) Z, X, Z, X
      WRITE (6, 101) Z, X
      WRITE (6, 102) Z, Z
  100 FORMAT (' >', 1PE10.2, E10.2, 0PE10.2, E10.2)
  101 FORMAT (' >', 2PE12.3, -1PE12.3)
  102 FORMAT (' >', 1PD14.5, 1PE12.3E3)
      END
