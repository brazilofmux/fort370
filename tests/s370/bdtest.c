/* bdtest.c -- the record-level primitives fort370's direct access is
 * built on, tried on MVS by themselves: a data set of fixed blocks made
 * with BSAM (OUTPUT, then EXTEND), read and rewritten by relative block
 * number with BDAM, then read back with QSAM as an ordinary sequential
 * data set.  DD DIRFILE; prints to SYSPRINT.  Build and run:
 *   cc370 -O1 -c bdtest.c && cc370 -o BDTEST bdtest.o -flinker-output=xmit
 *   bench/ship.py BDTEST.xmit */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <osio.h>

#define R 80

/* OPEN with an option osbopen does not offer: X'0F' OUTPUT, X'0E' EXTEND */
static int bopen(DCB *dcb, unsigned opt) {
    unsigned plist;
    int rc;
    plist = 0x80000000u | (opt << 24) | (unsigned)dcb;
    __asm__("LR    1,%1\n\tSVC   19         OPEN\n\tST\t15,0(,%0)"
        : : "r"(&rc), "r"(&plist) : "1", "14", "15", "memory");
    return (dcb->dcboflg & DCBOFOPN) ? 0 : 8;
}

static DCB *bdcb(void) {
    DCB *dcb = osbdcb("DIRFILE", 0);
    dcb->dcbmacr1 = 0;
    dcb->dcbmacr2 = DCBMRWRT;
    dcb->dcbrecfm = (char)0x80;          /* F */
    dcb->dcblrecl = R;
    dcb->dcbblksi = R;
    return dcb;
}

static void fill(char *b, int k, const char *tag) {
    memset(b, ' ', R);
    sprintf(b, "%s %04d", tag, k);
    b[strlen(b)] = ' ';
}

int main(void) {
    DCB *dcb;
    DECB decb;
    char b[R + 1];
    int k;
    int rc;
    FILE *f;

    /* 1: ten blocks, OUTPUT */
    dcb = bdcb();
    rc = bopen(dcb, 0x0F);
    printf("BSAM OUTPUT open rc=%d\n", rc);
    if (rc) return 8;
    for (k = 1; k <= 10; k++) {
        fill(b, k, "FIRST");
        memset(&decb, 0, sizeof decb);
        oswrite(&decb, dcb, b, R);
        rc = oscheck(&decb);
        if (rc) { printf("write %d check rc=%d\n", k, rc); break; }
    }
    osbclose(dcb, 0, 1, 0);

    /* 2: five more, EXTEND */
    dcb = bdcb();
    rc = bopen(dcb, 0x0E);
    printf("BSAM EXTEND open rc=%d\n", rc);
    if (rc) return 8;
    for (k = 11; k <= 15; k++) {
        fill(b, k, "EXTEND");
        memset(&decb, 0, sizeof decb);
        oswrite(&decb, dcb, b, R);
        rc = oscheck(&decb);
        if (rc) { printf("write %d check rc=%d\n", k, rc); break; }
    }
    osbclose(dcb, 0, 1, 0);

    /* 3: BDAM by relative block (0-based) */
    dcb = osddcb("DIRFILE");
    rc = osdopen(dcb, 0);
    printf("BDAM open rc=%d blksize=%d lrecl=%d\n", rc, dcb->dcbblksi, dcb->dcblrecl);
    if (rc) return 8;
    for (k = 12; k >= 0; k -= 6) {
        memset(&decb, 0, sizeof decb);
        memset(b, 0, sizeof b);
        rc = osdread(&decb, dcb, b, R, (unsigned)k);
        if (rc == 0) rc = oscheck(&decb);
        b[20] = 0;
        printf("BDAM read block %d rc=%d [%s]\n", k, rc, b);
    }
    fill(b, 4, "REWRITTEN");
    memset(&decb, 0, sizeof decb);
    rc = osdwrite(&decb, dcb, b, R, 3);
    if (rc == 0) rc = oscheck(&decb);
    printf("BDAM write block 3 rc=%d\n", rc);
    memset(&decb, 0, sizeof decb);
    rc = osdread(&decb, dcb, b, R, 20);
    if (rc == 0) rc = oscheck(&decb);
    printf("BDAM read block 20 (past the end) rc=%d\n", rc);
    osdclose(dcb, 1);

    /* 4: QSAM, sequentially */
    f = fopen("dd:DIRFILE", "rb");
    if (!f) { printf("fopen failed\n"); return 8; }
    k = 0;
    while (fread(b, 1, R, f) == R) {
        k++;
        b[20] = 0;
        if (k <= 5 || k >= 14) printf("QSAM %2d [%s]\n", k, b);
    }
    fclose(f);
    printf("QSAM read %d records\n", k);
    return 0;
}
