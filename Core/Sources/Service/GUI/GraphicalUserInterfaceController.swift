import ActiveApplicationMonitor
import AppActivator
import AppKit
import ConversationTab
import ChatTab
import ComposableArchitecture
import Dependencies
import Preferences
import SuggestionBasic
import SuggestionWidget
<<<<<<< HEAD
import PersistMiddleware
import ChatService
import Persist
import Workspace
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

#if canImport(ChatTabPersistent)
import ChatTabPersistent
#endif

@Reducer
struct GUI {
    @ObservableState
    struct State: Equatable {
        var suggestionWidgetState = WidgetFeature.State()

<<<<<<< HEAD
        var chatHistory: ChatHistory {
            get { suggestionWidgetState.chatPanelState.chatHistory }
            set { suggestionWidgetState.chatPanelState.chatHistory = newValue }
=======
        var chatTabGroup: ChatPanelFeature.ChatTabGroup {
            get { suggestionWidgetState.chatPanelState.chatTabGroup }
            set { suggestionWidgetState.chatPanelState.chatTabGroup = newValue }
>>>>>>> 4a8ae39... Pre-release 0.22.73
        }

        var promptToCodeGroup: PromptToCodeGroup.State {
            get { suggestionWidgetState.panelState.content.promptToCodeGroup }
            set { suggestionWidgetState.panelState.content.promptToCodeGroup = newValue }
        }
    }

    enum Action {
        case start
        case openChatPanel(forceDetach: Bool)
        case createAndSwitchToChatTabIfNeeded
<<<<<<< HEAD
//        case createAndSwitchToBrowserTabIfNeeded(url: URL)
=======
        case createAndSwitchToBrowserTabIfNeeded(url: URL)
>>>>>>> 4a8ae39... Pre-release 0.22.73
        case sendCustomCommandToActiveChat(CustomCommand)
        case toggleWidgetsHotkeyPressed

        case suggestionWidget(WidgetFeature.Action)
<<<<<<< HEAD
        case switchWorkspace(path: String, name: String, username: String)
        case initWorkspaceChatTabIfNeeded(path: String, username: String)
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

        static func promptToCodeGroup(_ action: PromptToCodeGroup.Action) -> Self {
            .suggestionWidget(.panel(.sharedPanel(.promptToCodeGroup(action))))
        }

        #if canImport(ChatTabPersistent)
        case persistent(ChatTabPersistent.Action)
        #endif
    }

    @Dependency(\.chatTabPool) var chatTabPool
    @Dependency(\.activateThisApp) var activateThisApp

    public enum Debounce: Hashable {
        case updateChatTabOrder
    }

    var body: some ReducerOf<Self> {
        CombineReducers {
            Scope(state: \.suggestionWidgetState, action: \.suggestionWidget) {
                WidgetFeature()
            }

            Scope(
<<<<<<< HEAD
                state: \.chatHistory,
                action: \.suggestionWidget.chatPanel
            ) {
                Reduce { state, action in
                    switch action {
                    case let .createNewTapButtonClicked(kind):
//                        return .run { send in
//                            if let (_, chatTabInfo) = await chatTabPool.createTab(for: kind) {
//                                await send(.createNewTab(chatTabInfo))
//                            }
//                        }
                        // The chat workspace should exist before create tab
                        guard let currentChatWorkspace = state.currentChatWorkspace else { return .none }
                        
                        return .run { send in
                            if let (_, chatTabInfo) = await chatTabPool.createTab(for: kind, with: currentChatWorkspace) {
                                await send(.appendAndSelectTab(chatTabInfo))
                            }
                        }
                    case .restoreTabByInfo(let info):
                        guard let currentChatWorkspace = state.currentChatWorkspace else { return .none }
                        
                        return .run { send in
                            if let _ = await chatTabPool.restoreTab(by: info, with: currentChatWorkspace) {
                                await send(.appendAndSelectTab(info))
                            }
                        }
                        
                    case .createNewTabByID(let id):
                        guard let currentChatWorkspace = state.currentChatWorkspace else { return .none }
                        
                        return .run { send in
                            if let (_, info) = await chatTabPool.createTab(id: id, with: currentChatWorkspace) {
                                await send(.appendAndSelectTab(info))
                            }
                        }

//                    case let .closeTabButtonClicked(id):
//                        return .run { _ in
//                            chatTabPool.removeTab(of: id)
//                        }

                    case let .chatTab(_, .openNewTab(builder)):
                        // The chat workspace should exist before create tab
                        guard let currentChatWorkspace = state.currentChatWorkspace else { return .none }
                        return .run { send in
                            if let (_, chatTabInfo) = await chatTabPool
                                .createTab(from: builder.chatTabBuilder, with: currentChatWorkspace)
=======
                state: \.chatTabGroup,
                action: \.suggestionWidget.chatPanel
            ) {
                Reduce { _, action in
                    switch action {
                    case let .createNewTapButtonClicked(kind):
                        return .run { send in
                            if let (_, chatTabInfo) = await chatTabPool.createTab(for: kind) {
                                await send(.appendAndSelectTab(chatTabInfo))
                            }
                        }

                    case let .closeTabButtonClicked(id):
                        return .run { _ in
                            chatTabPool.removeTab(of: id)
                        }

                    case let .chatTab(_, .openNewTab(builder)):
                        return .run { send in
                            if let (_, chatTabInfo) = await chatTabPool
                                .createTab(from: builder.chatTabBuilder)
>>>>>>> 4a8ae39... Pre-release 0.22.73
                            {
                                await send(.appendAndSelectTab(chatTabInfo))
                            }
                        }

                    default:
                        return .none
                    }
                }
            }

            #if canImport(ChatTabPersistent)
            Scope(state: \.persistentState, action: \.persistent) {
                ChatTabPersistent()
            }
            #endif

            Reduce { state, action in
                switch action {
                case .start:
                    #if canImport(ChatTabPersistent)
                    return .run { send in
                        await send(.persistent(.restoreChatTabs))
                    }
                    #else
                    return .none
                    #endif

                case let .openChatPanel(forceDetach):
                    return .run { send in
                        await send(
                            .suggestionWidget(
                                .chatPanel(.presentChatPanel(forceDetach: forceDetach))
                            )
                        )
                        await send(.suggestionWidget(.updateKeyWindow(.chatPanel)))

                        activateThisApp()
                    }

                case .createAndSwitchToChatTabIfNeeded:
<<<<<<< HEAD
                    // The chat workspace should exist before create tab
                    guard let currentChatWorkspace = state.chatHistory.currentChatWorkspace else { return .none }
                    
                    if let selectedTabInfo = currentChatWorkspace.selectedTabInfo,
=======
                    if let selectedTabInfo = state.chatTabGroup.selectedTabInfo,
>>>>>>> 4a8ae39... Pre-release 0.22.73
                       chatTabPool.getTab(of: selectedTabInfo.id) is ConversationTab
                    {
                        // Already in Chat tab
                        return .none
                    }

<<<<<<< HEAD
                    if let firstChatTabInfo = state.chatHistory.currentChatWorkspace?.tabInfo.first(where: {
=======
                    if let firstChatTabInfo = state.chatTabGroup.tabInfo.first(where: {
>>>>>>> 4a8ae39... Pre-release 0.22.73
                        chatTabPool.getTab(of: $0.id) is ConversationTab
                    }) {
                        return .run { send in
                            await send(.suggestionWidget(.chatPanel(.tabClicked(
                                id: firstChatTabInfo.id
                            ))))
                        }
                    }
                    return .run { send in
<<<<<<< HEAD
                        if let (_, chatTabInfo) = await chatTabPool.createTab(for: nil, with: currentChatWorkspace) {
=======
                        if let (_, chatTabInfo) = await chatTabPool.createTab(for: nil) {
>>>>>>> 4a8ae39... Pre-release 0.22.73
                            await send(
                                .suggestionWidget(.chatPanel(.appendAndSelectTab(chatTabInfo)))
                            )
                        }
                    }

<<<<<<< HEAD
                case let .switchWorkspace(path, name, username):
                    return .run { send in
                        await send(
                            .suggestionWidget(.chatPanel(.switchWorkspace(path, name, username)))
                        )
                    }
                case let .initWorkspaceChatTabIfNeeded(path, username):
                    let identifier = WorkspaceIdentifier(path: path, username: username)
                    guard let chatWorkspace = state.chatHistory.workspaces[id: identifier], chatWorkspace.tabInfo.isEmpty
                            else { return .none }
                    return .run { send in
                        if let (_, chatTabInfo) = await chatTabPool.createTab(for: nil, with: chatWorkspace) {
                            await send(
                                .suggestionWidget(.chatPanel(.appendTabToWorkspace(chatTabInfo, chatWorkspace)))
                                )
                        }
                    }
//                case let .createAndSwitchToBrowserTabIfNeeded(url):
//                    #if canImport(BrowserChatTab)
//                    func match(_ tabURL: URL?) -> Bool {
//                        guard let tabURL else { return false }
//                        return tabURL == url
//                            || tabURL.absoluteString.hasPrefix(url.absoluteString)
//                    }
//
//                    if let selectedTabInfo = state.chatTabGroup.selectedTabInfo,
//                       let tab = chatTabPool.getTab(of: selectedTabInfo.id) as? BrowserChatTab,
//                       match(tab.url)
//                    {
//                        // Already in the target Browser tab
//                        return .none
//                    }
//
//                    if let firstChatTabInfo = state.chatTabGroup.tabInfo.first(where: {
//                        guard let tab = chatTabPool.getTab(of: $0.id) as? BrowserChatTab,
//                              match(tab.url)
//                        else { return false }
//                        return true
//                    }) {
//                        return .run { send in
//                            await send(.suggestionWidget(.chatPanel(.tabClicked(
//                                id: firstChatTabInfo.id
//                            ))))
//                        }
//                    }
//
//                    return .run { send in
//                        if let (_, chatTabInfo) = await chatTabPool.createTab(
//                            for: .init(BrowserChatTab.urlChatBuilder(
//                                url: url,
//                                externalDependency: ChatTabFactory
//                                    .externalDependenciesForBrowserChatTab()
//                            ))
//                        ) {
//                            await send(
//                                .suggestionWidget(.chatPanel(.appendAndSelectTab(chatTabInfo)))
//                            )
//                        }
//                    }
//
//                    #else
//                    return .none
//                    #endif
=======
                case let .createAndSwitchToBrowserTabIfNeeded(url):
                    #if canImport(BrowserChatTab)
                    func match(_ tabURL: URL?) -> Bool {
                        guard let tabURL else { return false }
                        return tabURL == url
                            || tabURL.absoluteString.hasPrefix(url.absoluteString)
                    }

                    if let selectedTabInfo = state.chatTabGroup.selectedTabInfo,
                       let tab = chatTabPool.getTab(of: selectedTabInfo.id) as? BrowserChatTab,
                       match(tab.url)
                    {
                        // Already in the target Browser tab
                        return .none
                    }

                    if let firstChatTabInfo = state.chatTabGroup.tabInfo.first(where: {
                        guard let tab = chatTabPool.getTab(of: $0.id) as? BrowserChatTab,
                              match(tab.url)
                        else { return false }
                        return true
                    }) {
                        return .run { send in
                            await send(.suggestionWidget(.chatPanel(.tabClicked(
                                id: firstChatTabInfo.id
                            ))))
                        }
                    }

                    return .run { send in
                        if let (_, chatTabInfo) = await chatTabPool.createTab(
                            for: .init(BrowserChatTab.urlChatBuilder(
                                url: url,
                                externalDependency: ChatTabFactory
                                    .externalDependenciesForBrowserChatTab()
                            ))
                        ) {
                            await send(
                                .suggestionWidget(.chatPanel(.appendAndSelectTab(chatTabInfo)))
                            )
                        }
                    }

                    #else
                    return .none
                    #endif
>>>>>>> 4a8ae39... Pre-release 0.22.73

                case let .sendCustomCommandToActiveChat(command):
                    @Sendable func stopAndHandleCommand(_ tab: ConversationTab) async {
                        if tab.service.isReceivingMessage {
                            await tab.service.stopReceivingMessage()
                        }
                        try? await tab.service.handleCustomCommand(command)
                    }
<<<<<<< HEAD
                    
                    guard var currentChatWorkspace = state.chatHistory.currentChatWorkspace else { return .none }

                    if let info = currentChatWorkspace.selectedTabInfo,
=======

                    if let info = state.chatTabGroup.selectedTabInfo,
>>>>>>> 4a8ae39... Pre-release 0.22.73
                       let activeTab = chatTabPool.getTab(of: info.id) as? ConversationTab
                    {
                        return .run { send in
                            await send(.openChatPanel(forceDetach: false))
                            await stopAndHandleCommand(activeTab)
                        }
                    }

<<<<<<< HEAD
                    let chatWorkspace = currentChatWorkspace
                    if var info = currentChatWorkspace.tabInfo.first(where: {
=======
                    if let info = state.chatTabGroup.tabInfo.first(where: {
>>>>>>> 4a8ae39... Pre-release 0.22.73
                        chatTabPool.getTab(of: $0.id) is ConversationTab
                    }),
                        let chatTab = chatTabPool.getTab(of: info.id) as? ConversationTab
                    {
<<<<<<< HEAD
                        let (originalTab, currentTab) = currentChatWorkspace.switchTab(to: &info)
                        let updatedChatWorkspace = currentChatWorkspace
                        
                        return .run { send in
                            await send(.suggestionWidget(.chatPanel(.updateChatHistory(updatedChatWorkspace))))
                            await send(.openChatPanel(forceDetach: false))
                            await stopAndHandleCommand(chatTab)
                            await send(.suggestionWidget(.chatPanel(.saveChatTabInfo([originalTab, currentTab], chatWorkspace))))
                            await send(.suggestionWidget(.chatPanel(.syncChatTabInfo([originalTab, currentTab]))))
=======
                        state.chatTabGroup.selectedTabId = chatTab.id
                        return .run { send in
                            await send(.openChatPanel(forceDetach: false))
                            await stopAndHandleCommand(chatTab)
>>>>>>> 4a8ae39... Pre-release 0.22.73
                        }
                    }

                    return .run { send in
<<<<<<< HEAD
                        guard let (chatTab, chatTabInfo) = await chatTabPool.createTab(for: nil, with: chatWorkspace)
=======
                        guard let (chatTab, chatTabInfo) = await chatTabPool.createTab(for: nil)
>>>>>>> 4a8ae39... Pre-release 0.22.73
                        else {
                            return
                        }
                        await send(.suggestionWidget(.chatPanel(.appendAndSelectTab(chatTabInfo))))
                        await send(.openChatPanel(forceDetach: false))
                        if let chatTab = chatTab as? ConversationTab {
                            await stopAndHandleCommand(chatTab)
                        }
                    }

                case .toggleWidgetsHotkeyPressed:
                    return .run { send in
                        await send(.suggestionWidget(.circularWidget(.widgetClicked)))
                    }

                case let .suggestionWidget(.chatPanel(.chatTab(id, .tabContentUpdated))):
                    #if canImport(ChatTabPersistent)
                    // when a tab is updated, persist it.
                    return .run { send in
                        await send(.persistent(.chatTabUpdated(id: id)))
                    }
                    #else
                    return .none
                    #endif

<<<<<<< HEAD
//                case let .suggestionWidget(.chatPanel(.closeTabButtonClicked(id))):
//                    #if canImport(ChatTabPersistent)
//                    // when a tab is closed, remove it from persistence.
//                    return .run { send in
//                        await send(.persistent(.chatTabClosed(id: id)))
//                    }
//                    #else
//                    return .none
//                    #endif
=======
                case let .suggestionWidget(.chatPanel(.closeTabButtonClicked(id))):
                    #if canImport(ChatTabPersistent)
                    // when a tab is closed, remove it from persistence.
                    return .run { send in
                        await send(.persistent(.chatTabClosed(id: id)))
                    }
                    #else
                    return .none
                    #endif
>>>>>>> 4a8ae39... Pre-release 0.22.73

                case .suggestionWidget:
                    return .none

                #if canImport(ChatTabPersistent)
                case .persistent:
                    return .none
                #endif
                }
            }
<<<<<<< HEAD
        }
//        .onChange(of: \.chatCollection.selectedChatGroup?.tabInfo) { old, new in
//            Reduce { _, _ in
//                guard old.map(\.id) != new.map(\.id) else {
//                    return .none
//                }
//                #if canImport(ChatTabPersistent)
//                return .run { send in
//                    await send(.persistent(.chatOrderChanged))
//                }.debounce(id: Debounce.updateChatTabOrder, for: 1, scheduler: DispatchQueue.main)
//                #else
//                return .none
//                #endif
//            }
//        }
=======
        }.onChange(of: \.chatTabGroup.tabInfo) { old, new in
            Reduce { _, _ in
                guard old.map(\.id) != new.map(\.id) else {
                    return .none
                }
                #if canImport(ChatTabPersistent)
                return .run { send in
                    await send(.persistent(.chatOrderChanged))
                }.debounce(id: Debounce.updateChatTabOrder, for: 1, scheduler: DispatchQueue.main)
                #else
                return .none
                #endif
            }
        }
>>>>>>> 4a8ae39... Pre-release 0.22.73
    }
}

@MainActor
public final class GraphicalUserInterfaceController {
    let store: StoreOf<GUI>
    let widgetController: SuggestionWidgetController
    let widgetDataSource: WidgetDataSource
    let chatTabPool: ChatTabPool
<<<<<<< HEAD
    
    // Used for restoring. Handle concurrency
    var restoredChatHistory: Set<WorkspaceIdentifier> = Set()
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

    class WeakStoreHolder {
        weak var store: StoreOf<GUI>?
    }

    init() {
<<<<<<< HEAD
        @Dependency(\.workspacePool) var workspacePool
        @Dependency(\.workspaceInvoker) var workspaceInvoker
        
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
        let chatTabPool = ChatTabPool()
        let suggestionDependency = SuggestionWidgetControllerDependency()
        let setupDependency: (inout DependencyValues) -> Void = { dependencies in
            dependencies.suggestionWidgetControllerDependency = suggestionDependency
            dependencies.suggestionWidgetUserDefaultsObservers = .init()
            dependencies.chatTabPool = chatTabPool
            dependencies.chatTabBuilderCollection = ChatTabFactory.chatTabBuilderCollection
            dependencies.promptToCodeAcceptHandler = { promptToCode in
                Task {
                    let handler = PseudoCommandHandler()
                    await handler.acceptPromptToCode()
                    if !promptToCode.isContinuous {
                        NSWorkspace.activatePreviousActiveXcode()
                    } else {
                        NSWorkspace.activateThisApp()
                    }
                }
            }
        }
        let store = StoreOf<GUI>(
            initialState: .init(),
            reducer: { GUI() },
            withDependencies: setupDependency
        )
        self.store = store
        self.chatTabPool = chatTabPool
        widgetDataSource = .init()

        widgetController = SuggestionWidgetController(
            store: store.scope(
                state: \.suggestionWidgetState,
                action: \.suggestionWidget
            ),
            chatTabPool: chatTabPool,
            dependency: suggestionDependency
        )

<<<<<<< HEAD
        chatTabPool.createStore = { info in
            store.scope(
                state: { state in
                    state.chatHistory.currentChatWorkspace?.tabInfo[id: info.id] ?? info
                },
                action: { childAction in
                    .suggestionWidget(.chatPanel(.chatTab(id: info.id, action: childAction)))
=======
        chatTabPool.createStore = { id in
            store.scope(
                state: { state in
                    state.chatTabGroup.tabInfo[id: id] ?? .init(id: id, title: "")
                },
                action: { childAction in
                    .suggestionWidget(.chatPanel(.chatTab(id: id, action: childAction)))
>>>>>>> 4a8ae39... Pre-release 0.22.73
                }
            )
        }

        suggestionDependency.suggestionWidgetDataSource = widgetDataSource
        suggestionDependency.onOpenChatClicked = { [weak self] in
            Task { [weak self] in
                await self?.store.send(.createAndSwitchToChatTabIfNeeded).finish()
                self?.store.send(.openChatPanel(forceDetach: false))
            }
        }
        suggestionDependency.onCustomCommandClicked = { command in
            Task {
                let commandHandler = PseudoCommandHandler()
                await commandHandler.handleCustomCommand(command)
            }
        }
<<<<<<< HEAD
        
        workspaceInvoker.invokeFilespaceUpdate = { fileURL, content in
            guard let (workspace, _) = try? await workspacePool.fetchOrCreateWorkspaceAndFilespace(fileURL: fileURL)
            else { return }
            await workspace.didUpdateFilespace(fileURL: fileURL, content: content)
        }
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
    }

    func start() {
        store.send(.start)
    }

    public func openGlobalChat() {
        PseudoCommandHandler().openChat(forceDetach: true)
    }
}

extension ChatTabPool {
    @MainActor
    func createTab(
        id: String = UUID().uuidString,
<<<<<<< HEAD
        from builder: ChatTabBuilder? = nil,
        with chatWorkspace: ChatWorkspace
    ) async -> (any ChatTab, ChatTabInfo)? {
        let id = id
        let info = ChatTabInfo(id: id, workspacePath: chatWorkspace.workspacePath, username: chatWorkspace.username)
        guard let builder else {
            let chatTab = ConversationTab(store: createStore(info), with: info)
            setTab(chatTab)
            return (chatTab, info)
        }
        
        guard let chatTab = await builder.build(store: createStore(info)) else { return nil }
        setTab(chatTab)
        return (chatTab, info)
=======
        from builder: ChatTabBuilder
    ) async -> (any ChatTab, ChatTabInfo)? {
        let id = id
        let info = ChatTabInfo(id: id, title: "")
        guard let chatTap = await builder.build(store: createStore(id)) else { return nil }
        setTab(chatTap)
        return (chatTap, info)
>>>>>>> 4a8ae39... Pre-release 0.22.73
    }

    @MainActor
    func createTab(
<<<<<<< HEAD
        for kind: ChatTabKind?,
        with chatWorkspace: ChatWorkspace
    ) async -> (any ChatTab, ChatTabInfo)? {
        let id = UUID().uuidString
        let info = ChatTabInfo(id: id, workspacePath: chatWorkspace.workspacePath, username: chatWorkspace.username)
        guard let builder = kind?.builder else {
            let chatTab = ConversationTab(store: createStore(info), with: info)
            setTab(chatTab)
            return (chatTab, info)
        }
        
        guard let chatTab = await builder.build(store: createStore(info)) else { return nil }
        setTab(chatTab)
        return (chatTab, info)
    }
    
    @MainActor
    func restoreTab(
        by info: ChatTabInfo,
        with chaWorkspace: ChatWorkspace
    ) async -> (any ChatTab)? {
        let chatTab = ConversationTab.restoreConversation(by: info, store: createStore(info))
        setTab(chatTab)
        return chatTab
    }
}


extension GraphicalUserInterfaceController {
    
    @MainActor
    public func restore(path workspacePath: String, name workspaceName: String, username: String) async -> Void {
        let workspaceIdentifier = WorkspaceIdentifier(path: workspacePath, username: username)
        guard !restoredChatHistory.contains(workspaceIdentifier) else { return }
        
        // only restore once regardless of success or fail
        restoredChatHistory.insert(workspaceIdentifier)
        
        let metadata = StorageMetadata(workspacePath: workspacePath, username: username)
        let selectedChatTabInfo = ChatTabInfoStore.getSelected(with: metadata) ?? ChatTabInfoStore.getLatest(with: metadata)
        
        if let selectedChatTabInfo {
            let chatTab = ConversationTab.restoreConversation(by: selectedChatTabInfo, store: chatTabPool.createStore(selectedChatTabInfo))
            chatTabPool.setTab(chatTab)
            
            let chatWorkspace = ChatWorkspace(
                id: .init(path: workspacePath, username: username),
                tabInfo: [selectedChatTabInfo],
                tabCollection: [],
                selectedTabId: selectedChatTabInfo.id
            ) { [weak self] in
                self?.chatTabPool.removeTab(of: $0)
            }
            await self.store.send(.suggestionWidget(.chatPanel(.restoreWorkspace(chatWorkspace)))).finish()
        }
    }
}
=======
        for kind: ChatTabKind?
    ) async -> (any ChatTab, ChatTabInfo)? {
        let id = UUID().uuidString
        let info = ChatTabInfo(id: id, title: "")
        guard let builder = kind?.builder else {
            let chatTap = ConversationTab(store: createStore(id))
            setTab(chatTap)
            return (chatTap, info)
        }
        
        guard let chatTap = await builder.build(store: createStore(id)) else { return nil }
        setTab(chatTap)
        return (chatTap, info)
    }
}

>>>>>>> 4a8ae39... Pre-release 0.22.73
