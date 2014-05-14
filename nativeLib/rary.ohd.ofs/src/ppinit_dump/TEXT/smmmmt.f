C MEMBER SMMMMT
C-----------------------------------------------------------------------
C
C                             LAST UPDATE: 03/04/94.13:45:12 BY $WC20SV
C
C @PROCESS LVL(77)
C
C  DESC ROUTINE TO READ AND PRINT PREPROCESSOR PARAMETRIC STATION
C  DESC MAX/MIN TEMPERATURES.
C  DESC PPINIT COMMAND :  @DUMP MMMT
C
      SUBROUTINE SMMMMT (LARRAY,IARRAY,NFLD,ISTAT)
C
      REAL XMMMT/4HMMMT/
      REAL ALL/4HALL /
      INTEGER*2 IARRAY(24,1),IWORK(1)
C
      DIMENSION CHAR(5),CHK(5)
      DIMENSION IBUF(100),VALUES(12),TMPMAX(12),TMPMIN(12)
C
      INCLUDE 'uio'
      INCLUDE 'scommon/sudbgx'
      INCLUDE 'scommon/sworkx'
      INCLUDE 'pppcommon/ppxctl'
      INCLUDE 'pppcommon/ppdtdr'
      INCLUDE 'pppcommon/ppunts'
C
      EQUIVALENCE (IWORK(1),SWORK(1))
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/ppinit_dump/RCS/smmmmt.f,v $
     . $',                                                             '
     .$Id: smmmmt.f,v 1.1 1995/09/17 19:12:50 dws Exp $
     . $' /
C    ===================================================================
C
C
C
      IF (ISTRCE.GT.0) WRITE (IOSDBG,230)
      IF (ISTRCE.GT.0) CALL SULINE (IOSDBG,1)
C
C  SET DEBUG LEVEL
      LDEBUG=ISBUG('DUMP')
C
      ISTAT=0
C
      ISTRT=-1
      LCHAR=5
      LCHK=5
      ILPFND=0
      IRPFND=0
      NUMFLD=0
      NUMERR=0
      NUMPTR=0
      IENDIN=0
C
      WRITE (LP,240)
      CALL SULINE (LP,2)
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK FIELDS FOR TYPE
C
10    CALL UFIELD (NFLD,ISTRT,LENGTH,ITYPE,NREP,INTEGR,REAL,LCHAR,
     *   CHAR,LLPAR,LRPAR,LASK,LATSGN,LAMPS,LEQUAL,IERR)
      IF (LDEBUG.GT.0)
     *  CALL UPRFLD (NFLD,ISTRT,LENGTH,ITYPE,NREP,INTEGR,REAL,LCHAR,
     *   CHAR,LLPAR,LRPAR,LASK,LATSGN,LAMPS,LEQUAL,IERR)
      IF (IERR.NE.1) GO TO 20
         IF (LDEBUG.GT.0) WRITE (IOSDBG,270) NFLD
         IF (LDEBUG.GT.0) CALL SULINE (IOSDBG,1)
         GO TO 10
C
C  CHECK FOR END OF INPUT
20    IF (NFLD.EQ.-1) GO TO 55
C
C  CHECK FOR COMMAND
      IF (LATSGN.EQ.1) GO TO 55
C
C  CHECK FOR PAIRED PARENTHESIS
      IF (ILPFND.GT.0.AND.IRPFND.EQ.0) GO TO 30
         GO TO 40
30    IF (NFLD.EQ.1) CALL SUPCRD
      WRITE (LP,280) NFLD
      CALL SULINE (LP,2)
      ILPFND=0
      IRPFND=0
40    IF (LLPAR.GT.0) ILPFND=1
      IF (LRPAR.GT.0) IRPFND=1
C
C  CHECK FOR PARENTHESIS IN FIELD
      IF (LLPAR.GT.0) CALL UFPACK (LCHK,CHK,ISTRT,1,LLPAR-1,IERR)
      IF (LLPAR.EQ.0) CALL UFPACK (LCHK,CHK,ISTRT,1,LENGTH,IERR)
C
      IF (NFLD.EQ.1) CALL SUPCRD
      NUMFLD=NUMFLD+1
      IF (NUMFLD.GT.1) GO TO 50
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK OPTION
      IF (CHK(1).EQ.XMMMT) GO TO 10
         WRITE (LP,250) CHK(1)
         CALL SUERRS (LP,2,NUMERR)
         GO TO 10
C
C  CHECK FOR KEYWORD
50    CALL SUIDCK ('DMPG',CHK,NFLD,0,IKEYWD,IERR)
      IF (IERR.EQ.2) GO TO 55
C
      IF (LDEBUG.GT.0) WRITE (IOSDBG,260) CHK
      IF (LDEBUG.GT.0) CALL SULINE (IOSDBG,1)
C
C  CHECK FOR ALL OPTION
      IALL=0
      IF (CHK(1).EQ.ALL) IALL=1
C
C  SET POINTER VALUES
      IPMMMT=INTEGR
C
      IF (NFLD.EQ.1) CALL SUPCRD
      GO TO 60
C
C  CHECK IF ANY POINTERS VALUES PROCESSED
55    IF (NUMPTR.GT.0) GO TO 220
      IALL=1
      IENDIN=1
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
60    IF (NUMPTR.GT.0) GO TO 110
      NUMPTR=NUMPTR+1
C
C  OPEN DATA BASE
      CALL SUDOPN (1,'PPP ',IERR)
      IF (IERR.GT.0) GO TO 220
C
C  FIND CONTROL INFORMATION FOR MMMT RECORD
      CALL SUBSTR (XMMMT,1,4,IPTYPE,1)
      DO 70 I=1,NMPTYP
         IF (IPDTDR(1,I).EQ.IPTYPE) GO TO 80
70       CONTINUE
         WRITE (LP,300) XMMMT
         CALL SUWRNS (LP,2,NUMERR)
         GO TO 215
C
C  READ MMMT CONTROL RECORD
80    IREC=IPDTDR(3,I)
      IF (IREC.GT.0) GO TO 90
         WRITE (LP,310) XMMMT
         CALL SUWRNS (LP,2,NUMWRN)
         GO TO 215
90    IUNIT=KPPRMU(IPDTDR(2,I))
      CALL UREADT (IUNIT,IREC,IBUF,IERR)
      IF (IERR.EQ.0) GO TO 100
         WRITE (LP,290) IREC,IUNIT
         CALL SUERRS (LP,2,NUMERR)
         GO TO 215
100   NWORDS=IBUF(1)
      NREC1=IBUF(2)
      NRCENT=IBUF(3)
      NVLENT=IBUF(4)
      IPTYPE=IBUF(5)
      NUMENT=IBUF(6)
      NSTAS=IBUF(7)
      MAXSTA=IBUF(8)
      NXTSTA=IBUF(9)
      WRITE (LP,320) IPTYPE,MAXSTA,NSTAS
      CALL SULINE (LP,2)
      WRITE (LP,330) NWORDS
      CALL SULINE (LP,2)
      WRITE (LP,340) NREC1,NXTSTA
      CALL SULINE (LP,2)
      WRITE (LP,350) NRCENT,NUMENT,NVLENT
      CALL SULINE (LP,2)
C
C  CHECK IF ANY ENTRIES DEFINED
110   IF (NSTAS.GT.0) GO TO 120
         WRITE (LP,360)
         CALL SUWRNS (LP,2,NUMWRN)
         GO TO 215
C
C  CHECK IF ALL ENTRIES TO BE PROCESSED
120   IF (IALL.EQ.0) GO TO 200
C
C  PROCESS ALL VALUES
      MAXVAL=LARRAY/12
      DO 160 I=1,12
         CALL RPPMT (I,LSWORK,IWORK(1),IWORK(LSWORK+1),NFILL,IERR)
         IF (IERR.EQ.0) GO TO 130
            WRITE (LP,370) IERR
            CALL SULINE (LP,1)
            GO TO 110
130      IF (MAXVAL.GT.NFILL) GO TO 140
            WRITE (LP,380) NFILL,MAXVAL
            CALL SUERRS (LP,2,NUMERR)
            GO TO 215
140      DO 150 N=1,NFILL
            IARRAY(I,N)=IWORK(N)
            IARRAY(I+12,N)=IWORK(LSWORK+N)
150         CONTINUE
160      CONTINUE
      WRITE (LP,390)
      CALL SULINE (LP,2)
      WRITE (LP,400)
      CALL SULINE (LP,1)
      DO 190 I=1,NFILL
         DO 170 N=1,12
            VALUES(N)=IARRAY(N,I)/10.
170         CONTINUE
         WRITE (LP,410) I,VALUES
         DO 180 N=1,12
            VALUES(N)=IARRAY(12+N,I)/10.
180         CONTINUE
         WRITE (LP,420) I,VALUES
190      CONTINUE
      GO TO 215
C
C  PRINT VALUES FOR SPECIFIED POINTER
200   CALL RPP1MT (IPMMMT,TMPMAX,TMPMIN,IERR)
      IF (IERR.EQ.0) GO TO 210
         IF (IERR.EQ.1) WRITE (LP,430)
         IF (IERR.EQ.2) WRITE (LP,431)
         IF (IERR.EQ.3) WRITE (LP,432) IPMMMT
         IF (IERR.GT.3) WRITE (LP,433) IERR
         GO TO 215
210   WRITE (LP,440) IPMMMT,TMPMAX,TMPMIN
      CALL SULINE (LP,2)
C
C  CHECK FOR END OF INPUT
215   IF (IENDIN.EQ.0) GO TO 10
C
220   IF (ISTRCE.GT.0) WRITE (IOSDBG,450)
      IF (ISTRCE.GT.0) CALL SULINE (IOSDBG,1)
C
      RETURN
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
230   FORMAT (' *** ENTER SMMMMT')
240   FORMAT ('0*--> DUMP STATION MAX/MIN TEMPERATURES')
250   FORMAT ('0*** ERROR - IN SMMMMT - ',A4,' IS AN INVALID OPTION.')
260   FORMAT (' INPUT FIELD = ',5A4)
270   FORMAT (' NULL FIELD FOUND IN FIELD ',I2)
280   FORMAT ('0*** NOTE - RIGHT PARENTHESES ASSUMED IN FIELD ',
     *   I2,'.')
290   FORMAT ('0*** ERROR - IN SMMMMT - DAIO ERROR AT RECORD ',I5,
     *    ' OF UNIT ',I2,'.')
300   FORMAT ('0*** WARNING - PARAMETER TYPE ',A4,' NOT DEFINED ',
     *   'IN PARAMETRIC DATA BASE.')
310   FORMAT ('0*** WARNING - PARAMETER TYPE ',A4,' DEFINED ',
     *   'IN PARAMETRIC DATA BASE BUT CANNOT BE SPECIFIED FOR ',
     *   'STATIONS.')
320   FORMAT ('0TYPE = ',A4,5X,'MAXIMUM STATIONS = ',I4,5X,
     *   'STATIONS DEFINED = ',I4)
330   FORMAT ('0NUMBER OF WORDS IN CONTROL RECORD = ',I2)
340   FORMAT ('0FIRST RECORD = ',I4,5X,'LAST SLOT USED = ',I4)
350   FORMAT ('0NUMBER OF RECORDS PER ENTRY = ',I2,5X,
     *   'NUMBER OF ENTRIES PER STATION = ',I2,5X,
     *   'NUMBER OF VALUES PER ENTRY = ',I2)
360   FORMAT ('0*** WARNING - NO STATION MAX/MIN TEMPS ARE DEFINED.')
370   FORMAT (' RPPMT CALLED - STATUS CODE=',I2)
380   FORMAT ('0*** ERROR - IN SMMMMT - NUMBER OF STATIONS ',
     *   'DEFINED (',I4,') EXCEEDS MAXIMUM ALLOWED (',I5,').')
390   FORMAT ('0MAX/MIN TEMPS  :  JAN',4X,'FEB',4X,'MAR',4X,'APR',4X,
     *   'MAY',4X,'JUN',4X,'JUL',4X,'AUG',4X,'SEP',4X,'OCT',4X,'NOV',4X,
     *   'DEC')
400   FORMAT (1H )
410   FORMAT (2X,'SLOT ',I4,2X,'MAX',2X,12(F5.1,2X))
420   FORMAT (2X,'SLOT ',I4,2X,'MIN',2X,12(F5.1,2X))
430   FORMAT ('0*** ERROR - DAIO READ ERROR ENCOUNTERED IN ROUTINE ',
     *   'RPP1MT.')
431   FORMAT ('0*** ERROR - MAX/MIN TEMPS ARE NOT DEFINED IN THE ',
     *   'PREPROCESSOR PARAMETRIC DATA BASE.')
432   FORMAT ('0*** ERROR - INVALID VALUE POINTER TO MAX/MIN TEMPS ',
     *   ': ',I5)
433   FORMAT ('0*** ERROR - STATUS CODE ',I2,' FROM ROUTINE RPP1MT ',
     *   'NOT RECOGNIZED.')
440   FORMAT (' IPMMMT=',I4,3X,'TMPMAX=',12(F5.1,2X) /
     *   15X,'TMPMIN=',12(F5.1,2X))
450   FORMAT (' *** EXIT SMMMMT')
C
      END