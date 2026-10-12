/* hfp_test.c -- read decimal constants on stdin, print their HFP bits. */
#include <stdio.h>
#include <string.h>
#include "../../backend/s370_hfp.h"
int main(void) {
    char line[512];
    while (fgets(line, sizeof line, stdin)) {
        unsigned int hi, lo; int rc;
        line[strcspn(line, "\r\n")] = 0;
        rc = hfp_from_text(line, &hi, &lo);
        printf("%s %d %08X%08X\n", line, rc, hi, lo);
    }
    return 0;
}
