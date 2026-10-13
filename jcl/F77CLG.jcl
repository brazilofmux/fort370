//*  F77CLG -- compile, assemble, link and go, all on MVS 3.8j.
//*
//*  FORT370 compiles FORTRAN 77 to S/370 assembler; IFOX00 and IEWL
//*  are the system's own.  The program is linked with F77RT, the
//*  fort370 runtime as object decks (docs/INSTALL-MVS.txt), which ends
//*  in the control statement ENTRY @@CRT0: libc370's entry, which calls
//*  the Fortran main program.
//*  Adjust the three data set names to where FORT370, F77RT and the
//*  source live.
//*
//*  SYSIN may be a PDS member or DD * (the compiler reads it as its
//*  standard input); SYSUT1 is the work data set the compiler copies it
//*  to, so that it holds one program unit at a time, not the file.
//*  REGION=8192K for the compiler is the recommendation; the largest
//*  units tested compile in 6656K.  IFOX00 needs PARM='OBJ,NODECK' or it
//*  assembles cleanly and produces nothing.  Units are the DD names
//*  FTnnF001: unit 6 is FT06F001 (or SYSPRINT), unit 5 FT05F001 (or
//*  SYSIN), and any other unit the program uses needs its DD.
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
//LKED     EXEC PGM=IEWL,PARM='MAP,LET,LIST,NCAL',REGION=2048K,
//            COND=((0,NE,FORT),(8,LE,ASM))
//SYSLIN   DD DSN=&&OBJ,DISP=(OLD,DELETE)
//         DD DSN=HERC01.FORT370.F77RT,DISP=SHR
//SYSLMOD  DD DSN=&&LOAD(GO),DISP=(NEW,PASS),UNIT=SYSDA,
//            SPACE=(TRK,(30,10,5))
//SYSUT1   DD UNIT=SYSDA,SPACE=(CYL,(5,5))
//SYSPRINT DD SYSOUT=*
//GO       EXEC PGM=*.LKED.SYSLMOD,
//            COND=((0,NE,FORT),(8,LE,ASM),(4,LT,LKED))
//SYSPRINT DD SYSOUT=*
//SYSTERM  DD SYSOUT=*
//FT06F001 DD SYSOUT=*,DCB=(RECFM=FBA,LRECL=133,BLKSIZE=133)
//FT05F001 DD DUMMY
//SYSUDUMP DD SYSOUT=*
//         PEND
//*
//*  A run: //RUN EXEC F77CLG,MEM=HELLO
