C     CHARFN1 -- a CHARACTER function with three RETURN arms behind an
C     arithmetic IF.  It has nothing for the SSA pass to promote, which
C     left the dominator-tree children table stale from the previous
C     unit; the allocator's call-site split then rewired the result
C     pointer in two arms to a copy only the first arm executes, and
C     f77_strcpy wrote to address 0 (FCVS FM715, CF716; selfhost
C     ISSUES-86).
      PROGRAM CHARFN1
      CHARACTER*10 CF, R
      INTEGER I
      DO 10 I = 1, 3
         R = CF(I)
         IF (I .EQ. 1 .AND. R .NE. 'FIRST AID') STOP 1
         IF (I .EQ. 2 .AND. R .NE. 'SECONDRATE') STOP 2
         IF (I .EQ. 3 .AND. R .NE. 'THIRDCLASS') STOP 3
         WRITE (*, '(A)') R
   10 CONTINUE
      STOP 0
      END
      CHARACTER*10 FUNCTION CF(IVD001)
      INTEGER IVD001
      IF (IVD001 - 2) 70010, 70020, 70030
70010 CF = 'FIRST AID'
      RETURN
70020 CF = 'SECONDRATE'
      RETURN
70030 CF = 'THIRDCLASS'
      RETURN
      END
