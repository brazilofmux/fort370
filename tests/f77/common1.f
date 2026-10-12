      PROGRAM COMMON1
C     COMMON and SAVE.  Layout is deferred to the end of the
C     declaration part, so members typed or dimensioned AFTER the
C     COMMON statement get their true sizes; two units view /MIX/
C     through different member splits, which is what proves the
C     offsets rather than just the sharing.  Self-checking; success
C     falls through to STOP 0.
      DOUBLE PRECISION D
      COMMON /MIX/ D, M, R(4)
      INTEGER M
      REAL R
      INTEGER NB, KOUNT
      REAL SLOT
      COMMON NB, SLOT
      INTEGER K

C     Fill /MIX/ through this unit's view.
      D = 2.5D0
      M = 30
      DO 10 K = 1, 4
      R(K) = K * 1.25
   10 CONTINUE

C     The callee views the same block as X(2), MM, RR(4) and both
C     checks the values it sees and rewrites them.
      CALL PEEK

      IF (ABS(D - 5.0D0) .GT. 1.0D-9) STOP 1
      IF (M .NE. 61) STOP 2
      IF (ABS(R(1) - 101.25) .GT. 1.0E-4) STOP 3
      IF (ABS(R(4) - 5.0) .GT. 1.0E-4) STOP 4

C     Blank COMMON.
      NB = 12
      SLOT = 0.75
      CALL BLANKQ
      IF (NB .NE. 24) STOP 5
      IF (ABS(SLOT - 1.5) .GT. 1.0E-4) STOP 6

C     Bare SAVE: both locals persist across calls.
      CALL STEPS(KOUNT)
      CALL STEPS(KOUNT)
      CALL STEPS(KOUNT)
      IF (KOUNT .NE. 33) STOP 7

      WRITE (6, 100) M, R(1), NB
  100 FORMAT ('OK', I4, F8.2, I4)
      STOP 0
      END

      SUBROUTINE PEEK
C     Same block, different split: one flat INTEGER view.  IX(3)
C     landing on M proves D occupies exactly 8 bytes with no padding
C     before M -- the offsets, not merely the sharing.  (IX(8) also
C     matches gfortran's 8-aligned size for a block holding a double,
C     which keeps its size-mismatch warning out of the diff.)
      INTEGER IX(8)
      COMMON /MIX/ IX
      IF (IX(3) .NE. 30) STOP 11
      CALL REMIX
      RETURN
      END

      SUBROUTINE REMIX
      DOUBLE PRECISION D
      INTEGER M
      REAL R(4)
      COMMON /MIX/ D, M, R
      D = D * 2.0D0
      M = M + 31
      R(1) = R(1) + 100.0
      R(4) = R(4)
      RETURN
      END

      SUBROUTINE BLANKQ
      INTEGER NB
      REAL SLOT
      COMMON NB, SLOT
      NB = NB * 2
      SLOT = SLOT * 2.0
      RETURN
      END

      SUBROUTINE STEPS(KOUNT)
      INTEGER KOUNT, A, B
      SAVE
      A = A + 1
      B = B + 10
      KOUNT = A + B
      RETURN
      END
