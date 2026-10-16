//*  F77CLG -- compile, assemble, link and go, all on MVS 3.8j.
//*
//*  FORT370 compiles FORTRAN 77 to S/370 assembler; IFOX00 and IEWL
//*  are the system's own.  IEWL takes what the program calls from
//*  F77RT, the fort370 runtime as a library (docs/INSTALL-MVS.txt),
//*  by automatic call: the program's object names the startup and
//*  its entry point, and only the runtime it uses is linked.
//*  Adjust the three data set names to where FORT370, F77RT and the
//*  source live.
//*
//*  SYSIN may be a PDS member or DD * (the compiler reads it as its
//*  standard input); SYSUT1 is the work data set the compiler copies
//*  it to, so that it holds one program unit at a time, not the file.
//*  REGION=8192K for the compiler is the recommendation; the largest
//*  units tested need 7168K.  IFOX00 needs PARM='OBJ,NODECK' or
//*  it assembles cleanly and produces nothing.  A program's arrays
//*  are static storage in its module; raise GO's REGION for large
//*  ones.  Units are the DD names FTnnF001: unit 6 is FT06F001 (or
//*  SYSPRINT), unit 5 FT05F001 (or SYSIN), and any other unit the
//*  program uses needs its DD.
//*
//*  The assembly's listing is DUMMY: IFOX00 checks what FORT370
//*  wrote, and a clean compile assembles cleanly.  If ASM ends with
//*  RC 8 anyway, which is a compiler bug worth reporting, add
//*  //ASM.SYSPRINT DD SYSOUT=* after the EXEC to see IFOX00's
//*  messages; NOLIST would hide them with the listing.
//*
//F77CLG   PROC MEM=
//FORT     EXEC PGM=FORT370,REGION=8192K
//STEPLIB  DD DSN=HERC01.FORT370.LOAD,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSTERM  DD SYSOUT=*
//SYSIN    DD DSN=HERC01.FORT370.SRC(&MEM),DISP=SHR
//SYSPUNCH DD DSN=&&ASM,DISP=(NEW,PASS),UNIT=SYSDA,
//            SPACE=(CYL,(2,2)),
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=3120)
//SYSUT1   DD UNIT=SYSDA,SPACE=(CYL,(5,5))
//ASM      EXEC PGM=IFOX00,PARM='OBJ,NODECK',REGION=2048K,
//            COND=(0,NE)
//SYSLIB   DD DSN=SYS1.MACLIB,DISP=SHR
//SYSGO    DD DSN=&&OBJ,DISP=(NEW,PASS),UNIT=SYSDA,
//            SPACE=(CYL,(1,1)),
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=3120)
//SYSUT1   DD UNIT=SYSDA,SPACE=(CYL,(5,5))
//SYSUT2   DD UNIT=SYSDA,SPACE=(CYL,(5,5))
//SYSUT3   DD UNIT=SYSDA,SPACE=(CYL,(5,5))
//SYSPRINT DD DUMMY
//SYSIN    DD DSN=&&ASM,DISP=(OLD,DELETE)
//LKED     EXEC PGM=IEWL,PARM='MAP,LET,LIST',REGION=2048K,
//            COND=((0,NE,FORT),(8,LE,ASM))
//SYSLIN   DD DSN=&&OBJ,DISP=(OLD,DELETE)
//SYSLIB   DD DSN=HERC01.FORT370.F77RT,DISP=SHR
//SYSLMOD  DD DSN=&&LOAD(GO),DISP=(NEW,PASS),UNIT=SYSDA,
//            SPACE=(TRK,(30,10,5))
//SYSUT1   DD UNIT=SYSDA,SPACE=(CYL,(5,5))
//SYSPRINT DD SYSOUT=*
//GO       EXEC PGM=*.LKED.SYSLMOD,REGION=4096K,
//            COND=((0,NE,FORT),(8,LE,ASM),(4,LT,LKED))
//SYSPRINT DD SYSOUT=*
//SYSTERM  DD SYSOUT=*
//FT06F001 DD SYSOUT=*,DCB=(RECFM=FBA,LRECL=133,BLKSIZE=133)
//FT05F001 DD DUMMY
//SYSUDUMP DD SYSOUT=*
//         PEND
//*
//*  A run: //RUN EXEC F77CLG,MEM=HELLO
