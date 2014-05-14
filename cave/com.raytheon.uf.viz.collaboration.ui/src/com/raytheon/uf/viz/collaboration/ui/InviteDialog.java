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
package com.raytheon.uf.viz.collaboration.ui;

import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.StyledText;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.graphics.Font;
import org.eclipse.swt.graphics.FontData;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Layout;
import org.eclipse.swt.widgets.Shell;

import com.raytheon.viz.ui.dialogs.CaveSWTDialogBase;

/**
 * 
 * Invite dialog. This is a custom dialog that will handle really long messages.
 * 
 * <pre>
 * 
 * SOFTWARE HISTORY
 * 
 * Date         Ticket#    Engineer    Description
 * ------------ ---------- ----------- --------------------------
 * Aug 14, 2012            lvenable     Initial creation.
 * 
 * </pre>
 * 
 * @author lvenable
 * @version 1.0
 */
public class InviteDialog extends CaveSWTDialogBase {

    /** Main composite. */
    private Composite mainComp;

    private String inviter;

    private String subject;

    private String room;

    private String inviteText;

    private String message;

    private Font font;

    /**
     * Constructor.
     * 
     * @param parentShell
     *            Parent shell.
     * @param title
     *            Title for the dialog.
     * @param labelStr
     *            Test to put in the label for the message text control.
     * @param messageStr
     *            Message to be displayed.
     * @param iconStyle
     *            Icon style to be displayed.
     */
    public InviteDialog(Shell parentShell, String inviter, String subject,
            String room, String inviteText, String message) {
        super(parentShell, SWT.DIALOG_TRIM | SWT.APPLICATION_MODAL
                | SWT.PRIMARY_MODAL | SWT.SYSTEM_MODAL, CAVE.NONE);
        setText("Session Invitation");

        this.inviter = inviter;
        this.subject = subject;
        this.room = room;
        this.inviteText = inviteText;
        this.message = message;

        setReturnValue(Boolean.FALSE);
    }

    @Override
    protected Layout constructShellLayout() {
        // Create the main layout for the shell.
        GridLayout mainLayout = new GridLayout(1, false);
        mainLayout.marginHeight = 2;
        mainLayout.marginWidth = 2;

        return mainLayout;
    }

    @Override
    protected void initializeComponents(Shell shell) {
        mainComp = new Composite(shell, SWT.NONE);
        GridLayout gl = new GridLayout(2, false);
        gl.marginHeight = 0;
        gl.marginWidth = 0;
        gl.horizontalSpacing = 0;
        mainComp.setLayout(gl);

        createControls();
        createActionButtons();
    }

    /**
     * Create the icon, and message controls.
     */
    private void createControls() {
        // Create a label and text control for the message
        Composite labelTextComp = new Composite(mainComp, SWT.NONE);
        labelTextComp.setLayout(new GridLayout(2, false));

        GridData data = addLabel(labelTextComp, inviteText, true);
        data.horizontalSpan = 2;

        addLabel(labelTextComp, "Inviter: ", true);
        addLabel(labelTextComp, inviter, false);
        addLabel(labelTextComp, "Room: ", true);
        addLabel(labelTextComp, room, false);
        if (subject != null && subject.isEmpty() == false) {
            addLabel(labelTextComp, "Subject: ", true);
            addLabel(labelTextComp, subject, false);
        }

        if (message != null && message.isEmpty() == false) {
            StyledText text = new StyledText(labelTextComp, SWT.MULTI
                    | SWT.BORDER | SWT.V_SCROLL);
            text.setBackground(Display.getCurrent().getSystemColor(
                    SWT.COLOR_WIDGET_BACKGROUND));
            text.setText(message);
            text.setEditable(false);
            text.setWordWrap(true);
            GridData gd = new GridData(SWT.FILL, SWT.FILL, true, true);
            gd.widthHint = 350;
            gd.heightHint = 100;
            gd.horizontalSpan = 2;
            text.setLayoutData(gd);
        }
        font.dispose();
    }

    /**
     * Adds a label to the specified composite with bold or not bold heading
     * text
     * 
     * @param comp
     * @param text
     * @param heading
     * @return
     */
    private GridData addLabel(Composite comp, String text, boolean heading) {
        GridData gd = null;
        Label label = new Label(comp, SWT.WRAP);
        label.setText(text);
        if (font == null) {
            FontData[] fontData = label.getFont().getFontData();
            fontData[0].setStyle(SWT.BOLD);
            font = new Font(Display.getCurrent(), fontData[0]);
        }
        if (heading) {
            gd = new GridData(SWT.LEFT, SWT.NONE, false, false);
            label.setFont(font);
        } else {
            gd = new GridData(SWT.LEFT, SWT.NONE, true, true);
            gd.widthHint = 300;
        }
        label.setLayoutData(gd);
        return gd;
    }

    /**
     * Create the actions buttons.
     */
    private void createActionButtons() {
        Composite actionButtonComp = new Composite(mainComp, SWT.NONE);
        actionButtonComp.setLayout(new GridLayout(2, false));
        GridData gd = new GridData(SWT.FILL, SWT.DEFAULT, true, false);
        gd.horizontalSpan = 2;
        actionButtonComp.setLayoutData(gd);

        int btnWidth = 80;
        gd = new GridData(SWT.RIGHT, SWT.DEFAULT, true, false);
        gd.widthHint = btnWidth;
        Button okBtn = new Button(actionButtonComp, SWT.PUSH);
        okBtn.setText("Join");
        okBtn.setLayoutData(gd);
        okBtn.addSelectionListener(new SelectionAdapter() {
            @Override
            public void widgetSelected(SelectionEvent e) {
                setReturnValue(Boolean.TRUE);
                close();
            }
        });

        gd = new GridData(SWT.LEFT, SWT.DEFAULT, true, false);
        gd.widthHint = btnWidth;
        Button cancelBtn = new Button(actionButtonComp, SWT.PUSH);
        cancelBtn.setText("Cancel");
        cancelBtn.setLayoutData(gd);
        cancelBtn.addSelectionListener(new SelectionAdapter() {
            @Override
            public void widgetSelected(SelectionEvent e) {
                setReturnValue(Boolean.FALSE);
                close();
            }
        });
    }
}