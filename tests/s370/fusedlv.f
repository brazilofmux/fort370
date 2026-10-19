C     A value loaded before a loop and read only by a compare in it
C     must keep its spill slot for the whole loop.  A unit whose static
C     area outgrows one data base is allocated twice, and on the second
C     pass a compare fused into its branch was already a NOP: the
C     value's live range stopped at the compare, and the loop body's
C     temporaries took its slot.  MINOS's SPECS2 lost NSPEC so, and
C     stopped after two of five specs (Rene Ferland, 2026-10-19); here
C     a keyword constant is lost when the record before it is not a
C     keyword.  The shape is SPECS2's: many keyword constants (140,
C     which take a second data base), a chain of tests, a WRITE for
C     the rest.
      PROGRAM FUSEDL
      COMMON /VALS/ IV(140)
      CHARACTER*3 K(5)
      DATA K /'DEL', 'RAG', 'QQQ', 'SIG', 'HEN'/
      DO 10 I = 1, 5
      WRITE (8, 100) K(I), 10 * I
   10 CONTINUE
      END FILE 8
      REWIND 8
      CALL PICK(5, NGOT)
      WRITE (6, 101) NGOT, IV(4), IV(41), IV(18), IV(56)
  100 FORMAT (A3 / I8)
  101 FORMAT (' >READ', I3, 4I5)
      END
      SUBROUTINE PICK(NSPEC, NGOT)
      COMMON /VALS/ IV(140)
      REAL W(1200)
      INTEGER LALP, LBET, LGAM, LDEL, LEPS, LZET, LETA
      INTEGER LTHE, LIOT, LKAP, LLAM, LMUU, LNUU, LXII
      INTEGER LOMI, LPII, LRHO, LSIG, LTAU, LUPS, LPHI
      INTEGER LCHI, LPSI, LOMG, LARC, LBOW, LCUP, LDIE
      INTEGER LELM, LFIG, LGEM, LHUT, LINK, LJAR, LKIT
      INTEGER LLID, LMOP, LNIB, LOAK, LPEG, LRAG, LSAW
      INTEGER LTOP, LURN, LVAN, LWAX, LYAK, LZIP, LASH
      INTEGER LBAY, LCOG, LDEN, LEEL, LFOX, LGUM, LHEN
      INTEGER LBAB, LBAD, LBAG, LBAL, LBAM, LBAN, LBAP
      INTEGER LBAR, LBAS, LBAT, LBEB, LBED, LBEG, LBEL
      INTEGER LBEM, LBEN, LBEP, LBER, LBES, LBIB, LBID
      INTEGER LBIG, LBIL, LBIM, LBIN, LBIP, LBIR, LBIS
      INTEGER LBIT, LBOB, LBOD, LBOG, LBOL, LBOM, LBON
      INTEGER LBOP, LBOR, LBOS, LBOT, LBUB, LBUD, LBUG
      INTEGER LBUL, LBUM, LBUN, LBUP, LBUR, LBUS, LBUT
      INTEGER LCAB, LCAD, LCAG, LCAL, LCAM, LCAN, LCAP
      INTEGER LCAR, LCAS, LCAT, LCEB, LCED, LCEG, LCEL
      INTEGER LCEM, LCEN, LCEP, LCER, LCES, LCET, LCIB
      INTEGER LCID, LCIG, LCIL, LCIM, LCIN, LCIP, LCIR
      INTEGER LCIS, LCIT, LCOB, LCOD, LCOL, LCOM, LCON
      DATA LALP /4HALP /, LBET /4HBET /
      DATA LGAM /4HGAM /, LDEL /4HDEL /
      DATA LEPS /4HEPS /, LZET /4HZET /
      DATA LETA /4HETA /, LTHE /4HTHE /
      DATA LIOT /4HIOT /, LKAP /4HKAP /
      DATA LLAM /4HLAM /, LMUU /4HMUU /
      DATA LNUU /4HNUU /, LXII /4HXII /
      DATA LOMI /4HOMI /, LPII /4HPII /
      DATA LRHO /4HRHO /, LSIG /4HSIG /
      DATA LTAU /4HTAU /, LUPS /4HUPS /
      DATA LPHI /4HPHI /, LCHI /4HCHI /
      DATA LPSI /4HPSI /, LOMG /4HOMG /
      DATA LARC /4HARC /, LBOW /4HBOW /
      DATA LCUP /4HCUP /, LDIE /4HDIE /
      DATA LELM /4HELM /, LFIG /4HFIG /
      DATA LGEM /4HGEM /, LHUT /4HHUT /
      DATA LINK /4HINK /, LJAR /4HJAR /
      DATA LKIT /4HKIT /, LLID /4HLID /
      DATA LMOP /4HMOP /, LNIB /4HNIB /
      DATA LOAK /4HOAK /, LPEG /4HPEG /
      DATA LRAG /4HRAG /, LSAW /4HSAW /
      DATA LTOP /4HTOP /, LURN /4HURN /
      DATA LVAN /4HVAN /, LWAX /4HWAX /
      DATA LYAK /4HYAK /, LZIP /4HZIP /
      DATA LASH /4HASH /, LBAY /4HBAY /
      DATA LCOG /4HCOG /, LDEN /4HDEN /
      DATA LEEL /4HEEL /, LFOX /4HFOX /
      DATA LGUM /4HGUM /, LHEN /4HHEN /
      DATA LBAB /4HBAB /, LBAD /4HBAD /
      DATA LBAG /4HBAG /, LBAL /4HBAL /
      DATA LBAM /4HBAM /, LBAN /4HBAN /
      DATA LBAP /4HBAP /, LBAR /4HBAR /
      DATA LBAS /4HBAS /, LBAT /4HBAT /
      DATA LBEB /4HBEB /, LBED /4HBED /
      DATA LBEG /4HBEG /, LBEL /4HBEL /
      DATA LBEM /4HBEM /, LBEN /4HBEN /
      DATA LBEP /4HBEP /, LBER /4HBER /
      DATA LBES /4HBES /, LBIB /4HBIB /
      DATA LBID /4HBID /, LBIG /4HBIG /
      DATA LBIL /4HBIL /, LBIM /4HBIM /
      DATA LBIN /4HBIN /, LBIP /4HBIP /
      DATA LBIR /4HBIR /, LBIS /4HBIS /
      DATA LBIT /4HBIT /, LBOB /4HBOB /
      DATA LBOD /4HBOD /, LBOG /4HBOG /
      DATA LBOL /4HBOL /, LBOM /4HBOM /
      DATA LBON /4HBON /, LBOP /4HBOP /
      DATA LBOR /4HBOR /, LBOS /4HBOS /
      DATA LBOT /4HBOT /, LBUB /4HBUB /
      DATA LBUD /4HBUD /, LBUG /4HBUG /
      DATA LBUL /4HBUL /, LBUM /4HBUM /
      DATA LBUN /4HBUN /, LBUP /4HBUP /
      DATA LBUR /4HBUR /, LBUS /4HBUS /
      DATA LBUT /4HBUT /, LCAB /4HCAB /
      DATA LCAD /4HCAD /, LCAG /4HCAG /
      DATA LCAL /4HCAL /, LCAM /4HCAM /
      DATA LCAN /4HCAN /, LCAP /4HCAP /
      DATA LCAR /4HCAR /, LCAS /4HCAS /
      DATA LCAT /4HCAT /, LCEB /4HCEB /
      DATA LCED /4HCED /, LCEG /4HCEG /
      DATA LCEL /4HCEL /, LCEM /4HCEM /
      DATA LCEN /4HCEN /, LCEP /4HCEP /
      DATA LCER /4HCER /, LCES /4HCES /
      DATA LCET /4HCET /, LCIB /4HCIB /
      DATA LCID /4HCID /, LCIG /4HCIG /
      DATA LCIL /4HCIL /, LCIM /4HCIM /
      DATA LCIN /4HCIN /, LCIP /4HCIP /
      DATA LCIR /4HCIR /, LCIS /4HCIS /
      DATA LCIT /4HCIT /, LCOB /4HCOB /
      DATA LCOD /4HCOD /, LCOL /4HCOL /
      DATA LCOM /4HCOM /, LCON /4HCON /
      DO 5 J = 1, 1200
    5 W(J) = J
      NREAD = 0
      NGOT = 0
  100 NREAD = NREAD + 1
      IF (NREAD .GT. NSPEC) GO TO 900
      READ (8, 1000) KEY, NUM
      NGOT = NGOT + 1
      IF (KEY .EQ. LALP) GO TO 200
      IF (KEY .EQ. LBET) GO TO 201
      IF (KEY .EQ. LGAM) GO TO 202
      IF (KEY .EQ. LDEL) GO TO 203
      IF (KEY .EQ. LEPS) GO TO 204
      IF (KEY .EQ. LZET) GO TO 205
      IF (KEY .EQ. LETA) GO TO 206
      IF (KEY .EQ. LTHE) GO TO 207
      IF (KEY .EQ. LIOT) GO TO 208
      IF (KEY .EQ. LKAP) GO TO 209
      IF (KEY .EQ. LLAM) GO TO 210
      IF (KEY .EQ. LMUU) GO TO 211
      IF (KEY .EQ. LNUU) GO TO 212
      IF (KEY .EQ. LXII) GO TO 213
      IF (KEY .EQ. LOMI) GO TO 214
      IF (KEY .EQ. LPII) GO TO 215
      IF (KEY .EQ. LRHO) GO TO 216
      IF (KEY .EQ. LSIG) GO TO 217
      IF (KEY .EQ. LTAU) GO TO 218
      IF (KEY .EQ. LUPS) GO TO 219
      IF (KEY .EQ. LPHI) GO TO 220
      IF (KEY .EQ. LCHI) GO TO 221
      IF (KEY .EQ. LPSI) GO TO 222
      IF (KEY .EQ. LOMG) GO TO 223
      IF (KEY .EQ. LARC) GO TO 224
      IF (KEY .EQ. LBOW) GO TO 225
      IF (KEY .EQ. LCUP) GO TO 226
      IF (KEY .EQ. LDIE) GO TO 227
      IF (KEY .EQ. LELM) GO TO 228
      IF (KEY .EQ. LFIG) GO TO 229
      IF (KEY .EQ. LGEM) GO TO 230
      IF (KEY .EQ. LHUT) GO TO 231
      IF (KEY .EQ. LINK) GO TO 232
      IF (KEY .EQ. LJAR) GO TO 233
      IF (KEY .EQ. LKIT) GO TO 234
      IF (KEY .EQ. LLID) GO TO 235
      IF (KEY .EQ. LMOP) GO TO 236
      IF (KEY .EQ. LNIB) GO TO 237
      IF (KEY .EQ. LOAK) GO TO 238
      IF (KEY .EQ. LPEG) GO TO 239
      IF (KEY .EQ. LRAG) GO TO 240
      IF (KEY .EQ. LSAW) GO TO 241
      IF (KEY .EQ. LTOP) GO TO 242
      IF (KEY .EQ. LURN) GO TO 243
      IF (KEY .EQ. LVAN) GO TO 244
      IF (KEY .EQ. LWAX) GO TO 245
      IF (KEY .EQ. LYAK) GO TO 246
      IF (KEY .EQ. LZIP) GO TO 247
      IF (KEY .EQ. LASH) GO TO 248
      IF (KEY .EQ. LBAY) GO TO 249
      IF (KEY .EQ. LCOG) GO TO 250
      IF (KEY .EQ. LDEN) GO TO 251
      IF (KEY .EQ. LEEL) GO TO 252
      IF (KEY .EQ. LFOX) GO TO 253
      IF (KEY .EQ. LGUM) GO TO 254
      IF (KEY .EQ. LHEN) GO TO 255
      IF (KEY .EQ. LBAB) GO TO 256
      IF (KEY .EQ. LBAD) GO TO 257
      IF (KEY .EQ. LBAG) GO TO 258
      IF (KEY .EQ. LBAL) GO TO 259
      IF (KEY .EQ. LBAM) GO TO 260
      IF (KEY .EQ. LBAN) GO TO 261
      IF (KEY .EQ. LBAP) GO TO 262
      IF (KEY .EQ. LBAR) GO TO 263
      IF (KEY .EQ. LBAS) GO TO 264
      IF (KEY .EQ. LBAT) GO TO 265
      IF (KEY .EQ. LBEB) GO TO 266
      IF (KEY .EQ. LBED) GO TO 267
      IF (KEY .EQ. LBEG) GO TO 268
      IF (KEY .EQ. LBEL) GO TO 269
      IF (KEY .EQ. LBEM) GO TO 270
      IF (KEY .EQ. LBEN) GO TO 271
      IF (KEY .EQ. LBEP) GO TO 272
      IF (KEY .EQ. LBER) GO TO 273
      IF (KEY .EQ. LBES) GO TO 274
      IF (KEY .EQ. LBIB) GO TO 275
      IF (KEY .EQ. LBID) GO TO 276
      IF (KEY .EQ. LBIG) GO TO 277
      IF (KEY .EQ. LBIL) GO TO 278
      IF (KEY .EQ. LBIM) GO TO 279
      IF (KEY .EQ. LBIN) GO TO 280
      IF (KEY .EQ. LBIP) GO TO 281
      IF (KEY .EQ. LBIR) GO TO 282
      IF (KEY .EQ. LBIS) GO TO 283
      IF (KEY .EQ. LBIT) GO TO 284
      IF (KEY .EQ. LBOB) GO TO 285
      IF (KEY .EQ. LBOD) GO TO 286
      IF (KEY .EQ. LBOG) GO TO 287
      IF (KEY .EQ. LBOL) GO TO 288
      IF (KEY .EQ. LBOM) GO TO 289
      IF (KEY .EQ. LBON) GO TO 290
      IF (KEY .EQ. LBOP) GO TO 291
      IF (KEY .EQ. LBOR) GO TO 292
      IF (KEY .EQ. LBOS) GO TO 293
      IF (KEY .EQ. LBOT) GO TO 294
      IF (KEY .EQ. LBUB) GO TO 295
      IF (KEY .EQ. LBUD) GO TO 296
      IF (KEY .EQ. LBUG) GO TO 297
      IF (KEY .EQ. LBUL) GO TO 298
      IF (KEY .EQ. LBUM) GO TO 299
      IF (KEY .EQ. LBUN) GO TO 300
      IF (KEY .EQ. LBUP) GO TO 301
      IF (KEY .EQ. LBUR) GO TO 302
      IF (KEY .EQ. LBUS) GO TO 303
      IF (KEY .EQ. LBUT) GO TO 304
      IF (KEY .EQ. LCAB) GO TO 305
      IF (KEY .EQ. LCAD) GO TO 306
      IF (KEY .EQ. LCAG) GO TO 307
      IF (KEY .EQ. LCAL) GO TO 308
      IF (KEY .EQ. LCAM) GO TO 309
      IF (KEY .EQ. LCAN) GO TO 310
      IF (KEY .EQ. LCAP) GO TO 311
      IF (KEY .EQ. LCAR) GO TO 312
      IF (KEY .EQ. LCAS) GO TO 313
      IF (KEY .EQ. LCAT) GO TO 314
      IF (KEY .EQ. LCEB) GO TO 315
      IF (KEY .EQ. LCED) GO TO 316
      IF (KEY .EQ. LCEG) GO TO 317
      IF (KEY .EQ. LCEL) GO TO 318
      IF (KEY .EQ. LCEM) GO TO 319
      IF (KEY .EQ. LCEN) GO TO 320
      IF (KEY .EQ. LCEP) GO TO 321
      IF (KEY .EQ. LCER) GO TO 322
      IF (KEY .EQ. LCES) GO TO 323
      IF (KEY .EQ. LCET) GO TO 324
      IF (KEY .EQ. LCIB) GO TO 325
      IF (KEY .EQ. LCID) GO TO 326
      IF (KEY .EQ. LCIG) GO TO 327
      IF (KEY .EQ. LCIL) GO TO 328
      IF (KEY .EQ. LCIM) GO TO 329
      IF (KEY .EQ. LCIN) GO TO 330
      IF (KEY .EQ. LCIP) GO TO 331
      IF (KEY .EQ. LCIR) GO TO 332
      IF (KEY .EQ. LCIS) GO TO 333
      IF (KEY .EQ. LCIT) GO TO 334
      IF (KEY .EQ. LCOB) GO TO 335
      IF (KEY .EQ. LCOD) GO TO 336
      IF (KEY .EQ. LCOL) GO TO 337
      IF (KEY .EQ. LCOM) GO TO 338
      IF (KEY .EQ. LCON) GO TO 339
      WRITE (6, 1050) KEY, NUM, W(NUM)
      GO TO 100
  200 IV(1) = NUM + INT(W(1))
      GO TO 100
  201 IV(2) = NUM + INT(W(2))
      GO TO 100
  202 IV(3) = NUM + INT(W(3))
      GO TO 100
  203 IV(4) = NUM + INT(W(4))
      GO TO 100
  204 IV(5) = NUM + INT(W(5))
      GO TO 100
  205 IV(6) = NUM + INT(W(6))
      GO TO 100
  206 IV(7) = NUM + INT(W(7))
      GO TO 100
  207 IV(8) = NUM + INT(W(8))
      GO TO 100
  208 IV(9) = NUM + INT(W(9))
      GO TO 100
  209 IV(10) = NUM + INT(W(10))
      GO TO 100
  210 IV(11) = NUM + INT(W(11))
      GO TO 100
  211 IV(12) = NUM + INT(W(12))
      GO TO 100
  212 IV(13) = NUM + INT(W(13))
      GO TO 100
  213 IV(14) = NUM + INT(W(14))
      GO TO 100
  214 IV(15) = NUM + INT(W(15))
      GO TO 100
  215 IV(16) = NUM + INT(W(16))
      GO TO 100
  216 IV(17) = NUM + INT(W(17))
      GO TO 100
  217 IV(18) = NUM + INT(W(18))
      GO TO 100
  218 IV(19) = NUM + INT(W(19))
      GO TO 100
  219 IV(20) = NUM + INT(W(20))
      GO TO 100
  220 IV(21) = NUM + INT(W(21))
      GO TO 100
  221 IV(22) = NUM + INT(W(22))
      GO TO 100
  222 IV(23) = NUM + INT(W(23))
      GO TO 100
  223 IV(24) = NUM + INT(W(24))
      GO TO 100
  224 IV(25) = NUM + INT(W(25))
      GO TO 100
  225 IV(26) = NUM + INT(W(26))
      GO TO 100
  226 IV(27) = NUM + INT(W(27))
      GO TO 100
  227 IV(28) = NUM + INT(W(28))
      GO TO 100
  228 IV(29) = NUM + INT(W(29))
      GO TO 100
  229 IV(30) = NUM + INT(W(30))
      GO TO 100
  230 IV(31) = NUM + INT(W(31))
      GO TO 100
  231 IV(32) = NUM + INT(W(32))
      GO TO 100
  232 IV(33) = NUM + INT(W(33))
      GO TO 100
  233 IV(34) = NUM + INT(W(34))
      GO TO 100
  234 IV(35) = NUM + INT(W(35))
      GO TO 100
  235 IV(36) = NUM + INT(W(36))
      GO TO 100
  236 IV(37) = NUM + INT(W(37))
      GO TO 100
  237 IV(38) = NUM + INT(W(38))
      GO TO 100
  238 IV(39) = NUM + INT(W(39))
      GO TO 100
  239 IV(40) = NUM + INT(W(40))
      GO TO 100
  240 IV(41) = NUM + INT(W(41))
      GO TO 100
  241 IV(42) = NUM + INT(W(42))
      GO TO 100
  242 IV(43) = NUM + INT(W(43))
      GO TO 100
  243 IV(44) = NUM + INT(W(44))
      GO TO 100
  244 IV(45) = NUM + INT(W(45))
      GO TO 100
  245 IV(46) = NUM + INT(W(46))
      GO TO 100
  246 IV(47) = NUM + INT(W(47))
      GO TO 100
  247 IV(48) = NUM + INT(W(48))
      GO TO 100
  248 IV(49) = NUM + INT(W(49))
      GO TO 100
  249 IV(50) = NUM + INT(W(50))
      GO TO 100
  250 IV(51) = NUM + INT(W(51))
      GO TO 100
  251 IV(52) = NUM + INT(W(52))
      GO TO 100
  252 IV(53) = NUM + INT(W(53))
      GO TO 100
  253 IV(54) = NUM + INT(W(54))
      GO TO 100
  254 IV(55) = NUM + INT(W(55))
      GO TO 100
  255 IV(56) = NUM + INT(W(56))
      GO TO 100
  256 IV(57) = NUM + INT(W(57))
      GO TO 100
  257 IV(58) = NUM + INT(W(58))
      GO TO 100
  258 IV(59) = NUM + INT(W(59))
      GO TO 100
  259 IV(60) = NUM + INT(W(60))
      GO TO 100
  260 IV(61) = NUM + INT(W(61))
      GO TO 100
  261 IV(62) = NUM + INT(W(62))
      GO TO 100
  262 IV(63) = NUM + INT(W(63))
      GO TO 100
  263 IV(64) = NUM + INT(W(64))
      GO TO 100
  264 IV(65) = NUM + INT(W(65))
      GO TO 100
  265 IV(66) = NUM + INT(W(66))
      GO TO 100
  266 IV(67) = NUM + INT(W(67))
      GO TO 100
  267 IV(68) = NUM + INT(W(68))
      GO TO 100
  268 IV(69) = NUM + INT(W(69))
      GO TO 100
  269 IV(70) = NUM + INT(W(70))
      GO TO 100
  270 IV(71) = NUM + INT(W(71))
      GO TO 100
  271 IV(72) = NUM + INT(W(72))
      GO TO 100
  272 IV(73) = NUM + INT(W(73))
      GO TO 100
  273 IV(74) = NUM + INT(W(74))
      GO TO 100
  274 IV(75) = NUM + INT(W(75))
      GO TO 100
  275 IV(76) = NUM + INT(W(76))
      GO TO 100
  276 IV(77) = NUM + INT(W(77))
      GO TO 100
  277 IV(78) = NUM + INT(W(78))
      GO TO 100
  278 IV(79) = NUM + INT(W(79))
      GO TO 100
  279 IV(80) = NUM + INT(W(80))
      GO TO 100
  280 IV(81) = NUM + INT(W(81))
      GO TO 100
  281 IV(82) = NUM + INT(W(82))
      GO TO 100
  282 IV(83) = NUM + INT(W(83))
      GO TO 100
  283 IV(84) = NUM + INT(W(84))
      GO TO 100
  284 IV(85) = NUM + INT(W(85))
      GO TO 100
  285 IV(86) = NUM + INT(W(86))
      GO TO 100
  286 IV(87) = NUM + INT(W(87))
      GO TO 100
  287 IV(88) = NUM + INT(W(88))
      GO TO 100
  288 IV(89) = NUM + INT(W(89))
      GO TO 100
  289 IV(90) = NUM + INT(W(90))
      GO TO 100
  290 IV(91) = NUM + INT(W(91))
      GO TO 100
  291 IV(92) = NUM + INT(W(92))
      GO TO 100
  292 IV(93) = NUM + INT(W(93))
      GO TO 100
  293 IV(94) = NUM + INT(W(94))
      GO TO 100
  294 IV(95) = NUM + INT(W(95))
      GO TO 100
  295 IV(96) = NUM + INT(W(96))
      GO TO 100
  296 IV(97) = NUM + INT(W(97))
      GO TO 100
  297 IV(98) = NUM + INT(W(98))
      GO TO 100
  298 IV(99) = NUM + INT(W(99))
      GO TO 100
  299 IV(100) = NUM + INT(W(100))
      GO TO 100
  300 IV(101) = NUM + INT(W(101))
      GO TO 100
  301 IV(102) = NUM + INT(W(102))
      GO TO 100
  302 IV(103) = NUM + INT(W(103))
      GO TO 100
  303 IV(104) = NUM + INT(W(104))
      GO TO 100
  304 IV(105) = NUM + INT(W(105))
      GO TO 100
  305 IV(106) = NUM + INT(W(106))
      GO TO 100
  306 IV(107) = NUM + INT(W(107))
      GO TO 100
  307 IV(108) = NUM + INT(W(108))
      GO TO 100
  308 IV(109) = NUM + INT(W(109))
      GO TO 100
  309 IV(110) = NUM + INT(W(110))
      GO TO 100
  310 IV(111) = NUM + INT(W(111))
      GO TO 100
  311 IV(112) = NUM + INT(W(112))
      GO TO 100
  312 IV(113) = NUM + INT(W(113))
      GO TO 100
  313 IV(114) = NUM + INT(W(114))
      GO TO 100
  314 IV(115) = NUM + INT(W(115))
      GO TO 100
  315 IV(116) = NUM + INT(W(116))
      GO TO 100
  316 IV(117) = NUM + INT(W(117))
      GO TO 100
  317 IV(118) = NUM + INT(W(118))
      GO TO 100
  318 IV(119) = NUM + INT(W(119))
      GO TO 100
  319 IV(120) = NUM + INT(W(120))
      GO TO 100
  320 IV(121) = NUM + INT(W(121))
      GO TO 100
  321 IV(122) = NUM + INT(W(122))
      GO TO 100
  322 IV(123) = NUM + INT(W(123))
      GO TO 100
  323 IV(124) = NUM + INT(W(124))
      GO TO 100
  324 IV(125) = NUM + INT(W(125))
      GO TO 100
  325 IV(126) = NUM + INT(W(126))
      GO TO 100
  326 IV(127) = NUM + INT(W(127))
      GO TO 100
  327 IV(128) = NUM + INT(W(128))
      GO TO 100
  328 IV(129) = NUM + INT(W(129))
      GO TO 100
  329 IV(130) = NUM + INT(W(130))
      GO TO 100
  330 IV(131) = NUM + INT(W(131))
      GO TO 100
  331 IV(132) = NUM + INT(W(132))
      GO TO 100
  332 IV(133) = NUM + INT(W(133))
      GO TO 100
  333 IV(134) = NUM + INT(W(134))
      GO TO 100
  334 IV(135) = NUM + INT(W(135))
      GO TO 100
  335 IV(136) = NUM + INT(W(136))
      GO TO 100
  336 IV(137) = NUM + INT(W(137))
      GO TO 100
  337 IV(138) = NUM + INT(W(138))
      GO TO 100
  338 IV(139) = NUM + INT(W(139))
      GO TO 100
  339 IV(140) = NUM + INT(W(140))
      GO TO 100
  900 RETURN
 1000 FORMAT (A3 / I8)
 1050 FORMAT (' >OTHER ', A4, I4, F7.1)
      END
