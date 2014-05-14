C MEMBER FS43TL
C
      SUBROUTINE FS43TL(METRIC)
C.......................................
C     THIS SUBROUTINE PRINTS THE TITLE PAGE FOR THE SNOW-43 OPERATION
C     DISPLAY UNDER THE PRINTOPS COMMAND.
C.......................................
C     WRITTEN AS FSACTL SUB BY  ERIC ANDERSON - HRL - DEC 1982
C  MODIFIED FOR SNOW-17 OPERATION (FSNWTL SUB)
C    BY GEORGE SMITH - HRL - JANUARY 1988
C  MODIFIED FOR SNOW-43 OPERATION (FS43TL SUB)
C    BY RUSS ERB - HRL - MAY 1997
C.......................................
      DIMENSION DEPTH(2),DENG(2),DMET(2),MELTFC(3),UADJFC(3)
      DIMENSION MELTEN(3),MELTME(3),UADJEN(3),UADJME(3)
C
C     COMMON BLOCK
      INCLUDE 'common/ionum'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcst_printops/RCS/fs43tl.f,v $
     . $',                                                             '
     .$Id: fs43tl.f,v 1.1 1997/06/24 19:54:08 page Exp $
     . $' /
C    ===================================================================
C
C
C     DATA STATEMENTS
      DATA DENG,DMET,TENG,TMET/4HINCH,4HES  ,4HMM  ,4H    ,4HDEGF,
     14HDEGC/
      DATA MELTME/4HMM/D,4HEGC/,4H6HR /,MELTEN/4HIN/D,4HEGF/,4H6HR /
      DATA UADJME/4HMM/M,4HBAR/,4H6HR /
      DATA UADJEN/4HIN/I,4HN-HG,4H/6HR/
C.......................................
C     INITIAL VALUES.
      IF(METRIC.EQ.1) GO TO 11
      DEPTH(1)=DENG(1)
      DEPTH(2)=DENG(2)
      TEMP=TENG
      DO 2 I=1,3
      MELTFC(I)=MELTEN(I)
 2    UADJFC(I)=UADJEN(I)
      GO TO 10
   11 DEPTH(1)=DMET(1)
      DEPTH(2)=DMET(2)
      TEMP=TMET
      DO 5 I=1,3
      MELTFC(I)=MELTME(I)
 5    UADJFC(I)=UADJME(I)
C.......................................
C     PRINT TITLE PAGE
   10 WRITE(IPR,900)
  900 FORMAT(1H1)
      DO 12 I=1,8
   12 WRITE(IPR,901)
  901 FORMAT(1H0)
      WRITE(IPR,902)
  902 FORMAT(1H0,40X,45HGLOSSARY OF NAMES USED IN THE SNOW-43 DISPLAY)
      WRITE(IPR,901)
      WRITE(IPR,903)
  903 FORMAT(1H0,20X,4HNAME,31X,11HDESCRIPTION,33X,5HUNITS,/21X,4H****,
     131X,11H***********,33X,5H*****)
      WRITE(IPR,904)DEPTH
 904  FORMAT(1H0,20X,'CURRENT WE',5X,'CURRENT WATER-EQUIVALENT',
     1 1X,13(' . '),2A4)
      WRITE(IPR,905)
 905  FORMAT(21X,'AREAL COVER',4X,'AREAL EXTENT OF SNOW COVER',
     1 2X,12(' . '),'1/')
      WRITE(IPR,906)DEPTH
 906  FORMAT(21X,'MAX. WE',8X,'MAXIMUM WATER-EQUIVALENT THAT HAS ',
     1 'OCCURRED'/38X,'SINCE SNOW BEGAN TO ACCUMULATE',
     2 2X,10(' . '),2A4)
      WRITE(IPR,907)
 907  FORMAT(21X,'AEADJ',10X,'AREAL EXTENT OF SNOW COVER ',
     1 'ADJUSTMENT FACTOR',2X,6(' . '),'2/')
      WRITE(IPR,908)DEPTH
 908  FORMAT(21X,'HEAT DEF.',6X,'HEAT DEFICIT',
     1 1X,17(' . '),2A4)
      WRITE(IPR,909)TEMP
 909  FORMAT(21X,'TINDEX',9X,'ANTECEDENT SNOW TEMPERATURE INDEX',
     1 1X,10(' . '),2A4)
      WRITE(IPR,910)
 910  FORMAT(21X,'FRAC LIQUID',4X,'FRACTION OF WATER EQUIVALENT ',
     1 'THAT IS HELD'/38X,'AGAINST GRAVITY DRAINAGE',
     2 2X,12(' . '),'2/')
      WRITE(IPR,911)
 911  FORMAT(21X,'SCF',12X,'SNOWFALL CORRECTION FACTOR',
     1 2X,12(' . '),'3/')
      WRITE(IPR,912)DEPTH
 912  FORMAT(21X,'SI',13X,'AREAL WATER-EQUIVALENT ABOVE WHICH THERE ',
     1 'IS'/38X,'ALWAYS 100 PERCENT SNOW COVER',11(' . '),2A4)
      WRITE(IPR,913)TEMP
 913  FORMAT(21X,'PXTEMP',9X,'TEMPERATURE THAT SEPARATES RAIN FROM ',
     1 'SNOW'/38X,'(SNOW IF TEMPERATURE IS LE PXTEMP)',1X,9(' . '),2A4)
      WRITE(IPR,914)MELTFC
 914  FORMAT(21X,'MFMAX',10X,'MAXIMUM NONRAIN MELT FACTOR',
     1 1X,12(' . '),3A4)
      WRITE(IPR,915)MELTFC
 915  FORMAT(21X,'MFMIN',10X,'MINIMUM NONRAIN MELT FACTOR',
     1 1X,12(' . '),3A4)
      WRITE(IPR,916)UADJFC
 916  FORMAT(21X,'UADJ',11X,'AVERAGE VALUE OF THE WIND FUNCTION ',
     1 'DURING RAIN-ON-SNOW EVENTS',
     2 ' . ',3A4)
      WRITE(IPR,917)
 917  FORMAT(21X,'OP-NAME',8X,'OPERATION NAME WITHIN A SEGMENT')
C
      WRITE(IPR,950)
 950  FORMAT(//21X,'NOTES... 1. INDICATES FRACTION OF AREA ',
     1 'REPRESENTED.')
      WRITE(IPR,951)
 951  FORMAT(30X,'2. DECIMAL FRACTION.')
      WRITE(IPR,952)
 952  FORMAT(30X,'3. MULTIPLYING FACTOR.')
C
C.......................................
      RETURN
      END