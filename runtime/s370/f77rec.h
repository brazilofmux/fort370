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

int  f77d_read(int unit, const char *dd, int recl, int rec, unsigned char *buf);
int  f77d_write(int unit, const char *dd, int recl, int rec, const unsigned char *buf, int fill);
void f77d_close(int unit);

int  f77s_write(int unit, const char *dd, const unsigned char *p, int n);
int  f77s_read(int unit, const char *dd, unsigned char *p, int max, int *n);
void f77s_rewind(int unit);
void f77s_backspace(int unit);
void f77s_endfile(int unit, const char *dd);
void f77s_close(int unit);

void f77r_closeall(void);

#endif
