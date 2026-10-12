# Provenance

The compiler sources here began as copies from
[slow32-public](https://github.com/brazilofmux/slow32-public), taken at
commit `2245be78` on 2026-10-12. Each copied file says so on its first
line. They are copies, not a submodule or a symlink, on purpose: the
SLOW-32 tree must be free to change without breaking this one, and this
one is about to change its back end in ways SLOW-32 never will.

| here | there |
|---|---|
| `src/f77.c`, `src/f77_*.h`, `src/f77_lexer.rl` | `fortran/src/` — the front end and driver |
| `src/f77_lexer_gen.c` | regenerated here from the `.rl` by `src/gen_lexer.sh` |
| `backend/hir*.h` | `fortran/src/hir*.h` — which were themselves copies of `selfhost/stage08`, and still say so |
| `runtime/libf77.c` | `fortran/runtime/` — the formatted-I/O runtime |
| `tests/f77/` | `fortran/tests/f77/` — the regression programs |
| `tests/oracle.sh` | `fortran/tests/` — gfortran in a container, for F77 semantics H can't answer |
| `runtime/s370/millicode.c` | cobc370's `src/mvs370-millicode.c` (same author, MIT): the 64-bit millicode cc370 calls |

`runtime/s370/f77rt.c` and `f77rt.h` are generated from `runtime/libf77.c`
by `runtime/s370/port.py` and carry the MVS differences; the copy itself
is not edited.

## Checking a copy

Past its banner line, each file was byte-identical to its original when
copied. To see what has changed since:

    for f in src/f77.c src/f77_*.h src/f77_lexer.rl; do
      diff <(tail -n +2 $f) ../slow32-public/fortran/src/$(basename $f)
    done
    for f in backend/hir*.h; do
      diff <(tail -n +2 $f) ../slow32-public/fortran/src/$(basename $f)
    done

(`f77_lexer_gen.c` differs only in its `#line` directives, which name
the `.rl` relatively here.)

## What will diverge, and what won't

- `backend/` is going to become an S/370 back end. `hir.h`, `hir_ssa.h`,
  `hir_opt.h` and `hir_licm.h` are target-independent and should stay
  close to their originals; `hir_burg.h`, `hir_regalloc.h` and
  `hir_codegen.h` are the SLOW-32 target and will be replaced by S/370
  counterparts. The front-end contract (`src/f77_contract.h`,
  `src/f77_shim.h`) is the only thing that crosses between `src/` and
  `backend/`.
- `src/` should track the SLOW-32 front end where it can. A front-end
  fix found on either side belongs on both. Re-syncing is a deliberate
  act: copy, restamp the banner with the new commit, and run the tests.
- Table ceilings are this project's own (see `docs/FITTING.md`): sized
  for one Fortran unit inside an 8MB region, never inherited.
