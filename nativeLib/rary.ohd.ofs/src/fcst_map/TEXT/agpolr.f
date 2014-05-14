C MEMBER AGPOLR
C  (from old member AGPOLAR)
C **********************************************************************
C
      SUBROUTINE AGPOLR(TOP,BOT,XLEFT,RIGHT,ADJ,XA,YA,XB,YB)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcst_map/RCS/agpolr.f,v $
     . $',                                                             '
     .$Id: agpolr.f,v 1.1 1995/09/17 18:59:20 dws Exp $
     . $' /
C    ===================================================================
C
C
C          POLAR STEREOGRAPHIC SUBROUTINE
C
C THIS WAS INITIALLY SET UP FOR USE IN CREATING MAP BACKGROUNDS.
C IT SETS UP THE CONVERSION FACTORS FOR CONVERTING LAT,LON VALUES
C (IN RADIANS) TO X,Y VALUES ON THE AFOS GDM USING A POLAR
C STEREOGRAPHIC PROJECTION.
C
C BY ED VANBLARGAN - HRL - JULY,1982
C BASED ON PROGRAM WDB BY DON LAURAINE (SLC) AND EQUATIONS BY
C RICHARD CHIA (SDO).
C
C
C CONVERSION EQUATIONS TO GET AFOS IX,IY ARE:
C   XM=4680. * TAN(0.785369-0.5*XLAT*DEGRAD)
C   YM=XLON * DEGRAD - ADJ*DEGRAD
C   IX=XM*COS(YM) * XA -XB
C   IY=(-XM*SIN(YM)) * YA - YB
C WHERE
C   DEGRAD=0.017453 , DEGRESS TO RADIANS CONVERSION
C   XLAT  =LATITUDE OF POINT (IN DEGREES DECIMAL)
C   XLON  =LONGITUDE      "     "    "     "
C
C VARIABLES:
C        INPUT/
C NAME   OUTPUT DIM DESCRIPTION
C ----   ------ --- --------------------------------------------------
C TOP    INPUT   1  TOP    LATITUDE  OF WINDOW IN DEGREES DECIMAL
C BOT    INPUT   1  BOTTOM LATITUDE  OF WINDOW IN DEGREES DECIMAL
C XLEFT  INPUT   1  LEFT   LONGITUDE OF WINDOW IN DEGREES DECIMAL
C RIGHT  INPUT   1  RIGHT  LONGITUDE OF WINDOW IN DEGREES DECIMAL
C ADJ    OUTPUT  1  CONVERSION FACTOR
C XA     OUTPUT  1  CONVERSION FACTOR
C YA     OUTPUT  1  CONVERSION FACTOR
C XB     OUTPUT  1  CONVERSION FACTOR
C YB     OUTPUT  1  CONVERSION FACTOR
C
C C C C C C C C C C C C C C C C C C C C C C C C C C C C C C C C C C C C
C
C  THIS SECTION CONVERTS MAP BOUNDARIES FROM LAT/LON TO RADIANS.
C
      RADT = 0.017453 * TOP
      RADB = 0.017453 * BOT
      RADL = -0.017453 * XLEFT
      RADR = -0.017453 * RIGHT
C
C  SET UP POLAR PROJECTION AND SCALE FACTORS FOR AFOS SCREEN.
C
      ADJ = ((XLEFT + RIGHT)/2.)-90.
C
      COEF1 = 4680. * TAN(.785396 - .5 * RADT)
      COEF3 = 4680. * TAN(.785396 - .5 * RADB)
      COEF2 = RADR + ADJ * .017453
      COEF4 = RADL + ADJ * .017453
C
      XTR = COEF1 * COS(COEF2)
      XTL = COEF1 * COS(COEF4)
C
      XBR = COEF3 * COS(COEF2)
      XBL = COEF3 * COS(COEF4)
C
      YTR = COEF1 * SIN(COEF2)
      YTL = COEF1 * SIN(COEF4)
C
      YBR = COEF3 * SIN(COEF2)
      YBL = COEF3 * SIN(COEF4)
C
C
      RT = AMAX1(YTR,YTL)
      RB = AMIN1(YBR,YBL)
      RR = AMAX1(XTR,XBR)
      RL = AMIN1(XTL,XBL)
C
      XA = 4095./(RR-RL)
      YA = 3071./(RT-RB)
C
      XA = AMIN1(XA,YA)
      YA = XA
C
      XB = RL * XA
      YB = RB * YA
C
      RETURN
      END