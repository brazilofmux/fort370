#!/bin/sh
# stream.sh -- the source is streamed (src/f77_card.h): a file far past
# the old whole-file buffer compiles, with small subroutines defined after
# their caller (inlined from the copy the scan keeps), an ENTRY whose
# parent the stream has long passed (read again), and comment blocks the
# window must cross; and a build with a tiny window (a refill at nearly
# every statement) writes exactly the same assembler.
cd "$(dirname "$0")/../.." || exit 2
mkdir -p out/stream
python3 - <<'PY'
L = ['      PROGRAM BIGSRC', '      INTEGER I, K, ISUM', '      ISUM = 0',
     '      DO 10 I = 1, 600', '        CALL ADDK(ISUM, I)', '   10 CONTINUE',
     '      CALL FIRST(K)', '      CALL SECOND(K)',
     "      WRITE (6, 20) ISUM, K", "   20 FORMAT (' >', 2I10)", '      END',
     '      SUBROUTINE FIRST(K)', '      INTEGER K', '      K = 1', '      RETURN',
     '      ENTRY SECOND(K)', '      K = K + 41', '      RETURN', '      END']
for n in range(200):
    L += ['C     ' + ('COMMENT LINE %04d OF BLOCK %04d ' % (j, n)).ljust(66, '.') for j in range(40)]
    L += ['      SUBROUTINE S%04d(X)' % n, '      REAL X', '      X = X + %d.0' % n,
          '      RETURN', '      END']
L += ['      SUBROUTINE ADDK(ISUM, I)', '      INTEGER ISUM, I', '      ISUM = ISUM + I',
      '      RETURN', '      END']
open('out/stream/bigsrc.f', 'w').write('\n'.join(L) + '\n')
PY
${CC:-cc} -O1 -w -DF77_TARGET_S370 -DLX_AHEAD=1024 -DLX_CAP0=4096 -I backend -o out/stream/f77tiny src/f77.c || exit 1
F77=out/f77; [ -x out/f77.exe ] && F77=out/f77.exe
$F77 out/stream/bigsrc.f out/stream/big.asm || { echo "stream: the big source did not compile"; exit 1; }
out/stream/f77tiny out/stream/bigsrc.f out/stream/tiny.asm || { echo "stream: the tiny window failed"; exit 1; }
cmp -s out/stream/big.asm out/stream/tiny.asm || { echo "stream: the tiny window wrote different assembler"; exit 1; }
n=$(grep -c ' CSECT' out/stream/big.asm)
grep -q 'V(ADDK)' out/stream/big.asm && { echo "stream: ADDK was not inlined from its kept copy"; exit 1; }
echo "stream: $(wc -c < out/stream/bigsrc.f | tr -d ' ') bytes of source, $n CSECTs, the same through a 1K window"
