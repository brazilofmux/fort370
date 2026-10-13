      CHARACTER*7 X, Y
      CHARACTER*3 Z(2)
      DATA X /'ONE+TWO'/, Z /'ABC','DEF'/
      Y = 'GHIJKLM'
      WRITE(6,10) X, Y, Z
   10 FORMAT(1X,'>',A7,1X,A7,1X,2A3)
      END
