C     MATRIX MULTIPLY C = C + A*B, N=100, J-K-I ORDER, NREP TIMES
      REAL*8 A(100,100),B(100,100),C(100,100),T,S
      DATA NREP/200/
      N=100
      DO 10 J=1,N
      DO 10 I=1,N
      A(I,J)=DFLOAT(I+J)*1.0D-2
      B(I,J)=DFLOAT(I-J)*1.0D-2
   10 C(I,J)=0.0D0
      DO 40 IR=1,NREP
      DO 30 J=1,N
      DO 30 K=1,N
      T=B(K,J)
      DO 20 I=1,N
   20 C(I,J)=C(I,J)+A(I,K)*T
   30 CONTINUE
   40 CONTINUE
      S=0.0D0
      DO 50 J=1,N
      DO 50 I=1,N
   50 S=S+C(I,J)
      WRITE(6,100) S
  100 FORMAT(' MATMUL CHECKSUM ',D22.15)
      STOP
      END
