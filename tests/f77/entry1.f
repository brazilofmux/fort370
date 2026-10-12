      PROGRAM EN
      EXTERNAL SQ
      REAL SQ
      CALL SUB(3, I)
      WRITE (6, *) I
      CALL E1(5, J)
      WRITE (6, *) J
      CALL E2(2.0, R, SQ)
      WRITE (6, *) R
      CALL E3(1, *10, *20)
      WRITE (6, *) 'FELL'
      GO TO 30
 10   WRITE (6, *) 'ALT1'
      GO TO 30
 20   WRITE (6, *) 'ALT2'
 30   WRITE (6, *) RF(2.0), EF(2.0)
      END
      SUBROUTINE SUB(IA, IB)
      INTEGER W(2)
      REAL F
      W(1) = 10
      IB = IA + W(1)
      RETURN
      ENTRY E1(IC, ID)
      ID = IC * 100
      RETURN
      ENTRY E2(X, Y, F)
      Y = F(X) + 0.5
      RETURN
      ENTRY E3(K, *, *)
      IF (K .EQ. 1) RETURN 2
      RETURN 1
      END
      REAL FUNCTION SQ(X)
      SQ = X * X
      END
      FUNCTION RF(X)
      RF = X + 1.0
      RETURN
      ENTRY EF(Y)
      RF = Y + 2.0
      END
