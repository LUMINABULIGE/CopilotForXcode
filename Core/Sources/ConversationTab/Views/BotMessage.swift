import ComposableArchitecture
import ChatService
import Foundation
import MarkdownUI
import SharedUIComponents
import SwiftUI
<<<<<<< HEAD
import ConversationServiceProvider
import ChatTab
import ChatAPIService
import HostAppActivator

struct BotMessage: View {
    var r: Double { messageBubbleCornerRadius }
    let message: DisplayedChatMessage
    let chat: StoreOf<Chat>
    var id: String {
        message.id
    }
    var text: String { message.text }
    var references: [ConversationReference] { message.references }
    var followUp: ConversationFollowUp? { message.followUp }
    var errorMessages: [String] { message.errorMessages }
    var steps: [ConversationProgressStep] { message.steps }
    var editAgentRounds: [AgentRound] { message.editAgentRounds }
    var panelMessages: [CopilotShowMessageParams] { message.panelMessages }
    var codeReviewRound: CodeReviewRound? { message.codeReviewRound }
    
    @Environment(\.colorScheme) var colorScheme
    @AppStorage(\.chatFontSize) var chatFontSize

    @State var isHovering = false
    
    struct ReferenceButton: View {
        let references: [ConversationReference]
        let chat: StoreOf<Chat>
        
        @AppStorage(\.chatFontSize) var chatFontSize
        
        func MakeReferenceTitle(references: [ConversationReference]) -> String {
            guard !references.isEmpty else {
                return ""
            }
            
            let count = references.count
            let title = count > 1 ? "Used \(count) references" : "Used \(count) reference"
            return title
        }
        
        var body: some View {
            let files = references.map { $0.filePath }
            let fileHelpTexts = Dictionary<String, String>(uniqueKeysWithValues: references.compactMap { reference in
                guard reference.url != nil else { return nil }
                return (reference.filePath, reference.getPathRelativeToHome())
            })
            let progressMessage = Text(MakeReferenceTitle(references: references))
                .foregroundStyle(.secondary)
            
            HStack(spacing: 0) {
                ExpandableFileListView(
                    progressMessage: progressMessage,
                    files: files,
                    chatFontSize: chatFontSize,
                    helpText: "View referenced files",
                    onFileClick: { filePath in
                        if let reference = references.first(where: { $0.filePath == filePath }) {
                            chat.send(.referenceClicked(reference))
                        }
                    },
                    fileHelpTexts: fileHelpTexts
                )
                
                Spacer()
            }
        }
    }

    var body: some View {
        WithPerceptionTracking {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    if !references.isEmpty {
                        WithPerceptionTracking {
                            ReferenceButton(
                                references: references,
                                chat: chat
                            )
                        }
                    }
                    
                    // progress step
                    if steps.count > 0 {
                        ProgressStep(steps: steps)
                        
                    }
                    
                    if !panelMessages.isEmpty {
                        WithPerceptionTracking {
                            ForEach(panelMessages.indices, id: \.self) { index in
                                FunctionMessage(text: panelMessages[index].message, chat: chat)
                            }
                        }
                    }
                    
                    if editAgentRounds.count > 0 {
                        ProgressAgentRound(rounds: editAgentRounds, chat: chat)
                    }
                    
                    if !text.isEmpty {
                        Group{
                            ThemedMarkdownText(text: text, chat: chat)
                        }
                        .scaledPadding(.leading, 2)
                        .scaledPadding(.vertical, 4)
                    }
                    
                    if let codeReviewRound = codeReviewRound {
                        CodeReviewMainView(
                            store: chat, round: codeReviewRound
                        )
                        .frame(maxWidth: .infinity)
                    }
                    
                    if !errorMessages.isEmpty {
                        buildErrorMessageView()
                    }

                    HStack {
                        if shouldShowTurnStatus() {
                            TurnStatusView(message: message)
                                .modify { view in
                                    if message.turnStatus == .inProgress {
                                        view
                                            .scaledPadding(.leading, 6)
                                    } else {
                                        view
                                    }
                                }
                        }

                        Spacer()

                        ResponseToolBar(
                            id: id,
                            chat: chat,
                            text: text,
                            message: message
                        )
                            .conditionalFontWeight(.medium)
                            .opacity(shouldShowToolBar() ? 1 : 0)
                            .scaledPadding(.trailing, -20)
                    }
                }
                .padding(.leading, message.parentTurnId != nil ? 4 : 0)
                .shadow(color: .black.opacity(0.05), radius: 6)
                .contextMenu {
                    Button("Copy") {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(text, forType: .string)
                    }
                    .scaledFont(.body)
                    
                    Button("Set as Extra System Prompt") {
                        chat.send(.setAsExtraPromptButtonTapped(id))
                    }
                    .scaledFont(.body)
                    
                    Divider()
                    
                    Button("Delete") {
                        chat.send(.deleteMessageButtonTapped(id))
                    }
                    .scaledFont(.body)
                }
                .onHover {
                    isHovering = $0
                }
            }
        }
    }
    
    @ViewBuilder
    private func buildErrorMessageView() -> some View {
        VStack(spacing: 4) {
            ForEach(errorMessages.indices, id: \.self) { index in
                if let attributedString = try? AttributedString(markdown: errorMessages[index]) {
                    NotificationBanner(style: .warning) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(attributedString)
                            
                            if isSettingsActionableError(errorMessages[index]) {
                                Button(action: {
                                    Task {
                                        try? launchHostAppAdvancedSettings()
                                    }
                                }) {
                                    Text("Open Settings")
                                }
                                .buttonStyle(.link)
                            }
                        }
                    }
                }
            }
        }
        .scaledPadding(.vertical, 4)
    }
    
    private func isSettingsActionableError(_ message: String) -> Bool {
        message == HardCodedToolRoundExceedErrorMessage ||
        message == SSLCertificateErrorMessage
    }

    private func shouldShowTurnStatus() -> Bool {
        guard isLatestAssistantMessage() else {
            return false
        }
        
        if steps.isEmpty && editAgentRounds.isEmpty {
            return true
        }
        
        if !steps.isEmpty {
            return !message.text.isEmpty
        }
        
        return true
    }
    
    private func shouldShowToolBar() -> Bool {
        // Always show toolbar for historical messages
        if !isLatestAssistantMessage() { return isHovering }
        
        // For current message, only show toolbar when message is complete
        return !chat.isReceivingMessage
    }
    
    private func isLatestAssistantMessage() -> Bool {
        let lastMessage = chat.history.last
        return lastMessage?.role == .assistant && lastMessage?.id == id
    }
}

private struct TurnStatusView: View {
    
    let message: DisplayedChatMessage
    
    @AppStorage(\.chatFontSize) var chatFontSize
    
    var body: some View {
        HStack(spacing: 0) {
            if let turnStatus = message.turnStatus {
                switch turnStatus {
                case .inProgress:
                    inProgressStatus
                case .success:
                    completedStatus
                case .cancelled:
                    cancelStatus
                case .error:
                    EmptyView()
                case .waitForConfirmation:
                    waitForConfirmationStatus
                }
            }
        }
    }
    
    private var inProgressStatus: some View {
        HStack(spacing: 4) {
            ProgressView()
                .controlSize(.small)
                .scaledScaleEffect(0.7)
                .scaledFrame(width: 16, height: 16)
            
            Text("Generating...")
                .scaledFont(size: chatFontSize - 1)
                .foregroundColor(.secondary)
        }
    }
    
    private var completedStatus: some View {
        statusView(icon: "checkmark.circle.fill", iconColor: .successLightGreen, text: "Completed")
    }
    
    private var waitForConfirmationStatus: some View {
        statusView(icon: "clock.fill", iconColor: .brown, text: "Waiting for your response")
    }
    
    private var cancelStatus: some View {
        statusView(icon: "slash.circle", iconColor: .secondary, text: "Stopped")
    }
    
    private var errorStatus: some View {
        statusView(icon: "xmark.circle.fill", iconColor: .red, text: "Error Occurred")
    }
    
    private func statusView(icon: String, iconColor: Color, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .scaledFont(size: chatFontSize)
                .foregroundColor(iconColor)
                .conditionalFontWeight(.medium)
            
            Text(text)
                .scaledFont(size: chatFontSize - 1)
                .foregroundColor(.secondary)
        }
    }
}

struct BotMessage_Previews: PreviewProvider {
    static let steps: [ConversationProgressStep] = [
        .init(id: "001", title: "running step", description: "this is running step", status: .running, error: nil),
        .init(id: "002", title: "completed step", description: "this is completed step", status: .completed, error: nil),
        .init(id: "003", title: "failed step", description: "this is failed step", status: .failed, error: nil),
        .init(id: "004", title: "cancelled step", description: "this is cancelled step", status: .cancelled, error: nil)
    ]

    static let agentRounds: [AgentRound] = [
        .init(roundId: 1, reply: "this is agent step 1", toolCalls: [
            .init(
                id: "toolcall_001",
                name: "Tool Call 1",
                progressMessage: "Read Tool Call 1",
                status: .completed,
                error: nil)
            ]),
        .init(roundId: 2, reply: "this is agent step 2", toolCalls: [
            .init(
                id: "toolcall_002",
                name: "Tool Call 2",
                progressMessage: "Running Tool Call 2",
                status: .running)
            ])
        ]

    static var previews: some View {
        let chatTabInfo = ChatTabInfo(id: "id", workspacePath: "path", username: "name")
        BotMessage(
            message: .init(
                id: "1",
                role: .assistant,
                text: """
                    **Hey**! What can I do for you?**Hey**! What can I do for you?**Hey**! What can I do for you?**Hey**! What can I do for you?
                    ```swift
                    func foo() {}
                    ```
                    """,
                references: .init(
                    repeating: .init(
                    uri: "/Core/Sources/ConversationTab/Views/BotMessage.swift",
                    status: .included,
                    kind: .class,
                    referenceType: .file),
                    count: 2
                ),
                followUp: ConversationFollowUp(message: "followup question", id: "id", type: "type"),
                errorMessages: ["Sorry, an error occurred while generating a response."],
                steps: steps,
                editAgentRounds: agentRounds,
                panelMessages: [],
                codeReviewRound: nil,
                requestType: .conversation
            ),
            chat: .init(initialState: .init(), reducer: { Chat(service: ChatService.service(for: chatTabInfo)) }),
        )
        .padding()
        .fixedSize(horizontal: true, vertical: true)
    }
}
=======

struct BotMessage: View {
    var r: Double { messageBubbleCornerRadius }
    let id: String
    let text: String
    let references: [DisplayedChatMessage.Reference]
    let chat: StoreOf<Chat>
    @Environment(\.colorScheme) var colorScheme

    @State var isReferencesPresented = false
    @State var isReferencesHovered = false

    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Spacer() // Pushes the buttons to the right
                    UpvoteButton { rating in
                        chat.send(.upvote(id, rating))
                    }
                    
                    DownvoteButton { rating in
                        chat.send(.downvote(id, rating))
                    }
                    
                    CopyButton {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(text, forType: .string)
                        chat.send(.copyCode(id))
                    }
                }
                
                if !references.isEmpty {
                    Button(action: {
                        isReferencesPresented.toggle()
                    }, label: {
                        HStack(spacing: 4) {
                            Image(systemName: "plus.circle")
                            Text("Used \(references.count) references")
                        }
                        .padding(8)
                        .background {
                            RoundedRectangle(cornerRadius: r - 4)
                                .foregroundStyle(Color(isReferencesHovered ? .black : .clear))
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: r - 4)
                                .stroke(Color(nsColor: .separatorColor), lineWidth: 1)
                        }
                        .foregroundStyle(.secondary)
                    })
                    .buttonStyle(.plain)
                    .popover(isPresented: $isReferencesPresented, arrowEdge: .trailing) {
                        ReferenceList(references: references, chat: chat)
                    }
                }

                ThemedMarkdownText(text)
            }
            .frame(alignment: .trailing)
            .padding()
            .background {
                RoundedCorners(tl: r, tr: r, bl: 0, br: r)
                    .fill(Color.contentBackground)
            }
            .overlay {
                RoundedCorners(tl: r, tr: r, bl: 0, br: r)
                    .stroke(Color(nsColor: .separatorColor), lineWidth: 1)
            }
            .padding(.leading, 8)
            .shadow(color: .black.opacity(0.05), radius: 6)
            .contextMenu {
                Button("Copy") {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(text, forType: .string)
                }
                
                Button("Set as Extra System Prompt") {
                    chat.send(.setAsExtraPromptButtonTapped(id))
                }
                
                Divider()
                
                Button("Delete") {
                    chat.send(.deleteMessageButtonTapped(id))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.trailing, 2)
    }
}

struct ReferenceList: View {
    let references: [DisplayedChatMessage.Reference]
    let chat: StoreOf<Chat>

    var body: some View {
        WithPerceptionTracking {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(0..<references.endIndex, id: \.self) { index in
                        WithPerceptionTracking {
                            let reference = references[index]

                            Button(action: {
                                chat.send(.referenceClicked(reference))
                            }) {
                                HStack(spacing: 8) {
                                    ReferenceIcon(kind: reference.kind)
                                        .layoutPriority(2)
                                    Text(reference.title)
                                        .truncationMode(.middle)
                                        .lineLimit(1)
                                        .layoutPriority(1)
                                    Text(reference.subtitle)
                                        .lineLimit(1)
                                        .truncationMode(.middle)
                                        .foregroundStyle(.tertiary)
                                        .layoutPriority(0)
                                }
                                .padding(.vertical, 4)
                                .padding(.horizontal, 4)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color(nsColor: .separatorColor), lineWidth: 1)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
            .frame(maxWidth: 500, maxHeight: 500)
        }
    }
}

struct ReferenceIcon: View {
    let kind: DisplayedChatMessage.Reference.Kind

    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill({
                switch kind {
                case .class:
                    Color.purple
                case .struct:
                    Color.purple
                case .enum:
                    Color.purple
                case .actor:
                    Color.purple
                case .protocol:
                    Color.purple
                case .extension:
                    Color.indigo
                case .case:
                    Color.green
                case .property:
                    Color.teal
                case .typealias:
                    Color.orange
                case .function:
                    Color.teal
                case .method:
                    Color.blue
                case .text:
                    Color.gray
                case .webpage:
                    Color.blue
                case .other:
                    Color.gray
                }
            }())
            .frame(width: 22, height: 22)
            .overlay(alignment: .center) {
                Group {
                    switch kind {
                    case .class:
                        Text("C")
                    case .struct:
                        Text("S")
                    case .enum:
                        Text("E")
                    case .actor:
                        Text("A")
                    case .protocol:
                        Text("Pr")
                    case .extension:
                        Text("Ex")
                    case .case:
                        Text("K")
                    case .property:
                        Text("P")
                    case .typealias:
                        Text("T")
                    case .function:
                        Text("𝑓")
                    case .method:
                        Text("M")
                    case .text:
                        Text("Tx")
                    case .webpage:
                        Text("Wb")
                    case .other:
                        Text("Ot")
                    }
                }
                .font(.system(size: 12).monospaced())
                .foregroundColor(.white)
            }
    }
}

#Preview("Bot Message") {
    BotMessage(
        id: "1",
        text: """
        **Hey**! What can I do for you?**Hey**! What can I do for you?**Hey**! What can I do for you?**Hey**! What can I do for you?
        ```swift
        func foo() {}
        ```
        """,
        references: .init(repeating: .init(
            title: "ReferenceList",
            subtitle: "/Core/Sources/ConversationTab/Views/BotMessage.swift:100",
            uri: "https://google.com",
            startLine: nil,
            kind: .class
        ), count: 20),
        chat: .init(initialState: .init(), reducer: { Chat(service: ChatService.service()) })
    )
    .padding()
    .fixedSize(horizontal: true, vertical: true)
}

#Preview("Reference List") {
    ReferenceList(references: [
        .init(
            title: "ReferenceList",
            subtitle: "/Core/Sources/ConversationTab/Views/BotMessage.swift:100",
            uri: "https://google.com",
            startLine: nil,
            kind: .class
        ),
        .init(
            title: "BotMessage.swift:100-102",
            subtitle: "/Core/Sources/ConversationTab/Views",
            uri: "https://google.com",
            startLine: nil,
            kind: .struct
        ),
        .init(
            title: "ReferenceList",
            subtitle: "/Core/Sources/ConversationTab/Views/BotMessage.swift:100",
            uri: "https://google.com",
            startLine: nil,
            kind: .function
        ),
        .init(
            title: "ReferenceList",
            subtitle: "/Core/Sources/ConversationTab/Views/BotMessage.swift:100",
            uri: "https://google.com",
            startLine: nil,
            kind: .case
        ),
        .init(
            title: "ReferenceList",
            subtitle: "/Core/Sources/ConversationTab/Views/BotMessage.swift:100",
            uri: "https://google.com",
            startLine: nil,
            kind: .extension
        ),
        .init(
            title: "ReferenceList",
            subtitle: "/Core/Sources/ConversationTab/Views/BotMessage.swift:100",
            uri: "https://google.com",
            startLine: nil,
            kind: .webpage
        ),
    ], chat: .init(initialState: .init(), reducer: { Chat(service: ChatService.service()) }))
}

>>>>>>> 4a8ae39... Pre-release 0.22.73
