import CodableWrappers
import Foundation
import ConversationServiceProvider
<<<<<<< HEAD
import GitHubCopilotService

public struct FileEdit: Equatable, Codable {
    
    public enum Status: String, Codable {
        case none = "none"
        case kept = "kept"
        case undone = "undone"
    }
    
    public let fileURL: URL
    public let originalContent: String
    public var modifiedContent: String
    public var status: Status
    
    /// Different toolName, the different undo logic. Like `insert_edit_into_file` and `create_file`
    public var toolName: ToolName
    
    public init(
        fileURL: URL,
        originalContent: String,
        modifiedContent: String,
        status: Status = .none,
        toolName: ToolName
    ) {
        self.fileURL = fileURL
        self.originalContent = originalContent
        self.modifiedContent = modifiedContent
        self.status = status
        self.toolName = toolName
    }
}

// move here avoid circular reference
public struct ConversationReference: Codable, Equatable, Hashable {
    public enum Kind: Codable, Equatable, Hashable {
        case `class`
        case `struct`
        case `enum`
        case `actor`
        case `protocol`
        case `extension`
        case `case`
        case property
        case `typealias`
        case function
        case method
        case text
        case webpage
        case other
        // reference for turn - request
        case fileReference(ConversationAttachedReference)
        // reference from turn - response
        case reference(FileReference)
    }
    
    public enum Status: String, Codable {
        case included, blocked, notfound, empty
    }
    
    public enum ReferenceType: String, Codable {
        case file, directory
    }

    public var uri: String
    public var status: Status?
    public var kind: Kind
    public var referenceType: ReferenceType
    
    public var ext: String {
        return url?.pathExtension ?? ""
    }
    
    public var fileName: String {
        return url?.lastPathComponent ?? ""
    }
    
    public var filePath: String {
        return url?.path ?? ""
    }
    
    public var url: URL? {
        return URL(string: uri)
    }
    
    public var isDirectory: Bool { referenceType == .directory }

    public init(
        uri: String,
        status: Status?,
        kind: Kind,
        referenceType: ReferenceType = .file
    ) {
        self.uri = uri
        self.status = status
        self.kind = kind
        self.referenceType = referenceType
    }
}


public enum RequestType: String, Equatable, Codable {
    case conversation, codeReview
}

public let HardCodedToolRoundExceedErrorMessage: String = "Oops, maximum tool attempts reached. You can update the max tool requests in settings."
public let SSLCertificateErrorMessage: String = "Unable to verify the SSL certificate. This often happens in enterprise environments with custom certificates. Try disabling **Proxy strict SSL** in the Proxy Settings."
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

public struct ChatMessage: Equatable, Codable {
    public typealias ID = String

    public enum Role: String, Codable, Equatable {
<<<<<<< HEAD
        case user
        case assistant
        case system
        
        public var isAssistant: Bool { self == .assistant }
    }
    
    public enum TurnStatus: String, Codable, Equatable {
        case inProgress, success, cancelled, error, waitForConfirmation
    }
    
    /// The role of a message.
=======
        case system
        case user
        case assistant
    }

    public struct Reference: Codable, Equatable {
        public enum Kind: String, Codable {
            case `class`
            case `struct`
            case `enum`
            case `actor`
            case `protocol`
            case `extension`
            case `case`
            case property
            case `typealias`
            case function
            case method
            case text
            case webpage
            case other
        }

        public var title: String
        public var subTitle: String
        public var uri: String
        public var content: String
        public var startLine: Int?
        public var endLine: Int?
        @FallbackDecoding<ReferenceKindFallback>
        public var kind: Kind

        public init(
            title: String,
            subTitle: String,
            content: String,
            uri: String,
            startLine: Int?,
            endLine: Int?,
            kind: Kind
        ) {
            self.title = title
            self.subTitle = subTitle
            self.content = content
            self.uri = uri
            self.startLine = startLine
            self.endLine = endLine
            self.kind = kind
        }
    }

    /// The role of a message.
    @FallbackDecoding<ChatMessageRoleFallback>
>>>>>>> 4a8ae39... Pre-release 0.22.73
    public var role: Role

    /// The content of the message, either the chat message, or a result of a function call.
    public var content: String
<<<<<<< HEAD
    
    /// The attached image content of the message
    public var contentImageReferences: [ImageReference]
=======

    /// The summary of a message that is used for display.
    public var summary: String?
>>>>>>> 4a8ae39... Pre-release 0.22.73

    /// The id of the message.
    public var id: ID
    
<<<<<<< HEAD
    /// The conversation id (not the CLS conversation id)
    public var chatTabID: String
    
    /// The CLS turn id of the message which is from CLS.
    public var clsTurnID: ID?
    
    /// Rate assistant message
    public var rating: ConversationRating

    /// The references of this message.
    public var references: [ConversationReference]
    
    /// The followUp question of this message
    public var followUp: ConversationFollowUp?
    
    public var suggestedTitle: String?

    /// The error occurred during responding chat in server
    public var errorMessages: [String]
    
    /// The steps of conversation progress
    public var steps: [ConversationProgressStep]
    
    public var editAgentRounds: [AgentRound]
    
    public var parentTurnId: String?
    
    public var panelMessages: [CopilotShowMessageParams]
    
    public var codeReviewRound: CodeReviewRound?
    
    /// File edits performed during the current conversation turn.
    /// Used as a checkpoint to track file modifications made by tools.
    /// Note: Status changes (kept/undone) are tracked separately and not updated here.
    public var fileEdits: [FileEdit]
    
    public var turnStatus: TurnStatus?
    
    public let requestType: RequestType
    
    // The model name used for the turn.
    public var modelName: String?
    public var billingMultiplier: Float?
    
    /// The timestamp of the message.
    public var createdAt: Date
    public var updatedAt: Date

    public init(
        id: String = UUID().uuidString,
        chatTabID: String,
        clsTurnID: String? = nil,
        role: Role,
        content: String,
        contentImageReferences: [ImageReference] = [],
        references: [ConversationReference] = [],
        followUp: ConversationFollowUp? = nil,
        suggestedTitle: String? = nil,
        errorMessages: [String] = [],
        rating: ConversationRating = .unrated,
        steps: [ConversationProgressStep] = [],
        editAgentRounds: [AgentRound] = [],
        parentTurnId: String? = nil,
        panelMessages: [CopilotShowMessageParams] = [],
        codeReviewRound: CodeReviewRound? = nil,
        fileEdits: [FileEdit] = [],
        turnStatus: TurnStatus? = nil,
        requestType: RequestType = .conversation,
        modelName: String? = nil,
        billingMultiplier: Float? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil
    ) {
        self.role = role
        self.content = content
        self.contentImageReferences = contentImageReferences
        self.id = id
        self.chatTabID = chatTabID
        self.clsTurnID = clsTurnID
        self.references = references
        self.followUp = followUp
        self.suggestedTitle = suggestedTitle
        self.errorMessages = errorMessages
        self.rating = rating
        self.steps = steps
        self.editAgentRounds = editAgentRounds
        self.parentTurnId = parentTurnId
        self.panelMessages = panelMessages
        self.codeReviewRound = codeReviewRound
        self.fileEdits = fileEdits
        self.turnStatus = turnStatus
        self.requestType = requestType
        self.modelName = modelName
        self.billingMultiplier = billingMultiplier

        let now = Date.now
        self.createdAt = createdAt ?? now
        self.updatedAt = updatedAt ?? now
    }
    
    public init(
        userMessageWithId id: String,
        chatTabId: String,
        content: String,
        contentImageReferences: [ImageReference] = [],
        references: [ConversationReference] = [],
        requestType: RequestType = .conversation
    ) {
        self.init(
            id: id,
            chatTabID: chatTabId,
            role: .user,
            content: content,
            contentImageReferences: contentImageReferences,
            references: references,
            requestType: requestType
        )
    }
    
    public init(
        assistantMessageWithId id: String, // TurnId
        chatTabID: String,
        content: String = "",
        references: [ConversationReference] = [],
        followUp: ConversationFollowUp? = nil,
        suggestedTitle: String? = nil,
        steps: [ConversationProgressStep] = [],
        editAgentRounds: [AgentRound] = [],
        parentTurnId: String? = nil,
        codeReviewRound: CodeReviewRound? = nil,
        fileEdits: [FileEdit] = [],
        turnStatus: TurnStatus? = nil,
        requestType: RequestType = .conversation,
        modelName: String? = nil,
        billingMultiplier: Float? = nil
    ) {
        self.init(
            id: id,
            chatTabID: chatTabID,
            clsTurnID: id,
            role: .assistant,
            content: content,
            references: references,
            followUp: followUp,
            suggestedTitle: suggestedTitle,
            steps: steps,
            editAgentRounds: editAgentRounds,
            parentTurnId: parentTurnId,
            codeReviewRound: codeReviewRound,
            fileEdits: fileEdits,
            turnStatus: turnStatus,
            requestType: requestType,
            modelName: modelName,
            billingMultiplier: billingMultiplier
        )
    }
    
    public init(
        errorMessageWithId id: String, // TurnId
        chatTabID: String,
        errorMessages: [String] = [],
        panelMessages: [CopilotShowMessageParams] = []
    ) {
        self.init(
            id: id,
            chatTabID: chatTabID,
            clsTurnID: id,
            role: .assistant,
            content: "",
            errorMessages: errorMessages,
            panelMessages: panelMessages
        )
    }
}

extension ConversationReference {
  public func getPathRelativeToHome() -> String {
        guard !filePath.isEmpty else { return filePath}
        
        let homeDirectory = FileManager.default.homeDirectoryForCurrentUser.path
        if !homeDirectory.isEmpty{
            return filePath.replacingOccurrences(of: homeDirectory, with: "~")
        }
        
        return filePath
    }
}
=======
    /// The turn id of the message.
    public var turnId: ID?
    
    /// Rate assistant message
    public var rating: ConversationRating = .unrated

    /// The references of this message.
    @FallbackDecoding<EmptyArray<Reference>>
    public var references: [Reference]

    public init(
        id: String = UUID().uuidString,
        role: Role,
        turnId: String? = nil,
        content: String,
        summary: String? = nil,
        references: [Reference] = []
    ) {
        self.role = role
        self.content = content
        self.summary = summary
        self.id = id
        self.turnId = turnId
        self.references = references
    }
}

public struct ReferenceKindFallback: FallbackValueProvider {
    public static var defaultValue: ChatMessage.Reference.Kind { .other }
}

public struct ChatMessageRoleFallback: FallbackValueProvider {
    public static var defaultValue: ChatMessage.Role { .user }
}

>>>>>>> 4a8ae39... Pre-release 0.22.73
