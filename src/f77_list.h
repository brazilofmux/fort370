/* f77_list.h -- fort370: the compiler's options and its listing, as
 * FORTRAN H's (#34, #35).
 *
 * The options are H's names, with H's defaults (measured on TK5, level
 * 21.8): NAME=MAIN, OPT=00, LINECNT=50, SIZE=0000K, SOURCE, EBCDIC,
 * NOLIST, NODECK, LOAD, NOMAP, NOEDIT, NOID, NOXREF.  On MVS they come
 * from the EXEC statement's PARM, on a host from -p.  Those fort370
 * does not act on are taken and shown, so that JCL written for H runs;
 * an option H does not have is a warning.
 *
 * The listing, on SYSPRINT (a host's -l file), is H's in its layout:
 * a heading on each page; for each program unit its options, its
 * source with each statement numbered as H numbers it (ISN 2 the
 * first, comments and continuation lines unnumbered), its messages,
 * citing the ISN, and its statistics; and the step's at the end.  The
 * messages go to SYSTERM as before, whatever the listing. */

static int f77_opt_source = 1;
static int f77_opt_xref = 0;
static int f77_opt_map = 0;
static int f77_opt_list = 0;
static int f77_opt_deck = 0;
static int f77_opt_load = 1;
static int f77_opt_edit = 0;
static int f77_opt_id = 0;
static int f77_opt_ebcdic = 1;
static int f77_opt_opt = 0;
static int f77_opt_linecnt = 50;
static int f77_opt_size = 0;
static char f77_opt_name[9] = "MAIN";

static FILE *f77_lst;          /* the listing, or 0 */
static int f77_lst_on;         /* a unit's own text is being read: list it */
static int f77_lst_hi;         /* the source is listed up to here */
static int f77_lst_isn;        /* the unit's statements so far, H's ISN */
static int f77_lst_lines;      /* lines on the page */
static int f77_lst_page;
static char f77_lst_date[24];
static int f77_lst_ndiag;      /* the unit's messages */
static int f77_lst_usev;       /* their highest severity */
static int f77_lst_tdiag;      /* the step's */

/* the unit's statements: the line each begins on, and its ISN */
static int *f77_lst_sline;
static int f77_lst_nsline;
static int f77_lst_capsline;

/* the messages not yet listed */
#define F77_LST_MAXMSG 400
typedef struct { int line; int sev; char text[120]; } F77LstMsg;
static F77LstMsg *f77_lst_msg;
static int f77_lst_nmsg;
static int f77_lst_lost;       /* those past F77_LST_MAXMSG */

static int f77_opt_word(char *w, char *on, char *off, int *v) {
    if (strcmp(w, on) == 0) { *v = 1; return 1; }
    if (strcmp(w, off) == 0) { *v = 0; return 1; }
    return 0;
}

static int f77_opt_num(char *w, char *key, int *v) {
    int n;
    int k;
    n = (int)strlen(key);
    if (strncmp(w, key, (size_t)n) != 0) return 0;
    k = 0;
    w = w + n;
    if (*w < '0' || *w > '9') return 0;
    while (*w >= '0' && *w <= '9') { k = k * 10 + (*w - '0'); w++; }
    if (*w == 'K') w++;
    if (*w) return 0;
    *v = k;
    return 1;
}

/* The options, as PARM gives them: separated by commas or blanks,
 * perhaps in parentheses, in either case. */
static void f77_options(char *s) {
    char w[40];
    int n;
    for (;;) {
        while (*s == ',' || *s == ' ' || *s == '(' || *s == ')' || *s == '\'') s++;
        if (!*s) break;
        n = 0;
        while (*s && *s != ',' && *s != ' ' && *s != ')' && *s != '\'') {
            if (n < (int)sizeof w - 1) w[n++] = (char)lx_upper(*s);
            s++;
        }
        w[n] = 0;
        if (f77_opt_word(w, "SOURCE", "NOSOURCE", &f77_opt_source)) continue;
        if (f77_opt_word(w, "XREF", "NOXREF", &f77_opt_xref)) continue;
        if (f77_opt_word(w, "MAP", "NOMAP", &f77_opt_map)) continue;
        if (f77_opt_word(w, "LIST", "NOLIST", &f77_opt_list)) continue;
        if (f77_opt_word(w, "DECK", "NODECK", &f77_opt_deck)) continue;
        if (f77_opt_word(w, "LOAD", "NOLOAD", &f77_opt_load)) continue;
        if (f77_opt_word(w, "EDIT", "NOEDIT", &f77_opt_edit)) continue;
        if (f77_opt_word(w, "ID", "NOID", &f77_opt_id)) continue;
        if (f77_opt_word(w, "EBCDIC", "BCD", &f77_opt_ebcdic)) continue;
        if (f77_opt_num(w, "OPT=", &f77_opt_opt) && f77_opt_opt <= 2) continue;
        if (f77_opt_num(w, "LINECNT=", &f77_opt_linecnt)) {
            if (f77_opt_linecnt < 10) f77_opt_linecnt = 10;
            continue;
        }
        if (f77_opt_num(w, "SIZE=", &f77_opt_size)) continue;
        if (strncmp(w, "NAME=", 5) == 0 && w[5] && strlen(w + 5) <= 8) { strcpy(f77_opt_name, w + 5); continue; }
        {
            char m[80];
            sprintf(m, "the option %.40s is not one of FORTRAN H's; it is ignored", w);
            f77_warn(0, m);
        }
    }
}

static void f77_lst_heading(void) {
    f77_lst_page = f77_lst_page + 1;
    fprintf(f77_lst, "1 FORT370                                FORTRAN 77 FOR MVS 3.8J"
            "                     DATE  %s     PAGE %03d\n", f77_lst_date, f77_lst_page);
    f77_lst_lines = 1;
}

/* One line of the listing, after cc blank lines (0 or 1) */
static void f77_lst_put(int skip, char *text) {
    if (!f77_lst) return;
    if (f77_lst_page == 0 || f77_lst_lines + 1 + skip > f77_opt_linecnt) f77_lst_heading();
    fprintf(f77_lst, "%c%s\n", skip ? '0' : ' ', text);
    f77_lst_lines = f77_lst_lines + 1 + skip;
}

static void f77_lst_options(char *lead) {
    char b[200];
    sprintf(b, "%sNAME=%6s,OPT=%02d,LINECNT=%d,SIZE=%04dK,", lead, f77_opt_name, f77_opt_opt,
            f77_opt_linecnt, f77_opt_size);
    f77_lst_put(0, b);
    sprintf(b, "%*s%s,%s,%s,%s,%s,%s,%s,%s,%s", (int)strlen(lead), "",
            f77_opt_source ? "SOURCE" : "NOSOURCE", f77_opt_ebcdic ? "EBCDIC" : "BCD",
            f77_opt_list ? "LIST" : "NOLIST", f77_opt_deck ? "DECK" : "NODECK",
            f77_opt_load ? "LOAD" : "NOLOAD", f77_opt_map ? "MAP" : "NOMAP",
            f77_opt_edit ? "EDIT" : "NOEDIT", f77_opt_id ? "ID" : "NOID",
            f77_opt_xref ? "XREF" : "NOXREF");
    f77_lst_put(0, b);
}

/* The listing opened, if the options or the host ask for one */
static void f77_lst_open(FILE *f) {
    time_t t;
    struct tm *tm;
    f77_lst = f;
    if (!f) return;
    t = time(0);
    tm = localtime(&t);
    if (tm) sprintf(f77_lst_date, "%02d.%03d/%02d.%02d.%02d", tm->tm_year % 100, tm->tm_yday + 1,
                    tm->tm_hour, tm->tm_min, tm->tm_sec);
    if (!f77_lst_msg) f77_lst_msg = (F77LstMsg *)malloc(sizeof(F77LstMsg) * F77_LST_MAXMSG);
    if (!f77_lst_msg) f77_lst = 0;
}

/* A message, for the listing: f77_error's and the rest call it */
static void f77_lst_note(int line, int sev, char *text) {
    /* before the listing opens, the options' own: kept for it */
    if (!f77_lst && !f77_lst_msg) f77_lst_msg = (F77LstMsg *)malloc(sizeof(F77LstMsg) * F77_LST_MAXMSG);
    if (!f77_lst_msg) return;
    if (f77_lst_nmsg >= F77_LST_MAXMSG) { f77_lst_lost = f77_lst_lost + 1; return; }
    f77_lst_msg[f77_lst_nmsg].line = line;
    f77_lst_msg[f77_lst_nmsg].sev = sev;
    strncpy(f77_lst_msg[f77_lst_nmsg].text, text, sizeof f77_lst_msg[0].text - 1);
    f77_lst_msg[f77_lst_nmsg].text[sizeof f77_lst_msg[0].text - 1] = 0;
    f77_lst_nmsg = f77_lst_nmsg + 1;
}

/* A card of the source as it is read (f77_next_stmt): kind 0 a comment
 * or blank line, 1 a statement's line, 2 a continuation.  Only a unit's
 * own reading of its text is listed, each line once: not the scan, not
 * a callee's text read again for the inliner, not the trial compile of
 * f77_check_persistence, not an ENTRY's reading of its parent. */
static void f77_lst_card(int p, int kind) {
    char b[140];
    int e;
    int n;
    int c;
    if (!f77_lst || !f77_lst_on || f77_inline_depth > 0 || f77_quiet || p < f77_lst_hi) return;
    e = p;
    n = 0;
    while (lx_has(e) && lx_src[e] != '\n') {
        c = lx_src[e];
        if (c != '\r' && n < 80) { b[n + 16] = (char)(c == '\t' ? ' ' : c); n = n + 1; }
        e = e + 1;
    }
    f77_lst_hi = lx_has(e) ? e + 1 : e;
    while (n > 0 && b[n + 15] == ' ') n = n - 1;
    b[n + 16] = 0;
    if (kind == 1) {
        f77_lst_isn = f77_lst_isn + 1;
        if (f77_lst_nsline >= f77_lst_capsline) {
            int nc;
            int *nb;
            nc = f77_lst_capsline ? f77_lst_capsline * 2 : 256;
            nb = (int *)realloc(f77_lst_sline, sizeof(int) * (size_t)nc);
            if (nb) { f77_lst_sline = nb; f77_lst_capsline = nc; }
        }
        if (f77_lst_nsline < f77_lst_capsline) {
            f77_lst_sline[f77_lst_nsline] = lx_stmt_line;
            f77_lst_nsline = f77_lst_nsline + 1;
        }
        {
            char isn[20];
            sprintf(isn, "   ISN %04d     ", f77_lst_isn);
            memcpy(b, isn, 16);
        }
    } else {
        memset(b, ' ', 16);
    }
    if (!f77_opt_source) return;
    f77_lst_put(0, b);
}

/* The ISN of the statement on (or last begun before) a line, or 0 */
static int f77_lst_isn_of(int line) {
    int i;
    int k;
    k = 0;
    for (i = 0; i < f77_lst_nsline; i++) {
        if (f77_lst_sline[i] > line) break;
        k = i + 2;
    }
    return k;
}

static void f77_lst_unit_begin(int u) {
    if (!f77_lst) return;
    f77_lst_on = f77_uentry_parent[u] < 0 && !f77_quiet;
    if (!f77_lst_on) return;
    f77_lst_isn = 1;
    f77_lst_nsline = 0;
    f77_lst_ndiag = 0;
    f77_lst_usev = 0;
    f77_lst_heading();
    f77_lst_options("           COMPILER OPTIONS - ");
}

/* The unit's text read: its messages, those of the scan before it
 * among them, its statistics */
static void f77_lst_unit_end(int last) {
    char b[200];
    int i;
    int k;
    int first;
    if (!f77_lst || !f77_lst_on) return;
    f77_lst_on = 0;
    first = 1;
    k = 0;
    for (i = 0; i < f77_lst_nmsg; i++) {
        F77LstMsg *m;
        int isn;
        m = &f77_lst_msg[i];
        if (m->line > last && last >= 0) { f77_lst_msg[k++] = *m; continue; }
        if (first) {
            f77_lst_put(1, "                  LEVEL        MESSAGE");
            first = 0;
        }
        isn = f77_lst_isn_of(m->line);
        if (m->line <= 0) sprintf(b, "                    %02d        %s", m->sev, m->text);
        else if (isn > 0) sprintf(b, "     ISN    %04d     %02d        %s", isn, m->sev, m->text);
        else sprintf(b, "    LINE  %06d     %02d        %s", m->line, m->sev, m->text);
        f77_lst_put(0, b);
        f77_lst_ndiag = f77_lst_ndiag + 1;
        if (m->sev > f77_lst_usev) f77_lst_usev = m->sev;
    }
    f77_lst_nmsg = k;
    f77_lst_tdiag = f77_lst_tdiag + f77_lst_ndiag;
    f77_lst_options("*OPTIONS IN EFFECT*      ");
    sprintf(b, "*STATISTICS*     SOURCE STATEMENTS = %7d", f77_lst_isn - 1);
    f77_lst_put(0, b);
    if (f77_lst_ndiag) sprintf(b, "*STATISTICS*  %4d DIAGNOSTICS GENERATED, HIGHEST SEVERITY CODE IS %2d", f77_lst_ndiag, f77_lst_usev);
    else strcpy(b, "*STATISTICS*  NO  DIAGNOSTICS GENERATED");
    f77_lst_put(0, b);
    f77_lst_put(0, "****** END OF COMPILATION ******");
}

/* The step's end: what no unit took, and the step's statistics */
static void f77_lst_close(void) {
    char b[120];
    int i;
    if (!f77_lst) return;
    for (i = 0; i < f77_lst_nmsg; i++) {
        sprintf(b, "    LINE  %06d     %02d        %s", f77_lst_msg[i].line, f77_lst_msg[i].sev, f77_lst_msg[i].text);
        f77_lst_put(0, b);
        f77_lst_tdiag = f77_lst_tdiag + 1;
    }
    if (f77_lst_lost) {
        sprintf(b, "    %d MORE MESSAGES, ON SYSTERM ONLY", f77_lst_lost);
        f77_lst_put(0, b);
        f77_lst_tdiag = f77_lst_tdiag + f77_lst_lost;
    }
    if (f77_lst_tdiag) sprintf(b, "*STATISTICS*  %4d DIAGNOSTICS THIS STEP, HIGHEST SEVERITY CODE IS %2d", f77_lst_tdiag, f77_rc);
    else strcpy(b, "*STATISTICS*  NO  DIAGNOSTICS THIS STEP");
    f77_lst_put(1, b);
    fflush(f77_lst);
}
