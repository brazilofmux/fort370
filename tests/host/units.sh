#!/bin/sh
# units.sh -- how the compiler divides a source into program units, where
# a mistake loses a unit without a word: a PROGRAM statement inside a
# subprogram (its END missing) and a second main program are refused,
# each with its message; so is a GO TO to a label no statement carries,
# and text a statement's parser leaves unread (a missing comma), on its
# own line even after a CALL whose callee was spliced in its place; a
# DO or block IF still open at END, and a stray END DO; two subprograms
# or ENTRY points of one name, and two names that are one external name
# in eight characters; a function called with a type other than its own;
# a FORMAT, or a format that is one constant, that is certainly wrong
# (an nH past its end, a count with no descriptor, an unknown letter,
# an H with no count);
# a NAMELIST READ with a list, and a NAMELIST group defined twice;
# a READ or WRITE whose unit is CHARACTER (an internal file) with no
# format, as READ('(I5)') N is; a substring whose constant bounds fall
# outside its string, C(0:9), C(1:11) of a CHARACTER*10 C, or C(5:4)
# (F77 5.7.1); a hexadecimal or octal constant of DATA with a digit
# that is not, or a sign; a bit intrinsic with the wrong number of
# arguments or one not INTEGER, MVBITS too; a DEFINE FILE with a format
# letter not E, U or L, or an associated variable not INTEGER, and a
# list-directed READ (u'r).  tests/s370/mainlast.f has a main program after
# its subprograms, compiled to the assembler committed beside it.
cd "$(dirname "$0")/../.." || exit 2
F77=out/f77
[ -x out/f77.exe ] && F77=out/f77.exe
T=out/units.tmp; mkdir -p $T
bad=0
expect() {    # file message
  if "$F77" "$T/$1.f" "$T/$1.asm" 2>"$T/$1.err"; then
    echo "units: $1 compiled; expected: $2"; bad=$((bad+1))
  elif ! grep -q "$2" "$T/$1.err"; then
    echo "units: $1 said:"; sed 's/^/    /' "$T/$1.err"; bad=$((bad+1))
  fi
}
printf '      SUBROUTINE PRINTIT\n      RETURN\n      PROGRAM HELLO\n      CALL PRINTIT\n      END\n' > $T/noend.f
expect noend "line 3: PROGRAM statement inside a subprogram: the END before it is missing"
printf '      PROGRAM A\n      END\n      PROGRAM B\n      END\n' > $T/twomain.f
expect twomain "line 3: more than one main program"
printf '      GO TO 99\n      END\n' > $T/nolabel.f
expect nolabel "line 2: statement label 99 is referred to but never defined"
printf '      DIMENSION A(3) B(2)\n      END\n' > $T/leftover.f
expect leftover "line 1: unexpected text after the statement"
printf '      X = 1.0\n      CALL FOO(X) Z\n      END\n      SUBROUTINE FOO(Y)\n      Y = 2.0\n      END\n' > $T/callline.f
expect callline "line 2: unexpected text after the statement"
printf '      DO 10 I = 1, 3\n      J = I\n      END\n' > $T/dolabel.f
expect dolabel "line 3: DO 10 is never closed by a statement labelled 10"
printf '      DO I = 1, 3\n      J = I\n      END\n' > $T/noenddo.f
expect noenddo "line 3: DO without END DO"
printf '      IF (J .GT. 0) THEN\n      J = 1\n      END\n' > $T/noendif.f
expect noendif "line 3: IF block without END IF"
printf '      J = 1\n      END DO\n      END\n' > $T/strayenddo.f
expect strayenddo "line 2: END DO without DO"
printf '      CALL S\n      END\n      SUBROUTINE S\n      END\n      SUBROUTINE S\n      END\n' > $T/twosub.f
expect twosub "line 5: S is already a subprogram or ENTRY name (line 3)"
printf '      CALL S\n      END\n      SUBROUTINE S\n      ENTRY T\n      END\n      SUBROUTINE T\n      END\n' > $T/entsub.f
expect entsub "line 6: T is already a subprogram or ENTRY name (line 4)"
printf '      CALL LONGNAME\n      CALL LONGNAME01\n      END\n      SUBROUTINE LONGNAME\n      END\n      SUBROUTINE LONGNAME01\n      END\n' > $T/eightch.f
expect eightch "line 6: LONGNAME01 and LONGNAME (line 4) are one external name, LONGNAME"
printf '      INTEGER A(8)\n      X = SIZE8(A)\n      END\n      INTEGER FUNCTION SIZE8(A)\n      INTEGER A(8)\n      SIZE8 = 8\n      END\n' > $T/fntype.f
expect fntype "line 2: SIZE8 is REAL here but INTEGER where it is defined (line 4)"
printf '      LOGICAL LF\n      J = 0\n      IF (LF(1)) J = 1\n      END\n      INTEGER FUNCTION LF(I)\n      LF = I\n      END\n' > $T/fnlog.f
expect fnlog "line 3: LF is LOGICAL here but INTEGER where it is defined (line 5)"
printf "      WRITE (6, \047(1X,5H123)\047)\n      END\n" > $T/fmtholl.f
expect fmtholl "line 1: FORMAT: 5H wants 5 characters, and the format has 4 left"
printf "      WRITE (6, \047(1X,5H1234567)\047)\n      END\n" > $T/fmtcount.f
expect fmtcount "line 1: FORMAT: a count with no descriptor after it"
printf '      WRITE (6, 100) 1\n  100 FORMAT (1X, Q5)\n      END\n' > $T/fmtletter.f
expect fmtletter "line 2: FORMAT: Q is no edit descriptor"
printf '      WRITE (6, 100) 1\n  100 FORMAT (1X, I, 2(F8.2)\n      END\n' > $T/fmtwidth.f
expect fmtwidth "line 2: FORMAT: I needs a width"
printf "      WRITE (6, \047(HI,MOM)\047) 1\n      END\n" > $T/fmtnoh.f
expect fmtnoh "line 1: FORMAT: H needs its count, nH"
printf '      NAMELIST /G/ A, B\n      READ (5, G) A\n      END\n' > $T/nmllist.f
expect nmllist "line 2: a NAMELIST READ has no list"
printf '      NAMELIST /G/ A /G/ B\n      END\n' > $T/nmltwice.f
expect nmltwice "line 1: a NAMELIST group of that name is already defined"
printf "      READ(\047(I5)\047) N\n      END\n" > $T/intnofmt.f
expect intnofmt "line 1: a CHARACTER unit is an internal file and needs a format"
printf "      CHARACTER*8 C\n      WRITE(C) N\n      END\n" > $T/intunf.f
expect intunf "line 2: a CHARACTER unit is an internal file and needs a format"
printf "      CHARACTER*10 C,D\n      D=C(0:9)\n      END\n" > $T/sub0.f
expect sub0 "line 2: substring outside its string"
printf "      CHARACTER*10 C\n      C(3:11)='Q'\n      END\n" > $T/sublen.f
expect sublen "line 2: substring outside its string"
printf "      CHARACTER*10 C,D\n      D=C(5:4)\n      END\n" > $T/subrev.f
expect subrev "line 2: substring outside its string"
printf "      INTEGER I\n      DATA I /Z'1G'/\n      END\n" > $T/hexbad.f
expect hexbad "line 2: bad hexadecimal constant"
printf "      INTEGER I\n      DATA I /O'8'/\n      END\n" > $T/octbad.f
expect octbad "line 2: bad octal constant"
printf "      INTEGER I\n      DATA I /-ZFF/\n      END\n" > $T/hexneg.f
expect hexneg "line 2: a sign cannot precede a hexadecimal or octal constant"
printf "      I = ISHFT(3)\n      END\n" > $T/bitargs.f
expect bitargs "line 1: wrong number of arguments to a bit intrinsic"
printf "      I = IAND(3, 1.0)\n      END\n" > $T/bitreal.f
expect bitreal "line 1: this intrinsic needs INTEGER arguments"
printf "      CALL MVBITS(1, 0, 4, I)\n      END\n" > $T/mvbits4.f
expect mvbits4 "line 1: MVBITS needs five arguments"
printf "      DEFINE FILE 8(10,20,X,K)\n      END\n" > $T/dfform.f
expect dfform "line 1: a DEFINE FILE's format is E, U or L"
printf "      REAL K\n      DEFINE FILE 8(10,20,E,K)\n      K = 1.0\n      END\n" > $T/dfvar.f
expect dfvar "line 2: a DEFINE FILE's associated variable is an INTEGER variable"
printf "      DEFINE FILE 8(10,20,E,K)\n      READ (8'1,*) I\n      END\n" > $T/dalist.f
expect dalist "line 2: READ (u'r) and WRITE (u'r) take a FORMAT or none"
rm -rf $T
[ $bad = 0 ] && echo "units: a missing END, a second main program, an undefined label, leftover text, open DO and IF blocks, a name used twice, a function's type mistaken, a broken FORMAT, a misused NAMELIST, an internal file with no format, a substring outside its string, a bad hexadecimal or octal constant, a bit intrinsic misused and a DEFINE FILE misused refused"
[ $bad = 0 ]
