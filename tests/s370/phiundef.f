C     ** JJ is undefined on entry and set only when D(J) is a new
C     maximum; after the loop it must be the J of that last setting.
C     A phi of the undefined value and JJ's latch value was taken for
C     the latch value alone, so JJ became J itself: its value when the
C     loop ended.  SYMQR in Rene Ferland's ADDAD/ANCORR sorted every
C     eigenvalue to the same one.  Self-checking; success reaches STOP 0.
      REAL D(6), VAL(6)
      INTEGER IK(6), KEXP(6)
      DATA D /3., 1., 4., 1.5, 5., 2./
      DATA KEXP /5, 3, 1, 6, 4, 2/
      CALL SEL (D, VAL, IK, 6)
      WRITE (6, 100) VAL, IK
  100 FORMAT (1X, '>PHIUNDEF', 6F5.1, 6I2)
      DO 10 I = 1, 6
         IF (IK(I) .NE. KEXP(I)) STOP 1
   10 CONTINUE
      STOP 0
      END
      SUBROUTINE SEL (D, VAL, IK, N)
      REAL D(N), VAL(N)
      INTEGER IK(N)
      DO 400 L=1,N
      VMAX=-1.
      DO 410 J=1,N
      IF(D(J).LE.VMAX)  GOTO  410
      VMAX=D(J)
      JJ=J
  410 CONTINUE
      IK(L)=JJ
      VAL(L)=VMAX
  400 D(JJ)=-1.
      END
