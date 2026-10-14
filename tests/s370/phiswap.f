C     ** Values that trade registers on a loop's back edge: the phi
C     copies form a cycle, broken by parking one register's value in
C     storage.  The copies that read the parked register were run at
C     once, and one wrote the register the parked copy still had to
C     read: a swap of FPR0 and FPR2 came out STD 0 / LD 2 / LER 0,2,
C     both registers the same.  SYMQR in Rene Ferland's ADDAD/ANCORR
C     lost a Givens rotation's sine this way.  Self-checking; success
C     reaches STOP 0.
      REAL X, Y, T, U, V, W
      INTEGER I, J, K, L
      X = 1.
      Y = 2.
      U = 3.
      V = 4.
      I = 5
      J = 6
      DO 10 N = 1, 5
         T = X
         X = Y
         Y = T
         W = U
         U = V
         V = W
         K = I
         I = J
         J = K
   10 CONTINUE
      WRITE (6, 100) X, Y, U, V, I, J
  100 FORMAT (1X, '>PHISWAP', 4F5.1, 2I3)
      IF (X .NE. 2. .OR. Y .NE. 1.) STOP 1
      IF (U .NE. 4. .OR. V .NE. 3.) STOP 2
      IF (I .NE. 6 .OR. J .NE. 5) STOP 3
      STOP 0
      END
