C     LINPACK 100: DGEFA + DGESL WITH THE BLAS, AS DONGARRA WROTE THEM
      REAL*8 A(101,100),B(100),X(100),RESID,S
      INTEGER IPVT(100)
      DATA NREP/1000/
      N=100
      LDA=101
      DO 50 IR=1,NREP
      CALL MATGEN(A,LDA,N,B)
      CALL DGEFA(A,LDA,N,IPVT,INFO)
      CALL DGESL(A,LDA,N,IPVT,B,0)
   50 CONTINUE
      S=0.0D0
      DO 60 I=1,N
   60 S=S+B(I)
      WRITE(6,100) INFO,S
  100 FORMAT(' LINPACK INFO ',I3,' CHECKSUM ',D22.15)
      STOP
      END
      SUBROUTINE MATGEN(A,LDA,N,B)
      REAL*8 A(LDA,1),B(1)
      INIT=1325
      DO 30 J=1,N
      DO 20 I=1,N
      INIT=MOD(3125*INIT,65536)
      A(I,J)=(DFLOAT(INIT)-32768.0D0)/16384.0D0
   20 CONTINUE
   30 CONTINUE
      DO 35 I=1,N
   35 B(I)=0.0D0
      DO 50 J=1,N
      DO 40 I=1,N
   40 B(I)=B(I)+A(I,J)
   50 CONTINUE
      RETURN
      END
      SUBROUTINE DGEFA(A,LDA,N,IPVT,INFO)
      INTEGER LDA,N,IPVT(1),INFO
      REAL*8 A(LDA,1),T
      INFO=0
      NM1=N-1
      IF (NM1 .LT. 1) GO TO 70
      DO 60 K=1,NM1
      KP1=K+1
      L=IDAMAX(N-K+1,A(K,K),1)+K-1
      IPVT(K)=L
      IF (A(L,K) .EQ. 0.0D0) GO TO 40
      IF (L .EQ. K) GO TO 10
      T=A(L,K)
      A(L,K)=A(K,K)
      A(K,K)=T
   10 CONTINUE
      T=-1.0D0/A(K,K)
      CALL DSCAL(N-K,T,A(K+1,K),1)
      DO 30 J=KP1,N
      T=A(L,J)
      IF (L .EQ. K) GO TO 20
      A(L,J)=A(K,J)
      A(K,J)=T
   20 CONTINUE
      CALL DAXPY(N-K,T,A(K+1,K),1,A(K+1,J),1)
   30 CONTINUE
      GO TO 50
   40 CONTINUE
      INFO=K
   50 CONTINUE
   60 CONTINUE
   70 CONTINUE
      IPVT(N)=N
      IF (A(N,N) .EQ. 0.0D0) INFO=N
      RETURN
      END
      SUBROUTINE DGESL(A,LDA,N,IPVT,B,JOB)
      INTEGER LDA,N,IPVT(1),JOB
      REAL*8 A(LDA,1),B(1),T
      NM1=N-1
      IF (NM1 .LT. 1) GO TO 30
      DO 20 K=1,NM1
      L=IPVT(K)
      T=B(L)
      IF (L .EQ. K) GO TO 10
      B(L)=B(K)
      B(K)=T
   10 CONTINUE
      CALL DAXPY(N-K,T,A(K+1,K),1,B(K+1),1)
   20 CONTINUE
   30 CONTINUE
      DO 40 KB=1,N
      K=N+1-KB
      B(K)=B(K)/A(K,K)
      T=-B(K)
      CALL DAXPY(K-1,T,A(1,K),1,B(1),1)
   40 CONTINUE
      RETURN
      END
      SUBROUTINE DAXPY(N,DA,DX,INCX,DY,INCY)
      REAL*8 DX(1),DY(1),DA
      IF (N .LE. 0) RETURN
      IF (DA .EQ. 0.0D0) RETURN
      DO 10 I=1,N
      DY(I)=DY(I)+DA*DX(I)
   10 CONTINUE
      RETURN
      END
      SUBROUTINE DSCAL(N,DA,DX,INCX)
      REAL*8 DA,DX(1)
      IF (N .LE. 0) RETURN
      DO 10 I=1,N
      DX(I)=DA*DX(I)
   10 CONTINUE
      RETURN
      END
      INTEGER FUNCTION IDAMAX(N,DX,INCX)
      REAL*8 DX(1),DMAX
      IDAMAX=0
      IF (N .LT. 1) RETURN
      IDAMAX=1
      IF (N .EQ. 1) RETURN
      DMAX=DABS(DX(1))
      DO 30 I=2,N
      IF (DABS(DX(I)) .LE. DMAX) GO TO 30
      IDAMAX=I
      DMAX=DABS(DX(I))
   30 CONTINUE
      RETURN
      END
