/* COPIED from slow32-public fortran/src/f77_contract.h at 2245be78 (2026-10-12).  See PROVENANCE.md. */
/* f77_contract.h -- the frontend side of the copied SLOW-32 backend.
 *
 * The backend (hir*.h, copied from selfhost/stage08 at 30e16a57) is almost
 * entirely language-neutral, but it reads 45 symbols that the C
 * compiler's frontend happened to define.  They fall into four groups,
 * all supplied here:
 *
 *   1. fd* diagnostic output helpers
 *   2. the type encoding + ty_size/ty_is_* predicates
 *   3. the alloca registry the SSA promoter scans (hl_*)
 *   4. the global-data tables gen_data() emits (ps_g*, string pool)
 *
 * Group 4 is where Fortran COMMON blocks land: a COMMON block is one
 * named, sized .bss object, merged by this compiler rather than by the
 * linker -- s32_formats.h has no COMMON/tentative binding, only
 * LOCAL/GLOBAL/WEAK, so compiler-side merging is the only route.
 *
 * The type encoding is kept bit-identical to the C compiler's so the
 * backend's FP pair handling, comparison lowering and ABI assignment
 * all behave exactly as they do for stage08.  Fortran maps on as:
 *
 *   INTEGER, LOGICAL       -> TY_INT      (4)
 *   INTEGER*2              -> TY_SHORT    (2)
 *   REAL                   -> TY_FLOAT    (4)
 *   DOUBLE PRECISION       -> TY_DOUBLE   (8)
 *   CHARACTER              -> TY_CHAR     (1), CHARACTER*n as an array
 *   COMPLEX / DBLE COMPLEX -> a pair of TY_FLOAT / TY_DOUBLE
 */
#ifndef F77_CONTRACT_H
#define F77_CONTRACT_H

/* --- 1. diagnostic output ------------------------------------------ */

static void fdputs(char *s, int fd) { write(fd, s, strlen(s)); }
static void fdputc(int c, int fd) { char b; b = (char)c; write(fd, &b, 1); }
static void fdputuint(int fd, unsigned int v) {
    char b[16];
    int n;
    n = 0;
    if (v == 0) { fdputc('0', fd); return; }
    while (v > 0) { b[n] = (char)('0' + (v % 10)); v = v / 10; n = n + 1; }
    while (n > 0) { n = n - 1; fdputc(b[n], fd); }
}

/* --- 2. type encoding (bit-identical to selfhost/src/ast.h) --------- */

#define TY_INT    0
#define TY_CHAR   1
#define TY_SHORT  2
#define TY_VOID   3
#define TY_LLONG  4
#define TY_FLOAT  5
#define TY_DOUBLE 6
#define TY_I128   7
#define TY_STRUCT_BASE 8
#define TY_PTR       256
#define TY_UNSIGNED  0x4000
#define TY_BASE_MASK 0x00FF
#define TY_PTR_MASK  0x3F00

static int ty_ptr_size = 4;   /* SLOW-32 is the only target, by ruling */

static int ty_is_llong(int ty) {
    return !(ty & TY_PTR_MASK) && (ty & TY_BASE_MASK) == TY_LLONG;
}
static int ty_is_float(int ty) {
    return !(ty & TY_PTR_MASK) && (ty & TY_BASE_MASK) == TY_FLOAT;
}
static int ty_is_double(int ty) {
    return !(ty & TY_PTR_MASK) && (ty & TY_BASE_MASK) == TY_DOUBLE;
}
static int ty_is_fp(int ty) {
    return ty_is_float(ty) || ty_is_double(ty);
}
static int ty_is_ptr(int ty) { return (ty & TY_PTR_MASK) != 0; }
/* Fortran 77 has no derived types; the shared ssa pair-split pass
 * asks, so answer no. */
static int ty_is_struct(int ty) { (void)ty; return 0; }

static int ty_size(int ty) {
    if (ty & TY_PTR_MASK) return ty_ptr_size;
    if ((ty & TY_BASE_MASK) == TY_DOUBLE) return 8;
    if ((ty & TY_BASE_MASK) == TY_LLONG) return 8;
    if ((ty & TY_BASE_MASK) == TY_FLOAT) return 4;
    if ((ty & TY_BASE_MASK) == TY_CHAR) return 1;
    if ((ty & TY_BASE_MASK) == TY_SHORT) return 2;
    if ((ty & TY_BASE_MASK) == TY_VOID) return 1;
    return 4;
}

/* --- 3. alloca registry scanned by the SSA promoter ----------------- */

#define HL_MAX_ALLOCA 4096
static int hl_ainst[HL_MAX_ALLOCA];  /* HIR index of each ALLOCA */
static int hl_aoff[HL_MAX_ALLOCA];   /* frame offset of each ALLOCA */
static int hl_aslot[HL_MAX_ALLOCA];  /* the C parser's slot id; always 0 here
                                      * (keyed by offset) -- it only matters
                                      * to the SSA pass in a function that
                                      * calls setjmp, which no Fortran does */
static int hl_nalloca;
static int hl_temp_stack;            /* bytes of compiler temporaries */
static int hl_nparams;               /* flat incoming-parameter count */

/* --- 3b. the C inliner's hooks (selfhost hir_lower.h) ---------------- */
/* gen_program() sets these up from S12CC_INLINE* and calls
 * hl_inl_prepare() before the first unit.  Fortran inlines at the
 * front end (f77_parse.h splices units, F77_INLINE_MAX), so the hooks
 * are inert here: the budget stays whatever the environment says and
 * nothing reads it. */
static Node *hl_prog;
static int   hl_inline_max;
static int   hl_inl_move_max;
static int   hl_inl_huge;
static int   hl_stat_inlined;
static int   hl_stat_inl_sel;
static int   hl_stat_inl_direct;
static void  hl_inl_prepare(Node *prog) { (void)prog; }

/* --- 4. global data tables walked by gen_data() --------------------- */

#define P_MAX_GLOBALS 8192
#define PS_MAX_INIT_POOL 262144
#define PS_MAX_INIT_RELOCS 8192

static char *ps_gname[P_MAX_GLOBALS];
static int   ps_gtype[P_MAX_GLOBALS];
static int   ps_gsize[P_MAX_GLOBALS];
static int   ps_ginit[P_MAX_GLOBALS];
static int   ps_ginit_hi[P_MAX_GLOBALS];
static int   ps_gstr[P_MAX_GLOBALS];
static int   ps_glocal[P_MAX_GLOBALS];
static int   ps_gextern[P_MAX_GLOBALS];
static int   ps_nglobals;

static unsigned char ps_ginit_pool[PS_MAX_INIT_POOL];
static int ps_ginit_start[P_MAX_GLOBALS];
static int ps_ginit_count[P_MAX_GLOBALS];
static int ps_ginit_pool_len;

#define GIRELOC_STRING 0
#define GIRELOC_GLOBAL 1
#define GIRELOC_SYMBOL 2
static int   ps_girel_start[P_MAX_GLOBALS];
static int   ps_girel_count[P_MAX_GLOBALS];
static int   ps_girel_off[PS_MAX_INIT_RELOCS];
static int   ps_girel_kind[PS_MAX_INIT_RELOCS];
static int   ps_girel_idx[PS_MAX_INIT_RELOCS];
static int   ps_girel_size[PS_MAX_INIT_RELOCS];
static int   ps_girel_add[PS_MAX_INIT_RELOCS];
static char *ps_girel_name[PS_MAX_INIT_RELOCS];

/* String pool: Fortran character constants (Hollerith and '...' alike)
 * land here and are emitted as .L.str labels by gen_data(). */
#define LEX_STRPOOL_MAX 262144
#define LEX_MAX_STRINGS 8192
static char lex_strpool[LEX_STRPOOL_MAX];
static int  lex_str_off[LEX_MAX_STRINGS];
static int  lex_str_len[LEX_MAX_STRINGS];
static int  lex_str_count;
static int  lex_strpool_len;

/* Intern a string constant; returns its pool index. */
static int f77_intern_str(char *s, int len) {
    int idx;
    int i;
    idx = lex_str_count;
    lex_str_off[idx] = lex_strpool_len;
    lex_str_len[idx] = len;
    i = 0;
    while (i < len) {
        lex_strpool[lex_strpool_len] = s[i];
        lex_strpool_len = lex_strpool_len + 1;
        i = i + 1;
    }
    lex_strpool[lex_strpool_len] = 0;
    lex_strpool_len = lex_strpool_len + 1;
    lex_str_count = idx + 1;
    return idx;
}

/* Label counter shared with the backend's branch emission (same shape
 * as selfhost's parser.h: a monotonic counter behind an allocator). */
static int cg_lbl;

static int cg_label(void) {
    int l;
    l = cg_lbl;
    cg_lbl = cg_lbl + 1;
    return l;
}

/* Defined by hir_regalloc.h / the Fortran lowering respectively; the
 * backend calls both before their definitions appear. */
static void ra_dump_signed(int v);
static void hl_func(Node *fn);

/* ra_dump_signed is defined by hir_regalloc.h itself. */

#endif
