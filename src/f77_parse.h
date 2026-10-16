/* COPIED from slow32-public fortran/src/f77_parse.h at 2245be78 (2026-10-12).  See PROVENANCE.md. */
/* f77_parse.h -- recursive-descent Fortran 77 parser, lowering straight
 * to HIR as it goes.
 *
 * One pass, syntax-directed.  F77 requires declarations to precede
 * executable statements, so nothing needs a second look, and the copied
 * backend's SSA/optimizer does the work an AST would otherwise be built
 * to enable.  Control flow is handled with an explicit stack, and
 * forward GOTO targets work because HIR blocks can be created before
 * they are filled.
 *
 * STATEMENT CLASSIFICATION is the interesting part, and it cannot be
 * done by the lexer: F77 has no reserved words, so `IF` and `DO` are
 * legal variable names.  The rules implemented in f77_classify():
 *
 *   IF( ... )   -- match the balanced parens, then look at what follows:
 *                  THEN -> block IF, `=` -> assignment to the array
 *                  element IF(...), digits -> arithmetic IF, anything
 *                  else -> logical IF.
 *   DO          -- a DO statement needs a top-level `=` AND a top-level
 *                  `,` after it.  That is the whole difference between
 *                  `DO 20 I = 1, 10` (a loop) and `DO20I = 1.10` (an
 *                  assignment to the variable DO20I).
 *   otherwise   -- a top-level `=` means assignment; if there is none,
 *                  dispatch on a keyword prefix.
 */
#ifndef F77_PARSE_H
#define F77_PARSE_H

/* SLOW-32 is 32-bit, so addresses are plain ints. */
#define HL_ADDR_TY TY_INT

/* --- symbols -------------------------------------------------------- */

#define F77_MAX_SYM (4096 * F77_ROOM)  /* fort370: symbols in one unit, inlined callees' too */
#define F77_MAX_RANK 7                 /* the F77 limit */
static char f77_sname[F77_MAX_SYM][F77_MAX_NAME];
static short  f77_sty[F77_MAX_SYM];      /* TY_INT / TY_FLOAT / TY_DOUBLE */
static int  f77_sval[F77_MAX_SYM];     /* HIR alloca */
static signed char  f77_srank[F77_MAX_SYM];    /* 0 = scalar */
/* fort370: the bounds live in rows of their own, one per array, and a
 * symbol points at its row (f77_slo[s][k] reads as before).  Every
 * scalar shares row 0, whose bounds nothing writes (f77_parse_dims
 * gives a symbol its own row before it writes any); 112 bytes of rank-7
 * bounds per scalar would be most of the table. */
#define F77_MAX_ARR (1024 * F77_ROOM)  /* arrays in one unit */
static int  f77_dlo[F77_MAX_ARR][F77_MAX_RANK];
static int  f77_dext[F77_MAX_ARR][F77_MAX_RANK];
static int  f77_dextsym[F77_MAX_ARR][F77_MAX_RANK];
static int  f77_dlov[F77_MAX_ARR][F77_MAX_RANK];
static int  f77_narr;
static int *f77_slo[F77_MAX_SYM];      /* lower bound per dim */
static int *f77_sext[F77_MAX_SYM];     /* constant extent */
/* Adjustable dimensions: DOUBLE PRECISION A(LDA,1) inside a subprogram,
 * where LDA is itself a dummy argument.  LINPACK is built on this.  When
 * f77_sextv[s][k] >= 0 the extent is that HIR value (computed in the
 * declaration part) and f77_sext[s][k] is meaningless. */
static int *f77_sextsym[F77_MAX_SYM];  /* now: HIR value of the extent, or -1 */
static int *f77_slov[F77_MAX_SYM];     /* HIR value of the lower bound, or -1 */
#define f77_sextv f77_sextsym
/* Row r's bounds, fresh: extents and lower bounds unknown (-1). */
static void f77_dim_row(int s, int r) {
    int d;
    f77_slo[s] = f77_dlo[r];
    f77_sext[s] = f77_dext[r];
    f77_sextsym[s] = f77_dextsym[r];
    f77_slov[s] = f77_dlov[r];
    for (d = 0; d < F77_MAX_RANK; d++) {
        f77_dlo[r][d] = 0;
        f77_dext[r][d] = 0;
        f77_dextsym[r][d] = -1;
        f77_dlov[r][d] = -1;
    }
}
static int f77_adjustable(int s) {
    int k;
    for (k = 0; k < f77_srank[s]; k++)
        if (f77_sextv[s][k] >= 0 || f77_slov[s][k] >= 0) return 1;
    return 0;
}
static int  f77_nsym;

/* fort370: names hashed, so a unit of thousands of symbols does not look
 * each one up by scanning them all.  A chain holds every symbol of the
 * name's bucket, newest first; f77_sym_at answers what the scan from
 * f77_scope_base answered -- the oldest match at or above the base. */
#define F77_SHASH 1024
static int f77_shead[F77_SHASH];       /* symbol + 1, 0 = empty */
static int f77_snext[F77_MAX_SYM];     /* symbol + 1, 0 = end */
static int f77_shash(char *nm) {
    unsigned h;
    h = 0;
    while (*nm) { h = h * 31 + (unsigned char)*nm; nm++; }
    return (int)(h % F77_SHASH);
}
static void f77_sym_hash(int s) {
    int h;
    h = f77_shash(f77_sname[s]);
    f77_snext[s] = f77_shead[h];
    f77_shead[h] = s + 1;
}
static void f77_sym_reset(void) {
    memset(f77_shead, 0, sizeof f77_shead);
    f77_nsym = 0;
    f77_narr = 1;                      /* row 0 is every scalar's */
}
static int f77_sym_at(char *nm, int base) {
    int i;
    int found;
    found = -1;
    i = f77_shead[f77_shash(nm)];
    while (i) {
        if (i - 1 >= base && i - 1 < f77_nsym && strcmp(f77_sname[i - 1], nm) == 0) found = i - 1;
        i = f77_snext[i - 1];
    }
    return found;
}

/* Lookups start here, not at 0.  Inlining a subprogram pushes a fresh
 * scope so the callee's locals cannot resolve to identically-named
 * caller locals -- without this, a callee's `I` would silently become
 * the caller's `I`. */
static int  f77_scope_base;
static int  f77_label_base;

/* Is `s` a dummy argument?  Dummy arguments are passed BY REFERENCE in
 * Fortran, so the symbol's value is already an address and there is no
 * alloca behind it -- everything downstream works off an address, so
 * loads, stores and subscripting need no special case. */
static signed char  f77_sarg[F77_MAX_SYM];

/* Hi-word slot for a scalar DOUBLE local, or -1.
 *
 * A double is an 8-byte alloca whose hi word is normally reached with
 * `ADDI base,4` at each use.  That ADDI is a use of the alloca which is
 * neither a LOAD nor a STORE, and every mem2reg scan reads such a use
 * as address-taken -- so NO double was ever promoted to a register, and
 * every one lived in memory.  A routine with one double and one integer
 * emitted twelve frame accesses.
 *
 * Giving the hi word its OWN alloca, emitted beside the lo one, means
 * neither slot ever has its address taken: each has only direct word
 * LOAD/STOREs, which is exactly what the promoter accepts.  The hi slot
 * keeps the frame offset the ADDI would have addressed, so the layout
 * is unchanged. */
static int  f77_shi[F77_MAX_SYM];
static int  f77_split_count;
static int  f77_split_on = -1;

/* Static storage flags: member of a COMMON block / named in SAVE. */
static signed char  f77_scom[F77_MAX_SYM];
static signed char  f77_ssaved[F77_MAX_SYM];

/* Read-only dummy-load tracking, for LICM's h_ld_ro assertion.  F77
 * 15.9.3.6: while a subprogram executes, its scalar dummies cannot
 * legally be modified through any other name -- so a load of one is
 * loop-invariant even across stores and calls, UNLESS this unit
 * itself stores to it (assignment, DO variable, READ target, or its
 * address passed onward).  One-pass compilation means the store may
 * be seen after the load, so loads are recorded and the flag is
 * RETRACTED at unit end for every symbol that got stored. */
static signed char  f77_sstored[F77_MAX_SYM];
#define F77_MAX_LDRO 4096
static int  f77_ldro_inst[F77_MAX_LDRO];
static int  f77_ldro_sym[F77_MAX_LDRO];
static int  f77_ldro_n;

static void f77_ldro_note(int inst, int s) {
    if (inst < 0 || f77_ldro_n >= F77_MAX_LDRO) return;
    h_ld_ro[inst] = 1;
    f77_ldro_inst[f77_ldro_n] = inst;
    f77_ldro_sym[f77_ldro_n] = s;
    f77_ldro_n = f77_ldro_n + 1;
}

static int f77_unit_entries;    /* the unit being compiled is or has an ENTRY (set by hl_func) */
static int f77_ldro_local_ok(int s);
static void f77_ldro_finalize(void) {
    int i;
    for (i = 0; i < f77_ldro_n; i++) {
        if (f77_sstored[f77_ldro_sym[i]] ||
            (!f77_sarg[f77_ldro_sym[i]] && !f77_ldro_local_ok(f77_ldro_sym[i])))
            h_ld_ro[f77_ldro_inst[i]] = 0;
    }
}
static int  f77_sgidx[F77_MAX_SYM];    /* ps_g* index once bound static */
static int  f77_sgoff[F77_MAX_SYM];    /* byte offset inside that object */

/* --- CHARACTER ---------------------------------------------------------
 *
 * A CHARACTER*n entity is n bytes of storage and nothing else: no
 * descriptor, no terminator.  A character-valued EXPRESSION is an
 * ADDRESS (the HIR value f77_primary returns) plus a LENGTH, carried
 * beside ex_ty in ex_len (an HIR int value) and ex_clen (the constant
 * when it is known at compile time, else -1).  Lengths are constant
 * everywhere except an assumed-length dummy, CHARACTER*(*), whose
 * length arrives as a hidden INTEGER argument appended after the
 * regular ones -- one per CHARACTER actual, in order, the gfortran
 * convention -- and a CHARACTER FUNCTION, which takes its result
 * buffer and length as two hidden leading arguments. */
static int  f77_slen[F77_MAX_SYM];     /* length in bytes, -1 = assumed (*) */
static int  f77_slenv[F77_MAX_SYM];    /* HIR value of the length when -1 */
static int  f77_spstr[F77_MAX_SYM];    /* CHARACTER PARAMETER: string index */
static signed char  f77_sexternal[F77_MAX_SYM]; /* named in EXTERNAL */
static signed char  f77_sintrinsic[F77_MAX_SYM]; /* named in INTRINSIC */
/* LOGICAL shares TY_INT with INTEGER in the backend; what tells them
 * apart for list-directed output (T/F vs a number) is this flag on the
 * symbol, carried through expressions in ex_log. */
static signed char  f77_slog[F77_MAX_SYM];
/* fort370: indexed by letter - 'A', which in EBCDIC runs to 40 ('A' to
 * 'Z' has gaps there), so the tables span 'A'..'Z' in the execution
 * character set: 26 on a host, 41 on MVS. */
#define F77_IMP_N ('Z' - 'A' + 1)
static int  f77_imp_log[F77_IMP_N];
static int  ex_log;
static int  f77_decl_log;              /* the type statement being parsed is LOGICAL */
static int  f77_imp_len[F77_IMP_N];           /* IMPLICIT CHARACTER*n per letter */
static int  ex_len;
static int  ex_clen;
static int  f77_act_len;               /* length of the last f77_actual_addr, or -1 */

/* The unit's dummies in order (also the copy-in list), the count of
 * its incoming words, and the length of the last CHARACTER READ
 * target; declared here because the static layout reads them. */
#define F77_MAX_COPYIN 32
static int f77_ci_sym[F77_MAX_COPYIN];   /* the dummy's symbol */
static int f77_ci_addr[F77_MAX_COPYIN];  /* its original address value */
static int f77_ci_n;
static int f77_unit_nparams;
static int f77_rd_len;
static int f77_inline_depth;
static void f77_assign_params(int n);

/* COMPLEX: a parser-level type id (never the type of an HIR
 * instruction).  A COMPLEX value is two REAL words, re in the value and
 * im in ex_hi -- the channel DOUBLE PRECISION already uses for its hi
 * word -- so every pair site (split frame slots, load/store, return in
 * r1/r2, CALLHI) carries it with a type test added. */
#define TY_CPLX 9
/* fort370: COMPLEX*16 (DOUBLE COMPLEX), IBM's: two DOUBLE PRECISION
 * values, the same pair with double halves -- only where a double is
 * one HIR value (F77_NATIVE_F64). */
#define TY_DCPLX 10
static int f77_iscx(int ty) { return ty == TY_CPLX || ty == TY_DCPLX; }
/* a complex type's part, and a pair's word, its offset and an alloca's type */
static int f77_cxpart(int ty) { return ty == TY_DCPLX ? TY_DOUBLE : TY_FLOAT; }
static int f77_pairw(int ty) { return f77_iscx(ty) ? f77_cxpart(ty) : TY_INT; }
static int f77_pairoff(int ty) { return ty == TY_DCPLX ? 8 : 4; }
static int f77_slotty(int ty) { return f77_iscx(ty) ? f77_cxpart(ty) : ty; }
/* A length after a type, *n: REAL*8 is DOUBLE PRECISION, COMPLEX*16
 * COMPLEX*16, and *4 and *8 take them back; any other is the type
 * itself (INTEGER*2 and LOGICAL*1 get a fullword still).  The unit scan
 * in f77.c asks quietly (`say` 0); the statement itself reports. */
static int f77_lenty(int ty, int n, int say) {
    if ((ty == TY_FLOAT || ty == TY_DOUBLE) && (n == 4 || n == 8)) return n == 8 ? TY_DOUBLE : TY_FLOAT;
#ifdef F77_NATIVE_F64
    if (f77_iscx(ty) && (n == 8 || n == 16)) return n == 16 ? TY_DCPLX : TY_CPLX;
#else
    if (ty == TY_CPLX && n == 16 && say) f77_error("COMPLEX*16 needs a target with native DOUBLE PRECISION");
#endif
    return ty;
}

/* Element size: a CHARACTER element is its length. */
static int f77_esize(int s) {
    if (f77_sty[s] == TY_CHAR) return f77_slen[s] > 0 ? f77_slen[s] : 1;
    if (f77_sty[s] == TY_CPLX) return 8;
    if (f77_sty[s] == TY_DCPLX) return 16;
    return ty_size(f77_sty[s]);
}
static int f77_tysize(int ty) { return ty == TY_CPLX ? 8 : ty == TY_DCPLX ? 16 : ty_size(ty); }
#ifdef F77_NATIVE_F64
/* F77_NATIVE_F64 (the S/370 target): a DOUBLE PRECISION value is one
 * HIR value of type TY_DOUBLE, operated on by HI_FADD and friends, as
 * the C front end does under S12CC_NATIVE_F64.  The hi word that the
 * SLOW-32 pair convention threads through the parser (ex_hi, *hi) is
 * then always -1 for doubles; COMPLEX is still a pair of REALs. */
static int f77_ispair(int ty) { return f77_iscx(ty); }
#else
static int f77_ispair(int ty) { return ty == TY_DOUBLE || ty == TY_CPLX; }
#endif

/* --- EQUIVALENCE -------------------------------------------------------
 *
 * Each statement's groups are flattened into pairs: addr(a)+oa ==
 * addr(b)+ob, with the offsets in bytes from constant subscripts (and,
 * later, substrings).  Layout resolves them at the close of the
 * declaration part with a union-find that carries offsets, then either
 * hangs the group on the COMMON block one of its members belongs to or
 * gives it a static object of its own -- storage association means
 * static storage, the same trade SAVE makes. */
#define F77_MAX_EQ 256
static int f77_eq_sa[F77_MAX_EQ];
static int f77_eq_oa[F77_MAX_EQ];
static int f77_eq_sb[F77_MAX_EQ];
static int f77_eq_ob[F77_MAX_EQ];
static int f77_eq_n;
static int f77_eq_parent[F77_MAX_SYM];   /* union-find; -1 = not involved */
static int f77_eq_delta[F77_MAX_SYM];    /* addr(s) = addr(parent) + delta */

/* PARAMETER named constants: no storage, value folded at parse time.
 * The value is kept in both domains and converted per the symbol's
 * type at each use. */
static signed char    f77_sparam[F77_MAX_SYM];
static int    f77_spival[F77_MAX_SYM];
static double f77_spdval[F77_MAX_SYM];
static double f77_spdval2[F77_MAX_SYM];  /* COMPLEX PARAMETER: imaginary part */
static char  *f77_sptext[F77_MAX_SYM];   /* fort370: the value's decimal text (f77_cx_t), or 0 */
static char  *f77_sptext2[F77_MAX_SYM];

/* Explicitly typed by a type declaration (or a typed FUNCTION
 * header): what IMPLICIT NONE checks, and what an IMPLICIT statement
 * must not retype. */
static signed char    f77_styped[F77_MAX_SYM];

/* Per-unit implicit typing map, letter -> type.  bind_unit resets it
 * to the default rule (I-N INTEGER, the rest REAL) and the IMPLICIT
 * statement rewrites ranges; before the first bind (the phase-1 unit
 * scan) the default rule applies directly. */
static int f77_imp_map[F77_IMP_N];
static int f77_imp_ready;
static int f77_imp_none;

/* Defined (tentatively) again beside their own logic further down. */
static int f77_decls_open;

static int f77_implicit_ty(char *nm) {
    int c;
    c = nm[0];
    if (f77_imp_ready && c >= 'A' && c <= 'Z') return f77_imp_map[c - 'A'];
    if (c >= 'I' && c <= 'N') return TY_INT;
    return TY_FLOAT;
}

static int f77_frame;   /* bytes of locals allocated so far */

/* --- statement functions ---------------------------------------------
 *
 * NAME(d1, d2, ...) = expr in the declaration part.  The definition is
 * kept as TEXT (with its blank-boundary flags), and every reference
 * re-lexes it: the actuals are evaluated into fresh temporaries, each
 * dummy name is bound to its temporary for the duration (f77_sym
 * consults the bindings first), and the expression is parsed in place
 * with the scanner pointed at the saved text -- the same checkpoint and
 * restore the inliner uses, minus the scope push, because every other
 * name in the expression must still resolve to the unit's variables. */
#define F77_MAX_STF      64
#define F77_MAX_STF_ARGS 16
#define F77_STF_POOL     16384
static int  f77_stf_sym[F77_MAX_STF];
static int  f77_stf_nargs[F77_MAX_STF];
static char f77_stf_arg[F77_MAX_STF][F77_MAX_STF_ARGS][F77_MAX_NAME];
static int  f77_stf_argty[F77_MAX_STF][F77_MAX_STF_ARGS];
static int  f77_stf_text[F77_MAX_STF];
static int  f77_stf_len[F77_MAX_STF];
static int  f77_stf_n;
static char f77_stf_pool[F77_STF_POOL];
static unsigned char f77_stf_pbrk[F77_STF_POOL];
static int  f77_stf_pool_n;
#define F77_MAX_STFB 64
static char f77_stfb_name[F77_MAX_STFB][F77_MAX_NAME];
static int  f77_stfb_sym[F77_MAX_STFB];
static int  f77_stfb_n;

/* Names whose ADDRESS leaves the unit -- READ list items and actual
 * arguments -- collected per unit in phase 1 (over-approximated from
 * the text: any identifier standing alone inside the parentheses that
 * follow an identifier).  A DOUBLE PRECISION or COMPLEX scalar on this
 * list keeps its two words in ONE frame slot: the split lo/hi slots
 * are promotable only while nothing writes them behind the compiler's
 * back, and the dead-ADDI marker that was meant to say "address taken"
 * is removed by DCE before the next promotion pass runs -- READ into a
 * split double returned the value from before the READ. */
#define F77_MAX_ESC (1024 * F77_ROOM)
static int  f77_cur_unit;              /* defined with the FORMAT tables */
static char f77_esc_name[F77_MAX_ESC][F77_MAX_NAME];
static int  f77_esc_unit[F77_MAX_ESC];
static int  f77_nesc;

static void f77_esc_add(int unit, char *nm, int len) {
    int i;
    if (len <= 0 || len >= F77_MAX_NAME || f77_nesc >= F77_MAX_ESC) return;
    for (i = 0; i < f77_nesc; i++)
        if (f77_esc_unit[i] == unit && strncmp(f77_esc_name[i], nm, len) == 0 &&
            f77_esc_name[i][len] == 0) return;
    memcpy(f77_esc_name[f77_nesc], nm, len);
    f77_esc_name[f77_nesc][len] = 0;
    f77_esc_unit[f77_nesc] = unit;
    f77_nesc = f77_nesc + 1;
}

static int f77_name_escapes(int unit, char *nm) {
    int i;
    for (i = 0; i < f77_nesc; i++)
        if (f77_esc_unit[i] == unit && strcmp(f77_esc_name[i], nm) == 0) return 1;
    return 0;
}

/* Phase-1 scan of one assembled statement for escaping names. */
static void f77_esc_scan(int unit) {
    int i;
    int j;
    int k;
    int depth;
    /* READ list items: after the control list, or after `fmt,` */
    if (strncmp(lx_stmt, "READ", 4) == 0) {
        i = 4;
        if (i < lx_stmt_len && lx_stmt[i] == '(') {
            depth = 0;
            while (i < lx_stmt_len) {
                if (lx_stmt[i] == '(') depth = depth + 1;
                else if (lx_stmt[i] == ')') { depth = depth - 1; if (depth == 0) { i = i + 1; break; } }
                i = i + 1;
            }
        } else {
            while (i < lx_stmt_len && lx_stmt[i] != ',') i = i + 1;
            if (i < lx_stmt_len) i = i + 1;
        }
        /* items at depth 0, separated by commas */
        while (i < lx_stmt_len) {
            j = i;
            if (lx_isalpha(lx_stmt[j])) {
                while (j < lx_stmt_len && (lx_isalpha(lx_stmt[j]) || lx_isdigit(lx_stmt[j]))) j = j + 1;
                if (j >= lx_stmt_len || lx_stmt[j] == ',') f77_esc_add(unit, lx_stmt + i, j - i);
            }
            /* skip to the next top-level comma */
            depth = 0;
            while (i < lx_stmt_len) {
                if (lx_stmt[i] == '\'') { i = i + 1; while (i < lx_stmt_len && lx_stmt[i] != '\'') i = i + 1; }
                else if (lx_stmt[i] == '(') depth = depth + 1;
                else if (lx_stmt[i] == ')') depth = depth - 1;
                else if (lx_stmt[i] == ',' && depth == 0) break;
                i = i + 1;
            }
            if (i < lx_stmt_len) i = i + 1;
        }
    }
    /* IDENT( item, item ) anywhere: a call or a subscript */
    i = 0;
    while (i < lx_stmt_len) {
        if (lx_stmt[i] == '\'') { i = i + 1; while (i < lx_stmt_len && lx_stmt[i] != '\'') i = i + 1; i = i + 1; continue; }
        if (lx_stmt[i] == '(' && i > 0 && (lx_isalpha(lx_stmt[i - 1]) || lx_isdigit(lx_stmt[i - 1]))) {
            j = i + 1;
            for (;;) {
                k = j;
                if (k < lx_stmt_len && lx_isalpha(lx_stmt[k])) {
                    while (k < lx_stmt_len && (lx_isalpha(lx_stmt[k]) || lx_isdigit(lx_stmt[k]))) k = k + 1;
                    if (k < lx_stmt_len && (lx_stmt[k] == ',' || lx_stmt[k] == ')'))
                        f77_esc_add(unit, lx_stmt + j, k - j);
                }
                /* advance to the next top-level comma or the close */
                depth = 0;
                while (j < lx_stmt_len) {
                    if (lx_stmt[j] == '\'') { j = j + 1; while (j < lx_stmt_len && lx_stmt[j] != '\'') j = j + 1; }
                    else if (lx_stmt[j] == '(') depth = depth + 1;
                    else if (lx_stmt[j] == ')') { if (depth == 0) break; depth = depth - 1; }
                    else if (lx_stmt[j] == ',' && depth == 0) break;
                    j = j + 1;
                }
                if (j >= lx_stmt_len || lx_stmt[j] == ')') break;
                j = j + 1;
            }
        }
        i = i + 1;
    }
}

/* ASSIGN labels, collected per unit in phase 1 so an assigned GOTO
 * without a label list knows its candidates. */
#define F77_MAX_ASG 256
static int f77_asg_lab[F77_MAX_ASG];
static int f77_asg_unit[F77_MAX_ASG];
static int f77_nasg;

static int f77_sym(char *nm) {
    int i;
    i = f77_stfb_n;
    while (i > 0) {
        i = i - 1;
        if (strcmp(f77_stfb_name[i], nm) == 0) return f77_stfb_sym[i];
    }
    i = f77_sym_at(nm, f77_scope_base);
    if (i >= 0) return i;
    if (f77_nsym >= F77_MAX_SYM) { f77_error("too many symbols"); return 0; }
    if (f77_imp_none && !f77_decls_open) {
        /* A name first seen in executable code has no declaration. */
        static char msg[F77_MAX_NAME + 40];
        strcpy(msg, nm);
        strcat(msg, " is not declared (IMPLICIT NONE)");
        f77_error(msg);
    }
    strcpy(f77_sname[f77_nsym], nm);
    f77_sym_hash(f77_nsym);
    f77_sty[f77_nsym] = f77_implicit_ty(nm);
    f77_srank[f77_nsym] = 0;
    f77_sarg[f77_nsym] = 0;
    f77_shi[f77_nsym] = -1;
    f77_scom[f77_nsym] = 0;
    f77_ssaved[f77_nsym] = 0;
    f77_sgidx[f77_nsym] = -1;
    f77_sgoff[f77_nsym] = 0;
    f77_slen[f77_nsym] = 1;
    f77_slenv[f77_nsym] = -1;
    f77_spstr[f77_nsym] = -1;
    f77_sexternal[f77_nsym] = 0;
    f77_sintrinsic[f77_nsym] = 0;
    f77_slog[f77_nsym] = 0;
    if (f77_imp_ready && nm[0] >= 'A' && nm[0] <= 'Z') {
        if (f77_sty[f77_nsym] == TY_CHAR) f77_slen[f77_nsym] = f77_imp_len[nm[0] - 'A'];
        f77_slog[f77_nsym] = f77_imp_log[nm[0] - 'A'];
    }
    f77_sparam[f77_nsym] = 0;
    f77_styped[f77_nsym] = 0;
    f77_sstored[f77_nsym] = 0;
    f77_dim_row(f77_nsym, 0);
    /* An implicitly typed CHARACTER (IMPLICIT CHARACTER*14 (C)) has its
     * length now and gets all of it; a declaration re-issues the slot
     * anyway.  One byte here left CVCOMP*14 overlapping its
     * neighbours (FCVS FM301, test 18). */
    if (f77_sty[f77_nsym] == TY_CHAR && f77_slen[f77_nsym] > 1)
        f77_frame = f77_frame + ((f77_slen[f77_nsym] + 3) & ~3);
    else
        f77_frame = f77_frame + f77_tysize(f77_sty[f77_nsym]);
    f77_sval[f77_nsym] = hi_emit(HI_ALLOCA, f77_slotty(f77_sty[f77_nsym]), -1, -1,
                                 0 - f77_frame, NULL);
    hl_ainst[hl_nalloca] = f77_sval[f77_nsym];
    hl_aoff[hl_nalloca] = 0 - f77_frame;
    hl_nalloca = hl_nalloca + 1;
    f77_nsym = f77_nsym + 1;
    return f77_nsym - 1;
}

/* A fresh anonymous local of type `ty`: a statement-function actual.
 * Never looked up by name, so no scope or IMPLICIT NONE concerns. */
static void f77_realloc_sym(int s);
static int f77_sym_temp(int ty) {
    int s;
    if (f77_nsym >= F77_MAX_SYM) { f77_error("too many symbols"); return 0; }
    s = f77_nsym;
    strcpy(f77_sname[s], "%T");
    f77_sym_hash(s);
    f77_sty[s] = ty;
    f77_srank[s] = 0;
    f77_sarg[s] = 0;
    f77_shi[s] = -1;
    f77_scom[s] = 0;
    f77_ssaved[s] = 0;
    f77_sgidx[s] = -1;
    f77_sgoff[s] = 0;
    f77_sparam[s] = 0;
    f77_styped[s] = 1;
    f77_sstored[s] = 0;
    f77_slen[s] = 1;
    f77_slenv[s] = -1;
    f77_spstr[s] = -1;
    f77_sexternal[s] = 0;
    f77_sintrinsic[s] = 0;
    f77_slog[s] = 0;
    f77_dim_row(s, 0);
    f77_frame = f77_frame + f77_tysize(ty);
    f77_sval[s] = hi_emit(HI_ALLOCA, f77_slotty(ty), -1, -1, 0 - f77_frame, NULL);
    hl_ainst[hl_nalloca] = f77_sval[s];
    hl_aoff[hl_nalloca] = 0 - f77_frame;
    hl_nalloca = hl_nalloca + 1;
    f77_nsym = f77_nsym + 1;
    f77_realloc_sym(s);
    return s;
}

/* --- program units --------------------------------------------------- */

#define F77_UNIT_PROGRAM 0
#define F77_UNIT_SUBR    1
#define F77_UNIT_FUNC    2
#define F77_UNIT_BDATA   3     /* BLOCK DATA: declarations only */
#define F77_MAX_UNIT     (256 * F77_ROOM)   /* program units in one source file */

static char f77_uname[F77_MAX_UNIT][F77_MAX_NAME];
static int  f77_ukind[F77_MAX_UNIT];
static int  f77_upos[F77_MAX_UNIT];    /* source offset of the header */
static int  f77_uend[F77_MAX_UNIT];    /* fort370: source offset past the unit */
static char *f77_utext[F77_MAX_UNIT];  /* fort370: the unit's text, kept by the scan
    for the inliner (the source is streamed, f77_card.h), or 0 */
static int  f77_uline[F77_MAX_UNIT];
static int  f77_urty[F77_MAX_UNIT];    /* FUNCTION result type */
static int  f77_urlen[F77_MAX_UNIT];   /* CHARACTER FUNCTION result length, -1 = (*) */
static int  f77_urlog[F77_MAX_UNIT];   /* LOGICAL FUNCTION */
/* ENTRY: a secondary entry into a subprogram is compiled as a unit of
 * its own -- the parent's declarations, then the statements from the
 * ENTRY to END -- with f77_uentry_parent naming the parent (-1 for an
 * ordinary unit).  In a FUNCTION the entry names and the function
 * name all denote the one result, by aliasing. */
static int  f77_uentry_parent[F77_MAX_UNIT];
/* The dummies of every unit of an ENTRY family, collected in phase 1:
 * the shared statements name them all, so when one unit of the family
 * is compiled the dummies of the OTHER units are created as phantoms
 * -- by-reference symbols whose address is a frame slot -- so the
 * text compiles (to code that is never reached with them undefined)
 * instead of taking F(X) for a call to an external function F. */
#define F77_MAX_FAMD 512
static char f77_famd_name[F77_MAX_FAMD][F77_MAX_NAME];
static int  f77_famd_unit[F77_MAX_FAMD];
static int  f77_nfamd;
static int  f77_hdr_clen;              /* length seen by f77_function_kw_end; -2 = at f77_hdr_clen_off */
static int  f77_hdr_clen_off;
static int  f77_hdr_log;
static int  f77_hdr_len;              /* REAL*8 FUNCTION: the *n seen by f77_function_kw_end, else 0 */
static int  f77_nunit;

/* Create a symbol whose storage is a by-reference dummy argument: its
 * value is the ADDRESS of the actual, delivered in an argument
 * register.  Deliberately NOT registered in hl_ainst -- it is not an
 * alloca, and listing it there would offer it to mem2reg, which would
 * then rewrite loads through it into the address itself. */
static int f77_sym_param(char *nm, int index) {
    int s;
    if (f77_nsym >= F77_MAX_SYM) { f77_error("too many symbols"); return 0; }
    s = f77_nsym;
    strcpy(f77_sname[s], nm);
    f77_sym_hash(s);
    f77_sty[s] = f77_implicit_ty(nm);
    f77_srank[s] = 0;
    f77_sarg[s] = 1;
    f77_shi[s] = -1;
    f77_scom[s] = 0;
    f77_ssaved[s] = 0;
    f77_sgidx[s] = -1;
    f77_sgoff[s] = 0;
    f77_sparam[s] = 0;
    f77_styped[s] = 0;
    f77_sstored[s] = 0;
    f77_slen[s] = 1;
    f77_slenv[s] = -1;
    f77_spstr[s] = -1;
    f77_sexternal[s] = 0;
    f77_sintrinsic[s] = 0;
    f77_slog[s] = 0;
    if (f77_imp_ready && nm[0] >= 'A' && nm[0] <= 'Z') {
        if (f77_sty[s] == TY_CHAR) f77_slen[s] = f77_imp_len[nm[0] - 'A'];
        f77_slog[s] = f77_imp_log[nm[0] - 'A'];
    }
    f77_dim_row(s, 0);
    f77_sval[s] = hi_emit(HI_PARAM, HL_ADDR_TY, -1, -1, index, NULL);
    f77_nsym = f77_nsym + 1;
    return s;
}

/* Total element count of a shaped symbol. */
static int f77_sym_nelem(int s) {
    int n;
    int k;
    n = 1;
    k = 0;
    while (k < f77_srank[s]) { n = n * f77_sext[s][k]; k = k + 1; }
    return n;
}

/* (Re)allocate a symbol's frame slot once its type and shape are known.
 * Declarations arrive after the implicit-typing allocation, so the slot
 * is simply re-issued at the end of the frame; the earlier bytes are
 * abandoned, which costs a few words in exchange for not needing a
 * second pass over the declarations. */
static void f77_realloc_sym(int s) {
    int bytes;
    f77_shi[s] = -1;
    if (f77_sarg[s]) {
        /* By-reference dummy: storage belongs to the caller.  Only the
         * type and shape are recorded here.  A dummy the inliner bound
         * to an actual (f77_bind_actual) shares the caller's own
         * value -- often a local's alloca -- whose type must stay the
         * local's: retyped to an address, the SSA promoter saw its
         * double loads as type puns and left it in memory. */
        if (h_kind[f77_sval[s]] == HI_PARAM) h_ty[f77_sval[s]] = HL_ADDR_TY;
        return;
    }
    bytes = f77_esize(s) * f77_sym_nelem(s);
    bytes = (bytes + 3) & ~3;             /* keep the frame word-aligned */
    f77_frame = f77_frame + bytes;
    h_val[f77_sval[s]] = 0 - f77_frame;
    h_ty[f77_sval[s]] = f77_slotty(f77_sty[s]);
    hl_aoff[hl_nalloca - 1] = 0 - f77_frame;

    /* Scalar double or complex: give the hi word its own promotable slot. */
    if (f77_split_on < 0) f77_split_on = getenv("F77_NO_SPLIT") ? 0 : 1;
    if (f77_split_on && f77_srank[s] == 0 && f77_ispair(f77_sty[s]) &&
        !f77_name_escapes(f77_cur_unit, f77_sname[s])) {
        int wty;
        wty = f77_pairw(f77_sty[s]);
        h_ty[f77_sval[s]] = wty;                    /* lo word only */
        f77_shi[s] = hi_emit(HI_ALLOCA, wty, -1, -1,
                             0 - f77_frame + f77_pairoff(f77_sty[s]), NULL);
        if (hl_nalloca < HL_MAX_ALLOCA) {
            hl_ainst[hl_nalloca] = f77_shi[s];
            hl_aoff[hl_nalloca] = 0 - f77_frame + f77_pairoff(f77_sty[s]);
            hl_nalloca = hl_nalloca + 1;
        }
        f77_split_count = f77_split_count + 1;
    }
    {
        /* Keep the alloca registry entry pointing at this symbol's
         * instruction, wherever it landed. */
        int i;
        i = 0;
        while (i < hl_nalloca) {
            if (hl_ainst[i] == f77_sval[s]) hl_aoff[i] = 0 - f77_frame;
            i = i + 1;
        }
    }
}

/* --- statement labels ----------------------------------------------- */

#define F77_MAX_LABEL (4096 * F77_ROOM)   /* fort370: was 512 */
static int f77_lnum[F77_MAX_LABEL];
static int f77_lblk[F77_MAX_LABEL];
static signed char f77_ldef[F77_MAX_LABEL];   /* fort370: a statement carries it */
static int f77_nlabel;

/* Block for a label, created on first mention so forward GOTOs work. */
static int f77_label_blk(int n) {
    int i;
    i = f77_label_base;
    while (i < f77_nlabel) {
        if (f77_lnum[i] == n) return f77_lblk[i];
        i = i + 1;
    }
    if (f77_nlabel >= F77_MAX_LABEL) { f77_error("too many labels"); return 0; }
    f77_lnum[f77_nlabel] = n;
    f77_lblk[f77_nlabel] = hir_new_block();
    f77_ldef[f77_nlabel] = 0;
    f77_nlabel = f77_nlabel + 1;
    return f77_lblk[f77_nlabel - 1];
}

/* A statement carries label n: its block, marked defined.  (Its own
 * function: inline in f77_statement it pushed a branch there out of
 * cc370's addressability.) */
static int f77_label_def(int n) {
    int b;
    int q;
    b = f77_label_blk(n);
    for (q = f77_label_base; q < f77_nlabel; q++)
        if (f77_lnum[q] == n) f77_ldef[q] = 1;
    return b;
}

/* fort370: a label the unit refers to (GO TO, DO, IF, END=) but no
 * statement carries is an error: its block was made on first mention
 * and, left empty, fell through to whatever came next. */
static void f77_label_check(void) {
    int i;
    char msg[64];
    i = f77_label_base;
    while (i < f77_nlabel) {
        if (!f77_ldef[i]) {
            sprintf(msg, "statement label %d is referred to but never defined", f77_lnum[i]);
            f77_error(msg);
        }
        i = i + 1;
    }
}

/* --- FORMAT statements ----------------------------------------------- */

/* A FORMAT may appear anywhere in the unit, including after the WRITE
 * that names it, so phase 1 collects them all before any code is
 * emitted.  The format text is interned verbatim (parens included) and
 * handed to the runtime, which interprets it -- see runtime/libf77.c
 * for why this cannot be expanded inline. */
#define F77_MAX_FORMAT 256
static int f77_flabel[F77_MAX_FORMAT];
static int f77_funit[F77_MAX_FORMAT];   /* owning program unit */
static int f77_fstr[F77_MAX_FORMAT];    /* string-pool index */
static int f77_nformat;
static int f77_cur_unit;               /* set while compiling a unit */

static int f77_find_format(int label) {
    int i;
    i = 0;
    while (i < f77_nformat) {
        if (f77_flabel[i] == label && f77_funit[i] == f77_cur_unit)
            return f77_fstr[i];
        i = i + 1;
    }
    return -1;
}

/* --- control stack (DO loops and block IFs) ------------------------- */

#define F77_CTL_DO 1
#define F77_CTL_IF 2
#define F77_MAX_CTL 64

static int ctl_kind[F77_MAX_CTL];
static int ctl_label[F77_MAX_CTL];   /* DO: terminal statement label */
static int ctl_var[F77_MAX_CTL];     /* DO: symbol index */
static int ctl_step[F77_MAX_CTL];    /* DO: HIR value of the step */
static int ctl_stephi[F77_MAX_CTL];  /* DO: hi word of a DOUBLE step */
static int ctl_trip[F77_MAX_CTL];    /* DO: alloca holding the trip count */
static int ctl_test[F77_MAX_CTL];    /* DO: test block */
static int ctl_body[F77_MAX_CTL];    /* DO: body head, the rotated back edge */

static int ctl_exit[F77_MAX_CTL];    /* DO/IF: block after the construct */
static int ctl_else[F77_MAX_CTL];    /* IF: pending else block */
static int ctl_n;

/* Floor for f77_close_do.  A spliced callee raises it so that a label
 * in the callee can never close a DO belonging to the caller: DGEFA has
 * a statement labelled 70 and is inlined inside main's `DO 70`, and
 * without this floor parsing the callee's label popped the CALLER's
 * loop off the control stack. */
static int f77_ctl_base;

static void f77_ctl_reset(void) { ctl_n = 0; f77_ctl_base = 0; }

/* --- expression lowering -------------------------------------------- */

static int ex_ty;     /* type of the value most recently produced */
static int ex_hi;     /* its hi word, when ex_ty is TY_DOUBLE */

static int f77_expr(void);
static int f77_power(void);
static int f77_find_func(char *nm);
static int f77_actual_addr(void);
static int f77_urty_of(int u);
static int f77_load_at(int addr, int ty);
static int f77_load_sym(int s);
static void f77_store_sym_val(int s, int v, int vty, int vhi);
static void f77_store_at(int addr, int ty, int v, int vty, int vhi);
static int f77_can_inline(int u);
static int f77_inline_unit_body(int u, int *addrs, int nargs);
static int f77_find_unit(char *nm);
static int f77_stmt_is_declaration(int cls);
static void f77_emit_copyin(void);
static void f77_emit_copyout(void);

/* DOUBLE PRECISION on SLOW-32 is a PAIR of 32-bit values: the lo word is
 * the expression's value and the hi word travels beside it.  Operations
 * are emitted as calls to the __fp64_* helpers, every one of which the
 * backend recognises and replaces with inline hardware FP instructions
 * (hcg_fp64_kind / hcg_fp64_emit) -- so despite looking like libcalls
 * here, no call survives to the assembly.
 *
 * The hi word must be captured immediately after each subexpression:
 * the next emission overwrites the side channel. */

/* Is this lo/hi value pair the fp64 constant +2.0 (0x4000000000000000)? */
#ifdef F77_NATIVE_F64
/* Native doubles: the pseudo-call names become HIR floating-point ops.
 * Comparisons yield an int; sqrt is a real call the back end names. */
static int f77_libm_d1(char *name, int a, int ahi, int *rhi);
static int f77_fp64_call2(char *name, int alo, int ahi, int blo, int bhi, int *rhi) {
    int k;
    (void)ahi; (void)bhi;
    if (rhi) *rhi = -1;
    if (strcmp(name, "__fp64_add") == 0) k = HI_FADD;
    else if (strcmp(name, "__fp64_sub") == 0) k = HI_FSUB;
    else if (strcmp(name, "__fp64_mul") == 0) k = HI_FMUL;
    else if (strcmp(name, "__fp64_div") == 0) k = HI_FDIV;
    else if (strcmp(name, "__fp64_eq") == 0) return hi_emit(HI_FEQ, TY_INT, alo, blo, 0, NULL);
    else if (strcmp(name, "__fp64_lt") == 0) return hi_emit(HI_FLT, TY_INT, alo, blo, 0, NULL);
    else if (strcmp(name, "__fp64_le") == 0) return hi_emit(HI_FLE, TY_INT, alo, blo, 0, NULL);
    else { f77_error("internal: unknown fp64 op"); return alo; }
    return hi_emit(k, TY_DOUBLE, alo, blo, 0, NULL);
}
static int f77_fp64_pair1(char *name, int alo, int ahi, int *rhi) {
    (void)ahi;
    if (rhi) *rhi = -1;
    if (strcmp(name, "__fp64_neg") == 0) return hi_emit(HI_FNEG, TY_DOUBLE, alo, -1, 0, NULL);
    if (strcmp(name, "__fp64_sqrt") == 0) { int d; return f77_libm_d1("sqrt", alo, -1, &d); }
    f77_error("internal: unknown fp64 unary op");
    return alo;
}
static int f77_libm_f1(char *name, int a);
static int f77_fp64_call1(char *name, int alo, int *rhi) {
    if (rhi) *rhi = -1;
    if (strcmp(name, "__fp64_cvt_itoD") == 0) return hi_emit(HI_FCVT_ItoF, TY_DOUBLE, alo, -1, 0, NULL);
    if (strcmp(name, "__fp64_cvt_ftoD") == 0) return hi_emit(HI_FCVT_FtoD, TY_DOUBLE, alo, -1, 0, NULL);
    if (strcmp(name, "__fp32_sqrt") == 0) return f77_libm_f1("sqrtf", alo);
    f77_error("internal: unknown fp64 conversion");
    return alo;
}
#else
static int f77_fp64_is_two(int lo, int hi) {
    return lo >= 0 && hi >= 0 &&
           h_kind[lo] == HI_ICONST && h_val[lo] == 0 &&
           h_kind[hi] == HI_ICONST && h_val[hi] == 1073741824;
}

static int f77_fp64_call2(char *name, int alo, int ahi, int blo, int bhi, int *rhi) {
    int cb;
    int r;
    /* 2.0*X and X*2.0 are exactly X+X in IEEE (scaling by a power of
     * two never rounds), and the rewrite deletes the constant: in a
     * loop that is two fewer remat instructions every iteration. */
    if (strcmp(name, "__fp64_mul") == 0) {
        if (f77_fp64_is_two(alo, ahi)) {
            alo = blo; ahi = bhi; name = "__fp64_add";
        } else if (f77_fp64_is_two(blo, bhi)) {
            blo = alo; bhi = ahi; name = "__fp64_add";
        }
    }
    cb = h_ncarg;
    h_carg[h_ncarg] = alo; h_ncarg = h_ncarg + 1;
    h_carg[h_ncarg] = ahi; h_ncarg = h_ncarg + 1;
    h_carg[h_ncarg] = blo; h_ncarg = h_ncarg + 1;
    h_carg[h_ncarg] = bhi; h_ncarg = h_ncarg + 1;
    r = hi_emit(HI_CALL, TY_INT, -1, -1, 4, name);
    h_cbase[r] = cb;
    if (rhi) *rhi = hi_emit(HI_CALLHI, TY_INT, r, -1, 0, NULL);
    return r;
}

/* Unary operation on a double PAIR: exactly two argument words. */
static int f77_fp64_pair1(char *name, int alo, int ahi, int *rhi) {
    int cb;
    int r;
    cb = h_ncarg;
    h_carg[h_ncarg] = alo; h_ncarg = h_ncarg + 1;
    h_carg[h_ncarg] = ahi; h_ncarg = h_ncarg + 1;
    r = hi_emit(HI_CALL, TY_INT, -1, -1, 2, name);
    h_cbase[r] = cb;
    if (rhi) *rhi = hi_emit(HI_CALLHI, TY_INT, r, -1, 0, NULL);
    return r;
}

static int f77_fp64_call1(char *name, int alo, int *rhi) {
    int cb;
    int r;
    cb = h_ncarg;
    h_carg[h_ncarg] = alo; h_ncarg = h_ncarg + 1;
    r = hi_emit(HI_CALL, TY_INT, -1, -1, 1, name);
    h_cbase[r] = cb;
    if (rhi) *rhi = hi_emit(HI_CALLHI, TY_INT, r, -1, 0, NULL);
    return r;
}
#endif

/* --- libm calls by their C names ---------------------------------------
 *
 * The transcendentals are REAL calls, and the name IS the contract:
 * slow32 and slow32-fast execute the Newton-series SLOW-32 code that
 * libs32.s32a links in, while slow32-dbt and qemu-tcg find these names
 * in the .s32x symbol table and substitute the host's native routines
 * at translation time.  A wrapper name would starve that machinery, so
 * these emit `sin`, `atan2`, `pow`, ... verbatim -- and, unlike the
 * __fp64_* pseudo-calls the backend inlines, they carry real ABI tags
 * (aligned pairs for doubles). */

#ifdef F77_NATIVE_F64
static int f77_libm_d1(char *name, int a, int ahi, int *rhi) {
    int cb;
    int r;
    (void)ahi;
    cb = h_ncarg;
    h_carg[h_ncarg] = a; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    r = hi_emit(HI_CALL, TY_DOUBLE, -1, -1, 1, name);
    h_cbase[r] = cb;
    *rhi = -1;
    return r;
}

static int f77_libm_d2(char *name, int a, int ahi, int b, int bhi, int *rhi) {
    int cb;
    int r;
    (void)ahi; (void)bhi;
    cb = h_ncarg;
    h_carg[h_ncarg] = a; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    h_carg[h_ncarg] = b; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    r = hi_emit(HI_CALL, TY_DOUBLE, -1, -1, 2, name);
    h_cbase[r] = cb;
    *rhi = -1;
    return r;
}
#else
static int f77_libm_d1(char *name, int a, int ahi, int *rhi) {
    int cb;
    int r;
    cb = h_ncarg;
    h_carg[h_ncarg] = a;   h_carg_tag[h_ncarg] = 1; h_ncarg = h_ncarg + 1;
    h_carg[h_ncarg] = ahi; h_carg_tag[h_ncarg] = 2; h_ncarg = h_ncarg + 1;
    r = hi_emit(HI_CALL, TY_INT, -1, -1, 2, name);
    h_cbase[r] = cb;
    *rhi = hi_emit(HI_CALLHI, TY_INT, r, -1, 0, NULL);
    return r;
}

static int f77_libm_d2(char *name, int a, int ahi, int b, int bhi, int *rhi) {
    int cb;
    int r;
    cb = h_ncarg;
    h_carg[h_ncarg] = a;   h_carg_tag[h_ncarg] = 1; h_ncarg = h_ncarg + 1;
    h_carg[h_ncarg] = ahi; h_carg_tag[h_ncarg] = 2; h_ncarg = h_ncarg + 1;
    h_carg[h_ncarg] = b;   h_carg_tag[h_ncarg] = 1; h_ncarg = h_ncarg + 1;
    h_carg[h_ncarg] = bhi; h_carg_tag[h_ncarg] = 2; h_ncarg = h_ncarg + 1;
    r = hi_emit(HI_CALL, TY_INT, -1, -1, 4, name);
    h_cbase[r] = cb;
    *rhi = hi_emit(HI_CALLHI, TY_INT, r, -1, 0, NULL);
    return r;
}
#endif

static int f77_libm_f1(char *name, int a) {
    int cb;
    int r;
    cb = h_ncarg;
    h_carg[h_ncarg] = a; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    r = hi_emit(HI_CALL, TY_FLOAT, -1, -1, 1, name);
    h_cbase[r] = cb;
    return r;
}

static int f77_libm_f2(char *name, int a, int b) {
    int cb;
    int r;
    cb = h_ncarg;
    h_carg[h_ncarg] = a; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    h_carg[h_ncarg] = b; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    r = hi_emit(HI_CALL, TY_FLOAT, -1, -1, 2, name);
    h_cbase[r] = cb;
    return r;
}

#ifdef F77_NATIVE_F64
/* A floating constant is HI_FCONST carrying its decimal TEXT in h_name:
 * the back end converts it to the target's format exactly (S/370
 * hexadecimal float, rounded to the nearest; s370_hfp.h), which a host double
 * could not promise.  Literals keep the source spelling; values the
 * compiler made up are printed with enough digits to be exact. */
/* A double the compiler made as decimal text for s370_hfp.h, exactly:
 * the host's double is IEEE on a Mac and HFP on MVS, and either one is
 * M * 2^b, which is the decimal M * 5^-b * 10^b.  printf won't do: MVS's
 * is inexact, and seventeen digits of an IEEE double are not the double.
 * A value too small or too large for s370_hfp.h's digits (below about
 * 1E-10 here) falls back to seventeen digits.  Literals never come here:
 * they keep their source text (f77_cx_t, lex_ftext).  Only 32-bit
 * arithmetic: cc370 gets 64-bit wrong. */
static int f77_dec_muladd(unsigned char *g, int n, int m, int a) {
    int i;
    for (i = 0; i < n; i++) { a = a + g[i] * m; g[i] = (unsigned char)(a % 10); a = a / 10; }
    while (a) { if (n >= 300) return -1; g[n] = (unsigned char)(a % 10); a = a / 10; n = n + 1; }
    return n;
}
static void f77_dtext(double d, char *b) {
    unsigned int w[2], hi, lo;
    int bexp, nbits, neg, n, i, k;
    unsigned char g[300];
    if (d == (double)(int)d && d > -1.0e9 && d < 1.0e9) { sprintf(b, "%d", (int)d); return; }
    memcpy(w, &d, 8);
#ifdef __MVS__
    hi = w[0]; lo = w[1];
    neg = (int)(hi >> 31);
    bexp = 4 * (int)((hi >> 24) & 0x7F) - 256 - 56;
    hi = hi & 0xFFFFFFu; nbits = 56;
#else
    { unsigned int one = 1;
      if (*(unsigned char *)&one) { hi = w[1]; lo = w[0]; } else { hi = w[0]; lo = w[1]; } }
    neg = (int)(hi >> 31);
    bexp = (int)((hi >> 20) & 0x7FF);
    if (bexp == 0x7FF) { sprintf(b, "%.17g", d); return; }
    if (bexp == 0) bexp = -1074; else { bexp = bexp - 1075; hi = (hi & 0xFFFFFu) | 0x100000u; }
    hi = hi & 0x1FFFFFu; nbits = 53;
#endif
    while (bexp < 0 && (lo & 1u) == 0 && (hi | lo) != 0) {
        lo = (lo >> 1) | (hi << 31); hi = hi >> 1; bexp = bexp + 1; nbits = nbits - 1;
    }
    if (bexp < -90) { sprintf(b, "%.17g", d); return; }
    n = 0;
    for (i = nbits - 1; i >= 0; i--)
        n = f77_dec_muladd(g, n, 2, (int)((i >= 32 ? hi >> (i - 32) : lo >> i) & 1u));
    for (k = 0; n >= 0 && k < (bexp < 0 ? -bexp : bexp); k++) n = f77_dec_muladd(g, n, bexp < 0 ? 5 : 2, 0);
    if (n < 0 || n > 120) { sprintf(b, "%.17g", d); return; }
    k = 0;
    if (neg) b[k++] = '-';
    if (n == 0) b[k++] = '0';
    for (i = n - 1; i >= 0; i--) b[k++] = (char)('0' + g[i]);
    if (bexp < 0) sprintf(b + k, "E-%d", -bexp); else b[k] = 0;
}
static int f77_fconst_text(char *text, int ty) {
    return hi_emit(HI_FCONST, ty, -1, -1, 0, strdup(text));
}
static int f77_dconst(double d, int *hi) {
    char b[160];
    *hi = -1;
    f77_dtext(d, b);
    return f77_fconst_text(b, TY_DOUBLE);
}
#else
/* A DOUBLE literal is just its two words as constants. */
static int f77_dconst(double d, int *hi) {
    int w[2];
    memcpy(w, &d, 8);
    *hi = hi_emit(HI_ICONST, TY_INT, -1, -1, w[1], NULL);
    return hi_emit(HI_ICONST, TY_INT, -1, -1, w[0], NULL);
}
#endif

/* Convert `v` (with hi word *hi when it is a double) from one type to
 * another, updating *hi in place. */
static int f77_rconst(double d);
static int f77_cvt(int v, int *hi, int from, int to) {
    if (from == to) return v;
    if (from == TY_CHAR || to == TY_CHAR) {
        f77_error("CHARACTER value where a numeric one is needed (or vice versa)");
        return v;
    }
    if (f77_iscx(from) && f77_iscx(to)) {
        /* COMPLEX <-> COMPLEX*16: each part */
        int im;
        int h;
        h = -1;
        im = f77_cvt(*hi, &h, f77_cxpart(from), f77_cxpart(to));
        h = -1;
        v = f77_cvt(v, &h, f77_cxpart(from), f77_cxpart(to));
        *hi = im;
        return v;
    }
    if (f77_iscx(to)) {
        /* (x, 0.0) */
        v = f77_cvt(v, hi, from, f77_cxpart(to));
        if (to == TY_DCPLX) { int h; *hi = f77_dconst(0.0, &h); }
        else *hi = f77_rconst(0.0);
        return v;
    }
    if (f77_iscx(from)) {
        /* the real part, F77 4.6 */
        *hi = -1;
        return f77_cvt(v, hi, f77_cxpart(from), to);
    }
    if (to == TY_DOUBLE) {
        if (from == TY_INT)   return f77_fp64_call1("__fp64_cvt_itoD", v, hi);
        if (from == TY_FLOAT) return f77_fp64_call1("__fp64_cvt_ftoD", v, hi);
        return v;
    }
#ifdef F77_NATIVE_F64
    if (from == TY_DOUBLE) {
        *hi = -1;
        if (to == TY_INT) return hi_emit(HI_FCVT_FtoI, TY_INT, v, -1, 0, NULL);
        return hi_emit(HI_FCVT_DtoF, TY_FLOAT, v, -1, 0, NULL);
    }
#else
    if (from == TY_DOUBLE) {
        int cb;
        int r;
        cb = h_ncarg;
        h_carg[h_ncarg] = v;   h_ncarg = h_ncarg + 1;
        h_carg[h_ncarg] = *hi; h_ncarg = h_ncarg + 1;
        r = hi_emit(HI_CALL, TY_INT, -1, -1, 2,
                    to == TY_INT ? "__fp64_cvt_DtoI" : "__fp64_cvt_DtoF");
        h_cbase[r] = cb;
        h_ty[r] = to;
        return r;
    }
#endif
    if (from == TY_INT && to == TY_FLOAT)
        return hi_emit(HI_FCVT_ItoF, TY_FLOAT, v, -1, 0, NULL);
    if (from == TY_FLOAT && to == TY_INT)
        return hi_emit(HI_FCVT_FtoI, TY_INT, v, -1, 0, NULL);
    return v;
}

/* Back-compatible single-word convert (no doubles involved). */
static int f77_convert(int v, int from, int to) {
    int hi;
    hi = -1;
    return f77_cvt(v, &hi, from, to);
}

/* F77 mixed mode: DOUBLE beats REAL beats INTEGER. */
static int f77_balance(int *a, int *ahi, int aty, int *b, int *bhi, int bty) {
    if (aty == bty) return aty;
    if (f77_iscx(aty) || f77_iscx(bty)) {
        /* COMPLEX*16 beats COMPLEX, and COMPLEX with DOUBLE PRECISION
         * is COMPLEX*16, as in IBM's FORTRAN (F77 forbids the mix) */
        int r;
        r = (aty == TY_DCPLX || bty == TY_DCPLX || aty == TY_DOUBLE || bty == TY_DOUBLE) ? TY_DCPLX : TY_CPLX;
        *a = f77_cvt(*a, ahi, aty, r);
        *b = f77_cvt(*b, bhi, bty, r);
        return r;
    }
    if (aty == TY_DOUBLE || bty == TY_DOUBLE) {
        *a = f77_cvt(*a, ahi, aty, TY_DOUBLE);
        *b = f77_cvt(*b, bhi, bty, TY_DOUBLE);
        return TY_DOUBLE;
    }
    if (aty == TY_FLOAT || bty == TY_FLOAT) {
        *a = f77_cvt(*a, ahi, aty, TY_FLOAT);
        *b = f77_cvt(*b, bhi, bty, TY_FLOAT);
        return TY_FLOAT;
    }
    return TY_INT;
}

/* Integer constants are cached PER BASIC BLOCK.  CSE hashes on operand
 * instruction indices, so two identical expressions built from two
 * separately-emitted ICONSTs of the same value never match -- which is
 * why `(i-1)*8` was being recomputed once per array reference instead
 * of shared.  The cache is per-block, not per-function, so a reused
 * constant always dominates its uses. */
#define F77_KCACHE 64
static int f77_kval[F77_KCACHE];
static int f77_kinst[F77_KCACHE];
static int f77_nk;
static int f77_kblk = -1;

static int f77_iconst(int v) {
    int i;
    if (hl_cur_blk != f77_kblk) { f77_kblk = hl_cur_blk; f77_nk = 0; }
    i = 0;
    while (i < f77_nk) {
        if (f77_kval[i] == v) return f77_kinst[i];
        i = i + 1;
    }
    i = hi_emit(HI_ICONST, TY_INT, -1, -1, v, NULL);
    if (f77_nk < F77_KCACHE) {
        f77_kval[f77_nk] = v;
        f77_kinst[f77_nk] = i;
        f77_nk = f77_nk + 1;
    }
    return i;
}

/* REAL constant: f32 bits carried in an ICONST typed TY_FLOAT, which is
 * how the C compiler represents them too. */
#ifdef F77_NATIVE_F64
static int f77_rconst(double d) {
    char b[160];
    f77_dtext(d, b);
    return f77_fconst_text(b, TY_FLOAT);
}
#else
static int f77_rconst(double d) {
    float f;
    int bits;
    f = (float)d;
    memcpy(&bits, &f, 4);
    return hi_emit(HI_ICONST, TY_FLOAT, -1, -1, bits, NULL);
}
#endif

/* Address of A(s1,s2,...).  Fortran is COLUMN-MAJOR and 1-based by
 * default, so the element offset is
 *
 *     (s1-lo1) + (s2-lo2)*n1 + (s3-lo3)*n1*n2 + ...
 *
 * i.e. the FIRST subscript varies fastest -- the opposite of C.  Any
 * lower bound is allowed (A(0:9), A(-5:5)); it is folded into the
 * subtraction, and constant subscripts fold away entirely downstream. */
/* Byte offset of element `off` (zero-based, linear) of symbol s. */
static int f77_elem_bytes(int s, int off) {
    int t;
    if (f77_sty[s] == TY_CHAR && f77_slen[s] < 0)
        return hi_emit(HI_MUL, TY_INT, off, f77_slenv[s], 0, NULL);
    t = f77_esize(s);
    if (t == 1) return off;
    if (t == 4) return hi_emit(HI_SLL, TY_INT, off, f77_iconst(2), 0, NULL);
    if (t == 8) return hi_emit(HI_SLL, TY_INT, off, f77_iconst(3), 0, NULL);
    return hi_emit(HI_MUL, TY_INT, off, f77_iconst(t), 0, NULL);
}

static int f77_subscript_addr(int s) {
    int off;
    int cstride;      /* constant part of the running stride */
    int vstride;      /* runtime stride value, or -1 while still constant */
    int k;
    int idx;
    int t;
    int byte;
    int e;
    int coff;         /* compile-time part: -sum(lo_k * stride_k) */
    int addr;
    int n0;           /* the first instruction a subscript's expression made */

    /* A constant lower bound over a CONSTANT stride contributes a
     * compile-time byte offset, accumulated in coff and emitted as one
     * trailing ADDI on the final address -- which BURG folds into each
     * load/store's 12-bit displacement, so Fortran's 1-based (I-1)
     * subtraction costs nothing at run time.  A lower bound over a
     * RUNTIME stride (adjustable dimensions) keeps the subtraction on
     * the index, as before. */
    off = -1;
    coff = 0;
    cstride = 1;
    vstride = -1;
    k = 0;
    for (;;) {
        n0 = h_ninst;
        idx = f77_expr();
        idx = f77_cvt(idx, &ex_hi, ex_ty, TY_INT);
        if (k < f77_srank[s]) {
            if (f77_slov[s][k] >= 0)
                idx = hi_emit(HI_SUB, TY_INT, idx, f77_slov[s][k], 0, NULL);
            if (f77_slo[s][k] != 0) {
                if (vstride >= 0)
                    idx = hi_emit(HI_ADDI, TY_INT, idx, -1, 0 - f77_slo[s][k], NULL);
                else
                    coff = coff - f77_slo[s][k] * cstride;
            }
#ifdef F77_TARGET_S370
            /* Each term scaled to bytes by itself, so a term that is
             * invariant in a loop (the column of A(I,J)) can be hoisted
             * and the index register carries only the subscript that
             * varies: base+index+displacement in one operand. */
            if (vstride < 0 && h_kind[idx] == HI_ICONST
                && !(f77_sty[s] == TY_CHAR && f77_slen[s] < 0)) {
                /* a constant subscript over a constant stride joins the
                 * displacement: A(3) is one ADDI, not four instructions */
                coff = coff + h_val[idx] * cstride;
                if (idx == n0 && idx == h_ninst - 1 && f77_nk > 0 && f77_kinst[f77_nk - 1] == idx
                    && hl_cur_blk >= 0 && bb_end[hl_cur_blk] == h_ninst) {
                    /* and the ICONST made for it, and nothing else, is taken back */
                    f77_nk = f77_nk - 1;
                    h_ninst = h_ninst - 1;
                    bb_end[hl_cur_blk] = h_ninst;
                }
            } else if (!(f77_sty[s] == TY_CHAR && f77_slen[s] < 0)) {
                int m;
                int lg;
                m = f77_esize(s);
                if (vstride >= 0) {
                    idx = hi_emit(HI_MUL, TY_INT, idx, vstride, 0, NULL);
                } else {
                    m = m * cstride;
                }
                lg = -1;
                if (m == 1) lg = 0;
                else if (m == 2) lg = 1; else if (m == 4) lg = 2; else if (m == 8) lg = 3;
                else if (m == 16) lg = 4; else if (m == 32) lg = 5;
                if (lg > 0) idx = hi_emit(HI_SLL, TY_INT, idx, f77_iconst(lg), 0, NULL);
                else if (lg < 0) idx = hi_emit(HI_MUL, TY_INT, idx, f77_iconst(m), 0, NULL);
                off = (off < 0) ? idx : hi_emit(HI_ADD, TY_INT, off, idx, 0, NULL);
            } else {
#endif
            if (vstride >= 0)
                idx = hi_emit(HI_MUL, TY_INT, idx, vstride, 0, NULL);
            else if (cstride != 1)
                idx = hi_emit(HI_MUL, TY_INT, idx, f77_iconst(cstride), 0, NULL);
            off = (off < 0) ? idx : hi_emit(HI_ADD, TY_INT, off, idx, 0, NULL);
#ifdef F77_TARGET_S370
            }
#endif

            /* Advance the stride by this dimension's extent.  Once any
             * extent is a run-time value the stride becomes one too;
             * the last dimension's extent is never needed, which is why
             * A(LDA,1) and A(LDA,*) both work. */
            if (f77_sextv[s][k] >= 0) {
                e = f77_sextv[s][k];
                if (vstride >= 0) {
                    vstride = hi_emit(HI_MUL, TY_INT, vstride, e, 0, NULL);
                } else if (cstride == 1) {
                    vstride = e;
                } else {
                    vstride = hi_emit(HI_MUL, TY_INT, e, f77_iconst(cstride), 0, NULL);
                }
            } else if (vstride >= 0) {
                vstride = hi_emit(HI_MUL, TY_INT, vstride,
                                  f77_iconst(f77_sext[s][k]), 0, NULL);
            } else {
                cstride = cstride * f77_sext[s][k];
            }
        }
        k = k + 1;
        if (lx_t != T_COMMA) break;
        f77_tok();
    }
    if (lx_t != T_RP) { f77_error("expected ) after subscripts"); }
    else f77_tok();
    if (k != f77_srank[s]) f77_error("wrong number of subscripts");

#ifdef F77_TARGET_S370
    if (off < 0 && !(f77_sty[s] == TY_CHAR && f77_slen[s] < 0)) {   /* every subscript constant */
        int cb;
        cb = coff * f77_esize(s);
        if (cb >= -2048 && cb <= 2047)
            return hi_emit(HI_ADDI, HL_ADDR_TY, f77_sval[s], -1, cb, NULL);
        return hi_emit(HI_ADD, HL_ADDR_TY, f77_sval[s], f77_iconst(cb), 0, NULL);
    }
#endif
    if (off < 0) off = f77_iconst(0);
#ifdef F77_TARGET_S370
    if (!(f77_sty[s] == TY_CHAR && f77_slen[s] < 0)) byte = off;   /* already bytes */
    else byte = f77_elem_bytes(s, off);
#else
    byte = f77_elem_bytes(s, off);
#endif
    addr = hi_emit(HI_ADD, HL_ADDR_TY, f77_sval[s], byte, 0, NULL);
    if (coff != 0 && f77_sty[s] == TY_CHAR && f77_slen[s] < 0) {
        /* assumed-length elements: the offset is a run-time product */
        t = hi_emit(HI_MUL, TY_INT, f77_iconst(coff), f77_slenv[s], 0, NULL);
        addr = hi_emit(HI_ADD, HL_ADDR_TY, addr, t, 0, NULL);
    } else if (coff != 0) {
        int cb;
        cb = coff * f77_esize(s);
        if (cb >= -2048 && cb <= 2047)
            addr = hi_emit(HI_ADDI, HL_ADDR_TY, addr, -1, cb, NULL);
        else
            addr = hi_emit(HI_ADD, HL_ADDR_TY, addr, f77_iconst(cb), 0, NULL);
    }
    return addr;
}

/* A static local's loads may hoist only if nothing but this unit's own
 * stores could change it: not in an EQUIVALENCE (it could change under
 * the other name), and not in a unit with ENTRY points (each compiles
 * part of the parent's text against the same storage). */
static int f77_ldro_local_ok(int s) {
    int q;
    if (f77_scom[s]) return 0;
    for (q = 0; q < f77_eq_n; q++)
        if (f77_eq_sa[q] == s || f77_eq_sb[q] == s) return 0;
    if (f77_unit_entries) return 0;
    return 1;
}

/* Load a scalar symbol.  When it has a paired hi slot, both halves are
 * direct loads of promotable allocas -- no address arithmetic, so
 * mem2reg can keep the whole double in registers. */
static int f77_load_sym(int s) {
    int v;
    ex_ty = f77_sty[s];
    ex_log = f77_slog[s];
    if (f77_shi[s] >= 0) {
        int wty;
        wty = f77_pairw(f77_sty[s]);
        v = hi_emit(HI_LOAD, wty, f77_sval[s], -1, 0, NULL);
        ex_hi = hi_emit(HI_LOAD, wty, f77_shi[s], -1, 0, NULL);
        return v;
    }
    v = f77_load_at(f77_sval[s], f77_sty[s]);
    /* fort370: and a local scalar in static storage (SAVE, or DATA's
     * initial value) outside COMMON: only this unit can reach it, so if
     * the unit never stores it its value cannot change -- LEN in
     * INTEGER LEN/30000/, reloaded on every pass of a loop.  Retracted
     * at unit end (f77_ldro_finalize) for a stored, equivalenced or
     * ENTRY-shared one. */
    if (f77_srank[s] == 0 && f77_sty[s] != TY_CHAR &&
        (f77_sarg[s] || (f77_ssaved[s] && !f77_scom[s]))) {
        f77_ldro_note(v, s);
        if (f77_sty[s] == TY_DOUBLE && ex_hi >= 0) f77_ldro_note(ex_hi, s);
    }
    return v;
}

static void f77_store_sym_val(int s, int v, int vty, int vhi) {
    f77_sstored[s] = 1;
    if (f77_shi[s] >= 0) {
        int wty;
        wty = f77_pairw(f77_sty[s]);
        v = f77_cvt(v, &vhi, vty, f77_sty[s]);
        hi_emit(HI_STORE, wty, f77_sval[s], v, 0, NULL);
        hi_emit(HI_STORE, wty, f77_shi[s], vhi, 0, NULL);
        return;
    }
    f77_store_at(f77_sval[s], f77_sty[s], v, vty, vhi);
}

/* Load a value of type `ty` from `addr`, setting ex_ty/ex_hi. */
static int f77_load_at(int addr, int ty) {
    int v;
    ex_ty = ty;
    if (f77_ispair(ty)) {
        int a4;
        int wty;
        wty = f77_pairw(ty);
        v = hi_emit(HI_LOAD, wty, addr, -1, 0, NULL);
        a4 = hi_emit(HI_ADDI, HL_ADDR_TY, addr, -1, f77_pairoff(ty), NULL);
        ex_hi = hi_emit(HI_LOAD, wty, a4, -1, 0, NULL);
        return v;
    }
    return hi_emit(HI_LOAD, ty, addr, -1, 0, NULL);
}

/* Store `v` (hi word `vhi`) of type `vty` to `addr` as type `ty`. */
static void f77_store_at(int addr, int ty, int v, int vty, int vhi) {
    v = f77_cvt(v, &vhi, vty, ty);
    if (f77_ispair(ty)) {
        int a4;
        int wty;
        wty = f77_pairw(ty);
        hi_emit(HI_STORE, wty, addr, v, 0, NULL);
        a4 = hi_emit(HI_ADDI, HL_ADDR_TY, addr, -1, f77_pairoff(ty), NULL);
        hi_emit(HI_STORE, wty, a4, vhi, 0, NULL);
        return;
    }
    hi_emit(HI_STORE, ty, addr, v, 0, NULL);
}

/* --- intrinsic functions --------------------------------------------- */

/* Branchless select: cond ? a : b, via  b ^ ((a^b) & -cond).
 * SLOW-32 has no conditional move, and a branch inside an expression
 * would mean splitting the current block mid-expression, so the mask
 * form is both simpler here and better code. */
#ifdef F77_NATIVE_F64
static int f77_select_fp(int cond, int a, int b);
#endif
static int f77_select(int cond, int a, int b) {
    int m;
    int x;
#ifdef F77_NATIVE_F64
    /* A native floating value is not a bit pattern: choose with a
     * branch (f77_select_fp, below the block helpers). */
    if (a >= 0 && ty_is_fp(h_ty[a]) && h_kind[a] != HI_ALLOCA) return f77_select_fp(cond, a, b);
#endif
    m = hi_emit(HI_NEG, TY_INT, cond, -1, 0, NULL);
    x = hi_emit(HI_XOR, TY_INT, a, b, 0, NULL);
    x = hi_emit(HI_AND, TY_INT, x, m, 0, NULL);
    return hi_emit(HI_XOR, TY_INT, b, x, 0, NULL);
}

#define IN_NONE   0
#define IN_ABS    1
#define IN_MAX    2
#define IN_MIN    3
#define IN_MOD    4
#define IN_INT    5
#define IN_REAL   6
#define IN_DBLE   7
#define IN_SQRT   8
#define IN_SIGN   9
#define IN_MAX1   10   /* real args, integer result */
#define IN_MIN1   11
#define IN_AMAX0  12   /* integer args, real result */
#define IN_AMIN0  13
/* Transcendentals: contiguous ids, range-tested in the lowering. */
#define IN_SIN    14
#define IN_COS    15
#define IN_TAN    16
#define IN_ASIN   17
#define IN_ACOS   18
#define IN_ATAN   19
#define IN_ATAN2  20
#define IN_EXP    21
#define IN_LOG    22
#define IN_LOG10  23
#define IN_SINH   24
#define IN_COSH   25
#define IN_TANH   26
#define IN_AINT   27   /* truncation: AINT/DINT */
#define IN_ANINT  28   /* nearest whole number: ANINT/DNINT */
#define IN_NINT   29   /* nearest integer: NINT/IDNINT */
#define IN_DIM    30   /* positive difference: DIM/IDIM/DDIM */
#define IN_DPROD  31   /* double product of two reals */
#define IN_LEN    32   /* CHARACTER intrinsics */
#define IN_ICHAR  33
#define IN_CHAR   34
#define IN_INDEX  35
#define IN_LGE    36
#define IN_LGT    37
#define IN_LLE    38
#define IN_LLT    39
#define IN_AIMAG  40   /* COMPLEX intrinsics */
#define IN_CMPLX  41
#define IN_CONJG  42
#define IN_DCMPLX 43   /* fort370: IBM's COMPLEX*16 constructor */

/* F77 intrinsic names are type-decorated (ABS/IABS/DABS, MAX0/AMAX1/
 * DMAX1); the operation is the same and the operand types decide the
 * lowering, so the decorations all fold onto one id here. */
static int f77_intrinsic(char *nm) {
    if (strcmp(nm, "ABS") == 0 || strcmp(nm, "IABS") == 0 ||
        strcmp(nm, "DABS") == 0) return IN_ABS;
    if (strcmp(nm, "MAX") == 0 || strcmp(nm, "MAX0") == 0 ||
        strcmp(nm, "AMAX1") == 0 || strcmp(nm, "DMAX1") == 0) return IN_MAX;
    if (strcmp(nm, "MAX1") == 0) return IN_MAX1;
    if (strcmp(nm, "AMAX0") == 0) return IN_AMAX0;
    if (strcmp(nm, "MIN") == 0 || strcmp(nm, "MIN0") == 0 ||
        strcmp(nm, "AMIN1") == 0 || strcmp(nm, "DMIN1") == 0) return IN_MIN;
    if (strcmp(nm, "MIN1") == 0) return IN_MIN1;
    if (strcmp(nm, "AMIN0") == 0) return IN_AMIN0;
    if (strcmp(nm, "MOD") == 0 || strcmp(nm, "AMOD") == 0 ||
        strcmp(nm, "DMOD") == 0) return IN_MOD;
    if (strcmp(nm, "INT") == 0 || strcmp(nm, "IDINT") == 0 ||
        strcmp(nm, "IFIX") == 0) return IN_INT;
    if (strcmp(nm, "REAL") == 0 || strcmp(nm, "FLOAT") == 0 ||
        strcmp(nm, "SNGL") == 0) return IN_REAL;
    if (strcmp(nm, "DBLE") == 0 || strcmp(nm, "DFLOAT") == 0) return IN_DBLE;
    if (strcmp(nm, "SQRT") == 0 || strcmp(nm, "DSQRT") == 0) return IN_SQRT;
    if (strcmp(nm, "SIGN") == 0 || strcmp(nm, "ISIGN") == 0 ||
        strcmp(nm, "DSIGN") == 0) return IN_SIGN;
    if (strcmp(nm, "SIN") == 0 || strcmp(nm, "DSIN") == 0) return IN_SIN;
    if (strcmp(nm, "COS") == 0 || strcmp(nm, "DCOS") == 0) return IN_COS;
    if (strcmp(nm, "TAN") == 0 || strcmp(nm, "DTAN") == 0) return IN_TAN;
    /* ARSIN, ARCOS, DARSIN and DARCOS are IBM's names for them */
    if (strcmp(nm, "ASIN") == 0 || strcmp(nm, "DASIN") == 0 ||
        strcmp(nm, "ARSIN") == 0 || strcmp(nm, "DARSIN") == 0) return IN_ASIN;
    if (strcmp(nm, "ACOS") == 0 || strcmp(nm, "DACOS") == 0 ||
        strcmp(nm, "ARCOS") == 0 || strcmp(nm, "DARCOS") == 0) return IN_ACOS;
    if (strcmp(nm, "ATAN") == 0 || strcmp(nm, "DATAN") == 0) return IN_ATAN;
    if (strcmp(nm, "ATAN2") == 0 || strcmp(nm, "DATAN2") == 0) return IN_ATAN2;
    if (strcmp(nm, "EXP") == 0 || strcmp(nm, "DEXP") == 0) return IN_EXP;
    if (strcmp(nm, "LOG") == 0 || strcmp(nm, "ALOG") == 0 ||
        strcmp(nm, "DLOG") == 0) return IN_LOG;
    if (strcmp(nm, "LOG10") == 0 || strcmp(nm, "ALOG10") == 0 ||
        strcmp(nm, "DLOG10") == 0) return IN_LOG10;
    if (strcmp(nm, "SINH") == 0 || strcmp(nm, "DSINH") == 0) return IN_SINH;
    if (strcmp(nm, "COSH") == 0 || strcmp(nm, "DCOSH") == 0) return IN_COSH;
    if (strcmp(nm, "TANH") == 0 || strcmp(nm, "DTANH") == 0) return IN_TANH;
    if (strcmp(nm, "AINT") == 0 || strcmp(nm, "DINT") == 0) return IN_AINT;
    if (strcmp(nm, "ANINT") == 0 || strcmp(nm, "DNINT") == 0) return IN_ANINT;
    if (strcmp(nm, "NINT") == 0 || strcmp(nm, "IDNINT") == 0) return IN_NINT;
    if (strcmp(nm, "DIM") == 0 || strcmp(nm, "IDIM") == 0 ||
        strcmp(nm, "DDIM") == 0) return IN_DIM;
    if (strcmp(nm, "DPROD") == 0) return IN_DPROD;
    if (strcmp(nm, "LEN") == 0) return IN_LEN;
    if (strcmp(nm, "ICHAR") == 0) return IN_ICHAR;
    if (strcmp(nm, "CHAR") == 0) return IN_CHAR;
    if (strcmp(nm, "INDEX") == 0) return IN_INDEX;
    if (strcmp(nm, "LGE") == 0) return IN_LGE;
    if (strcmp(nm, "LGT") == 0) return IN_LGT;
    if (strcmp(nm, "LLE") == 0) return IN_LLE;
    if (strcmp(nm, "LLT") == 0) return IN_LLT;
    if (strcmp(nm, "AIMAG") == 0) return IN_AIMAG;
    if (strcmp(nm, "CMPLX") == 0) return IN_CMPLX;
    if (strcmp(nm, "CONJG") == 0) return IN_CONJG;
    if (strcmp(nm, "CABS") == 0) return IN_ABS;
    if (strcmp(nm, "CSQRT") == 0) return IN_SQRT;
    if (strcmp(nm, "CEXP") == 0) return IN_EXP;
    if (strcmp(nm, "CLOG") == 0) return IN_LOG;
    if (strcmp(nm, "CSIN") == 0) return IN_SIN;
    if (strcmp(nm, "CCOS") == 0) return IN_COS;
#ifdef F77_NATIVE_F64
    /* fort370: COMPLEX*16, by FORTRAN H's names (DIMAG and DREAL are
     * later IBM's, and gfortran's); the generic names take it too */
    if (strcmp(nm, "DCMPLX") == 0) return IN_DCMPLX;
    if (strcmp(nm, "DCONJG") == 0) return IN_CONJG;
    if (strcmp(nm, "DIMAG") == 0) return IN_AIMAG;
    if (strcmp(nm, "DREAL") == 0) return IN_DBLE;
    if (strcmp(nm, "CDABS") == 0) return IN_ABS;
    if (strcmp(nm, "CDSQRT") == 0) return IN_SQRT;
    if (strcmp(nm, "CDEXP") == 0) return IN_EXP;
    if (strcmp(nm, "CDLOG") == 0) return IN_LOG;
    if (strcmp(nm, "CDSIN") == 0) return IN_SIN;
    if (strcmp(nm, "CDCOS") == 0) return IN_COS;
#endif
    return IN_NONE;
}

/* The libm name for a transcendental, by result width. */
static char *f77_tr_name(int in, int dbl) {
    if (in == IN_SIN)   return dbl ? "sin"   : "sinf";
    if (in == IN_COS)   return dbl ? "cos"   : "cosf";
    if (in == IN_TAN)   return dbl ? "tan"   : "tanf";
    if (in == IN_ASIN)  return dbl ? "asin"  : "asinf";
    if (in == IN_ACOS)  return dbl ? "acos"  : "acosf";
    if (in == IN_ATAN)  return dbl ? "atan"  : "atanf";
    if (in == IN_ATAN2) return dbl ? "atan2" : "atan2f";
    if (in == IN_EXP)   return dbl ? "exp"   : "expf";
    if (in == IN_LOG)   return dbl ? "log"   : "logf";
    if (in == IN_LOG10) return dbl ? "log10" : "log10f";
    if (in == IN_SINH)  return dbl ? "sinh"  : "sinhf";
    if (in == IN_COSH)  return dbl ? "cosh"  : "coshf";
    return dbl ? "tanh" : "tanhf";
}

/* |x|: for FP just clear the sign bit; for an integer use the standard
 * branchless (x ^ (x>>31)) - (x>>31). */
static int f77_abs(int v, int ty, int *hi) {
    int m;
#ifdef F77_NATIVE_F64
    if (ty == TY_DOUBLE || ty == TY_FLOAT) {
        *hi = -1;
        return hi_emit(HI_FABS, ty, v, -1, 0, NULL);
    }
#endif
    if (ty == TY_DOUBLE) {
        *hi = hi_emit(HI_AND, TY_INT, *hi, f77_iconst(0x7fffffff), 0, NULL);
        return v;
    }
    if (ty == TY_FLOAT)
        return hi_emit(HI_AND, TY_FLOAT, v, f77_iconst(0x7fffffff), 0, NULL);
    m = hi_emit(HI_SRA, TY_INT, v, f77_iconst(31), 0, NULL);
    v = hi_emit(HI_XOR, TY_INT, v, m, 0, NULL);
    return hi_emit(HI_SUB, TY_INT, v, m, 0, NULL);
}

/* max/min of two already-balanced operands. */
static int f77_minmax(int want_max, int a, int ahi, int b, int bhi,
                      int ty, int *rhi) {
    int c;
    if (ty == TY_DOUBLE) {
        c = want_max ? f77_fp64_call2("__fp64_lt", b, bhi, a, ahi, NULL)
                     : f77_fp64_call2("__fp64_lt", a, ahi, b, bhi, NULL);
        if (f77_ispair(TY_DOUBLE)) *rhi = f77_select(c, ahi, bhi);
        else *rhi = -1;
        return f77_select(c, a, b);
    }
    if (ty == TY_FLOAT)
        c = want_max ? hi_emit(HI_FLT, TY_INT, b, a, 0, NULL)
                     : hi_emit(HI_FLT, TY_INT, a, b, 0, NULL);
    else
        c = want_max ? hi_emit(HI_SGT, TY_INT, a, b, 0, NULL)
                     : hi_emit(HI_SLT, TY_INT, a, b, 0, NULL);
    return f77_select(c, a, b);
}

static int f77_stf_find(char *nm);
static int f77_stf_expand(int si);
static int f77_sym_find(char *nm);

/* A call to a runtime routine taking `n` word arguments, result in r1. */
static int f77_call_i(char *name, int n, int *args) {
    int cb;
    int r;
    int i;
    cb = h_ncarg;
    for (i = 0; i < n; i++) {
        h_carg[h_ncarg] = args[i]; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    }
    r = hi_emit(HI_CALL, TY_INT, -1, -1, n, name);
    h_cbase[r] = cb;
    return r;
}

/* A frame temporary of `len` bytes for a CHARACTER value. */
static int f77_char_temp(int len) {
    int tmp;
    f77_frame = f77_frame + ((len + 3) & ~3);
    tmp = hi_emit(HI_ALLOCA, TY_CHAR, -1, -1, 0 - f77_frame, NULL);
    if (hl_nalloca < HL_MAX_ALLOCA) {
        hl_ainst[hl_nalloca] = tmp;
        hl_aoff[hl_nalloca] = 0 - f77_frame;
        hl_nalloca = hl_nalloca + 1;
    }
    return tmp;
}

/* dst(1:dlen) = src(1:slen), blank-padded or truncated. */
static void f77_char_assign(int dst, int dlen, int src, int slen) {
    int args[4];
    args[0] = dst; args[1] = dlen; args[2] = src; args[3] = slen;
    f77_call_i("f77_strcpy", 4, args);
}

/* Substring (e1:e2) of a value at `base` with length `lenv` (constant
 * `clen`, or -1).  The scanner is on the opening parenthesis.  Sets
 * ex_len/ex_clen. */
static int f77_substring(int base, int lenv, int clen) {
    int e1; int e2; int c1; int c2; int t;
    f77_tok();
    e1 = -1; e2 = -1; c1 = 1; c2 = clen;
    if (lx_t != T_COLON) {
        e1 = f77_expr(); e1 = f77_cvt(e1, &ex_hi, ex_ty, TY_INT);
        c1 = (h_kind[e1] == HI_ICONST) ? h_val[e1] : -2;
    }
    if (lx_t != T_COLON) { f77_error("expected : in substring"); return base; }
    f77_tok();
    if (lx_t != T_RP) {
        e2 = f77_expr(); e2 = f77_cvt(e2, &ex_hi, ex_ty, TY_INT);
        c2 = (h_kind[e2] == HI_ICONST) ? h_val[e2] : -2;
    }
    if (lx_t != T_RP) { f77_error("expected ) after substring"); return base; }
    f77_tok();
    if (e1 < 0) e1 = f77_iconst(1);
    if (e2 < 0) e2 = lenv;
    t = hi_emit(HI_ADDI, TY_INT, e1, -1, -1, NULL);
    base = hi_emit(HI_ADD, HL_ADDR_TY, base, t, 0, NULL);
    t = hi_emit(HI_SUB, TY_INT, e2, e1, 0, NULL);
    ex_len = hi_emit(HI_ADDI, TY_INT, t, -1, 1, NULL);
    ex_clen = (c1 >= 0 && c2 >= 0) ? c2 - c1 + 1 : -1;
    if (ex_clen >= 0) ex_len = f77_iconst(ex_clen);
    ex_ty = TY_CHAR;
    ex_hi = -1;
    return base;
}

/* Does the parenthesised group the scanner is on contain a top-level
 * colon?  That is what tells C(1:3) (a substring) from F(1) (a call to
 * an external CHARACTER function). */
static int f77_paren_has_colon(void) {
    int i;
    int depth;
    i = (int)(lx_rts - lx_stmt);
    if (i < 0 || i >= lx_stmt_len || lx_stmt[i] != '(') return 0;
    depth = 0;
    while (i < lx_stmt_len) {
        if (lx_stmt[i] == '\'') { i = i + 1; while (i < lx_stmt_len && lx_stmt[i] != '\'') i = i + 1; }
        else if (lx_stmt[i] == '(') depth = depth + 1;
        else if (lx_stmt[i] == ')') { depth = depth - 1; if (depth == 0) return 0; }
        else if (lx_stmt[i] == ':' && depth == 1) return 1;
        i = i + 1;
    }
    return 0;
}

/* Reference to CHARACTER symbol s (name already consumed): the whole
 * entity, an array element, or a substring of either.  Returns the
 * address; sets ex_ty/ex_len/ex_clen. */
static int f77_char_ref(int s) {
    int addr;
    int lenv;
    int clen;
    clen = f77_slen[s];
    if (clen >= 0) lenv = f77_iconst(clen);
    else if (f77_slenv[s] >= 0) lenv = f77_slenv[s];
    else { f77_error("CHARACTER length is not known here"); lenv = f77_iconst(1); clen = 1; }
    if (f77_sparam[s]) addr = hi_emit(HI_SADDR, HL_ADDR_TY, -1, -1, f77_spstr[s], NULL);
    else addr = f77_sval[s];
    if (lx_t == T_LP && f77_srank[s] > 0) {
        f77_tok();
        addr = f77_subscript_addr(s);
    }
    if (lx_t == T_LP) return f77_substring(addr, lenv, clen);
    ex_ty = TY_CHAR;
    ex_hi = -1;
    ex_len = lenv;
    ex_clen = clen;
    return addr;
}

/* Call a CHARACTER-valued function: hidden result buffer and length
 * first, then the actuals, then their hidden lengths.  `rlen` is the
 * result length the caller knows. */
static int f77_char_fcall(char *name, int rlen, int *addrs, int *lens, int nargs) {
    int tmp;
    int cb;
    int ai;
    int r;
    int nc;
    if (rlen < 0) {
        f77_error("the length of this CHARACTER function is not known at the call");
        rlen = 1;
    }
    tmp = f77_char_temp(rlen);
    cb = h_ncarg;
    h_carg[h_ncarg] = tmp; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    h_carg[h_ncarg] = f77_iconst(rlen); h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    nc = 2;
    for (ai = 0; ai < nargs; ai++) {
        h_carg[h_ncarg] = addrs[ai]; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
        nc = nc + 1;
    }
    for (ai = 0; ai < nargs; ai++) {
        if (lens[ai] < 0) continue;
        h_carg[h_ncarg] = lens[ai]; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
        nc = nc + 1;
    }
    r = hi_emit(HI_CALL, TY_INT, -1, -1, nc, name);
    h_cbase[r] = cb;
    ex_ty = TY_CHAR;
    ex_hi = -1;
    ex_clen = rlen;
    ex_len = f77_iconst(rlen);
    return tmp;
}

/* fort370: a reference to a FUNCTION of this file, from f77_primary.
 * A function of its own because of its argument arrays: in f77_primary
 * they sat in the frame of every level of a nested expression (FCVS
 * FM045 nests 57 deep), which is what sizes the stack on MVS. */
/* a type's name, for messages */
static char *f77_tyname(int ty, int lg) {
    if (ty == TY_INT) return lg ? "LOGICAL" : "INTEGER";
    if (ty == TY_FLOAT) return "REAL";
    if (ty == TY_DOUBLE) return "DOUBLE PRECISION";
    if (ty == TY_CPLX) return "COMPLEX";
    if (ty == TY_DCPLX) return "COMPLEX*16";
    if (ty == TY_CHAR) return "CHARACTER";
    return "untyped";
}

static int f77_unit_fcall(int u, char *nm) {
    /* FUNCTION reference: by-reference actuals, result in the
     * usual return register (plus its hi word for a double). */
    int cb;
    int nargs;
    int nc;
    int r;
    int rty;
    int addrs[64];
    int lens[64];
    int ai;
    f77_tok();
    nargs = 0;
    if (lx_t == T_LP) {
        f77_tok();
        if (lx_t != T_RP) {
            for (;;) {
                /* Evaluate every actual BEFORE reserving any
                 * h_carg slots: an actual may itself contain a
                 * call, which would otherwise interleave its
                 * arguments with ours. */
                if (nargs < 64) { addrs[nargs] = f77_actual_addr(); lens[nargs] = f77_act_len; }
                else f77_actual_addr();
                nargs = nargs + 1;
                if (lx_t != T_COMMA) break;
                f77_tok();
            }
        }
        if (lx_t != T_RP) f77_error("expected ) after arguments");
        else f77_tok();
    }
    rty = f77_urty_of(u);
    {
        /* fort370: the caller's type for the name, declared or
         * implicit, is the definition's (#21).  The call takes the
         * definition's, so the value was right here, but FORTRAN H,
         * which compiles units apart, reads it by the caller's: the
         * program does not mean what it says. */
        int s;
        int ulog;
        int cty;
        int clog;
        /* looked up, not made: a symbol made here moved the frame */
        s = f77_sym_at(nm, f77_scope_base);
        if (s >= 0) { cty = f77_sty[s]; clog = f77_slog[s]; }
        else {
            cty = f77_implicit_ty(nm);
            clog = (f77_imp_ready && nm[0] >= 'A' && nm[0] <= 'Z') ? f77_imp_log[nm[0] - 'A'] : 0;
        }
        ulog = f77_uentry_parent[u] >= 0 ? f77_urlog[f77_uentry_parent[u]] : f77_urlog[u];
        if (cty >= 0 && (cty != rty || (rty == TY_INT && clog != ulog))) {
            char m[160];
            sprintf(m, "%s is %s here but %s where it is defined (line %d)", nm,
                    f77_tyname(cty, clog), f77_tyname(rty, ulog), f77_uline[u]);
            f77_error(m);
        }
    }
    if (rty == TY_CHAR) {
        int rl;
        rl = f77_urlen[u];
        if (rl < 0) rl = f77_slen[f77_sym(nm)];
        return f77_char_fcall(f77_uname[u], rl, addrs, lens, nargs);
    }
    if (f77_can_inline(u)) {
        /* Splice the body, then read its result variable. */
        int rs;
        rs = f77_inline_unit_body(u, addrs, nargs);
        if (rs >= 0) return f77_load_sym(rs);
        ex_ty = TY_INT;
        return f77_iconst(0);
    }
    cb = h_ncarg;
    nc = 0;
    ai = 0;
    while (ai < nargs) {
        h_carg[h_ncarg] = addrs[ai];
        h_carg_tag[h_ncarg] = 0;
        h_ncarg = h_ncarg + 1;
        nc = nc + 1;
        ai = ai + 1;
    }
    for (ai = 0; ai < nargs; ai++) {
        if (lens[ai] < 0) continue;
        h_carg[h_ncarg] = lens[ai]; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
        nc = nc + 1;
    }
#ifdef F77_NATIVE_F64
    /* a DOUBLE PRECISION result is one value, in FPR0 */
    r = hi_emit(HI_CALL, f77_slotty(rty), -1, -1, nc, f77_uname[u]);
    h_cbase[r] = cb;
    ex_ty = rty;
    ex_log = f77_urlog[u];
    if (f77_iscx(rty))
        ex_hi = hi_emit(HI_CALLHI, f77_cxpart(rty), r, -1, 0, NULL);
    return r;
#else
    r = hi_emit(HI_CALL, rty == TY_DOUBLE ? TY_INT : rty == TY_CPLX ? TY_FLOAT : rty, -1, -1,
                nc, f77_uname[u]);
    h_cbase[r] = cb;
    ex_ty = rty;
    ex_log = f77_urlog[u];
    if (rty == TY_DOUBLE)
        ex_hi = hi_emit(HI_CALLHI, TY_INT, r, -1, 0, NULL);
    else if (rty == TY_CPLX)
        ex_hi = hi_emit(HI_CALLHI, TY_FLOAT, r, -1, 0, NULL);
    return r;
#endif
}

/* fort370: an external function reference or a dummy procedure, from
 * f77_primary; a function of its own for the reason f77_unit_fcall is. */
static int f77_ext_fcall(int s, char *nm) {
    /* Not an array and not a FUNCTION in this file: an
     * external function reference -- or a dummy procedure,
     * called through the address the caller passed. Leaving
     * the ( unconsumed used to drop the rest of the expression
     * (GitHub #20). */
    int cb;
    int nargs;
    int nc;
    int r;
    int addrs[64];
    int lens[64];
    int ai;
    int rty;
    int fptr;
    fptr = (f77_sarg[s] && f77_srank[s] == 0) ? f77_sval[s] : -1;
    nargs = 0;
    f77_tok();
    if (lx_t != T_RP) {
        for (;;) {
            if (nargs < 64) { addrs[nargs] = f77_actual_addr(); lens[nargs] = f77_act_len; }
            else f77_actual_addr();
            nargs = nargs + 1;
            if (lx_t != T_COMMA) break;
            f77_tok();
        }
    }
    if (lx_t != T_RP) f77_error("expected ) after arguments");
    else f77_tok();
    /* The type is the caller's declaration of the name (or the
     * implicit rule): INTEGER IRAND / CHARACTER*8 CDATE. */
    rty = f77_sty[s];
    if (rty == TY_CHAR) return f77_char_fcall(strdup(nm), f77_slen[s], addrs, lens, nargs);
    cb = h_ncarg;
    nc = 0;
    ai = 0;
    while (ai < nargs) {
        h_carg[h_ncarg] = addrs[ai];
        h_carg_tag[h_ncarg] = 0;
        h_ncarg = h_ncarg + 1;
        nc = nc + 1;
        ai = ai + 1;
    }
    for (ai = 0; ai < nargs; ai++) {
        if (lens[ai] < 0) continue;
        h_carg[h_ncarg] = lens[ai]; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
        nc = nc + 1;
    }
    /* nm is this frame's buffer and hi_emit keeps the pointer:
     * the callee's name must outlive the parse (GitHub #20 --
     * the call came out as "EN", whatever the buffer held by
     * codegen time). */
    if (fptr >= 0)
        r = hi_emit(HI_CALLP, f77_ispair(rty) ? f77_pairw(rty) : rty, fptr, -1,
                    nc, NULL);
    else
        r = hi_emit(HI_CALL, f77_ispair(rty) ? f77_pairw(rty) : rty, -1, -1,
                    nc, strdup(nm));
    h_cbase[r] = cb;
    ex_ty = rty;
    ex_log = f77_slog[s];
    ex_hi = -1;
    if (f77_ispair(rty) && rty == TY_DOUBLE) ex_hi = hi_emit(HI_CALLHI, TY_INT, r, -1, 0, NULL);
    else if (f77_iscx(rty)) ex_hi = hi_emit(HI_CALLHI, f77_cxpart(rty), r, -1, 0, NULL);
    return r;
}

static int f77_primary(void) {
    int v;
    int s;
    int save;

    ex_log = 0;
    if (lx_t == T_ICON) { v = f77_iconst(lex_ival); ex_ty = TY_INT; f77_tok(); return v; }
#ifdef F77_NATIVE_F64
    if (lx_t == T_RCON) { v = f77_fconst_text(lex_ftext, TY_FLOAT); ex_ty = TY_FLOAT; f77_tok(); return v; }
    if (lx_t == T_DCON) {
        v = f77_fconst_text(lex_ftext, TY_DOUBLE); ex_hi = -1; ex_ty = TY_DOUBLE; f77_tok(); return v;
    }
#endif
    if (lx_t == T_RCON) { v = f77_rconst(lex_dval); ex_ty = TY_FLOAT; f77_tok(); return v; }
    if (lx_t == T_DCON) {
        v = f77_dconst(lex_dval, &ex_hi); ex_ty = TY_DOUBLE; f77_tok(); return v;
    }
    if (lx_t == T_TRUE)  { v = f77_iconst(1); ex_ty = TY_INT; ex_log = 1; f77_tok(); return v; }
    if (lx_t == T_FALSE) { v = f77_iconst(0); ex_ty = TY_INT; ex_log = 1; f77_tok(); return v; }
    if (lx_t == T_SCON) {
        v = hi_emit(HI_SADDR, HL_ADDR_TY, -1, -1, lex_sidx, NULL);
        ex_ty = TY_CHAR;
        ex_hi = -1;
        ex_clen = lex_slen;
        ex_len = f77_iconst(lex_slen);
        f77_tok();
        return v;
    }
    if (lx_t == T_LP) {
        f77_tok();
        v = f77_expr();
        if (lx_t == T_COMMA) {
            /* (re, im): a COMPLEX constant (F77 takes constants; any
             * real expressions are accepted) */
            int re; int im; int rty; int retype; int rehi; int ct;
            retype = ex_ty; rehi = ex_hi; re = v;
            f77_tok();
            im = f77_expr();
            rty = ex_ty;
            /* fort370: a part in DOUBLE PRECISION makes it COMPLEX*16,
             * as (1.D0, 2.D0) is in IBM's FORTRAN */
            ct = TY_CPLX;
#ifdef F77_NATIVE_F64
            if (retype == TY_DOUBLE || rty == TY_DOUBLE) ct = TY_DCPLX;
#endif
            re = f77_cvt(re, &rehi, retype, f77_cxpart(ct));
            im = f77_cvt(im, &ex_hi, rty, f77_cxpart(ct));
            if (lx_t != T_RP) f77_error("expected ) after complex constant");
            f77_tok();
            ex_ty = ct; ex_hi = im; ex_log = 0;
            return re;
        }
        if (lx_t != T_RP) f77_error("expected )");
        f77_tok();
        return v;
    }
    if (lx_t == T_MINUS) {
        int vhi;
        f77_tok();
        /* Negation binds LOOSER than ** in F77: -X**2 is -(X**2), so
         * the operand is a power, not a primary.  For every other
         * operator the difference is invisible ((-a)*b == -(a*b)),
         * which is how binding at primary level survived until **
         * landed. */
        v = f77_power();
        save = ex_ty;
        vhi = ex_hi;
        if (save == TY_DOUBLE) {
            ex_ty = TY_DOUBLE;
            return f77_fp64_pair1("__fp64_neg", v, vhi, &ex_hi);
        }
        if (f77_iscx(save)) {
            ex_ty = save;
            ex_hi = hi_emit(HI_FNEG, f77_cxpart(save), vhi, -1, 0, NULL);
            return hi_emit(HI_FNEG, f77_cxpart(save), v, -1, 0, NULL);
        }
        if (save == TY_FLOAT) return hi_emit(HI_FNEG, TY_FLOAT, v, -1, 0, NULL);
        return hi_emit(HI_NEG, TY_INT, v, -1, 0, NULL);
    }
    if (lx_t == T_PLUS) { f77_tok(); return f77_power(); }
    if (lx_t == T_NAME) {
        char nm[F77_MAX_NAME];
        int u;
        int in;
        strcpy(nm, lex_name);
        u = f77_find_func(nm);

        /* A statement function of this unit shadows everything. */
        {
            int si;
            si = f77_stf_find(nm);
            if (si >= 0) return f77_stf_expand(si);
        }

        /* Intrinsics, unless a unit in this file defines the name --
         * a user FUNCTION shadows the intrinsic of the same name -- or
         * a dummy argument carries it (FF324(NINT, N) in the FCVS). */
        in = (u < 0) ? f77_intrinsic(nm) : IN_NONE;
        {
            int ds;
            ds = f77_sym_find(nm);
            if (ds >= 0 && (f77_sarg[ds] || f77_sexternal[ds])) in = IN_NONE;
            /* fort370: an intrinsic's name is the intrinsic only where
             * it is referenced as a function; not followed by '(' it is
             * a local variable (INTEGER LEN/30000/), and an array of that
             * name is the array */
            if (in != IN_NONE && !(lx_rp < lx_rpe && *lx_rp == '(')) in = IN_NONE;
            if (in != IN_NONE && ds >= 0 && f77_srank[ds] > 0) in = IN_NONE;
        }
        if (in != IN_NONE) {
            int a; int ahi; int aty;
            int b; int bhi; int bty;
            int rty;
            int qzero_hi;
            qzero_hi = -1;
            f77_tok();
            if (lx_t != T_LP) { f77_error("intrinsic needs arguments"); return f77_iconst(0); }
            f77_tok();
            a = f77_expr(); aty = ex_ty; ahi = ex_hi;

            if (in == IN_AIMAG || in == IN_CONJG || in == IN_CMPLX || in == IN_DCMPLX) {
                if (in == IN_CMPLX || in == IN_DCMPLX) {
                    int im;
                    int ct;
                    ct = in == IN_DCMPLX ? TY_DCPLX : TY_CPLX;
                    if (lx_t == T_COMMA) {
                        a = f77_cvt(a, &ahi, aty, f77_cxpart(ct));
                        f77_tok();
                        im = f77_expr();
                        im = f77_cvt(im, &ex_hi, ex_ty, f77_cxpart(ct));
                    } else {
                        a = f77_cvt(a, &ahi, aty, ct);
                        im = ahi;
                    }
                    if (lx_t == T_RP) f77_tok(); else f77_error("expected )");
                    ex_ty = ct; ex_hi = im; ex_log = 0;
                    return a;
                }
                if (!f77_iscx(aty)) { a = f77_cvt(a, &ahi, aty, TY_CPLX); aty = TY_CPLX; }
                if (lx_t == T_RP) f77_tok(); else f77_error("expected )");
                if (in == IN_AIMAG) { ex_ty = f77_cxpart(aty); ex_hi = -1; return ahi; }
                ex_ty = aty;
                ex_hi = hi_emit(HI_FNEG, f77_cxpart(aty), ahi, -1, 0, NULL);
                return a;
            }
            if (f77_iscx(aty) && (in == IN_ABS || in == IN_SQRT || in == IN_EXP ||
                                  in == IN_LOG || in == IN_SIN || in == IN_COS)) {
                /* CABS and the complex transcendentals: in the runtime;
                 * COMPLEX*16's are f77_z* */
                int args[4];
                int out;
                int z;
                z = aty == TY_DCPLX;
                if (lx_t == T_RP) f77_tok(); else f77_error("expected )");
                if (in == IN_ABS) {
                    args[0] = a; args[1] = ahi;
                    a = f77_call_i(z ? "f77_zabs" : "f77_cabs", 2, args);
                    h_ty[a] = f77_cxpart(aty);
                    ex_ty = f77_cxpart(aty); ex_hi = -1;
                    return a;
                }
                out = f77_char_temp(f77_tysize(aty));
                /* COMPLEX*16's take the doubles first, so that each
                 * is on a doubleword in the parameter list */
                if (z) { args[0] = a; args[1] = ahi; args[2] = out; }
                else { args[0] = out; args[1] = a; args[2] = ahi; }
                if (z)
                    f77_call_i(in == IN_SQRT ? "f77_zsqrt" : in == IN_EXP ? "f77_zexp" :
                               in == IN_LOG ? "f77_zlog" : in == IN_SIN ? "f77_zsin" : "f77_zcos",
                               3, args);
                else
                    f77_call_i(in == IN_SQRT ? "f77_csqrt" : in == IN_EXP ? "f77_cexp" :
                               in == IN_LOG ? "f77_clog" : in == IN_SIN ? "f77_csin" : "f77_ccos",
                               3, args);
                return f77_load_at(out, aty);
            }
            if (!f77_iscx(aty) &&
                (strcmp(nm, "CSQRT") == 0 || strcmp(nm, "CEXP") == 0 || strcmp(nm, "CLOG") == 0 ||
                 strcmp(nm, "CSIN") == 0 || strcmp(nm, "CCOS") == 0 || strcmp(nm, "CABS") == 0)) {
                f77_error("this intrinsic needs a COMPLEX argument");
                return f77_iconst(0);
            }

            if (in >= IN_LEN && in <= IN_LLT) {
                int alen;
                int args[4];
                alen = ex_len;
                if (in == IN_CHAR) {
                    int tmp;
                    a = f77_cvt(a, &ahi, aty, TY_INT);
                    if (lx_t == T_RP) f77_tok(); else f77_error("expected )");
                    tmp = f77_char_temp(1);
                    hi_emit(HI_STORE, TY_CHAR, tmp, a, 0, NULL);
                    ex_ty = TY_CHAR; ex_hi = -1; ex_clen = 1; ex_len = f77_iconst(1);
                    return tmp;
                }
                if (aty != TY_CHAR) { f77_error("this intrinsic needs a CHARACTER argument"); return f77_iconst(0); }
                if (in == IN_LEN) {
                    if (lx_t == T_RP) f77_tok(); else f77_error("expected )");
                    ex_ty = TY_INT; ex_hi = -1;
                    return alen;
                }
                if (in == IN_ICHAR) {
                    if (lx_t == T_RP) f77_tok(); else f77_error("expected )");
                    ex_ty = TY_INT; ex_hi = -1;
                    return hi_emit(HI_LOAD, TY_CHAR | TY_UNSIGNED, a, -1, 0, NULL);
                }
                /* INDEX and the lexical comparisons: two CHARACTER args */
                if (lx_t != T_COMMA) { f77_error("this intrinsic needs two arguments"); return f77_iconst(0); }
                f77_tok();
                b = f77_expr(); bty = ex_ty;
                if (bty != TY_CHAR) { f77_error("this intrinsic needs CHARACTER arguments"); return f77_iconst(0); }
                if (lx_t == T_RP) f77_tok(); else f77_error("expected )");
                args[0] = a; args[1] = alen; args[2] = b; args[3] = ex_len;
                ex_ty = TY_INT; ex_hi = -1;
                if (in == IN_INDEX) return f77_call_i("f77_index", 4, args);
#ifdef F77_TARGET_S370
                /* LGE and its kin compare in ASCII's order (15.10), which on
                 * an EBCDIC machine is not the machine's: the MVS runtime's
                 * f77_lstrcmp translates; the relational operators keep the
                 * native order through f77_strcmp */
                a = f77_call_i("f77_lstrcmp", 4, args);
#else
                a = f77_call_i("f77_strcmp", 4, args);
#endif
                ex_log = 1;
                if (in == IN_LGE) return hi_emit(HI_SGE, TY_INT, a, f77_iconst(0), 0, NULL);
                if (in == IN_LGT) return hi_emit(HI_SGT, TY_INT, a, f77_iconst(0), 0, NULL);
                if (in == IN_LLE) return hi_emit(HI_SLE, TY_INT, a, f77_iconst(0), 0, NULL);
                return hi_emit(HI_SLT, TY_INT, a, f77_iconst(0), 0, NULL);
            }

            if (in == IN_ABS) {
                a = f77_abs(a, aty, &ahi);
                if (lx_t == T_RP) f77_tok(); else f77_error("expected )");
                ex_ty = aty; ex_hi = ahi;
                return a;
            }
            if (in == IN_INT || in == IN_REAL || in == IN_DBLE) {
                rty = (in == IN_INT) ? TY_INT : (in == IN_REAL ? TY_FLOAT : TY_DOUBLE);
                if (in == IN_REAL && aty == TY_DCPLX) rty = TY_DOUBLE;   /* its part, as gfortran's */
                a = f77_cvt(a, &ahi, aty, rty);
                if (lx_t == T_RP) f77_tok(); else f77_error("expected )");
                ex_ty = rty; ex_hi = ahi;
                if (rty == TY_FLOAT) ex_hi = -1;
                return a;
            }
            if (in == IN_SQRT) {
                /* SLOW-32 has FSQRT, but the HI_FSQRT path is only wired
                 * for single-value doubles; the pair form goes through
                 * libm, which the DBT intercepts to a native call. */
                if (lx_t == T_RP) f77_tok(); else f77_error("expected )");
                if (aty == TY_DOUBLE) {
                    /* Inlined by the backend to a single FSQRT.D; the
                     * symbol never reaches the linker. */
                    ex_ty = TY_DOUBLE;
                    return f77_fp64_pair1("__fp64_sqrt", a, ahi, &ex_hi);
                }
                {
                    a = f77_cvt(a, &ahi, aty, TY_FLOAT);
                    ex_ty = TY_FLOAT;
                    return f77_fp64_call1("__fp32_sqrt", a, NULL);
                }
            }

            if (in == IN_AINT || in == IN_ANINT || in == IN_NINT) {
                /* trunc / round by the libm names the DBT intercepts
                 * (math_soft.c has them for the interpreters).  The
                 * D-specific names force the double path; NINT is
                 * ANINT followed by the integer conversion. */
                int dbl;
                char *fn;
                if (lx_t == T_RP) f77_tok(); else f77_error("expected )");
                dbl = (aty == TY_DOUBLE) || (in != IN_NINT && nm[0] == 'D') ||
                      strcmp(nm, "IDNINT") == 0;
                if (dbl) {
                    a = f77_cvt(a, &ahi, aty, TY_DOUBLE);
                    fn = (in == IN_AINT) ? "trunc" : "round";
                    a = f77_libm_d1(fn, a, ahi, &ahi);
                    aty = TY_DOUBLE;
                } else {
                    a = f77_cvt(a, &ahi, aty, TY_FLOAT);
                    fn = (in == IN_AINT) ? "truncf" : "roundf";
                    a = f77_libm_f1(fn, a);
                    aty = TY_FLOAT;
                }
                if (in == IN_NINT) {
                    a = f77_cvt(a, &ahi, aty, TY_INT);
                    aty = TY_INT;
                }
                ex_ty = aty; ex_hi = ahi;
                return a;
            }

            if (in >= IN_SIN && in <= IN_TANH) {
                /* A D-prefixed specific name (DSIN, DATAN2, ...) forces
                 * the double path even for a non-double argument; the
                 * generic names dispatch on the argument's type. */
                int dbl;
                dbl = (aty == TY_DOUBLE) || (nm[0] == 'D');
                if (in == IN_ATAN2) {
                    if (lx_t != T_COMMA) {
                        f77_error("ATAN2 needs two arguments");
                        return f77_iconst(0);
                    }
                    f77_tok();
                    b = f77_expr(); bty = ex_ty; bhi = ex_hi;
                    if (lx_t == T_RP) f77_tok(); else f77_error("expected )");
                    if (dbl || bty == TY_DOUBLE) {
                        a = f77_cvt(a, &ahi, aty, TY_DOUBLE);
                        b = f77_cvt(b, &bhi, bty, TY_DOUBLE);
                        ex_ty = TY_DOUBLE;
                        return f77_libm_d2("atan2", a, ahi, b, bhi, &ex_hi);
                    }
                    a = f77_cvt(a, &ahi, aty, TY_FLOAT);
                    b = f77_cvt(b, &bhi, bty, TY_FLOAT);
                    ex_ty = TY_FLOAT;
                    return f77_libm_f2("atan2f", a, b);
                }
                if (lx_t == T_RP) f77_tok(); else f77_error("expected )");
                if (dbl) {
                    a = f77_cvt(a, &ahi, aty, TY_DOUBLE);
                    ex_ty = TY_DOUBLE;
                    return f77_libm_d1(f77_tr_name(in, 1), a, ahi, &ex_hi);
                }
                a = f77_cvt(a, &ahi, aty, TY_FLOAT);
                ex_ty = TY_FLOAT;
                return f77_libm_f1(f77_tr_name(in, 0), a);
            }

            /* Binary and n-ary forms: MAX/MIN fold pairwise. */
            for (;;) {
                if (lx_t != T_COMMA) break;
                f77_tok();
                b = f77_expr(); bty = ex_ty; bhi = ex_hi;
                rty = f77_balance(&a, &ahi, aty, &b, &bhi, bty);
                if (in == IN_MAX || in == IN_MAX1 || in == IN_AMAX0 ||
                    in == IN_MIN || in == IN_MIN1 || in == IN_AMIN0) {
                    a = f77_minmax(in == IN_MAX || in == IN_MAX1 || in == IN_AMAX0,
                                   a, ahi, b, bhi, rty, &ahi);
                } else if (in == IN_MOD) {
                    if (rty == TY_INT) {
                        a = hi_emit(HI_REM, TY_INT, a, b, 0, NULL);
                    } else {
                        /* a - INT(a/b)*b, in the operands' own type */
                        int q; int qhi; int t;
                        qhi = -1;
                        if (rty == TY_DOUBLE) {
                            q = f77_fp64_call2("__fp64_div", a, ahi, b, bhi, &qhi);
                            t = f77_cvt(q, &qhi, TY_DOUBLE, TY_INT);
                            q = f77_cvt(t, &qhi, TY_INT, TY_DOUBLE);
                            q = f77_fp64_call2("__fp64_mul", q, qhi, b, bhi, &qhi);
                            a = f77_fp64_call2("__fp64_sub", a, ahi, q, qhi, &ahi);
                        } else {
                            q = hi_emit(HI_FDIV, TY_FLOAT, a, b, 0, NULL);
                            t = hi_emit(HI_FCVT_FtoI, TY_INT, q, -1, 0, NULL);
                            q = hi_emit(HI_FCVT_ItoF, TY_FLOAT, t, -1, 0, NULL);
                            q = hi_emit(HI_FMUL, TY_FLOAT, q, b, 0, NULL);
                            a = hi_emit(HI_FSUB, TY_FLOAT, a, q, 0, NULL);
                        }
                    }
                } else if (in == IN_DIM) {
                    /* max(a - b, 0) in the operands' type */
                    int zero;
                    int zhi;
                    zhi = -1;
                    if (rty == TY_DOUBLE) {
                        a = f77_fp64_call2("__fp64_sub", a, ahi, b, bhi, &ahi);
                        zero = f77_dconst(0.0, &zhi);
                    } else if (rty == TY_FLOAT) {
                        a = hi_emit(HI_FSUB, TY_FLOAT, a, b, 0, NULL);
                        zero = f77_rconst(0.0);
                    } else {
                        a = hi_emit(HI_SUB, TY_INT, a, b, 0, NULL);
                        zero = f77_iconst(0);
                    }
                    a = f77_minmax(1, a, ahi, zero, zhi, rty, &ahi);
                } else if (in == IN_DPROD) {
                    a = f77_cvt(a, &ahi, rty, TY_DOUBLE);
                    b = f77_cvt(b, &bhi, rty, TY_DOUBLE);
                    a = f77_fp64_call2("__fp64_mul", a, ahi, b, bhi, &ahi);
                    rty = TY_DOUBLE;
                } else if (in == IN_SIGN) {
                    /* |a| with the sign of b */
                    int neg;
                    a = f77_abs(a, rty, &ahi);
#ifdef F77_NATIVE_F64
                    if (rty == TY_DOUBLE || rty == TY_FLOAT) {
                        if (rty == TY_DOUBLE)
                            neg = f77_fp64_call2("__fp64_lt", b, bhi,
                                                 f77_dconst(0.0, &qzero_hi), qzero_hi, NULL);
                        else
                            neg = hi_emit(HI_FLT, TY_INT, b, f77_rconst(0.0), 0, NULL);
                        a = f77_select(neg, hi_emit(HI_FNEG, rty, a, -1, 0, NULL), a);
                        ahi = -1;
                    } else
#endif
                    if (rty == TY_DOUBLE) {
                        neg = f77_fp64_call2("__fp64_lt", b, bhi,
                                             f77_dconst(0.0, &qzero_hi), qzero_hi, NULL);
                        ahi = f77_select(neg,
                                hi_emit(HI_OR, TY_INT, ahi, f77_iconst(0x80000000), 0, NULL),
                                ahi);
                    } else if (rty == TY_FLOAT) {
                        neg = hi_emit(HI_FLT, TY_INT, b, f77_rconst(0.0), 0, NULL);
                        a = f77_select(neg,
                                hi_emit(HI_OR, TY_INT, a, f77_iconst(0x80000000), 0, NULL), a);
                    } else {
                        neg = hi_emit(HI_SLT, TY_INT, b, f77_iconst(0), 0, NULL);
                        a = f77_select(neg, hi_emit(HI_NEG, TY_INT, a, -1, 0, NULL), a);
                    }
                }
                aty = rty;
            }
            if (lx_t == T_RP) f77_tok(); else f77_error("expected ) after intrinsic");
            if (in == IN_MAX1 || in == IN_MIN1) {
                a = f77_cvt(a, &ahi, aty, TY_INT);
                aty = TY_INT;
            } else if (in == IN_AMAX0 || in == IN_AMIN0) {
                a = f77_cvt(a, &ahi, aty, TY_FLOAT);
                aty = TY_FLOAT;
            }
            ex_ty = aty; ex_hi = ahi;
            return a;
        }

        if (u >= 0 && u != f77_cur_unit) return f77_unit_fcall(u, nm);
        s = f77_sym(nm);
        f77_tok();
        if (f77_sty[s] == TY_CHAR &&
            !(lx_t == T_LP && f77_srank[s] == 0 && !f77_paren_has_colon()))
            return f77_char_ref(s);
        if (f77_sparam[s]) {            /* named constant: fold in place */
            ex_ty = f77_sty[s];
            ex_log = f77_slog[s];
#ifdef F77_NATIVE_F64
            /* fort370: from the PARAMETER's text when it has one */
            if (ex_ty == TY_CPLX) {
                ex_hi = f77_sptext2[s] ? f77_fconst_text(f77_sptext2[s], TY_FLOAT) : f77_rconst(f77_spdval2[s]);
                return f77_sptext[s] ? f77_fconst_text(f77_sptext[s], TY_FLOAT) : f77_rconst(f77_spdval[s]);
            }
            if (ex_ty == TY_DCPLX) {
                int h;
                ex_hi = f77_sptext2[s] ? f77_fconst_text(f77_sptext2[s], TY_DOUBLE) : f77_dconst(f77_spdval2[s], &h);
                return f77_sptext[s] ? f77_fconst_text(f77_sptext[s], TY_DOUBLE) : f77_dconst(f77_spdval[s], &h);
            }
            if (ex_ty == TY_DOUBLE) {
                if (f77_sptext[s]) { ex_hi = -1; return f77_fconst_text(f77_sptext[s], TY_DOUBLE); }
                return f77_dconst(f77_spdval[s], &ex_hi);
            }
            if (ex_ty == TY_FLOAT) return f77_sptext[s] ? f77_fconst_text(f77_sptext[s], TY_FLOAT) : f77_rconst(f77_spdval[s]);
#else
            if (ex_ty == TY_CPLX) { ex_hi = f77_rconst(f77_spdval2[s]); return f77_rconst(f77_spdval[s]); }
            if (ex_ty == TY_DOUBLE) return f77_dconst(f77_spdval[s], &ex_hi);
            if (ex_ty == TY_FLOAT) return f77_rconst(f77_spdval[s]);
#endif
            return f77_iconst(f77_spival[s]);
        }
        if (lx_t == T_LP && f77_srank[s] > 0) {
            int addr;
            f77_tok();
            addr = f77_subscript_addr(s);
            v = f77_load_at(addr, f77_sty[s]);
            ex_log = f77_slog[s];
            return v;
        }
        if (lx_t == T_LP) return f77_ext_fcall(s, nm);
        return f77_load_sym(s);
    }
    f77_error("bad expression");
    ex_ty = TY_INT;
    return f77_iconst(0);
}

/* ** is right-associative in F77.  An INTEGER exponent goes to the
 * runtime's binary-exponentiation helpers (f77_ipow / f77_rpow_i /
 * f77_dpow_i -- real calls, unlike the __fp64_* names the backend
 * inlines, so the arguments carry real ABI tags).  A real exponent
 * is pow / powf, by the libm names the DBT intercepts. */
static int f77_power(void) {
    int a;
    int b;
    int aty;
    int bty;
    int ahi;
    int cb;
    int r;
    a = f77_primary();
    aty = ex_ty;
    ahi = ex_hi;
    if (lx_t == T_POWER) {
        int bhi;
        f77_tok();
        b = f77_power();
        bty = ex_ty;
        bhi = ex_hi;
        if (f77_iscx(aty) || f77_iscx(bty)) {
            /* z**n by repeated squaring, z**w as exp(w log z): both in
             * the runtime, which writes the pair to a frame temporary.
             * COMPLEX*16 if either side is, or the other is DOUBLE. */
            int out;
            int args[6];
            int ct;
            ct = (aty == TY_DCPLX || bty == TY_DCPLX ||
                  (bty == TY_DOUBLE && f77_iscx(aty)) || (aty == TY_DOUBLE && f77_iscx(bty))) ? TY_DCPLX : TY_CPLX;
            a = f77_cvt(a, &ahi, aty, ct);
            out = f77_char_temp(f77_tysize(ct));
            if (bty == TY_INT) {
                if (ct == TY_DCPLX) { args[0] = a; args[1] = ahi; args[2] = b; args[3] = out; }
                else { args[0] = out; args[1] = a; args[2] = ahi; args[3] = b; }
                f77_call_i(ct == TY_DCPLX ? "f77_zpow_i" : "f77_cpow_i", 4, args);
            } else {
                b = f77_cvt(b, &bhi, bty, ct);
                if (ct == TY_DCPLX) { args[0] = a; args[1] = ahi; args[2] = b; args[3] = bhi; args[4] = out; }
                else { args[0] = out; args[1] = a; args[2] = ahi; args[3] = b; args[4] = bhi; }
                f77_call_i(ct == TY_DCPLX ? "f77_zpow_c" : "f77_cpow_c", 5, args);
            }
            return f77_load_at(out, ct);
        }
        if (bty != TY_INT) {
            /* Real exponent: pow / powf, by the libm names the DBT and
             * qemu intercept.  An INTEGER base promotes to the
             * exponent's type (F77: the result is real). */
            if (aty == TY_DOUBLE || bty == TY_DOUBLE) {
                a = f77_cvt(a, &ahi, aty, TY_DOUBLE);
                b = f77_cvt(b, &bhi, bty, TY_DOUBLE);
                ex_ty = TY_DOUBLE;
                return f77_libm_d2("pow", a, ahi, b, bhi, &ex_hi);
            }
            a = f77_cvt(a, &ahi, aty, TY_FLOAT);
            b = f77_cvt(b, &bhi, bty, TY_FLOAT);
            ex_ty = TY_FLOAT;
            return f77_libm_f2("powf", a, b);
        }
        cb = h_ncarg;
        if (aty == TY_DOUBLE) {
#ifdef F77_NATIVE_F64
            h_carg[h_ncarg] = a;   h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
            h_carg[h_ncarg] = b;   h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
            r = hi_emit(HI_CALL, TY_DOUBLE, -1, -1, 2, "f77_dpow_i");
            h_cbase[r] = cb;
            ex_hi = -1;
#else
            h_carg[h_ncarg] = a;   h_carg_tag[h_ncarg] = 1; h_ncarg = h_ncarg + 1;
            h_carg[h_ncarg] = ahi; h_carg_tag[h_ncarg] = 2; h_ncarg = h_ncarg + 1;
            h_carg[h_ncarg] = b;   h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
            r = hi_emit(HI_CALL, TY_INT, -1, -1, 3, "f77_dpow_i");
            h_cbase[r] = cb;
            ex_hi = hi_emit(HI_CALLHI, TY_INT, r, -1, 0, NULL);
#endif
            ex_ty = TY_DOUBLE;
            return r;
        }
        h_carg[h_ncarg] = a; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
        h_carg[h_ncarg] = b; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
        r = hi_emit(HI_CALL, aty == TY_FLOAT ? TY_FLOAT : TY_INT, -1, -1, 2,
                    aty == TY_FLOAT ? "f77_rpow_i" : "f77_ipow");
        h_cbase[r] = cb;
        ex_ty = aty;
        return r;
    }
    ex_ty = aty;
    ex_hi = ahi;
    return a;
}

static int f77_term(void) {
    int a; int b; int aty; int bty; int rty; int ahi; int bhi;
    a = f77_power();
    aty = ex_ty; ahi = ex_hi;
    while (lx_t == T_STAR || lx_t == T_SLASH) {
        int op;
        op = lx_t;
        f77_tok();
        b = f77_power();
        bty = ex_ty; bhi = ex_hi;
        rty = f77_balance(&a, &ahi, aty, &b, &bhi, bty);
        if (f77_iscx(rty)) {
            int t1; int t2; int re; int im; int pt;
            pt = f77_cxpart(rty);
            if (op == T_STAR) {
                /* (ar*br - ai*bi, ar*bi + ai*br) */
                t1 = hi_emit(HI_FMUL, pt, a, b, 0, NULL);
                t2 = hi_emit(HI_FMUL, pt, ahi, bhi, 0, NULL);
                re = hi_emit(HI_FSUB, pt, t1, t2, 0, NULL);
                t1 = hi_emit(HI_FMUL, pt, a, bhi, 0, NULL);
                t2 = hi_emit(HI_FMUL, pt, ahi, b, 0, NULL);
                im = hi_emit(HI_FADD, pt, t1, t2, 0, NULL);
            } else {
                /* in the runtime, in double (f77_cdiv): in float, the
                 * products' roundings cost up to 21 units; COMPLEX*16's
                 * is f77_zdiv */
                int args[5];
                int out;
                out = f77_char_temp(f77_tysize(rty));
                if (rty == TY_DCPLX) { args[0] = a; args[1] = ahi; args[2] = b; args[3] = bhi; args[4] = out; }
                else { args[0] = out; args[1] = a; args[2] = ahi; args[3] = b; args[4] = bhi; }
                f77_call_i(rty == TY_DCPLX ? "f77_zdiv" : "f77_cdiv", 5, args);
                re = f77_load_at(out, rty);
                im = ex_hi;
            }
            a = re; ahi = im;
        }
        else if (rty == TY_DOUBLE)
            a = f77_fp64_call2(op == T_STAR ? "__fp64_mul" : "__fp64_div",
                               a, ahi, b, bhi, &ahi);
        else if (rty == TY_FLOAT)
            a = hi_emit(op == T_STAR ? HI_FMUL : HI_FDIV, TY_FLOAT, a, b, 0, NULL);
        else
            a = hi_emit(op == T_STAR ? HI_MUL : HI_DIV, TY_INT, a, b, 0, NULL);
        aty = rty;
        ex_log = 0;
    }
    ex_ty = aty; ex_hi = ahi;
    return a;
}

static int f77_arith(void) {
    int a; int b; int aty; int bty; int rty; int ahi; int bhi;
    a = f77_term();
    aty = ex_ty; ahi = ex_hi;
    while (lx_t == T_PLUS || lx_t == T_MINUS) {
        int op;
        op = lx_t;
        f77_tok();
        b = f77_term();
        bty = ex_ty; bhi = ex_hi;
        rty = f77_balance(&a, &ahi, aty, &b, &bhi, bty);
        if (f77_iscx(rty)) {
            a = hi_emit(op == T_PLUS ? HI_FADD : HI_FSUB, f77_cxpart(rty), a, b, 0, NULL);
            ahi = hi_emit(op == T_PLUS ? HI_FADD : HI_FSUB, f77_cxpart(rty), ahi, bhi, 0, NULL);
        }
        else if (rty == TY_DOUBLE)
            a = f77_fp64_call2(op == T_PLUS ? "__fp64_add" : "__fp64_sub",
                               a, ahi, b, bhi, &ahi);
        else if (rty == TY_FLOAT)
            a = hi_emit(op == T_PLUS ? HI_FADD : HI_FSUB, TY_FLOAT, a, b, 0, NULL);
        else
            a = hi_emit(op == T_PLUS ? HI_ADD : HI_SUB, TY_INT, a, b, 0, NULL);
        aty = rty;
        ex_log = 0;
    }
    ex_ty = aty; ex_hi = ahi;
    return a;
}

/* Relationals produce an integer 0/1.  The FP comparison set is only
 * FEQ/FLT/FLE, so >, >= and /= are built by swapping operands or
 * inverting the result. */
/* a // b: CHARACTER concatenation into a frame temporary.  Both
 * lengths must be known here (F77 allows an assumed-length operand
 * only on the right of an assignment, which this does not special-case). */
static int f77_concat(void) {
    int a; int b; int aty; int alen; int aclen; int bclen; int tmp; int t;
    a = f77_arith();
    aty = ex_ty; alen = ex_len; aclen = ex_clen;
    while (lx_t == T_CONCAT) {
        f77_tok();
        b = f77_arith();
        if (aty != TY_CHAR || ex_ty != TY_CHAR) {
            f77_error("// needs CHARACTER operands");
            return a;
        }
        bclen = ex_clen;
        if (aclen < 0 || bclen < 0) {
            /* An assumed-length operand: the runtime builds the result
             * in its scratch ring and the length is a run-time sum. */
            int args[4];
            args[0] = a; args[1] = alen; args[2] = b; args[3] = ex_len;
            a = f77_call_i("f77_cat", 4, args);
            alen = hi_emit(HI_ADD, TY_INT, alen, ex_len, 0, NULL);
            aclen = -1;
            continue;
        }
        tmp = f77_char_temp(aclen + bclen);
        f77_char_assign(tmp, f77_iconst(aclen), a, alen);
        t = hi_emit(HI_ADDI, HL_ADDR_TY, tmp, -1, aclen, NULL);
        f77_char_assign(t, f77_iconst(bclen), b, ex_len);
        a = tmp;
        aclen = aclen + bclen;
        alen = f77_iconst(aclen);
    }
    ex_ty = aty; ex_len = alen; ex_clen = aclen;
    if (aty == TY_CHAR) ex_hi = -1;
    return a;
}

static int f77_relat(void) {
    int a; int b; int aty; int bty; int rty; int op; int r; int ahi; int bhi;
    int alen;
    a = f77_concat();
    aty = ex_ty; ahi = ex_hi; alen = ex_len;
    if (lx_t == T_EQ || lx_t == T_NE || lx_t == T_LT ||
        lx_t == T_LE || lx_t == T_GT || lx_t == T_GE) {
        op = lx_t;
        f77_tok();
        b = f77_concat();
        bty = ex_ty; bhi = ex_hi;
        ex_log = 1;
        if (aty == TY_CHAR || bty == TY_CHAR) {
            int args[4];
            if (aty != bty) { f77_error("CHARACTER compared with a numeric"); ex_ty = TY_INT; return f77_iconst(0); }
            args[0] = a; args[1] = alen; args[2] = b; args[3] = ex_len;
            r = f77_call_i("f77_strcmp", 4, args);
            ex_ty = TY_INT; ex_hi = -1;
            if (op == T_EQ) return hi_emit(HI_SEQ, TY_INT, r, f77_iconst(0), 0, NULL);
            if (op == T_NE) return hi_emit(HI_SNE, TY_INT, r, f77_iconst(0), 0, NULL);
            if (op == T_LT) return hi_emit(HI_SLT, TY_INT, r, f77_iconst(0), 0, NULL);
            if (op == T_LE) return hi_emit(HI_SLE, TY_INT, r, f77_iconst(0), 0, NULL);
            if (op == T_GT) return hi_emit(HI_SGT, TY_INT, r, f77_iconst(0), 0, NULL);
            return hi_emit(HI_SGE, TY_INT, r, f77_iconst(0), 0, NULL);
        }
        rty = f77_balance(&a, &ahi, aty, &b, &bhi, bty);
        ex_ty = TY_INT;
        ex_log = 1;
        if (f77_iscx(rty)) {
            int e1; int e2;
            if (op != T_EQ && op != T_NE) { f77_error("COMPLEX operands allow only .EQ. and .NE."); return f77_iconst(0); }
            e1 = hi_emit(HI_FEQ, TY_INT, a, b, 0, NULL);
            e2 = hi_emit(HI_FEQ, TY_INT, ahi, bhi, 0, NULL);
            r = hi_emit(HI_AND, TY_INT, e1, e2, 0, NULL);
            if (op == T_NE) r = hi_emit(HI_NOT, TY_INT, r, -1, 0, NULL);
            return r;
        }
        if (rty == TY_DOUBLE) {
            /* Only eq/lt/le exist; the rest come from swapping the
             * operands or inverting the result. */
            if (op == T_EQ) return f77_fp64_call2("__fp64_eq", a, ahi, b, bhi, NULL);
            if (op == T_NE) {
                r = f77_fp64_call2("__fp64_eq", a, ahi, b, bhi, NULL);
                return hi_emit(HI_NOT, TY_INT, r, -1, 0, NULL);
            }
            if (op == T_LT) return f77_fp64_call2("__fp64_lt", a, ahi, b, bhi, NULL);
            if (op == T_LE) return f77_fp64_call2("__fp64_le", a, ahi, b, bhi, NULL);
            if (op == T_GT) return f77_fp64_call2("__fp64_lt", b, bhi, a, ahi, NULL);
            return f77_fp64_call2("__fp64_le", b, bhi, a, ahi, NULL);
        }
        if (rty == TY_FLOAT) {
            if (op == T_EQ) return hi_emit(HI_FEQ, TY_INT, a, b, 0, NULL);
            if (op == T_NE) {
                r = hi_emit(HI_FEQ, TY_INT, a, b, 0, NULL);
                return hi_emit(HI_NOT, TY_INT, r, -1, 0, NULL);
            }
            if (op == T_LT) return hi_emit(HI_FLT, TY_INT, a, b, 0, NULL);
            if (op == T_LE) return hi_emit(HI_FLE, TY_INT, a, b, 0, NULL);
            if (op == T_GT) return hi_emit(HI_FLT, TY_INT, b, a, 0, NULL);
            return hi_emit(HI_FLE, TY_INT, b, a, 0, NULL);
        }
        if (op == T_EQ) return hi_emit(HI_SEQ, TY_INT, a, b, 0, NULL);
        if (op == T_NE) return hi_emit(HI_SNE, TY_INT, a, b, 0, NULL);
        if (op == T_LT) return hi_emit(HI_SLT, TY_INT, a, b, 0, NULL);
        if (op == T_LE) return hi_emit(HI_SLE, TY_INT, a, b, 0, NULL);
        if (op == T_GT) return hi_emit(HI_SGT, TY_INT, a, b, 0, NULL);
        return hi_emit(HI_SGE, TY_INT, a, b, 0, NULL);
    }
    ex_ty = aty; ex_hi = ahi;
    return a;
}

static int f77_not(void) {
    int v;
    if (lx_t == T_NOT) {
        f77_tok();
        v = f77_not();
        ex_ty = TY_INT;
        ex_log = 1;
        return hi_emit(HI_NOT, TY_INT, v, -1, 0, NULL);
    }
    return f77_relat();
}

static int f77_and(void) {
    int a;
    int b;
    a = f77_not();
    while (lx_t == T_AND) {
        f77_tok();
        b = f77_not();
        a = hi_emit(HI_AND, TY_INT, a, b, 0, NULL);
        ex_ty = TY_INT;
        ex_log = 1;
    }
    return a;
}

static int f77_or(void) {
    int a;
    int b;
    a = f77_and();
    while (lx_t == T_OR) {
        f77_tok();
        b = f77_and();
        a = hi_emit(HI_OR, TY_INT, a, b, 0, NULL);
        ex_ty = TY_INT;
        ex_log = 1;
    }
    return a;
}

/* fort370: how deep expressions may nest.  Each level is a chain of
 * frames (f77_expr down to f77_primary, about 1.2K on MVS), and the
 * stack is sized for this many (__stklen in f77.c): past it the compiler
 * refuses the statement rather than run off the stack.  FCVS FM045 nests
 * 57 deep. */
#define F77_MAX_EXPR_DEPTH 90
static int f77_expr_depth;

static int f77_expr(void) {
    int a;
    int b;
    if (f77_expr_depth >= F77_MAX_EXPR_DEPTH) {
        f77_error("expression nested too deeply");
        while (lx_t != T_EOF) f77_tok();          /* abandon the statement */
        ex_ty = TY_INT;
        return f77_iconst(0);
    }
    f77_expr_depth = f77_expr_depth + 1;
    a = f77_or();
    while (lx_t == T_EQV || lx_t == T_NEQV) {
        int op;
        op = lx_t;
        f77_tok();
        b = f77_or();
        a = hi_emit(HI_XOR, TY_INT, a, b, 0, NULL);
        if (op == T_EQV) a = hi_emit(HI_NOT, TY_INT, a, -1, 0, NULL);
        ex_ty = TY_INT;
        ex_log = 1;
    }
    f77_expr_depth = f77_expr_depth - 1;
    return a;
}

/* --- statement classification --------------------------------------- */

#define S_ASSIGN   1
#define S_IF_BLOCK 2
#define S_IF_LOGIC 3
#define S_DO       4
#define S_KEYWORD  5

/* Does the statement text start with `kw`?  Returns the length matched,
 * or 0.  Blanks are already squeezed, so this is a plain prefix test. */
static int f77_starts(char *kw) {
    int n;
    n = (int)strlen(kw);
    if (lx_stmt_len < n) return 0;
    if (strncmp(lx_stmt, kw, n) != 0) return 0;
    return n;
}

/* The unit terminator is the statement END, exactly. A prefix match
 * swallows ENDIF/ENDFILE and was the slice2 vacuous-pass bug; the
 * inliner still had the prefix form. */
static int f77_is_unit_end(void) {
    return f77_starts("END") && lx_stmt_len == 3;
}

/* Offset of the first `c` at paren depth zero, or -1.  Character
 * constants are skipped so a quoted '=' or ',' cannot fool the
 * classifier. */
static int f77_toplevel(int c, int from) {
    int i;
    int depth;
    i = from;
    depth = 0;
    while (i < lx_stmt_len) {
        if (lx_stmt[i] == '\'') {
            i = i + 1;
            while (i < lx_stmt_len && lx_stmt[i] != '\'') i = i + 1;
            i = i + 1;
            continue;
        }
        if (lx_stmt[i] == '(') depth = depth + 1;
        else if (lx_stmt[i] == ')') depth = depth - 1;
        else if (depth == 0 && lx_stmt[i] == c) return i;
        i = i + 1;
    }
    return -1;
}

/* Offset just past the parenthesised group starting at `open`. */
static int f77_match_paren(int open) {
    int i;
    int depth;
    i = open;
    depth = 0;
    while (i < lx_stmt_len) {
        if (lx_stmt[i] == '\'') {
            i = i + 1;
            while (i < lx_stmt_len && lx_stmt[i] != '\'') i = i + 1;
        } else if (lx_stmt[i] == '(') depth = depth + 1;
        else if (lx_stmt[i] == ')') {
            depth = depth - 1;
            if (depth == 0) return i + 1;
        }
        i = i + 1;
    }
    return lx_stmt_len;
}

static int f77_if_tail;   /* offset of what follows IF(...) */
static int f77_do_body;   /* offset of the DO control text */

static int f77_classify(void) {
    int eq;
    int after;

    if (f77_starts("IF(")) {
        after = f77_match_paren(2);
        f77_if_tail = after;
        if (after >= lx_stmt_len) return S_KEYWORD;      /* malformed */
        if (strncmp(lx_stmt + after, "THEN", 4) == 0 && after + 4 == lx_stmt_len)
            return S_IF_BLOCK;
        if (lx_stmt[after] == '=') return S_ASSIGN;      /* array element IF(..) */
        return S_IF_LOGIC;
    }

    if (f77_starts("DO")) {
        eq = f77_toplevel('=', 2);
        if (eq >= 0 && f77_toplevel(',', eq + 1) >= 0) {
            f77_do_body = 2;
            return S_DO;
        }
    }

    eq = f77_toplevel('=', 0);
    if (eq >= 0) return S_ASSIGN;
    return S_KEYWORD;
}

/* --- statements ------------------------------------------------------ */

static int f77_stop_code;    /* value for the trailing RET */
static int f77_cur_blk_live; /* 0 once the current block has terminated */

/* Re-point the token scanner at an offset inside the statement. */
static void f77_scan_from(int off) {
    lx_rp = lx_stmt + off;
    lx_rpe = lx_stmt + lx_stmt_len;
    lx_rcs = f77_lexer_start;
    lx_ract = 0;
    lx_rts = 0;
    lx_rte = 0;
    f77_tok();
}

static void f77_store_sym(int s, int v, int vty, int vhi) {
    f77_sstored[s] = 1;
    v = f77_cvt(v, &vhi, vty, f77_sty[s]);
    if (f77_sty[s] == TY_DOUBLE || f77_sty[s] == TY_CPLX) {
        int addr4;
        hi_emit(HI_STORE, TY_INT, f77_sval[s], v, 0, NULL);
        addr4 = hi_emit(HI_ADDI, HL_ADDR_TY, f77_sval[s], -1, 4, NULL);
        hi_emit(HI_STORE, TY_INT, addr4, vhi, 0, NULL);
        return;
    }
    hi_emit(HI_STORE, f77_sty[s], f77_sval[s], v, 0, NULL);
}

/* Start a new block and make it current. */
static void f77_begin_blk(int b) {
    hl_switch_block(b);
    f77_cur_blk_live = 1;
    f77_nk = 0;
    f77_kblk = b;
}

static void f77_goto_blk(int b) {
    if (f77_cur_blk_live) hi_emit(HI_BR, TY_VOID, -1, -1, b, NULL);
    f77_cur_blk_live = 0;
}

#ifdef F77_NATIVE_F64
/* cond ? a : b for a native floating value: each arm stores its value
 * to a temporary the join reloads; mem2reg turns that into a phi. */
static int f77_select_fp(int cond, int a, int b) {
    int ty;
    int tmp;
    int bt;
    int bf;
    int bj;
    ty = h_ty[a];
    f77_frame = f77_frame + 8;
    tmp = hi_emit(HI_ALLOCA, ty, -1, -1, 0 - f77_frame, NULL);
    if (hl_nalloca < HL_MAX_ALLOCA) {
        hl_ainst[hl_nalloca] = tmp;
        hl_aoff[hl_nalloca] = 0 - f77_frame;
        hl_nalloca = hl_nalloca + 1;
    }
    bt = hir_new_block();
    bf = hir_new_block();
    bj = hir_new_block();
    hi_emit(HI_BRC, TY_VOID, cond, bt, bf, NULL);
    f77_begin_blk(bt);
    hi_emit(HI_STORE, ty, tmp, a, 0, NULL);
    f77_goto_blk(bj);
    f77_begin_blk(bf);
    hi_emit(HI_STORE, ty, tmp, b, 0, NULL);
    f77_goto_blk(bj);
    f77_begin_blk(bj);
    return hi_emit(HI_LOAD, ty, tmp, -1, 0, NULL);
}
#endif

static void f77_stmt_assign(void) {
    int s;
    int v;
    int vty;
    int addr;
    f77_scan_from(0);
    if (lx_t != T_NAME) { f77_error("expected variable on the left of ="); return; }
    s = f77_sym(lex_name);
    if (f77_sparam[s]) { f77_error("cannot assign to a PARAMETER"); return; }
    f77_tok();
    if (f77_sty[s] == TY_CHAR) {
        int dlen;
        addr = f77_char_ref(s);
        dlen = ex_len;
        if (lx_t != T_ASSIGN) { f77_error("expected ="); return; }
        f77_tok();
        v = f77_expr();
        if (ex_ty != TY_CHAR) { f77_error("a CHARACTER variable needs a CHARACTER value"); return; }
        f77_sstored[s] = 1;
        f77_char_assign(addr, dlen, v, ex_len);
        return;
    }
    addr = f77_sval[s];
    if (lx_t == T_LP && f77_srank[s] > 0) {
        f77_tok();
        addr = f77_subscript_addr(s);
    }
    if (lx_t != T_ASSIGN) { f77_error("expected ="); return; }
    f77_tok();
    v = f77_expr();
    vty = ex_ty;
    if (addr == f77_sval[s] && f77_srank[s] == 0)
        f77_store_sym_val(s, v, vty, ex_hi);
    else
        f77_store_at(addr, f77_sty[s], v, vty, ex_hi);
}

static int f77_stf_find(char *nm) {
    int i;
    for (i = 0; i < f77_stf_n; i++)
        if (strcmp(f77_sname[f77_stf_sym[i]], nm) == 0) return i;
    return -1;
}

/* Is this S_ASSIGN statement a statement-function definition?  Shape:
 * an identifier, a parenthesised list ending exactly at the =, and a
 * name that is not an array (an array element assignment has the same
 * shape).  Records it and returns 1; returns 0 to let the assignment
 * path have it. */
static int f77_stf_define(void) {
    int i;
    int eq;
    int s;
    int n;
    int len;
    char nm[F77_MAX_NAME];

    i = 0;
    while (i < lx_stmt_len && (lx_isalpha(lx_stmt[i]) || lx_isdigit(lx_stmt[i]))) i = i + 1;
    if (i == 0 || i >= F77_MAX_NAME || i >= lx_stmt_len || lx_stmt[i] != '(') return 0;
    eq = f77_toplevel('=', 0);
    if (eq < 0 || f77_match_paren(i) != eq) return 0;
    memcpy(nm, lx_stmt, i);
    nm[i] = 0;
    s = f77_sym(nm);
    if (f77_srank[s] > 0 || f77_sarg[s] || f77_sparam[s]) return 0;
    if (f77_sty[s] == TY_CHAR) {
        /* C(1:3) = ... is a substring assignment, not a definition. */
        int k;
        int depth;
        depth = 0;
        for (k = i; k < eq; k++) {
            if (lx_stmt[k] == '(') depth = depth + 1;
            else if (lx_stmt[k] == ')') depth = depth - 1;
            else if (lx_stmt[k] == ':' && depth == 1) return 0;
        }
    }
    if (!f77_decls_open && f77_inline_depth == 0) return 0;
    if (f77_stf_n >= F77_MAX_STF) { f77_error("too many statement functions"); return 1; }

    f77_scan_from(i + 1);
    n = 0;
    while (lx_t == T_NAME) {
        if (n < F77_MAX_STF_ARGS) {
            strcpy(f77_stf_arg[f77_stf_n][n], lex_name);
            f77_stf_argty[f77_stf_n][n] = f77_sty[f77_sym(lex_name)];
        }
        n = n + 1;
        f77_tok();
        if (lx_t != T_COMMA) break;
        f77_tok();
    }
    if (lx_t != T_RP) { f77_error("bad statement function dummy list"); return 1; }
    if (n > F77_MAX_STF_ARGS) { f77_error("too many statement function dummies"); return 1; }

    len = lx_stmt_len - (eq + 1);
    if (f77_stf_pool_n + len + 1 > F77_STF_POOL) { f77_error("statement function pool overflow"); return 1; }
    memcpy(f77_stf_pool + f77_stf_pool_n, lx_stmt + eq + 1, len);
    memcpy(f77_stf_pbrk + f77_stf_pool_n, lx_brk + eq + 1, len);
    f77_stf_sym[f77_stf_n] = s;
    f77_stf_nargs[f77_stf_n] = n;
    f77_stf_text[f77_stf_n] = f77_stf_pool_n;
    f77_stf_len[f77_stf_n] = len;
    f77_stf_pool_n = f77_stf_pool_n + len + 1;
    f77_stf_n = f77_stf_n + 1;
    lx_t = T_EOF;            /* the body is kept as text, parsed where it is used */
    return 1;
}

/* Reference: NAME(a1, ...) with the scanner on NAME. */
static int f77_stf_expand(int si) {
    int n;
    int k;
    int v;
    int vty;
    int vhi;
    int fs;
    int targs[F77_MAX_STF_ARGS];
    char *save_stmt;                 /* fort370: on the heap, not in the frame: */
    unsigned char *save_brk;         /* this nests (16K a level on the stack) */
    int save_len;
    char *save_rp; char *save_rpe; char *save_rts; char *save_rte;
    int save_rcs; int save_ract;
    int save_t;
    char save_name[F77_MAX_NAME];
    int save_namelen;
    int save_ival;
    double save_dval;
    char save_ftext[128];
    int save_sidx;
    int save_slen;

    f77_tok();
    if (lx_t != T_LP) { f77_error("statement function needs arguments"); return f77_iconst(0); }
    f77_tok();
    n = 0;
    if (lx_t != T_RP) {
        for (;;) {
            v = f77_expr(); vty = ex_ty; vhi = ex_hi;
            if (n < f77_stf_nargs[si]) {
                targs[n] = f77_sym_temp(f77_stf_argty[si][n]);
                f77_store_sym_val(targs[n], v, vty, vhi);
            }
            n = n + 1;
            if (lx_t != T_COMMA) break;
            f77_tok();
        }
    }
    if (lx_t != T_RP) f77_error("expected ) after statement function arguments");
    else f77_tok();
    if (n != f77_stf_nargs[si]) {
        f77_error("wrong number of statement function arguments");
        return f77_iconst(0);
    }
    if (f77_stfb_n + n > F77_MAX_STFB) { f77_error("statement functions nested too deep"); return f77_iconst(0); }

    /* Checkpoint the statement and scanner, swap the definition in. */
    save_stmt = (char *)malloc(F77_MAX_STMT);
    save_brk = (unsigned char *)malloc(F77_MAX_STMT);
    if (!save_stmt || !save_brk) { f77_error("out of storage"); return f77_iconst(0); }
    memcpy(save_stmt, lx_stmt, lx_stmt_len + 1);
    memcpy(save_brk, lx_brk, lx_stmt_len);
    save_len = lx_stmt_len;
    save_rp = lx_rp; save_rpe = lx_rpe; save_rts = lx_rts; save_rte = lx_rte;
    save_rcs = lx_rcs; save_ract = lx_ract;
    save_t = lx_t;
    memcpy(save_name, lex_name, F77_MAX_NAME);
    save_namelen = lex_namelen;
    save_ival = lex_ival; save_dval = lex_dval; strcpy(save_ftext, lex_ftext);
    save_sidx = lex_sidx; save_slen = lex_slen;

    memcpy(lx_stmt, f77_stf_pool + f77_stf_text[si], f77_stf_len[si]);
    memcpy(lx_brk, f77_stf_pbrk + f77_stf_text[si], f77_stf_len[si]);
    lx_stmt_len = f77_stf_len[si];
    lx_stmt[lx_stmt_len] = 0;
    for (k = 0; k < n; k++) {
        strcpy(f77_stfb_name[f77_stfb_n], f77_stf_arg[si][k]);
        f77_stfb_sym[f77_stfb_n] = targs[k];
        f77_stfb_n = f77_stfb_n + 1;
    }
    f77_scan_from(0);
    v = f77_expr(); vty = ex_ty; vhi = ex_hi;
    if (lx_t != T_EOF) f77_error("junk after statement function expression");
    f77_stfb_n = f77_stfb_n - n;

    memcpy(lx_stmt, save_stmt, save_len + 1);
    memcpy(lx_brk, save_brk, save_len);
    lx_stmt_len = save_len;
    lx_rp = save_rp; lx_rpe = save_rpe; lx_rts = save_rts; lx_rte = save_rte;
    lx_rcs = save_rcs; lx_ract = save_ract;
    lx_t = save_t;
    memcpy(lex_name, save_name, F77_MAX_NAME);
    lex_namelen = save_namelen;
    lex_ival = save_ival; lex_dval = save_dval; strcpy(lex_ftext, save_ftext);
    lex_sidx = save_sidx; lex_slen = save_slen;

    fs = f77_stf_sym[si];
    v = f77_cvt(v, &vhi, vty, f77_sty[fs]);
    ex_ty = f77_sty[fs];
    ex_log = f77_slog[fs];
    ex_hi = vhi;
    free(save_stmt);
    free(save_brk);
    return v;
}

/* ASSIGN label TO var -- the label number is the variable's value. */
static void f77_stmt_assign_label(int skip) {
    int lab;
    int s;
    f77_scan_from(skip);
    if (lx_t != T_ICON) { f77_error("ASSIGN needs a statement label"); return; }
    lab = lex_ival;
    f77_tok();
    /* Blanks are gone: "TO M" arrives as the one name TOM. */
    if (lx_t != T_NAME || lex_name[0] != 'T' || lex_name[1] != 'O') {
        f77_error("ASSIGN needs TO");
        return;
    }
    if (lex_name[2] == 0) {
        f77_tok();
        if (lx_t != T_NAME) { f77_error("ASSIGN needs a variable"); return; }
        s = f77_sym(lex_name);
    } else {
        s = f77_sym(lex_name + 2);
    }
    f77_tok();
    f77_store_sym_val(s, f77_iconst(lab), TY_INT, -1);
}

/* A FORMAT named by an ASSIGNed variable: pick the format text at run
 * time by comparing the value against every FORMAT label of the unit
 * (a branchless select chain -- the unit has a handful). */
static int f77_fmt_dyn;

/* The unit of a WRITE/READ control list.  A CHARACTER entity makes it
 * an internal file: f77_io_int is set with the record length and count
 * (an unsubscripted CHARACTER array is one record per element). */
static int f77_io_int;
static int f77_io_int_len;
static int f77_io_int_nrec;
static int f77_io_unf;         /* unformatted statement in progress */
static int f77_io_unit_expr(void) {
    int v;
    int nrec;
    nrec = 1;
    f77_io_int = 0;
    if (lx_t == T_NAME) {
        int us;
        int after;
        us = f77_sym(lex_name);
        after = (int)(lx_rte - lx_stmt);
        if (f77_sty[us] == TY_CHAR && f77_srank[us] > 0 &&
            (after >= lx_stmt_len || lx_stmt[after] != '('))
            nrec = f77_sym_nelem(us);
    }
    v = f77_expr();
    if (ex_ty == TY_CHAR) {
        f77_io_int = 1;
        f77_io_int_len = ex_len;
        f77_io_int_nrec = f77_iconst(nrec);
        return v;
    }
    return f77_cvt(v, &ex_hi, ex_ty, TY_INT);
}

static int f77_fmt_dyn_addr(int v) {
    int i;
    int acc;
    int c;
    int fa;
    acc = f77_iconst(0);
    for (i = 0; i < f77_nformat; i++) {
        if (f77_funit[i] != f77_cur_unit) continue;
        fa = hi_emit(HI_SADDR, HL_ADDR_TY, -1, -1, f77_fstr[i], NULL);
        c = hi_emit(HI_SEQ, TY_INT, v, f77_iconst(f77_flabel[i]), 0, NULL);
        acc = f77_select(c, fa, acc);
    }
    return acc;
}

/* A dimension bound: a signed integer constant.  F77 allows constant
 * expressions here; only literals and negation are accepted so far. */
static void f77_cexpr(void);
static int    f77_cx_ty;
static int    f77_cx_i;
static int f77_dim_bound(void) {
    f77_cexpr();
    if (f77_cx_ty != TY_INT) { f77_error("dimension bound must be an integer constant"); return 1; }
    return f77_cx_i;
}

/* --- constant expressions (PARAMETER, DATA, dimension bounds) --------
 *
 * Evaluated at compile time on the host -- f77 is a cross-compiler in
 * the ordinary universe, so host doubles are the sanctioned tool.  The
 * value is carried as (type, ival, dval): integer arithmetic stays
 * exact in ival, anything real is done in dval, and mixed operands
 * promote the usual way. */
static int    f77_cx_ty;
static int    f77_cx_i;
static double f77_cx_d;
static int    f77_cx_sidx;   /* TY_CHAR: string index; f77_cx_i is the length */
static double f77_cx_d2;     /* TY_CPLX: the imaginary part (f77_cx_d is the real) */
/* fort370: the value's decimal text, when it is one: a literal (possibly
 * signed) or an integer, "" after real arithmetic.  A floating constant
 * is converted to HFP from text (s370_hfp.h); through a host double it
 * would depend on the host's floating point and its printf, and the
 * compiler on MVS, whose doubles are HFP and whose printf is inexact,
 * would not emit what the compiler on a host emits. */
static char   f77_cx_t[64];
static char   f77_cx_t2[64];  /* TY_CPLX: the imaginary part's */
static void f77_cx_settext(char *t, const char *v) {
    int n;
    n = (int)strlen(v);
    if (n >= 63) { t[0] = 0; return; }     /* too long to keep: the double serves */
    memcpy(t, v, (size_t)n + 1);
}
static void f77_cx_negtext(char *t) {
    int n;
    if (!t[0]) return;
    if (t[0] == '-') { memmove(t, t + 1, strlen(t)); return; }
    if (t[0] == '+') { t[0] = '-'; return; }
    n = (int)strlen(t);
    if (n >= 62) { t[0] = 0; return; }
    memmove(t + 1, t, (size_t)n + 1);
    t[0] = '-';
}
/* After arithmetic: an integer result has exact text, a real one none. */
static void f77_cx_arith_text(void) {
    if (f77_cx_ty == TY_INT) sprintf(f77_cx_t, "%d", f77_cx_i);
    else f77_cx_t[0] = 0;
    f77_cx_t2[0] = 0;
}
#define F77_MAX_CXB 8
static char f77_cxb_name[F77_MAX_CXB][F77_MAX_NAME];
static int  f77_cxb_val[F77_MAX_CXB];
static int  f77_cxb_n;

static void f77_cexpr(void);

static void f77_cpower(void);
static void f77_cprimary(void) {
    if (lx_t == T_SCON) {
        f77_cx_ty = TY_CHAR; f77_cx_sidx = lex_sidx; f77_cx_i = lex_slen; f77_cx_d = 0.0;
        f77_cx_t[0] = 0; f77_cx_t2[0] = 0;
        f77_tok();
        return;
    }
    f77_cx_t[0] = 0; f77_cx_t2[0] = 0;
    if (lx_t == T_ICON) { f77_cx_ty = TY_INT; f77_cx_i = lex_ival; f77_cx_d = (double)lex_ival; sprintf(f77_cx_t, "%d", lex_ival); f77_tok(); return; }
    if (lx_t == T_RCON) { f77_cx_ty = TY_FLOAT; f77_cx_d = lex_dval; f77_cx_i = (int)lex_dval; f77_cx_settext(f77_cx_t, lex_ftext); f77_tok(); return; }
    if (lx_t == T_DCON) { f77_cx_ty = TY_DOUBLE; f77_cx_d = lex_dval; f77_cx_i = (int)lex_dval; f77_cx_settext(f77_cx_t, lex_ftext); f77_tok(); return; }
    if (lx_t == T_TRUE)  { f77_cx_ty = TY_INT; f77_cx_i = 1; f77_cx_d = 1.0; f77_tok(); return; }
    if (lx_t == T_FALSE) { f77_cx_ty = TY_INT; f77_cx_i = 0; f77_cx_d = 0.0; f77_tok(); return; }
    if (lx_t == T_LP) {
        f77_tok();
        f77_cexpr();
        if (lx_t == T_COMMA) {
            double re;
            char ret[64];
            int rety;
            re = f77_cx_d;
            rety = f77_cx_ty;
            strcpy(ret, f77_cx_t);
            f77_tok();
            f77_cexpr();
            if (lx_t != T_RP) { f77_error("expected ) after complex constant"); return; }
            f77_tok();
            f77_cx_d2 = f77_cx_d;
            strcpy(f77_cx_t2, f77_cx_t);
            strcpy(f77_cx_t, ret);
            f77_cx_d = re;
#ifdef F77_NATIVE_F64
            f77_cx_ty = (rety == TY_DOUBLE || f77_cx_ty == TY_DOUBLE) ? TY_DCPLX : TY_CPLX;
#else
            f77_cx_ty = TY_CPLX;
#endif
            f77_cx_i = (int)re;
            return;
        }
        if (lx_t != T_RP) { f77_error("expected ) in constant expression"); return; }
        f77_tok();
        return;
    }
    if (lx_t == T_MINUS) {
        f77_tok();
        f77_cpower();                    /* -2**2 is -(2**2) */
        f77_cx_i = 0 - f77_cx_i;
        f77_cx_d = 0.0 - f77_cx_d;
        if (f77_cx_ty == TY_INT) sprintf(f77_cx_t, "%d", f77_cx_i);
        else if (f77_iscx(f77_cx_ty)) { f77_cx_d2 = 0.0 - f77_cx_d2; f77_cx_negtext(f77_cx_t); f77_cx_negtext(f77_cx_t2); }
        else f77_cx_negtext(f77_cx_t);
        return;
    }
    if (lx_t == T_PLUS) { f77_tok(); f77_cpower(); return; }
    if (lx_t == T_NAME) {
        int s;
        int b;
        for (b = f77_cxb_n - 1; b >= 0; b--) {
            if (strcmp(f77_cxb_name[b], lex_name) == 0) {
                f77_cx_ty = TY_INT; f77_cx_i = f77_cxb_val[b]; f77_cx_d = (double)f77_cx_i;
                sprintf(f77_cx_t, "%d", f77_cx_i);
                f77_tok();
                return;
            }
        }
        s = f77_sym(lex_name);
        if (f77_sparam[s] && f77_sty[s] == TY_CHAR) {
            f77_cx_ty = TY_CHAR; f77_cx_sidx = f77_spstr[s]; f77_cx_i = f77_slen[s]; f77_cx_d = 0.0;
            f77_tok();
            return;
        }
        if (!f77_sparam[s]) {
            f77_error("only PARAMETER constants may appear in a constant expression");
            f77_cx_ty = TY_INT; f77_cx_i = 1; f77_cx_d = 1.0;
            f77_tok();
            return;
        }
        f77_cx_ty = f77_sty[s];
        f77_cx_i = f77_spival[s];
        f77_cx_d = f77_spdval[s];
        if (f77_iscx(f77_cx_ty)) f77_cx_d2 = f77_spdval2[s];
        if (f77_cx_ty == TY_INT) sprintf(f77_cx_t, "%d", f77_cx_i);
        else {
            if (f77_sptext[s]) strcpy(f77_cx_t, f77_sptext[s]);
            if (f77_sptext2[s]) strcpy(f77_cx_t2, f77_sptext2[s]);
        }
        f77_tok();
        return;
    }
    f77_error("bad constant expression");
    f77_cx_ty = TY_INT; f77_cx_i = 1; f77_cx_d = 1.0;
}

/* fort370: ** in a constant expression, right-associative; F77 (6.1.2,
 * 7.1.2) lets a constant expression raise to an INTEGER power only, so
 * it is repeated multiplication.  It was refused: PARAMETER (N =
 * 2**10) said "expected ) after PARAMETER list". */
static void f77_cpower(void) {
    int bty;
    int bi;
    double bd;
    double bd2;
    int n;
    int k;
    f77_cprimary();
    if (lx_t != T_POWER) return;
    bty = f77_cx_ty; bi = f77_cx_i; bd = f77_cx_d; bd2 = f77_iscx(bty) ? f77_cx_d2 : 0.0;
    f77_tok();
    f77_cpower();
    if (f77_cx_ty != TY_INT) {
        f77_error("a constant expression raises to an INTEGER power only");
        f77_cx_ty = bty; f77_cx_i = bi; f77_cx_d = bd; f77_cx_d2 = bd2;
        return;
    }
    n = f77_cx_i;
    f77_cx_ty = bty;
    if (bty == TY_INT) {
        int r;
        if (n < 0) {
            if (bi == 0) { f77_error("zero to a negative power in constant expression"); r = 0; }
            else r = (bi == 1) ? 1 : (bi == -1) ? ((-n) % 2 ? -1 : 1) : 0;
        } else {
            r = 1;
            for (k = 0; k < n; k++) r = r * bi;
        }
        f77_cx_i = r;
        f77_cx_d = (double)r;
    } else if (f77_iscx(bty)) {
        double rr; double ri; double t;
        rr = 1.0; ri = 0.0;
        for (k = 0; k < (n < 0 ? -n : n); k++) { t = rr * bd - ri * bd2; ri = rr * bd2 + ri * bd; rr = t; }
        if (n < 0) {
            double den;
            den = rr * rr + ri * ri;
            if (den == 0.0) { f77_error("zero to a negative power in constant expression"); den = 1.0; }
            rr = rr / den; ri = 0.0 - ri / den;
        }
        f77_cx_d = rr; f77_cx_d2 = ri; f77_cx_i = (int)rr;
    } else {
        double r;
        r = 1.0;
        for (k = 0; k < (n < 0 ? -n : n); k++) r = r * bd;
        if (n < 0) {
            if (r == 0.0) { f77_error("zero to a negative power in constant expression"); r = 1.0; }
            r = 1.0 / r;
        }
        f77_cx_d = r; f77_cx_i = (int)r;
    }
    f77_cx_arith_text();
}

static int f77_cx_promote(int a, int b) {
    if (a == TY_DCPLX || b == TY_DCPLX) return TY_DCPLX;
    if (f77_iscx(a) || f77_iscx(b)) return (a == TY_DOUBLE || b == TY_DOUBLE) ? TY_DCPLX : TY_CPLX;
    if (a == TY_DOUBLE || b == TY_DOUBLE) return TY_DOUBLE;
    if (a == TY_FLOAT || b == TY_FLOAT) return TY_FLOAT;
    return TY_INT;
}

static void f77_cterm(void) {
    int ty; int iv; double dv; int mul; double d2v;
    f77_cpower();
    for (;;) {
        if (lx_t == T_STAR) mul = 1;
        else if (lx_t == T_SLASH) mul = 0;
        else return;
        ty = f77_cx_ty; iv = f77_cx_i; dv = f77_cx_d;
        d2v = f77_iscx(ty) ? f77_cx_d2 : 0.0;
        f77_tok();
        f77_cpower();
        if (f77_iscx(ty) || f77_iscx(f77_cx_ty)) {
            /* fort370: both parts (#11); the evaluator took the real
             * parts alone, and (1,2)*(3,4) came out (3,4) */
            double br; double bi; double re; double im;
            br = f77_cx_d;
            bi = f77_iscx(f77_cx_ty) ? f77_cx_d2 : 0.0;
            f77_cx_ty = f77_cx_promote(ty, f77_cx_ty);
            if (mul) {
                re = dv * br - d2v * bi;
                im = dv * bi + d2v * br;
            } else {
                double den;
                den = br * br + bi * bi;
                if (den == 0.0) { f77_error("division by zero in constant expression"); den = 1.0; }
                re = (dv * br + d2v * bi) / den;
                im = (d2v * br - dv * bi) / den;
            }
            f77_cx_d = re;
            f77_cx_d2 = im;
            f77_cx_i = (int)re;
            f77_cx_arith_text();
            continue;
        }
        f77_cx_ty = f77_cx_promote(ty, f77_cx_ty);
        if (mul) {
            f77_cx_i = iv * f77_cx_i;
            f77_cx_d = dv * f77_cx_d;
        } else if (f77_cx_ty == TY_INT) {
            if (f77_cx_i == 0) { f77_error("division by zero in constant expression"); f77_cx_i = 1; }
            f77_cx_i = iv / f77_cx_i;
        } else {
            if (f77_cx_d == 0.0) { f77_error("division by zero in constant expression"); f77_cx_d = 1.0; }
            f77_cx_d = dv / f77_cx_d;
        }
        if (f77_cx_ty == TY_INT) f77_cx_d = (double)f77_cx_i;
        else f77_cx_i = (int)f77_cx_d;
        f77_cx_arith_text();
    }
}

static void f77_cexpr(void) {
    int ty; int iv; double dv; int add; double d2v;
    f77_cterm();
    for (;;) {
        if (lx_t == T_PLUS) add = 1;
        else if (lx_t == T_MINUS) add = 0;
        else return;
        ty = f77_cx_ty; iv = f77_cx_i; dv = f77_cx_d;
        d2v = f77_iscx(ty) ? f77_cx_d2 : 0.0;
        f77_tok();
        f77_cterm();
        if (f77_iscx(ty) || f77_iscx(f77_cx_ty)) {
            double bi;
            bi = f77_iscx(f77_cx_ty) ? f77_cx_d2 : 0.0;
            f77_cx_ty = f77_cx_promote(ty, f77_cx_ty);
            f77_cx_d = add ? dv + f77_cx_d : dv - f77_cx_d;
            f77_cx_d2 = add ? d2v + bi : d2v - bi;
            f77_cx_i = (int)f77_cx_d;
            f77_cx_arith_text();
            continue;
        }
        f77_cx_ty = f77_cx_promote(ty, f77_cx_ty);
        if (add) { f77_cx_i = iv + f77_cx_i; f77_cx_d = dv + f77_cx_d; }
        else     { f77_cx_i = iv - f77_cx_i; f77_cx_d = dv - f77_cx_d; }
        if (f77_cx_ty == TY_INT) f77_cx_d = (double)f77_cx_i;
        else f77_cx_i = (int)f77_cx_d;
        f77_cx_arith_text();
    }
}

/* One dimension bound: `*` (assumed size), a non-PARAMETER name (an
 * adjustable dimension), or a constant expression -- which is where a
 * PARAMETER bound like A(N) or A(2*N+1) resolves. */
/* One dimension bound.  A constant expression gives its value; `*` is
 * an assumed size; an expression naming anything that is not a
 * PARAMETER (a dummy, say: A(LDA, 2*N+1)) is an adjustable bound,
 * evaluated here in the declaration part -- the entry block, which
 * dominates every subscript -- and returned through *val. */
static int f77_bound(int *val) {
    int i;
    int depth;
    int runtime;
    *val = -1;
    if (lx_t == T_STAR) { f77_tok(); return 1; }   /* assumed size */
    runtime = 0;
    i = (int)(lx_rts - lx_stmt);
    depth = 0;
    while (i < lx_stmt_len) {
        int c;
        c = lx_stmt[i];
        if (c == '(') depth = depth + 1;
        else if (c == ')') { if (depth == 0) break; depth = depth - 1; }
        else if ((c == ',' || c == ':') && depth == 0) break;
        if (lx_isalpha(c)) {
            char nm[F77_MAX_NAME];
            int j;
            int sf;
            j = i;
            while (j < lx_stmt_len && (lx_isalpha(lx_stmt[j]) || lx_isdigit(lx_stmt[j]))) j = j + 1;
            if (j - i < F77_MAX_NAME) {
                memcpy(nm, lx_stmt + i, j - i);
                nm[j - i] = 0;
                sf = f77_sym_find(nm);
                if (sf < 0 || !f77_sparam[sf]) runtime = 1;
            }
            i = j;
            continue;
        }
        i = i + 1;
    }
    if (runtime) {
        int v;
        v = f77_expr();
        *val = f77_cvt(v, &ex_hi, ex_ty, TY_INT);
        return 1;
    }
    f77_cexpr();
    if (f77_cx_ty != TY_INT) { f77_error("dimension bound must be an integer constant"); return 1; }
    return f77_cx_i;
}

/* Parse `(d1[,d2...])` after a name, each dimension `[lo:]hi`. */
static void f77_parse_dims(int s) {
    int rank;
    int lo;
    int hi;
    int losym;
    int hisym;
    rank = 0;
    if (f77_slo[s] == f77_dlo[0]) {  /* fort370: its own row of bounds */
        if (f77_narr >= F77_MAX_ARR) { f77_error("too many arrays"); return; }
        f77_dim_row(s, f77_narr);
        f77_narr = f77_narr + 1;
    }
    f77_tok();                       /* past ( */
    for (;;) {
        lo = 1;
        losym = -1;
        hi = f77_bound(&hisym);
        if (lx_t == T_COLON) {
            f77_tok();
            lo = hi;
            losym = hisym;
            hi = f77_bound(&hisym);
        }
        if (rank < F77_MAX_RANK) {
            f77_slo[s][rank] = (losym >= 0) ? 0 : lo;
            f77_slov[s][rank] = losym;
            if (hisym >= 0 || losym >= 0) {
                /* extent = hi - lo + 1 at run time */
                int hv; int lv; int e;
                hv = (hisym >= 0) ? hisym : f77_iconst(hi);
                lv = (losym >= 0) ? losym : f77_iconst(lo);
                e = hi_emit(HI_SUB, TY_INT, hv, lv, 0, NULL);
                f77_sextv[s][rank] = hi_emit(HI_ADDI, TY_INT, e, -1, 1, NULL);
                f77_sext[s][rank] = 1;      /* size unknown until run time */
            } else {
                f77_sextv[s][rank] = -1;
                f77_sext[s][rank] = hi - lo + 1;
                if (f77_sext[s][rank] < 0) f77_sext[s][rank] = 0;
            }
        }
        rank = rank + 1;
        if (lx_t != T_COMMA) break;
        f77_tok();
    }
    if (lx_t != T_RP) f77_error("expected ) after dimensions");
    else f77_tok();
    if (rank > F77_MAX_RANK) { f77_error("too many dimensions"); rank = F77_MAX_RANK; }
    f77_srank[s] = rank;
}

/* A CHARACTER length after the `*`: n, (cexpr), or (*) for an
 * assumed-length dummy (returned as -1). */
static void f77_cexpr(void);
/* fort370: a numeric type's length after the `*` (the current token),
 * read as digits from the text and the scan resumed after them -- the
 * scanner would take COMPLEX*16D1 as the constant 16D1 and REAL*8E1 as
 * 8E1.  Returns 1 with *n, or 0 (no digits; the scan moved past the
 * star). */
static int f77_star_len(int *n) {
    int off;
    int k;
    int v;
    off = (int)(lx_rte - lx_stmt);
    k = 0;
    v = 0;
    while (off + k < lx_stmt_len && lx_isdigit(lx_stmt[off + k])) { v = v * 10 + (lx_stmt[off + k] - '0'); k = k + 1; }
    if (k == 0) { f77_tok(); return 0; }
    *n = v;
    f77_scan_from(off + k);
    return 1;
}

static int f77_char_len(void) {
    int n;
    if (lx_t == T_ICON) { n = lex_ival; f77_tok(); return n; }
    if (lx_t == T_RCON || lx_t == T_DCON) {
        /* CHARACTER*2D2XVK: the scanner read 2D2 as a constant.  The
         * digits are the length; the scanner restarts after them. */
        int off;
        off = (int)(lx_rts - lx_stmt);
        n = 0;
        while (off < lx_stmt_len && lx_isdigit(lx_stmt[off])) {
            n = n * 10 + (lx_stmt[off] - '0');
            off = off + 1;
        }
        f77_scan_from(off);
        return n;
    }
    if (lx_t != T_LP) { f77_error("bad CHARACTER length"); return 1; }
    f77_tok();
    if (lx_t == T_STAR) {
        f77_tok();
        if (lx_t != T_RP) { f77_error("expected ) after CHARACTER*(*"); return 1; }
        f77_tok();
        return -1;
    }
    f77_cexpr();
    if (lx_t != T_RP) { f77_error("expected ) after CHARACTER length"); return 1; }
    f77_tok();
    if (f77_cx_ty != TY_INT || f77_cx_i < 0) { f77_error("CHARACTER length must be an integer constant"); return 1; }
    return f77_cx_i;
}

/* Type declarations, and DIMENSION (which sets shape without a type). */
static int f77_decl_init(int s);
static void f77_stmt_decl(int ty, int skip) {
    int s;
    int clen;
    clen = 1;
    f77_scan_from(skip);
    /* Type-level length: REAL*8 X, CHARACTER*10 S.  Per-name forms
     * (REAL X*8, CHARACTER S*10) are below. */
    if (lx_t == T_STAR) {
        int n;
        if (ty == TY_CHAR) {
            f77_tok();
            clen = f77_char_len();
        } else if (f77_star_len(&n)) {
            ty = f77_lenty(ty, n, 1);
        }
        if (lx_t == T_COMMA) f77_tok();       /* CHARACTER*10, A, B */
    }
    for (;;) {
        if (lx_t != T_NAME) break;
        s = f77_sym(lex_name);
        if (ty >= 0) {                  /* declaration overrides implicit typing */
            f77_sty[s] = ty;
            f77_styped[s] = 1;
            f77_slog[s] = f77_decl_log;
            if (ty == TY_CHAR) f77_slen[s] = clen;
        }
        f77_tok();
        /* name*len(dims) and name(dims)*len are both F77. */
        if (lx_t == T_LP) f77_parse_dims(s);
        if (lx_t == T_STAR) {           /* REAL*8 X -- length specifier */
            int n;
            if (f77_sty[s] == TY_CHAR) {
                f77_tok();
                f77_slen[s] = f77_char_len();
            } else if (f77_star_len(&n)) {
                f77_sty[s] = f77_lenty(f77_sty[s], n, 1);
            }
            if (lx_t == T_LP) f77_parse_dims(s);
        }
        f77_realloc_sym(s);
        if (lx_t == T_SLASH && ty >= 0 && !f77_decl_init(s)) return;
        if (lx_t != T_COMMA) break;
        f77_tok();
    }
}

/* --- COMMON and SAVE --------------------------------------------------
 *
 * COMMON blocks are a compiler problem, not a linker problem (see the
 * plan): each block is emitted as ONE named .bss object through the
 * ps_g* tables gen_data() walks, and every unit that declares the
 * block lays its own members over that same object.  The block table
 * is therefore global to the compilation; sizes take the max across
 * units.
 *
 * Layout cannot happen at the COMMON statement itself: F77 lets the
 * type and DIMENSION statements that decide each member's size come
 * before OR after it.  So the COMMON statement only records
 * membership, and f77_layout_static() -- run when the declaration part
 * closes, alongside the dummy copy-in -- assigns the offsets, rebinds
 * each member's f77_sval to GADDR(block)+offset, and drops any split
 * hi slot so doubles are stored contiguously.  The member's original
 * alloca is simply abandoned, the same trade f77_realloc_sym already
 * makes.  SAVE rides the same mechanism: a saved local becomes its own
 * one-symbol .bss object. */

#define F77_MAX_CBLK 64
#define F77_MAX_CMEM 256
#define F77_GPOOL_MAX 16384

/* Defined (tentatively) again further down, next to their own logic;
 * repeated here because COMMON/SAVE parsing needs them earlier. */
static int f77_decls_open;
static int f77_result_sym;

static char f77_cblk_name[F77_MAX_CBLK][F77_MAX_NAME + 8];  /* mangled */
static int  f77_cblk_gidx[F77_MAX_CBLK];   /* index into ps_g* */
static int  f77_ncblk;

/* Per-unit COMMON membership, in declaration order. */
static int f77_cm_sym[F77_MAX_CMEM];
static int f77_cm_blk[F77_MAX_CMEM];
static int f77_cm_n;

/* Per-unit SAVE state. */
static int f77_save_all;
static int f77_sv_sym[F77_MAX_CMEM];
static int f77_sv_n;

/* Names handed to HI_GADDR are kept by pointer, so they need storage
 * that outlives the statement buffer. */
static char f77_gpool[F77_GPOOL_MAX];
static int  f77_gpool_n;

static char *f77_gpool_name(char *a, char *b, char *c, char *d) {
    char *p;
    int need;
    need = (int)(strlen(a) + strlen(b) + strlen(c) + strlen(d)) + 1;
    if (f77_gpool_n + need > F77_GPOOL_MAX) {
        f77_error("too many static names");
        return f77_gpool;   /* garbage but safe */
    }
    p = f77_gpool + f77_gpool_n;
    strcpy(p, a);
    strcat(p, b);
    strcat(p, c);
    strcat(p, d);
    f77_gpool_n = f77_gpool_n + need;
    return p;
}

/* One zero-initialized .bss object in the tables gen_data() walks.
 * Every field is set explicitly: the parser owns these entries, and a
 * default-zero ps_ginit_start would read as an initializer list. */
static int f77_g_add(char *name, int size) {
    int i;
    i = ps_nglobals;
    if (i >= P_MAX_GLOBALS) { f77_error("too many globals"); return 0; }
    ps_gname[i] = name;
    ps_gtype[i] = TY_INT;
    ps_gsize[i] = size;
    ps_ginit[i] = 0;
    ps_ginit_hi[i] = 0;
    ps_gstr[i] = -1;
    ps_glocal[i] = 1;
    ps_gextern[i] = 0;
    ps_ginit_start[i] = -1;
    ps_ginit_count[i] = 0;
    ps_girel_start[i] = 0;
    ps_girel_count[i] = 0;
    ps_nglobals = i + 1;
    return i;
}

/* Find or create a COMMON block.  `nm` is the Fortran name; "" is
 * blank COMMON.  The mangled name is what the .bss label carries. */
static int f77_cblk_find(char *nm) {
    int i;
    char mangled[F77_MAX_NAME + 8];
    strcpy(mangled, "f77c_");
    strcat(mangled, nm);
    i = 0;
    while (i < f77_ncblk) {
        if (strcmp(f77_cblk_name[i], mangled) == 0) return i;
        i = i + 1;
    }
    if (f77_ncblk >= F77_MAX_CBLK) { f77_error("too many COMMON blocks"); return 0; }
    strcpy(f77_cblk_name[f77_ncblk], mangled);
    f77_cblk_gidx[f77_ncblk] = f77_g_add(f77_cblk_name[f77_ncblk], 0);
    f77_ncblk = f77_ncblk + 1;
    return f77_ncblk - 1;
}

/* COMMON [/name/] a, b /name2/ c ...  -- also blank COMMON via // or a
 * bare list.  Members may carry their dimensions here. */
static void f77_stmt_common(int skip) {
    int blk;
    int s;
    char bname[F77_MAX_NAME];

    if (!f77_decls_open) {
        f77_error("COMMON after the first executable statement");
        return;
    }
    f77_scan_from(skip);
    blk = -1;                           /* bare list = blank COMMON */
    for (;;) {
        if (lx_t == T_EOF) break;
        if (lx_t == T_CONCAT) {         /* // -- blank COMMON */
            blk = -1;
            f77_tok();
        } else if (lx_t == T_SLASH) {
            f77_tok();
            if (lx_t == T_SLASH) {      /* / / -- blank COMMON */
                blk = -1;
                f77_tok();
            } else if (lx_t == T_NAME) {
                strcpy(bname, lex_name);
                f77_tok();
                if (lx_t != T_SLASH) { f77_error("expected / after COMMON block name"); return; }
                f77_tok();
                blk = f77_cblk_find(bname);
            } else {
                f77_error("bad COMMON block name");
                return;
            }
        }
        if (lx_t != T_NAME) { f77_error("expected a variable in COMMON"); return; }
        if (blk < 0) blk = f77_cblk_find("");
        s = f77_sym(lex_name);
        if (f77_sarg[s]) { f77_error("a dummy argument cannot be in COMMON"); return; }
        if (f77_sparam[s]) { f77_error("a PARAMETER cannot be in COMMON"); return; }
        if (f77_scom[s]) { f77_error("variable appears in COMMON twice"); return; }
        f77_tok();
        if (lx_t == T_LP) {             /* dimensions declared here */
            f77_parse_dims(s);
            f77_realloc_sym(s);
        }
        f77_scom[s] = 1;
        if (f77_cm_n >= F77_MAX_CMEM) { f77_error("too many COMMON members"); return; }
        f77_cm_sym[f77_cm_n] = s;
        f77_cm_blk[f77_cm_n] = blk;
        f77_cm_n = f77_cm_n + 1;
        if (lx_t == T_COMMA) f77_tok();
    }
}

/* SAVE           -- every local becomes static
 * SAVE a, /b/, c -- listed variables (a named block is already static,
 *                   so /b/ is recognised and skipped) */
static void f77_stmt_save(int skip) {
    if (!f77_decls_open) {
        f77_error("SAVE after the first executable statement");
        return;
    }
    f77_scan_from(skip);
    if (lx_t == T_EOF) { f77_save_all = 1; return; }
    for (;;) {
        if (lx_t == T_SLASH) {          /* /block/ -- nothing to do */
            f77_tok();
            if (lx_t == T_NAME) f77_tok();
            if (lx_t != T_SLASH) { f77_error("expected / after SAVE block name"); return; }
            f77_tok();
        } else if (lx_t == T_NAME) {
            if (f77_sv_n >= F77_MAX_CMEM) { f77_error("too many SAVE names"); return; }
            f77_sv_sym[f77_sv_n] = f77_sym(lex_name);
            f77_sv_n = f77_sv_n + 1;
            f77_tok();
        } else {
            f77_error("bad SAVE list");
            return;
        }
        if (lx_t != T_COMMA) break;
        f77_tok();
    }
}

/* IMPLICIT NONE, or IMPLICIT type (letter-ranges), ... -- rewrite the
 * per-unit letter map.  Symbols that already exist untyped (dummies,
 * created at bind time under the default rule) are retyped to the new
 * map, with one guarded exception: the FUNCTION result's type was
 * fixed in phase 1 for every caller to see, so an IMPLICIT that would
 * change it is refused rather than silently splitting the ABI. */
static void f77_stmt_implicit(int skip) {
    int ty;
    int s;
    int c;
    int lo;
    int hi;

    if (!f77_decls_open) {
        f77_error("IMPLICIT after the first executable statement");
        return;
    }
    f77_scan_from(skip);
    if (lx_t == T_NAME && strcmp(lex_name, "NONE") == 0) {
        f77_imp_none = 1;
        f77_tok();
        return;
    }
    for (;;) {
        int clen;
        int lg;
        clen = 1;
        lg = 0;
        if (lx_t != T_NAME) { f77_error("IMPLICIT needs a type"); return; }
        if (strcmp(lex_name, "INTEGER") == 0) ty = TY_INT;
        else if (strcmp(lex_name, "REAL") == 0) ty = TY_FLOAT;
        else if (strcmp(lex_name, "DOUBLEPRECISION") == 0) ty = TY_DOUBLE;
        else if (strcmp(lex_name, "LOGICAL") == 0) { ty = TY_INT; lg = 1; }
        else if (strcmp(lex_name, "CHARACTER") == 0) ty = TY_CHAR;
        else if (strcmp(lex_name, "COMPLEX") == 0) ty = TY_CPLX;
#ifdef F77_NATIVE_F64
        else if (strcmp(lex_name, "DOUBLECOMPLEX") == 0) ty = TY_DCPLX;
#endif
        else { f77_error("IMPLICIT type not supported"); return; }
        f77_tok();
        if (lx_t == T_STAR) {
            int n;
            if (ty == TY_CHAR) { f77_tok(); clen = f77_char_len(); }
            else if (f77_star_len(&n)) ty = f77_lenty(ty, n, 1);
        }
        if (clen < 0) { f77_error("IMPLICIT CHARACTER*(*) is not allowed"); return; }
        if (lx_t != T_LP) { f77_error("IMPLICIT needs (letter-ranges)"); return; }
        f77_tok();
        for (;;) {
            if (lx_t != T_NAME || lex_name[1] != 0) {
                f77_error("IMPLICIT range needs single letters");
                return;
            }
            lo = lex_name[0];
            hi = lo;
            f77_tok();
            if (lx_t == T_MINUS) {
                f77_tok();
                if (lx_t != T_NAME || lex_name[1] != 0) {
                    f77_error("IMPLICIT range needs single letters");
                    return;
                }
                hi = lex_name[0];
                f77_tok();
            }
            if (lo < 'A' || hi > 'Z' || lo > hi) {
                f77_error("bad IMPLICIT letter range");
                return;
            }
            for (c = lo; c <= hi; c++) { f77_imp_map[c - 'A'] = ty; f77_imp_len[c - 'A'] = clen; f77_imp_log[c - 'A'] = lg; }
            if (lx_t != T_COMMA) break;
            f77_tok();
        }
        if (lx_t != T_RP) { f77_error("expected ) in IMPLICIT"); return; }
        f77_tok();
        if (lx_t != T_COMMA) break;
        f77_tok();
    }

    /* Retype symbols the default rule already created. */
    for (s = f77_scope_base; s < f77_nsym; s++) {
        if (f77_styped[s] || f77_sparam[s]) continue;
        ty = f77_imp_map[f77_sname[s][0] - 'A'];
        f77_slog[s] = f77_imp_log[f77_sname[s][0] - 'A'];
        if (ty == f77_sty[s] &&
            (ty != TY_CHAR || f77_slen[s] == f77_imp_len[f77_sname[s][0] - 'A'])) continue;
        if (s == f77_result_sym) {
            f77_error("IMPLICIT would change the FUNCTION result type; declare it in the header");
            return;
        }
        f77_sty[s] = ty;
        if (ty == TY_CHAR) f77_slen[s] = f77_imp_len[f77_sname[s][0] - 'A'];
        if (!f77_sarg[s]) f77_realloc_sym(s);
    }
}

/* PARAMETER (name = cexpr, ...) -- named constants, no storage.  The
 * symbol's type (declared or implicit, fixed by this point per F77's
 * ordering rules) decides which domain the value is served from. */
static void f77_stmt_parameter(int skip) {
    int s;
    if (!f77_decls_open) {
        f77_error("PARAMETER after the first executable statement");
        return;
    }
    f77_scan_from(skip);
    if (lx_t != T_LP) { f77_error("PARAMETER needs a parenthesised list"); return; }
    f77_tok();
    for (;;) {
        if (lx_t != T_NAME) { f77_error("PARAMETER needs a name"); return; }
        s = f77_sym(lex_name);
        if (f77_sarg[s] || f77_scom[s] || f77_srank[s] > 0) {
            f77_error("this name cannot be a PARAMETER");
            return;
        }
        f77_tok();
        if (lx_t != T_ASSIGN) { f77_error("expected = in PARAMETER"); return; }
        f77_tok();
        f77_cexpr();
        f77_sparam[s] = 1;
        if (f77_sty[s] == TY_CHAR) {
            if (f77_cx_ty != TY_CHAR) { f77_error("a CHARACTER PARAMETER needs a character constant"); return; }
            if (f77_slen[s] < 0) f77_slen[s] = f77_cx_i;       /* CHARACTER*(*) takes the constant's length */
            if (f77_slen[s] == f77_cx_i) {
                f77_spstr[s] = f77_cx_sidx;
            } else {
                /* Pad or truncate to the declared length. */
                static char buf[F77_MAX_STMT];   /* fort370: not in the frame */
                int k;
                for (k = 0; k < f77_slen[s] && k < F77_MAX_STMT - 1; k++)
                    buf[k] = (k < f77_cx_i) ? lex_strpool[lex_str_off[f77_cx_sidx] + k] : ' ';
                f77_spstr[s] = f77_intern_str(buf, k);
            }
        } else if (f77_cx_ty == TY_CHAR) {
            f77_error("a character constant cannot initialise a numeric PARAMETER");
            return;
        } else if (f77_iscx(f77_sty[s])) {
            f77_spdval[s] = (f77_cx_ty == TY_INT) ? (double)f77_cx_i : f77_cx_d;
            f77_spdval2[s] = f77_iscx(f77_cx_ty) ? f77_cx_d2 : 0.0;
            f77_spival[s] = (int)f77_spdval[s];
            f77_sptext[s] = f77_cx_t[0] ? strdup(f77_cx_t) : 0;
            f77_sptext2[s] = f77_iscx(f77_cx_ty) ? (f77_cx_t2[0] ? strdup(f77_cx_t2) : 0) : strdup("0");
        } else if (f77_sty[s] == TY_INT) {
            f77_spival[s] = (f77_cx_ty == TY_INT) ? f77_cx_i : (int)f77_cx_d;
            f77_spdval[s] = (double)f77_spival[s];
        } else {
            f77_spdval[s] = (f77_cx_ty == TY_INT) ? (double)f77_cx_i : f77_cx_d;
            if (f77_sty[s] == TY_FLOAT)
                f77_spdval[s] = (double)(float)f77_spdval[s];
            f77_spival[s] = (int)f77_spdval[s];
            f77_sptext[s] = f77_cx_t[0] ? strdup(f77_cx_t) : 0;
        }
        if (lx_t != T_COMMA) break;
        f77_tok();
    }
    if (lx_t != T_RP) f77_error("expected ) after PARAMETER list");
    else f77_tok();
}

/* --- DATA -------------------------------------------------------------
 *
 * DATA gives a variable an initial value, which in F77 means STATIC
 * storage initialized at load -- so a DATA'd variable takes the SAVE
 * path, and its values are poured into the ps_ginit pool when the
 * declaration part closes and the object exists.  Parsing flattens
 * each nlist/clist pair immediately (F77 requires the shape to be
 * declared before the DATA statement, so element counts are known):
 * one (symbol, element, value) triple per initialized element. */
#define F77_MAX_DINIT 8192
static int    f77_di_sym[F77_MAX_DINIT];
static int    f77_di_elem[F77_MAX_DINIT];
static int    f77_di_ty[F77_MAX_DINIT];
static int    f77_di_i[F77_MAX_DINIT];
static double f77_di_d[F77_MAX_DINIT];
static int    f77_di_sidx[F77_MAX_DINIT];
static double f77_di_d2[F77_MAX_DINIT];
static char  *f77_di_t[F77_MAX_DINIT];    /* fort370: the value's decimal text, or 0 */
static char  *f77_di_t2[F77_MAX_DINIT];
static int    f77_di_sub[F77_MAX_DINIT];   /* substring target: byte length, elem is a byte offset */
static int    f77_di_n;

/* Byte images of DATA values, in the TARGET's order and format.  The
 * S/370 is big-endian and its floats are hexadecimal; the SLOW-32 is
 * little-endian IEEE, which the host also is. */
#ifdef F77_TARGET_S370
/* ASCII to EBCDIC (code page 037), for character data laid down as
 * bytes; text in DC C'...' the assembler converts itself. */
static unsigned char f77_a2e[256] = {
    0x00, 0x01, 0x02, 0x03, 0x37, 0x2D, 0x2E, 0x2F, 0x16, 0x05, 0x25, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
    0x10, 0x11, 0x12, 0x13, 0x3C, 0x3D, 0x32, 0x26, 0x18, 0x19, 0x3F, 0x27, 0x1C, 0x1D, 0x1E, 0x1F,
    0x40, 0x5A, 0x7F, 0x7B, 0x5B, 0x6C, 0x50, 0x7D, 0x4D, 0x5D, 0x5C, 0x4E, 0x6B, 0x60, 0x4B, 0x61,
    0xF0, 0xF1, 0xF2, 0xF3, 0xF4, 0xF5, 0xF6, 0xF7, 0xF8, 0xF9, 0x7A, 0x5E, 0x4C, 0x7E, 0x6E, 0x6F,
    0x7C, 0xC1, 0xC2, 0xC3, 0xC4, 0xC5, 0xC6, 0xC7, 0xC8, 0xC9, 0xD1, 0xD2, 0xD3, 0xD4, 0xD5, 0xD6,
    0xD7, 0xD8, 0xD9, 0xE2, 0xE3, 0xE4, 0xE5, 0xE6, 0xE7, 0xE8, 0xE9, 0xBA, 0xE0, 0xBB, 0xB0, 0x6D,
    0x79, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96,
    0x97, 0x98, 0x99, 0xA2, 0xA3, 0xA4, 0xA5, 0xA6, 0xA7, 0xA8, 0xA9, 0xC0, 0x4F, 0xD0, 0xA1, 0x07,
    0x20, 0x21, 0x22, 0x23, 0x24, 0x15, 0x06, 0x17, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x09, 0x0A, 0x1B,
    0x30, 0x31, 0x1A, 0x33, 0x34, 0x35, 0x36, 0x08, 0x38, 0x39, 0x3A, 0x3B, 0x04, 0x14, 0x3E, 0xFF,
    0x41, 0xAA, 0x4A, 0xB1, 0x9F, 0xB2, 0x6A, 0xB5, 0xBD, 0xB4, 0x9A, 0x8A, 0x5F, 0xCA, 0xAF, 0xBC,
    0x90, 0x8F, 0xEA, 0xFA, 0xBE, 0xA0, 0xB6, 0xB3, 0x9D, 0xDA, 0x9B, 0x8B, 0xB7, 0xB8, 0xB9, 0xAB,
    0x64, 0x65, 0x62, 0x66, 0x63, 0x67, 0x9E, 0x68, 0x74, 0x71, 0x72, 0x73, 0x78, 0x75, 0x76, 0x77,
    0xAC, 0x69, 0xED, 0xEE, 0xEB, 0xEF, 0xEC, 0xBF, 0x80, 0xFD, 0xFE, 0xFB, 0xFC, 0xAD, 0xAE, 0x59,
    0x44, 0x45, 0x42, 0x46, 0x43, 0x47, 0x9C, 0x48, 0x54, 0x51, 0x52, 0x53, 0x58, 0x55, 0x56, 0x57,
    0x8C, 0x49, 0xCD, 0xCE, 0xCB, 0xCF, 0xCC, 0xE1, 0x70, 0xDD, 0xDE, 0xDB, 0xDC, 0x8D, 0x8E, 0xDF,
};
#ifdef __MVS__
/* the source is EBCDIC already when the compiler runs on MVS */
static unsigned char f77_target_char(unsigned char c) { return c; }
#else
static unsigned char f77_target_char(unsigned char c) { return f77_a2e[c]; }
#endif
static void f77_image_int(unsigned char *p, unsigned int v, int n) {
    int k;
    for (k = 0; k < n; k++) p[k] = (unsigned char)((v >> ((n - 1 - k) * 8)) & 255);
}
static void f77_image_fp(unsigned char *p, double d, int bytes) {
    char b[160];
    unsigned int hi, lo;
    f77_dtext(d, b);
    if (hfp_from_text_n(b, &hi, &lo, bytes == 8 ? 56 : 24) < 0) { hi = 0; lo = 0; }
    f77_image_int(p, hi, 4);
    if (bytes == 8) f77_image_int(p + 4, lo, 4);
}
/* From the constant's own text when there is one (f77_cx_t). */
static void f77_image_fpt(unsigned char *p, const char *t, double d, int bytes) {
    unsigned int hi, lo;
    if (t && hfp_from_text_n(t, &hi, &lo, bytes == 8 ? 56 : 24) >= 0) {
        f77_image_int(p, hi, 4);
        if (bytes == 8) f77_image_int(p + 4, lo, 4);
        return;
    }
    f77_image_fp(p, d, bytes);
}
#else
static unsigned char f77_target_char(unsigned char c) { return c; }
static void f77_image_int(unsigned char *p, unsigned int v, int n) {
    int k;
    for (k = 0; k < n; k++) p[k] = (unsigned char)((v >> (k * 8)) & 255);
}
static void f77_image_fpt(unsigned char *p, const char *t, double d, int bytes);
static void f77_image_fp(unsigned char *p, double d, int bytes) {
    int k;
    if (bytes == 8) {
        union { double d; unsigned char b[8]; } u;
        u.d = d;
        for (k = 0; k < 8; k++) p[k] = u.b[k];
    } else {
        union { float f; unsigned char b[4]; } u;
        u.f = (float)d;
        for (k = 0; k < 4; k++) p[k] = u.b[k];
    }
}
static void f77_image_fpt(unsigned char *p, const char *t, double d, int bytes) {
    (void)t;
    f77_image_fp(p, d, bytes);
}
#endif

/* One DATA constant: sign, literal, .TRUE./.FALSE., or a PARAMETER
 * name.  NOT f77_cexpr: `/` is the value-list delimiter here, and the
 * evaluator would read it as division. */
static void f77_data_const(void) {
    int neg;
    neg = 0;
    if (lx_t == T_MINUS) { neg = 1; f77_tok(); }
    else if (lx_t == T_PLUS) f77_tok();
    f77_cx_t[0] = 0; f77_cx_t2[0] = 0;
    if (lx_t == T_ICON) { f77_cx_ty = TY_INT; f77_cx_i = lex_ival; f77_cx_d = (double)lex_ival; sprintf(f77_cx_t, "%d", lex_ival); f77_tok(); }
    else if (lx_t == T_RCON) { f77_cx_ty = TY_FLOAT; f77_cx_d = lex_dval; f77_cx_i = (int)lex_dval; f77_cx_settext(f77_cx_t, lex_ftext); f77_tok(); }
    else if (lx_t == T_DCON) { f77_cx_ty = TY_DOUBLE; f77_cx_d = lex_dval; f77_cx_i = (int)lex_dval; f77_cx_settext(f77_cx_t, lex_ftext); f77_tok(); }
    else if (lx_t == T_TRUE)  { f77_cx_ty = TY_INT; f77_cx_i = 1; f77_cx_d = 1.0; f77_tok(); }
    else if (lx_t == T_FALSE) { f77_cx_ty = TY_INT; f77_cx_i = 0; f77_cx_d = 0.0; f77_tok(); }
    else if (lx_t == T_SCON) { f77_cx_ty = TY_CHAR; f77_cx_sidx = lex_sidx; f77_cx_i = lex_slen; f77_cx_d = 0.0; f77_tok(); }
    else if (lx_t == T_LP) {
        /* (re, im) */
        double re;
        char ret[64];
        f77_tok();
        f77_data_const();
        re = f77_cx_d;
        strcpy(ret, f77_cx_t);
        if (lx_t != T_COMMA) { f77_error("expected , in complex constant"); return; }
        f77_tok();
        f77_data_const();
        if (lx_t != T_RP) { f77_error("expected ) after complex constant"); return; }
        f77_tok();
        f77_cx_d2 = f77_cx_d;
        strcpy(f77_cx_t2, f77_cx_t);
        strcpy(f77_cx_t, ret);
        f77_cx_d = re;
        f77_cx_ty = TY_CPLX;
        f77_cx_i = (int)re;
    }
    else if (lx_t == T_NAME) {
        int s;
        s = f77_sym(lex_name);
        if (!f77_sparam[s]) { f77_error("DATA value must be a constant"); f77_cx_ty = TY_INT; f77_cx_i = 0; f77_cx_d = 0.0; return; }
        f77_cx_ty = f77_sty[s];
        f77_cx_i = f77_spival[s];
        f77_cx_d = f77_spdval[s];
        f77_cx_d2 = f77_spdval2[s];
        if (f77_cx_ty == TY_CHAR) { f77_cx_sidx = f77_spstr[s]; f77_cx_i = f77_slen[s]; }
        else if (f77_cx_ty == TY_INT) sprintf(f77_cx_t, "%d", f77_cx_i);
        else {
            if (f77_sptext[s]) strcpy(f77_cx_t, f77_sptext[s]);
            if (f77_sptext2[s]) strcpy(f77_cx_t2, f77_sptext2[s]);
        }
        f77_tok();
    } else {
        f77_error("DATA value must be a constant");
        f77_cx_ty = TY_INT; f77_cx_i = 0; f77_cx_d = 0.0;
        return;
    }
    if (neg) {
        f77_cx_i = 0 - f77_cx_i;
        f77_cx_d = 0.0 - f77_cx_d;
        if (f77_cx_ty == TY_INT) sprintf(f77_cx_t, "%d", f77_cx_i);
        else f77_cx_negtext(f77_cx_t);
        if (f77_iscx(f77_cx_ty)) { f77_cx_d2 = 0.0 - f77_cx_d2; f77_cx_negtext(f77_cx_t2); }
    }
}

#define F77_MAX_DTGT 1024
static int f77_dt_sym[F77_MAX_DTGT];
static int f77_dt_start[F77_MAX_DTGT];   /* element index, or byte offset for a substring */
static int f77_dt_count[F77_MAX_DTGT];   /* elements, or 1 */
static int f77_dt_sublen[F77_MAX_DTGT];  /* substring length, 0 = not a substring */
static int f77_dt_n;

/* Constant bindings of implied-DO variables while a DATA target list
 * is expanded; f77_cprimary consults them before PARAMETERs. */
static int f77_implied_do_spans(int open, int *close_off, int *eq_off, int *items_off, int *ctl_off);

/* One DATA target: name, name(subscripts), name(e1:e2), or an
 * implied-DO (items, var = c1, c2 [, c3]) expanded here at compile time.
 * `stop` is the statement offset where this list ends (the comma before
 * an enclosing implied-DO's control, or the statement end). Returns 0
 * on error. */
static int f77_data_target(int stop) {
    int s;
    int k;
    if (lx_t == T_LP) {
        int open_off; int close_off; int eq_off; int items_off; int ctl_off;
        int c1; int c2; int c3; int v;
        int bi;
        open_off = (int)(lx_rts - lx_stmt);
        if (!f77_implied_do_spans(open_off, &close_off, &eq_off, &items_off, &ctl_off)) {
            f77_error("bad parenthesised DATA item");
            return 0;
        }
        f77_scan_from(ctl_off);
        if (lx_t != T_NAME) { f77_error("implied-DO in DATA needs a variable"); return 0; }
        if (f77_cxb_n >= F77_MAX_CXB) { f77_error("implied-DO in DATA nested too deep"); return 0; }
        bi = f77_cxb_n;
        strcpy(f77_cxb_name[bi], lex_name);
        f77_tok();
        if (lx_t != T_ASSIGN) { f77_error("expected = in implied-DO"); return 0; }
        f77_tok();
        f77_cexpr(); c1 = f77_cx_i;
        if (lx_t != T_COMMA) { f77_error("expected , in implied-DO"); return 0; }
        f77_tok();
        f77_cexpr(); c2 = f77_cx_i;
        c3 = 1;
        if (lx_t == T_COMMA) { f77_tok(); f77_cexpr(); c3 = f77_cx_i; }
        if (c3 == 0) { f77_error("zero step in implied-DO"); return 0; }
        f77_cxb_n = bi + 1;
        for (v = c1; c3 > 0 ? v <= c2 : v >= c2; v = v + c3) {
            f77_cxb_val[bi] = v;
            f77_scan_from(items_off);
            for (;;) {
                if (!f77_data_target(ctl_off - 1)) { f77_cxb_n = bi; return 0; }
                if (lx_t != T_COMMA || (int)(lx_rts - lx_stmt) >= ctl_off - 1) break;
                f77_tok();
                if ((int)(lx_rts - lx_stmt) >= ctl_off) break;
            }
        }
        f77_cxb_n = bi;
        f77_scan_from(close_off);
        return 1;
    }
    if (lx_t != T_NAME) { f77_error("expected a variable in DATA"); return 0; }
    s = f77_sym(lex_name);
    if (f77_sarg[s]) { f77_error("a dummy argument cannot appear in DATA"); return 0; }
    if (f77_sparam[s]) { f77_error("a PARAMETER cannot appear in DATA"); return 0; }
    f77_tok();
    if (f77_dt_n >= F77_MAX_DTGT) { f77_error("too many DATA items"); return 0; }
    f77_dt_sym[f77_dt_n] = s;
    f77_dt_sublen[f77_dt_n] = 0;
    if (lx_t == T_LP && f77_srank[s] > 0) {
        /* Constant subscripts -> one element. */
        int elem;
        int stride;
        int d;
        elem = 0;
        stride = 1;
        d = 0;
        f77_tok();
        for (;;) {
            if (f77_adjustable(s)) { f77_error("adjustable array in DATA"); return 0; }
            f77_cexpr();
            if (f77_cx_ty != TY_INT) { f77_error("DATA subscript must be an integer constant"); return 0; }
            if (d >= f77_srank[s]) { f77_error("too many DATA subscripts"); return 0; }
            if (f77_cx_i < f77_slo[s][d] ||
                f77_cx_i >= f77_slo[s][d] + f77_sext[s][d]) {
                f77_error("DATA subscript out of bounds");
                return 0;
            }
            elem = elem + (f77_cx_i - f77_slo[s][d]) * stride;
            stride = stride * f77_sext[s][d];
            d = d + 1;
            if (lx_t != T_COMMA) break;
            f77_tok();
        }
        if (lx_t != T_RP) { f77_error("expected ) after DATA subscripts"); return 0; }
        if (d != f77_srank[s]) { f77_error("wrong number of DATA subscripts"); return 0; }
        f77_tok();
        f77_dt_start[f77_dt_n] = elem;
        f77_dt_count[f77_dt_n] = 1;
    } else if (f77_srank[s] > 0) {
        if (f77_adjustable(s)) { f77_error("adjustable array in DATA"); return 0; }
        f77_dt_start[f77_dt_n] = 0;
        f77_dt_count[f77_dt_n] = f77_sym_nelem(s);
    } else {
        f77_dt_start[f77_dt_n] = 0;
        f77_dt_count[f77_dt_n] = 1;
    }
    if (lx_t == T_LP && f77_sty[s] == TY_CHAR) {
        /* (e1:e2) substring of the element or scalar: a byte range */
        int e1; int e2;
        f77_tok();
        e1 = 1; e2 = f77_slen[s];
        if (lx_t != T_COLON) { f77_cexpr(); e1 = f77_cx_i; }
        if (lx_t != T_COLON) { f77_error("expected : in DATA substring"); return 0; }
        f77_tok();
        if (lx_t != T_RP) { f77_cexpr(); e2 = f77_cx_i; }
        if (lx_t != T_RP) { f77_error("expected ) after DATA substring"); return 0; }
        f77_tok();
        f77_dt_start[f77_dt_n] = f77_dt_start[f77_dt_n] * f77_esize(s) + (e1 - 1);
        f77_dt_count[f77_dt_n] = 1;
        f77_dt_sublen[f77_dt_n] = e2 - e1 + 1;
    }
    if (!f77_scom[s]) f77_ssaved[s] = 1;   /* DATA implies static storage */
    f77_dt_n = f77_dt_n + 1;
    (void)stop;
    return 1;
}

/* The value list of DATA (or of a type statement's /c/), from the first
 * value up to the closing /, poured across f77_dt_* in order.  Returns 0
 * on error. */
static int f77_data_values(void) {
    int ti;       /* target index */
    int te;       /* elements consumed within target ti */
    int rep;
    ti = 0;
    te = 0;
    for (;;) {
        if (lx_t == T_SLASH) break;
        f77_data_const();
        rep = 1;
        if (lx_t == T_STAR) {   /* r*c: what we parsed was the count */
            if (f77_cx_ty != TY_INT || f77_cx_i <= 0) {
                f77_error("DATA repeat count must be a positive integer");
                return 0;
            }
            rep = f77_cx_i;
            f77_tok();
            f77_data_const();
        }
        while (rep > 0) {
            while (ti < f77_dt_n && te >= f77_dt_count[ti]) { ti = ti + 1; te = 0; }
            if (ti >= f77_dt_n) { f77_error("more DATA values than variables"); return 0; }
            if (f77_di_n >= F77_MAX_DINIT) { f77_error("too many DATA initializers"); return 0; }
            f77_di_sym[f77_di_n] = f77_dt_sym[ti];
            f77_di_elem[f77_di_n] = f77_dt_sublen[ti] ? f77_dt_start[ti] : f77_dt_start[ti] + te;
            f77_di_ty[f77_di_n] = f77_cx_ty;
            f77_di_i[f77_di_n] = f77_cx_i;
            f77_di_d[f77_di_n] = f77_cx_d;
            f77_di_sidx[f77_di_n] = f77_cx_sidx;
            f77_di_d2[f77_di_n] = f77_cx_d2;
            f77_di_t[f77_di_n] = f77_cx_t[0] ? strdup(f77_cx_t) : 0;
            f77_di_t2[f77_di_n] = f77_cx_t2[0] ? strdup(f77_cx_t2) : 0;
            f77_di_sub[f77_di_n] = f77_dt_sublen[ti];
            f77_di_n = f77_di_n + 1;
            te = te + 1;
            rep = rep - 1;
        }
        if (lx_t == T_COMMA) { f77_tok(); continue; }
        break;
    }
    while (ti < f77_dt_n && te >= f77_dt_count[ti]) { ti = ti + 1; te = 0; }
    if (ti < f77_dt_n) { f77_error("fewer DATA values than variables"); return 0; }
        return 1;
}

/* fort370: INTEGER K/3/, A(2)/1,2/ -- initial values in a type statement
 * (IBM's FORTRAN IV and VS FORTRAN), the same as DATA for the whole
 * entity; lx_t is at the opening /.  They had been skipped, and with
 * them everything after in the statement.  Returns 0 on error. */
static int f77_decl_init(int s) {
    if (f77_sarg[s]) { f77_error("a dummy argument cannot be given an initial value"); return 0; }
    if (f77_srank[s] > 0 && f77_adjustable(s)) { f77_error("adjustable array given an initial value"); return 0; }
    f77_dt_n = 1;
    f77_cxb_n = 0;
    f77_dt_sym[0] = s;
    f77_dt_start[0] = 0;
    f77_dt_count[0] = f77_srank[s] > 0 ? f77_sym_nelem(s) : 1;
    f77_dt_sublen[0] = 0;
    if (!f77_scom[s]) f77_ssaved[s] = 1;   /* DATA implies static storage */
    f77_tok();
    if (!f77_data_values()) return 0;
    if (lx_t != T_SLASH) { f77_error("expected / after initial values"); return 0; }
    f77_tok();
    return 1;
}

static void f77_stmt_data(int skip) {
    int s;
    int k;

    if (!f77_decls_open) {
        f77_error("DATA after the first executable statement");
        return;
    }
    f77_scan_from(skip);
    for (;;) {
        /* --- the variable list, up to the opening / --- */
        f77_dt_n = 0;
        f77_cxb_n = 0;
        for (;;) {
            if (!f77_data_target(lx_stmt_len)) return;
            if (lx_t != T_COMMA) break;
            f77_tok();
        }
        if (lx_t != T_SLASH) { f77_error("expected / before DATA values"); return; }
        f77_tok();

        if (!f77_data_values()) return;
        if (lx_t != T_SLASH) { f77_error("expected / after DATA values"); return; }
        f77_tok();
        if (lx_t == T_COMMA) f77_tok();
        if (lx_t == T_EOF) break;
    }
}

/* EQUIVALENCE (a, b(2), c(1,2)), (d, e) ... -- record the pairs.  An
 * array element with constant subscripts (or a single subscript into a
 * multi-dimensional array, which F77 allows here) gives a byte offset;
 * a bare array name means its first element. */
static int f77_eq_offset(int s) {
    int elem;
    int stride;
    int d;
    int n;
    int subs[F77_MAX_RANK];
    if (lx_t != T_LP) return 0;
    if (f77_srank[s] == 0 && f77_sty[s] == TY_CHAR) {
        /* (e1:e2) on a scalar: the offset is e1-1 */
        int e1;
        f77_tok();
        e1 = 1;
        if (lx_t != T_COLON) { f77_cexpr(); e1 = f77_cx_i; }
        if (lx_t != T_COLON) { f77_error("expected : in EQUIVALENCE substring"); return 0; }
        f77_tok();
        if (lx_t != T_RP) f77_cexpr();
        if (lx_t != T_RP) { f77_error("expected ) in EQUIVALENCE"); return 0; }
        f77_tok();
        return e1 - 1;
    }
    if (f77_srank[s] == 0) { f77_error("subscript on a scalar in EQUIVALENCE"); return 0; }
    f77_tok();
    n = 0;
    for (;;) {
        f77_cexpr();
        if (f77_cx_ty != TY_INT) { f77_error("EQUIVALENCE subscript must be an integer constant"); return 0; }
        if (n < F77_MAX_RANK) subs[n] = f77_cx_i;
        n = n + 1;
        if (lx_t != T_COMMA) break;
        f77_tok();
    }
    if (lx_t != T_RP) { f77_error("expected ) in EQUIVALENCE"); return 0; }
    f77_tok();
    if (f77_adjustable(s)) { f77_error("adjustable array in EQUIVALENCE"); return 0; }
    if (n == 1 && f77_srank[s] > 1) {
        elem = subs[0] - 1;                 /* linear element number */
    } else {
        if (n != f77_srank[s]) { f77_error("wrong number of EQUIVALENCE subscripts"); return 0; }
        elem = 0;
        stride = 1;
        for (d = 0; d < n; d++) {
            elem = elem + (subs[d] - f77_slo[s][d]) * stride;
            stride = stride * f77_sext[s][d];
        }
    }
    return elem * f77_esize(s);
}

static void f77_stmt_equivalence(int skip) {
    int sa;
    int oa;
    int sb;
    int ob;
    if (!f77_decls_open) {
        f77_error("EQUIVALENCE after the first executable statement");
        return;
    }
    f77_scan_from(skip);
    for (;;) {
        if (lx_t != T_LP) { f77_error("EQUIVALENCE needs a parenthesised list"); return; }
        f77_tok();
        if (lx_t != T_NAME) { f77_error("expected a variable in EQUIVALENCE"); return; }
        sa = f77_sym(lex_name);
        f77_tok();
        oa = f77_eq_offset(sa);
        if (lx_t != T_COMMA) { f77_error("EQUIVALENCE needs at least two items"); return; }
        while (lx_t == T_COMMA) {
            f77_tok();
            if (lx_t != T_NAME) { f77_error("expected a variable in EQUIVALENCE"); return; }
            sb = f77_sym(lex_name);
            f77_tok();
            ob = f77_eq_offset(sb);
            if (f77_sarg[sa] || f77_sarg[sb]) { f77_error("a dummy argument cannot be in EQUIVALENCE"); return; }
            if (f77_sparam[sa] || f77_sparam[sb]) { f77_error("a PARAMETER cannot be in EQUIVALENCE"); return; }
            if (f77_eq_n >= F77_MAX_EQ) { f77_error("too many EQUIVALENCE pairs"); return; }
            f77_eq_sa[f77_eq_n] = sa; f77_eq_oa[f77_eq_n] = oa;
            f77_eq_sb[f77_eq_n] = sb; f77_eq_ob[f77_eq_n] = ob;
            f77_eq_n = f77_eq_n + 1;
        }
        if (lx_t != T_RP) { f77_error("expected ) in EQUIVALENCE"); return; }
        f77_tok();
        if (lx_t == T_COMMA) f77_tok();
        if (lx_t == T_EOF) break;
    }
}

/* Union-find with offsets: addr(s) = addr(root) + *off. */
static int f77_eq_find(int s, int *off) {
    int o;
    o = 0;
    while (f77_eq_parent[s] != s) {
        o = o + f77_eq_delta[s];
        s = f77_eq_parent[s];
    }
    *off = o;
    return s;
}

/* The static object `prefix`<unit>_<name> of the unit being compiled,
 * made on first use.  A subprogram and its ENTRY points are one
 * subprogram with one set of statics, so they are named after the
 * parent, and an ENTRY compiled after it finds the object already
 * there (each had had its own: a SAVEd K set through one entry was
 * not the K the other read). */
static int f77_static_obj(char *prefix, char *name, int size, char **out) {
    int fam;
    int g;
    char *nm;
    fam = f77_cur_unit;
    if (fam >= 0 && f77_uentry_parent[fam] >= 0) fam = f77_uentry_parent[fam];
    nm = f77_gpool_name(prefix, f77_uname[fam], "_", name);
    for (g = 0; g < ps_nglobals; g++) {
        if (strcmp(ps_gname[g], nm) == 0) {
            if (size > ps_gsize[g]) ps_gsize[g] = size;
            *out = ps_gname[g];
            return g;
        }
    }
    *out = nm;
    return f77_g_add(nm, size);
}

/* Rebind symbol `s` to static storage at `name`+`off`.  The GADDR (and
 * ADDI) land in whatever block is current -- the declaration part, so
 * the entry block, which dominates every use. */
static void f77_bind_static(int s, char *name, int off) {
    int ga;
    int old;
    int j;
    old = f77_sval[s];
    ga = hi_emit(HI_GADDR, HL_ADDR_TY, -1, -1, 0, name);
    if (off != 0) ga = hi_emit(HI_ADDI, HL_ADDR_TY, ga, -1, off, NULL);
    f77_sval[s] = ga;
    f77_shi[s] = -1;    /* doubles live contiguously in static storage */
    /* A reference made before the binding -- a COMMON member in a
     * dimension bound of the declaration part, INTEGER A(N:M) with M
     * in COMMON -- read the symbol's provisional local slot.  It reads
     * the static now.  (SN713 of FCVS FM711: the extent came from an
     * unset local, which SSA then made nothing at all.) */
    if (old >= 0 && h_kind[old] == HI_ALLOCA) {
        for (j = 0; j < h_ninst; j++) {
            int k;
            k = h_kind[j];
            if (k == HI_NOP || j == ga) continue;
            if (h_src1[j] == old) h_src1[j] = ga;
            if (h_src2[j] == old && ho_src2_is_ref(k)) h_src2[j] = ga;
            if ((k == HI_CALL || k == HI_CALLP) && h_cbase[j] >= 0) {
                int q;
                for (q = 0; q < h_val[j]; q++) if (h_carg[h_cbase[j] + q] == old) h_carg[h_cbase[j] + q] = ga;
            }
        }
    }
}

/* Run once per unit when the declaration part closes: lay out this
 * unit's COMMON members and convert SAVEd locals to statics. */
static void f77_layout_static(void) {
    int i;
    int k;
    int s;
    int blk;
    int sz;
    int boff[F77_MAX_CBLK];

    /* IMPLICIT NONE: every symbol created during the declaration part
     * (dummies included) must have been explicitly typed by now.
     * Names first seen in executable code are caught in f77_sym. */
    if (f77_imp_none) {
        for (s = f77_scope_base; s < f77_nsym; s++) {
            if (f77_styped[s] || f77_sparam[s]) continue;
            {
                static char msg[F77_MAX_NAME + 40];
                strcpy(msg, f77_sname[s]);
                strcat(msg, " is not declared (IMPLICIT NONE)");
                f77_error(msg);
            }
            return;
        }
    }

    for (s = f77_scope_base; s < f77_nsym; s++) {
        if (f77_sty[s] == TY_CHAR && f77_slen[s] < 0 && !f77_sarg[s] && !f77_sparam[s]) {
            static char msg[F77_MAX_NAME + 48];
            strcpy(msg, f77_sname[s]);
            strcat(msg, ": CHARACTER*(*) is only for dummy arguments and PARAMETERs");
            f77_error(msg);
            return;
        }
    }

    /* Hidden lengths: one trailing INTEGER per CHARACTER dummy, in
     * dummy order; an assumed-length dummy reads its length from it. */
    {
        int nh;
        nh = 0;
        for (i = 0; i < f77_ci_n; i++) {
            s = f77_ci_sym[i];
            if (f77_sty[s] != TY_CHAR) continue;
            if (f77_slen[s] < 0)
                f77_slenv[s] = hi_emit(HI_PARAM, TY_INT, -1, -1, f77_unit_nparams + nh, NULL);
            nh = nh + 1;
        }
        if (nh > 0) f77_assign_params(f77_unit_nparams + nh);
    }

    for (i = 0; i < f77_ncblk; i++) boff[i] = 0;

    for (i = 0; i < f77_cm_n; i++) {
        s = f77_cm_sym[i];
        blk = f77_cm_blk[i];
        if (f77_adjustable(s)) {
            f77_error("adjustable dimensions cannot appear in COMMON");
            return;
        }
        f77_bind_static(s, f77_cblk_name[blk], boff[blk]);
        f77_sgidx[s] = f77_cblk_gidx[blk];
        f77_sgoff[s] = boff[blk];
        if (f77_sty[s] == TY_CHAR && f77_slen[s] < 0) {
            f77_error("an assumed-length CHARACTER cannot be in COMMON");
            return;
        }
        sz = f77_esize(s) * f77_sym_nelem(s);
        boff[blk] = boff[blk] + sz;
    }

    /* EQUIVALENCE groups.  Resolve the pairs, then place each group:
     * on the COMMON block of a member that has one (the block grows
     * to cover the group, and may not be extended backwards), else on
     * a static object of the group's own. */
    if (f77_eq_n > 0) {
        int a; int b; int ra; int rb; int oa; int ob;
        for (s = f77_scope_base; s < f77_nsym; s++) { f77_eq_parent[s] = s; f77_eq_delta[s] = 0; }
        for (i = 0; i < f77_eq_n; i++) {
            a = f77_eq_sa[i]; b = f77_eq_sb[i];
            ra = f77_eq_find(a, &oa);
            rb = f77_eq_find(b, &ob);
            /* addr(b) = addr(a) + oa_i - ob_i */
            if (ra == rb) {
                if (oa + f77_eq_oa[i] - f77_eq_ob[i] != ob) {
                    f77_error("inconsistent EQUIVALENCE");
                    return;
                }
                continue;
            }
            f77_eq_parent[rb] = ra;
            f77_eq_delta[rb] = oa + f77_eq_oa[i] - f77_eq_ob[i] - ob;
        }
        for (i = f77_scope_base; i < f77_nsym; i++) {
            int root; int o; int minoff; int maxend; int csym; int coff; int g; int nm_s;
            char *nm;
            if (f77_eq_parent[i] != i) continue;          /* not a root */
            /* Gather the group's extent and any COMMON member. */
            minoff = 0; maxend = 0; csym = -1; coff = 0; nm_s = 0;
            for (s = f77_scope_base; s < f77_nsym; s++) {
                root = f77_eq_find(s, &o);
                if (root != i) continue;
                nm_s = nm_s + 1;
                if (o < minoff) minoff = o;
                sz = f77_esize(s) * f77_sym_nelem(s);
                if (o + sz > maxend) maxend = o + sz;
                if (f77_scom[s]) {
                    if (csym >= 0 && f77_sgidx[csym] != f77_sgidx[s]) {
                        f77_error("EQUIVALENCE joins two COMMON blocks");
                        return;
                    }
                    if (csym < 0 || f77_sgoff[s] - o < coff) { csym = s; coff = f77_sgoff[s] - o; }
                }
            }
            if (nm_s < 2) continue;                        /* a lone symbol */
            if (csym >= 0) {
                /* coff: block offset of the group origin (offset 0). */
                g = f77_sgidx[csym];
                if (coff + minoff < 0) {
                    f77_error("EQUIVALENCE extends a COMMON block backwards");
                    return;
                }
                for (s = f77_scope_base; s < f77_nsym; s++) {
                    root = f77_eq_find(s, &o);
                    if (root != i) continue;
                    if (f77_scom[s]) {
                        if (f77_sgoff[s] != coff + o) { f77_error("inconsistent EQUIVALENCE in COMMON"); return; }
                        continue;
                    }
                    f77_bind_static(s, ps_gname[g], coff + o);
                    f77_sgidx[s] = g;
                    f77_sgoff[s] = coff + o;
                }
                for (k = 0; k < f77_ncblk; k++) {
                    if (f77_cblk_gidx[k] == g && coff + maxend > boff[k]) boff[k] = coff + maxend;
                }
            } else {
                g = f77_static_obj("f77e_", f77_sname[i], maxend - minoff, &nm);
                for (s = f77_scope_base; s < f77_nsym; s++) {
                    root = f77_eq_find(s, &o);
                    if (root != i) continue;
                    f77_bind_static(s, nm, o - minoff);
                    f77_sgidx[s] = g;
                    f77_sgoff[s] = o - minoff;
                }
            }
        }
    }

    for (i = 0; i < f77_ncblk; i++) {
        if (boff[i] > ps_gsize[f77_cblk_gidx[i]])
            ps_gsize[f77_cblk_gidx[i]] = boff[i];
    }

    if (f77_save_all) {
        for (s = f77_scope_base; s < f77_nsym; s++) f77_ssaved[s] = 1;
    }
    for (i = 0; i < f77_sv_n; i++) f77_ssaved[f77_sv_sym[i]] = 1;

    for (s = f77_scope_base; s < f77_nsym; s++) {
        if (!f77_ssaved[s]) continue;
        if (f77_sarg[s] || f77_scom[s] || s == f77_result_sym) continue;
        if (f77_sgidx[s] >= 0) continue;          /* placed by EQUIVALENCE */
        if (f77_adjustable(s)) {
            f77_error("adjustable dimensions cannot be SAVEd");
            return;
        }
        {
            char *nm;
            f77_sgidx[s] = f77_static_obj("f77s_", f77_sname[s],
                                          f77_esize(s) * f77_sym_nelem(s), &nm);
            f77_bind_static(s, nm, 0);
        }
    }

    /* Pour DATA values into the init pool, now that every DATA'd
     * variable is a static object of known size.  A touched object
     * moves from .bss to .data whole: its image is reserved and
     * zeroed first, then each triple lands at element*size. */
    for (i = 0; i < f77_di_n; i++) {
        int g;
        int esz;
        int off;
        s = f77_di_sym[i];
        g = f77_sgidx[s];
        if (g < 0) continue;            /* parse already errored */
        if (ps_ginit_start[g] < 0) {
            if (ps_ginit_pool_len + ps_gsize[g] > PS_MAX_INIT_POOL) {
                f77_error("DATA initializer pool overflow");
                return;
            }
            ps_ginit_start[g] = ps_ginit_pool_len;
            ps_ginit_count[g] = ps_gsize[g];
            for (k = 0; k < ps_gsize[g]; k++)
                ps_ginit_pool[ps_ginit_pool_len + k] = 0;
            ps_ginit_pool_len = ps_ginit_pool_len + ps_gsize[g];
        }
        esz = f77_esize(s);
        off = ps_ginit_start[g] + f77_sgoff[s] + f77_di_elem[i] * esz;
        if (f77_di_sub[i] > 0) {
            off = ps_ginit_start[g] + f77_sgoff[s] + f77_di_elem[i];
            esz = f77_di_sub[i];
        }
        if (f77_di_ty[i] == TY_CHAR) {
            /* A character constant: into a CHARACTER item padded or
             * truncated to its length; into a numeric item (Hollerith
             * data) left-justified, blank-filled.  The image is bytes
             * of the target's character set: EBCDIC on the S/370 (the
             * source is ASCII here; DATA CATN11/'A',.../ of FCVS FM204
             * compared unequal to 'A' until it was). */
            int n;
            n = f77_di_i[i];
            for (k = 0; k < esz; k++)
                ps_ginit_pool[off + k] = f77_target_char((k < n) ?
                    (unsigned char)lex_strpool[lex_str_off[f77_di_sidx[i]] + k] : ' ');
        } else if (f77_sty[s] == TY_CHAR) {
            f77_error("a CHARACTER item needs a character constant in DATA");
            return;
        } else if (f77_iscx(f77_sty[s])) {
            int pw;
            pw = f77_sty[s] == TY_DCPLX ? 8 : 4;
            f77_image_fpt(ps_ginit_pool + off, f77_di_t[i],
                         (f77_di_ty[i] == TY_INT) ? (double)f77_di_i[i] : f77_di_d[i], pw);
            f77_image_fpt(ps_ginit_pool + off + pw, f77_iscx(f77_di_ty[i]) ? f77_di_t2[i] : "0",
                         f77_iscx(f77_di_ty[i]) ? f77_di_d2[i] : 0.0, pw);
        } else if (f77_sty[s] == TY_DOUBLE) {
            f77_image_fpt(ps_ginit_pool + off, f77_di_t[i],
                         (f77_di_ty[i] == TY_INT) ? (double)f77_di_i[i] : f77_di_d[i], 8);
        } else if (f77_sty[s] == TY_FLOAT) {
            f77_image_fpt(ps_ginit_pool + off, f77_di_t[i],
                         (f77_di_ty[i] == TY_INT) ? (double)f77_di_i[i] : f77_di_d[i], 4);
        } else {
            int v;
            v = (f77_di_ty[i] == TY_INT) ? f77_di_i[i] : (int)f77_di_d[i];
            f77_image_int(ps_ginit_pool + off, (unsigned int)v, 4);
        }
    }
}

static void f77_open_do(void) {
    int lab;
    int s;
    int m1, m2, m3;
    int t1, t2, t3;
    int trip_alloca;
    int b_test, b_body, b_exit;
    int c;
    int step_hi;
    step_hi = 0;

    f77_scan_from(f77_do_body);
    /* fort370: without a label the loop ends at END DO (MIL-STD-1753,
     * 1978), its label -1, which no statement carries */
    lab = -1;
    if (lx_t == T_ICON) {
        lab = lex_ival;
        f77_tok();
        if (lx_t == T_COMMA) f77_tok();      /* DO 20, I = ... is accepted */
    }
    if (lx_t != T_NAME) { f77_error("DO needs a loop variable"); return; }
    s = f77_sym(lex_name);
    f77_tok();
    if (lx_t != T_ASSIGN) { f77_error("expected = in DO"); return; }
    f77_tok();
    {
        int vty;
        int m1hi;
        int m2hi;
        int m3hi;
        m3hi = 0;
        vty = f77_sty[s];
        m1 = f77_expr(); m1hi = ex_hi; m1 = f77_cvt(m1, &m1hi, ex_ty, vty);
        if (lx_t != T_COMMA) { f77_error("expected , in DO"); return; }
        f77_tok();
        m2 = f77_expr(); m2hi = ex_hi; m2 = f77_cvt(m2, &m2hi, ex_ty, vty);
        if (lx_t == T_COMMA) {
            f77_tok();
            m3 = f77_expr(); m3hi = ex_hi; m3 = f77_cvt(m3, &m3hi, ex_ty, vty);
        } else {
            m3 = (vty == TY_FLOAT) ? f77_rconst(1.0) :
                 (vty == TY_DOUBLE) ? f77_dconst(1.0, &m3hi) : f77_iconst(1);
        }

        /* var = m1 in the DO variable's type */
        /* Through the symbol's own store: a DOUBLE DO variable lives
         * in split lo/hi slots, and a hand-rolled ADDI+4 store left
         * the promoted hi slot stale (FM719 test 14 summed garbage). */
        f77_store_sym_val(s, m1, vty, m1hi);

        /* Trip count MAX(0, INT((m2-m1+m3)/m3)), then counted as INT. */
        if (vty == TY_FLOAT) {
            t1 = hi_emit(HI_FSUB, TY_FLOAT, m2, m1, 0, NULL);
            t2 = hi_emit(HI_FADD, TY_FLOAT, t1, m3, 0, NULL);
            t3 = hi_emit(HI_FDIV, TY_FLOAT, t2, m3, 0, NULL);
            t3 = hi_emit(HI_FCVT_FtoI, TY_INT, t3, -1, 0, NULL);
        } else if (vty == TY_DOUBLE) {
            {
                int dhi;
                int thi;
                t1 = f77_fp64_call2("__fp64_sub", m2, m2hi, m1, m1hi, &dhi);
                t2 = f77_fp64_call2("__fp64_add", t1, dhi, m3, m3hi, &thi);
                t3 = f77_fp64_call2("__fp64_div", t2, thi, m3, m3hi, &dhi);
                t3 = f77_cvt(t3, &dhi, TY_DOUBLE, TY_INT);
            }
        } else {
            t1 = hi_emit(HI_SUB, TY_INT, m2, m1, 0, NULL);
            t2 = hi_emit(HI_ADD, TY_INT, t1, m3, 0, NULL);
            t3 = hi_emit(HI_DIV, TY_INT, t2, m3, 0, NULL);
        }
        step_hi = m3hi;
    }

    f77_frame = f77_frame + 4;
    trip_alloca = hi_emit(HI_ALLOCA, TY_INT, -1, -1, 0 - f77_frame, NULL);
    hl_ainst[hl_nalloca] = trip_alloca;
    hl_aoff[hl_nalloca] = 0 - f77_frame;
    hl_nalloca = hl_nalloca + 1;
    hi_emit(HI_STORE, TY_INT, trip_alloca, t3, 0, NULL);

    b_test = hir_new_block();
    b_body = hir_new_block();
    b_exit = hir_new_block();

    f77_goto_blk(b_test);
    f77_begin_blk(b_test);
    c = hi_emit(HI_LOAD, TY_INT, trip_alloca, -1, 0, NULL);
    c = hi_emit(HI_SGT, TY_INT, c, f77_iconst(0), 0, NULL);
    hi_emit(HI_BRC, TY_VOID, c, b_body, b_exit, NULL);
    f77_cur_blk_live = 0;

    f77_begin_blk(b_body);

    if (ctl_n >= F77_MAX_CTL) { f77_error("control nesting too deep"); return; }
    ctl_kind[ctl_n] = F77_CTL_DO;
    ctl_label[ctl_n] = lab;
    ctl_var[ctl_n] = s;
    ctl_step[ctl_n] = m3;
    ctl_stephi[ctl_n] = step_hi;
    ctl_trip[ctl_n] = trip_alloca;
    ctl_test[ctl_n] = b_test;
    ctl_body[ctl_n] = b_body;
    ctl_exit[ctl_n] = b_exit;
    ctl_n = ctl_n + 1;
}

/* Close the innermost DO: the step and the trip count, or for a DO
 * WHILE (ctl_var -1) back to its test. */
static void f77_close_top_do(void) {
    int s;
    int v;
    int t;
    {
        ctl_n = ctl_n - 1;
        s = ctl_var[ctl_n];
        if (s < 0) {
            if (f77_cur_blk_live) hi_emit(HI_BR, TY_VOID, -1, -1, ctl_test[ctl_n], NULL);
            f77_cur_blk_live = 0;
            f77_begin_blk(ctl_exit[ctl_n]);
            return;
        }
        if (f77_cur_blk_live) {
            int vty;
            vty = f77_sty[s];
            if (vty == TY_FLOAT) {
                v = hi_emit(HI_LOAD, TY_FLOAT, f77_sval[s], -1, 0, NULL);
                v = hi_emit(HI_FADD, TY_FLOAT, v, ctl_step[ctl_n], 0, NULL);
                hi_emit(HI_STORE, TY_FLOAT, f77_sval[s], v, 0, NULL);
            } else if (vty == TY_DOUBLE) {
                int vlo;
                int vhi;
                int shi;
                vlo = f77_load_sym(s);
                vhi = ex_hi;
                shi = ctl_stephi[ctl_n];
                vlo = f77_fp64_call2("__fp64_add", vlo, vhi,
                                     ctl_step[ctl_n], shi, &vhi);
                f77_store_sym_val(s, vlo, TY_DOUBLE, vhi);
            } else {
                v = hi_emit(HI_LOAD, TY_INT, f77_sval[s], -1, 0, NULL);
                v = hi_emit(HI_ADD, TY_INT, v, ctl_step[ctl_n], 0, NULL);
                hi_emit(HI_STORE, TY_INT, f77_sval[s], v, 0, NULL);
            }
            t = hi_emit(HI_LOAD, TY_INT, ctl_trip[ctl_n], -1, 0, NULL);
            t = hi_emit(HI_ADDI, TY_INT, t, -1, -1, NULL);
            hi_emit(HI_STORE, TY_INT, ctl_trip[ctl_n], t, 0, NULL);
            /* Rotated back edge: test the freshly decremented trip
             * here and branch straight to the body; the header test
             * still guards the zero-trip entry.  The scalar-double
             * gate that once protected fp64-phi loops is gone:
             * live-range splitting (licm_split) frees the registers
             * those loops needed, and rotated double loops now win
             * too (mandel 35.2M -> 28.4M with ZERO spills). */
            v = hi_emit(HI_SGT, TY_INT, t, f77_iconst(0), 0, NULL);
            hi_emit(HI_BRC, TY_VOID, v, ctl_body[ctl_n], ctl_exit[ctl_n], NULL);
        }
        f77_cur_blk_live = 0;
        f77_begin_blk(ctl_exit[ctl_n]);
    }
}

/* Close every DO whose terminal label is the one just executed. */
static void f77_close_do(int lab) {
    while (ctl_n > f77_ctl_base && ctl_kind[ctl_n - 1] == F77_CTL_DO &&
           ctl_label[ctl_n - 1] == lab)
        f77_close_top_do();
}

/* fort370: DO [label [,]] WHILE (e), MIL-STD-1753's: the test block
 * evaluates e and enters the body or leaves; the loop's end, its label
 * or END DO, goes back to the test. */
static void f77_open_dowhile(void) {
    int lab;
    int b_test;
    int b_body;
    int b_exit;
    int c;
    f77_scan_from(2);
    lab = -1;
    if (lx_t == T_ICON) {
        lab = lex_ival;
        f77_tok();
        if (lx_t == T_COMMA) f77_tok();
    }
    f77_tok();                               /* WHILE */
    b_test = hir_new_block();
    b_body = hir_new_block();
    b_exit = hir_new_block();
    f77_goto_blk(b_test);
    f77_begin_blk(b_test);
    c = f77_expr();
    if (ex_ty != TY_INT || !ex_log) f77_error("DO WHILE needs a logical expression");
    hi_emit(HI_BRC, TY_VOID, c, b_body, b_exit, NULL);
    f77_cur_blk_live = 0;
    f77_begin_blk(b_body);
    if (ctl_n >= F77_MAX_CTL) { f77_error("control nesting too deep"); return; }
    ctl_kind[ctl_n] = F77_CTL_DO;
    ctl_label[ctl_n] = lab;
    ctl_var[ctl_n] = -1;
    ctl_test[ctl_n] = b_test;
    ctl_body[ctl_n] = b_body;
    ctl_exit[ctl_n] = b_exit;
    ctl_n = ctl_n + 1;
}

/* Is the statement DO [label [,]] WHILE (e)? */
static int f77_is_dowhile(void) {
    int i;
    if (!f77_starts("DO")) return 0;
    i = 2;
    while (i < lx_stmt_len && lx_isdigit(lx_stmt[i])) i = i + 1;
    if (i > 2 && i < lx_stmt_len && lx_stmt[i] == ',') i = i + 1;
    if (i + 6 > lx_stmt_len || strncmp(lx_stmt + i, "WHILE(", 6) != 0) return 0;
    return f77_match_paren(i + 5) == lx_stmt_len;
}

/* --- subprograms ------------------------------------------------------ */

#define F77_MAX_INLINE_DEPTH 3
/* Default 12 = inlining ON.  For most of this compiler's life the
 * default was 0: inlining measured 2.3x WORSE on LINPACK at every
 * threshold, and the frame note below blamed the by-reference
 * convention.  The convention was never the whole story.  The loss
 * was three register-allocator defects stacked: linear-interval
 * liveness inventing cross-loop interference, coloring failures
 * landing on the hottest nodes because nothing chose spill victims,
 * and pair pins leaking across gc_build rounds once iteration
 * existed.  With per-block liveness + iterated spilling (hir_regalloc)
 * those are gone and threshold 12 measures LINPACK 563M -> 526M
 * (1.048x clang).  F77_INLINE_MAX=<n> still overrides; 0 disables. */
#define F77_INLINE_MAX_STMTS 12

static int f77_inline_depth;
static int f77_inline_unit[F77_MAX_INLINE_DEPTH];
static int f77_inline_ret_blk;       /* where RETURN branches to */
static int f77_inline_result;        /* FUNCTION result symbol, or -1 */
static int f77_ustmts[F77_MAX_UNIT]; /* statement count per unit */
static int f77_unosplice[F77_MAX_UNIT]; /* unit holds scope-stateful
    declarations (COMMON/IMPLICIT/DATA/...) that cannot be re-parsed in
    an executable context: never inline it.  A false positive (DATAX=5
    prefix-matches DATA) only costs a missed inline. */
static int f77_inline_count;         /* diagnostics */
static signed char f77_urelies[F77_MAX_UNIT]; /* fort370: the unit may read a
    local before setting it, counting on the value from its last call
    (f77_check_persistence): never inline it (#15) */



static int f77_result_sym;    /* FUNCTION: the symbol named after the unit */

static int f77_ident_cont(int c) {
    return lx_isalpha(c) || (c >= '0' && c <= '9');
}

/* Length of the identifier at `off`, or 0. */
static int f77_name_at(int off) {
    int n;
    if (off >= lx_stmt_len || !lx_isalpha(lx_stmt[off])) return 0;
    n = 1;
    while (off + n < lx_stmt_len && f77_ident_cont(lx_stmt[off + n]))
        n = n + 1;
    return n;
}

/* True if a blank was squeezed out somewhere in [lo, hi).  Index 0 is
 * the start of the statement, not a squeezed blank. */
static int f77_has_brk(int lo, int hi) {
    int i;
    i = lo;
    if (i < 1) i = 1;
    while (i < hi && i < lx_stmt_len) {
        if (lx_brk[i]) return 1;
        i = i + 1;
    }
    return 0;
}

/* Match `kw` at `off` as a complete token: the letters match, and the
 * next character is not glued onto a longer identifier.  A squeezed
 * blank before that next character (lx_brk) counts as a delimiter, so
 * FUNCTION is complete in `INTEGER FUNCTION F` but not in
 * `INTEGER FUNCTIONAL`.  Returns the offset just past `kw`, or -1. */
static int f77_kw_at(int off, char *kw) {
    int i;
    int k;
    k = 0;
    i = off;
    while (kw[k] != 0) {
        if (i >= lx_stmt_len) return -1;
        if (lx_stmt[i] != kw[k]) return -1;
        k = k + 1;
        i = i + 1;
    }
    if (i < lx_stmt_len && f77_ident_cont(lx_stmt[i]) && lx_brk[i] == 0)
        return -1;
    return i;
}

/* If the statement starts with `kw` as a complete token, or glued
 * specifically to FUNCTION (the INTEGERFUNCTIONF spelling), return
 * strlen(kw); else 0. */
static int f77_type_before_function(char *kw) {
    int n;
    n = (int)strlen(kw);
    if (lx_stmt_len < n) return 0;
    if (strncmp(lx_stmt, kw, n) != 0) return 0;
    if (f77_kw_at(0, kw) >= 0) return n;
    if (lx_stmt_len >= n + 8 && strncmp(lx_stmt + n, "FUNCTION", 8) == 0)
        return n;
    return 0;
}

/* Offset just past `[type] FUNCTION` if this is a function header
 * (`name (` follows); else -1.  Sets *ty_out to the result type.
 *
 * Two spellings, one rule: FUNCTION must be a complete token after
 * the type-spec (gfortran tokenizes on remaining spaces, so
 * FUNCTIONAL stays one name), except the fully squeezed no-space
 * form INTEGERFUNCTIONF(X) which the blank-squeeze was chosen for.
 * A FUNCTION statement also requires the dummy-list parenthesis
 * (F77 8.5); INTEGER FUNCTION G without parens is not a header. */
static int f77_function_kw_end(int *ty_out) {
    int off;
    int fn;
    int n;
    int ty;

    ty = TY_INT;
    off = 0;
    f77_hdr_clen = 1;
    f77_hdr_log = 0;
    f77_hdr_len = 0;
    n = f77_type_before_function("DOUBLEPRECISION");
    if (n > 0) { off = n; ty = TY_DOUBLE; }
#ifdef F77_NATIVE_F64
    else if ((n = f77_type_before_function("DOUBLECOMPLEX")) > 0) { off = n; ty = TY_DCPLX; }
#endif
    else if ((n = f77_type_before_function("CHARACTER")) > 0) {
        off = n;
        ty = TY_CHAR;
        if (off < lx_stmt_len && lx_stmt[off] == '*') {
            /* *n or *(*) by text; *(cexpr) through the scanner. */
            off = off + 1;
            if (off + 2 < lx_stmt_len && lx_stmt[off] == '(' && lx_stmt[off + 1] == '*' &&
                lx_stmt[off + 2] == ')') {
                f77_hdr_clen = -1;
                off = off + 3;
            } else if (off < lx_stmt_len && lx_isdigit(lx_stmt[off])) {
                f77_hdr_clen = 0;
                while (off < lx_stmt_len && lx_isdigit(lx_stmt[off])) {
                    f77_hdr_clen = f77_hdr_clen * 10 + (lx_stmt[off] - '0');
                    off = off + 1;
                }
            } else if (off < lx_stmt_len && lx_stmt[off] == '(') {
                /* Not evaluated here: this is also the test for "is it
                 * a header at all", run in phase 1 where a PARAMETER in
                 * the length is not yet known.  The caller evaluates
                 * once the statement is known to be a header. */
                int end;
                end = f77_match_paren(off);
                if (end < 0) return -1;
                f77_hdr_clen = -2;
                f77_hdr_clen_off = off;
                off = end;
            }
        }
    }
    else {
        n = f77_type_before_function("INTEGER");
        if (n > 0) { off = n; ty = TY_INT; }
        else {
            n = f77_type_before_function("LOGICAL");
            if (n > 0) { off = n; ty = TY_INT; f77_hdr_log = 1; }
            else if ((n = f77_type_before_function("COMPLEX")) > 0) { off = n; ty = TY_CPLX; }
            else {
                n = f77_type_before_function("REAL");
                if (n > 0) { off = n; ty = TY_FLOAT; }
            }
        }
    }

    /* fort370: a length after the type, REAL*8 FUNCTION F(X) */
    if (ty != TY_CHAR && off > 0 && off + 1 < lx_stmt_len && lx_stmt[off] == '*' && lx_isdigit(lx_stmt[off + 1])) {
        int ln;
        ln = 0;
        off = off + 1;
        while (off < lx_stmt_len && lx_isdigit(lx_stmt[off])) { ln = ln * 10 + (lx_stmt[off] - '0'); off = off + 1; }
        ty = f77_lenty(ty, ln, 0);
        f77_hdr_len = ln;
    }
    fn = f77_kw_at(off, "FUNCTION");
    if (fn < 0) {
        /* No-space spelling: only when no blank was squeezed in the
         * prefix through the name, so INTEGER FUNCTIONAL(N) (a blank
         * after INTEGER, FUNCTIONAL one word) is not INTEGER
         * FUNCTION AL(N). */
        if (off + 8 > lx_stmt_len) return -1;
        if (strncmp(lx_stmt + off, "FUNCTION", 8) != 0) return -1;
        n = f77_name_at(off + 8);
        if (n == 0) return -1;
        fn = off + 8;
        if (f77_has_brk(0, fn + n)) return -1;
    } else {
        n = f77_name_at(fn);
        if (n == 0) return -1;
    }
    /* F77 8.5: the dummy list in parens is required, and nothing
     * follows it.  FUNCTIONAL(1)=10 is an array assignment, not
     * FUNCTION AL with dummy 1. */
    if (fn + n >= lx_stmt_len || lx_stmt[fn + n] != '(') return -1;
    if (f77_match_paren(fn + n) != lx_stmt_len) return -1;
    *ty_out = ty;
    return fn;
}

/* If this statement is a `[type] FUNCTION name(...)` header, return the
 * result type; otherwise -1.  Checked before the type-declaration
 * keywords, because `REAL FUNCTION F(X)` squeezes to REALFUNCTIONF(X)
 * and would otherwise parse as a REAL declaration. */
static int f77_unit_header_ty(void) {
    int ty;
    if (f77_function_kw_end(&ty) < 0) return -1;
    return ty;
}

/* Characters to skip to reach the function name on a header we have
 * already classified.  8 is the bare-FUNCTION fallback. */
static int f77_function_skip(void) {
    int ty;
    int n;
    n = f77_function_kw_end(&ty);
    if (n < 0) return 8;
    return n;
}

/* Emit the unit's return.  A FUNCTION returns the variable named after
 * it, which F77 code assigns to; a SUBROUTINE and the main PROGRAM
 * return an int (the exit status, for the PROGRAM). */
static int f77_ret_code = -1;    /* RETURN e: the alternate-return index */
static void f77_emit_return(void) {
    int v;
    if (!f77_cur_blk_live) return;
    f77_emit_copyout();
    if (f77_inline_depth > 0) {
        /* Inside a spliced body a RETURN is a branch to the
         * continuation, not a machine return.  The FUNCTION result is
         * already in its variable, which the caller reads. */
        f77_goto_blk(f77_inline_ret_blk);
        return;
    }
    if (f77_ukind[f77_cur_unit] == F77_UNIT_FUNC && f77_result_sym >= 0) {
        v = f77_load_sym(f77_result_sym);
        if (f77_ispair(ex_ty)) {
            /* Wide result: lo in src1, hi in src2, and ty stays 0 --
             * the convention the C compiler uses for llong/double
             * returns on SLOW-32. */
            hi_emit(HI_RET, 0, v, ex_hi, 0, NULL);
            f77_cur_blk_live = 0;
            return;
        }
        hi_emit(HI_RET, 0, v, -1, 0, NULL);
        f77_cur_blk_live = 0;
        return;
    }
    hi_emit(HI_RET, TY_INT, f77_ret_code >= 0 ? f77_ret_code : f77_iconst(0), -1, 0, NULL);
    f77_cur_blk_live = 0;
}

/* Is the actual starting at the current token just a variable or a
 * single array element -- i.e. does a NAME, optionally followed by a
 * balanced subscript list, run to the very end of this argument?
 *
 * This is a text-level lookahead over the assembled statement rather
 * than a parse-and-rewind, because rewinding would mean un-emitting the
 * HIR the subscript expressions had already produced. */
static int f77_actual_is_simple(void) {
    int i;
    int depth;
    i = (int)(lx_rts - lx_stmt);       /* start of the current token */
    if (i < 0 || i >= lx_stmt_len) return 0;
    if (!lx_isalpha(lx_stmt[i])) return 0;
    while (i < lx_stmt_len &&
           (lx_isalpha(lx_stmt[i]) || lx_isdigit(lx_stmt[i]))) i = i + 1;
    if (i < lx_stmt_len && lx_stmt[i] == '(') {
        depth = 0;
        while (i < lx_stmt_len) {
            if (lx_stmt[i] == '(') depth = depth + 1;
            else if (lx_stmt[i] == ')') {
                depth = depth - 1;
                if (depth == 0) { i = i + 1; break; }
            }
            i = i + 1;
        }
    }
    if (i >= lx_stmt_len) return 0;
    return lx_stmt[i] == ',' || lx_stmt[i] == ')';
}

/* Address of an actual argument.  Fortran is call-by-reference, so a
 * variable or array element is passed as its address; anything else is
 * evaluated into a temporary whose address is passed instead. */
/* The runtime's by-reference version of a specific intrinsic, for
 * passing it as an actual argument (F77 15.9.3: a subset of Table 5). */
static char *f77_intrinsic_proc(char *nm) {
    static char *tab[] = {
        "IABS", "ABS", "DABS", "SQRT", "DSQRT", "EXP", "DEXP", "ALOG", "DLOG",
        "ALOG10", "DLOG10", "SIN", "DSIN", "COS", "DCOS", "TAN", "DTAN",
        "ASIN", "DASIN", "ACOS", "DACOS", "ATAN", "DATAN", "ATAN2", "DATAN2",
        "ARSIN", "DARSIN", "ARCOS", "DARCOS",
        "SINH", "DSINH", "COSH", "DCOSH", "TANH", "DTANH", "AINT", "DINT",
        "ANINT", "DNINT", "NINT", "IDNINT", "MOD", "AMOD", "DMOD", "SIGN",
        "ISIGN", "DSIGN", "DIM", "IDIM", "DDIM", "DPROD", "LEN", "INDEX",
        "AIMAG", "CABS", 0 };
    static char buf[F77_MAX_NAME + 8];
    int i;
    for (i = 0; tab[i]; i++) {
        if (strcmp(tab[i], nm) == 0) {
            char *q;
            strcpy(buf, "f77i_");
            q = buf + 5;
            while (*nm) { *q++ = (char)(*nm >= 'A' && *nm <= 'Z' ? *nm - 'A' + 'a' : *nm); nm++; }
            *q = 0;
            return strdup(buf);
        }
    }
    return NULL;
}

/* Index of an existing symbol, or -1 (no creation). */
static int f77_sym_find(char *nm) {
    return f77_sym_at(nm, f77_scope_base);
}

/* ABS(X) or SF(X) as an actual argument is a value, not a variable:
 * the name is an intrinsic or statement function and not an array. */
static int f77_actual_is_call(char *nm) {
    int s;
    int after;
    after = (int)(lx_rte - lx_stmt);
    if (after >= lx_stmt_len || lx_stmt[after] != '(') return 0;   /* a bare name */
    if (f77_stf_find(nm) >= 0) return 1;
    if (f77_intrinsic(nm) == IN_NONE) return 0;
    s = f77_sym_find(nm);
    return s < 0 || f77_srank[s] == 0;
}

static int f77_actual_addr(void) {
    int s;
    int v;
    int vty;
    int vhi;
    int tmp;

    if (lx_t == T_NAME && f77_actual_is_simple()) {
        /* A bare name that is a procedure -- EXTERNAL, a unit of this
         * file, INTRINSIC, or an intrinsic no variable is using --
         * passes the procedure's address.  A name the unit has typed,
         * stored, shaped or received as a dummy is its variable. */
        int after;
        int sf;
        after = (int)(lx_rte - lx_stmt);
        if (after >= lx_stmt_len || lx_stmt[after] != '(') {
            sf = f77_sym_find(lex_name);
            if (sf < 0 || (!f77_sstored[sf] && f77_srank[sf] == 0 &&
                           !f77_sarg[sf] && !f77_scom[sf] && !f77_sparam[sf])) {
                if ((sf >= 0 && f77_sexternal[sf]) || f77_find_unit(lex_name) >= 0) {
                    char *pn;
                    pn = strdup(lex_name);
                    f77_tok();
                    f77_act_len = -1;
                    return hi_emit(HI_FADDR, HL_ADDR_TY, -1, -1, 0, pn);
                }
                if ((sf >= 0 && f77_sintrinsic[sf]) || f77_intrinsic(lex_name) != IN_NONE) {
                    char *rn;
                    rn = f77_intrinsic_proc(lex_name);
                    f77_tok();
                    f77_act_len = -1;
                    if (rn == NULL) { f77_error("this intrinsic cannot be passed as an argument"); return f77_iconst(0); }
                    return hi_emit(HI_FADDR, HL_ADDR_TY, -1, -1, 0, rn);
                }
            }
        }
    }

    if (lx_t == T_NAME && f77_find_func(lex_name) < 0 && f77_actual_is_simple() &&
        !f77_actual_is_call(lex_name)) {
        /* A bare name, or a subscripted element, is passed by address;
         * a whole array passes its base.  A FUNCTION reference is not a
         * variable, so it falls through and is evaluated below.
         *
         * f77_actual_is_simple() is what keeps `N-K+1` out of this
         * path: without it the leading NAME would be taken as the whole
         * actual, N's address passed, and `-K+1` left unconsumed. */
        s = f77_sym(lex_name);
        /* A PARAMETER is a named constant, not a variable.  Passing
         * its leftover alloca would hand the callee garbage; fall
         * through and evaluate into a temp, like N+0 already does. */

        if (f77_sty[s] == TY_CHAR) {
            f77_tok();
            v = f77_char_ref(s);
            f77_act_len = ex_len;
            if (f77_srank[s] == 0) f77_sstored[s] = 1;
            return v;
        }
        f77_act_len = -1;
        if (!f77_sparam[s]) {
            f77_tok();
            if (lx_t == T_LP && f77_srank[s] > 0) {
                f77_tok();
                return f77_subscript_addr(s);
            }
            /* Taking the address of a split double escapes BOTH halves.
             * The promoter sees the lo alloca in h_carg and rejects it, but
             * the hi alloca appears nowhere -- it would stay promoted while
             * the callee read stale memory at offset+4.  A dead ADDI on the
             * hi slot is an address-taking use, which the promotion scan
             * rejects; DCE removes it afterwards, so it costs nothing in
             * the emitted code. */
            if (f77_srank[s] == 0) f77_sstored[s] = 1;   /* address escapes */
            if (f77_shi[s] >= 0)
                hi_emit(HI_ADDI, HL_ADDR_TY, f77_shi[s], -1, 0, NULL);
            return f77_sval[s];
        }
    }

    v = f77_expr();
    vty = ex_ty;
    vhi = ex_hi;
    if (vty == TY_CHAR) {
        /* A character value is already an address. */
        f77_act_len = ex_len;
        return v;
    }
    f77_act_len = -1;
    f77_frame = f77_frame + f77_tysize(vty);
    tmp = hi_emit(HI_ALLOCA, f77_slotty(vty), -1, -1, 0 - f77_frame, NULL);
    hl_ainst[hl_nalloca] = tmp;
    hl_aoff[hl_nalloca] = 0 - f77_frame;
    hl_nalloca = hl_nalloca + 1;
    f77_store_at(tmp, vty, v, vty, vhi);
    return tmp;
}

/* --- inlining (ON by default since the allocator rework) --------------
 *
 * f77 is one-pass with no AST, so a callee's body is not sitting in a
 * data structure waiting to be spliced.  What IS available is its
 * source offset (phase 1 recorded it), so inlining here means
 * RE-LEXING the callee's body at the call site with its dummy
 * arguments bound to the actuals.
 *
 * Fortran makes the binding unusually clean: arguments are by
 * reference, so a dummy's "value" is just an address.  Inlining
 * therefore binds each dummy symbol to the actual's address value
 * directly -- no PARAM, no marshalling, no call.  That is the entire
 * saving, and on LINPACK it is DAXPY vanishing into DGEFA's inner loop.
 *
 * Everything the callee touches must be scoped: symbols and labels get
 * fresh bases, the control stack is checkpointed (f77_ctl_base -- a
 * callee label must not close a CALLER's DO loop), the caller's
 * assembled statement is saved, and so is the token scanner's own state,
 * or a nested splice resumes the outer call mid-nowhere.
 *
 * HISTORY: this shipped OFF for most of the compiler's life, measured
 * 2.30x-off / 2.79x-at-12 / 6.09x-at-40 vs clang on LINPACK, and a
 * long note here blamed the by-reference convention (a dummy stays an
 * address when spliced, so the splice "only buys call/return").  That
 * explanation is RETRACTED: the loss was the register allocator, not
 * the convention -- linear-interval liveness invented interference
 * between loops laid end to end, coloring failures landed on the
 * hottest nodes, and pair pins leaked across allocation rounds.  With
 * per-block liveness and iterated spilling (see hir_regalloc.h) the
 * same splice at the same threshold 12 measures LINPACK at 1.048x
 * clang against 1.123x with inlining off.  h_ld_ro (F77 15.9.3.6)
 * already hoists the loads the old note said needed scalar
 * replacement.
 *
 * F77_INLINE_MAX=<n> overrides the threshold; 0 disables.
 */

/* Is `u` worth and safe to inline here?  Recursion is excluded by
 * checking the active inline stack, which also covers mutual
 * recursion. */
static int f77_inline_disabled = -1;   /* -1 = not yet probed */
static int f77_inline_max;

static void f77_inline_probe(void) {
    if (f77_inline_disabled < 0) {
        char *e;
        f77_inline_disabled = getenv("F77_NO_INLINE") ? 1 : 0;
        e = getenv("F77_INLINE_MAX");
        f77_inline_max = e ? atoi(e) : F77_INLINE_MAX_STMTS;
    }
}

/* fort370: might u be inlined somewhere?  The part of f77_can_inline
 * that depends on u alone: the scan keeps such a unit's text whole
 * (f77_utext), since the streamed source has passed it by the time a
 * caller wants it. */
static int f77_keep_candidate(int u) {
    f77_inline_probe();
    if (f77_inline_disabled) return 0;
    if (f77_ukind[u] == F77_UNIT_PROGRAM) return 0;
    if (f77_urty[u] == TY_CHAR) return 0;
    if (f77_ustmts[u] > f77_inline_max) return 0;
    if (f77_unosplice[u]) return 0;
    return 1;
}

/* fort370: the scan has reached the end of unit u, at offset end (the
 * next unit's header).  The comment and blank lines between u's END and
 * that header are not kept: a file of small subroutines, each before a
 * block of comments, had kept every block (750K of heap for the 600K
 * file of tests/host/stream.sh). */
static void f77_unit_done(int u, int end) {
    int ls;
    int k;
    while (end > f77_upos[u] && end > lx_lo && end <= lx_hi) {
        ls = end - 1;                  /* the last line: [ls, end) */
        while (ls > f77_upos[u] && ls > lx_lo && lx_src[ls - 1] != '\n') ls = ls - 1;
        if (ls >= end) break;
        if (lx_src[ls] != 'C' && lx_src[ls] != 'c' && lx_src[ls] != '*') {
            k = ls;
            while (k < end && (lx_src[k] == ' ' || lx_src[k] == '\n' || lx_src[k] == '\r')) k = k + 1;
            if (k < end) break;        /* a statement line */
        }
        end = ls;
    }
    f77_uend[u] = end;
    f77_utext[u] = 0;
    if (!lx_streaming || !f77_keep_candidate(u)) return;
    if (f77_upos[u] < lx_lo || end > lx_hi || end <= f77_upos[u]) return;
    f77_utext[u] = (char *)malloc((size_t)(end - f77_upos[u]));
    if (f77_utext[u]) memcpy(f77_utext[u], lx_src + f77_upos[u], (size_t)(end - f77_upos[u]));
}

static int f77_can_inline(int u) {
    int i;
    f77_inline_probe();
    if (f77_inline_disabled) return 0;
    if (u < 0) return 0;
    if (f77_ukind[u] == F77_UNIT_PROGRAM) return 0;
    if (f77_urty[u] == TY_CHAR) return 0;
    if (f77_inline_depth >= F77_MAX_INLINE_DEPTH) return 0;
    if (f77_ustmts[u] > f77_inline_max) return 0;
    if (f77_unosplice[u]) return 0;
    if (f77_urelies[u]) return 0;
    if (u == f77_cur_unit) return 0;
    i = 0;
    while (i < f77_inline_depth) {
        if (f77_inline_unit[i] == u) return 0;
        i = i + 1;
    }
    return 1;
}

/* Bind one dummy argument to an actual's address, as a symbol whose
 * "storage" IS that address.  This is what a by-reference call would
 * have achieved via a PARAM, minus the call. */
static int f77_bind_actual(char *nm, int addr) {
    int s;
    if (f77_nsym >= F77_MAX_SYM) { f77_error("too many symbols"); return 0; }
    s = f77_nsym;
    strcpy(f77_sname[s], nm);
    f77_sym_hash(s);
    f77_sty[s] = f77_implicit_ty(nm);
    f77_srank[s] = 0;
    f77_sarg[s] = 1;
    f77_shi[s] = -1;                 /* by-reference: value is an address */
    /* fort370: and taken as stored.  A dummy's loads are asserted
     * loop-invariant (f77_ldro_note) because nothing else may change
     * it while its own unit runs; spliced, the callee runs as part of
     * the caller, whose loop may be changing the actual -- the DO
     * variable in DO 30 I = ... CALL GEN(I, D), where GEN's D = FLOAT(I)
     * was hoisted out of the loop and every D was GEN(1)'s. */
    f77_sstored[s] = 1;
    f77_dim_row(s, 0);
    f77_sval[s] = addr;
    f77_nsym = f77_nsym + 1;
    return s;
}

static void f77_statement(void);

/* Splice unit `u`'s body in at the current point, with `addrs[0..n)`
 * bound to its dummy arguments.  Returns the FUNCTION result symbol,
 * or -1 for a SUBROUTINE. */
static int f77_inline_unit_body(int u, int *addrs, int nargs) {
    char *save_stmt;                 /* fort370: on the heap, not in the frame: */
    unsigned char *save_brk;         /* this nests (16K a level on the stack) */
    int save_len;
    int save_label;
    int save_line;
    int save_stmt_line;
    int save_pos;
    /* The token scanner runs over lx_stmt, so splicing a callee moves
     * the cursor into the callee's statements.  Restoring the buffer is
     * not enough -- the scanner state and the current token have to come
     * back too, or the caller resumes mid-nowhere.  This is what broke
     * ISQ(ISQ(2)): the outer call resumed with a stale cursor. */
    char *save_rp;
    char *save_rpe;
    char *save_rts;
    char *save_rte;
    int save_rcs;
    int save_ract;
    char *save_src;                  /* fort370: the source being read, */
    int save_lxlen;                  /* its end and whether it is the */
    int save_streaming;              /* streamed window (f77_card.h) */
    int save_t;
    char save_name[F77_MAX_NAME];
    int save_namelen;
    int save_ival;
    double save_dval;
    char save_ftext[128];
    int save_sidx;
    int save_slen;
    int save_scope;
    int save_lblbase;
    int save_nlabel;
    int save_ctl;
    int save_ctl_base;
    int save_unit;
    int save_ret;
    int save_result;
    int save_stf_n;
    int save_stf_pool;
    int save_imp_map[F77_IMP_N];     /* the caller's IMPLICIT, which the */
    int save_imp_len[F77_IMP_N];     /* callee does not share */
    int save_imp_log[F77_IMP_N];
    int save_imp_ready;
    int save_imp_none;
    int b_cont;
    int skip;
    int i;
    int rty;
    int result;

    save_stmt = (char *)malloc(F77_MAX_STMT);
    save_brk = (unsigned char *)malloc(F77_MAX_STMT);
    if (!save_stmt || !save_brk) { f77_error("out of storage"); return -1; }
    /* Checkpoint everything the callee will disturb. */
    memcpy(save_stmt, lx_stmt, lx_stmt_len + 1);
    memcpy(save_brk, lx_brk, lx_stmt_len);
    save_len = lx_stmt_len;
    save_label = lx_stmt_label;
    save_line = lx_line;
    save_stmt_line = lx_stmt_line;
    save_pos = lx_pos;
    save_rp = lx_rp; save_rpe = lx_rpe; save_rts = lx_rts; save_rte = lx_rte;
    save_rcs = lx_rcs; save_ract = lx_ract;
    save_t = lx_t;
    memcpy(save_name, lex_name, F77_MAX_NAME);
    save_namelen = lex_namelen;
    save_ival = lex_ival; save_dval = lex_dval; strcpy(save_ftext, lex_ftext);
    save_sidx = lex_sidx; save_slen = lex_slen;
    save_scope = f77_scope_base;
    save_lblbase = f77_label_base;
    save_nlabel = f77_nlabel;
    save_ctl = ctl_n;
    save_ctl_base = f77_ctl_base;
    save_unit = f77_cur_unit;
    save_ret = f77_inline_ret_blk;
    save_result = f77_inline_result;
    save_stf_n = f77_stf_n;
    save_stf_pool = f77_stf_pool_n;
    /* The callee is typed by its own rules: a unit with an IMPLICIT is
     * never spliced (f77_unosplice), so its rule is the default one,
     * whatever the caller's IMPLICIT or IMPLICIT NONE says.  Under the
     * caller's, IMPLICIT INTEGER (A-Z) made the callee's Y = 2.5 store
     * 2, and IMPLICIT NONE refused its undeclared names. */
    memcpy(save_imp_map, f77_imp_map, sizeof save_imp_map);
    memcpy(save_imp_len, f77_imp_len, sizeof save_imp_len);
    memcpy(save_imp_log, f77_imp_log, sizeof save_imp_log);
    save_imp_ready = f77_imp_ready;
    save_imp_none = f77_imp_none;
    for (i = 0; i < F77_IMP_N; i++) {
        f77_imp_map[i] = (i >= 'I' - 'A' && i <= 'N' - 'A') ? TY_INT : TY_FLOAT;
        f77_imp_len[i] = 1;
        f77_imp_log[i] = 0;
    }
    f77_imp_ready = 1;
    f77_imp_none = 0;

    b_cont = hir_new_block();

    f77_scope_base = f77_nsym;
    f77_label_base = f77_nlabel;
    f77_ctl_base = ctl_n;
    f77_inline_ret_blk = b_cont;
    f77_cur_unit = u;
    f77_inline_unit[f77_inline_depth] = u;
    f77_inline_depth = f77_inline_depth + 1;
    f77_inline_count = f77_inline_count + 1;

    /* Read the callee's header and bind its dummies to the actuals.
     * fort370: from the text the scan kept, the source being streamed. */
    save_src = lx_src;
    save_lxlen = lx_len;
    save_streaming = lx_streaming;
    if (f77_utext[u]) {
        lx_streaming = 0;
        lx_src = f77_utext[u] - f77_upos[u];
        lx_len = f77_uend[u];
        lx_pos = f77_upos[u];
        lx_line = f77_uline[u];
    } else {
        lx_goto(f77_upos[u], f77_uline[u]);
    }
    if (!f77_next_stmt()) { f77_error("inline: empty unit"); }
    if (f77_ukind[u] == F77_UNIT_SUBR) skip = 10;
    else skip = f77_function_skip();
    f77_scan_from(skip);
    if (lx_t == T_NAME) f77_tok();
    i = 0;
    if (lx_t == T_LP) {
        f77_tok();
        while (lx_t == T_NAME) {
            if (i < nargs) f77_bind_actual(lex_name, addrs[i]);
            else           f77_sym(lex_name);   /* missing actual: local */
            i = i + 1;
            f77_tok();
            if (lx_t != T_COMMA) break;
            f77_tok();
        }
        if (lx_t == T_RP) f77_tok();
    }

    result = -1;
    if (f77_ukind[u] == F77_UNIT_FUNC) {
        rty = f77_urty[u];
        result = f77_sym(f77_uname[u]);
        f77_sty[result] = rty;
        f77_sarg[result] = 0;
        f77_realloc_sym(result);
    }
    f77_inline_result = result;

    /* Body. */
    for (;;) {
        if (!f77_next_stmt()) break;
        if (f77_is_unit_end()) break;
        if (f77_unit_header_ty() >= 0 || f77_starts("SUBROUTINE")) break;
        f77_statement();
    }

    f77_goto_blk(b_cont);
    f77_begin_blk(b_cont);

    /* Restore.  The callee's statement functions go with it: a caller
     * variable of the same name must not resolve to them. */
    f77_stf_n = save_stf_n;
    f77_stf_pool_n = save_stf_pool;
    memcpy(f77_imp_map, save_imp_map, sizeof save_imp_map);
    memcpy(f77_imp_len, save_imp_len, sizeof save_imp_len);
    memcpy(f77_imp_log, save_imp_log, sizeof save_imp_log);
    f77_imp_ready = save_imp_ready;
    f77_imp_none = save_imp_none;
    f77_inline_depth = f77_inline_depth - 1;
    f77_cur_unit = save_unit;
    f77_inline_ret_blk = save_ret;
    f77_inline_result = save_result;
    f77_scope_base = save_scope;
    f77_label_base = save_lblbase;
    /* f77_nsym is deliberately NOT restored: the FUNCTION result
     * symbol must outlive the splice so the caller can load it, and
     * the scope base already hides the callee's names. */
    f77_nlabel = save_nlabel;
    ctl_n = save_ctl;
    f77_ctl_base = save_ctl_base;
    if (f77_utext[u]) {
        lx_src = save_src;
        lx_len = save_lxlen;
        lx_streaming = save_streaming;
        lx_pos = save_pos;
        lx_line = save_line;
    } else {
        lx_goto(save_pos, save_line);
    }
    memcpy(lx_stmt, save_stmt, save_len + 1);
    memcpy(lx_brk, save_brk, save_len);
    lx_stmt_len = save_len;
    lx_stmt_line = save_stmt_line;    /* errors later in the CALL are its line's */
    lx_stmt_label = save_label;
    lx_rp = save_rp; lx_rpe = save_rpe; lx_rts = save_rts; lx_rte = save_rte;
    lx_rcs = save_rcs; lx_ract = save_ract;
    lx_t = save_t;
    memcpy(lex_name, save_name, F77_MAX_NAME);
    lex_namelen = save_namelen;
    lex_ival = save_ival; lex_dval = save_dval; strcpy(lex_ftext, save_ftext);
    lex_sidx = save_sidx; lex_slen = save_slen;

    free(save_stmt);
    free(save_brk);
    return result;
}

/* CALL name(a1, a2, ...) */
static void f77_stmt_call(int skip) {
    char nm[F77_MAX_NAME];
    int addrs[64];
    int lens[64];
    int alts[16];
    int nalt;
    int cb;
    int nargs;
    int nc;
    int r;
    int fptr;

    f77_scan_from(skip);
    if (lx_t != T_NAME) { f77_error("CALL needs a subroutine name"); return; }
    strcpy(nm, lex_name);
    f77_tok();

    nargs = 0;
    nalt = 0;
    if (lx_t == T_LP) {
        f77_tok();
        if (lx_t != T_RP) {
            for (;;) {
                if (lx_t == T_STAR) {
                    /* *label: an alternate return */
                    f77_tok();
                    if (lx_t != T_ICON) { f77_error("* needs a statement label"); return; }
                    if (nalt < 16) { alts[nalt] = lex_ival; nalt = nalt + 1; }
                    f77_tok();
                    if (lx_t != T_COMMA) break;
                    f77_tok();
                    continue;
                }
                /* Evaluated before any h_carg slot is reserved -- see
                 * the note in the FUNCTION path. */
                if (nargs < 64) { addrs[nargs] = f77_actual_addr(); lens[nargs] = f77_act_len; }
                else f77_actual_addr();
                nargs = nargs + 1;
                if (lx_t != T_COMMA) break;
                f77_tok();
            }
        }
        if (lx_t != T_RP) f77_error("expected ) after arguments");
        else f77_tok();
    }
    fptr = -1;
    {
        int ds;
        ds = f77_sym_find(nm);
        if (ds >= 0 && f77_sarg[ds] && f77_srank[ds] == 0) fptr = f77_sval[ds];   /* dummy procedure */
    }
    if (fptr < 0 && nalt == 0) {
        int u;
        u = f77_find_unit(nm);
        if (u >= 0 && f77_can_inline(u)) {
            f77_inline_unit_body(u, addrs, nargs);
            return;
        }
    }
    cb = h_ncarg;
    nc = 0;
    {
        int ai;
        ai = 0;
        while (ai < nargs) {
            h_carg[h_ncarg] = addrs[ai];
            h_carg_tag[h_ncarg] = 0;
            h_ncarg = h_ncarg + 1;
            nc = nc + 1;
            ai = ai + 1;
        }
        for (ai = 0; ai < nargs; ai++) {
            if (lens[ai] < 0) continue;
            h_carg[h_ncarg] = lens[ai]; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
            nc = nc + 1;
        }
    }
    if (fptr >= 0) r = hi_emit(HI_CALLP, TY_INT, fptr, -1, nc, NULL);
    else r = hi_emit(HI_CALL, TY_INT, -1, -1, nc, strdup(nm));
    h_cbase[r] = cb;
    if (nalt > 0) {
        /* RETURN k in the callee comes back as k: branch to the k-th
         * label, fall through on 0 or out of range. */
        int i;
        for (i = 0; i < nalt; i++) {
            int c; int b_next;
            c = hi_emit(HI_SEQ, TY_INT, r, f77_iconst(i + 1), 0, NULL);
            b_next = hir_new_block();
            hi_emit(HI_BRC, TY_VOID, c, f77_label_blk(alts[i]), b_next, NULL);
            f77_cur_blk_live = 0;
            f77_begin_blk(b_next);
        }
    }
}


/* --- scalar dummy copy-in / copy-out ---------------------------------
 *
 * A by-reference scalar dummy is re-loaded through its address at every
 * use, and LICM cannot hoist those loads out of a loop that stores
 * through any other pointer, because it has no alias analysis.  In
 * DAXPY that costs two loads of DA on every iteration.
 *
 * Fortran, unlike C, says those loads ARE invariant: if a dummy
 * argument is assigned, no other name may be associated with the same
 * storage (F77 15.9.3.6).  DY is assigned, so DA cannot alias it.  This
 * is the rule that historically made Fortran faster than C on numeric
 * code, and it is available here for free.
 *
 * So each scalar dummy is copied into a local on entry and copied back
 * at every RETURN.  Copy-out keeps routines like SWAP correct; arrays
 * are left alone, since copying them would cost more than it saves.
 *
 * MEASURED A LOSS, so it is OFF by default (F77_COPYIN=1 to enable):
 * 2.14x clang without it, 3.09x with, and DAXPY's hot loop went from 17
 * instructions to 30.  The reason is not the idea but a deeper gap:
 * DOUBLE PRECISION locals are NEVER register-promoted in this compiler,
 * so the "local copy" is still a memory access -- no load is saved --
 * while the extra live values push the allocator into spilling.  A
 * program with one double and one integer emits twelve frame accesses.
 *
 * mem2reg refuses a double alloca because reaching its hi word takes
 * the alloca's address (ADDI base,4), which every promotion scan treats
 * as address-taken.  Promoting doubles needs PAIR-AWARE promotion --
 * one alloca becoming two SSA values -- and until that exists, copy-in
 * has nothing to win.
 *
 * The copies are emitted at the first EXECUTABLE statement rather than
 * at the header, because in a one-pass compiler the dummy's type is not
 * known until its declaration has been read -- and F77 requires all
 * declarations to precede executable statements, so that point is
 * exactly when every type is known. */
static int f77_decls_open;               /* still in the declaration part */

/* Compiling an ENTRY: the parent's whole text is compiled, and control
 * goes from the declarations straight to the ENTRY statement on
 * f77_entry_line.  A GO TO from after the ENTRY back into the text
 * before it is legal, and that text has to be there to go to.
 * 0 = not an ENTRY, 1 = branch not yet emitted, 2 = branched, the
 * parent's text before the ENTRY is being compiled, 3 = past it. */
static int f77_entry_state;
static int f77_entry_line;
static int f77_entry_blk;

static int f77_copyin_on = -1;

static void f77_emit_copyin(void) {
    int i;
    /* The declaration part is closing: every member's type and shape
     * is final, so COMMON blocks and SAVEd locals can be laid out. */
    f77_layout_static();
    if (f77_copyin_on < 0) f77_copyin_on = getenv("F77_COPYIN") ? 1 : 0;
    if (!f77_copyin_on) { f77_decls_open = 0; f77_ci_n = 0; return; }
    int s;
    int a;
    int v;
    int hi;
    f77_decls_open = 0;
    i = 0;
    while (i < f77_ci_n) {
        s = f77_ci_sym[i];
        a = f77_ci_addr[i];
        if (f77_srank[s] == 0) {
            /* Give the symbol real local storage and seed it --
             * through f77_realloc_sym, so a double copy gets the
             * SPLIT lo/hi slots every declared local gets.  The
             * 2026-08-27 measurement that sank copy-in predates the
             * split: the copy was one 8-byte alloca, reached by
             * ADDI base,4, address-taken, never promoted -- so no
             * load was saved while the extra live values spilled. */
            hi = -1;
            v = f77_load_at(a, f77_sty[s]);
            hi = ex_hi;
            f77_sarg[s] = 0;
            f77_frame = f77_frame + 4;
            f77_sval[s] = hi_emit(HI_ALLOCA, TY_INT, -1, -1,
                                  0 - f77_frame, NULL);
            hl_ainst[hl_nalloca] = f77_sval[s];
            hl_aoff[hl_nalloca] = 0 - f77_frame;
            hl_nalloca = hl_nalloca + 1;
            f77_realloc_sym(s);
            f77_store_sym_val(s, v, f77_sty[s], hi);
            i = i + 1;
        } else {
            /* An array dummy keeps its by-reference binding. */
            f77_ci_sym[i] = f77_ci_sym[f77_ci_n - 1];
            f77_ci_addr[i] = f77_ci_addr[f77_ci_n - 1];
            f77_ci_n = f77_ci_n - 1;
        }
    }
}

/* Write the local copies back through their original addresses. */
static void f77_emit_copyout(void) {
    int i;
    int s;
    int v;
    i = 0;
    while (i < f77_ci_n) {
        s = f77_ci_sym[i];
        if (!f77_sarg[s]) {
            v = f77_load_sym(s);
            f77_store_at(f77_ci_addr[i], f77_sty[s], v, f77_sty[s], ex_hi);
        }
        i = i + 1;
    }
}

static int f77_urty_of(int u) { return f77_urty[u]; }

/* Index of the FUNCTION unit called `nm`, or -1.  Phase 1 records every
 * unit in the file before any of them is compiled, so a call can be
 * resolved even when the callee appears later in the source. */
/* Any program unit with this name -- SUBROUTINE or FUNCTION. */
static int f77_find_unit(char *nm) {
    int i;
    i = 0;
    while (i < f77_nunit) {
        if (f77_ukind[i] != F77_UNIT_PROGRAM &&
            strcmp(f77_uname[i], nm) == 0) return i;
        i = i + 1;
    }
    return -1;
}

static int f77_find_func(char *nm) {
    int i;
    i = 0;
    while (i < f77_nunit) {
        if (f77_ukind[i] == F77_UNIT_FUNC && strcmp(f77_uname[i], nm) == 0)
            return i;
        i = i + 1;
    }
    return -1;
}

/* Record the unit's name from its header statement. */
static void f77_unit_name(int u) {
    int skip;
    if (f77_starts("SUBROUTINE")) skip = 10;
    else skip = f77_function_skip();
    f77_scan_from(skip);
    if (lx_t == T_NAME) strcpy(f77_uname[u], lex_name);
    else { f77_error("subprogram needs a name"); strcpy(f77_uname[u], "unnamed"); }
}

/* Resolve where `n` incoming arguments arrive.  Without this the
 * codegen's entry sequence is skipped entirely (it gates on h_val <
 * hl_param_nflat) and the argument registers are never moved into the
 * registers the allocator chose -- which silently "works" only when
 * the allocator happens to pick the ABI register.  Every Fortran
 * argument is one 32-bit word (an address, or a hidden CHARACTER
 * length), so every tag is 0.  Called again from f77_layout_static
 * when the declarations turn out to add hidden lengths: a later
 * argument never moves an earlier one, so re-running is safe. */
static void f77_assign_params(int n) {
    int i;
    int ord;
    i = 0;
    while (i < 64) { hl_param_tags[i] = 0; i = i + 1; }
    hl_param_nflat = n;
    hl_nparams = n;
    hi_abi_assign(hl_param_tags, hl_param_nflat, hl_param_map);
    ord = 0;
    i = 0;
    while (i < hl_param_nflat) {
        if (hl_param_map[i] < 0) { hl_param_stkord[i] = ord; ord = ord + 4; }
        else hl_param_stkord[i] = -1;
        i = i + 1;
    }
}

/* Bind this unit's header: record its dummy arguments as by-reference
 * symbols backed by HIR PARAMs, and, for a FUNCTION, create the result
 * variable that shares the unit's name. */
static void f77_bind_unit(int u) {
    int skip;
    int s;
    int nparam;
    int rty;

    f77_cur_unit = u;
    f77_result_sym = -1;
    nparam = 0;
    f77_unit_nparams = 0;
    f77_ci_n = 0;
    f77_decls_open = 1;
    f77_cm_n = 0;
    f77_save_all = 0;
    f77_sv_n = 0;
    f77_di_n = 0;
    f77_ldro_n = 0;
    f77_stf_n = 0;
    f77_stf_pool_n = 0;
    f77_stfb_n = 0;
    f77_eq_n = 0;

    /* Reset the implicit-typing map to the default rule. */
    {
        int c;
        for (c = 0; c < F77_IMP_N; c++) {
            f77_imp_map[c] = (c >= 'I' - 'A' && c <= 'N' - 'A') ? TY_INT : TY_FLOAT;
            f77_imp_len[c] = 1;
            f77_imp_log[c] = 0;
        }
    }
    f77_imp_ready = 1;
    f77_imp_none = 0;

    if (f77_ukind[u] == F77_UNIT_PROGRAM || f77_ukind[u] == F77_UNIT_BDATA) {
        hl_param_nflat = 0;
        hl_nparams = 0;
        return;
    }

    /* Skip past the keyword and the unit name to the argument list. */
    skip = 0;
    if (f77_uentry_parent[u] >= 0) skip = 5;                   /* ENTRY */
    else if (f77_ukind[u] == F77_UNIT_SUBR) skip = 10;         /* SUBROUTINE */
    else {
        rty = f77_unit_header_ty();
        skip = f77_function_skip();
        (void)rty;
    }
    f77_scan_from(skip);
    if (lx_t != T_NAME) { f77_error("subprogram needs a name"); return; }
    f77_tok();

    /* A CHARACTER FUNCTION takes its result buffer and length as two
     * hidden leading arguments; the dummies follow. */
    if (f77_ukind[u] == F77_UNIT_FUNC && f77_urty[u] == TY_CHAR) nparam = 2;

    if (lx_t == T_LP) {
        f77_tok();
        if (lx_t != T_RP) {
            for (;;) {
                if (lx_t == T_STAR) {
                    /* alternate return: no argument travels for it */
                    f77_tok();
                    if (lx_t != T_COMMA) break;
                    f77_tok();
                    continue;
                }
                if (lx_t != T_NAME) { f77_error("bad dummy argument"); break; }
                s = f77_sym_param(lex_name, nparam);
                if (f77_ci_n < F77_MAX_COPYIN) {
                    f77_ci_sym[f77_ci_n] = s;
                    f77_ci_addr[f77_ci_n] = f77_sval[s];
                    f77_ci_n = f77_ci_n + 1;
                }
                nparam = nparam + 1;
                f77_tok();
                if (lx_t != T_COMMA) break;
                f77_tok();
            }
        }
        if (lx_t == T_RP) f77_tok();
    }

    f77_unit_nparams = nparam;
    f77_assign_params(nparam);

    if (f77_ukind[u] == F77_UNIT_FUNC && f77_urty[u] == TY_CHAR) {
        /* The result is the caller's buffer: a by-reference CHARACTER
         * dummy in all but name, with its length in hidden param 1. */
        f77_result_sym = f77_sym_param(f77_uname[u], 0);
        f77_sty[f77_result_sym] = TY_CHAR;
        f77_styped[f77_result_sym] = 1;
        f77_slen[f77_result_sym] = f77_urlen[u];
        f77_slenv[f77_result_sym] = hi_emit(HI_PARAM, TY_INT, -1, -1, 1, NULL);
    } else if (f77_ukind[u] == F77_UNIT_FUNC) {
        f77_result_sym = f77_sym(f77_uname[u]);
        f77_sty[f77_result_sym] = f77_urty[u];
        f77_slog[f77_result_sym] = f77_urlog[u];
        /* A typed header (INTEGER FUNCTION F...) is an explicit
         * declaration; a bare FUNCTION F relies on implicit typing,
         * which a later IMPLICIT may not change (phase 1 already told
         * every caller the result type). */
        f77_styped[f77_result_sym] = (skip != 8 && skip != 5) ? 1 : 0;
        f77_realloc_sym(f77_result_sym);
    }

    /* Phantoms for the family's other dummies (see f77_famd_name). */
    if (f77_ukind[u] != F77_UNIT_PROGRAM && f77_ukind[u] != F77_UNIT_BDATA) {
        int fam;
        int q;
        fam = f77_uentry_parent[u] >= 0 ? f77_uentry_parent[u] : u;
        for (q = 0; q < f77_nfamd; q++) {
            int du;
            int ps;
            du = f77_famd_unit[q];
            if (du == u) continue;
            if (du != fam && f77_uentry_parent[du] != fam) continue;
            ps = f77_sym_find(f77_famd_name[q]);
            if (ps >= 0) continue;                    /* a real dummy of this unit, or seen */
            ps = f77_sym(f77_famd_name[q]);           /* a frame slot ... */
            f77_sarg[ps] = 1;                         /* ... treated as the address passed */
        }
    }

    /* Entry names and the function name denote one result (F77 15.7.3). */
    if (f77_ukind[u] == F77_UNIT_FUNC && f77_result_sym >= 0) {
        int fam;
        int e;
        fam = f77_uentry_parent[u] >= 0 ? f77_uentry_parent[u] : u;
        for (e = 0; e < f77_nunit; e++) {
            if (e == u) continue;
            if (e != fam && f77_uentry_parent[e] != fam) continue;
            if (f77_stfb_n < F77_MAX_STFB) {
                strcpy(f77_stfb_name[f77_stfb_n], f77_uname[e]);
                f77_stfb_sym[f77_stfb_n] = f77_result_sym;
                f77_stfb_n = f77_stfb_n + 1;
            }
        }
    }
}

/* Is the assembled statement a specification statement for the purpose
 * of compiling an ENTRY: a declaration, or a statement function? */
static int f77_is_spec_stmt(void) {
    int cls;
    int i;
    int eq;
    cls = f77_classify();
    if (f77_stmt_is_declaration(cls)) return 1;
    if (cls != S_ASSIGN) return 0;
    i = 0;
    while (i < lx_stmt_len && (lx_isalpha(lx_stmt[i]) || lx_isdigit(lx_stmt[i]))) i = i + 1;
    if (i == 0 || i >= lx_stmt_len || lx_stmt[i] != '(') return 0;
    eq = f77_toplevel('=', 0);
    if (eq < 0 || f77_match_paren(i) != eq) return 0;
    {
        char nm[F77_MAX_NAME];
        int sf;
        if (i >= F77_MAX_NAME) return 0;
        memcpy(nm, lx_stmt, i); nm[i] = 0;
        sf = f77_sym_find(nm);
        if (sf >= 0 && (f77_srank[sf] > 0 || f77_sty[sf] == TY_CHAR)) return 0;
    }
    return 1;
}

/* --- formatted I/O ---------------------------------------------------- */

/* WRITE and READ share the list walkers (f77_wr_one and friends):
 * implied-DOs, whole arrays, and the comma structure are identical in
 * both directions.  f77_io_rd flips the leaves -- a WRITE leaf loads a
 * value and hands it to f77_wr_*, a READ leaf takes the item's ADDRESS
 * and hands it to f77_rd_*, which stores through it. */
static int f77_io_rd;

/* Emit the call that hands one item to the runtime, choosing the entry
 * point by the item's type.  Doubles travel as an aligned register pair
 * (tags 1/2), which is the ABI a C callee taking a double expects. */
static void f77_wr_item(int v, int vty, int vhi) {
    int cb;
    int r;
    cb = h_ncarg;
    if (f77_iscx(vty)) {
        h_carg[h_ncarg] = v;   h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
        h_carg[h_ncarg] = vhi; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
        r = hi_emit(HI_CALL, TY_INT, -1, -1, 2, vty == TY_DCPLX ? "f77_wr_z" : "f77_wr_c");
        h_cbase[r] = cb;
        return;
    }
    if (vty == TY_DOUBLE) {
#ifdef F77_NATIVE_F64
        h_carg[h_ncarg] = v; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
        r = hi_emit(HI_CALL, TY_INT, -1, -1, 1, "f77_wr_d");
#else
        h_carg[h_ncarg] = v;   h_carg_tag[h_ncarg] = 1; h_ncarg = h_ncarg + 1;
        h_carg[h_ncarg] = vhi; h_carg_tag[h_ncarg] = 2; h_ncarg = h_ncarg + 1;
        r = hi_emit(HI_CALL, TY_INT, -1, -1, 2, "f77_wr_d");
#endif
    } else if (vty == TY_FLOAT) {
        h_carg[h_ncarg] = v; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
        r = hi_emit(HI_CALL, TY_INT, -1, -1, 1, "f77_wr_r");
    } else {
        h_carg[h_ncarg] = v; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
        r = hi_emit(HI_CALL, TY_INT, -1, -1, 1, "f77_wr_i");
    }
    h_cbase[r] = cb;
}

/* READ leaf: hand the runtime the item's address to store through.
 * INTEGER and LOGICAL both travel as TY_INT; the runtime tells I and L
 * apart by the format descriptor, not the type. */
static void f77_rd_item(int addr, int ty) {
    int cb;
    int r;
    if (f77_io_unf) {
        int args[2];
        args[0] = addr;
        args[1] = (ty == TY_CHAR) ? f77_rd_len : f77_iconst(f77_tysize(ty));
        f77_call_i("f77_ru", 2, args);
        return;
    }
    if (ty == TY_CHAR) {
        int args[2];
        args[0] = addr; args[1] = f77_rd_len;
        f77_call_i("f77_rd_s", 2, args);
        return;
    }
    cb = h_ncarg;
    h_carg[h_ncarg] = addr; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    if (ty == TY_CPLX)
        r = hi_emit(HI_CALL, TY_INT, -1, -1, 1, "f77_rd_c");
    else if (ty == TY_DCPLX)
        r = hi_emit(HI_CALL, TY_INT, -1, -1, 1, "f77_rd_z");
    else if (ty == TY_DOUBLE)
        r = hi_emit(HI_CALL, TY_INT, -1, -1, 1, "f77_rd_d");
    else if (ty == TY_FLOAT)
        r = hi_emit(HI_CALL, TY_INT, -1, -1, 1, "f77_rd_r");
    else
        r = hi_emit(HI_CALL, TY_INT, -1, -1, 1, "f77_rd_i");
    h_cbase[r] = cb;
}

/* A READ list item must be a variable or an array element -- somewhere
 * to store.  Same address recipe as f77_actual_addr's simple path,
 * including the address-taking escape on a split double's hi slot: the
 * runtime stores 8 contiguous bytes through the lo address, so both
 * halves must stay in memory. */
static int f77_rd_target(int *tyo) {
    int s;
    if (lx_t != T_NAME) {
        f77_error("READ list item must be a variable or array element");
        *tyo = TY_INT;
        return f77_iconst(0);
    }
    s = f77_sym(lex_name);
    if (f77_sparam[s]) {
        f77_error("cannot READ into a PARAMETER");
        *tyo = TY_INT;
        return f77_iconst(0);
    }
    f77_sstored[s] = 1;
    f77_tok();
    *tyo = f77_sty[s];
    if (f77_sty[s] == TY_CHAR) {
        int a;
        a = f77_char_ref(s);
        f77_rd_len = ex_len;
        return a;
    }
    if (lx_t == T_LP && f77_srank[s] > 0) {
        f77_tok();
        return f77_subscript_addr(s);
    }
    if (f77_shi[s] >= 0)
        hi_emit(HI_ADDI, HL_ADDR_TY, f77_shi[s], -1, 0, NULL);
    return f77_sval[s];
}

/* Does the parenthesised group starting at `open` look like an
 * implied-DO?  It does when the group contains a top-level `=` -- an
 * ordinary parenthesised expression never has one.  Reports the offset
 * just past the closing paren, the `=`, where the items start, and
 * where the control variable begins. */
static int f77_implied_do_spans(int open, int *close_off, int *eq_off,
                                int *items_off, int *ctl_off) {
    int i;
    int depth;
    int eq;
    int comma;

    if (open >= lx_stmt_len || lx_stmt[open] != '(') return 0;
    depth = 0;
    eq = -1;
    comma = -1;
    i = open;
    while (i < lx_stmt_len) {
        if (lx_stmt[i] == '\'') {
            i = i + 1;
            while (i < lx_stmt_len && lx_stmt[i] != '\'') i = i + 1;
        } else if (lx_stmt[i] == '(') depth = depth + 1;
        else if (lx_stmt[i] == ')') {
            depth = depth - 1;
            if (depth == 0) break;
        } else if (depth == 1) {
            if (lx_stmt[i] == '=' && eq < 0) eq = i;
            else if (lx_stmt[i] == ',' && eq < 0) comma = i;
        }
        i = i + 1;
    }
    if (i >= lx_stmt_len || eq < 0 || comma < 0) return 0;
    *close_off = i + 1;
    *eq_off = eq;
    *items_off = open + 1;
    *ctl_off = comma + 1;
    return 1;
}

/* One element of a whole array in an I/O list, `off` its element number. */
static void f77_whole_item(int s, int off) {
    int byte;
    int addr;
    int v;
    int vhi;
    byte = f77_elem_bytes(s, off);
    addr = hi_emit(HI_ADD, HL_ADDR_TY, f77_sval[s], byte, 0, NULL);
    if (f77_io_unf) {
        int args[2];
        args[0] = addr;
        args[1] = (f77_sty[s] == TY_CHAR && f77_slen[s] < 0) ? f77_slenv[s] : f77_iconst(f77_esize(s));
        f77_call_i(f77_io_rd ? "f77_ru" : "f77_wu", 2, args);
    } else if (f77_sty[s] == TY_CHAR) {
        int args[2];
        args[0] = addr;
        args[1] = (f77_slen[s] >= 0) ? f77_iconst(f77_slen[s]) : f77_slenv[s];
        f77_call_i(f77_io_rd ? "f77_rd_s" : "f77_wr_a", 2, args);
    } else if (f77_io_rd) {
        f77_rd_item(addr, f77_sty[s]);
    } else {
        v = f77_load_at(addr, f77_sty[s]);
        vhi = ex_hi;
        f77_wr_item(v, f77_sty[s], vhi);
    }
}

/* Column-major expansion of an unsubscripted array in an I/O list. */
static void f77_wr_whole_array(int s) {
    int rank;
    int k;
    int iv[F77_MAX_RANK];
    int trip[F77_MAX_RANK];
    int b_test[F77_MAX_RANK];
    int b_body[F77_MAX_RANK];
    int b_exit[F77_MAX_RANK];
    int c;
    int t;
    int idx;
    int off;
    int cstride;

    rank = f77_srank[s];
    if (f77_adjustable(s)) {
        /* fort370: an adjustable array's extents are run-time values;
         * its elements, in storage order, are one run of the product of
         * them -- one loop over the element number */
        int n;
        n = f77_iconst(1);
        for (k = 0; k < rank; k++)
            n = hi_emit(HI_MUL, TY_INT, n, f77_sextv[s][k] >= 0 ? f77_sextv[s][k] : f77_iconst(f77_sext[s][k]), 0, NULL);
        f77_frame = f77_frame + 4;
        iv[0] = hi_emit(HI_ALLOCA, TY_INT, -1, -1, 0 - f77_frame, NULL);
        hl_ainst[hl_nalloca] = iv[0];
        hl_aoff[hl_nalloca] = 0 - f77_frame;
        hl_nalloca = hl_nalloca + 1;
        hi_emit(HI_STORE, TY_INT, iv[0], f77_iconst(0), 0, NULL);
        b_test[0] = hir_new_block();
        b_body[0] = hir_new_block();
        b_exit[0] = hir_new_block();
        f77_goto_blk(b_test[0]);
        f77_begin_blk(b_test[0]);
        c = hi_emit(HI_LOAD, TY_INT, iv[0], -1, 0, NULL);
        c = hi_emit(HI_SLT, TY_INT, c, n, 0, NULL);
        hi_emit(HI_BRC, TY_VOID, c, b_body[0], b_exit[0], NULL);
        f77_cur_blk_live = 0;
        f77_begin_blk(b_body[0]);
        off = hi_emit(HI_LOAD, TY_INT, iv[0], -1, 0, NULL);
        f77_whole_item(s, off);
        idx = hi_emit(HI_LOAD, TY_INT, iv[0], -1, 0, NULL);
        idx = hi_emit(HI_ADDI, TY_INT, idx, -1, 1, NULL);
        hi_emit(HI_STORE, TY_INT, iv[0], idx, 0, NULL);
        hi_emit(HI_BR, TY_VOID, -1, -1, b_test[0], NULL);
        f77_cur_blk_live = 0;
        f77_begin_blk(b_exit[0]);
        return;
    }
    for (k = rank - 1; k >= 0; k--) {
        f77_frame = f77_frame + 4;
        iv[k] = hi_emit(HI_ALLOCA, TY_INT, -1, -1, 0 - f77_frame, NULL);
        hl_ainst[hl_nalloca] = iv[k];
        hl_aoff[hl_nalloca] = 0 - f77_frame;
        hl_nalloca = hl_nalloca + 1;
        f77_frame = f77_frame + 4;
        trip[k] = hi_emit(HI_ALLOCA, TY_INT, -1, -1, 0 - f77_frame, NULL);
        hl_ainst[hl_nalloca] = trip[k];
        hl_aoff[hl_nalloca] = 0 - f77_frame;
        hl_nalloca = hl_nalloca + 1;
        hi_emit(HI_STORE, TY_INT, iv[k], f77_iconst(f77_slo[s][k]), 0, NULL);
        hi_emit(HI_STORE, TY_INT, trip[k], f77_iconst(f77_sext[s][k]), 0, NULL);
        b_test[k] = hir_new_block();
        b_body[k] = hir_new_block();
        b_exit[k] = hir_new_block();
        f77_goto_blk(b_test[k]);
        f77_begin_blk(b_test[k]);
        c = hi_emit(HI_LOAD, TY_INT, trip[k], -1, 0, NULL);
        c = hi_emit(HI_SGT, TY_INT, c, f77_iconst(0), 0, NULL);
        hi_emit(HI_BRC, TY_VOID, c, b_body[k], b_exit[k], NULL);
        f77_cur_blk_live = 0;
        f77_begin_blk(b_body[k]);
    }
    off = f77_iconst(0);
    cstride = 1;
    for (k = 0; k < rank; k++) {
        idx = hi_emit(HI_LOAD, TY_INT, iv[k], -1, 0, NULL);
        if (f77_slo[s][k] != 0)
            idx = hi_emit(HI_ADDI, TY_INT, idx, -1, 0 - f77_slo[s][k], NULL);
        if (cstride != 1)
            idx = hi_emit(HI_MUL, TY_INT, idx, f77_iconst(cstride), 0, NULL);
        off = hi_emit(HI_ADD, TY_INT, off, idx, 0, NULL);
        cstride = cstride * f77_sext[s][k];
    }
    f77_whole_item(s, off);
    for (k = 0; k < rank; k++) {
        idx = hi_emit(HI_LOAD, TY_INT, iv[k], -1, 0, NULL);
        idx = hi_emit(HI_ADDI, TY_INT, idx, -1, 1, NULL);
        hi_emit(HI_STORE, TY_INT, iv[k], idx, 0, NULL);
        t = hi_emit(HI_LOAD, TY_INT, trip[k], -1, 0, NULL);
        t = hi_emit(HI_ADDI, TY_INT, t, -1, -1, NULL);
        hi_emit(HI_STORE, TY_INT, trip[k], t, 0, NULL);
        hi_emit(HI_BR, TY_VOID, -1, -1, b_test[k], NULL);
        f77_cur_blk_live = 0;
        f77_begin_blk(b_exit[k]);
    }
}

/* One element of an output list: an expression, a character constant,
 * or an implied-DO `(items, VAR = e1, e2 [, e3])`, which becomes a real
 * loop around the item calls. */
static void f77_wr_list(void);

static void f77_wr_one(void) {
    int v;
    int vty;
    int vhi;
    int cb;
    int r;

    if (lx_t == T_SCON && f77_io_rd) {
        f77_error("a character constant cannot be a READ list item");
        return;
    }
    if (lx_t == T_NAME) {
        int s;
        int after;
        s = f77_sym(lex_name);
        after = (int)(lx_rte - lx_stmt);
        if (f77_srank[s] > 0 &&
            (after >= lx_stmt_len || lx_stmt[after] != '(')) {
            f77_tok();
            f77_wr_whole_array(s);
            return;
        }
    }

    /* Implied-DO: `(items, VAR = e1, e2 [, e3])`.  The loop control sits
     * AFTER the items it governs, so the control spec is parsed first
     * from its own offset, the loop opened, and the scanner then rewound
     * to the items -- which are emitted straight into the body block.
     * Rewinding is safe here precisely because nothing has been emitted
     * for the items yet. */
    {
        int open_off;
        int close_off;
        int eq_off;
        int items_off;
        int ctl_off;
        open_off = (int)(lx_rts - lx_stmt);
        if (lx_t == T_LP &&
            f77_implied_do_spans(open_off, &close_off, &eq_off, &items_off, &ctl_off)) {
            int sv;
            int m1, m2, m3, t1, t2, t3;
            int trip;
            int b_test, b_body, b_exit, c;

            f77_scan_from(ctl_off);
            if (lx_t != T_NAME) { f77_error("implied-DO needs a control variable"); return; }
            sv = f77_sym(lex_name);
            f77_tok();
            if (lx_t != T_ASSIGN) { f77_error("expected = in implied-DO"); return; }
            f77_tok();
            m1 = f77_expr(); m1 = f77_cvt(m1, &ex_hi, ex_ty, TY_INT);
            if (lx_t != T_COMMA) { f77_error("expected , in implied-DO"); return; }
            f77_tok();
            m2 = f77_expr(); m2 = f77_cvt(m2, &ex_hi, ex_ty, TY_INT);
            if (lx_t == T_COMMA) {
                f77_tok();
                m3 = f77_expr(); m3 = f77_cvt(m3, &ex_hi, ex_ty, TY_INT);
            } else {
                m3 = f77_iconst(1);
            }

            f77_sstored[sv] = 1;
            hi_emit(HI_STORE, TY_INT, f77_sval[sv], m1, 0, NULL);
            t1 = hi_emit(HI_SUB, TY_INT, m2, m1, 0, NULL);
            t2 = hi_emit(HI_ADD, TY_INT, t1, m3, 0, NULL);
            t3 = hi_emit(HI_DIV, TY_INT, t2, m3, 0, NULL);
            f77_frame = f77_frame + 4;
            trip = hi_emit(HI_ALLOCA, TY_INT, -1, -1, 0 - f77_frame, NULL);
            hl_ainst[hl_nalloca] = trip;
            hl_aoff[hl_nalloca] = 0 - f77_frame;
            hl_nalloca = hl_nalloca + 1;
            hi_emit(HI_STORE, TY_INT, trip, t3, 0, NULL);

            b_test = hir_new_block();
            b_body = hir_new_block();
            b_exit = hir_new_block();
            f77_goto_blk(b_test);
            f77_begin_blk(b_test);
            c = hi_emit(HI_LOAD, TY_INT, trip, -1, 0, NULL);
            c = hi_emit(HI_SGT, TY_INT, c, f77_iconst(0), 0, NULL);
            hi_emit(HI_BRC, TY_VOID, c, b_body, b_exit, NULL);
            f77_cur_blk_live = 0;
            f77_begin_blk(b_body);

            /* Rewind to the items and emit them inside the body. */
            f77_scan_from(items_off);
            for (;;) {
                f77_wr_one();
                if (lx_t != T_COMMA) break;
                if ((int)(lx_rts - lx_stmt) >= ctl_off - 1) break;
                f77_tok();
                if ((int)(lx_rts - lx_stmt) >= ctl_off) break;
            }

            {
                int iv;
                iv = hi_emit(HI_LOAD, TY_INT, f77_sval[sv], -1, 0, NULL);
                iv = hi_emit(HI_ADD, TY_INT, iv, m3, 0, NULL);
                hi_emit(HI_STORE, TY_INT, f77_sval[sv], iv, 0, NULL);
                iv = hi_emit(HI_LOAD, TY_INT, trip, -1, 0, NULL);
                iv = hi_emit(HI_ADDI, TY_INT, iv, -1, -1, NULL);
                hi_emit(HI_STORE, TY_INT, trip, iv, 0, NULL);
                hi_emit(HI_BR, TY_VOID, -1, -1, b_test, NULL);
            }
            f77_cur_blk_live = 0;
            f77_begin_blk(b_exit);

            /* Continue after the implied-DO's closing paren. */
            f77_scan_from(close_off);
            return;
        }
    }

    if (f77_io_rd) {
        int a;
        a = f77_rd_target(&vty);
        f77_rd_item(a, vty);
        return;
    }
    v = f77_expr();
    if (f77_io_unf) {
        /* raw bytes: a character value is an address already; anything
         * else goes through a temporary */
        int args[2];
        if (ex_ty == TY_CHAR) { args[0] = v; args[1] = ex_len; }
        else {
            int tmp;
            tmp = f77_char_temp(f77_tysize(ex_ty));
            f77_store_at(tmp, ex_ty, v, ex_ty, ex_hi);
            args[0] = tmp; args[1] = f77_iconst(f77_tysize(ex_ty));
        }
        f77_call_i("f77_wu", 2, args);
        return;
    }
    if (ex_ty == TY_CHAR) {
        int args[2];
        args[0] = v; args[1] = ex_len;
        f77_call_i("f77_wr_a", 2, args);
        return;
    }
    if (ex_ty == TY_INT && ex_log) {
        /* T or F (list-directed), or by the L descriptor */
        f77_call_i("f77_wr_l", 1, &v);
        return;
    }
    f77_wr_item(v, ex_ty, ex_hi);
}

static void f77_wr_list(void) {
    if (lx_t == T_EOF) return;
    for (;;) {
        f77_wr_one();
        if (lx_t != T_COMMA) break;
        f77_tok();
    }
}

/* Emit the f77_wr_begin call: unit number, plus the format string or a
 * null pointer for list-directed (FMT=*) output. */
static void f77_wr_begin(int unit_val, int fmt_label) {
    int cb;
    int r;
    int fs;
    int fa;
    cb = h_ncarg;
    h_carg[h_ncarg] = unit_val; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    if (f77_io_int) {
        h_carg[h_ncarg] = f77_io_int_len; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
        h_carg[h_ncarg] = f77_io_int_nrec; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    }
    if (fmt_label == -3) {
        fa = f77_fmt_dyn;
    } else if (fmt_label == -2) {
        fa = f77_fmt_dyn_addr(f77_fmt_dyn);
    } else if (fmt_label >= 0) {
        fs = f77_find_format(fmt_label);
        if (fs < 0) { f77_error("no FORMAT statement with that label"); fs = 0; }
        fa = hi_emit(HI_SADDR, HL_ADDR_TY, -1, -1, fs, NULL);
    } else {
        fa = f77_iconst(0);
    }
    h_carg[h_ncarg] = fa; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    if (f77_io_int) r = hi_emit(HI_CALL, TY_INT, -1, -1, 4, "f77_wr_begin_int");
    else r = hi_emit(HI_CALL, TY_INT, -1, -1, 2, "f77_wr_begin");
    h_cbase[r] = cb;
    f77_io_int = 0;
}

static void f77_wr_finish(void) {
    int r;
    r = hi_emit(HI_CALL, TY_INT, -1, -1, 0, "f77_wr_end");
    h_cbase[r] = h_ncarg;
}

/* WRITE (unit, fmt) list  --  unit and fmt may each be `*`. */
/* The control list of a READ or WRITE: ( [UNIT=]u [, [FMT=]f] [, END=l]
 * [, ERR=l] [, IOSTAT=v] [, REC=r] ) in any order once keyworded.
 * fmt_label: >= 0 a label, -1 list-directed (*), -2 ASSIGNed variable,
 * -3 a CHARACTER expression (both in f77_fmt_dyn), -4 none at all
 * (unformatted). */
static int f77_io_end_label;
static int f77_io_err_label;
static int f77_io_iostat;      /* address of the IOSTAT variable, or -1 */
static int f77_io_rec;         /* REC= value, or -1 */

static int f77_io_fmt_spec(void) {
    if (lx_t == T_STAR) { f77_tok(); return -1; }
    if (lx_t == T_ICON) { int l; l = lex_ival; f77_tok(); return l; }
    if (lx_t == T_SCON || (lx_t == T_NAME && f77_sty[f77_sym(lex_name)] == TY_CHAR)) {
        f77_fmt_dyn = f77_expr();
        return -3;
    }
    if (lx_t == T_NAME) {
        f77_fmt_dyn = f77_load_sym(f77_sym(lex_name));
        f77_fmt_dyn = f77_cvt(f77_fmt_dyn, &ex_hi, ex_ty, TY_INT);
        f77_tok();
        return -2;
    }
    f77_error("bad FORMAT specifier");
    return -1;
}

static int f77_io_control(int is_read, int *unit_val, int *fmt_label) {
    int pos;
    int have_unit;
    char kw[F77_MAX_NAME];
    pos = 0;
    have_unit = 0;
    *fmt_label = -4;
    f77_io_end_label = -1;
    f77_io_err_label = -1;
    f77_io_iostat = -1;
    f77_io_rec = -1;
    f77_io_int = 0;
    if (lx_t != T_LP) { f77_error("I/O statement needs a control list"); return 0; }
    f77_tok();
    for (;;) {
        int iskw;
        iskw = 0;
        if (lx_t == T_NAME) {
            /* NAME= is a keyword; otherwise the name starts a value */
            int after;
            after = (int)(lx_rte - lx_stmt);
            if (after < lx_stmt_len && lx_stmt[after] == '=' &&
                !(after + 1 < lx_stmt_len && lx_stmt[after + 1] == '=')) {
                strcpy(kw, lex_name);
                f77_tok();
                f77_tok();
                iskw = 1;
            }
        }
        if (!iskw) {
            if (pos == 0) {
                if (lx_t == T_STAR) { *unit_val = f77_iconst(is_read ? 5 : 6); f77_tok(); }
                else *unit_val = f77_io_unit_expr();
                have_unit = 1;
            } else if (pos == 1) {
                *fmt_label = f77_io_fmt_spec();
            } else {
                f77_error("too many positional items in the control list");
                return 0;
            }
            pos = pos + 1;
        } else if (strcmp(kw, "UNIT") == 0) {
            if (lx_t == T_STAR) { *unit_val = f77_iconst(is_read ? 5 : 6); f77_tok(); }
            else *unit_val = f77_io_unit_expr();
            have_unit = 1;
            pos = pos < 1 ? 1 : pos;
        } else if (strcmp(kw, "FMT") == 0) {
            *fmt_label = f77_io_fmt_spec();
            pos = 2;
        } else if (strcmp(kw, "END") == 0 || strcmp(kw, "ERR") == 0) {
            if (lx_t != T_ICON) { f77_error("END=/ERR= needs a statement label"); return 0; }
            if (kw[1] == 'N') f77_io_end_label = lex_ival; else f77_io_err_label = lex_ival;
            f77_tok();
        } else if (strcmp(kw, "IOSTAT") == 0) {
            int ss;
            if (lx_t != T_NAME) { f77_error("IOSTAT= needs a variable"); return 0; }
            ss = f77_sym(lex_name);
            f77_sstored[ss] = 1;
            f77_tok();
            if (lx_t == T_LP && f77_srank[ss] > 0) { f77_tok(); f77_io_iostat = f77_subscript_addr(ss); }
            else {
                if (f77_shi[ss] >= 0) hi_emit(HI_ADDI, HL_ADDR_TY, f77_shi[ss], -1, 0, NULL);
                f77_io_iostat = f77_sval[ss];
            }
        } else if (strcmp(kw, "REC") == 0) {
            f77_io_rec = f77_expr();
            f77_io_rec = f77_cvt(f77_io_rec, &ex_hi, ex_ty, TY_INT);
        } else {
            f77_error("unknown keyword in the control list");
            return 0;
        }
        if (lx_t == T_COMMA) { f77_tok(); continue; }
        break;
    }
    if (lx_t != T_RP) { f77_error("expected ) after the control list"); return 0; }
    f77_tok();
    if (!have_unit) { f77_error("the control list needs a unit"); return 0; }
    return 1;
}

/* Common tail of READ/WRITE begin: REC= is announced to the runtime
 * before the statement opens. */
static void f77_io_announce(void) {
    if (f77_io_rec >= 0) f77_call_i("f77_set_rec", 1, &f77_io_rec);
}

/* After f77_rd_begin: branch on its code -- 1 end of file, 2 error --
 * to END=/ERR=, and store IOSTAT (-1 eof, 1 error, 0 ok). */
static void f77_io_after_read(int r) {
    if (f77_io_iostat >= 0) {
        int c; int v;
        /* iostat = (r == 1) ? -1 : (r == 2) ? 1 : 0 */
        c = hi_emit(HI_SEQ, TY_INT, r, f77_iconst(1), 0, NULL);
        v = f77_select(c, f77_iconst(-1), r);      /* 0 -> 0, 2 -> 2 -> then map 2 -> 1 */
        c = hi_emit(HI_SEQ, TY_INT, r, f77_iconst(2), 0, NULL);
        v = f77_select(c, f77_iconst(1), v);
        hi_emit(HI_STORE, TY_INT, f77_io_iostat, v, 0, NULL);
    }
    if (f77_io_end_label >= 0 || f77_io_err_label >= 0) {
        int b_cont; int c;
        if (f77_io_end_label >= 0) {
            b_cont = hir_new_block();
            c = hi_emit(HI_SEQ, TY_INT, r, f77_iconst(1), 0, NULL);
            hi_emit(HI_BRC, TY_VOID, c, f77_label_blk(f77_io_end_label), b_cont, NULL);
            f77_cur_blk_live = 0;
            f77_begin_blk(b_cont);
        }
        if (f77_io_err_label >= 0) {
            b_cont = hir_new_block();
            c = hi_emit(HI_SEQ, TY_INT, r, f77_iconst(2), 0, NULL);
            hi_emit(HI_BRC, TY_VOID, c, f77_label_blk(f77_io_err_label), b_cont, NULL);
            f77_cur_blk_live = 0;
            f77_begin_blk(b_cont);
        }
    }
}

static void f77_stmt_write(int skip) {
    int unit_val;
    int fmt_label;
    f77_scan_from(skip);
    if (!f77_io_control(0, &unit_val, &fmt_label)) return;
    f77_io_announce();
    if (fmt_label == -4) {
        /* Unformatted: raw bytes, one runtime call per item. */
        int r;
        f77_io_unf = 1;
        f77_call_i("f77_wu_begin", 1, &unit_val);
        f77_wr_list();
        r = hi_emit(HI_CALL, TY_INT, -1, -1, 0, "f77_wu_end");
        h_cbase[r] = h_ncarg;
        f77_io_unf = 0;
        return;
    }
    f77_wr_begin(unit_val, fmt_label);
    f77_wr_list();
    f77_wr_finish();
}

/* PRINT fmt, list  --  always unit 6. */
static void f77_stmt_print(int skip) {
    int fmt_label;
    f77_scan_from(skip);
    fmt_label = f77_io_fmt_spec();
    if (lx_t == T_COMMA) f77_tok();
    f77_io_int = 0;
    f77_io_rec = -1;
    f77_wr_begin(f77_iconst(6), fmt_label);
    f77_wr_list();
    f77_wr_finish();
}

/* READ (unit, fmt [, END=label]) list  --  or  READ fmt, list.
 *
 * The unit may be `*` or 5 (stdin); fmt is a FORMAT label or `*` for
 * list-directed.  END= names the statement to branch to at end of
 * file, checked when the READ begins -- which is what the standard
 * read-until-EOF loop exercises.  ERR= and IOSTAT= are refused
 * honestly, as is unformatted `READ (u)`. */
static void f77_stmt_read(int skip) {
    int unit_val;
    int fmt_label;
    int cb;
    int r;
    int fs;
    int fa;

    f77_scan_from(skip);
    f77_io_int = 0;
    f77_io_end_label = -1;
    f77_io_err_label = -1;
    f77_io_iostat = -1;
    f77_io_rec = -1;

    if (lx_t == T_LP) {
        if (!f77_io_control(1, &unit_val, &fmt_label)) return;
    } else {
        /* READ fmt, list  --  always unit 5. */
        unit_val = f77_iconst(5);
        fmt_label = f77_io_fmt_spec();
        if (lx_t == T_COMMA) f77_tok();
    }
    f77_io_announce();

    if (fmt_label == -4) {
        int args[2];
        args[0] = unit_val;
        args[1] = f77_iconst((f77_io_end_label >= 0 ? 1 : 0) |
                             ((f77_io_err_label >= 0 || f77_io_iostat >= 0) ? 2 : 0));
        r = f77_call_i("f77_ru_begin", 2, args);
        f77_io_after_read(r);
        f77_io_unf = 1;
        f77_io_rd = 1;
        f77_wr_list();
        f77_io_rd = 0;
        f77_io_unf = 0;
        r = hi_emit(HI_CALL, TY_INT, -1, -1, 0, "f77_ru_end");
        h_cbase[r] = h_ncarg;
        return;
    }

    cb = h_ncarg;
    h_carg[h_ncarg] = unit_val; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    if (f77_io_int) {
        h_carg[h_ncarg] = f77_io_int_len; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
        h_carg[h_ncarg] = f77_io_int_nrec; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    }
    if (fmt_label == -3) {
        fa = f77_fmt_dyn;
    } else if (fmt_label == -2) {
        fa = f77_fmt_dyn_addr(f77_fmt_dyn);
    } else if (fmt_label >= 0) {
        fs = f77_find_format(fmt_label);
        if (fs < 0) { f77_error("no FORMAT statement with that label"); fs = 0; }
        fa = hi_emit(HI_SADDR, HL_ADDR_TY, -1, -1, fs, NULL);
    } else {
        fa = f77_iconst(0);
    }
    h_carg[h_ncarg] = fa; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    h_carg[h_ncarg] = f77_iconst((f77_io_end_label >= 0 ? 1 : 0) |
                                 ((f77_io_err_label >= 0 || f77_io_iostat >= 0) ? 2 : 0));
    h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    if (f77_io_int) r = hi_emit(HI_CALL, TY_INT, -1, -1, 5, "f77_rd_begin_int");
    else r = hi_emit(HI_CALL, TY_INT, -1, -1, 3, "f77_rd_begin");
    h_cbase[r] = cb;
    f77_io_int = 0;

    f77_io_after_read(r);

    f77_io_rd = 1;
    f77_wr_list();
    f77_io_rd = 0;
    r = hi_emit(HI_CALL, TY_INT, -1, -1, 0, "f77_rd_end");
    h_cbase[r] = h_ncarg;
}

/* --- OPEN / CLOSE / REWIND -------------------------------------------- */

/* The unit in an OPEN/CLOSE control list: an integer constant, a
 * scalar variable, a PARAMETER, or UNIT=expr.  A leading NAME must be
 * peeked past to tell a keyword item from a positional unit, so a
 * name-led unit is restricted to a bare scalar -- OPEN (NU+1, ...) is
 * not worth the rewind machinery it would need. */
static int f77_io_unit_after_name(char *nm) {
    int s;
    s = f77_sym(nm);
    if (f77_sparam[s]) return f77_iconst(f77_spival[s]);
    return f77_load_sym(s);
}

/* OPEN (unit, FILE='name' [, STATUS='...']) -- FILE must be a
 * character constant until CHARACTER variables exist.  Everything
 * else in the standard's control list is refused honestly. */
static void f77_stmt_open(int skip) {
    int unit_val;
    int have_unit;
    int file_addr; int file_lenv;
    int stat_addr; int stat_lenv;
    int acc_addr; int acc_lenv;
    int form_addr; int form_lenv;
    int blank_addr; int blank_lenv;
    int recl_val;
    int err_label;
    int iostat_addr;
    char kw[F77_MAX_NAME];
    int cb;
    int r;

    f77_scan_from(skip);
    have_unit = 0;
    unit_val = -1;
    file_addr = -1; file_lenv = -1;
    stat_addr = -1; stat_lenv = -1;
    acc_addr = -1; acc_lenv = -1;
    form_addr = -1; form_lenv = -1;
    blank_addr = -1; blank_lenv = -1;
    recl_val = -1;
    err_label = -1;
    iostat_addr = -1;
    if (lx_t != T_LP) { f77_error("OPEN needs a control list"); return; }
    f77_tok();
    for (;;) {
        if (lx_t == T_NAME) {
            strcpy(kw, lex_name);
            f77_tok();
            if (lx_t == T_ASSIGN) {
                f77_tok();
                if (strcmp(kw, "UNIT") == 0) {
                    unit_val = f77_expr();
                    unit_val = f77_cvt(unit_val, &ex_hi, ex_ty, TY_INT);
                    have_unit = 1;
                } else if (strcmp(kw, "FILE") == 0) {
                    file_addr = f77_expr();
                    if (ex_ty != TY_CHAR) { f77_error("FILE= needs a CHARACTER value"); return; }
                    file_lenv = ex_len;
                } else if (strcmp(kw, "STATUS") == 0) {
                    stat_addr = f77_expr();
                    if (ex_ty != TY_CHAR) { f77_error("STATUS= needs a CHARACTER value"); return; }
                    stat_lenv = ex_len;
                } else if (strcmp(kw, "ACCESS") == 0) {
                    int a;
                    a = f77_expr();
                    if (ex_ty != TY_CHAR) { f77_error("ACCESS= needs a CHARACTER value"); return; }
                    acc_addr = a; acc_lenv = ex_len;
                } else if (strcmp(kw, "FORM") == 0) {
                    int a;
                    a = f77_expr();
                    if (ex_ty != TY_CHAR) { f77_error("FORM= needs a CHARACTER value"); return; }
                    form_addr = a; form_lenv = ex_len;
                } else if (strcmp(kw, "BLANK") == 0) {
                    int a;
                    a = f77_expr();
                    if (ex_ty != TY_CHAR) { f77_error("BLANK= needs a CHARACTER value"); return; }
                    blank_addr = a; blank_lenv = ex_len;
                } else if (strcmp(kw, "RECL") == 0) {
                    recl_val = f77_expr();
                    recl_val = f77_cvt(recl_val, &ex_hi, ex_ty, TY_INT);
                } else if (strcmp(kw, "ERR") == 0) {
                    if (lx_t != T_ICON) { f77_error("ERR= needs a statement label"); return; }
                    err_label = lex_ival;
                    f77_tok();
                } else if (strcmp(kw, "IOSTAT") == 0) {
                    int ss;
                    if (lx_t != T_NAME) { f77_error("IOSTAT= needs a variable"); return; }
                    ss = f77_sym(lex_name);
                    f77_sstored[ss] = 1;
                    f77_tok();
                    if (f77_shi[ss] >= 0) hi_emit(HI_ADDI, HL_ADDR_TY, f77_shi[ss], -1, 0, NULL);
                    iostat_addr = f77_sval[ss];
                } else {
                    f77_error("unknown keyword in OPEN");
                    return;
                }
            } else if (!have_unit) {
                unit_val = f77_io_unit_after_name(kw);
                unit_val = f77_cvt(unit_val, &ex_hi, ex_ty, TY_INT);
                have_unit = 1;
            } else {
                f77_error("bad OPEN control list");
                return;
            }
        } else if (!have_unit) {
            unit_val = f77_expr();
            unit_val = f77_cvt(unit_val, &ex_hi, ex_ty, TY_INT);
            have_unit = 1;
        } else {
            f77_error("bad OPEN control list");
            return;
        }
        if (lx_t != T_COMMA) break;
        f77_tok();
    }
    if (lx_t != T_RP) { f77_error("expected ) after OPEN control list"); return; }
    f77_tok();
    if (!have_unit) { f77_error("OPEN needs a unit"); return; }

    /* f77_open(unit, file, flen, status, slen, access, alen, form, fmlen,
     *          blank, blen, recl, recoverable) -> 0 ok, 2 error */
    cb = h_ncarg;
    h_carg[h_ncarg] = unit_val; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    if (file_addr < 0) { file_addr = f77_iconst(0); file_lenv = f77_iconst(0); }
    h_carg[h_ncarg] = file_addr; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    h_carg[h_ncarg] = file_lenv; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    if (stat_addr < 0) { stat_addr = f77_iconst(0); stat_lenv = f77_iconst(0); }
    h_carg[h_ncarg] = stat_addr; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    h_carg[h_ncarg] = stat_lenv; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    if (acc_addr < 0) { acc_addr = f77_iconst(0); acc_lenv = f77_iconst(0); }
    h_carg[h_ncarg] = acc_addr; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    h_carg[h_ncarg] = acc_lenv; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    if (form_addr < 0) { form_addr = f77_iconst(0); form_lenv = f77_iconst(0); }
    h_carg[h_ncarg] = form_addr; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    h_carg[h_ncarg] = form_lenv; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    if (blank_addr < 0) { blank_addr = f77_iconst(0); blank_lenv = f77_iconst(0); }
    h_carg[h_ncarg] = blank_addr; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    h_carg[h_ncarg] = blank_lenv; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    if (recl_val < 0) recl_val = f77_iconst(0);
    h_carg[h_ncarg] = recl_val; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    h_carg[h_ncarg] = f77_iconst((err_label >= 0 || iostat_addr >= 0) ? 1 : 0);
    h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    r = hi_emit(HI_CALL, TY_INT, -1, -1, 13, "f77_open");
    h_cbase[r] = cb;
    if (iostat_addr >= 0) hi_emit(HI_STORE, TY_INT, iostat_addr, r, 0, NULL);
    if (err_label >= 0) {
        int b_cont; int c;
        b_cont = hir_new_block();
        c = hi_emit(HI_SNE, TY_INT, r, f77_iconst(0), 0, NULL);
        hi_emit(HI_BRC, TY_VOID, c, f77_label_blk(err_label), b_cont, NULL);
        f77_cur_blk_live = 0;
        f77_begin_blk(b_cont);
    }
}

/* INQUIRE (UNIT=u | FILE=f, specifier=var, ...).  The runtime looks the
 * unit or file up once (f77_inquire) and then fills each specifier
 * variable by code (f77_inq); the codes are the runtime's. */
static void f77_stmt_inquire(int skip) {
    int unit_val;
    int file_addr; int file_lenv;
    int err_label;
    int iostat_addr;
    int nspec;
    int spec_code[24]; int spec_addr[24]; int spec_len[24]; int spec_log[24];
    char kw[F77_MAX_NAME];
    int r;
    int i;
    int args[4];

    f77_scan_from(skip);
    unit_val = -1;
    file_addr = -1; file_lenv = -1;
    err_label = -1;
    iostat_addr = -1;
    nspec = 0;
    if (lx_t != T_LP) { f77_error("INQUIRE needs a control list"); return; }
    f77_tok();
    for (;;) {
        int code;
        if (lx_t != T_NAME) {
            /* the first item may be the unit without UNIT= (12.10.3) */
            if (nspec == 0 && unit_val < 0 && file_addr < 0 && err_label < 0 && iostat_addr < 0) {
                unit_val = f77_expr();
                unit_val = f77_cvt(unit_val, &ex_hi, ex_ty, TY_INT);
                if (lx_t == T_COMMA) { f77_tok(); continue; }
                break;
            }
            f77_error("INQUIRE needs keyword=value items");
            return;
        }
        strcpy(kw, lex_name);
        f77_tok();
        if (lx_t != T_ASSIGN) {
            if (nspec == 0 && unit_val < 0 && file_addr < 0 && err_label < 0 && iostat_addr < 0) {
                /* a positional unit that is a name, as OPEN takes it */
                unit_val = f77_io_unit_after_name(kw);
                unit_val = f77_cvt(unit_val, &ex_hi, ex_ty, TY_INT);
                if (lx_t == T_COMMA) { f77_tok(); continue; }
                break;
            }
            f77_error("INQUIRE needs keyword=value items");
            return;
        }
        f77_tok();
        code = 0;
        if (strcmp(kw, "UNIT") == 0) {
            unit_val = f77_expr();
            unit_val = f77_cvt(unit_val, &ex_hi, ex_ty, TY_INT);
        } else if (strcmp(kw, "FILE") == 0) {
            file_addr = f77_expr();
            if (ex_ty != TY_CHAR) { f77_error("FILE= needs a CHARACTER value"); return; }
            file_lenv = ex_len;
        } else if (strcmp(kw, "ERR") == 0) {
            if (lx_t != T_ICON) { f77_error("ERR= needs a statement label"); return; }
            err_label = lex_ival;
            f77_tok();
        } else if (strcmp(kw, "IOSTAT") == 0) {
            int ty;
            iostat_addr = f77_rd_target(&ty);
        }
        else if (strcmp(kw, "EXIST") == 0) code = 1;
        else if (strcmp(kw, "OPENED") == 0) code = 2;
        else if (strcmp(kw, "NUMBER") == 0) code = 3;
        else if (strcmp(kw, "NAMED") == 0) code = 4;
        else if (strcmp(kw, "NAME") == 0) code = 5;
        else if (strcmp(kw, "ACCESS") == 0) code = 6;
        else if (strcmp(kw, "SEQUENTIAL") == 0) code = 7;
        else if (strcmp(kw, "DIRECT") == 0) code = 8;
        else if (strcmp(kw, "FORM") == 0) code = 9;
        else if (strcmp(kw, "FORMATTED") == 0) code = 10;
        else if (strcmp(kw, "UNFORMATTED") == 0) code = 11;
        else if (strcmp(kw, "RECL") == 0) code = 12;
        else if (strcmp(kw, "NEXTREC") == 0) code = 13;
        else if (strcmp(kw, "BLANK") == 0) code = 14;
        else { f77_error("unknown INQUIRE specifier"); return; }
        if (code > 0) {
            int ty;
            if (nspec >= 24) { f77_error("too many INQUIRE specifiers"); return; }
            spec_addr[nspec] = f77_rd_target(&ty);
            spec_len[nspec] = (ty == TY_CHAR) ? f77_rd_len : f77_iconst(0);
            spec_code[nspec] = code;
            spec_log[nspec] = (ty != TY_CHAR);
            nspec = nspec + 1;
        }
        if (lx_t == T_COMMA) { f77_tok(); continue; }
        break;
    }
    if (lx_t != T_RP) { f77_error("expected ) after INQUIRE list"); return; }
    f77_tok();
    if (unit_val < 0 && file_addr < 0) { f77_error("INQUIRE needs UNIT= or FILE="); return; }
    args[0] = (unit_val >= 0) ? unit_val : f77_iconst(-1);
    args[1] = (file_addr >= 0) ? file_addr : f77_iconst(0);
    args[2] = (file_addr >= 0) ? file_lenv : f77_iconst(0);
    r = f77_call_i("f77_inquire", 3, args);
    if (iostat_addr >= 0) hi_emit(HI_STORE, TY_INT, iostat_addr, r, 0, NULL);
    for (i = 0; i < nspec; i++) {
        args[0] = f77_iconst(spec_code[i]);
        args[1] = spec_addr[i];
        args[2] = spec_len[i];
        f77_call_i("f77_inq", 3, args);
    }
    if (err_label >= 0) {
        int b_cont; int c;
        b_cont = hir_new_block();
        c = hi_emit(HI_SNE, TY_INT, r, f77_iconst(0), 0, NULL);
        hi_emit(HI_BRC, TY_VOID, c, f77_label_blk(err_label), b_cont, NULL);
        f77_cur_blk_live = 0;
        f77_begin_blk(b_cont);
    }
}

/* CLOSE (unit [, STATUS='KEEP'|'DELETE']) */
static void f77_stmt_close(int skip) {
    int unit_val;
    int have_unit;
    int stat_sidx; int stat_slen;
    char kw[F77_MAX_NAME];
    int cb;
    int r;
    int a;

    f77_scan_from(skip);
    have_unit = 0;
    unit_val = -1;
    stat_sidx = -1; stat_slen = 0;
    if (lx_t != T_LP) { f77_error("CLOSE needs a control list"); return; }
    f77_tok();
    for (;;) {
        if (lx_t == T_NAME) {
            strcpy(kw, lex_name);
            f77_tok();
            if (lx_t == T_ASSIGN) {
                f77_tok();
                if (strcmp(kw, "UNIT") == 0) {
                    unit_val = f77_expr();
                    unit_val = f77_cvt(unit_val, &ex_hi, ex_ty, TY_INT);
                    have_unit = 1;
                } else if (strcmp(kw, "STATUS") == 0) {
                    if (lx_t != T_SCON) {
                        f77_error("STATUS= needs a character constant");
                        return;
                    }
                    stat_sidx = lex_sidx;
                    stat_slen = lex_slen;
                    f77_tok();
                } else {
                    f77_error("only UNIT= and STATUS= are supported in CLOSE");
                    return;
                }
            } else if (!have_unit) {
                unit_val = f77_io_unit_after_name(kw);
                unit_val = f77_cvt(unit_val, &ex_hi, ex_ty, TY_INT);
                have_unit = 1;
            } else {
                f77_error("bad CLOSE control list");
                return;
            }
        } else if (!have_unit) {
            unit_val = f77_expr();
            unit_val = f77_cvt(unit_val, &ex_hi, ex_ty, TY_INT);
            have_unit = 1;
        } else {
            f77_error("bad CLOSE control list");
            return;
        }
        if (lx_t != T_COMMA) break;
        f77_tok();
    }
    if (lx_t != T_RP) { f77_error("expected ) after CLOSE control list"); return; }
    f77_tok();
    if (!have_unit) { f77_error("CLOSE needs a unit"); return; }

    cb = h_ncarg;
    h_carg[h_ncarg] = unit_val; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    if (stat_sidx >= 0) a = hi_emit(HI_SADDR, HL_ADDR_TY, -1, -1, stat_sidx, NULL);
    else a = f77_iconst(0);
    h_carg[h_ncarg] = a; h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    h_carg[h_ncarg] = f77_iconst(stat_slen); h_carg_tag[h_ncarg] = 0; h_ncarg = h_ncarg + 1;
    r = hi_emit(HI_CALL, TY_INT, -1, -1, 3, "f77_close");
    h_cbase[r] = cb;
}

/* REWIND u  --  or REWIND (u). */
static int f77_rd_target(int *tyo);
static void f77_stmt_rewind(int skip) {
    int unit_val;
    f77_scan_from(skip);
    if (lx_t == T_LP) {
        /* (u) or (UNIT=u [, ERR=l] [, IOSTAT=v]) */
        unit_val = -1;
        f77_tok();
        for (;;) {
            if (lx_t == T_NAME && (int)(lx_rte - lx_stmt) < lx_stmt_len &&
                lx_stmt[(int)(lx_rte - lx_stmt)] == '=') {
                char kw[F77_MAX_NAME];
                strcpy(kw, lex_name);
                f77_tok();
                f77_tok();
                if (strcmp(kw, "UNIT") == 0) {
                    unit_val = f77_expr(); unit_val = f77_cvt(unit_val, &ex_hi, ex_ty, TY_INT);
                } else if (strcmp(kw, "ERR") == 0) {
                    f77_tok();                      /* a REWIND does not fail here */
                } else if (strcmp(kw, "IOSTAT") == 0) {
                    int ty; int a;
                    a = f77_rd_target(&ty);
                    hi_emit(HI_STORE, TY_INT, a, f77_iconst(0), 0, NULL);
                } else { f77_error("unknown keyword in REWIND"); return; }
            } else {
                unit_val = f77_expr(); unit_val = f77_cvt(unit_val, &ex_hi, ex_ty, TY_INT);
            }
            if (lx_t == T_COMMA) { f77_tok(); continue; }
            break;
        }
        if (lx_t != T_RP) { f77_error("expected ) after REWIND unit"); return; }
        f77_tok();
        if (unit_val < 0) { f77_error("REWIND needs a unit"); return; }
    } else {
        unit_val = f77_expr();
        unit_val = f77_cvt(unit_val, &ex_hi, ex_ty, TY_INT);
    }
    f77_call_i("f77_rewind", 1, &unit_val);
}

/* Is this statement part of the declaration part (so the scalar dummy
 * copies must not be emitted yet)? */
static int f77_stmt_is_declaration(int cls) {
    if (cls != S_KEYWORD) return 0;
    if (f77_starts("INTEGER")) return 1;
    if (f77_starts("REAL")) return 1;
    if (f77_starts("DOUBLEPRECISION")) return 1;
    if (f77_starts("LOGICAL")) return 1;
    if (f77_starts("CHARACTER")) return 1;
    if (f77_starts("COMPLEX")) return 1;
    if (f77_starts("DOUBLECOMPLEX")) return 1;
    if (f77_starts("DIMENSION")) return 1;
    if (f77_starts("COMMON")) return 1;
    if (f77_starts("EQUIVALENCE")) return 1;
    if (f77_starts("BLOCKDATA")) return 1;
    if (f77_starts("EXTERNAL")) return 1;
    if (f77_starts("INTRINSIC")) return 1;
    if (f77_starts("SAVE")) return 1;
    if (f77_starts("DATA")) return 1;
    if (f77_starts("PARAMETER")) return 1;
    if (f77_starts("IMPLICIT")) return 1;
    if (f77_starts("FORMAT")) return 1;
    if (f77_starts("PROGRAM")) return 1;
    if (f77_starts("SUBROUTINE")) return 1;
    if (f77_unit_header_ty() >= 0) return 1;
    return 0;
}

/* Dispatch one statement.  Called once per assembled statement. */
static void f77_statement(void) {
    int cls;
    int n;
    int c;
    int b_then;
    int b_else;
    int b_end;
    int lab;
    int nerr0;

    /* fort370: a statement no handler scans leaves no tokens; one that
     * is scanned must be used up (see done:) */
    lx_t = T_EOF;
    nerr0 = f77_nerr;
    cls = f77_classify();

    if (cls == S_ASSIGN && f77_stf_define()) goto done;

    /* Declarations must all precede executable statements, so the first
     * executable one is where every dummy's type is finally known --
     * and therefore where the static layout and the scalar copies are
     * emitted.  That happens BEFORE the label's block is opened: the
     * layout emits hidden-argument PARAMs and must stay in the entry
     * block, and it runs once, which a labelled first statement (a
     * loop target) would not guarantee. */
    if (f77_decls_open && !f77_stmt_is_declaration(cls)) f77_emit_copyin();
    if (f77_entry_state == 1 && !f77_decls_open) {
        /* The text before the ENTRY: reached only by a GO TO */
        f77_goto_blk(f77_entry_blk);
        f77_entry_state = 2;
    }

    /* A labelled statement starts (or continues into) that label's
     * block, so GOTOs and DO terminals both land correctly. */
    if (lx_stmt_label >= 0) {
        int b;
        b = f77_label_def(lx_stmt_label);
        f77_goto_blk(b);
        f77_begin_blk(b);
    }

    /* An unlabelled statement after RETURN, GOTO or STOP is unreachable,
     * but it is still compiled -- and it must not land in the block the
     * terminator just closed.  The backend's contract is that a
     * terminator is the LAST instruction of its block (the codegen drops
     * the jump of a RET or BR to the block laid out next, so anything
     * after it would run): the body of the next ENTRY, parsed here as
     * dead code, called through a phantom dummy's address in FCVS FM509
     * once the re-synced backend took that liberty.  So: a fresh block,
     * which has no predecessor and is removed as dead. */
    if (!f77_cur_blk_live && !f77_stmt_is_declaration(cls))
        f77_begin_blk(hir_new_block());

    if (cls == S_ASSIGN)   { f77_stmt_assign(); goto done; }
    if (cls == S_DO)       { f77_open_do();     goto done; }

    if (cls == S_IF_LOGIC &&
        f77_if_tail < lx_stmt_len &&
        lx_stmt[f77_if_tail] >= '0' && lx_stmt[f77_if_tail] <= '9') {
        /* Arithmetic IF: IF (e) l1, l2, l3 -- branch on the sign of e.
         * No statement can begin with a digit, so a digit after the
         * closing paren can only be the first label.  Both compares
         * are emitted up front in the current block (which dominates
         * the middle one), then two conditional branches chain. */
        int v;
        int vty;
        int vhi;
        int c_neg;
        int c_eq;
        int l1, l2, l3;
        int b_mid;
        f77_scan_from(2);
        v = f77_expr();          /* parses the (e) as a parenthesised primary */
        vty = ex_ty;
        vhi = ex_hi;
        if (lx_t != T_ICON) { f77_error("arithmetic IF needs three labels"); goto done; }
        l1 = lex_ival; f77_tok();
        if (lx_t != T_COMMA) { f77_error("arithmetic IF needs three labels"); goto done; }
        f77_tok();
        if (lx_t != T_ICON) { f77_error("arithmetic IF needs three labels"); goto done; }
        l2 = lex_ival; f77_tok();
        if (lx_t != T_COMMA) { f77_error("arithmetic IF needs three labels"); goto done; }
        f77_tok();
        if (lx_t != T_ICON) { f77_error("arithmetic IF needs three labels"); goto done; }
        l3 = lex_ival; f77_tok();

        if (vty == TY_DOUBLE) {
            int z;
            int zhi;
            z = f77_dconst(0.0, &zhi);
            c_neg = f77_fp64_call2("__fp64_lt", v, vhi, z, zhi, NULL);
            c_eq = f77_fp64_call2("__fp64_eq", v, vhi, z, zhi, NULL);
        } else if (vty == TY_FLOAT) {
            int z;
            z = f77_rconst(0.0);
            c_neg = hi_emit(HI_FLT, TY_INT, v, z, 0, NULL);
            c_eq = hi_emit(HI_FEQ, TY_INT, v, z, 0, NULL);
        } else {
            c_neg = hi_emit(HI_SLT, TY_INT, v, f77_iconst(0), 0, NULL);
            c_eq = hi_emit(HI_SEQ, TY_INT, v, f77_iconst(0), 0, NULL);
        }
        b_mid = hir_new_block();
        hi_emit(HI_BRC, TY_VOID, c_neg, f77_label_blk(l1), b_mid, NULL);
        f77_cur_blk_live = 0;
        f77_begin_blk(b_mid);
        {
            /* one at a time: f77_label_blk makes a label's block on first
             * sight, and C leaves the order of a call's arguments open,
             * so as arguments the two blocks came out numbered one way
             * by gcc on x86_64 and the other by gcc on arm64 and clang */
            int b2;
            int b3;
            b2 = f77_label_blk(l2);
            b3 = f77_label_blk(l3);
            hi_emit(HI_BRC, TY_VOID, c_eq, b2, b3, NULL);
        }
        f77_cur_blk_live = 0;
        goto done;
    }

    if (cls == S_IF_LOGIC) {
        /* IF (e) stmt -- execute stmt only when e is true. */
        f77_scan_from(2);
        c = f77_expr();
        b_then = hir_new_block();
        b_end = hir_new_block();
        hi_emit(HI_BRC, TY_VOID, c, b_then, b_end, NULL);
        f77_cur_blk_live = 0;
        f77_begin_blk(b_then);
        {
            /* Re-classify the tail as a statement in its own right by
             * shifting it to the front of the buffer. */
            int i;
            int tail;
            int save_label;
            tail = f77_if_tail;
            save_label = lx_stmt_label;
            i = 0;
            while (tail + i < lx_stmt_len) { lx_stmt[i] = lx_stmt[tail + i]; i = i + 1; }
            lx_stmt_len = i;
            lx_stmt[i] = 0;
            lx_stmt_label = -1;
            f77_statement();
            lx_stmt_label = save_label;
        }
        f77_goto_blk(b_end);
        f77_begin_blk(b_end);
        goto done;
    }

    if (cls == S_IF_BLOCK) {
        f77_scan_from(2);
        c = f77_expr();
        if (lx_t == T_NAME && strcmp(lex_name, "THEN") == 0) f77_tok();
        b_then = hir_new_block();
        b_else = hir_new_block();
        b_end = hir_new_block();
        hi_emit(HI_BRC, TY_VOID, c, b_then, b_else, NULL);
        f77_cur_blk_live = 0;
        f77_begin_blk(b_then);
        if (ctl_n >= F77_MAX_CTL) { f77_error("control nesting too deep"); goto done; }
        ctl_kind[ctl_n] = F77_CTL_IF;
        ctl_else[ctl_n] = b_else;
        ctl_exit[ctl_n] = b_end;
        ctl_n = ctl_n + 1;
        goto done;
    }

    /* --- keyword statements --- */

    if (f77_starts("PROGRAM")) goto done;      /* name is documentation */

    if (f77_starts("FORMAT")) goto done;       /* collected in phase 1 */

    if ((n = f77_starts("WRITE")) != 0) { f77_stmt_write(n); goto done; }
    if ((n = f77_starts("PRINT")) != 0) { f77_stmt_print(n); goto done; }
    if ((n = f77_starts("READ")) != 0)  { f77_stmt_read(n);  goto done; }
    if ((n = f77_starts("OPEN")) != 0)  { f77_stmt_open(n);  goto done; }
    if ((n = f77_starts("CLOSE")) != 0) { f77_stmt_close(n); goto done; }
    if ((n = f77_starts("INQUIRE")) != 0) { f77_stmt_inquire(n); goto done; }
    if ((n = f77_starts("REWIND")) != 0) { f77_stmt_rewind(n); goto done; }
    if ((n = f77_starts("BACKSPACE")) != 0) {
        int u;
        f77_scan_from(n);
        if (lx_t == T_LP) {
            f77_tok();
            if (lx_t == T_NAME && strcmp(lex_name, "UNIT") == 0) { f77_tok(); if (lx_t == T_ASSIGN) f77_tok(); }
            u = f77_expr(); u = f77_cvt(u, &ex_hi, ex_ty, TY_INT);
            if (lx_t != T_RP) f77_error("expected ) in BACKSPACE");
            else f77_tok();
        } else {
            u = f77_expr(); u = f77_cvt(u, &ex_hi, ex_ty, TY_INT);
        }
        f77_call_i("f77_backspace", 1, &u);
        goto done;
    }
    if ((n = f77_starts("EQUIVALENCE")) != 0) { f77_stmt_equivalence(n); goto done; }
    if (f77_starts("CHARACTER")) { f77_stmt_decl(TY_CHAR, 9); goto done; }
    if (f77_starts("COMPLEX")) { f77_stmt_decl(TY_CPLX, 7); goto done; }
#ifdef F77_NATIVE_F64
    if (f77_starts("DOUBLECOMPLEX")) { f77_stmt_decl(TY_DCPLX, 13); goto done; }
#endif
    if (f77_starts("BLOCKDATA")) goto done;    /* this unit's own header */
    if ((n = f77_starts("EXTERNAL")) != 0) {
        /* Names of external procedures.  Recorded so that passing one
         * as an actual argument is refused instead of passing the
         * address of a variable of that name. */
        f77_scan_from(n);
        while (lx_t == T_NAME) {
            f77_sexternal[f77_sym(lex_name)] = 1;
            f77_tok();
            if (lx_t != T_COMMA) break;
            f77_tok();
        }
        goto done;
    }
    if ((n = f77_starts("INTRINSIC")) != 0) {
        f77_scan_from(n);
        while (lx_t == T_NAME) {
            f77_sintrinsic[f77_sym(lex_name)] = 1;
            f77_tok();
            if (lx_t != T_COMMA) break;
            f77_tok();
        }
        goto done;
    }
    if ((n = f77_starts("ASSIGN")) != 0) { f77_stmt_assign_label(n); goto done; }
    if ((n = f77_starts("PAUSE")) != 0) {
        int args[2];
        f77_scan_from(n);
        if (lx_t == T_SCON) {
            args[0] = hi_emit(HI_SADDR, HL_ADDR_TY, -1, -1, lex_sidx, NULL);
            args[1] = f77_iconst(lex_slen);
        } else if (lx_t == T_ICON) {
            int si;
            si = f77_intern_str(lx_stmt + n, lx_stmt_len - n);
            args[0] = hi_emit(HI_SADDR, HL_ADDR_TY, -1, -1, si, NULL);
            args[1] = f77_iconst(lx_stmt_len - n);
        } else {
            args[0] = f77_iconst(0);
            args[1] = f77_iconst(0);
        }
        if (lx_t == T_SCON || lx_t == T_ICON) f77_tok();
        f77_call_i("f77_pause", 2, args);
        goto done;
    }
    if (f77_starts("ENTRY")) {
        /* A no-op in the flow, except where the unit being compiled is
         * this ENTRY: its code begins here (falling into an ENTRY
         * statement goes on past it, as for any other). */
        if (f77_entry_state == 2 && lx_stmt_line == f77_entry_line) {
            f77_goto_blk(f77_entry_blk);
            f77_begin_blk(f77_entry_blk);
            f77_entry_state = 3;
        }
        goto done;
    }


    if (f77_starts("SUBROUTINE") || f77_unit_header_ty() >= 0) {
        /* The header was consumed by f77_bind_unit() before the body
         * was parsed; seeing it here means it is this unit's own
         * header, which needs no code. */
        goto done;
    }

    if ((n = f77_starts("RETURN")) != 0) {
        /* RETURN [e]: e selects an alternate return in the caller. */
        f77_scan_from(n);
        f77_ret_code = -1;
        if (lx_t != T_EOF) {
            f77_ret_code = f77_expr();
            f77_ret_code = f77_cvt(f77_ret_code, &ex_hi, ex_ty, TY_INT);
        }
        f77_emit_return();
        f77_ret_code = -1;
        goto done;
    }

    if ((n = f77_starts("CALL")) != 0) {
        f77_stmt_call(n);
        goto done;
    }

    if (f77_starts("CONTINUE")) goto done;
    if (f77_starts("INTEGER"))  { f77_stmt_decl(TY_INT,   7); goto done; }
    if (f77_starts("LOGICAL"))  { f77_decl_log = 1; f77_stmt_decl(TY_INT, 7); f77_decl_log = 0; goto done; }
    if (f77_starts("DOUBLEPRECISION")) { f77_stmt_decl(TY_DOUBLE, 15); goto done; }
    if (f77_starts("DIMENSION")) { f77_stmt_decl(-1, 9); goto done; }
    if (f77_starts("REAL"))     { f77_stmt_decl(TY_FLOAT, 4); goto done; }
    if ((n = f77_starts("COMMON")) != 0) { f77_stmt_common(n); goto done; }
    if ((n = f77_starts("SAVE")) != 0)   { f77_stmt_save(n);   goto done; }
    if ((n = f77_starts("PARAMETER")) != 0) { f77_stmt_parameter(n); goto done; }
    if ((n = f77_starts("DATA")) != 0)   { f77_stmt_data(n);   goto done; }
    if ((n = f77_starts("IMPLICIT")) != 0) { f77_stmt_implicit(n); goto done; }

    if (f77_starts("ELSEIF")) {
        /* ELSE IF (e) THEN -- close the current arm, open a new test in
         * the pending else block. */
        if (ctl_n == 0 || ctl_kind[ctl_n - 1] != F77_CTL_IF) {
            f77_error("ELSE IF without IF");
            goto done;
        }
        f77_goto_blk(ctl_exit[ctl_n - 1]);
        f77_begin_blk(ctl_else[ctl_n - 1]);
        f77_scan_from(8);                       /* past "ELSEIF(" minus the ( */
        {
            int save;
            save = f77_match_paren(6);
            (void)save;
        }
        f77_scan_from(7);
        c = f77_expr();
        if (lx_t == T_RP) f77_tok();
        if (lx_t == T_NAME && strcmp(lex_name, "THEN") == 0) f77_tok();
        b_then = hir_new_block();
        b_else = hir_new_block();
        hi_emit(HI_BRC, TY_VOID, c, b_then, b_else, NULL);
        f77_cur_blk_live = 0;
        ctl_else[ctl_n - 1] = b_else;
        f77_begin_blk(b_then);
        goto done;
    }

    if (f77_starts("ELSE")) {
        if (ctl_n == 0 || ctl_kind[ctl_n - 1] != F77_CTL_IF) {
            f77_error("ELSE without IF");
            goto done;
        }
        f77_goto_blk(ctl_exit[ctl_n - 1]);
        f77_begin_blk(ctl_else[ctl_n - 1]);
        ctl_else[ctl_n - 1] = -1;
        goto done;
    }

    if (f77_starts("ENDDO") && lx_stmt_len == 5) {
        /* fort370: END DO closes the innermost unlabelled DO; with the
         * label a labelled DO names, it is that DO's terminal statement
         * (and closed with the label, below) */
        if (ctl_n > f77_ctl_base && ctl_kind[ctl_n - 1] == F77_CTL_DO && ctl_label[ctl_n - 1] == -1)
            f77_close_top_do();
        else if (!(ctl_n > f77_ctl_base && ctl_kind[ctl_n - 1] == F77_CTL_DO &&
                   lx_stmt_label >= 0 && ctl_label[ctl_n - 1] == lx_stmt_label))
            f77_error("END DO without DO");
        goto done;
    }
    if (f77_is_dowhile()) { f77_open_dowhile(); goto done; }

    if (f77_starts("ENDIF")) {
        if (ctl_n == 0 || ctl_kind[ctl_n - 1] != F77_CTL_IF) {
            f77_error("ENDIF without IF");
            goto done;
        }
        ctl_n = ctl_n - 1;
        f77_goto_blk(ctl_exit[ctl_n]);
        if (ctl_else[ctl_n] >= 0) {
            /* No ELSE arm: the false edge falls straight through. */
            f77_begin_blk(ctl_else[ctl_n]);
            f77_goto_blk(ctl_exit[ctl_n]);
        }
        f77_begin_blk(ctl_exit[ctl_n]);
        goto done;
    }

    if ((n = f77_starts("GOTO")) != 0) {
        f77_scan_from(n);
        if (lx_t == T_LP) {
            /* Computed GOTO: GOTO (l1, l2, ...) [,] e -- jump to the
             * e'th label, fall through when e is outside [1, n].  One
             * unsigned compare covers both ends (e-1 underflows), and
             * the dispatch itself is a jump table, the machinery
             * switch statements already proved. */
            int targets[64];
            int nt;
            int v;
            int b_tab;
            int b_next;
            nt = 0;
            f77_tok();
            for (;;) {
                if (lx_t != T_ICON) { f77_error("computed GOTO needs statement labels"); goto done; }
                if (nt >= 64) { f77_error("too many labels in computed GOTO"); goto done; }
                targets[nt] = f77_label_blk(lex_ival);
                nt = nt + 1;
                f77_tok();
                if (lx_t != T_COMMA) break;
                f77_tok();
            }
            if (lx_t != T_RP) { f77_error("expected ) in computed GOTO"); goto done; }
            f77_tok();
            if (lx_t == T_COMMA) f77_tok();
            v = f77_expr();
            v = f77_cvt(v, &ex_hi, ex_ty, TY_INT);
            v = hi_emit(HI_ADDI, TY_INT, v, -1, -1, NULL);
            b_tab = hir_new_block();
            b_next = hir_new_block();
            c = hi_emit(HI_SGTU, TY_INT, f77_iconst(nt), v, 0, NULL);
            hi_emit(HI_BRC, TY_VOID, c, b_tab, b_next, NULL);
            f77_cur_blk_live = 0;
            f77_begin_blk(b_tab);
            hi_emit_jmptab(v, b_next, targets, nt);
            f77_cur_blk_live = 0;
            f77_begin_blk(b_next);
            goto done;
        }
        if (lx_t == T_NAME) {
            /* Assigned GOTO: GO TO v [, (l1, l2, ...)].  A compare
             * chain over the listed labels, or over every label this
             * unit ASSIGNs when there is no list; the last candidate
             * is taken unconditionally (the standard leaves a value
             * outside the list undefined). */
            int labs[64];
            int nl;
            int i;
            int v;
            int s;
            s = f77_sym(lex_name);
            v = f77_load_sym(s);
            v = f77_cvt(v, &ex_hi, ex_ty, TY_INT);
            f77_tok();
            if (lx_t == T_COMMA) f77_tok();
            nl = 0;
            if (lx_t == T_LP) {
                f77_tok();
                for (;;) {
                    if (lx_t != T_ICON) { f77_error("assigned GOTO needs statement labels"); goto done; }
                    if (nl < 64) { labs[nl] = lex_ival; nl = nl + 1; }
                    f77_tok();
                    if (lx_t != T_COMMA) break;
                    f77_tok();
                }
                if (lx_t != T_RP) { f77_error("expected ) in assigned GOTO"); goto done; }
                f77_tok();
            } else {
                for (i = 0; i < f77_nasg; i++) {
                    if (f77_asg_unit[i] != f77_cur_unit) continue;
                    if (f77_find_format(f77_asg_lab[i]) >= 0) continue;
                    if (nl < 64) { labs[nl] = f77_asg_lab[i]; nl = nl + 1; }
                }
            }
            if (nl == 0) { f77_error("assigned GOTO has no candidate labels"); goto done; }
            for (i = 0; i + 1 < nl; i++) {
                int b_next;
                c = hi_emit(HI_SEQ, TY_INT, v, f77_iconst(labs[i]), 0, NULL);
                b_next = hir_new_block();
                hi_emit(HI_BRC, TY_VOID, c, f77_label_blk(labs[i]), b_next, NULL);
                f77_cur_blk_live = 0;
                f77_begin_blk(b_next);
            }
            f77_goto_blk(f77_label_blk(labs[nl - 1]));
            goto done;
        }
        if (lx_t != T_ICON) { f77_error("GOTO needs a label"); goto done; }
        f77_goto_blk(f77_label_blk(lex_ival));
        f77_tok();
        goto done;
    }

    if ((n = f77_starts("STOP")) != 0) {
        int v;
        int cb;
        int r;
        f77_scan_from(n);
        v = (lx_t == T_ICON) ? f77_iconst(lex_ival) : f77_iconst(0);
        if (lx_t == T_ICON || lx_t == T_SCON) f77_tok();   /* STOP n, STOP 'text' */
        if (f77_cur_blk_live) {
            /* Process exit, not a function return -- STOP in a
             * SUBROUTINE must terminate the program (GitHub #20). */
            cb = h_ncarg;
            h_carg[h_ncarg] = v;
            h_carg_tag[h_ncarg] = 0;
            h_ncarg = h_ncarg + 1;
            r = hi_emit(HI_CALL, TY_INT, -1, -1, 1, "exit");
            h_cbase[r] = cb;
            hi_emit(HI_RET, TY_INT, v, -1, 0, NULL);
        }
        f77_cur_blk_live = 0;
        goto done;
    }

    if ((n = f77_starts("ENDFILE")) != 0) {   /* must precede the END match */
        int u;
        f77_scan_from(n);
        if (lx_t == T_LP) {
            f77_tok();
            if (lx_t == T_NAME && strcmp(lex_name, "UNIT") == 0) {
                f77_tok();
                if (lx_t == T_ASSIGN) f77_tok();
            }
            u = f77_expr();
            u = f77_cvt(u, &ex_hi, ex_ty, TY_INT);
            if (lx_t != T_RP) f77_error("expected ) in ENDFILE");
            else f77_tok();
        } else {
            u = f77_expr();
            u = f77_cvt(u, &ex_hi, ex_ty, TY_INT);
        }
        f77_call_i("f77_endfile", 1, &u);
        goto done;
    }

    if (f77_is_unit_end()) {
        /* Falling off END returns like RETURN does -- a FUNCTION hands
         * back its result variable.  This emitted a bare `return 0`
         * for years: every direct caller was spliced inline and read
         * the variable itself, so only a FUNCTION reached through a
         * dummy procedure ever executed the out-of-line body. */
        f77_emit_return();
        f77_cur_blk_live = 0;
        goto done;
    }

    f77_error("unrecognised statement");

done:
    /* fort370: text left over after a statement's handler is text it
     * did not understand.  Ignored, it was ignored without a word:
     * INTEGER N/9000/, LEN/30000/ lost both values and every name after
     * them.  A statement that already reported an error is left be. */
    if (lx_t != T_EOF && f77_nerr == nerr0) f77_error("unexpected text after the statement");
    /* If this statement carried a label that closes one or more DO
     * loops, close them now -- the terminal statement is part of the
     * loop body and has just been emitted. */
    if (lx_stmt_label >= 0) {
        lab = lx_stmt_label;
        f77_close_do(lab);
    }
}

#endif
