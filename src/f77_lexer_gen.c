
#line 1 "f77_lexer.rl"
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


#line 279 "f77_lexer.rl"



#line 219 "f77_lexer_gen.c"
static const int f77_lexer_start = 38;
static const int f77_lexer_first_final = 38;
static const int f77_lexer_error = 0;

static const int f77_lexer_en_main = 38;


#line 282 "f77_lexer.rl"

/* Point the scanner at the statement the card reader just assembled. */
static void f77_lex_stmt_init(void) {
    int cs;
    int act;
    char *ts;
    char *te;
    lx_rp = lx_stmt;
    lx_rpe = lx_stmt + lx_stmt_len;
    
#line 238 "f77_lexer_gen.c"
	{
	cs = f77_lexer_start;
	ts = 0;
	te = 0;
	act = 0;
	}

#line 292 "f77_lexer.rl"
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

    
#line 276 "f77_lexer_gen.c"
	{
	if ( p == pe )
		goto _test_eof;
	switch ( cs )
	{
tr0:
#line 1 "NONE"
	{	switch( act ) {
	case 0:
	{{goto st0;}}
	break;
	case 18:
	{{p = ((te))-1;} f77_string_tok(ts, te); {p++; cs = 38; goto _out;} }
	break;
	}
	}
	goto st38;
tr13:
#line 242 "f77_lexer.rl"
	{{p = ((te))-1;}{
            p = ts + f77_number(ts, te, pe) - 1;
            {p++; cs = 38; goto _out;}
        }}
	goto st38;
tr18:
#line 229 "f77_lexer.rl"
	{te = p+1;{ lx_t = T_AND;   {p++; cs = 38; goto _out;} }}
	goto st38;
tr20:
#line 223 "f77_lexer.rl"
	{te = p+1;{ lx_t = T_EQ;    {p++; cs = 38; goto _out;} }}
	goto st38;
tr22:
#line 232 "f77_lexer.rl"
	{te = p+1;{ lx_t = T_EQV;   {p++; cs = 38; goto _out;} }}
	goto st38;
tr27:
#line 235 "f77_lexer.rl"
	{te = p+1;{ lx_t = T_FALSE; {p++; cs = 38; goto _out;} }}
	goto st38;
tr30:
#line 228 "f77_lexer.rl"
	{te = p+1;{ lx_t = T_GE;    {p++; cs = 38; goto _out;} }}
	goto st38;
tr31:
#line 227 "f77_lexer.rl"
	{te = p+1;{ lx_t = T_GT;    {p++; cs = 38; goto _out;} }}
	goto st38;
tr34:
#line 226 "f77_lexer.rl"
	{te = p+1;{ lx_t = T_LE;    {p++; cs = 38; goto _out;} }}
	goto st38;
tr35:
#line 225 "f77_lexer.rl"
	{te = p+1;{ lx_t = T_LT;    {p++; cs = 38; goto _out;} }}
	goto st38;
tr38:
#line 224 "f77_lexer.rl"
	{te = p+1;{ lx_t = T_NE;    {p++; cs = 38; goto _out;} }}
	goto st38;
tr41:
#line 233 "f77_lexer.rl"
	{te = p+1;{ lx_t = T_NEQV;  {p++; cs = 38; goto _out;} }}
	goto st38;
tr43:
#line 231 "f77_lexer.rl"
	{te = p+1;{ lx_t = T_NOT;   {p++; cs = 38; goto _out;} }}
	goto st38;
tr45:
#line 230 "f77_lexer.rl"
	{te = p+1;{ lx_t = T_OR;    {p++; cs = 38; goto _out;} }}
	goto st38;
tr49:
#line 234 "f77_lexer.rl"
	{te = p+1;{ lx_t = T_TRUE;  {p++; cs = 38; goto _out;} }}
	goto st38;
tr50:
#line 238 "f77_lexer.rl"
	{{p = ((te))-1;}{
            p = ts + f77_number(ts, te, pe) - 1;
            {p++; cs = 38; goto _out;}
        }}
	goto st38;
tr53:
#line 250 "f77_lexer.rl"
	{{p = ((te))-1;}{
            p = ts + f77_number(ts, te, pe) - 1;
            {p++; cs = 38; goto _out;}
        }}
	goto st38;
tr58:
#line 264 "f77_lexer.rl"
	{te = p+1;{ lx_t = T_LP;     {p++; cs = 38; goto _out;} }}
	goto st38;
tr59:
#line 265 "f77_lexer.rl"
	{te = p+1;{ lx_t = T_RP;     {p++; cs = 38; goto _out;} }}
	goto st38;
tr61:
#line 268 "f77_lexer.rl"
	{te = p+1;{ lx_t = T_PLUS;   {p++; cs = 38; goto _out;} }}
	goto st38;
tr62:
#line 266 "f77_lexer.rl"
	{te = p+1;{ lx_t = T_COMMA;  {p++; cs = 38; goto _out;} }}
	goto st38;
tr63:
#line 269 "f77_lexer.rl"
	{te = p+1;{ lx_t = T_MINUS;  {p++; cs = 38; goto _out;} }}
	goto st38;
tr67:
#line 272 "f77_lexer.rl"
	{te = p+1;{ lx_t = T_COLON;  {p++; cs = 38; goto _out;} }}
	goto st38;
tr68:
#line 267 "f77_lexer.rl"
	{te = p+1;{ lx_t = T_ASSIGN; {p++; cs = 38; goto _out;} }}
	goto st38;
tr69:
#line 276 "f77_lexer.rl"
	{te = p;p--;{ /* skip */ }}
	goto st38;
tr70:
#line 259 "f77_lexer.rl"
	{te = p;p--;{ f77_name_tok(ts, te); {p++; cs = 38; goto _out;} }}
	goto st38;
tr71:
#line 256 "f77_lexer.rl"
	{te = p;p--;{ f77_string_tok(ts, te); {p++; cs = 38; goto _out;} }}
	goto st38;
tr72:
#line 270 "f77_lexer.rl"
	{te = p;p--;{ lx_t = T_STAR;   {p++; cs = 38; goto _out;} }}
	goto st38;
tr73:
#line 262 "f77_lexer.rl"
	{te = p+1;{ lx_t = T_POWER;  {p++; cs = 38; goto _out;} }}
	goto st38;
tr74:
#line 242 "f77_lexer.rl"
	{te = p;p--;{
            p = ts + f77_number(ts, te, pe) - 1;
            {p++; cs = 38; goto _out;}
        }}
	goto st38;
tr76:
#line 271 "f77_lexer.rl"
	{te = p;p--;{ lx_t = T_SLASH;  {p++; cs = 38; goto _out;} }}
	goto st38;
tr77:
#line 263 "f77_lexer.rl"
	{te = p+1;{ lx_t = T_CONCAT; {p++; cs = 38; goto _out;} }}
	goto st38;
tr78:
#line 250 "f77_lexer.rl"
	{te = p;p--;{
            p = ts + f77_number(ts, te, pe) - 1;
            {p++; cs = 38; goto _out;}
        }}
	goto st38;
tr81:
#line 238 "f77_lexer.rl"
	{te = p;p--;{
            p = ts + f77_number(ts, te, pe) - 1;
            {p++; cs = 38; goto _out;}
        }}
	goto st38;
tr83:
#line 246 "f77_lexer.rl"
	{te = p;p--;{
            p = ts + f77_number(ts, te, pe) - 1;
            {p++; cs = 38; goto _out;}
        }}
	goto st38;
st38:
#line 1 "NONE"
	{ts = 0;}
#line 1 "NONE"
	{act = 0;}
	if ( ++p == pe )
		goto _test_eof38;
case 38:
#line 1 "NONE"
	{ts = p;}
#line 461 "f77_lexer_gen.c"
	switch( ( F77_KEY(*p)) ) {
		case 9: goto st39;
		case 32: goto st39;
		case 36: goto st40;
		case 39: goto st1;
		case 40: goto tr58;
		case 41: goto tr59;
		case 42: goto st42;
		case 43: goto tr61;
		case 44: goto tr62;
		case 45: goto tr63;
		case 46: goto st2;
		case 47: goto st45;
		case 58: goto tr67;
		case 61: goto tr68;
		case 95: goto st40;
	}
	if ( ( F77_KEY(*p)) < 65 ) {
		if ( 48 <= ( F77_KEY(*p)) && ( F77_KEY(*p)) <= 57 )
			goto tr66;
	} else if ( ( F77_KEY(*p)) > 90 ) {
		if ( 97 <= ( F77_KEY(*p)) && ( F77_KEY(*p)) <= 122 )
			goto st40;
	} else
		goto st40;
	goto st0;
st0:
cs = 0;
	goto _out;
st39:
	if ( ++p == pe )
		goto _test_eof39;
case 39:
	switch( ( F77_KEY(*p)) ) {
		case 9: goto st39;
		case 32: goto st39;
	}
	goto tr69;
st40:
	if ( ++p == pe )
		goto _test_eof40;
case 40:
	switch( ( F77_KEY(*p)) ) {
		case 36: goto st40;
		case 95: goto st40;
	}
	if ( ( F77_KEY(*p)) < 65 ) {
		if ( 48 <= ( F77_KEY(*p)) && ( F77_KEY(*p)) <= 57 )
			goto st40;
	} else if ( ( F77_KEY(*p)) > 90 ) {
		if ( 97 <= ( F77_KEY(*p)) && ( F77_KEY(*p)) <= 122 )
			goto st40;
	} else
		goto st40;
	goto tr70;
st1:
	if ( ++p == pe )
		goto _test_eof1;
case 1:
	if ( ( F77_KEY(*p)) == 39 )
		goto tr2;
	goto st1;
tr2:
#line 1 "NONE"
	{te = p+1;}
#line 256 "f77_lexer.rl"
	{act = 18;}
	goto st41;
st41:
	if ( ++p == pe )
		goto _test_eof41;
case 41:
#line 534 "f77_lexer_gen.c"
	if ( ( F77_KEY(*p)) == 39 )
		goto st1;
	goto tr71;
st42:
	if ( ++p == pe )
		goto _test_eof42;
case 42:
	if ( ( F77_KEY(*p)) == 42 )
		goto tr73;
	goto tr72;
st2:
	if ( ++p == pe )
		goto _test_eof2;
case 2:
	switch( ( F77_KEY(*p)) ) {
		case 65: goto st5;
		case 69: goto st8;
		case 70: goto st11;
		case 71: goto st16;
		case 76: goto st19;
		case 78: goto st22;
		case 79: goto st28;
		case 84: goto st30;
	}
	if ( 48 <= ( F77_KEY(*p)) && ( F77_KEY(*p)) <= 57 )
		goto tr3;
	goto st0;
tr3:
#line 1 "NONE"
	{te = p+1;}
	goto st43;
st43:
	if ( ++p == pe )
		goto _test_eof43;
case 43:
#line 570 "f77_lexer_gen.c"
	if ( ( F77_KEY(*p)) < 68 ) {
		if ( 48 <= ( F77_KEY(*p)) && ( F77_KEY(*p)) <= 57 )
			goto tr3;
	} else if ( ( F77_KEY(*p)) > 69 ) {
		if ( 100 <= ( F77_KEY(*p)) && ( F77_KEY(*p)) <= 101 )
			goto st3;
	} else
		goto st3;
	goto tr74;
st3:
	if ( ++p == pe )
		goto _test_eof3;
case 3:
	switch( ( F77_KEY(*p)) ) {
		case 43: goto st4;
		case 45: goto st4;
	}
	if ( 48 <= ( F77_KEY(*p)) && ( F77_KEY(*p)) <= 57 )
		goto st44;
	goto tr13;
st4:
	if ( ++p == pe )
		goto _test_eof4;
case 4:
	if ( 48 <= ( F77_KEY(*p)) && ( F77_KEY(*p)) <= 57 )
		goto st44;
	goto tr13;
st44:
	if ( ++p == pe )
		goto _test_eof44;
case 44:
	if ( 48 <= ( F77_KEY(*p)) && ( F77_KEY(*p)) <= 57 )
		goto st44;
	goto tr74;
st5:
	if ( ++p == pe )
		goto _test_eof5;
case 5:
	if ( ( F77_KEY(*p)) == 78 )
		goto st6;
	goto st0;
st6:
	if ( ++p == pe )
		goto _test_eof6;
case 6:
	if ( ( F77_KEY(*p)) == 68 )
		goto st7;
	goto st0;
st7:
	if ( ++p == pe )
		goto _test_eof7;
case 7:
	if ( ( F77_KEY(*p)) == 46 )
		goto tr18;
	goto st0;
st8:
	if ( ++p == pe )
		goto _test_eof8;
case 8:
	if ( ( F77_KEY(*p)) == 81 )
		goto st9;
	goto st0;
st9:
	if ( ++p == pe )
		goto _test_eof9;
case 9:
	switch( ( F77_KEY(*p)) ) {
		case 46: goto tr20;
		case 86: goto st10;
	}
	goto st0;
st10:
	if ( ++p == pe )
		goto _test_eof10;
case 10:
	if ( ( F77_KEY(*p)) == 46 )
		goto tr22;
	goto st0;
st11:
	if ( ++p == pe )
		goto _test_eof11;
case 11:
	if ( ( F77_KEY(*p)) == 65 )
		goto st12;
	goto st0;
st12:
	if ( ++p == pe )
		goto _test_eof12;
case 12:
	if ( ( F77_KEY(*p)) == 76 )
		goto st13;
	goto st0;
st13:
	if ( ++p == pe )
		goto _test_eof13;
case 13:
	if ( ( F77_KEY(*p)) == 83 )
		goto st14;
	goto st0;
st14:
	if ( ++p == pe )
		goto _test_eof14;
case 14:
	if ( ( F77_KEY(*p)) == 69 )
		goto st15;
	goto st0;
st15:
	if ( ++p == pe )
		goto _test_eof15;
case 15:
	if ( ( F77_KEY(*p)) == 46 )
		goto tr27;
	goto st0;
st16:
	if ( ++p == pe )
		goto _test_eof16;
case 16:
	switch( ( F77_KEY(*p)) ) {
		case 69: goto st17;
		case 84: goto st18;
	}
	goto st0;
st17:
	if ( ++p == pe )
		goto _test_eof17;
case 17:
	if ( ( F77_KEY(*p)) == 46 )
		goto tr30;
	goto st0;
st18:
	if ( ++p == pe )
		goto _test_eof18;
case 18:
	if ( ( F77_KEY(*p)) == 46 )
		goto tr31;
	goto st0;
st19:
	if ( ++p == pe )
		goto _test_eof19;
case 19:
	switch( ( F77_KEY(*p)) ) {
		case 69: goto st20;
		case 84: goto st21;
	}
	goto st0;
st20:
	if ( ++p == pe )
		goto _test_eof20;
case 20:
	if ( ( F77_KEY(*p)) == 46 )
		goto tr34;
	goto st0;
st21:
	if ( ++p == pe )
		goto _test_eof21;
case 21:
	if ( ( F77_KEY(*p)) == 46 )
		goto tr35;
	goto st0;
st22:
	if ( ++p == pe )
		goto _test_eof22;
case 22:
	switch( ( F77_KEY(*p)) ) {
		case 69: goto st23;
		case 79: goto st26;
	}
	goto st0;
st23:
	if ( ++p == pe )
		goto _test_eof23;
case 23:
	switch( ( F77_KEY(*p)) ) {
		case 46: goto tr38;
		case 81: goto st24;
	}
	goto st0;
st24:
	if ( ++p == pe )
		goto _test_eof24;
case 24:
	if ( ( F77_KEY(*p)) == 86 )
		goto st25;
	goto st0;
st25:
	if ( ++p == pe )
		goto _test_eof25;
case 25:
	if ( ( F77_KEY(*p)) == 46 )
		goto tr41;
	goto st0;
st26:
	if ( ++p == pe )
		goto _test_eof26;
case 26:
	if ( ( F77_KEY(*p)) == 84 )
		goto st27;
	goto st0;
st27:
	if ( ++p == pe )
		goto _test_eof27;
case 27:
	if ( ( F77_KEY(*p)) == 46 )
		goto tr43;
	goto st0;
st28:
	if ( ++p == pe )
		goto _test_eof28;
case 28:
	if ( ( F77_KEY(*p)) == 82 )
		goto st29;
	goto st0;
st29:
	if ( ++p == pe )
		goto _test_eof29;
case 29:
	if ( ( F77_KEY(*p)) == 46 )
		goto tr45;
	goto st0;
st30:
	if ( ++p == pe )
		goto _test_eof30;
case 30:
	if ( ( F77_KEY(*p)) == 82 )
		goto st31;
	goto st0;
st31:
	if ( ++p == pe )
		goto _test_eof31;
case 31:
	if ( ( F77_KEY(*p)) == 85 )
		goto st32;
	goto st0;
st32:
	if ( ++p == pe )
		goto _test_eof32;
case 32:
	if ( ( F77_KEY(*p)) == 69 )
		goto st33;
	goto st0;
st33:
	if ( ++p == pe )
		goto _test_eof33;
case 33:
	if ( ( F77_KEY(*p)) == 46 )
		goto tr49;
	goto st0;
st45:
	if ( ++p == pe )
		goto _test_eof45;
case 45:
	if ( ( F77_KEY(*p)) == 47 )
		goto tr77;
	goto tr76;
tr66:
#line 1 "NONE"
	{te = p+1;}
	goto st46;
st46:
	if ( ++p == pe )
		goto _test_eof46;
case 46:
#line 833 "f77_lexer_gen.c"
	if ( ( F77_KEY(*p)) == 46 )
		goto tr79;
	if ( ( F77_KEY(*p)) < 68 ) {
		if ( 48 <= ( F77_KEY(*p)) && ( F77_KEY(*p)) <= 57 )
			goto tr66;
	} else if ( ( F77_KEY(*p)) > 69 ) {
		if ( 100 <= ( F77_KEY(*p)) && ( F77_KEY(*p)) <= 101 )
			goto st36;
	} else
		goto st36;
	goto tr78;
tr79:
#line 1 "NONE"
	{te = p+1;}
	goto st47;
st47:
	if ( ++p == pe )
		goto _test_eof47;
case 47:
#line 853 "f77_lexer_gen.c"
	if ( ( F77_KEY(*p)) < 68 ) {
		if ( 48 <= ( F77_KEY(*p)) && ( F77_KEY(*p)) <= 57 )
			goto tr79;
	} else if ( ( F77_KEY(*p)) > 69 ) {
		if ( 100 <= ( F77_KEY(*p)) && ( F77_KEY(*p)) <= 101 )
			goto st34;
	} else
		goto st34;
	goto tr81;
st34:
	if ( ++p == pe )
		goto _test_eof34;
case 34:
	switch( ( F77_KEY(*p)) ) {
		case 43: goto st35;
		case 45: goto st35;
	}
	if ( 48 <= ( F77_KEY(*p)) && ( F77_KEY(*p)) <= 57 )
		goto st48;
	goto tr50;
st35:
	if ( ++p == pe )
		goto _test_eof35;
case 35:
	if ( 48 <= ( F77_KEY(*p)) && ( F77_KEY(*p)) <= 57 )
		goto st48;
	goto tr50;
st48:
	if ( ++p == pe )
		goto _test_eof48;
case 48:
	if ( 48 <= ( F77_KEY(*p)) && ( F77_KEY(*p)) <= 57 )
		goto st48;
	goto tr81;
st36:
	if ( ++p == pe )
		goto _test_eof36;
case 36:
	switch( ( F77_KEY(*p)) ) {
		case 43: goto st37;
		case 45: goto st37;
	}
	if ( 48 <= ( F77_KEY(*p)) && ( F77_KEY(*p)) <= 57 )
		goto st49;
	goto tr53;
st37:
	if ( ++p == pe )
		goto _test_eof37;
case 37:
	if ( 48 <= ( F77_KEY(*p)) && ( F77_KEY(*p)) <= 57 )
		goto st49;
	goto tr53;
st49:
	if ( ++p == pe )
		goto _test_eof49;
case 49:
	if ( 48 <= ( F77_KEY(*p)) && ( F77_KEY(*p)) <= 57 )
		goto st49;
	goto tr83;
	}
	_test_eof38: cs = 38; goto _test_eof; 
	_test_eof39: cs = 39; goto _test_eof; 
	_test_eof40: cs = 40; goto _test_eof; 
	_test_eof1: cs = 1; goto _test_eof; 
	_test_eof41: cs = 41; goto _test_eof; 
	_test_eof42: cs = 42; goto _test_eof; 
	_test_eof2: cs = 2; goto _test_eof; 
	_test_eof43: cs = 43; goto _test_eof; 
	_test_eof3: cs = 3; goto _test_eof; 
	_test_eof4: cs = 4; goto _test_eof; 
	_test_eof44: cs = 44; goto _test_eof; 
	_test_eof5: cs = 5; goto _test_eof; 
	_test_eof6: cs = 6; goto _test_eof; 
	_test_eof7: cs = 7; goto _test_eof; 
	_test_eof8: cs = 8; goto _test_eof; 
	_test_eof9: cs = 9; goto _test_eof; 
	_test_eof10: cs = 10; goto _test_eof; 
	_test_eof11: cs = 11; goto _test_eof; 
	_test_eof12: cs = 12; goto _test_eof; 
	_test_eof13: cs = 13; goto _test_eof; 
	_test_eof14: cs = 14; goto _test_eof; 
	_test_eof15: cs = 15; goto _test_eof; 
	_test_eof16: cs = 16; goto _test_eof; 
	_test_eof17: cs = 17; goto _test_eof; 
	_test_eof18: cs = 18; goto _test_eof; 
	_test_eof19: cs = 19; goto _test_eof; 
	_test_eof20: cs = 20; goto _test_eof; 
	_test_eof21: cs = 21; goto _test_eof; 
	_test_eof22: cs = 22; goto _test_eof; 
	_test_eof23: cs = 23; goto _test_eof; 
	_test_eof24: cs = 24; goto _test_eof; 
	_test_eof25: cs = 25; goto _test_eof; 
	_test_eof26: cs = 26; goto _test_eof; 
	_test_eof27: cs = 27; goto _test_eof; 
	_test_eof28: cs = 28; goto _test_eof; 
	_test_eof29: cs = 29; goto _test_eof; 
	_test_eof30: cs = 30; goto _test_eof; 
	_test_eof31: cs = 31; goto _test_eof; 
	_test_eof32: cs = 32; goto _test_eof; 
	_test_eof33: cs = 33; goto _test_eof; 
	_test_eof45: cs = 45; goto _test_eof; 
	_test_eof46: cs = 46; goto _test_eof; 
	_test_eof47: cs = 47; goto _test_eof; 
	_test_eof34: cs = 34; goto _test_eof; 
	_test_eof35: cs = 35; goto _test_eof; 
	_test_eof48: cs = 48; goto _test_eof; 
	_test_eof36: cs = 36; goto _test_eof; 
	_test_eof37: cs = 37; goto _test_eof; 
	_test_eof49: cs = 49; goto _test_eof; 

	_test_eof: {}
	if ( p == eof )
	{
	switch ( cs ) {
	case 39: goto tr69;
	case 40: goto tr70;
	case 1: goto tr0;
	case 41: goto tr71;
	case 42: goto tr72;
	case 43: goto tr74;
	case 3: goto tr13;
	case 4: goto tr13;
	case 44: goto tr74;
	case 45: goto tr76;
	case 46: goto tr78;
	case 47: goto tr81;
	case 34: goto tr50;
	case 35: goto tr50;
	case 48: goto tr81;
	case 36: goto tr53;
	case 37: goto tr53;
	case 49: goto tr83;
	}
	}

	_out: {}
	}

#line 321 "f77_lexer.rl"

    lx_rp = p;
    lx_rcs = cs;
    lx_ract = act;
    lx_rts = ts;
    lx_rte = te;
}
