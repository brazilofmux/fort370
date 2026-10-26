/* COPIED from slow32-public fortran/src/f77_card.h at 2245be78 (2026-10-12).  See PROVENANCE.md. */
/* f77_card.h -- fixed-form Fortran 77 card-image reader.
 *
 * Assembles statements; the token layer is Ragel (f77_lexer.rl).
 *
 * Fixed-form is not C-like, and three of its rules drive this design:
 *
 *   1. A *statement* -- not a line -- is the unit.  Columns 1-5 hold an
 *      optional label, column 6 a continuation marker, columns 7-72 the
 *      text, and 73-80 are ignored sequence numbers.  A statement is an
 *      initial line plus any continuation lines, concatenated.  So the
 *      reader assembles a whole statement before a single token is cut.
 *
 *   2. Blanks are insignificant outside character context.  `DO 10 I`,
 *      `DO10I` and `D O 1 0 I` are the same text.  Blanks are therefore
 *      squeezed during assembly, not skipped during tokenization --
 *      otherwise keywords with embedded blanks would never be
 *      recognised.
 *
 *   3. There are no reserved words.  `IF`, `DO` and `FORMAT` are all
 *      legal variable names, so the lexer must NOT classify keywords;
 *      it returns names and lets the parser decide from context.  This
 *      is why `DO 10 I = 1, 10` (a loop) and `DO10I = 1.10` (an
 *      assignment to the variable DO10I) can only be told apart by
 *      scanning ahead for the comma -- a parser job, not a lexer one.
 *
 * Two constructs survive blank-squeezing verbatim: character constants
 * ('...', with '' as an embedded quote) and Hollerith counts (nH
 * followed by exactly n characters, blanks included).  Both are
 * detected during assembly, when the character positions still mean
 * something.
 *
 * Extensions accepted, deliberately: tab-formatted source (a tab in
 * columns 1-6 jumps to the statement body; a digit right after it marks
 * a continuation), lower case, and `!` as an end-of-statement comment.
 * Real F77 decks in the wild use all three.
 */
#ifndef F77_CARD_H
#define F77_CARD_H

#define F77_MAX_STMT 8192
#define F77_MAX_NAME 32   /* fort370: FORTRAN 77 names are six characters; 31 are kept */

/* --- source state --- */
static char *lx_src;
static int   lx_len;
static int   lx_pos;        /* byte offset of the next line to read */
static int   lx_line;       /* 1-based line number of that line */

/* fort370: the source is streamed, not read whole.  Positions are byte
 * offsets in the source, as before, but lx_src[p] is only valid inside a
 * window [lx_lo, lx_hi) of it, which lx_window refills as reading goes
 * on: lx_src is lx_buf - lx_lo, and lx_len is lx_hi, the end of what has
 * been read (lx_has tells the true end of the source from the end of the
 * window).  Nothing before min(lx_keep, lx_pos) is kept -- the card
 * reader copies a line into the statement as it reads it -- so the
 * window holds a statement and its lookahead, or, while a phase asks
 * for it through lx_keep, a unit.  The driver reads the source twice
 * (the unit scan, then each unit's compilation) by reopening it
 * (lx_reopen); on MVS SYSIN may be DD *, which cannot be read twice, so
 * the scan copies it to SYSUT1 as it goes (lx_spool).  A unit compiled
 * out of order -- an ENTRY, after the others -- rewinds the stream; a
 * unit the front end inlines is kept whole from the scan (f77_utext).
 * lx_streaming is 0 while lx_src is such a kept copy. */
static char  *lx_buf;
static int    lx_cap;
static int    lx_lo;
static int    lx_hi;
static int    lx_eof;
static int    lx_keep = 0x7FFFFFFF;
static int    lx_streaming;
static FILE  *lx_fp;
static FILE  *lx_spool;
static FILE *(*lx_reopen)(void);
#ifndef LX_AHEAD
#define LX_AHEAD 32768                   /* read at least this far past lx_pos */
#endif
#ifndef LX_CAP0
#define LX_CAP0 65536                    /* the window's first allocation */
#endif

/* --- INCLUDE (MIL-STD-1753 2.3) -------------------------------------
 *
 * INCLUDE 'name', INCLUDE (name) or INCLUDE name, alone on its line,
 * copies the named text into the source in its place.  It is done where
 * the source is read, below the card reader: a line that is an INCLUDE
 * becomes a comment, and the text it names follows it, so both readings
 * of the source (the unit scan, then each unit's compilation) see one
 * stream, its offsets and lines the same.  On MVS the scan's copy in
 * SYSUT1 is that stream, read back as it is.  The name is a member of
 * the PDS on the DD SYSLIB (its directory and extension dropped, so
 * INCLUDE 'common.inc' is member COMMON); on a host, a file beside the
 * source, then in the current directory, as written or in lower case,
 * with or without .f, .for or .inc.  An included text may INCLUDE
 * another, but not one it is being read from.
 *
 * Messages name an included text's own lines (lx_where): lx_seg says
 * where in the stream each piece of a file begins. */
static int lx_isdigit(int c);
static int lx_isalpha(int c);
static int lx_upper(int c);
#define LX_INC_DEPTH 8
#define LX_INC_LINE  4096
static FILE *lx_inc_fp[LX_INC_DEPTH];        /* [0] is the source itself */
static char  lx_inc_nm[LX_INC_DEPTH][64];
static int   lx_inc_line[LX_INC_DEPTH];      /* lines read from each */
static int   lx_inc_n;                       /* files open, 0 before the first read */
static char  lx_ibuf[LX_INC_LINE + 80];      /* the line being passed on */
static int   lx_ipos;
static int   lx_ilen;
static int   lx_ixline;                      /* lines of the stream so far */
static int   lx_inc_record = 1;              /* the first reading: note the pieces */
static const char *lx_inname;                /* the source's file name (host) */
#define LX_MAX_SEG 512
static int   lx_seg_x[LX_MAX_SEG];           /* the stream's line where a piece begins */
static int   lx_seg_o[LX_MAX_SEG];           /* its first line in its file */
static int   lx_seg_f[LX_MAX_SEG];           /* its file: an index into lx_seg_nm, -1 the source */
static char  lx_seg_nm[64][64];
static int   lx_seg_nnm;
static int   lx_nseg;

/* A file's index in lx_seg_nm, added when new (the last one shared
 * when there are more than it holds). */
static int lx_seg_file(char *nm) {
    int j;
    for (j = 0; j < lx_seg_nnm; j++) if (strcmp(lx_seg_nm[j], nm) == 0) return j;
    if (lx_seg_nnm >= 64) return 63;
    strcpy(lx_seg_nm[j], nm);
    lx_seg_nnm = lx_seg_nnm + 1;
    return j;
}

static void lx_seg_note(int file, int oline) {
    if (!lx_inc_record || lx_nseg >= LX_MAX_SEG) return;
    lx_seg_x[lx_nseg] = lx_ixline + 1;
    lx_seg_o[lx_nseg] = oline;
    lx_seg_f[lx_nseg] = file;
    lx_nseg = lx_nseg + 1;
}

/* The file and line of the stream's line x: the file's name, or 0 for
 * the source itself. */
static char *lx_where(int x, int *line) {
    int i;
    for (i = lx_nseg - 1; i >= 0; i--)
        if (lx_seg_x[i] <= x) {
            *line = lx_seg_o[i] + (x - lx_seg_x[i]);
            return lx_seg_f[i] < 0 ? 0 : lx_seg_nm[lx_seg_f[i]];
        }
    *line = x;
    return 0;
}

static void lx_inc_error(char *msg, char *nm) {
    int line;
    char *f;
    if (!lx_inc_record) return;                    /* said at the first reading */
    f = lx_where(lx_ixline + 1, &line);
    fdputs("f77: ", 2);
    if (f) { fdputs(f, 2); fdputc(' ', 2); }
    fdputs("line ", 2);
    fdputuint(2, (unsigned int)line);
    fdputs(": ", 2);
    fdputs(msg, 2);
    fdputs(nm, 2);
    fdputc('\n', 2);
    f77_nerr = f77_nerr + 1;
    f77_note_rc(F77_RC_ERROR);
    {
        char t[120];
        sprintf(t, "%.60s%.50s", msg, nm);
        f77_lst_note(lx_ixline + 1, F77_RC_ERROR, t);
    }
}

/* Is the line an INCLUDE?  Its name into nm, 1 when it is. */
static int lx_inc_is(char *ln, int n, char *nm) {
    int i;
    int k;
    int col;
    char *kw;
    if (n == 0 || ln[0] == 'C' || ln[0] == 'c' || ln[0] == '*' || ln[0] == '!') return 0;
    col = 1;
    i = 0;
    if (ln[0] == '\t') { i = 1; col = 7; }
    while (col <= 6 && i < n) {
        if (ln[i] == '\t') { i = i + 1; col = 7; break; }
        if (col == 6 ? (ln[i] != ' ' && ln[i] != '0') : ln[i] != ' ') return 0;
        i = i + 1;
        col = col + 1;
    }
    if (n > 72 && ln[0] != '\t') n = 72;              /* columns 73-80 are sequence numbers */
    while (i < n && ln[i] == ' ') i = i + 1;
    for (kw = "INCLUDE"; *kw; kw++, i++)
        if (i >= n || lx_upper(ln[i]) != *kw) return 0;
    while (i < n && ln[i] == ' ') i = i + 1;
    k = 0;
    if (i < n && (ln[i] == '\'' || ln[i] == '(')) {
        int close;
        close = ln[i] == '(' ? ')' : '\'';
        i = i + 1;
        while (i < n && ln[i] != close && k < 63) nm[k++] = ln[i++];
        if (i >= n) return 0;
        i = i + 1;
    } else {
        while (i < n && (lx_isalpha(ln[i]) || lx_isdigit(ln[i]) || ln[i] == '@' || ln[i] == '#') && k < 63)
            nm[k++] = ln[i++];
    }
    while (k > 0 && nm[k - 1] == ' ') k = k - 1;
    nm[k] = 0;
    while (i < n && (ln[i] == ' ' || ln[i] == '\r' || ln[i] == '\n')) i = i + 1;
    if (i < n && ln[i] != '!') return 0;               /* more on the line: some other statement */
    return k > 0;
}

/* Open the text an INCLUDE names. */
static FILE *lx_inc_open(char *nm) {
#ifdef __MVS__
    char mem[9];
    char dd[24];
    char *b;
    int k;
    b = nm;
    for (k = 0; nm[k]; k++) if (nm[k] == '/') b = nm + k + 1;
    for (k = 0; b[k] && b[k] != '.'; k++) {
        if (k >= 8) return 0;
        mem[k] = (char)lx_upper(b[k]);
    }
    mem[k] = 0;
    if (k == 0) return 0;
    sprintf(dd, "dd:SYSLIB(%s)", mem);
    return fopen(dd, "r");
#else
    static char *sfx[4] = { "", ".f", ".for", ".inc" };
    char path[1024];
    char low[64];
    char dir[960];
    int d;
    int c;
    int x;
    int k;
    FILE *fp;
    dir[0] = 0;
    if (lx_inname) {
        k = (int)strlen(lx_inname);
        while (k > 0 && lx_inname[k - 1] != '/' && lx_inname[k - 1] != '\\') k = k - 1;
        if (k > 0 && k < (int)sizeof dir) { memcpy(dir, lx_inname, (size_t)k); dir[k] = 0; }
    }
    for (k = 0; nm[k] && k < 63; k++) low[k] = (char)(nm[k] >= 'A' && nm[k] <= 'Z' ? nm[k] - 'A' + 'a' : nm[k]);
    low[k] = 0;
    for (d = 0; d < 2; d++)
        for (c = 0; c < 2; c++)
            for (x = 0; x < 4; x++) {
                if (d == 0 && !dir[0]) continue;
                if (strlen(dir) + strlen(nm) + 5 >= sizeof path) continue;
                sprintf(path, "%s%s%s", d == 0 ? dir : "", c ? low : nm, sfx[x]);
                fp = fopen(path, "rb");
                if (fp) return fp;
            }
    return 0;
#endif
}

/* The next line of the stream into lx_ibuf, INCLUDEs done: 0 at its end. */
static int lx_inc_next(void) {
    for (;;) {
        FILE *fp;
        int c;
        int n;
        char nm[64];
        if (lx_inc_n == 0) return 0;
        fp = lx_inc_fp[lx_inc_n - 1];
        n = 0;
        while (n < LX_INC_LINE && (c = getc(fp)) != EOF) {
            lx_ibuf[n++] = (char)c;
            if (c == '\n') break;
        }
        if (n == 0) {                                  /* this file is done */
            if (lx_inc_n == 1) return 0;
            fclose(fp);
            lx_inc_n = lx_inc_n - 1;
            if (lx_inc_record)
                lx_seg_note(lx_inc_n == 1 ? -1 : lx_seg_file(lx_inc_nm[lx_inc_n - 1]), lx_inc_line[lx_inc_n - 1] + 1);
            continue;
        }
        if (lx_ibuf[n - 1] != '\n' && n < LX_INC_LINE) lx_ibuf[n++] = '\n';   /* a last line without one */
        lx_inc_line[lx_inc_n - 1]++;
        lx_ilen = n;
        lx_ipos = 0;
        if (lx_inc_is(lx_ibuf, n, nm)) {
            FILE *ip;
            int j;
            /* the INCLUDE line itself, now a comment */
            lx_ibuf[0] = 'C';
            for (j = 1; j < lx_inc_n; j++)
                if (strcmp(lx_inc_nm[j], nm) == 0) { lx_inc_error("INCLUDE of a text being read: ", nm); break; }
            if (j < lx_inc_n) { lx_ixline++; return 1; }
            if (lx_inc_n >= LX_INC_DEPTH) { lx_inc_error("INCLUDEs nested too deep: ", nm); lx_ixline++; return 1; }
            ip = lx_inc_open(nm);
            if (!ip) {
#ifdef __MVS__
                lx_inc_error("INCLUDE: no member of SYSLIB for ", nm);
#else
                lx_inc_error("INCLUDE: no file ", nm);
#endif
                lx_ixline++;
                return 1;
            }
            lx_ixline++;
            lx_inc_fp[lx_inc_n] = ip;
            strcpy(lx_inc_nm[lx_inc_n], nm);
            lx_inc_line[lx_inc_n] = 0;
            lx_inc_n = lx_inc_n + 1;
            if (lx_inc_record) lx_seg_note(lx_seg_file(nm), 1);
            return 1;
        }
        lx_ixline++;
        return 1;
    }
}

/* fread's part, for lx_window: up to n bytes of the stream. */
static size_t lx_read(char *dst, size_t n) {
    size_t got;
    got = 0;
    while (got < n) {
        size_t k;
        if (lx_ipos >= lx_ilen && !lx_inc_next()) break;
        k = (size_t)(lx_ilen - lx_ipos);
        if (k > n - got) k = n - got;
        memcpy(dst + got, lx_ibuf + lx_ipos, k);
        lx_ipos = lx_ipos + (int)k;
        got = got + k;
    }
    return got;
}

/* The stream begins again at the source's start: what an earlier
 * reading left open is closed. */
static void lx_inc_reset(FILE *fp) {
    while (lx_inc_n > 1) { lx_inc_n = lx_inc_n - 1; fclose(lx_inc_fp[lx_inc_n]); }
    lx_inc_fp[0] = fp;
    strcpy(lx_inc_nm[0], "");
    lx_inc_line[0] = 0;
    lx_inc_n = 1;
    lx_ipos = 0;
    lx_ilen = 0;
    lx_ixline = 0;
}

static void lx_window(int need) {
    int keep;
    size_t n;
    if (!lx_streaming) return;
    keep = lx_keep < lx_pos ? lx_keep : lx_pos;
    for (;;) {
        if (keep > lx_lo) {                  /* drop what nothing needs */
            int d;
            d = keep - lx_lo;
            if (d > lx_hi - lx_lo) d = lx_hi - lx_lo;
            if (lx_hi - lx_lo - d > 0) memmove(lx_buf, lx_buf + d, (size_t)(lx_hi - lx_lo - d));
            lx_lo = lx_lo + d;
        }
        if (lx_eof || (lx_hi >= need && lx_hi >= keep)) break;
        if (lx_hi - lx_lo >= lx_cap) {
            char *nb;
            int nc;
            nc = lx_cap ? lx_cap * 2 : LX_CAP0;
            nb = (char *)realloc(lx_buf, (size_t)nc);
            if (!nb) {
#ifdef __MVS__
                f77_error(lx_reopen ? "out of storage for the source (a unit too large)"
                                    : "out of storage for the source: give the step a SYSUT1 work data set");
#else
                f77_error("out of storage for the source");
#endif
                f77_note_rc(F77_RC_TERM);
                lx_eof = 1;
                break;
            }
            lx_buf = nb;
            lx_cap = nc;
        }
        n = lx_read(lx_buf + (lx_hi - lx_lo), (size_t)(lx_cap - (lx_hi - lx_lo)));
        if (n == 0) { lx_eof = 1; break; }
        if (lx_spool) fwrite(lx_buf + (lx_hi - lx_lo), 1, n, lx_spool);
        lx_hi = lx_hi + (int)n;
    }
    lx_src = lx_buf - lx_lo;
    lx_len = lx_hi;
}

/* Is there a byte at offset p?  Reads on when the window ends first. */
static int lx_has(int p) {
    if (p < lx_len) return 1;
    if (!lx_streaming || lx_eof) return 0;
    lx_window(p + LX_AHEAD);
    return p < lx_len;
}

/* Start reading the source from its beginning (again). */
static void lx_start(FILE *fp) {
    lx_fp = fp;
    lx_inc_reset(fp);
    lx_lo = 0;
    lx_hi = 0;
    lx_eof = 0;
    lx_pos = 0;
    lx_line = 1;
    lx_streaming = 1;
    lx_window(LX_AHEAD);
}

/* Go to offset pos, the start of a line numbered line: forward through
 * the stream, or back by reading it again from the start. */
static void lx_goto(int pos, int line) {
    if (lx_streaming && pos < lx_lo) {
        FILE *fp;
        fp = lx_reopen ? lx_reopen() : 0;
        if (!fp) { f77_error("the source cannot be read again"); return; }
        lx_keep = pos;
        lx_start(fp);
        lx_keep = 0x7FFFFFFF;
    }
    lx_pos = pos;
    lx_line = line;
    if (lx_streaming) lx_window(pos + LX_AHEAD);
}

/* --- assembled statement --- */
static char  lx_stmt[F77_MAX_STMT];
static int   lx_stmt_len;
static int   lx_stmt_label; /* -1 when the statement carries no label */
static int   lx_stmt_line;  /* line number of the initial line */
/* lx_brk[i] is 1 iff a blank was squeezed out immediately before
 * lx_stmt[i] -- i.e. i starts a space-delimited token in the original
 * card.  Leading blanks (column-7 indent) do not set this; only a
 * blank between two copied characters does.  The FUNCTION-header
 * classifier uses it so INTEGER FUNCTIONAL stays one name while
 * INTEGER FUNCTION F and the no-space INTEGERFUNCTIONF(X) both still
 * open a FUNCTION unit (GitHub issue 25). */
static unsigned char *lx_brk;
static int lx_after_blank;

static void f77_error(char *msg);    /* supplied by the driver */

/* --- character helpers ---------------------------------------------- */

static int lx_isdigit(int c) { return c >= '0' && c <= '9'; }
#ifdef __MVS__
/* fort370: EBCDIC letters have gaps (i-j, r-s), so a range test would
 * take the characters between them for letters; libc370's ctype knows. */
static int lx_isalpha(int c) {
    return (c >= 0 && c < 256 && isalpha(c)) || c == '_' || c == '$';
}
static int lx_upper(int c) {
    if (c >= 0 && c < 256 && islower(c)) return toupper(c);
    return c;
}
#else
static int lx_isalpha(int c) {
    return (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') ||
           c == '_' || c == '$';
}
static int lx_upper(int c) {
    if (c >= 'a' && c <= 'z') return c - 'a' + 'A';
    return c;
}
#endif

/* --- statement assembly --------------------------------------------- */

/* True when the line starting at `p` is a comment or is entirely blank.
 * F77: C or * in column 1.  D in column 1 is a debug line, which we
 * treat as a comment (the historic default when debug lines are off). */
static int lx_is_comment(int p) {
    int c;
    if (!lx_has(p)) return 0;
    c = lx_upper(lx_src[p]);
    if (c == 'C' || c == '*' || c == '!' || c == 'D') return 1;
    return 0;
}

/* Advance past the newline that ends the line beginning at p. */
static int lx_next_line(int p) {
    while (lx_has(p) && lx_src[p] != '\n') p = p + 1;
    if (lx_has(p)) p = p + 1;
    lx_line = lx_line + 1;
    return p;
}

/* Is the line at p blank (only spaces/tabs in columns 1-72)?  Columns
 * 73-80 are sequence numbers and do not count: a card of 72 blanks with
 * its sequence number is a blank card.  FCVS decks have them, and before
 * this rule such a card assembled as an empty statement, which the
 * reader reported as end of file -- half the program vanished with no
 * diagnostic but a missing FORMAT (FM036, FM038). */
static int lx_is_blank_line(int p) {
    int col;
    col = 1;
    while (lx_has(p) && lx_src[p] != '\n' && col <= 72) {
        if (lx_src[p] != ' ' && lx_src[p] != '\t' && lx_src[p] != '\r')
            return 0;
        p = p + 1;
        col = col + 1;
    }
    return 1;
}

/* Locate the statement body of the line at p.
 * Returns the offset of the first body character, and reports through
 * *cont whether the line is a continuation, and through *label the
 * value in columns 1-5 (-1 when blank). */
static int lx_line_body(int p, int *cont, int *label) {
    int col;
    int lab;
    int have_lab;
    int c;

    *cont = 0;
    *label = -1;
    lab = 0;
    have_lab = 0;
    col = 1;

    while (lx_has(p) && lx_src[p] != '\n' && col <= 6) {
        c = lx_src[p];
        if (c == '\t') {
            /* Tab-format extension: the tab ends the label field.  A
             * digit 1-9 immediately after it marks a continuation;
             * anything else begins the statement body. */
            p = p + 1;
            if (lx_has(p) && lx_src[p] >= '1' && lx_src[p] <= '9') {
                *cont = 1;
                p = p + 1;
            }
            if (have_lab) *label = lab;
            return p;
        }
        if (col == 6) {
            if (c != ' ' && c != '0') *cont = 1;
            p = p + 1;
            col = col + 1;
            break;
        }
        if (lx_isdigit(c)) { lab = lab * 10 + (c - '0'); have_lab = 1; }
        else if (c != ' ') {
            /* Junk in the label field: not fatal, F77 decks vary. */
        }
        p = p + 1;
        col = col + 1;
    }
    if (have_lab) *label = lab;
    return p;
}

/* Append one character to the statement buffer. */
static void lx_put(int c) {
    if (lx_stmt_len >= F77_MAX_STMT - 1) {
        f77_error("statement too long");
        return;
    }
    lx_brk[lx_stmt_len] = lx_after_blank ? 1 : 0;
    lx_stmt[lx_stmt_len] = (char)c;
    lx_stmt_len = lx_stmt_len + 1;
    lx_after_blank = 0;
}

/* Was the text just emitted an unsigned integer immediately preceded by
 * a non-alphanumeric?  That is what makes a following H a Hollerith
 * count rather than part of an identifier. */
static int lx_hcount_digits;   /* digits consumed by the count just read */

static int lx_pending_hollerith_count(void) {
    int i;
    int n;
    int v;
    i = lx_stmt_len - 1;
    n = 0;
    while (i >= 0 && lx_stmt[i] >= '0' && lx_stmt[i] <= '9') { i = i - 1; n = n + 1; }
    lx_hcount_digits = n;
    if (n == 0) return -1;
    if (i >= 0 && (lx_isalpha(lx_stmt[i]) || lx_stmt[i] == '.')) return -1;
    /* A type's length, REAL*8 H or CHARACTER*8 HUE squeezed to
     * REAL*8H...: the statement so far is the type keyword itself (a
     * DATA repeat count, 2*8H..., keeps its Hollerith).  From SLOW-32
     * 4d8ecc39; DOUBLECOMPLEX is fort370's. */
    if (i >= 0 && lx_stmt[i] == '*') {
        static char *tys[] = { "INTEGER", "LOGICAL", "COMPLEX", "REAL", "CHARACTER",
                               "DOUBLEPRECISION", "DOUBLECOMPLEX", 0 };
        int k;
        for (k = 0; tys[k]; k++)
            if ((int)strlen(tys[k]) == i && strncmp(lx_stmt, tys[k], (size_t)i) == 0) return -1;
    }
    v = 0;
    i = i + 1;
    while (i < lx_stmt_len) { v = v * 10 + (lx_stmt[i] - '0'); i = i + 1; }
    return v;
}

/* Is an apostrophe here FORTRAN IV's direct-access record separator,
 * READ (u'r), WRITE (u'r) or FIND (u'r) -- the statement so far that
 * keyword, a parenthesis and a unit, alone or after a logical IF's
 * condition?  Then it is no character constant; the caller writes it
 * as the control-list keyword DAREC= (f77_io_control). */
static int lx_da_apostrophe(void) {
    static char *kw[3] = { "READ(", "WRITE(", "FIND(" };
    int i;
    int k;
    int n;
    i = lx_stmt_len;
    while (i > 0 && (lx_isalpha(lx_stmt[i - 1]) || (lx_stmt[i - 1] >= '0' && lx_stmt[i - 1] <= '9'))) i = i - 1;
    if (i == lx_stmt_len) return 0;
    for (k = 0; k < 3; k++) {
        n = (int)strlen(kw[k]);
        if (i >= n && memcmp(lx_stmt + i - n, kw[k], (size_t)n) == 0 &&
            (i == n || lx_stmt[i - n - 1] == ')')) return 1;
    }
    return 0;
}

/* Assemble the next statement.  Returns 1 on success, 0 at end of file. */
static int f77_next_stmt(void) {
    int p;
    int body;
    int cont;
    int label;
    int col;
    int c;
    int inq;
    int hcount;
    int first;
    int listed;       /* fort370: the statement's line is in the listing (f77_lst_card) */

    listed = 0;
    lx_stmt_len = 0;
    lx_stmt_label = -1;
    lx_after_blank = 0;
    first = 1;
    inq = 0;
    lx_window(lx_pos + LX_AHEAD);

    for (;;) {
        /* Skip comment and blank lines. */
        while (lx_has(lx_pos) &&
               (lx_is_comment(lx_pos) || lx_is_blank_line(lx_pos))) {
            f77_lst_card(lx_pos, 0);
            lx_pos = lx_next_line(lx_pos);
        }
        if (!lx_has(lx_pos)) break;

        p = lx_pos;
        body = lx_line_body(p, &cont, &label);

        if (!first && !cont) break;      /* a new statement begins here */
        if (first && cont) {
            /* Continuation with nothing to continue: tolerate it. */
            cont = 0;
        }
        if (first) {
            lx_stmt_label = label;
            lx_stmt_line = lx_line;
        }

        /* Copy columns 7-72, squeezing blanks outside character context. */
        col = 7;
        p = body;
        while (lx_has(p) && lx_src[p] != '\n' && col <= 72) {
            c = lx_src[p];
            if (c == '\r') { p = p + 1; continue; }
            if (inq) {
                lx_put(c);
                if (c == '\'') {
                    /* '' inside a constant is an escaped quote. */
                    if (lx_has(p + 1) && lx_src[p + 1] == '\'') {
                        p = p + 1;
                        col = col + 1;
                        lx_put('\'');
                    } else {
                        inq = 0;
                    }
                }
                p = p + 1;
                col = col + 1;
                continue;
            }
            if (c == ' ' || c == '\t') {
                /* A blank between copied characters is a token
                 * boundary; leading indent is not. */
                if (lx_stmt_len > 0) lx_after_blank = 1;
                p = p + 1;
                col = col + 1;
                continue;
            }
            if (c == '!') break;                  /* trailing comment */
            if (c == '\'' && lx_da_apostrophe()) {
                char *t;
                for (t = ",DAREC="; *t; t++) lx_put(*t);
                p = p + 1;
                col = col + 1;
                continue;
            }
            if (c == '\'') { inq = 1; lx_put(c); p = p + 1; col = col + 1; continue; }
            if (lx_upper(c) == 'H') {
                hcount = lx_pending_hollerith_count();
                if (hcount > 0) {
                    /* Copy exactly hcount raw characters, blanks kept.
                     * Represent it as a quoted constant so the tokenizer
                     * has one string form to handle. */
                    int k;
                    /* Retract the count digits: they are part of the
                     * Hollerith constant, not a separate integer. */
                    lx_stmt_len = lx_stmt_len - lx_hcount_digits;
                    lx_put('\'');
                    p = p + 1;
                    col = col + 1;
                    k = 0;
                    while (k < hcount) {
                        if (col <= 72 && (!lx_has(p) || lx_src[p] == '\n' || lx_src[p] == '\r')) {
                            /* fort370: a line ending short of column
                             * 72 is blank to 72, as its card was, and
                             * the blanks are part of the constant */
                            lx_put(' ');
                            col = col + 1;
                            k = k + 1;
                            continue;
                        }
                        if (!lx_has(p) || lx_src[p] == '\n' || col > 72) {
                            /* The constant continues on the next
                             * continuation line (comments between are
                             * allowed), from its column 7. */
                            int q;
                            int qcont;
                            int qlabel;
                            q = lx_next_line(lx_pos);
                            while (lx_has(q) && (lx_is_comment(q) || lx_is_blank_line(q)))
                                q = lx_next_line(q);
                            if (!lx_has(q)) {
                                f77_error("Hollerith constant runs off the end of the file");
                                break;
                            }
                            p = lx_line_body(q, &qcont, &qlabel);
                            if (!qcont) {
                                f77_error("Hollerith constant runs off the line");
                                break;
                            }
                            {
                                /* fort370: the line left, and the comments
                                 * passed, into the listing */
                                int r;
                                f77_lst_card(lx_pos, listed ? 2 : 1);
                                listed = 1;
                                r = lx_pos;
                                while (lx_has(r) && lx_src[r] != '\n') r = r + 1;
                                if (lx_has(r)) r = r + 1;
                                while (r < q) {
                                    f77_lst_card(r, 0);
                                    while (lx_has(r) && lx_src[r] != '\n') r = r + 1;
                                    if (lx_has(r)) r = r + 1;
                                }
                            }
                            lx_pos = q;
                            col = 7;
                            continue;
                        }
                        if (lx_src[p] == '\'') lx_put('\'');
                        lx_put(lx_src[p]);
                        p = p + 1;
                        col = col + 1;
                        k = k + 1;
                    }
                    lx_put('\'');
                    continue;
                }
            }
            lx_put(lx_upper(c));
            p = p + 1;
            col = col + 1;
        }
        /* fort370: a character constant still open at the end of a line
         * short of column 72 keeps the blanks its card had out to 72,
         * before the continuation line's text -- so a host file with its
         * trailing blanks trimmed reads as the deck on MVS does */
        if (inq) while (col <= 72) { lx_put(' '); col = col + 1; }

        f77_lst_card(lx_pos, listed ? 2 : 1);
        listed = 1;
        lx_pos = lx_next_line(lx_pos);
        first = 0;

        /* Peek: is the next non-comment line a continuation? */
        {
            int q;
            int qcont;
            int qlabel;
            q = lx_pos;
            while (lx_has(q) && (lx_is_comment(q) || lx_is_blank_line(q))) {
                f77_lst_card(q, 0);
                q = lx_next_line(q);
                lx_pos = q;
            }
            if (!lx_has(q)) break;
            lx_line_body(q, &qcont, &qlabel);
            if (!qcont) break;
        }
    }

    lx_stmt[lx_stmt_len] = 0;
    return lx_stmt_len > 0 || lx_stmt_label >= 0;
}

#endif
