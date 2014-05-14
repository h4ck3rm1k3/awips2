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
package com.raytheon.uf.viz.collaboration.ui.actions;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

import org.eclipse.ecf.core.user.IUser;
import org.eclipse.ecf.presence.IPresence;
import org.eclipse.ecf.presence.IPresence.Type;
import org.eclipse.jface.action.Action;
import org.eclipse.jface.action.ActionContributionItem;
import org.eclipse.jface.action.IContributionItem;
import org.eclipse.jface.action.IMenuCreator;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Menu;

import com.raytheon.uf.common.status.IUFStatusHandler;
import com.raytheon.uf.common.status.UFStatus;
import com.raytheon.uf.common.status.UFStatus.Priority;
import com.raytheon.uf.viz.collaboration.comm.identity.CollaborationException;
import com.raytheon.uf.viz.collaboration.comm.identity.ISession;
import com.raytheon.uf.viz.collaboration.comm.identity.ISharedDisplaySession;
import com.raytheon.uf.viz.collaboration.comm.identity.IVenueSession;
import com.raytheon.uf.viz.collaboration.comm.identity.info.IVenueInfo;
import com.raytheon.uf.viz.collaboration.comm.identity.invite.SharedDisplayVenueInvite;
import com.raytheon.uf.viz.collaboration.comm.identity.invite.VenueInvite;
import com.raytheon.uf.viz.collaboration.comm.provider.session.CollaborationConnection;
import com.raytheon.uf.viz.collaboration.comm.provider.user.IDConverter;
import com.raytheon.uf.viz.collaboration.comm.provider.user.UserId;
import com.raytheon.uf.viz.collaboration.display.data.SharedDisplaySessionMgr;

/**
 * Invire some users to join a session.
 * 
 * <pre>
 * 
 * SOFTWARE HISTORY
 * 
 * Date         Ticket#    Engineer    Description
 * ------------ ---------- ----------- --------------------------
 * Jul 3, 2012            bsteffen     Initial creation
 * 
 * </pre>
 * 
 * @author bsteffen
 * @version 1.0
 */

public class InviteAction extends Action {

    private static final transient IUFStatusHandler statusHandler = UFStatus
            .getHandler(InviteAction.class);

    private final IUser[] users;

    private final IVenueSession session;

    private String inviteMessage;

    public InviteAction(IUser... users) {
        super("Invite...");
        this.users = users;
        this.session = null;
        this.setToolTipText("Invite selected user(s) to join a session.");
        // set the initial enabled state.
        updateEnabled();
        setMenuCreator(new MenuCreator());
    }

    public InviteAction(IVenueSession session, IUser... users) {
        super(session.getVenue().getInfo().getVenueDescription());
        this.users = users;
        this.session = session;
        this.setToolTipText("Invite selected user(s) to join a session.");
        // set the initial enabled state.
        isEnabled();
    }

    @Override
    public void run() {
        try {
            VenueInvite invite = null;
            if (session instanceof ISharedDisplaySession) {
                SharedDisplayVenueInvite displayInvite = new SharedDisplayVenueInvite();
                displayInvite.setDataProvider(SharedDisplaySessionMgr
                        .getSessionContainer(session.getSessionId())
                        .getSession().getCurrentDataProvider());
                displayInvite.setSessionLeader(SharedDisplaySessionMgr
                        .getSessionContainer(session.getSessionId())
                        .getSession().getCurrentSessionLeader());
                invite = displayInvite;
            } else {
                invite = new VenueInvite();
            }
            invite.setMessage(inviteMessage);
            invite.setSessionId(session.getSessionId());
            invite.setSubject(session.getVenue().getInfo().getVenueSubject());
            List<UserId> inviteList = new ArrayList<UserId>();
            UserId inviter = CollaborationConnection.getConnection().getUser();
            for (IUser user : users) {
                UserId userId = IDConverter.convertFrom(user);

                // don't invite the user sending the invite
                if (!inviter.equals(userId)) {
                    inviteList.add(userId);
                }
            }
            session.sendInvitation(inviteList, invite);
        } catch (CollaborationException e) {
            statusHandler.handle(Priority.PROBLEM, "Error sending invitiation",
                    e);
        }
    }

    /**
     * Set the enabled status of this action to be determined based off what
     * users are available.
     */
    public void updateEnabled() {
        boolean enabled = false;
        List<IVenueSession> newSessions = getNewSessions();
        if ((session == null && !newSessions.isEmpty())
                || newSessions.contains(session)) {
            enabled = true;
        }
        setEnabled(enabled);
    }

    private List<IVenueSession> getNewSessions() {
        List<IVenueSession> result = new ArrayList<IVenueSession>();
        for (IUser user : users) {
            for (IVenueSession session : getNewSessions(user)) {
                if (!result.contains(session)) {
                    result.add(session);
                }
            }
        }
        return result;
    }

    private List<IVenueSession> getNewSessions(IUser user) {
        IPresence presence = CollaborationConnection.getConnection()
                .getContactsManager().getPresence(user);
        if (presence.getType() == Type.UNAVAILABLE) {
            return Collections.emptyList();
        }
        List<IVenueSession> result = new ArrayList<IVenueSession>();
        Collection<ISession> sessions = CollaborationConnection.getConnection()
                .getSessions();
        for (ISession session : sessions) {
            if (session != null && session instanceof IVenueSession) {
                final IVenueInfo info = ((IVenueSession) session).getVenue()
                        .getInfo();
                Collection<UserId> participants = ((IVenueSession) session)
                        .getVenue().getParticipants();
                boolean notInRoom = true;
                String id = user.getID().getName();
                for (UserId pa : participants) {
                    if (pa.isSameUser(id)) {
                        notInRoom = false;
                        break;
                    }
                }
                if (info != null && notInRoom) {
                    result.add((IVenueSession) session);
                }
            }
        }
        return result;
    }

    private class MenuCreator implements IMenuCreator {

        private Menu menu;

        @Override
        public void dispose() {
            menu.dispose();
        }

        @Override
        public Menu getMenu(Control parent) {
            menu = new Menu(parent);
            fill();
            return menu;
        }

        @Override
        public Menu getMenu(Menu parent) {
            menu = new Menu(parent);
            fill();
            return menu;
        }

        private void fill() {
            for (IVenueSession session : getNewSessions()) {
                Action action = new InviteAction(session, users);
                IContributionItem contrib = new ActionContributionItem(action);
                contrib.fill(menu, -1);
            }
        }
    }

    /**
     * @param inviteMessage
     *            the inviteMessage to set
     */
    public void setInviteMessage(String inviteMessage) {
        this.inviteMessage = inviteMessage;
    }
}