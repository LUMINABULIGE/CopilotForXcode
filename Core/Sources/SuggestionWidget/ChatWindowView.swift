import ActiveApplicationMonitor
<<<<<<< HEAD
import ConversationTab
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
import AppKit
import ChatTab
import ComposableArchitecture
import SwiftUI
<<<<<<< HEAD
import SharedUIComponents
import GitHubCopilotViewModel
import Status
import ChatService
import Workspace
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

private let r: Double = 8

struct ChatWindowView: View {
    let store: StoreOf<ChatPanelFeature>
    let toggleVisibility: (Bool) -> Void
<<<<<<< HEAD
    @State private var isChatHistoryVisible: Bool = false
    @ObservedObject private var statusObserver = StatusObserver.shared

    var body: some View {
        WithPerceptionTracking {
            // Force re-evaluation when workspace state changes
            let currentWorkspace = store.currentChatWorkspace
            let _ = currentWorkspace?.selectedTabId
            ZStack {
                if statusObserver.observedAXStatus == .notGranted {
                    ChatNoAXPermissionView()
                } else {
                    switch statusObserver.authStatus.status {
                    case .loggedIn:
                        if currentWorkspace == nil || (currentWorkspace?.tabInfo.isEmpty ?? true) {
                            ChatNoWorkspaceView()
                        } else if isChatHistoryVisible {
                            ChatHistoryViewWrapper(store: store, isChatHistoryVisible: $isChatHistoryVisible)
                        } else {
                            ChatView(store: store, isChatHistoryVisible: $isChatHistoryVisible)
                        }
                    case .notLoggedIn:
                        ChatLoginView(viewModel: GitHubCopilotViewModel.shared)
                    case .notAuthorized:
                        ChatNoSubscriptionView(viewModel: GitHubCopilotViewModel.shared)
                    case .unknown:
                        ChatLoginView(viewModel: GitHubCopilotViewModel.shared)
                    }
                }
            }
            .onChange(of: store.isPanelDisplayed) { isDisplayed in
                toggleVisibility(isDisplayed)
            }
            .preferredColorScheme(store.colorScheme)
        }
    }
}

struct ChatView: View {
    let store: StoreOf<ChatPanelFeature>
    @Binding var isChatHistoryVisible: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.chatWindowBackgroundColor)
                .scaledFrame(height: 28)

            VStack(spacing: 0) {
                ChatBar(store: store, isChatHistoryVisible: $isChatHistoryVisible)
                    .scaledFrame(height: 32)
                    .scaledPadding(.leading, 16)
                    .scaledPadding(.trailing, 8)
                
                Divider()
                
                ChatTabContainer(store: store)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .xcodeStyleFrame()
        .ignoresSafeArea(edges: .top)
    }
}

struct ChatHistoryViewWrapper: View {
    let store: StoreOf<ChatPanelFeature>
    @Binding var isChatHistoryVisible: Bool

    
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.chatWindowBackgroundColor)
                    .scaledFrame(height: 28)
                
                ChatHistoryView(
                    store: store,
                    isChatHistoryVisible: $isChatHistoryVisible
                )
                .background(Color.chatWindowBackgroundColor)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )
            }
            .xcodeStyleFrame()
            .ignoresSafeArea(edges: .top)
            .preferredColorScheme(store.colorScheme)
            .focusable()
            .onExitCommand(perform: {
                isChatHistoryVisible = false
            })
        }
    }
}

struct ChatLoadingView: View {
    var body: some View {
        VStack(alignment: .center) {
            
            Spacer()
            
            VStack(spacing: 24) {
                Instruction(isAgentMode: .constant(false))
                
                ProgressView("Loading...")
                    
            }
            .frame(maxWidth: .infinity, alignment: .center)
            // keep same as chat view
            .padding(.top, 20) // chat bar
            
            Spacer()

        }
        .xcodeStyleFrame()
        .ignoresSafeArea(edges: .top)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
=======

    var body: some View {
        WithPerceptionTracking {
            let _ = store.chatTabGroup.selectedTabId // force re-evaluation
            VStack(spacing: 0) {
                Rectangle().fill(.regularMaterial).frame(height: 28)

                Divider()

                ChatTabBar(store: store)
                    .frame(height: 26)

                Divider()

                ChatTabContainer(store: store)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .xcodeStyleFrame(cornerRadius: 10)
            .ignoresSafeArea(edges: .top)
            .onChange(of: store.isPanelDisplayed) { isDisplayed in
                toggleVisibility(isDisplayed)
            }
            .preferredColorScheme(store.colorScheme)
        }
>>>>>>> 4a8ae39... Pre-release 0.22.73
    }
}

struct ChatTitleBar: View {
    let store: StoreOf<ChatPanelFeature>
    @State var isHovering = false
<<<<<<< HEAD
    @AppStorage(\.autoAttachChatToXcode) var autoAttachChatToXcode
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

    var body: some View {
        WithPerceptionTracking {
            HStack(spacing: 6) {
                Button(action: {
                    store.send(.closeActiveTabClicked)
                }) {
                    EmptyView()
                }
                .opacity(0)
                .keyboardShortcut("w", modifiers: [.command])

                Button(
                    action: {
                        store.send(.hideButtonClicked)
                    }
                ) {
                    Image(systemName: "minus")
                        .foregroundStyle(.black.opacity(0.5))
<<<<<<< HEAD
                        .scaledFont(Font.system(size: 8).weight(.heavy))
=======
                        .font(Font.system(size: 8).weight(.heavy))
>>>>>>> 4a8ae39... Pre-release 0.22.73
                }
                .opacity(0)
                .keyboardShortcut("m", modifiers: [.command])

                Spacer()

<<<<<<< HEAD
                if !autoAttachChatToXcode {
                    TrafficLightButton(
                        isHovering: isHovering,
                        isActive: store.isDetached,
                        color: Color(nsColor: .systemCyan),
                        action: {
                            store.send(.toggleChatPanelDetachedButtonClicked)
                        }
                    ) {
                        Image(systemName: "pin.fill")
                            .foregroundStyle(.black.opacity(0.5))
                            .scaledFont(Font.system(size: 6).weight(.black))
                            .transformEffect(.init(translationX: 0, y: 0.5))
                    }
=======
                TrafficLightButton(
                    isHovering: isHovering,
                    isActive: store.isDetached,
                    color: Color(nsColor: .systemCyan),
                    action: {
                        store.send(.toggleChatPanelDetachedButtonClicked)
                    }
                ) {
                    Image(systemName: "pin.fill")
                        .foregroundStyle(.black.opacity(0.5))
                        .font(Font.system(size: 6).weight(.black))
                        .transformEffect(.init(translationX: 0, y: 0.5))
>>>>>>> 4a8ae39... Pre-release 0.22.73
                }
            }
            .buttonStyle(.plain)
            .padding(.trailing, 8)
            .onHover(perform: { hovering in
                isHovering = hovering
            })
        }
    }

    struct TrafficLightButton<Icon: View>: View {
        let isHovering: Bool
        let isActive: Bool
        let color: Color
        let action: () -> Void
        let icon: () -> Icon

        @Environment(\.controlActiveState) var controlActiveState

        var body: some View {
            Button(action: {
                action()
            }) {
                Circle()
                    .fill(
                        controlActiveState == .key && isActive
                            ? color
                            : Color(nsColor: .separatorColor)
                    )
<<<<<<< HEAD
                    .scaledFrame(
=======
                    .frame(
>>>>>>> 4a8ae39... Pre-release 0.22.73
                        width: Style.trafficLightButtonSize,
                        height: Style.trafficLightButtonSize
                    )
                    .overlay {
                        Circle().stroke(lineWidth: 0.5).foregroundColor(.black.opacity(0.2))
                    }
                    .overlay {
                        if isHovering {
                            icon()
                        }
                    }
            }
            .focusable(false)
        }
    }
}

private extension View {
    func hideScrollIndicator() -> some View {
        if #available(macOS 13.0, *) {
            return scrollIndicators(.hidden)
        } else {
            return self
        }
    }
}

<<<<<<< HEAD
struct ChatBar: View {
    let store: StoreOf<ChatPanelFeature>
    @Binding var isChatHistoryVisible: Bool
=======
struct ChatTabBar: View {
    let store: StoreOf<ChatPanelFeature>
>>>>>>> 4a8ae39... Pre-release 0.22.73

    struct TabBarState: Equatable {
        var tabInfo: IdentifiedArray<String, ChatTabInfo>
        var selectedTabId: String
    }

    var body: some View {
<<<<<<< HEAD
        WithPerceptionTracking {
            HStack(spacing: 8) {
                if store.chatHistory.selectedWorkspaceName != nil {
                    ChatWindowHeader(store: store)
                }

                Spacer()

                CreateButton(store: store)

                ChatHistoryButton(store: store, isChatHistoryVisible: $isChatHistoryVisible)
                
                SettingsButton(store: store)
            }
=======
        HStack(spacing: 0) {
            Divider()
            Tabs(store: store)
            CreateButton(store: store)
        }
        .background {
            Button(action: { store.send(.switchToNextTab) }) { EmptyView() }
                .opacity(0)
                .keyboardShortcut("]", modifiers: [.command, .shift])
            Button(action: { store.send(.switchToPreviousTab) }) { EmptyView() }
                .opacity(0)
                .keyboardShortcut("[", modifiers: [.command, .shift])
>>>>>>> 4a8ae39... Pre-release 0.22.73
        }
    }

    struct Tabs: View {
        let store: StoreOf<ChatPanelFeature>
<<<<<<< HEAD
=======
        @State var draggingTabId: String?
>>>>>>> 4a8ae39... Pre-release 0.22.73
        @Environment(\.chatTabPool) var chatTabPool

        var body: some View {
            WithPerceptionTracking {
<<<<<<< HEAD
                let tabInfo = store.currentChatWorkspace?.tabInfo
                let selectedTabId = store.currentChatWorkspace?.selectedTabId
                ?? store.currentChatWorkspace?.tabInfo.first?.id
=======
                let tabInfo = store.chatTabGroup.tabInfo
                let selectedTabId = store.chatTabGroup.selectedTabId
                    ?? store.chatTabGroup.tabInfo.first?.id
>>>>>>> 4a8ae39... Pre-release 0.22.73
                    ?? ""
                ScrollViewReader { proxy in
                    ScrollView(.horizontal) {
                        HStack(spacing: 0) {
<<<<<<< HEAD
                            ForEach(tabInfo!, id: \.id) { info in
=======
                            ForEach(tabInfo, id: \.id) { info in
>>>>>>> 4a8ae39... Pre-release 0.22.73
                                if let tab = chatTabPool.getTab(of: info.id) {
                                    ChatTabBarButton(
                                        store: store,
                                        info: info,
                                        content: { tab.tabItem },
                                        icon: { tab.icon },
                                        isSelected: info.id == selectedTabId
                                    )
                                    .contextMenu {
                                        tab.menu
                                    }
                                    .id(info.id)
<<<<<<< HEAD
=======
                                    .onDrag {
                                        draggingTabId = info.id
                                        return NSItemProvider(object: info.id as NSString)
                                    }
                                    .onDrop(
                                        of: [.text],
                                        delegate: ChatTabBarDropDelegate(
                                            store: store,
                                            tabs: tabInfo,
                                            itemId: info.id,
                                            draggingTabId: $draggingTabId
                                        )
                                    )

>>>>>>> 4a8ae39... Pre-release 0.22.73
                                } else {
                                    EmptyView()
                                }
                            }
                        }
                    }
                    .hideScrollIndicator()
                    .onChange(of: selectedTabId) { id in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            proxy.scrollTo(id)
                        }
                    }
                }
            }
        }
    }

<<<<<<< HEAD
    struct ChatWindowHeader: View {
        let store: StoreOf<ChatPanelFeature>

        var body: some View {
            WithPerceptionTracking {
                HStack(spacing: 0) {
                    Image("XcodeIcon")
                            .resizable()
                            .renderingMode(.original)
                            .scaledToFit()
                            .scaledFrame(width: 24, height: 24)

                    Text(store.chatHistory.selectedWorkspaceName!)
                        .scaledFont(size: 13, weight: .bold)
                        .scaledPadding(.leading, 4)
                        .truncationMode(.tail)
                        .scaledFrame(maxWidth: 192, alignment: .leading)
                        .help(store.chatHistory.selectedWorkspacePath!)
                }
            }
        }
    }

=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
    struct CreateButton: View {
        let store: StoreOf<ChatPanelFeature>

        var body: some View {
            WithPerceptionTracking {
<<<<<<< HEAD
                Button(action: {
                    store.send(.createNewTapButtonClicked(kind: nil))
                }) {
                    Image(systemName: "plus.bubble")
                        .scaledFont(.body)
                }
                .buttonStyle(HoverButtonStyle())
                .help("New Chat")
                .accessibilityLabel("New Chat")
            }
        }
    }
    
    struct ChatHistoryButton: View {
        let store: StoreOf<ChatPanelFeature>
        @Binding var isChatHistoryVisible: Bool
        
        var body: some View {
            WithPerceptionTracking {
                Button(action: {
                    isChatHistoryVisible = true
                }) {
                    if #available(macOS 15.0, *) {
                        Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                            .scaledFont(.body)
                    } else {
                        Image(systemName: "clock.arrow.circlepath")
                            .scaledFont(.body)
                    }
                }
                .buttonStyle(HoverButtonStyle())
                .help("Show Chats...")
                .accessibilityLabel("Show Chats...")
            }
        }
    }
    
    struct SettingsButton: View {
        let store: StoreOf<ChatPanelFeature>

        var body: some View {
            WithPerceptionTracking {
                Button(action: {
                    store.send(.openSettings)
                }) {
                    Image(systemName: "gearshape")
                        .scaledFont(.body)
                }
                .buttonStyle(HoverButtonStyle())
                .help("Open Settings")
                .accessibilityLabel("Open Settings")
            }
        }
=======
                let collection = store.chatTabGroup.tabCollection
                Menu {
                    ForEach(0..<collection.endIndex, id: \.self) { index in
                        switch collection[index] {
                        case let .kind(kind):
                            Button(action: {
                                store.send(.createNewTapButtonClicked(kind: kind))
                            }) {
                                Text(kind.title)
                            }.disabled(kind.builder is DisabledChatTabBuilder)
                        case let .folder(title, list):
                            Menu {
                                ForEach(0..<list.endIndex, id: \.self) { index in
                                    Button(action: {
                                        store.send(
                                            .createNewTapButtonClicked(kind: list[index])
                                        )
                                    }) {
                                        Text(list[index].title)
                                    }
                                }
                            } label: {
                                Text(title)
                            }
                        }
                    }
                } label: {
                    Image(systemName: "plus")
                } primaryAction: {
                    store.send(.createNewTapButtonClicked(kind: nil))
                }
                .foregroundColor(.secondary)
                .menuStyle(.borderedButton)
                .padding(.horizontal, 4)
                .fixedSize(horizontal: true, vertical: false)
                .onHover { isHovering in
                    if isHovering {
                        store.send(.createNewTapButtonHovered)
                    }
                }
            }
        }
    }
}

struct ChatTabBarDropDelegate: DropDelegate {
    let store: StoreOf<ChatPanelFeature>
    let tabs: IdentifiedArray<String, ChatTabInfo>
    let itemId: String
    @Binding var draggingTabId: String?

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        draggingTabId = nil
        return true
    }

    func dropEntered(info: DropInfo) {
        guard itemId != draggingTabId else { return }
        let from = tabs.firstIndex { $0.id == draggingTabId }
        let to = tabs.firstIndex { $0.id == itemId }
        guard let from, let to, from != to else { return }
        store.send(.moveChatTab(from: from, to: to))
>>>>>>> 4a8ae39... Pre-release 0.22.73
    }
}

struct ChatTabBarButton<Content: View, Icon: View>: View {
    let store: StoreOf<ChatPanelFeature>
    let info: ChatTabInfo
    let content: () -> Content
    let icon: () -> Icon
    let isSelected: Bool
    @State var isHovered: Bool = false

    var body: some View {
<<<<<<< HEAD
        if self.isSelected {
            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    icon()
                        .buttonStyle(.plain)
                }
                .font(.callout)
                .lineLimit(1)
            }
            .frame(maxHeight: .infinity)
        }
=======
        HStack(spacing: 0) {
            HStack(spacing: 4) {
                icon().foregroundColor(.secondary)
                content()
            }
            .font(.callout)
            .lineLimit(1)
            .frame(maxWidth: 120)
            .padding(.horizontal, 28)
            .contentShape(Rectangle())
            .onTapGesture {
                store.send(.tabClicked(id: info.id))
            }
            .overlay(alignment: .leading) {
                Button(action: {
                    store.send(.closeTabButtonClicked(id: info.id))
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                .padding(2)
                .padding(.leading, 8)
                .opacity(isHovered ? 1 : 0)
            }
            .onHover { isHovered = $0 }
            .animation(.linear(duration: 0.1), value: isHovered)
            .animation(.linear(duration: 0.1), value: isSelected)

            Divider().padding(.vertical, 6)
        }
        .background(isSelected ? Color(nsColor: .selectedControlColor) : Color.clear)
        .frame(maxHeight: .infinity)
>>>>>>> 4a8ae39... Pre-release 0.22.73
    }
}

struct ChatTabContainer: View {
    let store: StoreOf<ChatPanelFeature>
    @Environment(\.chatTabPool) var chatTabPool
<<<<<<< HEAD
    @State private var pasteMonitor: Any?

    var body: some View {
        WithPerceptionTracking {
            let tabInfoArray = store.currentChatWorkspace?.tabInfo
            let selectedTabId = store.currentChatWorkspace?.selectedTabId
                ?? store.currentChatWorkspace?.tabInfo.first?.id
                ?? ""

            if let tabInfoArray = tabInfoArray, !tabInfoArray.isEmpty {
                activeTabsView(
                    tabInfoArray: tabInfoArray,
                    selectedTabId: selectedTabId
                )
            } else {
                // Fallback view for empty state (rarely seen in practice)
                EmptyView().frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            setupPasteMonitor()
        }
        .onDisappear {
            removePasteMonitor()
        }
    }

    // View displayed when there are active tabs
    private func activeTabsView(
        tabInfoArray: IdentifiedArray<String, ChatTabInfo>,
        selectedTabId: String
    ) -> some View {
        GeometryReader { geometry in
            if tabInfoArray[id: selectedTabId] != nil,
               let tab = chatTabPool.getTab(of: selectedTabId) {
                tab.body
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
            } else {
                // Fallback if selected tab is not found
                EmptyView()
            }
        }
    }
    
    private func setupPasteMonitor() {
        pasteMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            guard event.modifierFlags.contains(.command),
                  event.charactersIgnoringModifiers?.lowercased() == "v" else {
                return event
            }
            
            // Find the active chat tab and forward paste event to it
            if let activeConversationTab = getActiveConversationTab() {
                if !activeConversationTab.handlePasteEvent() {
                    return event
                }
            }
            
            return nil
        }
    }
    
    private func removePasteMonitor() {
        if let monitor = pasteMonitor {
            NSEvent.removeMonitor(monitor)
            pasteMonitor = nil
        }
    }
    
    private func getActiveConversationTab() -> ConversationTab? {
        guard let selectedTabId = store.currentChatWorkspace?.selectedTabId,
              let chatTab = chatTabPool.getTab(of: selectedTabId) as? ConversationTab else {
            return nil
        }
        return chatTab
=======

    var body: some View {
        WithPerceptionTracking {
            let tabInfo = store.chatTabGroup.tabInfo
            let selectedTabId = store.chatTabGroup.selectedTabId
                ?? store.chatTabGroup.tabInfo.first?.id
                ?? ""

            ZStack {
                if tabInfo.isEmpty {
                    Text("Empty")
                } else {
                    ForEach(tabInfo) { tabInfo in
                        if let tab = chatTabPool.getTab(of: tabInfo.id) {
                            let isActive = tab.id == selectedTabId
                            tab.body
                                .opacity(isActive ? 1 : 0)
                                .disabled(!isActive)
                                .allowsHitTesting(isActive)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                // move it out of window
                                .rotationEffect(
                                    isActive ? .zero : .degrees(90),
                                    anchor: .topLeading
                                )
                        } else {
                            EmptyView()
                        }
                    }
                }
            }
        }
>>>>>>> 4a8ae39... Pre-release 0.22.73
    }
}

struct CreateOtherChatTabMenuStyle: MenuStyle {
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: "chevron.down")
            .resizable()
<<<<<<< HEAD
            .scaledFrame(width: 7, height: 4)
=======
            .frame(width: 7, height: 4)
>>>>>>> 4a8ae39... Pre-release 0.22.73
            .frame(maxHeight: .infinity)
            .padding(.leading, 4)
            .padding(.trailing, 8)
            .foregroundColor(.secondary)
    }
}

struct ChatWindowView_Previews: PreviewProvider {
    static let pool = ChatTabPool([
        "2": EmptyChatTab(id: "2"),
        "3": EmptyChatTab(id: "3"),
        "4": EmptyChatTab(id: "4"),
        "5": EmptyChatTab(id: "5"),
        "6": EmptyChatTab(id: "6"),
        "7": EmptyChatTab(id: "7"),
    ])

    static func createStore() -> StoreOf<ChatPanelFeature> {
        StoreOf<ChatPanelFeature>(
            initialState: .init(
<<<<<<< HEAD
                chatHistory: .init(
                    workspaces: [
                        .init(
                            id: .init(path: "p", username: "u"),
                            tabInfo: [
                                .init(id: "2", title: "Empty-2", workspacePath: "path", username: "username"),
                                .init(id: "3", title: "Empty-3", workspacePath: "path", username: "username"),
                                .init(id: "4", title: "Empty-4", workspacePath: "path", username: "username"),
                                .init(id: "5", title: "Empty-5", workspacePath: "path", username: "username"),
                                .init(id: "6", title: "Empty-6", workspacePath: "path", username: "username"),
                                .init(id: "7", title: "Empty-7", workspacePath: "path", username: "username"),
                            ] as IdentifiedArray<String, ChatTabInfo>,
                            selectedTabId: "2"
                        ) { _ in }
                    ] as IdentifiedArray<WorkspaceIdentifier, ChatWorkspace>,
                    selectedWorkspacePath: "activeWorkspacePath",
                    selectedWorkspaceName: "activeWorkspacePath"
=======
                chatTabGroup: .init(
                    tabInfo: [
                        .init(id: "2", title: "Empty-2"),
                        .init(id: "3", title: "Empty-3"),
                        .init(id: "4", title: "Empty-4"),
                        .init(id: "5", title: "Empty-5"),
                        .init(id: "6", title: "Empty-6"),
                        .init(id: "7", title: "Empty-7"),
                    ] as IdentifiedArray<String, ChatTabInfo>,
                    selectedTabId: "2"
>>>>>>> 4a8ae39... Pre-release 0.22.73
                ),
                isPanelDisplayed: true
            ),
            reducer: { ChatPanelFeature() }
        )
    }

    static var previews: some View {
        ChatWindowView(store: createStore(), toggleVisibility: { _ in })
            .xcodeStyleFrame()
            .padding()
            .environment(\.chatTabPool, pool)
    }
}

<<<<<<< HEAD
struct ChatLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        ChatLoadingView()
    }
}
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
