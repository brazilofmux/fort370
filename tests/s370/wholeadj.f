C     ** Whole-array I/O of an adjustable array: F77 lets an array name
C     stand in an I/O list for all its elements, in storage order, an
C     adjustable dummy's included; it was refused ("whole-array I/O
C     needs constant extents").  Formatted, list-directed, READ and
C     unformatted, a lower bound other than 1 and a CHARACTER*(*)
C     array.
      REAL X(2,3)
      INTEGER K(0:4)
      CHARACTER*3 C(3)
      DATA X /1.,2.,3.,4.,5.,6./
      DATA K /10,11,12,13,14/
      DATA C /'AB', 'CD', 'EF'/
      CALL P(X, 2, 3, K, 0, 4, C, 3)
      END
      SUBROUTINE P(A, M, N, J, L, H, S, NS)
      INTEGER M, N, L, H, NS
      REAL A(M, N)
      INTEGER J(L:H)
      CHARACTER*(*) S(NS)
      CHARACTER*40 T
      WRITE (6, 100) A
      WRITE (6, 101) J
      WRITE (6, 102) S
      T = '9 8 7 6 5'
      READ (T, *) J
      WRITE (6, 101) J
      T = ' 0.5 1.5 2.5 3.5 4.5 5.5'
      READ (T, '(6F4.1)') A
      WRITE (6, 100) A
      OPEN (1, FORM='UNFORMATTED', STATUS='SCRATCH')
      WRITE (1) A, J
      REWIND 1
      A(1, 1) = 0.
      J(L) = 0
      READ (1) A, J
      WRITE (6, 100) A
      WRITE (6, 101) J
  100 FORMAT (1X, '>', 6F6.1)
  101 FORMAT (1X, '>', 5I4)
  102 FORMAT (1X, '>', 3(1X, A))
      END
