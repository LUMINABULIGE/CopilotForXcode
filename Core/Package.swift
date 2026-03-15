// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

// MARK: - Package

let package = Package(
    name: "Core",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "Service",
            targets: [
                "Service",
                "SuggestionInjector",
                "FileChangeChecker",
                "LaunchAgentManager",
                "UpdateChecker",
            ]
        ),
        .library(
            name: "Client",
            targets: [
                "Client",
            ]
        ),
        .library(
            name: "HostApp",
            targets: [
                "HostApp",
                "Client",
                "LaunchAgentManager",
                "UpdateChecker",
<<<<<<< HEAD
                "GitHubCopilotViewModel",
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
            ]
        ),
    ],
    dependencies: [
        .package(path: "../Tool"),
        .package(url: "https://github.com/apple/swift-async-algorithms", from: "1.0.0"),
        .package(url: "https://github.com/gonzalezreal/swift-markdown-ui", from: "2.4.0"),
        .package(url: "https://github.com/sparkle-project/Sparkle", from: "2.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-parsing", from: "0.12.1"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.10.4"
        ),
        // quick hack to support custom UserDefaults
        // https://github.com/sindresorhus/KeyboardShortcuts
            .package(url: "https://github.com/devm33/KeyboardShortcuts", branch: "main"),
<<<<<<< HEAD
        .package(url: "https://github.com/devm33/CGEventOverride", branch: "devm33/fix-stale-AXIsProcessTrusted"),
        .package(url: "https://github.com/devm33/Highlightr", branch: "master"),
        .package(url: "https://github.com/globulus/swiftui-flow-layout", from: "1.0.5"),
        .package(url: "https://github.com/tree-sitter/swift-tree-sitter.git", from: "0.25.0"),
        .package(url: "https://github.com/tree-sitter/tree-sitter-bash", from: "0.25.1")
=======
        .package(url: "https://github.com/devm33/CGEventOverride", from: "1.2.1"),
        .package(url: "https://github.com/devm33/Highlightr", branch: "master"),
>>>>>>> 4a8ae39... Pre-release 0.22.73
    ],
    targets: [
        // MARK: - Main
        
        .target(
            name: "Client",
            dependencies: [
                .product(name: "XPCShared", package: "Tool"),
                .product(name: "SuggestionProvider", package: "Tool"),
                .product(name: "SuggestionBasic", package: "Tool"),
                .product(name: "Logger", package: "Tool"),
                .product(name: "Preferences", package: "Tool"),
                .product(name: "GitHubCopilotService", package: "Tool"),
            ]),
        .target(
            name: "Service",
            dependencies: [
                "SuggestionWidget",
                "SuggestionService",
                "ChatService",
                "PromptToCodeService",
                "ConversationTab",
                "KeyBindingManager",
                "XcodeThemeController",
<<<<<<< HEAD
                .product(name: "TelemetryService", package: "Tool"),
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
                .product(name: "XPCShared", package: "Tool"),
                .product(name: "SuggestionProvider", package: "Tool"),
                .product(name: "ConversationServiceProvider", package: "Tool"),
                .product(name: "Workspace", package: "Tool"),
                .product(name: "UserDefaultsObserver", package: "Tool"),
                .product(name: "AppMonitoring", package: "Tool"),
                .product(name: "SuggestionBasic", package: "Tool"),
<<<<<<< HEAD
                .product(name: "Status", package: "Tool"),
                .product(name: "StatusBarItemView", package: "Tool"),
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
                .product(name: "ChatTab", package: "Tool"),
                .product(name: "Logger", package: "Tool"),
                .product(name: "ChatAPIService", package: "Tool"),
                .product(name: "Preferences", package: "Tool"),
<<<<<<< HEAD
                .product(name: "AXHelper", package: "Tool"),
                .product(name: "WorkspaceSuggestionService", package: "Tool"),
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "KeyboardShortcuts", package: "KeyboardShortcuts"),
            ]),
        .testTarget(
            name: "ServiceTests",
            dependencies: [
                "Service",
                "Client",
                "SuggestionInjector",
                .product(name: "XPCShared", package: "Tool"),
                .product(name: "SuggestionProvider", package: "Tool"),
                .product(name: "SuggestionBasic", package: "Tool"),
                .product(name: "Preferences", package: "Tool"),
                .product(name: "ConversationServiceProvider", package: "Tool"),
            ]
        ),
        
        // MARK: - Host App
        
            .target(
                name: "HostApp",
                dependencies: [
                    "Client",
                    "LaunchAgentManager",
<<<<<<< HEAD
                    "GitHubCopilotViewModel",
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
                    .product(name: "SuggestionProvider", package: "Tool"),
                    .product(name: "Toast", package: "Tool"),
                    .product(name: "SharedUIComponents", package: "Tool"),
                    .product(name: "SuggestionBasic", package: "Tool"),
                    .product(name: "MarkdownUI", package: "swift-markdown-ui"),
                    .product(name: "ChatAPIService", package: "Tool"),
                    .product(name: "Preferences", package: "Tool"),
                    .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                    .product(name: "KeyboardShortcuts", package: "KeyboardShortcuts"),
                    .product(name: "GitHubCopilotService", package: "Tool"),
<<<<<<< HEAD
                    .product(name: "Persist", package: "Tool"),
                    .product(name: "UserDefaultsObserver", package: "Tool"),
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
                ]),
        
        // MARK: - Suggestion Service
        
            .target(
                name: "SuggestionService",
                dependencies: [
                    .product(name: "UserDefaultsObserver", package: "Tool"),
                    .product(name: "Preferences", package: "Tool"),
                    .product(name: "SuggestionBasic", package: "Tool"),
                    .product(name: "SuggestionProvider", package: "Tool"),
                    .product(name: "BuiltinExtension", package: "Tool"),
                    .product(name: "GitHubCopilotService", package: "Tool"),
                ]),
        .target(
            name: "SuggestionInjector",
            dependencies: [.product(name: "SuggestionBasic", package: "Tool")]
        ),
        .testTarget(
            name: "SuggestionInjectorTests",
            dependencies: ["SuggestionInjector"]
        ),
        
        // MARK: - Prompt To Code
        
            .target(
                name: "PromptToCodeService",
                dependencies: [
                    .product(name: "SuggestionBasic", package: "Tool"),
                    .product(name: "ChatAPIService", package: "Tool"),
                    .product(name: "AppMonitoring", package: "Tool"),
                    .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                ]),
        
        // MARK: - Chat
        
            .target(
                name: "ChatService",
                dependencies: [
<<<<<<< HEAD
                    "PersistMiddleware",
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
                    .product(name: "AppMonitoring", package: "Tool"),
                    .product(name: "Parsing", package: "swift-parsing"),
                    .product(name: "ChatAPIService", package: "Tool"),
                    .product(name: "Preferences", package: "Tool"),
<<<<<<< HEAD
                    .product(name: "AXHelper", package: "Tool"),
                    .product(name: "ConversationServiceProvider", package: "Tool"),
                    .product(name: "GitHubCopilotService", package: "Tool"),
                    .product(name: "Workspace", package: "Tool"),
                    .product(name: "Terminal", package: "Tool"),
                    .product(name: "SystemUtils", package: "Tool"),
                    .product(name: "AppKitExtension", package: "Tool"),
                    .product(name: "WebContentExtractor", package: "Tool"),
                    .product(name: "GitHelper", package: "Tool"),
                    .product(name: "SuggestionBasic", package: "Tool"),
                    .product(name: "SwiftTreeSitter", package: "swift-tree-sitter"),
                    .product(name: "SwiftTreeSitterLayer", package: "swift-tree-sitter"),
                    .product(name: "TreeSitterBash", package: "tree-sitter-bash"),
                ]),
            .testTarget(
                name: "ChatServiceTests",
                dependencies: ["ChatService"]
            ),
=======
                    .product(name: "ConversationServiceProvider", package: "Tool"),
                    .product(name: "GitHubCopilotService", package: "Tool"),
                ]),
>>>>>>> 4a8ae39... Pre-release 0.22.73

            .target(
                name: "ConversationTab",
                dependencies: [
                    "ChatService",
                    .product(name: "SharedUIComponents", package: "Tool"),
                    .product(name: "ChatAPIService", package: "Tool"),
                    .product(name: "Logger", package: "Tool"),
                    .product(name: "ChatTab", package: "Tool"),
                    .product(name: "Terminal", package: "Tool"),
<<<<<<< HEAD
                    .product(name: "Cache", package: "Tool"),
                    .product(name: "MarkdownUI", package: "swift-markdown-ui"),
                    .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                    .product(name: "SwiftUIFlowLayout", package: "swiftui-flow-layout"),
                    .product(name: "Persist", package: "Tool")
=======
                    .product(name: "MarkdownUI", package: "swift-markdown-ui"),
                    .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
>>>>>>> 4a8ae39... Pre-release 0.22.73
                ]
            ),
        
        // MARK: - UI
        
            .target(
                name: "SuggestionWidget",
                dependencies: [
<<<<<<< HEAD
                    "ChatService",
                    "PromptToCodeService",
                    "ConversationTab",
                    "GitHubCopilotViewModel",
                    "PersistMiddleware",
=======
                    "PromptToCodeService",
                    "ConversationTab",
>>>>>>> 4a8ae39... Pre-release 0.22.73
                    .product(name: "GitHubCopilotService", package: "Tool"),
                    .product(name: "Toast", package: "Tool"),
                    .product(name: "UserDefaultsObserver", package: "Tool"),
                    .product(name: "SharedUIComponents", package: "Tool"),
                    .product(name: "AppMonitoring", package: "Tool"),
                    .product(name: "ChatTab", package: "Tool"),
                    .product(name: "Logger", package: "Tool"),
                    .product(name: "CustomAsyncAlgorithms", package: "Tool"),
<<<<<<< HEAD
                    .product(name: "HostAppActivator", package: "Tool"),
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
                    .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
                    .product(name: "MarkdownUI", package: "swift-markdown-ui"),
                    .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                ]
            ),
        .testTarget(name: "SuggestionWidgetTests", dependencies: ["SuggestionWidget"]),
        
        // MARK: - Helpers
        
<<<<<<< HEAD
        .target(name: "FileChangeChecker"),
        .target(
            name: "LaunchAgentManager",
            dependencies: [
                .product(name: "Logger", package: "Tool"),
            ]
        ),
=======
            .target(name: "FileChangeChecker"),
        .target(name: "LaunchAgentManager"),
>>>>>>> 4a8ae39... Pre-release 0.22.73
        .target(
            name: "UpdateChecker",
            dependencies: [
                "Sparkle",
                .product(name: "Preferences", package: "Tool"),
                .product(name: "Logger", package: "Tool"),
            ]
        ),
<<<<<<< HEAD
        .target(
            name: "GitHubCopilotViewModel",
            dependencies: [
                "Client",
                .product(name: "GitHubCopilotService", package: "Tool"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Status", package: "Tool"),
            ]
        ),
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

        // MARK: Key Binding

        .target(
            name: "KeyBindingManager",
            dependencies: [
<<<<<<< HEAD
                "SuggestionWidget",
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
                .product(name: "Workspace", package: "Tool"),
                .product(name: "Preferences", package: "Tool"),
                .product(name: "Logger", package: "Tool"),
                .product(name: "CGEventOverride", package: "CGEventOverride"),
                .product(name: "AppMonitoring", package: "Tool"),
                .product(name: "UserDefaultsObserver", package: "Tool"),
                .product(name: "ConversationServiceProvider", package: "Tool"),
            ]
        ),
        .testTarget(
            name: "KeyBindingManagerTests",
            dependencies: ["KeyBindingManager"]
        ),

        // MARK: Theming

        .target(
            name: "XcodeThemeController",
            dependencies: [
                .product(name: "Preferences", package: "Tool"),
                .product(name: "AppMonitoring", package: "Tool"),
                .product(name: "Highlightr", package: "Highlightr"),
            ]
        ),
<<<<<<< HEAD
        
        // MARK: Persist Middleware
        .target(
            name: "PersistMiddleware",
            dependencies: [
                .product(name: "Persist", package: "Tool"),
                .product(name: "ChatTab", package: "Tool"),
                .product(name: "ChatAPIService", package: "Tool"),
                .product(name: "ConversationServiceProvider", package: "Tool")
            ]
        )
=======

>>>>>>> 4a8ae39... Pre-release 0.22.73
    ]
)

