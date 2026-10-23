C     Program interrupts recovered as FORTLIB recovers them (issue
C     #17): an overflow gives the largest number with its sign
C     (IHC207I), an underflow zero (IHC208I), a division by zero the
C     dividend (IHC209I), each message followed by STANDARD FIXUP
C     TAKEN, and a summary of errors at the end.  Each result is used,
C     so that none of the divisions is dead; MOD by zero leaves the
C     remainder register as it was, zero.  The expected lines:
C       >O   0.7237005E+76 -0.7237005E+76  0.7237005E+76
C       >Q  0.7237005577332262D+76
C       >U   0.0000000E+00
C       >Z   0.4000000E+01 0.6000000000000000D+01
C       >J            9          -9
      PROGRAM PINT
      REAL A, B, C, Z
      DOUBLE PRECISION P, Q
      INTEGER I, J, K
      A = 2.0E68
      B = A*A
      C = -A*(A*4.0)
      Z = 6.5E75
      WRITE (6, 1) B, C, Z+Z
      P = 3.0D72
      Q = P*P
      WRITE (6, 2) Q
      A = 2.0E-66
      B = A*A
      WRITE (6, 3) B
      Z = 0.0
      A = 4.0
      P = 6.0D0
      WRITE (6, 4) A/Z, P/DBLE(Z)
      J = 9
      K = 0
      I = J/K
      J = MOD(J, K) - 9
      WRITE (6, 5) I, J
    1 FORMAT (' >O ', 3E15.7)
    2 FORMAT (' >Q ', D23.16)
    3 FORMAT (' >U ', E15.7)
    4 FORMAT (' >Z ', E15.7, D23.16)
    5 FORMAT (' >J ', 2I12)
      END
