C     A LOCAL SCALAR IN STATIC STORAGE (DATA OR SAVE) THAT THE UNIT NEVER
C     STORES CANNOT CHANGE, SO ITS LOAD MOVES OUT OF A LOOP (LEN BELOW).
C     EVERY OTHER WAY THE UNIT CAN CHANGE ONE MUST KEEP THE LOAD IN THE
C     LOOP: PASSED TO A SUBROUTINE, STORED THROUGH AN EQUIVALENCE, READ
C     INTO, AN IMPLIED-DO INDEX, A DO VARIABLE.  GFORTRAN PRINTS THE
C     SAME LINES.
      INTEGER LEN/4/, KC/1/, KE/1/, KR/1/, KI/1/, KD/1/
      INTEGER ME, I, J, S, SC, SE, SR, SI, SD
      INTEGER V(4)
      CHARACTER*2 C
      EQUIVALENCE (KE, ME)
      SAVE KI, KD
      S = 0
      SC = 0
      SE = 0
      SR = 0
      SI = 0
      SD = 0
      DO 10 I = 1, LEN
        S = S + LEN
        SC = SC + KC
        CALL INC (KC)
        SE = SE + KE
        ME = ME + 2
        SR = SR + KR
        WRITE (C, '(I2)') I + 10
        READ (C, '(I2)') KR
        SI = SI + KI
        WRITE (C, '(2I1)') (KI, KI = 1, 2)
   10 CONTINUE
      DO 20 KD = 1, 3
        DO 20 J = 1, 2
          SD = SD + KD
   20 CONTINUE
      WRITE (6,100) S, SC, SE, SR, SI, SD
  100 FORMAT (1X,'>LDRO',6I5)
      END
      SUBROUTINE INC (K)
      INTEGER K
      K = K + 1
      END
