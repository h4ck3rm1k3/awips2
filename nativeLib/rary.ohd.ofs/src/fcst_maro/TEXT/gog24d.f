C MEMBER GOG24D
C  (from old member PPGOG24D)
C
      SUBROUTINE GOG24D(NBUG, CHAR, OGPDA, NSTA, KEY)
C
C.....IF NBUG = 0 ...
C.....THIS SUBROUTINE IS CALLED TO RETRIEVE THE VALUE OF NSTA AND
C.....KEY WHICH WILL BE USED IN THE SUBROUTINE GPLIST.
C
C.....IF NBUG = 1 ...
C.....THIS SUBROUTINE IS CALLED TO PERFORM THE SAME FUNCTIONS AS
C.....WHEN NBUG = 0, AND
C.....THIS SUBROUTINE IS CALLED TO DUMP OUT THE CONTENTS OF THE OG24
C.....PARAMETRIC DATA ARRAY WITHIN THE WGRFC MARO FUNCTION. THIS IS
C.....CALLED ONLY IF THE DEBUG CODE IS TURNED ON FOR THE OG24
C.....PARAMETRIC DATA ARRAY.
C
C.....WRITTEN BY:   JERRY M. NUNN   WGRFC FT. WORTH   OCTOBER 5, 1987
C
C.....THIS SUBROUTINE HAS THE FOLLOWING ARGUMENTS:
C
C.....NBUG   - A DEBUG CODE FROM THE CALLING ROUTINE. USED FOR
C.....         POSSIBLE LATER OUTPUT.
C.....CHAR   - CHARACTERISTICS (SIZE, ETC.) OF THE PARAMETRIC ARRAY.
C.....OGPDA  - THE PARAMETRIC DATA ARRAY FOR OG24.
C.....NSTA   - THE NUMBER OF NAMED NETWORK STATIONS IN THE
C.....         PARAMETRIC ARRAY.
C.....KEY    - THE SORT KEY BY WHICH THE ARRAY IS LISTED.
C.....         = 1  THE ARRAY IS SORTED BY IDENTIFIER.
C.....         = 2  THE ARRAY IS SORTED BY DESCRIPTION.
C
      INTEGER*2 OGPDA(1), IREC(2500), IGRID(2500)
C
      DIMENSION CHAR(5), ISORT(9)
C
      INCLUDE 'common/pudbug'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcst_maro/RCS/gog24d.f,v $
     . $',                                                             '
     .$Id: gog24d.f,v 1.1 1995/09/17 19:02:10 dws Exp $
     . $' /
C    ===================================================================
C
C
      DATA ISORT /4hIDEN, 4hTIFI, 4hER  , 4hDESC, 4hRIPT, 4hION ,
     * 4hUNKN, 4hOWN , 4hKEYS/
C
  900 FORMAT(1H0, '*** OG24 PARAMETER ARRAY DUMP ***')
  901 FORMAT(5X, 'THERE ARE ', I4, ' STATIONS IN THE ARRAY', /, 5X, 'THE
     * SORT KEY IS ', I2, '...THE ARRAY IS SORTED BY ', 3A4)
  902 FORMAT(1H0, 'PPPDB POINTER/GRID POINT ADDRESS PAIRS ARE:')
  903 FORMAT(I5, '/', I5, 5X, I5, '/', I5, 5X, I5, '/', I5, 5X, I5, '/',
     * I5, 5X, I5, '/', I5)
C
      KEY = CHAR(2)
      NSTA = CHAR(5)
      IF(NBUG .EQ. 0) GOTO 999
C
      DO 100 NP = 1, NSTA
      IREC(NP) = OGPDA(2*NP-1)
      IGRID(NP) = OGPDA(2*NP)
  100 CONTINUE
C
      WRITE(IOPDBG,900)
      JP = (KEY-1)*3 + 1
      IF((JP .NE. 1) .AND. (JP .NE. 4)) JP = 7
      KP = JP + 2
      WRITE(IOPDBG,901) NSTA, KEY, (ISORT(LP), LP = JP, KP)
      IF(NSTA .LE. 0) GOTO 999
      WRITE(IOPDBG,902)
      WRITE(IOPDBG,903) (IREC(NP), IGRID(NP), NP = 1, NSTA)
C
  999 RETURN
      END