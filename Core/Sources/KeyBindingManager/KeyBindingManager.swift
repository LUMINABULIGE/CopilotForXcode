import Foundation
import Workspace
public final class KeyBindingManager {
    let tabToAcceptSuggestion: TabToAcceptSuggestion
    public init(
        workspacePool: WorkspacePool,
        acceptSuggestion: @escaping () -> Void,
<<<<<<< HEAD
        acceptNESSuggestion: @escaping () -> Void,
        expandSuggestion: @escaping () -> Void,
        collapseSuggestion: @escaping () -> Void,
        dismissSuggestion: @escaping () -> Void,
        rejectNESSuggestion: @escaping () -> Void,
        goToNextEditSuggestion: @escaping () -> Void,
        isNESPanelOutOfFrame: @escaping () -> Bool
=======
        expandSuggestion: @escaping () -> Void,
        collapseSuggestion: @escaping () -> Void,
        dismissSuggestion: @escaping () -> Void
>>>>>>> 4a8ae39... Pre-release 0.22.73
    ) {
        tabToAcceptSuggestion = .init(
            workspacePool: workspacePool,
            acceptSuggestion: acceptSuggestion,
<<<<<<< HEAD
            acceptNESSuggestion: acceptNESSuggestion,
            dismissSuggestion: dismissSuggestion,
            expandSuggestion: expandSuggestion,
            collapseSuggestion: collapseSuggestion,
            rejectNESSuggestion: rejectNESSuggestion,
            goToNextEditSuggestion: goToNextEditSuggestion,
            isNESPanelOutOfFrame: isNESPanelOutOfFrame
=======
            dismissSuggestion: dismissSuggestion, 
            expandSuggestion: expandSuggestion,
            collapseSuggestion: collapseSuggestion
>>>>>>> 4a8ae39... Pre-release 0.22.73
        )
    }

    public func start() {
        tabToAcceptSuggestion.start()
    }
    
    @MainActor
    public func stopForExit() {
        tabToAcceptSuggestion.stopForExit()
    }
}
