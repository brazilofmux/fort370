C     DECLINIT -- A TYPE STATEMENT'S INITIAL VALUES (INTEGER L/1/) ARE
C     DATA: THEY ARE SET ONCE, AND A VALUE CHANGED IN ONE CALL IS THERE
C     IN THE NEXT (ISSUE #32).  A UNIT SMALL ENOUGH TO BE PUT IN LINE IN
C     ITS CALLER WAS, AND ITS VARIABLE BECAME THE CALLER'S TEMPORARY,
C     NEVER SET: THE FIRST CALL SAW 0.  ONE UNIT FOR EACH TYPE, AND A
C     FUNCTION.  SELF-CHECKING: ONE LINE A CASE, " >NAME OK" OR
C     " >NAME BAD", THEN THE COUNT OF BAD ONES.
      PROGRAM DECLIN
      INTEGER K(3), NBAD, I, NEXTN
      REAL X(3)
      LOGICAL L(3)
      DOUBLE PRECISION D(3)
      COMPLEX C(3)
      NBAD = 0
      DO 10 I = 1, 3
        CALL STEPI(K(I))
        CALL STEPR(X(I))
        CALL STEPL(L(I))
        CALL STEPD(D(I))
        CALL STEPC(C(I))
   10 CONTINUE
      CALL CHK('INT   ', K(1) .EQ. 1 .AND. K(2) .EQ. 3 .AND.
     1    K(3) .EQ. 5, NBAD)
      CALL CHK('REAL  ', X(1) .EQ. 2.5 .AND. X(2) .EQ. 3.5 .AND.
     1    X(3) .EQ. 4.5, NBAD)
      CALL CHK('LOGIC ', L(1) .AND. .NOT. L(2) .AND. L(3), NBAD)
      CALL CHK('DOUBLE', D(1) .EQ. 0.25D0 .AND. D(2) .EQ. 0.5D0 .AND.
     1    D(3) .EQ. 1.0D0, NBAD)
      CALL CHK('CMPLX ', C(1) .EQ. (1.0, 2.0) .AND.
     1    C(2) .EQ. (2.0, 3.0) .AND. C(3) .EQ. (3.0, 4.0), NBAD)
      CALL CHK('FUNC  ', NEXTN() .EQ. 7 .AND. NEXTN() .EQ. 8, NBAD)
      WRITE (6,1) NBAD
    1 FORMAT(' >BAD ', I2)
      END
      SUBROUTINE STEPI(K)
      INTEGER K, LV/1/
      K = LV
      LV = LV + 2
      END
      SUBROUTINE STEPR(X)
      REAL X, RV/2.5/
      X = RV
      RV = RV + 1.0
      END
      SUBROUTINE STEPL(L)
      LOGICAL L, LV/.TRUE./
      L = LV
      LV = .NOT. LV
      END
      SUBROUTINE STEPD(D)
      DOUBLE PRECISION D, DV/0.25D0/
      D = DV
      DV = DV + DV
      END
      SUBROUTINE STEPC(C)
      COMPLEX C, CV/(1.0, 2.0)/
      C = CV
      CV = CV + (1.0, 1.0)
      END
      INTEGER FUNCTION NEXTN()
      INTEGER N/7/
      NEXTN = N
      N = N + 1
      END
      SUBROUTINE CHK(NAME, OK, NBAD)
      CHARACTER*6 NAME
      LOGICAL OK
      INTEGER NBAD
      IF (OK) THEN
        WRITE (6,1) NAME
    1   FORMAT(' >', A6, ' OK')
      ELSE
        WRITE (6,2) NAME
    2   FORMAT(' >', A6, ' BAD')
        NBAD = NBAD + 1
      END IF
      END
