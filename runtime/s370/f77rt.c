/* f77rt.c -- the Fortran 77 I/O runtime for MVS 3.8j: runtime/libf77.c
 * (the SLOW-32 runtime, see PROVENANCE.md) with the MVS differences
 * applied by runtime/s370/port.py, which is where to look for what
 * changed: units are DD names FTnnF001, floating numbers are edited
 * by the exact conversion in f77dtoa.c instead of printf, input
 * numbers by the compiler's own text-to-HFP, and every entry has the
 * eight-character external name of f77rt.h.  Built with cc370 for
 * libc370.  GENERATED -- edit libf77.c or port.py. */
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
#include "f77rt.h"
#include "f77dtoa.h"
#include "f77rec.h"
#include "../../backend/s370_hfp.h"

/* C89 has neither trunc nor round; libc370 is C89. */
static double fio_trunc(double v) { return v < 0.0 ? ceil(v) : floor(v); }
static double fio_round(double v) { return v < 0.0 ? ceil(v - 0.5) : floor(v + 0.5); }
double f77_dint(double v) { return fio_trunc(v); }
double f77_dnint(double v) { return fio_round(v); }
#define trunc fio_trunc
#define round fio_round

/* Text to HFP, exactly, truncating as the compiler does for constants. */
static double fio_strtod(const char *text) {
    unsigned int hi, lo;
    while (*text == ' ' || *text == '\t') text++;
    if (hfp_from_text(text, &hi, &lo) < 0) return 0.0;
    return f77_hfp_make(hi, lo);
}

/* OPEN FILE=name: on MVS the name is a DD name (eight characters,
 * upper case), and the job supplies the data set behind it.  A
 * mode of C's is passed through; libc370 reads the DCB from the DD. */
static FILE *fio_fopen(const char *name, const char *mode) {
    char dd[16];
    int i;
    int n;
    if (strncmp(name, "dd:", 3) == 0) return fopen(name, mode);   /* a unit's own FTnnF001 */
    strcpy(dd, "dd:");
    n = 3;
    for (i = 0; name[i] && n < 11; i++) {
        int c = (unsigned char)name[i];
        if (c == ' ') continue;
        if (c >= 'a' && c <= 'z') c = c - 'a' + 'A';
        dd[n++] = (char)c;
    }
    dd[n] = 0;
    return fopen(dd, mode);
}

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
#define FIO_MAXUNIT 32
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
static int   fio_ucur[FIO_MAXUNIT];      /* direct access: the record the next transfer reaches */
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

static void fio_exit(int code) {
    int u;
    f77r_closeall();
    for (u = 0; u < FIO_MAXUNIT; u++) if (fio_ufile[u]) { fclose(fio_ufile[u]); fio_ufile[u] = 0; }
    fflush(stdout);
    fflush(stderr);
    exit(code);
}

/* The unit's DD name, "dd:NAME": the one OPEN named, else FTnnF001. */
static char fio_ddbuf[16];
static const char *fio_ddof(int unit) {
    if (unit > 0 && unit < FIO_MAXUNIT && fio_ufname[unit][0]) return fio_ufname[unit];
    sprintf(fio_ddbuf, "dd:FT%02dF001", unit);
    return fio_ddbuf;
}

static FILE *fio_resolve(int unit, int writing) {
    if (unit >= 0 && unit < FIO_MAXUNIT && fio_ufile[unit]) return fio_ufile[unit];
    if (unit == 0) return writing ? stderr : stdin;
    if (unit > 0 && unit < FIO_MAXUNIT && fio_udirect[unit])
        return stdout;     /* a placeholder: f77rec.c transfers direct-access records, never through it */
    if (unit > 0 && unit < FIO_MAXUNIT && fio_ufname[unit][0]) {
        /* a unit OPENed by name, or closed by REWIND: its data set,
         * opened now in the direction this statement takes */
        FILE *f;
        char *mode;
        if (fio_udirect[unit]) mode = writing ? "rb+" : "rb";
        else if (fio_uunf[unit]) mode = writing ? "wb" : "rb";
        else mode = writing ? "w" : "r";
        f = fopen(fio_ufname[unit], mode);
        if (!f && fio_udirect[unit] && writing) f = fopen(fio_ufname[unit], "wb+");
        if (!f && fio_udirect[unit] && writing) f = fopen(fio_ufname[unit], "wb");
        if (f) { fio_ufile[unit] = f; return f; }
        fprintf(stderr, "f77: unit %d (%s) cannot be opened for %s\n", unit, fio_ufname[unit], writing ? "WRITE" : "READ");
        fio_exit(2);
    }
    if (unit > 0 && unit < FIO_MAXUNIT) {
        /* Preconnected unit: the DD name FTnnF001, as IBM's Fortran
         * names them, opened on first use for the direction asked. */
        char nm[FIO_MAXNAME];
        FILE *f;
        sprintf(nm, "dd:FT%02dF001", unit);
        f = fio_fopen(nm, writing ? "w" : "r");
        if (f) {
            fio_ufile[unit] = f;
            strcpy(fio_ufname[unit], nm);
            fio_uend[unit] = -1;
            fio_udirect[unit] = 0; fio_uunf[unit] = 0; fio_urecl[unit] = 0; fio_ubz[unit] = 0;
            return f;
        }
    }
    /* no such DD: the job's SYSPRINT or SYSIN stand in for 6 and 5 */
    if (writing && unit == 6) return stdout;
    if (!writing && unit == 5) return stdin;
    fprintf(stderr, "f77: unit %d (DD FT%02dF001) is not open for %s\n",
            unit, unit, writing ? "WRITE" : "READ");
    fio_exit(2);
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
            fio_exit(2);
        }
        if (fio_len > fio_ilen) {
            fprintf(stderr, "f77: record longer than the internal file (%d > %d)\n", fio_len, fio_ilen);
            fio_exit(2);
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
            fio_exit(2);
        }
        memcpy(fio_urec, fio_line, (size_t)fio_len);
        for (i = fio_len; i < recl; i++) fio_urec[i] = ' ';
        if (f77d_write(fio_unit, fio_ddof(fio_unit), recl, fio_ucur[fio_unit], fio_urec, ' ') != 0) {
            fprintf(stderr, "f77: unit %d: record %d was not written\n", fio_unit, fio_ucur[fio_unit]);
            fio_exit(2);
        }
        fio_ucur[fio_unit]++;
        fio_len = 0;
        return;
    }
    fputs(fio_line, f);
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
        if (f77d_read(fio_unit, fio_ddof(fio_unit), fio_urecl[fio_unit], fio_ucur[fio_unit], fio_urec) != 0) {
            fprintf(stderr, "f77: unit %d: record %d does not exist\n", fio_unit, fio_ucur[fio_unit]);
            fio_exit(2);
        }
        fio_ucur[fio_unit]++;
        memcpy(fio_rec, fio_urec, (size_t)recl);
        n = (size_t)recl;
        fio_rlen = (int)n;
        fio_rpos = 0;
        return 0;
    }
    if (!fgets(fio_rec, FIO_MAXLINE, fio_in ? fio_in : stdin)) {
        if (fio_unit > 0 && fio_unit < FIO_MAXUNIT) fio_uaeof[fio_unit] = 1;
        return 1;
    }
    fio_rlen = (int)strlen(fio_rec);
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
        fio_exit(2);
    }
}

static int fio_number(void) {
    int v = 0;
    while (fio_isdigit(fio_fmt[fio_pos]))
        v = v * 10 + (fio_fmt[fio_pos++] - '0');
    return v;
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
            fio_desc = (c >= 'a' && c <= 'z') ? c - 'a' + 'A' : c;
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
    /* the exact digits, rounded half up: value = 0.digits * 10^expv */
    expv = f77_fmt_e(v, nsig, tmp + 40, &neg);
    n = nsig;
    (void)cf; (void)p; (void)i;
    if (v == 0.0) { expv = 0; neg = 0; }

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
    expv = expv - k;
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
        f77_fmt_f(v, sig - ((a < 1.0 && a != 0.0) ? 0 : intd), buf);
        (void)cf;
        if (a < 1.0 && a != 0.0 && strlen(buf) > (size_t)(sig + 2 + (v < 0))) buf[sig + 2 + (v < 0)] = 0;
        fio_field(buf, width - fblanks);
        fio_blanks(fblanks);               /* part of the field: written */
    } else {
        char *e;
        char mant[64];
        int ex;
        int ng;
        /* C's d.dddE+ee from the exact digits */
        ex = f77_fmt_e(v, sig, mant, &ng);
        sprintf(buf, "%s%c.%sE%c%02d", ng ? "-" : "", mant[0], mant + 1, ex - 1 < 0 ? '-' : '+', ex - 1 < 0 ? 1 - ex : ex - 1);
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
        fio_exit(2);
    }
    (void)f;
    fio_ucur[unit] = rec;
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
    fio_out = 0;
    fio_unit = unit;
    if (unit <= 0 || unit >= FIO_MAXUNIT || unit == 5 || unit == 6) {
        fprintf(stderr, "f77: unit %d cannot take unformatted records\n", unit);
        fio_exit(2);
    }
    fio_uunf[unit] = 1;
    fio_uaeof[unit] = 0;
    fio_position(0, unit);
    fio_ulen = 0;
}
void f77_wu(const void *p, int n) {
    if (n <= 0) return;
    if (fio_ulen + n > FIO_MAXUREC) {
        fprintf(stderr, "f77: unformatted record too long\n");
        fio_exit(2);
    }
    memcpy(fio_urec + fio_ulen, p, (size_t)n);
    fio_ulen += n;
}
void f77_wu_end(void) {
    int u = fio_unit;
    if (fio_udirect[u]) {
        int recl = fio_urecl[u];
        if (fio_ulen > recl) {
            fprintf(stderr, "f77: unformatted record longer than RECL\n");
            fio_exit(2);
        }
        while (fio_ulen < recl) fio_urec[fio_ulen++] = 0;
        if (f77d_write(u, fio_ddof(u), recl, fio_ucur[u], fio_urec, 0) != 0) {
            fprintf(stderr, "f77: unit %d: record %d was not written\n", u, fio_ucur[u]);
            fio_exit(2);
        }
        fio_ucur[u]++;
        return;
    }
    if (f77s_write(u, fio_ddof(u), fio_urec, fio_ulen) != 0) fio_exit(2);
}
/* flags: 1 END= present, 2 ERR=/IOSTAT= present.  0 ok, 1 eof, 2 error */
int f77_ru_begin(int unit, int flags) {
    int rc;
    int n;
    fio_init_units();
    fio_in = 0;
    fio_unit = unit;
    if (unit <= 0 || unit >= FIO_MAXUNIT || unit == 5 || unit == 6) {
        if (flags & 2) return 2;
        fprintf(stderr, "f77: unit %d cannot give unformatted records\n", unit);
        fio_exit(2);
    }
    fio_uunf[unit] = 1;
    fio_position(0, unit);
    fio_upos = 0;
    if (fio_udirect[unit]) {
        rc = f77d_read(unit, fio_ddof(unit), fio_urecl[unit], fio_ucur[unit], fio_urec);
        if (rc == 0) { fio_ulen = fio_urecl[unit]; fio_ucur[unit]++; return 0; }
        if (flags & 2) return 2;
        fprintf(stderr, "f77: unit %d: record %d does not exist\n", unit, fio_ucur[unit]);
        fio_exit(2);
    }
    rc = f77s_read(unit, fio_ddof(unit), fio_urec, FIO_MAXUREC, &n);
    if (rc == 0) { fio_ulen = n; return 0; }
    if (rc == 1) {
        fio_uaeof[unit] = 1;
        if (flags & 3) return 1;
        fprintf(stderr, "f77: end of file on READ\n");
        fio_exit(2);
    }
    if (flags & 2) return 2;
    fio_exit(2);
    return 2;
}
void f77_ru(void *p, int n) {
    if (n <= 0) return;
    if (fio_upos + n > fio_ulen) {
        fprintf(stderr, "f77: unformatted READ past the end of the record\n");
        fio_exit(2);
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
    if (fio_uunf[unit]) { f77s_backspace(unit); fio_uaeof[unit] = 0; return; }
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
        fio_listed = 1;
        fio_fmt = "";
        fio_pos = 0;
        fio_revert = -1;
        return;
    }
    fio_listed = 0;
    fio_fmt = fmt;
    fio_pos = 0;
    fio_revert = -1;
    /* Skip the outer parenthesis; it is the reversion point. */
    while (fio_fmt[fio_pos] == ' ') fio_pos++;
    if (fio_fmt[fio_pos] == '(') { fio_revert = fio_pos; fio_pos++; }
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
        sprintf(buf, "%12d", v);
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
        sprintf(dig, "%u", u);
        nd = (int)strlen(dig);
        sprintf(buf, "%s%0*d%s", v < 0 ? "-" : "", nd < fio_d ? fio_d - nd : 0, 0, dig);
        if (nd >= fio_d) sprintf(buf, "%s%s", v < 0 ? "-" : "", dig);
    } else if (fio_fmt[fio_pos - 1] == '0' && fio_fmt[fio_pos - 2] == '.' && v == 0) {
        buf[0] = 0;                        /* Iw.0 of zero: blanks */
    } else {
        sprintf(buf, "%d", v);
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
        sprintf(buf, "%d", (int)v);
    } else if (d == 'F') {
        double fv = v;
        int k = fio_scale;
        while (k > 0) { fv *= 10.0; k--; }
        while (k < 0) { fv /= 10.0; k++; }
        f77_fmt_f(fv, fio_d, buf);
        (void)cf;
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
            f77_fmt_f(v, nd - k > 0 ? nd - k : 0, buf);
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
        fio_efmt(buf, sizeof buf, v, 6, 'E');
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
void f77_wr_c(float re, float im) {
    if (fio_listed) {
        int save;
        int start0;
        fio_putc(' ');
        start0 = fio_len;
        fio_putc('(');
        save = fio_len;
        fio_list_out_real((double)re, 0);
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
        fio_list_out_real((double)im, 0);
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
            int pad = 35 - n;
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
    f77_wr_d((double)re);
    f77_wr_d((double)im);
}

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

static const unsigned char fio_e2a[256] = {
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
int f77_lstrcmp(const char *a, int la, const char *b, int lb) {
    int n = la > lb ? la : lb;
    int i;
    for (i = 0; i < n; i++) {
        int ca = fio_e2a[i < la ? (unsigned char)a[i] : (unsigned char)' '];
        int cb = fio_e2a[i < lb ? (unsigned char)b[i] : (unsigned char)' '];
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
        fio_exit(2);
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
    if (!fio_listed) {
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
    if (unit <= 0 || unit >= FIO_MAXUNIT || unit == 5 || unit == 6) return;
    if (fio_uunf[unit]) { f77s_endfile(unit, fio_ddof(unit)); fio_uaeof[unit] = 1; return; }
    if (fio_ufile[unit]) { fclose(fio_ufile[unit]); fio_ufile[unit] = 0; }   /* the file ends here; a READ now sees its end */
    fio_uaeof[unit] = 1;
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
    fio_exit(2);
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
    sprintf(num + k, "E%d", expv);
    return fio_strtod(num);
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
            fio_exit(2);
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
    return fio_strtod(num);
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
    fio_fmt = fmt ? fmt : "";
    fio_pos = 0;
    fio_revert = -1;
    if (!fio_listed) {
        while (fio_fmt[fio_pos] == ' ') fio_pos++;
        if (fio_fmt[fio_pos] == '(') { fio_revert = fio_pos; fio_pos++; }
    }
    if (fio_getrec()) {
        fio_reading = 0;
        if (has_end & 3) return 1;
        fprintf(stderr, "f77: end of file on READ\n");
        fio_exit(2);
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
        fio_exit(2);
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
        fio_exit(2);
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
        fio_exit(2);
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

void f77_rd_end(void) {
    fio_reading = 0;
    fio_ibuf = 0;
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
        a = a * a;
        n = n >> 1;
    }
    return r;
}

double f77_dpow_i(double a, int n) {
    double r = 1.0;
    int neg = 0;
    unsigned int m;
    if (n < 0) { neg = 1; m = (unsigned int)0 - (unsigned int)n; }
    else m = (unsigned int)n;
    while (m) {
        if (m & 1u) r = r * a;
        a = a * a;
        m = m >> 1;
    }
    return neg ? 1.0 / r : r;
}

float f77_rpow_i(float a, int n) {
    float r = 1.0f;
    int neg = 0;
    unsigned int m;
    if (n < 0) { neg = 1; m = (unsigned int)0 - (unsigned int)n; }
    else m = (unsigned int)n;
    while (m) {
        if (m & 1u) r = r * a;
        a = a * a;
        m = m >> 1;
    }
    return neg ? 1.0f / r : r;
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
    char nm[FIO_MAXNAME];
    int direct;
    int unf;
    int scratch;
    int i;
    int n;

    fio_init_units();
    if (unit <= 0 || unit >= FIO_MAXUNIT || unit == 5 || unit == 6) {
        if (recoverable) return 2;
        fprintf(stderr, "f77: cannot OPEN unit %d\n", unit);
        fio_exit(2);
    }
    direct = (access && alen > 0 && fio_str_is(access, alen, "DIRECT"));
    unf = (form && fmlen > 0) ? fio_str_is(form, fmlen, "UNFORMATTED") : direct;
    scratch = (status && slen > 0 && fio_str_is(status, slen, "SCRATCH"));
    if (direct && recl <= 0) {
        if (recoverable) return 2;
        fprintf(stderr, "f77: OPEN ACCESS='DIRECT' needs RECL=\n");
        fio_exit(2);
    }
    /* the DD name: FILE= without its blanks, upper case, eight
     * characters at most; a nameless or SCRATCH unit uses its own */
    strcpy(nm, "dd:");
    n = 3;
    if (nlen > 0 && name && !scratch) {
        for (i = 0; i < nlen && n < 11; i++) {
            int c = (unsigned char)name[i];
            if (c == ' ') continue;
            if (c >= 'a' && c <= 'z') c = c - 'a' + 'A';
            nm[n++] = (char)c;
        }
        nm[n] = 0;
        if (n == 3) sprintf(nm, "dd:FT%02dF001", unit);
    } else {
        sprintf(nm, "dd:FT%02dF001", unit);
    }
    if (fio_ufile[unit]) { fclose(fio_ufile[unit]); fio_ufile[unit] = 0; }
    strcpy(fio_ufname[unit], nm);
    fio_uend[unit] = -1;
    fio_uaeof[unit] = 0;
    fio_udirect[unit] = direct;
    fio_uunf[unit] = unf;
    fio_urecl[unit] = recl;
    fio_ubz[unit] = (blank && blen > 0 && fio_str_is(blank, blen, "ZERO"));
    f77d_close(unit);
    f77s_close(unit);
    fio_ucur[unit] = 1;
    return 0;
}

/* CLOSE (u [, STATUS='KEEP'|'DELETE']).  Closing a unit that is not
 * open is permitted and does nothing, as the standard says. */
void f77_close(int unit, const char *status, int slen) {
    int del;
    if (unit < 0 || unit >= FIO_MAXUNIT) return;
    f77d_close(unit);
    f77s_close(unit);
    if (!fio_ufile[unit]) { fio_ufname[unit][0] = 0; return; }   /* OPENed, never used, or records only */
    del = (status && slen > 0 && fio_str_is(status, slen, "DELETE"));
    if (status && slen > 0 && !del && !fio_str_is(status, slen, "KEEP")) {
        fprintf(stderr, "f77: CLOSE STATUS value is not supported\n");
        fio_exit(2);
    }
    fclose(fio_ufile[unit]);
    fio_ufile[unit] = 0;
    fio_uend[unit] = -1;
    (void)del;                                  /* a DD's data set is the job's to keep or delete */
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

static void inq_ddname(char *dd, const char *file, int flen) {
    int i;
    int n;
    strcpy(dd, "dd:");
    n = 3;
    for (i = 0; i < flen && n < 11; i++) {
        int c = (unsigned char)file[i];
        if (c == ' ') continue;
        if (c >= 'a' && c <= 'z') c = c - 'a' + 'A';
        dd[n++] = (char)c;
    }
    dd[n] = 0;
}

int f77_inquire(int unit, const char *file, int flen) {
    int i;
    fio_init_units();
    inq_unit = -1; inq_exist = 0; inq_opened = 0; inq_name[0] = 0; inq_named = 0;
    inq_direct = 0; inq_unf = 0; inq_recl = 0; inq_nextrec = 0; inq_bz = 0;
    if (file && flen > 0) {
        char dd[16];
        inq_ddname(dd, file, flen);
        strcpy(inq_name, dd + 3);
        inq_named = 1;
        for (i = 1; i < FIO_MAXUNIT; i++) {
            if (fio_ufname[i][0] && strcmp(fio_ufname[i], dd) == 0) { inq_opened = 1; inq_unit = i; break; }
        }
        if (inq_opened) { inq_exist = 1; unit = inq_unit; }
        else {
            /* the DD exists when it can be opened; an unwritten one opens
             * for output (and stays empty) */
            FILE *f;
            f = fopen(dd, "r");
            if (!f) f = fopen(dd, "w");
            if (f) { inq_exist = 1; fclose(f); }
            return 0;
        }
    } else {
        if (unit < 0 || unit >= FIO_MAXUNIT) { inq_exist = 0; return 0; }
        inq_exist = 1;
        inq_unit = unit;
        if (unit == 5 || unit == 6 || unit == 0) {
            inq_opened = 1;
            strcpy(inq_name, unit == 5 ? "FT05F001" : unit == 6 ? "FT06F001" : "SYSTERM");
            inq_named = 0;
            return 0;
        }
        if (!fio_ufname[unit][0]) { inq_opened = 0; return 0; }
        inq_opened = 1;
        strcpy(inq_name, fio_ufname[unit] + 3);
        inq_named = 1;
    }
    inq_direct = fio_udirect[unit];
    inq_unf = fio_uunf[unit];
    inq_recl = fio_urecl[unit];
    inq_bz = fio_ubz[unit];
    if (inq_direct) inq_nextrec = fio_ucur[unit] > 0 ? fio_ucur[unit] : 1;
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
        fio_exit(2);
    }
    if (fio_ufile[unit]) { fclose(fio_ufile[unit]); fio_ufile[unit] = 0; }   /* reopened by the next statement, at the start */
    f77s_rewind(unit);
    fio_uend[unit] = -1;
    fio_uaeof[unit] = 0;
}
