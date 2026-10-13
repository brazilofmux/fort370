#!/usr/bin/env python3
"""limits.py SHAPE N -- one program unit of N statements of one shape, to
standard output, for measuring how large a unit a compiler takes
(bench/results-limits-2026-10-13.txt).  FORTRAN IV and FORTRAN 77 alike
(no PROGRAM statement, no list-directed I/O), so FORTRAN H and fort370
compile the same text.  Shapes:

  straight  A(i)=B(j)*c+A(k), no labels or branches
  if        IF (A(i).GT.B(j)) K=K+c, a branch per statement
  labels    every statement labelled
  vars      a distinct scalar assigned per statement"""
import sys
kind, n = sys.argv[1], int(sys.argv[2])
L=['      REAL A(100),B(100)','      INTEGER K','      K=0',
   '      DO 1 K=1,100','      A(K)=0.0','    1 B(K)=FLOAT(K)','      K=0']
if kind=='straight':
    for i in range(n): L.append('      A(%d)=B(%d)*%d.0+A(%d)' % (i%100+1,(i*7)%100+1,i%9+1,(i*3)%100+1))
elif kind=='if':
    for i in range(n): L.append('      IF (A(%d).GT.B(%d)) K=K+%d' % (i%100+1,(i*7)%100+1,i%9+1))
elif kind=='labels':
    for i in range(n): L.append('%5d A(%d)=A(%d)+1.0' % (i+2,i%100+1,(i*3)%100+1))
elif kind=='vars':
    for i in range(n): L.append('      X%04d=%d.0' % (i,i))
    L.append('      A(1)=' + '+'.join('X%04d'%i for i in range(0,n,max(1,n//20))))
L += ['      WRITE(6,99999) A(1),K','99999 FORMAT(1X,E15.7,I8)','      STOP','      END']
print('\n'.join(L))
