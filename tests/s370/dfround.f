C     ** The DOUBLE PRECISION functions rounded once (2026-10-15): each
C     ends in a sum of nearly exact terms added in extended precision
C     and rounded to nearest, so these arguments give the exact value
C     correctly rounded, to the bit.  One argument at least for each
C     way through: DEXP below 0; DLOG below 1, where the table's point
C     is past 64; DATAN past 1, through 1/x; DATAN2 with x < 0, pi less
C     it; DASIN past 0.5, where 1 - x^2 is taken as 2d - d^2; DACOS
C     below 0; DSINH by its series, by the corrected division and by
C     the plain one; DTANH below and past 1.75; D**D.  Success prints
C     >DFROUND and the checks passed and reaches STOP 0.
      DOUBLE PRECISION D
      INTEGER ID(2), NOK
      EQUIVALENCE (D, ID(1))
      NOK = 0
      D = DEXP(1.D0)
      IF (ID(1) .NE. 1093369365 .OR. ID(2) .NE. 371764947) STOP 1
      D = DEXP(-0.75D0)
      IF (ID(1) .NE. 1081666819 .OR. ID(2) .NE. -1346423303) STOP 2
      D = DLOG(2.D0)
      IF (ID(1) .NE. 1085370903 .OR. ID(2) .NE. -137244806) STOP 3
      D = DLOG(0.875D0)
      IF (ID(1) .NE. -1071501539 .OR. ID(2) .NE. 72337656) STOP 4
      D = DLOG10(2.D0)
      IF (ID(1) .NE. 1078792269 .OR. ID(2) .NE. 1115547644) STOP 5
      NOK = NOK + 5
      D = DATAN(1.D0)
      IF (ID(1) .NE. 1086918618 .OR. ID(2) .NE. -1574868798) STOP 6
      D = DATAN(3.D0)
      IF (ID(1) .NE. 1091828759 .OR. ID(2) .NE. 1803191648) STOP 7
      D = DATAN2(1.D0, -1.D0)
      IF (ID(1) .NE. 1092989688 .OR. ID(2) .NE. -26852444) STOP 8
      D = DASIN(0.5D0)
      IF (ID(1) .NE. 1082526353 .OR. ID(2) .NE. -1049912532) STOP 9
      D = DASIN(0.96875D0)
      IF (ID(1) .NE. 1091903307 .OR. ID(2) .NE. -784366191) STOP 10
      D = DACOS(-0.25D0)
      IF (ID(1) .NE. 1092431093 .OR. ID(2) .NE. -943255796) STOP 11
      NOK = NOK + 6
      D = DSINH(0.0625D0)
      IF (ID(1) .NE. 1074791082 .OR. ID(2) .NE. -858940195) STOP 12
      D = DSINH(0.5D0)
      IF (ID(1) .NE. 1082484352 .OR. ID(2) .NE. 2133974198) STOP 13
      D = DSINH(3.D0)
      IF (ID(1) .NE. 1101023543 .OR. ID(2) .NE. 944393581) STOP 14
      D = DCOSH(1.D0)
      IF (ID(1) .NE. 1092137077 .OR. ID(2) .NE. 1373238608) STOP 15
      D = DTANH(0.5D0)
      IF (ID(1) .NE. 1081494863 .OR. ID(2) .NE. 1566190542) STOP 16
      D = DTANH(2.D0)
      IF (ID(1) .NE. 1089915522 .OR. ID(2) .NE. -253878625) STOP 17
      D = 2.D0 ** 0.5D0
      IF (ID(1) .NE. 1092001950 .OR. ID(2) .NE. 1719614413) STOP 18
      NOK = NOK + 7
      WRITE (6, 100) NOK
  100 FORMAT (1X, '>DFROUND', I4)
      STOP 0
      END
