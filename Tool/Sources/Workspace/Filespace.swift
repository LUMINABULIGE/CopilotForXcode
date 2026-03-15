import Dependencies
import Foundation
import SuggestionBasic

public protocol FilespacePropertyKey {
    associatedtype Value
    static func createDefaultValue() -> Value
}

public final class FilespacePropertyValues {
    private var storage: [ObjectIdentifier: Any] = [:]

    @WorkspaceActor
    public subscript<K: FilespacePropertyKey>(_ key: K.Type) -> K.Value {
        get {
            if let value = storage[ObjectIdentifier(key)] as? K.Value {
                return value
            }
            let value = key.createDefaultValue()
            storage[ObjectIdentifier(key)] = value
            return value
        }
        set {
            storage[ObjectIdentifier(key)] = newValue
        }
    }
}

public struct FilespaceCodeMetadata: Equatable {
<<<<<<< HEAD
    /// Stands for `Uniform Type Identifier`
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
    public var uti: String?
    public var tabSize: Int?
    public var indentSize: Int?
    public var usesTabsForIndentation: Bool?
    public var lineEnding: String = "\n"

    init(
        uti: String? = nil,
        tabSize: Int? = nil,
        indentSize: Int? = nil,
        usesTabsForIndentation: Bool? = nil,
        lineEnding: String = "\n"
    ) {
        self.uti = uti
        self.tabSize = tabSize
        self.indentSize = indentSize
        self.usesTabsForIndentation = usesTabsForIndentation
        self.lineEnding = lineEnding
    }
    
    public mutating func guessLineEnding(from text: String?) {
        lineEnding = if let proposedEnding = text?.last {
            if proposedEnding.isNewline {
                String(proposedEnding)
            } else {
                "\n"
            }
        } else {
            "\n"
        }
    }
}

@dynamicMemberLookup
public final class Filespace {

    // MARK: Metadata

    public let fileURL: URL
<<<<<<< HEAD
    public private(set) var fileContent: String? = nil
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
    public private(set) lazy var language: CodeLanguage = languageIdentifierFromFileURL(fileURL)
    public var codeMetadata: FilespaceCodeMetadata = .init()
    public var isTextReadable: Bool {
        fileURL.pathExtension != "mlmodel"
    }

    // MARK: Suggestions

    public private(set) var suggestionIndex: Int = 0
    public internal(set) var suggestions: [CodeSuggestion] = [] {
<<<<<<< HEAD
        didSet{ refreshUpdateTime() }
    }
    // Use Array for potential extensibility
    public internal(set) var nesSuggestions: [CodeSuggestion] = [] {
        didSet { refreshNESUpdateTime() }
=======
        didSet { refreshUpdateTime() }
>>>>>>> 4a8ae39... Pre-release 0.22.73
    }

    public var presentingSuggestion: CodeSuggestion? {
        guard suggestions.endIndex > suggestionIndex, suggestionIndex >= 0 else { return nil }
        return suggestions[suggestionIndex]
    }
<<<<<<< HEAD
    
    public var presentingNESSuggestion: CodeSuggestion? {
        // Currently, only one nes suggestion will exist there
        return nesSuggestions.first
    }

    public private(set) var errorMessage: String = "" {
        didSet { refreshUpdateTime() }
    }
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

    // MARK: Life Cycle

    public var isExpired: Bool {
        Environment.now().timeIntervalSince(lastUpdateTime) > 60 * 3
    }
<<<<<<< HEAD
    
    public var isNESExpired: Bool {
        Environment.now().timeIntervalSince(lastNESUpdateTime) > 60 * 3
    }

    public private(set) var lastUpdateTime: Date = Environment.now()
    public private(set) var lastNESUpdateTime: Date = Environment.now()
=======

    public private(set) var lastUpdateTime: Date = Environment.now()
>>>>>>> 4a8ae39... Pre-release 0.22.73
    private var additionalProperties = FilespacePropertyValues()
    let fileSaveWatcher: FileSaveWatcher
    let onClose: (URL) -> Void
    
    @WorkspaceActor
    public private(set) var version: Int = 0

    // MARK: Methods

    deinit {
        onClose(fileURL)
    }

    init(
        fileURL: URL,
<<<<<<< HEAD
        content: String,
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
        onSave: @escaping (Filespace) -> Void,
        onClose: @escaping (URL) -> Void
    ) {
        self.fileURL = fileURL
<<<<<<< HEAD
        self.fileContent = content
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
        self.onClose = onClose
        fileSaveWatcher = .init(fileURL: fileURL)
        fileSaveWatcher.changeHandler = { [weak self] in
            guard let self else { return }
<<<<<<< HEAD
            // TODO: should distinguish code completion and NES?
            onSave(self)
            self.fileContent = try? String(contentsOf: self.fileURL)
=======
            onSave(self)
>>>>>>> 4a8ae39... Pre-release 0.22.73
        }
    }

    @WorkspaceActor
    public subscript<K>(
        dynamicMember dynamicMember: WritableKeyPath<FilespacePropertyValues, K>
    ) -> K {
        get { additionalProperties[keyPath: dynamicMember] }
        set { additionalProperties[keyPath: dynamicMember] = newValue }
    }

    @WorkspaceActor
    public func reset() {
        suggestions = []
        suggestionIndex = 0
    }
<<<<<<< HEAD
    
    @WorkspaceActor
    public func resetNESSuggestion() {
        nesSuggestions = []
    }
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

    @WorkspaceActor
    public func updateSuggestionsWithSameSelection(_ suggestions: [CodeSuggestion]) {
        self.suggestions = suggestions
        suggestionIndex = suggestionIndex < suggestions.count ? suggestionIndex : 0
    }

    public func refreshUpdateTime() {
        lastUpdateTime = Environment.now()
    }
<<<<<<< HEAD
    
    public func refreshNESUpdateTime() {
        lastNESUpdateTime = Date.now
    }
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

    @WorkspaceActor
    public func setSuggestions(_ suggestions: [CodeSuggestion]) {
        self.suggestions = suggestions
        suggestionIndex = 0
<<<<<<< HEAD
        if !self.suggestions.isEmpty {
            self.resetNESSuggestion()
        }
    }
    
    @WorkspaceActor
    public func setNESSuggestions(_ nesSuggestions: [CodeSuggestion]) {
        // Only when there is no code completion suggestion, NES suggestion can be set
        guard self.suggestions.isEmpty else { return }
        self.nesSuggestions = nesSuggestions
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
    }

    @WorkspaceActor
    public func nextSuggestion() {
        suggestionIndex += 1
        if suggestionIndex >= suggestions.endIndex {
            suggestionIndex = 0
        }
    }

    @WorkspaceActor
    public func previousSuggestion() {
        suggestionIndex -= 1
        if suggestionIndex < 0 {
            suggestionIndex = suggestions.endIndex - 1
        }
    }
    
    @WorkspaceActor
    public func bumpVersion() {
        version += 1
    }
<<<<<<< HEAD

    @WorkspaceActor
    public func setError(_ message: String) {
        errorMessage = message
    }

    @WorkspaceActor 
    public func dismissError() {
        errorMessage = ""
    }
    
    @WorkspaceActor
    public func updateCodeMetadata(
        uti: String,
        tabSize: Int,
        indentSize: Int,
        usesTabsForIndentation: Bool
    ) {
        self.codeMetadata.uti = uti
        self.codeMetadata.tabSize = tabSize
        self.codeMetadata.indentSize = indentSize
        self.codeMetadata.usesTabsForIndentation = usesTabsForIndentation
    }
    
    @WorkspaceActor
    public func setFileContent(_ content: String) {
        fileContent = content
    }
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
}

