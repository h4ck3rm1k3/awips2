##
# This software was developed and / or modified by Raytheon Company,
# pursuant to Contract DG133W-05-CQ-1067 with the US Government.
# 
# U.S. EXPORT CONTROLLED TECHNICAL DATA
# This software product contains export-restricted data whose
# export/transfer/disclosure is restricted by U.S. law. Dissemination
# to non-U.S. persons whether in the United States or abroad requires
# an export license or other authorization.
# 
# Contractor Name:        Raytheon Company
# Contractor Address:     6825 Pine Street, Suite 340
#                         Mail Stop B8
#                         Omaha, NE 68106
#                         402.291.0100
# 
# See the AWIPS II Master Rights File ("Master Rights File.pdf") for
# further licensing information.
##
# ----------------------------------------------------------------------------
# This software is in the public domain, furnished "as is", without technical
# support, and with no warranty, express or implied, as to its usefulness for
# any purpose.
#
# ETN REuse test case - CAR
#
# Author:
# ----------------------------------------------------------------------------

scripts = [
    {
    "commentary": "Clear out all Hazards Table and Grids.",
    "name": "ETNReuse_1a",
    "productType": None,
    "clearHazardsTable": 1,
    "checkStrings": [],
    },
    {
    "commentary": "Initial setup of two GL.As",
    "name": "ETNReuse_1b",
    "drtTime": "20101203_0200",
    "gridsStartTime": "20101203_0000",
    "productType": "CWF",
    "createGrids": [
       ("Fcst", "Hazards", "DISCRETE", -100, 100, "<None>", "all"),
       ("Fcst", "Hazards", "DISCRETE", 0, 7, "GL.A", ["GMZ870"]),
       ("Fcst", "Hazards", "DISCRETE", 18, 24+15, "GL.A", ["GMZ870"]),
       ],
    "checkStrings": [
       "FZUS52 KTBW 030200",
       "CWFTBW",
       "COASTAL WATERS FORECAST FOR FLORIDA",
       "NATIONAL WEATHER SERVICE TAMPA BAY RUSKIN FL",
       "900 PM EST THU DEC 2 2010",
       "GMZ800-031500-",
       "900 PM EST THU DEC 2 2010",
       "SYNOPSIS FOR BONITA BEACH TO SUWANNEE RIVER FL OUT 60 NM",
       "$$",
       "GMZ870-031500-",
#       "/O.NEW.KTBW.GL.A.0001.101203T0200Z-101203T0700Z/",
#       "/O.NEW.KTBW.GL.A.0002.101203T1800Z-101204T1500Z/",
       "WATERS FROM TARPON SPRINGS TO SUWANNEE RIVER FL OUT 20 TO 60 NM-",
       "900 PM EST THU DEC 2 2010",
       "...GALE WATCH IN EFFECT UNTIL 2 AM EST FRIDAY...",
       "...GALE WATCH IN EFFECT FROM FRIDAY AFTERNOON THROUGH SATURDAY MORNING...",
       ".TODAY...",
       ".TONIGHT...",
       ".FRIDAY...",
       ".FRIDAY NIGHT...",
       ".SATURDAY...",
       ".SATURDAY NIGHT...",
       ".SUNDAY...",
       ".MONDAY...",
       "$$",
       ],
    },

    {
    "commentary": "Initial setup of two GL.As - switch to CONs - P1",
    "name": "ETNReuse_1c",
    "drtTime": "20101203_0202",
    "gridsStartTime": "20101203_0000",
    "productType": "CWF",
    "createGrids": [
       ("Fcst", "Hazards", "DISCRETE", -100, 100, "<None>", "all"),
       ("Fcst", "Hazards", "DISCRETE", 0, 7, "GL.A", ["GMZ870"]),
       ("Fcst", "Hazards", "DISCRETE", 18, 24+15, "GL.A", ["GMZ870"]),
       ],
    "checkStrings": [
       "FZUS52 KTBW 030202",
       "CWFTBW",
       "COASTAL WATERS FORECAST FOR FLORIDA",
       "NATIONAL WEATHER SERVICE TAMPA BAY RUSKIN FL",
       "902 PM EST THU DEC 2 2010",
       "GMZ800-031500-",
       "902 PM EST THU DEC 2 2010",
       "SYNOPSIS FOR BONITA BEACH TO SUWANNEE RIVER FL OUT 60 NM",
       "$$",
       "GMZ870-031500-",
#      "/O.CON.KTBW.GL.A.0001.000000T0000Z-101203T0700Z/",
#      "/O.CON.KTBW.GL.A.0002.101203T1800Z-101204T1500Z/",
       "WATERS FROM TARPON SPRINGS TO SUWANNEE RIVER FL OUT 20 TO 60 NM-",
       "902 PM EST THU DEC 2 2010",
       "...GALE WATCH REMAINS IN EFFECT UNTIL 2 AM EST FRIDAY...",
       "...GALE WATCH REMAINS IN EFFECT FROM FRIDAY AFTERNOON THROUGH SATURDAY MORNING...",
       ".TODAY...",
       ".TONIGHT...",
       ".FRIDAY...",
       ".FRIDAY NIGHT...",
       ".SATURDAY...",
       ".SATURDAY NIGHT...",
       ".SUNDAY...",
       ".MONDAY...",
       "$$",
       ],
    },

    {
    "commentary": "1stGL.A EXP, adjust remaining GL.A to allow a SR.A - P2" ,
    "name": "ETNReuse_1d",
    "drtTime": "20101203_0820",
    "gridsStartTime": "20101203_0000",
    "productType": "CWF",
    "createGrids": [
       ("Fcst", "Hazards", "DISCRETE", -100, 100, "<None>", "all"),
       ("Fcst", "Hazards", "DISCRETE", 8, 18, "GL.A", ["GMZ870"]),
       ("Fcst", "Hazards", "DISCRETE", 18, 24+3, "SR.A", ["GMZ870"]),
       ("Fcst", "Hazards", "DISCRETE", 24+3, 24+16, "GL.A", ["GMZ870"]),
       ],
    "checkStrings": [
      "FZUS52 KTBW 030820",
      "CWFTBW",
      "COASTAL WATERS FORECAST FOR FLORIDA",
      "NATIONAL WEATHER SERVICE TAMPA BAY RUSKIN FL",
      "320 AM EST FRI DEC 3 2010",
      "GMZ800-032100-",
      "320 AM EST FRI DEC 3 2010",
      "SYNOPSIS FOR BONITA BEACH TO SUWANNEE RIVER FL OUT 60 NM",
      "$$",
      "GMZ870-032100-",
#      "/O.NEW.KTBW.GL.A.0003.101203T0820Z-101203T1800Z/",
#      "/O.NEW.KTBW.SR.A.0001.101203T1800Z-101204T0300Z/",
#      "/O.EXT.KTBW.GL.A.0002.101204T0300Z-101204T1600Z/",
      "WATERS FROM TARPON SPRINGS TO SUWANNEE RIVER FL OUT 20 TO 60 NM-",
      "320 AM EST FRI DEC 3 2010",
      "...GALE WATCH IN EFFECT UNTIL 1 PM EST THIS AFTERNOON...",
      "...STORM WATCH IN EFFECT FROM 1 PM EST THIS AFTERNOON THROUGH THIS EVENING...",
      "...GALE WATCH NOW IN EFFECT FROM THIS EVENING THROUGH SATURDAY MORNING...",
      ".TODAY...",
      ".TONIGHT...",
      ".SATURDAY...",
      ".SATURDAY NIGHT...",
      ".SUNDAY...",
      ".SUNDAY NIGHT...",
      ".MONDAY...",
      ".TUESDAY...",
      "$$",
       ],
    },

    {
    "commentary": "CAN SR.A, EXT the GL.A - P3",
    "name": "ETNReuse_1e",
    "drtTime": "20101203_1940",
    "gridsStartTime": "20101203_0000",
    "productType": "CWF",
    "createGrids": [
       ("Fcst", "Hazards", "DISCRETE", -100, 100, "<None>", "all"),
       ("Fcst", "Hazards", "DISCRETE", 0, 7, "GL.A", ["GMZ870"]),
       ("Fcst", "Hazards", "DISCRETE", 19, 24+15, "GL.A", ["GMZ870"]),
       ],
    "checkStrings": [
      "FZUS52 KTBW 031940",
      "CWFTBW",
      "COASTAL WATERS FORECAST FOR FLORIDA",
      "NATIONAL WEATHER SERVICE TAMPA BAY RUSKIN FL",
      "240 PM EST FRI DEC 3 2010",
      "GMZ800-040800-",
      "240 PM EST FRI DEC 3 2010",
      "SYNOPSIS FOR BONITA BEACH TO SUWANNEE RIVER FL OUT 60 NM",
      "$$",
      "GMZ870-040800-",
#     "/O.CAN.KTBW.SR.A.0001.000000T0000Z-101204T0300Z/",
#      "/O.EXT.KTBW.GL.A.0002.101203T1940Z-101204T1500Z/",
      "WATERS FROM TARPON SPRINGS TO SUWANNEE RIVER FL OUT 20 TO 60 NM-",
      "240 PM EST FRI DEC 3 2010",
      "...GALE WATCH NOW IN EFFECT THROUGH SATURDAY MORNING...",
      ".TODAY...",
      ".TONIGHT...",
      ".SATURDAY...",
      ".SATURDAY NIGHT...",
      ".SUNDAY...",
      ".SUNDAY NIGHT...",
      ".MONDAY...",
      ".TUESDAY...",
      "$$",
       ],
    },

    {
    "commentary": "NEW GL.A and SR.A",
    "name": "ETNReuse_1f",
    "drtTime": "20101206_0834",
    "gridsStartTime": "20101206_0000",
    "productType": "CWF",
    "createGrids": [
       ("Fcst", "Hazards", "DISCRETE", -100, 100, "<None>", "all"),
       ("Fcst", "Hazards", "DISCRETE", 24+1, 24+11, "SR.A", ["GMZ870"]),
       ("Fcst", "Hazards", "DISCRETE", 24+11, 24+23, "GL.A", ["GMZ870"]),
       ],
    "checkStrings": [
      "FZUS52 KTBW 060834",
      "CWFTBW",
      "COASTAL WATERS FORECAST FOR FLORIDA",
      "NATIONAL WEATHER SERVICE TAMPA BAY RUSKIN FL",
      "334 AM EST MON DEC 6 2010",
      "GMZ800-062100-",
      "334 AM EST MON DEC 6 2010",
      "SYNOPSIS FOR BONITA BEACH TO SUWANNEE RIVER FL OUT 60 NM",
      "$$",
      "GMZ870-062100-",
#      "/O.NEW.KTBW.SR.A.0002.101207T0100Z-101207T1100Z/",
#      "/O.NEW.KTBW.GL.A.0004.101207T1100Z-101207T2300Z/",
      "WATERS FROM TARPON SPRINGS TO SUWANNEE RIVER FL OUT 20 TO 60 NM-",
      "334 AM EST MON DEC 6 2010",
      "...STORM WATCH IN EFFECT FROM THIS EVENING THROUGH LATE TONIGHT...",
      "...GALE WATCH IN EFFECT FROM TUESDAY MORNING THROUGH TUESDAY AFTERNOON...",
      ".TODAY...",
      ".TONIGHT...",
      ".TUESDAY...",
      ".TUESDAY NIGHT...",
      ".WEDNESDAY...",
      ".WEDNESDAY NIGHT...",
      ".THURSDAY...",
      ".FRIDAY...",
      "$$",
       ],
    },

    {
    "commentary": "Deleting hazard grids.",
    "name": "ETNReuse_1g",
    "productType": None,
    "clearHazardsTable": 1,
    "checkStrings": [],
    },

# Shannon NHDW test case, split, create, delete, create, ETN codes and action
    {
    "commentary": "Deleting hazard grids.",
    "name": "ETNReuse_2a",
    "productType": None,
    "clearHazardsTable": 1,
    "checkStrings": [],
    },

    {
    "commentary": "Step1-initial HT.Y, etn0001",
    "name": "ETNReuse_2b",
    "drtTime": "20100706_2056",
    "gridsStartTime": "20100706_0000",
    "cmdLineVars": None,
    "comboFlag": 0,
    "combinations": None,
    "productType": "Hazard_NPW_Local",
    "createGrids": [
       ("Fcst", "Hazards", "DISCRETE", -100, 100, "<None>", "all"),
       ("Fcst", "Hazards", "DISCRETE", 21, 22, "HT.Y", ["FLZ052"]),
       ],
    "checkStrings": [
      "WWUS72 KTBW 062056",
      "NPWTBW",
      "URGENT - WEATHER MESSAGE",
      "NATIONAL WEATHER SERVICE TAMPA BAY RUSKIN FL",
      "456 PM EDT TUE JUL 6 2010",
      "...|*OVERVIEW HEADLINE (MUST EDIT)*|...",
      ".|*OVERVIEW (MUST EDIT)*|.",
      "FLZ052-062200-",
      "/O.NEW.KTBW.HT.Y.0001.100706T2100Z-100706T2200Z/",
      "POLK-",
      "456 PM EDT TUE JUL 6 2010",
      "...HEAT ADVISORY IN EFFECT UNTIL 6 PM EDT THIS EVENING...",
      "THE NATIONAL WEATHER SERVICE IN TAMPA BAY RUSKIN HAS ISSUED A HEAT ADVISORY...WHICH IS IN EFFECT UNTIL 6 PM EDT THIS EVENING.",
      "|* SEGMENT TEXT GOES HERE *|.",
      "A HEAT ADVISORY MEANS THAT A PERIOD OF HOT TEMPERATURES IS EXPECTED. THE COMBINATION OF HOT TEMPERATURES AND HIGH HUMIDITY WILL COMBINE TO CREATE A SITUATION IN WHICH HEAT ILLNESSES ARE POSSIBLE. DRINK PLENTY OF FLUIDS...STAY IN AN AIR-CONDITIONED ROOM...STAY OUT OF THE SUN...AND CHECK UP ON RELATIVES AND NEIGHBORS.",
      "$$",
       ],
    },

    {
    "commentary": "Step2-initial HT.Y, etn0002",
    "name": "ETNReuse_2c",
    "drtTime": "20101206_2056",
    "gridsStartTime": "20101206_0000",
    "cmdLineVars": None,
    "comboFlag": 0,
    "combinations": None,
    "productType": "Hazard_NPW_Local",
    "createGrids": [
       ("Fcst", "Hazards", "DISCRETE", -100, 100, "<None>", "all"),
       ("Fcst", "Hazards", "DISCRETE", 21, 48+9, "HT.Y", ["FLZ050","FLZ051"]),
       ],
    "checkStrings": [
      "WWUS72 KTBW 062056",
      "NPWTBW",
      "URGENT - WEATHER MESSAGE",
      "NATIONAL WEATHER SERVICE TAMPA BAY RUSKIN FL",
      "356 PM EST MON DEC 6 2010",
      "...|*OVERVIEW HEADLINE (MUST EDIT)*|...",
      ".|*OVERVIEW (MUST EDIT)*|.",
      "FLZ050-051-070500-",
      "/O.NEW.KTBW.HT.Y.0002.101206T2100Z-101208T0900Z/",
      "PINELLAS-HILLSBOROUGH-",
      "356 PM EST MON DEC 6 2010",
      "...HEAT ADVISORY IN EFFECT UNTIL 4 AM EST WEDNESDAY...",
      "THE NATIONAL WEATHER SERVICE IN TAMPA BAY RUSKIN HAS ISSUED A HEAT ADVISORY...WHICH IS IN EFFECT UNTIL 4 AM EST WEDNESDAY. ",
      "|* SEGMENT TEXT GOES HERE *|.",
      "A HEAT ADVISORY MEANS THAT A PERIOD OF HOT TEMPERATURES IS EXPECTED. THE COMBINATION OF HOT TEMPERATURES AND HIGH HUMIDITY WILL COMBINE TO CREATE A SITUATION IN WHICH HEAT ILLNESSES ARE POSSIBLE. DRINK PLENTY OF FLUIDS...STAY IN AN AIR-CONDITIONED ROOM...STAY OUT OF THE SUN...AND CHECK UP ON RELATIVES AND NEIGHBORS.",
      "$$",
       ],
    },


    {
    "commentary": "Step3-insert EH.W in middle of HT.Y",
    "name": "ETNReuse_2d",
    "drtTime": "20101206_2104",
    "gridsStartTime": "20101206_0000",
    "cmdLineVars": None,
    "comboFlag": 0,
    "combinations": None,
    "productType": "Hazard_NPW_Local",
    "createGrids": [
       ("Fcst", "Hazards", "DISCRETE", -100, 100, "<None>", "all"),
       ("Fcst", "Hazards", "DISCRETE", 21, 24+8, "HT.Y", ["FLZ050","FLZ051"]),
       ("Fcst", "Hazards", "DISCRETE", 24+8, 24+17, "EH.W", ["FLZ050","FLZ051"]),
       ("Fcst", "Hazards", "DISCRETE", 24+17, 48+9, "HT.Y", ["FLZ050","FLZ051"]),
       ],
    "checkStrings": [
      "WWUS72 KTBW 062104",
      "NPWTBW",
      "URGENT - WEATHER MESSAGE",
      "NATIONAL WEATHER SERVICE TAMPA BAY RUSKIN FL",
      "404 PM EST MON DEC 6 2010",
      "...|*OVERVIEW HEADLINE (MUST EDIT)*|...",
      ".|*OVERVIEW (MUST EDIT)*|.",
      "FLZ050-051-070515-",
      "/O.NEW.KTBW.EH.W.0001.101207T0800Z-101207T1700Z/",
      "/O.NEW.KTBW.HT.Y.0003.101207T1700Z-101208T0900Z/",
      "/O.EXT.KTBW.HT.Y.0002.000000T0000Z-101207T0800Z/",
      "PINELLAS-HILLSBOROUGH-",
      "404 PM EST MON DEC 6 2010",
      "...HEAT ADVISORY NOW IN EFFECT UNTIL 3 AM EST TUESDAY...",
      "...EXCESSIVE HEAT WARNING IN EFFECT FROM 3 AM TO NOON EST TUESDAY...",
      "...HEAT ADVISORY IN EFFECT FROM NOON TUESDAY TO 4 AM EST WEDNESDAY...",
#      "THE NATIONAL WEATHER SERVICE IN TAMPA BAY RUSKIN HAS ISSUED AN EXCESSIVE HEAT WARNING...WHICH IS IN EFFECT FROM 3 AM TO NOON EST TUESDAY. A HEAT ADVISORY HAS ALSO BEEN ISSUED. THIS HEAT ADVISORY IS IN EFFECT FROM NOON TUESDAY TO 4 AM EST WEDNESDAY. THE HEAT ADVISORY IS NOW IN EFFECT UNTIL 3 AM EST TUESDAY.",
      "|* SEGMENT TEXT GOES HERE *|.",
      "A HEAT ADVISORY MEANS THAT A PERIOD OF HOT TEMPERATURES IS EXPECTED. THE COMBINATION OF HOT TEMPERATURES AND HIGH HUMIDITY WILL COMBINE TO CREATE A SITUATION IN WHICH HEAT ILLNESSES ARE POSSIBLE. DRINK PLENTY OF FLUIDS...STAY IN AN AIR-CONDITIONED ROOM...STAY OUT OF THE SUN...AND CHECK UP ON RELATIVES AND NEIGHBORS.",
      "AN EXCESSIVE HEAT WARNING MEANS THAT A PROLONGED PERIOD OF DANGEROUSLY HOT TEMPERATURES WILL OCCUR. THE COMBINATION OF HOT TEMPERATURES AND HIGH HUMIDITY WILL COMBINE TO CREATE A DANGEROUS SITUATION IN WHICH HEAT ILLNESSES ARE LIKELY. DRINK PLENTY OF FLUIDS...STAY IN AN AIR-CONDITIONED ROOM...STAY OUT OF THE SUN...AND CHECK UP ON RELATIVES AND NEIGHBORS.",
      "$$",
       ],
    },

    {
    "commentary": "Step4-delete first HT.Y, leaving EH.W and HT.Y",
    "name": "ETNReuse_2e",
    "drtTime": "20101206_2107",
    "gridsStartTime": "20101206_0000",
    "cmdLineVars": None,
    "comboFlag": 0,
    "combinations": None,
    "productType": "Hazard_NPW_Local",
    "createGrids": [
       ("Fcst", "Hazards", "DISCRETE", -100, 100, "<None>", "all"),
       ("Fcst", "Hazards", "DISCRETE", 24+8, 24+17, "EH.W", ["FLZ050","FLZ051"]),
       ("Fcst", "Hazards", "DISCRETE", 24+17, 48+9, "HT.Y", ["FLZ050","FLZ051"]),
       ],
    "checkStrings": [
       "WWUS72 KTBW 062107",
       "NPWTBW",
       "URGENT - WEATHER MESSAGE",
       "NATIONAL WEATHER SERVICE TAMPA BAY RUSKIN FL",
       "407 PM EST MON DEC 6 2010",
       "...|*OVERVIEW HEADLINE (MUST EDIT)*|...",
       ".|*OVERVIEW (MUST EDIT)*|.",
       "FLZ050-051-070515-",
       "/O.CAN.KTBW.HT.Y.0002.000000T0000Z-101207T0800Z/",
       "/O.CON.KTBW.EH.W.0001.101207T0800Z-101207T1700Z/",
       "/O.CON.KTBW.HT.Y.0003.101207T1700Z-101208T0900Z/",
       "PINELLAS-HILLSBOROUGH-",
       "407 PM EST MON DEC 6 2010",
       "...EXCESSIVE HEAT WARNING REMAINS IN EFFECT FROM 3 AM TO NOON EST TUESDAY...",
       "...HEAT ADVISORY REMAINS IN EFFECT FROM NOON TUESDAY TO 4 AM EST WEDNESDAY...",
       "...HEAT ADVISORY IS CANCELLED...",
#       "THE NATIONAL WEATHER SERVICE IN TAMPA BAY RUSKIN HAS CANCELLED THE HEAT ADVISORY. AN EXCESSIVE HEAT WARNING REMAINS IN EFFECT FROM 3 AM TO NOON EST TUESDAY. A HEAT ADVISORY REMAINS IN EFFECT FROM NOON TUESDAY TO 4 AM EST WEDNESDAY. ",
#       "|*|* SEGMENT TEXT GOES HERE *|.*|",
       "AN EXCESSIVE HEAT WARNING MEANS THAT A PROLONGED PERIOD OF DANGEROUSLY HOT TEMPERATURES WILL OCCUR. THE COMBINATION OF HOT TEMPERATURES AND HIGH HUMIDITY WILL COMBINE TO CREATE A DANGEROUS SITUATION IN WHICH HEAT ILLNESSES ARE LIKELY. DRINK PLENTY OF FLUIDS...STAY IN AN AIR-CONDITIONED ROOM...STAY OUT OF THE SUN...AND CHECK UP ON RELATIVES AND NEIGHBORS.",
       "A HEAT ADVISORY MEANS THAT A PERIOD OF HOT TEMPERATURES IS EXPECTED. THE COMBINATION OF HOT TEMPERATURES AND HIGH HUMIDITY WILL COMBINE TO CREATE A SITUATION IN WHICH HEAT ILLNESSES ARE POSSIBLE. DRINK PLENTY OF FLUIDS...STAY IN AN AIR-CONDITIONED ROOM...STAY OUT OF THE SUN...AND CHECK UP ON RELATIVES AND NEIGHBORS.",
       "$$",
       ],
    },

    {
    "commentary": "Step5-create HT.Y again in 1st slot",
    "name": "ETNReuse_2f",
    "drtTime": "20101206_2113",
    "gridsStartTime": "20101206_0000",
    "cmdLineVars": None,
    "comboFlag": 0,
    "combinations": None,
    "productType": "Hazard_NPW_Local",
    "createGrids": [
       ("Fcst", "Hazards", "DISCRETE", -100, 100, "<None>", "all"),
       ("Fcst", "Hazards", "DISCRETE", 23, 24+8, "HT.Y", ["FLZ050","FLZ051"]),
       ("Fcst", "Hazards", "DISCRETE", 24+8, 24+17, "EH.W", ["FLZ050","FLZ051"]),
       ("Fcst", "Hazards", "DISCRETE", 24+17, 48+9, "HT.Y", ["FLZ050","FLZ051"]),
       ],
    "checkStrings": [
      "WWUS72 KTBW 062113",
      "NPWTBW",
      "URGENT - WEATHER MESSAGE",
      "NATIONAL WEATHER SERVICE TAMPA BAY RUSKIN FL",
      "413 PM EST MON DEC 6 2010",
      "...|*OVERVIEW HEADLINE (MUST EDIT)*|...",
      ".|*OVERVIEW (MUST EDIT)*|.",
      "FLZ050-051-070515-",
      "/O.NEW.KTBW.HT.Y.0004.101206T2300Z-101207T0800Z/",
      "/O.CON.KTBW.EH.W.0001.101207T0800Z-101207T1700Z/",
      "/O.CON.KTBW.HT.Y.0003.101207T1700Z-101208T0900Z/",
      "PINELLAS-HILLSBOROUGH-",
      "413 PM EST MON DEC 6 2010",
      "...HEAT ADVISORY IN EFFECT UNTIL 3 AM EST TUESDAY...",
      "...EXCESSIVE HEAT WARNING REMAINS IN EFFECT FROM 3 AM TO NOON EST TUESDAY...",
      "...HEAT ADVISORY REMAINS IN EFFECT FROM NOON TUESDAY TO 4 AM EST WEDNESDAY...",
#      "THE NATIONAL WEATHER SERVICE IN TAMPA BAY RUSKIN HAS ISSUED A HEAT ADVISORY...WHICH IS IN EFFECT UNTIL 3 AM EST TUESDAY. AN EXCESSIVE HEAT WARNING REMAINS IN EFFECT FROM 3 AM TO NOON EST TUESDAY. A HEAT ADVISORY REMAINS IN EFFECT FROM NOON TUESDAY TO 4 AM EST WEDNESDAY. ",
#      "|*|* SEGMENT TEXT GOES HERE *|.*|",
      "AN EXCESSIVE HEAT WARNING MEANS THAT A PROLONGED PERIOD OF DANGEROUSLY HOT TEMPERATURES WILL OCCUR. THE COMBINATION OF HOT TEMPERATURES AND HIGH HUMIDITY WILL COMBINE TO CREATE A DANGEROUS SITUATION IN WHICH HEAT ILLNESSES ARE LIKELY. DRINK PLENTY OF FLUIDS...STAY IN AN AIR-CONDITIONED ROOM...STAY OUT OF THE SUN...AND CHECK UP ON RELATIVES AND NEIGHBORS.",
      "A HEAT ADVISORY MEANS THAT A PERIOD OF HOT TEMPERATURES IS EXPECTED. THE COMBINATION OF HOT TEMPERATURES AND HIGH HUMIDITY WILL COMBINE TO CREATE A SITUATION IN WHICH HEAT ILLNESSES ARE POSSIBLE. DRINK PLENTY OF FLUIDS...STAY IN AN AIR-CONDITIONED ROOM...STAY OUT OF THE SUN...AND CHECK UP ON RELATIVES AND NEIGHBORS.",
      "$$",
       ],
    },

    {
    "commentary": "Step6-remove first HT.Y",
    "name": "ETNReuse_2g",
    "drtTime": "20101206_2115",
    "gridsStartTime": "20101206_0000",
    "cmdLineVars": None,
    "comboFlag": 0,
    "combinations": None,
    "productType": "Hazard_NPW_Local",
    "createGrids": [
       ("Fcst", "Hazards", "DISCRETE", -100, 100, "<None>", "all"),
       ("Fcst", "Hazards", "DISCRETE", 24+8, 24+17, "EH.W", ["FLZ050","FLZ051"]),
       ("Fcst", "Hazards", "DISCRETE", 24+17, 48+9, "HT.Y", ["FLZ050","FLZ051"]),
       ],
    "checkStrings": [
      "WWUS72 KTBW 062115",
      "NPWTBW",
      "URGENT - WEATHER MESSAGE",
      "NATIONAL WEATHER SERVICE TAMPA BAY RUSKIN FL",
      "415 PM EST MON DEC 6 2010",
      "...|*OVERVIEW HEADLINE (MUST EDIT)*|...",
      ".|*OVERVIEW (MUST EDIT)*|.",
      "FLZ050-051-070515-",
      "/O.CAN.KTBW.HT.Y.0004.101206T2300Z-101207T0800Z/",
      "/O.CON.KTBW.EH.W.0001.101207T0800Z-101207T1700Z/",
      "/O.CON.KTBW.HT.Y.0003.101207T1700Z-101208T0900Z/",
      "PINELLAS-HILLSBOROUGH-",
      "415 PM EST MON DEC 6 2010",
      "...EXCESSIVE HEAT WARNING REMAINS IN EFFECT FROM 3 AM TO NOON EST TUESDAY...",
      "...HEAT ADVISORY REMAINS IN EFFECT FROM NOON TUESDAY TO 4 AM EST WEDNESDAY...",
      "...HEAT ADVISORY IS CANCELLED...",
#      "THE NATIONAL WEATHER SERVICE IN TAMPA BAY RUSKIN HAS CANCELLED THE HEAT ADVISORY. AN EXCESSIVE HEAT WARNING REMAINS IN EFFECT FROM 3 AM TO NOON EST TUESDAY. A HEAT ADVISORY REMAINS IN EFFECT FROM NOON TUESDAY TO 4 AM EST WEDNESDAY. ",
#     "|*|*|* SEGMENT TEXT GOES HERE *|.*|*|",
      "AN EXCESSIVE HEAT WARNING MEANS THAT A PROLONGED PERIOD OF DANGEROUSLY HOT TEMPERATURES WILL OCCUR. THE COMBINATION OF HOT TEMPERATURES AND HIGH HUMIDITY WILL COMBINE TO CREATE A DANGEROUS SITUATION IN WHICH HEAT ILLNESSES ARE LIKELY. DRINK PLENTY OF FLUIDS...STAY IN AN AIR-CONDITIONED ROOM...STAY OUT OF THE SUN...AND CHECK UP ON RELATIVES AND NEIGHBORS.",
      "A HEAT ADVISORY MEANS THAT A PERIOD OF HOT TEMPERATURES IS EXPECTED. THE COMBINATION OF HOT TEMPERATURES AND HIGH HUMIDITY WILL COMBINE TO CREATE A SITUATION IN WHICH HEAT ILLNESSES ARE POSSIBLE. DRINK PLENTY OF FLUIDS...STAY IN AN AIR-CONDITIONED ROOM...STAY OUT OF THE SUN...AND CHECK UP ON RELATIVES AND NEIGHBORS.",
      "$$",
       ],
    },

    {
    "commentary": "Step7-put back in part of HT.Y in 1st slot",
    "name": "ETNReuse_2h",
    "drtTime": "20101206_2134",
    "gridsStartTime": "20101206_0000",
    "cmdLineVars": None,
    "comboFlag": 0,
    "combinations": None,
    "productType": "Hazard_NPW_Local",
    "createGrids": [
       ("Fcst", "Hazards", "DISCRETE", -100, 100, "<None>", "all"),
       ("Fcst", "Hazards", "DISCRETE", 21, 24+1, "HT.Y", ["FLZ050","FLZ051"]),
       ("Fcst", "Hazards", "DISCRETE", 24+8, 24+17, "EH.W", ["FLZ050","FLZ051"]),
       ("Fcst", "Hazards", "DISCRETE", 24+17, 48+9, "HT.Y", ["FLZ050","FLZ051"]),
       ],
    "checkStrings": [
      "WWUS72 KTBW 062134",
      "NPWTBW",
      "URGENT - WEATHER MESSAGE",
      "NATIONAL WEATHER SERVICE TAMPA BAY RUSKIN FL",
      "434 PM EST MON DEC 6 2010",
      "...|*OVERVIEW HEADLINE (MUST EDIT)*|...",
      ".|*OVERVIEW (MUST EDIT)*|.",
      "FLZ050-051-070545-",
      "/O.NEW.KTBW.HT.Y.0005.101206T2134Z-101207T0100Z/",
      "/O.CON.KTBW.EH.W.0001.101207T0800Z-101207T1700Z/",
      "/O.CON.KTBW.HT.Y.0003.101207T1700Z-101208T0900Z/",
      "PINELLAS-HILLSBOROUGH-",
      "434 PM EST MON DEC 6 2010",
      "...HEAT ADVISORY IN EFFECT UNTIL 8 PM EST THIS EVENING...",
      "...EXCESSIVE HEAT WARNING REMAINS IN EFFECT FROM 3 AM TO NOON EST TUESDAY...",
      "...HEAT ADVISORY REMAINS IN EFFECT FROM NOON TUESDAY TO 4 AM EST WEDNESDAY...",
#      "THE NATIONAL WEATHER SERVICE IN TAMPA BAY RUSKIN HAS ISSUED A HEAT ADVISORY...WHICH IS IN EFFECT UNTIL 8 PM EST THIS EVENING. AN EXCESSIVE HEAT WARNING REMAINS IN EFFECT FROM 3 AM TO NOON EST TUESDAY. A HEAT ADVISORY REMAINS IN EFFECT FROM NOON TUESDAY TO 4 AM EST WEDNESDAY. ",
#      "|*|*|* SEGMENT TEXT GOES HERE *|.*|*|",
      "AN EXCESSIVE HEAT WARNING MEANS THAT A PROLONGED PERIOD OF DANGEROUSLY HOT TEMPERATURES WILL OCCUR. THE COMBINATION OF HOT TEMPERATURES AND HIGH HUMIDITY WILL COMBINE TO CREATE A DANGEROUS SITUATION IN WHICH HEAT ILLNESSES ARE LIKELY. DRINK PLENTY OF FLUIDS...STAY IN AN AIR-CONDITIONED ROOM...STAY OUT OF THE SUN...AND CHECK UP ON RELATIVES AND NEIGHBORS.",
      "A HEAT ADVISORY MEANS THAT A PERIOD OF HOT TEMPERATURES IS EXPECTED. THE COMBINATION OF HOT TEMPERATURES AND HIGH HUMIDITY WILL COMBINE TO CREATE A SITUATION IN WHICH HEAT ILLNESSES ARE POSSIBLE. DRINK PLENTY OF FLUIDS...STAY IN AN AIR-CONDITIONED ROOM...STAY OUT OF THE SUN...AND CHECK UP ON RELATIVES AND NEIGHBORS.",
      "$$",
       ],
    },

    {
    "commentary": "Deleting hazard grids.",
    "name": "ETNReuse_2i",
    "productType": None,
    "clearHazardsTable": 1,
    "checkStrings": [],
    },

    ]

       
import TestScript
def testScript(self, dataMgr):
    defaults = {
        "database": "<site>_GRID__Official_00000000_0000",
        "publishGrids": 1,
        "decodeVTEC": 1,
        "gridsStartTime": "20100101_0500",
        "orderStrings": 1,
        "vtecMode": "O",
        "comboFlag": 1,
        "combinations": [(["GMZ870"],"")],
        "cmdLineVars": "{('Product Issuance', 'productIssuance'): 'Morning', ('Issued By', 'issuedBy'): None}",
        "deleteGrids": [("Fcst", "Hazards", "SFC", "all", "all")],
        }
    return TestScript.generalTestScript(self, dataMgr, scripts, defaults)



