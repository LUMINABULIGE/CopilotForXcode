import ComposableArchitecture
import Dependencies
import Foundation
import SwiftUI
<<<<<<< HEAD
import AppKitExtension

public enum ToastLevel {
    case info
    case warning
    case danger
    case error
    
    var icon: String {
        switch self {
        case .warning: return "exclamationmark.circle.fill"
        case .danger: return "exclamationmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .info: return "exclamationmark.triangle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .warning: return Color(nsColor: .systemOrange)
        case .danger, .error: return Color(nsColor: .systemRed)
        case .info: return Color.accentColor
        }
    }
}

public struct ToastKey: EnvironmentKey {
    public static var defaultValue: (String, ToastLevel) -> Void = { _, _ in }
}

public extension EnvironmentValues {
    var toast: (String, ToastLevel) -> Void {
=======

public enum ToastType {
    case info
    case warning
    case error
}

public struct ToastKey: EnvironmentKey {
    public static var defaultValue: (String, ToastType) -> Void = { _, _ in }
}

public extension EnvironmentValues {
    var toast: (String, ToastType) -> Void {
>>>>>>> 4a8ae39... Pre-release 0.22.73
        get { self[ToastKey.self] }
        set { self[ToastKey.self] = newValue }
    }
}

public struct ToastControllerDependencyKey: DependencyKey {
    public static let liveValue = ToastController(messages: [])
}

public extension DependencyValues {
    var toastController: ToastController {
        get { self[ToastControllerDependencyKey.self] }
        set { self[ToastControllerDependencyKey.self] = newValue }
    }

<<<<<<< HEAD
    var toast: (String, ToastLevel) -> Void {
        return { content, level in
            toastController.toast(content: content, level: level, namespace: nil)
        }
    }

    var namespacedToast: (String, ToastLevel, String) -> Void {
        return {
            content, level, namespace in
            toastController.toast(content: content, level: level, namespace: namespace)
        }
    }
    
    var persistentToast: (String, String, ToastLevel) -> Void {
        return { title, content, level in
            toastController.toast(title: title, content: content, level: level, namespace: nil)
=======
    var toast: (String, ToastType) -> Void {
        return { content, type in
            toastController.toast(content: content, type: type, namespace: nil)
        }
    }

    var namespacedToast: (String, ToastType, String) -> Void {
        return {
            content, type, namespace in
            toastController.toast(content: content, type: type, namespace: namespace)
>>>>>>> 4a8ae39... Pre-release 0.22.73
        }
    }
}

<<<<<<< HEAD
public struct ToastButton: Equatable {
    public let title: String
    public let action: () -> Void

    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    public static func ==(lhs: ToastButton, rhs: ToastButton) -> Bool {
        lhs.title == rhs.title
    }
}

public class ToastController: ObservableObject {
    public struct Message: Identifiable, Equatable {
        public var namespace: String?
        public var title: String?
        public var id: UUID
        public var level: ToastLevel
        public var content: Text
        public var button: ToastButton?

        // Convenience initializer for auto-dismissing messages (no title, no button)
        public init(
            id: UUID = UUID(),
            level: ToastLevel,
            namespace: String? = nil,
            content: Text
        ) {
            self.id = id
            self.level = level
            self.namespace = namespace
            self.title = nil
            self.content = content
            self.button = nil
        }

        // Convenience initializer for persistent messages (title is required)
        public init(
            id: UUID = UUID(),
            level: ToastLevel,
            namespace: String? = nil,
            title: String,
            content: Text,
            button: ToastButton? = nil
        ) {
            self.id = id
            self.level = level
            self.namespace = namespace
            self.title = title
            self.content = content
            self.button = button
=======
public class ToastController: ObservableObject {
    public struct Message: Identifiable, Equatable {
        public var namespace: String?
        public var id: UUID
        public var type: ToastType
        public var content: Text
        public init(id: UUID, type: ToastType, namespace: String? = nil, content: Text) {
            self.namespace = namespace
            self.id = id
            self.type = type
            self.content = content
>>>>>>> 4a8ae39... Pre-release 0.22.73
        }
    }

    @Published public var messages: [Message] = []

    public init(messages: [Message]) {
        self.messages = messages
    }

<<<<<<< HEAD
    @MainActor
    private func removeMessageWithAnimation(withId id: UUID) {
        withAnimation(.easeInOut(duration: 0.2)) {
            messages.removeAll { $0.id == id }
        }
    }

    private func showMessage(_ message: Message, autoDismissDelay: UInt64?) {
=======
    public func toast(content: String, type: ToastType, namespace: String? = nil) {
        let id = UUID()
        let message = Message(id: id, type: type, namespace: namespace, content: Text(content))

>>>>>>> 4a8ae39... Pre-release 0.22.73
        Task { @MainActor in
            withAnimation(.easeInOut(duration: 0.2)) {
                messages.append(message)
                messages = messages.suffix(3)
            }
<<<<<<< HEAD
            if let autoDismissDelay = autoDismissDelay {
                try await Task.sleep(nanoseconds: autoDismissDelay)
                removeMessageWithAnimation(withId: message.id)
            }
        }
    }

    // Auto-dismissing toast (title and button are not allowed)
    public func toast(
        content: String,
        level: ToastLevel,
        namespace: String? = nil
    ) {
        let message = Message(level: level, namespace: namespace, content: Text(content))
        showMessage(message, autoDismissDelay: 4_000_000_000)
    }

    // Persistent toast (title is required, button is optional)
    public func toast(
        title: String,
        content: String,
        level: ToastLevel,
        namespace: String? = nil,
        button: ToastButton? = nil
    ) {
        // Support markdown in persistent toasts
        let contentText: Text
        if let attributedString = try? AttributedString(markdown: content) {
            contentText = Text(attributedString)
        } else {
            contentText = Text(content)
        }
        let message = Message(
            level: level,
            namespace: namespace,
            title: title,
            content: contentText,
            button: button
        )
        showMessage(message, autoDismissDelay: nil)
    }
    
    public func dismissMessage(withId id: UUID) {
        Task { @MainActor in
            removeMessageWithAnimation(withId: id)
        }
    }
=======
            try await Task.sleep(nanoseconds: 4_000_000_000)
            withAnimation(.easeInOut(duration: 0.2)) {
                messages.removeAll { $0.id == id }
            }
        }
    }
>>>>>>> 4a8ae39... Pre-release 0.22.73
}

@Reducer
public struct Toast {
    public typealias Message = ToastController.Message
    
    @ObservableState
    public struct State: Equatable {
        var isObservingToastController = false
        public var messages: [Message] = []

        public init(messages: [Message] = []) {
            self.messages = messages
        }
    }

    public enum Action: Equatable {
        case start
        case updateMessages([Message])
<<<<<<< HEAD
        case toast(String, ToastLevel, String?)
        case toastPersistent(String, String, ToastLevel, String?, ToastButton?)
=======
        case toast(String, ToastType, String?)
>>>>>>> 4a8ae39... Pre-release 0.22.73
    }

    @Dependency(\.toastController) var toastController

    struct CancelID: Hashable {}

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .start:
                guard !state.isObservingToastController else { return .none }
                state.isObservingToastController = true
                return .run { send in
                    let stream = AsyncStream<[Message]> { continuation in
                        let cancellable = toastController.$messages.sink { newValue in
                            continuation.yield(newValue)
                        }
                        continuation.onTermination = { _ in
                            cancellable.cancel()
                        }
                    }
                    for await newValue in stream {
                        try Task.checkCancellation()
                        await send(.updateMessages(newValue), animation: .linear(duration: 0.2))
                    }
                }.cancellable(id: CancelID(), cancelInFlight: true)
            case let .updateMessages(messages):
                state.messages = messages
                return .none
<<<<<<< HEAD
            case let .toast(content, level, namespace):
                toastController.toast(content: content, level: level, namespace: namespace)
                return .none
            case let .toastPersistent(title, content, level, namespace, button):
                toastController
                    .toast(
                        title: title,
                        content: content,
                        level: level,
                        namespace: namespace,
                        button: button
                    )
=======
            case let .toast(content, type, namespace):
                toastController.toast(content: content, type: type, namespace: namespace)
>>>>>>> 4a8ae39... Pre-release 0.22.73
                return .none
            }
        }
    }
}

<<<<<<< HEAD
public extension NSWorkspace {
    /// Opens the System Preferences/Settings app at the Extensions pane
    /// - Parameter extensionPointIdentifier: Optional identifier for specific extension type
    static func openExtensionsPreferences(extensionPointIdentifier: String? = nil) {
        if #available(macOS 13.0, *) {
            var urlString = "x-apple.systempreferences:com.apple.ExtensionsPreferences"
            if let extensionPointIdentifier = extensionPointIdentifier {
                urlString += "?extensionPointIdentifier=\(extensionPointIdentifier)"
            }
            NSWorkspace.shared.open(URL(string: urlString)!)
        } else {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/open")
            process.arguments = [
                "-b",
                "com.apple.systempreferences",
                "/System/Library/PreferencePanes/Extensions.prefPane"
            ]
            
            do {
                try process.run()
            } catch {
                // Handle error silently
                return
            }
        }
    }
    
    /// Opens the Xcode Extensions preferences directly
    static func openXcodeExtensionsPreferences() {
        openExtensionsPreferences(extensionPointIdentifier: "com.apple.dt.Xcode.extension.source-editor")
    }
    
    static func restartXcode() {
        // Find current Xcode path before quitting
        // Restart if we found a valid path
        if let xcodeURL = getXcodeBundleURL() {
            // Quit Xcode
            let script = NSAppleScript(source: "tell application \"Xcode\" to quit")
            script?.executeAndReturnError(nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                NSWorkspace.shared.openApplication(
                    at: xcodeURL,
                    configuration: NSWorkspace.OpenConfiguration()
                )
            }
        }
    }
}
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
