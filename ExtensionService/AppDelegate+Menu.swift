import AppKit
import Foundation
import Preferences
<<<<<<< HEAD
import Status
import SuggestionBasic
import XcodeInspector
import Logger
import StatusBarItemView
import GitHubCopilotViewModel
=======
import XcodeInspector
import Logger
>>>>>>> 4a8ae39... Pre-release 0.22.73

extension AppDelegate {
    fileprivate var statusBarMenuIdentifier: NSUserInterfaceItemIdentifier {
        .init("statusBarMenu")
    }

    fileprivate var xcodeInspectorDebugMenuIdentifier: NSUserInterfaceItemIdentifier {
        .init("xcodeInspectorDebugMenu")
    }

<<<<<<< HEAD
=======
    fileprivate var accessibilityAPIPermissionMenuItemIdentifier: NSUserInterfaceItemIdentifier {
        .init("accessibilityAPIPermissionMenuItem")
    }

>>>>>>> 4a8ae39... Pre-release 0.22.73
    fileprivate var sourceEditorDebugMenu: NSUserInterfaceItemIdentifier {
        .init("sourceEditorDebugMenu")
    }

<<<<<<< HEAD
=======
    fileprivate var toggleCompletionsMenuItemIdentifier: NSUserInterfaceItemIdentifier {
        .init("toggleCompletionsMenuItem")
    }

    fileprivate var copilotStatusMenuItemIdentifier: NSUserInterfaceItemIdentifier {
        .init("copilotStatusMenuItem")
    }

>>>>>>> 4a8ae39... Pre-release 0.22.73
    @MainActor
    @objc func buildStatusBarMenu() {
        let statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(
            withLength: NSStatusItem.squareLength
        )
        statusBarItem.button?.image = NSImage(named: "MenuBarIcon")

        let statusBarMenu = NSMenu(title: "Status Bar Menu")
        statusBarMenu.identifier = statusBarMenuIdentifier
        statusBarItem.menu = statusBarMenu
<<<<<<< HEAD
        
=======

        let hostAppName = Bundle.main.object(forInfoDictionaryKey: "HOST_APP_NAME") as? String
            ?? "GitHub Copilot for Xcode"

>>>>>>> 4a8ae39... Pre-release 0.22.73
        let checkForUpdate = NSMenuItem(
            title: "Check for Updates",
            action: #selector(checkForUpdate),
            keyEquivalent: ""
        )

<<<<<<< HEAD
        openCopilotForXcodeItem = NSMenuItem(
            title: "Settings",
            action: #selector(openCopilotForXcodeSettings),
=======
        let openCopilotForXcode = NSMenuItem(
            title: "Open \(hostAppName) Settings",
            action: #selector(openCopilotForXcode),
>>>>>>> 4a8ae39... Pre-release 0.22.73
            keyEquivalent: ""
        )

        let xcodeInspectorDebug = NSMenuItem(
            title: "Xcode Inspector Debug",
            action: nil,
            keyEquivalent: ""
        )

        let xcodeInspectorDebugMenu = NSMenu(title: "Xcode Inspector Debug")
        xcodeInspectorDebugMenu.identifier = xcodeInspectorDebugMenuIdentifier
        xcodeInspectorDebug.submenu = xcodeInspectorDebugMenu
        xcodeInspectorDebug.isHidden = false

<<<<<<< HEAD
        axStatusItem = NSMenuItem(
            title: "",
            action: #selector(openAXStatusLink),
            keyEquivalent: ""
        )
        axStatusItem.isHidden = true

        extensionStatusItem = NSMenuItem(
            title: "",
            action: #selector(openExtensionStatusLink),
            keyEquivalent: ""
        )
        extensionStatusItem.isHidden = true
=======
        let accessibilityAPIPermission = NSMenuItem(
            title: "Accessibility Permission: N/A",
            action: nil,
            keyEquivalent: ""
        )
        accessibilityAPIPermission.identifier = accessibilityAPIPermissionMenuItemIdentifier
>>>>>>> 4a8ae39... Pre-release 0.22.73

        let quitItem = NSMenuItem(
            title: "Quit",
            action: #selector(quit),
            keyEquivalent: ""
        )
        quitItem.target = self

<<<<<<< HEAD
        toggleCompletions = NSMenuItem(
=======
        let toggleCompletions = NSMenuItem(
>>>>>>> 4a8ae39... Pre-release 0.22.73
            title: "Enable/Disable Completions",
            action: #selector(toggleCompletionsEnabled),
            keyEquivalent: ""
        )
<<<<<<< HEAD
        
        toggleIgnoreLanguage = NSMenuItem(
            title: "No Active Document",
            action: nil,
            keyEquivalent: ""
        )
        
        toggleNES = NSMenuItem(
            title: "Enable/Disable Next Edit Suggestions (NES)",
            action: #selector(toggleNESEnabled),
            keyEquivalent: ""
        )

        // Auth menu item with custom view
        accountItem = NSMenuItem()
        accountItem.view = AccountItemView(
            target: self,
            action: #selector(signIntoGitHub)
        )

        authStatusItem = NSMenuItem(
            title: "",
            action: nil,
            keyEquivalent: ""
        )
        authStatusItem.isHidden = true
        
        quotaItem = NSMenuItem()
        quotaItem.view = QuotaView(
            chat: .init(
                percentRemaining: 0,
                unlimited: false,
                overagePermitted: false
            ),
            completions: .init(
                percentRemaining: 0,
                unlimited: false,
                overagePermitted: false
            ),
            premiumInteractions: .init(
                percentRemaining: 0,
                unlimited: false,
                overagePermitted: false
            ),
            resetDate: "",
            copilotPlan: ""
        )
        quotaItem.isHidden = true

        let openDocs = NSMenuItem(
            title: "View Documentation",
=======
        toggleCompletions.identifier = toggleCompletionsMenuItemIdentifier;

        let copilotStatus = NSMenuItem(
            title: "Copilot Connection: Checking...",
            action: nil,
            keyEquivalent: ""
        )
        copilotStatus.identifier = copilotStatusMenuItemIdentifier

        let openDocs = NSMenuItem(
            title: "View Copilot Documentation...",
>>>>>>> 4a8ae39... Pre-release 0.22.73
            action: #selector(openCopilotDocs),
            keyEquivalent: ""
        )

        let openForum = NSMenuItem(
<<<<<<< HEAD
            title: "Feedback Forum",
=======
            title: "View Copilot Feedback Forum...",
>>>>>>> 4a8ae39... Pre-release 0.22.73
            action: #selector(openCopilotForum),
            keyEquivalent: ""
        )

<<<<<<< HEAD
        openChat = NSMenuItem(
            title: "Open Chat",
            action: #selector(openGlobalChat),
            keyEquivalent: ""
        )
        
        signOutItem = NSMenuItem(
            title: "Sign Out",
            action: #selector(signOutGitHub),
            keyEquivalent: ""
        )

        statusBarMenu.addItem(accountItem)
        statusBarMenu.addItem(.separator())
        statusBarMenu.addItem(authStatusItem)
        statusBarMenu.addItem(.separator())
        statusBarMenu.addItem(quotaItem)
        statusBarMenu.addItem(.separator())
        statusBarMenu.addItem(axStatusItem)
        statusBarMenu.addItem(extensionStatusItem)
        statusBarMenu.addItem(.separator())
        statusBarMenu.addItem(checkForUpdate)
        statusBarMenu.addItem(.separator())
        statusBarMenu.addItem(openChat)
        statusBarMenu.addItem(toggleCompletions)
        statusBarMenu.addItem(toggleIgnoreLanguage)
        statusBarMenu.addItem(toggleNES)
        statusBarMenu.addItem(.separator())
        statusBarMenu.addItem(openCopilotForXcodeItem)
        statusBarMenu.addItem(openDocs)
        statusBarMenu.addItem(openForum)
        statusBarMenu.addItem(.separator())
        statusBarMenu.addItem(signOutItem)
        statusBarMenu.addItem(.separator())
=======
        statusBarMenu.addItem(openCopilotForXcode)
        statusBarMenu.addItem(.separator())
        statusBarMenu.addItem(checkForUpdate)
        statusBarMenu.addItem(toggleCompletions)
        statusBarMenu.addItem(.separator())
        statusBarMenu.addItem(copilotStatus)
        statusBarMenu.addItem(accessibilityAPIPermission)
        statusBarMenu.addItem(.separator())
        statusBarMenu.addItem(openDocs)
        statusBarMenu.addItem(openForum)
        statusBarMenu.addItem(.separator())
>>>>>>> 4a8ae39... Pre-release 0.22.73
        statusBarMenu.addItem(xcodeInspectorDebug)
        statusBarMenu.addItem(quitItem)

        statusBarMenu.delegate = self
        xcodeInspectorDebugMenu.delegate = self
    }
}

extension AppDelegate: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        switch menu.identifier {
        case statusBarMenuIdentifier:
            if let xcodeInspectorDebug = menu.items.first(where: { item in
                item.submenu?.identifier == xcodeInspectorDebugMenuIdentifier
            }) {
                xcodeInspectorDebug.isHidden = !UserDefaults.shared
                    .value(for: \.enableXcodeInspectorDebugMenu)
            }

<<<<<<< HEAD
            if toggleCompletions != nil {
                toggleCompletions.title = "\(UserDefaults.shared.value(for: \.realtimeSuggestionToggle) ? "Disable" : "Enable") Completions"
            }
            
            if toggleIgnoreLanguage != nil {
                if let lang = DisabledLanguageList.shared.activeDocumentLanguage {
                    toggleIgnoreLanguage.title = "\(DisabledLanguageList.shared.isEnabled(lang) ? "Disable" : "Enable") Completions for \(lang.rawValue)"
                    toggleIgnoreLanguage.action = #selector(
                        toggleIgnoreLanguageEnabled
                    )
                } else {
                    toggleIgnoreLanguage.title = "No Active Document"
                    toggleIgnoreLanguage.action = nil
                }
            }
            
            if toggleNES != nil {
                toggleNES.title = "\(UserDefaults.shared.value(for: \.realtimeNESToggle) ? "Disable" : "Enable") Next Edit Suggestions (NES)"
            }

            Task {
                await forceAuthStatusCheck()
                updateStatusBarItem()
            }

=======
            if let toggleCompletions = menu.items.first(where: { item in
                item.identifier == toggleCompletionsMenuItemIdentifier
            }) {
                toggleCompletions.title = "\(UserDefaults.shared.value(for: \.realtimeSuggestionToggle) ? "Disable" : "Enable") Completions"
            }

            if let accessibilityAPIPermission = menu.items.first(where: { item in
                item.identifier == accessibilityAPIPermissionMenuItemIdentifier
            }) {
                AXIsProcessTrusted()
                accessibilityAPIPermission.title =
                    "Accessibility Permission: \(AXIsProcessTrusted() ? "Granted" : "Not Granted")"
            }

            statusChecker.updateStatusInBackground(notify: { (status: String, isOk: Bool) in
                if let statusItem = menu.items.first(where: { item in
                    item.identifier == self.copilotStatusMenuItemIdentifier
                }) {
                    statusItem.title = "Copilot Connection: \(isOk ? "Connected" : status)"
                }
            })

>>>>>>> 4a8ae39... Pre-release 0.22.73
        case xcodeInspectorDebugMenuIdentifier:
            let inspector = XcodeInspector.shared
            menu.items.removeAll()
            menu.items
                .append(.text("Active Project: \(inspector.activeProjectRootURL?.path ?? "N/A")"))
            menu.items
                .append(.text("Active Workspace: \(inspector.activeWorkspaceURL?.path ?? "N/A")"))
            menu.items
                .append(.text("Active Document: \(inspector.activeDocumentURL?.path ?? "N/A")"))

            if let focusedWindow = inspector.focusedWindow {
                menu.items.append(.text(
                    "Active Window: \(focusedWindow.uiElement.identifier)"
                ))
            } else {
                menu.items.append(.text("Active Window: N/A"))
            }

            if let focusedElement = inspector.focusedElement {
                menu.items.append(.text(
                    "Focused Element: \(focusedElement.description)"
                ))
            } else {
                menu.items.append(.text("Focused Element: N/A"))
            }

            if let sourceEditor = inspector.focusedEditor {
                let label = sourceEditor.element.description
                menu.items
                    .append(.text("Active Source Editor: \(label.isEmpty ? "Unknown" : label)"))
            } else {
                menu.items.append(.text("Active Source Editor: N/A"))
            }

            menu.items.append(.separator())

            for xcode in inspector.xcodes {
                let item = NSMenuItem(
                    title: "Xcode \(xcode.processIdentifier)",
                    action: nil,
                    keyEquivalent: ""
                )
                menu.addItem(item)
                let xcodeMenu = NSMenu()
                item.submenu = xcodeMenu
                xcodeMenu.items.append(.text("Is Active: \(xcode.isActive)"))
                xcodeMenu.items
                    .append(.text("Active Project: \(xcode.projectRootURL?.path ?? "N/A")"))
                xcodeMenu.items
                    .append(.text("Active Workspace: \(xcode.workspaceURL?.path ?? "N/A")"))
                xcodeMenu.items
                    .append(.text("Active Document: \(xcode.documentURL?.path ?? "N/A")"))

                for (key, workspace) in xcode.realtimeWorkspaces {
                    let workspaceItem = NSMenuItem(
                        title: "Workspace \(key)",
                        action: nil,
                        keyEquivalent: ""
                    )
                    xcodeMenu.items.append(workspaceItem)
                    let workspaceMenu = NSMenu()
                    workspaceItem.submenu = workspaceMenu
                    let tabsItem = NSMenuItem(
                        title: "Tabs",
                        action: nil,
                        keyEquivalent: ""
                    )
                    workspaceMenu.addItem(tabsItem)
                    let tabsMenu = NSMenu()
                    tabsItem.submenu = tabsMenu
                    for tab in workspace.tabs {
                        tabsMenu.addItem(.text(tab))
                    }
                }
            }

            menu.items.append(.separator())

            menu.items.append(NSMenuItem(
                title: "Restart Xcode Inspector",
                action: #selector(restartXcodeInspector),
                keyEquivalent: ""
            ))

        default:
            break
        }
    }
}

import XPCShared

private extension AppDelegate {
    @objc func restartXcodeInspector() {
        Task {
            await XcodeInspector.shared.restart(cleanUp: true)
        }
    }

    @objc func toggleCompletionsEnabled() {
        Task {
            let initialSetting = UserDefaults.shared.value(for: \.realtimeSuggestionToggle)
            do {
                let service = getXPCExtensionService()
                try await service.toggleRealtimeSuggestion()
            } catch {
                Logger.service.error("Failed to toggle completions enabled via XPC: \(error)")
                UserDefaults.shared.set(!initialSetting, for: \.realtimeSuggestionToggle)
            }
        }
    }
<<<<<<< HEAD
    
    @objc func toggleNESEnabled() {
        Task {
            let initialSetting = UserDefaults.shared.value(for: \.realtimeNESToggle)
            do {
                let service = getXPCExtensionService()
                try await service.toggleRealtimeNES()
            } catch {
                Logger.service.error("Failed to toggle NES enabled via XPC: \(error)")
                UserDefaults.shared.set(!initialSetting, for: \.realtimeNESToggle)
            }
        }
    }
    
    @objc func toggleIgnoreLanguageEnabled() {
        guard let lang = DisabledLanguageList.shared.activeDocumentLanguage else { return }

        if DisabledLanguageList.shared.isEnabled(lang) {
            DisabledLanguageList.shared.disable(lang)
        } else {
            DisabledLanguageList.shared.enable(lang)
        }
    }
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

    @objc func openCopilotDocs() {
        if let urlString = Bundle.main.object(forInfoDictionaryKey: "COPILOT_DOCS_URL") as? String {
            if let url = URL(string: urlString) {
                NSWorkspace.shared.open(url)
            }
        }
    }

    @objc func openCopilotForum() {
        if let urlString = Bundle.main.object(forInfoDictionaryKey: "COPILOT_FORUM_URL") as? String {
            if let url = URL(string: urlString) {
                NSWorkspace.shared.open(url)
            }
        }
    }
<<<<<<< HEAD

    @objc func openAXStatusLink() {
        Task {
            if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
                NSWorkspace.shared.open(url)
            }
        }
    }

    @objc func openExtensionStatusLink() {
        Task {
            let status = await Status.shared.getExtensionStatus()
            if status == .notGranted {
                if let url = URL(string: "x-apple.systempreferences:com.apple.ExtensionsPreferences?extensionPointIdentifier=com.apple.dt.Xcode.extension.source-editor") {
                    NSWorkspace.shared.open(url)
                }
            } else {
                NSWorkspace.restartXcode()
            }
        }
    }
    
    @objc func openUpSellLink() {
        Task {
            if let url = URL(string: "https://aka.ms/github-copilot-settings") {
                NSWorkspace.shared.open(url)
            }
        }
    }
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
}

private extension NSMenuItem {
    static func text(_ text: String) -> NSMenuItem {
        let item = NSMenuItem(
            title: text,
            action: nil,
            keyEquivalent: ""
        )
        item.isEnabled = false
        return item
    }
}
<<<<<<< HEAD
=======

>>>>>>> 4a8ae39... Pre-release 0.22.73
