      PROGRAM CHARACTER1
      CHARACTER*5 A, B
      CHARACTER C*3, D(3)*4, E*10
      CHARACTER*(*) P
      PARAMETER (P = 'HELLO')
      CHARACTER*6 F6
      INTEGER I
      LOGICAL L
      DATA D /'AB', 'CDEF', 'IJKL'/
      A = 'ABC'
      B = 'ABCDEFG'
      C = A(2:3)
      E = A // B(1:2) // 'X'
      WRITE (6, 100) A, B, C, E
 100  FORMAT (1X, A, '|', A5, '|', A, '|', A10, '|')
      WRITE (6, 101) D(1), D(2), D(3), D(2)(2:3)
 101  FORMAT (1X, 4(A, '|'))
      L = A .EQ. 'ABC'
      WRITE (6, *) L, A .LT. B, 'ABC' .EQ. 'ABC  ', LEN(E), LEN(P), P
      WRITE (6, *) INDEX(E, 'CAB'), ICHAR('A'), CHAR(66), LGE('B', 'A')
      I = 65
      D(3) = CHAR(I) // CHAR(I+1)
      WRITE (6, 102) D(3), F6(A, B)
 102  FORMAT (1X, A4, '/', A6, '/')
      CALL SUB1(A, 'XYZ', D)
      WRITE (6, *) A, D(1)
      READ (5, 103) A, C
 103  FORMAT (A5, A3)
      WRITE (6, 104) A, C, A(5:5), C(1:1)
 104  FORMAT (1X, A, '|', A, '|', A, '|', A)
      READ (5, *) B, I
      WRITE (6, *) B, I
      STOP
      END
      CHARACTER*6 FUNCTION F6(X, Y)
      CHARACTER*(*) X, Y
      F6 = Y(1:2) // X
      RETURN
      END
      SUBROUTINE SUB1(S, T, V)
      CHARACTER*(*) S, T
      CHARACTER*4 V(3)
      S = T // S
      V(1) = T(2:3)
      IF (LEN(S) .NE. 5 .OR. LEN(T) .NE. 3) WRITE (6, *) 'BAD LEN',
     1   LEN(S), LEN(T)
      RETURN
      END
