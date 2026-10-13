/* COPIED from slow32-public fortran/src/hir_ssa.h at 2245be78 (2026-10-12).  See PROVENANCE.md. */
/* COPIED from selfhost/stage08/hir_ssa.h at 30e16a57.  See note in hir.h. */
/* hir_ssa.h -- SSA construction for s12cc
 *
 * Phase B: CFG, RPO, dominator tree, DF, phi insertion, renaming.
 * Promotes scalar local ALLOCAs (not params, arrays, structs) to SSA.
 */

/* --- CFG arrays --- */
/* Successor lists use a CSR-style layout: each block b owns the slots
 * ssa_succ[ssa_soff[b] .. ssa_soff[b] + ssa_nsucc[b]).  ssa_soff[] is
 * assigned by a running cursor in ssa_build_cfg.  This supports an
 * arbitrary number of successors per block (e.g. jump-table dispatch),
 * not just the BR/BRC max of 2.
 *
 * Sized for total CFG edges in a function, not 2*blocks: a single dense
 * switch contributes up to its distinct-target count (bounded by case
 * count / HL_JT_MAX_SPAN).  4096 (the old 2-per-block bound) could be
 * exhausted by one large switch plus ordinary control flow, so allow ample
 * headroom; ssa_build_cfg still range-checks and aborts cleanly on overflow. */
#define SSA_SUCC_SZ 4096   /* fort370: one unit in an 8MB region, docs/FITTING.md */
static int ssa_succ[SSA_SUCC_SZ];
static int ssa_nsucc[HIR_MAX_BLOCK];
static int ssa_soff[HIR_MAX_BLOCK];

#define SSA_MAX_PRED 4096   /* fort370: one unit in an 8MB region, docs/FITTING.md */
static int ssa_pred[SSA_MAX_PRED];
static int ssa_pbase[HIR_MAX_BLOCK];
static int ssa_npred[HIR_MAX_BLOCK];

/* --- RPO --- */
static int ssa_rpo[HIR_MAX_BLOCK];
static int ssa_rpo_ord[HIR_MAX_BLOCK];
static int ssa_rpo_cnt;

/* --- Dominators --- */
static int ssa_idom[HIR_MAX_BLOCK];

/* --- Dominance frontier (fixed width per block) --- */
/* Per-block dominance-frontier width, and the flat array it indexes as
 * block * SSA_DF_W.  The two must be raised together: SSA_DF_SZ is
 * exactly HIR_MAX_BLOCK * SSA_DF_W, so bumping the width alone silently
 * shortens how many blocks are addressable.
 *
 * Raised 32 -> 64 because stage08 could no longer compile its own
 * source: some block in s12cc.c has a dominance frontier wider than 32,
 * and gen1 died with "too many dominance-frontier entries", failing the
 * (opt-in) fixed-point gate.  Dropping the entry instead would cost a
 * phi and silently produce a wrong reaching definition, so stopping is
 * right -- the ceiling just has to be big enough. */
#define SSA_DF_W 64
#define SSA_DF_SZ 65536   /* fort370: one unit in an 8MB region, docs/FITTING.md */
static short ssa_df[SSA_DF_SZ];   /* fort370: block numbers */
static int ssa_dfc[HIR_MAX_BLOCK];

/* --- Promotable variables --- */
#define SSA_MAX_PROMO 4096   /* was 256 */
static int ssa_promo[SSA_MAX_PROMO];
static int ssa_npromo;

/* The function calls setjmp.  A longjmp brings control back to that
 * call with the callee-saved registers as they were when setjmp was
 * first called and memory as it is now -- so a local kept in a register
 * goes back to an old value, and one kept in memory does not.  The
 * standard asks only that volatile locals keep what was last stored;
 * here every named local of such a function stays in memory, which
 * gives volatile ones what they are owed and the rest more.  The
 * allocator, for its part, gives each spilled value a slot of its own
 * in such a function (hir_regalloc.h): a slot shared by two values with
 * disjoint lifetimes is disjoint only along paths the flow graph has,
 * and the way back from longjmp is not one of them.  (selfhost
 * ISSUES-75: the library had no setjmp until then, so no program this
 * compiler built had called it.) */
static int ssa_fn_setjmp;

static int ssa_is_setjmp_name(char *nm) {
    if (nm == NULL) return 0;
    if (strcmp(nm, "setjmp") == 0) return 1;
    if (strcmp(nm, "_setjmp") == 0) return 1;
    if (strcmp(nm, "sigsetjmp") == 0) return 1;
    if (strcmp(nm, "__sigsetjmp") == 0) return 1;
    return 0;
}
static int ssa_phi_base; /* h_ninst before phi insertion */

/* --- PHI optimization (linked lists per block) --- */
static int ssa_phi_head[HIR_MAX_BLOCK];
static int ssa_phi_next[HIR_MAX_INST];

/* hl_nparams defined in hir_lower.h (shared) */

/* --- Dom tree children (flat) --- */
#define SSA_DTC_MAX HIR_MAX_BLOCK   /* fort370: every block but the entry is one child */
static int ssa_dtc[SSA_DTC_MAX];
static int ssa_dtc_base[HIR_MAX_BLOCK];
static int ssa_dtc_cnt[HIR_MAX_BLOCK];

/* --- Rename: per-variable value stack --- */
/* SSA_VD bounds the depth of the per-variable value stack along any
 * single dominator-tree path during SSA rename.  64 was tight: a few
 * deeply-nested functions in tools/dbt (block_cache.c) hit the cap.
 * 256 leaves comfortable headroom; the cost is just static memory in
 * the compiler. */
/* fort370: the stacks are threaded through the push log instead of
 * being SSA_VD deep each.  Pushes and pops are in strict stack order
 * along the dominator-tree walk, so a push is the log entry that records
 * it: the variable (ssa_plog), its value (ssa_pval) and the variable's
 * previous top (ssa_pprev).  ssa_vtop[v] is the log index of v's top, or
 * -1 when only the undefined value is on it.  The fixed-depth stacks had
 * been cut from 16MB to 128K for the region with their indexing kept, so
 * a unit with more than 32 promoted variables wrote past the table. */
#define SSA_VD 1024   /* was 256 */
static int ssa_vtop[SSA_MAX_PROMO];

/* --- Rename: DFS stack --- */
#define SSA_DFS (2 * HIR_MAX_BLOCK)   /* fort370: the walk holds a path of the dominator tree */
static int ssa_rblk[SSA_DFS];
static int ssa_rci[SSA_DFS];
static int ssa_rmark[SSA_DFS];

/* --- Rename: push log for backtracking --- */
#define SSA_PLOG 16384   /* fort370: pushes live along one path of the dominator tree */
static int ssa_plog[SSA_PLOG];
static int ssa_pval[SSA_PLOG];
static int ssa_pprev[SSA_PLOG];
static int ssa_plog_n;

/* --- Temp arrays (reused across passes) --- */
static int ssa_vis[HIR_MAX_BLOCK];
static int ssa_post[HIR_MAX_BLOCK];
static int ssa_tmp1[HIR_MAX_BLOCK];  /* cnt / wl */
static int ssa_tmp2[HIR_MAX_BLOCK];  /* has_phi */
static int ssa_tmp3[HIR_MAX_BLOCK];  /* in_wl */

/* ------------------------------------------------------------ */

static int ssa_find_promo_idx(int inst) {
    int i;
    if (inst < 0) return -1;
    if (h_kind[inst] != HI_ALLOCA) return -1;
    i = 0;
    while (i < ssa_npromo) {
        if (ssa_promo[i] == inst) return i;
        i = i + 1;
    }
    return -1;
}

static int ssa_phi_find_arg(int phi, int pred) {
    int base;
    int cnt;
    int j;
    base = h_pbase[phi];
    cnt = h_pcnt[phi];
    j = 0;
    while (j < cnt) {
        if (h_pblk[base + j] == pred) return h_pval[base + j];
        j = j + 1;
    }
    return -1;
}

/* ------------------------------------------------------------ */
/* Step 1: Build CFG successor/predecessor lists                */
/* ------------------------------------------------------------ */

static void ssa_build_cfg(void) {
    int b;
    int term;
    int k;
    int total;
    int i;
    int s;
    int pb;
    int cursor;

    b = 0;
    while (b < bb_nblk) {
        ssa_nsucc[b] = 0;
        ssa_npred[b] = 0;
        b = b + 1;
    }

    /* Build successors from terminators.
       A terminator is the LAST instruction of its block, by contract:
       the codegen emits a block's instructions in order and drops the
       branch of a RET or BR to the block laid out next (GitHub issue
       72), so an instruction after the terminator would RUN.  The C
       lowering skips statements after one (hl_stmt's ND_BLOCK loop);
       the Fortran front did not, at a statement after RETURN, and FCVS
       FM509 ran the next ENTRY's body through a phantom dummy.  Stop
       here rather than miscompile.

       ssa_soff[b] is the cursor position where block b's successor
       slots begin in the flat ssa_succ[] pool; cursor advances by the
       number of successors emitted for each block. */
    cursor = 0;
    b = 0;
    while (b < bb_nblk) {
        ssa_soff[b] = cursor;
        if (bb_start[b] >= bb_end[b]) { b = b + 1; continue; }
        term = bb_start[b];
        while (term < bb_end[b]) {
            k = h_kind[term];
            if (hi_is_terminator(k)) break;
            term = term + 1;
        }
        if (term < bb_end[b]) {
            i = term + 1;
            while (i < bb_end[b]) {
                if (h_kind[i] != HI_NOP) {
                    fdputs("s12cc: instructions after a block's terminator (fn=", 2);
                    fdputs(hl_cur_fn_dbg ? hl_cur_fn_dbg : "?", 2);
                    fdputs(")\n", 2);
                    exit(1);
                }
                i = i + 1;
            }
            k = h_kind[term];
            if (k == HI_BR) {
                if (cursor + 1 > SSA_SUCC_SZ) {
                    fdputs("s12cc: too many CFG successor edges\n", 2);
                    exit(1);
                }
                ssa_succ[cursor] = h_val[term];
                ssa_nsucc[b] = 1;
            } else if (k == HI_BRC) {
                if (cursor + 2 > SSA_SUCC_SZ) {
                    fdputs("s12cc: too many CFG successor edges\n", 2);
                    exit(1);
                }
                ssa_succ[cursor] = h_src2[term];
                ssa_succ[cursor + 1] = h_val[term];
                ssa_nsucc[b] = 2;
            } else if (k == HI_JMPTAB) {
                /* Successors = the DISTINCT destination blocks among the
                 * default and every table entry.  Dedup so each edge is
                 * listed once (duplicates would inflate predecessor counts
                 * and break per-predecessor phi-arg matching). */
                int base; int span; int t; int u; int seen; int n;
                base = hjt_base[term];
                span = hjt_span[term];
                n = 0;
                /* default first */
                if (cursor + 1 > SSA_SUCC_SZ) {
                    fdputs("s12cc: too many CFG successor edges\n", 2);
                    exit(1);
                }
                ssa_succ[cursor] = h_val[term];
                n = 1;
                t = 0;
                while (t < span) {
                    int tgt;
                    tgt = hjt_target[base + t];
                    seen = 0;
                    u = 0;
                    while (u < n) {
                        if (ssa_succ[cursor + u] == tgt) { seen = 1; break; }
                        u = u + 1;
                    }
                    if (!seen) {
                        if (cursor + n + 1 > SSA_SUCC_SZ) {
                            fdputs("s12cc: too many CFG successor edges\n", 2);
                            exit(1);
                        }
                        ssa_succ[cursor + n] = tgt;
                        n = n + 1;
                    }
                    t = t + 1;
                }
                ssa_nsucc[b] = n;
            }
        }
        cursor = cursor + ssa_nsucc[b];
        b = b + 1;
    }

    /* Count predecessors (with bounds validation on targets) */
    b = 0;
    while (b < bb_nblk) {
        i = 0;
        while (i < ssa_nsucc[b]) {
            s = ssa_succ[ssa_soff[b] + i];
            if (s >= 0 && s < bb_nblk) {
                ssa_npred[s] = ssa_npred[s] + 1;
                i = i + 1;
            } else {
                /* Invalid target — swap-remove: move the last edge into this
                 * slot and shrink.  Correct for any successor count (1, 2, or
                 * the N of a jump table); order is irrelevant to all readers. */
                ssa_succ[ssa_soff[b] + i] = ssa_succ[ssa_soff[b] + ssa_nsucc[b] - 1];
                ssa_nsucc[b] = ssa_nsucc[b] - 1;
                /* Don't increment i — retry current slot which now has the moved edge */
            }
        }
        b = b + 1;
    }

    /* Compute pred bases */
    total = 0;
    b = 0;
    while (b < bb_nblk) {
        ssa_pbase[b] = total;
        total = total + ssa_npred[b];
        ssa_npred[b] = 0;
        b = b + 1;
    }
    if (total > SSA_MAX_PRED) {
        fdputs("s12cc: too many CFG edges\n", 2);
        exit(1);
    }

    /* Fill predecessors (with bounds validation) */
    b = 0;
    while (b < bb_nblk) {
        i = 0;
        while (i < ssa_nsucc[b]) {
            s = ssa_succ[ssa_soff[b] + i];
            if (s >= 0 && s < bb_nblk) {
                pb = ssa_pbase[s] + ssa_npred[s];
                ssa_pred[pb] = b;
                ssa_npred[s] = ssa_npred[s] + 1;
            }
            i = i + 1;
        }
        b = b + 1;
    }
}

/* ------------------------------------------------------------ */
/* Step 2: Compute RPO via iterative DFS                        */
/* ------------------------------------------------------------ */

static void ssa_compute_rpo(void) {
    int top;
    int b;
    int i;
    int s;
    int post_n;

    b = 0;
    while (b < bb_nblk) {
        ssa_vis[b] = 0;
        ssa_rpo[b] = -1;
        b = b + 1;
    }
    post_n = 0;

    top = 0;
    ssa_rblk[0] = 0;
    ssa_rci[0] = 0;
    ssa_vis[0] = 1;

    while (top >= 0) {
        b = ssa_rblk[top];
        i = ssa_rci[top];
        if (i < ssa_nsucc[b]) {
            ssa_rci[top] = i + 1;
            s = ssa_succ[ssa_soff[b] + i];
            if (!ssa_vis[s]) {
                ssa_vis[s] = 1;
                top = top + 1;
                if (top >= SSA_DFS) {
                    fdputs("s12cc: RPO DFS stack overflow\n", 2);
                    exit(1);
                }
                ssa_rblk[top] = s;
                ssa_rci[top] = 0;
            }
        } else {
            ssa_post[post_n] = b;
            post_n = post_n + 1;
            top = top - 1;
        }
    }

    /* Reverse post-order = reversed post_order */
    ssa_rpo_cnt = post_n;
    i = 0;
    while (i < post_n) {
        ssa_rpo_ord[i] = ssa_post[post_n - 1 - i];
        ssa_rpo[ssa_rpo_ord[i]] = i;
        i = i + 1;
    }
}

/* ------------------------------------------------------------ */
/* Step 3: Compute immediate dominators (Cooper-Harvey-Kennedy)  */
/* ------------------------------------------------------------ */

static int ssa_intersect(int b1, int b2) {
    int guard;
    guard = 0;
    while (b1 != b2) {
        while (ssa_rpo[b1] > ssa_rpo[b2]) {
            if (b1 == ssa_idom[b1]) return b1; /* at root */
            b1 = ssa_idom[b1];
        }
        while (ssa_rpo[b2] > ssa_rpo[b1]) {
            if (b2 == ssa_idom[b2]) return b2; /* at root */
            b2 = ssa_idom[b2];
        }
        guard = guard + 1;
        if (guard > bb_nblk) return 0; /* bail to entry */
    }
    return b1;
}

static void ssa_compute_idom(void) {
    int changed;
    int ri;
    int b;
    int j;
    int p;
    int new_idom;

    b = 0;
    while (b < bb_nblk) {
        ssa_idom[b] = -1;
        b = b + 1;
    }
    ssa_idom[0] = 0;

    changed = 1;
    while (changed) {
        changed = 0;
        ri = 1;
        while (ri < ssa_rpo_cnt) {
            b = ssa_rpo_ord[ri];
            new_idom = -1;
            j = 0;
            while (j < ssa_npred[b]) {
                p = ssa_pred[ssa_pbase[b] + j];
                if (ssa_idom[p] >= 0) {
                    if (new_idom < 0) {
                        new_idom = p;
                    } else {
                        new_idom = ssa_intersect(new_idom, p);
                    }
                }
                j = j + 1;
            }
            if (new_idom >= 0 && ssa_idom[b] != new_idom) {
                ssa_idom[b] = new_idom;
                changed = 1;
            }
            ri = ri + 1;
        }
    }
}

/* ------------------------------------------------------------ */
/* Step 4: Compute dominance frontiers                           */
/* ------------------------------------------------------------ */

static void ssa_compute_df(void) {
    int b;
    int j;
    int p;
    int runner;
    int base;
    int di;
    int dup;

    b = 0;
    while (b < bb_nblk) {
        ssa_dfc[b] = 0;
        b = b + 1;
    }

    b = 0;
    while (b < bb_nblk) {
        if (ssa_npred[b] < 2) { b = b + 1; continue; }
        if (ssa_idom[b] < 0) { b = b + 1; continue; }
        j = 0;
        while (j < ssa_npred[b]) {
            p = ssa_pred[ssa_pbase[b] + j];
            runner = p;
            while (runner >= 0 && runner != ssa_idom[b]) {
                /* Add b to DF(runner), check dups */
                base = runner * SSA_DF_W;
                dup = 0;
                di = 0;
                while (di < ssa_dfc[runner]) {
                    if (ssa_df[base + di] == b) { dup = 1; }
                    di = di + 1;
                }
                if (!dup) {
                    if (ssa_dfc[runner] >= SSA_DF_W) {
                        /* Dropping the entry costs a phi, and a missing
                         * phi is a wrong reaching definition that nothing
                         * downstream can notice -- the one ceiling in this
                         * file that used to fail silently (GitHub issue
                         * 53).  Every other one stops here. */
                        fdputs("s12cc: too many dominance-frontier entries\n", 2);
                        exit(1);
                    }
                    ssa_df[base + ssa_dfc[runner]] = b;
                    ssa_dfc[runner] = ssa_dfc[runner] + 1;
                }
                /* Stop at root (self-dominating entry node) */
                if (runner == ssa_idom[runner]) break;
                runner = ssa_idom[runner];
            }
            j = j + 1;
        }
        b = b + 1;
    }
}

/* ------------------------------------------------------------ */
/* Step 5: Find promotable ALLOCAs                               */
/* ------------------------------------------------------------ */

static void ssa_find_promo(void) {
    int i;
    int j;
    int k;
    int ai;
    int a;
    int off;
    int ok[HL_MAX_ALLOCA];

    /* The promo list is rebuilt at the end of this scan; clear it up
     * front so nothing consults the PREVIOUS function's entries. */
    ssa_npromo = 0;

    /* Mark all allocas as potentially promotable */
    i = 0;
    while (i < hl_nalloca) {
        ok[i] = 1;
        i = i + 1;
    }

    /* A function that calls setjmp keeps its named locals in memory
     * (slot ids are the parser's, one per declaration; 0 is a temp of
     * the lowering's own, which does not live across a statement). */
    ssa_fn_setjmp = 0;
    i = 0;
    while (i < h_ninst) {
        if (h_kind[i] == HI_CALL && ssa_is_setjmp_name(h_name[i])) ssa_fn_setjmp = 1;
        i = i + 1;
    }
    if (ssa_fn_setjmp) {
        i = 0;
        while (i < hl_nalloca) {
            if (hl_aslot[i] != 0) ok[i] = 0;
            i = i + 1;
        }
    }

    /* Scan instructions for non-promotable uses */
    i = 0;
    while (i < h_ninst) {
        k = h_kind[i];
        /* src1: only OK as addr in a LOAD or STORE whose type MATCHES
         * the alloca's.  Reject unconditionally otherwise — an earlier
         * ssa_find_promo_idx() guard here consulted ssa_promo[], which
         * at this point still held the PREVIOUS function's list, so an
         * escaping alloca whose inst id collided with a stale entry
         * skipped rejection and got promoted (cc-a64: a double
         * literal's temp alloca escaping into ADDI+4 was promoted, and
         * the f64 LOAD collapsed to its lo-word ICONST).
         *
         * The type check treats a PUNNED access as address-taken:
         * `*(unsigned long long *)&d` is a LOAD on d's alloca, so the
         * old scan happily promoted d — the pun then read a stale slot
         * or a wrong-class register (cc-a64: every such pun returned
         * stack junk; d35_fp_loads).  fp-ness or width mismatch
         * blocks promotion; same-width integer sign punning stays
         * promotable. */
        if (h_src1[i] >= 0 && h_kind[h_src1[i]] == HI_ALLOCA) {
            int punned;
            punned = 0;
            if (k == HI_LOAD || k == HI_STORE) {
                if (ty_is_fp(h_ty[i]) != ty_is_fp(h_ty[h_src1[i]]) ||
                    ty_size(h_ty[i]) != ty_size(h_ty[h_src1[i]]))
                    punned = 1;
            }
            if ((k != HI_LOAD && k != HI_STORE) || punned) {
                j = 0;
                while (j < hl_nalloca) {
                    if (hl_ainst[j] == h_src1[i]) { ok[j] = 0; }
                    j = j + 1;
                }
            }
        }
        /* src2: any alloca as src2 means address-taken (STORE val).
         * Only check when src2 is actually an inst reference -- for
         * HI_BR/HI_BRC, src2 is a block index that can coincidentally
         * match an alloca's inst index, which would falsely reject the
         * alloca.  Inlined to avoid a forward dep on hir_opt.h. */
        if (h_src2[i] >= 0 && k != HI_BR && k != HI_BRC &&
            k != HI_PHI && k != HI_NOP &&
            h_kind[h_src2[i]] == HI_ALLOCA) {
            j = 0;
            while (j < hl_nalloca) {
                if (hl_ainst[j] == h_src2[i]) { ok[j] = 0; }
                j = j + 1;
            }
        }
        /* Call arguments */
        if (k == HI_CALL || k == HI_CALLP ||
            k == HI_A64_DBT_TRAMPOLINE || k == HI_X64_DBT_TRAMPOLINE) {
            j = 0;
            while (j < h_val[i]) {
                a = h_carg[h_cbase[i] + j];
                if (a >= 0 && h_kind[a] == HI_ALLOCA) {
                    ai = 0;
                    while (ai < hl_nalloca) {
                        if (hl_ainst[ai] == a) { ok[ai] = 0; }
                        ai = ai + 1;
                    }
                }
                j = j + 1;
            }
        }
        i = i + 1;
    }

    /* Diagnostic: print summary so the caller can see find_promo
     * running for every function. */
    if (getenv("CC_X64_PROMO_DEBUG")) {
        int n_rejected = 0;
        int xi = 0;
        while (xi < hl_nalloca) { if (!ok[xi]) n_rejected = n_rejected + 1; xi = xi + 1; }
        fdputs("PROMO_SUMMARY: ninst=", 2); fdputuint(2, h_ninst);
        fdputs(" hl_nalloca=", 2); fdputuint(2, hl_nalloca);
        fdputs(" rejected=", 2); fdputuint(2, n_rejected);
        fdputs("\n", 2);
    }

    /* Diagnostic: dump rejection reasons when CC_X64_PROMO_DEBUG is set.
     * Prints each non-promotable alloca with its inst index plus the
     * first instruction that rejected it.  Correlate with --hir-dump. */
    if (getenv("CC_X64_PROMO_DEBUG")) {
        i = 0;
        while (i < hl_nalloca) {
            if (!ok[i]) {
                int reason_inst = -1;
                int reason_kind = 0;
                char *reason_why = "(?)";
                int xi = 0;
                while (xi < h_ninst) {
                    int xk = h_kind[xi];
                    if (h_src1[xi] == hl_ainst[i] && xk != HI_LOAD && xk != HI_STORE) {
                        reason_inst = xi; reason_kind = xk;
                        reason_why = "src1-non-load-store"; break;
                    }
                    if (h_src2[xi] == hl_ainst[i] &&
                        xk != HI_BR && xk != HI_BRC &&
                        xk != HI_PHI && xk != HI_NOP) {
                        reason_inst = xi; reason_kind = xk;
                        reason_why = "src2"; break;
                    }
                    if ((xk == HI_CALL || xk == HI_CALLP ||
                         xk == HI_A64_DBT_TRAMPOLINE ||
                         xk == HI_X64_DBT_TRAMPOLINE) &&
                        h_cbase[xi] >= 0) {
                        int cj = 0;
                        while (cj < h_val[xi]) {
                            if (h_carg[h_cbase[xi] + cj] == hl_ainst[i]) {
                                reason_inst = xi; reason_kind = xk;
                                reason_why = "call-arg"; break;
                            }
                            cj = cj + 1;
                        }
                        if (reason_inst >= 0) break;
                    }
                    xi = xi + 1;
                }
                fdputs("PROMO_REJECT: ninst=", 2); fdputuint(2, h_ninst);
                fdputs(" alloca i", 2);
                fdputuint(2, hl_ainst[i]);
                fdputs(" off=", 2); fdputuint(2, hl_aoff[i]);
                fdputs(" reason=", 2); fdputs(reason_why, 2);
                if (reason_inst >= 0) {
                    fdputs(" inst=", 2); fdputuint(2, reason_inst);
                    fdputs(" k=", 2); fdputuint(2, reason_kind);
                }
                fdputs("\n", 2);
            }
            i = i + 1;
        }
    }

    /* Collect promotable ALLOCAs */
    ssa_npromo = 0;
    i = 0;
    while (i < hl_nalloca) {
        if (ok[i] && ssa_npromo < SSA_MAX_PROMO) {
            ssa_promo[ssa_npromo] = hl_ainst[i];
            ssa_npromo = ssa_npromo + 1;
        }
        i = i + 1;
    }
}

/* ------------------------------------------------------------ */
/* Step 6: Build dominator tree children lists                   */
/* ------------------------------------------------------------ */

static void ssa_build_dtree(void) {
    int b;
    int total;
    int p;

    /* Use ssa_tmp1 as cnt[] (static, avoids large stack frame) */
    b = 0;
    while (b < bb_nblk) {
        ssa_tmp1[b] = 0;
        b = b + 1;
    }

    b = 1;
    while (b < bb_nblk) {
        if (ssa_idom[b] >= 0 && ssa_idom[b] != b) {
            ssa_tmp1[ssa_idom[b]] = ssa_tmp1[ssa_idom[b]] + 1;
        }
        b = b + 1;
    }

    total = 0;
    b = 0;
    while (b < bb_nblk) {
        ssa_dtc_base[b] = total;
        ssa_dtc_cnt[b] = 0;
        total = total + ssa_tmp1[b];
        b = b + 1;
    }
    if (total > SSA_DTC_MAX) {
        fdputs("s12cc: too many domtree children\n", 2);
        exit(1);
    }

    b = 1;
    while (b < bb_nblk) {
        if (ssa_idom[b] >= 0 && ssa_idom[b] != b) {
            p = ssa_idom[b];
            ssa_dtc[ssa_dtc_base[p] + ssa_dtc_cnt[p]] = b;
            ssa_dtc_cnt[p] = ssa_dtc_cnt[p] + 1;
        }
        b = b + 1;
    }
}

/* ------------------------------------------------------------ */
/* Step 7: Insert phi nodes                                      */
/* ------------------------------------------------------------ */

static void ssa_insert_phis(void) {
    int v;
    int i;
    int b;
    int d;
    int di;
    int phi;
    int ty;
    int j;
    int wh;
    int wt;

    ssa_phi_base = h_ninst;

    v = 0;
    while (v < ssa_npromo) {
        ty = h_ty[ssa_promo[v]];

        /* ssa_tmp2 = has_phi, ssa_tmp3 = in_wl, ssa_tmp1 = wl */
        b = 0;
        while (b < bb_nblk) {
            ssa_tmp2[b] = 0;
            ssa_tmp3[b] = 0;
            b = b + 1;
        }

        /* Worklist: blocks with stores to this var */
        wh = 0;
        wt = 0;
        i = 0;
        while (i < ssa_phi_base) {
            if (h_kind[i] == HI_STORE && h_src1[i] == ssa_promo[v]) {
                b = h_blk[i];
                if (!ssa_tmp3[b]) {
                    ssa_tmp3[b] = 1;
                    ssa_tmp1[wt] = b;
                    wt = wt + 1;
                }
            }
            i = i + 1;
        }

        while (wh < wt) {
            b = ssa_tmp1[wh];
            wh = wh + 1;
            di = 0;
            while (di < ssa_dfc[b]) {
                d = ssa_df[b * SSA_DF_W + di];
                if (!ssa_tmp2[d] && ssa_rpo[d] >= 0) {
                    ssa_tmp2[d] = 1;
                    /* Emit PHI, pre-allocate arg slots */
                    phi = hi_emit(HI_PHI, ty, -1, -1, v, NULL);
                    h_blk[phi] = d;
                    h_pbase[phi] = h_nparg;
                    h_pcnt[phi] = ssa_npred[d];
                    j = 0;
                    while (j < ssa_npred[d]) {
                        if (h_nparg >= HIR_MAX_PARG) {
                            fdputs("s12cc: too many phi args\n", 2);
                            exit(1);
                        }
                        h_pblk[h_nparg] = ssa_pred[ssa_pbase[d] + j];
                        h_pval[h_nparg] = -1;
                        h_nparg = h_nparg + 1;
                        j = j + 1;
                    }
                    if (!ssa_tmp3[d]) {
                        ssa_tmp3[d] = 1;
                        ssa_tmp1[wt] = d;
                        wt = wt + 1;
                    }
                }
                di = di + 1;
            }
        }
        v = v + 1;
    }

    /* Build PHI lists per block for fast lookup in ssa_rename */
    b = 0;
    while (b < bb_nblk) { ssa_phi_head[b] = -1; b = b + 1; }
    i = ssa_phi_base;
    while (i < h_ninst) {
        if (h_kind[i] == HI_PHI) {
            b = h_blk[i];
            ssa_phi_next[i] = ssa_phi_head[b];
            ssa_phi_head[b] = i;
        }
        i = i + 1;
    }
}

/* ------------------------------------------------------------ */
/* Step 8: Rename variables (iterative DFS on domtree)           */
/* ------------------------------------------------------------ */

static void ssa_vpush(int v, int val) {
    if (ssa_plog_n >= SSA_PLOG) {
        fdputs("f77: SSA push log overflow (a unit too large to rename)\n", 2);
        exit(1);
    }
    ssa_plog[ssa_plog_n] = v;
    ssa_pval[ssa_plog_n] = val;
    ssa_pprev[ssa_plog_n] = ssa_vtop[v];
    ssa_vtop[v] = ssa_plog_n;
    ssa_plog_n = ssa_plog_n + 1;
}

static int ssa_vcur(int v) {
    if (ssa_vtop[v] < 0) return -1;
    return ssa_pval[ssa_vtop[v]];
}

static void ssa_rename(void) {
    int top;
    int b;
    int ci;
    int nch;
    int child;
    int i;
    int k;
    int v;
    int val;
    int si;
    int s;
    int j;
    int phi_v;

    /* Init variable stacks: all start with undef (-1) */
    v = 0;
    while (v < ssa_npromo) {
        ssa_vtop[v] = -1;            /* the undefined value */
        v = v + 1;
    }
    ssa_plog_n = 0;

    /* DFS from entry block */
    top = 0;
    ssa_rblk[0] = 0;
    ssa_rci[0] = -1;
    ssa_rmark[0] = 0;

    while (top >= 0) {
        b = ssa_rblk[top];
        ci = ssa_rci[top];

        if (ci == -1) {
            /* First visit: process block b */
            ssa_rmark[top] = ssa_plog_n;

            /* Process PHI nodes in block b (they define the variable) */
            i = ssa_phi_head[b];
            while (i >= 0) {
                phi_v = h_val[i];
                ssa_vpush(phi_v, i);
                i = ssa_phi_next[i];
            }

            /* Process regular instructions (stop at first terminator
               to avoid processing dead code after goto/break/return) */
            i = bb_start[b];
            while (i < bb_end[b]) {
                k = h_kind[i];
                if (k == HI_LOAD) {
                    v = ssa_find_promo_idx(h_src1[i]);
                    if (v >= 0) {
                        val = ssa_vcur(v);
                        h_kind[i] = HI_COPY;
                        h_src1[i] = val;
                    }
                } else if (k == HI_STORE) {
                    v = ssa_find_promo_idx(h_src1[i]);
                    if (v >= 0) {
                        ssa_vpush(v, h_src2[i]);
                        h_kind[i] = HI_NOP;
                    }
                }
                if (hi_is_terminator(k)) {
                    i = i + 1;
                    break;
                }
                i = i + 1;
            }

            /* Fill phi args in successors */
            si = 0;
            while (si < ssa_nsucc[b]) {
                s = ssa_succ[ssa_soff[b] + si];
                i = ssa_phi_head[s];
                while (i >= 0) {
                    phi_v = h_val[i];
                    val = ssa_vcur(phi_v);
                    /* Find this pred's slot in phi args */
                    j = 0;
                    while (j < h_pcnt[i]) {
                        if (h_pblk[h_pbase[i] + j] == b) {
                            h_pval[h_pbase[i] + j] = val;
                        }
                        j = j + 1;
                    }
                    i = ssa_phi_next[i];
                }
                si = si + 1;
            }

            ssa_rci[top] = 0;
        } else {
            nch = ssa_dtc_cnt[b];
            if (ci < nch) {
                child = ssa_dtc[ssa_dtc_base[b] + ci];
                ssa_rci[top] = ci + 1;
                top = top + 1;
                if (top >= SSA_DFS) {
                    fdputs("s12cc: SSA DFS stack overflow\n", 2);
                    exit(1);
                }
                ssa_rblk[top] = child;
                ssa_rci[top] = -1;
            } else {
                /* Backtrack: pop variable stacks */
                while (ssa_plog_n > ssa_rmark[top]) {
                    ssa_plog_n = ssa_plog_n - 1;
                    v = ssa_plog[ssa_plog_n];
                    ssa_vtop[v] = ssa_pprev[ssa_plog_n];
                }
                top = top - 1;
            }
        }
    }
}

/* ------------------------------------------------------------ */
/* Main entry point                                              */
/* ------------------------------------------------------------ */


/* =================================================================
 * Pair-alloca splitting (DIVERGENCE: SLOW-32 targets only)
 *
 * On SLOW-32, hir_lower reads a double or long long local as two
 * TY_INT word accesses: LOAD [A] for the lo half and LOAD [ADDI(A,4)]
 * for the hi half.  ssa_find_promo sees the ADDI as address-taken and
 * the width mismatch as a pun, so no 8-byte local was ever promoted
 * -- every fp64 operation in a C loop reloaded and re-stored both
 * halves through the frame, and the register allocator's pair
 * machinery (which took LINPACK-F77 to 1.048x clang) never saw C
 * doubles at all.
 *
 * Split each conforming 8-byte alloca into two independent TY_INT
 * allocas: A keeps the lo half (retyped), a fresh sibling at
 * offset+4 takes the hi half, the ADDI(+4) nodes' loads and stores
 * are redirected to the sibling and the ADDIs NOPed.  The existing
 * scalar mem2reg then promotes both halves, phis form per word, and
 * ra_build_pairs pairs them back up at every fp64 pseudo-call.
 *
 * Conformity: every reference to A must be a LOAD/STORE of size 4 at
 * displacement 0, or an ADDI(A, 4) whose own uses are all such
 * LOAD/STOREs.  Any other use -- address passed to a call, stored as
 * a value, referenced by a phi, a different displacement -- rejects
 * the alloca untouched.  The x64/a64 crosses share this file but
 * lower 8-byte locals natively; they leave ssa_split_pairs unset.
 * ================================================================= */
static int ssa_split_pairs;

static void ssa_split_pair_allocas(void) {
    int j;
    int i;
    int k;
    int q;
    int a_inst;
    int nhi;
    int hi_nodes[8];

    j = 0;
    while (j < hl_nalloca) {
        int ok;
        int ah;
        a_inst = hl_ainst[j];
        if (a_inst < 0 || h_kind[a_inst] != HI_ALLOCA ||
            ty_size(h_ty[a_inst]) != 8 || ty_is_struct(h_ty[a_inst])) {
            j = j + 1;
            continue;
        }

        ok = 1;
        nhi = 0;
        i = 0;
        while (i < h_ninst && ok) {
            k = h_kind[i];
            if (k == HI_NOP) { i = i + 1; continue; }
            if (h_src1[i] == a_inst) {
                if ((k == HI_LOAD || k == HI_STORE) &&
                    ty_size(h_ty[i]) == 4 && !ty_is_fp(h_ty[i]) &&
                    h_val[i] == 0) {
                    /* lo-half access: stays on A */
                } else if (k == HI_ADDI && h_val[i] == 4) {
                    if (nhi >= 8) { ok = 0; }
                    else { hi_nodes[nhi] = i; nhi = nhi + 1; }
                } else {
                    ok = 0;
                }
            }
            if (ok && h_src2[i] == a_inst &&
                k != HI_BR && k != HI_BRC && k != HI_PHI)
                ok = 0;
            if (ok && (k == HI_CALL || k == HI_CALLP ||
                       k == HI_A64_DBT_TRAMPOLINE ||
                       k == HI_X64_DBT_TRAMPOLINE) && h_cbase[i] >= 0) {
                q = 0;
                while (q < h_val[i]) {
                    if (h_carg[h_cbase[i] + q] == a_inst) ok = 0;
                    q = q + 1;
                }
            }
            if (ok && k == HI_PHI && h_pbase[i] >= 0) {
                q = 0;
                while (q < h_pcnt[i]) {
                    if (h_pval[h_pbase[i] + q] == a_inst) ok = 0;
                    q = q + 1;
                }
            }
            i = i + 1;
        }

        /* The hi-address nodes must feed only word loads/stores. */
        q = 0;
        while (q < nhi && ok) {
            int hn;
            hn = hi_nodes[q];
            i = 0;
            while (i < h_ninst && ok) {
                k = h_kind[i];
                if (k == HI_NOP || i == hn) { i = i + 1; continue; }
                if (h_src1[i] == hn) {
                    if (!((k == HI_LOAD || k == HI_STORE) &&
                          ty_size(h_ty[i]) == 4 && !ty_is_fp(h_ty[i]) &&
                          h_val[i] == 0))
                        ok = 0;
                }
                if (ok && h_src2[i] == hn &&
                    k != HI_BR && k != HI_BRC && k != HI_PHI)
                    ok = 0;
                if (ok && (k == HI_CALL || k == HI_CALLP ||
                           k == HI_A64_DBT_TRAMPOLINE ||
                           k == HI_X64_DBT_TRAMPOLINE) && h_cbase[i] >= 0) {
                    int p;
                    p = 0;
                    while (p < h_val[i]) {
                        if (h_carg[h_cbase[i] + p] == hn) ok = 0;
                        p = p + 1;
                    }
                }
                if (ok && k == HI_PHI && h_pbase[i] >= 0) {
                    int p;
                    p = 0;
                    while (p < h_pcnt[i]) {
                        if (h_pval[h_pbase[i] + p] == hn) ok = 0;
                        p = p + 1;
                    }
                }
                i = i + 1;
            }
            q = q + 1;
        }

        if (!ok || hl_nalloca >= HL_MAX_ALLOCA || h_ninst >= HIR_MAX_INST) {
            j = j + 1;
            continue;
        }

        /* Mint the hi-half alloca (same 8-byte slot, upper word). */
        ah = h_ninst;
        h_kind[ah] = HI_ALLOCA;
        h_ty[ah] = TY_INT;
        h_src1[ah] = -1;
        h_src2[ah] = -1;
        h_val[ah] = hl_aoff[j] + 4;
        h_name[ah] = 0;
        h_blk[ah] = h_blk[a_inst];
        h_cbase[ah] = -1;
        h_pbase[ah] = -1;
        h_pcnt[ah] = 0;
        h_ld_ro[ah] = 0;
        h_no_remat[ah] = 0;
        h_ninst = h_ninst + 1;
        hl_aoff[hl_nalloca] = hl_aoff[j] + 4;
        hl_aslot[hl_nalloca] = hl_aslot[j];     /* the half of a named local is that local's (ssa_find_promo asks) */
        hl_ainst[hl_nalloca] = ah;
        hl_nalloca = hl_nalloca + 1;

        h_ty[a_inst] = TY_INT;

        q = 0;
        while (q < nhi) {
            int hn;
            hn = hi_nodes[q];
            i = 0;
            while (i < h_ninst) {
                if (h_kind[i] != HI_NOP && h_src1[i] == hn &&
                    (h_kind[i] == HI_LOAD || h_kind[i] == HI_STORE))
                    h_src1[i] = ah;
                i = i + 1;
            }
            h_kind[hn] = HI_NOP;
            h_src1[hn] = -1;
            h_src2[hn] = -1;
            q = q + 1;
        }

        j = j + 1;
    }
}

/* JMPTAB edges cannot carry phi copies (hir_codegen.h).  Lowering already
 * trampolines C switch fall-through (GitHub issue 64), but a goto into a
 * case -- Ragel `st15:` falling into `case 15:` in lex_next -- is another
 * predecessor that only shows up once the whole function is lowered.
 * Split those table targets: JMPTAB -> trampoline BR -> case, so the
 * case's extra edge is a normal BR and can shuffle.  GitHub issue 75. */
static int ssa_jmptab_split_multi(void) {
    int b;
    int term;
    int k;
    int base;
    int span;
    int t;
    int u;
    int tgt;
    int tramp;
    int saved;
    int changed;
    int seen;

    changed = 0;
    b = 0;
    while (b < bb_nblk) {
        if (bb_start[b] >= 0 && bb_start[b] < bb_end[b]) {
            term = bb_start[b];
            while (term < bb_end[b]) {
                k = h_kind[term];
                if (hi_is_terminator(k)) break;
                term = term + 1;
            }
            if (term < bb_end[b] && h_kind[term] == HI_JMPTAB) {
                base = hjt_base[term];
                span = hjt_span[term];
                t = 0;
                while (t < span) {
                    tgt = hjt_target[base + t];
                    seen = 0;
                    u = 0;
                    while (u < t) {
                        if (hjt_target[base + u] == tgt) { seen = 1; break; }
                        u = u + 1;
                    }
                    if (!seen && tgt >= 0 && tgt < bb_nblk && ssa_npred[tgt] > 1) {
                        tramp = hir_new_block();
                        saved = hl_cur_blk;
                        hl_cur_blk = tramp;
                        bb_start[tramp] = h_ninst;
                        bb_end[tramp] = h_ninst;
                        hi_emit(HI_BR, 0, -1, -1, tgt, NULL);
                        hl_cur_blk = saved;
                        u = t;
                        while (u < span) {
                            if (hjt_target[base + u] == tgt) {
                                hjt_target[base + u] = tramp;
                            }
                            u = u + 1;
                        }
                        changed = 1;
                    }
                    t = t + 1;
                }
            }
        }
        b = b + 1;
    }
    return changed;
}

static void hir_ssa_construct(void) {
    int b;

    if (bb_nblk < 1) {
        ssa_phi_base = h_ninst;
        return;
    }

    if (ssa_split_pairs) ssa_split_pair_allocas();

    ssa_build_cfg();
    if (ssa_jmptab_split_multi()) {
        ssa_build_cfg();
    }

    /* Always init phi linked lists (codegen uses them even with 0 promos).
     * After the JMPTAB split so trampoline blocks are included. */
    b = 0;
    while (b < bb_nblk) { ssa_phi_head[b] = -1; b = b + 1; }

    ssa_compute_rpo();
    ssa_compute_idom();
    ssa_compute_df();
    /* The dominator-tree children are built whether or not anything
     * gets promoted: the allocator's call-site splitting walks them
     * (ra_csplit_on_dom, GitHub issue 67) long after this pass.  They
     * used to be built only past the early return below, so a function
     * with nothing to promote read the previous function's table -- a
     * Fortran CHARACTER function with three RETURN arms (FCVS FM715,
     * CF716) had its result pointer "split" into a copy that two of the
     * arms read without ever having executed it, and f77_strcpy wrote
     * to address 0.  Found by the Fortran front at the 2026-10-11
     * re-sync; latent for C. */
    ssa_build_dtree();
    ssa_find_promo();

    if (ssa_npromo == 0) {
        ssa_phi_base = h_ninst;
        return;
    }

    /* Detach current block so hi_emit during phi insertion
       doesn't corrupt bb_end of the last lowered block */
    hl_cur_blk = -1;
    ssa_insert_phis();
    ssa_rename();
}
