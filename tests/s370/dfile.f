C     DFILE -- DEFINE FILE, FORTRAN IV'S DIRECT ACCESS, AS FORTRAN H
C     DOES IT: E, U AND L FILES, READ (U'R), WRITE (U'R) AND FIND (U'R),
C     THE ASSOCIATED VARIABLE, A LIST LONGER THAN A RECORD, RECORDS
C     NEVER WRITTEN, RECORD NUMBERS OUT OF RANGE (IHC232I), A READ
C     BEFORE ANY WRITE (IHC236I), A FORMATTED RECORD TOO LONG (IHC212I),
C     A DEFINE FILE IN A SUBROUTINE AND ONE A GO TO GOES ROUND; AND
C     PUNCH.  UNITS 21-25 AND 7 ARE SCRATCH DDS.  THE LINES THAT BEGIN
C     WITH > AND THE IHC MESSAGES ARE FORTRAN H'S (EXPECTED BELOW).
C     >A     -7 / >A      4 / >A      3
C     >B      4 |GHI3                |
C     >C      3    11    22 / >A      7
C     >B      6 |                    |
C     >D     -5     -1     -2
C     >E      3 / >F      2 00000001 00000002 / >F      3 00000003 00000000
C     >G      5 00000001 00000002 00000003 00000000 40404040 (4 TIMES)
C     >H      4 / >H      5 / >H      5   (EACH AFTER AN IHC232I)
C     >I      3 |ABCDEFGHIJKLMNOPQRST                |
C     >J      6 / >K      5 12345  2.50 |XY|
C     >L      3     77 / >M      2 / >N     10 / >P  PUNCHED   42
      COMMON /DA/ KS
      INTEGER K, L, M, N, I, J, IA(5), IB(8), IC(9)
      REAL B
      DEFINE FILE 21(10,20,E,K), 22(5,2,U,L), 23(6,12,L,M)
      K = -7
      WRITE (6,1) K
    1 FORMAT(' >A ', I6)
      WRITE (21'3,2)
    2 FORMAT('GHI3')
      WRITE (6,1) K
      I = 11
      J = 22
      WRITE (21'1,3) I, J
    3 FORMAT(I5/I5)
      WRITE (6,1) K
      READ (21'3,4) IA
    4 FORMAT(5A4)
      WRITE (6,5) K, IA
    5 FORMAT(' >B ', I6, ' |', 5A4, '|')
      READ (21'1,6) I, J
    6 FORMAT(I5)
      WRITE (6,7) K, I, J
    7 FORMAT(' >C ', 3I6)
      FIND (21'7)
      WRITE (6,1) K
      N = 4
      READ (21'N+1,4) IA
      WRITE (6,5) K, IA
C     A READ BEFORE THE DATA SET IS WRITTEN: SKIPPED
      L = -5
      I = -1
      J = -2
      READ (22'3) I, J
      WRITE (6,8) L, I, J
    8 FORMAT(' >D ', 3I6)
C     A LIST LONGER THAN A RECORD: ON INTO THE NEXT
      I = 1
      J = 2
      N = 3
      WRITE (22'1) I, J, N
      WRITE (6,9) L
    9 FORMAT(' >E ', I6)
      READ (22'1) I, J
      WRITE (6,10) L, I, J
   10 FORMAT(' >F ', I6, 2(1X, Z8))
      READ (22'2) I, J
      WRITE (6,10) L, I, J
      READ (22'1) IB
      WRITE (6,11) L, IB
   11 FORMAT(' >G ', I6, 8(1X, Z8))
C     RECORD NUMBERS OUT OF RANGE: SKIPPED, K AS IT WAS
      K = 4
      READ (21'11,4) IA
      WRITE (6,12) K
   12 FORMAT(' >H ', I6)
      K = 5
      WRITE (21'0,2)
      WRITE (6,12) K
      FIND (21'12)
      WRITE (6,12) K
C     A FORMATTED RECORD TOO LONG: CUT
      WRITE (21'2,13)
   13 FORMAT('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
      READ (21'2,14) IB
   14 FORMAT(8A4)
      WRITE (6,15) K, IB
   15 FORMAT(' >I ', I6, ' |', 8A4, '|')
C     AN L FILE, FORMATTED AND UNFORMATTED
      IA(1) = IA(5)
      READ (23'2,16) IA(1)
   16 FORMAT(A2)
      IA(1) = IB(6)
      I = 12345
      B = 2.5
      WRITE (23'5) I, B
      WRITE (6,17) M
   17 FORMAT(' >J ', I6)
      I = 0
      B = 0.0
      READ (23'5) I, B
      WRITE (23'4,18)
   18 FORMAT('XY')
      READ (23'4,16) IA(3)
      WRITE (6,19) M, I, B, IA(3)
   19 FORMAT(' >K ', 2I6, F6.2, ' |', A2, '|')
C     A DEFINE FILE IN A SUBROUTINE, ITS VARIABLE IN COMMON
      CALL DSUB
      READ (24 ' KS - 1, 20) I
   20 FORMAT(I4)
      WRITE (6,21) KS, I
   21 FORMAT(' >L ', 2I6)
C     A DEFINE FILE A GO TO GOES ROUND, AND A LOGICAL IF
      GO TO 30
      DEFINE FILE 25(4,9,U,N)
   30 N = -1
      IF (N .LT. 0) WRITE (25'1) IC
      WRITE (6,22) N
   22 FORMAT(' >M ', I6)
      IF (N .GT. 0) FIND (21'10)
      WRITE (6,23) K
   23 FORMAT(' >N ', I6)
C     PUNCH: UNIT 7, THE RECORD AS ITS FORMAT MAKES IT
      I = 42
      PUNCH 24, I
   24 FORMAT(' PUNCHED', I5)
      REWIND 7
      READ (7,25) IA
   25 FORMAT(5A4)
      WRITE (6,26) IA
   26 FORMAT(' >P ', 5A4)
      STOP
      END
      SUBROUTINE DSUB
      COMMON /DA/ KS
      DEFINE FILE 24(3,4,E,KS)
      WRITE (24'2,1)
    1 FORMAT('  77')
      RETURN
      END
