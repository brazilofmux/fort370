/* COPIED from slow32-public fortran/src/hir_opt.h at 2245be78 (2026-10-12).  See PROVENANCE.md. */
/* COPIED from selfhost/stage08/hir_opt.h at 30e16a57.  See note in hir.h. */
/* hir_opt.h -- SSA optimization passes for s12cc
 *
 * Runs after hir_ssa.h, before hir_codegen.h.
 * 1. Copy propagation (eliminate HI_COPY chains)
 * 2. Constant folding + strength reduction (MUL by pow2 -> SLL)
 * 3. Algebraic simplifications (identity/absorbing elements)
 * 4. Dead block elimination (NOP unreachable blocks after BRC->BR)
 * 5. PHI simplification (trivial phis -> COPY)
 * 6. Dead code elimination (remove unused value-producing instructions)
 */

/* Use count per instruction */
static hir_ix ho_use[HIR_MAX_INST];
static char ho_phi_vouched[HIR_MAX_INST];   /* ho_count_uses: this live phi has counted its args */

/* Resolve COPY chains: follow src1 until non-COPY */
static int ho_resolve(int inst) {
    int depth;
    depth = 0;
    while (inst >= 0 && h_kind[inst] == HI_COPY && depth < 100) {
        inst = h_src1[inst];
        depth = depth + 1;
    }
    return inst;
}

/* Is src2 an instruction reference (not a block number)? */
static int ho_src2_is_ref(int k) {
    if (hi_is_binop(k)) return 1;
    if (k == HI_STORE) return 1;
    if (k == HI_RET) return 1;
    /* FP binary ops: FADD..FDIV, FEQ/FLT/FLE */
    if (k >= HI_FADD && k <= HI_FDIV) return 1;
    if (k >= HI_FEQ && k <= HI_FLE) return 1;
    return 0;
}

/* ----------------------------------------------------------------
 * Pass 1: Copy propagation
 * Rewrite all instruction references through COPY chains.
 * Also inline rematerializable COPY sources (COPY of ICONST -> ICONST).
 * ---------------------------------------------------------------- */

static int ho_copy_prop(void) {
    int changed;
    int i;
    int j;
    int k;
    int r;
    int base;
    int cnt;

    changed = 0;
    i = 0;
    while (i < h_ninst) {
        k = h_kind[i];
        if (k == HI_NOP) { i = i + 1; continue; }

        /* Rewrite src1 */
        if (h_src1[i] >= 0) {
            r = ho_resolve(h_src1[i]);
            if (r != h_src1[i]) {
                h_src1[i] = r;
                changed = 1;
            }
        }

        /* Rewrite src2 (only if it's an instruction ref, not a block number) */
        if (h_src2[i] >= 0 && ho_src2_is_ref(k)) {
            r = ho_resolve(h_src2[i]);
            if (r != h_src2[i]) {
                h_src2[i] = r;
                changed = 1;
            }
        }

        /* Rewrite call args */
        if ((k == HI_CALL || k == HI_CALLP ||
             k == HI_A64_DBT_TRAMPOLINE || k == HI_X64_DBT_TRAMPOLINE) &&
            h_cbase[i] >= 0) {
            base = h_cbase[i];
            cnt = h_val[i];
            j = 0;
            while (j < cnt) {
                if (h_carg[base + j] >= 0) {
                    r = ho_resolve(h_carg[base + j]);
                    if (r != h_carg[base + j]) {
                        h_carg[base + j] = r;
                        changed = 1;
                    }
                }
                j = j + 1;
            }
        }

        /* Rewrite PHI args */
        if (k == HI_PHI && h_pbase[i] >= 0) {
            j = 0;
            while (j < h_pcnt[i]) {
                if (h_pval[h_pbase[i] + j] >= 0) {
                    r = ho_resolve(h_pval[h_pbase[i] + j]);
                    if (r != h_pval[h_pbase[i] + j]) {
                        h_pval[h_pbase[i] + j] = r;
                        changed = 1;
                    }
                }
                j = j + 1;
            }
        }

        /* Inline rematerializable COPY sources:
         * COPY of ICONST -> ICONST (saves a spill slot) */
        if (k == HI_COPY && h_src1[i] >= 0 &&
            h_kind[h_src1[i]] == HI_ICONST) {
            h_kind[i] = HI_ICONST;
            h_val[i] = h_val[h_src1[i]];
            h_src1[i] = -1;
            changed = 1;
        }

        i = i + 1;
    }
    return changed;
}

/* ----------------------------------------------------------------
 * Pass 2: Constant folding and algebraic simplifications
 * ---------------------------------------------------------------- */

static int ho_const_fold(void) {
    int changed;
    int i;
    int k;
    int a;
    int b;
    int result;
    int can_fold;
    int s1c;
    int s2c;
    int shift;
    int tmp;
    int ci;

    changed = 0;
    i = 0;
    while (i < h_ninst) {
        k = h_kind[i];

        /* === Binop optimizations === */
        if (hi_is_binop(k)) {
            s1c = (h_src1[i] >= 0 && h_kind[h_src1[i]] == HI_ICONST);
            s2c = (h_src2[i] >= 0 && h_kind[h_src2[i]] == HI_ICONST);

#ifdef S12CC_X64_HOST
            /* On x64, skip constant folding for TY_LLONG operations:
             * h_val is 32-bit and can't hold 64-bit results. */
            if (ty_is_llong(h_ty[i])) { i = i + 1; continue; }
#endif

            if (s1c && s2c) {
                /* Both operands constant: evaluate at compile time */
                a = h_val[h_src1[i]];
                b = h_val[h_src2[i]];
                result = 0;
                can_fold = 1;

                if      (k == HI_ADD) result = a + b;
                else if (k == HI_SUB) result = a - b;
                else if (k == HI_MUL) result = a * b;
                else if (k == HI_MULH) result = (int)(((long long)a * (long long)b) >> 32);
                else if (k == HI_MULHU) result = (int)(((unsigned long long)(unsigned)a * (unsigned long long)(unsigned)b) >> 32);
                else if (k == HI_DIV) {
                    if (b != 0) result = a / b; else can_fold = 0;
                }
                else if (k == HI_REM) {
                    if (b != 0) result = a % b; else can_fold = 0;
                }
                else if (k == HI_AND) result = a & b;
                else if (k == HI_OR)  result = a | b;
                else if (k == HI_XOR) result = a ^ b;
                else if (k == HI_SLL) result = a << (b & 31);
                else if (k == HI_SRA) result = a >> (b & 31);
                else if (k == HI_SRL) result = (int)((unsigned int)a >> (b & 31));
                else if (k == HI_SEQ) {
                    if (a == b) result = 1; else result = 0;
                }
                else if (k == HI_SNE) {
                    if (a != b) result = 1; else result = 0;
                }
                else if (k == HI_SLT) {
                    if (a < b) result = 1; else result = 0;
                }
                else if (k == HI_SGT) {
                    if (a > b) result = 1; else result = 0;
                }
                else if (k == HI_SLE) {
                    if (a <= b) result = 1; else result = 0;
                }
                else if (k == HI_SGE) {
                    if (a >= b) result = 1; else result = 0;
                }
                else if (k == HI_SLTU) {
                    if ((unsigned int)a < (unsigned int)b) result = 1; else result = 0;
                }
                else if (k == HI_SGTU) {
                    if ((unsigned int)a > (unsigned int)b) result = 1; else result = 0;
                }
                else if (k == HI_SLEU) {
                    if ((unsigned int)a <= (unsigned int)b) result = 1; else result = 0;
                }
                else if (k == HI_SGEU) {
                    if ((unsigned int)a >= (unsigned int)b) result = 1; else result = 0;
                }
                else can_fold = 0;

                if (can_fold) {
                    h_kind[i] = HI_ICONST;
                    h_val[i] = result;
                    h_src1[i] = -1;
                    h_src2[i] = -1;
                    changed = 1;
                }
            } else if (s2c) {
                /* Right operand constant: identity/absorbing simplifications */
                b = h_val[h_src2[i]];

                /* x + 0, x - 0, x | 0, x ^ 0, x << 0, x >> 0 -> x */
                if (b == 0 && (k == HI_ADD || k == HI_SUB || k == HI_OR ||
                               k == HI_XOR || k == HI_SLL || k == HI_SRA ||
                               k == HI_SRL)) {
                    h_kind[i] = HI_COPY;
                    h_src2[i] = -1;
                    changed = 1;
                }
                /* SNE(cmp,0) -> COPY(cmp) when cmp produces 0/1 */
                else if (k == HI_SNE && b == 0 && h_src1[i] >= 0 &&
                         h_kind[h_src1[i]] >= HI_SEQ &&
                         h_kind[h_src1[i]] <= HI_SGEU) {
                    h_kind[i] = HI_COPY;
                    h_src2[i] = -1;
                    changed = 1;
                }
                /* SEQ(cmp,0) -> NOT(cmp) when cmp produces 0/1 */
                else if (k == HI_SEQ && b == 0 && h_src1[i] >= 0 &&
                         h_kind[h_src1[i]] >= HI_SEQ &&
                         h_kind[h_src1[i]] <= HI_SGEU) {
                    h_kind[i] = HI_NOT;
                    h_src2[i] = -1;
                    changed = 1;
                }
                /* x * 1 -> x, x / 1 -> x */
                else if ((k == HI_MUL || k == HI_DIV) && b == 1) {
                    h_kind[i] = HI_COPY;
                    h_src2[i] = -1;
                    changed = 1;
                }
                /* x % 1 -> 0 */
                else if (k == HI_REM && b == 1) {
                    h_kind[i] = HI_ICONST;
                    h_val[i] = 0;
                    h_src1[i] = -1;
                    h_src2[i] = -1;
                    changed = 1;
                }
                /* x * 0 -> 0, x & 0 -> 0 */
                else if ((k == HI_MUL || k == HI_AND) && b == 0) {
                    h_kind[i] = HI_ICONST;
                    h_val[i] = 0;
                    h_src1[i] = -1;
                    h_src2[i] = -1;
                    changed = 1;
                }
                /* x & -1 -> x */
                else if (k == HI_AND && b == -1) {
                    h_kind[i] = HI_COPY;
                    h_src2[i] = -1;
                    changed = 1;
                }
                /* x | -1 -> -1 */
                else if (k == HI_OR && b == -1) {
                    h_kind[i] = HI_ICONST;
                    h_val[i] = -1;
                    h_src1[i] = -1;
                    h_src2[i] = -1;
                    changed = 1;
                }
                /* x ^ -1 -> ~x */
                else if (k == HI_XOR && b == -1) {
                    h_kind[i] = HI_BNOT;
                    h_src2[i] = -1;
                    changed = 1;
                }
            } else if (s1c) {
                /* Left operand constant: identity/absorbing simplifications */
                a = h_val[h_src1[i]];

                /* 0 + x -> x */
                if (k == HI_ADD && a == 0) {
                    h_kind[i] = HI_COPY;
                    h_src1[i] = h_src2[i];
                    h_src2[i] = -1;
                    changed = 1;
                }
                /* 1 * x -> x */
                else if (k == HI_MUL && a == 1) {
                    h_kind[i] = HI_COPY;
                    h_src1[i] = h_src2[i];
                    h_src2[i] = -1;
                    changed = 1;
                }
                /* 0 * x -> 0, 0 & x -> 0 */
                else if ((k == HI_MUL || k == HI_AND) && a == 0) {
                    h_kind[i] = HI_ICONST;
                    h_val[i] = 0;
                    h_src1[i] = -1;
                    h_src2[i] = -1;
                    changed = 1;
                }
                /* 0 | x -> x, 0 ^ x -> x */
                else if ((k == HI_OR || k == HI_XOR) && a == 0) {
                    h_kind[i] = HI_COPY;
                    h_src1[i] = h_src2[i];
                    h_src2[i] = -1;
                    changed = 1;
                }
                /* -1 & x -> x */
                else if (k == HI_AND && a == -1) {
                    h_kind[i] = HI_COPY;
                    h_src1[i] = h_src2[i];
                    h_src2[i] = -1;
                    changed = 1;
                }
                /* -1 | x -> -1 */
                else if (k == HI_OR && a == -1) {
                    h_kind[i] = HI_ICONST;
                    h_val[i] = -1;
                    h_src1[i] = -1;
                    h_src2[i] = -1;
                    changed = 1;
                }
                /* -1 ^ x -> ~x */
                else if (k == HI_XOR && a == -1) {
                    h_kind[i] = HI_BNOT;
                    h_src1[i] = h_src2[i];
                    h_src2[i] = -1;
                    changed = 1;
                }
            }

            /* Strength reduction: MUL by power-of-2 -> SLL */
            if (h_kind[i] == HI_MUL) {
                if (s2c) {
                    b = h_val[h_src2[i]];
                    if (b > 0 && (b & (b - 1)) == 0) {
                        shift = 0; tmp = b;
                        while (tmp > 1) { shift = shift + 1; tmp = tmp >> 1; }
                        ci = hi_emit(HI_ICONST, TY_INT, -1, -1, shift, NULL);
                        h_blk[ci] = h_blk[i];
                        h_kind[i] = HI_SLL;
                        h_src2[i] = ci;
                        changed = 1;
                    }
                } else if (s1c) {
                    a = h_val[h_src1[i]];
                    if (a > 0 && (a & (a - 1)) == 0) {
                        shift = 0; tmp = a;
                        while (tmp > 1) { shift = shift + 1; tmp = tmp >> 1; }
                        ci = hi_emit(HI_ICONST, TY_INT, -1, -1, shift, NULL);
                        h_blk[ci] = h_blk[i];
                        h_kind[i] = HI_SLL;
                        h_src1[i] = h_src2[i];
                        h_src2[i] = ci;
                        changed = 1;
                    }
                }
            }

            /* Strength reduction: unsigned DIV by power-of-2 -> SRL */
            if (h_kind[i] == HI_DIV && (h_ty[i] & TY_UNSIGNED) && s2c) {
                b = h_val[h_src2[i]];
                if (b > 0 && (b & (b - 1)) == 0) {
                    shift = 0; tmp = b;
                    while (tmp > 1) { shift = shift + 1; tmp = tmp >> 1; }
                    ci = hi_emit(HI_ICONST, TY_INT, -1, -1, shift, NULL);
                    h_blk[ci] = h_blk[i];
                    h_kind[i] = HI_SRL;
                    h_src2[i] = ci;
                    changed = 1;
                }
            }

            /* Strength reduction: unsigned REM by power-of-2 -> AND mask */
            if (h_kind[i] == HI_REM && (h_ty[i] & TY_UNSIGNED) && s2c) {
                b = h_val[h_src2[i]];
                if (b > 0 && (b & (b - 1)) == 0) {
                    ci = hi_emit(HI_ICONST, TY_INT, -1, -1, b - 1, NULL);
                    h_blk[ci] = h_blk[i];
                    h_kind[i] = HI_AND;
                    h_src2[i] = ci;
                    changed = 1;
                }
            }

            /* Same-operand simplifications (only if not already folded) */
            if (h_kind[i] == k && h_src1[i] >= 0 && h_src1[i] == h_src2[i]) {
                /* x - x -> 0, x ^ x -> 0, x % x -> 0 */
                if (k == HI_SUB || k == HI_XOR || k == HI_REM) {
                    h_kind[i] = HI_ICONST;
                    h_val[i] = 0;
                    h_src1[i] = -1;
                    h_src2[i] = -1;
                    changed = 1;
                }
                /* x / x -> 1 */
                else if (k == HI_DIV) {
                    h_kind[i] = HI_ICONST;
                    h_val[i] = 1;
                    h_src1[i] = -1;
                    h_src2[i] = -1;
                    changed = 1;
                }
                /* x == x -> 1, x <= x -> 1, x >= x -> 1 */
                else if (k == HI_SEQ || k == HI_SLE || k == HI_SGE ||
                         k == HI_SLEU || k == HI_SGEU) {
                    h_kind[i] = HI_ICONST;
                    h_val[i] = 1;
                    h_src1[i] = -1;
                    h_src2[i] = -1;
                    changed = 1;
                }
                /* x != x -> 0, x < x -> 0, x > x -> 0 */
                else if (k == HI_SNE || k == HI_SLT || k == HI_SGT ||
                         k == HI_SLTU || k == HI_SGTU) {
                    h_kind[i] = HI_ICONST;
                    h_val[i] = 0;
                    h_src1[i] = -1;
                    h_src2[i] = -1;
                    changed = 1;
                }
                /* x & x -> x, x | x -> x */
                else if (k == HI_AND || k == HI_OR) {
                    h_kind[i] = HI_COPY;
                    h_src2[i] = -1;
                    changed = 1;
                }
            }
        }

        /* === Unary ops with constant operand === */
        if (k == HI_NEG && h_src1[i] >= 0 &&
            h_kind[h_src1[i]] == HI_ICONST) {
            h_kind[i] = HI_ICONST;
            h_val[i] = 0 - h_val[h_src1[i]];
            h_src1[i] = -1;
            changed = 1;
        }
        if (k == HI_NOT && h_src1[i] >= 0 &&
            h_kind[h_src1[i]] == HI_ICONST) {
            h_kind[i] = HI_ICONST;
            if (h_val[h_src1[i]] == 0) h_val[i] = 1;
            else h_val[i] = 0;
            h_src1[i] = -1;
            changed = 1;
        }
        /* NOT(comparison) -> inverted comparison */
        if (k == HI_NOT && h_src1[i] >= 0) {
            int sk;
            int inv;
            sk = h_kind[h_src1[i]];
            inv = -1;
            if (sk == HI_SEQ)  inv = HI_SNE;
            else if (sk == HI_SNE)  inv = HI_SEQ;
            else if (sk == HI_SLT)  inv = HI_SGE;
            else if (sk == HI_SGE)  inv = HI_SLT;
            else if (sk == HI_SGT)  inv = HI_SLE;
            else if (sk == HI_SLE)  inv = HI_SGT;
            else if (sk == HI_SLTU) inv = HI_SGEU;
            else if (sk == HI_SGEU) inv = HI_SLTU;
            else if (sk == HI_SGTU) inv = HI_SLEU;
            else if (sk == HI_SLEU) inv = HI_SGTU;
            if (inv >= 0) {
                h_kind[i] = inv;
                h_src2[i] = h_src2[h_src1[i]];
                h_src1[i] = h_src1[h_src1[i]];
                changed = 1;
            }
        }
        /* NOT(NOT(x)) -> COPY(x) */
        if (k == HI_NOT && h_src1[i] >= 0 &&
            h_kind[h_src1[i]] == HI_NOT) {
            h_kind[i] = HI_COPY;
            h_src1[i] = h_src1[h_src1[i]];
            changed = 1;
        }
        if (k == HI_BNOT && h_src1[i] >= 0 &&
            h_kind[h_src1[i]] == HI_ICONST) {
            h_kind[i] = HI_ICONST;
            h_val[i] = (-1) ^ h_val[h_src1[i]];
            h_src1[i] = -1;
            changed = 1;
        }

        /* === ADDI peepholes === */
        if (k == HI_ADDI) {
            /* addi x, 0 -> x */
            if (h_val[i] == 0) {
                h_kind[i] = HI_COPY;
                changed = 1;
            }
            /* addi const, c -> const */
            else if (h_src1[i] >= 0 && h_kind[h_src1[i]] == HI_ICONST) {
                h_kind[i] = HI_ICONST;
                h_val[i] = h_val[h_src1[i]] + h_val[i];
                h_src1[i] = -1;
                changed = 1;
            }
        }

        /* === BRC with constant condition -> unconditional BR === */
        if (k == HI_BRC && h_src1[i] >= 0 &&
            h_kind[h_src1[i]] == HI_ICONST) {
            if (h_val[h_src1[i]] != 0) {
                /* Always true: branch to then-block (src2) */
                h_kind[i] = HI_BR;
                h_val[i] = h_src2[i];
            } else {
                /* Always false: branch to else-block (val unchanged) */
                h_kind[i] = HI_BR;
            }
            h_src1[i] = -1;
            h_src2[i] = -1;
            changed = 1;
        }

        i = i + 1;
    }
    return changed;
}

/* ----------------------------------------------------------------
 * Pass 3: Branch simplification
 * ---------------------------------------------------------------- */

static int ho_branch_simplify(void) {
    int changed;
    int i;

    changed = 0;
    i = 0;
    while (i < h_ninst) {
        if (h_kind[i] == HI_BRC) {
            /* If both BRC successors are identical, collapse to BR. */
            if (h_src2[i] == h_val[i]) {
                h_kind[i] = HI_BR;
                h_val[i] = h_src2[i];
                h_src1[i] = -1;
                h_src2[i] = -1;
                changed = 1;
            }
        }
        i = i + 1;
    }
    return changed;
}

/* ----------------------------------------------------------------
 * Pass 4: PHI simplification
 * If all non-self-referential PHI args are the same value,
 * replace the PHI with a COPY of that value.
 * ---------------------------------------------------------------- */

static int ho_phi_simplify(void) {
    int changed;
    int i;
    int j;
    int v;
    int unique;

    changed = 0;
    i = 0;
    while (i < h_ninst) {
        if (h_kind[i] != HI_PHI) { i = i + 1; continue; }
        if (h_pbase[i] < 0 || h_pcnt[i] == 0) { i = i + 1; continue; }

        /* Find unique non-self-referential arg */
        unique = -1;
        j = 0;
        while (j < h_pcnt[i]) {
            v = h_pval[h_pbase[i] + j];
            if (v != i) {
                if (unique == -1) {
                    unique = v;
                } else if (v != unique) {
                    unique = -2;  /* multiple distinct values */
                }
            }
            j = j + 1;
        }

        if (unique >= 0) {
            /* All non-self args are the same value -> COPY */
            h_kind[i] = HI_COPY;
            h_src1[i] = unique;
            h_pbase[i] = -1;
            h_pcnt[i] = 0;
            changed = 1;
        }

        i = i + 1;
    }
    return changed;
}

/* ----------------------------------------------------------------
 * Pass 5: Dead block elimination
 * DFS from block 0, NOP unreachable blocks, fix PHI args from
 * dead predecessors (make self-referential so phi_simplify ignores them).
 * Reuses ho_use[] as visited + DFS stack (non-overlapping regions).
 * ---------------------------------------------------------------- */

static int ho_dead_blocks(void) {
    int changed;
    int i;
    int j;
    int sp;
    int b;
    int t;
    int k;

    if (bb_nblk == 0) return 0;

    /* ho_use[0..bb_nblk-1] = visited, ho_use[bb_nblk..] = DFS stack */
    i = 0;
    while (i < bb_nblk) { ho_use[i] = 0; i = i + 1; }

    /* DFS from block 0 */
    sp = bb_nblk;
    ho_use[0] = 1;
    ho_use[sp] = 0;
    sp = sp + 1;

    while (sp > bb_nblk) {
        sp = sp - 1;
        b = ho_use[sp];

        /* Scan block for branch targets */
        if (bb_start[b] < 0) continue;
        i = bb_start[b];
        while (i < bb_end[b]) {
            k = h_kind[i];
            if (k == HI_BR) {
                t = h_val[i];
                if (t >= 0 && t < bb_nblk && !ho_use[t]) {
                    ho_use[t] = 1;
                    ho_use[sp] = t;
                    sp = sp + 1;
                }
            }
            if (k == HI_BRC) {
                t = h_src2[i];
                if (t >= 0 && t < bb_nblk && !ho_use[t]) {
                    ho_use[t] = 1;
                    ho_use[sp] = t;
                    sp = sp + 1;
                }
                t = h_val[i];
                if (t >= 0 && t < bb_nblk && !ho_use[t]) {
                    ho_use[t] = 1;
                    ho_use[sp] = t;
                    sp = sp + 1;
                }
            }
            if (k == HI_JMPTAB) {
                int jb; int js; int jj;
                t = h_val[i];   /* default block */
                if (t >= 0 && t < bb_nblk && !ho_use[t]) {
                    ho_use[t] = 1;
                    ho_use[sp] = t;
                    sp = sp + 1;
                }
                jb = hjt_base[i];
                js = hjt_span[i];
                jj = 0;
                while (jj < js) {
                    t = hjt_target[jb + jj];
                    if (t >= 0 && t < bb_nblk && !ho_use[t]) {
                        ho_use[t] = 1;
                        ho_use[sp] = t;
                        sp = sp + 1;
                    }
                    jj = jj + 1;
                }
            }
            i = i + 1;
        }
    }

    /* NOP dead blocks + fixup PHI args from dead predecessors */
    changed = 0;
    i = 0;
    while (i < h_ninst) {
        b = h_blk[i];
        if (b >= 0 && b < bb_nblk && !ho_use[b]) {
            /* Dead block: NOP this instruction */
            if (h_kind[i] != HI_NOP) {
                h_kind[i] = HI_NOP;
                h_src1[i] = -1;
                h_src2[i] = -1;
                changed = 1;
            }
        } else if (h_kind[i] == HI_PHI && h_pbase[i] >= 0) {
            /* Live block PHI: make args from dead predecessors self-ref */
            j = 0;
            while (j < h_pcnt[i]) {
                t = h_pblk[h_pbase[i] + j];
                if (t >= 0 && t < bb_nblk && !ho_use[t]) {
                    h_pval[h_pbase[i] + j] = i;
                    changed = 1;
                }
                j = j + 1;
            }
        }
        i = i + 1;
    }

    return changed;
}

/* ----------------------------------------------------------------
 * Pass 6: Dead code elimination
 * Count uses of each instruction, delete unused value-producers
 * (except calls which have side effects).
 * ---------------------------------------------------------------- */

static void ho_count_uses(void) {
    int i;
    int j;
    int k;
    int base;
    int cnt;
    int changed;

    i = 0;
    while (i < h_ninst) {
        ho_use[i] = 0;
        ho_phi_vouched[i] = 0;
        i = i + 1;
    }

    i = 0;
    while (i < h_ninst) {
        k = h_kind[i];
        if (k == HI_NOP) { i = i + 1; continue; }

        /* src1 is always an instruction ref when >= 0 */
        if (h_src1[i] >= 0)
            ho_use[h_src1[i]] = ho_use[h_src1[i]] + 1;

        /* src2 is an instruction ref only for binops and STORE */
        if (h_src2[i] >= 0 && ho_src2_is_ref(k))
            ho_use[h_src2[i]] = ho_use[h_src2[i]] + 1;

        /* Call arguments */
        if ((k == HI_CALL || k == HI_CALLP ||
             k == HI_A64_DBT_TRAMPOLINE || k == HI_X64_DBT_TRAMPOLINE) &&
            h_cbase[i] >= 0) {
            base = h_cbase[i];
            cnt = h_val[i];
            j = 0;
            while (j < cnt) {
                if (h_carg[base + j] >= 0)
                    ho_use[h_carg[base + j]] = ho_use[h_carg[base + j]] + 1;
                j = j + 1;
            }
        }

        /* PHI arguments are counted below, and only from live phis. */

        i = i + 1;
    }

    /* PHI arguments.  A use from a phi is real only if the phi itself
     * is live.  Counting every phi's arguments kept dead phis alive
     * through each other: a loop header's phi feeds the join after the
     * switch in its body, whose phi feeds the header, and neither has a
     * real reader.  The SSA is minimal, not pruned, so sqlite3VdbeExec
     * carried one such pair per case-local -- 384 phis at one join,
     * each copied on every one of ~190 edges: three quarters of the
     * function.  (A phi's reference to ITSELF, x = phi(pre, x), is
     * likewise not a use.)  So: seed with the uses from real
     * instructions, then let each live phi vouch for its arguments,
     * to a fixpoint. */
    changed = 1;
    while (changed) {
        changed = 0;
        i = 0;
        while (i < h_ninst) {
            if (h_kind[i] == HI_PHI && h_pbase[i] >= 0 && ho_use[i] > 0 &&
                !ho_phi_vouched[i]) {
                ho_phi_vouched[i] = 1;
                changed = 1;
                j = 0;
                while (j < h_pcnt[i]) {
                    if (h_pval[h_pbase[i] + j] >= 0 &&
                        h_pval[h_pbase[i] + j] != i)
                        ho_use[h_pval[h_pbase[i] + j]] =
                            ho_use[h_pval[h_pbase[i] + j]] + 1;
                    j = j + 1;
                }
            }
            i = i + 1;
        }
    }
}

static int ho_dce(void) {
    int changed;
    int i;
    int k;

    ho_count_uses();

    changed = 0;
    i = 0;
    while (i < h_ninst) {
        k = h_kind[i];
        if (k == HI_NOP) { i = i + 1; continue; }

        /* Delete if: produces value, no uses, no side effects */
        if (hi_has_value(k) && ho_use[i] == 0 &&
            k != HI_CALL && k != HI_CALLP) {
            h_kind[i] = HI_NOP;
            h_src1[i] = -1;
            h_src2[i] = -1;
            changed = 1;
        }

        i = i + 1;
    }
    return changed;
}

/* ----------------------------------------------------------------
 * CSE (Common Subexpression Elimination)
 * Hash table keyed on (kind, src1, src2, val).
 * Forward scan: if duplicate found in a dominating block, replace
 * with COPY. Uses ssa_idom[] for cross-block domination checks.
 * ---------------------------------------------------------------- */

/* Does block a dominate block b?  Walk idom chain from b toward root. */
static int ho_dominates(int a, int b) {
    int depth;
    depth = 0;
    while (b >= 0 && depth < 200) {
        if (b == a) return 1;
        if (b == ssa_idom[b]) return 0;
        b = ssa_idom[b];
        depth = depth + 1;
    }
    return 0;
}
#define HO_CSE_SLOTS  2048
#define HO_CSE_MASK   2047

static int ho_cse_head[HO_CSE_SLOTS];   /* slot -> first inst index, -1 if empty */
static hir_ix ho_cse_next[HIR_MAX_INST];    /* inst -> next in chain, -1 if end */
static int ho_stat_cse;

static int ho_cse_hash(int kind, int s1, int s2, int val) {
    int h;
    h = kind * 73 + (s1 + 1) * 131 + (s2 + 1) * 257 + val * 37;
    if (h < 0) h = 0 - h;
    return h & HO_CSE_MASK;
}

static int ho_cse_eligible(int k) {
    /* Binary arithmetic/logic/comparison (not div/rem) */
    if (hi_is_binop(k) && k != HI_DIV && k != HI_REM) return 1;
    /* Unary */
    if (k == HI_NEG || k == HI_NOT || k == HI_BNOT) return 1;
    /* ADDI */
    if (k == HI_ADDI) return 1;
    return 0;
}

static int ho_cse(void) {
    int i;
    int k;
    int s1;
    int s2;
    int v;
    int slot;
    int j;
    int found;
    int changed;

    /* Initialize hash table */
    i = 0;
    while (i < HO_CSE_SLOTS) { ho_cse_head[i] = -1; i = i + 1; }

    changed = 0;
    i = 0;
    while (i < h_ninst) {
        k = h_kind[i];
        if (k == HI_NOP || !ho_cse_eligible(k)) { i = i + 1; continue; }

        s1 = h_src1[i];
        s2 = h_src2[i];
        v = h_val[i];
        slot = ho_cse_hash(k, s1, s2, v);

        /* Search chain for match */
        found = -1;
        j = ho_cse_head[slot];
        while (j >= 0) {
            if (h_kind[j] == k && h_src1[j] == s1 && h_src2[j] == s2 &&
                h_val[j] == v && ho_dominates(h_blk[j], h_blk[i]) &&
                /* fort370: an address over a remat base (A(3)) is one LA
                 * wherever it is used; shared across blocks it would
                 * hold a register from the first use to the last */
                !(k == HI_ADDI && s1 >= 0 && hi_is_remat(h_kind[s1]) && h_blk[j] != h_blk[i])) {
                found = j;
                j = -1;  /* break */
            } else {
                j = ho_cse_next[j];
            }
        }

        if (found >= 0) {
            /* Replace with COPY of the earlier instruction */
            h_kind[i] = HI_COPY;
            h_src1[i] = found;
            h_src2[i] = -1;
            h_val[i] = 0;
            changed = 1;
            ho_stat_cse = ho_stat_cse + 1;
        } else {
            /* Insert into hash table */
            ho_cse_next[i] = ho_cse_head[slot];
            ho_cse_head[slot] = i;
        }

        i = i + 1;
    }
    return changed;
}

/* ----------------------------------------------------------------
 * Dead store elimination
 * If two STOREs in the same block write to the same address with
 * no intervening LOAD/CALL/CALLP, the first STORE is dead.
 * ---------------------------------------------------------------- */

static int ho_stat_dse;

static int ho_dse_pass(void) {
    int changed;
    int i;
    int j;
    int addr;
    int blk;
    int end;
    int alive;
    int jk;

    changed = 0;
    i = 0;
    while (i < h_ninst) {
        if (h_kind[i] != HI_STORE) { i = i + 1; continue; }
        addr = h_src1[i];  /* address operand of STORE */
        blk = h_blk[i];
        end = bb_end[blk];

        /* Scan forward in same block for another STORE to same address */
        alive = 1;
        j = i + 1;
        while (j < end && alive) {
            jk = h_kind[j];
            if (jk == HI_NOP) { j = j + 1; continue; }
            /* If any LOAD/CALL/CALLP, the stored value might be observed */
            if (jk == HI_LOAD || jk == HI_CALL || jk == HI_CALLP ||
                jk == HI_A64_DBT_TRAMPOLINE || hi_is_a64_cache_asm(jk) ||
                jk == HI_X64_DBT_TRAMPOLINE || jk == HI_X64_RDTSC) {
                alive = 0;
            }
            /* Found another STORE to same address — first store is dead */
            if (jk == HI_STORE && h_src1[j] == addr) {
                h_kind[i] = HI_NOP;
                h_src1[i] = -1;
                h_src2[i] = -1;
                changed = 1;
                ho_stat_dse = ho_stat_dse + 1;
                alive = 0;
            }
            j = j + 1;
        }
        i = i + 1;
    }
    return changed;
}

/* ----------------------------------------------------------------
 * Memory forwarding (store-load, load-load, load-store elimination)
 *
 * Within a basic block, track the "last known value" for each address:
 *   STORE addr val → remember val for addr
 *   LOAD addr      → if we know the value at addr, replace with COPY
 *                     Also remember the LOAD's result for addr
 *   STORE/CALL/CALLP → invalidate all known values
 * ---------------------------------------------------------------- */

static int ho_stat_slf;   /* store-load and load-load forwards */
static int ho_stat_lse;   /* load-store eliminations */

/* Small table for tracking known values per address.
 * Key: address (instruction index), Value: known value (instruction index). */
#define HO_MEM_SLOTS 64
static int ho_mem_addr[HO_MEM_SLOTS];  /* address, or -1 if empty */
static int ho_mem_val[HO_MEM_SLOTS];   /* known value at that address */
static int ho_mem_ty[HO_MEM_SLOTS];    /* type of the value */
static int ho_mem_cnt;

static void ho_mem_clear(void) { ho_mem_cnt = 0; }

static int ho_mem_find(int addr) {
    int k;
    k = 0;
    while (k < ho_mem_cnt) {
        if (ho_mem_addr[k] == addr) return k;
        k = k + 1;
    }
    return -1;
}

static void ho_mem_set(int addr, int val, int ty) {
    int k;
    k = ho_mem_find(addr);
    if (k >= 0) {
        ho_mem_val[k] = val;
        ho_mem_ty[k] = ty;
        return;
    }
    if (ho_mem_cnt < HO_MEM_SLOTS) {
        ho_mem_addr[ho_mem_cnt] = addr;
        ho_mem_val[ho_mem_cnt] = val;
        ho_mem_ty[ho_mem_cnt] = ty;
        ho_mem_cnt = ho_mem_cnt + 1;
    }
}

/* Resolve an address value to (base, byte offset).  Returns 1 for a
 * frame slot (base = the HI_ALLOCA), 2 for a global (base = the
 * HI_GADDR; compare by h_name, two GADDRs of one symbol are distinct
 * ids), 0 when the base is unknown (a pointer from anywhere). */
static int ho_addr_resolve(int id, int *base, int *off) {
    int depth;
    int k;
    *off = 0;
    depth = 0;
    while (id >= 0 && depth < 64) {
        k = h_kind[id];
        if (k == HI_ALLOCA) { *base = id; return 1; }
        if (k == HI_GADDR) { *base = id; return 2; }
        if (k == HI_ADDI) { *off = *off + h_val[id]; id = h_src1[id]; }
        else if (k == HI_COPY) { id = h_src1[id]; }
        else if (k == HI_ADD && h_src2[id] >= 0 && h_kind[h_src2[id]] == HI_ICONST) {
            *off = *off + h_val[h_src2[id]]; id = h_src1[id];
        } else if (k == HI_ADD && h_src1[id] >= 0 && h_kind[h_src1[id]] == HI_ICONST) {
            *off = *off + h_val[h_src1[id]]; id = h_src2[id];
        } else return 0;
        depth = depth + 1;
    }
    return 0;
}

static int ho_acc_size(int ty) {
    int sz;
    sz = ty_size(ty);
    if (sz <= 0) sz = 4;
    return sz;
}

/* May a `sza`-byte access at address value `a` touch the same bytes as
 * a `szb`-byte access at `b`?  Sound in the conservative direction: any
 * base we cannot resolve may alias anything. */
static int ho_may_alias(int a, int sza, int b, int szb) {
    int ba; int oa; int ka;
    int bb; int ob; int kb;
    if (a == b) return 1;
    ka = ho_addr_resolve(a, &ba, &oa);
    kb = ho_addr_resolve(b, &bb, &ob);
    if (ka == 0 || kb == 0) return 1;
    if (ka != kb) return 0;               /* a frame slot vs a global */
    if (ba != bb) {
        if (ka == 1) return 0;            /* two distinct frame slots */
        if (h_name[ba] == NULL || h_name[bb] == NULL) return 1;
        if (strcmp(h_name[ba], h_name[bb]) != 0) return 0;
    }
    /* same object: byte ranges */
    if (oa + sza <= ob) return 0;
    if (ob + szb <= oa) return 0;
    return 1;
}

/* A STORE to `addr` of `sz` bytes: forget every remembered value whose
 * bytes it may overwrite.  Entries keyed by a different address value
 * used to survive any store -- `*p = 10; *q = 20; return *p;` returned
 * 10 when p == q, a union's short store vanished under its word, and a
 * struct returned by value lost a member stored after its compound-
 * literal init (libutf's co_cs_bg). */
static void ho_mem_kill_aliases(int addr, int sz) {
    int k;
    k = 0;
    while (k < ho_mem_cnt) {
        if (ho_mem_addr[k] != addr &&
            ho_may_alias(addr, sz, ho_mem_addr[k], ho_acc_size(ho_mem_ty[k]))) {
            ho_mem_cnt = ho_mem_cnt - 1;
            ho_mem_addr[k] = ho_mem_addr[ho_mem_cnt];
            ho_mem_val[k] = ho_mem_val[ho_mem_cnt];
            ho_mem_ty[k] = ho_mem_ty[ho_mem_cnt];
        } else {
            k = k + 1;
        }
    }
}

static int ho_mem_fwd(void) {
    int changed;
    int i;
    int b;
    int start;
    int end;
    int k;
    int kk;
    int addr;
    int val;

    changed = 0;
    b = 0;
    while (b < bb_nblk) {
        start = bb_start[b];
        end = bb_end[b];
        if (start < 0 || end <= start) { b = b + 1; continue; }

        ho_mem_clear();
        i = start;
        while (i < end) {
            k = h_kind[i];
            if (k == HI_NOP) { i = i + 1; continue; }

            if (k == HI_STORE) {
                addr = h_src1[i];
                val = h_src2[i];
                /* Check if we're storing the same value we just loaded.
                 * LOAD addr → v; STORE addr, v  → eliminate the STORE */
                kk = ho_mem_find(addr);
                if (kk >= 0 && ho_mem_val[kk] == val && ho_mem_ty[kk] == h_ty[i]) {
                    h_kind[i] = HI_NOP;
                    h_src1[i] = -1;
                    h_src2[i] = -1;
                    changed = 1;
                    ho_stat_lse = ho_stat_lse + 1;
                } else {
                    /* Record: after this STORE, addr holds val -- and
                     * nothing it may overlap is known any more. */
                    ho_mem_kill_aliases(addr, ho_acc_size(h_ty[i]));
                    ho_mem_set(addr, val, h_ty[i]);
                }
            }
            else if (k == HI_LOAD) {
                addr = h_src1[i];
                kk = ho_mem_find(addr);
                if (kk >= 0 && ho_mem_ty[kk] == h_ty[i]) {
                    /* We know the value at this address — forward it */
                    h_kind[i] = HI_COPY;
                    h_src1[i] = ho_mem_val[kk];
                    h_src2[i] = -1;
                    changed = 1;
                    ho_stat_slf = ho_stat_slf + 1;
                } else {
                    /* Record: after this LOAD, addr holds result i */
                    ho_mem_set(addr, i, h_ty[i]);
                }
            }
            else if (k == HI_CALL || k == HI_CALLP ||
                     k == HI_A64_DBT_TRAMPOLINE || hi_is_a64_cache_asm(k) ||
                     k == HI_X64_DBT_TRAMPOLINE || k == HI_X64_RDTSC) {
                /* Calls may write to any memory — invalidate all */
                ho_mem_clear();
            }
            i = i + 1;
        }
        b = b + 1;
    }
    return changed;
}

/* ----------------------------------------------------------------
 * Single-store alloca promotion (mem2reg, trivial case)
 *
 * The lowering emits `STORE alloca, PARAM` at function entry for every
 * parameter (so `&param` would work) and replaces every read of `param`
 * with `LOAD alloca`.  Within a basic block, ho_mem_fwd forwards these
 * loads to the stored value; across blocks it cannot.  Branchy functions
 * (e.g. h_bne) end up with a real stack spill of `e` plus a reload in
 * each branch arm.
 *
 * This pass handles the trivial single-store case: if an HI_ALLOCA is
 * referenced only as the address operand of a single HI_STORE and a set
 * of HI_LOADs (no escapes via h_src2-as-ref / h_carg / h_pval / arithmetic),
 * and that one STORE dominates every LOAD, replace each LOAD with a
 * HI_COPY of the stored value and NOP the STORE/ALLOCA.  Subsequent
 * ho_copy_prop folds the COPYs.
 *
 * Multi-store allocas need phi insertion (full mem2reg); we punt those.
 * ---------------------------------------------------------------- */

/* Does block `a` dominate block `b`? Walks ssa_idom[] from b. */
static int ho_block_dominates(int a, int b) {
    int depth;
    depth = 0;
    while (b >= 0 && depth < HIR_MAX_BLOCK) {
        if (b == a) return 1;
        if (b == ssa_idom[b]) return 0;  /* root */
        b = ssa_idom[b];
        depth = depth + 1;
    }
    return 0;
}

static int ho_promote_single_store_alloca(void) {
    int changed;
    int i;
    int fn_has_call;

    /* Conservative gate (precomputed once per function): when a function
     * contains any HI_CALL/HI_CALLP/DBT trampoline, we skip promoting
     * allocas whose stored value is an HI_PARAM.  After promotion such
     * loads become direct PARAM uses, which extends the precolored
     * range across the call.  IRC coalescing on the extended PARAM live
     * range can drop ABI hints on sibling PARAMs (see PARAM-coalesce
     * hazard memory) and produces miscompiled code.  Non-PARAM stored
     * values and call-free functions are still promoted. */
    fn_has_call = 0;
    i = 0;
    while (i < h_ninst) {
        int k;
        k = h_kind[i];
        if (k == HI_CALL || k == HI_CALLP ||
            k == HI_A64_DBT_TRAMPOLINE || hi_is_a64_cache_asm(k) ||
            k == HI_X64_DBT_TRAMPOLINE || k == HI_X64_RDTSC) {
            fn_has_call = 1; break;
        }
        i = i + 1;
    }

    changed = 0;
    i = 0;
    while (i < h_ninst) {
        if (h_kind[i] == HI_ALLOCA) {
            int store_inst;
            int n_stores;
            int has_bad;
            int j;

            store_inst = -1;
            n_stores = 0;
            has_bad = 0;

            /* Scan all instructions, classify any reference to alloca i. */
            j = 0;
            while (j < h_ninst) {
                int k;
                int s1; int s2;

                k = h_kind[j];
                if (k == HI_NOP) { j = j + 1; continue; }

                s1 = h_src1[j];
                s2 = h_src2[j];

                if (k == HI_LOAD && s1 == i) {
                    /* Direct load via alloca: OK — but only when the
                     * load's type matches the alloca's.  A type-PUNNED
                     * load (`*(unsigned long long *)&d`) must read the
                     * slot's bytes; forwarding it to the stored value
                     * handed the raw double to an integer consumer
                     * (cc-a64: every local-double pun returned junk —
                     * d35_fp_loads' locmem shape). */
                    if (ty_is_fp(h_ty[j]) != ty_is_fp(h_ty[i]) ||
                        ty_size(h_ty[j]) != ty_size(h_ty[i]))
                        has_bad = 1;
                } else if (k == HI_STORE && s1 == i) {
                    /* Direct store *into* alloca.  But if the value being
                     * stored is also the alloca itself, the address
                     * escapes through itself — bail.  A type-punned
                     * store blocks promotion the same way a punned
                     * load does. */
                    if (s2 == i) { has_bad = 1; }
                    else if (ty_is_fp(h_ty[j]) != ty_is_fp(h_ty[i]) ||
                             ty_size(h_ty[j]) != ty_size(h_ty[i])) {
                        has_bad = 1;
                    } else {
                        n_stores = n_stores + 1;
                        store_inst = j;
                    }
                } else {
                    /* Any other reference means the alloca's address is
                     * being used in a way we can't safely model. */
                    if (s1 == i) has_bad = 1;
                    if (s2 == i && ho_src2_is_ref(k)) has_bad = 1;
                    if (k == HI_CALL || k == HI_CALLP
                            || k == HI_A64_DBT_TRAMPOLINE
                            || k == HI_X64_DBT_TRAMPOLINE
                            || hi_is_a64_cache_asm(k)) {
                        int base; int cnt; int kk;
                        base = h_cbase[j];
                        cnt = h_val[j];
                        kk = 0;
                        while (kk < cnt) {
                            if (h_carg[base + kk] == i) has_bad = 1;
                            kk = kk + 1;
                        }
                    }
                    if (k == HI_PHI) {
                        int base; int cnt; int kk;
                        base = h_pbase[j];
                        cnt = h_pcnt[j];
                        kk = 0;
                        while (kk < cnt) {
                            if (h_pval[base + kk] == i) has_bad = 1;
                            kk = kk + 1;
                        }
                    }
                }
                j = j + 1;
            }

            if (!has_bad && n_stores == 1) {
                int store_val;
                int store_blk;
                int can_promote;

                store_val = h_src2[store_inst];
                store_blk = h_blk[store_inst];
                can_promote = 1;

                /* Verify the STORE dominates every LOAD. */
                j = 0;
                while (j < h_ninst) {
                    if (h_kind[j] == HI_LOAD && h_src1[j] == i) {
                        int load_blk;
                        load_blk = h_blk[j];
                        if (store_blk == load_blk) {
                            /* Same block: STORE must come before LOAD. */
                            if (store_inst >= j) { can_promote = 0; break; }
                        } else if (!ho_block_dominates(store_blk, load_blk)) {
                            can_promote = 0;
                            break;
                        }
                    }
                    j = j + 1;
                }

                if (can_promote) {
                    /* See fn_has_call comment at top: punt PARAM-store
                     * allocas in functions that have any call. */
                    if (fn_has_call && h_kind[store_val] == HI_PARAM) {
                        i = i + 1; continue;
                    }
                    /* Rewrite each LOAD as COPY(store_val), NOP STORE/ALLOCA. */
                    j = 0;
                    while (j < h_ninst) {
                        if (h_kind[j] == HI_LOAD && h_src1[j] == i) {
                            h_kind[j] = HI_COPY;
                            h_src1[j] = store_val;
                            h_src2[j] = -1;
                        }
                        j = j + 1;
                    }
                    h_kind[store_inst] = HI_NOP;
                    h_src1[store_inst] = -1;
                    h_src2[store_inst] = -1;
                    h_kind[i] = HI_NOP;
                    h_src1[i] = -1;
                    h_src2[i] = -1;
                    changed = 1;
                }
            }
        }
        i = i + 1;
    }

    return changed;
}

/* ----------------------------------------------------------------
 * Main optimization driver: iterate until fixpoint
 * ---------------------------------------------------------------- */

/* Cumulative count of HIR instructions eliminated across all functions */
static int ho_stat_elim;

/* -fopt=MASK (s12cc.c): which passes run; a bisection aid.  Bits: 1 copy
 * propagation, 2 constant folding, 4 CSE, 8 branch simplification,
 * 16 dead blocks, 32 phi simplification, 64 DSE, 128 store-load forwarding,
 * 256 single-store alloca promotion, 512 DCE, 1024 LICM. */
static int ho_mask = -1;

static void hir_opt(void) {
    int changed;
    int iter;
    int before;
    int after;
    int i;

    /* Count live instructions before */
    before = 0;
    i = 0;
    while (i < h_ninst) {
        if (h_kind[i] != HI_NOP) before = before + 1;
        i = i + 1;
    }

    iter = 0;
    changed = 1;
    while (changed && iter < 10) {
        changed = 0;
        if (ho_mask & 1)   changed = changed | ho_copy_prop();
        if (ho_mask & 2)   changed = changed | ho_const_fold();
        if (ho_mask & 4)   changed = changed | ho_cse();
        if (ho_mask & 8)   changed = changed | ho_branch_simplify();
        if (ho_mask & 16)  changed = changed | ho_dead_blocks();
        if (ho_mask & 32)  changed = changed | ho_phi_simplify();
        if (ho_mask & 64)  changed = changed | ho_dse_pass();
        if (ho_mask & 128) changed = changed | ho_mem_fwd();
        if (ho_mask & 256) changed = changed | ho_promote_single_store_alloca();
        if (ho_mask & 512) changed = changed | ho_dce();
        iter = iter + 1;
    }

    /* Count live instructions after */
    after = 0;
    i = 0;
    while (i < h_ninst) {
        if (h_kind[i] != HI_NOP) after = after + 1;
        i = i + 1;
    }

    ho_stat_elim = ho_stat_elim + (before - after);
}
