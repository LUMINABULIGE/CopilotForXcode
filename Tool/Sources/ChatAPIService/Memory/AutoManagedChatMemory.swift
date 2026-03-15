import Foundation
import Logger
import Preferences
<<<<<<< HEAD
import ConversationServiceProvider
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

@globalActor
public enum AutoManagedChatMemoryActor: GlobalActor {
    public actor Actor {}
    public static let shared = Actor()
}

protocol AutoManagedChatMemoryStrategy {
    func countToken(_ message: ChatMessage) async -> Int
}

/// A memory that automatically manages the history according to max tokens and max message count.
public actor AutoManagedChatMemory: ChatMemory {
    public struct ComposableMessages {
        public var systemPromptMessage: ChatMessage
        public var historyMessage: [ChatMessage]
        public var retrievedContentMessage: ChatMessage
        public var contextSystemPromptMessage: ChatMessage
        public var newMessage: ChatMessage
    }

    public typealias HistoryComposer = (ComposableMessages) -> [ChatMessage]

    public private(set) var history: [ChatMessage] = [] {
        didSet { onHistoryChange() }
    }

    public private(set) var remainingTokens: Int?

    public var systemPrompt: String
    public var contextSystemPrompt: String
<<<<<<< HEAD
    public var retrievedContent: [ConversationReference] = []
=======
    public var retrievedContent: [ChatMessage.Reference] = []
>>>>>>> 4a8ae39... Pre-release 0.22.73

    var onHistoryChange: () -> Void = {}

    let composeHistory: HistoryComposer

    public init(
        systemPrompt: String,
        composeHistory: @escaping HistoryComposer = {
            /// Default Format:
            /// ```
            /// [System Prompt] priority: high
            /// [Functions] priority: high
            /// [Retrieved Content] priority: low
            ///     [Retrieved Content A]
            ///     <separator>
            ///     [Retrieved Content B]
            /// [Message History] priority: medium
            /// [Context System Prompt] priority: high
            /// [Latest Message] priority: high
            /// ```
            [$0.systemPromptMessage] +
                $0.historyMessage +
                [$0.retrievedContentMessage, $0.contextSystemPromptMessage, $0.newMessage]
        }
    ) {
        self.systemPrompt = systemPrompt
        contextSystemPrompt = ""
        self.composeHistory = composeHistory
    }
<<<<<<< HEAD
    
    deinit {
        history.removeAll()
        onHistoryChange = {}
        
        retrievedContent.removeAll()
    }
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

    public func mutateHistory(_ update: (inout [ChatMessage]) -> Void) {
        update(&history)
    }

    public func mutateContextSystemPrompt(_ newPrompt: String) {
        contextSystemPrompt = newPrompt
    }

<<<<<<< HEAD
    public func mutateRetrievedContent(_ newContent: [ConversationReference]) {
=======
    public func mutateRetrievedContent(_ newContent: [ChatMessage.Reference]) {
>>>>>>> 4a8ae39... Pre-release 0.22.73
        retrievedContent = newContent
    }

    public nonisolated
    func observeHistoryChange(_ onChange: @escaping () -> Void) {
        Task {
            await setOnHistoryChangeBlock(onChange)
        }
    }

    func setOnHistoryChangeBlock(_ onChange: @escaping () -> Void) {
        onHistoryChange = onChange
    }
}

