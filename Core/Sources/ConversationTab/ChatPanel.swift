import AppKit
import Combine
import ComposableArchitecture
<<<<<<< HEAD
import ConversationServiceProvider
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
import MarkdownUI
import ChatAPIService
import SharedUIComponents
import SwiftUI
import ChatService
<<<<<<< HEAD
import SwiftUIFlowLayout
import XcodeInspector
import ChatTab
import Workspace
import Persist
import UniformTypeIdentifiers
import Status
import GitHubCopilotService
import GitHubCopilotViewModel
import LanguageServerProtocol

private let r: Double = 4

public struct ChatPanel: View {
    @Perception.Bindable var chat: StoreOf<Chat>
    @Namespace var inputAreaNamespace

    public var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                
                if chat.history.isEmpty {
                    VStack {
                        Spacer()
                        Instruction(isAgentMode: $chat.isAgentMode)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    ChatPanelMessages(chat: chat)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Chat Messages Group")

                    if chat.isAgentMode, let handOffs = chat.selectedAgent.handOffs, !handOffs.isEmpty, 
                       chat.history.contains(where: { $0.role == .assistant && $0.turnStatus != .inProgress }),
                       !chat.handOffClicked {
                        ChatHandOffs(chat: chat)
                            .scaledPadding(.vertical, 8)
                            .scaledPadding(.horizontal, 16)
                            .dimWithExitEditMode(chat)
                    } else if let _ = chat.history.last?.followUp {
                        ChatFollowUp(chat: chat)
                            .scaledPadding(.vertical, 8)
                            .scaledPadding(.horizontal, 16)
                            .dimWithExitEditMode(chat)
                    }
                }
                
                if chat.fileEditMap.count > 0 {
                    WorkingSetView(chat: chat)
                        .dimWithExitEditMode(chat)
                        .scaledPadding(.horizontal, 24)
                }
                
                ChatPanelInputArea(chat: chat, r: r, editorMode: .input)
                    .dimWithExitEditMode(chat)
                    .scaledPadding(.horizontal, 16)
            }
            .scaledPadding(.vertical, 12)
            .background(Color.chatWindowBackgroundColor)
            .onAppear {
                chat.send(.appear)
            }
            .onDrop(of: [.fileURL], isTargeted: nil) { providers in
                onFileDrop(providers)
            }
        }
    }
    
    private func onFileDrop(_ providers: [NSItemProvider]) -> Bool {
        let fileManager = FileManager.default
        
        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier) { item, error in
                    let url: URL? = {
                        if let data = item as? Data {
                            return URL(dataRepresentation: data, relativeTo: nil)
                        } else if let url = item as? URL {
                            return url
                        }
                        return nil
                    }()
                    
                    guard let url else { return }
                    
                    var isDirectory: ObjCBool = false
                    if let isValidFile = try? WorkspaceFile.isValidFile(url), isValidFile {
                        DispatchQueue.main.async {
                            let fileReference = ConversationFileReference(url: url, isCurrentEditor: false)
                            chat.send(.addReference(.file(fileReference)))
                        }
                    } else if let data = try? Data(contentsOf: url),
                        ["png", "jpeg", "jpg", "bmp", "gif", "tiff", "tif", "webp"].contains(url.pathExtension.lowercased()) {
                        DispatchQueue.main.async {
                            chat.send(.addSelectedImage(ImageReference(data: data, fileUrl: url)))
                        }
                    } else if fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory), isDirectory.boolValue {
                        DispatchQueue.main.async {
                            chat.send(.addReference(.directory(.init(url: url))))
                        }
                    }
                }
            }
        }
        
        return true
    }
}



=======

private let r: Double = 8

public struct ChatPanel: View {
    let chat: StoreOf<Chat>
    @Namespace var inputAreaNamespace

    public var body: some View {
        VStack(spacing: 0) {
            ChatPanelMessages(chat: chat)
            Divider()
            ChatPanelInputArea(chat: chat)
        }
        .background(Color(nsColor: .windowBackgroundColor))
        .onAppear { chat.send(.appear) }
    }
}

>>>>>>> 4a8ae39... Pre-release 0.22.73
private struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue = CGFloat.zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

private struct ListHeightPreferenceKey: PreferenceKey {
    static var defaultValue = CGFloat.zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

struct ChatPanelMessages: View {
    let chat: StoreOf<Chat>
    @State var cancellable = Set<AnyCancellable>()
    @State var isScrollToBottomButtonDisplayed = true
    @State var isPinnedToBottom = true
    @Namespace var bottomID
    @Namespace var topID
    @Namespace var scrollSpace
    @State var scrollOffset: Double = 0
    @State var listHeight: Double = 0
    @State var didScrollToBottomOnAppearOnce = false
    @State var isBottomHidden = true
    @Environment(\.isEnabled) var isEnabled
<<<<<<< HEAD
    @AppStorage(\.fontScale) private var fontScale: Double
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

    var body: some View {
        WithPerceptionTracking {
            ScrollViewReader { proxy in
                GeometryReader { listGeo in
                    List {
                        Group {
<<<<<<< HEAD

                            ChatHistory(chat: chat)
                                .fixedSize(horizontal: false, vertical: true)
=======
                            Spacer(minLength: 12)
                                .id(topID)

                            Instruction(chat: chat)

                            ChatHistory(chat: chat)
                                .listItemTint(.clear)
>>>>>>> 4a8ae39... Pre-release 0.22.73

                            ExtraSpacingInResponding(chat: chat)

                            Spacer(minLength: 12)
                                .id(bottomID)
<<<<<<< HEAD
                                .listRowInsets(EdgeInsets())
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
                                .onAppear {
                                    isBottomHidden = false
                                    if !didScrollToBottomOnAppearOnce {
                                        proxy.scrollTo(bottomID, anchor: .bottom)
                                        didScrollToBottomOnAppearOnce = true
                                    }
                                }
                                .onDisappear {
                                    isBottomHidden = true
                                }
                                .background(GeometryReader { geo in
                                    let offset = geo.frame(in: .named(scrollSpace)).minY
                                    Color.clear.preference(
                                        key: ScrollViewOffsetPreferenceKey.self,
                                        value: offset
                                    )
                                })
                        }
                        .modify { view in
                            if #available(macOS 13.0, *) {
                                view
                                    .listRowSeparator(.hidden)
<<<<<<< HEAD
=======
                                    .listSectionSeparator(.hidden)
>>>>>>> 4a8ae39... Pre-release 0.22.73
                            } else {
                                view
                            }
                        }
                    }
                    .listStyle(.plain)
<<<<<<< HEAD
                    .scaledPadding(.leading, 8)
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
                    .listRowBackground(EmptyView())
                    .modify { view in
                        if #available(macOS 13.0, *) {
                            view.scrollContentBackground(.hidden)
                        } else {
                            view
                        }
                    }
                    .coordinateSpace(name: scrollSpace)
                    .preference(
                        key: ListHeightPreferenceKey.self,
                        value: listGeo.size.height
                    )
                    .onPreferenceChange(ListHeightPreferenceKey.self) { value in
                        listHeight = value
                        updatePinningState()
                    }
                    .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                        scrollOffset = value
                        updatePinningState()
                    }
<<<<<<< HEAD
                    .overlay(alignment: .bottomTrailing) {
                        scrollToBottomButton(proxy: proxy)
                            .scaledPadding(4)
=======
                    .overlay(alignment: .bottom) {
                        StopRespondingButton(chat: chat)
                    }
                    .overlay(alignment: .bottomTrailing) {
                        scrollToBottomButton(proxy: proxy)
>>>>>>> 4a8ae39... Pre-release 0.22.73
                    }
                    .background {
                        PinToBottomHandler(
                            chat: chat,
                            isBottomHidden: isBottomHidden,
                            pinnedToBottom: $isPinnedToBottom
                        ) {
                            proxy.scrollTo(bottomID, anchor: .bottom)
                        }
                    }
                    .onAppear {
                        proxy.scrollTo(bottomID, anchor: .bottom)
                    }
                    .task {
                        proxy.scrollTo(bottomID, anchor: .bottom)
                    }
                }
            }
            .onAppear {
                trackScrollWheel()
            }
            .onDisappear {
                cancellable.forEach { $0.cancel() }
                cancellable = []
            }
        }
    }

    func trackScrollWheel() {
        NSApplication.shared.publisher(for: \.currentEvent)
            .filter {
                if !isEnabled { return false }
                return $0?.type == .scrollWheel
            }
            .compactMap { $0 }
            .sink { event in
                guard isPinnedToBottom else { return }
                let delta = event.deltaY
                let scrollUp = delta > 0
                if scrollUp {
                    isPinnedToBottom = false
                }
            }
            .store(in: &cancellable)
    }

<<<<<<< HEAD
    private let listRowSpacing: CGFloat = 32
    private let scrollButtonBuffer: CGFloat = 32
    
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
    @MainActor
    func updatePinningState() {
        // where does the 32 come from?
        withAnimation(.linear(duration: 0.1)) {
<<<<<<< HEAD
            // Ensure listHeight is greater than 0 to avoid invalid calculations or division by zero.
            // This guard clause prevents unnecessary updates when the list height is not yet determined.
            guard listHeight > 0 else {
                isScrollToBottomButtonDisplayed = false
                return
            }
            
            isScrollToBottomButtonDisplayed = scrollOffset > listHeight + (listRowSpacing + scrollButtonBuffer) * fontScale
=======
            isScrollToBottomButtonDisplayed = scrollOffset > listHeight + 32 + 20
                || scrollOffset <= 0
>>>>>>> 4a8ae39... Pre-release 0.22.73
        }
    }

    @ViewBuilder
    func scrollToBottomButton(proxy: ScrollViewProxy) -> some View {
        Button(action: {
            isPinnedToBottom = true
            withAnimation(.easeInOut(duration: 0.1)) {
                proxy.scrollTo(bottomID, anchor: .bottom)
            }
        }) {
<<<<<<< HEAD
            Image(systemName: "chevron.down")
                .scaledFrame(width: 12, height: 12)
                .scaledPadding(4)
                .background {
                    Circle()
                        .fill(Color.chatWindowBackgroundColor)
=======
            Image(systemName: "arrow.down")
                .padding(4)
                .background {
                    Circle()
                        .fill(.thickMaterial)
                        .shadow(color: .black.opacity(0.2), radius: 2)
>>>>>>> 4a8ae39... Pre-release 0.22.73
                }
                .overlay {
                    Circle().stroke(Color(nsColor: .separatorColor), lineWidth: 1)
                }
                .foregroundStyle(.secondary)
<<<<<<< HEAD
        }
        .buttonStyle(.plain)
        .keyboardShortcut(.downArrow, modifiers: [.command])
        .opacity(isScrollToBottomButtonDisplayed ? 1 : 0)
        .help("Scroll Down")
=======
                .padding(4)
        }
        .keyboardShortcut(.downArrow, modifiers: [.command])
        .opacity(isScrollToBottomButtonDisplayed ? 1 : 0)
        .buttonStyle(.plain)
>>>>>>> 4a8ae39... Pre-release 0.22.73
    }

    struct ExtraSpacingInResponding: View {
        let chat: StoreOf<Chat>
<<<<<<< HEAD
        
        @AppStorage(\.fontScale) private var fontScale: Double
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

        var body: some View {
            WithPerceptionTracking {
                if chat.isReceivingMessage {
<<<<<<< HEAD
                    Spacer(minLength: 12 * fontScale)
=======
                    Spacer(minLength: 12)
>>>>>>> 4a8ae39... Pre-release 0.22.73
                }
            }
        }
    }

    struct PinToBottomHandler: View {
        let chat: StoreOf<Chat>
        let isBottomHidden: Bool
        @Binding var pinnedToBottom: Bool
        let scrollToBottom: () -> Void

        @State var isInitialLoad = true
        
        var body: some View {
            WithPerceptionTracking {
                EmptyView()
                    .onChange(of: chat.isReceivingMessage) { isReceiving in
                        if isReceiving {
                            Task {
                                pinnedToBottom = true
                                await Task.yield()
                                withAnimation(.easeInOut(duration: 0.1)) {
                                    scrollToBottom()
                                }
                            }
<<<<<<< HEAD
                        } else {
                            Task {
                                // Scoll to bottom when `isReceiving` changes to `false`
                                if pinnedToBottom {
                                    await Task.yield()
                                    withAnimation(.easeInOut(duration: 0.1)) {
                                        scrollToBottom()
                                    }
                                }
                                pinnedToBottom = false
                            }
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
                        }
                    }
                    .onChange(of: chat.history.last) { _ in
                        if pinnedToBottom || isInitialLoad {
                            if isInitialLoad {
                                isInitialLoad = false
                            }
                            Task {
                                await Task.yield()
<<<<<<< HEAD
                                if !chat.editorMode.isEditingUserMessage {
                                    withAnimation(.easeInOut(duration: 0.1)) {
                                        scrollToBottom()
                                    }
=======
                                withAnimation(.easeInOut(duration: 0.1)) {
                                    scrollToBottom()
>>>>>>> 4a8ae39... Pre-release 0.22.73
                                }
                            }
                        }
                    }
                    .onChange(of: isBottomHidden) { value in
                        // This is important to prevent it from jumping to the top!
                        if value, pinnedToBottom {
                            scrollToBottom()
                        }
                    }
            }
        }
    }
}

struct ChatHistory: View {
    let chat: StoreOf<Chat>
<<<<<<< HEAD
    
    var filteredHistory: [DisplayedChatMessage] {
        guard let pendingCheckpointMessageId = chat.pendingCheckpointMessageId else {
            return chat.history
        }
        
        if let checkPointMessageIndex = chat.history.firstIndex(where: { $0.id == pendingCheckpointMessageId }) {
            return Array(chat.history.prefix(checkPointMessageIndex + 1))
        }
        
        return chat.history
    }
    
    var editUserMessageEffectedMessageIds: Set<String> {
        Set(chat.editUserMessageEffectedMessages.map { $0.id })
    }

    var body: some View {
        WithPerceptionTracking {
            let currentFilteredHistory = filteredHistory
            let pendingCheckpointMessageId = chat.pendingCheckpointMessageId
            
            VStack(spacing: 16) {
                ForEach(Array(currentFilteredHistory.enumerated()), id: \.element.id) { index, message in
                    VStack(spacing: 8) {
                        WithPerceptionTracking {
                            ChatHistoryItem(chat: chat, message: message)
                                .id(message.id)
                        }
                        
                        if message.role != .ignored && index < currentFilteredHistory.count - 1 {
                            if message.role == .assistant && message.parentTurnId == nil {
                                let nextMessage = currentFilteredHistory[index + 1]
                                let hasContent = !message.text.isEmpty || !message.editAgentRounds.isEmpty
                                let nextIsNotSubturn = nextMessage.parentTurnId != message.id
                                
                                if hasContent && nextIsNotSubturn {
                                    CheckPoint(chat: chat, messageId: message.id)
                                        .padding(.vertical, 8)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                        
                        // Show up check point for redo
                        if message.id == pendingCheckpointMessageId {
                            CheckPoint(chat: chat, messageId: message.id)
                                .padding(.vertical, 8)
                                .padding(.trailing, 8)
                        }
                    }
                    .dimWithExitEditMode(
                        chat,
                        applyTo: message.id,
                        isDimmed: editUserMessageEffectedMessageIds.contains(message.id),
                        allowTapToExit: chat.editorMode.isEditingUserMessage && chat.editorMode.editingUserMessageId != message.id
                    )
=======

    var body: some View {
        WithPerceptionTracking {
            ForEach(chat.history, id: \.id) { message in
                WithPerceptionTracking {
                    ChatHistoryItem(chat: chat, message: message).id(message.id)
>>>>>>> 4a8ae39... Pre-release 0.22.73
                }
            }
        }
    }
}

struct ChatHistoryItem: View {
    let chat: StoreOf<Chat>
    let message: DisplayedChatMessage

    var body: some View {
        WithPerceptionTracking {
            let text = message.text
            switch message.role {
            case .user:
<<<<<<< HEAD
                UserMessage(
                    id: message.id,
                    text: text,
                    imageReferences: message.imageReferences,
                    chat: chat,
                    editorCornerRadius: r,
                    requestType: message.requestType
                )
                .scaledPadding(.leading, chat.editorMode.isEditingUserMessage && chat.editorMode.editingUserMessageId == message.id ? 0 : 20)
                .scaledPadding(.trailing, 8)
            case .assistant:
                BotMessage(
                    message: message,
                    chat: chat
                )
                .scaledPadding(.trailing, 20)
=======
                UserMessage(id: message.id, text: text, chat: chat)
                    .listRowInsets(EdgeInsets(
                        top: 0,
                        leading: -8,
                        bottom: 0,
                        trailing: -8
                    ))
                    .padding(.vertical, 4)
            case .assistant:
                BotMessage(
                    id: message.id,
                    text: text,
                    references: message.references,
                    chat: chat
                )
                .listRowInsets(EdgeInsets(
                    top: 0,
                    leading: -8,
                    bottom: 0,
                    trailing: -8
                ))
                .padding(.vertical, 4)
            case .tool:
                FunctionMessage(id: message.id, text: text)
>>>>>>> 4a8ae39... Pre-release 0.22.73
            case .ignored:
                EmptyView()
            }
        }
    }
}

<<<<<<< HEAD
struct ChatFollowUp: View {
    let chat: StoreOf<Chat>
    @AppStorage(\.chatFontSize) var chatFontSize
    
    var body: some View {
        WithPerceptionTracking {
            HStack {
                if let followUp = chat.history.last?.followUp {
                    Button(action: {
                        chat.send(.followUpButtonClicked(UUID().uuidString, followUp.message))
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "sparkles")
                                .scaledFont(.body)
                                .foregroundColor(.blue)
                            
                            Text(followUp.message)
                                .scaledFont(size: chatFontSize)
                                .foregroundColor(.blue)
                        }
                    }
                    .buttonStyle(.plain)
                    .onHover { isHovered in
                        DispatchQueue.main.async {
                            if isHovered {
                                NSCursor.pointingHand.push()
                            } else {
                                NSCursor.pop()
                            }
                        }
                    }
                    .onDisappear {
                        NSCursor.pop()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
=======
private struct StopRespondingButton: View {
    let chat: StoreOf<Chat>

    var body: some View {
        WithPerceptionTracking {
            if chat.isReceivingMessage {
                Button(action: {
                    chat.send(.stopRespondingButtonTapped)
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "stop.fill")
                        Text("Stop Responding")
                    }
                    .padding(8)
                    .background(
                        .regularMaterial,
                        in: RoundedRectangle(cornerRadius: r, style: .continuous)
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: r, style: .continuous)
                            .stroke(Color(nsColor: .separatorColor), lineWidth: 1)
                    }
                }
                .buttonStyle(.borderless)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 8)
                .opacity(chat.isReceivingMessage ? 1 : 0)
                .disabled(!chat.isReceivingMessage)
                .transformEffect(.init(
                    translationX: 0,
                    y: chat.isReceivingMessage ? 0 : 20
                ))
            }
>>>>>>> 4a8ae39... Pre-release 0.22.73
        }
    }
}

<<<<<<< HEAD
struct ChatHandOffs: View {
    let chat: StoreOf<Chat>
    @AppStorage(\.chatFontSize) var chatFontSize

    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading) {
                Text("PROCEED FROM \(chat.selectedAgent.name.uppercased())")
                    .foregroundStyle(.secondary)
                    .scaledPadding(.horizontal, 4)
                    .scaledPadding(.bottom, -4)

                FlowLayout(mode: .vstack, items: chat.selectedAgent.handOffs ?? [], itemSpacing: 4) { item in
                    Button(action: {
                        chat.send(.handOffButtonClicked(item))
                    }) {
                        Text(item.label)
                    }
                    .buttonStyle(.bordered)
                    .onHover { isHovered in
                        DispatchQueue.main.async {
                            if isHovered {
                                NSCursor.pointingHand.push()
                            } else {
                                NSCursor.pop()
                            }
                        }
                    }
                    .onDisappear {
                        NSCursor.pop()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct ChatCLSError: View {
    let chat: StoreOf<Chat>
    @AppStorage(\.chatFontSize) var chatFontSize
    
    var body: some View {
        WithPerceptionTracking {
            HStack(alignment: .top) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.blue)
                    .padding(.leading, 8)
                
                Text("Monthly chat limit reached. [Upgrade now](https://github.com/github-copilot/signup/copilot_individual) or wait until your usage resets.")
                    .font(.system(size: chatFontSize))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
            .background(
                RoundedCorners(tl: r, tr: r, bl: 0, br: 0)
                    .fill(.ultraThickMaterial)
            )
            .overlay(
                RoundedCorners(tl: r, tr: r, bl: 0, br: 0)
                    .stroke(Color(nsColor: .separatorColor), lineWidth: 1)
            )
            .padding(.top, 4)
=======
struct ChatPanelInputArea: View {
    let chat: StoreOf<Chat>
    @FocusState var focusedField: Chat.State.Field?

    var body: some View {
        HStack {
            clearButton
            InputAreaTextEditor(chat: chat, focusedField: $focusedField)
        }
        .padding(8)
        .background(.ultraThickMaterial)
    }

    @MainActor
    var clearButton: some View {
        Button(action: {
            chat.send(.clearButtonTap)
        }) {
            Group {
                if #available(macOS 13.0, *) {
                    Image(systemName: "eraser.line.dashed.fill")
                } else {
                    Image(systemName: "trash.fill")
                }
            }
            .padding(6)
            .background {
                Circle().fill(Color(nsColor: .controlBackgroundColor))
            }
            .overlay {
                Circle().stroke(Color(nsColor: .controlColor), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }

    struct InputAreaTextEditor: View {
        @Perception.Bindable var chat: StoreOf<Chat>
        var focusedField: FocusState<Chat.State.Field?>.Binding

        var body: some View {
            WithPerceptionTracking {
                HStack(spacing: 0) {
                    AutoresizingCustomTextEditor(
                        text: $chat.typedMessage,
                        font: .systemFont(ofSize: 14),
                        isEditable: true,
                        maxHeight: 400,
                        onSubmit: {
                            chat.send(.sendButtonTapped(UUID().uuidString))
                        },
                        completions: chatAutoCompletion
                    )
                    .focused(focusedField, equals: .textField)
                    .bind($chat.focusedField, to: focusedField)
                    .padding(8)
                    .fixedSize(horizontal: false, vertical: true)

                    Button(action: {
                        chat.send(.sendButtonTapped(UUID().uuidString))
                    }) {
                        Image(systemName: "paperplane.fill")
                            .padding(8)
                    }
                    .buttonStyle(.plain)
                    .disabled(chat.isReceivingMessage)
                    .keyboardShortcut(KeyEquivalent.return, modifiers: [])
                }
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(nsColor: .controlBackgroundColor))
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(nsColor: .controlColor), lineWidth: 1)
                }
                .background {
                    Button(action: {
                        chat.send(.returnButtonTapped)
                    }) {
                        EmptyView()
                    }
                    .keyboardShortcut(KeyEquivalent.return, modifiers: [.shift])

                    Button(action: {
                        focusedField.wrappedValue = .textField
                    }) {
                        EmptyView()
                    }
                    .keyboardShortcut("l", modifiers: [.command])
                }
            }
        }

        func chatAutoCompletion(text: String, proposed: [String], range: NSRange) -> [String] {
            guard text.count == 1 else { return [] }
            let plugins = [String]() // chat.pluginIdentifiers.map { "/\($0)" }
            let availableFeatures = plugins + [
                "/exit",
                "@code",
                "@sense",
                "@project",
                "@web",
            ]

            let result: [String] = availableFeatures
                .filter { $0.hasPrefix(text) && $0 != text }
                .compactMap {
                    guard let index = $0.index(
                        $0.startIndex,
                        offsetBy: range.location,
                        limitedBy: $0.endIndex
                    ) else { return nil }
                    return String($0[index...])
                }
            return result
>>>>>>> 4a8ae39... Pre-release 0.22.73
        }
    }
}

<<<<<<< HEAD
extension URL {
    func getPathRelativeToHome() -> String {
        let filePath = self.path
        guard !filePath.isEmpty else { return "" }
        
        let homeDirectory = FileManager.default.homeDirectoryForCurrentUser.path
        if !homeDirectory.isEmpty {
            return filePath.replacingOccurrences(of: homeDirectory, with: "~")
        }
        
        return filePath
    }
}
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
// MARK: - Previews

struct ChatPanel_Preview: PreviewProvider {
    static let history: [DisplayedChatMessage] = [
        .init(
            id: "1",
            role: .user,
            text: "**Hello**",
<<<<<<< HEAD
            references: [],
            requestType: .conversation
=======
            references: []
>>>>>>> 4a8ae39... Pre-release 0.22.73
        ),
        .init(
            id: "2",
            role: .assistant,
            text: """
            ```swift
            func foo() {}
            ```
            **Hey**! What can I do for you?**Hey**! What can I do for you?**Hey**! What can I do for you?**Hey**! What can I do for you?
            """,
            references: [
                .init(
<<<<<<< HEAD
                    uri: "Hi Hi Hi Hi",
                    status: .included,
                    kind: .class,
                    referenceType: .file
                ),
            ],
            requestType: .conversation
=======
                    title: "Hello Hello Hello Hello",
                    subtitle: "Hi Hi Hi Hi",
                    uri: "https://google.com",
                    startLine: nil,
                    kind: .class
                ),
            ]
>>>>>>> 4a8ae39... Pre-release 0.22.73
        ),
        .init(
            id: "7",
            role: .ignored,
            text: "Ignored",
<<<<<<< HEAD
            references: [],
            requestType: .conversation
=======
            references: []
        ),
        .init(
            id: "6",
            role: .tool,
            text: """
            Searching for something...
            - abc
            - [def](https://1.com)
            > hello
            > hi
            """,
            references: []
>>>>>>> 4a8ae39... Pre-release 0.22.73
        ),
        .init(
            id: "5",
            role: .assistant,
            text: "Yooo",
<<<<<<< HEAD
            references: [],
            requestType: .conversation
=======
            references: []
>>>>>>> 4a8ae39... Pre-release 0.22.73
        ),
        .init(
            id: "4",
            role: .user,
            text: "Yeeeehh",
<<<<<<< HEAD
            references: [],
            requestType: .conversation
=======
            references: []
>>>>>>> 4a8ae39... Pre-release 0.22.73
        ),
        .init(
            id: "3",
            role: .user,
            text: #"""
            Please buy me a coffee!
            | Coffee | Milk |
            |--------|------|
            | Espresso | No |
            | Latte | Yes |

            ```swift
            func foo() {}
            ```
            ```objectivec
            - (void)bar {}
            ```
            """#,
<<<<<<< HEAD
            references: [],
            followUp: .init(message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce turpis dolor, malesuada quis fringilla sit amet, placerat at nunc. Suspendisse orci tortor, tempor nec blandit a, malesuada vel tellus. Nunc sed leo ligula. Ut at ligula eget turpis pharetra tristique. Integer luctus leo non elit rhoncus fermentum.", id: "3", type: "type"),
            requestType: .conversation
        ),
    ]
    
    static let chatTabInfo = ChatTabInfo(id: "", workspacePath: "path", username: "name")
=======
            references: []
        ),
    ]
>>>>>>> 4a8ae39... Pre-release 0.22.73

    static var previews: some View {
        ChatPanel(chat: .init(
            initialState: .init(history: ChatPanel_Preview.history, isReceivingMessage: true),
<<<<<<< HEAD
            reducer: { Chat(service: ChatService.service(for: chatTabInfo)) }
=======
            reducer: { Chat(service: ChatService.service()) }
>>>>>>> 4a8ae39... Pre-release 0.22.73
        ))
        .frame(width: 450, height: 1200)
        .colorScheme(.dark)
    }
}

struct ChatPanel_EmptyChat_Preview: PreviewProvider {
    static var previews: some View {
        ChatPanel(chat: .init(
            initialState: .init(history: [DisplayedChatMessage](), isReceivingMessage: false),
<<<<<<< HEAD
            reducer: { Chat(service: ChatService.service(for: ChatPanel_Preview.chatTabInfo)) }
=======
            reducer: { Chat(service: ChatService.service()) }
>>>>>>> 4a8ae39... Pre-release 0.22.73
        ))
        .padding()
        .frame(width: 450, height: 600)
        .colorScheme(.dark)
    }
}

struct ChatPanel_InputText_Preview: PreviewProvider {
    static var previews: some View {
        ChatPanel(chat: .init(
            initialState: .init(history: ChatPanel_Preview.history, isReceivingMessage: false),
<<<<<<< HEAD
            reducer: { Chat(service: ChatService.service(for: ChatPanel_Preview.chatTabInfo)) }
=======
            reducer: { Chat(service: ChatService.service()) }
>>>>>>> 4a8ae39... Pre-release 0.22.73
        ))
        .padding()
        .frame(width: 450, height: 600)
        .colorScheme(.dark)
    }
}

struct ChatPanel_InputMultilineText_Preview: PreviewProvider {
    static var previews: some View {
        ChatPanel(
            chat: .init(
                initialState: .init(
<<<<<<< HEAD
                    editorModeContexts: [Chat.EditorMode.input: ChatContext(
                        typedMessage: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce turpis dolor, malesuada quis fringilla sit amet, placerat at nunc. Suspendisse orci tortor, tempor nec blandit a, malesuada vel tellus. Nunc sed leo ligula. Ut at ligula eget turpis pharetra tristique. Integer luctus leo non elit rhoncus fermentum.")],
                    history: ChatPanel_Preview.history,
                    isReceivingMessage: false
                ),
                reducer: { Chat(service: ChatService.service(for: ChatPanel_Preview.chatTabInfo)) }
=======
                    typedMessage: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce turpis dolor, malesuada quis fringilla sit amet, placerat at nunc. Suspendisse orci tortor, tempor nec blandit a, malesuada vel tellus. Nunc sed leo ligula. Ut at ligula eget turpis pharetra tristique. Integer luctus leo non elit rhoncus fermentum.",

                    history: ChatPanel_Preview.history,
                    isReceivingMessage: false
                ),
                reducer: { Chat(service: ChatService.service()) }
>>>>>>> 4a8ae39... Pre-release 0.22.73
            )
        )
        .padding()
        .frame(width: 450, height: 600)
        .colorScheme(.dark)
    }
}

struct ChatPanel_Light_Preview: PreviewProvider {
    static var previews: some View {
        ChatPanel(chat: .init(
            initialState: .init(history: ChatPanel_Preview.history, isReceivingMessage: true),
<<<<<<< HEAD
            reducer: { Chat(service: ChatService.service(for: ChatPanel_Preview.chatTabInfo)) }
=======
            reducer: { Chat(service: ChatService.service()) }
>>>>>>> 4a8ae39... Pre-release 0.22.73
        ))
        .padding()
        .frame(width: 450, height: 600)
        .colorScheme(.light)
    }
}

