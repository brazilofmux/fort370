C     ALTERNATE RETURNS, INCLUDING ONE PASSED ON THROUGH A DUMMY
      INTEGER N
      N=0
      CALL SA(1,*10,*20)
      N=N+100
      GO TO 30
   10 N=N+1
      GO TO 30
   20 N=N+2
   30 CALL SA(2,*40,*50)
      N=N+100
      GO TO 60
   40 N=N+10
      GO TO 60
   50 N=N+20
   60 CALL SA(3,*70,*80)
      N=N+100
      GO TO 90
   70 N=N+1000
      GO TO 90
   80 N=N+2000
   90 CALL SB(2,*95)
      N=N+5
   95 WRITE(6,100) N
  100 FORMAT(' >ALTRET',I8)
      STOP
      END
      SUBROUTINE SA(K,*,*)
      IF (K.EQ.1) RETURN 1
      IF (K.EQ.2) RETURN 2
      RETURN
      END
      SUBROUTINE SB(K,*)
      CALL SA(K,*10,*10)
      RETURN
   10 RETURN 1
      END
