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
                lx_eof = 1;
                break;
            }
            lx_buf = nb;
            lx_cap = nc;
        }
        n = fread(lx_buf + (lx_hi - lx_lo), 1, (size_t)(lx_cap - (lx_hi - lx_lo)), lx_fp);
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

        lx_pos = lx_next_line(lx_pos);
        first = 0;

        /* Peek: is the next non-comment line a continuation? */
        {
            int q;
            int qcont;
            int qlabel;
            q = lx_pos;
            while (lx_has(q) && (lx_is_comment(q) || lx_is_blank_line(q))) {
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
