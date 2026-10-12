#!/bin/sh
# run.sh -- every kernel at OPT=0, 1 and 2: CPU seconds of the GO step and
# the checksum each program prints.
#
# RUNNER names a command that takes a deck and an output file, submits the
# deck to MVS and writes the job's printed output to the file. How a deck
# reaches the reader and the printout comes back depends on the system.
export LC_ALL=C
: "${RUNNER:?set RUNNER to a command: RUNNER deck.jcl out.txt}"
B=$(cd "$(dirname "$0")" && pwd); O=${OUT:-$B/out}; mkdir -p "$O"
for k in daxpy ddot matmul lll1 lll5 lll7 linpk; do
  for o in 0 1 2; do
    "$B/mk.sh" $k $o > "$O/$k$o.jcl"
    $RUNNER "$O/$k$o.jcl" "$O/$k$o.out" >/dev/null 2>&1
    cpu=$(grep -a "IEF374I STEP /GO " "$O/$k$o.out" |
          sed 's/.*CPU *\([0-9]*\)MIN \([0-9.]*\)SEC.*/\1 \2/' | awk '{print $1*60+$2}')
    ck=$(grep -a "CHECKSUM " "$O/$k$o.out" | grep -av ISN | tr -s ' ')
    echo "$k OPT=$o cpu=$cpu |$ck"
  done
done
