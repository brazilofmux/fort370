C     NAMELIST input as FORTRAN H writes it (fort370 issue 4): records
C     of 132 columns, a NAME= at the end of one and its value on the
C     next, a positive exponent written with a blank for its sign
C     (0.25E 10, D 12), zero as 0.0 and its padding, COMPLEX (re,im)
C     right-justified, T and F.
      PROGRAM NMLH
      INTEGER J, L(3)
      REAL P, Q
      DOUBLE PRECISION E
      COMPLEX Z, W
      LOGICAL U
      NAMELIST /HGRP/ J, P, Q, E, Z, W, U, L
      WRITE (9, 101) ' &HGRP'
      WRITE (9, 101) ' J=        -64,P= 0.25000000E 10,',
     1  'Q= 0.0           ,E=',
     2  '-0.3750000000000000D 12,Z=  (0.12500000E-04,0.50000000E 09),'
      WRITE (9, 101) ' W=  (0.0           ,0.0           ),',
     1  'U=T,L=          3,', '          2,          1'
      WRITE (9, 101) ' &END'
      REWIND 9
      READ (9, HGRP)
      WRITE (6, 102) J, P, Q, E, Z, W, U, L
  101 FORMAT (A, A, A)
  102 FORMAT (' >', I4, 2E12.4, D14.4, 4E12.4, L2, 3I3)
      END
