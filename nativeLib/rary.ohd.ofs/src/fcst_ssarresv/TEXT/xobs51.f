C MEMBER XOBS51
C DESC GENERATES TIME SERIES FROM OBSERVED TIME SERIES
C
C@PROCESS LVL(77)
C
      SUBROUTINE XOBS51(PO,CO,WK,D,LOCWS,IDPT,LOBS)
C---------------------------------------------------------------------
C  ROUTINE TO GENERATE POOL ELEVATIONS (AND STORAGES) AND
C  DISCHARGES. INPUT FOR THE PROCEDURE CAN BE EITHER AN OBSERVED
C  ELEVATION TS OR OBSERVED DISCHARGE TS OR BOTH. DIFFERENT STRATEGIES
C  ARE USED FOR THE DIFFERENT COMBINATIONS OF TIME SERIES AND THEIR
C  TIME INTERVALS.
C---------------------------------------------------------------------
C  WRITTEN BY KUANG HSU - HRL - OCTOBER 1994
C---------------------------------------------------------------------
C
C  NRUN -- NO. OF PERIODS WITH OBSERVED DATA
C  LAOBS -- LAST PERIOD WITH NON-MISSING OBSERVED DATA
C  TIME SERIES SEQUENCE STORED IN PO ARRAY --
C     (QI1),QI2,QO1,QO2,(QOM),(POOL),(STORAGE),(OBSQO),(OBSQOM),(OBSH),
C              (QO1,QO2,(QOM),(POOL),(STORAGE),(OBSQO),(OBSQOM),(OBSH))
C
      INCLUDE 'common/fdbug'
      INCLUDE 'common/fctime'
      INCLUDE 'common/ionum'
      INCLUDE 'common/sarr51'
      INCLUDE 'common/lts51'
      INCLUDE 'common/unit51'
C
      DIMENSION PO(*),CO(*),D(*),WK(*),LOCWS(*),IDPT(*),
     &          LOBS(*),QDUM(750),LAOBX(2)
      REAL*8 RESTYP(4)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcst_ssarresv/RCS/xobs51.f,v $
     . $',                                                             '
     .$Id: xobs51.f,v 1.4 2000/07/24 19:52:51 page Exp $
     . $' /
C    ===================================================================
C
C
      DATA RESTYP/8H'NOT A' ,8H'UPPER' ,8H'LOWER' ,8H'3-VAR' /
      DATA BLANK/4H    /
C
      IF (IBUG.GE.1) WRITE(IODBUG,9600)
 9600 FORMAT('   *** ENTER XOBS51 ***')
C
C  SET VALUES FOR IGNORETS MOD USE CHECK
C
      CQHST = 3600./43560.
      IF(METSAR.EQ.1) CQHST=3.6
      CQSTX = MINODT*CQHST
      IQOTYP = 1
      IQMTYP = 2
      IELTYP = 4
      NRES=PO(9)
C
      IF (NRES.LE.1) GO TO 100
      DO 90 II=1,NRES
      IRES = II
      LPO12 = PO(12)
      NTTS = PO(LPO12)
      NTS = (NTTS-2)/NRES
C
      IPTX = NRES-IRES+10
      LPP = PO(IPTX)
      ISTYP = PO(LPP)
      IRTYP = ISTYP+1
C
C  SET UP POINTER FOR PO, IDPT, D, WK ARRAY
C
      LWQO1X = LWQO1
      LWQO2X = LWQO2
      CALL TSPT51(PO,CO,D,LOCWS,IDPT)
C
      LDQL1X = 0
      LDQL2X = 0
      IF(IRES.EQ.NRES) GO TO  45
      IF(LDQL1.GT.0) LDQL1X=LDQL1
      IF(LDQL2.GT.0) LDQL2X=LDQL2
  45  CONTINUE
C
C  BACKWATER RESERVOIR START AT POSITION 10 IN PO ARRAY
C  NON-BACKWATER RESERVOIR START AT POSITION 11 IN PO ARRAY
C
      IPTX = NRES-IRES+10
      LPNSE = PO(IPTX)+1
      NSE = PO(LPNSE)
      LESELV = LPNSE+1
      LESSTO = LESELV+NSE
C
      LAQO = 0
      LAQM = 0
      LAEL = 0
      IF(LDOQO.EQ.0) GO TO 60
      DO 59 I=1,NUM
      IR = NUM-I+1
      LD = LDOQO+IR-1
      IF(IFMSNG(D(LD)).EQ.1) GO TO 59
      LAQO = IR
      GO TO 60
  59  CONTINUE
C
  60  IF(LDOQM.EQ.0) GO TO 70
      DO 69 I=1,NUM
      IR = NUM-I+1
      LD = LDOQM+IR-1
      IF(IFMSNG(D(LD)).EQ.1) GO TO 69
      LAQM = IR
      GO TO 70
  69  CONTINUE
C
  70  IF(LDOEL.EQ.0) GO TO 80
      DO 79 I=1,NUM
      IR = NUM-I+1
      LD = LDOEL+IR-1
      IF(IFMSNG(D(LD)).EQ.1) GO TO 79
      LAEL = IR
      GO TO 80
  79  CONTINUE
C
  80  LAOBX(II) = MAX0(LAQO,LAQM,LAEL)
  90  CONTINUE
      LAOBS = MIN0(LAOBX(1),LAOBX(2))
  100 CONTINUE
C
      DO 9000 II=1,NRES
      IRES = II
      LPO12 = PO(12)
      NTTS = PO(LPO12)
      NTS = (NTTS-2)/NRES
C
      IPTX = NRES-IRES+10
      LPP = PO(IPTX)
      ISTYP = PO(LPP)
      IRTYP = ISTYP+1
C
C  SET UP POINTER FOR PO, IDPT, D, WK ARRAY
C
      LWQO1X = LWQO1
      LWQO2X = LWQO2
      CALL TSPT51(PO,CO,D,LOCWS,IDPT)
C
      LDQL1X = 0
      LDQL2X = 0
      IF(IRES.EQ.NRES) GO TO 950
      IF(LDQL1.GT.0) LDQL1X=LDQL1
      IF(LDQL2.GT.0) LDQL2X=LDQL2
 950  CONTINUE
C
C  BACKWATER RESERVOIR START AT POSITION 10 IN PO ARRAY
C  NON-BACKWATER RESERVOIR START AT POSITION 11 IN PO ARRAY
C
      IPTX = NRES-IRES+10
      LPNSE = PO(IPTX)+1
      NSE = PO(LPNSE)
      LESELV = LPNSE+1
      LESSTO = LESELV+NSE
C
      LAQO = 0
      LAQM = 0
      LAEL = 0
      IF(LDOQO.EQ.0) GO TO 600
      DO 590 I=1,NUM
      IR = NUM-I+1
      LD = LDOQO+IR-1
      IF(IFMSNG(D(LD)).EQ.1) GO TO 590
      LAQO = IR
      GO TO 595
 590  CONTINUE
C
C  WRITE INSTANTANEOUS OBSERVED DISCHARGES
C
 595  IF(IBUG.LT.2 .OR. LAQO.LE.0) GO TO 600
      WRITE(IODBUG,1671) RESTYP(IRTYP)
 1671 FORMAT(/10X,'** INST. OBS. DISCHARGES ** FOR ',A8,
     & 'BACKWATER RESERVOIR')
      WRITE(IODBUG,1651) (D(LDOQO+I-1),I=1,LAQO)
C
 600  IF(LDOQM.EQ.0) GO TO 700
      DO 690 I=1,NUM
      IR = NUM-I+1
      LD = LDOQM+IR-1
      IF(IFMSNG(D(LD)).EQ.1) GO TO 690
      LAQM = IR
      GO TO 695
 690  CONTINUE
C
C  WRITE MEAN OBSERVED DISCHARGES
C
 695  IF(IBUG.LT.2 .OR. LAQM.LE.0) GO TO 700
      WRITE(IODBUG,1672) RESTYP(IRTYP)
 1672 FORMAT(/10X,'** MEAN OBS. DISCHARGES ** FOR ',A8,
     & 'BACKWATER RESERVOIR')
      WRITE(IODBUG,1651) (D(LDOQM+I-1),I=1,LAQM)
C
 700  IF(LDOEL.EQ.0) GO TO 800
      DO 790 I=1,NUM
      IR = NUM-I+1
      LD = LDOEL+IR-1
      IF(IFMSNG(D(LD)).EQ.1) GO TO 790
      LAEL = IR
      GO TO 795
 790  CONTINUE
C
C  WRITE OBSERVED POOL ELEVATIONS
C
 795  IF(IBUG.LT.2 .OR. LAEL.LE.0) GO TO 800
      WRITE(IODBUG,1674) RESTYP(IRTYP)
 1674 FORMAT(/10X,'** OBS. POOL ELEVATIONS ** FOR ',A8,
     & 'BACKWATER RESERVOIR')
      WRITE(IODBUG,1652) (D(LDOEL+I-1),I=1,LAEL)
 800  IF(NRES.LE.1) LAOBS = MAX0(LAQO,LAQM,LAEL)
C
C  NOTHING NEEDS TO BE DONE IF WE HAVE NO OBSERVED PERIODS TO PICK DATA
C  FROM.
C
      IF (LAOBS .EQ. 0) GO TO 9000
      IST = 1
      IEND = LAOBS
      LCO = (NRES-IRES)*4+2
      QO1 = CO(LCO)
      EL1 = CO(LCO+1)
      S1  = CO(LCO+2)
      QL1  = CO(LCO+3)
      LQDUM = 1
      DO 850 I=1,LAOBS
 850  QDUM(LQDUM+I-1) = -999.0
C
C  FIRST THING IS TO DETERMINE THE COMBINATION OF OBSERVED TIME-SERIES
C  THAT WE HAVE. THE POSSIBILITIES ARE:
C
C     1) OBSERVED INSTANTANEOUS DISCHARGES ONLY
C     2) OBSERVED MEAN DISCHARGES ONLY
C     3) BOTH OBSERVED INSTANTANEOUS DISCHARGES AND MEAN DISCHARGES
C     4) OBSERVED ELEVATIONS ONLY
C     5) BOTH OBSERVED INSTANTANEOUS DISCHARGES AND ELEVATIONS
C     6) BOTH OBSERVED ELEVATIONS AND MEAN DISCHARGES
C     7) ALL THREE TYPES OF OBSERVED TIME-SERIES
C
C  THE COMBINATION IS DETERMINED BY THE EXISTENCE OF ANY POINTERS FOR
C  THE OBSERVED TIME-SERIES IN THE D (TIME SERIES DATA) ARRAY POINTER
C  ARRAY (IDPT).
C
C  THE OBSERVED INSTANTANEOUS DISCHARGE IS THE FIRST POINTER, THE
C  OBSERVED MEAN DISCHARGE IS THE SECOND POINTER, AND THE OBSERVED
C  ELEVATION IS THE THIRD POINTER.
C
C
      ICOMB = 0
      IF (LAQO .NE. 0) ICOMB = ICOMB + 1
      IF (LAQM .NE. 0) ICOMB = ICOMB + 2
      IF (LAEL .NE. 0) ICOMB = ICOMB + 4
C
C  NOW SEND CONTROL TO PROPER ROUTINE LOCATION FOR THE FOUND COMBINATION
C  OF OBSERVED TIME-SERIES.
C
      GO TO (1000,2000,3000,4000,4000,2000,7000) , ICOMB
C
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  HERE WE HAVE INSTANTANEOUS OBSERVED DISCHARGES.
C
 1000 CONTINUE
C
C  GENERATE INSTANTANEOUS DISCHARGE USING THE OBSERVED INSTANTANEOUS.
C
C
C  IF THE OBSERVED INSTANTANEOUS TIME-SERIES IS LONGER THAN 
C  THE OBSERVED ELEVATION/MEAN FLOW TIME-SERIES AND 
C  THE FIRST OBSERVED ELEVATION IS MISSING, 
C  USE GENERATED INSTANTANEOUS DISCHARGE FOR INTERPOLATION.
C
      IEND = LAQO
      DO 1050 I=IST,IEND
 1050 QDUM(LQDUM+I-1) = D(LDOQO+I-1)
      IF(IST.GT.1 .AND. IFMSNG(D(LDOQO+IST-1)).EQ.1)
     &  QDUM(LQDUM+IST-1)=WK(LWST+IST-1)
C
      CALL XLIN51(IQOTYP,WK,LWQO2,QDUM,LQDUM,IST,IEND)
C
      DO 1100 I=IST,IEND
      CALL QIQL51(CO,D,I,QI1,QI2,LDQL1X,QL1,LDQL2X,QL2,
     & WK,LWQO1X,LWQO2X)
      QO2 = WK(LWQO2+I-1)
      DQ = QO2-QI2-QL2
      QO1N = QI1+QL1+DQ
      IF(QO1N.LE.0.0) QO1N=0.0
      WK(LWQO1+I-1) = QO1N
      QOM = 0.5*(QO1N+QO2)
      WK(LWQM+I-1) = QOM
      QIM = 0.5*(QI1+QL1+QI2+QL2)
      S2 = S1+(QIM-QOM)*CQSTX
      IF(S2.LE.0.0) S2=0.0
      WK(LWST+I-1) = S2
      CALL TERP26(S2,EL2,PO(LESSTO),PO(LESELV),NSE,IFLAG,IBUG)
      WK(LWEL+I-1) = EL2
      S1 = S2
 1100 CONTINUE
      GO TO 8000
C
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  HERE WE HAVE MEAN OBSERVED DISCHARGES OR
C  WE HAVE MEAN OBSERVED DISCHARGES AND POOL ELEVATION
C
 2000 CONTINUE
C
C  GENERATE MEAN DISCHARGE USING THE OBSERVED MEAN.
C
      IEND = LAQM
      CALL XLIN51(IQMTYP,WK,LWQM,QDUM,LQDUM,IST,IEND)
C
      DO 2100 I=IST,IEND
      CALL QIQL51(CO,D,I,QI1,QI2,LDQL1X,QL1,LDQL2X,QL2)
      QIM = 0.5*(QI1+QL1+QI2+QL2)
      QOM = WK(LWQM+I-1)
      DQ = QOM-QIM
      QO1N = QI1+QL1+DQ
      WK(LWQO1+I-1) = QO1N
      QO2 = QI2+QL2+DQ
      IF(QO2.LE.0.0) QO2=0.0
      WK(LWQO2+I-1) = QO2
      IF(LDOEL.LE.0) GO TO 2150
      EL2 = D(LDOEL+I-1)
      IF(IFMSNG(EL2).EQ.1) GO TO 2150
      WK(LWEL+I-1) = EL2
      CALL TERP26(EL2,S2,PO(LESELV),PO(LESSTO),NSE,IFLAG,IBUG)
      WK(LWST+I-1) = S2
      S1 = S2
      GO TO 2100
 2150 S2 = S1+(QIM-QOM)*CQSTX
      IF(S2.LE.0.0) S2=0.0
      WK(LWST+I-1) = S2
      S1 = S2
      CALL TERP26(S2,EL2,PO(LESSTO),PO(LESELV),NSE,IFLAG,IBUG)
      WK(LWEL+I-1) = EL2
 2100 CONTINUE
      IF(IEND.GE.LAOBS) GO TO 8000
C
C  LAST NON-MISSING DATA FOR OBSERVED POOL ELEV. IS LARGER THEN
C  MEAN DISCH.
      CALL XOBP51(WK,LAQM)
      IST = LAQM+1
      GO TO 4000
C
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  HERE WE HAVE BOTH THE INSTANTANEOUS AND THE MEAN OBSERVED DISCHARGES.
C
 3000 CONTINUE
C
C  GENERATE MEAN DISCHARGE USING THE OBSERVED INSTANTANEOUS
C
      IEND=LAQM
      QDUM(LQDUM) = D(LDOQM)
      DO 3050 I=IST,IEND
      IF(I.LE.1) GO TO 3050
      QO1 = D(LDOQO+I-2)
      QO2 = D(LDOQO+I-1)
      QOM = D(LDOQM+I-1)
      QDUM(LQDUM+I-1) = QOM
      IF(IFMSNG(QOM).EQ.0) GO TO 3050
      IF(IFMSNG(QO1).EQ.1 .OR. IFMSNG(QO2).EQ.1) GO TO 3050
      QDUM(LQDUM+I-1) = 0.5*(QO1+QO2)
      GO TO 3050
 3040 IF(IFMSNG(QO2).EQ.0) THEN
      CALL QIQL51(CO,D,I,QI1,QI2,LDQL1X,QL1,LDQL2X,QL2,
     & WK,LWQO1X,LWQO2X)
        DQ = QO2-QI2-QL2
        QO1 = QI1+QL1+DQ
        QDUM(LQDUM+I-1) = 0.5*(QO1+QO2)
      END IF
 3050 CONTINUE
C
      CALL XLIN51(IQMTYP,WK,LWQM,QDUM,LQDUM,IST,IEND)
C
      DO 3100 I=IST,IEND
      CALL QIQL51(CO,D,I,QI1,QI2,LDQL1X,QL1,LDQL2X,QL2,
     & WK,LWQO1X,LWQO2X)
      QIM = 0.5*(QI1+QL1+QI2+QL2)
      QOM = WK(LWQM+I-1)
      DQ = QOM-QIM
      QO1N = QI1+QL1+DQ
      IF(QO1N.LE.0.0) QO1N=0.0
      WK(LWQO1+I-1) = QO1N
      IF(I.GT.1) THEN
        OQO = D(LDOQO+I-2)
        IF(IFMSNG(OQO).EQ.0) THEN
          QO1N=OQO
          WK(LWQO1+I-1)=OQO
        ENDIF
      ENDIF
      QO2 = QI2+QL2+DQ
      IF(QO2.LE.0.0) QO2=0.0
      WK(LWQO2+I-1) = QO2
      OQO = D(LDOQO+I-1)
      IF(IFMSNG(OQO).EQ.0) THEN
        QO2=OQO
        WK(LWQO2+I-1)=OQO
      ENDIF
      S2 = S1+(QIM-QOM)*CQSTX
      IF(S2.LE.0.0) S2=0.0
      WK(LWST+I-1) = S2
      CALL TERP26(S2,EL2,PO(LESSTO),PO(LESELV),NSE,IFLAG,IBUG)
      WK(LWEL+I-1) = EL2
      S1 = S2
 3100 CONTINUE
      IF(IEND.GE.LAOBS) GO TO 8000
C
C  LAST NON-MISSING DATA FOR OBSERVED INST. DISCH. IS LARGER
C  THEN MEAN DISCH.
      CALL XOBP51(WK,LAQM)
      IST = LAQM+1
      IEND = LAQO
      GO TO 1000
C
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  HERE WE HAVE OBSERVED POOL ELEVATIONS OR
C  WE HAVE OBSERVED POOL ELEVATIONS AND INSTANTANEOUS DISCHARGE
C
 4000 CONTINUE
C
C  GENERATE OBSERVED STORAGES FROM THE OBSERVED POOL ELEVATIOS
C
C  IF THE OBSERVED ELEVATION TIME-SERIES IS LONGER THAN 
C  THE OBSERVED MEAN FLOW TIME-SERIES AND THE FIRST OBSERVED ELEVATION
C  IS MISSING, USE GENERATED STORAGE FOR INTERPOLATION.
C
      IF(IST.GT.1) QDUM(LQDUM+IST-1)=WK(LWST+IST-1)
      IEND=LAEL
      DO 4050 I=IST,IEND
      EL2 = D(LDOEL+I-1)
      IF(IFMSNG(EL2).EQ.1) GO TO 4050
      CALL TERP26(EL2,S2,PO(LESELV),PO(LESSTO),NSE,IFLAG,IBUG)
      QDUM(LQDUM+I-1) = S2
 4050 CONTINUE
C
C  GENERATE POOL STORAGE USING THE OBSERVED POOL STORAGE GENERATED FROM
C  ABOVE.
C
      CALL XLIN51(IELTYP,WK,LWST,QDUM,LQDUM,IST,IEND)
C
      DO 4100 I=IST,IEND
      CALL QIQL51(CO,D,I,QI1,QI2,LDQL1X,QL1,LDQL2X,QL2,
     & WK,LWQO1X,LWQO2X)
      S2 = WK(LWST+I-1)
      IF(IFMSNG(D(LDOEL+I-1)).EQ.1) THEN
        CALL TERP26(S2,EL2,PO(LESSTO),PO(LESELV),NSE,IFLAG,IBUG)
      ELSE
        EL2 = D(LDOEL+I-1)
      END IF
      WK(LWEL+I-1) = EL2
      DQ = (S1-S2)/CQSTX
      IF(LDOQO.LE.0) GO TO 4070
      QO2 = D(LDOQO+I-1)
      IF(IFMSNG(QO2).EQ.0) DQ = QO2-QI2-QL2
 4070 QO1N = QI1+QL1+DQ
      IF(QO1N.LE.0.0) QO1N=0.0
      WK(LWQO1+I-1) = QO1N
      QO2 = QI2+QL2+DQ
      IF(QO2.LE.0.0) QO2=0.0
      WK(LWQO2+I-1) = QO2
      QOM = 0.5*(QO1N+QO2)
      WK(LWQM+I-1) = QOM
      S1 = S2
 4100 CONTINUE
      IF(IEND.GE.LAOBS) GO TO 8000
C
C  LAST NON-MISSING DATA FOR OBSERVED INST. DISCH. IS LARGER THEN
C  POOL ELEV.
      CALL XOBP51(WK,LAEL)
      IST = LAEL+1
      IEND = LAQO
      GO TO 1000
C
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  HERE WE HAVE ALL THREE OBSERVED TIME SERIES
C
 7000 CONTINUE
C
C  GENERATE MEAN DISCHARGE USING THE OBSERVED INSTANTANEOUS
C
      IEND = LAQM
      QDUM(LQDUM) = D(LDOQM)
      DO 7050 I=IST,IEND
      IF(I.LE.1) GO TO 7050
      QO1 = D(LDOQO+I-2)
      QO2 = D(LDOQO+I-1)
      QOM = D(LDOQM+I-1)
      QDUM(LQDUM+I-1) = QOM
      IF(IFMSNG(QOM).EQ.0) GO TO 7050
      IF(IFMSNG(QO1).EQ.1 .OR. IFMSNG(QO2).EQ.1) GO TO 7050
      QDUM(LQDUM+I-1) = 0.5*(QO1+QO2)
      GO TO 7050
 7040 IF(IFMSNG(QO2).EQ.0) THEN
        CALL QIQL51(CO,D,I,QI1,QI2,LDQL1X,QL1,LDQL2X,QL2,
     &  WK,LWQO1X,LWQO2X)
        DQ = QO2-QI2-QL2
        QO1 = QI1+QL1+DQ
        QDUM(LQDUM+I-1) = 0.5*(QO1+QO2)
      END IF
 7050 CONTINUE
C
      CALL XLIN51(IQMTYP,WK,LWQM,QDUM,LQDUM,IST,IEND)
C
      DO 7100 I=IST,IEND
      CALL QIQL51(CO,D,I,QI1,QI2,LDQL1X,QL1,LDQL2X,QL2,
     & WK,LWQO1X,LWQO2X)
      QIM = 0.5*(QI1+QL1+QI2+QL2)
      QOM = WK(LWQM+I-1)
      DQ = QOM-QIM
      QO1N = QI1+QL1+DQ
      IF(QO1N.LE.0.0) QO1N=0.0
      WK(LWQO1+I-1) = QO1N
      IF(I.GT.1) THEN
        OQO = D(LDOQO+I-2)
        IF(IFMSNG(OQO).EQ.0) THEN
          QO1N=OQO
          WK(LWQO1+I-1)=OQO
        ENDIF
      ENDIF
      QO2 = QI2+QL2+DQ
      IF(QO2.LE.0.0) QO2=0.0
      WK(LWQO2+I-1) = QO2
      OQO = D(LDOQO+I-1)
      IF(IFMSNG(OQO).EQ.0) THEN
         QO2=OQO
         WK(LWQO2+I-1)=OQO
      ENDIF
      EL2 = D(LDOEL+I-1)
      IF(IFMSNG(EL2).EQ.1) GO TO 7150
      WK(LWEL+I-1) = EL2
      CALL TERP26(EL2,S2,PO(LESELV),PO(LESSTO),NSE,IFLAG,IBUG)
      WK(LWST+I-1) = S2
      S1 = S2
      GO TO 7100
 7150 S2 = S1+(QIM-QOM)*CQSTX
      IF(S2.LE.0.0) S2=0.0
      WK(LWST+I-1) = S2
      CALL TERP26(S2,EL2,PO(LESSTO),PO(LESELV),NSE,IFLAG,IBUG)
      WK(LWEL+I-1) = EL2
      S1 = S2
 7100 CONTINUE
      IF(IEND.GE.LAOBS) GO TO 8000
      CALL XOBP51(WK,LAQM)
      IST = LAQM+1
C
C  LAST NON-MISSING DATA FOR OBSERVED POOL ELEV. IS LARGER THEN
C  MEAN DISCH.
      IF(LAQM.LT.LAEL) GO TO 4000
C
C
C  LAST NON-MISSING DATA FOR OBSERVED MEAN DISCH. IS LARGER THEN
C  POOL ELEV.
C  LAST NON-MISSING DATA FOR OBSERVED INST.DISCH IS LARGER THEN
C  MEAN DISCH.
      CALL XOBP51(WK,LAQM)
      IEND = LAQO
      GO TO 1000
8000  CONTINUE
C
C ---------------------------------------------------------
C  THAT'S THE END
C
      LOBS(IRES) = LAOBS
C
C INITIALIZE INFLOW ARRAYS AND BACK COMPUTE INFLOW FROM OBSERVED DATA
      DO 8500 I=1,NUM
      LDQI1X = LDQI1
      IF(LDQI1.GT.0) GO TO 8510
      LDQI1X=LDQI2-1
      IF(I.GT.1) GO TO 8510
      QI1 = CO(1)
      GO TO 8511
 8510 QI1 = D(LDQI1X+I-1)
 8511 QI2 = D(LDQI2+I-1)
      IF(NTS.EQ.10) GO TO 8500
      WK(LWBQI1+I-1) = QI1
      WK(LWBQI2+I-1) = QI2
      QIM = 0.5*(QI1+QI2) 
      WK(LWBQIM+I-1) = QIM
 8500 CONTINUE
      IF(NTS.NE.10)
     & CALL BQIL51(CO,LCO,D,WK,LWQO1X,LWQO2X,LAOBS,CQSTX)
      IF (IBUG.LT.2) GO TO 9000
C
      CALL XOBP51(WK,LAOBS)
      IF(NTS.EQ.10) GO TO 9000
C
C  WRITE BACK INST. INFLOW AT PERIOD START
C
      WRITE(IODBUG,1615)
 1615 FORMAT(/10X,'** BACK INST. INFLOW AT PERIOD START **')
      WRITE(IODBUG,1651) (WK(LWBQI1+I-1),I=1,LAOBS)
C
C  WRITE BACK INST. INFLOW AT PERIOD END
C
      WRITE(IODBUG,1616)
 1616 FORMAT(/10X,'** BACK INST. INFLOW AT PERIOD END **')
      WRITE(IODBUG,1651) (WK(LWBQI2+I-1),I=1,LAOBS)
C
C  WRITE BACK MEAN INFLOW
C
      WRITE(IODBUG,1617)
 1617 FORMAT(/10X,'** BACK MEAN INFLOW **')
      WRITE(IODBUG,1651) (WK(LWBQIM+I-1),I=1,LAOBS)
C
      WRITE(IODBUG,1680) NRUN,LAQO,LAQM,LAEL,LAOBS,ICOMB
 1680 FORMAT(5X,'NO. OF PERIODS IN OBSERVED PORTION = ',I3,
     & 4X,'LAQO =',I4,4X,'LAQM =',I4,4X,'LAEL =',I4,
     & /5X,'LAST PERIOD WITH NON-MISSING DATA = ',I3,
     & ' OBS TS COMB CODE ICOMB = ',I3)
C
 9000 CONTINUE
 1651 FORMAT(5X,8F10.1)
 1652 FORMAT(5X,8F10.2)
      IF (IBUG.GE.1) WRITE(IODBUG,1699)
 1699 FORMAT('    *** EXIT XOBS51 ***')
C
      RETURN
      END