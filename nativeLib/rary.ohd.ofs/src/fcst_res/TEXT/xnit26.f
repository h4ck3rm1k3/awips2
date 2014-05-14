C MODULE XNIT26
C
C DESC INITIALIZE VARIABLES FOR EXECUTION OF 'RES-SNGL'
C-----------------------------------------------------------------
      SUBROUTINE XNIT26(PO)
C----------------------------------------------------------------
C  SUBROUTINE TO SET VALUES FOR GENERAL PURPOSE VARIABLES FOR THE
C  EXECUTION ROUTINE FOR THE RESERVOIR OPERATION.
C----------------------------------------------------------------
C  WRITTEN BY JOE OSTROWSKI - HRL - JULY 1983
C-----------------------------------------------------------------
C
      INCLUDE 'common/fctime'
      INCLUDE 'common/exg26'
      INCLUDE 'common/resv26'
      INCLUDE 'common/rulc26'
      INCLUDE 'common/genq26'
      INCLUDE 'common/flas26'
      INCLUDE 'common/srcg26'
      INCLUDE 'common/dste26'
      INCLUDE 'common/fdbug'
      INCLUDE 'common/fprog'
      INCLUDE 'common/xco26'
      INCLUDE 'common/fcary'
C
      DIMENSION PO(*),RESNAM(2)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcst_res/RCS/xnit26.f,v $
     . $',                                                             '
     .$Id: xnit26.f,v 1.7 2006/10/16 12:42:45 hsu Exp $
     . $' /
C    ===================================================================
C
C  THE FOLLOWING LINE DELETED ON 8/89
C      DATA NUMOP/26/,RESNAM/4HRES-,4HSNGL/
C  END OF CHANGE OF 8/89
C
C  DEBUG OUTPUT IF REQUESTED
C
      IF (IBUG.GE.1) WRITE(IODBUG,1600)
 1600 FORMAT('   *** ENTER XNIT26 ***')
C
C  INITIALIZE LOCATIONS OF MULTIPLE REFERENCE PARMS TO UNDEFINED (0).
C
      DO 5 I=1,10
      MRLOC(I) = 0
    5 CONTINUE
C
C  SET LOCATION FOR S/U POINTER INFO START & THE NUMBER OF DEFINED S/U'S
C
      LOCPTR = PO(9)
      NSUDEF = PO(LOCPTR)
C
C  SET OFFSETS IN PO ARRAY FOR RCL, IF GROUPS, COMPARISON VARIABLES,
C  AND PARAMETERS
C
      IOFRCL = PO(12) - 1
      IFOFF  = PO(14) - 1
      IOFCMP = PO(13) - 1
      IOFPRM = PO(10) - 1
C
C  SET NO. OF TIME PERIODS WITHIN THE DAY
C
      MINODT = PO(7)
      NTIM24 = 24/MINODT
C
C  SET PERIOD COUNTER TO FIRST PERIOD FOR ANY PRE-LOOP COMP. TASKS
C
      NS2 = 1
C
C  COMPUTE NO. OF DAYS DATA IS OFFSET FROM START OF D ARRAY POSTIONS
C  HOLDING DATA FOR TIME-SERIES. (NO. OF POSITIONS IS DEPENDENT ON
C  INTERVAL OF TIME-SERIES AND WILL BE COMPUTED WHEN TS IS USED.)
C
      IDOFST = IDA - IDADAT
C
C  SET TIME OF END OF FIRST PERIOD IN RUN.
C
C
C  SET TIMING INFORMATION (NO. OF PERIODS IN RUN, NO. OF PERIODS IN
C  OBSERVED PERIOD, AND THE CURRENT PERIOD {INITIALLY 1})
C
      NUM  = (LDA - IDA)*NTIM24 + LHR/MINODT
      NRUN = (LDACPD - IDA)*NTIM24 + LHRCPD/MINODT
      IF (NRUN.LT.0) NRUN = 0
      IF (NRUN.GT.NUM) NRUN = NUM
C
      IF (IBUG.GE.2) WRITE(IODBUG,1605) MINODT,NTIM24,NUM,NRUN,IDOFST
 1605 FORMAT('   *** OPERATION DELTA-T =',I5/'    *** NO. OF PERIODS',
     .' PER DAY = ',I5/'     *** NO. OF PERIODS IN RUN = ',I5/
     .'      *** NO. OF PERIODS IN OBSERVED PART OF RUN = ',I5/
     .'       *** NO. OF DAYS OF DATA OFFSET = ',I5)
C
C  SET THE NO. OF PAIRS OF VALUES AND THE INTERPOLATION TYPE FOR THE
C  ELEVATION VS. STORAGE CURVE . ALSO, SET THE LOCATION IN PO ARRAY OF
C  THE ELEVATIONS AND THE STORAGES.
C
      LOCGP = PO(10)
      NSE = PO(LOCGP)
      LESELV = LOCGP + 1
      LESSTO = LESELV + NSE
      LOCTRP = LOCGP + 2*NSE + 1
      NTERP = PO(LOCTRP)
C
C  SET THE SIZE OF THE WORK SPACE HOLDING THE MODIFIED PULS CURVES.
C   (ONLY NEEDED IF MOD. PULS ROUTING IS USED FOR 'FILLSPILL',
C    'SPILLWAY', AND OTHER SCHEMES USING ROUTING.)
C
      NOSOH = NSE + 5
C
C  SET NO. OF PAIRS IN TOTAL Q VS MAX GEN Q CURVE TO ZERO
C
      NQGEN = 0
C
C  SET METRIC COEFFICIENT FOR SHARP CRESTED WEIR EQUATION. USED WITH
C  FLASHBOARDS FOR COMPUTING FLOW FOR OVERTOPPING UPRIGHT BOARDS.
C
      COEF = 1.80426
C
C  ***** FOR STAND ALONE TEST COEF = 3.300
C
C     COEF = 3.300
C
C  SET RELATIVE JULIAN DATE, THE DAY OF THE WEEK, THE NUMBER OF DAYS
C  IN THE YEAR, AND THE HOUR OF MIDNIGHT IN THE HYDROLOGIC DAY.
C
      CALL MDYH1(IDA,IHR,IMON,IDAY,IYEAR,IHRM,NLSTZ,NOUTDS,TZCS)
      CALL FCTZC(NLSTZ,NOUTDS,TZCS)
      CALL JULDA(IDABGN,IHRB,1,1,IYEAR,IHRM,NLSTZ,NOUTDS,TZCS)
      KHRBGN = IHRM-MINODT
      KHRPRD = IHR+MINODT
      DO 90 I=1,NTIM24
      KHR=KHRBGN+I*MINODT
      IF(KHR.LT.24) GO TO 90
      KHR=MOD(KHR,24)
      GO TO 95
 90   CONTINUE
 95   MIDNIT=KHR
      MID1=MINODT-KHR
      IF(MID1.LT.MIDNIT) MIDNIT=KHR+24-MINODT
      JULDAT = IDA - IDABGN + 1
C
      JDAWEK = MTWT26(IDA,IHR)
C
      NODAYR = 365 + LEAP26(IDA,IHR)
      IF (IBUG.LT.2) GO TO 110
      WRITE(IODBUG,1609) IDA,IHR,LDA,LHR,LDACPD,LHRCPD,MIDNIT,
     & IMON,IDAY,IYEAR,IHRM,NLSTZ,NOUTDS,TZCS
 1609 FORMAT(1X,'IDA,IHR,LDA,LHR,LDACPD,LHRCPD,MIDNIT,',
     & 'IMON,IDAY,IYEAR,IHRM,NLSTZ,NOUTDS,TZCS',
     & /1X,I7,I3,I7,I3,I7,I3,7I6,1X,A4)
      WRITE(IODBUG,1610) JULDAT,JDAWEK,NODAYR,IDA,IDABGN
 1610 FORMAT('   REL. JUL. DATE (JULDAT) = ',I5,
     & /'   DAY OF WEEK (JDAWEK) = ',I3,
     ./'   NO. OF DAYS IN YEAR (NODAYR) = ',I4,
     & /'   JULIAN DATE 1ST DAY OF RUN (IDA) = ',I6,
     & /'   JULIAN DATE 1ST DAY OF YR (IDABGN) = ',I6)
 110  CONTINUE
C
C  SET SOME RULE CURVE ADJUSTMENT VALUES
C
      AVGDEV = 0.0
      AGBDEV = 0.0
      ADJRUL = 0.0
C
C  SET INDICATOR FOR FIRST ENTRY INTO POWER GENERATION SCHEME
C
      DO I=1,9
         IENTER(I) = -999
      ENDDO
C
C  SET SOME 'FIRST ENTRY' FLAGS FOR FLASHBOARDS
C
      GOFLSH = .FALSE.
      NLGSOH = -999
      NSMSOH = -999
      NGASOH = -999
      NPOSOH = -999
C
C  SET FLAG FOR 'SURCHARGE' TO 'NOT TO ENTER'. WILL BE RESET IN
C  SURCHARGE ROUTINES FOR FIRST PERIOD.
C
      SURCHG = .FALSE.
C
C  NOW SET POSITIONS WITHIN RUN FOR SAVING CARRYOVER (IF CARRYOVER IS
C   REQUESTED {I.E. - BOTH IFILLC AND NCSTOR ARE > 0})
C
      ISAVCO = IFILLC*NCSTOR
      NUMCOV = PO(15)
      LASTCO = 0
C
      DO 500 I=1,20
      ICOPOS(I) = 0
  500 CONTINUE
C
C  INITIALIZE CARRYOVER FOR 'ADJUST' UTILITY TO ZERO
C
      DO 520 I=1,10
      ADJCO(1,I) = 0.0
      ADJCO(2,I) = 0.0
  520 CONTINUE
C
C  IF WE NEED TO SAVE CARRYOVER, SET POSITIONS HERE
C
      IF (ISAVCO.LE.0) GO TO 9999
C
C  COMPUTE POSITIONS BY CONVERTING CARRY DATES TO JULIAN HOURS,
C  SUBTRACTING THE INITIAL RUN DATE (IN JULIAN HOURS) AND DIVIDING BY
C  THE OPERATION TIME INTERVAL.
C
      JULBGN = IDA*24
      IF (IBUG.GE.2) WRITE(IODBUG,1650)
 1650 FORMAT('  CARRYOVER TO BE SAVED. TIME PERIODS ARE :')
C
      DO 550 I=1,NCSTOR
      JULHR = ICDAY(I)*24 + ICHOUR(I)
      ICOPOS(I) = (JULHR-JULBGN)/MINODT
      IF (IBUG.GE.2) WRITE(IODBUG,1660) ICOPOS(I)
 1660 FORMAT(I5)
  550 CONTINUE
C
C  THAT'S IT!!!
C
 9999 CONTINUE
C
C  TRACE MESSAGE IF REQUESTED
C
      IF (IBUG.GE.1) WRITE(IODBUG,1699)
 1699 FORMAT('    *** EXIT XNIT26 ***')
      RETURN
      END