/* COPIED from slow32-public fortran/src/hir_regalloc.h at 2245be78 (2026-10-12).  See PROVENANCE.md. */
/* COPIED from selfhost/stage08/hir_regalloc.h at 30e16a57.  See note in hir.h. */
/* hir_regalloc.h -- IRC graph-coloring register allocation for s12cc (SLOW-32)
 *
 * Iterated Register Coalescing (George-Appel 1996) for the SLOW-32 selfhost
 * compiler.
 *
 * Current production: 18 callee-saved registers (r11..r28) only.
 * Work in progress on this branch: full classification so the allocator can
 * also use the 8 caller-saved argument registers (r3..r10) for values that
 * do not cross calls — matching the official LLVM SLOW32 backend ABI.
 *
 * No x86-64 clobber constraints, no SIB, no SysV ABI PARAM precoloring.
 * The linear-scan implementation has been replaced by the IRC core below
 * (including the edge-transfer fix, GC_MAX_EDGE overflow guard with force_spill,
 * call-crossing divergence blocking in coalesce, and non-crossing spill bias
 * from the x64/a64 robustness work — e4681a1d / b6f0832f and siblings).
 * Same live-interval linearization, fusion extension, spill assignment, and
 * diagnostic interfaces are preserved.
 *
 * Reference: George-Appel "Iterated Register Coalescing" (1996).
 *
 * Input:  HIR after SSA construction, optimization, and LICM.
 * Output: ra_reg[]   — physical register (r11..r28) per inst, -1 = spilled/remat
 *         ra_spill_off[] — stack offset per inst (negative from fp, 0 = none)
 *         ra_ncsave/ra_csave_reg[]/ra_csave_off[] — callee-save info
 */

/* --- Configuration (SLOW-32) --- */
#define RA_NPHY      19   /* r11..r28 + optional r30 */
#define RA_FIRST_REG 11   /* lowest allocatable register */
#define RA_NCALLEE   18   /* r11..r28; r30 is extra when ra_r30_alloc */

/* --- Full register classification (hard item — disabled until wired) ---
 * Goal: match the official LLVM SLOW32 ABI so short-lived values can use
 * the 8 caller-saved argument registers (r3-r10) instead of forcing every
 * live value into a callee-saved slot.
 *
 *   RA_NCALLEE   = 18  (r11..r28)  — must be saved/restored across calls
 *   RA_NCALLER   =  8  (r3..r10)   — clobbered by calls, cheap for temps
 *   RA_NPHY_ACTIVE = 18 + ra_caller_saved_enabled_count (0 during bring-up)
 *   RA_NPHY_TOTAL  = 26            — maximum pool size
 *
 * The knob ra_caller_saved_enabled_count starts at 0 so the tree remains
 * bit-for-bit identical to the committed 9117dec5 baseline.
 */
#define RA_NCALLER   8
/* Stage06 selfhost parser only accepts a bare integer literal as an array
 * dimension (parser.h:1496/1918 — no parenthesized expressions).  Hard-code
 * the sum so `static int ra_phys_reg[RA_NPHY_TOTAL]` below parses under the
 * bootstrap compiler.  Keep in sync with RA_NCALLEE + RA_NCALLER above. */
#define RA_NPHY_TOTAL 27   /* RA_NCALLEE (18) + r30 + RA_NCALLER (8) */

/* Knob: how many caller-saved registers the allocator may use right now.
 * 0 = current production behavior (18 callee only).
 * 8 = full pool (r3-r10 + r11-r28) for values that do not cross calls.
 */
static int ra_caller_saved_enabled_count = 8;  /* 0 = baseline (18 callee-saved only). 8 = enable r3-r10 for non-call-crossing values. */

/* GitHub issue 73: r30 is the frame pointer when the function keeps
 * one (varargs, or a large frame that did not take the extra color).
 * On the omit-fp path it is an extra callee-saved GPR.  Set per
 * function before hir_regalloc(); ra_init_phys_regs rebuilds the map. */
static int ra_r30_alloc;
static int ra_ncal = 18;             /* 18 or 19; set by ra_init_phys_regs */
static int ra_stat_r30;              /* values colored to r30 */

/* Cross-call liveness tracking — must be declared extremely early because
 * ra_prefers_caller_for_inst() (and other early helpers) reference it in
 * this single translation unit. */
static int ra_crosses_call[HIR_MAX_INST];
static int ra_mem_forced[HIR_MAX_INST];  /* iterated-spill victims (gc_respill) */
/* COPY insts emitted immediately before a call to split a live range
 * that is used as a call argument (or CALLP callee) and also lives
 * after the call.  Chained through ra_csplit_next. */
static int ra_csplit_head[HIR_MAX_INST];
static int ra_csplit_next[HIR_MAX_INST];
static int ra_split_orig;
static int ra_stat_csplit;
static int ra_after_stamp[HIR_MAX_INST];
static int ra_after_tick;
static char ra_is_csplit[HIR_MAX_INST];   /* COPY dest of a call split: always callee-saved */
static int ra_dom_wl[HIR_MAX_BLOCK];      /* dom-tree walk for after-use rewire */
static void ra_dump_signed(int v);       /* diagnostics; defined near the dump */

/* Physical register table and classification (populated by ra_init_phys_regs).
 * Index 0..17  → r11..r28 (callee)
 * Index 18..25 → r3..r10  (caller)
 */
static int ra_phys_reg[RA_NPHY_TOTAL];
static int ra_is_callee[RA_NPHY_TOTAL];

/* Initialize the physical register map and callee/caller classification.
 * Rebuilt per function so r30 can join the callee pool when ra_r30_alloc.
 */
static void ra_init_phys_regs(void) {
    int i;
    int ncal;

    /* Callee-saved pool: r11..r28 (indices 0..17), then r30 if enabled. */
    for (i = 0; i < RA_NCALLEE; i = i + 1) {
        ra_phys_reg[i] = RA_FIRST_REG + i;   /* 11 .. 28 */
        ra_is_callee[i] = 1;
    }
    ncal = RA_NCALLEE;
    if (ra_r30_alloc) {
        ra_phys_reg[ncal] = 30;
        ra_is_callee[ncal] = 1;
        ncal = ncal + 1;
    }
    ra_ncal = ncal;

    /* Caller-saved pool: r3..r10, immediately after the callee slots. */
    for (i = 0; i < RA_NCALLER; i = i + 1) {
        ra_phys_reg[ncal + i] = 3 + i; /* 3 .. 10 */
        ra_is_callee[ncal + i] = 0;
    }
}

/* Query helpers (safe even when knob == 0) */
static int ra_num_callee_saved(void) {
    ra_init_phys_regs();
    return ra_ncal;
}

static int ra_num_caller_saved_enabled(void) {
    return ra_caller_saved_enabled_count;
}

static int ra_num_active_slots(void) {
    ra_init_phys_regs();
    return ra_ncal + ra_caller_saved_enabled_count;
}

static int ra_phys_is_callee_saved(int phys) {
    int i;
    ra_init_phys_regs();
    i = 0;
    while (i < RA_NPHY_TOTAL) {
        if (ra_phys_reg[i] == phys) return ra_is_callee[i];
        i = i + 1;
    }
    return 1; /* conservative: unknown phys → treat as callee */
}

static int ra_phys_is_caller_saved(int phys) {
    return !ra_phys_is_callee_saved(phys);
}

/* Map an allocator "slot" (0..active-1) to its physical register number.
 * When knob==0 this is exactly the old 0..17 → r11..r28 mapping.
 */
static int ra_get_phys(int slot) {
    ra_init_phys_regs();
    if (slot < 0 || slot >= ra_num_active_slots()) return -1;
    return ra_phys_reg[slot];
}

/* Returns true if the given HIR opcode can usefully reuse the color of
 * its src1 operand for the result.  Covers the main destructive integer
 * ops plus the dominant immediate form (ADDI).
 */
static int ra_can_reuse_src1(int k) {
    return (k >= HI_ADD && k <= HI_SRL) || k == HI_ADDI || k == HI_MULH || k == HI_MULHU;
}

/* Returns true if we are allowed to give this instruction a caller-saved
 * register (r3-r10) on this run.
 *
 * With ra_caller_saved_enabled_count=8 (the default), this returns true for
 * values whose live range does not cross any call (computed by the active-set
 * walk in ra_mark_call_crossing).  Such values may be allocated from the
 * cheap r3-r10 pool instead of forcing everything into r11-r28.
 */
static int ra_prefers_caller_for_inst(int inst) {
    if (ra_caller_saved_enabled_count == 0) return 0;
    if (inst < 0 || inst >= h_ninst) return 0;

    /* Real call-crossing data is now available (ra_mark_call_crossing ran).
     * Values whose live range does *not* cross any call are allowed to use
     * the cheap caller-saved registers (r3-r10).  Values that cross calls
     * must stay in the callee-saved pool (r11-r28). */
    if (ra_is_csplit[inst]) return 0;
    return !ra_crosses_call[inst];
}

/* Returns the allocator color (slot 0..active-1) whose physical register
 * matches the ABI incoming register for this HI_PARAM (i.e. r3 + h_val[inst]),
 * if that register is currently part of the enabled pool *and* the value is
 * allowed to live there under the current crossing classification.
 *
 * When gc_select takes this color, the HI_PARAM emission in hir_codegen
 * produces `addi rd, rd, 0`, which hcg_mov already elides.  Net effect:
 * zero-copy parameter entry for the common non-call-crossing / leaf case.
 *
 * Crossing params will normally not get their preferred (caller) reg because
 * they are forced into the callee range; they pay the expected move into a
 * callee-saved register. */
static int ra_param_preferred_color(int inst) {
    int phys, slot, nactive;

    if (inst < 0 || inst >= h_ninst) return -1;
    if (h_kind[inst] != HI_PARAM) return -1;
    /* Incoming location comes from the ABI walk (aligned f64 pairs,
     * back-filled ints).  Stack-passed params have no incoming
     * register — any free color works. */
    if (h_val[inst] >= hl_param_nflat) return -1;
    if (hl_param_map[h_val[inst]] < 0) return -1;

    phys = hl_param_map[h_val[inst]];
    ra_init_phys_regs();
    nactive = ra_num_active_slots();

    slot = 0;
    while (slot < nactive) {
        if (ra_phys_reg[slot] == phys) {
            if (ra_is_callee[slot]) {
                /* Callee slot — always legal for any value */
                return slot;
            }
            /* Caller slot — only if this value is allowed in the caller pool */
            if (ra_prefers_caller_for_inst(inst)) return slot;
            return -1;
        }
        slot = slot + 1;
    }
    return -1;
}

/* Preferred physical register for a value used as a call argument
 * (issue 67).  -1 if none.  Last call site wins. */
static int ra_arg_pref_phys[HIR_MAX_INST];
static int ra_abi_map[256];

static void ra_mark_arg_prefs(void) {
    int i;
    int j;
    int n;
    int base;
    int v;
    i = 0;
    while (i < h_ninst) { ra_arg_pref_phys[i] = -1; i = i + 1; }
    i = 0;
    while (i < h_ninst) {
        if ((h_kind[i] == HI_CALL || h_kind[i] == HI_CALLP) &&
            h_cbase[i] >= 0) {
            n = h_val[i];
            base = h_cbase[i];
            if (n > 0 && n <= 256) {
                hi_abi_assign(&h_carg_tag[base], n, ra_abi_map);
                j = 0;
                while (j < n) {
                    v = h_carg[base + j];
                    if (v >= 0 && ra_abi_map[j] >= 0)
                        ra_arg_pref_phys[v] = ra_abi_map[j];
                    j = j + 1;
                }
            }
        }
        i = i + 1;
    }
}

static int ra_argsite_preferred_color(int inst) {
    int phys;
    int slot;
    int nactive;
    if (inst < 0 || inst >= h_ninst) return -1;
    phys = ra_arg_pref_phys[inst];
    if (phys < 0) return -1;
    ra_init_phys_regs();
    nactive = ra_num_active_slots();
    slot = 0;
    while (slot < nactive) {
        if (ra_phys_reg[slot] == phys) {
            if (ra_is_callee[slot]) return slot;
            if (ra_prefers_caller_for_inst(inst)) return slot;
            return -1;
        }
        slot = slot + 1;
    }
    return -1;
}

/* --- Output arrays --- */
static int ra_reg[HIR_MAX_INST];    /* physical register, -1 = spilled/remat */
static int ra_spill_off[HIR_MAX_INST]; /* spill slot (negative fp offset), 0 = none */

/* --- Live interval arrays --- */
static int ra_pos[HIR_MAX_INST];    /* linearized position */
static int ra_iend[HIR_MAX_INST];   /* last use position (end of live interval) */

/* --- Linearized order --- */
static int ra_order[HIR_MAX_INST];  /* instruction indices in position order */
static int ra_norder;

/* --- Callee-save tracking --- */
static int ra_used[RA_NPHY_TOTAL];  /* 1 if register (slot) was assigned; sized for full pool */
static int ra_csave_reg[RA_NPHY];   /* physical register number (still only callee-saved get slots) */
static int ra_csave_off[RA_NPHY];   /* fp offset for save slot */
static int ra_ncsave;               /* count of registers to save */
static int ra_csave_bytes;          /* bytes of frame charged for csave slots; tail of hl_temp_stack
                                     * after ra_assign_spills.  Read by leaf-frame reclaim in
                                     * hir_codegen instead of recomputing ra_ncsave*4 inline. */
static int ra_stat_spills;          /* cumulative spill count across all functions */
static int ra_stat_caller_used;     /* how many values got caller-saved registers */
static int ra_stat_callee_used;     /* how many values got callee-saved registers */
static int ra_stat_param_preferred; /* how many HI_PARAM nodes got their ABI incoming reg as color (zero-copy entry) */
static int ra_stat_operand_reuse;   /* binary ops whose result reused an operand's physical register
                                     * (src1 for destructive ops, or src1/src2 for commutative ops) */
static int ra_stat_src2_reuse;      /* subset of operand_reuse where src2 was the winning operand
                                     * (only meaningful for commutative ops where reordering paid off) */
static int ra_stat_secondary_reuse; /* times the secondary/smart operand choice actually supplied the color */
static int ra_stat_imm_base_reuse;  /* HI_ADDI results that reused their base register's color */

/* (ra_crosses_* arrays moved to the very top of the classification section
 * for single-TU declaration ordering.) */

/* =================================================================
 * IRC data structures (Chunk 3 — dead code until wiring step)
 * ================================================================= */

#define GC_MAX_NODE 4096   /* fort370: one unit in an 8MB region, docs/FITTING.md */
#define GC_MAX_EDGE 262144   /* fort370: one unit in an 8MB region, docs/FITTING.md */
#define GC_MAX_MOVE 4096   /* fort370: one unit in an 8MB region, docs/FITTING.md */

static int gc_nnode;
static int gc_inst[GC_MAX_NODE];
static int gc_node[HIR_MAX_INST];

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

/* ra_crosses_call is the only live cross tracking for SLOW-32 (caller-saved classification).
 * The x64 clobber-position lists and ra_mark_clobbers were dead after the IRC port and have
 * been removed.  See gc_add_edge for the GC_MAX_EDGE overflow guard (force_spill). */

/* =================================================================
 * Step 1: Compute linearized positions (RPO block order)
 * ================================================================= */

static void ra_compute_pos(void) {
    int ri;
    int b;
    int i;
    int pos;
    int phi;
    int term;
    int tk;

    /* Init all positions to -1 (unreachable) */
    i = 0;
    while (i < h_ninst) {
        ra_pos[i] = -1;
        i = i + 1;
    }

    pos = 0;
    ra_norder = 0;

    /* Walk blocks in RPO order */
    ri = 0;
    while (ri < ssa_rpo_cnt) {
        b = ssa_rpo_ord[ri];

        /* PHIs for this block (defined at block start) */
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

        /* Find terminator (last BR/BRC/RET/JMPTAB) in this block */
        term = -1;
        i = bb_end[b] - 1;
        while (i >= bb_start[b]) {
            tk = h_kind[i];
            if (hi_is_terminator(tk)) {
                term = i;
                break;
            }
            if (tk != HI_NOP) break;
            i = i - 1;
        }

        /* Regular instructions up to (not including) the terminator */
        /* Split-pass reloads run at the TOP of the block. */
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
            {
                int sp;
                sp = ra_csplit_head[i];
                while (sp >= 0) {
                    if (h_kind[sp] != HI_NOP) {
                        ra_pos[sp] = pos;
                        ra_order[ra_norder] = sp;
                        ra_norder = ra_norder + 1;
                        pos = pos + 1;
                    }
                    sp = ra_csplit_next[sp];
                }
            }
            if (h_kind[i] != HI_NOP) {
                ra_pos[i] = pos;
                ra_order[ra_norder] = i;
                ra_norder = ra_norder + 1;
                pos = pos + 1;
            }
            i = i + 1;
        }

        /* LICM-hoisted instructions (after regular, before terminator) */
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

        /* The terminator itself */
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
 * Step 2: Compute live interval endpoints
 * ================================================================= */

static void ra_extend(int inst, int use_pos) {
    if (inst >= 0 && ra_pos[inst] >= 0 && use_pos > ra_iend[inst]) {
        ra_iend[inst] = use_pos;
    }
}

/* --- Cross-block liveness propagation ---
 *
 * When a value is defined in one block and used in another, we must
 * extend its live interval through ALL blocks on any path from the
 * def block to the use block.  This is critical for loops: if a value
 * is defined before a loop and used inside it, the back-edge creates
 * a path that keeps the value alive through the entire loop body.
 *
 * Algorithm: BFS backward through CFG predecessors from the use block
 * to the def block, extending the value's interval to the end of every
 * intermediate block (and the use block and def block themselves).
 */

static int ra_blk_last[HIR_MAX_BLOCK]; /* last position in each block */
static int ra_bvis[HIR_MAX_BLOCK];     /* visited flags for BFS */
static int ra_bwl[HIR_MAX_BLOCK];      /* BFS worklist */

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

    /* Clear visited */
    b = 0;
    while (b < bb_nblk) {
        ra_bvis[b] = 0;
        b = b + 1;
    }

    /* Start BFS from use_blk.  The value was already extended to its
     * actual use position by the forward pass — do NOT extend it to
     * the end of the use block here.  That over-extension made every
     * loop-carried phi overlap its own next value (one copy per
     * iteration, uncoalesceable).  When use_blk is re-reached below
     * as a predecessor on a cycle, the value genuinely lives through
     * all of it, and the unconditional extend in the walk covers it. */
    ra_bvis[use_blk] = 1;
    ra_bwl[0] = use_blk;
    wh = 0;
    wt = 1;

    while (wh < wt) {
        b = ra_bwl[wh];
        wh = wh + 1;

        /* Walk predecessors of b.  Every predecessor on a def->use
         * path carries the value across its whole extent, so the
         * extend is unconditional (idempotent on revisits); visited
         * only gates enqueueing. */
        j = 0;
        while (j < ssa_npred[b]) {
            p = ssa_pred[ssa_pbase[b] + j];
            if (p >= 0 && p < bb_nblk) {
                ra_extend(val, ra_blk_last[p]);
                if (!ra_bvis[p]) {
                    ra_bvis[p] = 1;
                    if (p != def_blk && wt < HIR_MAX_BLOCK) {
                        /* Continue BFS past intermediate blocks, stop at def */
                        ra_bwl[wt] = p;
                        wt = wt + 1;
                    }
                }
            }
            j = j + 1;
        }
    }
}

static int ra_is_i12(int v) {
    return (v >= -2048 && v <= 2047);
}

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
    if (pat >= 0) {
        lnt = bg_plnt[pat];
    } else if (s1 >= 0 && h_kind[s1] == HI_ALLOCA) {
        lnt = BG_FADDR;
    }

    if (k == HI_LOAD || k == HI_STORE) {
        if (lnt == BG_FADDR || lnt == BG_SADDR) return 0;

        chain = s1;
        off = 0;
        chlim = 0;
        while (chain >= 0 && chlim < 64) {
            ck = h_kind[chain];
            if (ck == HI_COPY) {
                chain = h_src1[chain];
                chlim = chlim + 1;
                continue;
            }
            if (ck == HI_ADDI) {
                off = off + h_val[chain];
                chain = h_src1[chain];
                chlim = chlim + 1;
                continue;
            }
            break;
        }
        if (chain >= 0 && chain != s1 && ra_is_i12(off)) {
            *base_out = chain;
            return 1;
        }
        return 0;
    }

    if (k == HI_ADDI) {
        if (lnt == BG_FADDR) return 0;

        chain = s1;
        chlim = 0;
        while (chain >= 0 && h_kind[chain] == HI_ADDI && chlim < 64) {
            chain = h_src1[chain];
            chlim = chlim + 1;
        }
        if (chain >= 0 && chain != s1) {
            *base_out = chain;
            return 1;
        }
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

    /* Initialize end = start (def point) */
    i = 0;
    while (i < h_ninst) {
        ra_iend[i] = ra_pos[i];
        i = i + 1;
    }

    /* Compute last position in each block (for cross-block extension) */
    b = 0;
    while (b < bb_nblk) {
        ra_blk_last[b] = -1;
        b = b + 1;
    }
    i = 0;
    while (i < ra_norder) {
        inst = ra_order[i];
        b = h_blk[inst];
        if (b >= 0 && b < bb_nblk) {
            ra_blk_last[b] = ra_pos[inst];  /* last one wins */
        }
        i = i + 1;
    }

    /* Scan all instructions for uses */
    i = 0;
    while (i < ra_norder) {
        inst = ra_order[i];
        k = h_kind[inst];
        p = ra_pos[inst];

        /* src1 is always an instruction reference when >= 0 */
        ra_extend(h_src1[inst], p);

        /* src2 is an instruction ref for binops and STORE */
        if (h_src2[inst] >= 0 && ho_src2_is_ref(k)) {
            ra_extend(h_src2[inst], p);
        }

        /* Codegen fold-through: codegen may emit a load/store/addi
         * using a folded chain's base register rather than s1's
         * register.  Extend exactly the base that codegen will read.
         *
         * Without this, n's interval (the deepest base) ends at its
         * last *direct* use, but a later folded LOAD that reaches
         * through an ADDI(n,52) still emits `ldw rd, r_n, 52` —
         * reading a clobbered register.  See Issue #31. */
        if (ra_codegen_fold_base(inst, &src)) {
            ra_extend(src, p);
        }

        /* Call arguments */
        if ((k == HI_CALL || k == HI_CALLP) && h_cbase[inst] >= 0) {
            j = 0;
            while (j < h_val[inst]) {
                ra_extend(h_carg[h_cbase[inst] + j], p);
                j = j + 1;
            }
        }

        /* PHI arguments: used at end of predecessor block */
        if (k == HI_PHI && h_pbase[inst] >= 0) {
            j = 0;
            while (j < h_pcnt[inst]) {
                a = h_pval[h_pbase[inst] + j];
                pred = h_pblk[h_pbase[inst] + j];
                if (a >= 0 && ra_pos[a] >= 0 && pred >= 0 && pred < bb_nblk) {
                    /* Use point is at the terminator of the predecessor.
                     * Find the last non-NOP instruction in pred block. */
                    term = bb_end[pred] - 1;
                    while (term >= bb_start[pred] && h_kind[term] == HI_NOP) {
                        term = term - 1;
                    }
                    if (term >= bb_start[pred] && ra_pos[term] >= 0) {
                        ra_extend(a, ra_pos[term]);
                    }
                }
                j = j + 1;
            }
        }

        i = i + 1;
    }

    /* Cross-block liveness propagation: for each operand used in a
     * different block than its definition, backward-propagate through
     * CFG predecessors to extend the live interval through all
     * intermediate blocks.  This handles loops correctly because the
     * BFS follows back-edges. */
    i = 0;
    while (i < ra_norder) {
        inst = ra_order[i];
        k = h_kind[inst];

        /* src1 */
        src = h_src1[inst];
        if (src >= 0 && ra_pos[src] >= 0 && h_blk[src] != h_blk[inst]) {
            ra_backprop(src, h_blk[inst]);
        }

        /* src2 */
        if (h_src2[inst] >= 0 && ho_src2_is_ref(k)) {
            src = h_src2[inst];
            if (ra_pos[src] >= 0 && h_blk[src] != h_blk[inst]) {
                ra_backprop(src, h_blk[inst]);
            }
        }

        /* Codegen fold-through: mirror the forward extend above. */
        if (ra_codegen_fold_base(inst, &src) && ra_pos[src] >= 0 &&
            h_blk[src] != h_blk[inst]) {
            ra_backprop(src, h_blk[inst]);
        }

        /* Call arguments */
        if ((k == HI_CALL || k == HI_CALLP) && h_cbase[inst] >= 0) {
            j = 0;
            while (j < h_val[inst]) {
                src = h_carg[h_cbase[inst] + j];
                if (src >= 0 && ra_pos[src] >= 0 && h_blk[src] != h_blk[inst]) {
                    ra_backprop(src, h_blk[inst]);
                }
                j = j + 1;
            }
        }

        /* PHI arguments: used at end of predecessor block */
        if (k == HI_PHI && h_pbase[inst] >= 0) {
            j = 0;
            while (j < h_pcnt[inst]) {
                a = h_pval[h_pbase[inst] + j];
                pred = h_pblk[h_pbase[inst] + j];
                if (a >= 0 && ra_pos[a] >= 0 && pred >= 0 && pred < bb_nblk &&
                    h_blk[a] != pred) {
                    ra_backprop(a, pred);
                }
                j = j + 1;
            }
        }

        i = i + 1;
    }
}

/* =================================================================
 * Step 3: Spill / callee-save slot assignment
 * (Used by the IRC allocator)
 * ================================================================= */

/* --- Spill-slot sharing (GitHub issue 77) ---
 * A spilled value occupies its slot from the store after its def to
 * its last reload: the register interval [ra_pos, ra_iend].  A spilled
 * PHI is different -- its slot is written by the edge copies at the
 * end of EVERY predecessor, which on a back edge is a position far
 * after the phi's own, so the slot range is widened to cover each
 * predecessor's terminator.  That also keeps a phi apart from the
 * values still live at those terminators (the copies read them). */
static int ra_shead[HIR_MAX_INST];      /* per start position: first value */
static int ra_snext[HIR_MAX_INST];      /* next value with the same start */
static int ra_slot_end[HIR_MAX_INST];   /* per slot: occupant's end position */
static int ra_stat_sslots;              /* cumulative slots after sharing */

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
                while (term >= bb_start[pred] && h_kind[term] == HI_NOP)
                    term = term - 1;
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

static void ra_assign_spill_slots(void) {
    int i;
    int v;
    int s;
    int e;
    int p;
    int k;
    int nslot;
    int base;
    int npos;
    npos = ra_norder;
    p = 0;
    while (p < npos) { ra_shead[p] = -1; p = p + 1; }
    /* Bucket the spilled values by slot start; values with no
     * position (unreachable) are handled after the scan. */
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
    base = hl_temp_stack;
    nslot = 0;
    p = 0;
    while (p < npos) {
        v = ra_shead[p];
        while (v >= 0) {
            ra_slot_range(v, &s, &e);
            /* First fit: lowest slot whose occupant ended strictly
             * before this value starts (equal positions can be a
             * reload feeding the def that would overwrite it). */
            k = 0;
            while (k < nslot && ra_slot_end[k] >= p) k = k + 1;
            /* ...but not in a function that calls setjmp: lifetimes are
             * disjoint only along the paths the flow graph has, and the
             * way back from longjmp is not one (hir_ssa.h) */
            if (ssa_fn_setjmp) k = nslot;
            if (k == nslot) nslot = nslot + 1;
            ra_slot_end[k] = e;
            ra_spill_off[v] = 0 - (base + 4 * (k + 1));
            ra_stat_spills = ra_stat_spills + 1;
            v = ra_snext[v];
        }
        p = p + 1;
    }
    hl_temp_stack = base + 4 * nslot;
    ra_stat_sslots = ra_stat_sslots + nslot;
    /* Unreachable values: private slots, as before. */
    i = 0;
    while (i < h_ninst) {
        if (ra_spill_wants_slot(i) && !(ra_pos[i] >= 0 && ra_pos[i] < npos)) {
            hl_temp_stack = hl_temp_stack + 4;
            ra_spill_off[i] = 0 - hl_temp_stack;
            ra_stat_spills = ra_stat_spills + 1;
            ra_stat_sslots = ra_stat_sslots + 1;
        }
        i = i + 1;
    }
}

static void ra_assign_spills(void) {
    int i;
    int r;

    /* Initialize all spill offsets to 0 */
    i = 0;
    while (i < h_ninst) {
        ra_spill_off[i] = 0;
        i = i + 1;
    }

    if (getenv("HIR_RA_TRACE")) {
        i = atoi(getenv("HIR_RA_TRACE"));
        if (i >= 0 && i < h_ninst) {
            fdputs("TRACE inst=", 2);
            fdputuint(2, (unsigned)i);
            fdputs(" kind=", 2);
            fdputuint(2, (unsigned)h_kind[i]);
            fdputs(" blk=", 2);
            fdputuint(2, (unsigned)h_blk[i]);
            fdputs(" pos=", 2);
            fdputuint(2, (unsigned)ra_pos[i]);
            fdputs(" reg=", 2);
            fdputuint(2, (unsigned)ra_reg[i]);
            fdputs(" slot=", 2);
            fdputuint(2, (unsigned)ra_spill_off[i]);
            fdputs(" node=", 2);
            fdputuint(2, (unsigned)gc_node[i]);
            fdputc(10, 2);
        }
    }
    if (getenv("HIR_RA_DEBUG")) {
        i = 0;
        while (i < h_ninst) {
            if (h_kind[i] != HI_NOP && hi_has_value(h_kind[i]) &&
                !hi_inst_remat(i) && ra_reg[i] < 0 && ra_pos[i] < 0) {
                fdputs("ORPHAN inst=", 2);
                fdputuint(2, (unsigned)i);
                fdputs(" kind=", 2);
                fdputuint(2, (unsigned)h_kind[i]);
                fdputs(" blk=", 2);
                fdputuint(2, (unsigned)h_blk[i]);
                fdputc(10, 2);
            }
            i = i + 1;
        }
    }
    /* Assign spill slots for non-allocated, non-remat value-producing
     * instructions.  GitHub issue 77: slots are SHARED by live range.
     * One private slot per spilled value gave sqlite3VdbeExec 4,683
     * slots (a 22,572-byte frame against clang's 400), and a slot past
     * +/-2047 costs lui+addi+add on every access.  Linear scan over
     * the spilled values in start order: a slot whose occupant ended
     * strictly before this value starts is reused, else the frame
     * grows by one.  Values the linearization never reached keep a
     * private slot as before. */
    ra_assign_spill_slots();

    /* Assign callee-save slots.
     * Only callee colors (r11..r28, and r30 when allocated) need to be
     * saved/restored.  Caller-saved colors are deliberately excluded.
     *
     * Track the bytes we charge here in ra_csave_bytes so the leaf-frame
     * reclaim in hir_codegen can subtract them by name instead of assuming
     * the layout (csave block is the strict tail of hl_temp_stack here). */
    ra_ncsave = 0;
    ra_csave_bytes = 0;
    r = 0;
    while (r < ra_ncal) {
        if (ra_used[r]) {
            hl_temp_stack = hl_temp_stack + 4;
            ra_csave_bytes = ra_csave_bytes + 4;
            ra_csave_reg[ra_ncsave] = ra_get_phys(r);  /* r11..r28, maybe r30 */
            ra_csave_off[ra_ncsave] = 0 - hl_temp_stack;
            ra_ncsave = ra_ncsave + 1;
        }
        r = r + 1;
    }
}

/* =================================================================
 * Step 4b: Extend live ranges for compare-and-branch fusion
 *
 * For each BRC that fuses a comparison, extend the comparison's
 * operands to the BRC position so they remain in registers.
 * Then NOP the comparison so regalloc doesn't allocate for it.
 * ================================================================= */

static void ra_extend_fused_cmp(void) {
    int i;
    int cmp;
    int ca;
    int cb;
    int brc_pos;
    int c;
    int lim;

    i = 0;
    while (i < h_ninst) {
        /* Only BRC carries a fuse; extra insts appended after
         * hcg_identify_fusions (call-split COPYs) keep the BSS 0
         * in hcg_brc_fuse[], which would NOP instruction 0. */
        if (h_kind[i] != HI_BRC) { i = i + 1; continue; }
        cmp = hcg_brc_fuse[i];
        if (cmp < 0) { i = i + 1; continue; }

        brc_pos = ra_pos[i];
        if (brc_pos < 0) {
            hcg_brc_fuse[i] = -1;
            i = i + 1;
            continue;
        }

        /* A fused fp64 compare CALL is NOT re-emitted at the BRC: the
         * call site itself emits flt.d into r1 and the adjacent BRC
         * reads it.  Keep the call fully visible to the allocator --
         * its carg ranges and call-crossing effects stand as-is. */
        if (h_kind[cmp] == HI_CALL) { i = i + 1; continue; }

        ca = h_src1[cmp];
        cb = h_src2[cmp];

        /* Extend comparison operand live ranges to BRC position */
        ra_extend(ca, brc_pos);
        ra_extend(cb, brc_pos);

        /* NOP the comparison so regalloc skips it */
        h_kind[cmp] = HI_NOP;

        /* NOP any intermediate COPYs between BRC and the comparison */
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
 * Main entry point
 * ================================================================= */

/* =================================================================
 * IRC small helpers (Chunk 3 — dead code)
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

static void gc_add_edge(int u, int v) {
    int e1, e2;
    if (u == v) return;
    if (gc_has_edge(u, v)) return;
    if (gc_nedge + 2 > GC_MAX_EDGE) {
        /* Can't record this interference — mark both nodes as force-spill
         * so they get spill slots instead of potentially sharing a color
         * with the unrecorded interferer.  Without this guard a silent drop
         * here can cause multiple call arguments (or other live values) to
         * be assigned the same physical register, leading to corruption
         * before the call.  See b6f0832f (IRC graph-edge overflow fix). */
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
    while (gc_alias[n] != n && lim < GC_MAX_NODE) {
        n = gc_alias[n];
        lim = lim + 1;
    }
    return n;
}

/* Forward prototype so callers earlier in the TU see the static declaration.
 * Fixes the "static declaration follows non-static" error on some gcc versions
 * (Alpine, certain Debian builds) when building the single-TU s12cc.c. */
static int gc_k(int n);

static void gc_dec_degree(int n) {
    int k;
    gc_degree[n] = gc_degree[n] - 1;
    k = gc_k(n);
    if (gc_degree[n] == k - 1) {
        if (gc_move_related(n)) gc_wl[n] = GC_WL_FREEZE;
        else gc_wl[n] = GC_WL_SIMPLIFY;
    }
}

static int gc_k(int n) {
    (void)n;
    /* Dynamic K: the number of colors (registers) currently available.
     * When ra_caller_saved_enabled_count == 0 this is still 18 (identical
     * to the committed baseline).  When the knob is raised, short-lived
     * values will see K=26 and the allocator can use r3-r10. */
    return ra_num_active_slots();
}

/* =================================================================
 * IRC algorithmic core (Chunk 3 — dead code, C89 declaration style)
 * ================================================================= */

/* DIVERGENCE (f77, port upstream candidate): moves that come from a
 * PHI are tagged.  A loop-carried phi crosses the body's fp64 calls
 * while its increment usually does not, and the blanket crossing-
 * mismatch refusal in gc_coalesce left every such loop paying copies
 * each iteration; a phi move may coalesce across the mismatch because
 * the merged node keeps the CROSSING side's palette (the swap in
 * gc_coalesce puts the crossing node in u before gc_combine(u, v)). */
static char gc_mv_phi[GC_MAX_MOVE];

static void gc_add_move_tag(int a, int b, int is_phi) {
    int mv;
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

static void gc_add_move(int a, int b) {
    gc_add_move_tag(a, b, 0);
}

/* Tentatively re-declared: defined with the pair machinery below,
 * needed by gc_build/gc_combine above it. */
static int ra_pair_of[HIR_MAX_INST];
static int ra_pair_lo[HIR_MAX_INST];
static int gc_pair_inst[GC_MAX_NODE];

/* =================================================================
 * Per-block liveness (DIVERGENCE f77, port upstream candidate)
 *
 * The linear-interval model treats a value as live at every position
 * between its def and its last use IN LINEARIZED ORDER -- including
 * whole blocks on unrelated CFG paths that happen to sit in between.
 * Every value in those blocks picks up a false interference edge, and
 * in a function with several loops laid end to end (an inlined DAXPY,
 * say) the false pressure is what spills: inlining measured 2.3x
 * WORSE under intervals with the spill dump blaming exactly this.
 *
 * This is the classic fix: iterative backward dataflow to a fixpoint
 * gives live-in/live-out per block, then one backward walk per block
 * builds interference edges and the call-crossing marks from the
 * exact set of values live at each point.  Everything downstream --
 * IRC coalescing, pair claiming, weighted spill costs, select -- is
 * untouched; only where edges COME FROM changes.  The interval code
 * stays for its other consumers (fusion extends, dumps) and as the
 * HIR_LINEAR_LIVE=1 fallback.
 *
 * Bitsets are indexed by a dense id assigned in ra_order; the arrays
 * are statically sized for the worst case (8MB bss) but only
 * bb_nblk x lv_nw words are ever touched.
 * ================================================================= */
/* GC_MAX_NODE / 32: ids beyond the node cap could never be coloured
 * anyway, so functions that large stay on intervals. */
#define LV_W 128
/* Flattened [HIR_MAX_BLOCK][LV_W]: the selfhost dialect has no 2D
 * static arrays, and the bound must be a literal (2048 * 128).  Kept
 * to 1MB apiece -- the selfhost assembler has a cumulative BSS
 * budget, and 4MB versions of these were what first blew it. */
/* The live-in/out sets are bb_nblk rows of lv_w words, sized per
 * function and grown as needed (SQLite's sqlite3VdbeExec has tens of
 * thousands of values; 128 words per row was 4,096 and the row stride
 * was a fixed shift). */
static unsigned int *lv_in;
static unsigned int *lv_out;
static unsigned int *lv_live;
static int lv_w;                   /* row stride in words, = lv_nw */
#define LV_BUDGET_WORDS 65536   /* fort370: one unit in an 8MB region, docs/FITTING.md */
static unsigned int lv_pool_in[LV_BUDGET_WORDS];
static unsigned int lv_pool_out[LV_BUDGET_WORDS];

static void lv_putn(int n) {       /* decimal to stderr, for the diagnostic */
    char b[12];
    int i;
    i = 11;
    b[i] = 0;
    if (n == 0) { i = i - 1; b[i] = 48; }
    while (n > 0) { i = i - 1; b[i] = 48 + n % 10; n = n / 10; }
    fdputs(b + i, 2);
}
static int lv_cap;                 /* words allocated in lv_in and lv_out each */
static int lv_live_cap;            /* words allocated in lv_live */
static int lv_id[HIR_MAX_INST];    /* inst -> dense id, -1 = untracked */
static int lv_rev[HIR_MAX_INST];   /* dense id -> inst */
static int lv_nid;
static int lv_nw;                  /* words in use: (lv_nid+31)/32 */
static int lv_bstart[HIR_MAX_BLOCK];  /* ra_order index range per block */
static int lv_bend[HIR_MAX_BLOCK];
static int lv_on;

static int lv_tracked(int inst) {
    if (inst < 0) return 0;
    if (lv_id[inst] < 0) return 0;
    return 1;
}

/* Enumerate the register-read operands of one instruction -- the
 * same set the interval builder extends: src1, src2 when it is a
 * reference, the base a BURG fold reaches through (Issue #31), call
 * arguments, and a fused BRC's comparison operands (the compare was
 * NOPed; the branch re-emits it).  PHI arguments are NOT here; they
 * are uses at the end of the predecessor and the dataflow adds them
 * on the edge.  Returns the count in lv_ubuf. */
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
    if (h_src2[inst] >= 0 && ho_src2_is_ref(k)) {
        lv_ubuf[nu] = h_src2[inst];
        nu = nu + 1;
    }
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
        /* Only the int form: the compare is NOPed and re-emitted as a
         * bcond reading its operands here.  A fused fp64 compare CALL
         * stays a real instruction and its reads count at its own
         * site. */
        if (h_kind[cmp] == HI_NOP) {
            if (h_src1[cmp] >= 0) { lv_ubuf[nu] = h_src1[cmp]; nu = nu + 1; }
            if (h_src2[cmp] >= 0) { lv_ubuf[nu] = h_src2[cmp]; nu = nu + 1; }
        }
    }
    return nu;
}

static int lv_is_callkind(int k) {
    return k == HI_CALL || k == HI_CALLP || k == HI_CALLHI ||
           k == HI_A64_DBT_TRAMPOLINE || k == HI_X64_DBT_TRAMPOLINE;
}

/* Transform lv_live from live-out of b to live-in of b. */
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
            lv_live[lv_id[inst] >> 5] =
                lv_live[lv_id[inst] >> 5] & ~(1u << (lv_id[inst] & 31));
        nu = lv_uses(inst);
        j = 0;
        while (j < nu) {
            u = lv_ubuf[j];
            if (lv_tracked(u))
                lv_live[lv_id[u] >> 5] =
                    lv_live[lv_id[u] >> 5] | (1u << (lv_id[u] & 31));
            j = j + 1;
        }
    }
}

/* live-out(b) = union over successors s of live-in(s), plus every phi
 * argument s's phis receive along the b->s edge.  Built into lv_live. */
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
                                lv_live[lv_id[a] >> 5] =
                                    lv_live[lv_id[a] >> 5] | (1u << (lv_id[a] & 31));
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

    /* Dense ids for allocatable values, in ra_order. */
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
    if (lv_nid > GC_MAX_NODE) return;   /* stay on intervals */
    lv_nw = (lv_nid + 31) / 32;
    if (lv_nw == 0) lv_nw = 1;
    lv_w = lv_nw;
    /* Two bitsets of blocks x values: SQLite's sqlite3VdbeExec with
     * asserts on wanted more than the heap holds.  Past the budget the
     * function stays on intervals, like one with too many nodes. */
    if (bb_nblk * lv_w > LV_BUDGET_WORDS) return;
    /* Static, not heap: by code generation the whole file's syntax tree
     * fills the heap (stage07's linker fixes it at 64MB), and SQLite's
     * debug build could not get a 10MB pair from what was left. */
    lv_in = lv_pool_in;
    lv_out = lv_pool_out;
    lv_cap = LV_BUDGET_WORDS;
    if (lv_w > lv_live_cap) {
        if (lv_live) free(lv_live);
        lv_live_cap = lv_w + 256;
        lv_live = malloc(lv_live_cap * 4);
        if (!lv_live) { fdputs("s12cc: out of memory for liveness sets\n", 2); exit(1); }
    }

    /* ra_order index range per block (blocks are contiguous runs). */
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
            if (lv_bend[b] == 0) lv_bstart[b] = i;   /* first entry */
            lv_bend[b] = i + 1;
        }
        i = i + 1;
    }

    /* Backward dataflow to fixpoint, reverse-RPO sweeps. */
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
                if (lv_in[(b * lv_w) + w] != lv_live[w]) {
                    lv_in[(b * lv_w) + w] = lv_live[w];
                    changed = 1;
                }
                w = w + 1;
            }
        }
        sweeps = sweeps + 1;
    }
    if (changed) return;   /* did not converge: stay on intervals */

    lv_on = 1;
}

/* Interference edges and call-crossing marks from exact liveness.
 * One backward walk per block from lv_out.  The dying-src1 exception
 * falls out naturally (a source dead after the instruction is not in
 * the live set), so for the kinds where sharing is NOT known safe the
 * edge is added back explicitly -- the same conservative scope as the
 * interval builder: only ALU/ADDI/COPY may share with a dying src1,
 * everything else keeps all its edges. */
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
                            /* A respilled or unpinned value keeps its
                             * liveness bit but has no node this round. */
                            if (gc_node[lv_rev[(w << 5) + bit]] >= 0)
                                gc_add_edge(ni, gc_node[lv_rev[(w << 5) + bit]]);
                        }
                        bit = bit + 1;
                    }
                    w = w + 1;
                }
                /* Dying uses: only s1 of the single-instruction
                 * three-operand kinds may share the result register. */
                nu = lv_uses(inst);
                j = 0;
                while (j < nu) {
                    u = lv_ubuf[j];
                    if (lv_tracked(u) &&
                        !(lv_live[lv_id[u] >> 5] & (1u << (lv_id[u] & 31)))) {
                        dying_ok = 0;
                        if (u == h_src1[inst] &&
                            ((k >= HI_ADD && k <= HI_SRL) || k == HI_MULH || k == HI_MULHU ||
                             k == HI_ADDI || k == HI_COPY))
                            dying_ok = 1;
                        if (!dying_ok && gc_node[u] >= 0)
                            gc_add_edge(ni, gc_node[u]);
                    }
                    j = j + 1;
                }
            }
            /* Textbook liveness: a call's arguments die at the call and
             * do not cross it.  The emitter used to marshal one move at
             * a time, so a source in r3-r10 was clobbered before it was
             * read (trans1's DLOG(DEXP(X))); arguments were therefore
             * marked crossing.  The parallel-copy sequencer (issue 67)
             * removes that hazard, so mark BEFORE re-adding uses. */
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
                if (lv_tracked(u))
                    lv_live[lv_id[u] >> 5] =
                        lv_live[lv_id[u] >> 5] | (1u << (lv_id[u] & 31));
                j = j + 1;
            }
        }
        /* PHI defs of one block are written by one parallel copy:
         * they must never share a register, live or not. */
        p1 = ssa_phi_head[b];
        while (p1 >= 0) {
            if (h_kind[p1] == HI_PHI && gc_node[p1] >= 0) {
                p2 = ssa_phi_next[p1];
                while (p2 >= 0) {
                    if (h_kind[p2] == HI_PHI && gc_node[p2] >= 0)
                        gc_add_edge(gc_node[p1], gc_node[p2]);
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
        if (hi_has_value(k) && !hi_inst_remat(inst) && k != HI_NOP &&
            !ra_mem_forced[inst]) {
            if (gc_nnode < GC_MAX_NODE) {
                n = gc_nnode;
                gc_inst[n] = inst;
                gc_node[inst] = n;
                gc_adj_head[n] = -1;
                gc_degree[n] = 0;
                gc_alias[n] = n;
                gc_color[n] = -1;
                gc_nmlist_head[n] = -1;
                gc_pair_inst[n] = (ra_pair_of[inst] >= 0) ? inst : -1;
                gc_nnode = gc_nnode + 1;
            }
        }
        i = i + 1;
    }

    if (lv_on) {
        /* Exact per-block liveness: edges and call-crossing marks both
         * come from the same walk (the interval-based crossing pass
         * ran earlier; overwrite its answer with the precise one). */
        i = 0;
        while (i < h_ninst) { ra_crosses_call[i] = 0; i = i + 1; }
        lv_build_edges();
        if (getenv("HIR_RA_DEBUG")) {
            int fsp;
            fsp = 0;
            i = 0;
            while (i < gc_nnode) { if (gc_force_spill[i]) fsp = fsp + 1; i = i + 1; }
            fdputs("RA nodes=", 2);
            fdputuint(2, (unsigned)gc_nnode);
            fdputs(" edges=", 2);
            fdputuint(2, (unsigned)gc_nedge);
            fdputs(" forced=", 2);
            fdputuint(2, (unsigned)fsp);
            fdputc(10, 2);
        }
        return;
    }

    nact = 0;
    i = 0;
    while (i < ra_norder) {
        inst = ra_order[i];
        p = ra_pos[inst];
        ni = gc_node[inst];

        j = 0;
        while (j < nact) {
            aj = act[j];
            if (ra_iend[gc_inst[aj]] < p) {
                nact = nact - 1;
                act[j] = act[nact];
            } else {
                j = j + 1;
            }
        }

        /* Dying-src1 exception (ported from the x64 cross, where it was
         * two-address motivated): a result does NOT interfere with its
         * src1 when src1's live interval ends exactly at this op's
         * position p.  The strict `< p` expiry above keeps such a src
         * active here, which forces a spurious d<->s1 edge and blocks
         * the coalescer — every loop-carried phi (i=i+1, s=s+i) paid a
         * copy per iteration for it.  On SLOW-32 the suppression is
         * sound for the plain ALU range because each of these ops is a
         * single three-operand instruction: both sources are read
         * before the destination is written, so d may share s1's
         * register.  HI_COPY is the same case trivially.  We do NOT
         * suppress d<->s2 (mirrors the x64 rule; keeps the two files'
         * logic identical and avoids auditing every s2 emission). */
        if (ni >= 0) {
            int skip_node;
            skip_node = -1;
            /* DIVERGENCE (f77, port upstream): HI_ADDI (opcode 40)
             * sits outside the contiguous ALU range but is the same
             * single three-operand shape -- and it is exactly what a
             * DO loop's trip decrement emits, so without it every
             * counted loop paid one uncoalesceable copy per
             * iteration. */
            if ((h_kind[inst] >= HI_ADD && h_kind[inst] <= HI_SRL) || h_kind[inst] == HI_MULH || h_kind[inst] == HI_MULHU ||
                h_kind[inst] == HI_ADDI ||
                h_kind[inst] == HI_COPY) {
                int two_s1;
                two_s1 = h_src1[inst];
                if (two_s1 >= 0 && ra_iend[two_s1] <= p)
                    skip_node = gc_node[two_s1];
            }
            j = 0;
            while (j < nact) {
                if (act[j] != skip_node)
                    gc_add_edge(ni, act[j]);
                j = j + 1;
            }
            act[nact] = ni;
            nact = nact + 1;
        }
        i = i + 1;
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

        if (k == HI_COPY) {
            s1 = h_src1[inst];
            if (s1 >= 0) {
                ns1 = gc_node[s1];
                if (ns1 >= 0) gc_add_move(nd, ns1);
            }
        }
        if ((k >= HI_ADD && k <= HI_SRL) || k == HI_MULH || k == HI_MULHU) {
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
                if (gc_wl[peer] != GC_WL_SELECT && gc_wl[peer] != GC_WL_COALESCED) {
                    gc_dec_degree(peer);
                }
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
    if (gc_k(v) < kk) kk = gc_k(v);

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
    if (gc_pair_inst[u] < 0) gc_pair_inst[u] = gc_pair_inst[v];

    e = gc_nmlist_head[v];
    while (e >= 0) {
        gc_add_node_move(u, gc_nmlist_mv[e]);
        e = gc_nmlist_next[e];
    }

    /* Add edges: for each neighbor t of v, add edge(t, u).
     *
     * Always transfer the edge — even when t is on the select stack —
     * because t's color is consulted later via u's adjacency when u
     * itself is colored.  Without the transfer u's adj loses the
     * "must not pick t's color" constraint and can clash with t.
     *
     * Latent under traditional reverse-of-push pop order (high index
     * first, so u colors before t): the asymmetric edge still on t's
     * side via the alias was sufficient.  The two-pass select that
     * colors PARAMs first (or any ordering change) surfaces the bug.
     * This fix (e4681a1d) was ported into the SLOW-32 selfhost IRC. */
    e = gc_adj_head[v];
    while (e >= 0) {
        t = gc_adj_peer[e];
        if (gc_wl[t] != GC_WL_COALESCED) {
            gc_add_edge(t, u);
            if (gc_wl[t] != GC_WL_SELECT) gc_dec_degree(t);
        }
        e = gc_adj_next[e];
    }

    if (gc_degree[u] >= gc_k(u) && gc_wl[u] == GC_WL_FREEZE) {
        gc_wl[u] = GC_WL_SPILL;
    }
}

static int gc_coalesce(void) {
    int mv, u, v, tmp;
    mv = 0;
    while (mv < gc_nmove) {
        if (gc_mv_status[mv] != GC_MV_WORKLIST) { mv = mv + 1; continue; }

        u = gc_get_alias(gc_mv_a[mv]);
        v = gc_get_alias(gc_mv_b[mv]);

        if (ra_crosses_call[gc_inst[v]] && !ra_crosses_call[gc_inst[u]]) {
            tmp = u; u = v; v = tmp;
        }

        if (u == v) {
            gc_mv_status[mv] = GC_MV_COALESCED;
            if (!gc_move_related(u) && gc_degree[u] < gc_k(u) && gc_wl[u] == GC_WL_FREEZE) {
                gc_wl[u] = GC_WL_SIMPLIFY;
            }
            return 1;
        }
        if (gc_has_edge(u, v)) {
            gc_mv_status[mv] = GC_MV_CONSTRAINED;
            if (!gc_move_related(u) && gc_degree[u] < gc_k(u) && gc_wl[u] == GC_WL_FREEZE)
                gc_wl[u] = GC_WL_SIMPLIFY;
            if (!gc_move_related(v) && gc_degree[v] < gc_k(v) && gc_wl[v] == GC_WL_FREEZE)
                gc_wl[v] = GC_WL_SIMPLIFY;
            return 1;
        }
        /* A call-split COPY exists to separate the pre-call half
         * (caller-saved, maybe the ABI arg register) from the
         * post-call half (callee-saved).  Merging them back would
         * undo the split. */
        if (ra_is_csplit[gc_inst[u]] || ra_is_csplit[gc_inst[v]]) {
            gc_mv_status[mv] = GC_MV_CONSTRAINED;
            return 1;
        }
        if (ra_crosses_call[gc_inst[u]] != ra_crosses_call[gc_inst[v]] &&
            !gc_mv_phi[mv]) {
            /* DIVERGENCE (f77): a phi move may coalesce across the
             * crossing mismatch -- u is the crossing node (swapped
             * above), so the merged node keeps the callee-saved
             * palette and correctness is unchanged; the non-crossing
             * value merely lives in the register it was going to be
             * copied into anyway. */
            gc_mv_status[mv] = GC_MV_CONSTRAINED;
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
                    if (!gc_move_related(other) && gc_degree[other] < gc_k(other) &&
                        gc_wl[other] == GC_WL_FREEZE) {
                        gc_wl[other] = GC_WL_SIMPLIFY;
                    }
                }
                e = gc_nmlist_next[e];
            }
            return 1;
        }
        n = n + 1;
    }
    return 0;
}

/* DIVERGENCE (f77, port upstream): dynamic-use estimate for the spill
 * cost.  bg_uses is a STATIC count; a value touched twice in an
 * innermost loop looked exactly as cheap to spill as an entry-block
 * temp, and a rotated loop's IV/trip phis went to stack slots while
 * the slow parallel-copy path pushed the rest -- +71% on mandel.
 * Each USE is weighted 1/10/100/1000 by its block's natural-loop
 * nesting depth (licm_depth, computed during LICM), and the def adds
 * its own weight (a spilled def pays its store where it is defined). */
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
        if (h_src2[i] >= 0 && ho_src2_is_ref(k))
            ra_wuses[h_src2[i]] = ra_wuses[h_src2[i]] + w;
        if ((k == HI_CALL || k == HI_CALLP) && h_cbase[i] >= 0) {
            base = h_cbase[i];
            cnt = h_val[i];
            j = 0;
            while (j < cnt) {
                if (h_carg[base + j] >= 0)
                    ra_wuses[h_carg[base + j]] = ra_wuses[h_carg[base + j]] + w;
                j = j + 1;
            }
        }
        if (k == HI_PHI && h_pbase[i] >= 0) {
            j = 0;
            while (j < h_pcnt[i]) {
                if (h_pval[h_pbase[i] + j] >= 0)
                    ra_wuses[h_pval[h_pbase[i] + j]] =
                        ra_wuses[h_pval[h_pbase[i] + j]] + w;
                j = j + 1;
            }
        }
        if (hi_has_value(k))
            ra_wuses[i] = ra_wuses[i] + w;
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
            /* cost = weighted uses * 100 / (degree + 1).  Lower =
             * cheaper to spill.  Non-call-crossing values get a +50
             * penalty in the cost (making them *less* likely to be
             * chosen for spill) because they have access to the larger
             * color pool and are easier to color if left in simplify. */
            cost = (ra_wuses[inst] * 100) / (gc_degree[n] + 1);
            if (!ra_crosses_call[inst]) cost = cost + 50;
            /* DIVERGENCE (f77, port upstream): a pinned loop constant
             * (hcg_mark_loop_consts) is the CHEAPEST possible spill --
             * losing its register just reverts it to rematerialization
             * (writeback clears h_no_remat), no slot, no loads.  Prefer
             * it over anything that would pay real memory traffic. */
            if (h_kind[inst] == HI_ICONST && h_no_remat[inst]) cost = 0;
            if (cost < best_cost) {
                best_cost = cost;
                best = n;
            }
        }
        n = n + 1;
    }
    if (best < 0) return 0;

    /* Optimistic spill: move the chosen node back to simplify and let the
     * main IRC loop try to color it later (after more coalescing/simplification).
     * Its moves are frozen so we stop trying to coalesce them. */
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
                if (!gc_move_related(other) && gc_degree[other] < gc_k(other) &&
                    gc_wl[other] == GC_WL_FREEZE) {
                    gc_wl[other] = GC_WL_SIMPLIFY;
                }
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
    /* When the loop terminates we have either colored everything or
     * the remaining spill worklist nodes will be forced to spill in
     * gc_select / gc_writeback via gc_force_spill or degree >= K. */
}

/* --- fp64 pair preference (DIVERGENCE from selfhost, fortran/ only) ---
 *
 * fadd.d and friends address a register PAIR (r_n, r_n+1) with n even.
 * Nothing in the IR says which two values form a double, so the
 * allocator scatters the halves and the emitter pays ~8 moves per
 * operation shuffling them into the fixed r4:r5 / r6:r7 pair.
 *
 * ra_pair_of[v] records the partner of a value that is half of an fp64
 * pair, and ra_pair_lo[v] which half it is.  gc_select then PREFERS a
 * colour adjacent to an already-coloured partner.  It is only a
 * preference: when it cannot be honoured the emitter falls back to the
 * moves, so this can never produce wrong code -- only fewer or more
 * instructions. */
static int hcg_fp64_kind(char *nm);   /* defined in hir_codegen.h */

static int ra_stat_pair_pref;
static int ra_pair_share_fate = 1;
static int ra_pair_of[HIR_MAX_INST];
static int ra_pair_lo[HIR_MAX_INST];

static void ra_build_pairs(void) {
    int i;
    int base;
    int n;
    i = 0;
    while (i < h_ninst) { ra_pair_of[i] = -1; ra_pair_lo[i] = 0; i = i + 1; }

    i = 0;
    while (i < h_ninst) {
        if (h_kind[i] == HI_CALL && hcg_fp64_kind(h_name[i]) >= 0) {
            base = h_cbase[i];
            n = h_val[i];
            if (base >= 0 && n >= 2) {
                int a;
                int b;
                a = h_carg[base + 0];
                b = h_carg[base + 1];
                if (a >= 0 && b >= 0) {
                    ra_pair_of[a] = b; ra_pair_lo[a] = 1;
                    ra_pair_of[b] = a; ra_pair_lo[b] = 0;
                }
                if (n >= 4) {
                    a = h_carg[base + 2];
                    b = h_carg[base + 3];
                    if (a >= 0 && b >= 0) {
                        ra_pair_of[a] = b; ra_pair_lo[a] = 1;
                        ra_pair_of[b] = a; ra_pair_lo[b] = 0;
                    }
                }
            }
            /* The result pair: the CALL is the lo word, its CALLHI the hi. */
            if (i + 1 < h_ninst && h_kind[i + 1] == HI_CALLHI &&
                h_src1[i + 1] == i) {
                ra_pair_of[i] = i + 1; ra_pair_lo[i] = 1;
                ra_pair_of[i + 1] = i; ra_pair_lo[i + 1] = 0;
            }
        }
        i = i + 1;
    }
}

/* DIVERGENCE (f77, port upstream): the buddy colour completing an
 * aligned physical pair with c, or -1.  Used to steer SINGLES away
 * from virgin pairs: a single placed into an untouched aligned pair
 * fragments it for every later fp64 claim. */
static int ra_color_buddy(int c) {
    int p0;
    p0 = ra_get_phys(c);
    if (p0 < 0) return -1;
    if ((p0 & 1) == 0) {
        if (p0 + 1 < 31 && ra_get_phys(c + 1) == p0 + 1) return c + 1;
        return -1;
    }
    if (c > 0 && ra_get_phys(c - 1) == p0 - 1) return c - 1;
    return -1;
}

/* First free colour in [lo, hi), preferring one that does NOT break a
 * virgin aligned pair (its buddy already used or nonexistent). */
static int ra_first_free_pairfriendly(int lo, int hi, int *used) {
    int c;
    int cany;
    int b;
    cany = -1;
    c = lo;
    while (c < hi) {
        if (!used[c]) {
            if (cany < 0) cany = c;
            b = ra_color_buddy(c);
            if (b < 0 || b >= hi || used[b]) return c;
        }
        c = c + 1;
    }
    return cany;
}

/* Pinned colour for a node whose fp64 partner already claimed a pair.
 * -1 = unpinned.  A pin is honoured only if it is still conflict-free
 * for the pinned node's own neighbours, so it can never colour two
 * interfering values the same. */
static int gc_pin[GC_MAX_NODE];

/* DIVERGENCE (f77, port upstream): pair identity at NODE level.
 * ra_pair_of marks INSTRUCTIONS, but coalescing merges nodes -- a phi
 * half coalesced with its fp64 argument must keep the pair identity,
 * and the partner must be looked up through gc_get_alias, or the pin
 * lands on a node that is never selected and the pair misaligns into
 * scratch shuffles.  gc_pair_inst[n] is a pair-marked member
 * instruction of node n (or -1), propagated in gc_combine. */
static int gc_pair_inst[GC_MAX_NODE];

/* Claim an aligned register pair for `inst` and pin its partner to the
 * other half.  Returns this node's colour, or -1.
 *
 * The earlier version only looked for an ALREADY-coloured partner,
 * which never fired: select colours one node at a time and the partner
 * is almost always still uncoloured (measured: 33 misses, 0 hits). */
static int ra_pc_dbg[6];
static int ra_pair_claim(int n, int inst, int maxc, int *used) {
    int partner;
    int pn;
    int c;
    int lo_c;
    int hi_c;
    int pinst;

    pinst = gc_pair_inst[n];
    if (pinst < 0) return -1;
    partner = ra_pair_of[pinst];
    if (partner < 0) return -1;
    ra_pc_dbg[0]++;                       /* had a partner */
    pn = gc_node[partner];
    if (pn < 0) { ra_pc_dbg[1]++; return -1; }        /* partner not a node */
    pn = gc_get_alias(pn);
    if (pn == n) { ra_pc_dbg[1]++; return -1; }       /* degenerate merge */
    if (gc_color[pn] >= 0) { ra_pc_dbg[2]++; return -1; }

    c = 0;
    while (c + 1 < maxc) {
        int p0;
        int p1;
        p0 = ra_get_phys(c);
        p1 = ra_get_phys(c + 1);
        if (p0 >= 0 && p1 == p0 + 1 && (p0 & 1) == 0 && p0 + 1 < 31 &&
            !used[c] && !used[c + 1]) {
            if (ra_pair_lo[pinst]) { lo_c = c; hi_c = c + 1; }
            else                   { lo_c = c + 1; hi_c = c; }
            /* Respect the caller/callee split for both halves, judged
             * on the merged nodes' representatives. */
            if (lo_c >= ra_ncal && !ra_prefers_caller_for_inst(gc_inst[n]))
                { c = c + 1; continue; }
            if (hi_c >= ra_ncal && !ra_prefers_caller_for_inst(gc_inst[pn]))
                { c = c + 1; continue; }
            gc_pin[pn] = hi_c;
            ra_pc_dbg[4]++;
            return lo_c;
        }
        c = c + 1;
    }
    ra_pc_dbg[3]++;                       /* no free aligned pair */
    return -1;
}

static void gc_select(void) {
    int i, n, inst, e, peer, pa, pc, c;
    int used[RA_NPHY_TOTAL];
    int maxc;
    int pass;

    /* Two-pass color: PARAMs first, then everything else.
     *
     * Why: gc_simplify pushes nodes in gc_node-INDEX order (low index
     * first), so the select-stack pops them with high index first and
     * low index last.  PARAM nodes are typically created early (low
     * gc_node index) in hir_lower and therefore pop LAST under the
     * natural single-pass order — by which point temporaries have
     * already taken slots in the cheap r3-r10 caller pool.
     *
     * This defeats the PARAM preferred-color bias we just added.
     *
     * Fix: walk the select stack twice.  First pass colors only
     * HI_PARAM nodes (seeding their exact ABI registers r3+N when
     * possible).  Second pass colors the rest.  The used[] mask from
     * the first pass naturally protects the preferred registers for
     * the second pass.
     *
     * Pop direction (high index first) is unchanged within each pass.
     * This is the same technique used in the x64 and a64 backends
     * after the edge-transfer robustness work.
     */
    /* Three passes.  Parameters first (they have a preferred ABI
     * register), then fp64 PAIRS, then everything else.
     *
     * Pairs go before singles because an aligned pair needs two
     * ADJACENT free colours, and singles scattered through the file
     * destroy those far faster than they consume capacity.  Measured on
     * the mandel kernel before this change: of 30 pair claims, 12
     * failed purely for want of a free aligned pair, against 10 that
     * succeeded. */
    pass = 0;
    while (pass < 3) {

        i = gc_nsel - 1;
        while (i >= 0) {
            n = gc_sel_stk[i];
            inst = gc_inst[n];
            maxc = ra_num_active_slots();

            int k = h_kind[inst];

            /* Skip nodes that do not belong in this pass */
            if (pass == 0 && h_kind[inst] != HI_PARAM) { i = i - 1; continue; }
            if (pass == 1 && (h_kind[inst] == HI_PARAM ||
                              gc_pair_inst[n] < 0)) { i = i - 1; continue; }
            if (pass == 2 && (h_kind[inst] == HI_PARAM ||
                              gc_pair_inst[n] >= 0)) { i = i - 1; continue; }

            /* Zero only the active portion of the used[] mask */
            c = 0;
            while (c < maxc) { used[c] = 0; c = c + 1; }

            e = gc_adj_head[n];
            while (e >= 0) {
                peer = gc_adj_peer[e];
                pa = gc_get_alias(peer);
                pc = gc_color[pa];
                if (pc >= 0 && pc < maxc) used[pc] = 1;
                e = gc_adj_next[e];
            }

            gc_color[n] = -1;

            /* fp64 pairs, tried before src1 reuse.  Either honour a
             * pin left by this value's partner, or claim a fresh
             * aligned pair and pin the partner to the other half, so
             * the emitter can name the pair directly instead of
             * shuffling it through r4:r5. */
            if (gc_color[n] < 0 && gc_pin[n] >= 0 && gc_pin[n] < maxc &&
                !used[gc_pin[n]]) {
                gc_color[n] = gc_pin[n];
                ra_stat_pair_pref = ra_stat_pair_pref + 1;
            }
            if (gc_color[n] < 0) {
                int pw;
                pw = ra_pair_claim(n, inst, maxc, used);
                if (pw >= 0) {
                    gc_color[n] = pw;
                    ra_stat_pair_pref = ra_stat_pair_pref + 1;
                } else if (gc_pair_inst[n] >= 0 && ra_pair_share_fate) {
                    /* SHARE FATE.  Colouring the halves of a double
                     * independently is the worst outcome available: one
                     * lands in a register and the other spills, so the
                     * code pays spill traffic AND the moves to rebuild
                     * the pair in scratch.  If the pair cannot be
                     * placed, leave BOTH in memory -- the emitter then
                     * loads them into its scratch pair directly.  This
                     * is the property a real pair register class gives
                     * for free: allocated together, or spilled
                     * together. */
                    i = i - 1;
                    continue;
                }
            }

            /* Argument-register targeting (issue 67) before src1 reuse. */
            if (gc_color[n] < 0) {
                int ap2;
                ap2 = ra_argsite_preferred_color(inst);
                if (ap2 >= 0 && ap2 < maxc && !used[ap2])
                    gc_color[n] = ap2;
            }

            /* Src1 reuse for destructive binary ops.
             * For ADD, SUB, AND, OR, XOR, shifts, etc. the result can
             * usually live in the same physical register as the first
             * operand.  Trying src1's color first (if free) reduces
             * unnecessary copies in expressions.
             */
            if (gc_color[n] < 0) {
                if (ra_can_reuse_src1(k)) {
                    int s1 = h_src1[inst];
                    if (s1 >= 0) {
                        int s1_node = gc_node[s1];
                        if (s1_node >= 0) {
                            int col = gc_color[s1_node];
                            /* A call-crossing value must not inherit a
                             * caller-saved color from its operand — the
                             * call clobbers r3-r10 (W_LumpNameHash's
                             * xor temp died across toupper()). */
                            if (col >= ra_ncal &&
                                !ra_prefers_caller_for_inst(inst)) col = -1;
                            if (col >= 0 && col < maxc && !used[col]) {
                                gc_color[n] = col;
                                ra_stat_operand_reuse = ra_stat_operand_reuse + 1;
                                if (k == HI_ADDI) {
                                    ra_stat_imm_base_reuse = ra_stat_imm_base_reuse + 1;
                                }
                            }
                        }
                    }
                }

                /* Secondary operand preference for commutative ops.
                 * Consider both src1 and src2 and pick the one with the
                 * lowest physical register number (cheap tie-breaker that
                 * tends to keep lower caller registers free).
                 * This runs for all values, not just caller-saved.
                 */
                if (gc_color[n] < 0 &&
                    (k == HI_ADD || k == HI_AND || k == HI_OR || k == HI_XOR))
                {
                    int best_col = -1;
                    int best_phys = 999;
                    int best_is_src2 = 0;

                    // consider src1
                    int s1 = h_src1[inst];
                    if (s1 >= 0) {
                        int s1_node = gc_node[s1];
                        if (s1_node >= 0) {
                            int col = gc_color[s1_node];
                            if (col >= ra_ncal &&
                                !ra_prefers_caller_for_inst(inst)) col = -1;
                            if (col >= 0 && col < maxc && !used[col]) {
                                int phys = ra_get_phys(col);
                                if (phys < best_phys) {
                                    best_col = col;
                                    best_phys = phys;
                                    best_is_src2 = 0;
                                }
                            }
                        }
                    }

                    // consider src2 (may displace src1 if its phys is lower)
                    int s2 = h_src2[inst];
                    if (s2 >= 0) {
                        int s2_node = gc_node[s2];
                        if (s2_node >= 0) {
                            int col = gc_color[s2_node];
                            if (col >= ra_ncal &&
                                !ra_prefers_caller_for_inst(inst)) col = -1;
                            if (col >= 0 && col < maxc && !used[col]) {
                                int phys = ra_get_phys(col);
                                if (phys < best_phys) {
                                    best_col = col;
                                    best_phys = phys;
                                    best_is_src2 = 1;
                                }
                            }
                        }
                    }

                    if (best_col != -1) {
                        gc_color[n] = best_col;
                        ra_stat_operand_reuse = ra_stat_operand_reuse + 1;
                        if (best_is_src2) {
                            ra_stat_src2_reuse = ra_stat_src2_reuse + 1;
                        }
                        ra_stat_secondary_reuse = ra_stat_secondary_reuse + 1;
                    }
                }
            }

            /* Two-phase color selection (classification hook) + PARAM bias.
             *
             * Because of the outer two-pass, when we reach a non-PARAM
             * in pass 1 the preferred ABI registers for PARAMs are already
             * marked used, so temporaries naturally avoid stealing them.
             */
            if (ra_prefers_caller_for_inst(inst)) {
                int best_col;
                int best_phys;
                int best_is_src2;
                int ap;
                /* Argument-register targeting (issue 67) before src1 reuse:
                 * `u = x + 1` feeding argument 0 used to inherit x's
                 * register and skip the ABI preference. */
                if (gc_color[n] < 0) {
                    ap = ra_argsite_preferred_color(inst);
                    if (ap >= 0 && ap < maxc && !used[ap])
                        gc_color[n] = ap;
                }
                /* Operand reuse in the cheap caller-saved pool, then
                 * PARAM ABI preference. */
                best_col = -1;
                best_phys = 999;
                best_is_src2 = 0;

                if (ra_can_reuse_src1(k)) {
                    int s1 = h_src1[inst];
                    if (s1 >= 0) {
                        int s1_node = gc_node[s1];
                        if (s1_node >= 0) {
                            int col = gc_color[s1_node];
                            if (col >= ra_ncal && col < maxc && !used[col]) {
                                int phys = ra_get_phys(col);
                                if (phys < best_phys) {
                                    best_col = col;
                                    best_phys = phys;
                                    best_is_src2 = 0;
                                }
                            }
                        }
                    }
                }

                if ((k == HI_ADD || k == HI_AND || k == HI_OR || k == HI_XOR)) {
                    int s2 = h_src2[inst];
                    if (s2 >= 0) {
                        int s2_node = gc_node[s2];
                        if (s2_node >= 0) {
                            int col = gc_color[s2_node];
                            if (col >= ra_ncal && col < maxc && !used[col]) {
                                int phys = ra_get_phys(col);
                                if (phys < best_phys) {
                                    best_col = col;
                                    best_phys = phys;
                                    best_is_src2 = 1;
                                }
                            }
                        }
                    }
                }

                if (best_col != -1) {
                    gc_color[n] = best_col;
                    ra_stat_operand_reuse = ra_stat_operand_reuse + 1;
                    if (best_is_src2) {
                        ra_stat_src2_reuse = ra_stat_src2_reuse + 1;
                    }
                    ra_stat_secondary_reuse = ra_stat_secondary_reuse + 1;
                    if (k == HI_ADDI) {
                        /* ADDI is non-commutative — best_is_src2 is always 0 here,
                         * so this fires iff the ADDI base register was actually reused. */
                        ra_stat_imm_base_reuse = ra_stat_imm_base_reuse + 1;
                    }
                }

                /* If operand reuse didn't find anything, fall back to PARAM
                 * preferred color (still in the cheap pool).
                 */
                if (gc_color[n] < 0) {
                    int pref = ra_param_preferred_color(inst);
                    if (pref >= ra_ncal && pref < maxc && !used[pref]) {
                        gc_color[n] = pref;
                        ra_stat_param_preferred = ra_stat_param_preferred + 1;
                    }
                }

                /* Final fallback: generic first-free in caller range,
                 * but with a bias toward operand colors when possible.
                 * This gives the hints one last chance even if the early
                 * strong attempts didn't find a completely free slot.
                 */
                if (gc_color[n] < 0) {
                    /* First, try to pick a free caller color that belongs to
                     * an operand we can reuse (src1, and src2 for commutative).
                     * This is the "biased selection" pass.
                     */
                    int biased = -1;
                    int biased_is_src2 = 0;
                    if (ra_can_reuse_src1(k)) {
                        int s1 = h_src1[inst];
                        if (s1 >= 0) {
                            int s1_node = gc_node[s1];
                            if (s1_node >= 0) {
                                int col = gc_color[s1_node];
                                if (col >= ra_ncal && col < maxc && !used[col]) {
                                    biased = col;
                                    biased_is_src2 = 0;
                                }
                            }
                        }
                    }
                    if (biased < 0 &&
                        (k == HI_ADD || k == HI_AND || k == HI_OR || k == HI_XOR))
                    {
                        int s2 = h_src2[inst];
                        if (s2 >= 0) {
                            int s2_node = gc_node[s2];
                            if (s2_node >= 0) {
                                int col = gc_color[s2_node];
                                if (col >= ra_ncal && col < maxc && !used[col]) {
                                    biased = col;
                                    biased_is_src2 = 1;
                                }
                            }
                        }
                    }

                    if (biased >= 0) {
                        gc_color[n] = biased;
                        ra_stat_operand_reuse = ra_stat_operand_reuse + 1;
                        if (biased_is_src2) {
                            ra_stat_src2_reuse = ra_stat_src2_reuse + 1;
                        }
                        ra_stat_secondary_reuse = ra_stat_secondary_reuse + 1;
                    } else {
                        /* No biased color available — first-free, but
                         * pair-friendly: keep virgin aligned pairs whole. */
                        gc_color[n] = ra_first_free_pairfriendly(ra_ncal, maxc, used);
                    }
                }
            }

            if (gc_color[n] < 0) {
                int pref = ra_param_preferred_color(inst);
                if (pref >= 0 && pref < ra_ncal && !used[pref]) {
                    gc_color[n] = pref;
                    ra_stat_param_preferred = ra_stat_param_preferred + 1;
                } else {
                    /* Pair-friendly first-free in the callee pool. */
                    gc_color[n] = ra_first_free_pairfriendly(0, ra_ncal, used);
                }
            }

            if (s12cc_dump_intervals && gc_color[n] >= ra_ncal &&
                ra_crosses_call[inst]) {
                fdputs("XVIOL select inst=", 2);
                ra_dump_signed(inst);
                fdputc(10, 2);
            }
            if (gc_color[n] < 0) gc_wl[n] = GC_WL_SPILL;

            i = i - 1;
        }
        pass = pass + 1;
    }

    /* Propagate colors to coalesced nodes (ported from the x64 cross).
     * A coalesced node is never selected, so without this it keeps
     * color -1 and gc_writeback hands it to the spiller.  Unreachable
     * before the backprop liveness fix (no move ever coalesced). */
    i = 0;
    while (i < gc_nnode) {
        if (gc_wl[i] == GC_WL_COALESCED) {
            gc_color[i] = gc_color[gc_get_alias(i)];
            if (s12cc_dump_intervals && ra_crosses_call[gc_inst[i]] &&
                gc_color[i] >= ra_ncal) {
                fdputs("XVIOL coalesce inst=", 2);
                ra_dump_signed(gc_inst[i]);
                fdputs(" rep=", 2);
                ra_dump_signed(gc_inst[gc_get_alias(i)]);
                fdputc(10, 2);
            }
        }
        i = i + 1;
    }

    /* Post-coloring PARAM fix-up (ported from the x64 cross): if a
     * PARAM didn't get its ABI register and no neighbor holds that
     * color, take it — a param sitting in its incoming register costs
     * zero prologue moves, and params displaced from their homes are
     * how entry-move permutations (see ra_demote_conflicted_params)
     * arise in the first place.  Iterate: a PARAM blocked by another
     * PARAM may unblock once that one moves to its own want. */
    {
        int n2;
        int inst2;
        int want;
        int conflict;
        int ei;
        int pa;
        int moved;
        int passes;

        passes = 0;
        moved = 1;
        while (moved && passes < 8) {
            moved = 0;
            passes = passes + 1;
            n2 = 0;
            while (n2 < gc_nnode) {
                inst2 = gc_inst[n2];
                if (h_kind[inst2] == HI_PARAM && gc_color[n2] >= 0) {
                    want = ra_param_preferred_color(inst2);
                    if (want >= 0 && gc_color[n2] != want) {
                        conflict = 0;
                        ei = gc_adj_head[n2];
                        while (ei >= 0) {
                            pa = gc_get_alias(gc_adj_peer[ei]);
                            if (gc_color[pa] == want) {
                                conflict = 1;
                                break;
                            }
                            ei = gc_adj_next[ei];
                        }
                        if (!conflict) {
                            gc_color[n2] = want;
                            moved = 1;
                        }
                    }
                }
                n2 = n2 + 1;
            }
        }
    }
}

static void gc_writeback(void) {
    int i, n, inst, c, phys;

    i = 0;
    while (i < RA_NPHY_TOTAL) { ra_used[i] = 0; i = i + 1; }
    i = 0;
    while (i < h_ninst) { ra_reg[i] = -1; i = i + 1; }

    n = 0;
    while (n < gc_nnode) {
        inst = gc_inst[n];
        c = gc_color[n];
        if (gc_force_spill[n]) c = -1;

        if (c >= 0) {
            /* Color-to-physical mapping now goes through the classification table.
             * When caller-saved colors (18+) are handed out, ra_get_phys(c) will
             * return r3..r10 instead of the old linear r11.. formula. */
            phys = ra_get_phys(c);
            ra_reg[inst] = phys;
            if (phys >= 0) ra_used[c] = 1;

            /* Record class usage for diagnostics */
            if (c >= ra_ncal)
                ra_stat_caller_used = ra_stat_caller_used + 1;
            else
                ra_stat_callee_used = ra_stat_callee_used + 1;
            if (phys == 30) ra_stat_r30 = ra_stat_r30 + 1;
        } else {
            /* Uncolored pinned loop constant: revert to remat rather
             * than taking a frame slot -- every use materializes it
             * inline (the phi-copy fast path handles wide constants
             * via hcg_li), and the register it was competing for goes
             * to a value that actually needs one. */
            if (h_kind[inst] == HI_ICONST && h_no_remat[inst]) {
                h_no_remat[inst] = 0;
            } else if (getenv("HIR_RA_DEBUG")) {
                fdputs("SPILL inst=", 2);
                fdputuint(2, (unsigned)inst);
                fdputs(" kind=", 2);
                fdputuint(2, (unsigned)h_kind[inst]);
                fdputs(" blk=", 2);
                fdputuint(2, (unsigned)h_blk[inst]);
                fdputs(" depth=", 2);
                if (h_blk[inst] >= 0 && h_blk[inst] < bb_nblk)
                    fdputuint(2, (unsigned)licm_depth[h_blk[inst]]);
                else
                    fdputs("-1", 2);
                fdputs(" wuses=", 2);
                fdputuint(2, (unsigned)ra_wuses[inst]);
                fdputs(" deg=", 2);
                fdputuint(2, (unsigned)gc_degree[n]);
                fdputc(10, 2);
            }
        }
        n = n + 1;
    }
}

/* =================================================================
 * Iterated spilling (DIVERGENCE f77, port upstream candidate)
 *
 * gc_select's optimistic coloring means a coloring FAILURE lands on
 * whichever node happens to pop with its palette exhausted -- which
 * under real pressure is usually a value deep in the hottest loop,
 * not the cheapest one (the inlined DGEFA spilled its daxpy pointer
 * IVs, weight 3000, while weight-11 setup values kept registers).
 * Chaitin's answer: when a node fails, spill the CHEAPEST value in
 * its conflict neighborhood instead, rebuild the graph without it,
 * and color again.  Spilled values keep the existing memory model
 * (reload at use), so no new instructions or nodes appear; a pinned
 * constant victim is unpinned back to remat instead, and a pair half
 * takes its partner along (share fate).
 * ================================================================= */
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
        if (gc_color[n] < 0 || gc_force_spill[n]) {
            /* Cheapest of the failed node and its neighbors. */
            best = n;
            bcost = ra_wuses[gc_inst[n]];
            if (h_kind[gc_inst[n]] == HI_ICONST && h_no_remat[gc_inst[n]])
                bcost = 0;
            e = gc_adj_head[n];
            while (e >= 0) {
                a = gc_get_alias(gc_adj_peer[e]);
                inst = gc_inst[a];
                if (!ra_mem_forced[inst]) {
                    cost = ra_wuses[inst];
                    if (h_kind[inst] == HI_ICONST && h_no_remat[inst])
                        cost = 0;
                    if (cost < bcost) { best = a; bcost = cost; }
                }
                e = gc_adj_next[e];
            }
            inst = gc_inst[best];
            if (!ra_mem_forced[inst]) {
                if (h_kind[inst] == HI_ICONST && h_no_remat[inst]) {
                    h_no_remat[inst] = 0;   /* back to remat, no slot */
                } else {
                    ra_mem_forced[inst] = 1;
                }
                if (ra_pair_of[inst] >= 0) {
                    a = ra_pair_of[inst];
                    if (h_kind[a] == HI_ICONST && h_no_remat[a])
                        h_no_remat[a] = 0;
                    else
                        ra_mem_forced[a] = 1;
                }
                nv = nv + 1;
                if (getenv("HIR_RA_DEBUG")) {
                    fdputs("RESPILL victim=", 2);
                    fdputuint(2, (unsigned)inst);
                    fdputs(" wuses=", 2);
                    fdputuint(2, (unsigned)ra_wuses[inst]);
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
        /* Node ids are reassigned every build; a pair pin left by the
         * previous round would point at an unrelated node. */
        { int z; z = 0; while (z < GC_MAX_NODE) { gc_pin[z] = -1; z = z + 1; } }
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

static void ra_mark_call_crossing(void) {
    int i, j, inst, k, p, nact;
    int act[HIR_MAX_INST];   /* active instruction indices (the values themselves) */

    /* Clear */
    i = 0;
    while (i < h_ninst) { ra_crosses_call[i] = 0; i = i + 1; }

    nact = 0;
    i = 0;
    while (i < ra_norder) {
        inst = ra_order[i];
        p = ra_pos[inst];
        k = h_kind[inst];

        /* Expire anything whose live range ended before this position */
        j = 0;
        while (j < nact) {
            int v = act[j];
            if (ra_iend[v] < p) {
                nact = nact - 1;
                act[j] = act[nact];
            } else {
                j = j + 1;
            }
        }

        /* If this program point is a call, every value still live here
         * crosses the call site and must not be allocated to a caller-saved
         * register (r3-r10 are clobbered by the call). */
        if (k == HI_CALL || k == HI_CALLP || k == HI_CALLHI ||
            k == HI_A64_DBT_TRAMPOLINE || k == HI_X64_DBT_TRAMPOLINE) {

            j = 0;
            while (j < nact) {
                int v = act[j];
                if (v >= 0 && v < h_ninst) {
                    ra_crosses_call[v] = 1;
                }
                j = j + 1;
            }
        }

        /* If this instruction produces a tracked value, add it to the active set.
         * We use the same predicate that gc_build uses — the INSTRUCTION-level
         * remat query, so a promoted (h_no_remat) constant is tracked here too;
         * missing it colored call-crossing constants from the caller-saved pool
         * and they died at the first call (found via ssa_insert_phis's 32768
         * bound landing in r6). */
        if (hi_has_value(k) && !hi_inst_remat(inst) && k != HI_NOP) {
            if (nact < HIR_MAX_INST) {
                act[nact] = inst;
                nact = nact + 1;
            }
        }

        i = i + 1;
    }
}

static void ra_after_mark(int v) {
    if (v >= 0 && v < HIR_MAX_INST) ra_after_stamp[v] = ra_after_tick;
}

static int ra_after_has(int v) {
    if (v < 0 || v >= HIR_MAX_INST) return 0;
    return ra_after_stamp[v] == ra_after_tick;
}

/* nw < 0: mark uses.  nw >= 0: rewrite old -> nw. */
static void ra_csplit_on_inst(int i, int old, int nw) {
    int j;
    int n;
    int base;
    int sp;
    if (nw < 0) {
        if (h_src1[i] >= 0) ra_after_mark(h_src1[i]);
        if (h_src2[i] >= 0 && ho_src2_is_ref(h_kind[i]))
            ra_after_mark(h_src2[i]);
    } else {
        if (h_src1[i] == old) h_src1[i] = nw;
        if (h_src2[i] == old && ho_src2_is_ref(h_kind[i])) h_src2[i] = nw;
    }
    if ((h_kind[i] == HI_CALL || h_kind[i] == HI_CALLP) &&
        h_cbase[i] >= 0) {
        n = h_val[i];
        base = h_cbase[i];
        j = 0;
        while (j < n) {
            if (nw < 0) ra_after_mark(h_carg[base + j]);
            else if (h_carg[base + j] == old) h_carg[base + j] = nw;
            j = j + 1;
        }
    }
    sp = ra_csplit_head[i];
    while (sp >= 0) {
        if (nw < 0) ra_after_mark(h_src1[sp]);
        else if (h_src1[sp] == old) h_src1[sp] = nw;
        sp = ra_csplit_next[sp];
    }
}

/* Phi args on edges that are after the call: the predecessor is the
 * call block, or is strictly dominated by it (every path through that
 * pred already went through the call). */
static void ra_csplit_on_phis(int b, int cb, int old, int nw) {
    int phi;
    int j;
    int pred;
    int a;
    phi = ssa_phi_head[b];
    while (phi >= 0) {
        if (h_kind[phi] == HI_PHI && h_pbase[phi] >= 0) {
            j = 0;
            while (j < h_pcnt[phi]) {
                pred = h_pblk[h_pbase[phi] + j];
                if (pred == cb ||
                    (pred >= 0 && pred < bb_nblk &&
                     licm_dominates(cb, pred))) {
                    a = h_pval[h_pbase[phi] + j];
                    if (nw < 0) {
                        if (a >= 0) ra_after_mark(a);
                    } else if (a == old) {
                        h_pval[h_pbase[phi] + j] = nw;
                    }
                }
                j = j + 1;
            }
        }
        phi = ssa_phi_next[phi];
    }
}

/* Blocks strictly dominated by the call's block: every path to them
 * went through the call, so uses there are after-uses.  A miss used
 * to cost the split (V stayed live-out and still crossed) rather
 * than correctness. */
static void ra_csplit_on_dom(int cb, int old, int nw) {
    int nwl;
    int i;
    int b;
    int inst;
    nwl = 0;
    i = 0;
    while (i < ssa_dtc_cnt[cb] && nwl < HIR_MAX_BLOCK) {
        ra_dom_wl[nwl] = ssa_dtc[ssa_dtc_base[cb] + i];
        nwl = nwl + 1;
        i = i + 1;
    }
    while (nwl > 0) {
        nwl = nwl - 1;
        b = ra_dom_wl[nwl];
        if (b >= 0 && b < bb_nblk) {
            inst = bb_start[b];
            while (inst < bb_end[b]) {
                ra_csplit_on_inst(inst, old, nw);
                inst = inst + 1;
            }
            ra_csplit_on_phis(b, cb, old, nw);
            i = 0;
            while (i < ssa_dtc_cnt[b] && nwl < HIR_MAX_BLOCK) {
                ra_dom_wl[nwl] = ssa_dtc[ssa_dtc_base[b] + i];
                nwl = nwl + 1;
                i = i + 1;
            }
        }
    }
}

static void ra_mark_after_uses(int call) {
    int i;
    int si;
    int s;
    int cb;
    ra_after_tick = ra_after_tick + 1;
    if (ra_after_tick <= 0) {
        i = 0;
        while (i < HIR_MAX_INST) { ra_after_stamp[i] = 0; i = i + 1; }
        ra_after_tick = 1;
    }
    cb = h_blk[call];
    if (cb < 0) return;
    i = call + 1;
    while (i < bb_end[cb]) {
        ra_csplit_on_inst(i, -1, -1);
        i = i + 1;
    }
    si = 0;
    while (si < ssa_nsucc[cb]) {
        s = ssa_succ[ssa_soff[cb] + si];
        if (s >= 0 && s < bb_nblk) ra_csplit_on_phis(s, cb, -1, -1);
        si = si + 1;
    }
    ra_csplit_on_dom(cb, -1, -1);
}

static int ra_new_split_copy(int src, int blk) {
    int cl;
    cl = h_ninst;
    if (cl >= HIR_MAX_INST) return -1;
    h_kind[cl] = HI_COPY;
    h_ty[cl] = h_ty[src];
    h_src1[cl] = src;
    h_src2[cl] = -1;
    h_val[cl] = 0;
    h_name[cl] = 0;
    h_blk[cl] = blk;
    h_cbase[cl] = -1;
    h_pbase[cl] = -1;
    h_pcnt[cl] = 0;
    h_ld_ro[cl] = 0;
    h_no_remat[cl] = 0;
    bg_sel[cl] = -1;
    bg_uses[cl] = 0;
    bg_fold[cl] = 0;
    /* The copy is the same value as its source, so a frame-address or
     * symbol-address chain carries through it: a use the BURG matched
     * as LOAD(faddr) or STORE(faddr) before this split still reads its
     * offset from the operand (bg_foff), which was 0 here and sent the
     * reload of `w.scale` after `touch(&w.scale)` to fp+0+20 instead
     * of the struct's slot (ISSUES-81). */
    bg_foff[cl] = bg_foff[src];
    bg_ssym[cl] = bg_ssym[src];
    bg_soff[cl] = bg_soff[src];
    bg_iconst_seen_use[cl] = 0;
    bg_iconst_seen_nonimm[cl] = 0;
    licm_next[cl] = -1;
    licm_cpin[cl] = 0;
    licm_map[cl] = -1;
    ho_use[cl] = 0;
    ho_cse_next[cl] = -1;
    ho_phi_vouched[cl] = 0;
    hcg_brc_fuse[cl] = -1;
    hcg_cmp_fused[cl] = 0;
    hcg_cmp_kind[cl] = 0;
    hjt_base[cl] = -1;
    hjt_span[cl] = 0;
    ssa_phi_next[cl] = -1;
    ra_csplit_head[cl] = -1;
    ra_csplit_next[cl] = -1;
    ra_pair_of[cl] = -1;
    ra_pair_lo[cl] = 0;
    ra_is_csplit[cl] = 1;
    h_ninst = h_ninst + 1;
    return cl;
}

static void ra_rewire_after(int old, int nw, int call) {
    int i;
    int cb;
    int si;
    int s;
    cb = h_blk[call];
    i = call + 1;
    while (i < bb_end[cb]) {
        ra_csplit_on_inst(i, old, nw);
        i = i + 1;
    }
    si = 0;
    while (si < ssa_nsucc[cb]) {
        s = ssa_succ[ssa_soff[cb] + si];
        if (s >= 0 && s < bb_nblk) ra_csplit_on_phis(s, cb, old, nw);
        si = si + 1;
    }
    ra_csplit_on_dom(cb, old, nw);
}

static int ra_split_pairing = 0;  /* guards the fp64 partner recursion below */

static int ra_split_one(int v, int call) {
    int cp;
    int w;
    int cpw;
    if (v < 0 || v >= h_ninst) return -1;
    if (v == call) return -1;
    if (hi_is_remat(h_kind[v])) return -1;
    if (h_kind[v] == HI_NOP) return -1;
    if (h_blk[v] == h_blk[call] && v >= call) return -1;
    if (!ra_after_has(v)) return -1;
    cp = ra_new_split_copy(v, h_blk[call]);
    if (cp < 0) return -1;
    ra_csplit_next[cp] = ra_csplit_head[call];
    ra_csplit_head[call] = cp;
    ra_rewire_after(v, cp, call);
    /* v's after-uses now all name cp, so v has none left.  Clear the
     * stamp or the next ra_split_one(v, call) at this same call sees a
     * stale "has after-uses" and splits v again into a copy nothing
     * reads: an fp64 argument occupies TWO adjacent h_carg slots, so
     * the argument loop calls us once per half and the second call
     * re-split both halves. */
    ra_after_stamp[v] = 0;
    ra_stat_csplit = ra_stat_csplit + 1;
    w = ra_pair_of[v];
    /* Split the fp64 partner too, but NEVER let that inner call take
     * this branch again: ra_pair_of[w] still names v (the cp<->cpw
     * pairing below is what finally replaces it), so re-entering here
     * would split v a second time, then w again, ... until
     * ra_new_split_copy runs the instruction table out.  A double
     * passed to a call and used after it filled all HIR_MAX_INST
     * slots -- 6 lines of C became 1.3M lines of asm, and sqlite's
     * dekkerMul2/kahanBabuskaNeumaierStep/absFunc/strftimeFunc each
     * hit it (the assembler died on "Instruction buffer size
     * overflow"). */
    if (w >= 0 && w != v && ra_pair_of[cp] < 0 && !ra_split_pairing) {
        ra_split_pairing = 1;
        cpw = ra_split_one(w, call);
        ra_split_pairing = 0;
        if (cpw >= 0) {
            ra_pair_of[cp] = cpw;
            ra_pair_of[cpw] = cp;
            ra_pair_lo[cp] = ra_pair_lo[v];
            ra_pair_lo[cpw] = ra_pair_lo[w];
        }
    }
    return cp;
}

static void ra_split_at_calls(void) {
    int i;
    int j;
    int n;
    int base;
    int v;
    int c;
    ra_stat_csplit = 0;
    ra_split_orig = h_ninst;
    i = 0;
    while (i < h_ninst) {
        ra_csplit_head[i] = -1;
        ra_csplit_next[i] = -1;
        ra_is_csplit[i] = 0;
        i = i + 1;
    }
    c = ra_split_orig - 1;
    while (c >= 0) {
        if (h_kind[c] == HI_CALL || h_kind[c] == HI_CALLP) {
            ra_mark_after_uses(c);
            if (h_cbase[c] >= 0) {
                n = h_val[c];
                base = h_cbase[c];
                j = 0;
                while (j < n) {
                    v = h_carg[base + j];
                    if (v >= 0) ra_split_one(v, c);
                    j = j + 1;
                }
            }
            if (h_kind[c] == HI_CALLP && h_src1[c] >= 0)
                ra_split_one(h_src1[c], c);
        }
        c = c - 1;
    }
}

static void hir_regalloc(void) {
    /* SLOW-32 IRC path (George-Appel Iterated Register Coalescing) */
    ra_init_phys_regs();   /* populates classification tables (safe, knob==0 today) */
    { int z; z = 0; while (z < GC_MAX_NODE) { gc_pin[z] = -1; z = z + 1; } }
    ra_build_pairs();      /* fp64 halves that want adjacent registers */
    ra_split_at_calls();   /* chop crossing webs so the pre-call half can use r3-r10 */
    ra_build_wuses();      /* loop-depth-weighted use counts for spill cost */
    ra_compute_pos();
    ra_compute_ends();
    ra_extend_fused_cmp();
    ra_mark_call_crossing();
    lv_prepare();          /* per-block liveness; lv_on gates gc_build */
    ra_mark_arg_prefs();
    { int z; z = 0; while (z < h_ninst) { ra_mem_forced[z] = 0; z = z + 1; } }
    /* (ra_mark_clobbers removed — x64 RCX/RDX clobber arrays were never populated or used for SLOW-32) */

    ra_stat_caller_used = 0;
    ra_stat_callee_used = 0;
    ra_stat_param_preferred = 0;
    ra_stat_operand_reuse = 0;
    ra_stat_src2_reuse = 0;
    ra_stat_secondary_reuse = 0;
    ra_stat_imm_base_reuse = 0;

    gc_alloc();
    ra_assign_spills();
}

/* =================================================================
 * Diagnostic dump — enabled by `-d` on the s12cc command line.
 * Emits one line per non-NOP HIR instruction (after regalloc) so two
 * compiler binaries running on the same source can be diff'd to find
 * which inst's live interval / register assignment diverges.
 * ================================================================= */

static void ra_dump_signed(int v) {
    if (v < 0) {
        fdputc(45, 2);   /* '-' */
        fdputuint(2, 0 - v);
    } else {
        fdputuint(2, v);
    }
}

static void ra_dump_intervals(char *fname) {
    int i;

    fdputs("DUMP fn=", 2);
    fdputs(fname, 2);
    fdputs(" ninst=", 2);
    fdputuint(2, h_ninst);
    fdputs(" norder=", 2);
    fdputuint(2, ra_norder);
    fdputc(10, 2);

    i = 0;
    while (i < h_ninst) {
        if (h_kind[i] == HI_NOP) { i = i + 1; continue; }
        fdputs("DUMP i=", 2);
        fdputuint(2, i);
        fdputs(" k=", 2);
        fdputs(bg_op_name(h_kind[i]), 2);
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

    i = 0;
    while (i < h_ninst) {
        if (h_kind[i] == HI_PHI && h_pbase[i] >= 0) {
            int q;
            fdputs("PHIARGS i=", 2);
            fdputuint(2, (unsigned)i);
            q = 0;
            while (q < h_pcnt[i]) {
                fdputs(" [b", 2);
                ra_dump_signed(h_pblk[h_pbase[i] + q]);
                fdputs("]=", 2);
                ra_dump_signed(h_pval[h_pbase[i] + q]);
                q = q + 1;
            }
            fdputc(10, 2);
        }
        i = i + 1;
    }
}
