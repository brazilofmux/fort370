C     Argument register pressure: more dummy arguments than the ABI has
C     registers, forcing stack-passed parameters and exercising the
C     entry sequence's spill and stack paths.
      PROGRAM SLICE8
      INTEGER A,B,C,D,E,F,G,H,P,Q,R
      A=1
      B=2
      C=3
      D=4
      E=5
      F=6
      G=7
      H=8
      P=9
      Q=10
      CALL TEN(A,B,C,D,E,F,G,H,P,Q,R)
      IF (R .NE. 55) STOP 101
      CALL SWAP(A,B)
      IF (A .NE. 2) STOP 102
      IF (B .NE. 1) STOP 103
      STOP 0
      END

      SUBROUTINE TEN(A,B,C,D,E,F,G,H,P,Q,R)
      INTEGER A,B,C,D,E,F,G,H,P,Q,R
      R = A+B+C+D+E+F+G+H+P+Q
      RETURN
      END

      SUBROUTINE SWAP(X,Y)
      INTEGER X,Y,T
      T = X
      X = Y
      Y = T
      RETURN
      END
