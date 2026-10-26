/* COPIED from slow32-public fortran/src/f77.c at 2245be78 (2026-10-12).  See PROVENANCE.md. */
/* f77.c -- Fortran 77 compiler for SLOW-32.
 *
 * Single translation unit, like the rest of this project's compilers:
 * this file includes everything.  Source in, SLOW-32 assembly out.
 *
 *     f77 prog.f prog.s
 *
 * The PROGRAM unit is emitted as `main`, so the existing crt0 and
 * runtime start it and turn its return value into the process exit
 * status -- which is exactly what `STOP n` needs, with no Fortran I/O
 * runtime in the picture yet.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <time.h>
#ifndef __MVS__
#include <unistd.h>
#include <fcntl.h>
#else
/* f77_is_stdin: whether the source is SYSIN, without opening SYSIN */
#include "../runtime/s370/f77std.h"
#endif

/* Windows opens files in text mode unless told; the output must be the
 * same bytes on every host. */
#ifndef O_BINARY
#define O_BINARY 0
#endif

#ifdef F77_TARGET_S370
#define F77_NATIVE_F64 1
#endif

/* fort370: the compiler's switches are environment variables, read
 * where they act -- some once per interference edge or per instruction.
 * A host's getenv is cheap; libc370's is not: those reads were nine
 * tenths of FORT370's time on MVS (René Ferland's AIDAFC, 3 minutes of
 * CPU on TK5, 19 seconds without them).  The environment does not
 * change while the compiler runs, so each name's answer is kept,
 * found again by the address of the name (a literal at every call).
 * The answer is copied: a libc may return every value in one buffer
 * that the next getenv overwrites. */
static char *f77_getenv(const char *name) {
    static const char *key[256];
    static char *val[256];
    unsigned h;
    int n;
    h = (unsigned)(((size_t)name >> 2) & 255);
    n = 0;
    while (n < 256) {
        if (key[h] == name) return val[h];
        if (!key[h]) {
            char *v;
            key[h] = name;
            v = getenv(name);
            val[h] = v ? (char *)malloc(strlen(v) + 1) : (char *)0;
            if (val[h]) strcpy(val[h], v);
            return val[h];
        }
        h = (h + 1) & 255;
        n = n + 1;
    }
    return getenv(name);
}
#define getenv(n) f77_getenv(n)

/* fort370: how much room the tables have.  On MVS the compiler and its
 * tables share a TK5 region of 7.4MB with libc370's stack, so every
 * ceiling is the one docs/FITTING.md chose: one Fortran unit as large
 * as the largest FCVS program, with headroom.  On a host memory is not
 * the constraint, and the ceilings are four times as large (the
 * interference graph sixteen).  A unit that fits the guest compiles to
 * the same bytes on both; a larger one compiles on the host, and the
 * guest refuses it or, where a table only limits optimization, codes
 * it more plainly. */
#ifndef F77_ROOM                     /* -DF77_ROOM=1: a host build with the guest's ceilings */
#ifdef __MVS__
#define F77_ROOM 1
#else
#define F77_ROOM 4
#endif
#endif

#include "f77_shim.h"
#include "f77_contract.h"

static void f77_error(char *msg);
static void f77_limit(char *msg);
static void f77_lst_card(int p, int kind);            /* f77_list.h */
static void f77_warn(int line, char *msg);
static int f77_quiet;
static void f77_lst_note(int line, int sev, char *text);
static void f77_xr_note(char *nm);
static void f77_xr_label(int n, int def);
static void f77_lst_isn_skip(void);
static int f77_xr_off;     /* names noted for XREF not now (f77_list.h) */
static int f77_lst_asm_on; /* the code being written goes into the listing too (LIST) */
static void f77_lst_asm_c(int ch);
static int f77_nerr;      /* errors so far; a unit with any is not given to the back end */
/* fort370: the return code, the worst severity reported, as IBM's
 * compilers give it (#33): 4 a warning, 8 an error, 12 a table of the
 * compiler's too small for the source, 16 the compile not done at all
 * (no storage, the source or the output not to be had) */
#define F77_RC_WARN 4
#define F77_RC_ERROR 8
#define F77_RC_LIMIT 12
#define F77_RC_TERM 16
static int f77_rc;
static void f77_note_rc(int rc) { if (rc > f77_rc) f77_rc = rc; }
static int f77_keepall;   /* the source is read once: all of it stays in the window */

#include "f77_card.h"
#include "f77_lexer_gen.c"
#include "hir.h"
typedef char f77_alloca_room[HL_MAX_ALLOCA >= HIR_MAX_INST ? 1 : -1];   /* see f77_contract.h */
#include "hir_ssa.h"
#include "hir_opt.h"
#include "hir_licm.h"
#ifdef F77_TARGET_S370
/* fort370: the S/370 back end (docs/BACKEND.md).  s370_hfp.h comes
 * before the parser, which converts DATA images with it. */
#include "s370_hfp.h"
#include "hir_burg_s370.h"
#include "hir_regalloc_s370.h"
#include "f77_parse.h"
#include "f77_list.h"
#include "hir_codegen_s370.h"
#else
#include "hir_burg.h"
#include "hir_regalloc.h"
#include "f77_parse.h"
#include "f77_list.h"
#include "hir_codegen.h"
#endif

static int f77_quiet;     /* f77_check_persistence's trial compile: errors are its own */
/* --- the phases' tables, one storage (f77_arena.h) --- */
#include "f77_arena.h"
static char *f77_arena;
static unsigned int f77_arena_fe;          /* bytes of the front end's part */
static unsigned int f77_arena_be;          /* and the back end's */
#define F77_ARENA_SIZE(n, d) off = (off + 7u) & ~7u; off += (unsigned int)(d) * (unsigned int)sizeof *n;
#define F77_ARENA_PLACE(n, d) off = (off + 7u) & ~7u; n = (void *)(f77_arena + off); off += (unsigned int)(d) * (unsigned int)sizeof *n;
static int f77_arena_init(void) {
    unsigned int off;
    off = 0; F77_FE_TABLES(F77_ARENA_SIZE) f77_arena_fe = off;
#ifdef F77_TARGET_S370
    off = 0;
#else
    off = f77_arena_fe;        /* the SLOW-32 back end does not take turns (f77_arena.h) */
#endif
    F77_BE_TABLES(F77_ARENA_SIZE)
#ifdef F77_TARGET_S370
    F77_BE_S370_TABLES(F77_ARENA_SIZE)
#endif
    f77_arena_be = off;
    f77_arena = (char *)calloc(1, f77_arena_fe > f77_arena_be ? f77_arena_fe : f77_arena_be);
    if (!f77_arena) return -1;
    off = 0; F77_FE_TABLES(F77_ARENA_PLACE)
#ifdef F77_TARGET_S370
    off = 0;
#else
    off = f77_arena_fe;
#endif
    F77_BE_TABLES(F77_ARENA_PLACE)
#ifdef F77_TARGET_S370
    F77_BE_S370_TABLES(F77_ARENA_PLACE)
#endif
    if (getenv("F77_ARENA_STATS")) {
        fdputs("f77: arena: front end ", 2); fdputuint(2, f77_arena_fe);
        fdputs(" bytes, back end ", 2); fdputuint(2, f77_arena_be); fdputs("\n", 2);
    }
    return 0;
}
/* A phase begins: its tables start the unit as zeros.  Built with
 * -DF77_ARENA_POISON they start as garbage instead, which is how it is
 * proved that no table in the arena carries anything from one unit, or
 * one phase, to the next: the output must not change. */
static void f77_arena_phase(int be) {
#ifdef F77_ARENA_POISON
    memset(f77_arena, 0xA5, be ? f77_arena_be : f77_arena_fe);
#else
    memset(f77_arena, 0, be ? f77_arena_be : f77_arena_fe);
#endif
}

/* "f77: line n: ", or for a line an INCLUDE brought in, "f77: NAME
 * line n: ", its own file's line (f77_card.h, lx_where). */
static void f77_put_where(int x) {
    int line;
    char *f;
    f = lx_where(x, &line);
    fdputs("f77: ", 2);
    if (f) { fdputs(f, 2); fdputc(' ', 2); }
    fdputs("line ", 2);
    fdputuint(2, (unsigned int)line);
    fdputs(": ", 2);
}

static void f77_error_sev(char *msg, int sev) {
    if (f77_quiet) { f77_quiet = f77_quiet + 1; return; }
    f77_put_where(lx_stmt_line);
    fdputs(msg, 2);
    fdputc('\n', 2);
    fdputs("  in: ", 2);
    fdputs(lx_stmt, 2);
    fdputc('\n', 2);
    f77_nerr = f77_nerr + 1;
    f77_note_rc(sev);
    f77_lst_note(lx_stmt_line, sev, msg);
}
static void f77_error(char *msg) { f77_error_sev(msg, F77_RC_ERROR); }

/* An error that is the compiler's: one of its tables is full */
static void f77_limit(char *msg) { f77_error_sev(msg, F77_RC_LIMIT); }

/* A warning: said, and the compile goes on */
static void f77_warn(int line, char *msg) {
    if (f77_quiet) return;
    if (line > 0) f77_put_where(line);
    else fdputs("f77: ", 2);
    fdputs("warning: ", 2);
    fdputs(msg, 2);
    fdputc('\n', 2);
    f77_note_rc(F77_RC_WARN);
    f77_lst_note(line, F77_RC_WARN, msg);
}

/* fort370: two subprograms (or ENTRY points) of one name -- the CALL
 * reached whichever came first, without a word (#13) -- and, on MVS,
 * two names that are one external name there, the first eight
 * characters, which IEWL would take for one. */
static void f77_report_at(int line, char *msg) {
    f77_put_where(line);
    fdputs(msg, 2);
    fdputc('\n', 2);
    f77_nerr = f77_nerr + 1;
    f77_note_rc(F77_RC_ERROR);
    f77_lst_note(line, F77_RC_ERROR, msg);
}
static void f77_check_unit_names(void) {
    int i;
    int j;
    char m[160];
    for (j = 0; j < f77_nunit; j++) {
        if (f77_ukind[j] != F77_UNIT_SUBR && f77_ukind[j] != F77_UNIT_FUNC) continue;
        for (i = 0; i < j; i++) {
            if (f77_ukind[i] != F77_UNIT_SUBR && f77_ukind[i] != F77_UNIT_FUNC) continue;
            {
                int a;
                int b;
                /* report at the later of the two in the source (ENTRY
                 * points are units after the ordinary ones) */
                a = f77_uline[i] <= f77_uline[j] ? i : j;
                b = a == i ? j : i;
                if (strcmp(f77_uname[i], f77_uname[j]) == 0) {
                    sprintf(m, "%s is already a subprogram or ENTRY name (line %d)", f77_uname[b], f77_uline[a]);
                    f77_report_at(f77_uline[b], m);
                    break;
                }
#ifdef F77_TARGET_S370
                if ((strlen(f77_uname[i]) > 8 || strlen(f77_uname[j]) > 8) && strncmp(f77_uname[i], f77_uname[j], 8) == 0) {
                    sprintf(m, "%s and %s (line %d) are one external name, %.8s: MVS keeps eight characters",
                            f77_uname[b], f77_uname[a], f77_uline[a], f77_uname[b]);
                    f77_report_at(f77_uline[b], m);
                    break;
                }
#endif
            }
        }
    }
}

static Node f77_units[F77_MAX_UNIT];
static Node f77_program;

/* Phase 1: walk the source once and record where each program unit
 * begins.  A file may hold a PROGRAM plus any number of SUBROUTINEs and
 * FUNCTIONs, and the backend drives them one at a time, so their
 * boundaries have to be known before any of them is compiled. */
#define F77_MAX_ENTRY 64
static int  f77_ent_pos[F77_MAX_ENTRY];
static int  f77_ent_line[F77_MAX_ENTRY];
static int  f77_ent_parent[F77_MAX_ENTRY];
static char f77_ent_name[F77_MAX_ENTRY][F77_MAX_NAME];
static int  f77_ent_ty[F77_MAX_ENTRY];
static int  f77_nent;

/* Record the dummy names of the header the scanner is on (past `skip`)
 * against unit `unit`, for the ENTRY phantoms. */
static void f77_collect_dummies(int skip, int unit) {
    f77_scan_from(skip);
    if (lx_t == T_NAME) f77_tok();
    f77_hdr_skip_len();
    if (lx_t != T_LP) return;
    f77_tok();
    while (lx_t == T_NAME || lx_t == T_STAR) {
        if (lx_t == T_NAME && f77_nfamd < F77_MAX_FAMD) {
            strcpy(f77_famd_name[f77_nfamd], lex_name);
            f77_famd_unit[f77_nfamd] = unit;
            f77_nfamd = f77_nfamd + 1;
        }
        f77_tok();
        if (lx_t != T_COMMA) break;
        f77_tok();
    }
}

static void f77_scan_units(void) {
    int pos;
    int line;
    int rty;
    int started;
    int ended;        /* fort370: the unit begun last has had its END */
    int mains;        /* main programs begun */
    int last;         /* the line of the statement read last */

    f77_nunit = 0;
    f77_nent = 0;
    f77_nfamd = 0;
    { int z; z = 0; while (z < F77_MAX_UNIT) { f77_uentry_parent[z] = -1; z = z + 1; } }
    f77_nformat = 0;
    f77_ndf = 0;
    f77_nasg = 0;
    f77_nesc = 0;
    { int z; z = 0; while (z < F77_MAX_UNIT) { f77_ustmts[z] = 0; f77_unosplice[z] = 0; z = z + 1; } }
    started = 0;
    ended = 0;
    mains = 0;
    last = 1;
    pos = lx_pos;
    line = lx_line;

    for (;;) {
        /* fort370: what the window must hold while this statement is
         * read -- from its start, or from the unit's header while the
         * unit may yet be kept whole for the inliner (f77_unit_done) */
        if (!f77_keepall)
            lx_keep = (f77_nunit > 0 && f77_keep_candidate(f77_nunit - 1)) ? f77_upos[f77_nunit - 1] : pos;
        if (!f77_next_stmt()) break;
        /* fort370: a PROGRAM statement inside a subprogram means the
         * END before it is missing; taken as more of that unit, the
         * main program would vanish without a word.  (In a main program
         * a second one is documentation: 40 of the FCVS files as
         * distributed open with their PROGRAM card twice.) */
        if (started && !ended && f77_ukind[f77_nunit - 1] != F77_UNIT_PROGRAM
            && f77_starts("PROGRAM")
            && memchr(lx_stmt, '=', (size_t)lx_stmt_len) == NULL) {
            f77_error("PROGRAM statement inside a subprogram: the END before it is missing");
            return;
        }
        /* fort370: after an END, a statement that is no subprogram's
         * header begins the main program, with a PROGRAM statement or
         * without one -- the main program may follow its subprograms */
        if (started && ended && !f77_starts("SUBROUTINE") && !f77_starts("BLOCKDATA")
            && f77_unit_header_ty() < 0) {
            if (mains > 0) { f77_error("more than one main program"); return; }
            if (f77_nunit >= F77_MAX_UNIT) { f77_limit("too many program units"); return; }
            f77_unit_done(f77_nunit - 1, pos);
            f77_upos[f77_nunit] = pos;
            f77_uline[f77_nunit] = line;
            f77_ukind[f77_nunit] = F77_UNIT_PROGRAM;
            f77_urty[f77_nunit] = TY_INT;
            strcpy(f77_uname[f77_nunit], "main");
            f77_nunit = f77_nunit + 1;
            mains = mains + 1;
            ended = 0;
        }
        /* Collect FORMAT statements: a WRITE may name a label defined
         * later in the unit, so they must all be known up front. */
        if (f77_starts("FORMAT") && lx_stmt_label >= 0 &&
            f77_nformat < F77_MAX_FORMAT) {
            f77_flabel[f77_nformat] = lx_stmt_label;
            f77_funit[f77_nformat] = started ? f77_nunit - 1 : 0;
            f77_fstr[f77_nformat] =
                f77_intern_str(lx_stmt + 6, lx_stmt_len - 6);
            f77_nformat = f77_nformat + 1;
        }
        f77_esc_scan(started ? f77_nunit - 1 : 0);
        /* DEFINE FILE: done as its unit is entered, so collected here;
         * a unit with one is not inlined, which would lose that */
        if (f77_is_dfile()) {
            f77_dfile_scan(started ? f77_nunit - 1 : 0);
            if (started && f77_nunit > 0) f77_unosplice[f77_nunit - 1] = 1;
        }
        if (f77_starts("ASSIGN") && f77_nasg < F77_MAX_ASG) {
            f77_scan_from(6);
            if (lx_t == T_ICON) {
                f77_asg_lab[f77_nasg] = lex_ival;
                f77_asg_unit[f77_nasg] = started ? f77_nunit - 1 : 0;
                f77_nasg = f77_nasg + 1;
            }
        }
        if (started && f77_nunit > 0) {
            f77_ustmts[f77_nunit - 1]++;
            if (f77_starts("COMMON") || f77_starts("IMPLICIT") ||
                f77_starts("DATA") || f77_starts("SAVE") ||
                f77_starts("EQUIVALENCE") || f77_starts("PARAMETER") ||
                f77_starts("ENTRY") || f77_starts("EXTERNAL") ||
                f77_starts("CHARACTER") || f77_starts("NAMELIST"))
                f77_unosplice[f77_nunit - 1] = 1;
            /* fort370: and a type statement with initial values,
             * INTEGER L/1/, which are DATA: spliced, L became the
             * caller's temporary, never set (#32) */
            if ((f77_starts("INTEGER") || f77_starts("REAL") ||
                 f77_starts("LOGICAL") || f77_starts("DOUBLE") ||
                 f77_starts("COMPLEX")) && f77_toplevel('/', 0) >= 0)
                f77_unosplice[f77_nunit - 1] = 1;
        }
        if (started && f77_nunit > 0 && f77_starts("ENTRY") &&
            f77_ukind[f77_nunit - 1] != F77_UNIT_PROGRAM && f77_nent < F77_MAX_ENTRY) {
            f77_scan_from(5);
            if (lx_t == T_NAME) {
                strcpy(f77_ent_name[f77_nent], lex_name);
                f77_ent_pos[f77_nent] = pos;
                f77_ent_line[f77_nent] = line;
                f77_ent_parent[f77_nent] = f77_nunit - 1;
                f77_ent_ty[f77_nent] = f77_implicit_ty(lex_name);
                f77_collect_dummies(5, -2 - f77_nent);   /* unit index assigned after the scan */
                f77_nent = f77_nent + 1;
            }
            f77_unosplice[f77_nunit - 1] = 1;
            pos = lx_pos;
            line = lx_line;
            continue;
        }
        rty = f77_unit_header_ty();
        if (f77_starts("BLOCKDATA")) {
            /* A declarations-only unit: its DATA lands in the COMMON
             * blocks it names.  It compiles to an empty function that
             * nothing calls; the name is mangled so it cannot collide
             * with a subprogram. */
            if (f77_nunit >= F77_MAX_UNIT) { f77_limit("too many program units"); return; }
            if (f77_nunit > 0) f77_unit_done(f77_nunit - 1, pos);
            f77_upos[f77_nunit] = pos;
            f77_uline[f77_nunit] = line;
            f77_ukind[f77_nunit] = F77_UNIT_BDATA;
            f77_urty[f77_nunit] = TY_INT;
            f77_scan_from(9);
            strcpy(f77_uname[f77_nunit], "f77bd_");
            if (lx_t == T_NAME) strcat(f77_uname[f77_nunit], lex_name);
            {
                char num[12];
                int q;
                int v;
                q = 0; v = f77_nunit;
                num[q++] = '_';
                if (v >= 100) num[q++] = (char)('0' + v / 100);
                if (v >= 10) num[q++] = (char)('0' + (v / 10) % 10);
                num[q++] = (char)('0' + v % 10);
                num[q] = 0;
                strcat(f77_uname[f77_nunit], num);
            }
            f77_nunit = f77_nunit + 1;
            started = 1;
            ended = 0;
        } else if (f77_starts("SUBROUTINE") || rty >= 0) {
            if (f77_nunit >= F77_MAX_UNIT) { f77_limit("too many program units"); return; }
            if (f77_nunit > 0) f77_unit_done(f77_nunit - 1, pos);
            f77_upos[f77_nunit] = pos;
            f77_uline[f77_nunit] = line;
            f77_unit_name(f77_nunit);
            f77_collect_dummies(f77_starts("SUBROUTINE") ? 10 : f77_function_skip(), f77_nunit);
            if (rty >= 0) {
                /* the header is classified many times; its length is
                 * reported once, here (from SLOW-32 9b9c91f4) */
                if (f77_hdr_len > 0) (void)f77_lenty(rty, f77_hdr_len, 1);
                f77_ukind[f77_nunit] = F77_UNIT_FUNC;
                /* Bare FUNCTION uses the I-N rule; a later type
                 * statement of the function name overrides it. */
                if (f77_starts("FUNCTION"))
                    f77_urty[f77_nunit] = f77_implicit_ty(f77_uname[f77_nunit]);
                else
                    f77_urty[f77_nunit] = rty;
                f77_urlog[f77_nunit] = f77_hdr_log;
                f77_urnar[f77_nunit] = f77_starts("FUNCTION") ? 0 : f77_lennar(rty, f77_hdr_len, f77_hdr_log);
                if (rty == TY_CHAR && f77_hdr_clen == -2) {
                    f77_scan_from(f77_hdr_clen_off);
                    f77_urlen[f77_nunit] = f77_char_len();
                } else {
                    f77_urlen[f77_nunit] = (rty == TY_CHAR) ? f77_hdr_clen : 1;
                }
            } else {
                f77_ukind[f77_nunit] = F77_UNIT_SUBR;
                f77_urty[f77_nunit] = TY_INT;
                f77_urlog[f77_nunit] = 0;
                f77_urnar[f77_nunit] = 0;
            }
            f77_nunit = f77_nunit + 1;
            started = 1;
            ended = 0;
        } else if (started && f77_nunit > 0 &&
                   f77_ukind[f77_nunit - 1] == F77_UNIT_FUNC) {
            int ty;
            int skip;
            ty = -1;
            skip = 0;
            int clen;
            int lg;
            int tnar;
            clen = 1;
            lg = 0;
            tnar = 0;
            if (f77_starts("INTEGER")) { ty = TY_INT; skip = 7; }
            else if (f77_starts("LOGICAL")) { ty = TY_INT; skip = 7; lg = 1; }
            else if (f77_starts("DOUBLEPRECISION")) { ty = TY_DOUBLE; skip = 15; }
            else if (f77_starts("REAL")) { ty = TY_FLOAT; skip = 4; }
            else if (f77_starts("CHARACTER")) { ty = TY_CHAR; skip = 9; }
            else if (f77_starts("COMPLEX")) { ty = TY_CPLX; skip = 7; }
#ifdef F77_NATIVE_F64
            else if (f77_starts("DOUBLECOMPLEX")) { ty = TY_DCPLX; skip = 13; }
#endif
            if (ty >= 0) {
                f77_scan_from(skip);
                if (lx_t == T_STAR) {
                    int n;
                    if (ty == TY_CHAR) { f77_tok(); clen = f77_char_len(); }
                    else if (f77_star_len(&n)) { ty = f77_lenty(ty, n, 0); tnar = f77_lennar(ty, n, lg); }
                    if (lx_t == T_COMMA) f77_tok();
                }
                while (lx_t == T_NAME) {
                    int is_fn;
                    is_fn = strcmp(lex_name, f77_uname[f77_nunit - 1]) == 0;
                    f77_tok();
                    if (lx_t == T_STAR && ty == TY_CHAR) {
                        int l;
                        f77_tok();
                        l = f77_char_len();
                        if (is_fn) { f77_urty[f77_nunit - 1] = TY_CHAR; f77_urlen[f77_nunit - 1] = l; }
                    } else if (lx_t == T_STAR) {
                        int n;
                        if (f77_star_len(&n) && is_fn) {
                            f77_urty[f77_nunit - 1] = f77_lenty(ty, n, 0);
                            f77_urlog[f77_nunit - 1] = lg;
                            f77_urnar[f77_nunit - 1] = f77_lennar(ty, n, lg);
                        }
                    } else if (is_fn) {
                        f77_urty[f77_nunit - 1] = ty;
                        f77_urlog[f77_nunit - 1] = lg;
                        f77_urnar[f77_nunit - 1] = tnar;
                        if (ty == TY_CHAR) f77_urlen[f77_nunit - 1] = clen;
                    } else {
                        int q;
                        for (q = 0; q < f77_nent; q++)
                            if (f77_ent_parent[q] == f77_nunit - 1 &&
                                strcmp(f77_ent_name[q], lex_name) == 0) f77_ent_ty[q] = ty;
                    }
                    if (lx_t == T_LP) {
                        int depth;
                        depth = 1;
                        f77_tok();
                        while (lx_t != T_EOF && depth > 0) {
                            if (lx_t == T_LP) depth = depth + 1;
                            else if (lx_t == T_RP) depth = depth - 1;
                            f77_tok();
                        }
                    }
                    if (lx_t != T_COMMA) break;
                    f77_tok();
                }
            }
        } else if (!started) {
            /* Statements before any subprogram header belong to the
             * main program, whether or not a PROGRAM card is present. */
            f77_upos[f77_nunit] = pos;
            f77_uline[f77_nunit] = line;
            f77_ukind[f77_nunit] = F77_UNIT_PROGRAM;
            f77_urty[f77_nunit] = TY_INT;
            strcpy(f77_uname[f77_nunit], "main");
            f77_nunit = f77_nunit + 1;
            mains = mains + 1;
            started = 1;
        }
        if (started && f77_is_unit_end()) ended = 1;
        last = lx_stmt_line;
        pos = lx_pos;
        line = lx_line;
    }
    /* fort370: the source ends inside a unit, with no END.  FORTRAN H
     * stops there, return code 16; taken as ended, as it always was
     * here, but said (#33) */
    if (started && !ended) f77_warn(last, "the source ends without an END statement");

    if (f77_nunit > 0) f77_unit_done(f77_nunit - 1, lx_pos);
    if (!f77_keepall) lx_keep = 0x7FFFFFFF;

    /* Each ENTRY becomes a unit of its own, after the ordinary ones. */
    {
        int q;
        for (q = 0; q < f77_nent; q++) {
            int par;
            if (f77_nunit >= F77_MAX_UNIT) { f77_limit("too many program units"); return; }
            par = f77_ent_parent[q];
            f77_upos[f77_nunit] = f77_ent_pos[q];
            f77_uline[f77_nunit] = f77_ent_line[q];
            f77_ukind[f77_nunit] = f77_ukind[par];
            f77_urty[f77_nunit] = (f77_ukind[par] == F77_UNIT_FUNC) ? f77_ent_ty[q] : TY_INT;
            f77_urlog[f77_nunit] = 0;
            f77_urnar[f77_nunit] = 0;
            f77_urlen[f77_nunit] = 1;
            strcpy(f77_uname[f77_nunit], f77_ent_name[q]);
            f77_uentry_parent[f77_nunit] = par;
            f77_unosplice[f77_nunit] = 1;
            {
                int d;
                for (d = 0; d < f77_nfamd; d++)
                    if (f77_famd_unit[d] == -2 - q) f77_famd_unit[d] = f77_nunit;
            }
            f77_nunit = f77_nunit + 1;
        }
    }
    f77_check_unit_names();
}

/* Phase 2: the backend asks for one unit's HIR. */
static void hl_func_body(Node *fn);
static void hl_func(Node *fn) {
    f77_lst_unit_begin(fn->unit);
    hl_func_body(fn);
    f77_lst_unit_mid(lx_line);
#ifndef F77_TARGET_S370
    f77_lst_unit_end();          /* the S/370 back end's s370_gen_unit ends it, after the code */
#endif
}
static void hl_func_body(Node *fn) {
    int b_entry;
    int u;

    u = fn->unit;
    hl_cur_fn_dbg = fn->name;
    f77_arena_phase(0);
#ifdef F77_TARGET_S370
    ssa_exposed_keep = (f77_ukind[u] != F77_UNIT_PROGRAM);   /* see ssa_keep_exposed */
#endif
    {
        int q;
        f77_unit_entries = f77_uentry_parent[u] >= 0;
        for (q = 0; q < f77_nent; q++)
            if (f77_ent_parent[q] == u) f77_unit_entries = 1;
    }

    hir_reset();
    hl_nalloca = 0;
    hl_temp_stack = 0;
    f77_sym_reset();
    f77_nlabel = 0;
    f77_scope_base = 0;
    f77_label_base = 0;
    f77_inline_depth = 0;
    f77_ctl_reset();
    /* Reserve the top 8 bytes of the frame for the saved r31 and r30,
     * exactly as the C compiler's parser does (ps_stack = 8).  Starting
     * at 0 lets the register allocator place the first callee-save slot
     * at fp-4 -- on top of the saved return address -- so any unit with
     * fewer than two locals returned to a wild address.  It only became
     * visible when a bigger .text gave that address somewhere harmful
     * to land. */
    f77_frame = 8;

    b_entry = hir_new_block();
    f77_begin_blk(b_entry);

    /* Rewind to this unit's first statement and bind its header. */
    lx_goto(f77_upos[u], f77_uline[u]);
    if (!f77_next_stmt()) return;
    f77_bind_unit(u);
    fn->nparams = f77_unit_nparams;

    f77_entry_state = 0;
    if (f77_uentry_parent[u] >= 0) {
        /* An ENTRY: the parent's whole text, from its header on.  Its
         * first executable statement branches to the ENTRY statement
         * (f77_entry_state); the statements before that are reached
         * only by a GO TO.  Compiled from the ENTRY onward alone, a
         * GO TO back into them had nowhere to go. */
        int par;
        par = f77_uentry_parent[u];
        f77_entry_line = f77_uline[u];
        f77_entry_blk = hir_new_block();
        f77_entry_state = 1;
        lx_goto(f77_upos[par], f77_uline[par]);
        if (!f77_next_stmt()) return;                 /* the parent's header */
        if (!f77_next_stmt()) { f77_emit_return(); fn->locals_size = f77_frame; return; }
    } else if (f77_ukind[u] != F77_UNIT_PROGRAM) {
        /* The header itself emits nothing; go on to the body. */
        if (!f77_next_stmt()) { f77_emit_return(); fn->locals_size = f77_frame; return; }
    }

    for (;;) {
        f77_statement();
        /* The unit terminator is the statement END, exactly: a prefix
         * match here swallowed everything after the first ENDIF -- the
         * unit ended there, fell off returning 0, and slice2 passed
         * vacuously against the oracle for a full day. */
        if (f77_is_unit_end()) break;
        if (!f77_next_stmt()) break;
        if (f77_unit_header_ty() >= 0 || f77_starts("SUBROUTINE")) break;
    }
    /* fort370: a block left open at END */
    while (ctl_n > 0) {
        ctl_n = ctl_n - 1;
        if (ctl_kind[ctl_n] == F77_CTL_IF) f77_error("IF block without END IF");
        else if (ctl_label[ctl_n] < 0) f77_error("DO without END DO");
        else {
            /* a labelled DO whose terminal statement never came (#14) */
            char m[64];
            sprintf(m, "DO %d is never closed by a statement labelled %d", ctl_label[ctl_n], ctl_label[ctl_n]);
            f77_error(m);
        }
    }
    f77_label_check();

    if (f77_cur_blk_live) f77_emit_return();

    /* The HIR is complete: retract the read-only-load assertion for
     * every dummy this unit turned out to store (see f77_ldro_note). */
    f77_ldro_finalize();

    fn->locals_size = f77_frame;
}

#ifdef F77_TARGET_S370
/* fort370: a subprogram's locals keep their values from one call to the
 * next, as under FORTRAN H (ssa_keep_exposed); a spliced copy's locals
 * are the caller's, fresh at each splice, so a small subroutine counting
 * its calls in a local would count wrongly inlined (#15).  Before code
 * generation, each unit the inliner might take is compiled once alone,
 * with inlining off, and the compile thrown away: if a local's value on
 * entry can reach a use, or its address is taken (an array, an actual
 * argument, an I/O item), the unit is never spliced. */
static int f77_locals_exposed(void) {
    char *want;
    int *mark;
    int *stack;
    int s, i, k, v, b, sp, x, exposed;
    want = (char *)calloc((size_t)h_ninst + 1, 1);
    mark = (int *)calloc((size_t)bb_nblk + 1, sizeof(int));
    stack = (int *)calloc((size_t)bb_nblk + 1, sizeof(int));
    if (!want || !mark || !stack) { free(want); free(mark); free(stack); return 1; }
    for (s = 0; s < f77_nsym; s++) {
        if (f77_sarg[s] || f77_scom[s] || f77_sexternal[s] || f77_sintrinsic[s] ||
            f77_sparam[s] || f77_sname[s][0] == '%') continue;
        if (f77_sval[s] >= 0 && f77_sval[s] < h_ninst && h_kind[f77_sval[s]] == HI_ALLOCA)
            want[f77_sval[s]] = 1;
        if (f77_shi[s] >= 0 && f77_shi[s] < h_ninst && h_kind[f77_shi[s]] == HI_ALLOCA)
            want[f77_shi[s]] = 1;
    }
    exposed = 0;
    /* an address taken: anything but a LOAD or STORE through it */
    for (i = 0; i < h_ninst && !exposed; i++) {
        k = h_kind[i];
        if (k == HI_BR || k == HI_BRC || k == HI_JMPTAB || k == HI_ALLOCA ||
            k == HI_ICONST || k == HI_FCONST || k == HI_PARAM || k == HI_NOP) continue;
        if (h_src1[i] >= 0 && h_src1[i] < h_ninst && want[h_src1[i]] &&
            k != HI_LOAD && k != HI_STORE) exposed = 1;
        if (h_src2[i] >= 0 && h_src2[i] < h_ninst && want[h_src2[i]]) exposed = 1;
    }
    for (i = 0; i < h_ncarg && !exposed; i++)
        if (h_carg[i] >= 0 && h_carg[i] < h_ninst && want[h_carg[i]]) exposed = 1;
    /* a read reached from the entry along blocks that never write it */
    for (v = 0; v < h_ninst && !exposed; v++) {
        if (!want[v]) continue;
        sp = 0;
        stack[sp++] = 0;
        mark[0] = v + 1;
        while (sp > 0 && !exposed) {
            int term;
            int first;
            b = stack[--sp];
            if (bb_start[b] < 0 || bb_start[b] >= bb_end[b]) { exposed = 1; break; }
            first = 0;
            term = -1;
            for (i = bb_start[b]; i < bb_end[b]; i++) {
                k = h_kind[i];
                if (!first && (k == HI_LOAD || k == HI_STORE) && h_src1[i] == v)
                    first = k == HI_LOAD ? 1 : 2;
                if (hi_is_terminator(k)) { term = i; break; }
            }
            if (first == 1 || term < 0) { exposed = 1; break; }
            if (first == 2) continue;
            k = h_kind[term];
            for (x = 0; x < 2; x++) {
                int t;
                t = -1;
                if (k == HI_BR && x == 0) t = h_val[term];
                if (k == HI_BRC) t = x == 0 ? h_src2[term] : h_val[term];
                if (t >= 0 && t < bb_nblk && mark[t] != v + 1) { mark[t] = v + 1; stack[sp++] = t; }
            }
            if (k == HI_JMPTAB) {
                int j;
                j = h_val[term];
                if (j >= 0 && j < bb_nblk && mark[j] != v + 1) { mark[j] = v + 1; stack[sp++] = j; }
                for (j = 0; j < hjt_span[term]; j++) {
                    int t;
                    t = hjt_target[hjt_base[term] + j];
                    if (t >= 0 && t < bb_nblk && mark[t] != v + 1) { mark[t] = v + 1; stack[sp++] = t; }
                }
            }
        }
    }
    free(want); free(mark); free(stack);
    return exposed;
}

static void f77_check_persistence(void) {
    int u;
    int save_dis;
    int save_strs;
    int save_pool;
    char *save_src;
    int save_len;
    int save_streaming;
    int save_pos;
    int save_line;
    Node fn;
    f77_inline_probe();
    if (f77_inline_disabled) return;
    save_dis = f77_inline_disabled;
    for (u = 0; u < f77_nunit; u++) {
        f77_urelies[u] = 0;
        if (!f77_keep_candidate(u)) continue;
        if (lx_streaming && !f77_utext[u]) { f77_urelies[u] = 1; continue; }
        save_strs = lex_str_count;
        save_pool = lex_strpool_len;
        save_src = lx_src;
        save_len = lx_len;
        save_streaming = lx_streaming;
        save_pos = lx_pos;
        save_line = lx_line;
        if (f77_utext[u]) {
            lx_streaming = 0;
            lx_src = f77_utext[u] - f77_upos[u];
            lx_len = f77_uend[u];
        }
        memset(&fn, 0, sizeof fn);
        fn.name = f77_uname[u];
        fn.unit = u;
        f77_inline_disabled = 1;
        f77_quiet = 1;
        hl_func(&fn);
        /* a unit in error is refused when it is compiled for real */
        f77_urelies[u] = (char)(f77_quiet > 1 || f77_locals_exposed());
        f77_quiet = 0;
        f77_inline_disabled = save_dis;
        lex_str_count = save_strs;
        lex_strpool_len = save_pool;
        lx_src = save_src;
        lx_len = save_len;
        lx_streaming = save_streaming;
        lx_pos = save_pos;
        lx_line = save_line;
    }
    if (getenv("F77_RELIES")) {
        for (u = 0; u < f77_nunit; u++)
            if (f77_urelies[u]) { fdputs("f77: not inlined, may keep a local: ", 2); fdputs(f77_uname[u], 2); fdputc('\n', 2); }
    }
}
#endif

#ifdef __MVS__
/* fort370: the C stack libc370's startup allocates (its weak external
 * @@STKLEN; the default is 256K).  The compiler's frames are small --
 * the largest is under 1K, its big buffers live on the heap or in static
 * storage -- and its deepest chain is a nested expression, about 1.2K a
 * level, limited to F77_MAX_EXPR_DEPTH (90) levels: 128K holds that with
 * room, and gives the tables 128K more of the region. */
int __stklen = 131072;
#endif

/* fort370: how the source is read again for code generation (lx_reopen):
 * on a host the named file is opened again; on MVS the copy the scan
 * made in SYSUT1 is read back. */
static char *f77_inname;
static FILE *f77_reopen_file(void) {
#ifdef __MVS__
    if (lx_fp && !f77_is_stdin(lx_fp)) fclose(lx_fp);
#else
    if (lx_fp && lx_fp != stdin) fclose(lx_fp);
#endif
#ifdef __MVS__
    return fopen("dd:SYSUT1", "r");
#else
    return fopen(f77_inname, "rb");
#endif
}

int main(int argc, char **argv) {
#ifdef F77_TARGET_S370
    FILE *flst;
#endif
#ifdef F77_TARGET_S370
    /* stdio, which every host and libc370 have.  On MVS the source is
     * the SYSIN DD and the assembler goes to SYSPUNCH, as cobc370's do,
     * both as records (text); on a host both are files, as bytes.  The
     * source is streamed (f77_card.h), so no limit on its length but the
     * largest unit's. */
    FILE *fin;
    FILE *fout;
    char *inname;
    char *outname;
    int keepall;
    keepall = 0;
    flst = 0;
#ifdef __MVS__
    /* SYSIN is libc370's stdin, already open: reading it there rather
     * than opening dd:SYSIN a second time lets it be DD * (a second open
     * of instream data is the one JES2 refuses, S013-C0).  It is read
     * once, so the scan copies it to the work data set SYSUT1 for the
     * second reading; without a SYSUT1 the whole source is kept in
     * storage instead. */
    /* PARM is the options (#35), H's; the listing is SYSPRINT, libc370's
     * stdout.  (A PARM of data set names, dd:..., is the source and the
     * output, as before.) */
    if (argc > 1 && (strncmp(argv[1], "dd:", 3) == 0 || strncmp(argv[1], "DD:", 3) == 0)) {
        inname = argv[1];
        outname = argc > 2 ? argv[2] : "dd:SYSPUNCH";
        fin = fopen(inname, "r");
    } else {
        int a;
        for (a = 1; a < argc; a++) f77_options(argv[a]);
        inname = "dd:SYSIN";
        outname = "dd:SYSPUNCH";
        fin = stdin;
    }
    flst = stdout;
    lx_spool = fopen("dd:SYSUT1", "w");
    if (!lx_spool) keepall = 1;
#else
    /* -p OPTIONS, H's, and -l FILE, a listing, before the two names */
    while (argc > 2 && argv[1][0] == '-' && (argv[1][1] == 'p' || argv[1][1] == 'l') && argv[1][2] == 0) {
        if (argv[1][1] == 'p') f77_options(argv[2]);
        else {
            flst = fopen(argv[2], "w");
            if (!flst) { fdputs("f77: cannot open the listing ", 2); fdputs(argv[2], 2); fdputc('\n', 2); return F77_RC_TERM; }
        }
        argv[2] = argv[0];
        argv = argv + 2;
        argc = argc - 2;
    }
    if (argc < 3) {
        fdputs("usage: f77 [-p options] [-l listing] source.f output.asm\n", 2);
        return F77_RC_TERM;
    }
    inname = argv[1];
    outname = argv[2];
    fin = fopen(inname, "rb");
#endif
    if (!fin) {
        fdputs("f77: cannot open ", 2);
        fdputs(inname, 2);
        fdputc('\n', 2);
        return F77_RC_TERM;
    }
    f77_inname = inname;
    lx_inname = inname;
    f77_keepall = keepall;
    lx_reopen = keepall ? 0 : f77_reopen_file;
    lx_keep = keepall ? 0 : 0x7FFFFFFF;
    lx_start(fin);
    f77_lst_open(flst);
#else
    static char src[1 << 18];   /* the source file, whole */
    int n;
    int fd;

    if (argc < 3) {
        fdputs("usage: f77 source.f output.s\n", 2);
        return F77_RC_TERM;
    }

    fd = open(argv[1], O_RDONLY | O_BINARY);
    if (fd < 0) {
        fdputs("f77: cannot open ", 2);
        fdputs(argv[1], 2);
        fdputc('\n', 2);
        return F77_RC_TERM;
    }
    n = (int)read(fd, src, sizeof(src) - 1);
    if (n < 0) n = 0;
    src[n] = 0;
    close(fd);

    lx_src = src;
    lx_len = n;
    lx_pos = 0;
    lx_line = 1;
#endif

    if (f77_arena_init() != 0) { fdputs("f77: no storage for the compiler's tables\n", 2); return F77_RC_TERM; }
    f77_scan_units();
    lx_inc_record = 0;               /* INCLUDE's pieces are known; a second reading repeats them */
    if (f77_nunit == 0) { fdputs("f77: empty source\n", 2); return F77_RC_TERM; }
#ifdef F77_TARGET_S370
    if (f77_nerr == 0) f77_check_persistence();
    if (lx_spool) { fclose(lx_spool); lx_spool = 0; }
    if (!keepall) {
        FILE *again;
        again = f77_reopen_file();
        if (!again) { fdputs("f77: the source cannot be read again\n", 2); return F77_RC_TERM; }
        lx_keep = 0x7FFFFFFF;
        lx_start(again);
    }
#endif

    {
        int i;
        i = 0;
        while (i < f77_nunit) {
            f77_units[i].name = f77_uname[i];
            f77_units[i].nparams = 0;
            f77_units[i].is_varargs = 0;
            f77_units[i].unit = i;
            f77_units[i].body = NULL;
            f77_units[i].next = (i + 1 < f77_nunit) ? &f77_units[i + 1] : NULL;
            i = i + 1;
        }
    }
    f77_program.body = &f77_units[0];

    /* The output is opened before code generation: the emitter flushes
     * its buffer to it whenever the buffer fills (a full buffer used to
     * be a silent drop). */
#ifdef F77_TARGET_S370
#ifdef __MVS__
    fout = fopen(outname, "w");
#else
    fout = fopen(outname, "wb");
#endif
    if (!fout) {
        fdputs("f77: cannot open output\n", 2);
        return F77_RC_TERM;
    }
    cg_fp = fout;
    cg_outpath = outname;
    gen_program(&f77_program);
    cg_flush();
    if (fclose(fout) != 0) {
        fdputs("f77: the output could not be written\n", 2);
        return F77_RC_TERM;
    }
#else
    fd = open(argv[2], O_WRONLY | O_CREAT | O_TRUNC | O_BINARY, 0644);
    if (fd < 0) {
        fdputs("f77: cannot open output\n", 2);
        return F77_RC_TERM;
    }
    cg_fd = fd;
    cg_outpath = argv[2];
    gen_program(&f77_program);
    cg_flush();
    close(fd);
#endif

    if (getenv("HIR_PAIR_STATS")) {
        int z;
        fdputs("split doubles: ", 2);
        fdputuint(2, (unsigned int)f77_split_count);
        fdputc(10, 2);
        {
            int q;
            fdputs("pair-claim [partner,nonode,placed,nofree,HIT]=", 2);
            q = 0;
            while (q < 5) { fdputuint(2, (unsigned)ra_pc_dbg[q]); fdputc(' ', 2); q = q + 1; }
            fdputc(10, 2);
        }
        fdputs("pair-pref hits: ", 2);
        fdputuint(2, (unsigned int)ra_stat_pair_pref);
        fdputs("  addi[calls,spill,nouse,valuse,mismatch,HIT]=", 2);
        z = 0;
        while (z < 6) { fdputuint(2, (unsigned)hcg_dbg_addi[z]); fdputc(' ', 2); z = z + 1; }
        fdputc(10, 2);
    }
    if (f77_nerr > 0) {
        fdputs("f77: compilation failed\n", 2);
#ifdef F77_TARGET_S370
#ifndef __MVS__
        remove(outname);    /* on MVS the DD's data set is the job's */
#endif
#else
        unlink(argv[2]);
#endif
        f77_lst_close();
        return f77_rc;
    }
    f77_lst_close();
    return f77_rc;              /* 0, or 4 with warnings */
}
