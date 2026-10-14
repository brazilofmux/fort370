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
#ifndef __MVS__
#include <unistd.h>
#include <fcntl.h>
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
static int f77_nerr;      /* errors so far; a unit with any is not given to the back end */
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
#include "hir_codegen_s370.h"
#else
#include "hir_burg.h"
#include "hir_regalloc.h"
#include "f77_parse.h"
#include "hir_codegen.h"
#endif

static void f77_error(char *msg) {
    fdputs("f77: line ", 2);
    fdputuint(2, (unsigned int)lx_stmt_line);
    fdputs(": ", 2);
    fdputs(msg, 2);
    fdputc('\n', 2);
    fdputs("  in: ", 2);
    fdputs(lx_stmt, 2);
    fdputc('\n', 2);
    f77_nerr = f77_nerr + 1;
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

    f77_nunit = 0;
    f77_nent = 0;
    f77_nfamd = 0;
    { int z; z = 0; while (z < F77_MAX_UNIT) { f77_uentry_parent[z] = -1; z = z + 1; } }
    f77_nformat = 0;
    f77_nasg = 0;
    f77_nesc = 0;
    { int z; z = 0; while (z < F77_MAX_UNIT) { f77_ustmts[z] = 0; f77_unosplice[z] = 0; z = z + 1; } }
    started = 0;
    ended = 0;
    mains = 0;
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
            if (f77_nunit >= F77_MAX_UNIT) { f77_error("too many program units"); return; }
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
                f77_starts("CHARACTER"))
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
            if (f77_nunit >= F77_MAX_UNIT) { f77_error("too many program units"); return; }
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
            if (f77_nunit >= F77_MAX_UNIT) { f77_error("too many program units"); return; }
            if (f77_nunit > 0) f77_unit_done(f77_nunit - 1, pos);
            f77_upos[f77_nunit] = pos;
            f77_uline[f77_nunit] = line;
            f77_unit_name(f77_nunit);
            f77_collect_dummies(f77_starts("SUBROUTINE") ? 10 : f77_function_skip(), f77_nunit);
            if (rty >= 0) {
                f77_ukind[f77_nunit] = F77_UNIT_FUNC;
                /* Bare FUNCTION uses the I-N rule; a later type
                 * statement of the function name overrides it. */
                if (f77_starts("FUNCTION"))
                    f77_urty[f77_nunit] = f77_implicit_ty(f77_uname[f77_nunit]);
                else
                    f77_urty[f77_nunit] = rty;
                f77_urlog[f77_nunit] = f77_hdr_log;
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
            clen = 1;
            lg = 0;
            if (f77_starts("INTEGER")) { ty = TY_INT; skip = 7; }
            else if (f77_starts("LOGICAL")) { ty = TY_INT; skip = 7; lg = 1; }
            else if (f77_starts("DOUBLEPRECISION")) { ty = TY_DOUBLE; skip = 15; }
            else if (f77_starts("REAL")) { ty = TY_FLOAT; skip = 4; }
            else if (f77_starts("CHARACTER")) { ty = TY_CHAR; skip = 9; }
            else if (f77_starts("COMPLEX")) { ty = TY_CPLX; skip = 7; }
            if (ty >= 0) {
                f77_scan_from(skip);
                if (lx_t == T_STAR) {
                    f77_tok();
                    if (ty == TY_CHAR) clen = f77_char_len();
                    else if (lx_t == T_ICON) {
                        if (lex_ival == 8 && ty == TY_FLOAT) ty = TY_DOUBLE;
                        f77_tok();
                    }
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
                        f77_tok();
                        if (lx_t == T_ICON) {
                            if (is_fn) {
                                if (lex_ival == 8 && ty == TY_FLOAT)
                                    f77_urty[f77_nunit - 1] = TY_DOUBLE;
                                else
                                    f77_urty[f77_nunit - 1] = ty;
                            }
                            f77_tok();
                        }
                    } else if (is_fn) {
                        f77_urty[f77_nunit - 1] = ty;
                        f77_urlog[f77_nunit - 1] = lg;
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
        pos = lx_pos;
        line = lx_line;
    }

    if (f77_nunit > 0) f77_unit_done(f77_nunit - 1, lx_pos);
    if (!f77_keepall) lx_keep = 0x7FFFFFFF;

    /* Each ENTRY becomes a unit of its own, after the ordinary ones. */
    {
        int q;
        for (q = 0; q < f77_nent; q++) {
            int par;
            if (f77_nunit >= F77_MAX_UNIT) { f77_error("too many program units"); return; }
            par = f77_ent_parent[q];
            f77_upos[f77_nunit] = f77_ent_pos[q];
            f77_uline[f77_nunit] = f77_ent_line[q];
            f77_ukind[f77_nunit] = f77_ukind[par];
            f77_urty[f77_nunit] = (f77_ukind[par] == F77_UNIT_FUNC) ? f77_ent_ty[q] : TY_INT;
            f77_urlog[f77_nunit] = 0;
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
}

/* Phase 2: the backend asks for one unit's HIR. */
static void hl_func(Node *fn) {
    int b_entry;
    int u;

    u = fn->unit;
    hl_cur_fn_dbg = fn->name;
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
    f77_label_check();

    if (f77_cur_blk_live) f77_emit_return();

    /* The HIR is complete: retract the read-only-load assertion for
     * every dummy this unit turned out to store (see f77_ldro_note). */
    f77_ldro_finalize();

    fn->locals_size = f77_frame;
}

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
    if (lx_fp && lx_fp != stdin) fclose(lx_fp);
#ifdef __MVS__
    return fopen("dd:SYSUT1", "r");
#else
    return fopen(f77_inname, "rb");
#endif
}

int main(int argc, char **argv) {
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
#ifdef __MVS__
    /* SYSIN is libc370's stdin, already open: reading it there rather
     * than opening dd:SYSIN a second time lets it be DD * (a second open
     * of instream data is the one JES2 refuses, S013-C0).  It is read
     * once, so the scan copies it to the work data set SYSUT1 for the
     * second reading; without a SYSUT1 the whole source is kept in
     * storage instead. */
    inname = argc > 1 ? argv[1] : "dd:SYSIN";
    outname = argc > 2 ? argv[2] : "dd:SYSPUNCH";
    fin = argc > 1 ? fopen(inname, "r") : stdin;
    lx_spool = fopen("dd:SYSUT1", "w");
    if (!lx_spool) keepall = 1;
#else
    if (argc < 3) {
        fdputs("usage: f77 source.f output.asm\n", 2);
        return 1;
    }
    inname = argv[1];
    outname = argv[2];
    fin = fopen(inname, "rb");
#endif
    if (!fin) {
        fdputs("f77: cannot open ", 2);
        fdputs(inname, 2);
        fdputc('\n', 2);
        return 1;
    }
    f77_inname = inname;
    f77_keepall = keepall;
    lx_reopen = keepall ? 0 : f77_reopen_file;
    lx_keep = keepall ? 0 : 0x7FFFFFFF;
    lx_start(fin);
#else
    static char src[1 << 18];   /* the source file, whole */
    int n;
    int fd;

    if (argc < 3) {
        fdputs("usage: f77 source.f output.s\n", 2);
        return 1;
    }

    fd = open(argv[1], O_RDONLY | O_BINARY);
    if (fd < 0) {
        fdputs("f77: cannot open ", 2);
        fdputs(argv[1], 2);
        fdputc('\n', 2);
        return 1;
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

    f77_scan_units();
    if (f77_nunit == 0) { fdputs("f77: empty source\n", 2); return 1; }
#ifdef F77_TARGET_S370
    if (lx_spool) { fclose(lx_spool); lx_spool = 0; }
    if (!keepall) {
        FILE *again;
        again = f77_reopen_file();
        if (!again) { fdputs("f77: the source cannot be read again\n", 2); return 1; }
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
        return 1;
    }
    cg_fp = fout;
    cg_outpath = outname;
    gen_program(&f77_program);
    cg_flush();
    if (fclose(fout) != 0) {
        fdputs("f77: the output could not be written\n", 2);
        return 1;
    }
#else
    fd = open(argv[2], O_WRONLY | O_CREAT | O_TRUNC | O_BINARY, 0644);
    if (fd < 0) {
        fdputs("f77: cannot open output\n", 2);
        return 1;
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
        return 1;
    }
    return 0;
}
