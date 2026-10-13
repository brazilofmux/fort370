/* hir_codegen_s370.h -- HIR to System/370 assembler, for IFOX00 and IEWL.
 *
 * The shape of the output is FORTRAN H's (docs/BACKEND.md): one CSECT
 * per program unit, standard OS linkage, a static area per unit (save
 * area, constants, scalars, spill slots, arrays) based on R13, code
 * based on R12.  Every reference into the static area is written
 * symbolically so the assembler chooses base and displacement.
 *
 * Register roles:
 *   R0,R1    scratch; the even/odd pair for M/D; R1 the parameter list
 *   R2..R11  allocatable (R11, R10 withheld as extra data bases if the
 *            static area outgrows 4K)
 *   R12      code base
 *   R13      data base and save area
 *   R14,R15  linkage; reload scratch between calls
 *   FPR0,2,4,6  allocatable; FPR0 carries a REAL/DOUBLE function result
 *
 * The first version is register to register: a storage operand
 * nonterminal comes later.  WRITE and STOP go through FORTLIB's IBCOM#
 * exactly as H's code does, as a bootstrap.
 */

/* ---------------------------------------------------------------- */
/* Output                                                            */
/* ---------------------------------------------------------------- */

#define CG_MAX_OUT 32768    /* flushed whenever it fills */
static char cg_out[CG_MAX_OUT];
static int  cg_olen;
static FILE *cg_fp;
static char *cg_outpath;

static void cg_flush(void) {
    if (!cg_fp) { cg_olen = 0; return; }
    if (cg_olen > 0 && fwrite(cg_out, 1, (size_t)cg_olen, cg_fp) != (size_t)cg_olen) {
        fdputs("f77: write failed\n", 2);
        exit(1);
    }
    cg_olen = 0;
}

static int cg_dry;          /* a sizing pass: emit nothing, count bytes */
static void cg_c(int ch) {
    if (cg_dry) return;
    if (cg_olen >= CG_MAX_OUT) cg_flush();
    cg_out[cg_olen] = (char)ch;
    cg_olen = cg_olen + 1;
}

static void cg_s(char *s) { while (*s) { cg_c(*s); s = s + 1; } }

static void cg_n(int v) {
    char b[16];
    int n;
    unsigned int u;
    if (v < 0) { cg_c('-'); u = (unsigned int)(0 - v); } else u = (unsigned int)v;
    n = 0;
    if (u == 0) { cg_c('0'); return; }
    while (u > 0) { b[n] = (char)('0' + (u % 10)); u = u / 10; n = n + 1; }
    while (n > 0) { n = n - 1; cg_c(b[n]); }
}

static int s370_emitting = -1;   /* the instruction being emitted, for diagnostics */
static char *bg_op_name(int op);
static void cg_die(char *msg, int inst) {
    fdputs("f77: s370: ", 2);
    fdputs(msg, 2);
    if (inst >= 0) {
        fdputs(" at HIR ", 2); fdputuint(2, (unsigned)inst);
        fdputs(" (", 2); fdputs(bg_op_name(h_kind[inst]), 2);
        fdputs(" ty=", 2); fdputuint(2, (unsigned)h_ty[inst]);
        fdputs(" reg=", 2); fdputuint(2, (unsigned)ra_reg[inst]);
        fdputs(" blk=", 2); fdputuint(2, (unsigned)h_blk[inst]);
        fdputs(" fold=", 2); fdputuint(2, (unsigned)bg_fold[inst]);
        fdputs(" licm_map=", 2); fdputuint(2, (unsigned)licm_map[inst]);
        fdputs(" src1=", 2); fdputuint(2, (unsigned)h_src1[inst]);
        fdputc(')', 2);
    }
    if (s370_emitting >= 0) {
        fdputs(" while emitting HIR ", 2); fdputuint(2, (unsigned)s370_emitting);
        fdputs(" (", 2); fdputs(bg_op_name(h_kind[s370_emitting]), 2); fdputc(')', 2);
    }
    fdputc(10, 2);
    exit(1);
}

/* One assembler statement: label in column 1, opcode in 10, operands
 * in 16, nothing past column 71.  Comments go on their own lines. */
static char s370_line[200];
static int  s370_pc;          /* bytes of code emitted in this CSECT, for alignment */

static void s370_scache_clear(void);
static int s370_scache[16];
/* Code labels (Lnnnnn) by offset in the CSECT, numbered from the first
 * label the unit allocated.  A label 4K or more past the code base
 * (the BALR 12,0) is "far": a branch to it loads its address into R15
 * from the pool and branches 0(,15).  A sizing pass (cg_dry) finds
 * them before the real one; see s370_gen_unit. */
#define S370_MAX_ULBL (8192 * F77_ROOM)    /* fort370: labels in one unit; a unit past it is refused */
static int  s370_lbl_base;
static int  s370_lbl_pc[S370_MAX_ULBL];
static char s370_far[S370_MAX_ULBL];
static int  s370_code_base;
static int  s370_sizing_changed;
static int  s370_area_end_sized;   /* the static area's extent the sizing found */
static int s370_lbl_far(int lbl) {
    lbl = lbl - s370_lbl_base;
    return lbl >= 0 && lbl < S370_MAX_ULBL && s370_far[lbl];
}

static void asm_stmt(char *label, char *op, char *operands) {
    int col;
    int i;
    char *p;
    if (label && *label) s370_scache_clear();
    if (label && label[0] == 'L' && label[1] >= '0' && label[1] <= '9') {
        int n;
        n = atoi(label + 1) - s370_lbl_base;
        if (n < 0 || n >= S370_MAX_ULBL) cg_die("too many labels in one unit", -1);
        s370_lbl_pc[n] = s370_pc;
    }
    col = 0;
    p = label;
    while (p && *p) { cg_c(*p); p = p + 1; col = col + 1; }
    while (col < 9) { cg_c(' '); col = col + 1; }
    p = op;
    while (*p) { cg_c(*p); p = p + 1; col = col + 1; }
    if (operands && *operands) {
        i = col < 15 ? 15 : col + 1;
        while (col < i) { cg_c(' '); col = col + 1; }
        p = operands;
        while (*p) {
            if (col >= 71) cg_die("assembler statement past column 71", -1);
            cg_c(*p); p = p + 1; col = col + 1;
        }
    }
    cg_c('\n');
}

static void asm_comment(char *text) {
    int col;
    cg_c('*'); cg_c(' ');
    col = 2;
    while (*text && col < 71) { cg_c(*text); text = text + 1; col = col + 1; }
    cg_c('\n');
}

/* Reload reuse: which value R1, R14 and R15 hold after a reload, so
 * a second use in the same straight-line run needs no second load.
 * Cleared at every label and whenever the register is written. */
static int s370_scache[16];
static void s370_scache_clear(void) { s370_scache[1] = -1; s370_scache[14] = -1; s370_scache[15] = -1; }

/* Does this instruction write its first-operand register? */
static int s370_writes_r1(char *op) {
    if (op[0] == 'S' && op[1] == 'T') return 0;            /* ST STD STE STH STC STM */
    if (op[0] == 'C') return op[1] == 'V' ? 1 : 0;          /* C CR CD CDR CL CLR CE CER; CNOP; CVD writes storage */
    if (op[0] == 'B') return 0;                             /* B BC BR BCR BXLE BXH (BXLE writes r1!) */
    if (op[0] == 'O' && op[1] == 'I') return 0;             /* OI */
    if (op[0] == 'M' && op[1] == 'V') return 0;             /* MVC MVI */
    if (op[0] == 'T' && op[1] == 'R') return 0;             /* TR */
    return 1;
}

/* Machine instruction with a byte length, so alignment is known. */
static void asm_ins(char *op, char *operands, int len) {
    int r;
    asm_stmt("", op, operands);
    s370_pc = s370_pc + len;
    /* keep the scratch cache honest */
    if (op[0] == 'B' && op[1] == 'A') { s370_scache[14] = -1; s370_scache[15] = -1; }   /* BAL BALR */
    if (op[0] == 'B' && op[1] == 'X') { r = atoi(operands); if (r >= 0 && r < 16) s370_scache[r] = -1; }
    if ((op[0] == 'M' && op[1] != 'V') || op[0] == 'D') { if (op[1] == 'R' || op[1] == 0 || op[1] == 'H' || op[1] == 'D' || op[1] == 'E') { s370_scache[1] = -1; } }  /* M MR MH D DR: the pair */
    if (s370_writes_r1(op)) {
        r = atoi(operands);
        if (r >= 0 && r < 16) s370_scache[r] = -1;
    }
    if (strcmp(op, "SRDA") == 0 || strcmp(op, "SRDL") == 0 || strcmp(op, "SLDA") == 0 || strcmp(op, "SLDL") == 0) s370_scache[1] = -1;
}

/* A small formatter for operand strings. */
static char *fmt_p;
static void f_reset(void) { fmt_p = s370_line; *fmt_p = 0; }
static void f_s(char *s) { while (*s) { *fmt_p = *s; fmt_p = fmt_p + 1; s = s + 1; } *fmt_p = 0; }
static void f_c(int c) { *fmt_p = (char)c; fmt_p = fmt_p + 1; *fmt_p = 0; }
static void f_n(int v) {
    char b[16];
    int n;
    unsigned int u;
    if (v < 0) { f_c('-'); u = (unsigned int)(0 - v); } else u = (unsigned int)v;
    n = 0;
    if (u == 0) { f_c('0'); return; }
    while (u > 0) { b[n] = (char)('0' + (u % 10)); u = u / 10; n = n + 1; }
    while (n > 0) { n = n - 1; f_c(b[n]); }
}
static void f_hex8(unsigned int v) {
    int i;
    for (i = 7; i >= 0; i--) f_c("0123456789ABCDEF"[(v >> (4 * i)) & 15]);
}

/* Labels: one global counter, five digits, a letter prefix per kind. */
static char s370_lbuf[8][12];
static int  s370_lrot;
static char *s370_lab(char prefix, int n) {
    char *b;
    int i;
    b = s370_lbuf[s370_lrot];
    s370_lrot = (s370_lrot + 1) & 7;
    b[0] = prefix;
    for (i = 5; i >= 1; i--) { b[i] = (char)('0' + n % 10); n = n / 10; }
    b[6] = 0;
    return b;
}

/* ---------------------------------------------------------------- */
/* Names                                                             */
/* ---------------------------------------------------------------- */

/* External names: eight characters, upper case.  The runtime's C names
 * map to short ones; FORTLIB's mathematical routines by their own
 * names, so a fort370 program and an H program call the same code. */
#include "s370_rtnames.h"

/* The runtime: fort370's own, in C, called by cc370's convention
 * (values at 0(R1), the C stack pointer in word 76 of the save area,
 * results in R15 and FPR0), or F77_IBCOM=1 for H's IBCOM# as the
 * first version used it. */
static int s370_crt = -1;
static int s370_crt_on(void) {
    if (s370_crt < 0) s370_crt = getenv("F77_IBCOM") ? 0 : 1;
    return s370_crt;
}

static char s370_nbuf[12];
static char *s370_extname(char *name) {
    int i;
    if (s370_crt_on()) {
        char *r;
        r = s370_rt_extname(name);
        if (r) return r;
    }
    static char *map[] = {
        "sqrt", "DSQRT", "sqrtf", "SQRT", "sin", "DSIN", "cos", "DCOS", "tan", "DTAN",
        "asin", "DARSIN", "acos", "DARCOS", "atan", "DATAN", "atan2", "DATAN2",
        "exp", "DEXP", "log", "DLOG", "log10", "DLOG10", "sinh", "DSINH", "cosh", "DCOSH",
        "tanh", "DTANH", "pow", "F77DPOW",
        "sinf", "SIN", "cosf", "COS", "tanf", "TAN", "asinf", "ARSIN", "acosf", "ARCOS",
        "atanf", "ATAN", "atan2f", "ATAN2", "expf", "EXP", "logf", "ALOG", "log10f", "ALOG10",
        "sinhf", "SINH", "coshf", "COSH", "tanhf", "TANH", "powf", "F77RPOW",
        "trunc", "F77DINT", "round", "F77DNINT", "truncf", "F77AINT", "roundf", "F77ANINT",
        "f77_ipow", "F77IPOW", "f77_rpow_i", "F77RPOWI", "f77_dpow_i", "F77DPOWI",
        "main", "MAIN",
        0 };
    i = 0;
    while (map[i]) {
        if (strcmp(map[i], name) == 0) return map[i + 1];
        i = i + 2;
    }
    i = 0;
    while (name[i] && i < 8) {
        s370_nbuf[i] = (char)toupper((unsigned char)name[i]);   /* fort370: not - 32, which is ASCII's */
        if (s370_nbuf[i] == '_') s370_nbuf[i] = '@';
        i = i + 1;
    }
    s370_nbuf[i] = 0;
    return s370_nbuf;
}

/* Global objects: a COMMON block "f77c_NAME" is the external NAME (the
 * linkage editor merges COM sections by name); a unit's static
 * ("f77s_unit_var") gets a generated name, since eight characters
 * cannot hold the mangled one. */
static int s370_glbl[P_MAX_GLOBALS];
static char s370_gbuf[12];
static char *s370_gname(char *name) {
    int i;
    if (strncmp(name, "f77c_", 5) == 0) {
        if (strcmp(name + 5, "") == 0 || strcmp(name + 5, "blank") == 0) return "#BLANK";
        return s370_extname(name + 5);
    }
    i = 0;
    while (i < ps_nglobals) {
        if (strcmp(ps_gname[i], name) == 0) {
            if (s370_glbl[i] == 0) s370_glbl[i] = cg_label();
            strcpy(s370_gbuf, s370_lab('G', s370_glbl[i]));
            return s370_gbuf;
        }
        i = i + 1;
    }
    return s370_extname(name);
}

/* ---------------------------------------------------------------- */
/* The unit's static area                                            */
/* ---------------------------------------------------------------- */

/* Fixed header: save area (18F), the saved R1, the conversion
 * doublewords, a floating scratch doubleword. */
#define S370_HDR_SAVE   0
#define S370_HDR_PARM   72
#define S370_HDR_ICVT   80    /* DC X'4E000000',F'0': the int-to-float staging doubleword */
#define S370_HDR_ECVT   88    /* DC D'0': short-to-long staging (only the first word is written) */
#define S370_HDR_FTMP   96    /* floating scratch, for FPR spills around a def */
#define S370_HDR_PHIT   104   /* phi-copy staging: 8 doublewords, the last for cycle breaking */
#define S370_HDR_NPHIT  8
#define S370_HDR_CVTT   168   /* float-to-integer staging doubleword */
#define S370_HDR_SIZE   176

static int s370_area_lbl;     /* Snnnnn, the area */
static int s370_near_limit;   /* bytes the data bases reach */
static int s370_nbases;       /* 1: R13; 2: +R11; 3: +R10 */
static int s370_area_size;    /* running size during layout */
static int s370_unit_is_main;
static int s370_cur_unit;

/* ALLOCA objects */
#define S370_MAX_OBJ 4096
static int s370_obj_inst[S370_MAX_OBJ];
static int s370_obj_size[S370_MAX_OBJ];
static int s370_obj_off[S370_MAX_OBJ];     /* offset in the area, or -1 = far */
static int s370_obj_lbl[S370_MAX_OBJ];     /* Tnnnnn */
static int s370_nobj;
static int s370_alab[HIR_MAX_INST];        /* ALLOCA inst -> its label number */

/* Spill slots: offset of slot 0 in the area; each 8 bytes */
static int s370_spill_base;

/* Constant pool entries, interned */
#define S370_MAX_POOL 4096
#define S370_PK_F     1    /* DC F'v' */
#define S370_PK_H     2    /* DC H'v' */
#define S370_PK_D     3    /* DC X'8 bytes' */
#define S370_PK_E     4    /* DC X'4 bytes' */
#define S370_PK_A     5    /* DC A(name+off) */
#define S370_PK_V     6    /* DC V(name) */
#define S370_PK_AT    7    /* DC A(Tnnnnn+off): a far object */
#define S370_PK_AL    8    /* DC A(Lnnnnn): a block label */
#define S370_PK_AQ    9    /* DC A(Qnnnnn+off): a string */
#define S370_PK_AB   10    /* DC A(Lnnnnn): a code label, for a far branch */
static int   s370_pk_kind[S370_MAX_POOL];
static int   s370_pk_lbl[S370_MAX_POOL];
static unsigned int s370_pk_v1[S370_MAX_POOL];
static unsigned int s370_pk_v2[S370_MAX_POOL];
static char *s370_pk_name[S370_MAX_POOL];
static int   s370_npool;

static int s370_pool(int kind, unsigned int v1, unsigned int v2, char *name) {
    int i;
    i = 0;
    while (i < s370_npool) {
        if (s370_pk_kind[i] == kind && s370_pk_v1[i] == v1 && s370_pk_v2[i] == v2 &&
            ((name == 0 && s370_pk_name[i] == 0) ||
             (name != 0 && s370_pk_name[i] != 0 && strcmp(name, s370_pk_name[i]) == 0)))
            return s370_pk_lbl[i];
        i = i + 1;
    }
    if (s370_npool >= S370_MAX_POOL) cg_die("constant pool overflow", -1);
    s370_pk_kind[i] = kind;
    s370_pk_v1[i] = v1;
    s370_pk_v2[i] = v2;
    s370_pk_name[i] = name ? strdup(name) : 0;   /* callers pass static buffers */
    s370_pk_lbl[i] = cg_label();
    s370_npool = s370_npool + 1;
    return s370_pk_lbl[i];
}

static char *s370_pool_f(int v) { return s370_lab('C', s370_pool(S370_PK_F, (unsigned)v, 0, 0)); }
static char *s370_pool_h(int v) { return s370_lab('C', s370_pool(S370_PK_H, (unsigned)v, 0, 0)); }
static char *s370_pool_v(char *name) { return s370_lab('C', s370_pool(S370_PK_V, 0, 0, name)); }
static char *s370_pool_a(char *name, int off) { return s370_lab('C', s370_pool(S370_PK_A, (unsigned)off, 0, name)); }
static char *s370_pool_at(int tlbl, int off) { return s370_lab('C', s370_pool(S370_PK_AT, (unsigned)tlbl, (unsigned)off, 0)); }
static char *s370_pool_al(int lbl) { return s370_lab('C', s370_pool(S370_PK_AL, (unsigned)lbl, 0, 0)); }
static char *s370_pool_ab(int lbl) { return s370_lab('C', s370_pool(S370_PK_AB, (unsigned)lbl, 0, 0)); }
static char *s370_pool_aq(int sidx, int off) { return s370_lab('C', s370_pool(S370_PK_AQ, (unsigned)sidx, (unsigned)off, 0)); }

/* Strings used by this compilation (format texts, character
 * constants): Qnnnnn, emitted in the area of the unit that first used
 * them -- every unit's area is covered, and a string is referenced
 * through an address constant anyway. */
static int s370_str_lbl[LEX_MAX_STRINGS];
static int s370_str_unit[LEX_MAX_STRINGS];

/* Floating constant conversion */
static void s370_fconst_bits(int inst, unsigned int *hi, unsigned int *lo) {
    if (h_name[inst] == 0 || hfp_from_text(h_name[inst], hi, lo) < 0)
        cg_die("bad floating constant", inst);
}

static char *s370_pool_fconst(int inst) {
    unsigned int hi, lo;
    s370_fconst_bits(inst, &hi, &lo);
    if (ty_is_double(h_ty[inst])) return s370_lab('C', s370_pool(S370_PK_D, hi, lo, 0));
    return s370_lab('C', s370_pool(S370_PK_E, hi, 0, 0));
}

/* ---------------------------------------------------------------- */
/* Layout of the allocas: small objects first, so scalars and spills */
/* stay within reach of the data bases.                              */
/* ---------------------------------------------------------------- */

static int s370_cmp_size(const void *a, const void *b) {
    int ia, ib;
    ia = *(const int *)a;
    ib = *(const int *)b;
    if (s370_obj_size[ia] != s370_obj_size[ib]) return s370_obj_size[ia] - s370_obj_size[ib];
    return ia - ib;
}

static int s370_order[S370_MAX_OBJ];

static void s370_layout(void) {
    int i;
    int j;
    int n;
    int k;
    int off;
    int small_total;
    int big_total;

    i = 0;
    while (i < h_ninst) { s370_aoff[i] = -1; s370_alab[i] = -1; i = i + 1; }
    n = 0;
    i = 0;
    while (i < h_ninst) {
        if (h_kind[i] == HI_ALLOCA && h_val[i] < 0) {
            if (n >= S370_MAX_OBJ) cg_die("too many local objects", i);
            s370_obj_inst[n] = i;
            n = n + 1;
        }
        i = i + 1;
    }
    s370_nobj = n;
    /* Sizes from the gaps between frame offsets (the front end hands
     * out offsets in allocation order; an abandoned slot merges into
     * its predecessor's gap, which is harmless). */
    i = 0;
    while (i < n) { s370_order[i] = i; i = i + 1; }
    /* sort by frame depth (-h_val ascending) to find the gaps */
    i = 0;
    while (i < n) {
        j = i + 1;
        while (j < n) {
            if (0 - h_val[s370_obj_inst[s370_order[j]]] < 0 - h_val[s370_obj_inst[s370_order[i]]]) {
                k = s370_order[i]; s370_order[i] = s370_order[j]; s370_order[j] = k;
            }
            j = j + 1;
        }
        i = i + 1;
    }
    i = 0;
    while (i < n) {
        int d0, d1;
        d0 = 0 - h_val[s370_obj_inst[s370_order[i]]];
        if (i + 1 < n) d1 = 0 - h_val[s370_obj_inst[s370_order[i + 1]]];
        else d1 = hl_temp_stack > d0 ? hl_temp_stack : d0;
        /* the object occupies [d0 - size, d0): its size is the gap
         * below it down to the next shallower object */
        if (i == 0) s370_obj_size[s370_order[i]] = d0 - 8 > 0 ? d0 - 8 : 4;
        else s370_obj_size[s370_order[i]] = d0 - (0 - h_val[s370_obj_inst[s370_order[i - 1]]]);
        (void)d1;
        if (s370_obj_size[s370_order[i]] < ty_size(h_ty[s370_obj_inst[s370_order[i]]]))
            s370_obj_size[s370_order[i]] = ty_size(h_ty[s370_obj_inst[s370_order[i]]]);
        i = i + 1;
    }
    /* now order by size, small first */
    i = 0;
    while (i < n) { s370_order[i] = i; i = i + 1; }
    qsort(s370_order, n, sizeof(int), s370_cmp_size);

    small_total = 0;
    big_total = 0;
    i = 0;
    while (i < n) {
        if (s370_obj_size[i] <= 256) small_total = small_total + ((s370_obj_size[i] + 7) & ~7);
        else big_total = big_total + ((s370_obj_size[i] + 7) & ~7);
        i = i + 1;
    }
    /* How many data bases: everything small plus room for spills and
     * the constant pool within reach. */
    if (S370_HDR_SIZE + small_total + 1024 <= 4096) s370_nbases = 1;
    else if (S370_HDR_SIZE + small_total + 1024 <= 8192) s370_nbases = 2;
    else s370_nbases = 3;
    s370_near_limit = 4096 * s370_nbases;

    off = S370_HDR_SIZE;
    i = 0;
    while (i < n) {
        k = s370_order[i];
        s370_obj_lbl[k] = cg_label();
        s370_alab[s370_obj_inst[k]] = s370_obj_lbl[k];
        if (off + s370_obj_size[k] <= s370_near_limit - 1024) {
            s370_obj_off[k] = off;
            s370_aoff[s370_obj_inst[k]] = off;
            off = off + ((s370_obj_size[k] + 7) & ~7);
        } else {
            s370_obj_off[k] = -1;
        }
        i = i + 1;
    }
    s370_spill_base = off;
}

/* Spilled operand's slot label text: Ssssss+8k is written as the area
 * label plus offset, since slots have no label of their own. */
static char s370_slotbuf[24];
static char *s370_slot(int inst) {
    int k;
    char *save;
    k = (0 - ra_spill_off[inst]) / 8 - 1;
    save = fmt_p;
    fmt_p = s370_slotbuf;
    f_s(s370_lab('S', s370_area_lbl));
    f_c('+');
    f_n(s370_spill_base + 8 * k);
    fmt_p = save;
    return s370_slotbuf;
}

static char s370_hdrbuf[24];
static char *s370_hdr(int off) {
    char *save;
    save = fmt_p;
    fmt_p = s370_hdrbuf;
    f_s(s370_lab('S', s370_area_lbl));
    f_c('+');
    f_n(off);
    fmt_p = save;
    return s370_hdrbuf;
}

/* ---------------------------------------------------------------- */
/* Pinning: far objects and symbols used inside loops get a register */
/* for the whole function rather than an adcon load at every use.    */
/* ---------------------------------------------------------------- */

static int s370_is_far_addr(int a) {
    int k;
    if (a < 0) return 0;
    k = h_kind[a];
    if (k == HI_GADDR || k == HI_FADDR || k == HI_SADDR) return 1;
    if (k == HI_ALLOCA && s370_aoff[a] < 0) return 1;
    if (k == HI_FCONST) return 1;       /* H holds a loop's constant in an FPR */
    return 0;
}

static void s370_mark_loop_consts(void) {
    int i;
    int j;
    int k;
    int b;
    int a;
    i = 0;
    while (i < h_ninst) { h_no_remat[i] = licm_cpin[i]; i = i + 1; }
    i = 0;
    while (i < h_ninst) {
        k = h_kind[i];
        if (k == HI_NOP) { i = i + 1; continue; }
        b = h_blk[i];
        if (k == HI_PHI) {
            if (h_pbase[i] >= 0) {
                j = 0;
                while (j < h_pcnt[i]) {
                    a = h_pval[h_pbase[i] + j];
                    b = h_pblk[h_pbase[i] + j];
                    if (b >= 0 && b < bb_nblk && licm_in_any_loop[b] && s370_is_far_addr(a)) h_no_remat[a] = 1;
                    j = j + 1;
                }
            }
        } else if (b >= 0 && b < bb_nblk && licm_in_any_loop[b]) {
            if (s370_is_far_addr(h_src1[i])) h_no_remat[h_src1[i]] = 1;
            if (ho_src2_is_ref(k) && s370_is_far_addr(h_src2[i])) h_no_remat[h_src2[i]] = 1;
        }
        i = i + 1;
    }
}

/* ---------------------------------------------------------------- */
/* Operands                                                          */
/* ---------------------------------------------------------------- */

static int s370_cur_pos;      /* ra_pos of the instruction being emitted */
static int s370_r1_intact;    /* R1 still holds the parameter list (entry block, nothing emitted yet) */

/* A general register free at the current position for a spilled
 * result: R14 unless it is in use, then R15. */
static int s370_scratch_gpr(int avoid) { return avoid == 14 ? 15 : 14; }

/* Is floating register r (0,2,4,6) free at position p?  Judged by the
 * intervals, which are a superset of liveness. */
static int s370_fpr_free_at(int r, int p) {
    int i;
    i = 0;
    while (i < h_ninst) {
        if (ra_reg[i] == r && ra_is_fpv(i) && h_kind[i] != HI_NOP &&
            ra_pos[i] >= 0 && ra_pos[i] <= p && ra_iend[i] >= p) return 0;
        i = i + 1;
    }
    return 1;
}

static int s370_fpr_saved;    /* an FPR borrowed and parked in FTMP, or -1 */
static char *s370_r(int r);

/* Floating register to compute a spilled result in: a free one, else
 * FPR6 parked in the scratch doubleword for the duration. */
static int s370_borrow_fpr(void) {
    int r;
    int s1;
    int s2;
    r = 0;
    while (r <= 6) {
        if (s370_fpr_free_at(r, s370_cur_pos)) return r;
        r = r + 2;
    }
    /* None free: park one.  Not one the instruction reads -- its
     * operands are taken from the registers after the parking, so a
     * divisor parked in FPR6 was read as the dividend just loaded
     * there (FCVS FM828, (BVC + 1 / BVC) / (2.0, 0.0) with four
     * complex values live). */
    s1 = s370_emitting >= 0 ? h_src1[s370_emitting] : -1;
    s2 = s370_emitting >= 0 ? h_src2[s370_emitting] : -1;
    r = 6;
    while (r > 0 && ((s1 >= 0 && ra_is_fpv(s1) && ra_reg[s1] == r) ||
                     (s2 >= 0 && ra_is_fpv(s2) && ra_reg[s2] == r))) r = r - 2;
    f_reset(); f_s(s370_r(r)); f_c(','); f_s(s370_hdr(S370_HDR_FTMP));
    asm_ins("STD", s370_line, 4);
    s370_fpr_saved = r;
    return r;
}

static void s370_return_fpr(void) {
    if (s370_fpr_saved >= 0) {
        f_reset(); f_s(s370_r(s370_fpr_saved)); f_c(','); f_s(s370_hdr(S370_HDR_FTMP));
        asm_ins("LD", s370_line, 4);
        s370_fpr_saved = -1;
    }
}

/* Register-form operand text for a GPR number. */
static char *s370_r(int r) {
    static char b[4];
    b[0] = (char)('0' + r / 10);
    b[1] = (char)('0' + r % 10);
    b[2] = 0;
    if (r < 10) { b[0] = (char)('0' + r); b[1] = 0; }
    return b;
}

/* Materialize an integer value (or address) into register d. */
static void s370_load_into(int d, int v);
static char *s370_memop_text(int ld, int s);
static int s370_bxle_add[HIR_MAX_INST];   /* BRC -> the index-step ADD it performs, or -1 */
static int s370_bxle_brc[HIR_MAX_INST];   /* ADD -> its BRC, or -1 */
static int s370_bxle_ok(int brc);

/* Chain folding: a LOAD/STORE/ADDI address through ADDI chains to a
 * register base, when the total displacement is 0..4095.  Mirrors
 * ra_codegen_fold_base. */
static int s370_fold_chain(int addr, int *base, int *off) {
    int chain;
    int o;
    int lim;
    chain = addr;
    o = 0;
    lim = 0;
    while (chain >= 0 && lim < 64) {
        if (bg_kind(chain) == HI_COPY) { chain = h_src1[chain]; lim = lim + 1; continue; }
        if (bg_kind(chain) == HI_ADDI) { o = o + h_val[chain]; chain = h_src1[chain]; lim = lim + 1; continue; }
        break;
    }
    if (chain >= 0 && chain != addr && ra_is_disp(o)) { *base = chain; *off = o; return 1; }
    *base = addr;
    *off = 0;
    return 0;
}

/* The general register holding value v, loading a spilled or remat
 * value into scratch s when needed. */
static int s370_gpr(int v, int s) {
    if (v < 0) cg_die("missing operand", -1);
    if (ra_reg[v] >= 0 && !ra_is_fpv(v)) return ra_reg[v];
    /* a scratch already holding this spilled value serves as well */
    if (ra_spill_off[v] != 0 && !(bg_fold[v] && bg_mem_lnt[v] >= 0)) {
        if (s370_scache[s] == v) return s;
        if (s370_scache[14] == v) return 14;
        if (s370_scache[15] == v) return 15;
        if (s370_scache[1] == v) return 1;
    }
    s370_load_into(s, v);
    return s;
}

/* Storage-operand text for an integer value that is not in a register:
 * a spill slot or a pool constant.  Returns 0 if v is in a register. */
static int s370_imem(int v, char *out) {
    int c;
    int root;
    if (v >= 0 && bg_fold[v] && bg_mem_lnt[v] >= 0) { strcpy(out, s370_memop_text(v, 15)); return 1; }
    if (ra_reg[v] >= 0) return 0;
    if (bg_const_imm_inst(v, &c, &root) && hi_inst_remat(root)) {
        strcpy(out, s370_pool_f(c));
        return 1;
    }
    if (hi_inst_remat(v)) return 0;    /* an address: needs a register */
    if (ra_spill_off[v] == 0) cg_die("value has neither register nor slot", v);
    strcpy(out, s370_slot(v));
    return 1;
}

/* Storage-operand text for a floating value not in a register. */
static int s370_fmem(int v, char *out) {
    if (v >= 0 && bg_fold[v] && bg_mem_lnt[v] >= 0) { strcpy(out, s370_memop_text(v, 15)); return 1; }
    if (ra_reg[v] >= 0) return 0;
    if (h_kind[v] == HI_FCONST) { strcpy(out, s370_pool_fconst(v)); return 1; }
    if (ra_spill_off[v] == 0) cg_die("floating value has neither register nor slot", v);
    strcpy(out, s370_slot(v));
    return 1;
}

/* Materialize integer value v into GPR d. */
static void s370_load_into(int d, int v) {
    int k;
    int c;
    int root;
    char mem[40];
    if (ra_reg[v] >= 0) {
        if (ra_reg[v] != d) { f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_r(ra_reg[v])); asm_ins("LR", s370_line, 2); }
        return;
    }
    k = bg_kind(v);
    if (bg_const_imm_inst(v, &c, &root)) {
        if (hi_inst_remat(root)) {
            if (c >= 0 && c <= 4095) { f_reset(); f_s(s370_r(d)); f_c(','); f_n(c); asm_ins("LA", s370_line, 4); }
            else if (c >= -32768 && c <= 32767) { f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_pool_h(c)); asm_ins("LH", s370_line, 4); }
            else { f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_pool_f(c)); asm_ins("L", s370_line, 4); }
            return;
        }
        if (ra_reg[root] >= 0) {
            /* a pinned constant in a register, plus the chain's offset */
            int off;
            off = c - h_val[root];
            if (ra_reg[root] != d) { f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_r(ra_reg[root])); asm_ins("LR", s370_line, 2); }
            if (off != 0) {
                if (off >= -32768 && off <= 32767) { f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_pool_h(off)); asm_ins("AH", s370_line, 4); }
                else { f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_pool_f(off)); asm_ins("A", s370_line, 4); }
            }
            return;
        }
    }
    if (k == HI_ALLOCA && hi_inst_remat(v)) {
        if (s370_aoff[v] >= 0) { f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_lab('T', s370_alab[v])); asm_ins("LA", s370_line, 4); }
        else { f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_pool_at(s370_alab[v], 0)); asm_ins("L", s370_line, 4); }
        return;
    }
    if (k == HI_ADDI && ra_spill_off[v] == 0) {
        /* an ADDI chain over a remat address that BURG folded into
         * a parent: materialize base + offset */
        int base;
        int off;
        if (bg_ssym[v] >= 0 && hi_inst_remat(bg_ssym[v])) {
            int sy;
            sy = bg_ssym[v];
            if (h_kind[sy] == HI_SADDR) { f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_pool_aq(h_val[sy], bg_soff[v])); asm_ins("L", s370_line, 4); }
            else { f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_pool_a(s370_gname(h_name[sy]), bg_soff[v])); asm_ins("L", s370_line, 4); }
            return;
        }
        if (bg_faddr_root(v) >= 0) {
            int rt;
            rt = bg_faddr_root(v);
            if (s370_aoff[rt] >= 0) {
                f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_lab('T', s370_alab[rt]));
                if (bg_foff[v] > 0) { f_c('+'); f_n(bg_foff[v]); }
                else if (bg_foff[v] < 0) { f_n(bg_foff[v]); }
                asm_ins("LA", s370_line, 4);
            } else {
                f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_pool_at(s370_alab[rt], bg_foff[v])); asm_ins("L", s370_line, 4);
            }
            return;
        }
        if (s370_fold_chain(v, &base, &off)) {
            int b;
            b = s370_gpr(base, d);
            f_reset(); f_s(s370_r(d)); f_c(','); f_n(off); f_s("(,"); f_s(s370_r(b)); f_c(')');
            asm_ins("LA", s370_line, 4);
            return;
        }
        cg_die("cannot materialize folded ADDI", v);
    }
    if (k == HI_GADDR) {
        f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_pool_a(s370_gname(h_name[v]), 0)); asm_ins("L", s370_line, 4);
        return;
    }
    if (k == HI_FADDR) {
        f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_pool_v(s370_extname(h_name[v]))); asm_ins("L", s370_line, 4);
        return;
    }
    if (k == HI_SADDR) {
        f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_pool_aq(h_val[v], 0)); asm_ins("L", s370_line, 4);
        return;
    }
    if (s370_imem(v, mem)) {
        if ((d == 1 || d == 14 || d == 15) && s370_scache[d] == v && ra_spill_off[v] != 0 && !(bg_fold[v] && bg_mem_lnt[v] >= 0)) return;
        f_reset(); f_s(s370_r(d)); f_c(','); f_s(mem); asm_ins("L", s370_line, 4);
        if ((d == 1 || d == 14 || d == 15) && ra_spill_off[v] != 0 && !(bg_fold[v] && bg_mem_lnt[v] >= 0)) s370_scache[d] = v;
        return;
    }
    cg_die("cannot materialize value", v);
}

/* Address of a near object as symbolic text: Tnnnnn+disp, with an
 * index register when the chain has one: Tnnnnn+disp(X). */
static char s370_abuf[40];
static char *s370_faddr_text(int addr) {
    int root;
    int index;
    int disp;
    char *save;
    int x;
    if (s370_addr_form(addr, BG_FADDR, &root, &index, &disp) != 1) cg_die("not a static address", addr);
    /* the index's register first: loading a spilled index emits an
     * instruction through the formatter, which must not be ours */
    x = index >= 0 ? s370_gpr(index, 1) : -1;
    save = fmt_p;
    fmt_p = s370_abuf;
    f_s(s370_lab('T', s370_alab[root]));
    if (disp > 0) { f_c('+'); f_n(disp); }
    else if (disp < 0) f_n(disp);
    if (x >= 0) { f_c('('); f_s(s370_r(x)); f_c(')'); }
    fmt_p = save;
    return s370_abuf;
}

/* Storage operand for the address `addr` of a LOAD or STORE given its
 * nonterminal: symbolic (near static), D(,base) through a register,
 * or through an address constant loaded into scratch s. */
static char s370_mbuf[48];
static char *s370_mem_operand(int addr, int lnt, int s) {
    int base;
    int off;
    int b;
    char *save;
    if (lnt == BG_FADDR) return s370_faddr_text(addr);
    save = fmt_p;
    if (lnt == BG_SADDR) {
        int sy;
        sy = bg_ssym[addr];
        if (sy < 0) cg_die("SADDR without symbol", addr);
        {
            char ln[80];
            fmt_p = ln;
            f_s(s370_r(s)); f_c(',');
            if (h_kind[sy] == HI_SADDR) f_s(s370_pool_aq(h_val[sy], bg_soff[addr]));
            else f_s(s370_pool_a(s370_gname(h_name[sy]), bg_soff[addr]));
            asm_ins("L", ln, 4);
        }
        fmt_p = s370_mbuf; f_s("0(,"); f_s(s370_r(s)); f_c(')'); fmt_p = save;
        return s370_mbuf;
    }
    {
        int root;
        int index;
        int x;
        s370_addr_form(addr, lnt, &root, &index, &off);
        b = s370_gpr(root, s);
        if (index >= 0) {
            /* the index's scratch: R15 when the base had R14 and the
             * caller holds nothing in R15; R1 otherwise (free outside
             * call sequences and the M/D pair) */
            x = s370_gpr(index, 1);
            fmt_p = s370_mbuf; f_n(off); f_c('('); f_s(s370_r(x)); f_c(','); f_s(s370_r(b)); f_c(')'); fmt_p = save;
            return s370_mbuf;
        }
    }
    fmt_p = s370_mbuf; f_n(off); f_s("(,"); f_s(s370_r(b)); f_c(')'); fmt_p = save;
    return s370_mbuf;
}

/* The same for an RS-format instruction (ICM, STCM), whose operand has
 * no index: an indexed address is formed into the scratch first. */
static char s370_mbuf3[48];
static char *s370_mem_operand_rs(int addr, int lnt, int s) {
    char *m;
    char *save;
    char *p;
    int simple;
    m = s370_mem_operand(addr, lnt, s);
    /* "D(,B)" becomes "D(B)"; "D(X,B)" needs the LA; a symbolic
     * operand with no parenthesis is fine as it is */
    p = m;
    simple = 1;
    while (*p && *p != '(') p = p + 1;
    if (*p == 0) return m;
    if (p[1] != ',') simple = 0;
    save = fmt_p;
    if (simple) {
        int i;
        fmt_p = s370_mbuf3;
        i = 0;
        while (m[i] != '(') { f_c(m[i]); i = i + 1; }
        f_c('(');
        i = i + 2;
        while (m[i]) { f_c(m[i]); i = i + 1; }
        fmt_p = save;
        return s370_mbuf3;
    }
    f_reset(); f_s(s370_r(s)); f_c(','); f_s(m); asm_ins("LA", s370_line, 4);
    fmt_p = s370_mbuf3; f_s("0("); f_s(s370_r(s)); f_c(')'); fmt_p = save;
    return s370_mbuf3;
}

/* The storage operand of a load folded into its user (bg_memop). */
static char s370_mbuf2[48];
static char *s370_memop_text(int ld, int s) {
    int lnt;
    char *m;
    char *save;
    lnt = bg_mem_lnt[ld];
    if (lnt < 0) lnt = BG_RADDR;
    m = s370_mem_operand(h_src1[ld], lnt, s);
    save = fmt_p;
    fmt_p = s370_mbuf2; f_s(m); fmt_p = save;
    return s370_mbuf2;
}

/* ---------------------------------------------------------------- */
/* Results                                                           */
/* ---------------------------------------------------------------- */

/* Destination GPR for an integer-valued instruction: its register,
 * or a scratch to be stored afterwards. */
static int s370_idst(int i) {
    if (ra_reg[i] >= 0) return ra_reg[i];
    return 14;
}

static void s370_ifinish(int i, int d) {
    if (ra_reg[i] >= 0) return;
    if (ra_spill_off[i] == 0) return;    /* dead value */
    f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_slot(i));
    asm_ins("ST", s370_line, 4);
}

static int s370_fdst(int i) {
    if (ra_reg[i] >= 0) return ra_reg[i];
    return s370_borrow_fpr();
}

static void s370_ffinish(int i, int d) {
    if (ra_reg[i] >= 0) return;
    if (ra_spill_off[i] != 0) {
        f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_slot(i));
        asm_ins(ty_is_double(h_ty[i]) ? "STD" : "STE", s370_line, 4);
    }
    s370_return_fpr();
}

/* ---------------------------------------------------------------- */
/* Code emission                                                     */
/* ---------------------------------------------------------------- */

static int hcg_blk_lbl[HIR_MAX_BLOCK];
static int hcg_emit_ord[HIR_MAX_BLOCK];
static int hcg_placed[HIR_MAX_BLOCK];
static int hcg_epilog;
static int hcg_cur_blk;

/* Branch to a block label.  Direct for now; the far form (address
 * constant and BCR) comes with the size estimate. */
/* The branch target operand: the label, or 0(,15) with R15 loaded
 * from the pool when the label is beyond the code base's 4K. */
static char *s370_target_fmt(int lbl, int rs) {
    if (s370_lbl_far(lbl)) {
        f_reset(); f_s("15,"); f_s(s370_pool_ab(lbl)); asm_ins("L", s370_line, 4);
        return rs ? "0(15)" : "0(,15)";      /* RS (BXLE) has no index field */
    }
    return s370_lab('L', lbl);
}
static char *s370_target(int lbl) { return s370_target_fmt(lbl, 0); }

static void s370_branch(int mask, int lbl) {
    char *t;
    t = s370_target(lbl);
    if (mask == 15) { f_reset(); f_s(t); asm_ins("B", s370_line, 4); return; }
    f_reset(); f_n(mask); f_c(','); f_s(t);
    asm_ins("BC", s370_line, 4);
}

/* Phi copies for the edge from -> to: a parallel copy.  Sources may be
 * registers, slots or constants; destinations registers or slots.
 * Memory destinations first (they cannot be in a register cycle),
 * then register copies with cycle breaking through R0 / the PHIT
 * doubleword. */
#define S370_MAX_PHI 256
static int ph_phi[S370_MAX_PHI];
static int ph_src[S370_MAX_PHI];
static int ph_done[S370_MAX_PHI];
static int ph_stage[S370_MAX_PHI];   /* staging doubleword index for a done==2 copy */
static int ph_nstage;

static void s370_copy_to_reg(int dreg, int dfp, int v, int is_double) {
    char mem[40];
    if (dfp) {
        if (ra_reg[v] >= 0) {
            if (ra_reg[v] != dreg) { f_reset(); f_s(s370_r(dreg)); f_c(','); f_s(s370_r(ra_reg[v])); asm_ins(is_double ? "LDR" : "LER", s370_line, 2); }
        } else if (s370_fmem(v, mem)) {
            f_reset(); f_s(s370_r(dreg)); f_c(','); f_s(mem); asm_ins(is_double ? "LD" : "LE", s370_line, 4);
        } else cg_die("phi source", v);
    } else {
        s370_load_into(dreg, v);
    }
}

static void s370_copy_to_slot(int phi, int v) {
    char mem[40];
    int dbl;
    dbl = ty_is_double(h_ty[phi]);
    if (ra_is_fpv(phi)) {
        if (ra_reg[v] >= 0) {
            f_reset(); f_s(s370_r(ra_reg[v])); f_c(','); f_s(s370_slot(phi)); asm_ins(dbl ? "STD" : "STE", s370_line, 4);
        } else if (s370_fmem(v, mem)) {
            f_reset(); f_s(s370_slot(phi)); f_c('('); f_n(dbl ? 8 : 4); f_s("),"); f_s(mem); asm_ins("MVC", s370_line, 6);
        } else cg_die("phi source", v);
    } else {
        s370_load_into(14, v);
        f_reset(); f_s("14,"); f_s(s370_slot(phi)); asm_ins("ST", s370_line, 4);
    }
}

static void s370_phi_copies(int from_blk, int to_blk) {
    int n;
    int i;
    int j;
    int phi;
    int progress;
    int remaining;
    int v;

    n = 0;
    i = ssa_phi_head[to_blk];
    while (i >= 0) {
        if (h_kind[i] == HI_PHI) {
            if (n >= S370_MAX_PHI) cg_die("too many phis on one edge", i);
            ph_phi[n] = i;
            ph_src[n] = ssa_phi_find_arg(i, from_blk);
            ph_done[n] = 0;
            /* A phi with no argument for this edge carries an undefined
             * value along it (a variable not set on this path): nothing
             * to copy. */
            if (ph_src[n] >= 0) n = n + 1;
        }
        i = ssa_phi_next[i];
    }
    if (n == 0) return;
    ph_nstage = 0;

    /* 1. Destinations in memory (or dead): no register is written. */
    i = 0;
    while (i < n) {
        phi = ph_phi[i];
        if (ra_reg[phi] < 0) {
            if (ra_spill_off[phi] != 0) {
                /* A slot read by another copy on this edge must be
                 * read first: handled by writing through PHIT. */
                int conflict;
                conflict = 0;
                j = 0;
                while (j < n) { if (j != i && ph_src[j] == phi && ra_reg[phi] < 0) conflict = 1; j = j + 1; }
                if (!conflict) s370_copy_to_slot(phi, ph_src[i]);
                else {
                    /* stage the new value in a PHIT doubleword of its
                     * own, copy it in at the end */
                    int st;
                    if (ph_nstage >= S370_HDR_NPHIT - 1) cg_die("too many staged phi copies on one edge", phi);
                    st = S370_HDR_PHIT + 8 * ph_nstage;
                    ph_stage[i] = st;
                    ph_nstage = ph_nstage + 1;
                    ph_done[i] = 2;
                    if (ra_is_fpv(phi)) {
                        char mem[40];
                        if (ra_reg[ph_src[i]] >= 0) { f_reset(); f_s(s370_r(ra_reg[ph_src[i]])); f_c(','); f_s(s370_hdr(st)); asm_ins("STD", s370_line, 4); }
                        else if (s370_fmem(ph_src[i], mem)) { f_reset(); f_s(s370_hdr(st)); f_s("(8),"); f_s(mem); asm_ins("MVC", s370_line, 6); }
                    } else {
                        s370_load_into(14, ph_src[i]);
                        f_reset(); f_s("14,"); f_s(s370_hdr(st)); asm_ins("ST", s370_line, 4);
                    }
                    i = i + 1;
                    continue;
                }
            }
            ph_done[i] = 1;
        }
        i = i + 1;
    }
    /* 2. Register destinations: a copy may run when no other pending
     * copy reads its destination register. */
    remaining = 1;
    while (remaining) {
        remaining = 0;
        progress = 0;
        i = 0;
        while (i < n) {
            if (ph_done[i]) { i = i + 1; continue; }
            phi = ph_phi[i];
            {
                int blocked;
                int dreg;
                int dfp;
                blocked = 0;
                dreg = ra_reg[phi];
                dfp = ra_is_fpv(phi);
                j = 0;
                while (j < n) {
                    if (j != i && !ph_done[j]) {
                        v = ph_src[j];
                        if (v >= 0 && ra_reg[v] == dreg && ra_is_fpv(v) == dfp) blocked = 1;
                    }
                    j = j + 1;
                }
                if (!blocked) {
                    s370_copy_to_reg(dreg, dfp, ph_src[i], ty_is_double(h_ty[phi]));
                    ph_done[i] = 1;
                    progress = 1;
                } else remaining = 1;
            }
            i = i + 1;
        }
        if (remaining && !progress) {
            /* a cycle: park one destination's current value in PHIT /
             * R0 and let the copies that read it proceed from there */
            int parked;
            int preg;
            int pfp;
            parked = -1;
            i = 0;
            while (i < n && parked < 0) { if (!ph_done[i]) parked = i; i = i + 1; }
            phi = ph_phi[parked];
            preg = ra_reg[phi];
            pfp = ra_is_fpv(phi);
            if (pfp) { f_reset(); f_s(s370_r(preg)); f_c(','); f_s(s370_hdr(S370_HDR_PHIT + 8 * (S370_HDR_NPHIT - 1))); asm_ins("STD", s370_line, 4); }
            else { f_reset(); f_s("0,"); f_s(s370_r(preg)); asm_ins("LR", s370_line, 2); }
            /* copies reading preg now read the parked copy */
            j = 0;
            while (j < n) {
                if (!ph_done[j] && j != parked && ph_src[j] >= 0 && ra_reg[ph_src[j]] == preg &&
                    ra_is_fpv(ph_src[j]) == pfp) {
                    int dreg2;
                    dreg2 = ra_reg[ph_phi[j]];
                    if (pfp) { f_reset(); f_s(s370_r(dreg2)); f_c(','); f_s(s370_hdr(S370_HDR_PHIT + 8 * (S370_HDR_NPHIT - 1))); asm_ins("LD", s370_line, 4); }
                    else { f_reset(); f_s(s370_r(dreg2)); f_s(",0"); asm_ins("LR", s370_line, 2); }
                    ph_done[j] = 1;
                }
                j = j + 1;
            }
        }
    }
    /* 3. staged slot writes */
    i = 0;
    while (i < n) {
        if (ph_done[i] == 2) {
            phi = ph_phi[i];
            if (ra_is_fpv(phi)) { f_reset(); f_s(s370_slot(phi)); f_s("(8),"); f_s(s370_hdr(ph_stage[i])); asm_ins("MVC", s370_line, 6); }
            else { f_reset(); f_s(s370_slot(phi)); f_s("(4),"); f_s(s370_hdr(ph_stage[i])); asm_ins("MVC", s370_line, 6); }
        }
        i = i + 1;
    }
}

/* Does the edge from -> to need any copy at all?  A phi whose source
 * already sits in the phi's register needs none. */
static int s370_edge_needs_copies(int from_blk, int to_blk) {
    int i;
    int v;
    i = ssa_phi_head[to_blk];
    while (i >= 0) {
        if (h_kind[i] == HI_PHI) {
            v = ssa_phi_find_arg(i, from_blk);
            if (v < 0) { i = ssa_phi_next[i]; continue; }
            if (ra_reg[i] < 0 && ra_spill_off[i] == 0) { i = ssa_phi_next[i]; continue; }
            if (ra_reg[i] < 0 || ra_reg[v] != ra_reg[i] || ra_is_fpv(v) != ra_is_fpv(i)) return 1;
        }
        i = ssa_phi_next[i];
    }
    return 0;
}

static int s370_has_phis(int b) {
    int i;
    i = ssa_phi_head[b];
    while (i >= 0) { if (h_kind[i] == HI_PHI) return 1; i = ssa_phi_next[i]; }
    return 0;
}

/* Condition-code mask for an integer comparison kind, as "branch if
 * the comparison is TRUE" after C a,b.  Unsigned kinds use CL. */
static int s370_cc_mask(int k) {
    if (k == HI_SEQ || k == HI_FEQ) return 8;
    if (k == HI_SNE) return 7;
    if (k == HI_SLT || k == HI_SLTU || k == HI_FLT) return 4;
    if (k == HI_SGT || k == HI_SGTU) return 2;
    if (k == HI_SLE || k == HI_SLEU || k == HI_FLE) return 12;
    if (k == HI_SGE || k == HI_SGEU) return 10;
    return 0;
}

/* Emit the compare for comparison kind k on a, b; leaves the CC. */
static void s370_compare(int k, int a, int b) {
    char mem[40];
    int ra;
    if (a >= 0 && bg_fold[a] && bg_mem_lnt[a] >= 0) { int t; t = a; a = b; b = t; }   /* commutative kinds only reach here folded left */
    if (k == HI_FEQ || k == HI_FLT || k == HI_FLE) {
        int dbl;
        int fa;
        dbl = ty_is_double(h_ty[a]);
        if (ra_reg[a] >= 0) fa = ra_reg[a];
        else {
            fa = s370_borrow_fpr();
            if (s370_fmem(a, mem)) { f_reset(); f_s(s370_r(fa)); f_c(','); f_s(mem); asm_ins(dbl ? "LD" : "LE", s370_line, 4); }
        }
        if (ra_reg[b] >= 0) { f_reset(); f_s(s370_r(fa)); f_c(','); f_s(s370_r(ra_reg[b])); asm_ins(dbl ? "CDR" : "CER", s370_line, 2); }
        else if (s370_fmem(b, mem)) { f_reset(); f_s(s370_r(fa)); f_c(','); f_s(mem); asm_ins(dbl ? "CD" : "CE", s370_line, 4); }
        if (ra_reg[a] < 0) s370_return_fpr();   /* LD does not disturb the CC */
        return;
    }
    ra = s370_gpr(a, 14);
    if (ra_reg[b] >= 0) {
        f_reset(); f_s(s370_r(ra)); f_c(','); f_s(s370_r(ra_reg[b]));
        asm_ins((k == HI_SLTU || k == HI_SGTU || k == HI_SLEU || k == HI_SGEU) ? "CLR" : "CR", s370_line, 2);
    } else if (s370_imem(b, mem)) {
        f_reset(); f_s(s370_r(ra)); f_c(','); f_s(mem);
        asm_ins((k == HI_SLTU || k == HI_SGTU || k == HI_SLEU || k == HI_SGEU) ? "CL" : "C", s370_line, 4);
    } else {
        int rb;
        rb = s370_gpr(b, 15);
        f_reset(); f_s(s370_r(ra)); f_c(','); f_s(s370_r(rb));
        asm_ins((k == HI_SLTU || k == HI_SGTU || k == HI_SLEU || k == HI_SGEU) ? "CLR" : "CR", s370_line, 2);
    }
}

/* Two-address integer op: d = s1 OP s2.  d never equals s2's register
 * unless s1 == s2 (the allocator keeps src2's edge). */
static void s370_binop(int i, char *rr, char *rx, int d) {
    int s1;
    int s2;
    char mem[40];
    s1 = h_src1[i];
    s2 = h_src2[i];
    if (bg_memop[i] == 1) { s1 = h_src2[i]; s2 = h_src1[i]; }   /* commutative: the load is the storage operand */
    else if (ra_commutative(h_kind[i]) && s2 >= 0 && ra_reg[s2] == d && ra_reg[s1] != d) { int t; t = s1; s1 = s2; s2 = t; }
    s370_load_into(d, s1);
    if (ra_reg[s2] >= 0) {
        f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_r(ra_reg[s2])); asm_ins(rr, s370_line, 2);
    } else if (s370_imem(s2, mem)) {
        f_reset(); f_s(s370_r(d)); f_c(','); f_s(mem); asm_ins(rx, s370_line, 4);
    } else {
        int r2;
        r2 = s370_gpr(s2, d == 15 ? 14 : 15);
        f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_r(r2)); asm_ins(rr, s370_line, 2);
    }
}

static void s370_shift(int i, char *op, int d) {
    int s1;
    int s2;
    int c;
    int root;
    s1 = h_src1[i];
    s2 = h_src2[i];
    s370_load_into(d, s1);
    if (bg_const_imm_inst(s2, &c, &root) && hi_inst_remat(root)) {
        f_reset(); f_s(s370_r(d)); f_c(','); f_n(c & 63); asm_ins(op, s370_line, 4);
    } else {
        int r2;
        r2 = s370_gpr(s2, d == 15 ? 14 : 15);
        f_reset(); f_s(s370_r(d)); f_s(",0("); f_s(s370_r(r2)); f_c(')'); asm_ins(op, s370_line, 4);
    }
}

/* Multiply and divide through the R0/R1 pair. */
static void s370_muldiv(int i, int d) {
    int k;
    int s1;
    int s2;
    char mem[40];
    int have_mem;
    int r2;
    k = h_kind[i];
    s1 = h_src1[i];
    s2 = h_src2[i];
    if (bg_memop[i] == 1) { s1 = h_src2[i]; s2 = h_src1[i]; }
    /* The second operand first: forming a storage operand may reload
     * an index into R1, which the pair is about to use. */
    have_mem = 0;
    r2 = -1;
    if (ra_reg[s2] >= 0) r2 = ra_reg[s2];
    else if (s370_imem(s2, mem)) have_mem = 1;
    else r2 = s370_gpr(s2, 15);
    /* M multiplies the odd register of the pair; D divides the pair,
     * so the dividend goes in R0 and SRDA spreads it over R0:R1 */
    if (k == HI_MUL) s370_load_into(1, s1);
    else { s370_load_into(0, s1); asm_ins("SRDA", "0,32", 4); }
    if (have_mem) {
        f_reset(); f_s("0,"); f_s(mem); asm_ins(k == HI_MUL ? "M" : "D", s370_line, 4);
    } else {
        f_reset(); f_s("0,"); f_s(s370_r(r2)); asm_ins(k == HI_MUL ? "MR" : "DR", s370_line, 2);
    }
    f_reset(); f_s(s370_r(d)); f_s(k == HI_REM ? ",0" : ",1"); asm_ins("LR", s370_line, 2);
}

/* Floating two-address op. */
static void s370_fbinop(int i, char *rr, char *rx, int d) {
    int s1;
    int s2;
    int dbl;
    char mem[40];
    s1 = h_src1[i];
    s2 = h_src2[i];
    if (bg_memop[i] == 1) { s1 = h_src2[i]; s2 = h_src1[i]; }
    else if (ra_commutative(h_kind[i]) && s2 >= 0 && ra_reg[s2] == d && ra_reg[s1] != d) { int t; t = s1; s1 = s2; s2 = t; }
    dbl = ty_is_double(h_ty[i]);
    /* A commutative op on a register that must survive (so the result
     * would start with an LDR) and a storage operand: load the storage
     * operand into the result and operate by the register, as H does
     * (LD / MDR rather than LDR / MD).  The same two instructions, but
     * measured 5% faster on daxpy under Hercules, where MD from storage
     * costs more than LD and MDR together. */
    if (ra_commutative(h_kind[i]) && ra_reg[s1] >= 0 && ra_reg[s1] != d &&
        ra_reg[s2] < 0 && s370_fmem(s2, mem)) {
        f_reset(); f_s(s370_r(d)); f_c(','); f_s(mem); asm_ins(dbl ? "LD" : "LE", s370_line, 4);
        f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_r(ra_reg[s1])); asm_ins(rr, s370_line, 2);
        return;
    }
    s370_copy_to_reg(d, 1, s1, dbl);
    if (ra_reg[s2] >= 0) {
        f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_r(ra_reg[s2])); asm_ins(rr, s370_line, 2);
    } else if (s370_fmem(s2, mem)) {
        f_reset(); f_s(s370_r(d)); f_c(','); f_s(mem); asm_ins(rx, s370_line, 4);
    } else cg_die("floating operand", s2);
}

/* 0/1 result of a comparison kind k on (a, b) into register d. */
static void s370_setcc(int k, int a, int b, int d) {
    int l;
    s370_compare(k, a, b);
    f_reset(); f_s(s370_r(d)); f_s(",1"); asm_ins("LA", s370_line, 4);
    l = cg_label();
    s370_branch(s370_cc_mask(k), l);
    f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_r(d)); asm_ins("SR", s370_line, 2);
    asm_stmt(s370_lab('L', l), "DS", "0H");
}

/* ---- calls ---- */

/* Runtime routines whose arguments are values rather than addresses,
 * by name and position (bit k = argument k is a value). */
static int s370_byval_mask(char *name) {
    if (strcmp(name, "f77_dpow_i") == 0) return 2;
    if (strcmp(name, "f77_rpow_i") == 0) return 2;
    if (strcmp(name, "f77_ipow") == 0) return 3;
    return 0;
}

/* Call temporaries (a by-value argument stored so its address can be
 * passed; a WRITE item): doublewords Wnnnnn in the static area.  A
 * temporary is read by the callee during the call and not after, so
 * every call starts again at the first one; the unit's area holds as
 * many as its biggest call needed. */
#define S370_MAX_TMP 64
static int s370_ntmp;        /* temporaries the unit's area must hold */
static int s370_tmp_next;    /* next free for the call being emitted */
static int s370_tmp_labels[S370_MAX_TMP];
static void s370_tmp_reset(void) { s370_tmp_next = 0; }
static int s370_new_tmp(void) {
    int k;
    if (s370_tmp_next >= S370_MAX_TMP) cg_die("too many temporaries in one call", -1);
    k = s370_tmp_next;
    s370_tmp_next = s370_tmp_next + 1;
    if (k >= s370_ntmp) { s370_tmp_labels[k] = cg_label(); s370_ntmp = k + 1; }
    return s370_tmp_labels[k];
}

/* Store value v (any type) into the doubleword temporary tl. */
static void s370_store_tmp(int tl, int v) {
    char mem[40];
    if (ra_is_fpv(v)) {
        int dbl;
        dbl = ty_is_double(h_ty[v]);
        if (ra_reg[v] >= 0) { f_reset(); f_s(s370_r(ra_reg[v])); f_c(','); f_s(s370_lab('W', tl)); asm_ins(dbl ? "STD" : "STE", s370_line, 4); }
        else if (s370_fmem(v, mem)) { f_reset(); f_s(s370_lab('W', tl)); f_c('('); f_n(dbl ? 8 : 4); f_s("),"); f_s(mem); asm_ins("MVC", s370_line, 6); }
        else cg_die("temp source", v);
    } else {
        s370_load_into(14, v);
        f_reset(); f_s("14,"); f_s(s370_lab('W', tl)); asm_ins("ST", s370_line, 4);
    }
}

/* Parameter lists: one list per unit, Pnnnnn DS nF, as long as the
 * unit's longest call needs; filled before each call.  Arguments are
 * values computed before the call, so no nested call can disturb it.
 * The same table also records jump tables (n < 0). */
#define S370_MAX_PL 256
static int s370_pl_lbl[S370_MAX_PL];
static int s370_pl_n[S370_MAX_PL];
static int s370_npl;
static int s370_plist_lbl;   /* the unit's parameter list */
static int s370_plist_n;     /* its length in words */

static void s370_call_result(int i) {
    if (bg_uses[i] == 0) return;
    if (ra_is_fpv(i)) {
        int dbl;
        dbl = ty_is_double(h_ty[i]);
        if (ra_reg[i] >= 0) {
            if (ra_reg[i] != 0) { f_reset(); f_s(s370_r(ra_reg[i])); f_s(",0"); asm_ins(dbl ? "LDR" : "LER", s370_line, 2); }
        } else if (ra_spill_off[i] != 0) {
            f_reset(); f_s("0,"); f_s(s370_slot(i)); asm_ins(dbl ? "STD" : "STE", s370_line, 4);
        }
    } else {
        if (ra_reg[i] >= 0) { f_reset(); f_s(s370_r(ra_reg[i])); f_s(",0"); asm_ins("LR", s370_line, 2); }
        else if (ra_spill_off[i] != 0) { f_reset(); f_s("0,"); f_s(s370_slot(i)); asm_ins("ST", s370_line, 4); }
    }
}

/* The string table index of a format passed as an SADDR, or -1. */
static int s370_saddr_string(int v) {
    int lim;
    lim = 0;
    while (v >= 0 && lim < 16) {
        if (h_kind[v] == HI_SADDR) return h_val[v];
        if (h_kind[v] == HI_COPY) { v = h_src1[v]; lim = lim + 1; continue; }
        return -1;
    }
    return -1;
}

static void s370_ibcom_load(void) {
    f_reset(); f_s("15,"); f_s(s370_pool_v("IBCOM#"));
    asm_ins("L", s370_line, 4);
}

/* Align the location counter to a fullword before inline arguments:
 * CNOP pads with no-ops, so the count of bytes emitted so far need
 * not be trusted. */
static void s370_align4(void) {
    asm_stmt("", "CNOP", "0,4");
    s370_pc = (s370_pc + 3) & ~3;
}

/* WRITE through IBCOM#: the front end's f77_wr_begin(unit, fmt),
 * f77_wr_<type>(value) and f77_wr_end() become H's sequence.  The
 * item descriptor is H's: a length byte, a type byte, and an S-type
 * constant naming the item in storage. */
static int s370_io_runtime(int i) {
    char *nm;
    int base;
    nm = h_name[i];
    base = h_cbase[i];
    if (strcmp(nm, "f77_wr_begin") == 0) {
        int unit;
        int fmt;
        int sidx;
        int c;
        int root;
        unit = h_carg[base];
        fmt = h_carg[base + 1];
        sidx = s370_saddr_string(fmt);
        s370_tmp_reset();
        /* The unit number and the format address go inline after the
         * BAL; a value not known at compile time is stored into its
         * word first (the code is writable).  AL1(1) marks the format
         * as text, as an array format is; a compiled one carries 0. */
        {
            int lu;
            int lf;
            lu = cg_label();
            lf = cg_label();
            if (!bg_const_imm_inst(unit, &c, &root)) {
                s370_load_into(14, unit);
                f_reset(); f_s("14,"); f_s(s370_lab('L', lu)); asm_ins("ST", s370_line, 4);
            }
            if (sidx < 0) {
                s370_load_into(14, fmt);
                f_reset(); f_s("14,"); f_s(s370_lab('L', lf)); asm_ins("ST", s370_line, 4);
                f_reset(); f_s(s370_lab('L', lf)); f_s(",X'01'"); asm_ins("MVI", s370_line, 4);
            }
            s370_ibcom_load();
            s370_align4();
            asm_ins("BAL", "14,4(,15)", 4);
            f_reset(); f_s("F'"); f_n(bg_const_imm_inst(unit, &c, &root) ? c : 0); f_c('\'');
            asm_stmt(s370_lab('L', lu), "DC", s370_line); s370_pc = s370_pc + 4;
            if (sidx >= 0) { f_reset(); f_s("AL1(1),AL3("); f_s(s370_lab('Q', s370_str_lbl[sidx])); f_c(')'); }
            else { f_reset(); f_s("A(0)"); }
            asm_stmt(s370_lab('L', lf), "DC", s370_line); s370_pc = s370_pc + 4;
        }
        return 1;
    }
    if (strcmp(nm, "f77_wr_end") == 0) {
        s370_ibcom_load();
        asm_ins("BAL", "14,16(,15)", 4);
        return 1;
    }
    if (strcmp(nm, "f77_wr_i") == 0 || strcmp(nm, "f77_wr_d") == 0 ||
        strcmp(nm, "f77_wr_r") == 0 || strcmp(nm, "f77_wr_l") == 0) {
        int v;
        int tl;
        int len;
        int ty;
        v = h_carg[base];
        s370_tmp_reset();
        tl = s370_new_tmp();
        s370_store_tmp(tl, v);
        if (nm[7] == 'd') { len = 8; ty = 0x60; }
        else if (nm[7] == 'r') { len = 4; ty = 0x70; }
        else if (nm[7] == 'l') { len = 4; ty = 0x30; }
        else { len = 4; ty = 0x50; }
        s370_ibcom_load();
        s370_align4();
        asm_ins("BAL", "14,8(,15)", 4);
        f_reset(); f_s("AL1("); f_n(len); f_s("),AL1("); f_n(ty); f_s("),S("); f_s(s370_lab('W', tl)); f_c(')');
        asm_stmt("", "DC", s370_line); s370_pc = s370_pc + 4;
        return 1;
    }
    if (strcmp(nm, "exit") == 0) {
        int v;
        int c;
        int root;
        int n;
        char digits[8];
        v = h_carg[base];
        c = 0;
        if (!bg_const_imm_inst(v, &c, &root)) c = 0;
        s370_ibcom_load();
        asm_ins("BAL", "14,52(,15)", 4);
        /* H: a length byte then the STOP text, right-justified in 5 */
        n = 5;
        digits[n] = 0;
        if (c == 0) { digits[4] = '0'; n = 4; }
        else { while (c > 0 && n > 0) { n = n - 1; digits[n] = (char)('0' + c % 10); c = c / 10; } }
        while (n > 0) { n = n - 1; digits[n] = ' '; }
        f_reset(); f_s("AL1(5),CL5'"); f_s(digits); f_c('\'');
        asm_stmt("", "DC", s370_line); s370_pc = s370_pc + 6;
        return 1;
    }
    return 0;
}

/* A call into the runtime, by cc370's convention: the arguments as
 * values in a list R1 points to, an INTEGER or an address a word, a
 * DOUBLE PRECISION a doubleword, a REAL a word -- or a doubleword
 * widened (a short floating number followed by a zero word IS the
 * long one) for the libm functions, which take double.  Register
 * arguments go first, then the ones in storage through FPR0, which is
 * free by then: floating values do not survive a call here.  An
 * integer result comes back in R15. */
static void s370_ccall(int i) {
    int n;
    int base;
    int j;
    int pl;
    int off;
    int words;
    int libm;
    int pass;
    char mem[40];
    n = h_val[i];
    base = h_cbase[i];
    libm = s370_rt_libm(h_name[i]);
    words = 0;
    j = 0;
    while (j < n) {
        int v;
        v = h_carg[base + j];
        if (v >= 0 && ra_is_fpv(v)) words = words + ((ty_is_double(h_ty[v]) || libm) ? 2 : 1);
        else words = words + 1;
        j = j + 1;
    }
    pl = -1;
    if (words > 0) {
        if (s370_plist_lbl < 0) s370_plist_lbl = cg_label();
        pl = s370_plist_lbl;
        if (words > s370_plist_n) s370_plist_n = words;
    }
    pass = 0;
    while (pass < 2) {
        off = 0;
        j = 0;
        while (j < n) {
            int v;
            v = h_carg[base + j];
            if (v >= 0 && ra_is_fpv(v)) {
                int dbl;
                int wide;
                dbl = ty_is_double(h_ty[v]);
                wide = dbl || libm;
                if (pass == 0 && ra_reg[v] >= 0) {
                    f_reset(); f_s(s370_r(ra_reg[v])); f_c(','); f_s(s370_lab('P', pl)); f_c('+'); f_n(off);
                    asm_ins(dbl ? "STD" : "STE", s370_line, 4);
                } else if (pass == 1 && ra_reg[v] < 0) {
                    if (!s370_fmem(v, mem)) cg_die("floating argument", v);
                    f_reset(); f_s("0,"); f_s(mem); asm_ins(dbl ? "LD" : "LE", s370_line, 4);
                    f_reset(); f_s("0,"); f_s(s370_lab('P', pl)); f_c('+'); f_n(off);
                    asm_ins(dbl ? "STD" : "STE", s370_line, 4);
                }
                if (pass == 1 && !dbl && wide) {
                    f_reset(); f_s(s370_lab('P', pl)); f_c('+'); f_n(off + 4); f_s("(4),"); f_s(s370_lab('P', pl)); f_c('+'); f_n(off + 4);
                    asm_ins("XC", s370_line, 6);
                }
                off = off + (wide ? 8 : 4);
            } else {
                if (pass == 1) {
                    s370_load_into(0, v);
                    f_reset(); f_s("0,"); f_s(s370_lab('P', pl)); f_c('+'); f_n(off);
                    asm_ins("ST", s370_line, 4);
                }
                off = off + 4;
            }
            j = j + 1;
        }
        pass = pass + 1;
    }
    if (pl >= 0) { f_reset(); f_s("1,"); f_s(s370_lab('P', pl)); asm_ins("LA", s370_line, 4); }
    f_reset(); f_s("15,"); f_s(s370_pool_v(s370_extname(h_name[i])));
    asm_ins("L", s370_line, 4);
    asm_ins("BALR", "14,15", 2);
    if (bg_uses[i] == 0) return;
    if (ra_is_fpv(i)) { s370_call_result(i); return; }
    if (ra_reg[i] >= 0) { f_reset(); f_s(s370_r(ra_reg[i])); f_s(",15"); asm_ins("LR", s370_line, 2); }
    else if (ra_spill_off[i] != 0) { f_reset(); f_s("15,"); f_s(s370_slot(i)); asm_ins("ST", s370_line, 4); }
}

static void s370_call(int i) {
    int n;
    int base;
    int j;
    int pl;
    int bymask;
    char *ext;
    int callp;

    char extbuf[12];

    callp = (h_kind[i] == HI_CALLP);
    n = h_val[i];
    base = h_cbase[i];
    if (!callp && h_name[i] && s370_crt_on() && s370_rt_is_c(h_name[i])) { s370_ccall(i); return; }
    if (!callp && h_name[i] && !s370_crt_on() && s370_io_runtime(i)) { s370_call_result(i); return; }
    /* s370_extname's buffer is static, and an argument that is itself a
     * procedure's address (CALL FS333(FF330, 5)) names another one
     * through it while the list is built: keep this name in a buffer
     * of its own, or the call goes to the argument */
    ext = 0;
    if (!callp) { strcpy(extbuf, s370_extname(h_name[i])); ext = extbuf; }
    bymask = (callp || !h_name[i]) ? 0 : s370_byval_mask(h_name[i]);

    s370_tmp_reset();
    if (n > 0) {
        if (s370_plist_lbl < 0) s370_plist_lbl = cg_label();
        pl = s370_plist_lbl;
        if (n > s370_plist_n) s370_plist_n = n;
        j = 0;
        while (j < n) {
            int v;
            v = h_carg[base + j];
            if (ra_is_fpv(v) || (bymask & (1 << j))) {
                int tl;
                tl = s370_new_tmp();
                s370_store_tmp(tl, v);
                f_reset(); f_s("0,"); f_s(s370_lab('W', tl)); asm_ins("LA", s370_line, 4);
            } else {
                s370_load_into(0, v);
            }
            f_reset(); f_s("0,"); f_s(s370_lab('P', pl)); f_c('+'); f_n(4 * j);
            asm_ins("ST", s370_line, 4);
            j = j + 1;
        }
        f_reset(); f_s(s370_lab('P', pl)); f_c('+'); f_n(4 * (n - 1)); f_s(",X'80'");
        asm_ins("OI", s370_line, 4);
        f_reset(); f_s("1,"); f_s(s370_lab('P', pl));
        asm_ins("LA", s370_line, 4);
    }
    if (callp) {
        s370_load_into(15, h_src1[i]);
    } else {
        f_reset(); f_s("15,"); f_s(s370_pool_v(ext));
        asm_ins("L", s370_line, 4);
    }
    asm_ins("BALR", "14,15", 2);
    s370_call_result(i);
}

/* ---- one instruction ---- */

static int s370_fused_cmp_for(int brc) { return hcg_brc_fuse[brc]; }

static void s370_condbr(int i) {
    int cmp;
    int mask;
    int then_b;
    int else_b;
    int cond;
    int then_copies;
    int else_copies;
    int next_b;
    int lstub;

    /* HI_BRC: src1 the condition, src2 the taken target, val the
     * fall-through (hi_emit(HI_BRC, ty, cond, then, else)). */
    then_b = h_src2[i];
    else_b = h_val[i];
    cond = h_src1[i];
    cmp = s370_fused_cmp_for(i);
    /* the block laid out next, for fallthrough */
    next_b = -1;
    {
        int q;
        q = 0;
        while (q + 1 < bb_nblk) {
            if (hcg_emit_ord[q] == hcg_cur_blk) { next_b = hcg_emit_ord[q + 1]; break; }
            q = q + 1;
        }
    }
    then_copies = s370_edge_needs_copies(hcg_cur_blk, then_b);
    else_copies = s370_edge_needs_copies(hcg_cur_blk, else_b);

    if (s370_bxle_ok(i)) {
        int p1;
        int idx;
        int step;
        char bx[32];
        p1 = s370_bxle_add[i];
        idx = (h_src1[p1] >= 0 && h_kind[h_src1[p1]] == HI_PHI) ? h_src1[p1] : h_src2[p1];
        step = (idx == h_src1[p1]) ? h_src2[p1] : h_src1[p1];
        if (ra_reg[p1] != ra_reg[idx]) {
            f_reset(); f_s(s370_r(ra_reg[p1])); f_c(','); f_s(s370_r(ra_reg[idx])); asm_ins("LR", s370_line, 2);
        }
        strcpy(bx, s370_r(ra_reg[p1]));
        strcat(bx, ",");
        strcat(bx, s370_r(ra_reg[step]));
        strcat(bx, ",");
        if (!then_copies) {
            { char *t; t = s370_target_fmt(hcg_blk_lbl[then_b], 1); f_reset(); f_s(bx); f_s(t); }
            asm_ins(hcg_cmp_kind[cmp] == HI_SGT ? "BXH" : "BXLE", s370_line, 4);
            if (else_copies) s370_phi_copies(hcg_cur_blk, else_b);
            if (else_b != next_b) s370_branch(15, hcg_blk_lbl[else_b]);
            return;
        }
        lstub = cg_label();
        { char *t; t = s370_target_fmt(lstub, 1); f_reset(); f_s(bx); f_s(t); }
        asm_ins(hcg_cmp_kind[cmp] == HI_SGT ? "BXH" : "BXLE", s370_line, 4);
        if (else_copies) s370_phi_copies(hcg_cur_blk, else_b);
        s370_branch(15, hcg_blk_lbl[else_b]);
        asm_stmt(s370_lab('L', lstub), "DS", "0H");
        s370_phi_copies(hcg_cur_blk, then_b);
        s370_branch(15, hcg_blk_lbl[then_b]);
        return;
    }
    if (cmp >= 0) {
        s370_compare(hcg_cmp_kind[cmp], h_src1[cmp], h_src2[cmp]);
        mask = s370_cc_mask(hcg_cmp_kind[cmp]);
    } else {
        int r;
        r = s370_gpr(cond, 14);
        f_reset(); f_s(s370_r(r)); f_c(','); f_s(s370_r(r)); asm_ins("LTR", s370_line, 2);
        mask = 7;
    }
    if (!then_copies && !else_copies) {
        if (else_b == next_b) { s370_branch(mask, hcg_blk_lbl[then_b]); return; }
        if (then_b == next_b) { s370_branch(15 - mask, hcg_blk_lbl[else_b]); return; }
        s370_branch(mask, hcg_blk_lbl[then_b]);
        s370_branch(15, hcg_blk_lbl[else_b]);
        return;
    }
    /* Copies on an edge.  If only the else edge needs them, branch
     * on the condition to the then block and run them in line; else
     * branch to a stub for the then side, and the else path must jump
     * over the stub even when its block is laid out next. */
    if (!then_copies) {
        s370_branch(mask, hcg_blk_lbl[then_b]);
        s370_phi_copies(hcg_cur_blk, else_b);
        if (else_b != next_b) s370_branch(15, hcg_blk_lbl[else_b]);
        return;
    }
    lstub = cg_label();
    s370_branch(mask, lstub);
    if (else_copies) s370_phi_copies(hcg_cur_blk, else_b);
    s370_branch(15, hcg_blk_lbl[else_b]);
    asm_stmt(s370_lab('L', lstub), "DS", "0H");
    s370_phi_copies(hcg_cur_blk, then_b);
    s370_branch(15, hcg_blk_lbl[then_b]);
}

static void s370_inst(int i) {
    int k;
    int pat;
    int lnt;
    int d;
    char mem[40];

    k = h_kind[i];
    if (k == HI_NOP || k == HI_PHI) return;
    s370_emitting = i;
    s370_cur_pos = ra_pos[i];
    s370_fpr_saved = -1;
    pat = bg_sel[i];
    lnt = -1;
    if (pat >= 0) lnt = bg_plnt[pat];
    else if (h_src1[i] >= 0 && h_kind[h_src1[i]] == HI_ALLOCA && s370_aoff[h_src1[i]] >= 0) lnt = BG_FADDR;
    else if (k == HI_LOAD || k == HI_STORE) lnt = BG_RADDR;

    /* A value that nobody reads and that lives nowhere: skip the work,
     * except for calls and stores, which have effects. */
    if (hi_has_value(k) && ra_reg[i] < 0 && ra_spill_off[i] == 0 &&
        k != HI_CALL && k != HI_CALLP && !hi_inst_remat(i)) return;
    if (hi_inst_remat(i)) return;      /* materialized at each use */

    if (k == HI_ICONST || k == HI_FCONST || k == HI_ALLOCA || k == HI_GADDR || k == HI_FADDR || k == HI_SADDR) {
        /* pinned (no_remat): materialize once into its register */
        if (k == HI_FCONST) {
            d = s370_fdst(i);
            f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_pool_fconst(i));
            asm_ins(ty_is_double(h_ty[i]) ? "LD" : "LE", s370_line, 4);
            s370_ffinish(i, d);
            return;
        }
        {
            int saved_reg;
            d = s370_idst(i);
            saved_reg = ra_reg[i];
            ra_reg[i] = -1;         /* materialize, do not "copy from itself" */
            h_no_remat[i] = 0;      /* so load_into treats it as remat */
            s370_load_into(d, i);
            h_no_remat[i] = 1;
            ra_reg[i] = saved_reg;
            s370_ifinish(i, d);
        }
        return;
    }

    if (k == HI_PARAM) {
        d = s370_idst(i);
        if (s370_r1_intact) {
            /* still in the entry block before anything touched R1:
             * the list is where the caller left it */
            f_reset(); f_s(s370_r(d)); f_c(','); f_n(4 * h_val[i]); f_s("(,1)"); asm_ins("L", s370_line, 4);
        } else {
            f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_hdr(S370_HDR_PARM)); asm_ins("L", s370_line, 4);
            f_reset(); f_s(s370_r(d)); f_c(','); f_n(4 * h_val[i]); f_s("(,"); f_s(s370_r(d)); f_c(')'); asm_ins("L", s370_line, 4);
        }
        /* the last word of an OS parameter list carries X'80' in its
         * first byte: an address, not a flag, from here on */
        if (h_val[i] == hl_nparams - 1) { f_reset(); f_s(s370_r(d)); f_s(",0(,"); f_s(s370_r(d)); f_c(')'); asm_ins("LA", s370_line, 4); }
        s370_ifinish(i, d);
        return;
    }
    /* anything else may use R1: the index scratch, the M/D pair, a call */
    s370_r1_intact = 0;

    if (k == HI_LOAD) {
        int ty;
        int s;
        char *op;
        ty = h_ty[i];
        s = 14;
        if (ty_is_fp(ty)) {
            d = s370_fdst(i);
            op = ty_is_double(ty) ? "LD" : "LE";
            {
                char *m;
                m = s370_mem_operand(h_src1[i], lnt, s);
                f_reset(); f_s(s370_r(d)); f_c(','); f_s(m); asm_ins(op, s370_line, 4);
            }
            s370_ffinish(i, d);
            return;
        }
        d = s370_idst(i);
        if (d == 14) s = 15;
        if ((ty & TY_BASE_MASK) == TY_CHAR) {
            char *m;
            if (ty & TY_UNSIGNED) {
                m = s370_mem_operand(h_src1[i], lnt, s);
                f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_r(d)); asm_ins("SR", s370_line, 2);
                f_reset(); f_s(s370_r(d)); f_c(','); f_s(m); asm_ins("IC", s370_line, 4);
            } else {
                m = s370_mem_operand_rs(h_src1[i], lnt, s);     /* ICM is RS: no index */
                f_reset(); f_s(s370_r(d)); f_s(",8,"); f_s(m); asm_ins("ICM", s370_line, 4);
                f_reset(); f_s(s370_r(d)); f_s(",24"); asm_ins("SRA", s370_line, 4);
            }
        } else {
            char *m;
            m = s370_mem_operand(h_src1[i], lnt, s);
            f_reset(); f_s(s370_r(d)); f_c(','); f_s(m);
            asm_ins((ty & TY_BASE_MASK) == TY_SHORT ? "LH" : "L", s370_line, 4);
        }
        s370_ifinish(i, d);
        return;
    }

    if (k == HI_STORE) {
        int ty;
        int v;
        char *m;
        ty = h_ty[i];
        v = h_src2[i];
        if (ty_is_fp(ty) && !ra_is_fpv(v)) ty = TY_INT;   /* an address stored through a typed temp */
        if (ty_is_fp(ty)) {
            int dbl;
            dbl = ty_is_double(ty);
            if (ra_reg[v] >= 0) {
                m = s370_mem_operand(h_src1[i], lnt, 14);
                f_reset(); f_s(s370_r(ra_reg[v])); f_c(','); f_s(m); asm_ins(dbl ? "STD" : "STE", s370_line, 4);
            } else if (s370_fmem(v, mem)) {
                /* storage to storage: MVC takes a base but no index,
                 * which our operand forms never have */
                m = s370_mem_operand(h_src1[i], lnt, 14);
                f_reset(); f_s(m);
                /* insert the length: "D(,B)" -> "D(8,B)", "T+off" -> "T+off(8)" */
                {
                    char tmp[64];
                    char *p;
                    int q;
                    strcpy(tmp, m);
                    p = strchr(tmp, '(');
                    f_reset();
                    if (p && p[1] == ',') {
                        q = (int)(p - tmp);
                        tmp[q] = 0;
                        f_s(tmp); f_c('('); f_n(dbl ? 8 : 4); f_s(p + 1);
                    } else {
                        f_s(tmp); f_c('('); f_n(dbl ? 8 : 4); f_c(')');
                    }
                    f_c(','); f_s(mem);
                }
                asm_ins("MVC", s370_line, 6);
            } else cg_die("store source", v);
            return;
        }
        {
            int r;
            r = s370_gpr(v, 15);
            m = s370_mem_operand(h_src1[i], lnt, 14);     /* base R14, index R1 */
            if ((ty & TY_BASE_MASK) == TY_CHAR) { f_reset(); f_s(s370_r(r)); f_c(','); f_s(m); asm_ins("STC", s370_line, 4); }
            else if ((ty & TY_BASE_MASK) == TY_SHORT) { f_reset(); f_s(s370_r(r)); f_c(','); f_s(m); asm_ins("STH", s370_line, 4); }
            else { f_reset(); f_s(s370_r(r)); f_c(','); f_s(m); asm_ins("ST", s370_line, 4); }
        }
        return;
    }

    if (k == HI_ADDI) {
        d = s370_idst(i);
        if (lnt == BG_FADDR) {
            f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_faddr_text(i)); asm_ins("LA", s370_line, 4);
        } else {
            /* An integer add: AH/A, never LA, which would keep 24 bits
             * of a value that may be negative or large.  The chain is
             * folded so one add covers ADDI(ADDI(x, a), b). */
            int c;
            int base;
            int off;
            if (s370_fold_chain(i, &base, &off)) {
                c = off;
                s370_load_into(d, base);
            } else {
                c = h_val[i];
                s370_load_into(d, h_src1[i]);
            }
            if (c >= -32768 && c <= 32767) { f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_pool_h(c)); asm_ins("AH", s370_line, 4); }
            else { f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_pool_f(c)); asm_ins("A", s370_line, 4); }
        }
        s370_ifinish(i, d);
        return;
    }

    if (k == HI_COPY) {
        if (ra_is_fpv(i)) {
            d = s370_fdst(i);
            s370_copy_to_reg(d, 1, h_src1[i], ty_is_double(h_ty[i]));
            s370_ffinish(i, d);
        } else {
            d = s370_idst(i);
            s370_load_into(d, h_src1[i]);
            s370_ifinish(i, d);
        }
        return;
    }

    if (k == HI_ADD && s370_bxle_brc[i] >= 0 && s370_bxle_ok(s370_bxle_brc[i])) return;   /* done by the BXLE */
    if (k == HI_ADD || k == HI_SUB || k == HI_AND || k == HI_OR || k == HI_XOR) {
        d = s370_idst(i);
        if (k == HI_ADD) s370_binop(i, "AR", "A", d);
        else if (k == HI_SUB) s370_binop(i, "SR", "S", d);
        else if (k == HI_AND) s370_binop(i, "NR", "N", d);
        else if (k == HI_OR) s370_binop(i, "OR", "O", d);
        else s370_binop(i, "XR", "X", d);
        s370_ifinish(i, d);
        return;
    }
    if (k == HI_SLL || k == HI_SRL || k == HI_SRA) {
        d = s370_idst(i);
        s370_shift(i, k == HI_SLL ? "SLL" : k == HI_SRL ? "SRL" : "SRA", d);
        s370_ifinish(i, d);
        return;
    }
    if (k == HI_MUL || k == HI_DIV || k == HI_REM) {
        d = s370_idst(i);
        s370_muldiv(i, d);
        s370_ifinish(i, d);
        return;
    }
    if (hcg_is_cmp(k)) {
        d = s370_idst(i);
        s370_setcc(k, h_src1[i], h_src2[i], d);
        s370_ifinish(i, d);
        return;
    }
    if (k == HI_NEG) {
        int r;
        d = s370_idst(i);
        r = s370_gpr(h_src1[i], d);
        f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_r(r)); asm_ins("LCR", s370_line, 2);
        s370_ifinish(i, d);
        return;
    }
    if (k == HI_NOT) {
        int r;
        int l;
        d = s370_idst(i);
        r = s370_gpr(h_src1[i], d);
        f_reset(); f_s(s370_r(r)); f_c(','); f_s(s370_r(r)); asm_ins("LTR", s370_line, 2);
        f_reset(); f_s(s370_r(d)); f_s(",1"); asm_ins("LA", s370_line, 4);
        l = cg_label();
        s370_branch(8, l);
        f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_r(d)); asm_ins("SR", s370_line, 2);
        asm_stmt(s370_lab('L', l), "DS", "0H");
        s370_ifinish(i, d);
        return;
    }
    if (k == HI_BNOT) {
        d = s370_idst(i);
        s370_load_into(d, h_src1[i]);
        f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_pool_f(-1)); asm_ins("X", s370_line, 4);
        s370_ifinish(i, d);
        return;
    }

    if (k == HI_FADD || k == HI_FSUB || k == HI_FMUL || k == HI_FDIV) {
        int dbl;
        dbl = ty_is_double(h_ty[i]);
        d = s370_fdst(i);
        if (k == HI_FADD) s370_fbinop(i, dbl ? "ADR" : "AER", dbl ? "AD" : "AE", d);
        else if (k == HI_FSUB) s370_fbinop(i, dbl ? "SDR" : "SER", dbl ? "SD" : "SE", d);
        else if (k == HI_FMUL) s370_fbinop(i, dbl ? "MDR" : "MER", dbl ? "MD" : "ME", d);
        else s370_fbinop(i, dbl ? "DDR" : "DER", dbl ? "DD" : "DE", d);
        s370_ffinish(i, d);
        return;
    }
    if (k == HI_FNEG || k == HI_FABS) {
        int dbl;
        dbl = ty_is_double(h_ty[i]);
        d = s370_fdst(i);
        s370_copy_to_reg(d, 1, h_src1[i], dbl);
        f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_r(d));
        if (k == HI_FNEG) asm_ins(dbl ? "LCDR" : "LCER", s370_line, 2);
        else asm_ins(dbl ? "LPDR" : "LPER", s370_line, 2);
        s370_ffinish(i, d);
        return;
    }
    if (k == HI_FCVT_ItoF) {
        /* integer to long: the unnormalized doubleword trick, exact */
        int dbl;
        dbl = ty_is_double(h_ty[i]);
        s370_load_into(0, h_src1[i]);
        f_reset(); f_s("0,"); f_s(s370_pool_f((int)0x80000000u)); asm_ins("X", s370_line, 4);
        f_reset(); f_s("0,"); f_s(s370_hdr(S370_HDR_ICVT + 4)); asm_ins("ST", s370_line, 4);
        d = s370_fdst(i);
        f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_hdr(S370_HDR_ICVT)); asm_ins("LD", s370_line, 4);
        f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_lab('C', s370_pool(S370_PK_D, 0x4E000000u, 0x80000000u, 0))); asm_ins("SD", s370_line, 4);
        if (!dbl) { f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_r(d)); asm_ins("LER", s370_line, 2); }
        s370_ffinish(i, d);
        return;
    }
    if (k == HI_FCVT_FtoI) {
        /* truncate toward zero: AW with the unnormalized magic, sign
         * restored afterwards */
        int src;
        int f;
        int l;
        int dbl;
        char fm[40];
        src = h_src1[i];
        dbl = ty_is_double(h_ty[src]);
        f = s370_borrow_fpr();
        if (ra_reg[src] >= 0) { if (ra_reg[src] != f) { f_reset(); f_s(s370_r(f)); f_c(','); f_s(s370_r(ra_reg[src])); asm_ins("LDR", s370_line, 2); } }
        else if (s370_fmem(src, fm)) { f_reset(); f_s(s370_r(f)); f_c(','); f_s(fm); asm_ins(dbl ? "LD" : "LE", s370_line, 4); }
        if (!dbl) {
            /* make the low word zero so AW sees a clean long value */
            f_reset(); f_s(s370_r(f)); f_c(','); f_s(s370_hdr(S370_HDR_ECVT)); asm_ins("STE", s370_line, 4);
            f_reset(); f_s(s370_r(f)); f_c(','); f_s(s370_hdr(S370_HDR_ECVT)); asm_ins("LD", s370_line, 4);
        }
        d = s370_idst(i);
        f_reset(); f_s(s370_r(f)); f_c(','); f_s(s370_r(f)); asm_ins("LTDR", s370_line, 2);
        /* work on the magnitude */
        f_reset(); f_s(s370_r(f)); f_c(','); f_s(s370_r(f)); asm_ins("LPDR", s370_line, 2);
        f_reset(); f_s(s370_r(f)); f_c(','); f_s(s370_lab('C', s370_pool(S370_PK_D, 0x4E000000u, 0, 0))); asm_ins("AW", s370_line, 4);
        /* not FTMP: the borrowed register may be parked there */
        f_reset(); f_s(s370_r(f)); f_c(','); f_s(s370_hdr(S370_HDR_CVTT)); asm_ins("STD", s370_line, 4);
        f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_hdr(S370_HDR_CVTT + 4)); asm_ins("L", s370_line, 4);
        /* LTDR's condition code was clobbered by LPDR/AW: redo the sign test on the source */
        if (ra_reg[src] >= 0) { f_reset(); f_s(s370_r(ra_reg[src])); f_c(','); f_s(s370_r(ra_reg[src])); asm_ins("LTDR", s370_line, 2); }
        else { f_reset(); f_s(s370_r(f)); f_c(','); f_s(fm); asm_ins(dbl ? "LD" : "LE", s370_line, 4);
               f_reset(); f_s(s370_r(f)); f_c(','); f_s(s370_r(f)); asm_ins("LTDR", s370_line, 2); }
        l = cg_label();
        s370_branch(10, l);    /* zero or positive */
        f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_r(d)); asm_ins("LCR", s370_line, 2);
        asm_stmt(s370_lab('L', l), "DS", "0H");
        if (s370_fpr_saved >= 0) s370_return_fpr();
        s370_ifinish(i, d);
        return;
    }
    if (k == HI_FCVT_FtoD) {
        int src;
        char fm[40];
        src = h_src1[i];
        d = s370_fdst(i);
        if (ra_reg[src] >= 0) { f_reset(); f_s(s370_r(ra_reg[src])); f_c(','); f_s(s370_hdr(S370_HDR_ECVT)); asm_ins("STE", s370_line, 4); }
        else if (s370_fmem(src, fm)) { f_reset(); f_s(s370_hdr(S370_HDR_ECVT)); f_s("(4),"); f_s(fm); asm_ins("MVC", s370_line, 6); }
        f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_hdr(S370_HDR_ECVT)); asm_ins("LD", s370_line, 4);
        s370_ffinish(i, d);
        return;
    }
    if (k == HI_FCVT_DtoF) {
        d = s370_fdst(i);
        s370_copy_to_reg(d, 1, h_src1[i], 1);
        /* the short value is the long one's first word: nothing to do
         * but drop the low word, which LER into itself does */
        f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_r(d)); asm_ins("LER", s370_line, 2);
        s370_ffinish(i, d);
        return;
    }

    if (k == HI_CALL || k == HI_CALLP) { s370_call(i); return; }

    if (k == HI_BR) {
        int tgt;
        int next_b;
        int q;
        tgt = h_val[i];
        if (s370_edge_needs_copies(hcg_cur_blk, tgt)) s370_phi_copies(hcg_cur_blk, tgt);
        next_b = -1;
        q = 0;
        while (q + 1 < bb_nblk) { if (hcg_emit_ord[q] == hcg_cur_blk) { next_b = hcg_emit_ord[q + 1]; break; } q = q + 1; }
        if (tgt != next_b) s370_branch(15, hcg_blk_lbl[tgt]);
        return;
    }
    if (k == HI_BRC) { s370_condbr(i); return; }
    if (k == HI_RET) {
        int v;
        int next_b;
        int q;
        v = h_src1[i];
        if (v >= 0 && !s370_unit_is_main) {
            /* a FUNCTION result: FPR0 (and FPR2 for COMPLEX) or R0; a
             * SUBROUTINE's RETURN n: the alternate return's index in R0 */
            if (ra_is_fpv(v)) {
                int w;
                w = h_src2[i];
                if (w >= 0 && ra_reg[w] == 0 && ra_reg[v] == 2) {
                    /* the parts sit in each other's register: swap
                     * through FPR4, which nothing holds at a RETURN
                     * (FCVS FM722's ZF724 returned (3,3) for (3,4)) */
                    asm_ins(ty_is_double(h_ty[w]) ? "LDR" : "LER", "4,0", 2);
                    s370_copy_to_reg(0, 1, v, ty_is_double(h_ty[v]));
                    asm_ins(ty_is_double(h_ty[w]) ? "LDR" : "LER", "2,4", 2);
                } else if (w >= 0 && ra_reg[w] == 0) {
                    /* the imaginary part is in FPR0: move it out first */
                    s370_copy_to_reg(2, 1, w, ty_is_double(h_ty[w]));
                    s370_copy_to_reg(0, 1, v, ty_is_double(h_ty[v]));
                } else {
                    s370_copy_to_reg(0, 1, v, ty_is_double(h_ty[v]));
                    if (w >= 0) s370_copy_to_reg(2, 1, w, ty_is_double(h_ty[w]));
                }
            } else {
                s370_load_into(0, v);
            }
        }
        next_b = -1;
        q = 0;
        while (q + 1 < bb_nblk) { if (hcg_emit_ord[q] == hcg_cur_blk) { next_b = hcg_emit_ord[q + 1]; break; } q = q + 1; }
        if (next_b >= 0) s370_branch(15, hcg_epilog);
        return;
    }
    if (k == HI_JMPTAB) {
        int r;
        int jt;
        int q;
        r = s370_gpr(h_src1[i], 14);
        if (r != 14) { f_reset(); f_s("14,"); f_s(s370_r(r)); asm_ins("LR", s370_line, 2); }
        asm_ins("SLL", "14,2", 4);
        jt = cg_label();
        f_reset(); f_s("15,"); f_s(s370_pool_al(jt)); asm_ins("L", s370_line, 4);
        asm_ins("L", "15,0(14,15)", 4);
        asm_ins("BCR", "15,15", 2);
        /* the table is emitted in the static area: remember it */
        if (s370_npl >= S370_MAX_PL) cg_die("too many jump tables", i);
        s370_pl_lbl[s370_npl] = jt;
        s370_pl_n[s370_npl] = -(i + 1);     /* negative: a jump table for instruction i */
        s370_npl = s370_npl + 1;
        (void)q;
        return;
    }
    if (k == HI_CALLHI) {
        /* the imaginary part of a COMPLEX function result, FPR2 */
        if (ra_reg[i] >= 0) { if (ra_reg[i] != 2) { f_reset(); f_s(s370_r(ra_reg[i])); f_s(",2"); asm_ins("LER", s370_line, 2); } }
        else if (ra_spill_off[i] != 0) { f_reset(); f_s("2,"); f_s(s370_slot(i)); asm_ins("STE", s370_line, 4); }
        return;
    }
    cg_die("unhandled instruction kind", i);
}

static void s370_block(int b) {
    int i;
    int term;
    int k;
    hcg_cur_blk = b;
    if (b != hcg_emit_ord[0]) s370_r1_intact = 0;
    asm_stmt(s370_lab('L', hcg_blk_lbl[b]), "DS", "0H");
    i = split_head[b];
    while (i >= 0) { s370_inst(i); i = licm_next[i]; }
    term = -1;
    i = bb_end[b] - 1;
    while (i >= bb_start[b]) {
        k = h_kind[i];
        if (hi_is_terminator(k)) { term = i; break; }
        if (k != HI_NOP) break;
        i = i - 1;
    }
    i = bb_start[b];
    while (i < bb_end[b]) {
        if (i == term) break;
        s370_inst(i);
        i = i + 1;
    }
    i = licm_head[b];
    while (i >= 0) { s370_inst(i); i = licm_next[i]; }
    if (term >= 0) s370_inst(term);
}

/* Block order: greedy fallthrough chains, block 0 first. */
static void s370_layout_blocks(void) {
    int b;
    int n;
    int cur;
    int nxt;
    int i;
    int k;
    b = 0;
    while (b < bb_nblk) { hcg_placed[b] = 0; b = b + 1; }
    n = 0;
    cur = 0;
    while (n < bb_nblk) {
        hcg_emit_ord[n] = cur;
        hcg_placed[cur] = 1;
        n = n + 1;
        nxt = -1;
        /* preferred successor: BR target, or the else arm of a BRC */
        i = bb_end[cur] - 1;
        while (i >= bb_start[cur] && h_kind[i] == HI_NOP) i = i - 1;
        if (i >= bb_start[cur]) {
            k = h_kind[i];
            if (k == HI_BR && !hcg_placed[h_val[i]]) nxt = h_val[i];
            else if (k == HI_BRC) {
                int t;
                int e;
                t = h_src2[i];
                e = h_val[i];
                /* IF (c) statement: the then arm is a block of its own
                 * that falls into the join; lay it next (the branch
                 * inverts), as H does, rather than at the unit's end,
                 * where in a unit of more than 4K it is a far branch */
                if (!hcg_placed[t] && t >= 0 && t < bb_nblk && ssa_npred[t] == 1 && ssa_nsucc[t] == 1 &&
                    ssa_succ[ssa_soff[t]] == e) nxt = t;
                else if (!hcg_placed[e]) nxt = e;        /* the fall-through arm */
                else if (!hcg_placed[t]) nxt = t;
            }
        }
        if (nxt < 0) {
            b = 0;
            while (b < bb_nblk && hcg_placed[b]) b = b + 1;
            if (b < bb_nblk) nxt = b;
        }
        cur = nxt;
        if (cur < 0) break;
    }
}

/* ---------------------------------------------------------------- */
/* The static area                                                   */
/* ---------------------------------------------------------------- */

static void s370_emit_dc_string(char *label, unsigned char *s, int len) {
    /* CLn'...' with quotes and ampersands doubled, 40 characters per
     * statement so the line stays short */
    int i;
    int n;
    char *lab;
    lab = label;
    i = 0;
    if (len == 0) { asm_stmt(label, "DC", "C' '"); return; }
    while (i < len) {
        n = 0;
        f_reset();
        f_s("C'");
        while (i < len && n < 40) {
            int c;
            c = s[i];
            if (c == '\'' || c == '&') { f_c(c); f_c(c); }
#ifdef __MVS__
            else if (!isprint(c)) f_c('?');          /* EBCDIC: printable is not 32..126 */
#else
            else if (c < 32 || c > 126) f_c('?');
#endif
            else f_c(c);
            i = i + 1;
            n = n + 1;
        }
        f_c('\'');
        asm_stmt(lab, "DC", s370_line);
        lab = "";
    }
}

static void s370_emit_area(void) {
    int i;
    int k;
    int off;
    int pad;

    asm_stmt("", "DROP", "12");
    asm_stmt(s370_lab('S', s370_area_lbl), "DS", "0D");
    asm_stmt("", "DS", "18F");                       /* save area */
    asm_stmt("", "DS", "F");                         /* saved R1 */
    asm_stmt("", "DS", "F");                         /* pad to 80 */
    asm_stmt("", "DC", "X'4E000000',F'0'");          /* 80: ICVT */
    asm_stmt("", "DC", "D'0'");                      /* 88: ECVT */
    asm_stmt("", "DS", "D");                         /* 96: FTMP */
    asm_stmt("", "DS", "8D");                        /* 104: PHIT x 8 */
    asm_stmt("", "DS", "D");                         /* 168: CVTT */
    off = S370_HDR_SIZE;
    /* near objects, in layout order */
    i = 0;
    while (i < s370_nobj) {
        k = s370_order[i];
        if (s370_obj_off[k] >= 0) {
            if (s370_obj_off[k] != off) cg_die("area layout drift", s370_obj_inst[k]);
            f_reset(); f_s("XL"); f_n(s370_obj_size[k]);
            asm_stmt(s370_lab('T', s370_obj_lbl[k]), "DS", s370_line);
            off = off + s370_obj_size[k];
            pad = ((off + 7) & ~7) - off;
            if (pad > 0) { f_reset(); f_s("XL"); f_n(pad); asm_stmt("", "DS", s370_line); off = off + pad; }
        }
        i = i + 1;
    }
    if (off != s370_spill_base) cg_die("spill base drift", -1);
    if (ra_nslots > 0) { f_reset(); f_n(ra_nslots); f_c('D'); asm_stmt("", "DS", s370_line); off = off + 8 * ra_nslots; }
    /* call temporaries */
    i = 0;
    while (i < s370_ntmp) { asm_stmt(s370_lab('W', s370_tmp_labels[i]), "DS", "D"); off = off + 8; i = i + 1; }
    /* the parameter list, and jump tables */
    if (s370_plist_lbl >= 0) {
        f_reset(); f_n(s370_plist_n); f_c('F');
        asm_stmt(s370_lab('P', s370_plist_lbl), "DS", s370_line);
        off = off + 4 * s370_plist_n;
    }
    i = 0;
    while (i < s370_npl) {
        if (s370_pl_n[i] > 0) {
            cg_die("stale parameter list entry", -1);
        } else {
            int ji;
            int q;
            ji = -s370_pl_n[i] - 1;
            q = 0;
            while (q < hjt_span[ji]) {
                f_reset(); f_s("A("); f_s(s370_lab('L', hcg_blk_lbl[hjt_target[hjt_base[ji] + q]])); f_c(')');
                asm_stmt(q == 0 ? s370_lab('P', s370_pl_lbl[i]) : "", "DC", s370_line);
                off = off + 4;
                q = q + 1;
            }
        }
        i = i + 1;
    }
    /* the constant pool */
    if (off & 7) { f_reset(); f_s("XL"); f_n(8 - (off & 7)); asm_stmt("", "DS", s370_line); off = (off + 7) & ~7; }
    i = 0;
    while (i < s370_npool) {
        char *lab;
        lab = s370_lab('C', s370_pk_lbl[i]);
        k = s370_pk_kind[i];
        if (k == S370_PK_D) {
            f_reset(); f_s("X'"); f_hex8(s370_pk_v1[i]); f_hex8(s370_pk_v2[i]); f_c('\'');
            asm_stmt(lab, "DC", s370_line);
        }
        i = i + 1;
    }
    i = 0;
    while (i < s370_npool) {
        char *lab;
        lab = s370_lab('C', s370_pk_lbl[i]);
        k = s370_pk_kind[i];
        if (k == S370_PK_F) { f_reset(); f_s("F'"); f_n((int)s370_pk_v1[i]); f_c('\''); asm_stmt(lab, "DC", s370_line); }
        else if (k == S370_PK_E) { f_reset(); f_s("X'"); f_hex8(s370_pk_v1[i]); f_c('\''); asm_stmt(lab, "DC", s370_line); }
        else if (k == S370_PK_A) {
            f_reset(); f_s("A("); f_s(s370_pk_name[i]);
            if ((int)s370_pk_v1[i] > 0) { f_c('+'); f_n((int)s370_pk_v1[i]); }
            else if ((int)s370_pk_v1[i] < 0) { f_n((int)s370_pk_v1[i]); }
            f_c(')'); asm_stmt(lab, "DC", s370_line);
        }
        else if (k == S370_PK_V) { f_reset(); f_s("V("); f_s(s370_pk_name[i]); f_c(')'); asm_stmt(lab, "DC", s370_line); }
        else if (k == S370_PK_AT) {
            f_reset(); f_s("A("); f_s(s370_lab('T', (int)s370_pk_v1[i]));
            if ((int)s370_pk_v2[i] > 0) { f_c('+'); f_n((int)s370_pk_v2[i]); }
            else if ((int)s370_pk_v2[i] < 0) { f_n((int)s370_pk_v2[i]); }
            f_c(')'); asm_stmt(lab, "DC", s370_line);
        }
        else if (k == S370_PK_AL) { f_reset(); f_s("A("); f_s(s370_lab('P', (int)s370_pk_v1[i])); f_c(')'); asm_stmt(lab, "DC", s370_line); }
        else if (k == S370_PK_AB) { f_reset(); f_s("A("); f_s(s370_lab('L', (int)s370_pk_v1[i])); f_c(')'); asm_stmt(lab, "DC", s370_line); }
        else if (k == S370_PK_AQ) {
            f_reset(); f_s("A("); f_s(s370_lab('Q', s370_str_lbl[(int)s370_pk_v1[i]]));
            if ((int)s370_pk_v2[i] > 0) { f_c('+'); f_n((int)s370_pk_v2[i]); }
            f_c(')'); asm_stmt(lab, "DC", s370_line);
        }
        i = i + 1;
    }
    i = 0;
    while (i < s370_npool) {
        if (s370_pk_kind[i] == S370_PK_H) {
            f_reset(); f_s("H'"); f_n((int)s370_pk_v1[i]); f_c('\'');
            asm_stmt(s370_lab('C', s370_pk_lbl[i]), "DC", s370_line);
        }
        i = i + 1;
    }
    /* strings first referenced by this unit */
    i = 0;
    while (i < lex_str_count) {
        if (s370_str_unit[i] == s370_cur_unit) {
            s370_emit_dc_string(s370_lab('Q', s370_str_lbl[i]),
                                (unsigned char *)lex_strpool + lex_str_off[i], lex_str_len[i]);
        }
        i = i + 1;
    }
    /* far objects */
    i = 0;
    while (i < s370_nobj) {
        k = s370_order[i];
        if (s370_obj_off[k] < 0) {
            /* a length modifier stops at 65535; a doubleword count
             * reaches eight times as far, and beyond that several */
            int n;
            int first;
            n = (s370_obj_size[k] + 7) / 8;
            first = 1;
            asm_stmt("", "DS", "0D");
            while (n > 0) {
                int c;
                c = n > 65535 ? 65535 : n;
                f_reset(); f_n(c); f_c('D');
                asm_stmt(first ? s370_lab('T', s370_obj_lbl[k]) : "", "DS", s370_line);
                n = n - c;
                first = 0;
            }
        }
        i = i + 1;
    }
}

/* ---------------------------------------------------------------- */
/* A unit                                                            */
/* ---------------------------------------------------------------- */

static void s370_mark_strings(void) {
    int i;
    i = 0;
    while (i < h_ninst) {
        if (h_kind[i] == HI_SADDR && h_val[i] >= 0 && h_val[i] < lex_str_count) {
            if (s370_str_unit[h_val[i]] < 0) {
                s370_str_unit[h_val[i]] = s370_cur_unit;
                s370_str_lbl[h_val[i]] = cg_label();
            }
        }
        i = i + 1;
    }
}

/* What LICM may leave in a loop as a leaf to recompute: an object the
 * data bases reach (its address is a label, no instruction), or a
 * constant LA can make.  A far object or a symbol costs a load from
 * the pool at every use; hoist those. */
static int s370_cheap_operand(int inst) {
    int k;
    if (inst < 0) return 1;
    k = h_kind[inst];
    if (k == HI_ALLOCA) return s370_aoff[inst] >= 0;
    if (k == HI_ICONST) return h_val[inst] >= 0 && h_val[inst] <= 4095;
    return 0;
}

/* ADDI(ADD(base, idx), c) -> ADD(ADDI(base, c), idx) when base is an
 * address: the constant then belongs to a loop-invariant base (H's
 * "DY-8" register, or a label with an offset) and the index register
 * carries nothing but the subscript.  Both instructions are rewritten
 * in place, which keeps the order right; the ADD must have no other
 * use. */
static short s370_use_count[HIR_MAX_INST];
static void s370_reassoc(void) {
    int i;
    int j;
    int k;
    int a;
    int base;
    int idx;
    i = 0;
    while (i < h_ninst) { s370_use_count[i] = 0; i = i + 1; }
    i = 0;
    while (i < h_ninst) {
        k = h_kind[i];
        if (k == HI_NOP) { i = i + 1; continue; }
        if (h_src1[i] >= 0) s370_use_count[h_src1[i]] = s370_use_count[h_src1[i]] + 1;
        if (h_src2[i] >= 0 && ho_src2_is_ref(k)) s370_use_count[h_src2[i]] = s370_use_count[h_src2[i]] + 1;
        if ((k == HI_CALL || k == HI_CALLP) && h_cbase[i] >= 0) {
            j = 0;
            while (j < h_val[i]) { if (h_carg[h_cbase[i] + j] >= 0) s370_use_count[h_carg[h_cbase[i] + j]] = s370_use_count[h_carg[h_cbase[i] + j]] + 1; j = j + 1; }
        }
        if (k == HI_PHI && h_pbase[i] >= 0) {
            j = 0;
            while (j < h_pcnt[i]) { if (h_pval[h_pbase[i] + j] >= 0) s370_use_count[h_pval[h_pbase[i] + j]] = s370_use_count[h_pval[h_pbase[i] + j]] + 1; j = j + 1; }
        }
        i = i + 1;
    }
    /* SLL(ADD(x, c), k) -> ADDI(SLL(x, k), c<<k), and the same for a
     * MUL by a constant: a subscript K+j then shares K's index register
     * and puts 8*j in the displacement, as H's U(K+6) does. */
    i = 0;
    while (i < h_ninst) {
        int c;
        int root;
        int m;
        if ((h_kind[i] == HI_SLL || h_kind[i] == HI_MUL) && h_src1[i] >= 0 && h_src2[i] >= 0 &&
            bg_const_imm_inst(h_src2[i], &m, &root) && hi_is_remat(h_kind[root]) &&
            (h_kind[h_src1[i]] == HI_ADD || h_kind[h_src1[i]] == HI_ADDI || h_kind[h_src1[i]] == HI_SUB) &&
            s370_use_count[h_src1[i]] == 1 && h_blk[h_src1[i]] == h_blk[i]) {
            int x;
            int cval;
            int shifted;
            a = h_src1[i];
            if (h_kind[a] == HI_ADDI) { x = h_src1[a]; cval = h_val[a]; }
            else if (h_kind[a] == HI_SUB) {
                if (bg_const_imm_inst(h_src2[a], &c, &root) && hi_is_remat(h_kind[root])) { x = h_src1[a]; cval = 0 - c; }
                else { i = i + 1; continue; }
            }
            else if (bg_const_imm_inst(h_src2[a], &c, &root) && hi_is_remat(h_kind[root])) { x = h_src1[a]; cval = c; }
            else if (bg_const_imm_inst(h_src1[a], &c, &root) && hi_is_remat(h_kind[root])) { x = h_src2[a]; cval = c; }
            else { i = i + 1; continue; }
            if (h_kind[i] == HI_SLL) { if (m < 0 || m > 20) { i = i + 1; continue; } shifted = cval << m; }
            else { if (m < -4096 || m > 4096) { i = i + 1; continue; } shifted = cval * m; }
            /* a := SLL/MUL(x, m); i := ADDI(a, shifted) */
            h_kind[a] = h_kind[i];
            h_src1[a] = x;
            h_src2[a] = h_src2[i];
            h_val[a] = 0;
            h_kind[i] = HI_ADDI;
            h_src1[i] = a;
            h_src2[i] = -1;
            h_val[i] = shifted;
        }
        i = i + 1;
    }
    i = 0;
    while (i < h_ninst) {
        if (h_kind[i] == HI_ADDI && h_src1[i] >= 0 && h_kind[h_src1[i]] == HI_ADD &&
            s370_use_count[h_src1[i]] == 1 && h_blk[h_src1[i]] == h_blk[i]) {
            a = h_src1[i];
            if (bg_addrlike(h_src1[a]) && !bg_addrlike(h_src2[a])) { base = h_src1[a]; idx = h_src2[a]; }
            else if (bg_addrlike(h_src2[a]) && !bg_addrlike(h_src1[a])) { base = h_src2[a]; idx = h_src1[a]; }
            else { i = i + 1; continue; }
            /* a := ADDI(base, c); i := ADD(a, idx) */
            h_kind[a] = HI_ADDI;
            h_src1[a] = base;
            h_src2[a] = -1;
            h_val[a] = h_val[i];
            h_kind[i] = HI_ADD;
            h_src1[i] = a;
            h_src2[i] = idx;
            h_val[i] = 0;
        }
        i = i + 1;
    }
}

/* ---------------------------------------------------------------- */
/* Loops: the innermost header of each block, from the back edges    */
/* ---------------------------------------------------------------- */

static int s370_loop_hdr[HIR_MAX_BLOCK];   /* innermost loop header containing the block, or -1 */
static int s370_loop_size[HIR_MAX_BLOCK];  /* body size of the loop headed here */
static int s370_lwl[HIR_MAX_BLOCK];
static char s370_lvis[HIR_MAX_BLOCK];

static void s370_find_loops(void) {
    int b;
    int si;
    int s;
    int n;
    int wh;
    int wt;
    int j;
    int p;
    int i;
    b = 0;
    while (b < bb_nblk) { s370_loop_hdr[b] = -1; s370_loop_size[b] = 0; b = b + 1; }
    b = 0;
    while (b < bb_nblk) {
        si = 0;
        while (si < ssa_nsucc[b]) {
            s = ssa_succ[ssa_soff[b] + si];
            if (s >= 0 && s < bb_nblk && licm_dominates(s, b)) {
                /* back edge b -> s: body = blocks reaching b without passing s */
                i = 0;
                while (i < bb_nblk) { s370_lvis[i] = 0; i = i + 1; }
                s370_lvis[s] = 1;
                n = 1;
                wh = 0; wt = 0;
                if (b != s) { s370_lwl[wt] = b; wt = wt + 1; s370_lvis[b] = 1; n = n + 1; }
                while (wh < wt) {
                    int x;
                    x = s370_lwl[wh];
                    wh = wh + 1;
                    j = 0;
                    while (j < ssa_npred[x]) {
                        p = ssa_pred[ssa_pbase[x] + j];
                        if (p >= 0 && p < bb_nblk && !s370_lvis[p]) {
                            s370_lvis[p] = 1;
                            n = n + 1;
                            if (wt < HIR_MAX_BLOCK) { s370_lwl[wt] = p; wt = wt + 1; }
                        }
                        j = j + 1;
                    }
                }
                i = 0;
                while (i < bb_nblk) {
                    if (s370_lvis[i] && (s370_loop_hdr[i] < 0 || n < s370_loop_size[s370_loop_hdr[i]] ||
                                         (s370_loop_hdr[i] == s))) {
                        s370_loop_hdr[i] = s;
                    }
                    i = i + 1;
                }
                if (s370_loop_size[s] == 0 || n < s370_loop_size[s]) s370_loop_size[s] = n;
            }
            si = si + 1;
        }
        b = b + 1;
    }
}

/* Is v invariant with respect to the loop headed by hdr: a constant,
 * an address, or defined in a block outside the loop? */
static int s370_invariant_in(int v, int hdr) {
    int b;
    if (v < 0) return 1;
    if (hi_is_remat(h_kind[v])) return 1;
    b = h_blk[v];
    if (b < 0 || b >= bb_nblk) return 0;
    if (s370_loop_hdr[b] < 0) return 1;
    /* inside some loop: outside THIS one if its block is not in this
     * loop's body, which the header map approximates by headers */
    {
        int h;
        h = s370_loop_hdr[b];
        while (h >= 0) {
            if (h == hdr) return 0;
            h = (ssa_idom[h] >= 0 && ssa_idom[h] < bb_nblk) ? s370_loop_hdr[ssa_idom[h]] : -1;
        }
    }
    return 1;
}

/* ADD(b, ADD(a, c)) with b and c invariant in the loop and a not:
 * -> ADD(n, a) with n = ADD(b, c) hoisted to the preheader, so the
 * operand is D(a, n).  The inner ADD must have no other use. */
static void s370_hoist_bases(void) {
    int i;
    int hdr;
    int pre;
    int inner;
    int b;
    int a;
    int c;
    int n;
    int j;
    s370_find_loops();
    i = 0;
    while (i < h_ninst) { s370_use_count[i] = 0; i = i + 1; }
    i = 0;
    while (i < h_ninst) {
        int k;
        k = h_kind[i];
        if (k == HI_NOP) { i = i + 1; continue; }
        if (h_src1[i] >= 0) s370_use_count[h_src1[i]] = s370_use_count[h_src1[i]] + 1;
        if (h_src2[i] >= 0 && ho_src2_is_ref(k)) s370_use_count[h_src2[i]] = s370_use_count[h_src2[i]] + 1;
        if ((k == HI_CALL || k == HI_CALLP) && h_cbase[i] >= 0) {
            j = 0;
            while (j < h_val[i]) { if (h_carg[h_cbase[i] + j] >= 0) s370_use_count[h_carg[h_cbase[i] + j]] = s370_use_count[h_carg[h_cbase[i] + j]] + 1; j = j + 1; }
        }
        if (k == HI_PHI && h_pbase[i] >= 0) {
            j = 0;
            while (j < h_pcnt[i]) { if (h_pval[h_pbase[i] + j] >= 0) s370_use_count[h_pval[h_pbase[i] + j]] = s370_use_count[h_pval[h_pbase[i] + j]] + 1; j = j + 1; }
        }
        i = i + 1;
    }
    i = 0;
    while (i < h_ninst) {
        if (h_kind[i] == HI_ADDI && h_src1[i] >= 0 && h_kind[h_src1[i]] == HI_ADD &&
            s370_use_count[h_src1[i]] == 1 && h_blk[h_src1[i]] == h_blk[i] &&
            h_blk[i] >= 0 && h_blk[i] < bb_nblk && s370_loop_hdr[h_blk[i]] >= 0) {
            /* ADDI(ADD(b, a), c): the constant joins an invariant b in
             * the preheader, and the ADDI becomes ADD(n, a) */
            int ad;
            ad = h_src1[i];
            hdr = s370_loop_hdr[h_blk[i]];
            pre = ssa_idom[hdr];
            if (pre >= 0 && pre < bb_nblk && s370_loop_hdr[pre] != hdr) {
                b = -1; a = -1;
                if (s370_invariant_in(h_src1[ad], hdr) && !s370_invariant_in(h_src2[ad], hdr) && !bg_static_chain(h_src1[ad])) { b = h_src1[ad]; a = h_src2[ad]; }
                else if (s370_invariant_in(h_src2[ad], hdr) && !s370_invariant_in(h_src1[ad], hdr) && !bg_static_chain(h_src2[ad])) { b = h_src2[ad]; a = h_src1[ad]; }
                if (b >= 0 && h_ninst + 1 < HIR_MAX_INST) {
                    n = sp_new_inst(HI_ADDI, h_ty[i], b, -1, h_val[i], pre);
                    if (licm_tail[pre] >= 0) licm_next[licm_tail[pre]] = n;
                    else licm_head[pre] = n;
                    licm_tail[pre] = n;
                    h_kind[i] = HI_ADD;
                    h_src1[i] = n;
                    h_src2[i] = a;
                    h_val[i] = 0;
                    h_kind[ad] = HI_NOP;
                    i = i + 1;
                    continue;
                }
            }
        }
        if (h_kind[i] != HI_ADD || h_blk[i] < 0 || h_blk[i] >= bb_nblk) { i = i + 1; continue; }
        hdr = s370_loop_hdr[h_blk[i]];
        if (hdr < 0) { i = i + 1; continue; }
        pre = ssa_idom[hdr];
        if (pre < 0 || pre >= bb_nblk || s370_loop_hdr[pre] == hdr) { i = i + 1; continue; }
        inner = -1;
        b = -1;
        if (h_src2[i] >= 0 && h_kind[h_src2[i]] == HI_ADD && s370_use_count[h_src2[i]] == 1 &&
            h_blk[h_src2[i]] == h_blk[i] && s370_invariant_in(h_src1[i], hdr)) { inner = h_src2[i]; b = h_src1[i]; }
        else if (h_src1[i] >= 0 && h_kind[h_src1[i]] == HI_ADD && s370_use_count[h_src1[i]] == 1 &&
                 h_blk[h_src1[i]] == h_blk[i] && s370_invariant_in(h_src2[i], hdr)) { inner = h_src1[i]; b = h_src2[i]; }
        if (inner < 0) {
            /* ADD(b, ADDI(a, c)) with b a register base: the constant
             * cannot be a negative displacement, so it joins the base:
             * ADD(n, a) with n = ADDI(b, c) hoisted.  A static base
             * keeps its constant symbolically and needs no register. */
            int ad;
            ad = -1;
            if (h_src2[i] >= 0 && h_kind[h_src2[i]] == HI_ADDI && s370_use_count[h_src2[i]] == 1 &&
                h_blk[h_src2[i]] == h_blk[i] && s370_invariant_in(h_src1[i], hdr) &&
                !s370_invariant_in(h_src1[h_src2[i]], hdr) && !bg_static_chain(h_src1[i])) { ad = h_src2[i]; b = h_src1[i]; }
            else if (h_src1[i] >= 0 && h_kind[h_src1[i]] == HI_ADDI && s370_use_count[h_src1[i]] == 1 &&
                h_blk[h_src1[i]] == h_blk[i] && s370_invariant_in(h_src2[i], hdr) &&
                !s370_invariant_in(h_src1[h_src1[i]], hdr) && !bg_static_chain(h_src2[i])) { ad = h_src1[i]; b = h_src2[i]; }
            if (ad < 0 || h_val[ad] >= 0) { i = i + 1; continue; }
            if (h_ninst + 1 >= HIR_MAX_INST) break;
            n = sp_new_inst(HI_ADDI, h_ty[i], b, -1, h_val[ad], pre);
            if (licm_tail[pre] >= 0) licm_next[licm_tail[pre]] = n;
            else licm_head[pre] = n;
            licm_tail[pre] = n;
            h_src1[i] = n;
            h_src2[i] = h_src1[ad];
            h_kind[ad] = HI_NOP;
            i = i + 1;
            continue;
        }
        if (s370_invariant_in(h_src2[inner], hdr) && !s370_invariant_in(h_src1[inner], hdr)) { c = h_src2[inner]; a = h_src1[inner]; }
        else if (s370_invariant_in(h_src1[inner], hdr) && !s370_invariant_in(h_src2[inner], hdr)) { c = h_src1[inner]; a = h_src2[inner]; }
        else { i = i + 1; continue; }
        if (h_ninst + 1 >= HIR_MAX_INST) break;
        n = sp_new_inst(HI_ADD, h_ty[i], b, c, 0, pre);
        if (licm_tail[pre] >= 0) licm_next[licm_tail[pre]] = n;
        else licm_head[pre] = n;
        licm_tail[pre] = n;
        h_src1[i] = n;
        h_src2[i] = a;
        h_kind[inner] = HI_NOP;
        i = i + 1;
    }
}

/* ---------------------------------------------------------------- */
/* Lifting an inner loop's setup out of the enclosing loop           */
/* ---------------------------------------------------------------- */

static int s370_const_eval(int v, int *out, int depth);

/* Replace every use of value old by nw. */
static void s370_replace_uses(int old, int nw) {
    int i;
    int j;
    int k;
    i = 0;
    while (i < h_ninst) {
        k = h_kind[i];
        if (k == HI_NOP || i == nw) { i = i + 1; continue; }
        if (h_src1[i] == old) h_src1[i] = nw;
        if (h_src2[i] == old && ho_src2_is_ref(k)) h_src2[i] = nw;
        if ((k == HI_CALL || k == HI_CALLP) && h_cbase[i] >= 0) {
            j = 0;
            while (j < h_val[i]) { if (h_carg[h_cbase[i] + j] == old) h_carg[h_cbase[i] + j] = nw; j = j + 1; }
        }
        if (k == HI_PHI && h_pbase[i] >= 0) {
            j = 0;
            while (j < h_pcnt[i]) { if (h_pval[h_pbase[i] + j] == old) h_pval[h_pbase[i] + j] = nw; j = j + 1; }
        }
        i = i + 1;
    }
}

/* Does v feed, through an address chain in its own block, a load or
 * store there?  Such a chain folds in place, and moving v out of the
 * block would unfold it. */
static int s370_feeds_memop_here(int v, int depth) {
    int i;
    int k;
    if (depth > 4) return 1;
    i = 0;
    while (i < h_ninst) {
        k = h_kind[i];
        if (k == HI_NOP || h_blk[i] != h_blk[v]) { i = i + 1; continue; }
        if (h_src1[i] == v || (h_src2[i] == v && ho_src2_is_ref(k))) {
            if (k == HI_LOAD || k == HI_STORE) return 1;
            if ((k == HI_ADD || k == HI_ADDI) && s370_feeds_memop_here(i, depth + 1)) return 1;
        }
        i = i + 1;
    }
    return 0;
}

/* The passes after LICM -- strength reduction's derived induction
 * variables, s370_hoist_bases, s370_loops -- put an inner loop's setup
 * in its preheader, which is the enclosing loop's body: an index's
 * initial value, its step and limit, the bases.  Where those are
 * invariant in the enclosing loop too, they move to its preheader,
 * and the outer loop is left with the inner loop and its own
 * counting, as H's is.  Integer arithmetic only, from a block inside
 * a loop, not feeding an address that folds in that block, not a
 * static chain (which folds symbolically wherever it is).  Rounds until nothing moves (a lifted value
 * may be lifted again from the next loop out). */
/* Integer arithmetic on constants becomes the constant, in place: the
 * passes after hir_opt (strength reduction, s370_loops) build such
 * expressions for an index's initial value, step and limit.  A pinned
 * one stays pinned (a constant in a register materializes once). */
static void s370_fold_consts(void) {
    int i;
    int k;
    int c;
    i = 0;
    while (i < h_ninst) {
        k = h_kind[i];
        if ((k == HI_ADD || k == HI_ADDI || k == HI_SUB || k == HI_MUL || k == HI_SLL) &&
            !ty_is_fp(h_ty[i]) && s370_const_eval(i, &c, 0)) {
            h_kind[i] = HI_ICONST;
            h_src1[i] = -1;
            h_src2[i] = -1;
            h_val[i] = c;
        }
        i = i + 1;
    }
}

static void s370_rehoist(void) {
    int i;
    int k;
    int b;
    int hdr;
    int pre;
    int n;
    int c;
    int round;
    int moved;
    if (getenv("F77_NO_REHOIST")) return;
    round = 0;
    for (;;) {
        moved = 0;
        s370_fold_consts();
        s370_find_loops();
        i = 0;
        while (i < h_ninst) {
            k = h_kind[i];
            if (!(k == HI_ADD || k == HI_ADDI || k == HI_SUB || k == HI_MUL || k == HI_SLL ||
                  k == HI_SRL || k == HI_SRA || k == HI_AND || k == HI_OR || k == HI_XOR)) { i = i + 1; continue; }
            /* a pinned constant (a BXLE's step or limit) stays where it
             * is: one LA per outer iteration, against a register pair
             * held across every enclosing loop, which matmul's three
             * nested loops could not afford -- the pair went uncoloured
             * and the loop lost its BXLE */
            if (h_no_remat[i] && hi_is_remat(k)) { i = i + 1; continue; }
            if (ty_is_fp(h_ty[i])) { i = i + 1; continue; }
            b = h_blk[i];
            if (b < 0 || b >= bb_nblk) { i = i + 1; continue; }
            hdr = s370_loop_hdr[b];
            if (hdr < 0) { i = i + 1; continue; }
            pre = ssa_idom[hdr];
            if (pre < 0 || pre >= bb_nblk || pre == hdr || s370_loop_hdr[pre] == hdr) { i = i + 1; continue; }
            if (!s370_invariant_in(h_src1[i], hdr)) { i = i + 1; continue; }
            if (ho_src2_is_ref(k) && !s370_invariant_in(h_src2[i], hdr)) { i = i + 1; continue; }
            if (s370_feeds_memop_here(i, 0)) { i = i + 1; continue; }
            if (bg_static_chain(i)) { i = i + 1; continue; }   /* folds symbolically anywhere */
            if (h_ninst + 1 >= HIR_MAX_INST) return;
            {
                n = sp_new_inst(k, h_ty[i], h_src1[i], ho_src2_is_ref(k) ? h_src2[i] : -1, h_val[i], pre);
                h_no_remat[n] = h_no_remat[i];
                ra_pair_of[n] = -1; ra_pair_lo[n] = 0;
                if (ra_pair_of[i] >= 0) {
                    ra_pair_of[n] = ra_pair_of[i];
                    ra_pair_lo[n] = ra_pair_lo[i];
                    ra_pair_of[ra_pair_of[i]] = n;
                    ra_pair_of[i] = -1;
                }
            }
            if (licm_tail[pre] >= 0) licm_next[licm_tail[pre]] = n;
            else licm_head[pre] = n;
            licm_tail[pre] = n;
            s370_replace_uses(i, n);
            if (getenv("F77_REHOIST_DEBUG")) {
                fdputs("REHOIST ", 2); fdputuint(2, (unsigned)i); fdputs(" ", 2); fdputs(bg_op_name(k), 2);
                fdputs(" s1=", 2); fdputs(h_src1[i] >= 0 ? bg_op_name(h_kind[h_src1[i]]) : "-", 2);
                fdputs(" s2=", 2); fdputs((ho_src2_is_ref(k) && h_src2[i] >= 0) ? bg_op_name(h_kind[h_src2[i]]) : "-", 2);
                fdputs(" pin=", 2); fdputuint(2, (unsigned)h_no_remat[i]);
                fdputs(" -> ", 2); fdputuint(2, (unsigned)n); fdputs(" ", 2); fdputs(bg_op_name(h_kind[n]), 2);
                fdputs(" blk ", 2); fdputuint(2, (unsigned)b); fdputs(" -> ", 2); fdputuint(2, (unsigned)pre); fdputc(10, 2);
            }
            h_kind[i] = HI_NOP;
            moved = moved + 1;
            i = i + 1;
        }
        round = round + 1;
        if (moved == 0 || round >= 8) break;
    }
}

/* ---------------------------------------------------------------- */
/* Counted loops: BXLE                                               */
/* ---------------------------------------------------------------- */

/* A loop whose latch tests a trip count (t' = t-1; continue while
 * t' > 0) and that steps an index p by a positive constant s (p' = p
 * + s) can test the index instead: continue while p' <= L, with L =
 * i0 - s + N*s computed once before the loop.  Then BXLE p',s,top does
 * the step, the test and the branch in one instruction, as H's loops
 * do, and the trip count disappears. */
/* Evaluate a constant expression: ICONST, and ADDI/ADD/SUB/SLL/MUL of
 * constants (what the strength reducer leaves for a step). */
static int s370_const_eval(int v, int *out, int depth) {
    int a;
    int b;
    int k;
    if (v < 0 || depth > 8) return 0;
    k = bg_kind(v);
    if (k == HI_ICONST) { *out = h_val[v]; return 1; }
    if (k == HI_COPY) return s370_const_eval(h_src1[v], out, depth + 1);
    if (k == HI_ADDI) { if (!s370_const_eval(h_src1[v], &a, depth + 1)) return 0; *out = a + h_val[v]; return 1; }
    if (k == HI_ADD || k == HI_SUB || k == HI_SLL || k == HI_MUL) {
        if (!s370_const_eval(h_src1[v], &a, depth + 1) || !s370_const_eval(h_src2[v], &b, depth + 1)) return 0;
        if (k == HI_ADD) *out = a + b;
        else if (k == HI_SUB) *out = a - b;
        else if (k == HI_SLL) *out = (b >= 0 && b < 32) ? (int)((unsigned)a << b) : 0;
        else *out = a * b;
        return 1;
    }
    return 0;
}

static int s370_phi_arg_from(int phi, int blk) {
    int j;
    j = 0;
    while (j < h_pcnt[phi]) {
        if (h_pblk[h_pbase[phi] + j] == blk) return h_pval[h_pbase[phi] + j];
        j = j + 1;
    }
    return -1;
}

static void s370_loops(void) {
    int i;
    int b;
    int cmp;
    int t1;
    int tphi;
    int zero;
    int hdr;
    int pre;
    int latch;
    int p;
    int p1;
    int step;
    int n0;
    int i0;
    int c;
    int root;
    int sh;
    int m;
    int a;
    int lim;
    int j;

    i = 0;
    while (i < h_ninst) { s370_bxle_add[i] = -1; s370_bxle_brc[i] = -1; i = i + 1; }
    /* use counts, for the trip count's other uses */
    i = 0;
    while (i < h_ninst) { s370_use_count[i] = 0; i = i + 1; }
    i = 0;
    while (i < h_ninst) {
        int k;
        k = h_kind[i];
        if (k == HI_NOP) { if (getenv("F77_LOOP_DEBUG")) { fdputs("  reject 1\n", 2); } i = i + 1; continue; }
        if (h_src1[i] >= 0) s370_use_count[h_src1[i]] = s370_use_count[h_src1[i]] + 1;
        if (h_src2[i] >= 0 && ho_src2_is_ref(k)) s370_use_count[h_src2[i]] = s370_use_count[h_src2[i]] + 1;
        if ((k == HI_CALL || k == HI_CALLP) && h_cbase[i] >= 0) {
            j = 0;
            while (j < h_val[i]) { if (h_carg[h_cbase[i] + j] >= 0) s370_use_count[h_carg[h_cbase[i] + j]] = s370_use_count[h_carg[h_cbase[i] + j]] + 1; j = j + 1; }
        }
        if (k == HI_PHI && h_pbase[i] >= 0) {
            j = 0;
            while (j < h_pcnt[i]) { if (h_pval[h_pbase[i] + j] >= 0) s370_use_count[h_pval[h_pbase[i] + j]] = s370_use_count[h_pval[h_pbase[i] + j]] + 1; j = j + 1; }
        }
        i = i + 1;
    }

    i = 0;
    while (i < h_ninst) {
        if (h_kind[i] != HI_BRC) { if (getenv("F77_LOOP_DEBUG")) { fdputs("  reject 2\n", 2); } i = i + 1; continue; }
        latch = h_blk[i];
        hdr = h_src2[i];                 /* the taken target: the loop header */
        cmp = h_src1[i];
        if (getenv("F77_LOOP_DEBUG")) {
            fdputs("LOOP brc=", 2); fdputuint(2, (unsigned)i);
            fdputs(" cmp=", 2); fdputuint(2, (unsigned)cmp);
            fdputs(" kind=", 2); fdputs(cmp >= 0 ? bg_op_name(h_kind[cmp]) : "-", 2);
            fdputs(" uses=", 2); fdputuint(2, cmp >= 0 ? (unsigned)s370_use_count[cmp] : 0);
            fdputc(10, 2);
        }
        if (cmp < 0 || h_kind[cmp] != HI_SGT || h_blk[cmp] != latch || s370_use_count[cmp] != 1) { if (getenv("F77_LOOP_DEBUG")) { fdputs("  reject 3\n", 2); } i = i + 1; continue; }
        t1 = h_src1[cmp];
        zero = h_src2[cmp];
        if (t1 < 0 || zero < 0 || h_kind[t1] != HI_ADDI || h_val[t1] != -1 || h_blk[t1] != latch) { if (getenv("F77_LOOP_DEBUG")) { fdputs("  reject 4\n", 2); } i = i + 1; continue; }
        if (!(bg_const_imm_inst(zero, &c, &root) && c == 0)) { if (getenv("F77_LOOP_DEBUG")) { fdputs("  reject 5\n", 2); } i = i + 1; continue; }
        tphi = h_src1[t1];
        if (tphi < 0 || h_kind[tphi] != HI_PHI || h_blk[tphi] != hdr || h_pcnt[tphi] != 2) { if (getenv("F77_LOOP_DEBUG")) { fdputs("  reject 6\n", 2); } i = i + 1; continue; }
        if (s370_phi_arg_from(tphi, latch) != t1) { if (getenv("F77_LOOP_DEBUG")) { fdputs("  reject 7\n", 2); } i = i + 1; continue; }
        /* the trip count must be the test's alone: the phi feeds the
         * decrement, the decrement feeds the phi and the compare */
        if (s370_use_count[tphi] != 1 || s370_use_count[t1] != 2) { if (getenv("F77_LOOP_DEBUG")) { fdputs("  reject 8\n", 2); } i = i + 1; continue; }
        pre = -1;
        j = 0;
        while (j < 2) { if (h_pblk[h_pbase[tphi] + j] != latch) { pre = h_pblk[h_pbase[tphi] + j]; n0 = h_pval[h_pbase[tphi] + j]; } j = j + 1; }
        if (pre < 0 || n0 < 0) { if (getenv("F77_LOOP_DEBUG")) { fdputs("  reject 9\n", 2); } i = i + 1; continue; }
        if (pre != ssa_idom[hdr]) { if (getenv("F77_LOOP_DEBUG")) { fdputs("  reject 10\n", 2); } i = i + 1; continue; }

        /* an index: a header phi stepped by a positive constant */
        p = ssa_phi_head[hdr];
        p1 = -1;
        step = -1;
        while (p >= 0) {
            if (h_kind[p] == HI_PHI && p != tphi && h_pcnt[p] == 2 && !ra_is_fpv(p)) {
                int q;
                q = s370_phi_arg_from(p, latch);
                if (q >= 0 && h_kind[q] == HI_ADD && h_blk[q] == latch && s370_use_count[q] == 1) {
                    int o;
                    o = -1;
                    if (h_src1[q] == p) o = h_src2[q];
                    else if (h_src2[q] == p) o = h_src1[q];
                    if (o >= 0 && s370_const_eval(o, &c, 0) && c > 0 &&
                        h_blk[o] != latch && h_blk[o] != hdr) {
                        p1 = q;
                        step = o;
                        break;
                    }
                }
            }
            p = ssa_phi_next[p];
        }
        if (p1 < 0) {
            /* No index, only the trip count: count it down with BXH,
             * t' = t + (-1), continue while t' > 0, the -1 and the 0 a
             * register pair as a BXLE's step and limit are.  An outer
             * loop whose own variable went unused is this shape. */
            if (h_ninst + 2 >= HIR_MAX_INST) { if (getenv("F77_LOOP_DEBUG")) { fdputs("  reject 11\n", 2); } i = i + 1; continue; }
            step = sp_new_inst(HI_ICONST, TY_INT, -1, -1, -1, pre);
            lim = sp_new_inst(HI_ICONST, TY_INT, -1, -1, 0, pre);
            if (licm_tail[pre] >= 0) licm_next[licm_tail[pre]] = step;
            else licm_head[pre] = step;
            licm_next[step] = lim;
            licm_tail[pre] = lim;
            h_no_remat[step] = 1;
            h_no_remat[lim] = 1;
            ra_pair_of[step] = lim; ra_pair_lo[step] = 1;
            ra_pair_of[lim] = step; ra_pair_lo[lim] = 0;
            h_kind[t1] = HI_ADD;
            h_src2[t1] = step;
            h_val[t1] = 0;
            h_src2[cmp] = lim;
            s370_bxle_add[i] = t1;
            s370_bxle_brc[t1] = i;
            i = i + 1;
            continue;
        }
        i0 = s370_phi_arg_from(p, pre);
        if (i0 < 0) { if (getenv("F77_LOOP_DEBUG")) { fdputs("  reject 12\n", 2); } i = i + 1; continue; }
        if (h_ninst + 6 >= HIR_MAX_INST) { if (getenv("F77_LOOP_DEBUG")) { fdputs("  reject 13\n", 2); } i = i + 1; continue; }

        /* L = (i0 - s) + N*s, in the preheader's hoist list */
        s370_const_eval(step, &c, 0);
        a = sp_new_inst(HI_ADDI, TY_INT, i0, -1, 0 - c, pre);
        sh = -1;
        while ((1 << (sh + 1)) <= c) sh = sh + 1;
        if ((1 << sh) == c) {
            int k;
            k = sp_new_inst(HI_ICONST, TY_INT, -1, -1, sh, pre);
            m = sp_new_inst(HI_SLL, TY_INT, n0, k, 0, pre);
        } else {
            int k;
            k = sp_new_inst(HI_ICONST, TY_INT, -1, -1, c, pre);
            m = sp_new_inst(HI_MUL, TY_INT, n0, k, 0, pre);
        }
        lim = sp_new_inst(HI_ADD, TY_INT, a, m, 0, pre);
        /* append to the preheader's list */
        {
            int q;
            q = a;
            while (q <= lim) {
                if (licm_tail[pre] >= 0) licm_next[licm_tail[pre]] = q;
                else licm_head[pre] = q;
                licm_tail[pre] = q;
                q = q + 1;
            }
        }
        h_no_remat[lim] = 1;
        h_no_remat[step] = 1;
        ra_pair_of[step] = lim; ra_pair_lo[step] = 1;
        ra_pair_of[lim] = step; ra_pair_lo[lim] = 0;

        /* the compare becomes p' <= L; the trip count goes */
        h_kind[cmp] = HI_SLE;
        h_src1[cmp] = p1;
        h_src2[cmp] = lim;
        h_kind[t1] = HI_NOP;
        h_kind[tphi] = HI_NOP;
        s370_bxle_add[i] = p1;
        s370_bxle_brc[p1] = i;
        i = i + 1;
    }
}

/* Can this BRC be a BXLE, given the registers?  The increment even,
 * the limit in the register above it, the stepped index in a register. */
static int s370_bxle_ok(int brc) {
    int p1;
    int step;
    int lim;
    int cmp;
    p1 = s370_bxle_add[brc];
    if (p1 < 0) return 0;
    cmp = hcg_brc_fuse[brc];
    if (cmp < 0) return 0;
    lim = h_src2[cmp];
    /* the ADD's operands: the index phi, and the step */
    if (h_src1[p1] >= 0 && h_kind[h_src1[p1]] == HI_PHI) step = h_src2[p1];
    else step = h_src1[p1];
    if (ra_reg[p1] < 0 || ra_reg[step] < 0 || ra_reg[lim] < 0) return 0;
    if (ra_reg[step] & 1) return 0;
    if (ra_reg[lim] != ra_reg[step] + 1) return 0;
    return 1;
}

static void s370_emit_csect(Node *fn, char *csect, int size_only);
static void s370_emit_code(Node *fn, char *csect);
static int s370_area_end(void);
static void s370_gen_unit(Node *fn) {
    int b;
    int attempt;
    char csect_name[16];

    s370_cur_unit = fn->unit;
    s370_unit_is_main = (f77_ukind[fn->unit] == F77_UNIT_PROGRAM);
    {
        int nerr;
        nerr = f77_nerr;
        hl_func(fn);
        /* the front end reported an error: the unit's HIR is incomplete,
         * and generating from it would only bury the message */
        if (f77_nerr > nerr) return;
    }

    { int z; z = 0; while (z < HIR_MAX_INST) { bg_fold[z] = 0; bg_memop[z] = 0; bg_mem_lnt[z] = -1; z = z + 1; } }
    ssa_split_pairs = 0;
    if (getenv("F77_HIR0")) ra_dump_intervals(fn->name);     /* the HIR as parsed */
    hir_ssa_construct();
    if (getenv("F77_HIR1")) ra_dump_intervals(fn->name);     /* after SSA construction */
    hir_opt();
    if (getenv("F77_HIR2")) ra_dump_intervals(fn->name);     /* after hir_opt */
    if (!getenv("F77_NO_REASSOC")) { s370_reassoc(); hir_opt(); }   /* the second hir_opt merges the shifted indexes */
    licm_cheap_fn = s370_cheap_operand;
    licm_loopopt = 1;
    licm_split_on = getenv("F77_SPLIT") ? 1 : 0;   /* the allocator's own spilling serves; see s370_rehoist */
    licm_no_ptr_iv = getenv("F77_NO_IDX") ? 0 : 1;
    if (ho_mask & 1024) hir_licm();

    s370_npool = 0;
    s370_ntmp = 0;
    s370_tmp_next = 0;
    s370_npl = 0;
    s370_plist_lbl = -1;
    s370_plist_n = 0;
    s370_lbl_base = cg_lbl;
    s370_area_lbl = cg_label();
    s370_pc = 0;
    s370_mark_strings();
    s370_layout();
    s370_mark_loop_consts();
    { int z; z = 0; while (z < h_ninst + 16 && z < HIR_MAX_INST) { ra_pair_of[z] = -1; ra_pair_lo[z] = 0; z = z + 1; } }
    if (!getenv("F77_NO_HOIST")) s370_hoist_bases();
    if (!getenv("F77_NO_BXLE")) s370_loops();
    s370_rehoist();
    { int z; z = h_ninst; while (z < HIR_MAX_INST) { ra_pair_of[z] = -1; z = z + 1; } }
    hir_burg();
    hcg_identify_fusions();

    /* Register allocation; a spill region past the data bases' reach
     * costs another base and a second try. */
    s370_layout_blocks();
    b = 0;
    while (b < bb_nblk) { hcg_blk_lbl[b] = cg_label(); b = b + 1; }
    hcg_epilog = cg_label();
    strcpy(csect_name, s370_extname(fn->name));   /* the buffer is reused by callee names */

    /* Register allocation, then a sizing of the code (which fills the
     * constant pool: a far branch costs an address constant); a static
     * area past the data bases' reach costs another base and a second
     * try. */
    attempt = 0;
    for (;;) {
        int save_ts;
        ra_gpr_avail = RA_NGPR - (s370_nbases - 1);
        save_ts = hl_temp_stack;
        hir_regalloc();
        s370_emit_csect(fn, csect_name, 1);
        if (s370_area_end_sized + 256 <= s370_near_limit || attempt >= 2 || s370_nbases >= 3) break;
        s370_nbases = s370_nbases + 1;
        s370_near_limit = 4096 * s370_nbases;
        hl_temp_stack = save_ts;
        attempt = attempt + 1;
    }

    if (getenv("F77_DUMP")) ra_dump_intervals(fn->name);

    s370_emit_csect(fn, csect_name, 0);
    s370_emit_area();
}

/* The CSECT, in a sizing pass first: branch targets 4K or more past
 * the code base are far and need the longer form, which moves later
 * labels further still, so the sizing repeats until no label turns
 * far (a 25K unit took eleven passes); then the real pass.  Everything the emission allocates (labels,
 * pool entries, temporaries, parameter lists, global labels) is
 * restored between passes so that every pass numbers alike. */
static int s370_glbl_save[P_MAX_GLOBALS];
static void s370_emit_csect(Node *fn, char *csect, int size_only) {
    int sv_lbl;
    int sv_npool;
    int sv_ntmp;
    int sv_npl;
    int sv_plist_lbl;
    int sv_plist_n;
    int pass;
    int l;
    int changed;
    sv_lbl = cg_lbl;
    sv_npool = s370_npool;
    sv_ntmp = s370_ntmp;
    sv_npl = s370_npl;
    sv_plist_lbl = s370_plist_lbl;
    sv_plist_n = s370_plist_n;
    memcpy(s370_glbl_save, s370_glbl, sizeof(s370_glbl));
    l = 0;
    while (l < S370_MAX_ULBL) { s370_far[l] = 0; l = l + 1; }
    pass = 0;
    for (;;) {
        cg_lbl = sv_lbl;
        l = sv_npool;
        while (l < s370_npool) { if (s370_pk_name[l]) free(s370_pk_name[l]); s370_pk_name[l] = 0; l = l + 1; }
        s370_npool = sv_npool;
        s370_ntmp = sv_ntmp;
        s370_npl = sv_npl;
        s370_plist_lbl = sv_plist_lbl;
        s370_plist_n = sv_plist_n;
        memcpy(s370_glbl, s370_glbl_save, sizeof(s370_glbl));
        s370_pc = 0;
        l = 0;
        while (l < S370_MAX_ULBL) { s370_lbl_pc[l] = -1; l = l + 1; }
        cg_dry = (pass < 256);
        s370_emit_code(fn, csect);
        if (!cg_dry) break;
        if (size_only && pass > 0 && !s370_sizing_changed) break;   /* the pool is as full as it gets */
        changed = 0;
        l = 0;
        while (l < cg_lbl - s370_lbl_base && l < S370_MAX_ULBL) {
            if (s370_lbl_pc[l] >= 0 && s370_lbl_pc[l] - s370_code_base >= 4096 && !s370_far[l]) { s370_far[l] = 1; changed = 1; }
            l = l + 1;
        }
        if (getenv("F77_FAR_DEBUG")) {
            int nf;
            nf = 0;
            l = 0;
            while (l < cg_lbl - s370_lbl_base && l < S370_MAX_ULBL) { if (s370_far[l]) nf = nf + 1; l = l + 1; }
            fdputs("FAR pass=", 2); fdputuint(2, (unsigned)pass); fdputs(" code=", 2); fdputuint(2, (unsigned)s370_pc);
            fdputs(" labels=", 2); fdputuint(2, (unsigned)(cg_lbl - s370_lbl_base)); fdputs(" far=", 2); fdputuint(2, (unsigned)nf);
            fdputs(" changed=", 2); fdputuint(2, (unsigned)changed); fdputc(10, 2);
        }
        s370_sizing_changed = changed;
        pass = pass + 1;
        if (!changed) { if (size_only) break; pass = 256; }   /* stable: the next pass is the real one */
    }
    cg_dry = 0;
    if (size_only) {
        /* the measure the caller wants, then everything back as it
         * was: the real emission numbers its labels from here again */
        s370_area_end_sized = s370_area_end();
        cg_lbl = sv_lbl;
        l = sv_npool;
        while (l < s370_npool) { if (s370_pk_name[l]) free(s370_pk_name[l]); s370_pk_name[l] = 0; l = l + 1; }
        s370_npool = sv_npool;
        s370_ntmp = sv_ntmp;
        s370_npl = sv_npl;
        s370_plist_lbl = sv_plist_lbl;
        s370_plist_n = sv_plist_n;
        memcpy(s370_glbl, s370_glbl_save, sizeof(s370_glbl));
    }
}

/* The static area's extent after the code has been sized: header,
 * near objects, spill slots, temporaries, parameter list, jump tables
 * and the constant pool (s370_emit_area lays them out in this order). */
static int s370_area_end(void) {
    int off;
    int i;
    off = s370_spill_base + 8 * ra_nslots + 8 * s370_ntmp;
    if (s370_plist_lbl >= 0) off = off + 4 * s370_plist_n;
    i = 0;
    while (i < s370_npl) { if (s370_pl_n[i] < 0) off = off + 4 * hjt_span[-s370_pl_n[i] - 1]; else off = off + 4 * s370_pl_n[i]; i = i + 1; }
    off = (off + 7) & ~7;
    i = 0;
    while (i < s370_npool) {
        int k;
        k = s370_pk_kind[i];
        off = off + ((k == S370_PK_D) ? 8 : (k == S370_PK_H) ? 2 : 4);
        i = i + 1;
    }
    return off + 8;
}

static void s370_emit_code(Node *fn, char *csect) {
    int q;
    /* --- the CSECT --- */
    asm_comment(fn->name);
    asm_stmt(csect, "CSECT", "");
    asm_stmt("", "USING", "*,15");
    f_reset(); f_s(s370_lab('L', hcg_blk_lbl[0] + 0)); /* placeholder, replaced below */
    {
        int lent;
        lent = cg_label();
        f_reset(); f_s(s370_lab('L', lent));
        asm_ins("B", s370_line, 4);
        f_reset(); f_s("AL1("); f_n((int)strlen(csect)); f_s("),CL7'"); f_s(csect); f_c('\'');
        asm_stmt("", "DC", s370_line); s370_pc = s370_pc + 8;
        asm_stmt(s370_lab('L', lent), "STM", "14,12,12(13)");
        s370_pc = s370_pc + 4;
    }
    asm_ins("BALR", "12,0", 2);
    asm_stmt("", "USING", "*,12");
    asm_stmt("", "DROP", "15");
    s370_code_base = s370_pc;
    {
        int lgo;
        int lac;
        lgo = cg_label();
        lac = cg_label();
        f_reset(); f_s(s370_lab('L', lgo)); asm_ins("B", s370_line, 4);
        f_reset(); f_s("A("); f_s(s370_lab('S', s370_area_lbl)); f_c(')');
        s370_pc = (s370_pc + 3) & ~3;   /* the assembler aligns the A-constant */
        asm_stmt(s370_lab('L', lac), "DC", s370_line); s370_pc = s370_pc + 4;
        if (s370_unit_is_main && !s370_crt_on()) {
            int lib;
            lib = cg_label();
            asm_stmt(s370_lab('L', lib), "DC", "V(IBCOM#)"); s370_pc = s370_pc + 4;
            f_reset(); f_s("15,"); f_s(s370_lab('L', lib));
            asm_stmt(s370_lab('L', lgo), "L", s370_line); s370_pc = s370_pc + 4;
            asm_ins("BAL", "14,64(,15)", 4);
            f_reset(); f_s("15,"); f_s(s370_lab('L', lac));
            asm_ins("L", s370_line, 4);
        } else {
            f_reset(); f_s("15,"); f_s(s370_lab('L', lac));
            asm_stmt(s370_lab('L', lgo), "L", s370_line); s370_pc = s370_pc + 4;
        }
    }
    asm_ins("ST", "13,4(,15)", 4);
    asm_ins("ST", "15,8(,13)", 4);
    if (s370_crt_on()) asm_ins("MVC", "76(4,15),76(13)", 6);   /* the C runtime's stack pointer travels */
    asm_ins("LR", "13,15", 2);
    f_reset(); f_s(s370_lab('S', s370_area_lbl)); f_s(",13");
    asm_stmt("", "USING", s370_line);
    if (s370_nbases >= 2) {
        asm_ins("LA", "11,2048(,13)", 4);
        asm_ins("LA", "11,2048(,11)", 4);
        f_reset(); f_s(s370_lab('S', s370_area_lbl)); f_s("+4096,11");
        asm_stmt("", "USING", s370_line);
    }
    if (s370_nbases >= 3) {
        asm_ins("LA", "10,2048(,11)", 4);
        asm_ins("LA", "10,2048(,10)", 4);
        f_reset(); f_s(s370_lab('S', s370_area_lbl)); f_s("+8192,10");
        asm_stmt("", "USING", s370_line);
    }
    f_reset(); f_s("1,"); f_s(s370_hdr(S370_HDR_PARM));
    asm_ins("ST", s370_line, 4);

    s370_r1_intact = 1;
    s370_scache_clear();
    q = 0;
    while (q < bb_nblk) { s370_block(hcg_emit_ord[q]); q = q + 1; }

    /* epilogue: H's, leaving R0 (and FPR0) as they are */
    asm_stmt(s370_lab('L', hcg_epilog), "DS", "0H");
    asm_ins("L", "13,4(,13)", 4);
    asm_ins("L", "14,12(,13)", 4);
    asm_ins("LM", "2,12,28(13)", 4);
    asm_ins("SR", "15,15", 2);
    asm_ins("BR", "14", 2);
}

/* ---------------------------------------------------------------- */
/* Global data: COMMON blocks and SAVE'd statics                     */
/* ---------------------------------------------------------------- */

static void s370_emit_image(unsigned char *p, int n) {
    int i;
    int c;
    i = 0;
    while (i < n) {
        c = 0;
        f_reset();
        f_s("X'");
        while (i < n && c < 24) {
            f_c("0123456789ABCDEF"[p[i] >> 4]);
            f_c("0123456789ABCDEF"[p[i] & 15]);
            i = i + 1;
            c = c + 1;
        }
        f_c('\'');
        asm_stmt("", "DC", s370_line);
    }
}

static void gen_data(void) {
    int i;
    char *nm;
    i = 0;
    while (i < ps_nglobals) {
        if (ps_gextern[i]) { i = i + 1; continue; }
        nm = s370_gname(ps_gname[i]);
        if (nm[0] == 'G' && s370_glbl[i] == 0) { i = i + 1; continue; }   /* never referenced */
        if (strncmp(ps_gname[i], "f77c_", 5) != 0 && s370_glbl[i] == 0) { i = i + 1; continue; }
        if (ps_ginit_start[i] >= 0) {
            /* initialized: a named CSECT with its image (DATA in a
             * COMMON block is BLOCK DATA's business in Fortran; here
             * the compiler lays the image down itself) */
            asm_stmt(nm, "CSECT", "");
            asm_stmt("", "DS", "0D");
            if (ps_girel_count[i] > 0) cg_die("relocations in a data image", -1);
            s370_emit_image(ps_ginit_pool + ps_ginit_start[i], ps_ginit_count[i]);
            if (ps_gsize[i] > ps_ginit_count[i]) {
                f_reset(); f_s("XL"); f_n(ps_gsize[i] - ps_ginit_count[i]);
                asm_stmt("", "DS", s370_line);
            }
        } else {
            /* uninitialized: a CSECT of reserved storage.  COM would be
             * the assembler's word for it, but as370 has no COM, and
             * the whole program is compiled at once, so each block is
             * defined exactly once anyway. */
            int n;
            n = ps_gsize[i] > 0 ? ps_gsize[i] : 8;
            asm_stmt(nm, "CSECT", "");
            asm_stmt("", "DS", "0D");
            if (n > 65535) { f_reset(); f_n((n + 7) / 8); f_c('D'); }   /* DS XL stops at 65535 */
            else { f_reset(); f_s("XL"); f_n(n); }
            asm_stmt("", "DS", s370_line);
        }
        i = i + 1;
    }
}

static void gen_program(Node *prog) {
    Node *fn;
    int i;
    i = 0;
    while (i < LEX_MAX_STRINGS) { s370_str_unit[i] = -1; i = i + 1; }
    fn = prog->body;
    while (fn) {
        s370_gen_unit(fn);
        fn = fn->next;
    }
    gen_data();
    asm_stmt("", "END", "");
}

/* Driver compatibility: statistics the SLOW-32 build prints. */
static int hcg_dbg_addi[6];
static int ra_pc_dbg[6];
static int ra_stat_pair_pref;
