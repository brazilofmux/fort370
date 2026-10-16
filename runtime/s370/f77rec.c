/* f77rec.c -- record-level I/O for fort370's runtime on MVS.
 *
 * libc370's streams are QSAM underneath, and QSAM cannot reposition:
 * fseek abends, and a stream opened for output starts the data set
 * again.  Fortran's direct access and its REWIND, BACKSPACE and ENDFILE
 * on unformatted files need records, so they are done here, on the
 * access methods themselves (libc370's os* layer):
 *
 * Direct access, as IBM's FORTRAN did it: a data set of fixed blocks,
 * one record each, RECL bytes.  A record past the end is written by
 * BSAM -- OUTPUT on an empty data set, EXTEND on one with records --
 * and the records between are written as filler; a record that exists
 * is read or rewritten in place by BDAM, by relative block number.  The
 * data set stays an ordinary sequential one (DSORG=PS, RECFM=F), which
 * any program can read.  Whether it is empty is the DSCB's last-block
 * pointer (a new data set's space holds whatever was there before).
 *
 * Unformatted sequential: each record a length word and its bytes, in
 * a stream, and the unit's position a record count.  REWIND closes the
 * stream; a READ opens it and skips to the position; a WRITE where the
 * file does not end first copies the records before it (the data set
 * is opened for output again, which ends it there); BACKSPACE counts
 * one back; ENDFILE ends the file at the position.
 *
 * Everything is closed at exit (atexit), so the DSCBs say where each
 * data set ends. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <osio.h>
#include <osjfcb.h>
#include <clibdscb.h>
#include "f77rec.h"
#include "f77std.h"

#define RMAXU 100                        /* units 0-99, as f77rt.c's FIO_MAXUNIT */

static int rinit;

static void rname(char *out, const char *dd) {
    int i;
    if (dd[0] && dd[1] && dd[2] == ':') dd += 3;
    for (i = 0; i < 8 && dd[i] && dd[i] != ' '; i++) out[i] = dd[i];
    out[i] = 0;
}

static void rstart(void) {
    if (rinit) return;
    rinit = 1;
    atexit(f77r_closeall);
}

/* ---- direct access ---------------------------------------------- */

typedef struct {
    DCB  *bdam;          /* open for read and update by block number */
    DCB  *bsam;          /* open for output at the end */
    int   nrec;          /* records the data set holds, -1 not yet known */
    int   recl;
    char  dd[9];
} DUNIT;
static DUNIT dunit[RMAXU];

/* OPEN a BSAM DCB with an option osbopen does not offer (X'0F'
 * OUTPUT, X'0E' EXTEND); 0 when the data set opened. */
static int dopenb(DCB *dcb, unsigned opt) {
    unsigned plist;
    int rc;
    plist = 0x80000000u | (opt << 24) | (unsigned)dcb;
    __asm__("LR    1,%1\n\tSVC   19         OPEN\n\tST\t15,0(,%0)"
        : : "r"(&rc), "r"(&plist) : "1", "14", "15", "memory");
    return (dcb->dcboflg & DCBOFOPN) ? 0 : 8;
}

static void dshut(DUNIT *d) {
    if (d->bsam) { osbclose(d->bsam, 0, 1, 0); d->bsam = 0; }
    if (d->bdam) { osdclose(d->bdam, 1); d->bdam = 0; }
}

/* The DD's data set has never been written (its DSCB has no last
 * block): 1; written: 0, with its block size; not on DASD, or not to be
 * found: -1. */
static int dempty(const char *dd, int *blksz) {
    DCB *dcb;
    JFCB jfcb;
    DSCB dscb;
    int n;
    *blksz = 0;
    dcb = osbdcb(dd, 0);
    if (!dcb) return -1;
    memset(&jfcb, 0, sizeof jfcb);
    n = __rdjfcb(dcb, &jfcb);
    free(dcb);
    if (n != 0) return -1;
    memset(&dscb, 0, sizeof dscb);
    if (__dscbdv(jfcb.jfcbdsnm, jfcb.jfcbvols, &dscb) != 0) return -1;
    if (!dscb.dscb1.lstar[0] && !dscb.dscb1.lstar[1] && !dscb.dscb1.lstar[2]) return 1;
    *blksz = dscb.dscb1.blksz;
    return 0;
}

/* How many records the data set holds: none when it was never written;
 * else counted.  -2 when its blocks are not RECL bytes. */
static int dcount(DUNIT *d) {
    FILE *f;
    unsigned char *buf;
    char nm[16];
    int n;
    int blksz;
    n = dempty(d->dd, &blksz);
    if (n == 1) return 0;
    if (n == 0 && blksz != d->recl) return -2;
    sprintf(nm, "dd:%s", d->dd);
    f = fopen(nm, "rb");
    if (!f) return 0;
    buf = (unsigned char *)malloc((size_t)d->recl);
    n = 0;
    if (buf) while (fread(buf, 1, (size_t)d->recl, f) == (size_t)d->recl) n++;
    free(buf);
    fclose(f);
    return n;
}

/* The unit's state for this data set and RECL; 0 when it is usable. */
static DUNIT *dget(int unit, const char *dd, int recl) {
    DUNIT *d;
    char nm[9];
    if (unit < 0 || unit >= RMAXU || recl <= 0) return 0;
    rstart();
    d = &dunit[unit];
    rname(nm, dd);
    if (strcmp(nm, d->dd) != 0 || recl != d->recl) {
        dshut(d);
        strcpy(d->dd, nm);
        d->recl = recl;
        d->nrec = -1;
    }
    if (d->nrec < 0) {
        int n;
        n = dcount(d);
        if (n == -2) {
            fprintf(stderr, "f77: DD %s: its records are not RECL=%d bytes\n", d->dd, recl);
            d->dd[0] = 0;
            return 0;
        }
        d->nrec = n;
    }
    return d;
}

static int dbsamw(DUNIT *d, const unsigned char *buf) {
    DECB decb;
    memset(&decb, 0, sizeof decb);
    oswrite(&decb, d->bsam, (void *)buf, d->recl);
    return oscheck(&decb);
}

int f77d_write(int unit, const char *dd, int recl, int rec, const unsigned char *buf, int fill) {
    DUNIT *d;
    DECB decb;
    int rc;
    d = dget(unit, dd, recl);
    if (!d) return 2;
    if (rec < 1) return 1;
    if (rec > d->nrec) {
        /* past the end: BSAM, filler for the records between */
        if (d->bdam) { osdclose(d->bdam, 1); d->bdam = 0; }
        if (!d->bsam) {
            d->bsam = osbdcb(d->dd, 0);
            if (!d->bsam) return 2;
            d->bsam->dcbmacr1 = 0;
            d->bsam->dcbmacr2 = DCBMRWRT;
            d->bsam->dcbrecfm = (char)0x80;          /* F */
            d->bsam->dcblrecl = (unsigned short)recl;
            d->bsam->dcbblksi = (unsigned short)recl;
            if (dopenb(d->bsam, d->nrec == 0 ? 0x0F : 0x0E) != 0) {
                fprintf(stderr, "f77: DD %s cannot be opened for direct access\n", d->dd);
                free(d->bsam);
                d->bsam = 0;
                return 2;
            }
        }
        if (rec > d->nrec + 1) {
            unsigned char *f;
            f = (unsigned char *)malloc((size_t)recl);
            if (!f) return 2;
            memset(f, fill, (size_t)recl);
            while (d->nrec + 1 < rec) {
                if (dbsamw(d, f) != 0) { free(f); return 2; }
                d->nrec++;
            }
            free(f);
        }
        if (dbsamw(d, buf) != 0) {
            fprintf(stderr, "f77: DD %s: record %d could not be written\n", d->dd, rec);
            return 2;
        }
        d->nrec = rec;
        return 0;
    }
    /* in place: BDAM */
    if (d->bsam) { osbclose(d->bsam, 0, 1, 0); d->bsam = 0; }
    if (!d->bdam) {
        d->bdam = osddcb(d->dd);
        if (!d->bdam) return 2;
        if (osdopen(d->bdam, 0) != 0) {
            fprintf(stderr, "f77: DD %s cannot be opened for direct access\n", d->dd);
            free(d->bdam);
            d->bdam = 0;
            return 2;
        }
    }
    memset(&decb, 0, sizeof decb);
    rc = osdwrite(&decb, d->bdam, (void *)buf, recl, (unsigned)(rec - 1));
    if (rc == 0) rc = oscheck(&decb);
    if (rc != 0) {
        fprintf(stderr, "f77: DD %s: record %d could not be rewritten\n", d->dd, rec);
        return 2;
    }
    return 0;
}

int f77d_read(int unit, const char *dd, int recl, int rec, unsigned char *buf) {
    DUNIT *d;
    DECB decb;
    int rc;
    d = dget(unit, dd, recl);
    if (!d) return 2;
    if (rec < 1 || rec > d->nrec) return 1;
    if (d->bsam) { osbclose(d->bsam, 0, 1, 0); d->bsam = 0; }
    if (!d->bdam) {
        d->bdam = osddcb(d->dd);
        if (!d->bdam) return 2;
        if (osdopen(d->bdam, 0) != 0) {
            fprintf(stderr, "f77: DD %s cannot be opened for direct access\n", d->dd);
            free(d->bdam);
            d->bdam = 0;
            return 2;
        }
    }
    memset(&decb, 0, sizeof decb);
    rc = osdread(&decb, d->bdam, buf, recl, (unsigned)(rec - 1));
    if (rc == 0) rc = oscheck(&decb);
    if (rc != 0) {
        fprintf(stderr, "f77: DD %s: record %d could not be read\n", d->dd, rec);
        return 2;
    }
    return 0;
}

void f77d_close(int unit) {
    if (unit < 0 || unit >= RMAXU) return;
    dshut(&dunit[unit]);
    dunit[unit].dd[0] = 0;
    dunit[unit].nrec = -1;
}

/* ---- unformatted sequential --------------------------------------- */

typedef struct {
    FILE *f;
    int   mode;          /* 0 closed, 1 reading, 2 writing */
    int   pos;           /* records before the position */
    int   nrec;          /* records in the file, -1 not known */
    int   aeof;          /* after the endfile record */
    char  dd[12];        /* "dd:NAME" */
} SUNIT;
static SUNIT sunit[RMAXU];

static SUNIT *sget(int unit, const char *dd) {
    SUNIT *s;
    char nm[9];
    char full[12];
    if (unit < 0 || unit >= RMAXU) return 0;
    rstart();
    s = &sunit[unit];
    rname(nm, dd);
    sprintf(full, "dd:%s", nm);
    if (strcmp(full, s->dd) != 0) {
        if (s->f) fclose(s->f);
        s->f = 0;
        s->mode = 0;
        s->pos = 0;
        s->nrec = -1;
        s->aeof = 0;
        strcpy(s->dd, full);
    }
    return s;
}

static int sgetw(FILE *f, int *n) {
    unsigned char lw[4];
    if (fread(lw, 1, 4, f) != 4) return 1;
    *n = (lw[0] << 24) | (lw[1] << 16) | (lw[2] << 8) | lw[3];
    return 0;
}

static void sputw(FILE *f, int n) {
    unsigned char lw[4];
    lw[0] = (unsigned char)(n >> 24); lw[1] = (unsigned char)(n >> 16);
    lw[2] = (unsigned char)(n >> 8);  lw[3] = (unsigned char)n;
    fwrite(lw, 1, 4, f);
}

/* Open for reading at the position: from the start, skipping. */
static int sopenr(SUNIT *s) {
    int k;
    int n;
    if (s->f) fclose(s->f);
    s->f = 0;
    s->mode = 0;
    if (s->nrec < 0) {
        /* a data set never written holds no records, whatever its space does */
        int blksz;
        if (dempty(s->dd, &blksz) == 1) { s->nrec = 0; return 1; }
    }
    s->f = fopen(s->dd, "rb");
    if (!s->f) return 1;
    s->mode = 1;
    for (k = 0; k < s->pos; k++) {
        if (sgetw(s->f, &n) != 0 || n < 0) return 1;
        while (n-- > 0) if (fgetc(s->f) == EOF) return 1;
    }
    return 0;
}

/* Open for writing at the position: the records before it are copied
 * and written again, since an output open starts the data set anew. */
static int sopenw(SUNIT *s) {
    unsigned char *keep;
    long size;
    long used;
    int k;
    int n;
    keep = 0;
    used = 0;
    if (s->f) { fclose(s->f); s->f = 0; }
    s->mode = 0;
    if (s->pos > 0) {
        FILE *f;
        size = 4096;
        keep = (unsigned char *)malloc((size_t)size);
        f = fopen(s->dd, "rb");
        if (!f || !keep) { if (f) fclose(f); free(keep); return 2; }
        for (k = 0; k < s->pos; k++) {
            if (sgetw(f, &n) != 0 || n < 0) break;
            while (used + 4 + n > size) {
                unsigned char *b;
                size = size * 2;
                b = (unsigned char *)realloc(keep, (size_t)size);
                if (!b) { fclose(f); free(keep); return 2; }
                keep = b;
            }
            keep[used] = (unsigned char)(n >> 24); keep[used + 1] = (unsigned char)(n >> 16);
            keep[used + 2] = (unsigned char)(n >> 8); keep[used + 3] = (unsigned char)n;
            if (fread(keep + used + 4, 1, (size_t)n, f) != (size_t)n) break;
            used += 4 + n;
        }
        fclose(f);
        s->pos = k;
    }
    s->f = fopen(s->dd, "wb");
    if (!s->f) { free(keep); return 2; }
    if (used > 0) fwrite(keep, 1, (size_t)used, s->f);
    free(keep);
    s->mode = 2;
    s->nrec = s->pos;
    return 0;
}

int f77s_write(int unit, const char *dd, const unsigned char *p, int n) {
    SUNIT *s;
    s = sget(unit, dd);
    if (!s) return 2;
    s->aeof = 0;
    if (s->mode != 2 && sopenw(s) != 0) {
        fprintf(stderr, "f77: %s cannot be opened for an unformatted WRITE\n", s->dd + 3);
        return 2;
    }
    sputw(s->f, n);
    if (n > 0) fwrite(p, 1, (size_t)n, s->f);
    s->pos++;
    s->nrec = s->pos;
    return 0;
}

int f77s_read(int unit, const char *dd, unsigned char *p, int max, int *n) {
    SUNIT *s;
    int len;
    *n = 0;
    s = sget(unit, dd);
    if (!s) return 2;
    if (s->aeof) return 1;
    if (s->nrec >= 0 && s->pos >= s->nrec) {
        if (s->mode == 2) { fclose(s->f); s->f = 0; s->mode = 0; }
        s->aeof = 1;
        return 1;
    }
    if (s->mode != 1 && sopenr(s) != 0) {
        s->aeof = 1;
        if (s->nrec < 0) s->nrec = s->pos;
        return 1;
    }
    if (sgetw(s->f, &len) != 0) {
        s->aeof = 1;
        s->nrec = s->pos;
        return 1;
    }
    if (len < 0 || len > max) {
        fprintf(stderr, "f77: %s: bad unformatted record\n", s->dd + 3);
        return 2;
    }
    if (fread(p, 1, (size_t)len, s->f) != (size_t)len) {
        fprintf(stderr, "f77: %s: unformatted record cut short\n", s->dd + 3);
        return 2;
    }
    *n = len;
    s->pos++;
    return 0;
}

void f77s_rewind(int unit) {
    SUNIT *s;
    if (unit < 0 || unit >= RMAXU) return;
    s = &sunit[unit];
    if (s->f) { fclose(s->f); s->f = 0; }
    s->mode = 0;
    s->pos = 0;
    s->aeof = 0;
}

void f77s_backspace(int unit) {
    SUNIT *s;
    if (unit < 0 || unit >= RMAXU) return;
    s = &sunit[unit];
    if (s->aeof) { s->aeof = 0; return; }           /* back over the endfile record */
    if (s->pos == 0) return;
    if (s->f) { fclose(s->f); s->f = 0; }           /* a writer's file ends here */
    s->mode = 0;
    s->pos--;
}

void f77s_endfile(int unit, const char *dd) {
    SUNIT *s;
    s = sget(unit, dd);
    if (!s) return;
    if (s->mode == 2) {
        fclose(s->f);
        s->f = 0;
    } else if (s->nrec < 0 || s->pos < s->nrec || s->mode == 0) {
        /* end the file at the position: rewrite what comes before it */
        if (sopenw(s) == 0) { fclose(s->f); s->f = 0; }
    } else if (s->f) {
        fclose(s->f);
        s->f = 0;
    }
    s->mode = 0;
    s->nrec = s->pos;
    s->aeof = 1;
}

void f77s_close(int unit) {
    SUNIT *s;
    if (unit < 0 || unit >= RMAXU) return;
    s = &sunit[unit];
    if (s->f) fclose(s->f);
    memset(s, 0, sizeof *s);
    s->nrec = -1;
}

void f77r_closeall(void) {
    int u;
    for (u = 0; u < RMAXU; u++) {
        dshut(&dunit[u]);
        if (sunit[u].f) { fclose(sunit[u].f); sunit[u].f = 0; }
    }
}
