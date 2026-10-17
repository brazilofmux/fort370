C A dummy spliced in at an index an earlier unit's PARAMETER held
C must not inherit that symbol's fields (fort370 822e933).
      SUBROUTINE PFILL(X)
      INTEGER P1,P2,P3,P4,P5,P6,P7,P8
      PARAMETER (P1=1,P2=2,P3=3,P4=4,P5=5,P6=6,P7=7,P8=8)
      CHARACTER*7 C1,C2,C3,C4
      COMMON /BLK/ Q1,Q2,Q3,Q4
      X = P1+P2+P3+P4+P5+P6+P7+P8
      C1 = 'ABCDEFG'
      C2 = C1
      C3 = C2
      C4 = C3
      Q1 = 1.0
      Q2 = Q1
      Q3 = Q2
      Q4 = Q3
      END
      PROGRAM MAIN
      INTEGER K
      REAL Y
      CALL PFILL(Y)
      K = 0
      CALL BUMP(K)
      CALL BUMP(K)
      IF (K .NE. 2) STOP 1
      IF (Y .NE. 36.0) STOP 2
      STOP 0
      END
      SUBROUTINE BUMP(J)
      J = J + 1
      END
