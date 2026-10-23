C     The INTEGER intrinsics passed as actual arguments, through the
C     shims in runtime/s370/f77ishim.asm: ISIGN, IDIM and MOD loaded
C     their second argument from storage location 0, and NINT and
C     IDNINT gave a negative argument's magnitude, its sign lost.
C     The expected lines:
C       >S    -7    7   -7    5    0    2   -2    8
C       >S     3   -3    3   -3    0   -3    8   -8
      INTRINSIC IABS, ISIGN, IDIM, MOD, NINT, IDNINT
      INTEGER F1, F2, G1, H1
      WRITE(6,1) F2(ISIGN,7,-3), F2(ISIGN,-7,3), F2(ISIGN,-7,-3),
     1   F2(IDIM,9,4), F2(IDIM,4,9), F2(MOD,17,5), F2(MOD,-17,5),
     2   F1(IABS,-8)
      WRITE(6,1) G1(NINT,2.6), G1(NINT,-2.6), G1(NINT,2.5),
     1   G1(NINT,-2.5), G1(NINT,-0.4), H1(IDNINT,-2.6D0),
     2   H1(IDNINT,7.5D0), H1(IDNINT,-7.5D0)
    1 FORMAT(' >S ',8I5)
      END
      INTEGER FUNCTION F2(F,A,B)
      INTEGER F,A,B
      F2=F(A,B)
      END
      INTEGER FUNCTION F1(F,A)
      INTEGER F,A
      F1=F(A)
      END
      INTEGER FUNCTION G1(F,X)
      INTEGER F
      REAL X
      G1=F(X)
      END
      INTEGER FUNCTION H1(F,D)
      INTEGER F
      DOUBLE PRECISION D
      H1=F(D)
      END
