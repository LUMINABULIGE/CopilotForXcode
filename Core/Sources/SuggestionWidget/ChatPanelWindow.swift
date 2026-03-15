import AppKit
import ChatTab
import ComposableArchitecture
import Foundation
import SwiftUI
<<<<<<< HEAD
import ConversationTab
import SharedUIComponents
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

final class ChatPanelWindow: NSWindow {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }

    private let storeObserver = NSObject()
<<<<<<< HEAD
    private let fontScaleManager: FontScaleManager = .shared
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

    var minimizeWindow: () -> Void = {}

    init(
        store: StoreOf<ChatPanelFeature>,
        chatTabPool: ChatTabPool,
        minimizeWindow: @escaping () -> Void
    ) {
        self.minimizeWindow = minimizeWindow
<<<<<<< HEAD
        // Initialize with zero rect initially to prevent flashing
        super.init(
            contentRect: .zero,
            styleMask: [.resizable, .titled, .miniaturizable, .fullSizeContentView, .closable],
            backing: .buffered,
            defer: true // Use defer to prevent window from appearing immediately
        )
        
=======
        super.init(
            contentRect: .zero,
            styleMask: [.resizable, .titled, .miniaturizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

>>>>>>> 4a8ae39... Pre-release 0.22.73
        titleVisibility = .hidden
        addTitlebarAccessoryViewController({
            let controller = NSTitlebarAccessoryViewController()
            let view = NSHostingView(rootView: ChatTitleBar(store: store))
            controller.view = view
            view.frame = .init(x: 0, y: 0, width: 100, height: 40)
            controller.layoutAttribute = .right
            return controller
        }())
        titlebarAppearsTransparent = true
        isReleasedWhenClosed = false
        isOpaque = false
        backgroundColor = .clear
<<<<<<< HEAD
        level = widgetLevel(1)
        collectionBehavior = [
            .fullScreenAuxiliary,
//            .transient,
=======
        level = .init(NSWindow.Level.floating.rawValue + 1)
        collectionBehavior = [
            .fullScreenAuxiliary,
            .transient,
>>>>>>> 4a8ae39... Pre-release 0.22.73
            .fullScreenPrimary,
            .fullScreenAllowsTiling,
        ]
        hasShadow = true
<<<<<<< HEAD
        
        // Set contentView after basic configuration
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
        contentView = NSHostingView(
            rootView: ChatWindowView(
                store: store,
                toggleVisibility: { [weak self] isDisplayed in
                    guard let self else { return }
                    self.isPanelDisplayed = isDisplayed
                }
            )
            .environment(\.chatTabPool, chatTabPool)
        )
<<<<<<< HEAD
        
        // Initialize as invisible first
        alphaValue = 0
        isPanelDisplayed = false
        setIsVisible(true)
=======
        setIsVisible(true)
        isPanelDisplayed = false
>>>>>>> 4a8ae39... Pre-release 0.22.73

        storeObserver.observe { [weak self] in
            guard let self else { return }
            let isDetached = store.isDetached
            Task { @MainActor in
                if UserDefaults.shared.value(for: \.disableFloatOnTopWhenTheChatPanelIsDetached) {
                    self.setFloatOnTop(!isDetached)
                } else {
                    self.setFloatOnTop(true)
                }
            }
        }
<<<<<<< HEAD
        
        setInitialFrame()
    }
    
    private func setInitialFrame() {
        let frame = UpdateLocationStrategy.getChatPanelFrame()
        setFrame(frame, display: false, animate: true)
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
    }

    func setFloatOnTop(_ isFloatOnTop: Bool) {
        let targetLevel: NSWindow.Level = isFloatOnTop
            ? .init(NSWindow.Level.floating.rawValue + 1)
            : .normal

        if targetLevel != level {
            level = targetLevel
        }
    }

    var isWindowHidden: Bool = false {
        didSet {
            alphaValue = isPanelDisplayed && !isWindowHidden ? 1 : 0
        }
    }

    var isPanelDisplayed: Bool = false {
        didSet {
            alphaValue = isPanelDisplayed && !isWindowHidden ? 1 : 0
        }
    }

    override var alphaValue: CGFloat {
        didSet {
            ignoresMouseEvents = alphaValue <= 0
        }
    }

    override func miniaturize(_: Any?) {
        minimizeWindow()
    }
<<<<<<< HEAD

    override func close() {
        minimizeWindow()
    }
    
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        if event.modifierFlags.contains(.command) {
            switch event.charactersIgnoringModifiers {
            case "-":
                fontScaleManager.decreaseFontScale()
                return true
            case "=":
                fontScaleManager.increaseFontScale()
                return true
            default:
                break
            }
        }
        
        return super.performKeyEquivalent(with: event)
    }
}
=======
}

>>>>>>> 4a8ae39... Pre-release 0.22.73
