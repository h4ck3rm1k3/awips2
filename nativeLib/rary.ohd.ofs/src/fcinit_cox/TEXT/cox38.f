C MEMBER COX38
C  (from old member FCCOX38)
C
      SUBROUTINE COX38(POLD,COLD,PONEW,CONEW)
C                             LAST UPDATE: 02/08/94.09:15:51 BY $WC20SV
C
C
C#######################################################################
C
C  THIS SUBROUTINE MAINTAINS INTEGRITY BETWEEN THE OLD CARRYOVER
C  ARRAY, COLD, AND THE NEW CARRYOVER ARRAY, CONEW, WHENEVER
C  THE PARAMETER ARRAY FOR OPERATION 38 IS RE-INITIALIZED.  IF THE
C  VARIABLE BASEFLOW OPTION INDICATOR DOES NOT CHANGE, (I.E.,
C  POLD(9)=PONEW(9)), THE CONTENTS OF COLD ARE LOADED DIRECTLY INTO
C  CONEW, AS LONG AS POLD(9).NE.0.  IF THE VARIABLE BASEFLOW OPTION
C  INDICATOR GOES FROM 1 TO 2, OR FROM 2 TO 1, ONLY BASEFLOW IS
C  TRANSFERRED FROM THE COLD TO THE CONEW ARRAY.  FOR ALL OTHER
C  COMBINATIONS, NEITHER BASEFLOW NOR BASEFLOW RECESSION COEFFICIENT
C  IS TRANSFERRED.
C
C#######################################################################
C
C  FOR DEFINITION OF VARIABLES STORED IN THE CO AND PO ARRAYS, SEE
C  THE PIN38 ROUTINE, OR THE USERS MANUAL.
C
C#######################################################################
C
      DIMENSION POLD(1),COLD(1),PONEW(1),CONEW(1),SUBNAM(2)
      COMMON /FDBUG/IODBUG,ITRACE,IDBALL,NDEBUG,IDEBUG(20)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcinit_cox/RCS/cox38.f,v $
     . $',                                                             '
     .$Id: cox38.f,v 1.1 1995/09/17 18:47:23 dws Exp $
     . $' /
C    ===================================================================
C
      DATA SUBNAM/4hCOX3,4h8   /,NOP/38/
C
C  CALL DEBUG CHECK ROUTINE
C
      CALL FPRBUG(SUBNAM,1,NOP,IFDEB)
C
C  EXTRACT NEEDED VARIABLES FROM THE OLD AND NEW PARAMETER ARRAYS
C
      IVERS=POLD(1)
      IVBFO=POLD(9)
      NVBFPO=POLD(10)
      IUSEPO=POLD(11)
      IUSECO=POLD(12)
      IVBFN=PONEW(9)
      NVBFPN=PONEW(10)
      IUSEPN=PONEW(11)
      IUSECN=PONEW(12)
      IF(IFDEB)100,100,4000
C
C  IF IVBFO = IVBFN, LOAD OLD CARRYOVER INTO NEW CARRYOVER ARRAY
C  AND RETURN.  IF IVBFO=IVBFN=0, JUST RETURN.
C
100   IF(IVBFO-IVBFN)200,150,200
150   IF(IVBFO-1)180,170,160
160   CONEW(1)=COLD(1)
      CONEW(2)=COLD(2)
      IF(IFDEB)10000,10000,4160
170   CONEW(1)=COLD(1)
      IF(IFDEB)10000,10000,4170
180   IF(IFDEB)10000,10000,4180
C
C  SINCE IVBFO.NE.IVBFN, CHECK TO SEE WHETHER OR NOT BASEFLOW SHOULD
C  BE TRANSFERRED FROM THE OLD TO THE NEW CARRYOVER ARRAY.
C
200   IF(((IVBFO.EQ.1).AND.(IVBFN.EQ.2)).OR.((IVBFO.EQ.2).AND.
     1  (IVBFN.EQ.1)))GO TO 300
      IF(IFDEB)10000,10000,4180
300   CONEW(1)=COLD(1)
      IF(IFDEB)10000,10000,4170
10000 RETURN
C
C#######################################################################
C
C  DEBUG WRITE STATEMENTS
C
C#######################################################################
C
4000  WRITE(IODBUG,8000)SUBNAM,IVERS
      WRITE(IODBUG,8010)
      WRITE(IODBUG,8020)IVBFO,NVBFPO,IUSEPO,IUSECO
      IF(IVBFO-1)4050,4040,4030
4030  WRITE(IODBUG,8030)
      WRITE(IODBUG,8035)COLD(1),COLD(2)
      GO TO 4060
4040  WRITE(IODBUG,8030)
      WRITE(IODBUG,8045)COLD(1)
      GO TO 4060
4050  WRITE(IODBUG,8050)
4060  WRITE(IODBUG,8060)
      WRITE(IODBUG,8020)IVBFN,NVBFPN,IUSEPN,IUSECN
      GO TO 100
4160  WRITE(IODBUG,8100)
      WRITE(IODBUG,8035)CONEW(1),CONEW(2)
      GO TO 10000
4170  WRITE(IODBUG,8100)
      WRITE(IODBUG,8045)CONEW(1)
      GO TO 10000
4180  WRITE(IODBUG,8180)
      GO TO 10000
C
C#######################################################################
C
C  DEBUG FORMAT STATEMENTS
C
C#######################################################################
C
8000  FORMAT(//5X,'DEBUG OUTPUT FOR SUBROUTINE ',2A4,' VERSION ',I2,//)
8010  FORMAT(/15X,'SELECT PARAMETERS FROM THE POLD ARRAY:')
8020  FORMAT(/20X,'IVBF   = ',I2,/20X,'NVBFP  = ',I2,
     1       /20X,'IUSEP  = ',I2,/20X,'IUSEC  = ',I2)
8030  FORMAT(/15X,'CARRYOVER FROM THE COLD ARRAY:')
8035  FORMAT(/20X,'TBFLOW = ',F9.1,/20X,'BFREC  = ',F5.3)
8045  FORMAT(/20X,'TBFLOW = ',F9.1)
8050  FORMAT(/20X,'** NO CARRYOVER IS STORED IN THE COLD ARRAY **')
8060  FORMAT(/15X,'SELECT PARAMETERS FROM THE PONEW ARRAY:')
8100  FORMAT(/15X,'CARRYOVER STORED IN THE CONEW ARRAY BY THIS ',
     1       'ROUTINE:')
8180  FORMAT(/20X,'** NO CARRYOVER TRANSFER HAS TAKEN PLACE ',
     1       'BETWEEN THE OLD AND NEW CARRYOVER ARRAYS **')
      END