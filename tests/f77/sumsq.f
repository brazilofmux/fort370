      PROGRAM HELLO
      INTEGER I, S
      S = 0
      DO 10 I = 1, 10
         S = S + I*I
   10 CONTINUE
      WRITE (6,100) S
  100 FORMAT ('SUM OF SQUARES = ', I5)
      WRITE (6,200) 2.0*ATAN2(1.0,0.0)
  200 FORMAT ('PI = ', F10.6)
      END
