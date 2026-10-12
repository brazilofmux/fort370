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
    char buf[F77_MAX_STMT];
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
        lex_dval = strtod(buf, NULL);
        strcpy(lex_ftext, buf);
        lx_t = isdbl ? T_DCON : T_RCON;
    }
    return (int)(te - ts);
}

%%{
    machine f77_lexer;

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
