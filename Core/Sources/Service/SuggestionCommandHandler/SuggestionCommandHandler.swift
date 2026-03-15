import SuggestionBasic
import XPCShared

protocol SuggestionCommandHandler {
    @ServiceActor
    func presentSuggestions(editor: EditorContent) async throws -> UpdatedContent?
    @ServiceActor
    func presentNextSuggestion(editor: EditorContent) async throws -> UpdatedContent?
    @ServiceActor
    func presentPreviousSuggestion(editor: EditorContent) async throws -> UpdatedContent?
    @ServiceActor
    func rejectSuggestion(editor: EditorContent) async throws -> UpdatedContent?
    @ServiceActor
<<<<<<< HEAD
    func rejectNESSuggestion(editor: EditorContent) async throws -> UpdatedContent?
    @ServiceActor
    func acceptSuggestion(editor: EditorContent) async throws -> UpdatedContent?
    @ServiceActor
    func acceptNESSuggestion(editor: EditorContent) async throws -> UpdatedContent?
    @ServiceActor
=======
    func acceptSuggestion(editor: EditorContent) async throws -> UpdatedContent?
    @ServiceActor
>>>>>>> 4a8ae39... Pre-release 0.22.73
    func acceptPromptToCode(editor: EditorContent) async throws -> UpdatedContent?
    @ServiceActor
    func presentRealtimeSuggestions(editor: EditorContent) async throws -> UpdatedContent?
    @ServiceActor
    func generateRealtimeSuggestions(editor: EditorContent) async throws -> UpdatedContent?
    @ServiceActor
    func promptToCode(editor: EditorContent) async throws -> UpdatedContent?
    @ServiceActor
    func customCommand(id: String, editor: EditorContent) async throws -> UpdatedContent?
}
