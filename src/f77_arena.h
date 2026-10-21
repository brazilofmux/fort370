/* f77_arena.h -- the front end's tables and the back end's, one storage.
 *
 * A program unit is parsed into HIR (hl_func), and then the back end
 * makes code of it; neither phase reads the other's own tables, and
 * neither's survive the unit.  So each table below is a pointer into
 * one arena, and the two phases' pointers start at its beginning: the
 * compiler's storage is the larger phase's tables, not both (about
 * 1.7MB less on MVS, where the region is what limits a unit).  Each
 * phase zeroes its part as it begins (f77_arena_phase), so a table
 * starts a unit as static storage starts the program.  The HIR itself,
 * the string pool, the DATA images and what the pre-scan collects for
 * the whole source are shared, and stay static where they are.
 *
 * A pointer here costs no more than an array did: on S/370 an array
 * past a base register's 4K is reached through an address constant,
 * a pointer through its value, one load either way.
 *
 * A table that is one phase's, per unit, can join: declare it a pointer
 * and add it to its phase here, with its first dimension.  The back
 * end's are in two lists: those of the headers the SLOW-32 build shares
 * (out/f77-s32, which keeps the other back end), and the S/370 code
 * generator's, allocator's and selector's. */

#define F77_FE_TABLES(X) \
    X(lx_brk, F77_MAX_STMT) \
    X(ps_gtype, P_MAX_GLOBALS) \
    X(ps_ginit, P_MAX_GLOBALS) \
    X(ps_ginit_hi, P_MAX_GLOBALS) \
    X(ps_gstr, P_MAX_GLOBALS) \
    X(ps_glocal, P_MAX_GLOBALS) \
    X(ps_girel_start, P_MAX_GLOBALS) \
    X(ps_girel_off, PS_MAX_INIT_RELOCS) \
    X(ps_girel_kind, PS_MAX_INIT_RELOCS) \
    X(ps_girel_idx, PS_MAX_INIT_RELOCS) \
    X(ps_girel_size, PS_MAX_INIT_RELOCS) \
    X(ps_girel_add, PS_MAX_INIT_RELOCS) \
    X(ps_girel_name, PS_MAX_INIT_RELOCS) \
    X(f77_sname, F77_MAX_SYM) \
    X(f77_sty, F77_MAX_SYM) \
    X(f77_sval, F77_MAX_SYM) \
    X(f77_srank, F77_MAX_SYM) \
    X(f77_dlo, F77_MAX_ARR) \
    X(f77_dext, F77_MAX_ARR) \
    X(f77_dextsym, F77_MAX_ARR) \
    X(f77_dlov, F77_MAX_ARR) \
    X(f77_slo, F77_MAX_SYM) \
    X(f77_sext, F77_MAX_SYM) \
    X(f77_sextsym, F77_MAX_SYM) \
    X(f77_slov, F77_MAX_SYM) \
    X(f77_shead, F77_SHASH) \
    X(f77_snext, F77_MAX_SYM) \
    X(f77_sarg, F77_MAX_SYM) \
    X(f77_shi, F77_MAX_SYM) \
    X(f77_scom, F77_MAX_SYM) \
    X(f77_ssaved, F77_MAX_SYM) \
    X(f77_sstored, F77_MAX_SYM) \
    X(f77_ldro_inst, F77_MAX_LDRO) \
    X(f77_ldro_sym, F77_MAX_LDRO) \
    X(f77_sgidx, F77_MAX_SYM) \
    X(f77_sgoff, F77_MAX_SYM) \
    X(f77_slen, F77_MAX_SYM) \
    X(f77_slenv, F77_MAX_SYM) \
    X(f77_spstr, F77_MAX_SYM) \
    X(f77_sexternal, F77_MAX_SYM) \
    X(f77_sintrinsic, F77_MAX_SYM) \
    X(f77_slog, F77_MAX_SYM) \
    X(f77_snar, F77_MAX_SYM) \
    X(f77_eq_parent, F77_MAX_SYM) \
    X(f77_eq_delta, F77_MAX_SYM) \
    X(f77_sparam, F77_MAX_SYM) \
    X(f77_spival, F77_MAX_SYM) \
    X(f77_spdval, F77_MAX_SYM) \
    X(f77_spdval2, F77_MAX_SYM) \
    X(f77_sptext, F77_MAX_SYM) \
    X(f77_sptext2, F77_MAX_SYM) \
    X(f77_styped, F77_MAX_SYM) \
    X(f77_stf_arg, F77_MAX_STF) \
    X(f77_stf_argty, F77_MAX_STF) \
    X(f77_stf_arglen, F77_MAX_STF) \
    X(f77_stf_pool, F77_STF_POOL) \
    X(f77_stf_pbrk, F77_STF_POOL) \
    X(f77_stfb_name, F77_MAX_STFB) \
    X(f77_lnum, F77_MAX_LABEL) \
    X(f77_lblk, F77_MAX_LABEL) \
    X(f77_ldef, F77_MAX_LABEL) \
    X(f77_di_sym, F77_MAX_DINIT) \
    X(f77_di_elem, F77_MAX_DINIT) \
    X(f77_di_ty, F77_MAX_DINIT) \
    X(f77_di_i, F77_MAX_DINIT) \
    X(f77_di_d, F77_MAX_DINIT) \
    X(f77_di_sidx, F77_MAX_DINIT) \
    X(f77_di_d2, F77_MAX_DINIT) \
    X(f77_di_t, F77_MAX_DINIT) \
    X(f77_di_t2, F77_MAX_DINIT) \
    X(f77_di_sub, F77_MAX_DINIT) \
    X(f77_dt_sym, F77_MAX_DTGT) \
    X(f77_dt_start, F77_MAX_DTGT) \
    X(f77_dt_count, F77_MAX_DTGT) \
    X(f77_dt_sublen, F77_MAX_DTGT) \

#define F77_BE_TABLES(X) \
    X(h_pblk, HIR_MAX_PARG) \
    X(h_pval, HIR_MAX_PARG) \
    X(h_pbase, HIR_MAX_INST) \
    X(h_pcnt, HIR_MAX_INST) \
    X(h_no_remat, HIR_MAX_INST) \
    X(licm_head, HIR_MAX_BLOCK) \
    X(licm_tail, HIR_MAX_BLOCK) \
    X(licm_next, HIR_MAX_INST) \
    X(licm_cpin, HIR_MAX_INST) \
    X(licm_in_any_loop, HIR_MAX_BLOCK) \
    X(licm_depth, HIR_MAX_BLOCK) \
    X(split_head, HIR_MAX_BLOCK) \
    X(sp_inbody, HIR_MAX_INST) \
    X(sp_post, HIR_MAX_INST) \
    X(sp_bad, HIR_MAX_INST) \
    X(licm_body, LICM_MAX_BODY) \
    X(licm_ucnt, HIR_MAX_INST) \
    X(ho_use, HIR_MAX_INST) \
    X(ho_phi_vouched, HIR_MAX_INST) \
    X(ho_cse_head, HO_CSE_SLOTS) \
    X(ho_cse_next, HIR_MAX_INST) \
    X(ssa_succ, SSA_SUCC_SZ) \
    X(ssa_nsucc, HIR_MAX_BLOCK) \
    X(ssa_soff, HIR_MAX_BLOCK) \
    X(ssa_pred, SSA_MAX_PRED) \
    X(ssa_pbase, HIR_MAX_BLOCK) \
    X(ssa_npred, HIR_MAX_BLOCK) \
    X(ssa_rpo, HIR_MAX_BLOCK) \
    X(ssa_rpo_ord, HIR_MAX_BLOCK) \
    X(ssa_idom, HIR_MAX_BLOCK) \
    X(ssa_dfc, HIR_MAX_BLOCK) \
    X(ssa_phi_head, HIR_MAX_BLOCK) \
    X(ssa_phi_next, HIR_MAX_INST) \
    X(ssa_dtc, SSA_DTC_MAX) \
    X(ssa_dtc_base, HIR_MAX_BLOCK) \
    X(ssa_dtc_cnt, HIR_MAX_BLOCK) \
    X(ssa_vis, HIR_MAX_BLOCK) \
    X(ssa_post, HIR_MAX_BLOCK) \
    X(ssa_tmp1, HIR_MAX_BLOCK) \
    X(ssa_tmp2, HIR_MAX_BLOCK) \
    X(ssa_tmp3, HIR_MAX_BLOCK) \

#define F77_BE_S370_TABLES(X) \
    X(bg_sel, HIR_MAX_INST) \
    X(bg_uses, HIR_MAX_INST) \
    X(bg_foff, HIR_MAX_INST) \
    X(bg_ssym, HIR_MAX_INST) \
    X(bg_soff, HIR_MAX_INST) \
    X(bg_memop, HIR_MAX_INST) \
    X(bg_fold_kind, HIR_MAX_INST) \
    X(bg_need_reg, HIR_MAX_INST) \
    X(bg_mem_lnt, HIR_MAX_INST) \
    X(s370_aoff, HIR_MAX_INST) \
    X(bg_fdone, HIR_MAX_INST) \
    X(bg_walk, HIR_MAX_INST) \
    X(bg_done, HIR_MAX_INST) \
    X(hcg_brc_fuse, HIR_MAX_INST) \
    X(hcg_cmp_fused, HIR_MAX_INST) \
    X(hcg_cmp_kind, HIR_MAX_INST) \
    X(s370_far, S370_MAX_ULBL) \
    X(s370_obj_inst, S370_MAX_OBJ) \
    X(s370_obj_size, S370_MAX_OBJ) \
    X(s370_obj_off, S370_MAX_OBJ) \
    X(s370_obj_lbl, S370_MAX_OBJ) \
    X(s370_alab, HIR_MAX_INST) \
    X(s370_pk_kind, S370_MAX_POOL) \
    X(s370_pk_lbl, S370_MAX_POOL) \
    X(s370_pk_v1, S370_MAX_POOL) \
    X(s370_pk_v2, S370_MAX_POOL) \
    X(s370_pk_name, S370_MAX_POOL) \
    X(s370_order, S370_MAX_OBJ) \
    X(s370_bxle_add, HIR_MAX_INST) \
    X(s370_bxle_brc, HIR_MAX_INST) \
    X(hcg_blk_lbl, HIR_MAX_BLOCK) \
    X(hcg_emit_ord, HIR_MAX_BLOCK) \
    X(hcg_placed, HIR_MAX_BLOCK) \
    X(s370_use_count, HIR_MAX_INST) \
    X(s370_loop_hdr, HIR_MAX_BLOCK) \
    X(s370_loop_size, HIR_MAX_BLOCK) \
    X(s370_lwl, HIR_MAX_BLOCK) \
    X(s370_glbl_save, P_MAX_GLOBALS) \
    X(ra_crosses_call, HIR_MAX_INST) \
    X(ra_mem_forced, HIR_MAX_INST) \
    X(ra_pair_of, HIR_MAX_INST) \
    X(ra_pair_lo, HIR_MAX_INST) \
    X(gc_pin, GC_MAX_NODE) \
    X(gc_pair_inst, GC_MAX_NODE) \
    X(ra_spill_off, HIR_MAX_INST) \
    X(ra_pos, HIR_MAX_INST) \
    X(ra_iend, HIR_MAX_INST) \
    X(ra_order, HIR_MAX_INST) \
    X(gc_inst, GC_MAX_NODE) \
    X(gc_node, HIR_MAX_INST) \
    X(gc_cls, GC_MAX_NODE) \
    X(gc_adj_head, GC_MAX_NODE) \
    X(gc_degree, GC_MAX_NODE) \
    X(gc_mv_a, GC_MAX_MOVE) \
    X(gc_mv_b, GC_MAX_MOVE) \
    X(gc_mv_status, GC_MAX_MOVE) \
    X(gc_nmlist_mv, GC_MAX_NMLIST) \
    X(gc_nmlist_next, GC_MAX_NMLIST) \
    X(gc_nmlist_head, GC_MAX_NODE) \
    X(gc_wl, GC_MAX_NODE) \
    X(gc_sel_stk, GC_MAX_NODE) \
    X(gc_alias, GC_MAX_NODE) \
    X(gc_color, GC_MAX_NODE) \
    X(gc_force_spill, GC_MAX_NODE) \
    X(ra_blk_last, HIR_MAX_BLOCK) \
    X(ra_bvis, HIR_MAX_BLOCK) \
    X(ra_bwl, HIR_MAX_BLOCK) \
    X(ra_shead, HIR_MAX_INST) \
    X(ra_snext, HIR_MAX_INST) \
    X(ra_slot_end, HIR_MAX_INST) \
    X(gc_mv_phi, GC_MAX_MOVE) \
    X(lv_id, HIR_MAX_INST) \
    X(lv_rev, HIR_MAX_INST) \
    X(lv_bstart, HIR_MAX_BLOCK) \
    X(lv_bend, HIR_MAX_BLOCK) \
    X(ra_wuses, HIR_MAX_INST) \

