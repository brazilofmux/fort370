C     LINPACK'S PIECES ON A 3X3: IDAMAX, DGEFA'S PIVOTS, DGESL'S SOLVE
      REAL*8 A(3,3),B(3),X(5)
      INTEGER IPVT(3)
      X(1)=1.0D0
      X(2)=-7.0D0
      X(3)=3.0D0
      X(4)=7.0D0
      X(5)=-2.0D0
      I=IDAMAX(5,X,1)
      WRITE(6,100) I
  100 FORMAT(' >IDAMAX ',I5)
      A(1,1)=2.0D0
      A(2,1)=1.0D0
      A(3,1)=4.0D0
      A(1,2)=1.0D0
      A(2,2)=3.0D0
      A(3,2)=1.0D0
      A(1,3)=1.0D0
      A(2,3)=2.0D0
      A(3,3)=5.0D0
      B(1)=4.0D0
      B(2)=6.0D0
      B(3)=10.0D0
      CALL DGEFA(A,3,3,IPVT,INFO)
      WRITE(6,101) IPVT(1),IPVT(2),IPVT(3),INFO
  101 FORMAT(' >IPVT ',4I5)
      WRITE(6,102) A(1,1),A(2,2),A(3,3)
  102 FORMAT(' >DIAG ',3D22.15)
      CALL DGESL(A,3,3,IPVT,B,0)
      WRITE(6,103) B(1),B(2),B(3)
  103 FORMAT(' >SOLN ',3D22.15)
      STOP
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
   10 DY(I)=DY(I)+DA*DX(I)
      RETURN
      END
      SUBROUTINE DSCAL(N,DA,DX,INCX)
      REAL*8 DA,DX(1)
      IF (N .LE. 0) RETURN
      DO 10 I=1,N
   10 DX(I)=DA*DX(I)
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
