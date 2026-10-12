#!/bin/sh
# asmclg.sh file.asm [jobname] -- a job deck on standard output that
# assembles fort370's output with IFOX00, link-edits it against
# SYS1.FORTLIB (for IBCOM# and the mathematical routines) and runs it.
# The GO step's CPU time (IEF374I) and what the program prints are the
# measurement.
#
# If JOBUSER and JOBPASS are set, the job card carries USER= and PASSWORD=.
a=${1:?usage: asmclg.sh file.asm [jobname]}
jn=${2:-$(basename "$a" .asm)}
jn=$(echo "F$jn" | tr a-z A-Z | cut -c1-8)
printf '//%-8s JOB (1),%s,\n' "$jn" "'FORT370'"
if [ -n "${JOBUSER:-}" ]; then
  printf '//             CLASS=A,MSGCLASS=Z,MSGLEVEL=(1,1),\n'
  printf '//             USER=%s,PASSWORD=%s\n' "$JOBUSER" "${JOBPASS:-}"
else
  printf '//             CLASS=A,MSGCLASS=Z,MSGLEVEL=(1,1)\n'
fi
cat <<'EOF'
//ASM      EXEC PGM=IFOX00,PARM='OBJ,NODECK',REGION=1024K
//SYSLIB   DD DSN=SYS1.MACLIB,DISP=SHR
//SYSGO    DD DSN=&&OBJ,DISP=(NEW,PASS),UNIT=SYSDA,SPACE=(TRK,(10,5)),
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=3120)
//SYSUT1   DD UNIT=SYSDA,SPACE=(CYL,(5,5))
//SYSUT2   DD UNIT=SYSDA,SPACE=(CYL,(5,5))
//SYSUT3   DD UNIT=SYSDA,SPACE=(CYL,(5,5))
//SYSPRINT DD SYSOUT=Z
//SYSIN    DD *
EOF
cut -c1-72 "$a" | grep -v '^         END *$'
# the debugging routines IPRINT/DPRINT (runtime/s370/f77dbg.asm), for
# programs under test that want to report through the job log; then
# the END card the compiler's output ended with
d="$(dirname "$0")/../runtime/s370/f77dbg.asm"
[ -r "$d" ] && cut -c1-72 "$d"
echo "         END"
cat <<'EOF'
/*
//LKED     EXEC PGM=IEWL,PARM='MAP,LET,LIST',REGION=1024K,
//            COND=(8,LE,ASM)
//SYSLIN   DD DSN=&&OBJ,DISP=(OLD,DELETE)
//SYSLIB   DD DSN=SYS1.FORTLIB,DISP=SHR
//SYSLMOD  DD DSN=&&LOAD(GO),DISP=(NEW,PASS),UNIT=SYSDA,
//            SPACE=(TRK,(20,10,5))
//SYSUT1   DD UNIT=SYSDA,SPACE=(CYL,(5,5))
//SYSPRINT DD SYSOUT=Z
//GO       EXEC PGM=*.LKED.SYSLMOD,COND=((8,LE,ASM),(4,LT,LKED))
//FT05F001 DD DUMMY
//FT06F001 DD SYSOUT=Z
//SYSUDUMP DD SYSOUT=Z
//
EOF
