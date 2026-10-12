      PROGRAM DP
      EXTERNAL SQ
      INTRINSIC IABS
      CALL SUB(SQ, 3.0, R)
      WRITE (6, *) R
      I = IAPPLY(IABS, -7)
      WRITE (6, *) I
      CALL S2(SQ, 2.0)
      END
      SUBROUTINE SUB(F, X, R)
      REAL F
      R = F(X) + 1.0
      END
      INTEGER FUNCTION IAPPLY(G, N)
      INTEGER G
      IAPPLY = G(N) * 2
      END
      SUBROUTINE S2(F, X)
      REAL F
      WRITE (6, *) F(X)
      END
      REAL FUNCTION SQ(X)
      SQ = X * X
      END
