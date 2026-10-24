C     The mathematical functions' arguments out of their domains, as
C     FORTLIB treats them (issue #17): each gets its IHC message, as
C     FORTRAN H's, and its standard fixup -- SQRT of the magnitude,
C     ALOG of zero the largest negative number and of a negative one
C     the log of its magnitude, EXP and SINH and COSH too large the
C     largest number, SIN and COS of a huge argument SQRT(2)/2, TAN
C     of a huge one 1 and at a singularity the largest, ARSIN and
C     ARCOS and ATAN2(0,0) zero, a zero base to a power not positive
C     zero, a negative base to a REAL power its magnitude's.  The
C     expected lines:
C       >R   0.3000000E+01 -0.7237005E+76  0.6931471E+00  0.7237005E+76
C       >R   0.7071068E+00  0.1000000E+01  0.7237005E+76  0.0000000E+00
C       >R   0.0000000E+00  0.7237005E+76  0.0000000E+00  0.5000000E+00
C       >D   0.2500000000000000D+01 -0.7237005577332262D+76
C       >D   0.2302585092994046D+01  0.7237005577332262D+76
C       >D   0.7071067811865477D+00  0.0000000000000000D+00
C       >P   0.0000000E+00  0.0000000000000000D+00           0
      PROGRAM MATHCK
      REAL X, R(4), P, ZR
      DOUBLE PRECISION D(2), Q, ZD
      INTEGER IZ, K
      ZR = 0.0
      ZD = 0.0D0
      IZ = 0
      K = -3
      X = -9.0
      R(1) = SQRT(X)
      R(2) = ALOG(ZR)
      X = -2.0
      R(3) = ALOG(X)
      R(4) = EXP(181.5)
      WRITE (6, 1) R
      R(1) = COS(2.5E6)
      R(2) = TAN(-3.0E7)
      X = 4.712389
      R(3) = TAN(X)
      R(4) = ARSIN(-1.25)
      WRITE (6, 1) R
      R(1) = ATAN2(ZR, ZR)
      R(2) = COSH(-190.0)
      R(3) = ZR**(-2.5)
      X = -4.0
      R(4) = X**(-0.5)
      WRITE (6, 1) R
      D(1) = DSQRT(-6.25D0)
      D(2) = DLOG10(ZD)
      WRITE (6, 2) D
      D(1) = DLOG(-10.0D0)
      D(2) = DSINH(-181.0D0)
      WRITE (6, 2) D
      D(1) = DSIN(7.5D16)
      D(2) = DARCOS(2.0D0)
      WRITE (6, 2) D
      P = ZR**K
      Q = ZD**K
      WRITE (6, 3) P, Q, IZ**K
    1 FORMAT (' >R ', 4E15.7)
    2 FORMAT (' >D ', 2D24.16)
    3 FORMAT (' >P ', E15.7, D24.16, I12)
      END
