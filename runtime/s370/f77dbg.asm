*
* f77dbg -- two routines a program under test can call to put a value
* into the job log, where nothing buffers it and an abend cannot lose
* it: CALL IPRINT(I) and CALL DPRINT(D) write one WTO each, the value
* in hexadecimal.  Standard linkage; registers restored.
*
IPRINT   CSECT
         STM   14,12,12(13)
         BALR  12,0
         USING *,12
         L     2,0(,1)             address of the INTEGER
         L     3,0(,2)
         ST    3,IWORK
         UNPK  IHEX(9),IWORK(5)
         TR    IHEX(8),IHEXTAB
         MVC   IMSG+16(8),IHEX
         LA    1,IMSG
         WTO   MF=(E,(1))
         LM    14,12,12(13)
         SR    15,15
         BR    14
IWORK    DS    F
         DS    X
IHEX     DS    CL9
IHEXTAB  DC    240X'00',C'0123456789ABCDEF'
IMSG     DC    AL2(IMSGE-IMSG),AL2(0),C'FORT370 I = XXXXXXXX'
IMSGE    EQU   *
         LTORG
DPRINT   CSECT
         STM   14,12,12(13)
         BALR  12,0
         USING *,12
         L     2,0(,1)             address of the REAL*8
         MVC   DWORK(8),0(2)
         UNPK  DHEX(9),DWORK(5)
         UNPK  DHEX+8(9),DWORK+4(5)
         TR    DHEX(16),DHEXTAB
         MVC   DMSG+16(16),DHEX
         LA    1,DMSG
         WTO   MF=(E,(1))
         LM    14,12,12(13)
         SR    15,15
         BR    14
DWORK    DS    D
         DS    X
DHEX     DS    CL17
DHEXTAB  DC    240X'00',C'0123456789ABCDEF'
DMSG     DC    AL2(DMSGE-DMSG),AL2(0),C'FORT370 D = XXXXXXXXXXXXXXXX'
DMSGE    EQU   *
         LTORG
