import Foundation
import GitHubCopilotService
import SuggestionBasic
import SuggestionProvider
import Workspace
<<<<<<< HEAD
import Status
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
import XPCShared

public extension Workspace {
    var suggestionPlugin: SuggestionServiceWorkspacePlugin? {
        plugin(for: SuggestionServiceWorkspacePlugin.self)
    }

    var suggestionService: SuggestionServiceProvider? {
        suggestionPlugin?.suggestionService
    }

    var isSuggestionFeatureEnabled: Bool {
        suggestionPlugin?.isSuggestionFeatureEnabled ?? false
    }

    var gitHubCopilotPlugin: GitHubCopilotWorkspacePlugin? {
        plugin(for: GitHubCopilotWorkspacePlugin.self)
    }

    var gitHubCopilotService: GitHubCopilotService? {
        gitHubCopilotPlugin?.gitHubCopilotService
    }

    struct SuggestionFeatureDisabledError: Error, LocalizedError {
        public var errorDescription: String? {
            "Suggestion feature is disabled for this project."
        }
    }
<<<<<<< HEAD
    
    struct EditorCursorOutOfScopeError: Error, LocalizedError {
        public var errorDescription: String? {
            "Cursor position is out of scope."
        }
    }
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
}

public extension Workspace {
    @WorkspaceActor
    @discardableResult
    func generateSuggestions(
        forFileAt fileURL: URL,
        editor: EditorContent
    ) async throws -> [CodeSuggestion] {
<<<<<<< HEAD
    refreshUpdateTime()
    
    guard editor.cursorPosition != .outOfScope else {
        throw EditorCursorOutOfScopeError()
    }
    
    let filespace = try await createFilespaceIfNeeded(fileURL: fileURL)
    
    if !editor.uti.isEmpty {
        filespace.updateCodeMetadata(
            uti: editor.uti,
            tabSize: editor.tabSize,
            indentSize: editor.indentSize,
            usesTabsForIndentation: editor.usesTabsForIndentation
        )
    }
    
    filespace.codeMetadata.guessLineEnding(from: editor.lines.first)
    
    let snapshot = FilespaceSuggestionSnapshot(content: editor)
    filespace.suggestionSourceSnapshot = snapshot
    
    guard let suggestionService else { throw SuggestionFeatureDisabledError() }
    let content = editor.lines.joined(separator: "")
    let completions = try await suggestionService.getSuggestions(
        .from(fileURL: fileURL, content: content, editor: editor, projectRootURL: projectRootURL),
        workspaceInfo: .init(workspaceURL: workspaceURL, projectURL: projectRootURL)
    )
    
    let clsStatus = await Status.shared.getCLSStatus()
    if clsStatus.isErrorStatus && clsStatus.message.contains("Completions limit reached") {
        filespace.setError(clsStatus.message)
    } else {
        filespace.setError("")
        filespace.setSuggestions(completions)
    }
    
    return completions
}
    
    @WorkspaceActor
    @discardableResult
    func generateNESSuggestions(
        forFileAt fileURL: URL,
        editor: EditorContent
    ) async throws -> [CodeSuggestion] {
        refreshUpdateTime()
        
        guard editor.cursorPosition != .outOfScope else {
            throw EditorCursorOutOfScopeError()
        }

        let filespace = try await createFilespaceIfNeeded(fileURL: fileURL)

        if !editor.uti.isEmpty {
            filespace.updateCodeMetadata(
                uti: editor.uti,
                tabSize: editor.tabSize,
                indentSize: editor.indentSize,
                usesTabsForIndentation: editor.usesTabsForIndentation
            )
=======
        refreshUpdateTime()

        let filespace = createFilespaceIfNeeded(fileURL: fileURL)

        if !editor.uti.isEmpty {
            filespace.codeMetadata.uti = editor.uti
            filespace.codeMetadata.tabSize = editor.tabSize
            filespace.codeMetadata.indentSize = editor.indentSize
            filespace.codeMetadata.usesTabsForIndentation = editor.usesTabsForIndentation
>>>>>>> 4a8ae39... Pre-release 0.22.73
        }

        filespace.codeMetadata.guessLineEnding(from: editor.lines.first)

        let snapshot = FilespaceSuggestionSnapshot(content: editor)

<<<<<<< HEAD
        filespace.nesSuggestionSourceSnapshot = snapshot

        guard let suggestionService else { throw SuggestionFeatureDisabledError() }
        let content = editor.lines.joined(separator: "")
        let completions = try await suggestionService.getNESSuggestions(
            .from(fileURL: fileURL, content: content, editor: editor, projectRootURL: projectRootURL),
            workspaceInfo: .init(workspaceURL: workspaceURL, projectURL: projectRootURL)
        )
        
        // TODO: How to get the `limit reached` error? Same as Code Completion?
        filespace.setNESSuggestions(completions)
        
=======
        filespace.suggestionSourceSnapshot = snapshot

        guard let suggestionService else { throw SuggestionFeatureDisabledError() }
        let content = editor.lines.joined(separator: "")
        let completions = try await suggestionService.getSuggestions(
            .init(
                fileURL: fileURL,
                relativePath: fileURL.path.replacingOccurrences(of: projectRootURL.path, with: ""),
                content: content,
                originalContent: content,
                lines: editor.lines,
                cursorPosition: editor.cursorPosition,
                cursorOffset: editor.cursorOffset,
                tabSize: editor.tabSize,
                indentSize: editor.indentSize,
                usesTabsForIndentation: editor.usesTabsForIndentation,
                relevantCodeSnippets: []
            ),
            workspaceInfo: .init(workspaceURL: workspaceURL, projectURL: projectRootURL)
        )

        filespace.setSuggestions(completions)

>>>>>>> 4a8ae39... Pre-release 0.22.73
        return completions
    }

    @WorkspaceActor
    func selectNextSuggestion(forFileAt fileURL: URL) {
        refreshUpdateTime()
        guard let filespace = filespaces[fileURL],
              filespace.suggestions.count > 1
        else { return }
        filespace.nextSuggestion()
    }

    @WorkspaceActor
    func selectPreviousSuggestion(forFileAt fileURL: URL) {
        refreshUpdateTime()
        guard let filespace = filespaces[fileURL],
              filespace.suggestions.count > 1
        else { return }
        filespace.previousSuggestion()
    }

    @WorkspaceActor
    func notifySuggestionShown(fileFileAt fileURL: URL) {
        if let suggestion = filespaces[fileURL]?.presentingSuggestion {
            Task {
                await gitHubCopilotService?.notifyShown(suggestion)
            }
        }
    }
<<<<<<< HEAD
    
    @WorkspaceActor
    func notifyNESSuggestionShown(forFileAt fileURL: URL) {
        if let suggestion = filespaces[fileURL]?.presentingNESSuggestion {
            Task {
                await gitHubCopilotService?.notifyCopilotInlineEditShown(suggestion)
            }
        }
    }
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

    @WorkspaceActor
    func rejectSuggestion(forFileAt fileURL: URL, editor: EditorContent?) {
        refreshUpdateTime()

        if let editor, !editor.uti.isEmpty {
<<<<<<< HEAD
            filespaces[fileURL]?.updateCodeMetadata(
                uti: editor.uti,
                tabSize: editor.tabSize,
                indentSize: editor.indentSize,
                usesTabsForIndentation: editor.usesTabsForIndentation
            )
=======
            filespaces[fileURL]?.codeMetadata.uti = editor.uti
            filespaces[fileURL]?.codeMetadata.tabSize = editor.tabSize
            filespaces[fileURL]?.codeMetadata.indentSize = editor.indentSize
            filespaces[fileURL]?.codeMetadata.usesTabsForIndentation = editor.usesTabsForIndentation
>>>>>>> 4a8ae39... Pre-release 0.22.73
        }

        Task {
            await suggestionService?.notifyRejected(
                filespaces[fileURL]?.suggestions ?? [],
                workspaceInfo: .init(
                    workspaceURL: workspaceURL,
                    projectURL: projectRootURL
                )
            )
        }
        filespaces[fileURL]?.reset()
    }
<<<<<<< HEAD
    
    @WorkspaceActor
    func rejectNESSuggestion(forFileAt fileURL: URL, editor: EditorContent?) {
        refreshUpdateTime()
        
        if let editor, !editor.uti.isEmpty {
            filespaces[fileURL]?.updateCodeMetadata(
                uti: editor.uti,
                tabSize: editor.tabSize,
                indentSize: editor.indentSize,
                usesTabsForIndentation: editor.usesTabsForIndentation
            )
        }
        
        Task {
            await suggestionService?.notifyRejected(
                filespaces[fileURL]?.nesSuggestions ?? [],
                workspaceInfo: .init(
                    workspaceURL: workspaceURL,
                    projectURL: projectRootURL
                )
            )
        }
        filespaces[fileURL]?.resetNESSuggestion()
    }
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

    @WorkspaceActor
    func acceptSuggestion(forFileAt fileURL: URL, editor: EditorContent?, suggestionLineLimit: Int? = nil) -> CodeSuggestion? {
        refreshUpdateTime()
        guard let filespace = filespaces[fileURL],
              !filespace.suggestions.isEmpty,
              filespace.suggestionIndex >= 0,
              filespace.suggestionIndex < filespace.suggestions.endIndex
        else { return nil }

        if let editor, !editor.uti.isEmpty {
<<<<<<< HEAD
            filespaces[fileURL]?.updateCodeMetadata(
                uti: editor.uti,
                tabSize: editor.tabSize,
                indentSize: editor.indentSize,
                usesTabsForIndentation: editor.usesTabsForIndentation
            )
=======
            filespaces[fileURL]?.codeMetadata.uti = editor.uti
            filespaces[fileURL]?.codeMetadata.tabSize = editor.tabSize
            filespaces[fileURL]?.codeMetadata.indentSize = editor.indentSize
            filespaces[fileURL]?.codeMetadata.usesTabsForIndentation = editor.usesTabsForIndentation
>>>>>>> 4a8ae39... Pre-release 0.22.73
        }

        var allSuggestions = filespace.suggestions
        let suggestion = allSuggestions.remove(at: filespace.suggestionIndex)

        var length: Int? = nil
        if let suggestionLineLimit {
            let lines = suggestion.text.breakLines(
                proposedLineEnding: filespaces[fileURL]?.codeMetadata.lineEnding
            )
            length = lines.prefix(suggestionLineLimit).joined().count
        }

        Task {
            await gitHubCopilotService?.notifyAccepted(suggestion, acceptedLength: length)
        }

        filespaces[fileURL]?.reset()
        filespaces[fileURL]?.resetSnapshot()

        return suggestion
    }
<<<<<<< HEAD
    
    @WorkspaceActor
    func acceptNESSuggestion(forFileAt fileURL: URL, editor: EditorContent?, suggestionLineLimit: Int? = nil) -> CodeSuggestion? {
        refreshUpdateTime()
        guard let filespace = filespaces[fileURL],
              let suggestion = filespace.presentingNESSuggestion
        else { return nil }
        
        if let editor, !editor.uti.isEmpty {
            filespaces[fileURL]?.updateCodeMetadata(
                uti: editor.uti,
                tabSize: editor.tabSize,
                indentSize: editor.indentSize,
                usesTabsForIndentation: editor.usesTabsForIndentation
            )
        }
        
        Task {
             await gitHubCopilotService?.notifyCopilotInlineEditAccepted(suggestion)
        }
        
        filespace.resetNESSuggestion()
        filespace.resetNESSnapshot()
        
        return suggestion
    }
    
    @WorkspaceActor
    func getNESSuggestion(forFileAt fileURL: URL) -> CodeSuggestion? {
        guard let filespace = filespaces[fileURL],
              let suggestion = filespace.presentingNESSuggestion
        else { return nil }
        
        return suggestion
    }
}

extension SuggestionRequest {
    static func from(fileURL: URL, content: String, editor: EditorContent, projectRootURL: URL) -> Self {
        return .init(
            fileURL: fileURL,
            relativePath: fileURL.path.replacingOccurrences(of: projectRootURL.path, with: ""),
            content: content,
            originalContent: content,
            lines: editor.lines,
            cursorPosition: editor.cursorPosition,
            cursorOffset: editor.cursorOffset,
            tabSize: editor.tabSize,
            indentSize: editor.indentSize,
            usesTabsForIndentation: editor.usesTabsForIndentation,
            relevantCodeSnippets: []
        )
    }
}
=======
}

>>>>>>> 4a8ae39... Pre-release 0.22.73
