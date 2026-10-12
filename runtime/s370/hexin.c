/* hexin.c -- a card deck's worth of hexadecimal text in, binary records
 * out: the way a host-linked load module reaches the guest without a
 * tape.  Built with cc370 and installed once in HERC01.FORT370.LOAD;
 * bench/ship.py then sends each module's XMIT as hex on SYSIN, HEXIN
 * writes it to SYSUT2 as the FB/80 data set it was, and RECEIVE takes
 * it from there.  A mount request per tape file was the alternative.
 *
 * SYSIN (libc370's stdin): records of hexadecimal digits, any length, blanks and
 * anything past column 72 ignored; every 160 digits are one 80-byte
 * record of SYSUT2.  Exit 0, or 8 on a bad digit or a short tail. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int hexval(int c) {
    if (c >= '0' && c <= '9') return c - '0';
    if (c >= 'A' && c <= 'F') return c - 'A' + 10;
    if (c >= 'a' && c <= 'f') return c - 'a' + 10;
    return -1;
}

int main(void) {
    FILE *in;
    FILE *out;
    char line[256];
    unsigned char rec[80];
    int n;
    int half;
    long recs;
    in = stdin;                      /* libc370 has SYSIN open as stdin already */
    out = fopen("dd:SYSUT2", "wb,recfm=fb,lrecl=80");
    if (!out) { fprintf(stderr, "HEXIN: cannot open dd:SYSUT2 for wb,recfm=fb,lrecl=80\n"); out = fopen("dd:SYSUT2", "wb"); }
    if (!out) { fprintf(stderr, "HEXIN: cannot open dd:SYSUT2 for wb\n"); out = fopen("dd:SYSUT2", "w"); }
    if (!out) { fprintf(stderr, "HEXIN: cannot open dd:SYSUT2 for w\n"); return 8; }
    n = 0;
    half = -1;
    recs = 0;
    while (fgets(line, sizeof line, in)) {
        int i;
        for (i = 0; line[i] && i < 72; i++) {
            int v;
            if (line[i] == ' ' || line[i] == '\n' || line[i] == '\r') continue;
            v = hexval(line[i]);
            if (v < 0) { fprintf(stderr, "HEXIN: bad digit '%c' in record %ld\n", line[i], recs + 1); return 8; }
            if (half < 0) { half = v; continue; }
            rec[n++] = (unsigned char)((half << 4) | v);
            half = -1;
            if (n == 80) {
                if (fwrite(rec, 1, 80, out) != 80) { fprintf(stderr, "HEXIN: write failed\n"); return 8; }
                n = 0;
                recs++;
            }
        }
    }
    if (n != 0 || half >= 0) { fprintf(stderr, "HEXIN: %d bytes left over\n", n); return 8; }
    fclose(out);
    printf("HEXIN: %ld records\n", recs);
    return 0;
}
