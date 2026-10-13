# Fitting on MVS 3.8j

The plan is a compiler that runs on MVS 3.8j itself. Before any of it is
written, the question is whether the front end and back end it starts
from can live inside a 24-bit region at all. This is the measurement
that answers it, made 2026-10-12, before any code was copied into this
repository.

## The region

MVS 3.8j runs every job step in a region below the 16MB line, and the
private area that is left after the nucleus, SQA, CSA and LPA is what a
program gets. On TK5 the limit was found by running a small program at
increasing REGION values; it mallocs in 256K pieces, touches each, and
prints the total.

| REGION   | result |
|---|---|
| 8192K    | runs; 7,424K obtained |
| 8704K    | runs; 7,936K obtained |
| 9216K    | ABEND S822, region not available |
| 10240K   | ABEND S822 |
| 16384K   | IEF638I, the JCL reader rejects the number |

So the whole compiler, its tables, its stack and its run-time heap have
to fit in about 7.9MB, and a job that asks for more than 8704K will not
start on this system. cobc370 settled on REGION=8192K; that is the
right number here too.

The S822 is the initiator's, not the program's: the failing steps show
`VIRT 0K` and no CPU time, so the ceiling is the private area TK5's
own layout leaves below 16MB (nucleus, SQA, CSA, LPA), and the
toolchain has no say in it. Where the toolchain could matter is the
second figure, what malloc hands out inside the region, and 7,936K of
8,704K leaves little to gain there.

## The compiler as it is

The starting point is the FORTRAN 77 compiler in slow32-public: a C
program of 22,800 lines, the front end (8,000 lines) plus a copy of the
SLOW-32 back end (13,800 lines: SSA construction, optimizer, invariant
code motion, BURS instruction selection, graph-coloring allocation,
code generation). It was built with cc370, the GCC 3.4.6 port for the
370 that cobc370 is also built with.

The C compiled with no source changes beyond two:

- `open`, `read`, `write`, `close` and `unlink` are not in cc370's
  library. A 25-line shim over stdio stands in for them. (A proper port
  reads SYSIN and writes SYSPUNCH through `dd:` names, as cobc370 does.)
- The constant folder multiplies 64-bit integers, which cc370 compiles
  to a call on `@@MULDI3`. cobc370's millicode file supplies it.

What did not fit was the tables. Every table in this compiler is a
static array with a fixed ceiling, and the ceilings had been raised
over the summer to compile SQLite through the C front end: 262,144 HIR
instructions, 2,097,152 phi arguments, a 16MB SSA renaming stack. The
host binary carries 161MB of static data. as370 refused to assemble it,
rightly: a section cannot pass 16MB.

## What a program unit needs

Fortran program units compile one at a time, so the tables only have to
hold the largest unit anyone writes. The compiler was instrumented to
print, per unit, how much of each table it used, and run over the 192
FCVS programs and the seven kernels in `bench/` (298 units):

| table | largest use | where |
|---|---:|---|
| HIR instructions | 6,691 | FM413, a 1,421-line main program |
| basic blocks | 555 | FM411 |
| phi arguments | 2,482 | FM351 |
| interference-graph nodes | 1,657 | FM909 |
| interference-graph edges | 218,934 | FM801 |

The kernels are small: lll7 is 467 instructions, matmul 559, LINPACK's
MATGEN 310. The FCVS main programs are the largest Fortran units in
reach, and the interference graph is the one table where they come
close to the old ceiling: FM801 has 1,308 nodes but 219K edges, because
its values live long.

## Built for the region

With the ceilings set for 8,192 instructions, 1,024 blocks, 4,096
graph nodes and 262,144 edges, the same C builds under cc370, links,
and compiles all 199 programs on the host without hitting a limit.

| | |
|---|---:|
| load module, XMIT form | 484,720 bytes |
| static tables | 9.2MB |

The module is small. The tables are not yet: 9.2MB is more than the
region. Where they go:

| | bytes | what |
|---|---:|---|
| interference graph adjacency | 2.0MB | two int arrays of 262,144 edges |
| per-instruction arrays | 2.5MB | 81 arrays of 8,192 ints |
| per-block and liveness sets | 1.8MB | dominance frontiers, liveness, the source buffer |
| everything else | 2.9MB | symbol tables, string pools, parse state |

None of this is hard. The adjacency lists can be a bit matrix (4,096
nodes is 2MB, 2,048 nodes is 512K); most per-instruction fields fit a
byte or a halfword; the parser's tables and the allocator's are never
live at the same time and can share storage. Each of those is a day's
work, and together they bring the tables under 6MB. The port is
possible; the ceilings must be chosen, not inherited.

## What this does not say

This section once said the compiler had not run on MVS. It has now
(2026-10-13), and the rest of this file is the record of how it got
there.

## In the region, and running

The day's work the previous section predicted, done: the static tables
and code are 3.9MB, against 9.7MB, and the compiler runs on TK5 in
REGION=8192K; every FCVS program and test compiles in 6656K (the phases' tables,
up to 1MB for the interference graph, come and go on the heap).

| | before | after |
|---|---:|---:|
| interference edges | two int arrays, 2MB | peer and next in one word, 1MB |
| output buffer | 256K | 32K, flushed when full |
| liveness sets | two 256K pools, static | allocated at a unit's size |
| SSA rename stacks | 128K, overrun past 32 variables | threaded through the push log |
| dominator-tree children, rename walk | 256K, 192K | one per block |
| labels, globals, names | 32K labels, 8K globals, 64-byte names | 8K, 2K, 32 bytes |
| kinds, types, flags | int arrays | bytes and halfwords |
| the source file | 256K, read whole | streamed: a unit and 32K of lookahead |
| SSA construction, selection's costs, the graph's edges | static, all at once | allocated per phase, one at a time |
| big frame buffers (8-33K, two in recursion) | the stack | the heap, or static |
| libc370's stack | 256K | 128K; expressions nest 90 deep at most |
| 34 per-instruction index tables | ints | halfwords (`hir_ix`), 560K |

Some of the room went back into the language the same day.  FORTRAN H
takes far larger units than the guest's first ceilings allowed
(`bench/results-limits-2026-10-13.txt`): 4096 symbols and 4096 labels
in a unit, from 1024 and 512, cost 464K, after an array's bounds moved
into rows of their own (a scalar had carried 112 bytes of rank-7
bounds) and the symbols' flags and types became bytes and halfwords.
The static tables and code are 4.4MB, and every FCVS program and test
compiles in 7168K, FM912 being the one that needs more than 6656K.
A constant subscript then became one instruction instead of four,
and what bounds a unit now is its 8192 instructions and 1024 blocks.

Every FCVS program and test compiled to the same assembler before and
after each step, except where a step fixed something: the SSA stacks
had been cut from 16MB to 128K with their indexing kept, so a unit with
more than 32 promoted variables wrote past the table, and four FCVS
programs had compiled differently because of it.

On a host the ceilings are four times as large (`F77_ROOM`, src/f77.c;
the interference graph sixteen), since memory is not the constraint
there. A unit that fits the guest compiles to the same bytes on both;
`make out/f77-guest` is a host build with the guest's ceilings, which is
what the port sweep compares against. The one test too large for the
guest's tables is `tests/s370/big.f`, which needs more than twice its
262,144 interference edges: the guest spills where the host keeps a
register.

`bench/port-sweep.py` compiles every FCVS program and test on the guest
and diffs the assembler with the host's: 254 of 254 identical (the
printer's display of three CP037 characters normalized). What it took
besides room is in docs/BACKEND.md: stdio for the driver, EBCDIC in the
scanner and the front end, and floating constants always converted from
their decimal text rather than through a host double and printf.
