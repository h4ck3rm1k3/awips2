c ---------------------------------------------------------------------
      SUBROUTINE BATCHR(IBC,ISH,JNK,IDAM,HDE,BME,SA,BW,TFM,QO,
     *VOL,NS,NCS,CMS,D,FLD,HS,BS,BSS,CM,IN,IOUT,NCARD,
     *DAMN,RIVN,TOWN,DISTTN,IPLT,TWN)
C
      DIMENSION D(50),FLD(50),HS(8,50),BS(8,50),CM(8,50),BSS(8,50)
      CHARACTER*5 CODE
      CHARACTER*41 DAMN,RIVN
      CHARACTER*26 TOWN,TWN(50)
      COMMON/IOANUM/IOUTA
      COMMON/RECNO/IREC
	COMMON/S4/XLAT(50),XLON(50)
C
C         THIS SUBROUTINE READS THE DATA FROM AN EXISTING FILE - BATCH MODE
C
C
C         INPUT DATA DOCUMENTATION
C          CODE-C1 INPUT DATA LINE NO.1: DAMN
C              DAMN=NAME OF THE DAM
C	   CODE-C2 INPUT DATA LINE NO.2: RIVN,TOWN
C	       RIVN=NAME OF THE RIVER
C	       TOWN=NAME OF PRIMARY POINT OF INTEREST OR TOWN ALONG THE
C		 ROUTING REACH
C          CODE-C3 INPUT DATA LINE NO.3: IBC,ISH,JNK,IPLT,IREC
C              IBC=0  INTERACTIVE INPUT; IBC=1 BATCH INPUT
C              ISH=0  LONG VERSION; ISH=1 SHORT VERSION (REMOVED 8/90)
C              JNK=0  MINIMUM OUTPUT; JNK=1 MAX OUTPUT FOR DEBUGGING
C              IPLT=0 NO PROFILE PLOTS; IPLT=1 PROFILE PLOTS
C              IREC=0 NOT AVAILABLE; IREC>0 RECORD NO. OF DAM IN CATALOG
C                TO BE UPDATED.
C
C          CODE-C4 INPUT DATA LINE NO.4: IDAM,HDE,BME,VOL,SA,
C             BW,TFM,QO
C              IDAM=0 EARTH DAM;IDAM=1 CONCRETE GRAVITY;IDAM=2 CONCRETE ARCH
C              HDE=ELEVATION(M.S.L.) OF CREST OF DAM OR ELEV. OF WATER WHEN
C                DAM BREACHES.
C              BME=FINAL ELEVATION(M.S.L.) OF BREACH BOTTOM.
C              VOL=VOLUME(ACRE-FT) OF RESERVOIR; IF UNKNOWN LEAVE BLANK IF
C               SURFACE AREA OF RESERVOIR IS KNOWN.
C              SA=SURFACE AREA(ACRES) OF RESERVOIR AT DAM CREST; IF UNKNOWN
C               LEAVE BLANK IF VOLUME OF RESERVOIR IS KNOWN.
C              BW=WIDTH(FT) OF RECTANGULAR BREACH; IF UNKNOWN LEAVE BLANK AND
C               APPROXIMATE DEFAULT VALUE IS USED.
C              TFM=TIME(MINUTES) FOR BREACH TO DEVELOP; IF UNKNOWN LEAVE
C               BLANK AND APPROXIMATE DEFAULT VALUE IS USED.
C              QO=NON-BREACH FLOW(SPILLWAY AND OVERTOPPING) WHICH OCCURS WITH
C               MAXIMUM BREACH FLOW.
C
C           CODE-C5 INPUT DATA LINE NO.5: NS,NCS,CMS,DISTTN
C              NS=NUMBER OF CROSS-SECTIONS
C              NCS=NUMBER OF CHANNEL WIDTHS FOR EACH CROSS-SECTION
C              CMS=MANNING N ASSOCIATED WITH OFF-CHANNEL STORAGE
C	       DISTTN=DISTANCE TO PRIMARY POINT OF INTEREST OR TOWN ALONG
C		THE ROUTING REACH
C
C           CODE-C6 INPUT DATA LINE NO.6: D(I),FLD(I)
C              D(I)=DISTANCE(MILES) FROM DAM TO ITH CROSS-SECTION(USE 0.0 TO
C               DENOTE TAILWATER(FIRST) CROSS-SECTION).
C              FLD(I)=DEPTH(FT) IN CROSS-SECTION AT WHICH FLO0DING AND
C               DE-FLOODING TIMES WILL BE COMPUTED.
C
C           CODE-C7 INPUT DATA LINE NO.7:HS(K,I),BS(K,I),CM(K,I)
C              HS(K,I)=ELEVATION(M.S.L.) ASSOCIATED WITH KTH CHANNEL
C               WIDTH(BS) OF ITH CROSS-SECTION; FIRST ELEV. IS THE
C               INVERT ELEV.
C              BS(K,I)=KTH CHANNEL WIDTH(FT) OF ITH CROSS-SECTION.
C              BSS(K,I)=KTH INACTIVE CHANNEL WIDTH(FT) OF ITH CROSS-SECTION.
C              CM(K,I)=KTH MANNING N ASSOCIATED WITH KTH CHANNEL WIDTH
C               OF ITH CROSS-SECTION.
C
C         REPEAT DATA LINE NO. 7 FOR ALL NCS NUMBER OF CHANNEL WIDTHS
C         THEN, REPEAT DATA LINES NO.6 AND 7 FOR NS NUMBER OF X-SECTIONS
C
C         NCARD = NUMBER OF CARDS TO SKIP READING IN
C         NCARDS= NUMBER OF CARDS THAT WERE READ IN
C
      IF(NCARD.GT.0) GO TO 138
C
      NCARDS=0
      READ(IN,905,END=200,ERR=300) CODE,DAMN
      WRITE(IOUT,910) CODE,DAMN
      NCARDS=NCARDS+1
      READ(IN,905,END=200,ERR=300) CODE,RIVN,TOWN
      WRITE(IOUT,910) CODE,RIVN,TOWN
      NCARDS=NCARDS+1
      READ(IN,1,END=200,ERR=300) CODE,ISH,JNK,IDAM,IPLT,IREC
      WRITE(IOUT,11) CODE,IBC,ISH,JNK,IDAM,IPLT,IREC
      IF(ISH.EQ.1) THEN
        WRITE(IOUTA,994)
  994   FORMAT(/' *****  THE SHORT VERSION OF THIS PROGRAM IS NO LONGER
     *AVAILABLE.'/15X,'PROGRAM TERMINATED.')
        stop
      ENDIF
      NCARDS=NCARDS+1
C
  138 IF(NCARD.EQ.2) GO TO 139
      READ(IN,2,END=200,ERR=300) CODE,HDE,BME,VOL,SA,BW,TFM,QO
      WRITE(IOUT,12) CODE,HDE,BME,VOL,SA,BW,TFM,QO
      NCARDS=NCARDS+1
C
C          CROSS SECTION DATA NOW BEING READ IN
C
  139 READ(IN,4,END=200,ERR=300) CODE,NS,NCS,CMS,DISTTN
      WRITE(IOUT,13) CODE,NS,NCS,CMS,DISTTN
      NCARDS=NCARDS+1
      DO 150 I=1,NS
         IF(IOUT.NE.IOUTA) WRITE(IOUT,15) I
         READ(IN,5,END=200,ERR=300) CODE,D(I),FLD(I),XLAT(I),XLON(I),
     .          TWN(I)
         IF(IOUT.NE.IOUTA) WRITE(IOUT,16) CODE,D(I),FLD(I),
     .          XLAT(I),XLON(I),TWN(I)
         NCARDS=NCARDS+1
         DO 140 K=1,NCS
            READ(IN,3,END=200,ERR=300) CODE,HS(K,I),BS(K,I),BSS(K,I),
     .       CM(K,I)
            IF(IOUT.NE.IOUTA) WRITE(IOUT,14) CODE,HS(K,I),BS(K,I),
     *       BSS(K,I),CM(K,I)
            NCARDS=NCARDS+1
  140    CONTINUE
  150 CONTINUE
      GO TO 169
  200 NCARD=-NCARDS
      IF(NCARD.GE.0) NCARD=-1
      IBC=0
      write(iout,205) NCARDS, NCARD
  205 FORMAT(' NCARDS=',I5,5X,'NCARD=',I5)

      write(iout,210)
  210 FORMAT(/' *****  END OF FILE REACHED IN DATA SET.'/
     . '*****   THE REST OF THE CARDS WILL BE READ IN INTERACTIVELY.'/)
      stop
  300 NCARD=-9999
      write(iout,400) CODE
  400 FORMAT(3X,'*** ERROR READING CARD ',A5,'.  PROGRAM TERMINATED.')
      stop
    1 FORMAT(A5,5X,5I10)
    2 FORMAT(A5,5X,7F10.2)
    3 FORMAT(A5,5X,4F10.2)
    4 FORMAT(A5,5X,2I10,2F10.2)
    5 FORMAT(A5,5X,2F10.2,2F10.4,A26)
   11 FORMAT(20X,3HIBC,5X,3HISH,7X,3HJNK,5X,4HIDAM,4X,4HIPLT,4X,4HIREC/
     * 5X,A5,12X,I1,7X,I1,9X,I1,3(7X,I1))
CC   11 FORMAT(5X,A5,5X,4HIBC=,I2,5X,4HISH=,I2,5X,4HJNK=,I2,5X,5HIDAM=,I1)
   12 FORMAT(20X, 3HHDE,5X,3HBME,7X,3HVOL,6X,2HSA,6X,2HBW,5X,
     *3HTFM,6X,2HQO/5X,A5,5X,2F8.1,F10.0,3F8.1,F8.0)
   13 FORMAT(5X,A5,5X,3HNS=,I3,5X,4HNCS=,I2,5X,4HCMS=,F3.2,5X,
     *7HDISTTN=,F5.2)
   14 FORMAT(5X,A5,5X,3HHS=,F8.2,5X,3HBS=,F8.0,4X,4HBSS=,F8.0,5X
     *,3HCM=,F5.3)
   15 FORMAT(15X,8HX-S NO. ,I3)
   16 FORMAT(5X,A5,5X,2HD=,F8.2,5X,4HFLD=,F8.2,5X,'XLAT=',F10.4,5X,
     .       'XLON',F10.4,4X,'LOC=',A26)
   24 FORMAT(5X,A5,5X,3HSM=,F6.2,5X,4HCMN=,F6.4,5X,3HXM=,F6.1)
  905 FORMAT(A5,5X,A40,5X,A25)
  910 FORMAT(5X,A5,3X,A40,2X,A25)
  169 RETURN
      END