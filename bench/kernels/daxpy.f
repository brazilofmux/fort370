C     DAXPY KERNEL: Y = Y + A*X, N=1000, NREP TIMES
      REAL*8 X(1000),Y(1000),A,S
      DATA NREP/200000/
      N=1000
      A=1.0D-6
      DO 10 I=1,N
      X(I)=DFLOAT(I)
   10 Y(I)=0.0D0
      DO 30 IR=1,NREP
      DO 20 I=1,N
   20 Y(I)=Y(I)+A*X(I)
   30 CONTINUE
      S=0.0D0
      DO 40 I=1,N
   40 S=S+Y(I)
      WRITE(6,100) S
  100 FORMAT(' DAXPY CHECKSUM ',D22.15)
      STOP
      END
