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

#define CG_MAX_OUT 262144   /* fort370: one unit in an 8MB region, docs/FITTING.md */
static char cg_out[CG_MAX_OUT];
static int  cg_olen;
static int  cg_fd = -1;
static char *cg_outpath;

static void cg_flush(void) {
    int off;
    int n;
    if (cg_fd < 0) { cg_olen = 0; return; }
    off = 0;
    while (off < cg_olen) {
        n = write(cg_fd, &cg_out[off], cg_olen - off);
        if (n <= 0) { fdputs("f77: write failed\n", 2); exit(1); }
        off = off + n;
    }
    cg_olen = 0;
}

static void cg_c(int ch) {
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

static void asm_stmt(char *label, char *op, char *operands) {
    int col;
    int i;
    char *p;
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

/* Machine instruction with a byte length, so alignment is known. */
static void asm_ins(char *op, char *operands, int len) {
    asm_stmt("", op, operands);
    s370_pc = s370_pc + len;
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
static char s370_nbuf[12];
static char *s370_extname(char *name) {
    int i;
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
        s370_nbuf[i] = (char)((name[i] >= 'a' && name[i] <= 'z') ? name[i] - 32 : name[i]);
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
#define S370_HDR_PHIT   104   /* phi-copy cycle temporary */
#define S370_HDR_SIZE   112

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
    s370_pk_name[i] = name;
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

/* Floating register to compute a spilled result in: a free one, else
 * FPR6 parked in the scratch doubleword for the duration. */
static int s370_borrow_fpr(void) {
    int r;
    r = 0;
    while (r <= 6) {
        if (s370_fpr_free_at(r, s370_cur_pos)) return r;
        r = r + 2;
    }
    f_reset(); f_s("6,"); f_s(s370_hdr(S370_HDR_FTMP));
    asm_ins("STD", s370_line, 4);
    s370_fpr_saved = 6;
    return 6;
}

static void s370_return_fpr(void) {
    if (s370_fpr_saved >= 0) {
        f_reset(); f_s("6,"); f_s(s370_hdr(S370_HDR_FTMP));
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
        if (h_kind[chain] == HI_COPY) { chain = h_src1[chain]; lim = lim + 1; continue; }
        if (h_kind[chain] == HI_ADDI) { o = o + h_val[chain]; chain = h_src1[chain]; lim = lim + 1; continue; }
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
    s370_load_into(s, v);
    return s;
}

/* Storage-operand text for an integer value that is not in a register:
 * a spill slot or a pool constant.  Returns 0 if v is in a register. */
static int s370_imem(int v, char *out) {
    int c;
    int root;
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
    k = h_kind[v];
    if (bg_const_imm_inst(v, &c, &root) && hi_inst_remat(root)) {
        if (c >= 0 && c <= 4095) { f_reset(); f_s(s370_r(d)); f_c(','); f_n(c); asm_ins("LA", s370_line, 4); }
        else if (c >= -32768 && c <= 32767) { f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_pool_h(c)); asm_ins("LH", s370_line, 4); }
        else { f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_pool_f(c)); asm_ins("L", s370_line, 4); }
        return;
    }
    if (k == HI_ALLOCA && hi_inst_remat(v)) {
        if (s370_aoff[v] >= 0) { f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_lab('T', s370_alab[v])); asm_ins("LA", s370_line, 4); }
        else { f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_pool_at(s370_alab[v], 0)); asm_ins("L", s370_line, 4); }
        return;
    }
    if ((k == HI_ADDI) && hi_inst_remat(v) == 0 && ra_spill_off[v] == 0) {
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
        f_reset(); f_s(s370_r(d)); f_c(','); f_s(mem); asm_ins("L", s370_line, 4);
        return;
    }
    cg_die("cannot materialize value", v);
}

/* Address of a near ALLOCA chain as symbolic text: Tnnnnn+off. */
static char s370_abuf[40];
static char *s370_faddr_text(int addr) {
    int rt;
    char *save;
    rt = bg_faddr_root(addr);
    save = fmt_p;
    fmt_p = s370_abuf;
    f_s(s370_lab('T', s370_alab[rt]));
    if (bg_foff[addr] > 0) { f_c('+'); f_n(bg_foff[addr]); }
    else if (bg_foff[addr] < 0) f_n(bg_foff[addr]);
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
    if (s370_fold_chain(addr, &base, &off)) {
        b = s370_gpr(base, s);
    } else {
        off = 0;
        b = s370_gpr(addr, s);
    }
    fmt_p = s370_mbuf; f_n(off); f_s("(,"); f_s(s370_r(b)); f_c(')'); fmt_p = save;
    return s370_mbuf;
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
static void s370_branch(int mask, int lbl) {
    if (mask == 15) { f_reset(); f_s(s370_lab('L', lbl)); asm_ins("B", s370_line, 4); return; }
    f_reset(); f_n(mask); f_c(','); f_s(s370_lab('L', lbl));
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
            if (ph_src[n] < 0) cg_die("phi without an argument for this edge", i);
            n = n + 1;
        }
        i = ssa_phi_next[i];
    }
    if (n == 0) return;

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
                    /* stage the new value in PHIT, copy it in at the end */
                    ph_done[i] = 2;
                    if (ra_is_fpv(phi)) {
                        char mem[40];
                        if (ra_reg[ph_src[i]] >= 0) { f_reset(); f_s(s370_r(ra_reg[ph_src[i]])); f_c(','); f_s(s370_hdr(S370_HDR_PHIT)); asm_ins("STD", s370_line, 4); }
                        else if (s370_fmem(ph_src[i], mem)) { f_reset(); f_s(s370_hdr(S370_HDR_PHIT)); f_s("(8),"); f_s(mem); asm_ins("MVC", s370_line, 6); }
                    } else {
                        s370_load_into(14, ph_src[i]);
                        f_reset(); f_s("14,"); f_s(s370_hdr(S370_HDR_PHIT)); asm_ins("ST", s370_line, 4);
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
            if (pfp) { f_reset(); f_s(s370_r(preg)); f_c(','); f_s(s370_hdr(S370_HDR_PHIT)); asm_ins("STD", s370_line, 4); }
            else { f_reset(); f_s("0,"); f_s(s370_r(preg)); asm_ins("LR", s370_line, 2); }
            /* copies reading preg now read the parked copy */
            j = 0;
            while (j < n) {
                if (!ph_done[j] && j != parked && ph_src[j] >= 0 && ra_reg[ph_src[j]] == preg &&
                    ra_is_fpv(ph_src[j]) == pfp) {
                    int dreg2;
                    dreg2 = ra_reg[ph_phi[j]];
                    if (pfp) { f_reset(); f_s(s370_r(dreg2)); f_c(','); f_s(s370_hdr(S370_HDR_PHIT)); asm_ins("LD", s370_line, 4); }
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
            if (ra_is_fpv(phi)) { f_reset(); f_s(s370_slot(phi)); f_s("(8),"); f_s(s370_hdr(S370_HDR_PHIT)); asm_ins("MVC", s370_line, 6); }
            else { f_reset(); f_s(s370_slot(phi)); f_s("(4),"); f_s(s370_hdr(S370_HDR_PHIT)); asm_ins("MVC", s370_line, 6); }
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
            if (v < 0) return 1;
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
    k = h_kind[i];
    s1 = h_src1[i];
    s2 = h_src2[i];
    s370_load_into(1, s1);
    if (k == HI_DIV || k == HI_REM) asm_ins("SRDA", "0,32", 4);
    if (ra_reg[s2] >= 0) {
        f_reset(); f_s("0,"); f_s(s370_r(ra_reg[s2])); asm_ins(k == HI_MUL ? "MR" : "DR", s370_line, 2);
    } else if (s370_imem(s2, mem)) {
        f_reset(); f_s("0,"); f_s(mem); asm_ins(k == HI_MUL ? "M" : "D", s370_line, 4);
    } else {
        int r2;
        r2 = s370_gpr(s2, 15);
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
    dbl = ty_is_double(h_ty[i]);
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

static int s370_tmp_lbl;   /* a 16-byte temporary in the header? no: per call, from the pool of temps */
#define S370_MAX_TMP 64
static int s370_ntmp;      /* call-argument temporaries used in this unit (each a doubleword) */
static int s370_tmp_base;  /* offset of the first in the area, assigned at emission */

/* The static area is emitted after the code, so temporaries can be
 * allocated as calls are emitted: their labels are Wnnnnn. */
static int s370_tmp_labels[S370_MAX_TMP];
static int s370_new_tmp(void) {
    if (s370_ntmp >= S370_MAX_TMP) cg_die("too many call temporaries", -1);
    s370_tmp_labels[s370_ntmp] = cg_label();
    s370_ntmp = s370_ntmp + 1;
    return s370_tmp_labels[s370_ntmp - 1];
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

/* Parameter lists: Pnnnnn DS nF, filled before the call. */
#define S370_MAX_PL 256
static int s370_pl_lbl[S370_MAX_PL];
static int s370_pl_n[S370_MAX_PL];
static int s370_npl;

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

/* Align the location counter to a fullword with a harmless LR 0,0, as
 * H does before inline arguments. */
static void s370_align4(void) {
    if (s370_pc & 2) asm_ins("LR", "0,0", 2);
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
        if (sidx < 0) cg_die("WRITE with a non-constant format is not supported yet", i);
        s370_ibcom_load();
        s370_align4();
        asm_ins("BAL", "14,4(,15)", 4);
        if (bg_const_imm_inst(unit, &c, &root)) {
            f_reset(); f_s("F'"); f_n(c); f_c('\''); asm_stmt("", "DC", s370_line); s370_pc = s370_pc + 4;
        } else cg_die("WRITE with a non-constant unit is not supported yet", i);
        /* AL1(1): the format is text, as an array format is; a
         * compiled one would carry 0 (seen in H's listing) */
        f_reset(); f_s("AL1(1),AL3("); f_s(s370_lab('Q', s370_str_lbl[sidx])); f_c(')');
        asm_stmt("", "DC", s370_line); s370_pc = s370_pc + 4;
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

static void s370_call(int i) {
    int n;
    int base;
    int j;
    int pl;
    int bymask;
    char *ext;
    int callp;

    callp = (h_kind[i] == HI_CALLP);
    n = h_val[i];
    base = h_cbase[i];
    if (!callp && h_name[i] && s370_io_runtime(i)) { s370_call_result(i); return; }
    ext = callp ? 0 : s370_extname(h_name[i]);
    bymask = (callp || !h_name[i]) ? 0 : s370_byval_mask(h_name[i]);

    if (n > 0) {
        if (s370_npl >= S370_MAX_PL) cg_die("too many parameter lists", i);
        pl = cg_label();
        s370_pl_lbl[s370_npl] = pl;
        s370_pl_n[s370_npl] = n;
        s370_npl = s370_npl + 1;
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
    /* copies on an edge: branch to a stub for the taken side */
    lstub = cg_label();
    s370_branch(mask, lstub);
    if (else_copies) s370_phi_copies(hcg_cur_blk, else_b);
    if (else_b != next_b || else_copies) s370_branch(15, hcg_blk_lbl[else_b]);
    asm_stmt(s370_lab('L', lstub), "DS", "0H");
    if (then_copies) s370_phi_copies(hcg_cur_blk, then_b);
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
        f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_hdr(S370_HDR_PARM)); asm_ins("L", s370_line, 4);
        f_reset(); f_s(s370_r(d)); f_c(','); f_n(4 * h_val[i]); f_s("(,"); f_s(s370_r(d)); f_c(')'); asm_ins("L", s370_line, 4);
        s370_ifinish(i, d);
        return;
    }

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
            m = s370_mem_operand(h_src1[i], lnt, s);
            if (ty & TY_UNSIGNED) {
                f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_r(d)); asm_ins("SR", s370_line, 2);
                f_reset(); f_s(s370_r(d)); f_c(','); f_s(m); asm_ins("IC", s370_line, 4);
            } else {
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
            m = s370_mem_operand(h_src1[i], lnt, 14);
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
            int c;
            int base;
            int off;
            c = h_val[i];
            if (s370_fold_chain(i, &base, &off) && off >= 0) {
                /* LA folds the whole chain; it is an address, so the
                 * 24-bit result is right */
                int b;
                b = s370_gpr(base, d);
                f_reset(); f_s(s370_r(d)); f_c(','); f_n(off); f_s("(,"); f_s(s370_r(b)); f_c(')'); asm_ins("LA", s370_line, 4);
            } else {
                s370_load_into(d, h_src1[i]);
                if (c >= -32768 && c <= 32767) { f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_pool_h(c)); asm_ins("AH", s370_line, 4); }
                else { f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_pool_f(c)); asm_ins("A", s370_line, 4); }
            }
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
    if (k == HI_FNEG) {
        int dbl;
        dbl = ty_is_double(h_ty[i]);
        d = s370_fdst(i);
        s370_copy_to_reg(d, 1, h_src1[i], dbl);
        f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_r(d)); asm_ins(dbl ? "LCDR" : "LCER", s370_line, 2);
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
        f_reset(); f_s(s370_r(f)); f_c(','); f_s(s370_hdr(S370_HDR_FTMP)); asm_ins("STD", s370_line, 4);
        f_reset(); f_s(s370_r(d)); f_c(','); f_s(s370_hdr(S370_HDR_FTMP + 4)); asm_ins("L", s370_line, 4);
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
        if (v >= 0 && h_ty[i] != TY_INT) {
            /* a FUNCTION result (ty stays 0 for a typed result) */
            if (ra_is_fpv(v)) {
                s370_copy_to_reg(0, 1, v, ty_is_double(h_ty[v]));
                if (h_src2[i] >= 0) s370_copy_to_reg(2, 1, h_src2[i], ty_is_double(h_ty[h_src2[i]]));
            } else {
                s370_load_into(0, v);
            }
        } else if (v >= 0 && s370_unit_is_main == 0 && f77_ukind[s370_cur_unit] == F77_UNIT_FUNC) {
            s370_load_into(0, v);
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
    if (k == HI_CALLHI) cg_die("CALLHI in native mode", i);
    cg_die("unhandled instruction kind", i);
}

static void s370_block(int b) {
    int i;
    int term;
    int k;
    hcg_cur_blk = b;
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
                if (!hcg_placed[h_val[i]]) nxt = h_val[i];        /* the fall-through arm */
                else if (!hcg_placed[h_src2[i]]) nxt = h_src2[i];
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
            else if (c < 32 || c > 126) f_c('?');
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
    asm_stmt("", "DS", "D");                         /* 104: PHIT */
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
    /* parameter lists and jump tables */
    i = 0;
    while (i < s370_npl) {
        if (s370_pl_n[i] > 0) {
            f_reset(); f_n(s370_pl_n[i]); f_c('F');
            asm_stmt(s370_lab('P', s370_pl_lbl[i]), "DS", s370_line);
            off = off + 4 * s370_pl_n[i];
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
            asm_stmt("", "DS", "0D");
            f_reset(); f_s("XL"); f_n(s370_obj_size[k]);
            asm_stmt(s370_lab('T', s370_obj_lbl[k]), "DS", s370_line);
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

static void s370_gen_unit(Node *fn) {
    int b;
    int q;
    int attempt;
    char *csect;

    s370_cur_unit = fn->unit;
    s370_unit_is_main = (f77_ukind[fn->unit] == F77_UNIT_PROGRAM);
    hl_func(fn);

    ssa_split_pairs = 0;
    hir_ssa_construct();
    hir_opt();
    licm_loopopt = 1;
    if (ho_mask & 1024) hir_licm();

    s370_npool = 0;
    s370_ntmp = 0;
    s370_npl = 0;
    s370_area_lbl = cg_label();
    s370_pc = 0;
    s370_mark_strings();
    s370_layout();
    s370_mark_loop_consts();
    hir_burg();
    hcg_identify_fusions();

    /* Register allocation; a spill region past the data bases' reach
     * costs another base and a second try. */
    attempt = 0;
    for (;;) {
        int save_ts;
        ra_gpr_avail = RA_NGPR - (s370_nbases - 1);
        save_ts = hl_temp_stack;
        hir_regalloc();
        if (s370_spill_base + 8 * ra_nslots + 8 * S370_MAX_TMP + 1024 <= s370_near_limit || attempt >= 2 || s370_nbases >= 3) break;
        s370_nbases = s370_nbases + 1;
        s370_near_limit = 4096 * s370_nbases;
        hl_temp_stack = save_ts;
        attempt = attempt + 1;
    }

    if (getenv("F77_DUMP")) ra_dump_intervals(fn->name);

    s370_layout_blocks();
    b = 0;
    while (b < bb_nblk) { hcg_blk_lbl[b] = cg_label(); b = b + 1; }
    hcg_epilog = cg_label();

    /* --- the CSECT --- */
    csect = s370_extname(fn->name);
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
    {
        int lgo;
        int lac;
        lgo = cg_label();
        lac = cg_label();
        f_reset(); f_s(s370_lab('L', lgo)); asm_ins("B", s370_line, 4);
        f_reset(); f_s("A("); f_s(s370_lab('S', s370_area_lbl)); f_c(')');
        s370_pc = (s370_pc + 3) & ~3;   /* the assembler aligns the A-constant */
        asm_stmt(s370_lab('L', lac), "DC", s370_line); s370_pc = s370_pc + 4;
        if (s370_unit_is_main) {
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

    q = 0;
    while (q < bb_nblk) { s370_block(hcg_emit_ord[q]); q = q + 1; }

    /* epilogue: H's, leaving R0 (and FPR0) as they are */
    asm_stmt(s370_lab('L', hcg_epilog), "DS", "0H");
    asm_ins("L", "13,4(,13)", 4);
    asm_ins("L", "14,12(,13)", 4);
    asm_ins("LM", "2,12,28(13)", 4);
    asm_ins("SR", "15,15", 2);
    asm_ins("BR", "14", 2);

    s370_emit_area();
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
            /* uninitialized: COM, which the linkage editor merges */
            asm_stmt(nm, "COM", "");
            asm_stmt("", "DS", "0D");
            f_reset(); f_s("XL"); f_n(ps_gsize[i] > 0 ? ps_gsize[i] : 8);
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
