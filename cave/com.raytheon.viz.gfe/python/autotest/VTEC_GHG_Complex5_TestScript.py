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
# More VT?EC_GHG Complex Hazard Tests 
#
# Author:
# ----------------------------------------------------------------------------

scripts = [
    {
    "commentary": "Clear out all Hazards Table and Grids.", 
    "name": "GHG_Complex5_0",
    "productType": None,
    "clearHazardsTable": 1,
    "checkStrings": [],
    },
    {
    
    "commentary": """
    Creating a WS.A hazard for Area1, Area2, Area3, and Area4
    Note that the ETN number illustrates the Area (:1, :2, :3, :4)
    During this run Area3 and Area4 are combined into the same segment
    Area1 (FLZ039, FLZ042) 24-53
    Area2 (FLZ052) 24-53
    Area3 (FLZ061) 24-53
    Area4 (FLZ062) 24-53
    """,
    
    "name": "GHG_Complex5_1",
    "productType": "Hazard_WSW_Local",
    "createGrids": [
        ("Fcst", "Hazards", "DISCRETE", -100, 100, "<None>", "all"),
        ("Fcst", "Hazards", "DISCRETE", 24, 53, "WS.A:1", ["FLZ039", "FLZ042"]),
        ("Fcst", "Hazards", "DISCRETE", 24, 53, "WS.A:2", ["FLZ052"]),
        ("Fcst", "Hazards", "DISCRETE", 24, 53, "WS.A:3", ["FLZ061", "FLZ062"]),
        ],
    "checkStrings": [
      "WWUS42 KTBW 010000",
      "WSWTBW",
      "URGENT - WINTER WEATHER MESSAGE",
      "NATIONAL WEATHER SERVICE TAMPA BAY RUSKIN FL",
      "700 PM EST THU DEC 31 2009",
      "...|*OVERVIEW HEADLINE (MUST EDIT)*|...",
      ".|*OVERVIEW (MUST EDIT)*|.",
      "FLZ039-042-010800-",
      "/O.NEW.KTBW.WS.A.0001.100102T0000Z-100103T0500Z/",
      "LEVY-CITRUS-",
      "700 PM EST THU DEC 31 2009",
      "...WINTER STORM WATCH IN EFFECT FROM FRIDAY EVENING THROUGH SATURDAY EVENING...",
      "THE NATIONAL WEATHER SERVICE IN TAMPA BAY RUSKIN HAS ISSUED A WINTER STORM WATCH...WHICH IS IN EFFECT FROM FRIDAY EVENING THROUGH SATURDAY EVENING. ",
#      "|* SEGMENT TEXT GOES HERE *|.",
      "PRECAUTIONARY/PREPAREDNESS ACTIONS...",
      "A WINTER STORM WATCH MEANS THERE IS A POTENTIAL FOR SIGNIFICANT SNOW...SLEET...OR ICE ACCUMULATIONS THAT MAY IMPACT TRAVEL. CONTINUE TO MONITOR THE LATEST FORECASTS.",
      "&&",
      "$$",
      "FLZ052-010800-",
      "/O.NEW.KTBW.WS.A.0001.100102T0000Z-100103T0500Z/",
      "POLK-",
      "700 PM EST THU DEC 31 2009",
      "...WINTER STORM WATCH IN EFFECT FROM FRIDAY EVENING THROUGH SATURDAY EVENING...",
      "THE NATIONAL WEATHER SERVICE IN TAMPA BAY RUSKIN HAS ISSUED A WINTER STORM WATCH...WHICH IS IN EFFECT FROM FRIDAY EVENING THROUGH SATURDAY EVENING. ",
      "|* SEGMENT TEXT GOES HERE *|.",
      "PRECAUTIONARY/PREPAREDNESS ACTIONS...",
      "A WINTER STORM WATCH MEANS THERE IS A POTENTIAL FOR SIGNIFICANT SNOW...SLEET...OR ICE ACCUMULATIONS THAT MAY IMPACT TRAVEL. CONTINUE TO MONITOR THE LATEST FORECASTS.",
      "&&",
      "$$",
      "FLZ061-062-010800-",
      "/O.NEW.KTBW.WS.A.0001.100102T0000Z-100103T0500Z/",
      "DE SOTO-CHARLOTTE-",
      "700 PM EST THU DEC 31 2009",
      "...WINTER STORM WATCH IN EFFECT FROM FRIDAY EVENING THROUGH SATURDAY EVENING...",
      "THE NATIONAL WEATHER SERVICE IN TAMPA BAY RUSKIN HAS ISSUED A WINTER STORM WATCH...WHICH IS IN EFFECT FROM FRIDAY EVENING THROUGH SATURDAY EVENING. ",
      "|* SEGMENT TEXT GOES HERE *|.",
      "PRECAUTIONARY/PREPAREDNESS ACTIONS...",
      "A WINTER STORM WATCH MEANS THERE IS A POTENTIAL FOR SIGNIFICANT SNOW...SLEET...OR ICE ACCUMULATIONS THAT MAY IMPACT TRAVEL. CONTINUE TO MONITOR THE LATEST FORECASTS.",
      "&&",
      "$$",
                     ],
    },
    {
    "commentary": "No changes are made to the existing hazards.",
    "name": "GHG_Complex5_2",
    "productType": "Hazard_WSW_Local",
    "deleteGrids": [],
    "checkStrings": [
      "WWUS42 KTBW 010000",
      "WSWTBW",
      "URGENT - WINTER WEATHER MESSAGE",
      "NATIONAL WEATHER SERVICE TAMPA BAY RUSKIN FL",
      "700 PM EST THU DEC 31 2009",
      "...|*OVERVIEW HEADLINE (MUST EDIT)*|...",
      ".|*OVERVIEW (MUST EDIT)*|.",
      "FLZ039-042-010800-",
      "/O.CON.KTBW.WS.A.0001.100102T0000Z-100103T0500Z/",
      "LEVY-CITRUS-",
      "700 PM EST THU DEC 31 2009",
      "...WINTER STORM WATCH REMAINS IN EFFECT FROM FRIDAY EVENING THROUGH SATURDAY EVENING...",
      "A WINTER STORM WATCH REMAINS IN EFFECT FROM FRIDAY EVENING THROUGH SATURDAY EVENING. ",
#      "|* SEGMENT TEXT GOES HERE *|.",
      "PRECAUTIONARY/PREPAREDNESS ACTIONS...",
      "A WINTER STORM WATCH MEANS THERE IS A POTENTIAL FOR SIGNIFICANT SNOW...SLEET...OR ICE ACCUMULATIONS THAT MAY IMPACT TRAVEL. CONTINUE TO MONITOR THE LATEST FORECASTS.",
      "&&",
      "$$",
      "FLZ052-010800-",
      "/O.CON.KTBW.WS.A.0001.100102T0000Z-100103T0500Z/",
      "POLK-",
      "700 PM EST THU DEC 31 2009",
      "...WINTER STORM WATCH REMAINS IN EFFECT FROM FRIDAY EVENING THROUGH SATURDAY EVENING...",
      "A WINTER STORM WATCH REMAINS IN EFFECT FROM FRIDAY EVENING THROUGH SATURDAY EVENING. ",
#      "|* SEGMENT TEXT GOES HERE *|.",
      "PRECAUTIONARY/PREPAREDNESS ACTIONS...",
      "A WINTER STORM WATCH MEANS THERE IS A POTENTIAL FOR SIGNIFICANT SNOW...SLEET...OR ICE ACCUMULATIONS THAT MAY IMPACT TRAVEL. CONTINUE TO MONITOR THE LATEST FORECASTS.",
      "&&",
      "$$",
      "FLZ061-062-010800-",
      "/O.CON.KTBW.WS.A.0001.100102T0000Z-100103T0500Z/",
      "DE SOTO-CHARLOTTE-",
      "700 PM EST THU DEC 31 2009",
      "...WINTER STORM WATCH REMAINS IN EFFECT FROM FRIDAY EVENING THROUGH SATURDAY EVENING...",
      "A WINTER STORM WATCH REMAINS IN EFFECT FROM FRIDAY EVENING THROUGH SATURDAY EVENING. ",
#      "|* SEGMENT TEXT GOES HERE *|.",
      "PRECAUTIONARY/PREPAREDNESS ACTIONS...",
      "A WINTER STORM WATCH MEANS THERE IS A POTENTIAL FOR SIGNIFICANT SNOW...SLEET...OR ICE ACCUMULATIONS THAT MAY IMPACT TRAVEL. CONTINUE TO MONITOR THE LATEST FORECASTS.",
      "&&",
      "$$",
                     ],
    },
    {

    "commentary": """
    Upgrading the WS.A hazard to a WS.W hazard in all Areas
    Area2, Area3, and Area4 have new start times
    Area2 (FLZ052) 27-53
    Area3 (FLZ061) 27-53
    Area4 (FLZ062) 36-53
    Note that we had to condense the times into 3 time ranges to accomodate the overlapping
    """,
    
    "name": "GHG_Complex5_3",
    "productType": "Hazard_WSW_Local",
    "createGrids": [
        ("Fcst", "Hazards", "DISCRETE", -100, 100, "<None>", "all"),
        ("Fcst", "Hazards", "DISCRETE", 24, 27, "WS.W:1", ["FLZ039", "FLZ042"]),
        ("Fcst", "Hazards", "DISCRETE", 27, 36, "WS.W:1", ["FLZ039", "FLZ042"]),
        ("Fcst", "Hazards", "DISCRETE", 27, 36, "WS.W:2", ["FLZ052"]),
        ("Fcst", "Hazards", "DISCRETE", 27, 36, "WS.W:3", ["FLZ061"]),
        ("Fcst", "Hazards", "DISCRETE", 36, 53, "WS.W:1", ["FLZ039", "FLZ042"]),
        ("Fcst", "Hazards", "DISCRETE", 36, 53, "WS.W:2", ["FLZ052"]),
        ("Fcst", "Hazards", "DISCRETE", 36, 53, "WS.W:3", ["FLZ061"]),
        ("Fcst", "Hazards", "DISCRETE", 36, 53, "WS.W:4", ["FLZ062"]),
        ],
    "checkStrings": [
      "WWUS42 KTBW 010000",
      "WSWTBW",
      "URGENT - WINTER WEATHER MESSAGE",
      "NATIONAL WEATHER SERVICE TAMPA BAY RUSKIN FL",
      "700 PM EST THU DEC 31 2009",
      "...|*OVERVIEW HEADLINE (MUST EDIT)*|...",
      ".|*OVERVIEW (MUST EDIT)*|.",
      "FLZ039-042-010800-",
      "/O.UPG.KTBW.WS.A.0001.100102T0000Z-100103T0500Z/",
      "/O.NEW.KTBW.WS.W.0001.100102T0000Z-100103T0500Z/",
      "LEVY-CITRUS-",
      "700 PM EST THU DEC 31 2009",
      "...WINTER STORM WARNING IN EFFECT FROM 7 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT...",
#      "THE NATIONAL WEATHER SERVICE IN TAMPA BAY RUSKIN HAS ISSUED A WINTER STORM WARNING...WHICH IS IN EFFECT FROM 7 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT. THE WINTER STORM WATCH IS NO LONGER IN EFFECT. ",
#      "|*|* SEGMENT TEXT GOES HERE *|.*|",
      "PRECAUTIONARY/PREPAREDNESS ACTIONS...",
#      "A WINTER STORM WARNING MEANS SIGNIFICANT AMOUNTS OF SNOW...SLEET...AND ICE ARE EXPECTED OR OCCURRING. STRONG WINDS ARE ALSO POSSIBLE. THIS WILL MAKE TRAVEL VERY HAZARDOUS OR IMPOSSIBLE.",
      "&&",
      "$$",
      "FLZ052-010800-",
      "/O.UPG.KTBW.WS.A.0001.100102T0000Z-100103T0500Z/",
      "/O.NEW.KTBW.WS.W.0001.100102T0300Z-100103T0500Z/",
      "POLK-",
      "INCLUDING THE CITIES OF...LAKELAND...WINTER HAVEN",
      "700 PM EST THU DEC 31 2009",
      "...WINTER STORM WARNING IN EFFECT FROM 10 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT...",
#      "THE NATIONAL WEATHER SERVICE IN TAMPA BAY RUSKIN HAS ISSUED A WINTER STORM WARNING...WHICH IS IN EFFECT FROM 10 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT. THE WINTER STORM WATCH IS NO LONGER IN EFFECT. ",
#      "|*|* SEGMENT TEXT GOES HERE *|.*|",
      "PRECAUTIONARY/PREPAREDNESS ACTIONS...",
#      "A WINTER STORM WARNING MEANS SIGNIFICANT AMOUNTS OF SNOW...SLEET...AND ICE ARE EXPECTED OR OCCURRING. STRONG WINDS ARE ALSO POSSIBLE. THIS WILL MAKE TRAVEL VERY HAZARDOUS OR IMPOSSIBLE.",
      "&&",
      "$$",
      "FLZ061-010800-",
      "/O.UPG.KTBW.WS.A.0001.100102T0000Z-100103T0500Z/",
      "/O.NEW.KTBW.WS.W.0001.100102T0300Z-100103T0500Z/",
      "DE SOTO-",
      "700 PM EST THU DEC 31 2009",
      "...WINTER STORM WARNING IN EFFECT FROM 10 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT...",
#      "THE NATIONAL WEATHER SERVICE IN TAMPA BAY RUSKIN HAS ISSUED A WINTER STORM WARNING...WHICH IS IN EFFECT FROM 10 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT. THE WINTER STORM WATCH IS NO LONGER IN EFFECT. ",
#      "|*|* SEGMENT TEXT GOES HERE *|.*|",
      "PRECAUTIONARY/PREPAREDNESS ACTIONS...",
#      "A WINTER STORM WARNING MEANS SIGNIFICANT AMOUNTS OF SNOW...SLEET...AND ICE ARE EXPECTED OR OCCURRING. STRONG WINDS ARE ALSO POSSIBLE. THIS WILL MAKE TRAVEL VERY HAZARDOUS OR IMPOSSIBLE.",
      "&&",
      "$$",
      "FLZ062-010800-",
      "/O.UPG.KTBW.WS.A.0001.100102T0000Z-100103T0500Z/",
      "/O.NEW.KTBW.WS.W.0001.100102T1200Z-100103T0500Z/",
      "CHARLOTTE-",
      "700 PM EST THU DEC 31 2009",
      "...WINTER STORM WARNING IN EFFECT FROM 7 AM SATURDAY TO MIDNIGHT EST SATURDAY NIGHT...",
#      "THE NATIONAL WEATHER SERVICE IN TAMPA BAY RUSKIN HAS ISSUED A WINTER STORM WARNING...WHICH IS IN EFFECT FROM 7 AM SATURDAY TO MIDNIGHT EST SATURDAY NIGHT. THE WINTER STORM WATCH IS NO LONGER IN EFFECT. ",
#      "|*|* SEGMENT TEXT GOES HERE *|.*|",
      "PRECAUTIONARY/PREPAREDNESS ACTIONS...",
#      "A WINTER STORM WARNING MEANS SIGNIFICANT AMOUNTS OF SNOW...SLEET...AND ICE ARE EXPECTED OR OCCURRING. STRONG WINDS ARE ALSO POSSIBLE. THIS WILL MAKE TRAVEL VERY HAZARDOUS OR IMPOSSIBLE.",
      "&&",
      "$$",
                     ],
    },
    {
    "commentary": "No changes are made to the existing hazards.",
    "name": "GHG_Complex5_4",
    "productType": "Hazard_WSW_Local",
    "deleteGrids": [],        
    "checkStrings": [
      "WWUS42 KTBW 010000",
      "WSWTBW",
      "URGENT - WINTER WEATHER MESSAGE",
      "NATIONAL WEATHER SERVICE TAMPA BAY RUSKIN FL",
      "700 PM EST THU DEC 31 2009",
      "...|*OVERVIEW HEADLINE (MUST EDIT)*|...",
      ".|*OVERVIEW (MUST EDIT)*|.",
      "FLZ039-042-010800-",
      "/O.CON.KTBW.WS.W.0001.100102T0000Z-100103T0500Z/",
      "LEVY-CITRUS-",
      "700 PM EST THU DEC 31 2009",
      "...WINTER STORM WARNING REMAINS IN EFFECT FROM 7 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT...",
      "A WINTER STORM WARNING REMAINS IN EFFECT FROM 7 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT. ",
#      "|*|* SEGMENT TEXT GOES HERE *|.*|",
      "PRECAUTIONARY/PREPAREDNESS ACTIONS...",
#      "A WINTER STORM WARNING MEANS SIGNIFICANT AMOUNTS OF SNOW...SLEET...AND ICE ARE EXPECTED OR OCCURRING. STRONG WINDS ARE ALSO POSSIBLE. THIS WILL MAKE TRAVEL VERY HAZARDOUS OR IMPOSSIBLE.",
      "&&",
      "$$",
      "FLZ052-010800-",
      "/O.CON.KTBW.WS.W.0001.100102T0300Z-100103T0500Z/",
      "POLK-",
      "700 PM EST THU DEC 31 2009",
      "...WINTER STORM WARNING REMAINS IN EFFECT FROM 10 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT...",
      "A WINTER STORM WARNING REMAINS IN EFFECT FROM 10 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT. ",
#      "|*|* SEGMENT TEXT GOES HERE *|.*|",
      "PRECAUTIONARY/PREPAREDNESS ACTIONS...",
#      "A WINTER STORM WARNING MEANS SIGNIFICANT AMOUNTS OF SNOW...SLEET...AND ICE ARE EXPECTED OR OCCURRING. STRONG WINDS ARE ALSO POSSIBLE. THIS WILL MAKE TRAVEL VERY HAZARDOUS OR IMPOSSIBLE.",
      "&&",
      "$$",
      "FLZ061-010800-",
      "/O.CON.KTBW.WS.W.0001.100102T0300Z-100103T0500Z/",
      "DE SOTO-",
      "700 PM EST THU DEC 31 2009",
      "...WINTER STORM WARNING REMAINS IN EFFECT FROM 10 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT...",
      "A WINTER STORM WARNING REMAINS IN EFFECT FROM 10 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT. ",
#      "|*|* SEGMENT TEXT GOES HERE *|.*|",
      "PRECAUTIONARY/PREPAREDNESS ACTIONS...",
#      "A WINTER STORM WARNING MEANS SIGNIFICANT AMOUNTS OF SNOW...SLEET...AND ICE ARE EXPECTED OR OCCURRING. STRONG WINDS ARE ALSO POSSIBLE. THIS WILL MAKE TRAVEL VERY HAZARDOUS OR IMPOSSIBLE.",
      "&&",
      "$$",
      "FLZ062-010800-",
      "/O.CON.KTBW.WS.W.0001.100102T1200Z-100103T0500Z/",
      "CHARLOTTE-",
      "700 PM EST THU DEC 31 2009",
      "...WINTER STORM WARNING REMAINS IN EFFECT FROM 7 AM SATURDAY TO MIDNIGHT EST SATURDAY NIGHT...",
      "A WINTER STORM WARNING REMAINS IN EFFECT FROM 7 AM SATURDAY TO MIDNIGHT EST SATURDAY NIGHT. ",
#      "|*|* SEGMENT TEXT GOES HERE *|.*|",
      "PRECAUTIONARY/PREPAREDNESS ACTIONS...",
#      "A WINTER STORM WARNING MEANS SIGNIFICANT AMOUNTS OF SNOW...SLEET...AND ICE ARE EXPECTED OR OCCURRING. STRONG WINDS ARE ALSO POSSIBLE. THIS WILL MAKE TRAVEL VERY HAZARDOUS OR IMPOSSIBLE.",
      "&&",
      "$$",
                     ],
    },
    {

    "commentary": """
    Replacing a portion of the WS.W hazard in Area1 with a BZ.W hazard
    Area1 (FLZ042) 24-53
    Replacing the WS.W hazard in Area2 with a WW.Y hazard
    Area2 (FLZ052) 27-53
    """,
    
    "name": "GHG_Complex5_5",
    "productType": "Hazard_WSW_Local",
    "createGrids": [
        ("Fcst", "Hazards", "DISCRETE", -100, 100, "<None>", "all"),
        ("Fcst", "Hazards", "DISCRETE", 24, 27, "WS.W:1", ["FLZ039"]),
        ("Fcst", "Hazards", "DISCRETE", 24, 27, "BZ.W:^WS.W:1", ["FLZ042"]),
        ("Fcst", "Hazards", "DISCRETE", 27, 36, "WS.W:1", ["FLZ039"]),
        ("Fcst", "Hazards", "DISCRETE", 27, 36, "BZ.W:^WS.W:1", ["FLZ042"]),
        ("Fcst", "Hazards", "DISCRETE", 27, 36, "WW.Y", ["FLZ052"]),
        ("Fcst", "Hazards", "DISCRETE", 27, 36, "WS.W:3", ["FLZ061"]),
        ("Fcst", "Hazards", "DISCRETE", 36, 53, "WS.W:1", ["FLZ039"]),
        ("Fcst", "Hazards", "DISCRETE", 36, 53, "BZ.W:^WS.W:1", ["FLZ042"]),
        ("Fcst", "Hazards", "DISCRETE", 36, 53, "WW.Y", ["FLZ052"]),
        ("Fcst", "Hazards", "DISCRETE", 36, 53, "WS.W:3", ["FLZ061"]),
        ("Fcst", "Hazards", "DISCRETE", 36, 53, "WS.W:4", ["FLZ062"]),
        ],
    "checkStrings": [
      "WWUS42 KTBW 010000",
      "WSWTBW",
      "URGENT - WINTER WEATHER MESSAGE",
      "NATIONAL WEATHER SERVICE TAMPA BAY RUSKIN FL",
      "700 PM EST THU DEC 31 2009",
      "...|*OVERVIEW HEADLINE (MUST EDIT)*|...",
      ".|*OVERVIEW (MUST EDIT)*|.",
      "FLZ042-010800-",
      "/O.CAN.KTBW.WS.W.0001.100102T0000Z-100103T0500Z/",
      "/O.NEW.KTBW.BZ.W.0001.100102T0000Z-100103T0500Z/",
      "CITRUS-",
      "700 PM EST THU DEC 31 2009",
      "...BLIZZARD WARNING IN EFFECT FROM 7 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT...",
      "...WINTER STORM WARNING IS CANCELLED...",
      "THE NATIONAL WEATHER SERVICE IN TAMPA BAY RUSKIN HAS ISSUED A BLIZZARD WARNING...WHICH IS IN EFFECT FROM 7 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT. THE WINTER STORM WARNING HAS BEEN CANCELLED. ",
#      "|*|*|* SEGMENT TEXT GOES HERE *|.*|*|",
      "PRECAUTIONARY/PREPAREDNESS ACTIONS...",
      "A BLIZZARD WARNING MEANS SEVERE WINTER WEATHER CONDITIONS ARE EXPECTED OR OCCURRING. FALLING AND BLOWING SNOW WITH STRONG WINDS AND POOR VISIBILITIES ARE LIKELY. THIS WILL LEAD TO WHITEOUT CONDITIONS...MAKING TRAVEL EXTREMELY DANGEROUS. DO NOT TRAVEL. IF YOU MUST TRAVEL...HAVE A WINTER SURVIVAL KIT WITH YOU. IF YOU GET STRANDED...STAY WITH YOUR VEHICLE.",
      "&&",
      "$$",
      "FLZ052-010800-",
      "/O.CAN.KTBW.WS.W.0001.100102T0300Z-100103T0500Z/",
      "/O.NEW.KTBW.WW.Y.0001.100102T0300Z-100103T0500Z/",
      "POLK-",
      "700 PM EST THU DEC 31 2009",
      "...WINTER WEATHER ADVISORY IN EFFECT FROM 10 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT...",
      "...WINTER STORM WARNING IS CANCELLED...",
#      "THE NATIONAL WEATHER SERVICE IN TAMPA BAY RUSKIN HAS ISSUED A WINTER WEATHER ADVISORY...WHICH IS IN EFFECT FROM 10 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT. THE WINTER STORM WARNING HAS BEEN CANCELLED. ",
#      "|*|*|* SEGMENT TEXT GOES HERE *|.*|*|",
      "PRECAUTIONARY/PREPAREDNESS ACTIONS...",
#      "A WINTER WEATHER ADVISORY MEANS THAT PERIODS OF SNOW...SLEET...OR FREEZING RAIN WILL CAUSE TRAVEL DIFFICULTIES. BE PREPARED FOR SLIPPERY ROADS AND LIMITED VISIBILITIES...AND USE CAUTION WHILE DRIVING.",
      "&&",
      "$$",
      "FLZ039-010800-",
      "/O.CON.KTBW.WS.W.0001.100102T0000Z-100103T0500Z/",
      "LEVY-",
      "700 PM EST THU DEC 31 2009",
      "...WINTER STORM WARNING REMAINS IN EFFECT FROM 7 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT...",
      "A WINTER STORM WARNING REMAINS IN EFFECT FROM 7 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT. ",
#      "|*|* SEGMENT TEXT GOES HERE *|.*|",
      "PRECAUTIONARY/PREPAREDNESS ACTIONS...",
#      "A WINTER STORM WARNING MEANS SIGNIFICANT AMOUNTS OF SNOW...SLEET...AND ICE ARE EXPECTED OR OCCURRING. STRONG WINDS ARE ALSO POSSIBLE. THIS WILL MAKE TRAVEL VERY HAZARDOUS OR IMPOSSIBLE.",
      "&&",
      "$$",
      "FLZ061-010800-",
      "/O.CON.KTBW.WS.W.0001.100102T0300Z-100103T0500Z/",
      "DE SOTO-",
      "700 PM EST THU DEC 31 2009",
      "...WINTER STORM WARNING REMAINS IN EFFECT FROM 10 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT...",
      "A WINTER STORM WARNING REMAINS IN EFFECT FROM 10 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT. ",
#      "|*|* SEGMENT TEXT GOES HERE *|.*|",
      "PRECAUTIONARY/PREPAREDNESS ACTIONS...",
#      "A WINTER STORM WARNING MEANS SIGNIFICANT AMOUNTS OF SNOW...SLEET...AND ICE ARE EXPECTED OR OCCURRING. STRONG WINDS ARE ALSO POSSIBLE. THIS WILL MAKE TRAVEL VERY HAZARDOUS OR IMPOSSIBLE.",
      "&&",
      "$$",
      "FLZ062-010800-",
      "/O.CON.KTBW.WS.W.0001.100102T1200Z-100103T0500Z/",
      "CHARLOTTE-",
      "700 PM EST THU DEC 31 2009",
      "...WINTER STORM WARNING REMAINS IN EFFECT FROM 7 AM SATURDAY TO MIDNIGHT EST SATURDAY NIGHT...",
      "A WINTER STORM WARNING REMAINS IN EFFECT FROM 7 AM SATURDAY TO MIDNIGHT EST SATURDAY NIGHT. ",
#      "|*|* SEGMENT TEXT GOES HERE *|.*|",
      "PRECAUTIONARY/PREPAREDNESS ACTIONS...",
#      "A WINTER STORM WARNING MEANS SIGNIFICANT AMOUNTS OF SNOW...SLEET...AND ICE ARE EXPECTED OR OCCURRING. STRONG WINDS ARE ALSO POSSIBLE. THIS WILL MAKE TRAVEL VERY HAZARDOUS OR IMPOSSIBLE.",
      "&&",
      "$$",
                     ],
    },
    {
    "commentary": "No changes are made to the existing hazards.",
    "name": "GHG_Complex5_6",
    "productType": "Hazard_WSW_Local",
    "deleteGrids": [],
    "checkStrings": [
      "WWUS42 KTBW 010000",
      "WSWTBW",
      "URGENT - WINTER WEATHER MESSAGE",
      "NATIONAL WEATHER SERVICE TAMPA BAY RUSKIN FL",
      "700 PM EST THU DEC 31 2009",
      "...|*OVERVIEW HEADLINE (MUST EDIT)*|...",
      ".|*OVERVIEW (MUST EDIT)*|.",
      "FLZ042-010800-",
      "/O.CON.KTBW.BZ.W.0001.100102T0000Z-100103T0500Z/",
      "CITRUS-",
      "700 PM EST THU DEC 31 2009",
      "...BLIZZARD WARNING REMAINS IN EFFECT FROM 7 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT...",
      "A BLIZZARD WARNING REMAINS IN EFFECT FROM 7 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT. ",
#      "|*|*|* SEGMENT TEXT GOES HERE *|.*|*|",
      "PRECAUTIONARY/PREPAREDNESS ACTIONS...",
      "A BLIZZARD WARNING MEANS SEVERE WINTER WEATHER CONDITIONS ARE EXPECTED OR OCCURRING. FALLING AND BLOWING SNOW WITH STRONG WINDS AND POOR VISIBILITIES ARE LIKELY. THIS WILL LEAD TO WHITEOUT CONDITIONS...MAKING TRAVEL EXTREMELY DANGEROUS. DO NOT TRAVEL. IF YOU MUST TRAVEL...HAVE A WINTER SURVIVAL KIT WITH YOU. IF YOU GET STRANDED...STAY WITH YOUR VEHICLE.",
      "&&",
      "$$",
      "FLZ039-010800-",
      "/O.CON.KTBW.WS.W.0001.100102T0000Z-100103T0500Z/",
      "LEVY-",
      "700 PM EST THU DEC 31 2009",
      "...WINTER STORM WARNING REMAINS IN EFFECT FROM 7 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT...",
      "A WINTER STORM WARNING REMAINS IN EFFECT FROM 7 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT. ",
#      "|*|* SEGMENT TEXT GOES HERE *|.*|",
#      "A WINTER STORM WARNING MEANS SIGNIFICANT AMOUNTS OF SNOW...SLEET...AND ICE ARE EXPECTED OR OCCURRING. STRONG WINDS ARE ALSO POSSIBLE. THIS WILL MAKE TRAVEL VERY HAZARDOUS OR IMPOSSIBLE.",
      "$$",
      "FLZ061-010800-",
      "/O.CON.KTBW.WS.W.0001.100102T0300Z-100103T0500Z/",
      "DE SOTO-",
      "700 PM EST THU DEC 31 2009",
      "...WINTER STORM WARNING REMAINS IN EFFECT FROM 10 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT...",
      "A WINTER STORM WARNING REMAINS IN EFFECT FROM 10 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT. ",
#      "|*|* SEGMENT TEXT GOES HERE *|.*|",
      "PRECAUTIONARY/PREPAREDNESS ACTIONS...",
#      "A WINTER STORM WARNING MEANS SIGNIFICANT AMOUNTS OF SNOW...SLEET...AND ICE ARE EXPECTED OR OCCURRING. STRONG WINDS ARE ALSO POSSIBLE. THIS WILL MAKE TRAVEL VERY HAZARDOUS OR IMPOSSIBLE.",
      "&&",
      "$$",
      "FLZ062-010800-",
      "/O.CON.KTBW.WS.W.0001.100102T1200Z-100103T0500Z/",
      "CHARLOTTE-",
      "700 PM EST THU DEC 31 2009",
      "...WINTER STORM WARNING REMAINS IN EFFECT FROM 7 AM SATURDAY TO MIDNIGHT EST SATURDAY NIGHT...",
      "A WINTER STORM WARNING REMAINS IN EFFECT FROM 7 AM SATURDAY TO MIDNIGHT EST SATURDAY NIGHT. ",
#      "|*|* SEGMENT TEXT GOES HERE *|.*|",
      "PRECAUTIONARY/PREPAREDNESS ACTIONS...",
#      "A WINTER STORM WARNING MEANS SIGNIFICANT AMOUNTS OF SNOW...SLEET...AND ICE ARE EXPECTED OR OCCURRING. STRONG WINDS ARE ALSO POSSIBLE. THIS WILL MAKE TRAVEL VERY HAZARDOUS OR IMPOSSIBLE.",
      "&&",
      "$$",
      "FLZ052-010800-",
      "/O.CON.KTBW.WW.Y.0001.100102T0300Z-100103T0500Z/",
      "POLK-",
      "700 PM EST THU DEC 31 2009",
      "...WINTER WEATHER ADVISORY REMAINS IN EFFECT FROM 10 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT...",
      "A WINTER WEATHER ADVISORY REMAINS IN EFFECT FROM 10 PM FRIDAY TO MIDNIGHT EST SATURDAY NIGHT. ",
#      "|*|*|* SEGMENT TEXT GOES HERE *|.*|*|",
      "PRECAUTIONARY/PREPAREDNESS ACTIONS...",
#      "A WINTER WEATHER ADVISORY MEANS THAT PERIODS OF SNOW...SLEET...OR FREEZING RAIN WILL CAUSE TRAVEL DIFFICULTIES. BE PREPARED FOR SLIPPERY ROADS AND LIMITED VISIBILITIES...AND USE CAUTION WHILE DRIVING.",
      "&&",
      "$$",
                     ],
    }, 
    {
    "commentary": "Canceling out all hazards.",
    "name": "GHG_Complex5_7",
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
        "gridsStartTime": "20100101_0000",
        "orderStrings": 1,
        "cmdLineVars": "{('Issued By', 'issuedBy'): None}",
        "deleteGrids": [("Fcst", "Hazards", "SFC", "all", "all")],
        }
    return TestScript.generalTestScript(self, dataMgr, scripts, defaults)


