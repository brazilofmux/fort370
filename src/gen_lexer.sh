#!/usr/bin/env bash
set -euo pipefail
# Generate the Ragel -G2 Fortran token scanner.  Run from inside src/ so
# the #line directives name f77_lexer.rl relatively, not by a host path.
cd "$(dirname "$0")"
ragel -G2 -o f77_lexer_gen.c f77_lexer.rl
echo "Generated: $(wc -l < f77_lexer_gen.c) lines"
