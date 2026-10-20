C     INTEGER*2 is a halfword and LOGICAL*1 a byte, as in FORTRAN H
C     (fort370 issue 10).  The values below are what H prints on TK5:
C     a store keeps the low 16 bits, sign extended; halfwords pack two
C     to a word; .TRUE. in a LOGICAL*1 is the byte 01; COMMON is not
C     padded; READ keeps the low 16 bits too.  A REAL*8 work array
C     holding halfword arrays four to a word, as MINOS's Z does, keeps
C     the doubles that follow them.
      PROGRAM INT2
      INTEGER*2 K, KA(4), M, N, KD, KB(3)
      INTEGER IW(2), J, I4, IC
      LOGICAL*1 L(4), LT, LF
      LOGICAL LW
      INTEGER*2 JH, IH, KH(2), KHD
      CHARACTER*3 C3
      REAL R
      DOUBLE PRECISION Z(4)
      CHARACTER*12 LINE
      EQUIVALENCE (KA(1), IW(1)), (L(1), J)
      COMMON /C/ M, R, N
      DATA KD /-7/, KB /3*5/, KHD /2HPQ/
      K = 40000
      WRITE (6, 100) K
  100 FORMAT (' >K ', I8)
      KA(1) = 1
      KA(2) = 2
      KA(3) = 3
      KA(4) = 4
      WRITE (6, 101) IW
  101 FORMAT (' >IW ', 2I12)
      J = 0
      L(1) = .TRUE.
      L(3) = .FALSE.
      L(4) = .TRUE.
      WRITE (6, 101) J
      LT = .TRUE.
      LF = .NOT. LT
      LW = LT .AND. .NOT. LF
      WRITE (6, 102) LT, LF, LW, L(1), L(2)
  102 FORMAT (' >L ', 5L3)
      M = 300
      I4 = M * M
      K = M * M
      WRITE (6, 103) I4, K
  103 FORMAT (' >MM ', 2I10)
      N = -2
      CALL SUB(IC)
      WRITE (6, 101) IC
      WRITE (6, 104) KD, KB
  104 FORMAT (' >KD ', 4I6)
      DO 10 K = 1, 3
         WRITE (6, 100) K
   10 CONTINUE
      LINE = '  1234 70000'
      READ (LINE, '(2I6)') K, KD
      WRITE (6, 104) K, KD
      K = 9
      CALL BUMP(K, KB, 3)
      WRITE (6, 104) K, KB
      Z(1) = 1.5D0
      Z(2) = 2.5D0
      Z(3) = 3.5D0
      Z(4) = 4.5D0
      CALL PACK(Z, 8)
      WRITE (6, 105) Z(3), Z(4)
  105 FORMAT (' >Z ', 2F6.2)
      CALL UNPK(Z, 8, I4)
      WRITE (6, 101) I4
      IF (K .GT. KD) WRITE (6, 100) K
      I4 = JH(20000)
      WRITE (6, 103) I4, IH(-3)
      WRITE (6, 106) C3(1)
      LINE = 'ELMS'
      READ (LINE, '(2A2)') KH
      WRITE (6, 107) KH(2), KH(1), KHD
  107 FORMAT (' >A ', 2A2, 1X, A2)
  106 FORMAT (' >C3 ', A)
      END
C     The length after the name, as FORTRAN H writes it, and before
C     FUNCTION; the result is a halfword: 40000 is -25536.
      INTEGER FUNCTION JH*2(I)
      JH = I * 2
      END
      INTEGER*2 FUNCTION IH(I)
      IH = I * 30000
      END
      CHARACTER FUNCTION C3*3(I)
      C3 = 'OAK'
      END
C     The block as fullwords: M's 300 is the first halfword.
      SUBROUTINE SUB(IC)
      INTEGER IC, JC(2)
      COMMON /C/ JC
      IC = JC(1)
      END
      SUBROUTINE BUMP(K, KB, NB)
      INTEGER*2 K, KB(NB)
      K = K + 32767
      DO 20 I = 1, NB
         KB(I) = KB(I) * I
   20 CONTINUE
      END
C     Halfwords in the first two doubles of the work array.
      SUBROUTINE PACK(HZ, NH)
      INTEGER*2 HZ(NH)
      DO 30 I = 1, NH
         HZ(I) = 100 + I
   30 CONTINUE
      END
      SUBROUTINE UNPK(HZ, NH, ISUM)
      INTEGER*2 HZ(NH)
      ISUM = 0
      DO 40 I = 1, NH
         ISUM = ISUM + HZ(I)
   40 CONTINUE
      END
