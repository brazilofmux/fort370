/* COPIED from slow32-public fortran/src/f77_lexer.rl at 2245be78 (2026-10-12).  See PROVENANCE.md. */
/* f77_lexer.rl -- Ragel -G2 token scanner for Fortran 77.
 *
 * Build:  bash gen_lexer.sh   ->  f77_lexer_gen.c
 *
 * Runs over one ASSEMBLED statement at a time (see f77_card.h, which
 * handles the card-image layer: columns, continuations, blank squeezing
 * and Hollerith counts).  By the time the scanner sees text, blanks are
 * gone and case is folded, so the token grammar is ordinary.
 *
 * Two Fortran-specific hazards are handled here:
 *
 *   1. `1.EQ.2` -- longest-match would take `1.` as a REAL constant and
 *      leave `EQ.2`.  The dotted operators are matched at higher
 *      priority, and f77_number() additionally backs off the trailing
 *      dot when what follows is a dotted operator, so the scanner
 *      resumes at the `.` and yields `1` `.EQ.` `2`.
 *
 *   2. There are NO reserved words.  The scanner never classifies a
 *      keyword: `IF`, `DO` and `FORMAT` come back as T_NAME and the
 *      parser decides from context.  This is what lets `DO10I=1.10` be
 *      an assignment while `DO 10 I=1,10` is a loop.
 */

/* === Token kinds === */

#define T_EOF     0
#define T_NAME    1
#define T_ICON    2   /* integer constant          -> lex_ival */
#define T_RCON    3   /* REAL constant             -> lex_dval */
#define T_DCON    4   /* DOUBLE PRECISION constant -> lex_dval */
#define T_SCON    5   /* character / Hollerith     -> lex_sidx, lex_slen */
#define T_LP      6
#define T_RP      7
#define T_COMMA   8
#define T_ASSIGN  9
#define T_PLUS   10
#define T_MINUS  11
#define T_STAR   12
#define T_SLASH  13
#define T_POWER  14   /* ** */
#define T_CONCAT 15   /* // */
#define T_COLON  16
#define T_EQ     17
#define T_NE     18
#define T_LT     19
#define T_LE     20
#define T_GT     21
#define T_GE     22
#define T_AND    23
#define T_OR     24
#define T_NOT    25
#define T_EQV    26
#define T_NEQV   27
#define T_TRUE   28
#define T_FALSE  29

/* === Current token === */

static int    lx_t;                    /* token kind */
static char   lex_name[F77_MAX_NAME];  /* T_NAME text (upper case) */
static int    lex_namelen;
static int    lex_ival;                /* T_ICON value */
static double lex_dval;                /* T_RCON / T_DCON value */
static char   lex_ftext[128];          /* T_RCON / T_DCON source text, D as E */
static int    lex_sidx;                /* T_SCON: string-pool index */
static int    lex_slen;                /* T_SCON: length in bytes */

/* Scanner state, saved between calls (one statement at a time). */
static char *lx_rp;
static char *lx_rpe;
static int   lx_rcs;
static int   lx_ract;
static char *lx_rts;
static char *lx_rte;

/* fort370: Ragel bakes its character classes into the machine as ASCII
 * values (48 <= c <= 57 for a digit), which recompiling under an EBCDIC
 * C compiler does not change.  So on MVS the machine reads each byte
 * through this table, EBCDIC (code page 037) to ASCII, by getkey below;
 * the pointers still point into the statement as it is, EBCDIC, which is
 * what the helpers read and what the parser compares with its own
 * (EBCDIC) literals.  Everywhere else the key is the byte itself. */
#ifdef __MVS__
static const unsigned char lx_e2a[256] = {
    0x00, 0x01, 0x02, 0x03, 0x9C, 0x09, 0x86, 0x7F, 0x97, 0x8D, 0x8E, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
    0x10, 0x11, 0x12, 0x13, 0x9D, 0x85, 0x08, 0x87, 0x18, 0x19, 0x92, 0x8F, 0x1C, 0x1D, 0x1E, 0x1F,
    0x80, 0x81, 0x82, 0x83, 0x84, 0x0A, 0x17, 0x1B, 0x88, 0x89, 0x8A, 0x8B, 0x8C, 0x05, 0x06, 0x07,
    0x90, 0x91, 0x16, 0x93, 0x94, 0x95, 0x96, 0x04, 0x98, 0x99, 0x9A, 0x9B, 0x14, 0x15, 0x9E, 0x1A,
    0x20, 0xA0, 0xE2, 0xE4, 0xE0, 0xE1, 0xE3, 0xE5, 0xE7, 0xF1, 0xA2, 0x2E, 0x3C, 0x28, 0x2B, 0x7C,
    0x26, 0xE9, 0xEA, 0xEB, 0xE8, 0xED, 0xEE, 0xEF, 0xEC, 0xDF, 0x21, 0x24, 0x2A, 0x29, 0x3B, 0xAC,
    0x2D, 0x2F, 0xC2, 0xC4, 0xC0, 0xC1, 0xC3, 0xC5, 0xC7, 0xD1, 0xA6, 0x2C, 0x25, 0x5F, 0x3E, 0x3F,
    0xF8, 0xC9, 0xCA, 0xCB, 0xC8, 0xCD, 0xCE, 0xCF, 0xCC, 0x60, 0x3A, 0x23, 0x40, 0x27, 0x3D, 0x22,
    0xD8, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0xAB, 0xBB, 0xF0, 0xFD, 0xFE, 0xB1,
    0xB0, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F, 0x70, 0x71, 0x72, 0xAA, 0xBA, 0xE6, 0xB8, 0xC6, 0xA4,
    0xB5, 0x7E, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7A, 0xA1, 0xBF, 0xD0, 0xDD, 0xDE, 0xAE,
    0x5E, 0xA3, 0xA5, 0xB7, 0xA9, 0xA7, 0xB6, 0xBC, 0xBD, 0xBE, 0x5B, 0x5D, 0xAF, 0xA8, 0xB4, 0xD7,
    0x7B, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0xAD, 0xF4, 0xF6, 0xF2, 0xF3, 0xF5,
    0x7D, 0x4A, 0x4B, 0x4C, 0x4D, 0x4E, 0x4F, 0x50, 0x51, 0x52, 0xB9, 0xFB, 0xFC, 0xF9, 0xFA, 0xFF,
    0x5C, 0xF7, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59, 0x5A, 0xB2, 0xD4, 0xD6, 0xD2, 0xD3, 0xD5,
    0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0xB3, 0xDB, 0xDC, 0xD9, 0xDA, 0x9F,
};
#define F77_KEY(c) ((signed char)lx_e2a[(unsigned char)(c)])
#else
#define F77_KEY(c) (c)
#endif

#ifdef __MVS__
static int hfp_from_text(const char *s, unsigned int *hi, unsigned int *lo);   /* s370_hfp.h */
#endif

/* === Helpers === */

static void f77_name_tok(char *ts, char *te) {
    int n;
    n = (int)(te - ts);
    if (n > F77_MAX_NAME - 1) n = F77_MAX_NAME - 1;
    memcpy(lex_name, ts, n);
    lex_name[n] = 0;
    lex_namelen = n;
    lx_t = T_NAME;
}

/* A character constant, already normalised by the card reader so that
 * '' is the only escape.  Interned into the shared string pool. */
static void f77_string_tok(char *ts, char *te) {
    static char buf[F77_MAX_STMT];   /* fort370: not in the frame; runs under every nested expression */
    char *p;
    int n;
    p = ts + 1;          /* skip opening quote */
    n = 0;
    while (p < te - 1) {
        if (*p == '\'' && p + 1 < te - 1 && p[1] == '\'') p = p + 1;
        buf[n] = *p;
        n = n + 1;
        p = p + 1;
    }
    lex_sidx = f77_intern_str(buf, n);
    lex_slen = n;
    lx_t = T_SCON;
}

static int f77_digits_val(char *s, char *e) {
    int v;
    v = 0;
    while (s < e && *s >= '0' && *s <= '9') { v = v * 10 + (*s - '0'); s = s + 1; }
    return v;
}

/* Is `s` the start of a dotted operator?  Used to decide whether a
 * trailing '.' on a numeric literal really belongs to the number. */
static int f77_is_dotop(char *s, char *e) {
    int n;
    if (s >= e || *s != '.') return 0;
    n = 1;
    while (s + n < e && ((s[n] >= 'A' && s[n] <= 'Z'))) n = n + 1;
    if (n == 1) return 0;
    if (s + n >= e || s[n] != '.') return 0;
    return 1;
}

/* Scan a numeric literal.  Returns the number of characters actually
 * consumed, which may be FEWER than Ragel matched: `1.EQ.2` matches
 * `1.` but must consume only `1`, leaving the dot to start .EQ. */
static int f77_number(char *ts, char *te, char *pe) {
    char buf[128];
    char *p;
    int n;
    int isreal;
    int isdbl;

    /* Back off a trailing dot that introduces a dotted operator. */
    if (te > ts && te[-1] == '.' && f77_is_dotop(te - 1, pe)) te = te - 1;

    isreal = 0;
    isdbl = 0;
    n = 0;
    p = ts;
    while (p < te && n < 127) {
        if (*p == '.') isreal = 1;
        if (*p == 'D' || *p == 'd') { isdbl = 1; isreal = 1; buf[n] = 'E'; }
        else if (*p == 'E' || *p == 'e') { isreal = 1; buf[n] = 'E'; }
        else buf[n] = *p;
        n = n + 1;
        p = p + 1;
    }
    buf[n] = 0;

    if (!isreal) {
        lex_ival = f77_digits_val(ts, te);
        lx_t = T_ICON;
    } else {
#ifdef __MVS__
        /* fort370: a double on MVS is HFP, so it can be had exactly from
         * the compiler's own conversion (s370_hfp.h, truncating as the
         * constants are); libc370's strtod is not to be trusted. */
        {
            union { double d; unsigned int w[2]; } u;
            if (hfp_from_text(buf, &u.w[0], &u.w[1]) < 0) { u.w[0] = 0; u.w[1] = 0; }
            lex_dval = u.d;
        }
#else
        lex_dval = strtod(buf, NULL);
#endif
        strcpy(lex_ftext, buf);
        lx_t = isdbl ? T_DCON : T_RCON;
    }
    return (int)(te - ts);
}

%%{
    machine f77_lexer;
    getkey F77_KEY(*p);

    # --- Dotted operators.  Listed ahead of numeric literals so that a
    # --- position like `.EQ.` is never mistaken for `.5`-style syntax.
    dotop = '.EQ.' | '.NE.' | '.LT.' | '.LE.' | '.GT.' | '.GE.'
          | '.AND.' | '.OR.' | '.NOT.' | '.EQV.' | '.NEQV.'
          | '.TRUE.' | '.FALSE.';

    main := |*

        '.EQ.'    => { lx_t = T_EQ;    fbreak; };
        '.NE.'    => { lx_t = T_NE;    fbreak; };
        '.LT.'    => { lx_t = T_LT;    fbreak; };
        '.LE.'    => { lx_t = T_LE;    fbreak; };
        '.GT.'    => { lx_t = T_GT;    fbreak; };
        '.GE.'    => { lx_t = T_GE;    fbreak; };
        '.AND.'   => { lx_t = T_AND;   fbreak; };
        '.OR.'    => { lx_t = T_OR;    fbreak; };
        '.NOT.'   => { lx_t = T_NOT;   fbreak; };
        '.EQV.'   => { lx_t = T_EQV;   fbreak; };
        '.NEQV.'  => { lx_t = T_NEQV;  fbreak; };
        '.TRUE.'  => { lx_t = T_TRUE;  fbreak; };
        '.FALSE.' => { lx_t = T_FALSE; fbreak; };

        # --- Numeric literals (longest-match first) ---
        [0-9]+ '.' [0-9]* ([EeDd] [+\-]? [0-9]+)? => {
            p = ts + f77_number(ts, te, pe) - 1;
            fbreak;
        };
        '.' [0-9]+ ([EeDd] [+\-]? [0-9]+)? => {
            p = ts + f77_number(ts, te, pe) - 1;
            fbreak;
        };
        [0-9]+ [EeDd] [+\-]? [0-9]+ => {
            p = ts + f77_number(ts, te, pe) - 1;
            fbreak;
        };
        [0-9]+ => {
            p = ts + f77_number(ts, te, pe) - 1;
            fbreak;
        };

        # --- Character constants ('' is the embedded quote) ---
        '\'' ( [^'] | '\'\'' )* '\'' => { f77_string_tok(ts, te); fbreak; };

        # --- Names.  NOT classified: F77 has no reserved words. ---
        [A-Za-z_$] [A-Za-z0-9_$]* => { f77_name_tok(ts, te); fbreak; };

        # --- Operators and punctuation ---
        '**' => { lx_t = T_POWER;  fbreak; };
        '//' => { lx_t = T_CONCAT; fbreak; };
        '('  => { lx_t = T_LP;     fbreak; };
        ')'  => { lx_t = T_RP;     fbreak; };
        ','  => { lx_t = T_COMMA;  fbreak; };
        '='  => { lx_t = T_ASSIGN; fbreak; };
        '+'  => { lx_t = T_PLUS;   fbreak; };
        '-'  => { lx_t = T_MINUS;  fbreak; };
        '*'  => { lx_t = T_STAR;   fbreak; };
        '/'  => { lx_t = T_SLASH;  fbreak; };
        ':'  => { lx_t = T_COLON;  fbreak; };

        # Stray blanks cannot occur (the card reader squeezed them), but
        # tolerate them so a hand-fed statement still scans.
        [ \t]+ => { /* skip */ };

    *|;
}%%

%% write data;

/* Point the scanner at the statement the card reader just assembled. */
static void f77_lex_stmt_init(void) {
    int cs;
    int act;
    char *ts;
    char *te;
    lx_rp = lx_stmt;
    lx_rpe = lx_stmt + lx_stmt_len;
    %% write init;
    lx_rcs = cs;
    lx_ract = act;
    lx_rts = ts;
    lx_rte = te;
    lx_t = T_EOF;
}

/* Scan one token from the current statement. */
static void f77_tok(void) {
    char *p;
    char *pe;
    char *eof;
    char *ts;
    char *te;
    int cs;
    int act;

    p = lx_rp;
    pe = lx_rpe;
    eof = pe;
    cs = lx_rcs;
    act = lx_ract;
    ts = lx_rts;
    te = lx_rte;

    lx_t = T_EOF;
    if (p >= pe) return;

    %% write exec;

    lx_rp = p;
    lx_rcs = cs;
    lx_ract = act;
    lx_rts = ts;
    lx_rte = te;
}
