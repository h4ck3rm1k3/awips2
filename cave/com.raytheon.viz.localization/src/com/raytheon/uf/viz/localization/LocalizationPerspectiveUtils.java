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
package com.raytheon.uf.viz.localization;

import org.eclipse.core.resources.IResource;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.ui.IEditorDescriptor;
import org.eclipse.ui.IEditorInput;
import org.eclipse.ui.IEditorPart;
import org.eclipse.ui.IEditorReference;
import org.eclipse.ui.IEditorRegistry;
import org.eclipse.ui.IViewReference;
import org.eclipse.ui.IWorkbenchPage;
import org.eclipse.ui.IWorkbenchWindow;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.WorkbenchException;

import com.raytheon.uf.common.localization.LocalizationFile;
import com.raytheon.uf.common.status.IUFStatusHandler;
import com.raytheon.uf.common.status.UFStatus;
import com.raytheon.uf.common.status.UFStatus.Priority;
import com.raytheon.uf.viz.localization.service.ILocalizationService;
import com.raytheon.viz.ui.VizWorkbenchManager;

/**
 * Utility class for the localization perspective
 * 
 * TODO: See LocalizationPerspectiveManager static block
 * 
 * <pre>
 * 
 * SOFTWARE HISTORY
 * 
 * Date         Ticket#    Engineer    Description
 * ------------ ---------- ----------- --------------------------
 * Nov 2, 2010            mschenke     Initial creation
 * 
 * </pre>
 * 
 * @author mschenke
 * @version 1.0
 */

public class LocalizationPerspectiveUtils {
    private static final transient IUFStatusHandler statusHandler = UFStatus
            .getHandler(LocalizationPerspectiveUtils.class);

    public static final String ID_PERSPECTIVE = "com.raytheon.uf.viz.ui.LocalizationPerspective"; //$NON-NLS-1$

    private static final String DEFAULT_TEXT_EDITOR = "org.eclipse.ui.DefaultTextEditor";

    /**
     * Get the editor descriptors for the localization file input
     * 
     * @param input
     * @return
     */
    public static IEditorDescriptor[] getEditorsForInput(
            LocalizationEditorInput input) {
        IEditorRegistry reg = getEditorRegistry();
        if (reg == null) {
            return new IEditorDescriptor[0];
        }
        return reg.getEditors(input.getLocalizationFile().getName());
    }

    /**
     * Get the default editor for the localization editor input
     * 
     * @param input
     * @return the default editor descriptor or null if none
     */
    public static IEditorDescriptor getDefaultEditorForInput(
            LocalizationEditorInput input) {
        IEditorRegistry reg = getEditorRegistry();
        if (reg == null) {
            return null;
        }
        return reg.getDefaultEditor(input.getLocalizationFile().getName());
    }

    /**
     * Get the text editor descriptor
     * 
     * @return the text editor descriptor or null if none
     */
    public static IEditorDescriptor getTextEditorDescriptor() {
        IEditorRegistry reg = getEditorRegistry();
        if (reg == null) {
            return null;
        }
        return reg.findEditor(DEFAULT_TEXT_EDITOR);
    }

    /**
     * Opens an editor using the editor input and default editor associated with
     * file extension
     * 
     * @param page
     *            page to open in
     * @param input
     *            input to open with
     * @return null the opened editor or null no editor opened
     */
    public static IEditorPart openInEditor(IWorkbenchPage page,
            LocalizationEditorInput input) {
        IEditorRegistry reg = getEditorRegistry();
        if (reg != null) {
            IEditorDescriptor desc = reg.getDefaultEditor(input
                    .getLocalizationFile().getName());
            String id = DEFAULT_TEXT_EDITOR;
            if (desc != null) {
                id = desc.getId();
            }
            return openInEditor(page, input, id);
        }
        return null;
    }

    /**
     * Open an editor given the input and editor id, activate editor if already
     * opened
     * 
     * @param page
     * @param input
     * @param editorId
     * @return
     */
    public static IEditorPart openInEditor(IWorkbenchPage page,
            LocalizationEditorInput input, String editorId) {
        IEditorPart rval = null;
        IEditorPart existingPart = null;
        try {
            input.getFile().refreshLocal(IResource.DEPTH_ZERO, null);
            existingPart = getEditorForFile(page, input.getLocalizationFile());
            if ((existingPart != null)
                    && existingPart.getEditorSite().getId().equals(editorId)) {
                page.activate(existingPart);
                rval = existingPart;
            } else {
                rval = page.openEditor(input, editorId, true);
            }
        } catch (PartInitException e) {
            statusHandler.handle(Priority.PROBLEM,
                    "Error opening editor for file: " + input.getName(), e);
        } catch (CoreException e) {
            // Ignore exception from refreshing the file
        }

        return rval;
    }

    /**
     * Get the workbench editor registry
     * 
     * @return
     */
    public static IEditorRegistry getEditorRegistry() {
        return PlatformUI.getWorkbench().getEditorRegistry();
    }

    /**
     * Get the open editor editing the file
     * 
     * @param file
     * @return the open editor part or null if not being edited
     */
    public static IEditorPart getEditorForFile(IWorkbenchPage page,
            LocalizationFile file) {
        for (IEditorReference ref : page.getEditorReferences()) {
            IEditorPart part = ref.getEditor(false);
            if (part != null) {
                IEditorInput input = part.getEditorInput();
                if (input instanceof LocalizationEditorInput) {
                    LocalizationFile editedFile = ((LocalizationEditorInput) input)
                            .getLocalizationFile();
                    if (editedFile.getContext().equals(file.getContext())
                            && editedFile.getName().equals(file.getName())) {
                        return part;
                    }
                }
            }
        }
        return null;
    }

    /**
     * Get a localization service object from the active window
     * 
     * @return the localization service or null if none available
     */
    public static ILocalizationService getService() {
        return getService(VizWorkbenchManager.getInstance().getCurrentWindow());
    }

    /**
     * Get a localization service object from the given window
     * 
     * @param window
     *            the window to check
     * @return the localization service or null if none available
     */
    public static ILocalizationService getService(IWorkbenchWindow window) {
        return getService(window != null ? window.getActivePage() : null);
    }

    /**
     * Get a localization service object from the specified workbench page
     * 
     * @param page
     *            the page to search
     * @return the localization service or null if none available
     */
    public static ILocalizationService getService(IWorkbenchPage page) {
        if (page != null) {
            for (IViewReference ref : page.getViewReferences()) {
                ILocalizationService service = (ILocalizationService) ref
                        .getView(false).getAdapter(ILocalizationService.class);
                if (service != null) {
                    return service;
                }
            }
        }
        return null;
    }

    /**
     * Function to make the localization perspective active
     * 
     * @return
     */
    public static ILocalizationService changeToLocalizationPerspective() {
        try {
            IWorkbenchPage page = PlatformUI.getWorkbench().showPerspective(
                    ID_PERSPECTIVE,
                    PlatformUI.getWorkbench().getActiveWorkbenchWindow());
            return getService(page);
        } catch (WorkbenchException e) {
            statusHandler.handle(Priority.PROBLEM,
                    "Error switching to localization perspective", e);
        }

        return null;
    }

}