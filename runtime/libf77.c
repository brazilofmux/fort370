/* COPIED from slow32-public fortran/runtime/libf77.c at 2245be78 (2026-10-12).  See PROVENANCE.md. */
/* libf77.c -- Fortran 77 formatted I/O runtime for SLOW-32.
 *
 * FORMAT is an interpreted mini-language, not something a compiler can
 * expand inline: the edit descriptors are consumed on demand as the I/O
 * list supplies items, repeat counts and nested groups have run-time
 * state, and when the list outlasts the format the format REVERTS --
 * restarting at the last top-level group rather than at the beginning.
 * So the compiler emits a format string plus a sequence of item calls,
 * and this walks the format between them.
 *
 * Numeric rendering defers to snprintf, which on SLOW-32 is David Gay's
 * dtoa; that is what makes F/E/D/G output match a reference Fortran's
 * digits instead of merely being close.
 *
 * Built for SLOW-32 with clang (see build.sh).  fortran/ is in the
 * tree's ordinary universe, so using the host toolchain to produce
 * guest code is the normal arrangement here.
 */
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <ctype.h>

#define FIO_MAXFMT   1024
#define FIO_MAXLINE  1024
#define FIO_MAXGROUP 16

static const char *fio_fmt;      /* format text, without outer parens */
static int   fio_pos;            /* cursor into fio_fmt */
static int   fio_unit;
static char  fio_line[FIO_MAXLINE];
static int   fio_len;

/* Repeat state for the descriptor currently being consumed. */
static int   fio_rep;            /* repeats left on the active descriptor */
static int   fio_desc;           /* active descriptor letter, 0 = none */
static int   fio_w, fio_d;       /* width and digits of the active one */

/* Group stack: start position and remaining count of each open ( ). */
static int   fio_gstart[FIO_MAXGROUP];
static int   fio_gcount[FIO_MAXGROUP];
static int   fio_gdepth;
static int   fio_scale;    /* the kP scale factor in force */

/* Where the last TOP-LEVEL group began, for format reversion. */
static int   fio_revert;

static int   fio_listed;         /* 1 = list-directed (FMT=*) */
static int   fio_first_item;

/* Input state.  The format walker is shared between WRITE and READ;
 * fio_reading flips the direction of the record-affecting descriptors
 * (literals, X, /, end-of-format reversion). */
static int   fio_reading;        /* 1 = READ in progress */
static char  fio_rec[FIO_MAXLINE];  /* current input record */
static int   fio_rlen;
static int   fio_rpos;
static int   fio_ldone;          /* list-directed: '/' seen, rest untouched */
static int   fio_l_pending;      /* list-directed r*c: repeats left on fio_ltok */
static char  fio_ltok[128];

/* Open units.  0/5/6 are preconnected (stderr/stdin/stdout, matching
 * gfortran) and may not be OPENed; everything else goes through the
 * table.  The name is kept for CLOSE (STATUS='DELETE'). */
#define FIO_MAXUNIT 100                  /* units 0-99, as IBM's Fortran numbers them */
#define FIO_MAXNAME 256
static FILE *fio_ufile[FIO_MAXUNIT];
static char  fio_ufname[FIO_MAXUNIT][FIO_MAXNAME];
/* Logical end of file set by ENDFILE (-1 = the physical end): a READ
 * at or past it sees end of file, a WRITE moves it. */
static long  fio_uend[FIO_MAXUNIT];
static int   fio_uend_init;
static int   fio_udirect[FIO_MAXUNIT];   /* ACCESS='DIRECT' */
static int   fio_uunf[FIO_MAXUNIT];      /* FORM='UNFORMATTED' */
static int   fio_urecl[FIO_MAXUNIT];     /* RECL= in bytes */
static int   fio_ubz[FIO_MAXUNIT];       /* BLANK='ZERO' */
static int   fio_rec_next;               /* REC= of the statement about to begin, or 0 */
static int   fio_uaeof[FIO_MAXUNIT];     /* positioned after the endfile record */
static int   fio_recoverable;            /* ERR=/IOSTAT= present: report, do not exit */
static int   fio_err;                    /* set when a recoverable error happened */
/* Unformatted record buffer: assembled on WRITE, consumed on READ. */
#define FIO_MAXUREC 65536
static unsigned char fio_urec[FIO_MAXUREC];
static int   fio_ulen;
static int   fio_upos;
/* Internal file in progress (NULL = external): the CHARACTER entity's
 * records, each fio_ilen bytes, fio_inrec of them, fio_irec next. */
static char *fio_ibuf;
static int   fio_ilen;
static int   fio_inrec;
static int   fio_irec;
static int   fio_draining;       /* wr_end: no reversion at end of format */
static int   fio_bz;             /* BZ in effect: blanks in a field are zeros */
static int   fio_sp;             /* SP in effect: a plus sign on positive numbers */
static int   fio_e;              /* Ew.dEe exponent digits, 0 = default */
/* List-directed layout follows gfortran: INTEGER in a 12-wide field,
 * character items run together after one separating blank. */
static int   fio_prev_char;
static FILE *fio_in;             /* stream of the READ in progress */
static FILE *fio_out;            /* stream of the WRITE in progress */

static FILE *fio_resolve(int unit, int writing) {
    if (unit >= 0 && unit < FIO_MAXUNIT && fio_ufile[unit]) return fio_ufile[unit];
    if (writing) {
        if (unit == 6) return stdout;
        if (unit == 0) return stderr;
        if (unit == 5) return stdout;    /* tolerated historically */
    } else {
        if (unit == 5 || unit == 0) return stdin;
    }
    if (unit > 0 && unit < FIO_MAXUNIT) {
        /* Preconnected unit: the file fort.N in the working directory,
         * created on first use (gfortran's convention). */
        char nm[FIO_MAXNAME];
        FILE *f;
        snprintf(nm, sizeof nm, "fort.%d", unit);
        f = fopen(nm, "r+");
        if (!f) f = fopen(nm, "w+");
        if (f) {
            fio_ufile[unit] = f;
            strcpy(fio_ufname[unit], nm);
            fio_uend[unit] = -1;
            fio_udirect[unit] = 0; fio_uunf[unit] = 0; fio_urecl[unit] = 0; fio_ubz[unit] = 0;
            return f;
        }
    }
    fprintf(stderr, "f77: unit %d is not open for %s\n",
            unit, writing ? "WRITE" : "READ");
    exit(2);
    return 0;
}

/* Case-insensitive match of a counted, possibly blank-padded Fortran
 * string against a keyword. */
static int fio_str_is(const char *s, int len, const char *kw) {
    int i;
    for (i = 0; i < len && kw[i]; i++) {
        int c = s[i];
        if (c >= 'a' && c <= 'z') c = c - 'a' + 'A';
        if (c != kw[i]) return 0;
    }
    if (kw[i]) return 0;
    for (; i < len; i++) if (s[i] != ' ') return 0;
    return 1;
}

/* The output line has a cursor (fio_col) distinct from its length:
 * X and T editing move the cursor, characters are written at it
 * (overwriting, or extending the line with blanks when the cursor is
 * past the end), so `T1` after text overprints and trailing X emits no
 * blanks -- both as gfortran does. */
static int fio_col;
static void fio_putc(int c) {
    if (fio_col >= FIO_MAXLINE - 1) return;
    while (fio_len < fio_col) fio_line[fio_len++] = ' ';
    fio_line[fio_col] = (char)c;
    fio_col++;
    if (fio_col > fio_len) fio_len = fio_col;
}

static void fio_puts(const char *s) {
    while (*s) fio_putc(*s++);
}

static int fio_unit;             /* unit of the statement in progress */

static void fio_flush_line(void) {
    FILE *f = fio_out ? fio_out : stdout;
    fio_line[fio_len] = 0;
    fio_col = 0;
    if (fio_ibuf) {
        int i;
        if (fio_irec >= fio_inrec) {
            fprintf(stderr, "f77: WRITE past the end of an internal file\n");
            exit(2);
        }
        if (fio_len > fio_ilen) {
            fprintf(stderr, "f77: record longer than the internal file (%d > %d)\n", fio_len, fio_ilen);
            exit(2);
        }
        memcpy(fio_ibuf + fio_irec * fio_ilen, fio_line, (size_t)fio_len);
        for (i = fio_len; i < fio_ilen; i++) fio_ibuf[fio_irec * fio_ilen + i] = ' ';
        fio_irec++;
        fio_len = 0;
        return;
    }
    if (fio_unit > 0 && fio_unit < FIO_MAXUNIT && fio_udirect[fio_unit]) {
        int recl = fio_urecl[fio_unit];
        int i;
        if (fio_len > recl) {
            fprintf(stderr, "f77: record longer than RECL (%d > %d)\n", fio_len, recl);
            exit(2);
        }
        fwrite(fio_line, 1, (size_t)fio_len, f);
        for (i = fio_len; i < recl; i++) fputc(' ', f);
        fio_len = 0;
        return;
    }
    /* All fio_len bytes: a CHARACTER item may hold X'00', which
     * fputs took for the end of the record and dropped the rest. */
    fwrite(fio_line, 1, (size_t)fio_len, f);
    fputc('\n', f);
    fio_len = 0;
    if (fio_unit > 0 && fio_unit < FIO_MAXUNIT && fio_unit != 5 && fio_unit != 6)
        fio_uend[fio_unit] = ftell(f);
}

/* SP: a positive number gets a leading plus. */
static void fio_plus(char *buf) {
    if (!fio_sp) return;
    if (buf[0] == '-' || buf[0] == '+' || buf[0] == 0) return;
    memmove(buf + 1, buf, strlen(buf) + 1);
    buf[0] = '+';
}

/* A numeric field one column too wide whose first character is the
 * optional zero before the decimal point drops that zero (F77
 * 13.5.9.2: the zero is optional, and gfortran omits it exactly then). */
static void fio_drop_zero(char *buf, int w) {
    int n = (int)strlen(buf);
    if (w <= 0 || n != w + 1) return;
    if (buf[0] == '0' && buf[1] == '.') memmove(buf, buf + 1, (size_t)n);
    else if ((buf[0] == '-' || buf[0] == '+') && buf[1] == '0' && buf[2] == '.') memmove(buf + 1, buf + 2, (size_t)(n - 1));
}

static void fio_pad(int n) { if (n > 0) fio_col += n; }
/* Blanks that are part of a field (G editing's trailer) are written. */
static void fio_blanks(int n) { while (n-- > 0) fio_putc(' '); }

/* Right-justify `s` in a field of `w`; a field too narrow is filled
 * with asterisks, which is what Fortran does rather than overflowing. */
static void fio_field(const char *s, int w) {
    int n = (int)strlen(s);
    if (w <= 0) { fio_puts(s); return; }
    if (n > w) { while (w-- > 0) fio_putc('*'); return; }
    fio_pad(w - n);
    fio_puts(s);
}

static int fio_isdigit(int c) { return c >= '0' && c <= '9'; }

/* Fetch the next input record.  Returns 1 at end of file.  A record
 * shorter than the fields read from it behaves as if blank-padded,
 * which fio_field_in provides by supplying blanks past fio_rlen. */
static int fio_getrec(void) {
    if (fio_ibuf) {
        if (fio_irec >= fio_inrec) return 1;
        memcpy(fio_rec, fio_ibuf + fio_irec * fio_ilen, (size_t)fio_ilen);
        fio_rlen = fio_ilen;
        fio_rpos = 0;
        fio_irec++;
        return 0;
    }
    if (fio_unit > 0 && fio_unit < FIO_MAXUNIT && fio_uend[fio_unit] >= 0 &&
        fio_in && ftell(fio_in) >= fio_uend[fio_unit]) { fio_uaeof[fio_unit] = 1; return 1; }
    if (fio_unit > 0 && fio_unit < FIO_MAXUNIT && fio_udirect[fio_unit]) {
        int recl = fio_urecl[fio_unit];
        size_t n;
        if (recl > FIO_MAXLINE - 1) recl = FIO_MAXLINE - 1;
        n = fread(fio_rec, 1, (size_t)recl, fio_in);
        if (n == 0) return 1;
        fio_rlen = (int)n;
        fio_rpos = 0;
        return 0;
    }
    /* fgets, counted: a record may hold CHAR(0), where strlen stopped. */
    {
        FILE *in = fio_in ? fio_in : stdin;
        int c = 0, n = 0;
        while (n < FIO_MAXLINE - 1 && (c = getc(in)) != EOF) {
            fio_rec[n++] = (char)c;
            if (c == '\n') break;
        }
        if (n == 0) {
            if (fio_unit > 0 && fio_unit < FIO_MAXUNIT) fio_uaeof[fio_unit] = 1;
            return 1;
        }
        fio_rec[n] = '\0';
        fio_rlen = n;
    }
    while (fio_rlen > 0 &&
           (fio_rec[fio_rlen - 1] == '\n' || fio_rec[fio_rlen - 1] == '\r'))
        fio_rlen--;
    fio_rpos = 0;
    return 0;
}

/* Mid-statement end of file is an error: END= is checked only when the
 * READ begins, which covers the read-until-EOF idiom. */
static void fio_next_record(void) {
    if (fio_getrec()) {
        fprintf(stderr, "f77: end of file on READ\n");
        exit(2);
    }
}

static int fio_number(void) {
    int v = 0;
    while (fio_isdigit(fio_fmt[fio_pos]))
        v = v * 10 + (fio_fmt[fio_pos++] - '0');
    return v;
}

/* fort370: a format given at run time -- a CHARACTER variable, an
 * array, an expression -- is checked before it is used, as the compiler
 * checks the ones it can see (fort370 issues 24, 25).  Blanks are not
 * significant in a format outside its quoted strings and nH text (F77
 * 13.1.2, 3.1.6): VS FORTRAN takes ( 3I 2), and a format built with
 * WRITE (FMT, '(''('',I2,''I'',I2,'')'')') has them.  fio_fmt_prep
 * copies the format to fio_fbuf without them, up to its closing ),
 * a "string" made an 'string'; fio_fmt_check then refuses what is
 * certainly wrong.  A malformed format used to be read some other way:
 * (HI,MOM) skipped the M, O and M and reverted with no data descriptor,
 * one empty record per pass, 150,000 records. */
static char fio_fbuf[FIO_MAXFMT];
static const char *fio_fmt_why;          /* why the format was refused */
static int   fio_since_data;             /* a data descriptor since the last reversion */
static int   fio_ftext;                  /* fio_fbuf's end of the last nH or quoted text */

/* Digits here are a width, not a count: the last character copied
 * takes one (Iw, Tc, TLc, Fw.d, Ew.dEe), and BZ's Z does not. */
static int fio_fmt_width_next(int j) {
    int c, b;
    if (j == 0 || j == fio_ftext) return 0;
    c = toupper((unsigned char)fio_fbuf[j - 1]);
    b = j >= 2 ? toupper((unsigned char)fio_fbuf[j - 2]) : 0;
    if (c == 'Z') return b != 'B';
    return c == 'I' || c == 'F' || c == 'E' || c == 'D' || c == 'G' ||
           c == 'L' || c == 'A' || c == 'O' || c == 'T' || c == 'R' || c == '.';
}

static int fio_fmt_prep(const char *fmt) {
    int i, j, depth, q, n;
    i = 0;
    j = 0;
    depth = 0;
    fio_ftext = -1;
    while (fmt[i] == ' ') i++;
    if (fmt[i] != '(') { fio_fmt_why = "a format begins with ("; return -1; }
    for (;;) {
        int c = fmt[i];
        if (j >= FIO_MAXFMT - 2) { fio_fmt_why = "the format is too long, or ends without its )"; return -1; }
        if (c == 0) { fio_fmt_why = "the format ends without its )"; return -1; }
        if (c == ' ') { i++; continue; }
        if (c == '\'' || c == '"') {
            q = c;
            fio_fbuf[j++] = '\'';
            i++;
            for (;;) {
                if (fmt[i] == 0 || j >= FIO_MAXFMT - 3) { fio_fmt_why = "a quoted string runs past the end of the format"; return -1; }
                if (fmt[i] == q) {
                    if (fmt[i + 1] != q) { i++; break; }
                    i++;                             /* '' or "" stands for one */
                }
                if (fmt[i] == '\'') fio_fbuf[j++] = '\'';
                fio_fbuf[j++] = fmt[i++];
            }
            fio_fbuf[j++] = '\'';
            fio_ftext = j;
            continue;
        }
        if (fio_isdigit(c) && !fio_fmt_width_next(j)) {
            /* a count: nH takes the n characters after it as they are */
            n = 0;
            while (fio_isdigit(fmt[i]) || fmt[i] == ' ') {
                if (fmt[i] != ' ') {
                    if (j >= FIO_MAXFMT - 2) { fio_fmt_why = "the format is too long"; return -1; }
                    n = n * 10 + (fmt[i] - '0');
                    fio_fbuf[j++] = fmt[i];
                }
                i++;
            }
            if (fmt[i] == 'H' || fmt[i] == 'h') {
                if (n == 0) { fio_fmt_why = "0H is no Hollerith string"; return -1; }
                if (j + n >= FIO_MAXFMT - 2) { fio_fmt_why = "the format is too long"; return -1; }
                fio_fbuf[j++] = fmt[i++];
                while (n-- > 0) {
                    if (fmt[i] == 0) { fio_fmt_why = "nH wants more characters than the format has"; return -1; }
                    fio_fbuf[j++] = fmt[i++];
                }
                fio_ftext = j;
            }
            continue;
        }
        fio_fbuf[j++] = (char)c;
        i++;
        if (c == '(') depth++;
        if (c == ')' && --depth == 0) break;  /* what follows is ignored (F77 13.1.1) */
    }
    fio_fbuf[j] = 0;
    return 0;
}

static int fio_fmt_digits(const char *s, int *i) {
    int v = 0;
    if (!fio_isdigit(s[*i])) return -1;
    while (fio_isdigit(s[*i])) { v = v * 10 + (s[*i] - '0'); *i = *i + 1; }
    return v;
}

/* The compiler's f77_check_format, on fio_fbuf: no blanks, an nH's
 * count known good, one ) at the end. */
static int fio_fmt_check(void) {
    const char *s = fio_fbuf;
    static char why[64];
    int i = 1, c, cnt;
    for (;;) {
        c = s[i];
        if (c == 0) return 0;
        if (c == ',' || c == '/' || c == ':' || c == '(' || c == ')') { i++; continue; }
        if (c == '\'') {
            i++;
            for (;;) {
                if (s[i] == '\'') { if (s[i + 1] == '\'') { i += 2; continue; } i++; break; }
                i++;
            }
            continue;
        }
        cnt = -1;
        if (c == '+' || c == '-') {
            i++;
            cnt = fio_fmt_digits(s, &i);
            if (cnt < 0 || toupper((unsigned char)s[i]) != 'P') { fio_fmt_why = "a sign belongs to a scale factor, nP"; return -1; }
        } else if (fio_isdigit(c)) {
            cnt = fio_fmt_digits(s, &i);
        }
        c = toupper((unsigned char)s[i]);
        if (c == 'H') {
            if (cnt < 0) { fio_fmt_why = "H needs its count, nH"; return -1; }
            i = i + 1 + cnt;                 /* fio_fmt_prep counted it */
            continue;
        }
        if (cnt >= 0 && c == '(') { i++; continue; }
        if (c == 'X' || (cnt >= 0 && c == 'P')) { i++; continue; }
        if (c == 'T') {
            i++;
            c = toupper((unsigned char)s[i]);
            if (c == 'L' || c == 'R') i++;
            if (fio_fmt_digits(s, &i) < 0) { fio_fmt_why = "T, TL and TR take a column"; return -1; }
            continue;
        }
        if (c == 'S') {
            i++;
            c = toupper((unsigned char)s[i]);
            if (c == 'P' || c == 'S') i++;
            continue;
        }
        if (c == 'B') {
            i++;
            c = toupper((unsigned char)s[i]);
            if (c == 'N' || c == 'Z') { i++; continue; }
            fio_fmt_why = "B is BN or BZ";
            return -1;
        }
        if (c == 'A' || c == 'Z' || c == 'O') {
            i++;
            (void)fio_fmt_digits(s, &i);
            continue;
        }
        if (c == 'I' || c == 'F' || c == 'E' || c == 'D' || c == 'G' || c == 'L') {
            i++;
            if (fio_fmt_digits(s, &i) < 0) {
                sprintf(why, "%c needs a width", c);
                fio_fmt_why = why;
                return -1;
            }
            if (s[i] == '.') {
                i++;
                if (fio_fmt_digits(s, &i) < 0) { fio_fmt_why = "a . needs digits after it"; return -1; }
            }
            if ((c == 'E' || c == 'G' || c == 'D') && toupper((unsigned char)s[i]) == 'E') {
                i++;
                if (fio_fmt_digits(s, &i) < 0) { fio_fmt_why = "Ee needs its digits"; return -1; }
            }
            continue;
        }
        if (cnt >= 0) {
            fio_fmt_why = c == ')' || c == ',' || c == '/' || c == ':' ? "a count with no descriptor after it"
                                                : "a count before something that is no edit descriptor";
            return -1;
        }
        sprintf(why, "%c is no edit descriptor", s[i]);
        fio_fmt_why = why;
        return -1;
    }
}

/* The format as it was given, for the message: up to its ) or 80
 * characters. */
static void fio_fmt_fail(const char *fmt) {
    int n = 0, depth = 0;
    while (fmt[n] && n < 80) {
        if (fmt[n] == '(') depth++;
        if (fmt[n] == ')' && --depth == 0) { n++; break; }
        n++;
    }
    fprintf(stderr, "f77: FORMAT: %s\n  in: %.*s\n", fio_fmt_why, n, fmt);
}

/* A CHARACTER format is its declared length, not up to a 0 byte (F77
 * 13.1.1): f77_fmt_lim, called just before the begin, gives that
 * length, and the format is read from a copy that ends there.  -1 for
 * a FORMAT statement or an ASSIGNed label, whose text ends in a 0. */
static int fio_fmt_lim = -1;
static char fio_flim[FIO_MAXFMT + 1];
void f77_fmt_lim(int n) { fio_fmt_lim = n; }

/* 0, fio_fmt the checked format; -1 refused, the message written. */
static int fio_fmt_use(const char *fmt) {
    int lim = fio_fmt_lim;
    fio_fmt_lim = -1;
    if (fmt && lim >= 0) {
        int n = lim < FIO_MAXFMT ? lim : FIO_MAXFMT;
        memcpy(fio_flim, fmt, (size_t)n);
        fio_flim[n] = 0;
        fmt = fio_flim;
    }
    if (fmt != fio_fbuf) {
        if (fio_fmt_prep(fmt) < 0 || fio_fmt_check() < 0) { fio_fmt_fail(fmt); return -1; }
    }
    fio_fmt = fio_fbuf;
    return 0;
}

/* Items remain and the format is at its end: it is used again from
 * the reversion point (F77 13.3) -- unless it has had no data
 * descriptor since it last was, when it would make empty records for
 * ever.  F77 forbids it; VS FORTRAN stops the program too. */
static void fio_no_data(void) {
    if (!fio_since_data) {
        fio_flush_line();
        fprintf(stderr, "f77: FORMAT: no data edit descriptor for the items left\n");
        exit(2);
    }
    fio_since_data = 0;
}

/* Walk the format, emitting literal items, until a DATA descriptor is
 * reached.  Returns its letter, or 0 if the format ran out with no data
 * descriptor left (which ends the record). */
static int fio_next_desc(void) {
    int c;
    int n;
    int item_start;
    int nneg;
    int guard = 0;

    for (;;) {
        if (++guard > 100000) return 0;          /* malformed format */
        c = fio_fmt[fio_pos];

        if (c == 0) {
            /* End of format.  If items remain, revert to the last
             * top-level group; otherwise the record is done.  On input,
             * a new record is taken where output would start a new
             * line. */
            if (fio_gdepth > 0) { fio_gdepth = 0; }
            if (fio_draining || fio_revert < 0) return 0;
            fio_no_data();
            fio_pos = fio_revert;
            if (fio_fmt[fio_pos] == 0) return 0;
            if (fio_reading) fio_next_record();
            else fio_flush_line();
            continue;
        }
        if (c == ' ' || c == ',') { fio_pos++; continue; }

        if (c == 'S' || c == 's') {
            /* S, SP, SS: optional plus sign control, sticky (13.5.6) */
            fio_pos++;
            if (fio_fmt[fio_pos] == 'P' || fio_fmt[fio_pos] == 'p') { fio_sp = 1; fio_pos++; }
            else if (fio_fmt[fio_pos] == 'S' || fio_fmt[fio_pos] == 's') { fio_sp = 0; fio_pos++; }
            else fio_sp = 0;
            continue;
        }
        if (c == ':') {
            /* colon editing: ends format control when no items remain */
            fio_pos++;
            if (fio_draining) return 0;
            continue;
        }
        if ((c == 'B' || c == 'b') &&
            (fio_fmt[fio_pos + 1] == 'N' || fio_fmt[fio_pos + 1] == 'n' ||
             fio_fmt[fio_pos + 1] == 'Z' || fio_fmt[fio_pos + 1] == 'z')) {
            /* BN / BZ: blank interpretation on input, sticky for the
             * rest of the statement (13.5.8). */
            fio_bz = (fio_fmt[fio_pos + 1] == 'Z' || fio_fmt[fio_pos + 1] == 'z');
            fio_pos += 2;
            continue;
        }

        if (c == '/') {
            fio_pos++;
            if (fio_reading) fio_next_record();
            else fio_flush_line();
            continue;
        }

        if (c == '\'') {
            /* Apostrophe editing is output-only in F77; on input the
             * text is skipped rather than transferred. */
            fio_pos++;
            while (fio_fmt[fio_pos]) {
                if (fio_fmt[fio_pos] == '\'') {
                    if (fio_fmt[fio_pos + 1] == '\'') {
                        if (!fio_reading) fio_putc('\'');
                        fio_pos += 2;
                        continue;
                    }
                    fio_pos++;
                    break;
                }
                if (!fio_reading) fio_putc(fio_fmt[fio_pos]);
                fio_pos++;
            }
            continue;
        }

        if (c == ')') {
            if (fio_gdepth == 0) {
                /* The outer close: the end of the format.  A format in
                 * a CHARACTER entity has no terminator after it, so
                 * this, not the NUL, is what ends it. */
                if (fio_draining || fio_revert < 0) return 0;
                fio_no_data();
                fio_pos = fio_revert;
                if (fio_fmt[fio_pos] == 0) return 0;
                if (fio_reading) fio_next_record();
                else fio_flush_line();
                continue;
            }
            fio_pos++;
            fio_gdepth--;
            if (--fio_gcount[fio_gdepth] > 0) {
                fio_pos = fio_gstart[fio_gdepth];
                fio_gdepth++;
            }
            continue;
        }

        item_start = fio_pos;
        nneg = 0;
        if (c == '-' && fio_isdigit(fio_fmt[fio_pos + 1])) { fio_pos++; nneg = 1; c = fio_fmt[fio_pos]; }
        n = fio_isdigit(c) ? fio_number() : 1;
        c = fio_fmt[fio_pos];

        if (c == '(') {
            fio_pos++;
            if (fio_gdepth < FIO_MAXGROUP) {
                fio_gstart[fio_gdepth] = fio_pos;
                fio_gcount[fio_gdepth] = n;
                fio_gdepth++;
                /* Reversion restarts at the last TOP-LEVEL group
                 * INCLUDING its repeat count, so remember where the
                 * count began -- not where the paren is.  Pointing at
                 * the paren silently drops the count, so `2(I2,'-')'
                 * printed one pair per record after reversion instead
                 * of two. */
                if (fio_gdepth == 1) fio_revert = item_start;
            }
            continue;
        }
        if (c == 'X' || c == 'x') {
            fio_pos++;
            if (fio_reading) fio_rpos += n;   /* skip columns */
            else fio_pad(n);
            continue;
        }
        if (c == 'T' || c == 't') {
            /* Tn: to column n; TLn / TRn: n columns left / right */
            int dir = 0;
            fio_pos++;
            if (fio_fmt[fio_pos] == 'L' || fio_fmt[fio_pos] == 'l') { dir = -1; fio_pos++; }
            else if (fio_fmt[fio_pos] == 'R' || fio_fmt[fio_pos] == 'r') { dir = 1; fio_pos++; }
            n = fio_isdigit(fio_fmt[fio_pos]) ? fio_number() : 1;
            if (fio_reading) {
                if (dir == 0) fio_rpos = n - 1;
                else fio_rpos += dir * n;
                if (fio_rpos < 0) fio_rpos = 0;
            } else {
                if (dir == 0) fio_col = n - 1;
                else fio_col += dir * n;
                if (fio_col < 0) fio_col = 0;
            }
            continue;
        }
        if (c == 'H' || c == 'h') {
            fio_pos++;
            while (n-- > 0 && fio_fmt[fio_pos]) {
                if (!fio_reading) fio_putc(fio_fmt[fio_pos]);
                fio_pos++;
            }
            continue;
        }
        if (c == 'P' || c == 'p') { fio_pos++; fio_scale = nneg ? -n : n; continue; }   /* kP: sticky until the next P (13.5.9) */

        /* Data descriptors */
        if (c=='I'||c=='i'||c=='F'||c=='f'||c=='E'||c=='e'||
            c=='D'||c=='d'||c=='G'||c=='g'||c=='A'||c=='a'||
            c=='L'||c=='l') {
            fio_pos++;
            fio_w = fio_isdigit(fio_fmt[fio_pos]) ? fio_number() : 0;
            fio_d = 0;
            if (fio_fmt[fio_pos] == '.') { fio_pos++; fio_d = fio_number(); }
            /* Ew.dEe -- e digits in the exponent */
            fio_e = 0;
            if (fio_fmt[fio_pos] == 'E' || fio_fmt[fio_pos] == 'e') {
                int save = fio_pos;
                fio_pos++;
                if (fio_isdigit(fio_fmt[fio_pos])) fio_e = fio_number();
                else fio_pos = save;
            }
            fio_rep = n;
            fio_desc = toupper((unsigned char)c);
            fio_since_data = 1;
            return fio_desc;
        }

        fio_pos++;   /* unknown descriptor: skip it rather than hang */
    }
}

/* Obtain the descriptor for the next item, honouring repeat counts. */
static int fio_want(void) {
    if (fio_desc && fio_rep > 0) return fio_desc;
    fio_desc = 0;
    return fio_next_desc();
}

static void fio_consumed(void) {
    if (fio_rep > 0) fio_rep--;
    if (fio_rep == 0) fio_desc = 0;
}

/* Fortran's E output is NOT C's.  C's %E gives `d.dddddd E-07`; the
 * Fortran E descriptor normalises the mantissa to less than one, giving
 * `0.dddddddE-06` -- same value, mantissa shifted one place right and
 * the exponent incremented.  Getting this wrong is invisible on small
 * examples and wrong on every real numeric report, so it is done by
 * rewriting C's output rather than by trying to coax printf into it.
 *
 * `letter` is the exponent letter to emit (E or D).
 */
static void fio_efmt(char *out, int outsz, double v, int nd, int letter) {
    char tmp[64];
    char cf[16];
    char *p;
    char *q;
    int expv;
    int neg;
    int i;
    int n;
    int k;
    int nsig;

    if (nd <= 0) nd = 6;
    k = fio_scale;
    if (k <= -nd || k >= nd + 2) k = 0;             /* out of 13.5.9's range: no effect */
    nsig = k > 0 ? nd + 1 : nd + k;                 /* significant digits shown */
    if (nsig < 1) nsig = 1;
    snprintf(cf, sizeof cf, "%%.%dE", nsig - 1);
    snprintf(tmp, sizeof tmp, cf, v);

    p = tmp;
    neg = 0;
    if (*p == '-') { neg = 1; p++; }
    else if (*p == '+') p++;

    /* Collect the significant digits, dropping the decimal point. */
    n = 0;
    q = out;
    i = 0;
    while (p[i] && p[i] != 'E' && p[i] != 'e') {
        if (p[i] != '.') { tmp[n + 40] = p[i]; n++; }
        i++;
    }
    expv = 0;
    if (p[i] == 'E' || p[i] == 'e') expv = (int)strtol(p + i + 1, 0, 10);
    expv = expv + 1;                  /* mantissa moved below one */

    if (v == 0.0) expv = 0;           /* exact zero: all its digits are zeros */

    q = out;
    if (neg) *q++ = '-';
    if (k > 0) {                                    /* k digits ahead of the point */
        for (i = 0; i < k && i < n; i++) *q++ = tmp[40 + i];
        *q++ = '.';
        for (; i < n && (q - out) < outsz - 8; i++) *q++ = tmp[40 + i];
    } else {
        *q++ = '0';
        *q++ = '.';
        for (i = k; i < 0 && (q - out) < outsz - 8; i++) *q++ = '0';   /* |k| leading zeros */
        for (i = 0; i < n && (q - out) < outsz - 8; i++) *q++ = tmp[40 + i];
    }
    if (v != 0.0) expv = expv - k;    /* zero's exponent is 0 whatever k: 1PE10.2 is 0.00E+00 */
    {
        /* Exponent: Ew.dEe gives e digits after the letter and sign;
         * without e, two digits with the letter up to |exp| 99, three
         * digits and no letter up to 999 (13.5.9.2.2).  An exponent
         * that needs more digits than its field is written in full,
         * which makes the item too wide and the field asterisks. */
        int sign = expv < 0 ? '-' : '+';
        int digits;
        char dbuf[16];
        int nd = 0;
        int i2;
        if (expv < 0) expv = -expv;
        digits = fio_e > 0 ? fio_e : (expv <= 99 ? 2 : 3);
        if (fio_e == 0 && expv > 99 && expv <= 999) { /* no letter */ }
        else *q++ = (char)letter;
        *q++ = (char)sign;
        do { dbuf[nd++] = (char)('0' + expv % 10); expv /= 10; } while (expv > 0 && nd < 15);
        while (nd < digits && nd < 15) dbuf[nd++] = '0';
        for (i2 = nd - 1; i2 >= 0; i2--) *q++ = dbuf[i2];
    }
    *q = 0;
}

/* List-directed REAL output, gfortran's layout: one separating blank,
 * then for REAL(4) a 16-column field (DOUBLE: 25) holding either an F
 * form with 9 (17) significant digits right-justified in the first 12
 * (20) columns followed by 4 (5) blanks, when 0.1 <= |v| < 10^9
 * (10^17) or v is zero, or an ES form d.ddddddddE+ee (3-digit
 * exponent for DOUBLE) right-justified in the whole field. */
static void fio_list_out_real(double v, int dbl) {
    char buf[64];
    char cf[16];
    double a = v < 0 ? -v : v;
    int sig = dbl ? 17 : 9;
    int width = dbl ? 25 : 16;
    int fblanks = dbl ? 5 : 4;
    double lim = dbl ? 1e17 : 1e9;
    fio_putc(' ');
    if (v == 0.0 || (a >= 0.1 && a < lim)) {
        int intd = 0;
        double t = a;
        while (t >= 1.0) { t /= 10.0; intd++; }
        if (intd == 0) intd = 1;                 /* the 0 before the point */
        snprintf(cf, sizeof cf, "%%.%df", sig - ((a < 1.0 && a != 0.0) ? 0 : intd));
        snprintf(buf, sizeof buf, cf, v);
        if (a < 1.0 && a != 0.0 && strlen(buf) > (size_t)(sig + 2 + (v < 0))) buf[sig + 2 + (v < 0)] = 0;
        fio_field(buf, width - fblanks);
        fio_blanks(fblanks);               /* part of the field: written */
    } else {
        char *e;
        snprintf(cf, sizeof cf, "%%.%dE", sig - 1);
        snprintf(buf, sizeof buf, cf, v);
        e = strchr(buf, 'E');
        if (e && dbl) {
            /* three exponent digits */
            int n = (int)strlen(e + 2);
            if (n < 3) { memmove(e + 2 + (3 - n), e + 2, (size_t)n + 1); memset(e + 2, '0', (size_t)(3 - n)); }
        }
        fio_field(buf, width);
    }
    fio_first_item = 0;
    fio_prev_char = 0;
}

/* --- entry points called by compiled Fortran ------------------------ */

static void fio_init_units(void) {
    int i;
    if (fio_uend_init) return;
    for (i = 0; i < FIO_MAXUNIT; i++) fio_uend[i] = -1;
    fio_uend_init = 1;
}

static void fio_wr_setup(const char *fmt);
/* REC= announced by the compiler just before the statement begins. */
void f77_set_rec(int rec) { fio_rec_next = rec; }

/* Position a direct-access unit at the record the statement names. */
static void fio_position(FILE *f, int unit) {
    int rec = fio_rec_next;
    fio_rec_next = 0;
    if (unit <= 0 || unit >= FIO_MAXUNIT) return;
    if (!fio_udirect[unit]) return;
    if (rec <= 0) {
        fprintf(stderr, "f77: a direct-access unit needs REC=\n");
        exit(2);
    }
    fseek(f, (long)(rec - 1) * fio_urecl[unit], SEEK_SET);
}

void f77_wr_begin(int unit, const char *fmt) {
    fio_init_units();
    fio_ibuf = 0;
    fio_out = fio_resolve(unit, 1);
    fio_unit = unit;
    if (unit > 0 && unit < FIO_MAXUNIT) { fio_uunf[unit] = 0; fio_uaeof[unit] = 0; }
    fio_position(fio_out, unit);
    fio_wr_setup(fmt);
}

/* --- unformatted I/O ----------------------------------------------------
 *
 * Sequential records carry a 4-byte length before and after the data
 * (gfortran's layout, so files are interchangeable with the oracle);
 * direct-access records are RECL bytes.  Items are raw bytes. */
void f77_wu_begin(int unit) {
    fio_init_units();
    fio_out = fio_resolve(unit, 1);
    fio_unit = unit;
    if (unit > 0 && unit < FIO_MAXUNIT) { fio_uunf[unit] = 1; fio_uaeof[unit] = 0; }   /* BACKSPACE needs to know */
    fio_position(fio_out, unit);
    fio_ulen = 0;
}
void f77_wu(const void *p, int n) {
    if (n <= 0) return;
    if (fio_ulen + n > FIO_MAXUREC) {
        fprintf(stderr, "f77: unformatted record too long\n");
        exit(2);
    }
    memcpy(fio_urec + fio_ulen, p, (size_t)n);
    fio_ulen += n;
}
void f77_wu_end(void) {
    FILE *f = fio_out ? fio_out : stdout;
    if (fio_unit > 0 && fio_unit < FIO_MAXUNIT && fio_udirect[fio_unit]) {
        int recl = fio_urecl[fio_unit];
        if (fio_ulen > recl) {
            fprintf(stderr, "f77: unformatted record longer than RECL\n");
            exit(2);
        }
        fwrite(fio_urec, 1, (size_t)fio_ulen, f);
        while (fio_ulen < recl) { fputc(0, f); fio_ulen++; }
        return;
    }
    {
        unsigned char lw[4];
        int n = fio_ulen;
        lw[0] = (unsigned char)n; lw[1] = (unsigned char)(n >> 8);
        lw[2] = (unsigned char)(n >> 16); lw[3] = (unsigned char)(n >> 24);
        fwrite(lw, 1, 4, f);
        fwrite(fio_urec, 1, (size_t)n, f);
        fwrite(lw, 1, 4, f);
        if (fio_unit > 0 && fio_unit < FIO_MAXUNIT) fio_uend[fio_unit] = ftell(f);
    }
}
/* flags: 1 END= present, 2 ERR=/IOSTAT= present.  0 ok, 1 eof, 2 error */
int f77_ru_begin(int unit, int flags) {
    FILE *f;
    fio_init_units();
    f = fio_resolve(unit, 0);
    fio_in = f;
    fio_unit = unit;
    if (unit > 0 && unit < FIO_MAXUNIT) fio_uunf[unit] = 1;
    fio_position(f, unit);
    fio_upos = 0;
    if (unit > 0 && unit < FIO_MAXUNIT && fio_udirect[unit]) {
        size_t n = fread(fio_urec, 1, (size_t)fio_urecl[unit], f);
        fio_ulen = (int)n;
        if (n == 0) {
            if (flags & 2) return 2;
            fprintf(stderr, "f77: READ past the end of a direct-access file\n");
            exit(2);
        }
        return 0;
    }
    if (fio_uend[unit] >= 0 && ftell(f) >= fio_uend[unit]) {
        fio_uaeof[unit] = 1;
        if (flags & 1) return 1;
        if (flags & 2) return 1;
        fprintf(stderr, "f77: end of file on READ\n");
        exit(2);
    }
    {
        unsigned char lw[4];
        int n;
        if (fread(lw, 1, 4, f) != 4) {
            fio_uaeof[unit] = 1;
            if (flags & 3) return 1;
            fprintf(stderr, "f77: end of file on READ\n");
            exit(2);
        }
        n = lw[0] | (lw[1] << 8) | (lw[2] << 16) | (lw[3] << 24);
        if (n < 0 || n > FIO_MAXUREC) {
            if (flags & 2) return 2;
            fprintf(stderr, "f77: bad unformatted record\n");
            exit(2);
        }
        fio_ulen = (int)fread(fio_urec, 1, (size_t)n, f);
        fread(lw, 1, 4, f);
    }
    return 0;
}
void f77_ru(void *p, int n) {
    if (n <= 0) return;
    if (fio_upos + n > fio_ulen) {
        fprintf(stderr, "f77: unformatted READ past the end of the record\n");
        exit(2);
    }
    memcpy(p, fio_urec + fio_upos, (size_t)n);
    fio_upos += n;
}
void f77_ru_end(void) { }

/* BACKSPACE: back over the previous record.  Formatted: scan back to
 * the newline before it; unformatted: the trailing length word says
 * how far.  After ENDFILE the endfile record is what is backed over. */
void f77_backspace(int unit) {
    FILE *f;
    long pos;
    fio_init_units();
    if (unit <= 0 || unit >= FIO_MAXUNIT || unit == 5 || unit == 6) return;
    f = fio_resolve(unit, 1);
    fflush(f);
    pos = ftell(f);
    if (fio_uaeof[unit]) { fio_uaeof[unit] = 0; return; }   /* back over the endfile record */
    if (pos <= 0) return;
    if (fio_uunf[unit]) {
        unsigned char lw[4];
        long n;
        fseek(f, pos - 4, SEEK_SET);
        if (fread(lw, 1, 4, f) != 4) { fseek(f, 0L, SEEK_SET); return; }
        n = lw[0] | (lw[1] << 8) | (lw[2] << 16) | ((long)lw[3] << 24);
        fseek(f, pos - 8 - n, SEEK_SET);
        return;
    }
    pos -= 1;                                   /* the newline ending the previous record */
    while (pos > 0) {
        int c;
        fseek(f, pos - 1, SEEK_SET);
        c = fgetc(f);
        if (c == '\n') break;
        pos -= 1;
    }
    fseek(f, pos, SEEK_SET);
}

/* WRITE into an internal file: the CHARACTER entity at buf, nrec
 * records of len bytes. */
void f77_wr_begin_int(char *buf, int len, int nrec, const char *fmt) {
    fio_init_units();
    fio_out = stdout;
    fio_unit = -1;
    fio_ibuf = buf;
    fio_ilen = len;
    fio_inrec = nrec;
    fio_irec = 0;
    fio_wr_setup(fmt);
}

static void fio_wr_setup(const char *fmt) {
    fio_reading = 0;
    fio_len = 0;
    fio_col = 0;
    fio_sp = 0;
    fio_gdepth = 0;
    fio_scale = 0;
    fio_rep = 0;
    fio_desc = 0;
    fio_first_item = 1;
    fio_prev_char = 0;
    if (fmt == 0) {
        fio_fmt_lim = -1;
        fio_listed = 1;
        fio_fmt = "";
        fio_pos = 0;
        fio_revert = -1;
        return;
    }
    fio_listed = 0;
    if (fio_fmt_use(fmt) < 0) exit(2);
    fio_pos = 0;
    fio_revert = -1;
    fio_since_data = 0;
    /* Skip the outer parenthesis; just inside it is the reversion
     * point.  (fort370: it was the parenthesis itself, so a reversion
     * made the whole format a group and its last ')' a group's end,
     * not the format's -- and where no NUL follows the format, as on
     * MVS, the next reversion read on into whatever did: READ (5,
     * '(A)') A, B, C left C blank (2026-10-16).) */
    while (fio_fmt[fio_pos] == ' ') fio_pos++;
    if (fio_fmt[fio_pos] == '(') { fio_pos++; fio_revert = fio_pos; }
}

/* fort370: A editing of a numeric item -- FORTRAN 66 and IBM keep text
 * in INTEGER and REAL variables (DATA D/1H5/), and A writes the item's
 * bytes as they lie in storage: Aw with w no larger than the item takes
 * its first w bytes, a larger w pads on the left, A alone is the item's
 * size.  fio_want() has been called and returned 'A'. */
void f77_rd_s(char *p, int len);
static void fio_hol_out(const void *item, int n) {
    const char *b = (const char *)item;
    int len = n;
    int i;
    if (fio_w > 0 && fio_w < len) len = fio_w;
    else if (fio_w > len) fio_pad(fio_w - len);
    for (i = 0; i < len; i++) fio_putc(b[i]);
    fio_consumed();
}

void f77_wr_i(int v) {
    char buf[32];
    int d;
    if (fio_listed) {
        snprintf(buf, sizeof buf, "%12d", v);
        fio_puts(buf);
        fio_first_item = 0;
        fio_prev_char = 0;
        return;
    }
    d = fio_want();
    if (d == 0) return;
    if (d == 'A') { fio_hol_out(&v, (int)sizeof v); return; }
    if (d == 'L') {
        if (fio_w > 1) fio_pad(fio_w - 1);
        fio_putc(v ? 'T' : 'F');
        fio_consumed();
        return;
    }
    if (fio_d > 0) {
        /* Iw.m: at least m digits, zero-filled */
        char dig[32];
        int nd;
        unsigned int u = v < 0 ? (unsigned int)(-(long)v) : (unsigned int)v;
        snprintf(dig, sizeof dig, "%u", u);
        nd = (int)strlen(dig);
        snprintf(buf, sizeof buf, "%s%0*d%s", v < 0 ? "-" : "", nd < fio_d ? fio_d - nd : 0, 0, dig);
        if (nd >= fio_d) snprintf(buf, sizeof buf, "%s%s", v < 0 ? "-" : "", dig);
    } else if (fio_fmt[fio_pos - 1] == '0' && fio_fmt[fio_pos - 2] == '.' && v == 0) {
        buf[0] = 0;                        /* Iw.0 of zero: blanks */
    } else {
        snprintf(buf, sizeof buf, "%d", v);
    }
    fio_plus(buf);
    fio_field(buf, fio_w);
    fio_consumed();
}

void f77_wr_d(double v) {
    char buf[64];
    char cf[16];
    int d;
    if (fio_listed) { fio_list_out_real(v, 1); return; }
    d = fio_want();
    if (d == 0) return;
    if (d == 'A') { fio_hol_out(&v, (int)sizeof v); return; }   /* DOUBLE PRECISION text, 8 bytes */
    if (d == 'I') {
        snprintf(buf, sizeof buf, "%d", (int)v);
    } else if (d == 'F') {
        double fv = v;
        int k = fio_scale;
        while (k > 0) { fv *= 10.0; k--; }
        while (k < 0) { fv /= 10.0; k++; }
        snprintf(cf, sizeof cf, "%%.%df", fio_d);
        snprintf(buf, sizeof buf, cf, fv);
        /* Fw.0 keeps the decimal point ("3."); C's %.0f drops it. */
        if (fio_d == 0) strcat(buf, ".");
        fio_plus(buf);
        fio_drop_zero(buf, fio_w);
    } else if (d == 'G') {
        /* Gw.d: F form when 0.1 <= |v| < 10^d, else E. The F form
         * occupies w-4 columns and is followed by four blanks. */
        double a = v < 0 ? -v : v;
        double lim = 1.0;
        int i;
        int use_f = 0;
        int nd = fio_d > 0 ? fio_d : 1;
        for (i = 0; i < nd; i++) lim *= 10.0;
        if (a == 0.0 || (a >= 0.1 && a < lim)) use_f = 1;
        if (use_f) {
            int tb = fio_e > 0 ? fio_e + 2 : 4;
            int fw = fio_w >= tb ? fio_w - tb : fio_w;
            int k = 0;
            double t = a;
            if (t >= 1.0) {
                while (t >= 10.0 && k < nd) { t /= 10.0; k++; }
                k++;
            }
            snprintf(cf, sizeof cf, "%%.%df", nd - k > 0 ? nd - k : 0);
            snprintf(buf, sizeof buf, cf, v);
            if (nd - k <= 0) strcat(buf, ".");
            fio_plus(buf);
            fio_drop_zero(buf, fw);
            fio_field(buf, fw);
            fio_blanks(fio_w >= tb ? tb : 0);
            fio_consumed();
            return;
        }
        fio_efmt(buf, sizeof buf, v, nd, 'E');
        fio_plus(buf);
        fio_drop_zero(buf, fio_w);
    } else if (d == 'E' || d == 'D') {
        fio_efmt(buf, sizeof buf, v, fio_d, d);
        fio_plus(buf);
        fio_drop_zero(buf, fio_w);
    } else {
        snprintf(buf, sizeof buf, "%g", v);
    }
    fio_field(buf, fio_w);
    fio_consumed();
}

void f77_wr_r(float v) {
    if (fio_listed) { fio_list_out_real((double)v, 0); return; }
    if (fio_want() == 'A') { fio_hol_out(&v, (int)sizeof v); return; }   /* REAL text, 4 bytes */
    f77_wr_d((double)v);
}

/* A COMPLEX item: two edit descriptors, or "(re,im)" list-directed. */
/* A complex item: "(re,im)" when list-directed, right-justified as
 * gfortran does (35 columns after the blank, 53 for COMPLEX*16); two
 * items under a format.  (fort370: shared with COMPLEX*16.) */
static void fio_wr_pair(double re, double im, int dbl) {
    if (fio_listed) {
        int save;
        int start0;
        fio_putc(' ');
        start0 = fio_len;
        fio_putc('(');
        save = fio_len;
        fio_list_out_real(re, dbl);
        /* trim the field to the number: drop the leading blank and the padding */
        {
            int i, j;
            int start = save;
            while (start < fio_len && fio_line[start] == ' ') start++;
            j = fio_len;
            while (j > start && fio_line[j - 1] == ' ') j--;
            for (i = 0; i < j - start; i++) fio_line[save + i] = fio_line[start + i];
            fio_len = save + (j - start);
            fio_col = fio_len;
        }
        fio_putc(',');
        save = fio_len;
        fio_list_out_real(im, dbl);
        {
            int i, j;
            int start = save;
            while (start < fio_len && fio_line[start] == ' ') start++;
            j = fio_len;
            while (j > start && fio_line[j - 1] == ' ') j--;
            for (i = 0; i < j - start; i++) fio_line[save + i] = fio_line[start + i];
            fio_len = save + (j - start);
            fio_col = fio_len;
        }
        fio_col = fio_len;
        fio_putc(')');
        /* gfortran right-justifies the pair in 35 columns after the blank */
        {
            int n = fio_len - start0;
            int pad = (dbl ? 53 : 35) - n;
            if (pad > 0 && fio_len + pad < FIO_MAXLINE - 1) {
                memmove(fio_line + start0 + pad, fio_line + start0, (size_t)n);
                memset(fio_line + start0, ' ', (size_t)pad);
                fio_len += pad;
            }
            fio_col = fio_len;
        }
        fio_first_item = 0;
        fio_prev_char = 0;
        return;
    }
    f77_wr_d(re);
    f77_wr_d(im);
}
void f77_wr_c(float re, float im) { fio_wr_pair((double)re, (double)im, 0); }
void f77_wr_z(double re, double im) { fio_wr_pair(re, im, 1); }

void f77_wr_a(const char *s, int len) {
    int d;
    int i;
    if (fio_listed) {
        /* List-directed: the record's leading blank, then character
         * items run together with no separator (gfortran's layout). */
        if (fio_first_item || !fio_prev_char) fio_putc(' ');
        for (i = 0; i < len; i++) fio_putc(s[i]);
        fio_first_item = 0;
        fio_prev_char = 1;
        return;
    }
    d = fio_want();
    if (d == 0) return;
    if (fio_w > 0 && fio_w < len) len = fio_w;
    else if (fio_w > len) fio_pad(fio_w - len);
    for (i = 0; i < len; i++) fio_putc(s[i]);
    fio_consumed();
}

/* --- COMPLEX primitives ------------------------------------------------
 *
 * A COMPLEX is two floats; the compiler passes the parts as two words
 * and takes results back through an 8-byte frame temporary (`out`). */
float f77_cabs(float re, float im) { return (float)sqrt((double)re * re + (double)im * im); }

/* a / b: the textbook (ar br + ai bi, ai br - ar bi) / (br^2 + bi^2),
 * in double, where a product of two floats is exact -- so only the
 * sums and the quotients are rounded, and the result once more to
 * float.  A divisor far from 1 is first scaled by 2^64 at a time (a
 * power of 16 as well: exact in either arithmetic) so that its square
 * stays in range.  (fort370: was inline in float, 2026-10-15.) */
void f77_cdiv(float *out, float ar, float ai, float br, float bi) {
    double k = 18446744073709551616.0;
    double c = br, d = bi, sc = 1.0, m, den;
    m = fabs(c) > fabs(d) ? fabs(c) : fabs(d);
    while (m > k) { c = c / k; d = d / k; m = m / k; sc = sc / k; }
    while (m > 0.0 && m < 1.0 / k) { c = c * k; d = d * k; m = m * k; sc = sc * k; }
    den = c * c + d * d;
    out[0] = (float)((ar * c + ai * d) / den * sc);
    out[1] = (float)((ai * c - ar * d) / den * sc);
}

/* fort370: COMPLEX*16, in double, where the products are not exact:
 * division by Smith's way (the smaller part of the divisor over the
 * larger), the modulus scaled so that its square cannot overflow.  The
 * result's address comes last, after the doubles, which then sit on
 * doublewords in the parameter list. */
static double fio_zmod(double re, double im) {
    double a = fabs(re), b = fabs(im), t;
    if (a < b) { t = a; a = b; b = t; }
    if (a == 0.0) return 0.0;
    t = b / a;
    return a * sqrt(1.0 + t * t);
}
double f77_zabs(double re, double im) { return fio_zmod(re, im); }
void f77_zdiv(double ar, double ai, double br, double bi, double *out) {
    double r, d;
    if (fabs(br) >= fabs(bi)) {
        r = bi / br; d = br + bi * r;
        out[0] = (ar + ai * r) / d;
        out[1] = (ai - ar * r) / d;
    } else {
        r = br / bi; d = bi + br * r;
        out[0] = (ar * r + ai) / d;
        out[1] = (ai * r - ar) / d;
    }
}
void f77_zpow_i(double re, double im, int n, double *out) {
    double rr = 1.0, ri = 0.0;
    double br = re, bi = im;
    int neg = n < 0;
    unsigned k = (unsigned)(neg ? -n : n);
    while (k) {
        if (k & 1) { double t = rr * br - ri * bi; ri = rr * bi + ri * br; rr = t; }
        k >>= 1;
        if (k) { double t = br * br - bi * bi; bi = 2.0 * br * bi; br = t; }
    }
    if (neg) { double q[2]; f77_zdiv(1.0, 0.0, rr, ri, q); rr = q[0]; ri = q[1]; }
    out[0] = rr; out[1] = ri;
}
void f77_zlog(double re, double im, double *out) {
    out[0] = log(fio_zmod(re, im));
    out[1] = atan2(im, re);
}
void f77_zexp(double re, double im, double *out) {
    double e = exp(re);
    out[0] = e * cos(im);
    out[1] = e * sin(im);
}
void f77_zpow_c(double ar, double ai, double br, double bi, double *out) {
    double l[2];
    if (ar == 0.0 && ai == 0.0) { out[0] = 0.0; out[1] = 0.0; return; }
    f77_zlog(ar, ai, l);
    f77_zexp(br * l[0] - bi * l[1], br * l[1] + bi * l[0], out);
}
void f77_zsqrt(double re, double im, double *out) {
    double m = fio_zmod(re, im);
    double r = sqrt((m + fabs(re)) / 2.0);
    if (re >= 0.0) { out[0] = r; out[1] = r == 0.0 ? 0.0 : im / (2.0 * r); }
    else { out[0] = r == 0.0 ? 0.0 : fabs(im) / (2.0 * r); out[1] = im < 0.0 ? -r : r; }
}
void f77_zsin(double re, double im, double *out) {
    out[0] = sin(re) * cosh(im);
    out[1] = cos(re) * sinh(im);
}
void f77_zcos(double re, double im, double *out) {
    out[0] = cos(re) * cosh(im);
    out[1] = -sin(re) * sinh(im);
}

void f77_cpow_i(float *out, float re, float im, int n) {
    double rr = 1.0, ri = 0.0;
    double br = re, bi = im;
    int neg = n < 0;
    unsigned k = (unsigned)(neg ? -n : n);
    while (k) {
        if (k & 1) { double t = rr * br - ri * bi; ri = rr * bi + ri * br; rr = t; }
        k >>= 1;
        if (k) { double t = br * br - bi * bi; bi = 2.0 * br * bi; br = t; }
    }
    if (neg) { double d = rr * rr + ri * ri; double t = rr / d; ri = -ri / d; rr = t; }
    out[0] = (float)rr; out[1] = (float)ri;
}

void f77_clog(float *out, float re, float im) {
    out[0] = (float)log(sqrt((double)re * re + (double)im * im));
    out[1] = (float)atan2((double)im, (double)re);
}
void f77_cexp(float *out, float re, float im) {
    double e = exp((double)re);
    out[0] = (float)(e * cos((double)im));
    out[1] = (float)(e * sin((double)im));
}
void f77_cpow_c(float *out, float ar, float ai, float br, float bi) {
    float l[2];
    double wr, wi;
    if (ar == 0.0f && ai == 0.0f) { out[0] = 0.0f; out[1] = 0.0f; return; }
    f77_clog(l, ar, ai);
    wr = (double)br * l[0] - (double)bi * l[1];
    wi = (double)br * l[1] + (double)bi * l[0];
    f77_cexp(out, (float)wr, (float)wi);
}
void f77_csqrt(float *out, float re, float im) {
    double m = sqrt((double)re * re + (double)im * im);
    double r = sqrt((m + fabs((double)re)) / 2.0);
    if (re >= 0.0f) { out[0] = (float)r; out[1] = (float)(r == 0.0 ? 0.0 : im / (2.0 * r)); }
    else { out[0] = (float)(r == 0.0 ? 0.0 : fabs((double)im) / (2.0 * r)); out[1] = (float)(im < 0.0f ? -r : r); }
}
void f77_csin(float *out, float re, float im) {
    out[0] = (float)(sin((double)re) * cosh((double)im));
    out[1] = (float)(cos((double)re) * sinh((double)im));
}
void f77_ccos(float *out, float re, float im) {
    out[0] = (float)(cos((double)re) * cosh((double)im));
    out[1] = (float)(-sin((double)re) * sinh((double)im));
}

int f77_index(const char *a, int la, const char *b, int lb);

/* --- specific intrinsics as actual arguments ---------------------------
 *
 * F77 15.9.3 lets a specific intrinsic name be passed to a dummy
 * procedure; the compiler lowers intrinsics inline, so these are the
 * by-reference copies it passes the address of. */
int    f77i_iabs(int *x)              { return *x < 0 ? -*x : *x; }
float  f77i_abs(float *x)             { return *x < 0 ? -*x : *x; }
double f77i_dabs(double *x)           { return *x < 0 ? -*x : *x; }
float  f77i_sqrt(float *x)            { return (float)sqrt((double)*x); }
double f77i_dsqrt(double *x)          { return sqrt(*x); }
float  f77i_exp(float *x)             { return (float)exp((double)*x); }
double f77i_dexp(double *x)           { return exp(*x); }
float  f77i_alog(float *x)            { return (float)log((double)*x); }
double f77i_dlog(double *x)           { return log(*x); }
float  f77i_alog10(float *x)          { return (float)log10((double)*x); }
double f77i_dlog10(double *x)         { return log10(*x); }
float  f77i_sin(float *x)             { return (float)sin((double)*x); }
double f77i_dsin(double *x)           { return sin(*x); }
float  f77i_cos(float *x)             { return (float)cos((double)*x); }
double f77i_dcos(double *x)           { return cos(*x); }
float  f77i_tan(float *x)             { return (float)tan((double)*x); }
double f77i_dtan(double *x)           { return tan(*x); }
float  f77i_asin(float *x)            { return (float)asin((double)*x); }
double f77i_dasin(double *x)          { return asin(*x); }
float  f77i_acos(float *x)            { return (float)acos((double)*x); }
double f77i_dacos(double *x)          { return acos(*x); }
float  f77i_arsin(float *x)           { return (float)asin((double)*x); }   /* IBM's names */
double f77i_darsin(double *x)         { return asin(*x); }
float  f77i_arcos(float *x)           { return (float)acos((double)*x); }
double f77i_darcos(double *x)         { return acos(*x); }
float  f77i_atan(float *x)            { return (float)atan((double)*x); }
double f77i_datan(double *x)          { return atan(*x); }
float  f77i_atan2(float *y, float *x) { return (float)atan2((double)*y, (double)*x); }
double f77i_datan2(double *y, double *x) { return atan2(*y, *x); }
float  f77i_sinh(float *x)            { return (float)sinh((double)*x); }
double f77i_dsinh(double *x)          { return sinh(*x); }
float  f77i_cosh(float *x)            { return (float)cosh((double)*x); }
double f77i_dcosh(double *x)          { return cosh(*x); }
float  f77i_tanh(float *x)            { return (float)tanh((double)*x); }
double f77i_dtanh(double *x)          { return tanh(*x); }
float  f77i_aint(float *x)            { return (float)trunc((double)*x); }
double f77i_dint(double *x)           { return trunc(*x); }
float  f77i_anint(float *x)           { return (float)round((double)*x); }
double f77i_dnint(double *x)          { return round(*x); }
int    f77i_nint(float *x)            { return (int)round((double)*x); }
int    f77i_idnint(double *x)         { return (int)round(*x); }
int    f77i_mod(int *a, int *b)       { return *a % *b; }
float  f77i_amod(float *a, float *b)  { return (float)fmod((double)*a, (double)*b); }
double f77i_dmod(double *a, double *b) { return fmod(*a, *b); }
int    f77i_isign(int *a, int *b)     { int v = *a < 0 ? -*a : *a; return *b < 0 ? -v : v; }
float  f77i_sign(float *a, float *b)  { float v = *a < 0 ? -*a : *a; return *b < 0 ? -v : v; }
double f77i_dsign(double *a, double *b) { double v = *a < 0 ? -*a : *a; return *b < 0 ? -v : v; }
int    f77i_idim(int *a, int *b)      { return *a > *b ? *a - *b : 0; }
float  f77i_dim(float *a, float *b)   { return *a > *b ? *a - *b : 0.0f; }
double f77i_ddim(double *a, double *b) { return *a > *b ? *a - *b : 0.0; }
double f77i_dprod(float *a, float *b) { return (double)*a * (double)*b; }
int    f77i_len(const char *s, int len) { (void)s; return len; }
int    f77i_index(const char *a, const char *b, int la, int lb) { return f77_index(a, la, b, lb); }
float  f77i_aimag(float *z)           { return z[1]; }
float  f77i_cabs(float *z)            { return (float)sqrt((double)z[0] * z[0] + (double)z[1] * z[1]); }

/* --- CHARACTER primitives --------------------------------------------- */

/* d(1:dl) = s(1:sl): copy, then blank-fill; memmove because F77 lets
 * the two overlap only when they coincide, and that must still work. */
void f77_strcpy(char *d, int dl, const char *s, int sl) {
    int n = sl < dl ? sl : dl;
    if (n > 0) memmove(d, s, (size_t)n);
    while (n < dl) d[n++] = ' ';
}

/* Compare with the shorter operand blank-extended: -1, 0, 1. */
int f77_strcmp(const char *a, int la, const char *b, int lb) {
    int n = la > lb ? la : lb;
    int i;
    for (i = 0; i < n; i++) {
        int ca = i < la ? (unsigned char)a[i] : ' ';
        int cb = i < lb ? (unsigned char)b[i] : ' ';
        if (ca != cb) return ca < cb ? -1 : 1;
    }
    return 0;
}

/* a // b when a length is not known at compile time: the result goes
 * into a scratch ring and is consumed by the statement that built it
 * (an assignment, comparison or argument), so a 64 KB ring outlives
 * every live result in practice; a chain longer than that wraps. */
#define FIO_CATRING 65536
static char fio_catring[FIO_CATRING];
static int  fio_catpos;
char *f77_cat(const char *a, int la, const char *b, int lb) {
    char *r;
    int n = (la > 0 ? la : 0) + (lb > 0 ? lb : 0);
    if (n > FIO_CATRING) {
        fprintf(stderr, "f77: concatenation result of %d bytes is too long\n", n);
        exit(2);
    }
    if (fio_catpos + n > FIO_CATRING) fio_catpos = 0;
    r = fio_catring + fio_catpos;
    fio_catpos += (n + 3) & ~3;
    if (la > 0) memmove(r, a, (size_t)la);
    if (lb > 0) memmove(r + (la > 0 ? la : 0), b, (size_t)lb);
    return r;
}

/* INDEX: first position of b in a, 1-based; 0 when absent. */
int f77_index(const char *a, int la, const char *b, int lb) {
    int i;
    if (lb == 0) return la > 0 ? 1 : 0;
    for (i = 0; i + lb <= la; i++)
        if (memcmp(a + i, b, (size_t)lb) == 0) return i + 1;
    return 0;
}

void f77_wr_l(int v) {
    int d;
    if (fio_listed) {
        fio_putc(' ');
        fio_putc(v ? 'T' : 'F');
        fio_first_item = 0;
        fio_prev_char = 0;
        return;
    }
    d = fio_want();
    if (d == 0) { return; }
    if (fio_w > 1) fio_pad(fio_w - 1);
    fio_putc(v ? 'T' : 'F');
    fio_consumed();
}

/* Finish the record: emit any trailing literal text, but stop at the
 * first data descriptor that has no item to feed it. */
void f77_wr_end(void) {
    /* A data descriptor with repeats left (15A1 with fewer than 15
     * items) wants the next item itself: the record ends there, and
     * the literal after the group is not written.  Draining from a
     * fresh descriptor wrote it -- ADDAD's histogram bars, 4('!',15A1),
     * ended in a '!' that VS FORTRAN and gfortran do not write. */
    if (!fio_listed && !(fio_desc && fio_rep > 0)) {
        /* Run the format out to its end or the next data descriptor
         * with no reversion: a WRITE with no items and a format ending
         * in a group, `3(/)`, reverted to that group for ever. */
        fio_draining = 1;
        fio_desc = 0;
        fio_rep = 0;
        fio_next_desc();
        fio_draining = 0;
    }
    fio_flush_line();
    fio_ibuf = 0;
}

/* ENDFILE: the file ends here; a READ past this point sees end of
 * file until a WRITE moves the end. */
void f77_endfile(int unit) {
    FILE *f;
    fio_init_units();
    f = fio_resolve(unit, 1);
    if (f == stdout || f == stderr) return;
    fflush(f);
    if (unit > 0 && unit < FIO_MAXUNIT) {
        fio_uend[unit] = ftell(f);
        fio_uaeof[unit] = 1;       /* positioned after the endfile record */
    }
}

/* PAUSE [n | 'text']: report and continue (there is no operator). */
void f77_pause(const char *s, int len) {
    fflush(stdout);
    fprintf(stderr, "PAUSE %.*s\n", len, s);
}

/* --- formatted input ------------------------------------------------- */

/* Copy the next `w` columns of the record into `buf` with every blank
 * squeezed out (F77's default BLANK='NULL' for preconnected units: a
 * blank is no character at all, and an all-blank field is zero).
 * Columns past the end of the record read as blanks. */
static void fio_field_in(char *buf, int w) {
    int i;
    int c;
    int n = 0;
    int seen = 0;
    for (i = 0; i < w; i++) {
        c = (fio_rpos + i < fio_rlen) ? fio_rec[fio_rpos + i] : ' ';
        if (c == ' ' || c == '\t') {
            /* BZ: a blank after the first nonblank is a zero */
            if (fio_bz && seen && n < FIO_MAXLINE - 1) buf[n++] = '0';
            continue;
        }
        seen = 1;
        if (n < FIO_MAXLINE - 1) buf[n++] = (char)c;
    }
    buf[n] = 0;
    fio_rpos += w;
}

static int fio_in_int(int w) {
    char buf[FIO_MAXLINE];
    fio_field_in(buf, w);
    if (!buf[0]) return 0;
    return (int)strtol(buf, 0, 10);
}

static int fio_in_logical(int w) {
    char buf[FIO_MAXLINE];
    int i = 0;
    fio_field_in(buf, w);
    if (buf[i] == '.') i++;
    if (buf[i] == 'T' || buf[i] == 't') return 1;
    if (buf[i] == 'F' || buf[i] == 'f') return 0;
    if (buf[i] == 0) return 0;             /* all-blank field */
    fprintf(stderr, "f77: bad LOGICAL input field '%s'\n", buf);
    exit(2);
    return 0;   /* not reached; -fno-builtin hides exit's noreturn */
}

/* F/E/D/G input.  The field is normalised into one string that strtod
 * parses in a single call -- building the string rather than scaling
 * the value keeps the conversion correctly rounded, which is what lets
 * the digits match a reference Fortran after formatting.
 *
 * Rules folded in: D/Q exponent letters mean E; a bare +/- after the
 * mantissa starts an exponent ('1.5+3'); a field with no decimal point
 * has its rightmost `d` mantissa digits taken as fractional; the kP
 * scale factor divides by 10^k, but only when the field itself has no
 * exponent. */
static double fio_in_real(int w, int d) {
    char raw[FIO_MAXLINE];
    char mant[FIO_MAXLINE];     /* mantissa digits only, no sign, no point */
    char num[FIO_MAXLINE + 16];
    int i;
    int n;
    int neg = 0;
    int has_point = 0;
    int has_exp = 0;
    int pfrac = 0;              /* mantissa digits after the point so far */
    int expv = 0;
    int esign = 1;
    int intlen;
    int k;

    fio_field_in(raw, w);
    if (!raw[0]) return 0.0;

    i = 0;
    if (raw[i] == '+') i++;
    else if (raw[i] == '-') { neg = 1; i++; }

    n = 0;
    for (; raw[i] && !has_exp; i++) {
        int c = raw[i];
        if (c == '.') { has_point = 1; continue; }
        if (fio_isdigit(c)) {
            if (n < FIO_MAXLINE - 1) mant[n++] = (char)c;
            if (has_point) pfrac++;
            continue;
        }
        if (c == 'E' || c == 'e' || c == 'D' || c == 'd' ||
            c == 'Q' || c == 'q') {
            has_exp = 1;
            if (raw[i + 1] == '+') i++;
            else if (raw[i + 1] == '-') { esign = -1; i++; }
            continue;
        }
        if (c == '+' || c == '-') {         /* bare signed exponent */
            has_exp = 1;
            if (c == '-') esign = -1;
            continue;
        }
        break;                              /* junk: stop, keep what parsed */
    }
    if (has_exp) {
        for (; raw[i]; i++)
            if (fio_isdigit(raw[i])) expv = expv * 10 + (raw[i] - '0');
        expv = expv * esign;
    }
    mant[n] = 0;
    if (n == 0) return 0.0;

    /* Where does the point go?  Explicit point: pfrac digits are
     * fractional.  No point: the rightmost d are. */
    intlen = has_point ? n - pfrac : n - d;
    if (!has_exp) expv = expv - fio_scale;

    k = 0;
    if (neg) num[k++] = '-';
    if (intlen <= 0) {
        num[k++] = '0';
        num[k++] = '.';
        for (i = intlen; i < 0; i++) num[k++] = '0';
        for (i = 0; i < n; i++) num[k++] = mant[i];
    } else {
        for (i = 0; i < intlen && i < n; i++) num[k++] = mant[i];
        num[k++] = '.';
        for (; i < n; i++) num[k++] = mant[i];
    }
    snprintf(num + k, sizeof num - k, "E%d", expv);
    return strtod(num, 0);
}

/* --- list-directed input --------------------------------------------- */

/* Next list-directed value into fio_ltok.  Returns 0 with the token
 * filled, or 1 for the `/` terminator.  Handles r*c repeats and value
 * lists spanning records.  Null values (`1,,3`) are refused honestly
 * rather than mis-assigned. */
/* List-directed input tokens (13.6).  Values are separated by blanks,
 * a comma (with optional blanks), a slash (which ends the statement),
 * or the end of a record; two separators with nothing between them,
 * or a leading comma, are a NULL value, which leaves the item as it
 * was; r*c is c repeated r times and r* is r nulls.  A quoted constant
 * may hold blanks, commas and slashes, doubles its quote, and may
 * continue onto the next record.  Returns 0 with the token in fio_ltok
 * (fio_l_quoted says whether it was quoted), 1 for the slash, 2 for a
 * null value. */
static int fio_l_nulls;      /* nulls still owed by r* */
static int fio_l_after;      /* a value has been taken since the last separator */
static int fio_l_quoted;

static int fio_list_tok(void) {
    int c;
    int n;

    if (fio_l_nulls > 0) { fio_l_nulls--; return 2; }
    if (fio_l_pending > 0) { fio_l_pending--; return 0; }

    for (;;) {
        if (fio_rpos >= fio_rlen) { fio_next_record(); continue; }
        c = fio_rec[fio_rpos];
        if (c == ' ' || c == '\t') { fio_rpos++; continue; }
        if (c == ',') {
            fio_rpos++;
            if (!fio_l_after) return 2;          /* null value */
            fio_l_after = 0;
            continue;
        }
        break;
    }
    if (c == '/') { fio_rpos++; return 1; }

    n = 0;
    fio_l_quoted = 0;
    if (c == '\'' || c == '"') {
        int q = c;
        fio_l_quoted = 1;
        fio_rpos++;
        for (;;) {
            if (fio_rpos >= fio_rlen) { fio_next_record(); continue; }   /* continues on the next record */
            c = fio_rec[fio_rpos++];
            if (c == q) {
                if (fio_rpos < fio_rlen && fio_rec[fio_rpos] == q) { fio_rpos++; }
                else break;
            }
            if (n < (int)sizeof fio_ltok - 1) fio_ltok[n++] = (char)c;
        }
        fio_ltok[n] = 0;
        fio_l_after = 1;
        return 0;
    }
    while (fio_rpos < fio_rlen) {
        c = fio_rec[fio_rpos];
        if (c == '(') {
            /* A complex constant, ( re , im ): blanks anywhere inside,
             * and it may continue on the next record; taken whole,
             * blanks dropped, through its closing parenthesis, for
             * f77_rd_c to split at the comma.  (FCVS FM906 writes
             * "( 2.5 , 3.5 )" and "(1.0        ," / "   2.0)".) */
            for (;;) {
                if (fio_rpos >= fio_rlen) { fio_next_record(); continue; }
                c = fio_rec[fio_rpos++];
                if (c == ' ' || c == '\t') continue;
                if (n < (int)sizeof fio_ltok - 1) fio_ltok[n++] = (char)c;
                if (c == ')') break;
            }
            break;
        }
        if (c == ' ' || c == '\t' || c == ',' || c == '/') break;
        if (n < (int)sizeof fio_ltok - 1) fio_ltok[n++] = (char)c;
        fio_rpos++;
    }
    fio_ltok[n] = 0;
    fio_l_after = 1;

    /* r*value, or r* for r nulls: unsigned repeat count, then a star. */
    n = 0;
    while (fio_isdigit(fio_ltok[n])) n++;
    if (n > 0 && fio_ltok[n] == '*') {
        int r = (int)strtol(fio_ltok, 0, 10);
        if (r == 0) {
            fprintf(stderr, "f77: zero repeat count in list-directed input\n");
            exit(2);
        }
        if (fio_ltok[n + 1] == 0) { fio_l_nulls = r - 1; return 2; }
        if (r > 1) fio_l_pending = r - 1;
        memmove(fio_ltok, fio_ltok + n + 1, strlen(fio_ltok + n + 1) + 1);
    }
    return 0;
}

static double fio_list_real(void) {
    char num[sizeof fio_ltok];
    int i;
    for (i = 0; fio_ltok[i]; i++) {
        int c = fio_ltok[i];
        if (c == 'D' || c == 'd' || c == 'Q' || c == 'q') c = 'E';
        num[i] = (char)c;
    }
    num[i] = 0;
    return strtod(num, 0);
}

/* --- READ entry points ------------------------------------------------ */

/* Begin a READ.  Returns 1 at end of file when the statement carries
 * END= (has_end); without END=, end of file is fatal here.  The first
 * record is fetched now, which is what makes the read-until-EOF idiom
 * (`READ (5, *, END=99) X` in a loop) work; end of file in the middle
 * of a statement is always fatal (see fio_next_record). */
static int fio_rd_setup(const char *fmt, int has_end);
int f77_rd_begin(int unit, const char *fmt, int has_end) {
    fio_init_units();
    fio_ibuf = 0;
    fio_in = fio_resolve(unit, 0);
    fio_unit = unit;
    if (unit > 0 && unit < FIO_MAXUNIT) fio_uunf[unit] = 0;
    fio_position(fio_in, unit);
    fio_bz = (unit > 0 && unit < FIO_MAXUNIT) ? fio_ubz[unit] : 0;
    return fio_rd_setup(fmt, has_end);
}

int f77_rd_begin_int(char *buf, int len, int nrec, const char *fmt, int has_end) {
    fio_init_units();
    fio_in = stdin;
    fio_unit = -1;
    fio_ibuf = buf;
    fio_ilen = len;
    fio_inrec = nrec;
    fio_irec = 0;
    return fio_rd_setup(fmt, has_end);
}

static int fio_rd_setup(const char *fmt, int has_end) {
    if (fio_unit <= 0) fio_bz = 0;
    fio_l_nulls = 0;
    fio_l_after = 0;
    fio_l_quoted = 0;
    fio_reading = 1;
    fio_ldone = 0;
    fio_l_pending = 0;
    fio_gdepth = 0;
    fio_scale = 0;
    fio_rep = 0;
    fio_desc = 0;
    fio_len = 0;
    fio_listed = (fmt == 0);
    fio_fmt = "";
    fio_pos = 0;
    fio_revert = -1;
    fio_since_data = 0;
    if (fio_listed) fio_fmt_lim = -1;
    if (!fio_listed && fio_fmt_use(fmt) < 0) {
        fio_reading = 0;
        if (has_end & 2) return 2;
        exit(2);
    }
    if (!fio_listed) {
        while (fio_fmt[fio_pos] == ' ') fio_pos++;
        if (fio_fmt[fio_pos] == '(') { fio_pos++; fio_revert = fio_pos; }   /* inside it: see fio_wr_setup's */
    }
    if (fio_getrec()) {
        fio_reading = 0;
        if (has_end & 3) return 1;
        fprintf(stderr, "f77: end of file on READ\n");
        exit(2);
    }
    return 0;
}

/* INTEGER and LOGICAL targets share TY_INT in the compiler, so both
 * arrive here; the format descriptor (or the token's first character,
 * list-directed) says which conversion applies. */
void f77_rd_i(int *p) {
    int d;
    if (fio_listed) {
        int c0;
        int t;
        if (fio_ldone) return;
        t = fio_list_tok();
        if (t == 1) { fio_ldone = 1; return; }
        if (t == 2) return;
        c0 = fio_ltok[0];
        if (c0 == '.' || c0 == 'T' || c0 == 't' || c0 == 'F' || c0 == 'f') {
            int i = (c0 == '.') ? 1 : 0;
            *p = (fio_ltok[i] == 'T' || fio_ltok[i] == 't') ? 1 : 0;
            return;
        }
        *p = (int)strtol(fio_ltok, 0, 10);
        return;
    }
    d = fio_want();
    if (d == 0) return;
    if (d == 'L') *p = fio_in_logical(fio_w);
    else if (d == 'I') *p = fio_in_int(fio_w);
    else if (d == 'A') { f77_rd_s((char *)p, (int)sizeof *p); return; }   /* text into an INTEGER */
    else *p = (int)fio_in_real(fio_w, fio_d);
    fio_consumed();
}

/* fort370: an INTEGER*2 or LOGICAL*1 item, n bytes of storage (issue
 * 10).  A editing takes and gives its n bytes as they lie in storage,
 * as FORTRAN H's does: A2 of an INTEGER*2 is its two characters.  Any
 * other descriptor reads a fullword and keeps its low n bytes, a
 * halfword sign extended -- H keeps 4464 of 70000. */
void f77_rd_in(void *p, int n) {
    int t;
    if (!fio_listed && fio_want() == 'A') { f77_rd_s((char *)p, n); return; }
    t = n == 2 ? *(short *)p : *(unsigned char *)p;     /* a null value leaves it */
    f77_rd_i(&t);
    if (n == 2) *(short *)p = (short)t;
    else *(unsigned char *)p = (unsigned char)t;
}

void f77_wr_i(int v);
void f77_wr_in(int v, int n) {
    if (!fio_listed && fio_want() == 'A') {
        short h = (short)v;
        unsigned char c = (unsigned char)v;
        if (n == 2) fio_hol_out(&h, 2);
        else fio_hol_out(&c, 1);
        return;
    }
    f77_wr_i(v);
}

void f77_rd_d(double *p) {
    int d;
    if (fio_listed) {
        int t;
        if (fio_ldone) return;
        t = fio_list_tok();
        if (t == 1) { fio_ldone = 1; return; }
        if (t == 2) return;
        *p = fio_list_real();
        return;
    }
    d = fio_want();
    if (d == 0) return;
    if (d == 'I') *p = (double)fio_in_int(fio_w);
    else if (d == 'A') { f77_rd_s((char *)p, (int)sizeof *p); return; }   /* text into a DOUBLE PRECISION */
    else if (d == 'L') {
        fprintf(stderr, "f77: %c editing does not match a numeric READ item\n", d);
        exit(2);
    }
    else *p = fio_in_real(fio_w, fio_d);
    fio_consumed();
}

void f77_rd_r(float *p) {
    int d;
    if (fio_listed) {
        int t;
        if (fio_ldone) return;
        t = fio_list_tok();
        if (t == 1) { fio_ldone = 1; return; }
        if (t == 2) return;
        *p = (float)fio_list_real();
        return;
    }
    d = fio_want();
    if (d == 0) return;
    if (d == 'I') *p = (float)fio_in_int(fio_w);
    else if (d == 'A') { f77_rd_s((char *)p, (int)sizeof *p); return; }   /* text into a REAL */
    else if (d == 'L') {
        fprintf(stderr, "f77: %c editing does not match a numeric READ item\n", d);
        exit(2);
    }
    else *p = (float)fio_in_real(fio_w, fio_d);
    fio_consumed();
}

/* CHARACTER input.  Aw: w > len takes the rightmost len characters,
 * w < len left-justifies and blank-fills; a bare A uses len.  Blanks
 * are data here, not squeezed.  List-directed: a quoted token (with
 * '' as the embedded quote) or an unquoted one. */
void f77_rd_s(char *p, int len) {
    int d;
    int w;
    int i;
    if (fio_listed) {
        int n;
        int t;
        if (fio_ldone) return;
        t = fio_list_tok();
        if (t == 1) { fio_ldone = 1; return; }
        if (t == 2) return;
        n = (int)strlen(fio_ltok);
        for (i = 0; i < len; i++) p[i] = i < n ? fio_ltok[i] : ' ';
        return;
    }
    d = fio_want();
    if (d == 0) return;
    if (d != 'A') {
        fprintf(stderr, "f77: %c editing does not match a CHARACTER READ item\n", d);
        exit(2);
    }
    w = fio_w > 0 ? fio_w : len;
    if (w >= len) {
        int skip = w - len;
        for (i = 0; i < len; i++) {
            int c = (fio_rpos + skip + i < fio_rlen) ? fio_rec[fio_rpos + skip + i] : ' ';
            p[i] = (char)c;
        }
    } else {
        for (i = 0; i < len; i++) {
            int c = (i < w && fio_rpos + i < fio_rlen) ? fio_rec[fio_rpos + i] : ' ';
            p[i] = (char)c;
        }
    }
    fio_rpos += w;
    fio_consumed();
}

/* COMPLEX input: two edit descriptors, or "(re, im)" list-directed. */
void f77_rd_c(float *p) {
    if (fio_listed) {
        int t;
        if (fio_ldone) return;
        t = fio_list_tok();
        if (t == 1) { fio_ldone = 1; return; }
        if (t == 2) return;
        if (fio_ltok[0] == '(') {
            /* ( re , im ): the tokenizer took it whole, through the
             * closing parenthesis, blanks dropped. */
            char *comma;
            char *close;
            close = strchr(fio_ltok, ')');
            if (close) *close = 0;
            comma = strchr(fio_ltok + 1, ',');
            if (comma) *comma = 0;
            memmove(fio_ltok, fio_ltok + 1, strlen(fio_ltok + 1) + 1);
            p[0] = (float)fio_list_real();
            if (comma) { strcpy(fio_ltok, comma + 1); p[1] = (float)fio_list_real(); }
            else p[1] = 0.0f;
            return;
        }
        p[0] = (float)fio_list_real();
        p[1] = 0.0f;
        return;
    }
    f77_rd_r(p);
    f77_rd_r(p + 1);
}

/* fort370: COMPLEX*16, as COMPLEX in doubles */
void f77_rd_z(double *p) {
    if (fio_listed) {
        int t;
        if (fio_ldone) return;
        t = fio_list_tok();
        if (t == 1) { fio_ldone = 1; return; }
        if (t == 2) return;
        if (fio_ltok[0] == '(') {
            char *comma;
            char *close;
            close = strchr(fio_ltok, ')');
            if (close) *close = 0;
            comma = strchr(fio_ltok + 1, ',');
            if (comma) *comma = 0;
            memmove(fio_ltok, fio_ltok + 1, strlen(fio_ltok + 1) + 1);
            p[0] = fio_list_real();
            if (comma) { strcpy(fio_ltok, comma + 1); p[1] = fio_list_real(); }
            else p[1] = 0.0;
            return;
        }
        p[0] = fio_list_real();
        p[1] = 0.0;
        return;
    }
    f77_rd_d(p);
    f77_rd_d(p + 1);
}

void f77_rd_end(void) {
    fio_reading = 0;
    fio_ibuf = 0;
}

/* --- NAMELIST --------------------------------------------------------- */

/* fort370: READ (u, name) and WRITE (u, name) of a NAMELIST group, as
 * FORTRAN H has them (fort370 issue 4).  The compiler calls
 *
 *     f77_nml_begin(unit, group, glen, reading, flags)
 *     f77_nml_dim(lo, extent)          -- per dimension, before an array
 *     f77_nml_item(name, nlen, code, addr, elen, nelem)   -- per item
 *     r = f77_nml_end()                -- 0, 1 end of file, 2 error
 *
 * Item codes: 1 INTEGER, 2 REAL, 3 DOUBLE PRECISION, 4 COMPLEX,
 * 5 COMPLEX*16, 6 LOGICAL, 7 CHARACTER (elen its length).
 *
 * WRITE writes FORTRAN H's layout: a record " &GROUP", then the items
 * as NAME=value,value,... packed into records, a NAME= or a value with
 * its comma never split, and " &END".  Each record begins with a
 * blank.  H fills 132 columns after it; here a record is as long as
 * the unit's records are (fio_nml_width), so a NAMELIST written to an
 * 80-byte data set can be punched, and read back.  Fields are H's:
 * INTEGER I11, REAL G15.8, DOUBLE PRECISION G23.16 with D for E,
 * zero as 0.0, COMPLEX (re,im) right-justified in 2w+3, LOGICAL T or
 * F; CHARACTER, which H has not, 'text' with each ' doubled.  The
 * digits are this runtime's own, exact.
 *
 * READ looks for &GROUP (or $GROUP) after column 1 of a record,
 * skipping the records before it, and takes what follows up to &END
 * ($END, or /): NAME=, NAME(s,...)= and values separated by commas or
 * blanks, r*value for r of them, r* or an empty place for values left
 * as they are.  It is all read and parsed at f77_nml_begin; each
 * f77_nml_item then stores its own values, so storage changes only in
 * the call that is given its address.  A name that is no item of the
 * group, a subscript out of range and too many values are errors. */

#define NML_MAXDIM 7
static int   nml_unit, nml_reading, nml_flags, nml_status;
static char  nml_grp[32];
static int   nml_ndim, nml_lo[NML_MAXDIM], nml_ext[NML_MAXDIM];
/* writing */
static char  nml_line[FIO_MAXLINE];
static int   nml_len, nml_width;
static char  nml_pend[FIO_MAXLINE];
static int   nml_npend;
/* reading: the group's text, and the assignments parsed from it */
static char *nml_text;
static int   nml_tlen, nml_tcap;
struct nml_asg { char name[32]; int nsub; int sub[NML_MAXDIM]; int first, count, used; };
struct nml_val { int start, len, rep; };          /* len 0: a null value */
static struct nml_asg *nml_asg;
static int   nml_nasg, nml_casg;
static struct nml_val *nml_val;
static int   nml_nval, nml_cval;
static char  nml_err[96];

/* The length of the unit's records, for the width of what WRITE packs
 * into them: 133 where nothing says (H's 132 columns and the blank). */
static int fio_nml_width(int unit) {
    (void)unit;
    return 133;
}

static void nml_record(const char *s, int n) {
    f77_wr_begin(nml_unit, "(A)");
    f77_wr_a(s, n);
    f77_wr_end();
}

static void nml_flush(void) {
    if (nml_len > 1) nml_record(nml_line, nml_len);
    nml_line[0] = ' ';
    nml_len = 1;
}

/* One unit of output: a NAME= or a value with its comma. */
static void nml_put(const char *s, int n) {
    if (nml_len > 1 && nml_len + n > nml_width) nml_flush();
    if (nml_len + n > FIO_MAXLINE) n = FIO_MAXLINE - nml_len;
    memcpy(nml_line + nml_len, s, (size_t)n);
    nml_len += n;
}

/* A value waits for the next, which says whether a comma follows it. */
static void nml_put_pending(int comma) {
    if (nml_npend < 0) return;
    if (comma) nml_pend[nml_npend++] = ',';
    nml_put(nml_pend, nml_npend);
    nml_npend = -1;
}

static void nml_value(const char *s, int n) {
    nml_put_pending(1);
    if (n > FIO_MAXLINE - 2) n = FIO_MAXLINE - 2;
    memcpy(nml_pend, s, (size_t)n);
    nml_npend = n;
}

/* A value formatted by this runtime's own editing, into buf (w wide). */
static void nml_fmt(char *buf, int w, const char *fmt, int code, const void *p) {
    f77_wr_begin_int(buf, w, 1, fmt);
    if (code == 1) f77_wr_i(*(const int *)p);
    else if (code == 2) f77_wr_r(*(const float *)p);
    else f77_wr_d(*(const double *)p);
    f77_wr_end();
    buf[w] = 0;
}

/* REAL (w 15) or DOUBLE PRECISION (w 23) as H writes it. */
static void nml_real(char *buf, double v, int dbl) {
    int w = dbl ? 23 : 15;
    int i;
    if (v == 0.0) {
        memset(buf, ' ', (size_t)w);
        memcpy(buf + 1, "0.0", 3);
        buf[w] = 0;
        return;
    }
    if (dbl) {
        nml_fmt(buf, w, "(G23.16)", 3, &v);
        for (i = 0; i < w; i++) if (buf[i] == 'E') buf[i] = 'D';
    } else {
        float r = (float)v;
        nml_fmt(buf, w, "(G15.8)", 2, &r);
    }
}

/* s without its leading blanks, and but for a zero (0.0 and its
 * padding, as H has it) its trailing ones, appended to out */
static int nml_trim_cat(char *out, int n, const char *s) {
    int a = 0, b = (int)strlen(s);
    while (a < b && s[a] == ' ') a++;
    if (!(b - a >= 3 && memcmp(s + a, "0.0", 3) == 0 && (a + 3 == b || s[a + 3] == ' ')))
        while (b > a && s[b - 1] == ' ') b--;
    memcpy(out + n, s + a, (size_t)(b - a));
    return n + (b - a);
}

void f77_nml_begin(int unit, const char *grp, int glen, int reading, int flags);
void f77_nml_dim(int lo, int ext);
void f77_nml_item(const char *name, int nlen, int code, void *addr, int elen, int nelem);
int f77_nml_end(void);

static void *nml_grow(void *p, size_t n) {
    p = realloc(p, n);
    if (!p) { fprintf(stderr, "f77: out of storage for a NAMELIST\n"); exit(2); }
    return p;
}

static void nml_text_add(const char *s, int n) {
    if (nml_tlen + n + 2 > nml_tcap) {
        int cap = nml_tcap ? nml_tcap * 2 : 4096;
        char *t;
        while (cap < nml_tlen + n + 2) cap *= 2;
        t = (char *)realloc(nml_text, (size_t)cap);
        if (!t) { fprintf(stderr, "f77: out of storage for a NAMELIST\n"); exit(2); }
        nml_text = t;
        nml_tcap = cap;
    }
    memcpy(nml_text + nml_tlen, s, (size_t)n);
    nml_tlen += n;
    nml_text[nml_tlen] = 0;
}

static void nml_fail(const char *what) {
    if (nml_status == 0) {
        nml_status = 2;
        strncpy(nml_err, what, sizeof nml_err - 1);
        nml_err[sizeof nml_err - 1] = 0;
    }
}

static int nml_namech(int c) { return isalnum((unsigned char)c) || c == '_' || c == '$' || c == '@' || c == '#'; }

/* Is the text at i a NAME= or NAME(...)= ?  Its end (past the =) in *end. */
static int nml_is_name(int i, int *end) {
    int j = i;
    if (j >= nml_tlen || !isalpha((unsigned char)nml_text[j])) return 0;
    while (j < nml_tlen && nml_namech(nml_text[j])) j++;
    while (j < nml_tlen && nml_text[j] == ' ') j++;
    if (j < nml_tlen && nml_text[j] == '(') {
        while (j < nml_tlen && nml_text[j] != ')') j++;
        if (j >= nml_tlen) return 0;
        j++;
        while (j < nml_tlen && nml_text[j] == ' ') j++;
    }
    if (j < nml_tlen && nml_text[j] == '=') { *end = j + 1; return 1; }
    return 0;
}

/* H writes a positive exponent with a blank for its sign, 0.5E 10:
 * a blank after the E or D of a number, before its digits, is a +. */
static int nml_exp_blank(int j) {
    int k;
    if (j < 2 || j + 1 >= nml_tlen) return 0;
    k = toupper((unsigned char)nml_text[j - 1]);
    if (k != 'E' && k != 'D') return 0;
    if (!isdigit((unsigned char)nml_text[j - 2]) && nml_text[j - 2] != '.') return 0;
    return isdigit((unsigned char)nml_text[j + 1]);
}

static void nml_parse(void) {
    int i = 0;
    struct nml_asg *a = 0;
    int sep = 1;                 /* a separator was the last thing seen */
    nml_nasg = 0;
    nml_nval = 0;
    while (i < nml_tlen && nml_status == 0) {
        int c = nml_text[i];
        int end;
        if (c == ' ') { i++; continue; }
        if (c == ',') {
            if (sep && a) {             /* an empty place: a null value */
                if (nml_nval >= nml_cval) {
                    nml_cval = nml_cval ? nml_cval * 2 : 64;
                    nml_val = (struct nml_val *)nml_grow(nml_val, sizeof *nml_val * (size_t)nml_cval);
                }
                nml_val[nml_nval].start = i; nml_val[nml_nval].len = 0; nml_val[nml_nval].rep = 1;
                nml_nval++; a->count++;
            }
            sep = 1;
            i++;
            continue;
        }
        if (nml_is_name(i, &end)) {
            int j = i, k = 0;
            if (nml_nasg >= nml_casg) {
                nml_casg = nml_casg ? nml_casg * 2 : 16;
                nml_asg = (struct nml_asg *)nml_grow(nml_asg, sizeof *nml_asg * (size_t)nml_casg);
            }
            a = &nml_asg[nml_nasg++];
            while (j < nml_tlen && nml_namech(nml_text[j]) && k < 31) a->name[k++] = (char)toupper((unsigned char)nml_text[j++]);
            a->name[k] = 0;
            while (j < nml_tlen && nml_namech(nml_text[j])) j++;
            while (j < nml_tlen && nml_text[j] == ' ') j++;
            a->nsub = 0;
            if (nml_text[j] == '(') {
                j++;
                for (;;) {
                    char *e;
                    long v;
                    while (nml_text[j] == ' ') j++;
                    v = strtol(nml_text + j, &e, 10);
                    if (e == nml_text + j) { nml_fail("a subscript is no integer"); return; }
                    if (a->nsub < NML_MAXDIM) a->sub[a->nsub++] = (int)v;
                    j = (int)(e - nml_text);
                    while (nml_text[j] == ' ') j++;
                    if (nml_text[j] == ',') { j++; continue; }
                    break;
                }
            }
            a->first = nml_nval;
            a->count = 0;
            a->used = 0;
            i = end;
            sep = 1;
            continue;
        }
        if (!a) { nml_fail("a value before the first NAME="); return; }
        {
            /* one value: up to a separator, outside quotes and parentheses */
            int s = i, rep = 1, depth = 0, q = 0;
            int j = i;
            while (j < nml_tlen && isdigit((unsigned char)nml_text[j])) j++;
            if (j > i && j < nml_tlen && nml_text[j] == '*') {
                rep = atoi(nml_text + i);
                if (rep <= 0) { nml_fail("a repeat count is not positive"); return; }
                s = j + 1;
            }
            j = s;
            while (j < nml_tlen) {
                int d = nml_text[j];
                if (q) { if (d == q) { if (j + 1 < nml_tlen && nml_text[j + 1] == q) j++; else q = 0; } j++; continue; }
                if (d == '\'' || d == '"') { q = d; j++; continue; }
                if (d == '(') depth++;
                else if (d == ')') depth--;
                else if (d == ' ' && nml_exp_blank(j)) nml_text[j] = '+';
                else if (depth <= 0 && (d == ',' || d == ' ')) break;
                j++;
            }
            if (nml_nval >= nml_cval) {
                nml_cval = nml_cval ? nml_cval * 2 : 64;
                nml_val = (struct nml_val *)nml_grow(nml_val, sizeof *nml_val * (size_t)nml_cval);
            }
            nml_val[nml_nval].start = s;
            nml_val[nml_nval].len = j - s;         /* r* alone: a null, r times */
            nml_val[nml_nval].rep = rep;
            nml_nval++;
            a->count++;
            i = j;
            sep = 0;
        }
    }
}

/* The group's text: from the record that starts &GROUP, after it, up
 * to &END.  Returns 1 at an end of file before or inside the group. */
static int nml_read_group(void) {
    char rec[FIO_MAXLINE];
    int in = 0;
    int glen = (int)strlen(nml_grp);
    nml_tlen = 0;
    nml_text_add("", 0);
    for (;;) {
        int r, i, n;
        r = f77_rd_begin(nml_unit, "(A)", 3);
        if (r == 1) return 1;
        if (r != 0) { nml_fail("the record could not be read"); return 0; }
        f77_rd_s(rec, FIO_MAXLINE - 1);
        f77_rd_end();
        n = FIO_MAXLINE - 1;
        while (n > 1 && rec[n - 1] == ' ') n--;
        i = 1;                                       /* column 1 is not read, as on H */
        if (!in) {
            int k;
            while (i < n && rec[i] == ' ') i++;
            if (i >= n || (rec[i] != '&' && rec[i] != '$')) continue;
            for (k = 0; k < glen; k++)
                if (i + 1 + k >= n || toupper((unsigned char)rec[i + 1 + k]) != nml_grp[k]) break;
            if (k < glen || (i + 1 + glen < n && nml_namech(rec[i + 1 + glen]))) continue;
            in = 1;
            i = i + 1 + glen;
        }
        /* look for the end in this record, outside quotes */
        {
            int j, q = 0;
            for (j = i; j < n; j++) {
                int c = rec[j];
                if (q) { if (c == q) q = 0; continue; }
                if (c == '\'' || c == '"') { q = c; continue; }
                if (c == '/' || ((c == '&' || c == '$') && j + 3 < n &&
                    toupper((unsigned char)rec[j + 1]) == 'E' && toupper((unsigned char)rec[j + 2]) == 'N' &&
                    toupper((unsigned char)rec[j + 3]) == 'D')) {
                    nml_text_add(rec + i, j - i);
                    return 0;
                }
            }
            nml_text_add(rec + i, n - i);
            nml_text_add(" ", 1);
        }
    }
}

void f77_nml_begin(int unit, const char *grp, int glen, int reading, int flags) {
    int k;
    nml_unit = unit;
    nml_reading = reading;
    nml_flags = flags;
    nml_status = 0;
    nml_ndim = 0;
    nml_err[0] = 0;
    if (glen > 31) glen = 31;
    for (k = 0; k < glen; k++) nml_grp[k] = (char)toupper((unsigned char)grp[k]);
    nml_grp[glen] = 0;
    if (!reading) {
        char hdr[40];
        hdr[0] = ' ';
        hdr[1] = '&';
        memcpy(hdr + 2, nml_grp, (size_t)glen);
        nml_record(hdr, glen + 2);
        nml_width = fio_nml_width(unit);
        if (nml_width < 20) nml_width = 20;
        if (nml_width > FIO_MAXLINE) nml_width = FIO_MAXLINE;
        nml_line[0] = ' ';
        nml_len = 1;
        nml_npend = -1;
        return;
    }
    nml_nasg = 0;
    nml_nval = 0;
    if (nml_read_group()) { nml_status = 1; return; }
    nml_parse();
}

void f77_nml_dim(int lo, int ext) {
    if (nml_ndim < NML_MAXDIM) { nml_lo[nml_ndim] = lo; nml_ext[nml_ndim] = ext; nml_ndim++; }
}

/* An INTEGER or LOGICAL element of elen bytes: 4, or 2 and 1 for
 * INTEGER*2 and LOGICAL*1. */
static int nml_get_int(const char *p, int elen) {
    if (elen == 2) return *(const short *)p;
    if (elen == 1) return (signed char)*p;
    return *(const int *)p;
}
static void nml_put_int(char *p, int elen, int v) {
    if (elen == 2) *(short *)p = (short)v;
    else if (elen == 1) *p = (char)v;
    else *(int *)p = v;
}

/* One value of the input into element p of an item. */
static void nml_store(const struct nml_val *v, int code, char *p, int elen) {
    const char *s = nml_text + v->start;
    int n = v->len;
    if (code == 6) {
        int i = 0;
        if (i < n && s[i] == '.') i++;
        if (i < n && toupper((unsigned char)s[i]) == 'T') nml_put_int(p, elen, 1);
        else if (i < n && toupper((unsigned char)s[i]) == 'F') nml_put_int(p, elen, 0);
        else nml_fail("a LOGICAL value is not T or F");
        return;
    }
    if (code == 7) {
        int i = 0, k = 0, q;
        if (n < 1 || (s[0] != '\'' && s[0] != '"')) { nml_fail("a CHARACTER value is not in quotes"); return; }
        q = s[0];
        for (i = 1; i < n; i++) {
            if (s[i] == q) { if (i + 1 < n && s[i + 1] == q) i++; else break; }
            if (k < elen) p[k++] = s[i];
        }
        while (k < elen) p[k++] = ' ';
        return;
    }
    {
        char buf[FIO_MAXLINE];
        int r;
        if (n >= FIO_MAXLINE) n = FIO_MAXLINE - 1;
        memcpy(buf, s, (size_t)n);
        buf[n] = 0;
        r = f77_rd_begin_int(buf, n, 1, 0, 3);
        if (r != 0) { nml_fail("a value could not be read"); return; }
        if (code == 1) { int iv; f77_rd_i(&iv); nml_put_int(p, elen, iv); }
        else if (code == 2) f77_rd_r((float *)p);
        else if (code == 3) f77_rd_d((double *)p);
        else if (code == 4) f77_rd_c((float *)p);
        else f77_rd_z((double *)p);
        f77_rd_end();
    }
}

void f77_nml_item(const char *name, int nlen, int code, void *addr, int elen, int nelem) {
    char nm[32];
    int k, size;
    if (nlen > 31) nlen = 31;
    for (k = 0; k < nlen; k++) nm[k] = (char)toupper((unsigned char)name[k]);
    nm[nlen] = 0;
    size = code == 2 ? 4 : code == 3 || code == 4 ? 8 : code == 5 ? 16 : elen;
    if (!nml_reading) {
        char buf[64];
        char eq[40];
        int e;
        memcpy(eq, nm, (size_t)nlen);
        eq[nlen] = '=';
        nml_put_pending(1);
        nml_put(eq, nlen + 1);
        for (e = 0; e < nelem; e++) {
            char *p = (char *)addr + (long)e * size;
            if (code == 1) { int iv = nml_get_int(p, elen); nml_fmt(buf, 11, "(I11)", 1, &iv); nml_value(buf, 11); }
            else if (code == 2) { nml_real(buf, *(float *)p, 0); nml_value(buf, 15); }
            else if (code == 3) { nml_real(buf, *(double *)p, 1); nml_value(buf, 23); }
            else if (code == 4 || code == 5) {
                char out[80], part[32];
                int n = 0, w = code == 5 ? 49 : 33, pad;
                double re = code == 5 ? ((double *)p)[0] : ((float *)p)[0];
                double im = code == 5 ? ((double *)p)[1] : ((float *)p)[1];
                out[n++] = '(';
                nml_real(part, re, code == 5);
                n = nml_trim_cat(out, n, part);
                out[n++] = ',';
                nml_real(part, im, code == 5);
                n = nml_trim_cat(out, n, part);
                out[n++] = ')';
                pad = w - n;
                if (pad > 0) { memmove(out + pad, out, (size_t)n); memset(out, ' ', (size_t)pad); n = w; }
                nml_value(out, n);
            }
            else if (code == 6) nml_value(nml_get_int(p, elen) ? "T" : "F", 1);
            else {
                char out[FIO_MAXLINE];
                int n = 0, i;
                out[n++] = '\'';
                for (i = 0; i < elen && n < FIO_MAXLINE - 3; i++) {
                    out[n++] = p[i];
                    if (p[i] == '\'') out[n++] = '\'';
                }
                out[n++] = '\'';
                nml_value(out, n);
            }
        }
        nml_ndim = 0;
        return;
    }
    if (nml_status == 0) {
        int a;
        for (a = 0; a < nml_nasg && nml_status == 0; a++) {
            struct nml_asg *g = &nml_asg[a];
            int el = 0, v;
            if (strcmp(g->name, nm) != 0) continue;
            g->used = 1;
            if (g->nsub > 0) {
                int stride = 1, d;
                if (g->nsub != nml_ndim) { nml_fail("the subscripts do not match the array"); break; }
                for (d = 0; d < g->nsub; d++) {
                    int s = g->sub[d] - nml_lo[d];
                    if (s < 0 || s >= nml_ext[d]) { nml_fail("a subscript is out of range"); break; }
                    el += s * stride;
                    stride *= nml_ext[d];
                }
                if (nml_status) break;
            }
            for (v = g->first; v < g->first + g->count && nml_status == 0; v++) {
                int r;
                for (r = 0; r < nml_val[v].rep; r++) {
                    if (el >= nelem) { nml_fail("more values than the item has elements"); break; }
                    if (nml_val[v].len > 0) nml_store(&nml_val[v], code, (char *)addr + (long)el * size, elen);
                    el++;
                }
            }
        }
    }
    nml_ndim = 0;
}

int f77_nml_end(void) {
    if (!nml_reading) {
        nml_put_pending(0);
        nml_flush();
        nml_record(" &END", 5);
        return 0;
    }
    if (nml_status == 0) {
        int a;
        for (a = 0; a < nml_nasg; a++)
            if (!nml_asg[a].used) {
                char m[96];
                sprintf(m, "%s is no item of the NAMELIST", nml_asg[a].name);
                nml_fail(m);
                break;
            }
    }
    if (nml_status == 1 && !(nml_flags & 1)) {
        fprintf(stderr, "f77: end of file on unit %d looking for NAMELIST &%s\n", nml_unit, nml_grp);
        exit(2);
    }
    if (nml_status == 2 && !(nml_flags & 2)) {
        fprintf(stderr, "f77: NAMELIST &%s on unit %d: %s\n", nml_grp, nml_unit, nml_err);
        exit(2);
    }
    return nml_status;
}

/* --- ** with an INTEGER exponent -------------------------------------- */

/* Binary exponentiation, the same shape gcc's __builtin_powi uses, so
 * rounding of the multiply chain matches a reference compiler's.  A
 * negative INTEGER exponent follows F77 integer division: 1/I**n,
 * which is 0 for |I| > 1.  Real bases take the reciprocal at the end
 * (one rounding, like powi). */
int f77_ipow(int a, int n) {
    int r;
    if (n < 0) {
        if (a == 1) return 1;
        if (a == -1) return (n & 1) ? -1 : 1;
        return 0;               /* |a| > 1 truncates; 0**negative is 0 */
    }
    r = 1;
    while (n > 0) {
        if (n & 1) r = r * a;
        n = n >> 1;
        if (n) a = a * a;       /* not past the last bit, where it may overflow */
    }
    return r;
}

/* The largest REAL and DOUBLE PRECISION magnitudes, a little under. */
#define F77_RHUGE 3.40e38
#define F77_DHUGE 1.79e308

/* Whether |x*y| stays at or under huge: x*y is safe without asking
 * when both are under 1e18, in any format. */
static int fio_pow_fits(double x, double y, double huge) {
    if (x < 0.0) x = -x;
    if (y < 0.0) y = -y;
    if (x <= 1e18 && y <= 1e18) return 1;
    return x <= 1.0 || y <= huge / x;
}

/* a**m.  With big, it stops and sets *big when a product would exceed
 * huge, rather than overflow. */
static double fio_dpow_u(double a, unsigned int m, int *big) {
    double r = 1.0;
    for (;;) {
        if (m & 1u) {
            if (big && !fio_pow_fits(r, a, F77_DHUGE)) { *big = 1; return 0.0; }
            r = r * a;
        }
        m = m >> 1;
        if (!m) return r;
        if (big && !fio_pow_fits(a, a, F77_DHUGE)) { *big = 1; return 0.0; }
        a = a * a;
    }
}

static float fio_rpow_u(float a, unsigned int m, int *big) {
    float r = 1.0f;
    for (;;) {
        if (m & 1u) {
            if (big && !fio_pow_fits(r, a, F77_RHUGE)) { *big = 1; return 0.0f; }
            r = r * a;
        }
        m = m >> 1;
        if (!m) return r;
        if (big && !fio_pow_fits(a, a, F77_RHUGE)) { *big = 1; return 0.0f; }
        a = a * a;
    }
}

/* A negative exponent is 1/a**-n; when a**-n is too large to hold but
 * its reciprocal is not too small (16.0**(-65), the smallest HFP
 * number), it is (1/a)**-n instead. */
double f77_dpow_i(double a, int n) {
    unsigned int m;
    int big = 0;
    double r;
    if (n >= 0) return fio_dpow_u(a, (unsigned int)n, 0);
    m = (unsigned int)0 - (unsigned int)n;
    r = fio_dpow_u(a, m, &big);
    return big ? fio_dpow_u(1.0 / a, m, 0) : 1.0 / r;
}

float f77_rpow_i(float a, int n) {
    unsigned int m;
    int big = 0;
    float r;
    if (n >= 0) return fio_rpow_u(a, (unsigned int)n, 0);
    m = (unsigned int)0 - (unsigned int)n;
    r = fio_rpow_u(a, m, &big);
    return big ? fio_rpow_u(1.0f / a, m, 0) : 1.0f / r;
}

/* --- OPEN / CLOSE / REWIND -------------------------------------------- */

/* OPEN (u, FILE='name' [, STATUS='OLD'|'NEW'|'UNKNOWN']).
 * Sequential formatted access, the only kind this runtime does.
 *   OLD:     the file must exist ("r+", read-only "r" as fallback).
 *   NEW:     the file must NOT exist; created "w+".
 *   UNKNOWN: OLD if it exists (no truncation!), otherwise NEW.
 * An OPEN on an already-open unit closes it first. */
/* OPEN.  Returns 0, or 2 for a failure the statement can recover from
 * (ERR=/IOSTAT= present); otherwise a failure is fatal here. */
int f77_open(int unit, const char *name, int nlen,
             const char *status, int slen,
             const char *access, int alen,
             const char *form, int fmlen,
             const char *blank, int blen,
             int recl, int recoverable) {
    FILE *f;
    char nm[FIO_MAXNAME];
    int direct;
    int unf;
    int scratch;

    fio_init_units();
    if (unit <= 0 || unit >= FIO_MAXUNIT || unit == 5 || unit == 6) {
        if (recoverable) return 2;
        fprintf(stderr, "f77: cannot OPEN unit %d\n", unit);
        exit(2);
    }
    direct = (access && alen > 0 && fio_str_is(access, alen, "DIRECT"));
    unf = (form && fmlen > 0) ? fio_str_is(form, fmlen, "UNFORMATTED") : direct;
    scratch = (status && slen > 0 && fio_str_is(status, slen, "SCRATCH"));
    if (direct && recl <= 0) {
        if (recoverable) return 2;
        fprintf(stderr, "f77: OPEN ACCESS='DIRECT' needs RECL=\n");
        exit(2);
    }
    if (nlen > 0 && name) {
        if (nlen >= FIO_MAXNAME) {
            if (recoverable) return 2;
            fprintf(stderr, "f77: bad FILE= name in OPEN\n");
            exit(2);
        }
        memcpy(nm, name, nlen);
        nm[nlen] = 0;
        while (nlen > 0 && nm[nlen - 1] == ' ') nm[--nlen] = 0;   /* Fortran pads */
    } else {
        snprintf(nm, sizeof nm, "fort.%d", unit);
    }

    if (fio_ufile[unit]) {
        /* Reconnecting the same file changes its attributes only. */
        if (strcmp(fio_ufname[unit], nm) == 0 && !scratch) {
            fio_udirect[unit] = direct; fio_uunf[unit] = unf; fio_urecl[unit] = recl;
            fio_ubz[unit] = (blank && blen > 0 && fio_str_is(blank, blen, "ZERO"));
            return 0;
        }
        fclose(fio_ufile[unit]);
        fio_ufile[unit] = 0;
    }

    if (scratch) {
        f = tmpfile();
        if (!f) { if (recoverable) return 2; fprintf(stderr, "f77: OPEN cannot create a scratch file\n"); exit(2); }
    } else if (status && slen > 0 && fio_str_is(status, slen, "OLD")) {
        f = fopen(nm, "r+");
        if (!f) f = fopen(nm, "r");
        if (!f) {
            if (recoverable) return 2;
            fprintf(stderr, "f77: OPEN STATUS='OLD': no such file '%s'\n", nm);
            exit(2);
        }
    } else if (status && slen > 0 && fio_str_is(status, slen, "NEW")) {
        f = fopen(nm, "r");
        if (f) {
            fclose(f);
            if (recoverable) return 2;
            fprintf(stderr, "f77: OPEN STATUS='NEW': '%s' already exists\n", nm);
            exit(2);
        }
        f = fopen(nm, "w+");
        if (!f) {
            if (recoverable) return 2;
            fprintf(stderr, "f77: OPEN cannot create '%s'\n", nm);
            exit(2);
        }
    } else if (!status || slen <= 0 ||
               fio_str_is(status, slen, "UNKNOWN")) {
        f = fopen(nm, "r+");
        if (!f) f = fopen(nm, "w+");
        if (!f) {
            if (recoverable) return 2;
            fprintf(stderr, "f77: OPEN cannot open '%s'\n", nm);
            exit(2);
        }
    } else {
        if (recoverable) return 2;
        fprintf(stderr, "f77: OPEN STATUS value is not supported\n");
        exit(2);
    }
    fio_ufile[unit] = f;
    strcpy(fio_ufname[unit], scratch ? "" : nm);
    fio_uend[unit] = -1;
    fio_udirect[unit] = direct;
    fio_uunf[unit] = unf;
    fio_urecl[unit] = recl;
    fio_ubz[unit] = (blank && blen > 0 && fio_str_is(blank, blen, "ZERO"));
    return 0;
}

/* CLOSE (u [, STATUS='KEEP'|'DELETE']).  Closing a unit that is not
 * open is permitted and does nothing, as the standard says. */
void f77_close(int unit, const char *status, int slen) {
    int del;
    if (unit < 0 || unit >= FIO_MAXUNIT || !fio_ufile[unit]) return;
    del = (status && slen > 0 && fio_str_is(status, slen, "DELETE"));
    if (status && slen > 0 && !del && !fio_str_is(status, slen, "KEEP")) {
        fprintf(stderr, "f77: CLOSE STATUS value is not supported\n");
        exit(2);
    }
    fclose(fio_ufile[unit]);
    fio_ufile[unit] = 0;
    fio_uend[unit] = -1;
    if (del) remove(fio_ufname[unit]);
    fio_ufname[unit][0] = 0;
}

/* --- INQUIRE ------------------------------------------------------------
 *
 * f77_inquire looks the unit (or file) up and remembers what it found;
 * f77_inq then fills one specifier by code.  Values for an unconnected
 * unit follow gfortran: 'UNDEFINED' for ACCESS/FORM/BLANK, 'UNKNOWN'
 * for the yes/no ones, and the INTEGER ones unchanged. */
static int  inq_unit;        /* -1 none */
static int  inq_exist;
static int  inq_opened;
static char inq_name[FIO_MAXNAME];
static int  inq_named;
static int  inq_direct;
static int  inq_unf;
static int  inq_recl;
static long inq_nextrec;
static int  inq_bz;

int f77_inquire(int unit, const char *file, int flen) {
    int i;
    fio_init_units();
    inq_unit = -1; inq_exist = 0; inq_opened = 0; inq_name[0] = 0; inq_named = 0;
    inq_direct = 0; inq_unf = 0; inq_recl = 0; inq_nextrec = 0; inq_bz = 0;
    if (file && flen > 0) {
        char nm[FIO_MAXNAME];
        FILE *f;
        int n = flen < FIO_MAXNAME - 1 ? flen : FIO_MAXNAME - 1;
        memcpy(nm, file, (size_t)n); nm[n] = 0;
        while (n > 0 && nm[n - 1] == ' ') nm[--n] = 0;
        strcpy(inq_name, nm);
        inq_named = 1;
        f = fopen(nm, "r");
        if (f) { inq_exist = 1; fclose(f); }
        for (i = 1; i < FIO_MAXUNIT; i++) {
            if (fio_ufile[i] && strcmp(fio_ufname[i], nm) == 0) { inq_opened = 1; inq_unit = i; break; }
        }
        if (inq_opened) { unit = inq_unit; }
        else return 0;
    } else {
        if (unit < 0 || unit >= FIO_MAXUNIT) { inq_exist = 0; return 0; }
        inq_exist = 1;
        inq_unit = unit;
        if (unit == 5 || unit == 6 || unit == 0) {
            inq_opened = 1;
            strcpy(inq_name, unit == 5 ? "stdin" : unit == 6 ? "stdout" : "stderr");
            inq_named = 0;
            return 0;
        }
        if (!fio_ufile[unit]) { inq_opened = 0; return 0; }
        inq_opened = 1;
        strcpy(inq_name, fio_ufname[unit]);
        inq_named = inq_name[0] != 0;
    }
    inq_direct = fio_udirect[unit];
    inq_unf = fio_uunf[unit];
    inq_recl = fio_urecl[unit];
    inq_bz = fio_ubz[unit];
    if (inq_direct && inq_recl > 0) {
        fflush(fio_ufile[unit]);
        inq_nextrec = ftell(fio_ufile[unit]) / inq_recl + 1;
    }
    return 0;
}

static void inq_put_s(char *p, int len, const char *v) {
    int n = (int)strlen(v);
    int i;
    for (i = 0; i < len; i++) p[i] = i < n ? v[i] : ' ';
}

void f77_inq(int code, void *p, int len) {
    int *ip = (int *)p;
    char *cp = (char *)p;
    switch (code) {
    case 1: *ip = inq_exist; break;
    case 2: *ip = inq_opened; break;
    case 3: if (inq_opened || inq_unit >= 0) *ip = inq_unit; else *ip = -1; break;
    case 4: *ip = inq_opened ? inq_named : 0; break;
    case 5: if (inq_opened && inq_named) inq_put_s(cp, len, inq_name); break;
    case 6: inq_put_s(cp, len, !inq_opened ? "UNDEFINED" : inq_direct ? "DIRECT" : "SEQUENTIAL"); break;
    case 7: inq_put_s(cp, len, !inq_opened ? "UNKNOWN" : inq_direct ? "NO" : "YES"); break;
    case 8: inq_put_s(cp, len, !inq_opened ? "UNKNOWN" : inq_direct ? "YES" : "NO"); break;
    case 9: inq_put_s(cp, len, !inq_opened ? "UNDEFINED" : inq_unf ? "UNFORMATTED" : "FORMATTED"); break;
    case 10: inq_put_s(cp, len, !inq_opened ? "UNKNOWN" : inq_unf ? "NO" : "YES"); break;
    case 11: inq_put_s(cp, len, !inq_opened ? "UNKNOWN" : inq_unf ? "YES" : "NO"); break;
    case 12: if (inq_opened && inq_direct) *ip = inq_recl; break;
    case 13: if (inq_opened && inq_direct) *ip = (int)inq_nextrec; break;
    case 14: inq_put_s(cp, len, (!inq_opened || inq_unf) ? "UNDEFINED" : inq_bz ? "ZERO" : "NULL"); break;
    default: break;
    }
}

void f77_rewind(int unit) {
    FILE *f;
    fio_init_units();
    if (unit <= 0 || unit >= FIO_MAXUNIT || unit == 5 || unit == 6) {
        fprintf(stderr, "f77: REWIND: unit %d cannot be rewound\n", unit);
        exit(2);
    }
    f = fio_resolve(unit, 1);
    fflush(f);
    fseek(f, 0L, SEEK_SET);
    fio_uaeof[unit] = 0;
}
