/* dtoa_test.c -- the runtime's exact HFP-to-decimal conversion against
 * Python's Fraction, on the host.  Build and run with tests/host/dtoa.sh:
 * for each decimal in the list, the compiler's own text-to-HFP gives the
 * words, this prints the digits the runtime would show, and the script
 * checks them against the exact value of those words. */
#include <stdio.h>
#include <string.h>
#include "../../backend/s370_hfp.h"
#include "../../runtime/s370/f77dtoa.h"

int main(int argc, char **argv) {
    int i;
    for (i = 1; i < argc; i++) {
        unsigned int hi, lo;
        char digits[260];
        char mant[64];
        char f[320];
        int decpt, neg, nd, e;
        if (hfp_from_text(argv[i], &hi, &lo) < 0) { printf("%s: bad\n", argv[i]); continue; }
        nd = f77_hfp_digits(hi, lo, digits, &decpt, &neg);
        e = f77_fmt_e_w(hi, lo, 15, mant, &neg);
        f77_fmt_f_w(hi, lo, 6, f);
        printf("%s %08X%08X %d %d %s E15=%s%s.%s%d F6=%s\n", argv[i], hi, lo, nd, decpt, nd ? digits : "0",
               neg ? "-" : "", "0", mant, e, f);
    }
    return 0;
}
