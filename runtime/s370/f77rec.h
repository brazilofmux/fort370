/* f77rec.h -- record-level I/O for fort370's runtime on MVS (f77rec.c).
 *
 * Direct access: a data set of fixed blocks, one record each, RECL
 * bytes; written past its end by BSAM (OUTPUT, then EXTEND), read and
 * rewritten in place by BDAM, by relative block number.
 *
 * Unformatted sequential: records framed by a length word in a stream,
 * positioned by record count, so that REWIND, BACKSPACE and ENDFILE
 * never need a seek (QSAM has none).
 *
 * dd is "dd:NAME" or "NAME".  Results: 0 done, 1 no such record (direct)
 * or end of file (sequential), 2 an error, with a message on stderr. */
#ifndef F77REC_H
#define F77REC_H

/* f77rt.c refers to these weakly (fort370 issue 1): with F77RT as an
 * autocall library, a program that does no unformatted or direct-access
 * I/O does not take this file, and f77rt.c calls these only if they are
 * there.  What brings it in is the program's own call of an entry point
 * defined here, f77_wu_begin, f77_ru_begin, f77_set_rec or f77_dfile:
 * the front doors of unformatted I/O, REC= and DEFINE FILE, which go on
 * into f77rt.c's own (the _rt names below). */
#ifdef F77REC_WEAK
#define F77W __attribute__((weak))
#else
#define F77W
#endif

void f77_wu_begin_rt(int unit) __asm__("F77WUB@R");
int  f77_ru_begin_rt(int unit, int flags) __asm__("F77RUB@R");
void f77_set_rec_rt(int rec) __asm__("F77SRC@R");
void f77_dfile_rt(int unit, int m, int r, int f, int *v) __asm__("F77DFL@R");

int  f77d_read(int unit, const char *dd, int recl, int rec, unsigned char *buf) F77W;
int  f77d_write(int unit, const char *dd, int recl, int rec, const unsigned char *buf, int fill) F77W;
void f77d_close(int unit) F77W;
int  f77d_count(int unit, const char *dd, int recl) F77W;

int  f77s_write(int unit, const char *dd, const unsigned char *p, int n) F77W;
int  f77s_read(int unit, const char *dd, unsigned char *p, int max, int *n) F77W;
void f77s_rewind(int unit) F77W;
void f77s_backspace(int unit) F77W;
void f77s_endfile(int unit, const char *dd) F77W;
void f77s_close(int unit) F77W;

void f77r_closeall(void) F77W;
void f77r_ihc(int n, const char *text) F77W;

#endif
