C     LINPACK's actual output shape: a formatted residual/timing table,
C     which is what the benchmark prints and what the FORMAT engine has
C     to get right -- E and F fields side by side, headers, and an
C     implied-DO over a solution vector.
      PROGRAM FORM2
      INTEGER I, N
      DOUBLE PRECISION X(4), RESID, T
      N = 4
      DO 10 I = 1, N
         X(I) = 1.0D0 + DBLE(I) / 8.0D0
   10 CONTINUE
      RESID = 1.25D-7
      T = 0.125D0
      WRITE (6,100)
  100 FORMAT ('     NORM. RESID      TIME       MFLOPS')
      WRITE (6,110) RESID, T, 12.5D0
  110 FORMAT (2X, E14.7, 2X, F8.4, 2X, F10.3)
      WRITE (6,120) (X(I), I = 1, N)
  120 FORMAT (' X =', 4F9.4)
      WRITE (6,130) N, RESID
  130 FORMAT (' N =', I4, '  RESID =', E12.5)
      STOP 0
      END
