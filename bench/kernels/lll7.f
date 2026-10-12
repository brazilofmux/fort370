C     LIVERMORE LOOP 7, EQUATION OF STATE FRAGMENT
      REAL*8 X(1001),Y(1001),Z(1001),U(1007),Q,R,T,S
      DATA NREP/100000/
      N=1000
      Q=0.5D0
      R=0.25D0
      T=0.125D0
      DO 10 K=1,1007
   10 U(K)=DFLOAT(K)*1.0D-3
      DO 15 K=1,1001
      Y(K)=1.0D0/DFLOAT(K)
   15 Z(K)=DFLOAT(K)*2.0D-3
      DO 30 IR=1,NREP
      DO 20 K=1,N
      X(K)=U(K)+R*(Z(K)+R*Y(K))+T*(U(K+3)+R*(U(K+2)+R*U(K+1))+
     1     T*(U(K+6)+Q*(U(K+5)+Q*U(K+4))))
   20 CONTINUE
   30 CONTINUE
      S=0.0D0
      DO 40 K=1,N
   40 S=S+X(K)
      WRITE(6,100) S
  100 FORMAT(' LLL7 CHECKSUM ',D22.15)
      STOP
      END
