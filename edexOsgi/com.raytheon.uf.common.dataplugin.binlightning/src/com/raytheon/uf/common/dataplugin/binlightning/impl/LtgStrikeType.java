/**
 * This software was developed and / or modified by Raytheon Company,
 * pursuant to Contract DG133W-05-CQ-1067 with the US Government.
 * 
 * U.S. EXPORT CONTROLLED TECHNICAL DATA
 * This software product contains export-restricted data whose
 * export/transfer/disclosure is restricted by U.S. law. Dissemination
 * to non-U.S. persons whether in the United States or abroad requires
 * an export license or other authorization.
 * 
 * Contractor Name:        Raytheon Company
 * Contractor Address:     6825 Pine Street, Suite 340
 *                         Mail Stop B8
 *                         Omaha, NE 68106
 *                         402.291.0100
 * 
 * See the AWIPS II Master Rights File ("Master Rights File.pdf") for
 * further licensing information.
 **/
package com.raytheon.uf.common.dataplugin.binlightning.impl;

/**
 * Enums for the lightning strike type, cloud-to-cloud or cloud-to-ground.
 * 
 * <pre>
 *
 * SOFTWARE HISTORY
 *
 * Date         Ticket#    Engineer    Description
 * ------------ ---------- ----------- --------------------------
 * 20070810            379 jkorman     Initial Coding from prototype.
 * 20130425        DCS 112 Wufeng Zhou Added STRIKE_TF (for Total Flash) in definition for Total Flash 
 * 
 * </pre>
 *
 * @author jkorman
 * @version 1.0
 */
public enum LtgStrikeType
{
    STRIKE_CC("CC"),
    STRIKE_CG("CG"),
    STRIKE_TF("TF");
    
    private final String strikeType;
    
    /**
     * Construct the type.
     * @param type Lightning strike type.
     */
    private LtgStrikeType(String type)
    {
        strikeType = type;
    }
    
    /**
     * Get the strike type value.
     * @return The strike type value.
     */
    public String getType()
    {
        return strikeType;
    }
}