C     NAMELIST items that are dummy arguments (fort370 issue 4): a
C     scalar, and an adjustable array whose bounds are run-time values,
C     its lower bound not 1; written to card images, then read back
C     with a subscript counted from that lower bound.
      PROGRAM NMLDUM
      REAL V(6)
      INTEGER M
      DO 5 I = 1, 6
    5 V(I) = 0.5 * I
      M = 6
      CALL SHOW(V, M, -2)
      END
      SUBROUTINE SHOW(A, N, L)
      INTEGER N, L
      REAL A(L:L+N-1)
      CHARACTER*80 LINE
      NAMELIST /ARR/ N, A
      WRITE (31, ARR)
      REWIND 31
   10 READ (31, 101, END=20) LINE
      WRITE (6, 102) LINE
      GO TO 10
   20 WRITE (9, 101) ' &ARR A(0)=9.5, 2*7.25 &END'
      REWIND 9
      READ (9, ARR)
      WRITE (6, 103) N, A
  101 FORMAT (A)
  102 FORMAT (' >|', A, '|')
  103 FORMAT (' >', I3, 6F6.2)
      END
