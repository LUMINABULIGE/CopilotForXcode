import ChatService
import Foundation
import ChatAPIService
import SuggestionBasic
import SuggestionWidget

struct PresentInWindowSuggestionPresenter {
    func presentSuggestion(fileURL: URL) {
        Task { @MainActor in
            let controller = Service.shared.guiController.widgetController
            controller.suggestCode()
        }
    }
<<<<<<< HEAD
    
    func presentNESSuggestion(fileURL: URL) {
        Task { @MainActor in
            let controller = Service.shared.guiController.widgetController
            controller.suggestNESCode()
        }
    }
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

    func expandSuggestion(fileURL: URL) {
        Task { @MainActor in
            let controller = Service.shared.guiController.widgetController
            controller.expandSuggestion()
        }
    }
    
    func discardSuggestion(fileURL: URL) {
        Task { @MainActor in
            let controller = Service.shared.guiController.widgetController
            controller.discardSuggestion()
        }
    }
<<<<<<< HEAD
    
    func discardNESSuggestion(fileURL: URL) {
        Task { @MainActor in
            let controller = Service.shared.guiController.widgetController
            controller.discardNESSuggestion()
        }
    }
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

    func markAsProcessing(_ isProcessing: Bool) {
        Task { @MainActor in
            let controller = Service.shared.guiController.widgetController
            controller.markAsProcessing(isProcessing)
        }
    }

    func presentError(_ error: Error) {
        if error is CancellationError { return }
        if let urlError = error as? URLError, urlError.code == URLError.cancelled { return }
        Task { @MainActor in
            let controller = Service.shared.guiController.widgetController
            controller.presentError(error.localizedDescription)
        }
    }

    func presentErrorMessage(_ message: String) {
        Task { @MainActor in
            let controller = Service.shared.guiController.widgetController
            controller.presentError(message)
        }
    }

<<<<<<< HEAD
    func presentWarningMessage(_ message: String, url: String?) {
        Task { @MainActor in
            let controller = Service.shared.guiController.widgetController
            controller.presentWarning(message: message, url: url)
        }
    }

    func dismissWarning() {
        Task { @MainActor in
            let controller = Service.shared.guiController.widgetController
            controller.dismissWarning()
        }
    }

=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
    func closeChatRoom(fileURL: URL) {
        Task { @MainActor in
            let controller = Service.shared.guiController.widgetController
            controller.closeChatRoom()
        }
    }

    func presentChatRoom(fileURL: URL) {
        Task { @MainActor in
            let controller = Service.shared.guiController.widgetController
            controller.presentChatRoom()
        }
    }
}

