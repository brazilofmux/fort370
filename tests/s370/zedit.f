C     Hexadecimal constants in DATA (IBM's Z1F, MIL-STD-1753's Z'1F'
C     and O'17') and Zw editing (fort370 issues 9 and 29), as FORTRAN
C     H gives them, run on TK5: a constant right-justified in its item
C     whatever the item's type, the leftmost digits of one too long
C     lost; on output the item's bytes, leading zeros kept, a narrow
C     field its rightmost digits; on input blanks as zeros, a minus
C     sign the sign bit.  A COMPLEX item is two REAL ones, under A
C     editing too.  The expected lines:
C       >I  00000001 000000FF 7FFFFFFF FFFFFFFF 23456789 00000012
C       >J  000000FF 000001FF FFFFFFFF
C       >X  41100000 00000001 C1200000
C       >D 4110000000000000  0.1000000000000000D+01
C       >D 0000000041100000
C       >D 0000000000000001
C       >L  00000001 00000000
C       >C  00000000 41100000
C       >H 1234 6789
C       >W FE|FFFE|  FFFFFFFE|    FFFFFFFE|
C       >R 0000|  41100000|00000000|    C110000000000000|
C       >Q 00000000 41100000|001|
C       >1 0000ABCD 00001234 41100000 4120000000000001
C       >2 00102030 00000F01 0C110000 0040000000000000
C       >3 56789ABC 0000001F 000000000000ABCD
C       >4 80000001 4567
C       >A ABCD|EFGH|ABEF|  ABCD    EFGH|
      PROGRAM ZEDIT
      INTEGER I(6), J(3), K, IN, JN
      REAL X(3), RX
      DOUBLE PRECISION D(3), DX
      LOGICAL L(2)
      COMPLEX C
      INTEGER*2 H(2)
      CHARACTER*44 T(4)
      COMPLEX CA
      INTEGER IA(2)
      EQUIVALENCE (CA, IA(1))
      DATA IA /4HABCD, 4HEFGH/
      DATA I /Z1, ZFF, Z7FFFFFFF, ZFFFFFFFF, Z123456789, Z00000000012/
      DATA J /Z'FF', O'777', O'37777777777'/
      DATA X /Z41100000, Z1, ZC1200000/
      DATA D /Z4110000000000000, Z41100000, Z1/
      DATA L /Z1, Z0/
      DATA C /Z41100000/
      DATA H /Z1234, Z56789/
      DATA T(1) /'0000ABCD12344110000041200000000000010000000'/
      DATA T(2) /'  1 2 3  F 1 C1100000 4'/
      DATA T(3) /'123456789ABC1FABCD'/
      DATA T(4) /'-0000001 1234567'/
      WRITE (6, 1) I
    1 FORMAT (' >I ', 6(1X,Z8))
      WRITE (6, 2) J
    2 FORMAT (' >J ', 3(1X,Z8))
      WRITE (6, 3) X
    3 FORMAT (' >X ', 3(1X,Z8))
      DX = D(1)
      WRITE (6, 4) DX, DX
    4 FORMAT (' >D ', Z16, 1X, D23.16)
      WRITE (6, 4) D(2)
      WRITE (6, 4) D(3)
      WRITE (6, 5) L
    5 FORMAT (' >L ', 2(1X,Z8))
      WRITE (6, 6) C
    6 FORMAT (' >C ', 2(1X,Z8))
      WRITE (6, 7) H
    7 FORMAT (' >H ', Z4, 1X, Z4)
      K = -2
      WRITE (6, 8) K, K, K, K
    8 FORMAT (' >W ', Z2, '|', Z4, '|', Z10, '|', Z12, '|')
      RX = 1.0
      DX = -1.0D0
      WRITE (6, 9) RX, RX, DX, DX
    9 FORMAT (' >R ', Z4, '|', Z10, '|', Z8, '|', Z20, '|')
      WRITE (6, 10) C, L(1)
   10 FORMAT (' >Q ', Z8, Z9, '|', Z3, '|')
      READ (T(1), 11) IN, JN, RX, DX
   11 FORMAT (Z8, Z4, Z8, Z16)
      WRITE (6, 12) IN, JN, RX, DX
   12 FORMAT (' >1 ', Z8, 1X, Z8, 1X, Z8, 1X, Z16)
      READ (T(2), 11) IN, JN, RX, DX
      WRITE (6, 13) IN, JN, RX, DX
   13 FORMAT (' >2 ', Z8, 1X, Z8, 1X, Z8, 1X, Z16)
      READ (T(3), 14) IN, JN, DX
   14 FORMAT (Z12, Z2, Z4)
      WRITE (6, 15) IN, JN, DX
   15 FORMAT (' >3 ', Z8, 1X, Z8, 1X, Z16)
      READ (T(4), 16) IN, H(1)
   16 FORMAT (Z8, Z8)
      WRITE (6, 17) IN, H(1)
   17 FORMAT (' >4 ', Z8, 1X, Z4)
C     A COMPLEX item is two REAL ones under A editing too
      WRITE (6, 18) CA, CA, CA
   18 FORMAT (' >A ', A4, '|', A4, '|', 2A2, '|', A6, A8, '|')
      END
