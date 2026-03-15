<<<<<<< HEAD

//import Foundation

// Not used actor, commit it avoid chat message init error
//public actor ConversationChatMemory: ChatMemory {
//    public var history: [ChatMessage] = []
//
//    public init(systemPrompt: String, systemMessageId: String = UUID().uuidString) {
//        history.append(.init(id: systemMessageId, role: .system, content: systemPrompt))
//    }
//
//    public func mutateHistory(_ update: (inout [ChatMessage]) -> Void) {
//        update(&history)
//    }
//}
=======
import Foundation

public actor ConversationChatMemory: ChatMemory {
    public var history: [ChatMessage] = []

    public init(systemPrompt: String, systemMessageId: String = UUID().uuidString) {
        history.append(.init(id: systemMessageId, role: .system, content: systemPrompt))
    }

    public func mutateHistory(_ update: (inout [ChatMessage]) -> Void) {
        update(&history)
    }
}

>>>>>>> 4a8ae39... Pre-release 0.22.73
