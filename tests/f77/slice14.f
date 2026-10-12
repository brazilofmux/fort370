C     E and D descriptors with real E's in them, and the kP scale
C     factor: E unchanged in value with the mantissa shifted, F
C     multiplied, negative k, and the stickiness across items.
      PROGRAM SLICE14
      REAL X
      DOUBLE PRECISION D
      X = 12.5
      D = 0.0004567D0
      WRITE(*,100) X
  100 FORMAT(E12.4)
      WRITE(*,110) X
  110 FORMAT(1PE12.4)
      WRITE(*,120) X
  120 FORMAT(2PE13.4)
      WRITE(*,130) D
  130 FORMAT(D14.5)
      WRITE(*,140) D
  140 FORMAT(1PD14.5)
      WRITE(*,150) X
  150 FORMAT(-1PE13.4)
      WRITE(*,160) X, X
  160 FORMAT(1P,E12.4,E12.4)
      WRITE(*,170) X
  170 FORMAT(2PF10.2)
C     kP on G: F-form (12.5) ignores the scale, matching gfortran;
C     E-form (0.00125) applies it through fio_efmt.
      WRITE(*,180) X
  180 FORMAT(1PG12.4)
      X = 0.00125
      WRITE(*,190) X
  190 FORMAT(1PG12.4)
      WRITE(*,200) X
  200 FORMAT(G12.4)
      END
