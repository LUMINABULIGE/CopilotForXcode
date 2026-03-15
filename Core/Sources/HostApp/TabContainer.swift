import ComposableArchitecture
import Dependencies
import Foundation
import LaunchAgentManager
import SwiftUI
import Toast
import UpdateChecker
<<<<<<< HEAD
import Client
import Logger
import Combine

@MainActor
public let hostAppStore: StoreOf<HostApp> = .init(initialState: .init(), reducer: { HostApp() })
=======

@MainActor
let hostAppStore: StoreOf<HostApp> = .init(initialState: .init(), reducer: { HostApp() })
>>>>>>> 4a8ae39... Pre-release 0.22.73

public struct TabContainer: View {
    let store: StoreOf<HostApp>
    @ObservedObject var toastController: ToastController
<<<<<<< HEAD
    @ObservedObject private var featureFlags = FeatureFlagManager.shared
    @State private var tabBarItems = [TabBarItem]()
    @Binding var tag: TabIndex
=======
    @State private var tabBarItems = [TabBarItem]()
    @State var tag: Int = 0
>>>>>>> 4a8ae39... Pre-release 0.22.73

    public init() {
        toastController = ToastControllerDependencyKey.liveValue
        store = hostAppStore
<<<<<<< HEAD
        _tag = Binding(
            get: { hostAppStore.state.activeTabIndex },
            set: { hostAppStore.send(.setActiveTab($0)) }
        )
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
    }

    init(store: StoreOf<HostApp>, toastController: ToastController) {
        self.store = store
        self.toastController = toastController
<<<<<<< HEAD
        _tag = Binding(
            get: { store.state.activeTabIndex },
            set: { store.send(.setActiveTab($0)) }
        )
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
    }

    public var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                TabBar(tag: $tag, tabBarItems: tabBarItems)
                    .padding(.bottom, 8)
<<<<<<< HEAD
                ZStack(alignment: .center) {
                    GeneralView(store: store.scope(state: \.general, action: \.general)).tabBarItem(for: .general)
                    AdvancedSettings().tabBarItem(for: .advanced)
                    if featureFlags.isAgentModeEnabled {
                        MCPConfigView().tabBarItem(for: .tools)
                    }
                    if featureFlags.isBYOKEnabled {
                        BYOKConfigView().tabBarItem(for: .byok)
                    }
=======

                Divider()

                ZStack(alignment: .center) {
                    GeneralView(store: store.scope(state: \.general, action: \.general))
                        .tabBarItem(
                            tag: 0,
                            title: "General",
                            image: "gearshape"
                        )
                    FeatureSettingsView().tabBarItem(
                        tag: 2,
                        title: "Feature",
                        image: "star.square"
                    )
>>>>>>> 4a8ae39... Pre-release 0.22.73
                }
                .environment(\.tabBarTabTag, tag)
                .frame(minHeight: 400)
            }
            .focusable(false)
            .padding(.top, 8)
<<<<<<< HEAD
            .background(Color(nsColor: .controlBackgroundColor))
=======
            .background(.ultraThinMaterial.opacity(0.01))
            .background(Color(nsColor: .controlBackgroundColor).opacity(0.4))
>>>>>>> 4a8ae39... Pre-release 0.22.73
            .handleToast()
            .onPreferenceChange(TabBarItemPreferenceKey.self) { items in
                tabBarItems = items
            }
            .onAppear {
                store.send(.appear)
            }
<<<<<<< HEAD
            .onChange(of: featureFlags.isAgentModeEnabled) { isEnabled in
                if hostAppStore.state.activeTabIndex == .tools && !isEnabled {
                    hostAppStore.send(.setActiveTab(.general))
                }
            }
            .onChange(of: featureFlags.isBYOKEnabled) { isEnabled in
                if hostAppStore.state.activeTabIndex == .byok && !isEnabled {
                    hostAppStore.send(.setActiveTab(.general))
                }
            }
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
        }
    }
}

struct TabBar: View {
<<<<<<< HEAD
    @Binding var tag: TabIndex
=======
    @Binding var tag: Int
>>>>>>> 4a8ae39... Pre-release 0.22.73
    fileprivate var tabBarItems: [TabBarItem]

    var body: some View {
        HStack {
            ForEach(tabBarItems) { tab in
                TabBarButton(
                    currentTag: $tag,
                    tag: tab.tag,
                    title: tab.title,
<<<<<<< HEAD
                    image: tab.image,
                    isSystemImage: tab.isSystemImage
=======
                    image: tab.image
>>>>>>> 4a8ae39... Pre-release 0.22.73
                )
            }
        }
    }
}

struct TabBarButton: View {
<<<<<<< HEAD
    @Binding var currentTag: TabIndex
    @State var isHovered = false
    var tag: TabIndex
    var title: String
    var image: String
    var isSystemImage: Bool = true
    
    private var tabImage: Image {
        isSystemImage ? Image(systemName: image) : Image(image)
    }

    private var isSelected: Bool {
        tag == currentTag
    }
=======
    @Binding var currentTag: Int
    @State var isHovered = false
    var tag: Int
    var title: String
    var image: String
>>>>>>> 4a8ae39... Pre-release 0.22.73

    var body: some View {
        Button(action: {
            self.currentTag = tag
        }) {
            VStack(spacing: 2) {
<<<<<<< HEAD
                tabImage
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(title)
            }
            .foregroundColor(isSelected ? .blue : .gray)
=======
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 18)
                Text(title)
            }
>>>>>>> 4a8ae39... Pre-release 0.22.73
            .font(.body)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .padding(.top, 4)
            .background(
<<<<<<< HEAD
                isSelected
=======
                tag == currentTag
>>>>>>> 4a8ae39... Pre-release 0.22.73
                    ? Color(nsColor: .textColor).opacity(0.1)
                    : Color.clear,
                in: RoundedRectangle(cornerRadius: 8)
            )
            .background(
                isHovered
                    ? Color(nsColor: .textColor).opacity(0.05)
                    : Color.clear,
                in: RoundedRectangle(cornerRadius: 8)
            )
        }
        .onHover(perform: { yes in
            isHovered = yes
        })
        .buttonStyle(.borderless)
    }
}

private struct TabBarTabViewWrapper<Content: View>: View {
    @Environment(\.tabBarTabTag) var tabBarTabTag
<<<<<<< HEAD
    var tag: TabIndex
    var title: String
    var image: String
    var isSystemImage: Bool = true
=======
    var tag: Int
    var title: String
    var image: String
>>>>>>> 4a8ae39... Pre-release 0.22.73
    var content: () -> Content

    var body: some View {
        Group {
            if tag == tabBarTabTag {
                content()
            } else {
                Color.clear
            }
        }
        .preference(
            key: TabBarItemPreferenceKey.self,
<<<<<<< HEAD
            value: [.init(tag: tag, title: title, image: image, isSystemImage: isSystemImage)]
=======
            value: [.init(tag: tag, title: title, image: image)]
>>>>>>> 4a8ae39... Pre-release 0.22.73
        )
    }
}

private extension View {
<<<<<<< HEAD
    func tabBarItem(for tag: TabIndex) -> some View {
        TabBarTabViewWrapper(
            tag: tag,
            title: tag.title,
            image: tag.image,
            isSystemImage: tag.isSystemImage,
=======
    func tabBarItem(
        tag: Int,
        title: String,
        image: String
    ) -> some View {
        TabBarTabViewWrapper(
            tag: tag,
            title: title,
            image: image,
>>>>>>> 4a8ae39... Pre-release 0.22.73
            content: { self }
        )
    }
}

private struct TabBarItem: Identifiable, Equatable {
<<<<<<< HEAD
    var id: TabIndex { tag }
    var tag: TabIndex
    var title: String
    var image: String
    var isSystemImage: Bool = true
=======
    var id: Int { tag }
    var tag: Int
    var title: String
    var image: String
>>>>>>> 4a8ae39... Pre-release 0.22.73
}

private struct TabBarItemPreferenceKey: PreferenceKey {
    static var defaultValue: [TabBarItem] = []
    static func reduce(value: inout [TabBarItem], nextValue: () -> [TabBarItem]) {
        value.append(contentsOf: nextValue())
    }
}

private struct TabBarTabTagKey: EnvironmentKey {
<<<<<<< HEAD
    static var defaultValue: TabIndex = .general
}

private extension EnvironmentValues {
    var tabBarTabTag: TabIndex {
=======
    static var defaultValue: Int = 0
}

private extension EnvironmentValues {
    var tabBarTabTag: Int {
>>>>>>> 4a8ae39... Pre-release 0.22.73
        get { self[TabBarTabTagKey.self] }
        set { self[TabBarTabTagKey.self] = newValue }
    }
}

struct UpdateCheckerKey: EnvironmentKey {
<<<<<<< HEAD
    static var defaultValue: UpdateCheckerProtocol = NoopUpdateChecker()
}

public extension EnvironmentValues {
    var updateChecker: UpdateCheckerProtocol {
=======
    static var defaultValue: UpdateChecker = .init(hostBundle: nil)
}

public extension EnvironmentValues {
    var updateChecker: UpdateChecker {
>>>>>>> 4a8ae39... Pre-release 0.22.73
        get { self[UpdateCheckerKey.self] }
        set { self[UpdateCheckerKey.self] = newValue }
    }
}

// MARK: - Previews

struct TabContainer_Previews: PreviewProvider {
    static var previews: some View {
        TabContainer()
            .frame(width: 800)
    }
}

struct TabContainer_Toasts_Previews: PreviewProvider {
    static var previews: some View {
        TabContainer(
            store: .init(initialState: .init(), reducer: { HostApp() }),
            toastController: .init(messages: [
<<<<<<< HEAD
                .init(id: UUID(), level: .info, content: Text("info")),
                .init(id: UUID(), level: .error, content: Text("error")),
                .init(id: UUID(), level: .warning, content: Text("warning")),
=======
                .init(id: UUID(), type: .info, content: Text("info")),
                .init(id: UUID(), type: .error, content: Text("error")),
                .init(id: UUID(), type: .warning, content: Text("warning")),
>>>>>>> 4a8ae39... Pre-release 0.22.73
            ])
        )
        .frame(width: 800)
    }
}

<<<<<<< HEAD
@available(macOS 14.0, *)
@MainActor
public struct SettingsEnvironment: View {
    @Environment(\.openSettings) public var openSettings: OpenSettingsAction
    
    public init() {}
    
    public var body: some View {
        EmptyView().onAppear {
            openSettings()
        }
    }
    
    public func open() {
        let controller = NSHostingController(rootView: self)
        let window = NSWindow(contentViewController: controller)
        window.orderFront(nil)
        // Close the temporary window after settings are opened
        DispatchQueue.main.async {
            window.close()
        }
    }
}
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
