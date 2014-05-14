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


#
# Adapter for com.raytheon.uf.common.message.WsId
#  
#    
#     SOFTWARE HISTORY
#    
#    Date            Ticket#       Engineer       Description
#    ------------    ----------    -----------    --------------------------
#    09/16/10                      dgilling       Initial Creation.
#    
# 
#


import calendar
from dynamicserialize.dstypes.com.raytheon.uf.common.time import TimeRange


# class adapters are broken, let's use a Field adapter instead
ClassAdapter = 'com.raytheon.uf.common.time.TimeRange'


def serialize(context, timeRange):
    context.writeI64(calendar.timegm(timeRange.getStart()) * 1000.0)
    context.writeI64(calendar.timegm(timeRange.getEnd()) * 1000.0)

def deserialize(context):
    startTime = context.readI64()
    endTime  = context.readI64()
    
    timeRange = TimeRange()
    timeRange.setStart(startTime/1000.0)
    timeRange.setEnd(endTime/1000.0)
    
    return timeRange
