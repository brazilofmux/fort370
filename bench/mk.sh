#!/bin/sh
# mk.sh kernel opt -- write a job deck to standard output that compiles
# kernels/<kernel>.f with FORTRAN H at OPT=<opt> (with the object listing),
# links it and runs it, through the FORTHCLG procedure TK4- and TK5 carry.
#
# If JOBUSER and JOBPASS are set, the job card carries USER= and PASSWORD=.
k=${1:?usage: mk.sh kernel opt}; o=${2:?usage: mk.sh kernel opt}
jn=$(echo "FH${k}${o}" | tr a-z A-Z | cut -c1-8)
printf '//%-8s JOB (1),%s,\n' "$jn" "'FORTH'"
if [ -n "${JOBUSER:-}" ]; then
  printf '//             CLASS=A,MSGCLASS=Z,MSGLEVEL=(1,1),\n'
  printf '//             USER=%s,PASSWORD=%s\n' "$JOBUSER" "${JOBPASS:-}"
else
  printf '//             CLASS=A,MSGCLASS=Z,MSGLEVEL=(1,1)\n'
fi
printf "//S1       EXEC FORTHCLG,SOUT=Z,PARM.FORT='OPT=%s,LIST,MAP'\n" "$o"
echo "//FORT.SYSIN DD *"
expand "$(dirname "$0")/kernels/$k.f" | cut -c1-72
echo "/*"
echo "//GO.SYSIN DD DUMMY"
echo "//"
