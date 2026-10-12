C     FUNCTION units: INTEGER, REAL and DOUBLE PRECISION results,
C     called from expressions, including as an actual argument.
      PROGRAM SLICE7
      INTEGER ISQ, N
      REAL RHALF, X
      DOUBLE PRECISION DCUBE, D
      N = ISQ(7)
      IF (N .NE. 49) STOP 91
      N = ISQ(ISQ(2))
      IF (N .NE. 16) STOP 92
      N = ISQ(3) + ISQ(4)
      IF (N .NE. 25) STOP 93
      X = RHALF(5.0)
      IF (X .NE. 2.5) STOP 94
      D = DCUBE(3.0D0)
      IF (D .NE. 27.0D0) STOP 95
      D = DCUBE(2.0D0) + 1.0D0
      IF (D .NE. 9.0D0) STOP 96
      STOP 0
      END

      INTEGER FUNCTION ISQ(K)
      INTEGER K
      ISQ = K * K
      RETURN
      END

      REAL FUNCTION RHALF(Y)
      REAL Y
      RHALF = Y / 2.0
      RETURN
      END

      DOUBLE PRECISION FUNCTION DCUBE(Z)
      DOUBLE PRECISION Z
      DCUBE = Z * Z * Z
      RETURN
      END
