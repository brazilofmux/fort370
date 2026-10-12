/* hir_regalloc_s370.h -- IRC graph-coloring register allocation, S/370.
 *
 * Derived from hir_regalloc.h (the SLOW-32 allocator, itself
 * George-Appel Iterated Register Coalescing).  What is kept: the
 * linearization, the per-block liveness, the interference graph, the
 * IRC worklists, loop-weighted spill costs, iterated respilling and
 * shared spill slots.  What is changed, per docs/BACKEND.md:
 *
 *   - Two register classes.  General: R2..R11, ten colours, all
 *     callee-saved (standard linkage saves and restores R14-R12 as a
 *     block).  Floating: FPR0/2/4/6, four colours, caller-saved: a
 *     floating value live across a call is forced to memory, since no
 *     callee preserves the floating-point registers.  Only same-class
 *     nodes interfere or coalesce; K is per class.
 *   - No register parameters, no argument registers, no pairs: every
 *     argument is an address in a parameter list, so none of the ABI
 *     colouring preferences apply, and a double is one value.
 *   - Spill slots are 8 bytes, doubleword aligned, shared by live
 *     range as before; ra_spill_off is -(8*(slot+1)).
 *   - Two-address shape: a result may share the register of a src1
 *     that dies at the instruction (AR 2,3 adds into its first
 *     operand), and src1 -> result moves are coalescing candidates,
 *     for the floating ops as well as the integer ones.
 *
 * Input:  HIR after SSA, optimization, LICM and BURS.
 * Output: ra_reg[]       physical register per inst (R2..R11, or FPR
 *                        0/2/4/6 for a floating value), -1 = memory/remat
 *         ra_spill_off[] -(8*(slot+1)), 0 = none; ra_nslots
 *         ra_crosses_call[]
 */

#define RA_NGPR 10            /* R2..R11 */
#define RA_NFPR 4             /* FPR 0, 2, 4, 6 */
#define RA_NCOLORS 10         /* max of the two, for used[] masks */

static int ra_gpr_avail = RA_NGPR;   /* the emitter withholds R11 (and R10) when it needs more data bases */

static int ra_gpr_phys(int c) { return 2 + c; }
static int ra_fpr_phys(int c) { return 2 * c; }

/* Is this instruction's VALUE a floating-point number?  An ALLOCA (or
 * any other address) carries its object's type but yields an address,
 * which lives in a general register. */
static int ra_is_fpv(int inst) {
    int k;
    if (inst < 0) return 0;
    if (!ty_is_fp(h_ty[inst])) return 0;
    k = h_kind[inst];
    if (k == HI_ALLOCA || k == HI_GADDR || k == HI_FADDR || k == HI_SADDR || k == HI_ADDI || k == HI_PARAM) return 0;
    return 1;
}

/* Class of a value: 0 general, 1 floating. */
static int ra_class(int inst) { return ra_is_fpv(inst); }

static int ra_class_k(int cls) { return cls ? RA_NFPR : ra_gpr_avail; }

static int ra_crosses_call[HIR_MAX_INST];
static int ra_mem_forced[HIR_MAX_INST];   /* iterated-spill victims, and floating values across calls */
static void ra_dump_signed(int v);

/* --- Output arrays --- */
static int ra_reg[HIR_MAX_INST];
static int ra_spill_off[HIR_MAX_INST];
static int ra_nslots;

/* --- Live interval arrays --- */
static int ra_pos[HIR_MAX_INST];
static int ra_iend[HIR_MAX_INST];
static int ra_order[HIR_MAX_INST];
static int ra_norder;

static int ra_stat_spills;
static int ra_stat_sslots;

/* A two-address destructive op: the result wants src1's register. */
static int ra_can_reuse_src1(int k) {
    return (k >= HI_ADD && k <= HI_SRL) || k == HI_ADDI || k == HI_MULH || k == HI_MULHU ||
           (k >= HI_FADD && k <= HI_FDIV) || k == HI_FNEG;
}

/* =================================================================
 * IRC data structures
 * ================================================================= */

#define GC_MAX_NODE 4096   /* fort370: one unit in an 8MB region, docs/FITTING.md */
#define GC_MAX_EDGE 262144   /* fort370: one unit in an 8MB region, docs/FITTING.md */
#define GC_MAX_MOVE 4096   /* fort370: one unit in an 8MB region, docs/FITTING.md */

static int gc_nnode;
static int gc_inst[GC_MAX_NODE];
static int gc_node[HIR_MAX_INST];
static char gc_cls[GC_MAX_NODE];

static int gc_adj_head[GC_MAX_NODE];
static int gc_adj_peer[GC_MAX_EDGE];
static int gc_adj_next[GC_MAX_EDGE];
static int gc_nedge;

static int gc_degree[GC_MAX_NODE];

static int gc_mv_a[GC_MAX_MOVE];
static int gc_mv_b[GC_MAX_MOVE];
static int gc_nmove;

#define GC_MV_WORKLIST    0
#define GC_MV_ACTIVE      1
#define GC_MV_COALESCED   2
#define GC_MV_FROZEN      3
#define GC_MV_CONSTRAINED 4
static int gc_mv_status[GC_MAX_MOVE];

#define GC_MAX_NMLIST 16384   /* fort370: one unit in an 8MB region, docs/FITTING.md */
static int gc_nmlist_mv[GC_MAX_NMLIST];
static int gc_nmlist_next[GC_MAX_NMLIST];
static int gc_nmlist_head[GC_MAX_NODE];
static int gc_nnmlist;

#define GC_WL_SIMPLIFY  0
#define GC_WL_FREEZE    1
#define GC_WL_SPILL     2
#define GC_WL_COALESCED 3
#define GC_WL_SELECT    4
#define GC_WL_COLORED   5
static int gc_wl[GC_MAX_NODE];

static int gc_sel_stk[GC_MAX_NODE];
static int gc_nsel;

static int gc_alias[GC_MAX_NODE];
static int gc_color[GC_MAX_NODE];
static int gc_force_spill[GC_MAX_NODE];

/* =================================================================
 * Step 1: linearized positions (RPO block order)
 * ================================================================= */

static void ra_compute_pos(void) {
    int ri;
    int b;
    int i;
    int pos;
    int phi;
    int term;
    int tk;

    i = 0;
    while (i < h_ninst) { ra_pos[i] = -1; i = i + 1; }
    pos = 0;
    ra_norder = 0;

    ri = 0;
    while (ri < ssa_rpo_cnt) {
        b = ssa_rpo_ord[ri];

        phi = ssa_phi_head[b];
        while (phi >= 0) {
            if (h_kind[phi] == HI_PHI) {
                ra_pos[phi] = pos;
                ra_order[ra_norder] = phi;
                ra_norder = ra_norder + 1;
                pos = pos + 1;
            }
            phi = ssa_phi_next[phi];
        }

        term = -1;
        i = bb_end[b] - 1;
        while (i >= bb_start[b]) {
            tk = h_kind[i];
            if (hi_is_terminator(tk)) { term = i; break; }
            if (tk != HI_NOP) break;
            i = i - 1;
        }

        /* Split-pass reloads run at the top of the block. */
        i = split_head[b];
        while (i >= 0) {
            if (h_kind[i] != HI_NOP) {
                ra_pos[i] = pos;
                ra_order[ra_norder] = i;
                ra_norder = ra_norder + 1;
                pos = pos + 1;
            }
            i = licm_next[i];
        }

        i = bb_start[b];
        while (i < bb_end[b]) {
            if (i == term) break;
            if (h_kind[i] != HI_NOP) {
                ra_pos[i] = pos;
                ra_order[ra_norder] = i;
                ra_norder = ra_norder + 1;
                pos = pos + 1;
            }
            i = i + 1;
        }

        /* LICM-hoisted instructions: after the body, before the terminator */
        i = licm_head[b];
        while (i >= 0) {
            if (h_kind[i] != HI_NOP) {
                ra_pos[i] = pos;
                ra_order[ra_norder] = i;
                ra_norder = ra_norder + 1;
                pos = pos + 1;
            }
            i = licm_next[i];
        }

        if (term >= 0 && h_kind[term] != HI_NOP) {
            ra_pos[term] = pos;
            ra_order[ra_norder] = term;
            ra_norder = ra_norder + 1;
            pos = pos + 1;
        }
        ri = ri + 1;
    }
}

/* =================================================================
 * Step 2: live interval endpoints
 * ================================================================= */

static void ra_extend(int inst, int use_pos) {
    if (inst >= 0 && ra_pos[inst] >= 0 && use_pos > ra_iend[inst]) ra_iend[inst] = use_pos;
}

static int ra_blk_last[HIR_MAX_BLOCK];
static int ra_bvis[HIR_MAX_BLOCK];
static int ra_bwl[HIR_MAX_BLOCK];

static void ra_backprop(int val, int use_blk) {
    int def_blk;
    int wh;
    int wt;
    int b;
    int j;
    int p;

    def_blk = h_blk[val];
    if (def_blk < 0 || use_blk < 0) return;
    if (def_blk == use_blk) return;
    b = 0;
    while (b < bb_nblk) { ra_bvis[b] = 0; b = b + 1; }
    ra_bvis[use_blk] = 1;
    ra_bwl[0] = use_blk;
    wh = 0;
    wt = 1;
    while (wh < wt) {
        b = ra_bwl[wh];
        wh = wh + 1;
        j = 0;
        while (j < ssa_npred[b]) {
            p = ssa_pred[ssa_pbase[b] + j];
            if (p >= 0 && p < bb_nblk) {
                ra_extend(val, ra_blk_last[p]);
                if (!ra_bvis[p]) {
                    ra_bvis[p] = 1;
                    if (p != def_blk && wt < HIR_MAX_BLOCK) {
                        ra_bwl[wt] = p;
                        wt = wt + 1;
                    }
                }
            }
            j = j + 1;
        }
    }
}

/* The emitter folds an ADDI chain into a displacement when the whole
 * offset is 0..4095 and the base is a register: a LOAD or STORE
 * through ADDI(ADDI(p, 8), 16) reads p's register, not the ADDI's.
 * The same answer here keeps p live until that use.  Only the chain
 * root is reported; the emitter must fold exactly these chains. */
static int ra_is_disp(int v) { return v >= 0 && v <= 4095; }

static int ra_codegen_fold_base(int inst, int *base_out) {
    int k;
    int s1;
    int pat;
    int lnt;
    int chain;
    int ck;
    int chlim;
    int off;

    k = h_kind[inst];
    s1 = h_src1[inst];
    pat = bg_sel[inst];
    lnt = -1;
    if (pat >= 0) lnt = bg_plnt[pat];
    else if (s1 >= 0 && h_kind[s1] == HI_ALLOCA) lnt = BG_FADDR;

    if (k == HI_LOAD || k == HI_STORE) {
        if (lnt == BG_FADDR || lnt == BG_SADDR) return 0;
        chain = s1;
        off = 0;
        chlim = 0;
        while (chain >= 0 && chlim < 64) {
            ck = h_kind[chain];
            if (ck == HI_COPY) { chain = h_src1[chain]; chlim = chlim + 1; continue; }
            if (ck == HI_ADDI) { off = off + h_val[chain]; chain = h_src1[chain]; chlim = chlim + 1; continue; }
            break;
        }
        if (chain >= 0 && chain != s1 && ra_is_disp(off)) { *base_out = chain; return 1; }
        return 0;
    }
    if (k == HI_ADDI) {
        if (lnt == BG_FADDR) return 0;
        chain = s1;
        off = 0;
        chlim = 0;
        while (chain >= 0 && h_kind[chain] == HI_ADDI && chlim < 64) {
            off = off + h_val[chain];
            chain = h_src1[chain];
            chlim = chlim + 1;
        }
        if (chain >= 0 && chain != s1 && ra_is_disp(off + h_val[inst])) { *base_out = chain; return 1; }
    }
    return 0;
}

static void ra_compute_ends(void) {
    int i;
    int j;
    int inst;
    int k;
    int p;
    int a;
    int pred;
    int term;
    int src;
    int b;

    i = 0;
    while (i < h_ninst) { ra_iend[i] = ra_pos[i]; i = i + 1; }
    b = 0;
    while (b < bb_nblk) { ra_blk_last[b] = -1; b = b + 1; }
    i = 0;
    while (i < ra_norder) {
        inst = ra_order[i];
        b = h_blk[inst];
        if (b >= 0 && b < bb_nblk) ra_blk_last[b] = ra_pos[inst];
        i = i + 1;
    }

    i = 0;
    while (i < ra_norder) {
        inst = ra_order[i];
        k = h_kind[inst];
        p = ra_pos[inst];
        ra_extend(h_src1[inst], p);
        if (h_src2[inst] >= 0 && ho_src2_is_ref(k)) ra_extend(h_src2[inst], p);
        if (ra_codegen_fold_base(inst, &src)) ra_extend(src, p);
        if ((k == HI_CALL || k == HI_CALLP) && h_cbase[inst] >= 0) {
            j = 0;
            while (j < h_val[inst]) { ra_extend(h_carg[h_cbase[inst] + j], p); j = j + 1; }
        }
        if (k == HI_PHI && h_pbase[inst] >= 0) {
            j = 0;
            while (j < h_pcnt[inst]) {
                a = h_pval[h_pbase[inst] + j];
                pred = h_pblk[h_pbase[inst] + j];
                if (a >= 0 && ra_pos[a] >= 0 && pred >= 0 && pred < bb_nblk) {
                    term = bb_end[pred] - 1;
                    while (term >= bb_start[pred] && h_kind[term] == HI_NOP) term = term - 1;
                    if (term >= bb_start[pred] && ra_pos[term] >= 0) ra_extend(a, ra_pos[term]);
                }
                j = j + 1;
            }
        }
        i = i + 1;
    }

    i = 0;
    while (i < ra_norder) {
        inst = ra_order[i];
        k = h_kind[inst];
        src = h_src1[inst];
        if (src >= 0 && ra_pos[src] >= 0 && h_blk[src] != h_blk[inst]) ra_backprop(src, h_blk[inst]);
        if (h_src2[inst] >= 0 && ho_src2_is_ref(k)) {
            src = h_src2[inst];
            if (ra_pos[src] >= 0 && h_blk[src] != h_blk[inst]) ra_backprop(src, h_blk[inst]);
        }
        if (ra_codegen_fold_base(inst, &src) && ra_pos[src] >= 0 && h_blk[src] != h_blk[inst])
            ra_backprop(src, h_blk[inst]);
        if ((k == HI_CALL || k == HI_CALLP) && h_cbase[inst] >= 0) {
            j = 0;
            while (j < h_val[inst]) {
                src = h_carg[h_cbase[inst] + j];
                if (src >= 0 && ra_pos[src] >= 0 && h_blk[src] != h_blk[inst]) ra_backprop(src, h_blk[inst]);
                j = j + 1;
            }
        }
        if (k == HI_PHI && h_pbase[inst] >= 0) {
            j = 0;
            while (j < h_pcnt[inst]) {
                a = h_pval[h_pbase[inst] + j];
                pred = h_pblk[h_pbase[inst] + j];
                if (a >= 0 && ra_pos[a] >= 0 && pred >= 0 && pred < bb_nblk && h_blk[a] != pred)
                    ra_backprop(a, pred);
                j = j + 1;
            }
        }
        i = i + 1;
    }
}

/* =================================================================
 * Step 3: spill slots, 8 bytes each, shared by live range
 * ================================================================= */

static int ra_shead[HIR_MAX_INST];
static int ra_snext[HIR_MAX_INST];
static int ra_slot_end[HIR_MAX_INST];

static int ra_spill_wants_slot(int i) {
    if (ra_reg[i] >= 0) return 0;
    if (h_kind[i] == HI_NOP) return 0;
    if (!hi_has_value(h_kind[i])) return 0;
    if (hi_inst_remat(i)) return 0;
    return 1;
}

static void ra_slot_range(int v, int *ps, int *pe) {
    int s;
    int e;
    int j;
    int pred;
    int term;
    s = ra_pos[v];
    e = ra_iend[v];
    if (e < s) e = s;
    if (h_kind[v] == HI_PHI && h_pbase[v] >= 0) {
        j = 0;
        while (j < h_pcnt[v]) {
            pred = h_pblk[h_pbase[v] + j];
            if (pred >= 0 && pred < bb_nblk) {
                term = bb_end[pred] - 1;
                while (term >= bb_start[pred] && h_kind[term] == HI_NOP) term = term - 1;
                if (term >= bb_start[pred] && ra_pos[term] >= 0) {
                    if (ra_pos[term] < s) s = ra_pos[term];
                    if (ra_pos[term] > e) e = ra_pos[term];
                }
            }
            j = j + 1;
        }
    }
    *ps = s;
    *pe = e;
}

static void ra_assign_spills(void) {
    int i;
    int v;
    int s;
    int e;
    int p;
    int k;
    int nslot;
    int npos;

    i = 0;
    while (i < h_ninst) { ra_spill_off[i] = 0; i = i + 1; }
    npos = ra_norder;
    p = 0;
    while (p < npos) { ra_shead[p] = -1; p = p + 1; }
    i = h_ninst - 1;
    while (i >= 0) {
        if (ra_spill_wants_slot(i) && ra_pos[i] >= 0 && ra_pos[i] < npos) {
            ra_slot_range(i, &s, &e);
            if (s < 0) s = 0;
            if (s >= npos) s = npos - 1;
            ra_snext[i] = ra_shead[s];
            ra_shead[s] = i;
        }
        i = i - 1;
    }
    nslot = 0;
    p = 0;
    while (p < npos) {
        v = ra_shead[p];
        while (v >= 0) {
            ra_slot_range(v, &s, &e);
            k = 0;
            while (k < nslot && ra_slot_end[k] >= p) k = k + 1;
            if (ssa_fn_setjmp) k = nslot;
            if (k == nslot) nslot = nslot + 1;
            ra_slot_end[k] = e;
            ra_spill_off[v] = 0 - 8 * (k + 1);
            ra_stat_spills = ra_stat_spills + 1;
            v = ra_snext[v];
        }
        p = p + 1;
    }
    /* Values the linearization never reached: private slots. */
    i = 0;
    while (i < h_ninst) {
        if (ra_spill_wants_slot(i) && !(ra_pos[i] >= 0 && ra_pos[i] < npos)) {
            nslot = nslot + 1;
            ra_spill_off[i] = 0 - 8 * nslot;
            ra_stat_spills = ra_stat_spills + 1;
        }
        i = i + 1;
    }
    ra_nslots = nslot;
    ra_stat_sslots = ra_stat_sslots + nslot;
    hl_temp_stack = hl_temp_stack + 8 * nslot;
}

/* =================================================================
 * Step 4: fused compare-and-branch: the compare is NOPed and the
 * branch re-emits it, so its operands live to the branch.
 * ================================================================= */

static void ra_extend_fused_cmp(void) {
    int i;
    int cmp;
    int brc_pos;
    int c;
    int lim;
    i = 0;
    while (i < h_ninst) {
        if (h_kind[i] != HI_BRC) { i = i + 1; continue; }
        cmp = hcg_brc_fuse[i];
        if (cmp < 0) { i = i + 1; continue; }
        brc_pos = ra_pos[i];
        if (brc_pos < 0) { hcg_brc_fuse[i] = -1; i = i + 1; continue; }
        ra_extend(h_src1[cmp], brc_pos);
        ra_extend(h_src2[cmp], brc_pos);
        h_kind[cmp] = HI_NOP;
        c = h_src1[i];
        lim = 0;
        while (c >= 0 && c != cmp && lim < 64) {
            if (hcg_cmp_fused[c]) h_kind[c] = HI_NOP;
            c = h_src1[c];
            lim = lim + 1;
        }
        i = i + 1;
    }
}

/* =================================================================
 * IRC small helpers
 * ================================================================= */

static int gc_has_edge(int u, int v) {
    int e;
    e = gc_adj_head[u];
    while (e >= 0) {
        if (gc_adj_peer[e] == v) return 1;
        e = gc_adj_next[e];
    }
    return 0;
}

/* Only same-class nodes interfere: a general register and a floating
 * register never compete. */
static void gc_add_edge(int u, int v) {
    int e1, e2;
    if (u == v) return;
    if (gc_cls[u] != gc_cls[v]) return;
    if (gc_has_edge(u, v)) return;
    if (gc_nedge + 2 > GC_MAX_EDGE) {
        if (u >= 0 && u < GC_MAX_NODE) gc_force_spill[u] = 1;
        if (v >= 0 && v < GC_MAX_NODE) gc_force_spill[v] = 1;
        return;
    }
    e1 = gc_nedge;
    gc_adj_peer[e1] = v;
    gc_adj_next[e1] = gc_adj_head[u];
    gc_adj_head[u] = e1;
    gc_nedge = gc_nedge + 1;
    e2 = gc_nedge;
    gc_adj_peer[e2] = u;
    gc_adj_next[e2] = gc_adj_head[v];
    gc_adj_head[v] = e2;
    gc_nedge = gc_nedge + 1;
    gc_degree[u] = gc_degree[u] + 1;
    gc_degree[v] = gc_degree[v] + 1;
}

static void gc_add_node_move(int node, int mv) {
    int idx;
    if (gc_nnmlist >= GC_MAX_NMLIST) return;
    idx = gc_nnmlist;
    gc_nnmlist = gc_nnmlist + 1;
    gc_nmlist_mv[idx] = mv;
    gc_nmlist_next[idx] = gc_nmlist_head[node];
    gc_nmlist_head[node] = idx;
}

static int gc_move_related(int n) {
    int e, mv, st;
    e = gc_nmlist_head[n];
    while (e >= 0) {
        mv = gc_nmlist_mv[e];
        st = gc_mv_status[mv];
        if (st == GC_MV_WORKLIST || st == GC_MV_ACTIVE) return 1;
        e = gc_nmlist_next[e];
    }
    return 0;
}

static int gc_get_alias(int n) {
    int lim;
    lim = 0;
    while (gc_alias[n] != n && lim < GC_MAX_NODE) { n = gc_alias[n]; lim = lim + 1; }
    return n;
}

static int gc_k(int n) { return ra_class_k(gc_cls[n]); }

static void gc_dec_degree(int n) {
    int k;
    gc_degree[n] = gc_degree[n] - 1;
    k = gc_k(n);
    if (gc_degree[n] == k - 1) {
        if (gc_move_related(n)) gc_wl[n] = GC_WL_FREEZE;
        else gc_wl[n] = GC_WL_SIMPLIFY;
    }
}

static char gc_mv_phi[GC_MAX_MOVE];

static void gc_add_move_tag(int a, int b, int is_phi) {
    int mv;
    if (gc_cls[a] != gc_cls[b]) return;
    if (gc_nmove >= GC_MAX_MOVE) return;
    mv = gc_nmove;
    gc_mv_a[mv] = a;
    gc_mv_b[mv] = b;
    gc_mv_status[mv] = GC_MV_WORKLIST;
    gc_mv_phi[mv] = (char)is_phi;
    gc_nmove = gc_nmove + 1;
    gc_add_node_move(a, mv);
    gc_add_node_move(b, mv);
}

static void gc_add_move(int a, int b) { gc_add_move_tag(a, b, 0); }

/* =================================================================
 * Per-block liveness (see hir_regalloc.h for the rationale)
 * ================================================================= */

static unsigned int *lv_in;
static unsigned int *lv_out;
static unsigned int *lv_live;
static int lv_w;
#define LV_BUDGET_WORDS 65536   /* fort370: one unit in an 8MB region, docs/FITTING.md */
static unsigned int lv_pool_in[LV_BUDGET_WORDS];
static unsigned int lv_pool_out[LV_BUDGET_WORDS];
static int lv_cap;
static int lv_live_cap;
static int lv_id[HIR_MAX_INST];
static int lv_rev[HIR_MAX_INST];
static int lv_nid;
static int lv_nw;
static int lv_bstart[HIR_MAX_BLOCK];
static int lv_bend[HIR_MAX_BLOCK];
static int lv_on;

static int lv_tracked(int inst) {
    if (inst < 0) return 0;
    if (lv_id[inst] < 0) return 0;
    return 1;
}

static int lv_ubuf[128];
static int lv_uses(int inst) {
    int nu;
    int k;
    int j;
    int a;
    int cmp;
    nu = 0;
    k = h_kind[inst];
    if (h_src1[inst] >= 0) { lv_ubuf[nu] = h_src1[inst]; nu = nu + 1; }
    if (h_src2[inst] >= 0 && ho_src2_is_ref(k)) { lv_ubuf[nu] = h_src2[inst]; nu = nu + 1; }
    if (ra_codegen_fold_base(inst, &a)) { lv_ubuf[nu] = a; nu = nu + 1; }
    if ((k == HI_CALL || k == HI_CALLP) && h_cbase[inst] >= 0) {
        j = 0;
        while (j < h_val[inst] && nu < 120) {
            a = h_carg[h_cbase[inst] + j];
            if (a >= 0) { lv_ubuf[nu] = a; nu = nu + 1; }
            j = j + 1;
        }
    }
    if (k == HI_BRC && hcg_brc_fuse[inst] >= 0) {
        cmp = hcg_brc_fuse[inst];
        if (h_kind[cmp] == HI_NOP) {
            if (h_src1[cmp] >= 0) { lv_ubuf[nu] = h_src1[cmp]; nu = nu + 1; }
            if (h_src2[cmp] >= 0) { lv_ubuf[nu] = h_src2[cmp]; nu = nu + 1; }
        }
    }
    return nu;
}

static int lv_is_callkind(int k) { return k == HI_CALL || k == HI_CALLP || k == HI_CALLHI; }

static void lv_transfer(int b) {
    int oi;
    int inst;
    int nu;
    int j;
    int u;
    oi = lv_bend[b];
    while (oi > lv_bstart[b]) {
        oi = oi - 1;
        inst = ra_order[oi];
        if (lv_tracked(inst))
            lv_live[lv_id[inst] >> 5] = lv_live[lv_id[inst] >> 5] & ~(1u << (lv_id[inst] & 31));
        nu = lv_uses(inst);
        j = 0;
        while (j < nu) {
            u = lv_ubuf[j];
            if (lv_tracked(u)) lv_live[lv_id[u] >> 5] = lv_live[lv_id[u] >> 5] | (1u << (lv_id[u] & 31));
            j = j + 1;
        }
    }
}

static void lv_out_of(int b) {
    int w;
    int si;
    int s;
    int phi;
    int j;
    int a;
    w = 0;
    while (w < lv_nw) { lv_live[w] = 0; w = w + 1; }
    si = 0;
    while (si < ssa_nsucc[b]) {
        s = ssa_succ[ssa_soff[b] + si];
        if (s >= 0 && s < bb_nblk) {
            w = 0;
            while (w < lv_nw) { lv_live[w] = lv_live[w] | lv_in[(s * lv_w) + w]; w = w + 1; }
            phi = ssa_phi_head[s];
            while (phi >= 0) {
                if (h_kind[phi] == HI_PHI && h_pbase[phi] >= 0) {
                    j = 0;
                    while (j < h_pcnt[phi]) {
                        if (h_pblk[h_pbase[phi] + j] == b) {
                            a = h_pval[h_pbase[phi] + j];
                            if (lv_tracked(a))
                                lv_live[lv_id[a] >> 5] = lv_live[lv_id[a] >> 5] | (1u << (lv_id[a] & 31));
                        }
                        j = j + 1;
                    }
                }
                phi = ssa_phi_next[phi];
            }
        }
        si = si + 1;
    }
}

static void lv_prepare(void) {
    int i;
    int b;
    int inst;
    int k;
    int w;
    int ri;
    int changed;
    int sweeps;

    lv_on = 0;
    if (getenv("HIR_LINEAR_LIVE")) return;
    i = 0;
    while (i < h_ninst) { lv_id[i] = -1; i = i + 1; }
    lv_nid = 0;
    i = 0;
    while (i < ra_norder) {
        inst = ra_order[i];
        k = h_kind[inst];
        if (hi_has_value(k) && !hi_inst_remat(inst) && k != HI_NOP) {
            lv_id[inst] = lv_nid;
            lv_rev[lv_nid] = inst;
            lv_nid = lv_nid + 1;
        }
        i = i + 1;
    }
    if (lv_nid > GC_MAX_NODE) return;
    lv_nw = (lv_nid + 31) / 32;
    if (lv_nw == 0) lv_nw = 1;
    lv_w = lv_nw;
    if (bb_nblk * lv_w > LV_BUDGET_WORDS) return;
    lv_in = lv_pool_in;
    lv_out = lv_pool_out;
    lv_cap = LV_BUDGET_WORDS;
    if (lv_w > lv_live_cap) {
        if (lv_live) free(lv_live);
        lv_live_cap = lv_w + 256;
        lv_live = malloc(lv_live_cap * 4);
        if (!lv_live) { fdputs("f77: out of memory for liveness sets\n", 2); exit(1); }
    }
    b = 0;
    while (b < bb_nblk) {
        lv_bstart[b] = 0;
        lv_bend[b] = 0;
        w = 0;
        while (w < lv_nw) { lv_in[(b * lv_w) + w] = 0; lv_out[(b * lv_w) + w] = 0; w = w + 1; }
        b = b + 1;
    }
    i = 0;
    while (i < ra_norder) {
        b = h_blk[ra_order[i]];
        if (b >= 0 && b < bb_nblk) {
            if (lv_bend[b] == 0) lv_bstart[b] = i;
            lv_bend[b] = i + 1;
        }
        i = i + 1;
    }
    changed = 1;
    sweeps = 0;
    while (changed && sweeps < 64) {
        changed = 0;
        ri = ssa_rpo_cnt;
        while (ri > 0) {
            ri = ri - 1;
            b = ssa_rpo_ord[ri];
            if (b < 0 || b >= bb_nblk) continue;
            lv_out_of(b);
            w = 0;
            while (w < lv_nw) { lv_out[(b * lv_w) + w] = lv_live[w]; w = w + 1; }
            lv_transfer(b);
            w = 0;
            while (w < lv_nw) {
                if (lv_in[(b * lv_w) + w] != lv_live[w]) { lv_in[(b * lv_w) + w] = lv_live[w]; changed = 1; }
                w = w + 1;
            }
        }
        sweeps = sweeps + 1;
    }
    if (changed) return;
    lv_on = 1;
}

/* May the result share a register with a src1 that dies here?  Yes
 * for the two-address shapes the emitter writes as "LR d,s1 / OP d,s2"
 * or "OP d,s2" when d is s1: the first operand is read before the
 * result is written, and src2 keeps its edge so d is never src2. */
static int ra_dying_src1_ok(int k) {
    return (k >= HI_ADD && k <= HI_SRL) || k == HI_MULH || k == HI_MULHU ||
           k == HI_ADDI || k == HI_COPY ||
           (k >= HI_FADD && k <= HI_FDIV) || k == HI_FNEG;
}

static void lv_build_edges(void) {
    int b;
    int oi;
    int inst;
    int k;
    int ni;
    int w;
    int bit;
    int id;
    int nu;
    int j;
    int u;
    int dying_ok;
    int p1;
    int p2;

    b = 0;
    while (b < bb_nblk) {
        w = 0;
        while (w < lv_nw) { lv_live[w] = lv_out[(b * lv_w) + w]; w = w + 1; }
        oi = lv_bend[b];
        while (oi > lv_bstart[b]) {
            oi = oi - 1;
            inst = ra_order[oi];
            k = h_kind[inst];
            ni = -1;
            if (lv_tracked(inst)) ni = gc_node[inst];
            if (lv_tracked(inst)) {
                id = lv_id[inst];
                lv_live[id >> 5] = lv_live[id >> 5] & ~(1u << (id & 31));
            }
            if (ni >= 0) {
                w = 0;
                while (w < lv_nw) {
                    unsigned int bits;
                    bits = lv_live[w];
                    bit = 0;
                    while (bits != 0 && bit < 32) {
                        if (bits & (1u << bit)) {
                            bits = bits & ~(1u << bit);
                            if (gc_node[lv_rev[(w << 5) + bit]] >= 0)
                                gc_add_edge(ni, gc_node[lv_rev[(w << 5) + bit]]);
                        }
                        bit = bit + 1;
                    }
                    w = w + 1;
                }
                nu = lv_uses(inst);
                j = 0;
                while (j < nu) {
                    u = lv_ubuf[j];
                    if (lv_tracked(u) && !(lv_live[lv_id[u] >> 5] & (1u << (lv_id[u] & 31)))) {
                        dying_ok = 0;
                        if (u == h_src1[inst] && ra_dying_src1_ok(k)) dying_ok = 1;
                        if (!dying_ok && gc_node[u] >= 0) gc_add_edge(ni, gc_node[u]);
                    }
                    j = j + 1;
                }
            }
            if (lv_is_callkind(k)) {
                w = 0;
                while (w < lv_nw) {
                    unsigned int bits;
                    bits = lv_live[w];
                    bit = 0;
                    while (bits != 0 && bit < 32) {
                        if (bits & (1u << bit)) {
                            bits = bits & ~(1u << bit);
                            ra_crosses_call[lv_rev[(w << 5) + bit]] = 1;
                        }
                        bit = bit + 1;
                    }
                    w = w + 1;
                }
            }
            nu = lv_uses(inst);
            j = 0;
            while (j < nu) {
                u = lv_ubuf[j];
                if (lv_tracked(u)) lv_live[lv_id[u] >> 5] = lv_live[lv_id[u] >> 5] | (1u << (lv_id[u] & 31));
                j = j + 1;
            }
        }
        p1 = ssa_phi_head[b];
        while (p1 >= 0) {
            if (h_kind[p1] == HI_PHI && gc_node[p1] >= 0) {
                p2 = ssa_phi_next[p1];
                while (p2 >= 0) {
                    if (h_kind[p2] == HI_PHI && gc_node[p2] >= 0) gc_add_edge(gc_node[p1], gc_node[p2]);
                    p2 = ssa_phi_next[p2];
                }
            }
            p1 = ssa_phi_next[p1];
        }
        b = b + 1;
    }
}

static void gc_build(void) {
    int i, j, inst, k, n, ni, aj, nact, p;
    int act[GC_MAX_NODE];

    gc_nnode = 0;
    gc_nedge = 0;
    gc_nmove = 0;
    gc_nnmlist = 0;
    gc_nsel = 0;
    i = 0;
    while (i < h_ninst) { gc_node[i] = -1; i = i + 1; }
    i = 0;
    while (i < GC_MAX_NODE) { gc_force_spill[i] = 0; i = i + 1; }

    i = 0;
    while (i < ra_norder) {
        inst = ra_order[i];
        k = h_kind[inst];
        if (hi_has_value(k) && !hi_inst_remat(inst) && k != HI_NOP && !ra_mem_forced[inst]) {
            if (gc_nnode < GC_MAX_NODE) {
                n = gc_nnode;
                gc_inst[n] = inst;
                gc_node[inst] = n;
                gc_cls[n] = (char)ra_class(inst);
                gc_adj_head[n] = -1;
                gc_degree[n] = 0;
                gc_alias[n] = n;
                gc_color[n] = -1;
                gc_nmlist_head[n] = -1;
                gc_nnode = gc_nnode + 1;
            }
        }
        i = i + 1;
    }

    if (lv_on) {
        i = 0;
        while (i < h_ninst) { ra_crosses_call[i] = 0; i = i + 1; }
        lv_build_edges();
        /* A floating value found live across a call by the exact
         * liveness, that the interval pass had not caught: it cannot
         * be coloured (no callee keeps the FPRs), and respill below
         * would pick a victim around it; force it to memory itself. */
        n = 0;
        while (n < gc_nnode) {
            if (gc_cls[n] && ra_crosses_call[gc_inst[n]]) gc_force_spill[n] = 1;
            n = n + 1;
        }
        return;
    }

    /* Interval fallback */
    nact = 0;
    i = 0;
    while (i < ra_norder) {
        inst = ra_order[i];
        p = ra_pos[inst];
        ni = gc_node[inst];
        j = 0;
        while (j < nact) {
            aj = act[j];
            if (ra_iend[gc_inst[aj]] < p) { nact = nact - 1; act[j] = act[nact]; }
            else j = j + 1;
        }
        if (ni >= 0) {
            int skip_node;
            skip_node = -1;
            if (ra_dying_src1_ok(h_kind[inst])) {
                int two_s1;
                two_s1 = h_src1[inst];
                if (two_s1 >= 0 && ra_iend[two_s1] <= p) skip_node = gc_node[two_s1];
            }
            j = 0;
            while (j < nact) {
                if (act[j] != skip_node) gc_add_edge(ni, act[j]);
                j = j + 1;
            }
            act[nact] = ni;
            nact = nact + 1;
        }
        i = i + 1;
    }
    n = 0;
    while (n < gc_nnode) {
        if (gc_cls[n] && ra_crosses_call[gc_inst[n]]) gc_force_spill[n] = 1;
        n = n + 1;
    }
}

static void gc_find_moves(void) {
    int i, inst, k, s1, nd, ns1, j, a, na;
    i = 0;
    while (i < ra_norder) {
        inst = ra_order[i];
        k = h_kind[inst];
        nd = gc_node[inst];
        if (nd < 0) { i = i + 1; continue; }
        if (k == HI_COPY || ra_can_reuse_src1(k)) {
            s1 = h_src1[inst];
            if (s1 >= 0) {
                ns1 = gc_node[s1];
                if (ns1 >= 0) gc_add_move(nd, ns1);
            }
        }
        if (k == HI_PHI && h_pbase[inst] >= 0) {
            j = 0;
            while (j < h_pcnt[inst]) {
                a = h_pval[h_pbase[inst] + j];
                if (a >= 0) {
                    na = gc_node[a];
                    if (na >= 0) gc_add_move_tag(nd, na, 1);
                }
                j = j + 1;
            }
        }
        i = i + 1;
    }
}

static void gc_make_worklists(void) {
    int n, k;
    n = 0;
    while (n < gc_nnode) {
        k = gc_k(n);
        if (gc_degree[n] >= k) gc_wl[n] = GC_WL_SPILL;
        else if (gc_move_related(n)) gc_wl[n] = GC_WL_FREEZE;
        else gc_wl[n] = GC_WL_SIMPLIFY;
        n = n + 1;
    }
}

static int gc_simplify(void) {
    int n, e, peer;
    n = 0;
    while (n < gc_nnode) {
        if (gc_wl[n] == GC_WL_SIMPLIFY) {
            gc_wl[n] = GC_WL_SELECT;
            gc_sel_stk[gc_nsel] = n;
            gc_nsel = gc_nsel + 1;
            e = gc_adj_head[n];
            while (e >= 0) {
                peer = gc_adj_peer[e];
                if (gc_wl[peer] != GC_WL_SELECT && gc_wl[peer] != GC_WL_COALESCED) gc_dec_degree(peer);
                e = gc_adj_next[e];
            }
            return 1;
        }
        n = n + 1;
    }
    return 0;
}

static int gc_george(int u, int v) {
    int e, t, kk;
    e = gc_adj_head[v];
    while (e >= 0) {
        t = gc_adj_peer[e];
        if (gc_wl[t] != GC_WL_SELECT && gc_wl[t] != GC_WL_COALESCED) {
            kk = gc_k(t);
            if (gc_degree[t] >= kk && !gc_has_edge(t, u)) return 0;
        }
        e = gc_adj_next[e];
    }
    return 1;
}

static int gc_briggs(int u, int v) {
    int count, kk, e, t;
    count = 0;
    kk = gc_k(u);
    e = gc_adj_head[u];
    while (e >= 0) {
        t = gc_adj_peer[e];
        if (gc_wl[t] != GC_WL_SELECT && gc_wl[t] != GC_WL_COALESCED && t != v) {
            if (gc_degree[t] >= kk) count = count + 1;
        }
        e = gc_adj_next[e];
    }
    e = gc_adj_head[v];
    while (e >= 0) {
        t = gc_adj_peer[e];
        if (gc_wl[t] != GC_WL_SELECT && gc_wl[t] != GC_WL_COALESCED && t != u) {
            if (gc_degree[t] >= kk && !gc_has_edge(t, u)) count = count + 1;
        }
        e = gc_adj_next[e];
    }
    return count < kk;
}

static void gc_combine(int u, int v) {
    int e, t;
    gc_wl[v] = GC_WL_COALESCED;
    gc_alias[v] = u;
    e = gc_nmlist_head[v];
    while (e >= 0) { gc_add_node_move(u, gc_nmlist_mv[e]); e = gc_nmlist_next[e]; }
    e = gc_adj_head[v];
    while (e >= 0) {
        t = gc_adj_peer[e];
        if (gc_wl[t] != GC_WL_COALESCED) {
            gc_add_edge(t, u);
            if (gc_wl[t] != GC_WL_SELECT) gc_dec_degree(t);
        }
        e = gc_adj_next[e];
    }
    if (gc_degree[u] >= gc_k(u) && gc_wl[u] == GC_WL_FREEZE) gc_wl[u] = GC_WL_SPILL;
}

static int gc_coalesce(void) {
    int mv, u, v;
    mv = 0;
    while (mv < gc_nmove) {
        if (gc_mv_status[mv] != GC_MV_WORKLIST) { mv = mv + 1; continue; }
        u = gc_get_alias(gc_mv_a[mv]);
        v = gc_get_alias(gc_mv_b[mv]);
        if (u == v) {
            gc_mv_status[mv] = GC_MV_COALESCED;
            if (!gc_move_related(u) && gc_degree[u] < gc_k(u) && gc_wl[u] == GC_WL_FREEZE) gc_wl[u] = GC_WL_SIMPLIFY;
            return 1;
        }
        if (gc_has_edge(u, v) || gc_cls[u] != gc_cls[v] ||
            gc_force_spill[u] != gc_force_spill[v]) {
            gc_mv_status[mv] = GC_MV_CONSTRAINED;
            if (!gc_move_related(u) && gc_degree[u] < gc_k(u) && gc_wl[u] == GC_WL_FREEZE) gc_wl[u] = GC_WL_SIMPLIFY;
            if (!gc_move_related(v) && gc_degree[v] < gc_k(v) && gc_wl[v] == GC_WL_FREEZE) gc_wl[v] = GC_WL_SIMPLIFY;
            return 1;
        }
        if (gc_george(u, v) || gc_briggs(u, v)) {
            gc_mv_status[mv] = GC_MV_COALESCED;
            gc_combine(u, v);
            if (!gc_move_related(u) && gc_degree[u] < gc_k(u)) {
                if (gc_wl[u] == GC_WL_FREEZE) gc_wl[u] = GC_WL_SIMPLIFY;
            }
            return 1;
        }
        gc_mv_status[mv] = GC_MV_ACTIVE;
        return 1;
    }
    return 0;
}

static int gc_freeze(void) {
    int n, e, mv, other;
    n = 0;
    while (n < gc_nnode) {
        if (gc_wl[n] == GC_WL_FREEZE) {
            gc_wl[n] = GC_WL_SIMPLIFY;
            e = gc_nmlist_head[n];
            while (e >= 0) {
                mv = gc_nmlist_mv[e];
                if (gc_mv_status[mv] == GC_MV_WORKLIST || gc_mv_status[mv] == GC_MV_ACTIVE) {
                    gc_mv_status[mv] = GC_MV_FROZEN;
                    other = gc_get_alias(gc_mv_a[mv]);
                    if (other == n) other = gc_get_alias(gc_mv_b[mv]);
                    if (!gc_move_related(other) && gc_degree[other] < gc_k(other) && gc_wl[other] == GC_WL_FREEZE)
                        gc_wl[other] = GC_WL_SIMPLIFY;
                }
                e = gc_nmlist_next[e];
            }
            return 1;
        }
        n = n + 1;
    }
    return 0;
}

/* Loop-depth-weighted use counts for the spill cost. */
static int ra_wuses[HIR_MAX_INST];

static int ra_depth_w(int b) {
    int d;
    if (b < 0 || b >= bb_nblk) return 1;
    d = licm_depth[b];
    if (d <= 0) return 1;
    if (d == 1) return 10;
    if (d == 2) return 100;
    return 1000;
}

static void ra_build_wuses(void) {
    int i;
    int w;
    int j;
    int base;
    int cnt;
    int k;
    i = 0;
    while (i < h_ninst) { ra_wuses[i] = 0; i = i + 1; }
    i = 0;
    while (i < h_ninst) {
        k = h_kind[i];
        if (k == HI_NOP) { i = i + 1; continue; }
        w = ra_depth_w(h_blk[i]);
        if (h_src1[i] >= 0) ra_wuses[h_src1[i]] = ra_wuses[h_src1[i]] + w;
        if (h_src2[i] >= 0 && ho_src2_is_ref(k)) ra_wuses[h_src2[i]] = ra_wuses[h_src2[i]] + w;
        if ((k == HI_CALL || k == HI_CALLP) && h_cbase[i] >= 0) {
            base = h_cbase[i];
            cnt = h_val[i];
            j = 0;
            while (j < cnt) {
                if (h_carg[base + j] >= 0) ra_wuses[h_carg[base + j]] = ra_wuses[h_carg[base + j]] + w;
                j = j + 1;
            }
        }
        if (k == HI_PHI && h_pbase[i] >= 0) {
            j = 0;
            while (j < h_pcnt[i]) {
                if (h_pval[h_pbase[i] + j] >= 0)
                    ra_wuses[h_pval[h_pbase[i] + j]] = ra_wuses[h_pval[h_pbase[i] + j]] + w;
                j = j + 1;
            }
        }
        if (hi_has_value(k)) ra_wuses[i] = ra_wuses[i] + w;
        if (ra_wuses[i] > 1000000) ra_wuses[i] = 1000000;
        i = i + 1;
    }
}

static int gc_select_spill(void) {
    int n, best, best_cost, cost, inst;
    best = -1;
    best_cost = 0x7FFFFFFF;
    n = 0;
    while (n < gc_nnode) {
        if (gc_wl[n] == GC_WL_SPILL) {
            inst = gc_inst[n];
            cost = (ra_wuses[inst] * 100) / (gc_degree[n] + 1);
            if (h_no_remat[inst] && hi_is_remat(h_kind[inst])) cost = 0;
            if (cost < best_cost) { best_cost = cost; best = n; }
        }
        n = n + 1;
    }
    if (best < 0) return 0;
    gc_wl[best] = GC_WL_SIMPLIFY;
    {
        int e, mv, other;
        e = gc_nmlist_head[best];
        while (e >= 0) {
            mv = gc_nmlist_mv[e];
            if (gc_mv_status[mv] == GC_MV_WORKLIST || gc_mv_status[mv] == GC_MV_ACTIVE) {
                gc_mv_status[mv] = GC_MV_FROZEN;
                other = gc_get_alias(gc_mv_a[mv]);
                if (other == best) other = gc_get_alias(gc_mv_b[mv]);
                if (!gc_move_related(other) && gc_degree[other] < gc_k(other) && gc_wl[other] == GC_WL_FREEZE)
                    gc_wl[other] = GC_WL_SIMPLIFY;
            }
            e = gc_nmlist_next[e];
        }
    }
    return 1;
}

static void gc_irc(void) {
    int progress;
    gc_make_worklists();
    progress = 1;
    while (progress) {
        progress = 0;
        if (gc_simplify()) { progress = 1; continue; }
        if (gc_coalesce()) { progress = 1; continue; }
        if (gc_freeze())   { progress = 1; continue; }
        if (gc_select_spill()) { progress = 1; continue; }
    }
}

/* Colouring.  Within a class: a destructive op tries its src1's
 * colour first (then "OP d,s2" needs no LR), a COPY its source's; a
 * commutative op may take src2's; otherwise the first free colour. */
static void gc_select(void) {
    int i, n, inst, e, peer, pa, pc, c, k, maxc, s;
    int used[RA_NCOLORS];

    i = gc_nsel - 1;
    while (i >= 0) {
        n = gc_sel_stk[i];
        inst = gc_inst[n];
        k = h_kind[inst];
        maxc = gc_k(n);
        c = 0;
        while (c < RA_NCOLORS) { used[c] = 0; c = c + 1; }
        e = gc_adj_head[n];
        while (e >= 0) {
            peer = gc_adj_peer[e];
            pa = gc_get_alias(peer);
            pc = gc_color[pa];
            if (pc >= 0 && pc < RA_NCOLORS) used[pc] = 1;
            e = gc_adj_next[e];
        }
        gc_color[n] = -1;
        if (gc_force_spill[n]) { gc_wl[n] = GC_WL_SPILL; i = i - 1; continue; }

        if (ra_can_reuse_src1(k) || k == HI_COPY) {
            s = h_src1[inst];
            if (s >= 0 && gc_node[s] >= 0) {
                c = gc_color[gc_get_alias(gc_node[s])];
                if (c >= 0 && c < maxc && !used[c]) gc_color[n] = c;
            }
        }
        if (gc_color[n] < 0 && (k == HI_ADD || k == HI_AND || k == HI_OR || k == HI_XOR ||
                                k == HI_FADD || k == HI_FMUL)) {
            s = h_src2[inst];
            if (s >= 0 && gc_node[s] >= 0) {
                c = gc_color[gc_get_alias(gc_node[s])];
                if (c >= 0 && c < maxc && !used[c]) gc_color[n] = c;
            }
        }
        if (gc_color[n] < 0) {
            c = 0;
            while (c < maxc && used[c]) c = c + 1;
            if (c < maxc) gc_color[n] = c;
        }
        if (gc_color[n] < 0) gc_wl[n] = GC_WL_SPILL;
        i = i - 1;
    }

    i = 0;
    while (i < gc_nnode) {
        if (gc_wl[i] == GC_WL_COALESCED) gc_color[i] = gc_color[gc_get_alias(i)];
        i = i + 1;
    }
}

static void gc_writeback(void) {
    int i, n, inst, c;
    i = 0;
    while (i < h_ninst) { ra_reg[i] = -1; i = i + 1; }
    n = 0;
    while (n < gc_nnode) {
        inst = gc_inst[n];
        c = gc_color[n];
        if (gc_force_spill[n]) c = -1;
        if (c >= 0) {
            ra_reg[inst] = gc_cls[n] ? ra_fpr_phys(c) : ra_gpr_phys(c);
        } else if (h_no_remat[inst] && hi_is_remat(h_kind[inst])) {
            /* An uncoloured pinned constant goes back to remat. */
            h_no_remat[inst] = 0;
        } else if (getenv("HIR_RA_DEBUG")) {
            fdputs("SPILL inst=", 2);
            fdputuint(2, (unsigned)inst);
            fdputs(" kind=", 2);
            fdputuint(2, (unsigned)h_kind[inst]);
            fdputs(" blk=", 2);
            fdputuint(2, (unsigned)h_blk[inst]);
            fdputs(" wuses=", 2);
            fdputuint(2, (unsigned)ra_wuses[inst]);
            fdputs(" deg=", 2);
            fdputuint(2, (unsigned)gc_degree[n]);
            fdputc(10, 2);
        }
        n = n + 1;
    }
}

/* Iterated spilling: when a node fails, spill the cheapest value in
 * its neighbourhood, rebuild and colour again (see hir_regalloc.h). */
static int gc_respill(void) {
    int n;
    int nv;
    int e;
    int a;
    int inst;
    int best;
    int bcost;
    int cost;
    nv = 0;
    n = 0;
    while (n < gc_nnode) {
        if (gc_force_spill[n]) { n = n + 1; continue; }
        if (gc_color[n] < 0) {
            best = n;
            bcost = ra_wuses[gc_inst[n]];
            if (h_no_remat[gc_inst[n]] && hi_is_remat(h_kind[gc_inst[n]])) bcost = 0;
            e = gc_adj_head[n];
            while (e >= 0) {
                a = gc_get_alias(gc_adj_peer[e]);
                inst = gc_inst[a];
                if (!ra_mem_forced[inst] && !gc_force_spill[a]) {
                    cost = ra_wuses[inst];
                    if (h_no_remat[inst] && hi_is_remat(h_kind[inst])) cost = 0;
                    if (cost < bcost) { best = a; bcost = cost; }
                }
                e = gc_adj_next[e];
            }
            inst = gc_inst[best];
            if (!ra_mem_forced[inst]) {
                if (h_no_remat[inst] && hi_is_remat(h_kind[inst])) h_no_remat[inst] = 0;
                else ra_mem_forced[inst] = 1;
                nv = nv + 1;
                if (getenv("HIR_RA_DEBUG")) {
                    fdputs("RESPILL victim=", 2);
                    fdputuint(2, (unsigned)inst);
                    fdputs(" for=", 2);
                    fdputuint(2, (unsigned)gc_inst[n]);
                    fdputc(10, 2);
                }
            }
        }
        n = n + 1;
    }
    return nv;
}

static void gc_alloc(void) {
    int iter;
    iter = 0;
    for (;;) {
        gc_build();
        gc_find_moves();
        gc_irc();
        gc_select();
        if (iter >= 32) break;
        if (gc_respill() == 0) break;
        iter = iter + 1;
    }
    gc_writeback();
}

/* Interval-based call crossing: conservative (a superset), used to
 * force floating values to memory before the graph is built. */
static void ra_mark_call_crossing(void) {
    int i, j, inst, k, p, nact;
    int act[HIR_MAX_INST];
    i = 0;
    while (i < h_ninst) { ra_crosses_call[i] = 0; i = i + 1; }
    nact = 0;
    i = 0;
    while (i < ra_norder) {
        inst = ra_order[i];
        p = ra_pos[inst];
        k = h_kind[inst];
        j = 0;
        while (j < nact) {
            int v = act[j];
            if (ra_iend[v] < p) { nact = nact - 1; act[j] = act[nact]; }
            else j = j + 1;
        }
        if (lv_is_callkind(k)) {
            j = 0;
            while (j < nact) {
                int v = act[j];
                if (v >= 0 && v < h_ninst) ra_crosses_call[v] = 1;
                j = j + 1;
            }
        }
        if (hi_has_value(k) && !hi_inst_remat(inst) && k != HI_NOP) {
            if (nact < HIR_MAX_INST) { act[nact] = inst; nact = nact + 1; }
        }
        i = i + 1;
    }
}

static void hir_regalloc(void) {
    int z;
    ra_build_wuses();
    ra_compute_pos();
    ra_compute_ends();
    ra_extend_fused_cmp();
    ra_mark_call_crossing();
    lv_prepare();
    z = 0;
    while (z < h_ninst) {
        ra_mem_forced[z] = 0;
        /* A floating value live across a call: memory, by the linkage
         * convention.  The exact liveness may clear a few of these
         * marks; gc_build forces whatever it finds instead. */
        if (ra_class(z) && ra_crosses_call[z] && hi_has_value(h_kind[z]) &&
            !hi_inst_remat(z) && h_kind[z] != HI_NOP)
            ra_mem_forced[z] = 1;
        z = z + 1;
    }
    gc_alloc();
    ra_assign_spills();
}

/* ---- diagnostics ---- */

static void ra_dump_signed(int v) {
    if (v < 0) { fdputc(45, 2); fdputuint(2, 0 - v); }
    else fdputuint(2, v);
}

static void ra_dump_intervals(char *fname) {
    int i;
    fdputs("DUMP fn=", 2);
    fdputs(fname, 2);
    fdputs(" ninst=", 2);
    fdputuint(2, h_ninst);
    fdputc(10, 2);
    i = 0;
    while (i < h_ninst) {
        if (h_kind[i] == HI_NOP) { i = i + 1; continue; }
        fdputs("DUMP i=", 2);
        fdputuint(2, i);
        fdputs(" k=", 2);
        fdputs(bg_op_name(h_kind[i]), 2);
        fdputs(" t=", 2);
        ra_dump_signed(h_ty[i]);
        fdputs(" b=", 2);
        ra_dump_signed(h_blk[i]);
        fdputs(" p=", 2);
        ra_dump_signed(ra_pos[i]);
        fdputs(" e=", 2);
        ra_dump_signed(ra_iend[i]);
        fdputs(" r=", 2);
        ra_dump_signed(ra_reg[i]);
        fdputs(" s=", 2);
        ra_dump_signed(ra_spill_off[i]);
        fdputs(" v=", 2);
        ra_dump_signed(h_val[i]);
        fdputs(" s1=", 2);
        ra_dump_signed(h_src1[i]);
        fdputs(" s2=", 2);
        ra_dump_signed(h_src2[i]);
        fdputs(" x=", 2);
        ra_dump_signed(ra_crosses_call[i]);
        fdputc(10, 2);
        i = i + 1;
    }
}
