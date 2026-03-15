import Client
import SuggestionBasic
import Foundation
import XcodeKit

class OpenChatCommand: NSObject, XCSourceEditorCommand, CommandType {
    var name: String { "Open Chat" }

    func perform(
        with invocation: XCSourceEditorCommandInvocation,
        completionHandler: @escaping (Error?) -> Void
    ) {
<<<<<<< HEAD
        Task {
            do {
                let service = try getService()
                try await service.openChat()
                completionHandler(nil)
            } catch is CancellationError {
                completionHandler(nil)
            } catch {
                completionHandler(error)
            }
=======
        completionHandler(nil)
        Task {
            let service = try getService()
            _ = try await service.openChat(editorContent: .init(invocation))
>>>>>>> 4a8ae39... Pre-release 0.22.73
        }
    }
}
