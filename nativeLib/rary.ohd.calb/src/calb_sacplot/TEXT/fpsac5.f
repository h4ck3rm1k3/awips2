C MEMBER FPSAC5
C  (from old member MCEX5)
C
C @PROCESS LVL(77)
C
      SUBROUTINE FPSAC5(NSAC,LSAC,PO,P,MP,C,MC)
C.......................................
C     THIS SUBROUTINE PRINTS INFORMATION ABOUT SAC-SMA OPERATIONS
C          FOR THE SAC-PLOT OPERATION.
C.......................................
C     SUBROUTINE INITIALLY WRITTEN BY...
C        ERIC ANDERSON - HRL   JAN. 1980
C.......................................
C     THE VARIABLES IN THE ARGUMENT LIST ARE
C        NAME                DESCRIPTION
C        NSAC      NUMBER OF SAC-SMA OPERATIONS.
C        LSAC      LOCATION OF SAC-SMA OPERATIONS IN THE P ARRAY.
C        PO        PARAMETER ARRAY FOR THE SAC-PLOT OPERATION.
C        P         THE ENTIRE P ARRAY.
C        MP        DIMENSION OF THE P ARRAY.
C        C         THE ENTIRE C ARRAY.
C        MC        DIMENSION OF THE C ARRAY.
C.......................................
      DIMENSION P(MP),C(MC)
      DIMENSION PO(*),LSAC(*)
C
C     COMMON BLOCKS
      INCLUDE 'common/fdbug'
      INCLUDE 'common/ionum'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/calb/src/calb_sacplot/RCS/fpsac5.f,v $
     . $',                                                             '
     .$Id: fpsac5.f,v 1.2 1996/07/11 19:24:20 dws Exp $
     . $' /
C    ===================================================================
C
C.......................................
C     TRACE LEVEL FOR THIS SUBROUTINE=1.
      IF(ITRACE.GE.1)WRITE(IODBUG,10)
10    FORMAT(1H0,17H** FPSAC5 ENTERED)
C.......................................
C     PRINT PARAMETER VALUES.
      WRITE (IPR,20)
20    FORMAT(1H0,8HOP. NAME,1X,5HPXADJ,1X,5HPEADJ,1X,5HUZTWM,1X,5HUZFWM,
     13X,3HUZK,1X,5HPCTIM,1X,5HADIMP,2X,4HRIVA,1X,5HZPERC,2X,4HREXP,1X,
     2 5HLZTWM,1X,5HLZFSM,1X,5HLZFPM,2X,4HLZSK,3X,4HLZPK,1X,5HPFREE,1X,
     35HRSERV,2X,4HSIDE,3X,3HEFC)
      DO 40 N=1,NSAC
      LP=LSAC(N)
      LOC=P(LP+19)-1.0
      LV=LOC+17
      LP5 = LP-5
      LP4 = LP-4
      LPLOC = LP+LOC
      LPLV = LP+LV
      LPLO19 = LP+LOC+19
C
C  FOLLOWING WRITE CONVERTED FOR CONFORMITY WITH VS FORTRAN LVL 66.
C
C     WRITE (IPR,903) P(LP-5),P(LP-4),(P(LP+I),I=LOC,LV),P(LP+LOC+19)
C
      WRITE (IPR,30) P(LP5),P(LP4),(P(I),I=LPLOC,LPLV),P(LPLO19)
30    FORMAT (1H ,2A4,2F6.2,2F6.0,4F6.3,F6.1,F6.2,3F6.0,F6.3,F7.4,4F6.2)
40    CONTINUE
C
C     PRINT CARRYOVER VALUES.
      WRITE (IPR,50)
50    FORMAT (1H0,22HCONTENTS OF STORAGES--,2X,5HUZTWC,2X,5HUZFWC,2X,
     15HLZTWC,2X,5HLZFSC,2X,5HLZFPC,2X,5HADIMC)
      DO 70 N=1,NSAC
      LP=LSAC(N)
      LOC=P(LP-1)
      LV=LOC+5
      LP5 = LP-5
      LP4 = LP-4
C
C  FOLLOWING WRITE CHANGED FOR CONFORMITY WITH VS FORTRAN LVL66
C
C       WRITE (IPR,905) P(LP-5),P(LP-4),(C(I),I=LOC,LV)
C
      WRITE (IPR,60) P(LP5),P(LP4),(C(I),I=LOC,LV)
60    FORMAT (1H ,12X,2A4,2X,F7.0,F7.1,F7.0,F7.1,2F7.0)
70    CONTINUE
C
C     CHECK IF SUMMATIONS ARE AVAILABLE FOR ANY SAC-SMA OPERATIONS.
      LP=PO(13)
      DO 80 N=1,NSAC
      I=PO(LP+N*3)
      IF (I.GT.0) GO TO 90
80    CONTINUE
      GO TO 130
C
C     SUMMATIONS EXIST.
90    WRITE (IPR,100)
100   FORMAT (1H0,27X,24HWATER BALANCE COMPONENTS,23X,19HBREAKDOWN OF RU
     1NOFF, 6X,31HBREAKDOWN OF EVAPOTRANSPIRATION,/13X,6HPRECIP,4X,
     26HRUNOFF,2X,8HRECHARGE,4X,6HACT-ET,3X,7HDELTA S,2X,8HRESIDUAL,
     32X,3HIMP,2X,3HDIR,2X,3HSUR,2X,3HINT,2X,3HSUP,2X,3HPRM,4X,2HPE,4X,
     42HUZ,4X,2HLZ,1X,5HADIMP,2X,4HRIVA)
      DO 120 N=1,NSAC
      LV=LP+3*(N-1)+1
      I=PO(LV+2)
      IF (I.EQ.0) GO TO 120
      LOC=LSAC(N)+I-2
      DS=P(LOC+1)-P(LOC+2)-P(LOC+3)-P(LOC+4)-P(LOC+5)
      LV1 = LV+1
      LOC1 = LOC+1
      LOC4 = LOC+4
      LOC5 = LOC+5
      LOC16 = LOC+16
C
C  FOLLOWING WRITE CHANGED TO CONFORM WITH VS FORTRAN LVL 66
C
C         WRITE (IPR,907) PO(LV),PO(LV+1),(P(LOC+I),I=1,4),DS,(P(LOC+I),
C        1I=5,16)
C
      WRITE (IPR,110) PO(LV),PO(LV1),(P(I),I=LOC1,LOC4),DS,(P(I),
     1I=LOC5,LOC16)
110   FORMAT (1H ,2A4,5F10.1,F10.3,6F5.0,5F6.1)
120   CONTINUE
C
C     PRINT SEPARATOR.
130   WRITE (IPR,140)
140   FORMAT (1H0,50H**************************************************)
C.......................................
      RETURN
      END