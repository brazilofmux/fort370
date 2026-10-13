/* COPIED from slow32-public fortran/src/hir_licm.h at 2245be78 (2026-10-12).  See PROVENANCE.md. */
/* COPIED from selfhost/stage08/hir_licm.h at 30e16a57.  See note in hir.h. */
/* hir_licm.h -- Loop-Invariant Code Motion for s12cc
 *
 * Hoists pure computations out of loops.  Runs after hir_opt.h,
 * before hir_regalloc.h.  Requires dominator tree from hir_ssa.h.
 *
 * Design: Clone invariant instructions at h_ninst (appended), NOP
 * the originals in the loop body, rewrite all references globally.
 * Hoisted clones are linked into per-block lists (licm_head/licm_next)
 * and emitted by codegen/regalloc before the block's regular instructions.
 *
 * What gets hoisted: pure non-faulting arithmetic (ADD..SGEU excluding
 * DIV/REM), NEG, NOT, BNOT, ADDI, COPY.  An instruction is invariant
 * if all operands are defined outside the loop, rematerializable, or
 * themselves loop-invariant (iterative marking to fixpoint).
 *
 * Where: to ssa_idom[loop_header] (the preheader).  Safe for pure ops.
 */

/* --- Per-block hoisted instruction lists (append order: defs before uses) --- */
static int licm_head[HIR_MAX_BLOCK];  /* first hoisted inst, -1 = none */

/* Loop-optimisation gate.  licm_split parks values in split_head[]
 * TOP-of-block lists and licm_strred/licm_fp64_consts append clones
 * that only the SLOW-32 regalloc/codegen know how to walk; the x64
 * and a64 cross backends share this file but not that plumbing, so
 * the passes run only where the target's driver turns them on
 * (hir_codegen.h sets it before calling hir_licm). */
static int licm_loopopt;
static int licm_split_on = 1;        /* licm_split around each loop (a target may decline) */
/* fort370: on S/370 an array reference is base+index+displacement in
 * one instruction, so ADD(iv, base) must stay an ADD rather than
 * become a pointer induction variable; set by the S/370 emitter. */
static int licm_no_ptr_iv;
static int licm_tail[HIR_MAX_BLOCK];  /* last hoisted inst, for O(1) append */
static int licm_next[HIR_MAX_INST];   /* next hoisted inst, -1 = end */

/* --- Old-to-clone mapping --- */
static int licm_map[HIR_MAX_INST];    /* old index -> clone index, -1 = not hoisted */
static int licm_cpin[HIR_MAX_INST];   /* ICONST clone placed in a preheader by
                                       * licm_fp64_consts; codegen pins it
                                       * (h_no_remat) so it can keep a pair */

/* Blocks belonging to ANY natural loop in this function — persists
 * after hir_licm (ssa_vis is per-loop scratch).  Consumed by
 * hcg_mark_loop_consts. */
static int licm_in_any_loop[HIR_MAX_BLOCK];
/* DIVERGENCE (f77, port upstream): nesting depth per block -- each
 * natural-loop body found below increments its blocks, so an inner
 * loop's blocks count every enclosing loop.  Consumed by the spill
 * cost in hir_regalloc: a value used in an inner loop is far more
 * expensive to spill than its static use count says. */
static int licm_depth[HIR_MAX_BLOCK];

/* --- Stats --- */
static int licm_stat_hoisted;

/* --- Live-range splitting around loops (DIVERGENCE f77, port
 * upstream candidate) ---------------------------------------------
 *
 * A value LIVE THROUGH a loop but unused inside it still occupies a
 * register for the whole loop under linear-interval liveness -- and
 * under pressure it is exactly the register an inner-loop phi
 * needed.  Split it: store it to a fresh frame slot in the
 * preheader, end its register life there, and reload it at the top
 * of each post-loop block that uses it.  Cost: one store per loop
 * entry plus one load per use block; benefit: a callee-saved
 * register freed for the entire loop.
 *
 * split_head[b] is a TOP-of-block list (chained through licm_next,
 * memberships are disjoint from licm_head's): unlike LICM's hoists,
 * which run after a block's body, reloads must run before the uses
 * in their block.  Consumed by ra_order, hcg_block and the layout
 * size estimate; a block carrying reloads must never be forwarded.
 *
 * Safety: candidates are defined in a block dominating the header,
 * have NO use in the body, at least one use in a block dominated by
 * the preheader, and no use anywhere else (a use neither clearly
 * before nor clearly after the loop disqualifies).  CALL/CALLHI
 * values are excluded (their result-pair linkage is positional). */
static int split_head[HIR_MAX_BLOCK];
static int split_frame;
static int licm_stat_split;
static char sp_inbody[HIR_MAX_INST];
static char sp_post[HIR_MAX_INST];
static char sp_bad[HIR_MAX_INST];

/* --- Scratch for loop body --- */
#define LICM_MAX_BODY (8192 * F77_ROOM)    /* fort370: blocks of loop bodies, as one unit has them */
static int licm_body[LICM_MAX_BODY];

/* --- Helpers --- */

/* Does block a dominate block b?  Walk ssa_idom[] chain from b. */
static int licm_dominates(int a, int b) {
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

/* Is instruction defined inside the loop body? */
static int licm_in_loop(int inst) {
    if (inst < 0) return 0;
    if (h_blk[inst] < 0 || h_blk[inst] >= bb_nblk) return 0;
    return ssa_vis[h_blk[inst]];
}

/* Is an operand "loop-invariant"?  True if:
 * - negative (no operand)
 * - defined outside the loop
 * - rematerializable (ICONST, ALLOCA, etc.)
 * - already marked as invariant (ho_use[inst] == 1) */
static int licm_cur_header = -1;
static int licm_cur_latch = -1;      /* back-edge source of the loop being hoisted */
static int licm_ucnt[HIR_MAX_INST];  /* marked in-loop users, for the cheap-leaf rule */

static int licm_operand_ok(int inst) {
    if (inst < 0) return 1;
    if (hi_is_remat(h_kind[inst])) return 1;
    if (!licm_in_loop(inst)) {
        /* Outside the body is NOT enough: original SSA guarantees an
         * outside def dominates the header, but licm_split's reloads
         * are multiple non-SSA defs of one value scattered in
         * post-inner-loop blocks.  Hoisting a user of one of those to
         * this loop's preheader read the slot before any reload ran
         * (s12cc's own ra_mark_call_crossing lost its loop counter to
         * exactly that -- gen2 span forever).  Demand dominance. */
        if (licm_cur_header >= 0 &&
            h_blk[inst] >= 0 && h_blk[inst] < bb_nblk &&
            !licm_dominates(h_blk[inst], licm_cur_header)) return 0;
        return 1;
    }
    if (ho_use[inst]) return 1;
    return 0;
}

/* ----------------------------------------------------------------
 * Find natural loops and hoist invariants
 * ---------------------------------------------------------------- */

/* Compute loop body via backward BFS from latch to header.
 * Returns body count in licm_body[]. Sets ssa_vis[] for body blocks. */
static int licm_find_body(int header, int latch) {
    int n;
    int wh;
    int wt;
    int b;
    int j;
    int p;

    /* Clear vis */
    b = 0;
    while (b < bb_nblk) {
        ssa_vis[b] = 0;
        b = b + 1;
    }

    /* Header is always in the loop */
    ssa_vis[header] = 1;
    licm_body[0] = header;
    n = 1;

    /* If latch != header, seed BFS with latch */
    if (latch != header) {
        ssa_vis[latch] = 1;
        if (n < LICM_MAX_BODY) {
            licm_body[n] = latch;
            n = n + 1;
        }
    }

    /* BFS backwards from latch through predecessors.
     * Start from latch (index 1), not header (index 0) — going backwards
     * from header would escape the loop.
     * For single-block loops (latch == header), body = {header}, no BFS. */
    if (latch == header) return n;
    wh = 1;
    wt = n;

    while (wh < wt) {
        b = licm_body[wh];
        wh = wh + 1;

        j = 0;
        while (j < ssa_npred[b]) {
            p = ssa_pred[ssa_pbase[b] + j];
            if (p >= 0 && p < bb_nblk && !ssa_vis[p]) {
                ssa_vis[p] = 1;
                if (wt < LICM_MAX_BODY) {
                    licm_body[wt] = p;
                    wt = wt + 1;
                }
            }
            j = j + 1;
        }
    }

    return wt;
}

/* Mark loop-invariant instructions.  Iterates to fixpoint.
 * Uses ho_use[] as the invariant flag (0=not invariant, 1=invariant).
 * ssa_vis[] must be set for loop body blocks. */
/* --- Hoist policy (GitHub issue 73/77 follow-up) ---
 * Marking alone hoisted 18k instructions out of sqlite's loops and cost
 * 7% of the program: sqlite3VdbeExec's opcode loop is a 200-case switch,
 * so a value hoisted for one case is live across every iteration and
 * spills, and chacha_block's 16 `&x[k]` addresses (ALLOCA+const, one
 * instruction each) took 16 registers.  Two rules, on by default
 * (S12CC_LICM_GREEDY=1 restores the old marking for A/B, S12CC_LICM_NODOM
 * / S12CC_LICM_NOCHEAP disable one rule, S12CC_NO_LICM=1 skips hoisting):
 *   DOM:   only hoist from blocks that dominate the latch -- code that
 *          runs on every iteration.  A conditional path's invariants
 *          stay put; hoisting them is speculation that only pays if
 *          that path is hot, and costs a register always.
 *   CHEAP: a marked instruction whose operands are all one-instruction
 *          leaves (a frame address, or a constant that fits an
 *          immediate) and that feeds no other hoisted instruction is one
 *          instruction to recompute -- the same as a reload -- so it
 *          stays in the loop.  Global addresses and wide constants are
 *          lui+addi and do not count (LINPACK-as-Fortran lost 7% when
 *          they did).
 * Measured (same compiler, sqlite 3.51.0 at S12CC_INLINE=20; LINPACK
 * and mandel kernels from fortran/bench compiled as C):
 *                      sqlite static  sqlite dyn   LINPACK dyn
 *   greedy (before)        245,840      1.227M       990.6M
 *   DOM only               229,597      1.130M       961.0M
 *   CHEAP only             237,107      1.176M       961.1M
 *   DOM + CHEAP (now)      228,595      1.131M       961.0M
 *   no LICM at all         227,809      1.131M       990.6M
 * Greedy hoisting was worth nothing on LINPACK and cost 7% on sqlite;
 * pruned, it is 3% on LINPACK and neutral on mandel.
 * Unmarking must keep the closure valid: a marked instruction whose
 * in-loop operand is no longer marked is unmarked too (it would read a
 * loop value from the preheader), iterated to a fixpoint. */
/* One-instruction operands: a frame address (sp+off) or a constant that
 * fits an immediate.  A global address or a wide constant is lui+addi,
 * so a leaf built on one is NOT cheap -- LINPACK's COMMON-array bases
 * hoisted that way are worth their register (pruning them cost 7%). */
static int (*licm_cheap_fn)(int inst);   /* a target's own notion of a cheap operand (fort370: S/370) */
static int licm_operand_cheap(int inst) {
    if (inst < 0) return 1;
    if (licm_cheap_fn) return licm_cheap_fn(inst);
    if (h_kind[inst] == HI_ALLOCA) return 1;
    if (h_kind[inst] == HI_ICONST && h_val[inst] >= -2048 && h_val[inst] <= 2047) return 1;
    return 0;
}

static int licm_operand_hoistable(int inst) {
    /* An in-loop operand must itself be hoisted for the user to be. */
    if (inst < 0) return 1;
    if (!licm_in_loop(inst)) return 1;
    if (hi_is_remat(h_kind[inst])) return 1;
    return ho_use[inst];
}

static void licm_prune(int body_count) {
    int dom;
    int cheap;
    int cheap_min;
    int nmarked;
    int changed;
    int bi;
    int b;
    int i;
    int k;
    if (getenv("S12CC_LICM_GREEDY")) return;
    dom = getenv("S12CC_LICM_NODOM") == NULL;      /* A/B: disable one rule */
    cheap = getenv("S12CC_LICM_NOCHEAP") == NULL;
    cheap_min = 8;
    if (getenv("S12CC_LICM_CHEAP_MIN")) cheap_min = atoi(getenv("S12CC_LICM_CHEAP_MIN"));
    if (dom && licm_cur_latch >= 0) {
        bi = 0;
        while (bi < body_count) {
            b = licm_body[bi];
            if (!licm_dominates(b, licm_cur_latch)) {
                i = bb_start[b];
                while (i < bb_end[b]) { ho_use[i] = 0; i = i + 1; }
            }
            bi = bi + 1;
        }
    }
    /* CHEAP trades a register for one recompute per iteration.  That
     * wins only when the loop would have spilled anyway; in a small
     * loop with registers to spare it is a pure loss (LINPACK-as-
     * Fortran: +7% dynamic).  Apply it only when this loop hoists
     * more than cheap_min values. */
    if (cheap) {
        nmarked = 0;
        bi = 0;
        while (bi < body_count) {
            b = licm_body[bi];
            i = bb_start[b];
            while (i < bb_end[b]) { if (ho_use[i]) nmarked = nmarked + 1; i = i + 1; }
            bi = bi + 1;
        }
        if (nmarked <= cheap_min) cheap = 0;
    }
    changed = 1;
    while (changed) {
        changed = 0;
        /* Marked in-loop users of each instruction. */
        bi = 0;
        while (bi < body_count) {
            b = licm_body[bi];
            i = bb_start[b];
            while (i < bb_end[b]) { licm_ucnt[i] = 0; i = i + 1; }
            bi = bi + 1;
        }
        bi = 0;
        while (bi < body_count) {
            b = licm_body[bi];
            i = bb_start[b];
            while (i < bb_end[b]) {
                if (ho_use[i]) {
                    k = h_kind[i];
                    if (h_src1[i] >= 0 && licm_in_loop(h_src1[i]))
                        licm_ucnt[h_src1[i]] = licm_ucnt[h_src1[i]] + 1;
                    if (ho_src2_is_ref(k) && h_src2[i] >= 0 && licm_in_loop(h_src2[i]))
                        licm_ucnt[h_src2[i]] = licm_ucnt[h_src2[i]] + 1;
                }
                i = i + 1;
            }
            bi = bi + 1;
        }
        bi = 0;
        while (bi < body_count) {
            b = licm_body[bi];
            i = bb_start[b];
            while (i < bb_end[b]) {
                if (ho_use[i]) {
                    k = h_kind[i];
                    if (cheap && licm_ucnt[i] == 0 &&
                        licm_operand_cheap(h_src1[i]) &&
                        (ho_src2_is_ref(k) ? licm_operand_cheap(h_src2[i]) : 1)) {
                        ho_use[i] = 0;
                        changed = 1;
                    } else if (!licm_operand_hoistable(h_src1[i]) ||
                               (ho_src2_is_ref(k) && !licm_operand_hoistable(h_src2[i]))) {
                        ho_use[i] = 0;
                        changed = 1;
                    }
                }
                i = i + 1;
            }
            bi = bi + 1;
        }
    }
}

static void licm_mark(int body_count) {
    int changed;
    int bi;
    int b;
    int i;
    int k;

    /* Clear marking for all instructions in loop body */
    bi = 0;
    while (bi < body_count) {
        b = licm_body[bi];
        i = bb_start[b];
        while (i < bb_end[b]) {
            ho_use[i] = 0;
            i = i + 1;
        }
        bi = bi + 1;
    }

    /* Iterate to fixpoint */
    changed = 1;
    while (changed) {
        changed = 0;

        bi = 0;
        while (bi < body_count) {
            b = licm_body[bi];
            i = bb_start[b];
            while (i < bb_end[b]) {
                k = h_kind[i];
                /* DIVERGENCE (f77): a LOAD carrying the frontend's
                 * read-only assertion (h_ld_ro) hoists like a pure
                 * instruction once its address is invariant.  The
                 * speculation is safe: the address is a dummy
                 * argument the caller already dereferenced. */
                if (!ho_use[i] &&
                    (hi_is_pure(k) || (k == HI_LOAD && h_ld_ro[i]))) {
                    /* Check all operands */
                    if (licm_operand_ok(h_src1[i]) &&
                        (ho_src2_is_ref(k) ? licm_operand_ok(h_src2[i]) : 1)) {
                        ho_use[i] = 1;
                        changed = 1;
                    }
                }
                i = i + 1;
            }
            bi = bi + 1;
        }
    }
    licm_prune(body_count);
}

/* Clone an instruction at h_ninst.  Returns clone index. */
static int licm_clone(int orig) {
    int cl;
    int s1;
    int s2;

    cl = h_ninst;
    if (cl >= HIR_MAX_INST) return -1;

    h_kind[cl] = h_kind[orig];
    h_ty[cl] = h_ty[orig];

    /* Remap operands through licm_map (already-hoisted deps) */
    s1 = h_src1[orig];
    if (s1 >= 0 && licm_map[s1] >= 0) s1 = licm_map[s1];
    h_src1[cl] = s1;

    s2 = h_src2[orig];
    if (s2 >= 0 && ho_src2_is_ref(h_kind[orig]) && licm_map[s2] >= 0) {
        s2 = licm_map[s2];
    }
    h_src2[cl] = s2;

    h_val[cl] = h_val[orig];
    h_name[cl] = h_name[orig];
    h_ld_ro[cl] = h_ld_ro[orig];   /* direct writes bypass hi_emit's clear */
    h_cbase[cl] = -1;
    h_pbase[cl] = -1;
    h_pcnt[cl] = 0;

    /* Clones are never themselves hoisted; mark so rewrite skips them */
    licm_map[cl] = -1;
    licm_cpin[cl] = 0;   /* the index may be reused across functions */
    ho_use[cl] = 0;      /* same stale-flag hazard as sp_new_inst */

    h_ninst = h_ninst + 1;

    return cl;
}

/* Hoist invariants for one loop.  Body is in licm_body[], count is body_count.
 * ssa_vis[] set for body blocks.  ho_use[] marks invariants. */
static void licm_hoist(int header, int body_count) {
    int target;
    int ri;
    int b;
    int i;
    int cl;

    target = ssa_idom[header];
    if (target < 0 || target >= bb_nblk) return;

    /* Process body blocks in RPO order (defs before uses) */
    ri = 0;
    while (ri < ssa_rpo_cnt) {
        b = ssa_rpo_ord[ri];
        if (b >= 0 && b < bb_nblk && ssa_vis[b]) {
            i = bb_start[b];
            while (i < bb_end[b]) {
                if (ho_use[i]) {
                    cl = licm_clone(i);
                    if (cl < 0) {
                        ri = ssa_rpo_cnt;  /* abort */
                        break;
                    }
                    /* Set block of clone to target (preheader) */
                    h_blk[cl] = target;

                    /* Append to target's hoisted list (defs before uses) */
                    licm_next[cl] = -1;
                    if (licm_tail[target] >= 0) {
                        licm_next[licm_tail[target]] = cl;
                    } else {
                        licm_head[target] = cl;
                    }
                    licm_tail[target] = cl;

                    /* NOP the original */
                    h_kind[i] = HI_NOP;

                    /* Record mapping */
                    licm_map[i] = cl;
                    licm_stat_hoisted = licm_stat_hoisted + 1;
                }
                i = i + 1;
            }
        }
        ri = ri + 1;
    }
}

/* Global rewrite: replace all references to hoisted originals with clones. */
static void licm_rewrite(void) {
    int i;
    int k;
    int j;
    int a;

    i = 0;
    while (i < h_ninst) {
        k = h_kind[i];
        if (k == HI_NOP) { i = i + 1; continue; }

        /* src1 */
        if (h_src1[i] >= 0 && licm_map[h_src1[i]] >= 0) {
            h_src1[i] = licm_map[h_src1[i]];
        }

        /* src2 (instruction ref) */
        if (h_src2[i] >= 0 && ho_src2_is_ref(k) && licm_map[h_src2[i]] >= 0) {
            h_src2[i] = licm_map[h_src2[i]];
        }

        /* Call arguments */
        if ((k == HI_CALL || k == HI_CALLP ||
             k == HI_A64_DBT_TRAMPOLINE || k == HI_X64_DBT_TRAMPOLINE) &&
            h_cbase[i] >= 0) {
            j = 0;
            while (j < h_val[i]) {
                a = h_carg[h_cbase[i] + j];
                if (a >= 0 && licm_map[a] >= 0) {
                    h_carg[h_cbase[i] + j] = licm_map[a];
                }
                j = j + 1;
            }
        }

        /* PHI arguments */
        if (k == HI_PHI && h_pbase[i] >= 0) {
            j = 0;
            while (j < h_pcnt[i]) {
                a = h_pval[h_pbase[i] + j];
                if (a >= 0 && licm_map[a] >= 0) {
                    h_pval[h_pbase[i] + j] = licm_map[a];
                }
                j = j + 1;
            }
        }

        i = i + 1;
    }
}

/* ----------------------------------------------------------------
 * Main entry point
 * ---------------------------------------------------------------- */

/* Classify one use of value v occurring in block ub, for licm_split. */
static void sp_use(int v, int ub, int pre, int header) {
    if (v < 0) return;
    if (ub < 0 || ub >= bb_nblk) { sp_bad[v] = 1; return; }
    if (ssa_vis[ub]) { sp_inbody[v] = 1; return; }
    if (ub == pre || licm_dominates(ub, header)) return;   /* pre-loop */
    if (licm_dominates(pre, ub)) { sp_post[v] = 1; return; }
    sp_bad[v] = 1;
}

static int sp_new_inst(int kind, int ty, int s1, int s2, int val, int blk) {
    int cl;
    cl = h_ninst;
    if (cl >= HIR_MAX_INST) return -1;
    h_kind[cl] = kind;
    h_ty[cl] = ty;
    h_src1[cl] = s1;
    h_src2[cl] = s2;
    h_val[cl] = val;
    h_name[cl] = 0;
    h_blk[cl] = blk;
    h_cbase[cl] = -1;
    h_pbase[cl] = -1;
    h_pcnt[cl] = 0;
    h_ld_ro[cl] = 0;
    h_no_remat[cl] = 0;
    licm_map[cl] = -1;
    licm_next[cl] = -1;
    licm_cpin[cl] = 0;
    /* Appended instructions are OUTSIDE every bb_start..bb_end range,
     * so licm_mark's per-body clear never reaches them -- a stale
     * ho_use count left by the PREVIOUS function's hir_opt at this
     * index reads as "marked invariant" and lets a later loop hoist a
     * user of this instruction illegally (s12cc's ra_mark_call_crossing
     * lost its loop counter to a hoisted increment that read a split
     * reload; gen2 span forever).  Clear it at birth. */
    ho_use[cl] = 0;
    h_ninst = h_ninst + 1;
    return cl;
}

static void licm_split(int header) {
    int pre;
    int i;
    int j;
    int k;
    int v;
    int lim;
    int nsplit;
    int a_inst;
    int s_inst;
    int lb[8];
    int li[8];
    int nlb;

    pre = ssa_idom[header];
    if (pre < 0 || pre >= bb_nblk || ssa_vis[pre]) return;

    lim = h_ninst;
    i = 0;
    while (i < lim) {
        sp_inbody[i] = 0;
        sp_post[i] = 0;
        sp_bad[i] = 0;
        i = i + 1;
    }

    /* Classify every use */
    i = 0;
    while (i < lim) {
        k = h_kind[i];
        if (k == HI_NOP) { i = i + 1; continue; }
        if (k == HI_PHI && h_pbase[i] >= 0) {
            j = 0;
            while (j < h_pcnt[i]) {
                sp_use(h_pval[h_pbase[i] + j], h_pblk[h_pbase[i] + j],
                       pre, header);
                j = j + 1;
            }
        } else {
            if (h_src1[i] >= 0) sp_use(h_src1[i], h_blk[i], pre, header);
            if (h_src2[i] >= 0 && ho_src2_is_ref(k))
                sp_use(h_src2[i], h_blk[i], pre, header);
            if ((k == HI_CALL || k == HI_CALLP) && h_cbase[i] >= 0) {
                j = 0;
                while (j < h_val[i]) {
                    sp_use(h_carg[h_cbase[i] + j], h_blk[i], pre, header);
                    j = j + 1;
                }
            }
        }
        i = i + 1;
    }

    nsplit = 0;
    v = 0;
    while (v < lim && nsplit < 8) {
        k = h_kind[v];
        if (k == HI_NOP || !hi_has_value(k) || hi_inst_remat(v) ||
            k == HI_CALL || k == HI_CALLHI ||
            sp_inbody[v] || sp_bad[v] || !sp_post[v] ||
            h_blk[v] < 0 || h_blk[v] >= bb_nblk || ssa_vis[h_blk[v]] ||
            !licm_dominates(h_blk[v], header)) { v = v + 1; continue; }

        if (h_ninst + 2 >= HIR_MAX_INST) return;

        split_frame = split_frame + 4;
        a_inst = sp_new_inst(HI_ALLOCA, TY_INT, -1, -1, 0 - split_frame, pre);
        s_inst = sp_new_inst(HI_STORE, TY_INT, a_inst, v, 0, pre);
        if (a_inst < 0 || s_inst < 0) return;

        /* The store runs in the preheader, after any hoisted clones
         * (which may themselves read v). */
        if (licm_tail[pre] >= 0) licm_next[licm_tail[pre]] = s_inst;
        else licm_head[pre] = s_inst;
        licm_tail[pre] = s_inst;

        /* Rewrite each post-loop use through a per-block reload. */
        nlb = 0;
        i = 0;
        while (i < lim) {
            k = h_kind[i];
            if (k == HI_NOP) { i = i + 1; continue; }
            if (k == HI_PHI && h_pbase[i] >= 0) {
                j = 0;
                while (j < h_pcnt[i]) {
                    if (h_pval[h_pbase[i] + j] == v) {
                        int ub;
                        ub = h_pblk[h_pbase[i] + j];
                        if (ub >= 0 && ub < bb_nblk && !ssa_vis[ub] &&
                            ub != pre && !licm_dominates(ub, header) &&
                            licm_dominates(pre, ub)) {
                            int ld;
                            int x;
                            ld = -1;
                            x = 0;
                            while (x < nlb) { if (lb[x] == ub) { ld = li[x]; break; } x = x + 1; }
                            if (ld < 0 && nlb < 8) {
                                ld = sp_new_inst(HI_LOAD, TY_INT, a_inst, -1, 0, ub);
                                if (ld < 0) return;
                                licm_next[ld] = split_head[ub];
                                split_head[ub] = ld;
                                lb[nlb] = ub; li[nlb] = ld; nlb = nlb + 1;
                            }
                            if (ld >= 0) h_pval[h_pbase[i] + j] = ld;
                        }
                    }
                    j = j + 1;
                }
                i = i + 1;
                continue;
            }
            {
                int ub;
                int ld;
                int x;
                int refs;
                ub = h_blk[i];
                refs = 0;
                if (h_src1[i] == v) refs = 1;
                if (h_src2[i] == v && ho_src2_is_ref(k)) refs = 1;
                if ((k == HI_CALL || k == HI_CALLP) && h_cbase[i] >= 0) {
                    j = 0;
                    while (j < h_val[i]) {
                        if (h_carg[h_cbase[i] + j] == v) refs = 1;
                        j = j + 1;
                    }
                }
                if (!refs || ub < 0 || ub >= bb_nblk || ssa_vis[ub] ||
                    ub == pre || licm_dominates(ub, header) ||
                    !licm_dominates(pre, ub)) {
                    i = i + 1;
                    continue;
                }
                ld = -1;
                x = 0;
                while (x < nlb) { if (lb[x] == ub) { ld = li[x]; break; } x = x + 1; }
                if (ld < 0 && nlb < 8) {
                    ld = sp_new_inst(HI_LOAD, TY_INT, a_inst, -1, 0, ub);
                    if (ld < 0) return;
                    licm_next[ld] = split_head[ub];
                    split_head[ub] = ld;
                    lb[nlb] = ub; li[nlb] = ld; nlb = nlb + 1;
                }
                if (ld >= 0) {
                    if (h_src1[i] == v) h_src1[i] = ld;
                    if (h_src2[i] == v && ho_src2_is_ref(k)) h_src2[i] = ld;
                    if ((k == HI_CALL || k == HI_CALLP) && h_cbase[i] >= 0) {
                        j = 0;
                        while (j < h_val[i]) {
                            if (h_carg[h_cbase[i] + j] == v)
                                h_carg[h_cbase[i] + j] = ld;
                            j = j + 1;
                        }
                    }
                }
            }
            i = i + 1;
        }
        licm_stat_split = licm_stat_split + 1;
        nsplit = nsplit + 1;
        v = v + 1;
    }
}

/* --- Derived induction variables (DIVERGENCE f77, port upstream) ---
 *
 * Strength reduction.  For a loop phi iv with a single back edge and
 * an invariant step, an in-body SLL(iv, k) / MUL(iv, m) / ADD(iv, m)
 * with invariant k/m is itself an induction variable: give it its
 * own phi (init computed once in the preheader, its own increment in
 * the latch) and rewrite the uses.  Run twice, so ADD(base, p) over
 * a first-round derived p becomes a POINTER induction variable --
 * the clang shape: no shift, no add, just a bumped address.  ADDI
 * candidates are deliberately excluded: trailing displacement ADDIs
 * fold into load/store offsets, and deriving them would unfold that.
 * Original IVs whose only remaining use is their own increment are
 * swept afterwards. */
#define SR_MAX_IV 16
static int sr_phi[SR_MAX_IV];
static int sr_init[SR_MAX_IV];
static int sr_step[SR_MAX_IV];      /* step VALUE (inst id) */
static int sr_inc[SR_MAX_IV];
static int sr_niv;
/* fort370: derived IVs made so far in this loop, keyed on the base
 * IV's phi, the operation and the other operand, so the same
 * expression in another block of the body (SLL(K,3) under both arms of
 * an IF) shares one phi instead of costing a second register. */
static int sr_dk_phi[SR_MAX_IV];
static int sr_dk_knd[SR_MAX_IV];
static int sr_dk_other[SR_MAX_IV];
static int sr_dk_oval[SR_MAX_IV];   /* the other operand's value when it is a constant, else a marker */
static int sr_dk_new[SR_MAX_IV];
static int sr_ndk;

static int sr_arg_of(int phi, int blk) {
    int j;
    j = 0;
    while (j < h_pcnt[phi]) {
        if (h_pblk[h_pbase[phi] + j] == blk) return h_pval[h_pbase[phi] + j];
        j = j + 1;
    }
    return -1;
}

static int sr_invariant(int v) {
    if (v < 0) return 0;
    if (hi_is_remat(h_kind[v])) return 1;
    if (h_blk[v] < 0 || h_blk[v] >= bb_nblk) return 0;
    return !ssa_vis[h_blk[v]];
}

/* Is value x one of the recorded IVs?  Returns record index or -1. */
static int sr_find(int x) {
    int i;
    i = 0;
    while (i < sr_niv) {
        if (sr_phi[i] == x) return i;
        i = i + 1;
    }
    return -1;
}

/* Resolve a reference one hop through licm_map: LICM NOPs hoisted
 * originals immediately but defers the global reference rewrite to
 * the end of hir_licm, so at strength-reduction time users of a
 * hoisted computation still name the ORIGINAL.  (This cost a day-one
 * bug: deriving from a clone rewrote zero references, and the
 * deferred rewrite then pointed users at the clone we had NOPped.) */
static int sr_res(int x) {
    if (x >= 0 && licm_map[x] >= 0) return licm_map[x];
    return x;
}

/* All uses of j inside the loop body (and none in phi pools outside)? */
static int sr_uses_local(int j) {
    int i;
    int k;
    int x;
    i = 0;
    while (i < h_ninst) {
        k = h_kind[i];
        if (k == HI_NOP || i == j) { i = i + 1; continue; }
        x = 0;
        if (sr_res(h_src1[i]) == j) x = 1;
        if (sr_res(h_src2[i]) == j && ho_src2_is_ref(k)) x = 1;
        if ((k == HI_CALL || k == HI_CALLP) && h_cbase[i] >= 0) {
            int q;
            q = 0;
            while (q < h_val[i]) {
                if (sr_res(h_carg[h_cbase[i] + q]) == j) x = 1;
                q = q + 1;
            }
        }
        if (k == HI_PHI && h_pbase[i] >= 0) {
            int q;
            q = 0;
            while (q < h_pcnt[i]) {
                if (sr_res(h_pval[h_pbase[i] + q]) == j) return 0;
                q = q + 1;
            }
        }
        if (x) {
            if (h_blk[i] < 0 || h_blk[i] >= bb_nblk || !ssa_vis[h_blk[i]])
                return 0;
        }
        i = i + 1;
    }
    return 1;
}

/* Count references to `old` that sr_rewrite would see (operands,
 * call args, phi pool), resolving one licm_map hop like the rewrite
 * does.  A candidate with zero VISIBLE references must not be
 * derived: either it is dead (nothing to gain) or it has a user
 * behind an aliasing form this pass does not know, and retiring it
 * would hand that user a NOP. */
static int sr_count_refs(int old) {
    int i;
    int k;
    int q;
    int n;
    n = 0;
    i = 0;
    while (i < h_ninst) {
        k = h_kind[i];
        if (k == HI_NOP) { i = i + 1; continue; }
        if (sr_res(h_src1[i]) == old) n = n + 1;
        if (sr_res(h_src2[i]) == old && ho_src2_is_ref(k)) n = n + 1;
        if ((k == HI_CALL || k == HI_CALLP) && h_cbase[i] >= 0) {
            q = 0;
            while (q < h_val[i]) {
                if (sr_res(h_carg[h_cbase[i] + q]) == old) n = n + 1;
                q = q + 1;
            }
        }
        if (k == HI_PHI && h_pbase[i] >= 0) {
            q = 0;
            while (q < h_pcnt[i]) {
                if (sr_res(h_pval[h_pbase[i] + q]) == old) n = n + 1;
                q = q + 1;
            }
        }
        i = i + 1;
    }
    return n;
}

/* Rewrite every reference to old with nw. */
static int sr_rewrite_n;
static void sr_rewrite(int old, int nw) {
    int i;
    int k;
    int q;
    sr_rewrite_n = 0;
    i = 0;
    while (i < h_ninst) {
        k = h_kind[i];
        if (k == HI_NOP || i == nw) { i = i + 1; continue; }
        if (sr_res(h_src1[i]) == old) { h_src1[i] = nw; sr_rewrite_n = sr_rewrite_n + 1; }
        if (sr_res(h_src2[i]) == old && ho_src2_is_ref(k)) { h_src2[i] = nw; sr_rewrite_n = sr_rewrite_n + 1; }
        if ((k == HI_CALL || k == HI_CALLP) && h_cbase[i] >= 0) {
            q = 0;
            while (q < h_val[i]) {
                if (sr_res(h_carg[h_cbase[i] + q]) == old) {
                    h_carg[h_cbase[i] + q] = nw;
                    sr_rewrite_n = sr_rewrite_n + 1;
                }
                q = q + 1;
            }
        }
        if (k == HI_PHI && h_pbase[i] >= 0) {
            q = 0;
            while (q < h_pcnt[i]) {
                if (sr_res(h_pval[h_pbase[i] + q]) == old) {
                    h_pval[h_pbase[i] + q] = nw;
                    sr_rewrite_n = sr_rewrite_n + 1;
                }
                q = q + 1;
            }
        }
        i = i + 1;
    }
}

static int licm_stat_sr;

static void licm_strred(int header, int latch) {
    int pre;
    int phi;
    int i;
    int rec;
    int round;
    int nderived;

    pre = ssa_idom[header];
    if (pre < 0 || pre >= bb_nblk || ssa_vis[pre]) return;

    /* Base IVs: two-arg phis of the header whose latch arg is an
     * ADD/ADDI of the phi by an invariant step. */
    sr_niv = 0;
    sr_ndk = 0;
    phi = ssa_phi_head[header];
    while (phi >= 0 && sr_niv < SR_MAX_IV) {
        if (h_kind[phi] == HI_PHI && h_pcnt[phi] == 2) {
            int a_l;
            int a_0;
            a_l = sr_arg_of(phi, latch);
            a_0 = -1;
            i = 0;
            while (i < 2) {
                if (h_pblk[h_pbase[phi] + i] != latch)
                    a_0 = h_pval[h_pbase[phi] + i];
                i = i + 1;
            }
            if (a_l >= 0 && a_0 >= 0) {
                int stepv;
                stepv = -1;
                if (h_kind[a_l] == HI_ADDI && h_src1[a_l] == phi) {
                    /* materialize the constant step as an ICONST */
                    if (h_ninst < HIR_MAX_INST) {
                        stepv = sp_new_inst(HI_ICONST, TY_INT, -1, -1,
                                            h_val[a_l], pre);
                    }
                } else if (h_kind[a_l] == HI_ADD) {
                    if (h_src1[a_l] == phi &&
                        sr_invariant(sr_res(h_src2[a_l])))
                        stepv = sr_res(h_src2[a_l]);
                    else if (h_src2[a_l] == phi &&
                             sr_invariant(sr_res(h_src1[a_l])))
                        stepv = sr_res(h_src1[a_l]);
                }
                if (stepv >= 0 && ssa_vis[h_blk[a_l]]) {
                    sr_phi[sr_niv] = phi;
                    sr_init[sr_niv] = sr_res(a_0);
                    sr_step[sr_niv] = stepv;
                    sr_inc[sr_niv] = a_l;
                    sr_niv = sr_niv + 1;
                }
            }
        }
        phi = ssa_phi_next[phi];
    }
    if (sr_niv == 0) return;

    nderived = 0;
    round = 0;
    while (round < 2) {
        int lim;
        lim = h_ninst;
        i = 0;
        while (i < lim && nderived < 6) {
            int k;
            int r;
            int other;
            int knd;
            k = h_kind[i];
            r = -1;
            other = -1;
            knd = 0;
            if (h_blk[i] >= 0 && h_blk[i] < bb_nblk && ssa_vis[h_blk[i]]) {
                int o1;
                int o2;
                o1 = sr_res(h_src1[i]);
                o2 = sr_res(h_src2[i]);
                if (k == HI_SLL && o2 >= 0 &&
                    h_kind[o2] == HI_ICONST &&
                    h_val[o2] >= 1 && h_val[o2] <= 20) {
                    r = sr_find(o1);
                    other = o2;
                    knd = 1;
                } else if (k == HI_MUL) {
                    if (sr_find(o1) >= 0 && sr_invariant(o2)) {
                        r = sr_find(o1); other = o2; knd = 2;
                    } else if (sr_find(o2) >= 0 && sr_invariant(o1)) {
                        r = sr_find(o2); other = o1; knd = 2;
                    }
                } else if (k == HI_ADD && !licm_no_ptr_iv) {
                    if (sr_find(o1) >= 0 && sr_invariant(o2)) {
                        r = sr_find(o1); other = o2; knd = 3;
                    } else if (sr_find(o2) >= 0 && sr_invariant(o1)) {
                        r = sr_find(o2); other = o1; knd = 3;
                    }
                }
            }
            if (r >= 0 && other >= 0 && getenv("HIR_SR_DEBUG") &&
                !sr_uses_local(i)) {
                fdputs("SR reject cand=", 2);
                fdputuint(2, (unsigned)i);
                fdputs(" kind=", 2);
                fdputuint(2, (unsigned)k);
                fdputs(" (nonlocal use)\n", 2);
            }
            if (r >= 0 && other >= 0 && sr_uses_local(i) && sr_count_refs(i) > 0) {
                /* the same derived IV already made in this loop? */
                int d;
                int oconst;
                int oval;
                oconst = (h_kind[other] == HI_ICONST);
                oval = oconst ? h_val[other] : 0;
                d = 0;
                while (d < sr_ndk) {
                    if (sr_dk_phi[d] == sr_phi[r] && sr_dk_knd[d] == knd &&
                        ((oconst && sr_dk_oval[d] == oval && sr_dk_other[d] == -1) ||
                         (!oconst && sr_dk_other[d] == other))) break;
                    d = d + 1;
                }
                if (d < sr_ndk) {
                    sr_rewrite(i, sr_dk_new[d]);
                    h_kind[i] = HI_NOP;
                    h_src1[i] = -1;
                    h_src2[i] = -1;
                    i = i + 1;
                    continue;
                }
            }
            if (r >= 0 && other >= 0 && sr_uses_local(i) &&
                sr_count_refs(i) > 0 &&
                sr_niv < SR_MAX_IV && h_ninst + 4 < HIR_MAX_INST) {
                int ninit;
                int nstep;
                int nphi;
                int nnext;
                int okind;
                okind = (knd == 1) ? HI_SLL : ((knd == 2) ? HI_MUL : HI_ADD);
                /* init = op(iv.init, other), in the preheader */
                ninit = sp_new_inst(okind, h_ty[i], sr_init[r], other, 0, pre);
                if (licm_tail[pre] >= 0) licm_next[licm_tail[pre]] = ninit;
                else licm_head[pre] = ninit;
                licm_tail[pre] = ninit;
                /* step' = step<<k / step*m / step (for ADD) */
                if (knd == 3) {
                    nstep = sr_step[r];
                } else {
                    nstep = sp_new_inst(okind, TY_INT, sr_step[r], other, 0, pre);
                    licm_next[licm_tail[pre]] = nstep;
                    licm_tail[pre] = nstep;
                }
                /* the new phi, in the header's list */
                nphi = sp_new_inst(HI_PHI, h_ty[i], -1, -1, 0, header);
                if (h_nparg + 2 > HIR_MAX_PARG) return;
                h_pbase[nphi] = h_nparg;
                h_pcnt[nphi] = 2;
                {
                    int q;
                    q = 0;
                    while (q < 2) {
                        h_pblk[h_nparg] = h_pblk[h_pbase[sr_phi[r]] + q];
                        h_pval[h_nparg] =
                            (h_pblk[h_nparg] == latch) ? -1 : ninit;
                        h_nparg = h_nparg + 1;
                        q = q + 1;
                    }
                }
                ssa_phi_next[nphi] = ssa_phi_head[header];
                ssa_phi_head[header] = nphi;
                /* increment in the latch */
                nnext = sp_new_inst(HI_ADD, h_ty[i], nphi, nstep, 0, latch);
                if (licm_tail[latch] >= 0) licm_next[licm_tail[latch]] = nnext;
                else licm_head[latch] = nnext;
                licm_tail[latch] = nnext;
                {
                    int q;
                    q = 0;
                    while (q < 2) {
                        if (h_pblk[h_pbase[nphi] + q] == latch)
                            h_pval[h_pbase[nphi] + q] = nnext;
                        q = q + 1;
                    }
                }
                if (getenv("HIR_SR_DEBUG")) {
                fdputs("SR hdr=", 2);
                    fdputuint(2, (unsigned)(header));
                    fdputs(" latch=", 2);
                    fdputuint(2, (unsigned)(latch));
                    fdputs(" pre=", 2);
                    fdputuint(2, (unsigned)(pre));
                    fdputs(": cand=", 2);
                    fdputuint(2, (unsigned)(i));
                    fdputs(" kind=", 2);
                    fdputuint(2, (unsigned)(k));
                    fdputs(" iv=", 2);
                    fdputuint(2, (unsigned)(sr_phi[r]));
                    fdputs(" init=", 2);
                    fdputuint(2, (unsigned)(sr_init[r]));
                    fdputs(" step=", 2);
                    fdputuint(2, (unsigned)(sr_step[r]));
                    fdputs(" -> ninit=", 2);
                    fdputuint(2, (unsigned)(ninit));
                    fdputs(" nstep=", 2);
                    fdputuint(2, (unsigned)(nstep));
                    fdputs(" nphi=", 2);
                    fdputuint(2, (unsigned)(nphi));
                    fdputs(" nnext=", 2);
                    fdputuint(2, (unsigned)(nnext));
                    fdputc(10, 2);
                }
                /* rewrite and retire the original computation */
                sr_rewrite(i, nphi);
                if (getenv("HIR_SR_DEBUG")) {
                    fdputs("SR rewrote ", 2);
                    fdputuint(2, (unsigned)sr_rewrite_n);
                    fdputs(" refs of ", 2);
                    fdputuint(2, (unsigned)i);
                    fdputc(10, 2);
                }
                h_kind[i] = HI_NOP;
                h_src1[i] = -1;
                h_src2[i] = -1;
                /* register as an IV for round 2 */
                if (sr_ndk < SR_MAX_IV) {
                    sr_dk_phi[sr_ndk] = sr_phi[r];
                    sr_dk_knd[sr_ndk] = knd;
                    sr_dk_other[sr_ndk] = (h_kind[other] == HI_ICONST) ? -1 : other;
                    sr_dk_oval[sr_ndk] = (h_kind[other] == HI_ICONST) ? h_val[other] : 0;
                    sr_dk_new[sr_ndk] = nphi;
                    sr_ndk = sr_ndk + 1;
                }
                sr_phi[sr_niv] = nphi;
                sr_init[sr_niv] = ninit;
                sr_step[sr_niv] = nstep;
                sr_inc[sr_niv] = nnext;
                sr_niv = sr_niv + 1;
                nderived = nderived + 1;
                licm_stat_sr = licm_stat_sr + 1;
            }
            i = i + 1;
        }
        round = round + 1;
    }

    /* Sweep original IVs whose only remaining use is their own
     * increment (the subscripts were their only consumers). */
    i = 0;
    while (i < sr_niv) {
        int phi2;
        int inc2;
        int j;
        int k;
        int used;
        phi2 = sr_phi[i];
        inc2 = sr_inc[i];
        if (h_kind[phi2] != HI_PHI) { i = i + 1; continue; }
        used = 0;
        j = 0;
        while (j < h_ninst && !used) {
            k = h_kind[j];
            if (k == HI_NOP || j == inc2) { j = j + 1; continue; }
            if (h_src1[j] == phi2 || h_src1[j] == inc2) used = 1;
            if (!used && ho_src2_is_ref(k) &&
                (h_src2[j] == phi2 || h_src2[j] == inc2)) used = 1;
            if (!used && (k == HI_CALL || k == HI_CALLP) && h_cbase[j] >= 0) {
                int q;
                q = 0;
                while (q < h_val[j]) {
                    if (h_carg[h_cbase[j] + q] == phi2 ||
                        h_carg[h_cbase[j] + q] == inc2) used = 1;
                    q = q + 1;
                }
            }
            if (!used && k == HI_PHI && j != phi2 && h_pbase[j] >= 0) {
                int q;
                q = 0;
                while (q < h_pcnt[j]) {
                    if (h_pval[h_pbase[j] + q] == phi2 ||
                        h_pval[h_pbase[j] + q] == inc2) used = 1;
                    q = q + 1;
                }
            }
            j = j + 1;
        }
        if (getenv("HIR_SR_DEBUG")) {
        fdputs("SWEEP hdr=", 2);
            fdputuint(2, (unsigned)(header));
            fdputs(" rec=", 2);
            fdputuint(2, (unsigned)(i));
            fdputs(" phi=", 2);
            fdputuint(2, (unsigned)(phi2));
            fdputs(" inc=", 2);
            fdputuint(2, (unsigned)(inc2));
            fdputs(" used=", 2);
            fdputuint(2, (unsigned)(used));
            fdputc(10, 2);
        }
        if (!used) {
            /* unlink the phi from the header's list, NOP both */
            int pp;
            if (ssa_phi_head[header] == phi2) {
                ssa_phi_head[header] = ssa_phi_next[phi2];
            } else {
                pp = ssa_phi_head[header];
                while (pp >= 0 && ssa_phi_next[pp] != phi2) pp = ssa_phi_next[pp];
                if (pp >= 0) ssa_phi_next[pp] = ssa_phi_next[phi2];
            }
            h_kind[phi2] = HI_NOP;
            h_pcnt[phi2] = 0;
            h_kind[inc2] = HI_NOP;
            h_src1[inc2] = -1;
            h_src2[inc2] = -1;
        }
        i = i + 1;
    }
}

/* =================================================================
 * fp64 constant pairs into the INNERMOST loop preheader
 *
 * An fp64 pseudo-call reads each operand as an aligned register PAIR;
 * a constant operand is two ICONSTs, and a double's lo word is often
 * 0 (i12), so remat left the pair split and the emitter marshalled
 * through scratch -- two instructions EVERY iteration (mandel paid 4
 * per z-step before 2.0*X became X+X).  Clone both halves into the
 * INNERMOST enclosing loop's preheader hoist list and rewrite just
 * those carg slots; codegen pins the clones (h_no_remat via
 * licm_cpin) so the allocator can give them a pair.  If it cannot,
 * spill-to-remat unpins at zero cost and the remattable clone in the
 * hoist list emits nothing: exactly the status quo.
 *
 * Placement is the point, not the pin.  Two rejected placements, both
 * measured 2.8x WORSE: pinning the entry-block originals, and pinning
 * where licm_hoist leaves constants -- it chain-hoists them to the
 * OUTERMOST preheader, and under linear-interval liveness either way
 * gives a range spanning every enclosing loop; pairs being coloured
 * first, the constants starved the real loop pairs into spills.
 * Innermost placement re-materializes once per loop ENTRY (outer
 * iteration) to keep the pinned range one loop deep.
 *
 * Runs as a second scan after all loops are processed: licm_depth is
 * final, so "this loop is the call's innermost" is one compare; carg
 * slots still name NOPed hoisted originals until licm_rewrite, so
 * every operand read resolves one hop through licm_map (the deferred
 * -rewrite trap, hit a FOURTH time before this line was written).
 * ================================================================= */
static void licm_fp64_consts(int header, int latch) {
    int target;
    int body_count;
    int bi;
    int b;
    int i;
    int n;
    int j;
    int a;
    int p;
    int d;
    int fl;
    int fh;
    int dl[16];
    int dh[16];
    int dcl[16];
    int dch[16];
    int nd;

    target = ssa_idom[header];
    if (target < 0 || target >= bb_nblk) return;
    body_count = licm_find_body(header, latch);
    nd = 0;

    /* LEAF loops only.  A loop containing a nested loop gets nothing:
     * its constants are touched once per OUTER iteration, but the
     * pinned pair would sit on the register file across the whole
     * inner nest -- measured 2.1x worse on mandel (the 100.0 scale
     * divisor pinned across the z-loop).  In a leaf, every iteration
     * touches the use, so the pair pays for itself. */
    bi = 0;
    while (bi < body_count) {
        if (licm_depth[licm_body[bi]] != licm_depth[header]) return;
        bi = bi + 1;
    }

    bi = 0;
    while (bi < body_count) {
        b = licm_body[bi];
        i = bb_start[b];
        while (i < bb_end[b]) {
            n = h_val[i];
            if (h_kind[i] == HI_CALL && h_name[i] != NULL &&
                strncmp(h_name[i], "__fp64_", 7) == 0 &&
                h_cbase[i] >= 0 && (n == 2 || n == 4)) {
                j = 0;
                while (j + 1 < n) {
                    a = h_carg[h_cbase[i] + j];
                    p = h_carg[h_cbase[i] + j + 1];
                    if (a >= 0 && licm_map[a] >= 0) a = licm_map[a];
                    if (p >= 0 && licm_map[p] >= 0) p = licm_map[p];
                    if (a >= 0 && p >= 0 &&
                        h_kind[a] == HI_ICONST && h_kind[p] == HI_ICONST &&
                        !licm_cpin[a] && !licm_cpin[p]) {
                        /* One clone pair per distinct constant per loop. */
                        fl = -1;
                        fh = -1;
                        d = 0;
                        while (d < nd) {
                            if (dl[d] == h_val[a] && dh[d] == h_val[p]) {
                                fl = dcl[d];
                                fh = dch[d];
                                break;
                            }
                            d = d + 1;
                        }
                        if (fl < 0 && nd < 16) {
                            fl = licm_clone(a);
                            fh = licm_clone(p);
                            if (fl < 0 || fh < 0) return;
                            h_blk[fl] = target;
                            h_blk[fh] = target;
                            licm_cpin[fl] = 1;
                            licm_cpin[fh] = 1;
                            licm_next[fl] = -1;
                            licm_next[fh] = -1;
                            if (licm_tail[target] >= 0)
                                licm_next[licm_tail[target]] = fl;
                            else
                                licm_head[target] = fl;
                            licm_next[fl] = fh;
                            licm_tail[target] = fh;
                            dl[nd] = h_val[a];
                            dh[nd] = h_val[p];
                            dcl[nd] = fl;
                            dch[nd] = fh;
                            nd = nd + 1;
                            if (getenv("HIR_CP_DEBUG")) {
                                fdputs("cpin: pin pair hi=", 2);
                                fdputuint(2, (unsigned)h_val[fh]);
                                fdputs(" ph=", 2);
                                fdputuint(2, (unsigned)target);
                                fdputc(10, 2);
                            }
                        }
                        if (fl >= 0 && fh >= 0) {
                            h_carg[h_cbase[i] + j] = fl;
                            h_carg[h_cbase[i] + j + 1] = fh;
                        }
                    }
                    j = j + 2;
                }
            }
            i = i + 1;
        }
        bi = bi + 1;
    }
}

static void hir_licm(void) {
    int b;
    int i;
    int si;
    int s;
    int body_count;

    /* Initialize (licm_stat_hoisted is cumulative across functions) */
    b = 0;
    while (b < bb_nblk) {
        licm_head[b] = -1;
        licm_tail[b] = -1;
        licm_in_any_loop[b] = 0;
        licm_depth[b] = 0;
        split_head[b] = -1;
        b = b + 1;
    }
    /* Frame high-water for split slots: below every existing ALLOCA,
     * and never above fp-8 -- the frontend reserves the top 8 bytes
     * of the frame for the saved r31/r30 (f77_frame starts at 8; the
     * same ps_stack = 8 convention as the C compiler).  In a function
     * whose allocas were all promoted away, the scan alone sees
     * nothing and the first slot would land ON the saved return
     * address (SCALE in slice9: J overwrote r31's save; RETURN
     * jumped to J). */
    split_frame = 8;
    i = 0;
    while (i < h_ninst) {
        if (h_kind[i] == HI_ALLOCA && h_val[i] < 0 &&
            0 - h_val[i] > split_frame) split_frame = 0 - h_val[i];
        i = i + 1;
    }
    i = 0;
    while (i < h_ninst) {
        licm_map[i] = -1;
        licm_next[i] = -1;
        licm_cpin[i] = 0;
        ho_use[i] = 0;  /* clear stale use counts before reusing as invariant flag */
        i = i + 1;
    }

    /* Find natural loops: scan for back-edges (b -> s where s dominates b) */
    b = 0;
    while (b < bb_nblk) {
        /* Check each successor */
        si = 0;
        while (si < ssa_nsucc[b]) {
            s = ssa_succ[ssa_soff[b] + si];
            if (s >= 0 && s < bb_nblk && licm_dominates(s, b)) {
                /* Back-edge: b -> s, s is loop header */
                body_count = licm_find_body(s, b);
                {
                    int lb;
                    lb = 0;
                    while (lb < bb_nblk) {
                        if (ssa_vis[lb]) {
                            licm_in_any_loop[lb] = 1;
                            licm_depth[lb] = licm_depth[lb] + 1;
                        }
                        lb = lb + 1;
                    }
                }
                licm_cur_header = s;
                licm_cur_latch = b;
                licm_mark(body_count);
                if (!getenv("S12CC_NO_LICM")) licm_hoist(s, body_count);   /* A/B knob */
                if (licm_loopopt) {
                    if (licm_split_on) licm_split(s);
                    licm_strred(s, b);
                }
            }
            si = si + 1;
        }
        b = b + 1;
    }

    /* Second back-edge scan: licm_depth is final only now, so this is
     * the earliest "innermost loop" can be decided.  Must run before
     * licm_rewrite conceptually, but the pass resolves licm_map at
     * every operand read, so either side works; it adds mappings of
     * its own only via direct carg rewrites. */
    if (licm_loopopt) {
        b = 0;
        while (b < bb_nblk) {
            si = 0;
            while (si < ssa_nsucc[b]) {
                s = ssa_succ[ssa_soff[b] + si];
                if (s >= 0 && s < bb_nblk && licm_dominates(s, b))
                    licm_fp64_consts(s, b);
                si = si + 1;
            }
            b = b + 1;
        }
    }

    /* Global rewrite of all references */
    if (licm_stat_hoisted > 0) {
        licm_rewrite();
    }

}
