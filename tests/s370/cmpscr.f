C     ** IF (IFIN .GT. MEMOIR) RETURN, cut down from LECAFC in Rene
C     Ferland's ADDAD/ANCORR.  The new IFIN was cached in R15 and the
C     compare took it as its first operand; MEMOIR's address, spilled,
C     was then reloaded into R15 as the storage operand's base:
C     C 15,0(,15) compared MEMOIR's address with MEMOIR, and LECAFC
C     returned before it read its data.  Self-checking; success
C     reaches STOP 0.
      CHARACTER*4 NOM(3), NOMJ(3)
      INTEGER NO(3), IRANG(3), KGR(80)
      REAL A(3,3)
      DATA NOM /'V1  ','V2  ','V3  '/, IRANG /3,1,2/
      IFIN = 187
      MEMOIR = 500000
      CALL LECAFC (NOMJ, NO, IRANG, NOM, A, KGR, IFIN, MEMOIR, 3, 3,
     1             46, IDONE)
      WRITE (6, 100) IFIN, IDONE, NOMJ(1)
  100 FORMAT (1X, '>CMPSCR', 2I8, 1X, A4)
      IF (IFIN .NE. 187) STOP 1
      IF (IDONE .NE. 9) STOP 2
      STOP 0
      END
      SUBROUTINE LECAFC (NOMJ, NO, IRANG, NOM, A, KGR, IFIN, MEMOIR,
     1                   NJ, NJ1, MEM1, IDONE)
      CHARACTER*80  DUM80,TEXTES
      CHARACTER*4  NOM(NJ),NOMJ(NJ),DUMCAR
      INTEGER NO(NJ), IRANG(NJ), KGR(80)
      REAL A(NJ1,NJ1)
      IDONE = 0
      TEXTES  =  'FIRST PROMPT, A STAND-IN TEXT LONG ENOUGH TO CROSS THE
     1CARD EDGE :  '
      CALL  LECPAR  ('80I1',BATCH,TEXTES,NJ,NO,1,DUMFLO,1,DUMCAR,
     1   DUM80,IENT,IMPR,201,4,IERPAR)
      TEXTES  =  'SECOND PROMPT, ANOTHER STAND-IN THAT RUNS PAST THE CA
     1RD EDGE AS WELL '
      CALL  LECPAR  ('80I1',BATCH,TEXTES,NGR1,KGR,1,DUMFLO,1,DUMCAR,
     1   DUM80,IENT,IMPR,201,5,IERPAR)
      DO 50 J=1,NJ
      NOMJ(J)=NOM(IRANG(J))
   50 CONTINUE
      IFIN  =  MAX0(IFIN,MEM1)
      IF  (IFIN .GT. MEMOIR) RETURN
      DO  30  J=1,NJ1
      DO 30 L=1,NJ1
      A(J,L) = 0.
   30 IDONE = IDONE + 1
      RETURN
      END
      SUBROUTINE LECPAR (OPT, BATCH, TEXTES, N, IV, M1, F, M2, C,
     1                   D80, IENT, IMPR, IPROG, NOCRT, IERR)
      CHARACTER*(*) OPT, TEXTES, C, D80
      INTEGER IV(*)
      IERR = 0
      END
