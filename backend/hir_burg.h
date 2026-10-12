/* COPIED from slow32-public fortran/src/hir_burg.h at 2245be78 (2026-10-12).  See PROVENANCE.md. */
/* COPIED from selfhost/stage08/hir_burg.h at 30e16a57.  See note in hir.h. */
/* hir_burg.h -- BURG-style instruction selection for s12cc
 *
 * Bottom-up rewrite grammar: table-driven pattern matcher.
 * Labels each HIR instruction with minimum-cost tiling, then
 * selects patterns top-down. Codegen dispatches on bg_sel[].
 *
 * Runs BEFORE regalloc (between hir_licm and hir_regalloc).
 *
 * Nonterminals:
 *   BG_REG   = value in a register
 *   BG_IMM   = compile-time constant (not yet materialized)
 *   BG_FADDR = frame-relative address (r30 + small offset)
 *   BG_SADDR = symbol address (needs lui)
 *   BG_STMT  = side-effect (no value produced)
 */

#define BG_REG    0
#define BG_IMM    1
#define BG_FADDR  2
#define BG_SADDR  3
#define BG_STMT   4
#define BG_NNT    5
#define BG_INF    999999

/* --- Pattern table --- */
#define BG_MAX_PAT 128

static int bg_pnt[BG_MAX_PAT];     /* result nonterminal */
static int bg_pop[BG_MAX_PAT];     /* HIR operator */
static int bg_plnt[BG_MAX_PAT];    /* left child required NT (-1 = leaf) */
static int bg_prnt[BG_MAX_PAT];    /* right child required NT (-1 = none) */
static int bg_pcost[BG_MAX_PAT];   /* base cost */
static int bg_npat;

/* Per-operator index (41 ops + 1 sentinel = 42) */
#define BG_MAX_OP 55
#define BG_OP_SZ 56
static int bg_ofirst[BG_OP_SZ];
static int bg_ocount[BG_OP_SZ];
static int bg_sorted[BG_MAX_PAT];

/* Chain rules */
#define BG_MAX_CHAIN 8
static int bg_cfrom[BG_MAX_CHAIN];
static int bg_cto[BG_MAX_CHAIN];
static int bg_ccost[BG_MAX_CHAIN];
static int bg_nchain;

/* Per-instruction labeling: 8192 * 5 = 40960 entries.
 * Covers functions up to 8192 HIR instructions.
 * Functions exceeding this skip BURG (codegen falls back). */
#define BG_MAX_INST 262144   /* was 8192 */
#define BG_COST_SZ (BG_MAX_INST * BG_NNT)   /* was 40960 = 8192 * 5, the old ceiling: a function past 8192 instructions indexed off both tables into their neighbours, and sqlite3VdbeExec got garbage costs, rules, folds and symbol names from it */
static int bg_cost[BG_COST_SZ];
static int bg_rule[BG_COST_SZ];

/* Selection output */
static int bg_sel[HIR_MAX_INST];

/* Folding */
static int bg_fold[HIR_MAX_INST];  /* 1 = folded into parent */
static int bg_uses[HIR_MAX_INST];  /* use count per value */
static int bg_foff[HIR_MAX_INST];  /* precomputed faddr offset */
static int bg_ssym[HIR_MAX_INST];  /* base symbol inst for SADDR chain (-1=none) */
static int bg_soff[HIR_MAX_INST];  /* accumulated offset for SADDR chain */

/* Stats */
static int bg_stat_folded;
static int bg_stat_cand;
static int bg_stat_rej_uses;
static int bg_stat_rej_remat;
static int bg_stat_rej_blk;
static int bg_stat_rej_cost;
static int bg_stat_sel_total;
static int bg_stat_sel_chain;
static int bg_stat_sel_imm;
static int bg_stat_sel_faddr;
static int bg_stat_sel_saddr;
static int bg_stat_sel_op[BG_OP_SZ];
static int bg_stat_sel_pat[BG_MAX_PAT];
static int bg_stat_iconst_total;
static int bg_stat_iconst_imm_only;
static int bg_stat_iconst_nonimm;
static int bg_stat_iconst_unused;
static int bg_stat_burg_skipped;
static int bg_iconst_seen_use[HIR_MAX_INST];
static int bg_iconst_seen_nonimm[HIR_MAX_INST];
static int bg_stat_iconst_use_op[BG_OP_SZ];
static int bg_stat_iconst_nonimm_use_op[BG_OP_SZ];

/* Init flag */
static int bg_inited;

/* --- Registration --- */

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

/* --- Pattern initialization --- */

static void bg_init(void) {
    bg_npat = 0;
    bg_nchain = 0;

    /* Leaves */
    bg_add_pat(BG_IMM,   HI_ICONST, -1, -1, 0);
    bg_add_pat(BG_REG,   HI_ICONST, -1, -1, 1);
    bg_add_pat(BG_FADDR, HI_ALLOCA, -1, -1, 0);
    bg_add_pat(BG_REG,   HI_ALLOCA, -1, -1, 1);
    bg_add_pat(BG_SADDR, HI_GADDR,  -1, -1, 0);
    bg_add_pat(BG_REG,   HI_GADDR,  -1, -1, 2);
    bg_add_pat(BG_SADDR, HI_SADDR,  -1, -1, 0);
    bg_add_pat(BG_REG,   HI_SADDR,  -1, -1, 2);
    bg_add_pat(BG_SADDR, HI_FADDR,  -1, -1, 0);
    bg_add_pat(BG_REG,   HI_FADDR,  -1, -1, 2);
    bg_add_pat(BG_REG,   HI_PARAM,  -1, -1, 1);
    bg_add_pat(BG_REG,   HI_GETFP,  -1, -1, 1);

    /* Addressing: LOAD */
    bg_add_pat(BG_REG,  HI_LOAD, BG_FADDR, -1, 1);
    bg_add_pat(BG_REG,  HI_LOAD, BG_SADDR, -1, 2);
    bg_add_pat(BG_REG,  HI_LOAD, BG_REG,   -1, 1);

    /* Addressing: STORE */
    bg_add_pat(BG_STMT, HI_STORE, BG_FADDR, BG_REG, 1);
    bg_add_pat(BG_STMT, HI_STORE, BG_SADDR, BG_REG, 2);
    bg_add_pat(BG_STMT, HI_STORE, BG_REG,   BG_REG, 1);

    /* ADDI */
    bg_add_pat(BG_IMM,   HI_ADDI, BG_IMM, -1, 0);
    bg_add_pat(BG_FADDR, HI_ADDI, BG_FADDR, -1, 0);
    bg_add_pat(BG_SADDR, HI_ADDI, BG_SADDR, -1, 0);
    bg_add_pat(BG_REG,   HI_ADDI, BG_FADDR, -1, 1);
    bg_add_pat(BG_REG,   HI_ADDI, BG_REG,   -1, 1);

    /* Binary arithmetic/logic/comparison */
    bg_add_pat(BG_REG, HI_ADD,  BG_REG, BG_IMM, 1);
    bg_add_pat(BG_REG, HI_ADD,  BG_IMM, BG_REG, 1);
    bg_add_pat(BG_REG, HI_SUB,  BG_REG, BG_IMM, 1);
    bg_add_pat(BG_REG, HI_AND,  BG_REG, BG_IMM, 1);
    bg_add_pat(BG_REG, HI_AND,  BG_IMM, BG_REG, 1);
    bg_add_pat(BG_REG, HI_OR,   BG_REG, BG_IMM, 1);
    bg_add_pat(BG_REG, HI_OR,   BG_IMM, BG_REG, 1);
    bg_add_pat(BG_REG, HI_XOR,  BG_REG, BG_IMM, 1);
    bg_add_pat(BG_REG, HI_XOR,  BG_IMM, BG_REG, 1);
    bg_add_pat(BG_REG, HI_SLL,  BG_REG, BG_IMM, 1);
    bg_add_pat(BG_REG, HI_SRL,  BG_REG, BG_IMM, 1);
    bg_add_pat(BG_REG, HI_SRA,  BG_REG, BG_IMM, 1);
    bg_add_pat(BG_REG, HI_SEQ,  BG_REG, BG_IMM, 1);
    bg_add_pat(BG_REG, HI_SEQ,  BG_IMM, BG_REG, 1);
    bg_add_pat(BG_REG, HI_SNE,  BG_REG, BG_IMM, 1);
    bg_add_pat(BG_REG, HI_SNE,  BG_IMM, BG_REG, 1);
    bg_add_pat(BG_REG, HI_SLT,  BG_REG, BG_IMM, 1);
    bg_add_pat(BG_REG, HI_SLTU, BG_REG, BG_IMM, 1);
    bg_add_pat(BG_REG, HI_ADD,  BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_SUB,  BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_MUL,  BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_MULH, BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_MULHU, BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_DIV,  BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_REM,  BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_AND,  BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_OR,   BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_XOR,  BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_SLL,  BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_SRA,  BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_SRL,  BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_SEQ,  BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_SNE,  BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_SLT,  BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_SGT,  BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_SLE,  BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_SGE,  BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_SLTU, BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_SGTU, BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_SLEU, BG_REG, BG_REG, 1);
    bg_add_pat(BG_REG, HI_SGEU, BG_REG, BG_REG, 1);

    /* Unary */
    bg_add_pat(BG_REG, HI_NEG,  BG_REG, -1, 1);
    bg_add_pat(BG_REG, HI_NOT,  BG_REG, -1, 1);
    bg_add_pat(BG_REG, HI_BNOT, BG_REG, -1, 2);
    bg_add_pat(BG_IMM, HI_COPY, BG_IMM, -1, 0);
    bg_add_pat(BG_REG, HI_COPY, BG_REG, -1, 0);

    /* Control flow */
    bg_add_pat(BG_STMT, HI_BR,  -1, -1, 1);
    bg_add_pat(BG_STMT, HI_BRC, BG_REG, -1, 2);
    bg_add_pat(BG_STMT, HI_RET, -1, -1, 1);

    /* Calls */
    bg_add_pat(BG_REG, HI_CALL,  -1, -1, 3);
    bg_add_pat(BG_REG, HI_CALLP, BG_REG, -1, 3);

    /* PHI */
    bg_add_pat(BG_REG, HI_PHI, -1, -1, 0);

    /* Chain rules */
    bg_add_chain(BG_IMM,   BG_REG, 1);
    bg_add_chain(BG_FADDR, BG_REG, 1);
    bg_add_chain(BG_SADDR, BG_REG, 2);
}

/* --- Build per-operator index --- */

static void bg_build_index(void) {
    int op;
    int i;
    int j;

    op = 0;
    while (op <= BG_MAX_OP) {
        bg_ocount[op] = 0;
        op = op + 1;
    }

    i = 0;
    while (i < bg_npat) {
        op = bg_pop[i];
        if (op >= 0 && op <= BG_MAX_OP) {
            bg_ocount[op] = bg_ocount[op] + 1;
        }
        i = i + 1;
    }

    bg_ofirst[0] = 0;
    op = 1;
    while (op <= BG_MAX_OP) {
        bg_ofirst[op] = bg_ofirst[op - 1] + bg_ocount[op - 1];
        op = op + 1;
    }

    op = 0;
    while (op <= BG_MAX_OP) {
        bg_ocount[op] = 0;
        op = op + 1;
    }

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

static int bg_faddr_ok(int idx) {
    int off;
    off = h_val[idx];
    return (off >= -2048 && off <= 2047);
}

static int bg_faddr_offset(int idx) {
    int k;
    k = h_kind[idx];
    if (k == HI_ALLOCA) return h_val[idx];
    if (k == HI_ADDI) {
        return h_val[idx] + bg_faddr_offset(h_src1[idx]);
    }
    return 0;
}

static int bg_addi_faddr_ok(int idx) {
    int off;
    off = bg_faddr_offset(idx);
    return (off >= -2048 && off <= 2047);
}

static int bg_const_imm_inst(int inst, int *out, int *root_iconst) {
    int k;
    int acc;
    int lim;

    acc = 0;
    lim = 0;
    while (inst >= 0 && lim < 64) {
        k = h_kind[inst];
        if (k == HI_ICONST) {
            *out = acc + h_val[inst];
            *root_iconst = inst;
            return 1;
        }
        if (k == HI_COPY) {
            inst = h_src1[inst];
            lim = lim + 1;
            continue;
        }
        if (k == HI_ADDI) {
            acc = acc + h_val[inst];
            inst = h_src1[inst];
            lim = lim + 1;
            continue;
        }
        return 0;
    }
    return 0;
}

static int bg_is_i12(int v) {
    return (v >= -2048 && v <= 2047);
}

static int bg_is_u12(int v) {
    return (v >= 0 && v <= 4095);
}

/* Is src2 an instruction reference (not a block number)? */
static int bg_src2_is_ref(int k) {
    if (hi_is_binop(k)) return 1;
    if (k == HI_STORE) return 1;
    if (k == HI_RET) return 1;
    if (k >= HI_FADD && k <= HI_FDIV) return 1;
    if (k >= HI_FEQ && k <= HI_FLE) return 1;
    return 0;
}

static int bg_use_accepts_imm(int user, int pos, int c) {
    int k;
    k = h_kind[user];

    if (k == HI_COPY && pos == 1) return 1;     /* transit */
    if (k == HI_ADDI && pos == 1) return 1;     /* transit */
    if (k == HI_ADD) return bg_is_i12(c);
    if (k == HI_SUB && pos == 2) {
        if (c == -2147483647 - 1) return 0;
        return bg_is_i12(0 - c);
    }
    if ((k == HI_AND || k == HI_OR || k == HI_XOR)) return bg_is_u12(c);
    if ((k == HI_SLL || k == HI_SRL || k == HI_SRA) && pos == 2) return (c >= 0 && c <= 31);
    if (k == HI_SEQ || k == HI_SNE) return bg_is_u12(c);
    if ((k == HI_SLT || k == HI_SLTU) && pos == 2) return bg_is_i12(c);
    if ((k == HI_SLE || k == HI_SLEU) && pos == 1) return bg_is_i12(c);
    if ((k == HI_SGT || k == HI_SGTU) && pos == 1) return bg_is_i12(c);
    if ((k == HI_SGE || k == HI_SGEU) && pos == 2) return bg_is_i12(c);
    if ((k == HI_SGT || k == HI_SGTU) && pos == 2) {
        if ((k == HI_SGT && c == 2147483647) || (k == HI_SGTU && c == -1)) return 1;
        return bg_is_i12(c + 1);
    }
    if ((k == HI_SLE || k == HI_SLEU) && pos == 2) {
        if ((k == HI_SLE && c == 2147483647) || (k == HI_SLEU && c == -1)) return 1;
        return bg_is_i12(c + 1);
    }
    if (k == HI_RET && pos == 1) return 1;
    if (k == HI_BRC && pos == 1) return 1;
    if (k == HI_CALLP && pos == 1) return 1;
    if (k == HI_STORE && pos == 2 && c == 0) return 1;
    return 0;
}

static void bg_profile_iconst_consumers(void) {
    int i;
    int j;
    int k;
    int base;
    int cnt;
    int root;
    int c;
    int v;

    /* Reset per-instruction flags (per-function) */
    i = 0;
    while (i < h_ninst) {
        bg_iconst_seen_use[i] = 0;
        bg_iconst_seen_nonimm[i] = 0;
        i = i + 1;
    }
    /* Note: bg_stat_iconst_use_op[] and bg_stat_iconst_nonimm_use_op[]
     * are NOT reset here — they accumulate across functions. */

    i = 0;
    while (i < h_ninst) {
        k = h_kind[i];
        if (k != HI_NOP) {
            v = h_src1[i];
            if (v >= 0 && bg_const_imm_inst(v, &c, &root)) {
                bg_iconst_seen_use[root] = 1;
                if (k >= 0 && k <= BG_MAX_OP) bg_stat_iconst_use_op[k] = bg_stat_iconst_use_op[k] + 1;
                if (!bg_use_accepts_imm(i, 1, c)) {
                    bg_iconst_seen_nonimm[root] = 1;
                    if (k >= 0 && k <= BG_MAX_OP) {
                        bg_stat_iconst_nonimm_use_op[k] = bg_stat_iconst_nonimm_use_op[k] + 1;
                    }
                }
            }
            v = h_src2[i];
            if (v >= 0 && bg_src2_is_ref(k) && bg_const_imm_inst(v, &c, &root)) {
                bg_iconst_seen_use[root] = 1;
                if (k >= 0 && k <= BG_MAX_OP) bg_stat_iconst_use_op[k] = bg_stat_iconst_use_op[k] + 1;
                if (!bg_use_accepts_imm(i, 2, c)) {
                    bg_iconst_seen_nonimm[root] = 1;
                    if (k >= 0 && k <= BG_MAX_OP) {
                        bg_stat_iconst_nonimm_use_op[k] = bg_stat_iconst_nonimm_use_op[k] + 1;
                    }
                }
            }

            if (k == HI_CALL || k == HI_CALLP) {
                base = h_cbase[i];
                cnt = h_val[i];
                j = 0;
                while (j < cnt) {
                    v = h_carg[base + j];
                    if (v >= 0 && bg_const_imm_inst(v, &c, &root)) {
                        bg_iconst_seen_use[root] = 1;
                        bg_stat_iconst_use_op[k] = bg_stat_iconst_use_op[k] + 1;
                    }
                    j = j + 1;
                }
            }

            if (k == HI_PHI) {
                base = h_pbase[i];
                cnt = h_pcnt[i];
                j = 0;
                while (j < cnt) {
                    v = h_pval[base + j];
                    if (v >= 0 && bg_const_imm_inst(v, &c, &root)) {
                        bg_iconst_seen_use[root] = 1;
                        bg_stat_iconst_use_op[k] = bg_stat_iconst_use_op[k] + 1;
                    }
                    j = j + 1;
                }
            }
        }
        i = i + 1;
    }

    i = 0;
    while (i < h_ninst) {
        if (h_kind[i] == HI_ICONST) {
            bg_stat_iconst_total = bg_stat_iconst_total + 1;
            if (!bg_iconst_seen_use[i]) {
                bg_stat_iconst_unused = bg_stat_iconst_unused + 1;
            } else if (!bg_iconst_seen_nonimm[i]) {
                bg_stat_iconst_imm_only = bg_stat_iconst_imm_only + 1;
            } else {
                bg_stat_iconst_nonimm = bg_stat_iconst_nonimm + 1;
            }
        }
        i = i + 1;
    }
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
    while (i < h_ninst) {
        bg_uses[i] = 0;
        i = i + 1;
    }

    i = 0;
    while (i < h_ninst) {
        k = h_kind[i];
        if (k == HI_NOP) { i = i + 1; continue; }

        if (h_src1[i] >= 0) bg_uses[h_src1[i]] = bg_uses[h_src1[i]] + 1;
        if (h_src2[i] >= 0 && bg_src2_is_ref(k)) bg_uses[h_src2[i]] = bg_uses[h_src2[i]] + 1;

        /* CALL/CALLP args */
        if (k == HI_CALL || k == HI_CALLP) {
            base = h_cbase[i];
            cnt = h_val[i];
            j = 0;
            while (j < cnt) {
                if (h_carg[base + j] >= 0) {
                    bg_uses[h_carg[base + j]] = bg_uses[h_carg[base + j]] + 1;
                }
                j = j + 1;
            }
        }

        /* PHI args */
        if (k == HI_PHI) {
            base = h_pbase[i];
            cnt = h_pcnt[i];
            j = 0;
            while (j < cnt) {
                if (h_pval[base + j] >= 0) {
                    bg_uses[h_pval[base + j]] = bg_uses[h_pval[base + j]] + 1;
                }
                j = j + 1;
            }
        }

        i = i + 1;
    }
}

/* --- Precompute frame-relative and symbol-relative offsets --- */

static int bg_is_sym(int k) {
    return k == HI_GADDR || k == HI_SADDR || k == HI_FADDR;
}

static char bg_fdone[HIR_MAX_INST];   /* bg_foff_one: computed this function */
static int  bg_walk[HIR_MAX_INST];    /* explicit stack: operand chains are not host recursion (GitHub issue 56) */

/* Push onto bg_walk with a bound.  A node is marked done when it first
 * reaches the TOP, not when it is pushed, so a shared operand can sit on
 * the stack more than once and the depth is bounded by 2*h_ninst, not by
 * h_ninst.  Measured max over all of sqlite3.c is 5 -- HIR operand trees
 * are shallow -- so this never fires on real code; it is here because an
 * unbounded write into a static array is how silent corruption starts. */
static int bg_walk_push(int sp, int v) {
    if (sp >= HIR_MAX_INST) {
        fdputs("s12cc: burg walk stack overflow\n", 2);
        exit(1);
    }
    bg_walk[sp] = v;
    return sp + 1;
}

/* Frame offset and symbol base of one instruction; an addi's operand
 * first, since the SSA pass appends allocas after their users. */
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
            if (k == HI_ADDI && s1 >= 0 && s1 < h_ninst && !bg_fdone[s1]) {
                sp = bg_walk_push(sp, s1);
                continue;
            }
        }
        k = h_kind[i];
        s1 = h_src1[i];
        if (k == HI_ALLOCA) {
            bg_foff[i] = h_val[i];
        } else if (k == HI_ADDI) {
            sk = -1;
            if (s1 >= 0) sk = h_kind[s1];
            if (sk == HI_ALLOCA || sk == HI_ADDI) {
                bg_foff[i] = bg_foff[s1] + h_val[i];
            } else {
                bg_foff[i] = 0;
            }
        } else {
            bg_foff[i] = 0;
        }
        /* Symbol offsets for SADDR chains */
        if (bg_is_sym(k)) {
            bg_ssym[i] = i;
            bg_soff[i] = 0;
        } else if (k == HI_ADDI) {
            if (s1 >= 0 && bg_ssym[s1] >= 0) {
                bg_ssym[i] = bg_ssym[s1];
                bg_soff[i] = bg_soff[s1] + h_val[i];
            } else {
                bg_ssym[i] = -1;
                bg_soff[i] = 0;
            }
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
    while (i < h_ninst) {
        bg_fdone[i] = 0;
        i = i + 1;
    }
    i = 0;
    while (i < h_ninst) {
        bg_foff_one(i);
        i = i + 1;
    }
}

/* --- Bottom-up labeling --- */

static char bg_done[HIR_MAX_INST];   /* bg_label_one: labeled this function */

/* Is src2 a value operand for this kind (a branch's src2 is a block)? */
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
        if (k == HI_NOP || k < 0 || k > BG_MAX_OP) {
            sp = sp - 1;
            continue;
        }
        s1 = h_src1[i];
        s2 = h_src2[i];
        /* Operands defined AFTER their user -- the allocas the SSA pass
         * appends, the phis at the end of the array -- are labeled first,
         * or this instruction sees only infinite costs, gets no rule, and
         * the emitter reads a nonterminal off the end of a table (SQLite's
         * sqlite3VdbeExec loaded db->aDb through a symbol named by garbage).
         * Walk them with bg_walk, not host recursion: a 50k ADDI chain
         * blew the stack (GitHub issue 56). */
        pushed = 0;
        if (s1 >= 0 && s1 < h_ninst && !bg_done[s1]) {
            sp = bg_walk_push(sp, s1);
            pushed = 1;
        }
        if (s2 >= 0 && s2 < h_ninst && bg_src2_is_value(k) && !bg_done[s2]) {
            sp = bg_walk_push(sp, s2);
            pushed = 1;
        }
        if (pushed) continue;
    }
    k = h_kind[i];
    if (k == HI_NOP || k < 0 || k > BG_MAX_OP) {
        sp = sp - 1;
        continue;
    }
    s1 = h_src1[i];
    s2 = h_src2[i];

    /* Try all patterns for this operator */
    pi = 0;
    while (pi < bg_ocount[k]) {
        pat = bg_sorted[bg_ofirst[k] + pi];
        lnt = bg_plnt[pat];
        rnt = bg_prnt[pat];
        cost = bg_pcost[pat];

        /* Guard: faddr -> ALLOCA requires small offset */
        if (k == HI_ALLOCA && bg_pnt[pat] == BG_FADDR) {
            if (!bg_faddr_ok(i)) { pi = pi + 1; continue; }
        }

        /* Guard: faddr -> ADDI(faddr) requires combined offset fits */
        if (k == HI_ADDI && bg_pnt[pat] == BG_FADDR) {
            if (!bg_addi_faddr_ok(i)) { pi = pi + 1; continue; }
        }

        /* Check left child */
        if (lnt >= 0) {
            if (s1 < 0 || bg_cost[s1 * BG_NNT + lnt] >= BG_INF) {
                pi = pi + 1;
                continue;
            }
            cost = cost + bg_cost[s1 * BG_NNT + lnt];
        }

        /* Check right child */
        if (rnt >= 0) {
            if (s2 < 0 || bg_cost[s2 * BG_NNT + rnt] >= BG_INF) {
                pi = pi + 1;
                continue;
            }
            cost = cost + bg_cost[s2 * BG_NNT + rnt];
        }

        /* Update if better */
        dst = i * BG_NNT + bg_pnt[pat];
        if (cost < bg_cost[dst]) {
            bg_cost[dst] = cost;
            bg_rule[dst] = pat;
        }

        pi = pi + 1;
    }

    /* Apply chain rules */
    ci = 0;
    while (ci < bg_nchain) {
        base_idx = i * BG_NNT + bg_cfrom[ci];
        if (bg_cost[base_idx] < BG_INF) {
            cost = bg_cost[base_idx] + bg_ccost[ci];
            dst = i * BG_NNT + bg_cto[ci];
            if (cost < bg_cost[dst]) {
                bg_cost[dst] = cost;
                /* Chain encodes as <= -2; -1 means no rule. */
                bg_rule[dst] = -(ci + 2);
            }
        }
        ci = ci + 1;
    }

    sp = sp - 1;
    }

}

static void bg_label(void) {
    int i;

    /* Initialize all costs to INF */
    i = 0;
    while (i < h_ninst * BG_NNT) {
        bg_cost[i] = BG_INF;
        bg_rule[i] = -1;
        i = i + 1;
    }
    i = 0;
    while (i < h_ninst) {
        bg_done[i] = 0;
        i = i + 1;
    }

    /* Label each instruction, operands first */
    i = 0;
    while (i < h_ninst) {
        bg_label_one(i);
        i = i + 1;
    }
}

/* --- Top-down selection --- */

/* Kinds a parent's pattern can regenerate once the child is folded away. */
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

    /* Phase 1: Init and select all patterns */
    i = 0;
    while (i < h_ninst) {
        bg_sel[i] = -1;
        bg_fold[i] = 0;
        i = i + 1;
    }

    /* Note: stats accumulate across all functions (not reset here) */

    i = 0;
    while (i < h_ninst) {
        k = h_kind[i];
        if (k == HI_NOP) { i = i + 1; continue; }

        if (!hi_has_value(k)) {
            nt = BG_STMT;
        } else {
            nt = BG_REG;
        }

        bg_sel[i] = bg_rule[i * BG_NNT + nt];
        if (bg_sel[i] >= 0) {
            pat = bg_sel[i];
            k = bg_pop[pat];
            bg_stat_sel_total = bg_stat_sel_total + 1;
            if (k >= 0 && k <= BG_MAX_OP) {
                bg_stat_sel_op[k] = bg_stat_sel_op[k] + 1;
            }
            if (pat >= 0 && pat < BG_MAX_PAT) {
                bg_stat_sel_pat[pat] = bg_stat_sel_pat[pat] + 1;
            }
            lnt = bg_plnt[pat];
            rnt = bg_prnt[pat];
            if (lnt == BG_IMM || rnt == BG_IMM) bg_stat_sel_imm = bg_stat_sel_imm + 1;
            if (lnt == BG_FADDR || rnt == BG_FADDR) bg_stat_sel_faddr = bg_stat_sel_faddr + 1;
            if (lnt == BG_SADDR || rnt == BG_SADDR) bg_stat_sel_saddr = bg_stat_sel_saddr + 1;
        } else if (bg_sel[i] <= -2) {
            bg_stat_sel_chain = bg_stat_sel_chain + 1;
        }
        i = i + 1;
    }

    /* Phase 2: Fold single-use children into parents */
    i = 0;
    while (i < h_ninst) {
        pat = bg_sel[i];
        if (pat < 0) { i = i + 1; continue; }

        lnt = bg_plnt[pat];
        s1 = h_src1[i];

        /* Fold left child if: non-REG NT, single use, same block, viable,
         * and of a kind the parent's pattern can regenerate.  A phi met
         * every other test with a finite symbol-address cost and was
         * deleted: SQLite's OP_OpenRead read its cursor as a literal 0. */
        if (lnt >= 0 && lnt != BG_REG && s1 >= 0 && !bg_fold[s1] && bg_foldable(h_kind[s1])) {
            bg_stat_cand = bg_stat_cand + 1;
            if (hi_is_remat(h_kind[s1])) {
                bg_stat_rej_remat = bg_stat_rej_remat + 1;
            } else if (bg_uses[s1] != 1) {
                bg_stat_rej_uses = bg_stat_rej_uses + 1;
            } else if (h_blk[s1] != h_blk[i]) {
                bg_stat_rej_blk = bg_stat_rej_blk + 1;
            } else if (bg_cost[s1 * BG_NNT + lnt] >= BG_INF) {
                bg_stat_rej_cost = bg_stat_rej_cost + 1;
            } else if (h_kind[s1] != HI_NOP) {
                bg_fold[s1] = 1;
                bg_sel[s1] = -1;
                h_kind[s1] = HI_NOP;
                bg_stat_folded = bg_stat_folded + 1;
            }
        }

        rnt = bg_prnt[pat];
        s2 = h_src2[i];

        /* Fold right child (rare, but check for completeness) */
        if (rnt >= 0 && rnt != BG_REG && s2 >= 0 && !bg_fold[s2] && bg_foldable(h_kind[s2])) {
            if (bg_uses[s2] == 1
                && !hi_is_remat(h_kind[s2])
                && h_kind[s2] != HI_NOP
                && h_blk[s2] == h_blk[i]
                && bg_cost[s2 * BG_NNT + rnt] < BG_INF) {
                bg_fold[s2] = 1;
                bg_sel[s2] = -1;
                h_kind[s2] = HI_NOP;
                bg_stat_folded = bg_stat_folded + 1;
            }
        }

        i = i + 1;
    }
}

/* --- Entry point --- */

static void hir_burg(void) {
    int i;

    if (!bg_inited) {
        bg_init();
        bg_build_index();
        bg_inited = 1;
    }

    /* Always precompute foff (needed by codegen even in fallback) */
    bg_compute_foff();

    /* Skip BURG for functions with too many instructions */
    if (h_ninst > BG_MAX_INST) {
        /* Set bg_sel to -1: codegen falls back to h_kind dispatch */
        i = 0;
        while (i < h_ninst) {
            bg_sel[i] = -1;
            bg_fold[i] = 0;
            i = i + 1;
        }
        bg_stat_burg_skipped = bg_stat_burg_skipped + 1;
        return;
    }

    bg_label();
    bg_count_uses();
    bg_profile_iconst_consumers();
    /* bg_compute_foff already called above (before any NOP changes) */
    bg_select();  /* Phase 2 of select may NOP folded instructions */
}

/* ============================================================================
 * Compare-and-branch fusion identification
 *
 * Must live here (after bg_uses is available, before hir_regalloc.h)
 * so that regalloc can extend live ranges for fused comparison operands.
 * ============================================================================ */

static int hcg_brc_fuse[HIR_MAX_INST];   /* BRC idx -> fused comparison idx, -1 = none */
static int hcg_cmp_fused[HIR_MAX_INST];  /* 1 if comparison is fused into a BRC */
static int hcg_cmp_kind[HIR_MAX_INST];   /* saved comparison kind (before NOP) */

static int hcg_is_cmp(int k) {
    return (k >= HI_SEQ && k <= HI_SGEU);
}

static int hcg_fp64_kind(char *nm);   /* defined in hir_codegen.h */

static void hcg_identify_fusions(void) {
    int i;
    int k;
    int root;
    int rk;
    int lim;
    int ok;

    i = 0;
    while (i < h_ninst) {
        hcg_brc_fuse[i] = -1;
        hcg_cmp_fused[i] = 0;
        i = i + 1;
    }

    /* bg_uses is only valid when BURG ran (not skipped) */
    if (h_ninst > BG_MAX_INST) return;

    i = 0;
    while (i < h_ninst) {
        k = h_kind[i];
        if (k != HI_BRC) { i = i + 1; continue; }

        ok = 1;

        /* Chase COPY chain on s1 to find root value */
        root = h_src1[i];
        lim = 0;
        while (root >= 0 && h_kind[root] == HI_COPY && lim < 64) {
            if (bg_uses[root] != 1 || h_blk[root] != h_blk[i]) {
                ok = 0;
                break;
            }
            root = h_src1[root];
            lim = lim + 1;
        }
        if (!ok || root < 0) { i = i + 1; continue; }

        rk = h_kind[root];

        /* DIVERGENCE (f77, port upstream): an fp64 compare pseudo-call
         * (__fp64_eq/lt/le) leaves its flag in r1; when it is the
         * branch's only user, sits immediately before the BRC (nothing
         * whose emission could touch r1 in between -- so no copies, no
         * intervening instructions, and no LICM list on the block,
         * which emits between body and terminator), the BRC reads r1
         * directly and the r1 -> home-register move is skipped. */
        if (rk == HI_CALL && root == h_src1[i] &&
            hcg_fp64_kind(h_name[root]) >= 5 &&
            hcg_fp64_kind(h_name[root]) <= 7 &&
            bg_uses[root] == 1 && h_blk[root] == h_blk[i] &&
            licm_head[h_blk[i]] < 0) {
            int gap;
            int adj;
            adj = 1;
            gap = root + 1;
            while (gap < i) {
                if (h_kind[gap] != HI_NOP) { adj = 0; break; }
                gap = gap + 1;
            }
            if (adj) {
                hcg_brc_fuse[i] = root;
                hcg_cmp_fused[root] = 1;
                hcg_cmp_kind[root] = HI_CALL;   /* sentinel: flag in r1 */
                i = i + 1;
                continue;
            }
        }

        if (!hcg_is_cmp(rk)) { i = i + 1; continue; }
        if (bg_uses[root] != 1) { i = i + 1; continue; }
        if (h_blk[root] != h_blk[i]) { i = i + 1; continue; }

        /* Reject if either comparison operand was BURG-folded (NOPed).
         * Folded operands can't be materialized at BRC time. */
        if (h_src1[root] >= 0 && h_kind[h_src1[root]] == HI_NOP) {
            i = i + 1; continue;
        }
        if (h_src2[root] >= 0 && h_kind[h_src2[root]] == HI_NOP) {
            i = i + 1; continue;
        }

        hcg_brc_fuse[i] = root;
        hcg_cmp_fused[root] = 1;
        hcg_cmp_kind[root] = rk;

        /* Also mark intermediate COPYs for suppression */
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
