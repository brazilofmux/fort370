/* hir_burg_s370.h -- BURS instruction selection for the S/370 back end.
 *
 * The engine is hir_burg.h's (bottom-up labelling with a pattern table,
 * top-down selection, single-use folding); the grammar is this
 * machine's.  Nonterminals:
 *
 *   BG_REG    value in a register (general or floating, by type)
 *   BG_IMM    an integer constant not yet materialized: on S/370 every
 *             binary operation can take it from the constant pool as
 *             a storage operand (A 2,C0012; N 2,C0013; SLL 2,3), at the
 *             same cost as a register, so IMM is allowed as the right
 *             operand everywhere and as the left of commutative ops
 *   BG_FADDR  an address in the unit's static area, D(X,13): an ALLOCA
 *             the layout placed within reach of the data bases, plus a
 *             constant offset
 *   BG_SADDR  a symbol reached through an address constant (COMMON
 *             members, SAVE'd statics, strings, far arrays)
 *   BG_STMT   no value
 *
 * The emitter decides near from far (s370_near[]) before BURS runs, so
 * the FADDR guards can ask.  A storage-operand nonterminal (MEM) is the
 * next step, not this one: the first grammar is register to register.
 */

#define BG_REG    0
#define BG_IMM    1
#define BG_FADDR  2
#define BG_SADDR  3
#define BG_STMT   4
#define BG_NNT    5
#define BG_INF    999999

#define BG_MAX_PAT 160

static int bg_pnt[BG_MAX_PAT];
static int bg_pop[BG_MAX_PAT];
static int bg_plnt[BG_MAX_PAT];
static int bg_prnt[BG_MAX_PAT];
static int bg_pcost[BG_MAX_PAT];
static int bg_npat;

#define BG_MAX_OP 55
#define BG_OP_SZ 56
static int bg_ofirst[BG_OP_SZ];
static int bg_ocount[BG_OP_SZ];
static int bg_sorted[BG_MAX_PAT];

#define BG_MAX_CHAIN 8
static int bg_cfrom[BG_MAX_CHAIN];
static int bg_cto[BG_MAX_CHAIN];
static int bg_ccost[BG_MAX_CHAIN];
static int bg_nchain;

#define BG_MAX_INST 8192   /* fort370: one unit in an 8MB region, docs/FITTING.md */
#define BG_COST_SZ (BG_MAX_INST * BG_NNT)
static int bg_cost[BG_COST_SZ];
static int bg_rule[BG_COST_SZ];

static int bg_sel[HIR_MAX_INST];
static int bg_fold[HIR_MAX_INST];
static int bg_uses[HIR_MAX_INST];
static int bg_foff[HIR_MAX_INST];   /* offset within the ALLOCA's object along an ADDI chain */
static int bg_ssym[HIR_MAX_INST];
static int bg_soff[HIR_MAX_INST];

/* Filled by the emitter's layout pass before hir_burg(): for an ALLOCA,
 * its byte offset in the unit's static area, or -1 when it lies past
 * the data bases' reach and must go through an address constant. */
static int s370_aoff[HIR_MAX_INST];

static int bg_inited;

static int bg_add_pat(int nt, int op, int lnt, int rnt, int cost) {
    int idx;
    idx = bg_npat;
    if (idx >= BG_MAX_PAT) return -1;
    bg_pnt[idx] = nt;
    bg_pop[idx] = op;
    bg_plnt[idx] = lnt;
    bg_prnt[idx] = rnt;
    bg_pcost[idx] = cost;
    bg_npat = bg_npat + 1;
    return idx;
}

static void bg_add_chain(int from, int to, int cost) {
    int idx;
    idx = bg_nchain;
    if (idx >= BG_MAX_CHAIN) return;
    bg_cfrom[idx] = from;
    bg_cto[idx] = to;
    bg_ccost[idx] = cost;
    bg_nchain = bg_nchain + 1;
}

static void bg_binop_rules(int op, int commutative) {
    bg_add_pat(BG_REG, op, BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, op, BG_REG, BG_IMM, 1);
    if (commutative) bg_add_pat(BG_REG, op, BG_IMM, BG_REG, 1);
}

static void bg_init(void) {
    bg_npat = 0;
    bg_nchain = 0;

    /* Leaves */
    bg_add_pat(BG_IMM,   HI_ICONST, -1, -1, 0);
    bg_add_pat(BG_REG,   HI_ICONST, -1, -1, 1);
    bg_add_pat(BG_REG,   HI_FCONST, -1, -1, 1);
    bg_add_pat(BG_FADDR, HI_ALLOCA, -1, -1, 0);
    bg_add_pat(BG_REG,   HI_ALLOCA, -1, -1, 1);
    bg_add_pat(BG_SADDR, HI_GADDR,  -1, -1, 0);
    bg_add_pat(BG_REG,   HI_GADDR,  -1, -1, 1);
    bg_add_pat(BG_SADDR, HI_SADDR,  -1, -1, 0);
    bg_add_pat(BG_REG,   HI_SADDR,  -1, -1, 1);
    bg_add_pat(BG_SADDR, HI_FADDR,  -1, -1, 0);
    bg_add_pat(BG_REG,   HI_FADDR,  -1, -1, 1);
    bg_add_pat(BG_REG,   HI_PARAM,  -1, -1, 1);

    /* LOAD / STORE */
    bg_add_pat(BG_REG,  HI_LOAD, BG_FADDR, -1, 1);
    bg_add_pat(BG_REG,  HI_LOAD, BG_SADDR, -1, 2);
    bg_add_pat(BG_REG,  HI_LOAD, BG_REG,   -1, 1);
    bg_add_pat(BG_STMT, HI_STORE, BG_FADDR, BG_REG, 1);
    bg_add_pat(BG_STMT, HI_STORE, BG_SADDR, BG_REG, 2);
    bg_add_pat(BG_STMT, HI_STORE, BG_REG,   BG_REG, 1);

    /* ADDI */
    bg_add_pat(BG_IMM,   HI_ADDI, BG_IMM, -1, 0);
    bg_add_pat(BG_FADDR, HI_ADDI, BG_FADDR, -1, 0);
    bg_add_pat(BG_SADDR, HI_ADDI, BG_SADDR, -1, 0);
    bg_add_pat(BG_REG,   HI_ADDI, BG_FADDR, -1, 1);
    bg_add_pat(BG_REG,   HI_ADDI, BG_REG,   -1, 1);

    /* Integer binary ops */
    bg_binop_rules(HI_ADD, 1);
    bg_binop_rules(HI_SUB, 0);
    bg_binop_rules(HI_MUL, 1);
    bg_binop_rules(HI_DIV, 0);
    bg_binop_rules(HI_REM, 0);
    bg_binop_rules(HI_AND, 1);
    bg_binop_rules(HI_OR, 1);
    bg_binop_rules(HI_XOR, 1);
    bg_binop_rules(HI_SLL, 0);
    bg_binop_rules(HI_SRL, 0);
    bg_binop_rules(HI_SRA, 0);
    bg_binop_rules(HI_SEQ, 1);
    bg_binop_rules(HI_SNE, 1);
    bg_binop_rules(HI_SLT, 0);
    bg_binop_rules(HI_SGT, 0);
    bg_binop_rules(HI_SLE, 0);
    bg_binop_rules(HI_SGE, 0);
    bg_binop_rules(HI_SLTU, 0);
    bg_binop_rules(HI_SGTU, 0);
    bg_binop_rules(HI_SLEU, 0);
    bg_binop_rules(HI_SGEU, 0);

    /* Floating */
    bg_add_pat(BG_REG, HI_FADD, BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_FSUB, BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_FMUL, BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_FDIV, BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_FNEG, BG_REG, -1, 1);
    bg_add_pat(BG_REG, HI_FEQ,  BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_FLT,  BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_FLE,  BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_FCVT_ItoF, BG_REG, -1, 1);
    bg_add_pat(BG_REG, HI_FCVT_FtoI, BG_REG, -1, 1);
    bg_add_pat(BG_REG, HI_FCVT_FtoD, BG_REG, -1, 1);
    bg_add_pat(BG_REG, HI_FCVT_DtoF, BG_REG, -1, 1);

    /* Unary */
    bg_add_pat(BG_REG, HI_NEG,  BG_REG, -1, 1);
    bg_add_pat(BG_REG, HI_NOT,  BG_REG, -1, 1);
    bg_add_pat(BG_REG, HI_BNOT, BG_REG, -1, 1);
    bg_add_pat(BG_IMM, HI_COPY, BG_IMM, -1, 0);
    bg_add_pat(BG_REG, HI_COPY, BG_REG, -1, 0);

    /* Control flow */
    bg_add_pat(BG_STMT, HI_BR,  -1, -1, 1);
    bg_add_pat(BG_STMT, HI_BRC, BG_REG, -1, 2);
    bg_add_pat(BG_STMT, HI_RET, -1, -1, 1);

    /* Calls */
    bg_add_pat(BG_REG, HI_CALL,  -1, -1, 3);
    bg_add_pat(BG_REG, HI_CALLP, BG_REG, -1, 3);
    bg_add_pat(BG_REG, HI_PHI, -1, -1, 0);

    /* Chain rules */
    bg_add_chain(BG_IMM,   BG_REG, 1);
    bg_add_chain(BG_FADDR, BG_REG, 1);
    bg_add_chain(BG_SADDR, BG_REG, 1);
}

static void bg_build_index(void) {
    int op;
    int i;
    int j;
    op = 0;
    while (op <= BG_MAX_OP) { bg_ocount[op] = 0; op = op + 1; }
    i = 0;
    while (i < bg_npat) {
        op = bg_pop[i];
        if (op >= 0 && op <= BG_MAX_OP) bg_ocount[op] = bg_ocount[op] + 1;
        i = i + 1;
    }
    bg_ofirst[0] = 0;
    op = 1;
    while (op <= BG_MAX_OP) { bg_ofirst[op] = bg_ofirst[op - 1] + bg_ocount[op - 1]; op = op + 1; }
    op = 0;
    while (op <= BG_MAX_OP) { bg_ocount[op] = 0; op = op + 1; }
    i = 0;
    while (i < bg_npat) {
        op = bg_pop[i];
        if (op >= 0 && op <= BG_MAX_OP) {
            j = bg_ofirst[op] + bg_ocount[op];
            bg_sorted[j] = i;
            bg_ocount[op] = bg_ocount[op] + 1;
        }
        i = i + 1;
    }
}

/* --- Helpers --- */

/* The ALLOCA at the root of an ADDI chain, or -1. */
static int bg_faddr_root(int idx) {
    int lim;
    lim = 0;
    while (idx >= 0 && lim < 64) {
        if (h_kind[idx] == HI_ALLOCA) return idx;
        if (h_kind[idx] != HI_ADDI) return -1;
        idx = h_src1[idx];
        lim = lim + 1;
    }
    return -1;
}

/* Offset within the object along the chain (the ALLOCA itself is 0). */
static int bg_faddr_offset(int idx) {
    int k;
    k = h_kind[idx];
    if (k == HI_ALLOCA) return 0;
    if (k == HI_ADDI) return h_val[idx] + bg_faddr_offset(h_src1[idx]);
    return 0;
}

/* D(X,13) can name the object plus offset: the object is near and the
 * final displacement is 0..4095. */
static int bg_faddr_ok(int idx) {
    int root;
    int off;
    root = bg_faddr_root(idx);
    if (root < 0) return 0;
    if (s370_aoff[root] < 0) return 0;
    off = s370_aoff[root] + bg_faddr_offset(idx);
    return off >= 0 && off <= 4095;
}

static int bg_addi_faddr_ok(int idx) { return bg_faddr_ok(idx); }

static int bg_const_imm_inst(int inst, int *out, int *root_iconst) {
    int k;
    int acc;
    int lim;
    acc = 0;
    lim = 0;
    while (inst >= 0 && lim < 64) {
        k = h_kind[inst];
        if (k == HI_ICONST) { *out = acc + h_val[inst]; *root_iconst = inst; return 1; }
        if (k == HI_COPY) { inst = h_src1[inst]; lim = lim + 1; continue; }
        if (k == HI_ADDI) { acc = acc + h_val[inst]; inst = h_src1[inst]; lim = lim + 1; continue; }
        return 0;
    }
    return 0;
}

static int bg_src2_is_ref(int k) {
    if (hi_is_binop(k)) return 1;
    if (k == HI_STORE) return 1;
    if (k == HI_RET) return 1;
    if (k >= HI_FADD && k <= HI_FDIV) return 1;
    if (k >= HI_FEQ && k <= HI_FLE) return 1;
    return 0;
}

static char *bg_nt_name(int nt) {
    if (nt == BG_REG) return "reg";
    if (nt == BG_IMM) return "imm";
    if (nt == BG_FADDR) return "faddr";
    if (nt == BG_SADDR) return "saddr";
    if (nt == BG_STMT) return "stmt";
    return "?";
}

static char *bg_op_name(int op) {
    if (op == HI_NOP) return "nop";
    if (op == HI_ICONST) return "iconst";
    if (op == HI_PARAM) return "param";
    if (op == HI_ADD) return "add";
    if (op == HI_SUB) return "sub";
    if (op == HI_MUL) return "mul";
    if (op == HI_MULH) return "mulh";
    if (op == HI_MULHU) return "mulhu";
    if (op == HI_DIV) return "div";
    if (op == HI_REM) return "rem";
    if (op == HI_AND) return "and";
    if (op == HI_OR) return "or";
    if (op == HI_XOR) return "xor";
    if (op == HI_SLL) return "sll";
    if (op == HI_SRA) return "sra";
    if (op == HI_SRL) return "srl";
    if (op == HI_SEQ) return "seq";
    if (op == HI_SNE) return "sne";
    if (op == HI_SLT) return "slt";
    if (op == HI_SGT) return "sgt";
    if (op == HI_SLE) return "sle";
    if (op == HI_SGE) return "sge";
    if (op == HI_SLTU) return "sltu";
    if (op == HI_SGTU) return "sgtu";
    if (op == HI_SLEU) return "sleu";
    if (op == HI_SGEU) return "sgeu";
    if (op == HI_NEG) return "neg";
    if (op == HI_NOT) return "not";
    if (op == HI_BNOT) return "bnot";
    if (op == HI_LOAD) return "load";
    if (op == HI_STORE) return "store";
    if (op == HI_ALLOCA) return "alloca";
    if (op == HI_GADDR) return "gaddr";
    if (op == HI_SADDR) return "saddr";
    if (op == HI_FADDR) return "faddr";
    if (op == HI_BR) return "br";
    if (op == HI_BRC) return "brc";
    if (op == HI_RET) return "ret";
    if (op == HI_CALL) return "call";
    if (op == HI_CALLP) return "callp";
    if (op == HI_PHI) return "phi";
    if (op == HI_COPY) return "copy";
    if (op == HI_ADDI) return "addi";
    if (op == HI_GETFP) return "getfp";
    if (op == HI_CALLHI) return "callhi";
    if (op == HI_FADD) return "fadd";
    if (op == HI_FSUB) return "fsub";
    if (op == HI_FMUL) return "fmul";
    if (op == HI_FDIV) return "fdiv";
    if (op == HI_FNEG) return "fneg";
    if (op == HI_FEQ) return "feq";
    if (op == HI_FLT) return "flt";
    if (op == HI_FLE) return "fle";
    if (op == HI_FCVT_ItoF) return "fcvt_itof";
    if (op == HI_FCVT_FtoI) return "fcvt_ftoi";
    if (op == HI_FCVT_FtoD) return "fcvt_ftod";
    if (op == HI_FCVT_DtoF) return "fcvt_dtof";
    if (op == HI_FCONST) return "fconst";
    if (op == HI_FABS) return "fabs";
    if (op == HI_JMPTAB) return "jmptab";
    return "?";
}

/* --- Use counting --- */

static void bg_count_uses(void) {
    int i;
    int j;
    int k;
    int base;
    int cnt;
    i = 0;
    while (i < h_ninst) { bg_uses[i] = 0; i = i + 1; }
    i = 0;
    while (i < h_ninst) {
        k = h_kind[i];
        if (k == HI_NOP) { i = i + 1; continue; }
        if (h_src1[i] >= 0) bg_uses[h_src1[i]] = bg_uses[h_src1[i]] + 1;
        if (h_src2[i] >= 0 && bg_src2_is_ref(k)) bg_uses[h_src2[i]] = bg_uses[h_src2[i]] + 1;
        if (k == HI_CALL || k == HI_CALLP) {
            base = h_cbase[i];
            cnt = h_val[i];
            j = 0;
            while (j < cnt) {
                if (h_carg[base + j] >= 0) bg_uses[h_carg[base + j]] = bg_uses[h_carg[base + j]] + 1;
                j = j + 1;
            }
        }
        if (k == HI_PHI) {
            base = h_pbase[i];
            cnt = h_pcnt[i];
            j = 0;
            while (j < cnt) {
                if (h_pval[base + j] >= 0) bg_uses[h_pval[base + j]] = bg_uses[h_pval[base + j]] + 1;
                j = j + 1;
            }
        }
        i = i + 1;
    }
}

/* --- Frame and symbol offsets along ADDI chains --- */

static int bg_is_sym(int k) { return k == HI_GADDR || k == HI_SADDR || k == HI_FADDR; }

static char bg_fdone[HIR_MAX_INST];
static int  bg_walk[HIR_MAX_INST];

static int bg_walk_push(int sp, int v) {
    if (sp >= HIR_MAX_INST) { fdputs("f77: burg walk stack overflow\n", 2); exit(1); }
    bg_walk[sp] = v;
    return sp + 1;
}

/* bg_foff: offset WITHIN the object (0 at the ALLOCA), so the emitter
 * writes "T0012+off".  bg_ssym/bg_soff: symbol and offset for chains
 * rooted at a GADDR/SADDR/FADDR. */
static void bg_foff_one(int start) {
    int sp;
    int i;
    int k;
    int s1;
    int sk;
    if (bg_fdone[start]) return;
    sp = 0;
    sp = bg_walk_push(sp, start);
    while (sp > 0) {
        i = bg_walk[sp - 1];
        if (!bg_fdone[i]) {
            bg_fdone[i] = 1;
            k = h_kind[i];
            s1 = h_src1[i];
            if (k == HI_ADDI && s1 >= 0 && s1 < h_ninst && !bg_fdone[s1]) { sp = bg_walk_push(sp, s1); continue; }
        }
        k = h_kind[i];
        s1 = h_src1[i];
        if (k == HI_ALLOCA) {
            bg_foff[i] = 0;
        } else if (k == HI_ADDI) {
            sk = -1;
            if (s1 >= 0) sk = h_kind[s1];
            if (sk == HI_ALLOCA || sk == HI_ADDI) bg_foff[i] = bg_foff[s1] + h_val[i];
            else bg_foff[i] = 0;
        } else {
            bg_foff[i] = 0;
        }
        if (bg_is_sym(k)) {
            bg_ssym[i] = i;
            bg_soff[i] = 0;
        } else if (k == HI_ADDI) {
            if (s1 >= 0 && bg_ssym[s1] >= 0) { bg_ssym[i] = bg_ssym[s1]; bg_soff[i] = bg_soff[s1] + h_val[i]; }
            else { bg_ssym[i] = -1; bg_soff[i] = 0; }
        } else {
            bg_ssym[i] = -1;
            bg_soff[i] = 0;
        }
        sp = sp - 1;
    }
}

static void bg_compute_foff(void) {
    int i;
    i = 0;
    while (i < h_ninst) { bg_fdone[i] = 0; i = i + 1; }
    i = 0;
    while (i < h_ninst) { bg_foff_one(i); i = i + 1; }
}

/* --- Bottom-up labelling --- */

static char bg_done[HIR_MAX_INST];

static int bg_src2_is_value(int k) {
    if (k == HI_BR || k == HI_BRC || k == HI_PHI) return 0;
    return 1;
}

static void bg_label_one(int start) {
    int k;
    int pi;
    int pat;
    int lnt;
    int rnt;
    int cost;
    int ci;
    int s1;
    int s2;
    int base_idx;
    int dst;
    int sp;
    int i;
    int pushed;
    if (bg_done[start]) return;
    sp = 0;
    sp = bg_walk_push(sp, start);
    while (sp > 0) {
        i = bg_walk[sp - 1];
        if (!bg_done[i]) {
            bg_done[i] = 1;
            k = h_kind[i];
            if (k == HI_NOP || k < 0 || k > BG_MAX_OP) { sp = sp - 1; continue; }
            s1 = h_src1[i];
            s2 = h_src2[i];
            pushed = 0;
            if (s1 >= 0 && s1 < h_ninst && !bg_done[s1]) { sp = bg_walk_push(sp, s1); pushed = 1; }
            if (s2 >= 0 && s2 < h_ninst && bg_src2_is_value(k) && !bg_done[s2]) { sp = bg_walk_push(sp, s2); pushed = 1; }
            if (pushed) continue;
        }
        k = h_kind[i];
        if (k == HI_NOP || k < 0 || k > BG_MAX_OP) { sp = sp - 1; continue; }
        s1 = h_src1[i];
        s2 = h_src2[i];
        pi = 0;
        while (pi < bg_ocount[k]) {
            pat = bg_sorted[bg_ofirst[k] + pi];
            lnt = bg_plnt[pat];
            rnt = bg_prnt[pat];
            cost = bg_pcost[pat];
            if (k == HI_ALLOCA && bg_pnt[pat] == BG_FADDR) {
                if (!bg_faddr_ok(i)) { pi = pi + 1; continue; }
            }
            if (k == HI_ADDI && bg_pnt[pat] == BG_FADDR) {
                if (!bg_addi_faddr_ok(i)) { pi = pi + 1; continue; }
            }
            if (lnt >= 0) {
                if (s1 < 0 || bg_cost[s1 * BG_NNT + lnt] >= BG_INF) { pi = pi + 1; continue; }
                cost = cost + bg_cost[s1 * BG_NNT + lnt];
            }
            if (rnt >= 0) {
                if (s2 < 0 || bg_cost[s2 * BG_NNT + rnt] >= BG_INF) { pi = pi + 1; continue; }
                cost = cost + bg_cost[s2 * BG_NNT + rnt];
            }
            dst = i * BG_NNT + bg_pnt[pat];
            if (cost < bg_cost[dst]) { bg_cost[dst] = cost; bg_rule[dst] = pat; }
            pi = pi + 1;
        }
        ci = 0;
        while (ci < bg_nchain) {
            base_idx = i * BG_NNT + bg_cfrom[ci];
            if (bg_cost[base_idx] < BG_INF) {
                cost = bg_cost[base_idx] + bg_ccost[ci];
                dst = i * BG_NNT + bg_cto[ci];
                if (cost < bg_cost[dst]) { bg_cost[dst] = cost; bg_rule[dst] = -(ci + 2); }
            }
            ci = ci + 1;
        }
        sp = sp - 1;
    }
}

static void bg_label(void) {
    int i;
    i = 0;
    while (i < h_ninst * BG_NNT) { bg_cost[i] = BG_INF; bg_rule[i] = -1; i = i + 1; }
    i = 0;
    while (i < h_ninst) { bg_done[i] = 0; i = i + 1; }
    i = 0;
    while (i < h_ninst) { bg_label_one(i); i = i + 1; }
}

/* --- Top-down selection and folding --- */

static int bg_foldable(int k) {
    return k == HI_ICONST || k == HI_GADDR || k == HI_SADDR || k == HI_FADDR ||
           k == HI_ALLOCA || k == HI_ADDI;
}

static void bg_select(void) {
    int i;
    int k;
    int nt;
    int pat;
    int lnt;
    int rnt;
    int s1;
    int s2;
    i = 0;
    while (i < h_ninst) { bg_sel[i] = -1; bg_fold[i] = 0; i = i + 1; }
    i = 0;
    while (i < h_ninst) {
        k = h_kind[i];
        if (k == HI_NOP) { i = i + 1; continue; }
        nt = hi_has_value(k) ? BG_REG : BG_STMT;
        bg_sel[i] = bg_rule[i * BG_NNT + nt];
        i = i + 1;
    }
    /* Fold single-use, same-block, non-remat children matched as a
     * non-REG nonterminal into their parent.  (Only ADDI chains ever
     * qualify: the leaves are rematerializable.) */
    i = 0;
    while (i < h_ninst) {
        pat = bg_sel[i];
        if (pat < 0) { i = i + 1; continue; }
        lnt = bg_plnt[pat];
        s1 = h_src1[i];
        if (lnt >= 0 && lnt != BG_REG && s1 >= 0 && !bg_fold[s1] && bg_foldable(h_kind[s1])) {
            if (!hi_is_remat(h_kind[s1]) && bg_uses[s1] == 1 && h_blk[s1] == h_blk[i] &&
                bg_cost[s1 * BG_NNT + lnt] < BG_INF && h_kind[s1] != HI_NOP) {
                bg_fold[s1] = 1;
                bg_sel[s1] = -1;
                h_kind[s1] = HI_NOP;
            }
        }
        rnt = bg_prnt[pat];
        s2 = h_src2[i];
        if (rnt >= 0 && rnt != BG_REG && s2 >= 0 && !bg_fold[s2] && bg_foldable(h_kind[s2])) {
            if (bg_uses[s2] == 1 && !hi_is_remat(h_kind[s2]) && h_kind[s2] != HI_NOP &&
                h_blk[s2] == h_blk[i] && bg_cost[s2 * BG_NNT + rnt] < BG_INF) {
                bg_fold[s2] = 1;
                bg_sel[s2] = -1;
                h_kind[s2] = HI_NOP;
            }
        }
        i = i + 1;
    }
}

static void hir_burg(void) {
    int i;
    if (!bg_inited) {
        bg_init();
        bg_build_index();
        bg_inited = 1;
    }
    bg_compute_foff();
    if (h_ninst > BG_MAX_INST) {
        i = 0;
        while (i < h_ninst) { bg_sel[i] = -1; bg_fold[i] = 0; i = i + 1; }
        return;
    }
    bg_label();
    bg_count_uses();
    bg_select();
}

/* ============================================================================
 * Compare-and-branch fusion: a BRC whose condition is a single-use
 * comparison in the same block re-emits the comparison as C/CR/CD/CDR
 * and branches on the condition code.  The comparison is NOPed by the
 * allocator (ra_extend_fused_cmp), which keeps its operands live.
 * ============================================================================ */

static int hcg_brc_fuse[HIR_MAX_INST];
static int hcg_cmp_fused[HIR_MAX_INST];
static int hcg_cmp_kind[HIR_MAX_INST];

static int hcg_is_cmp(int k) {
    return (k >= HI_SEQ && k <= HI_SGEU) || k == HI_FEQ || k == HI_FLT || k == HI_FLE;
}

static void hcg_identify_fusions(void) {
    int i;
    int k;
    int root;
    int rk;
    int lim;
    int ok;
    i = 0;
    while (i < h_ninst) { hcg_brc_fuse[i] = -1; hcg_cmp_fused[i] = 0; i = i + 1; }
    if (h_ninst > BG_MAX_INST) return;
    i = 0;
    while (i < h_ninst) {
        k = h_kind[i];
        if (k != HI_BRC) { i = i + 1; continue; }
        ok = 1;
        root = h_src1[i];
        lim = 0;
        while (root >= 0 && h_kind[root] == HI_COPY && lim < 64) {
            if (bg_uses[root] != 1 || h_blk[root] != h_blk[i]) { ok = 0; break; }
            root = h_src1[root];
            lim = lim + 1;
        }
        if (!ok || root < 0) { i = i + 1; continue; }
        rk = h_kind[root];
        if (!hcg_is_cmp(rk)) { i = i + 1; continue; }
        if (bg_uses[root] != 1) { i = i + 1; continue; }
        if (h_blk[root] != h_blk[i]) { i = i + 1; continue; }
        if (h_src1[root] >= 0 && h_kind[h_src1[root]] == HI_NOP) { i = i + 1; continue; }
        if (h_src2[root] >= 0 && h_kind[h_src2[root]] == HI_NOP) { i = i + 1; continue; }
        hcg_brc_fuse[i] = root;
        hcg_cmp_fused[root] = 1;
        hcg_cmp_kind[root] = rk;
        {
            int c;
            c = h_src1[i];
            lim = 0;
            while (c >= 0 && c != root && h_kind[c] == HI_COPY && lim < 64) {
                hcg_cmp_fused[c] = 1;
                c = h_src1[c];
                lim = lim + 1;
            }
        }
        i = i + 1;
    }
}
