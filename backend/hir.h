/* COPIED from slow32-public fortran/src/hir.h at 2245be78 (2026-10-12).  See PROVENANCE.md. */
/* COPIED from selfhost/stage08/hir.h at 30e16a57 (re-sync 2026-10-11; the
 * first copy was 849dd791, 2026-08-31).
 * fortran/ is self-contained by ruling: selfhost must be free to evolve
 * without breaking f77.  Do NOT symlink this back.  Re-sync deliberately,
 * and record the new vintage here.
 */
/* hir.h -- High-level IR for s12cc
 *
 * Parallel-array instruction representation.
 * Each instruction slot is identified by its index.
 * Instructions that produce values use their index as the value number.
 */

/* --- Instruction kinds --- */
#define HI_NOP       0
#define HI_ICONST    1
#define HI_PARAM     2
#define HI_ADD       3
#define HI_SUB       4
#define HI_MUL       5
#define HI_DIV       6
#define HI_REM       7
#define HI_AND       8
#define HI_OR        9
#define HI_XOR      10
#define HI_SLL      11
#define HI_SRA      12
#define HI_SRL      13
#define HI_SEQ      14
#define HI_SNE      15
#define HI_SLT      16
#define HI_SGT      17
#define HI_SLE      18
#define HI_SGE      19
#define HI_SLTU     20
#define HI_SGTU     21
#define HI_SLEU     22
#define HI_SGEU     23
#define HI_NEG      24
#define HI_NOT      25
#define HI_BNOT     26
#define HI_LOAD     27
#define HI_STORE    28
#define HI_ALLOCA   29
#define HI_GADDR    30
#define HI_SADDR    31
#define HI_FADDR    32
#define HI_BR       33
#define HI_BRC      34
#define HI_RET      35
#define HI_CALL     36
#define HI_CALLP    37
#define HI_PHI      38
#define HI_COPY     39
#define HI_ADDI     40
#define HI_GETFP    41
#define HI_CALLHI   42  /* hi word of 64-bit return: src1=CALL instruction */

/* Floating-point operations (f32/f64 determined by h_ty) */
#define HI_FADD     43  /* FP add */
#define HI_FSUB     44  /* FP subtract */
#define HI_FMUL     45  /* FP multiply */
#define HI_FDIV     46  /* FP divide */
#define HI_FNEG     47  /* FP negate */
#define HI_FEQ      48  /* FP equal → int 0/1 */
#define HI_FLT      49  /* FP less than → int 0/1 */
#define HI_FLE      50  /* FP less-equal → int 0/1 */
#define HI_FCVT_ItoF 51 /* int to float conversion */
#define HI_FCVT_FtoI 52 /* float to int conversion */
#define HI_FCVT_FtoD 53 /* f32 to f64 promotion */
#define HI_FCVT_DtoF 54 /* f64 to f32 truncation */
#define HI_FCONST   55  /* float constant: val=bits (f32 in val, f64 in val+val_hi via CALLHI-like) */

/* Varargs (x64-specific; emitted only when S12CC_X64_HOST is defined) */
#define HI_VA_START 56  /* va_start: val=nparams. Produces initial va_list value. */
#define HI_VA_ARG   57  /* va_arg:   src1=current va_list, ty=arg type. Produces argument. */
#define HI_VA_NEXT  58  /* va_next:  src1=current va_list. Produces updated va_list. */

/* Widening (x64-specific; the optimizer must NOT fold these) */
#define HI_SEXT32   59  /* sign-extend 32→64: src1=32-bit value → 64-bit signed */
#define HI_ZEXT32   60  /* zero-extend 32→64: src1=32-bit value → 64-bit unsigned */

/* AArch64 inline-asm subset needed by tools/dbt. */
#define HI_A64_MRS_CNTVCT     61  /* mrs Xt, cntvct_el0 */
#define HI_A64_DBT_TRAMPOLINE 62  /* execute translated block trampoline; args in h_carg */
#define HI_A64_DC_CVAU        63  /* dc cvau, Xt */
#define HI_A64_IC_IVAU        64  /* ic ivau, Xt */
#define HI_A64_DSB_ISH        65  /* dsb ish */
#define HI_A64_ISB            66  /* isb */

/* Floating-point square root.  Single-source FP op; ty selects S/D form.
 * Recognised by the lower from __builtin_sqrt / __builtin_sqrtf source
 * patterns and lowered directly to FSQRT on backends that support it. */
#define HI_FSQRT    67

/* x86-64 inline-asm subset needed by tools/dbt.  Both ops produce no
 * value; their effects are stores via addresses passed as arguments. */
#define HI_X64_RDTSC          68  /* lfence;rdtsc → store eax to src1, edx to src2 */
#define HI_X64_DBT_TRAMPOLINE 69  /* execute translated block trampoline; args in h_carg */

/* Jump-table dispatch terminator (issue #32).  Used for dense switches.
 * src1 = index value, already normalised to [0,span) and bounds-checked by
 * a preceding BRC to the default block.  h_val = default block (taken for
 * table holes).  The per-index target block list lives in hjt_target[]
 * (hjt_base[]/hjt_span[]), NOT h_carg — h_carg entries are value
 * instructions that several passes rewrite, but these are block numbers. */
#define HI_JMPTAB   70

/* The high word of a product, signed and unsigned -- SLOW-32's mulh and
 * mulhu.  A 64-bit product is lo = MUL, hi = MULH when both operands are
 * sign-extended words, else MULHU + two MULs (hir_lower.h hl_ll_op); it
 * was a __muldi3 call.  Binary like ADD..SGEU: pure, CSE-able, the result
 * may reuse src1's register.  Came up from the COBOL front's copy of these
 * headers (cobol/src/hir), 2026-10-03. */
#define HI_MULH     71
#define HI_MULHU    72
/* a binary operation over two value operands (the ADD..SGEU range and
 * the two above); the passes that classified by the range ask this */
static int hi_is_binop(int k) { return (k >= HI_ADD && k <= HI_SGEU) || k == HI_MULH || k == HI_MULHU; }

/* --- Limits --- */

/* s12cc.c is built without -I, so these come from the implicit
 * declaration everywhere they are used for truthiness (HIR_*_DEBUG
 * gates).  The inline budget needs getenv's real return type, and a
 * later prototype would conflict with the earlier implicit int -- so
 * declare both here, ahead of every use in the HIR headers. */
static int hl_inl_depth_dbg;
static char *hl_cur_fn_dbg;

char *getenv(const char *name);
int atoi(const char *nptr);

#define HIR_MAX_INST 8192   /* fort370: one unit in an 8MB region, docs/FITTING.md */
#define HIR_MAX_BLOCK 1024   /* fort370: one unit in an 8MB region, docs/FITTING.md */
#define HIR_MAX_CARG 8192   /* fort370: one unit in an 8MB region, docs/FITTING.md */
#define HIR_MAX_PARG 8192   /* fort370: one unit in an 8MB region, docs/FITTING.md */

/* --- Diagnostic flags --- */
static int   s12cc_dump_intervals;  /* set by `-d` to dump per-fn live intervals */

/* --- Instruction parallel arrays --- */
static int   h_kind[HIR_MAX_INST];
static int   h_ty[HIR_MAX_INST];
static int   h_src1[HIR_MAX_INST];
static int   h_src2[HIR_MAX_INST];
static int   h_val[HIR_MAX_INST];
static char *h_name[HIR_MAX_INST];
static int   h_blk[HIR_MAX_INST];
static int   h_ninst;

/* Call arguments (flat array, indexed per-call) */
static int   h_carg[HIR_MAX_CARG];
/* ABI tag per flat call-arg slot: 0 = 32-bit word (ints, i64 halves,
 * varargs doubles), 1 = f64 LO half, 2 = f64 HI half, 16+k = byval
 * struct pointer whose stack slot reserves k words.  Non-varargs
 * doubles occupy an even-odd aligned register pair (r3:r4, r5:r6,
 * r7:r8, r9:r10) in clang's convention; byval pointers always go to
 * the stack (clang never assigns them a register, and the slot keeps
 * the struct's full rounded size so later stack args land where a
 * clang callee expects them); everything else fills the lowest free
 * register. */
#define HI_TAG_BYVAL 16
static int   h_carg_tag[HIR_MAX_CARG];

/* Assign physical argument locations for n flat slots with the given
 * tags (see h_carg_tag).  out[i] = register number 3..10, or -1 for a
 * stack slot.  Returns the number of stack WORDS (byval slots count
 * their full reserved size).  Mirrors clang's CC_SLOW32: f64 takes the
 * lowest free even-odd aligned pair, byval pointers (tag 16+k) always
 * take a k-word stack slot and never a register, every other slot
 * (ints, i64 halves, f32, varargs f64 halves) takes the lowest free
 * single register; later args back-fill skipped registers; spilled
 * args go to the stack in argument order. */
static int hi_abi_assign(int *tags, int n, int *out) {
    int freeb[8];
    int i;
    int p;
    int nstk;

    i = 0;
    while (i < 8) { freeb[i] = 1; i = i + 1; }
    nstk = 0;
    i = 0;
    while (i < n) {
        if (tags[i] >= HI_TAG_BYVAL) {
            out[i] = -1;
            nstk = nstk + (tags[i] - HI_TAG_BYVAL);
            i = i + 1;
        } else if (tags[i] == 1 && i + 1 < n && tags[i + 1] == 2) {
            p = 0;
            while (p < 8 && !(freeb[p] && freeb[p + 1])) p = p + 2;
            if (p < 8) {
                out[i] = 3 + p;
                out[i + 1] = 4 + p;
                freeb[p] = 0;
                freeb[p + 1] = 0;
            } else {
                out[i] = -1;
                out[i + 1] = -1;
                nstk = nstk + 2;
            }
            i = i + 2;
        } else {
            p = 0;
            while (p < 8 && !freeb[p]) p = p + 1;
            if (p < 8) {
                out[i] = 3 + p;
                freeb[p] = 0;
            } else {
                out[i] = -1;
                nstk = nstk + 1;
            }
            i = i + 1;
        }
    }
    return nstk;
}

/* Per-function incoming-parameter ABI map, filled by hl_func from the
 * parameter list and consumed by the register allocator (preferred
 abi colors) and the codegen entry sequence. */
static int hl_param_tags[64];
static int hl_param_map[64];     /* reg 3..10 or -1 = stack */
static int hl_param_stkord[64];  /* for -1 slots: BYTE offset from the
                                    incoming sp (byval slots reserve the
                                    struct's rounded size, so ordinals
                                    would lie) */
static int hl_param_nflat;
static int hl_pp_inst[66];       /* HI_PARAM inst id per flat phys slot;
                                    all PARAMs are emitted before any
                                    param-copy code so incoming registers
                                    stay pinned across earlier copies */
static int   h_cbase[HIR_MAX_INST];
static int   h_ncarg;

/* Jump-table targets (flat pool; per-HI_JMPTAB-instruction slice).
 * hjt_target[hjt_base[i] .. hjt_base[i]+hjt_span[i]) are the destination
 * block numbers for index 0..span-1.  Kept separate from h_carg because
 * these are block numbers, not value instructions. */
#define HIR_MAX_JT 4096   /* fort370: one unit in an 8MB region, docs/FITTING.md */
static int   hjt_target[HIR_MAX_JT];
static int   hjt_base[HIR_MAX_INST];
static int   hjt_span[HIR_MAX_INST];
static int   hjt_n;

/* Phi arguments (Phase B) */
static int   h_pblk[HIR_MAX_PARG];
static int   h_pval[HIR_MAX_PARG];
static int   h_pbase[HIR_MAX_INST];
static int   h_pcnt[HIR_MAX_INST];
static int   h_nparg;

/* Basic blocks */
static int   bb_start[HIR_MAX_BLOCK];
static int   bb_end[HIR_MAX_BLOCK];
static int   bb_nblk;

/* Current block being built (used by lowering) */
static int   hl_cur_blk;

/* --- Functions --- */

static void hir_reset(void) {
    h_ninst = 0;
    h_ncarg = 0;
    {
        int hi_i;
        hi_i = 0;
        while (hi_i < HIR_MAX_CARG) { h_carg_tag[hi_i] = 0; hi_i = hi_i + 1; }
    }
    h_nparg = 0;
    hjt_n = 0;
    bb_nblk = 0;
    hl_cur_blk = -1;
}

static int hir_new_block(void) {
    int b;
    b = bb_nblk;
    if (b >= HIR_MAX_BLOCK) {
        fdputs("s12cc: too many HIR blocks (fn=", 2);
        fdputs(hl_cur_fn_dbg ? hl_cur_fn_dbg : "?", 2);
        fdputs(" inl_depth=", 2);
        fdputuint(2, (unsigned)hl_inl_depth_dbg);
        fdputs(")\n", 2);
        exit(1);
    }
    bb_start[b] = -1;  /* set lazily when block becomes current */
    bb_end[b] = -1;
    bb_nblk = bb_nblk + 1;
    return b;
}

/* Switch current block; fix up start/end to current h_ninst */
static void hl_switch_block(int blk) {
    hl_cur_blk = blk;
    bb_start[blk] = h_ninst;
    bb_end[blk] = h_ninst;
}

/* DIVERGENCE (f77, port upstream candidate): a LOAD the FRONTEND
 * asserts reads storage no store in this unit can legally alias --
 * F77 scalar dummies under 15.9.3.6 -- may be hoisted by LICM like a
 * pure instruction.  The frontend sets the flag at emission and must
 * RETRACT it (at unit end) for any symbol the unit itself stores.
 * Nothing in a C-compiler frontend sets it, so the mechanism is inert
 * when ported. */
static char h_ld_ro[HIR_MAX_INST];

static int hi_emit(int kind, int ty, int s1, int s2, int val, char *name) {
    int idx;
    idx = h_ninst;
    if (idx >= HIR_MAX_INST) {
        fdputs("s12cc: too many HIR instructions (inl_depth=", 2);
        fdputuint(2, (unsigned)hl_inl_depth_dbg);
        fdputs(" fn=", 2);
        fdputs(hl_cur_fn_dbg ? hl_cur_fn_dbg : "?", 2);
        fdputs(")\n", 2);
        exit(1);
    }
    h_ld_ro[idx] = 0;
    h_kind[idx] = kind;
    h_ty[idx] = ty;
    h_src1[idx] = s1;
    h_src2[idx] = s2;
    h_val[idx] = val;
    h_name[idx] = name;
    h_blk[idx] = hl_cur_blk;
    h_cbase[idx] = -1;
    h_pbase[idx] = -1;
    h_pcnt[idx] = 0;
    h_ninst = h_ninst + 1;
    if (hl_cur_blk >= 0) {
        bb_end[hl_cur_blk] = h_ninst;
    }
    return idx;
}

/* Does an instruction produce a value? */
static int hi_has_value(int kind) {
    if (kind == HI_NOP) return 0;
    if (kind == HI_STORE) return 0;
    if (kind == HI_BR) return 0;
    if (kind == HI_BRC) return 0;
    if (kind == HI_RET) return 0;
    if (kind == HI_A64_DBT_TRAMPOLINE) return 0;
    if (kind == HI_A64_DC_CVAU) return 0;
    if (kind == HI_A64_IC_IVAU) return 0;
    if (kind == HI_A64_DSB_ISH) return 0;
    if (kind == HI_A64_ISB) return 0;
    if (kind == HI_X64_RDTSC) return 0;
    if (kind == HI_X64_DBT_TRAMPOLINE) return 0;
    if (kind == HI_JMPTAB) return 0;
    return 1;
}

/* Can a value be rematerialized (no spill needed)? */
static int hi_is_remat(int kind) {
    if (kind == HI_ICONST) return 1;
    if (kind == HI_ALLOCA) return 1;
    if (kind == HI_GADDR) return 1;
    if (kind == HI_SADDR) return 1;
    if (kind == HI_FADDR) return 1;
    if (kind == HI_GETFP) return 1;
    return 0;
}

/* Per-instruction remat override.  hcg_mark_loop_consts sets this
 * for big (non-i12) HI_ICONSTs used inside loops: instead of a
 * lui+addi rematerialized at every use (two instructions per loop
 * iteration), the value gets a graph node, a color, and one
 * materialization at its def.  Reset per function by that pass. */
static int h_no_remat[HIR_MAX_INST];

/* Instruction-level remat query: kind says remat, override says
 * keep it in a register.  Use wherever an instruction (not just a
 * kind) is in hand. */
static int hi_inst_remat(int i) {
    if (i < 0) return 0;
    if (h_no_remat[i]) return 0;
    return hi_is_remat(h_kind[i]);
}

static int hi_is_a64_cache_asm(int kind) {
    return kind == HI_A64_DC_CVAU || kind == HI_A64_IC_IVAU ||
           kind == HI_A64_DSB_ISH || kind == HI_A64_ISB;
}

/* Is this instruction kind safe to hoist/CSE? Pure, non-faulting. */
static int hi_is_pure(int k) {
    /* Binary arithmetic/logic/comparison, excluding DIV/REM */
    if (hi_is_binop(k)) {
        if (k == HI_DIV || k == HI_REM) return 0;
        return 1;
    }
    if (k == HI_NEG) return 1;
    if (k == HI_NOT) return 1;
    if (k == HI_BNOT) return 1;
    if (k == HI_ADDI) return 1;
    if (k == HI_COPY) return 1;
    if (k == HI_ICONST) return 1;
    if (k == HI_PARAM) return 1;
    if (k == HI_ALLOCA) return 1;
    if (k == HI_GADDR) return 1;
    if (k == HI_SADDR) return 1;
    if (k == HI_FADDR) return 1;
    if (k == HI_GETFP) return 1;
    if (k == HI_FSQRT) return 1;
    return 0;
}

/* Control-flow terminators that end a basic block (define its CFG successors).
 * BR/BRC/RET/JMPTAB. (Calls are regular value-producing instructions here.) */
static int hi_is_terminator(int kind) {
    if (kind == HI_BR) return 1;
    if (kind == HI_BRC) return 1;
    if (kind == HI_RET) return 1;
    if (kind == HI_JMPTAB) return 1;
    return 0;
}

/* Is the current block terminated? */
static int hl_terminated(void) {
    int last;
    if (hl_cur_blk < 0) return 1;
    if (bb_start[hl_cur_blk] >= bb_end[hl_cur_blk]) return 0;
    last = bb_end[hl_cur_blk] - 1;
    if (hi_is_terminator(h_kind[last])) return 1;
    return 0;
}

/* Emit a HI_JMPTAB terminator dispatching `index_val` (already in [0,span)
 * and bounds-checked) through a table of `span` destination blocks.  Holes
 * in the table should be filled with `def_blk` by the caller. */
static int hi_emit_jmptab(int index_val, int def_blk, int *targets, int span) {
    int idx;
    int j;
    if (hjt_n + span > HIR_MAX_JT) {
        fdputs("s12cc: jump-table target pool overflow\n", 2);
        exit(1);
    }
    idx = hi_emit(HI_JMPTAB, 0, index_val, -1, def_blk, NULL);
    hjt_base[idx] = hjt_n;
    hjt_span[idx] = span;
    j = 0;
    while (j < span) {
        hjt_target[hjt_n] = targets[j];
        hjt_n = hjt_n + 1;
        j = j + 1;
    }
    return idx;
}
