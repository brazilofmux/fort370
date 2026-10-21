C     An intrinsic's name not in an INTRINSIC statement is a variable
C     (F77 8.8, 15.10): passed bare, it is passed by address as any
C     variable is, and the callee may store through it.  Named in an
C     INTRINSIC statement, it is the procedure.
      PROGRAM INTRAG
      INTRINSIC SQRT
      CALL SETOUT(IFIX, MAX)
      WRITE (6, 100) IFIX, MAX
      CALL APPLY(SQRT, 49.0)
  100 FORMAT (' >V ', 2I4)
      END
      SUBROUTINE SETOUT(I, J)
      I = 17
      J = I + 4
      END
      SUBROUTINE APPLY(F, X)
      EXTERNAL F
      WRITE (6, 100) F(X)
  100 FORMAT (' >F ', F6.2)
      END
