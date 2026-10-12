C     FORMAT labels are per program unit.  Both units have FORMAT 10.
      PROGRAM SLICE13
      WRITE (6,10)
   10 FORMAT ('MAIN')
      CALL T
      STOP 0
      END
      SUBROUTINE T
      WRITE (6,10)
   10 FORMAT ('SUB')
      END
