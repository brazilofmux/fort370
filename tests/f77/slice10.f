C     Intrinsics: ABS/IABS/DABS, MAX/MIN families (n-ary), MOD, the
C     conversions, SIGN, and SQRT.
      PROGRAM SLICE10
      INTEGER I, J
      REAL X, Y
      DOUBLE PRECISION D, E
      I = -7
      IF (IABS(I) .NE. 7) STOP 121
      IF (ABS(I) .NE. 7) STOP 122
      X = -2.5
      IF (ABS(X) .NE. 2.5) STOP 123
      D = -3.5D0
      IF (DABS(D) .NE. 3.5D0) STOP 124
      IF (DABS(-D) .NE. 3.5D0) STOP 125
      IF (MAX0(3, 9) .NE. 9) STOP 126
      IF (MIN0(3, 9) .NE. 3) STOP 127
      IF (MAX0(3, 9, 5) .NE. 9) STOP 128
      IF (MIN0(3, 9, 5, 1) .NE. 1) STOP 129
      IF (AMAX1(1.5, 2.5) .NE. 2.5) STOP 130
      IF (DMAX1(1.5D0, 2.5D0) .NE. 2.5D0) STOP 131
      IF (DMIN1(1.5D0, 2.5D0) .NE. 1.5D0) STOP 132
      IF (DMAX1(-1.5D0, -2.5D0) .NE. -1.5D0) STOP 133
      IF (MOD(17, 5) .NE. 2) STOP 134
      IF (MOD(-17, 5) .NE. -2) STOP 135
      IF (INT(3.9) .NE. 3) STOP 136
      IF (IDINT(3.9D0) .NE. 3) STOP 137
      D = DBLE(3)
      IF (D .NE. 3.0D0) STOP 138
      X = REAL(7)
      IF (X .NE. 7.0) STOP 139
      IF (SIGN(3, -1) .NE. -3) STOP 140
      IF (DSIGN(3.0D0, -1.0D0) .NE. -3.0D0) STOP 141
      IF (SQRT(16.0) .NE. 4.0) STOP 142
      E = DSQRT(9.0D0)
      IF (E .NE. 3.0D0) STOP 143
      STOP 0
      END
