#!/bin/sh
# listing.sh -- the compiler's options and listing, FORTRAN H's (#34,
# #35): each statement numbered as H numbers it (ISN 2 the first,
# comments unnumbered), a message under its unit citing its statement's
# ISN and its level, the options in effect, NOSOURCE leaving the source
# out but not the messages, LINECNT making pages, and an option H does
# not have a warning.
cd "$(dirname "$0")/../.." || exit 2
F77=out/f77
[ -x out/f77.exe ] && F77=out/f77.exe
T=out/listing.tmp; mkdir -p $T
bad=0
has() {    # file text
  if ! grep -q -- "$2" "$T/$1"; then echo "listing: $1 lacks: $2"; bad=$((bad+1)); fi
}
lacks() {  # file text
  if grep -q -- "$2" "$T/$1"; then echo "listing: $1 has: $2"; bad=$((bad+1)); fi
}
printf 'C     A COMMENT\n      N = 5\n      X = (1.0\n   10 CONTINUE\n      END\n      SUBROUTINE S\n      END\n' > $T/a.f
"$F77" -l $T/a.lst $T/a.f $T/a.s 2>/dev/null
has a.lst "^                 C     A COMMENT"
has a.lst "^    ISN 0002           N = 5"
has a.lst "^    ISN 0004        10 CONTINUE"
has a.lst "ISN    0003     08        expected )"
has a.lst "NOSOURCE\|SOURCE,EBCDIC,NOLIST,NODECK,LOAD,NOMAP,NOEDIT,NOID,NOXREF"
has a.lst "SOURCE STATEMENTS =       4"
has a.lst "1 DIAGNOSTICS THIS STEP, HIGHEST SEVERITY CODE IS  8"
"$F77" -p NOSOURCE,LINECNT=12,FOO -l $T/b.lst $T/a.f $T/b.s 2>/dev/null
lacks b.lst "ISN 0002 "
has b.lst "ISN    0003     08        expected )"
has b.lst "04        the option FOO is not one of FORTRAN H's"
has b.lst "LINECNT=12"
"$F77" -p LINECNT=10 -l $T/c.lst $T/a.f $T/c.s 2>/dev/null
has c.lst "PAGE 003"
rm -rf $T
[ $bad = 0 ] && echo "listing: ISNs as H's, messages under their statements, the options in effect, NOSOURCE, LINECNT and an unknown option"
[ $bad = 0 ]
