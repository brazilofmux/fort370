/* s370_rtnames.h -- the runtime's entry points by their C names and the
 * eight-character external names the S/370 code calls them by.  The
 * runtime (runtime/s370/f77rt.h) gives each C function the same
 * external name with an asm label; tests/host/rtnames.sh checks the
 * two agree.  cc370 would otherwise mangle f77_wr_begin and
 * f77_wr_begin_int both to F77@WR@B.
 *
 * "I#" names are the specific intrinsics a program passes as actual
 * arguments (F77 15.9.3): the runtime's by-reference copies. */
static char *s370_rt_map[] = {
    "f77_wr_begin",     "F77WRBEG",
    "f77_wr_begin_int", "F77WRBI",
    "f77_wr_i",         "F77WRI",
    "f77_wr_d",         "F77WRD",
    "f77_wr_r",         "F77WRR",
    "f77_wr_c",         "F77WRC",
    "f77_wr_z",         "F77WRZ",
    "f77_wr_a",         "F77WRA",
    "f77_wr_l",         "F77WRL",
    "f77_wr_end",       "F77WREND",
    "f77_wu_begin",     "F77WUBEG",
    "f77_wu",           "F77WU",
    "f77_wu_end",       "F77WUEND",
    "f77_rd_begin",     "F77RDBEG",
    "f77_rd_begin_int", "F77RDBI",
    "f77_rd_i",         "F77RDI",
    "f77_rd_in",        "F77RDIN",
    "f77_fmt_lim",      "F77FMTLM",
    "f77_wr_in",        "F77WRIN",
    "f77_rd_d",         "F77RDD",
    "f77_rd_r",         "F77RDR",
    "f77_rd_s",         "F77RDS",
    "f77_rd_c",         "F77RDC",
    "f77_rd_z",         "F77RDZ",
    "f77_rd_end",       "F77RDEND",
    "f77_nml_begin",    "F77NMLBG",
    "f77_nml_dim",      "F77NMLDM",
    "f77_nml_item",     "F77NMLIT",
    "f77_nml_end",      "F77NMLEN",
    "f77_ru_begin",     "F77RUBEG",
    "f77_ru",           "F77RU",
    "f77_ru_end",       "F77RUEND",
    "f77_set_rec",      "F77SETRC",
    "f77_dfile",        "F77DFILE",
    "f77_darec",        "F77DAREC",
    "f77_dadone",       "F77DADON",
    "f77_open",         "F77OPEN",
    "f77_close",        "F77CLOSE",
    "f77_inquire",      "F77INQR",
    "f77_inq",          "F77INQ",
    "f77_rewind",       "F77REWND",
    "f77_backspace",    "F77BKSP",
    "f77_endfile",      "F77ENDF",
    "f77_pause",        "F77PAUSE",
    "f77_ipow",         "F77IPOW",
    "f77_dpow_i",       "F77DPOWI",
    "f77_rpow_i",       "F77RPOWI",
    "f77_cabs",         "F77CABS",
    "f77_cdiv",         "F77CDIV",
    "f77_zabs",         "F77ZABS",
    "f77_zdiv",         "F77ZDIV",
    "f77_zpow_i",       "F77ZPOWI",
    "f77_zpow_c",       "F77ZPOWC",
    "f77_zlog",         "F77ZLOG",
    "f77_zexp",         "F77ZEXP",
    "f77_zsqrt",        "F77ZSQRT",
    "f77_zsin",         "F77ZSIN",
    "f77_zcos",         "F77ZCOS",
    "f77_cpow_i",       "F77CPOWI",
    "f77_cpow_c",       "F77CPOWC",
    "f77_clog",         "F77CLOG",
    "f77_cexp",         "F77CEXP",
    "f77_csqrt",        "F77CSQRT",
    "f77_csin",         "F77CSIN",
    "f77_ccos",         "F77CCOS",
    "f77_strcpy",       "F77STRCP",
    "f77_strcmp",       "F77STRCM",
    "f77_lstrcmp",      "F77LSTRC",
    "f77_cat",          "F77CAT",
    "f77_index",        "F77INDEX",
    /* the libm names the front end emits, to the runtime's entries
     * (runtime/s370/f77m.h): FORTLIB's checks of the argument and its
     * messages are REAL's or DOUBLE PRECISION's, so the two have their
     * own names, FORTLIB's mostly; a REAL argument is widened to DOUBLE
     * PRECISION for these */
    "sqrt", "DSQRT", "sin", "DSIN", "cos", "DCOS", "tan", "DTAN",
    "asin", "DASIN", "acos", "DACOS", "atan", "DATAN", "atan2", "DATAN2",
    "exp", "DEXP", "log", "DLOG", "log10", "DLOG10", "sinh", "DSINH", "cosh", "DCOSH",
    "tanh", "DTANH", "pow", "DPOW",
    "sqrtf", "SQRT", "sinf", "SIN", "cosf", "COS", "tanf", "TAN",
    "asinf", "ASIN", "acosf", "ACOS", "atanf", "ATAN", "atan2f", "ATAN2",
    "expf", "EXP", "logf", "LOG", "log10f", "LOG10", "sinhf", "SINH", "coshf", "COSH",
    "tanhf", "TANH", "powf", "POW",
    /* the runtime's own: C89 has no trunc or round */
    "trunc", "F77DINT", "round", "F77DNINT", "truncf", "F77DINT", "roundf", "F77DNINT",
    "exit", "EXIT",
    "main", "F77MAIN",
    0 };

/* Is this libm name one whose REAL argument widens to double? */
static int s370_rt_libm(char *name) {
    static char *libm[] = { "sqrt", "sin", "cos", "tan", "asin", "acos", "atan", "atan2",
        "exp", "log", "log10", "sinh", "cosh", "tanh", "pow",
        "sqrtf", "sinf", "cosf", "tanf", "asinf", "acosf", "atanf", "atan2f",
        "expf", "logf", "log10f", "sinhf", "coshf", "tanhf", "powf",
        "trunc", "round", "truncf", "roundf", 0 };
    int i;
    i = 0;
    while (libm[i]) { if (strcmp(libm[i], name) == 0) return 1; i = i + 1; }
    return 0;
}

/* Does the runtime's C convention apply to a call of this name?  The
 * runtime's own entries, the libm names and exit; everything else is
 * a Fortran unit, called by reference. */
static int s370_rt_is_c(char *name) {
    if (name == 0) return 0;
    if (strncmp(name, "f77_", 4) == 0 || strncmp(name, "f77i_", 5) == 0) return 1;
    if (strcmp(name, "exit") == 0) return 1;
    return s370_rt_libm(name);
}

/* The external name of a runtime entry, or 0 when the name is not one. */
static char *s370_rt_extname(char *name) {
    int i;
    static char ibuf[12];
    i = 0;
    while (s370_rt_map[i]) {
        if (strcmp(s370_rt_map[i], name) == 0) return s370_rt_map[i + 1];
        i = i + 2;
    }
    if (strncmp(name, "f77i_", 5) == 0) {
        /* f77i_dsqrt -> I#DSQRT */
        int n;
        ibuf[0] = 'I'; ibuf[1] = '#';
        n = 2;
        i = 5;
        while (name[i] && n < 8) {
            ibuf[n] = (char)toupper((unsigned char)name[i]);
            n = n + 1; i = i + 1;
        }
        ibuf[n] = 0;
        return ibuf;
    }
    return 0;
}
