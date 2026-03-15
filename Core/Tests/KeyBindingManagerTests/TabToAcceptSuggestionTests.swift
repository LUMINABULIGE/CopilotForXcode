import Foundation
import XCTest
<<<<<<< HEAD
import SuggestionBasic
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

@testable import Workspace
@testable import KeyBindingManager

class TabToAcceptSuggestionTests: XCTestCase {
<<<<<<< HEAD
    
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
    @WorkspaceActor
    func test_should_accept() {
        let fileURL = URL(string: "file:///test")!
        let workspacePool = FakeWorkspacePool()
        workspacePool.setTestFile(fileURL: fileURL)
        let xcodeInspector = FakeThreadSafeAccessToXcodeInspector(
            activeDocumentURL: fileURL,
            hasActiveXcode: true,
            hasFocusedEditor: true
        )
<<<<<<< HEAD
        assertEqual(
=======
        XCTAssertTrue(
>>>>>>> 4a8ae39... Pre-release 0.22.73
            TabToAcceptSuggestion.shouldAcceptSuggestion(
                event: CGEvent(keyboardEventSource: nil, virtualKey: 48, keyDown: true)!,
                workspacePool: workspacePool,
                xcodeInspector: xcodeInspector
<<<<<<< HEAD
            ), (true, nil, .codeCompletion)
=======
            )
>>>>>>> 4a8ae39... Pre-release 0.22.73
        )
    }

    @WorkspaceActor
    func test_should_not_accept_without_suggestion() {
        let fileURL = URL(string: "file:///test")!
        let workspacePool = FakeWorkspacePool()
<<<<<<< HEAD
        workspacePool.setTestFile(fileURL: fileURL, skipSuggestion: true)
        let xcodeInspector = FakeThreadSafeAccessToXcodeInspector(
            activeDocumentURL: fileURL,
            hasActiveXcode: true,
            hasFocusedEditor: true
        )
        assertEqual(
            TabToAcceptSuggestion.shouldAcceptSuggestion(
                event: CGEvent(keyboardEventSource: nil, virtualKey: 48, keyDown: true)!,
                workspacePool: workspacePool,
                xcodeInspector: xcodeInspector
            ), (false, "No suggestion", nil)
        )
    }

    @WorkspaceActor
    func test_should_not_accept_without_filespace() {
        let fileURL = URL(string: "file:///test")!
        let workspacePool = FakeWorkspacePool()
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
        let xcodeInspector = FakeThreadSafeAccessToXcodeInspector(
            activeDocumentURL: fileURL,
            hasActiveXcode: true,
            hasFocusedEditor: true
        )
<<<<<<< HEAD
        assertEqual(
=======
        XCTAssertFalse(
>>>>>>> 4a8ae39... Pre-release 0.22.73
            TabToAcceptSuggestion.shouldAcceptSuggestion(
                event: CGEvent(keyboardEventSource: nil, virtualKey: 48, keyDown: true)!,
                workspacePool: workspacePool,
                xcodeInspector: xcodeInspector
<<<<<<< HEAD
            ), (false, "No filespace", nil)
=======
            )
>>>>>>> 4a8ae39... Pre-release 0.22.73
        )
    }

    @WorkspaceActor
    func test_should_not_accept_without_editor_focused() {
        let fileURL = URL(string: "file:///test")!
        let workspacePool = FakeWorkspacePool()
        workspacePool.setTestFile(fileURL: fileURL)
        let xcodeInspector = FakeThreadSafeAccessToXcodeInspector(
            activeDocumentURL: fileURL,
            hasActiveXcode: true,
            hasFocusedEditor: false
        )
<<<<<<< HEAD
        assertEqual(
=======
        XCTAssertFalse(
>>>>>>> 4a8ae39... Pre-release 0.22.73
            TabToAcceptSuggestion.shouldAcceptSuggestion(
                event: CGEvent(keyboardEventSource: nil, virtualKey: 48, keyDown: true)!,
                workspacePool: workspacePool,
                xcodeInspector: xcodeInspector
<<<<<<< HEAD
            ), (false, "No focused editor", nil)
=======
            )
>>>>>>> 4a8ae39... Pre-release 0.22.73
        )
    }

    @WorkspaceActor
    func test_should_not_accept_without_active_xcode() {
        let fileURL = URL(string: "file:///test")!
        let workspacePool = FakeWorkspacePool()
        workspacePool.setTestFile(fileURL: fileURL)
        let xcodeInspector = FakeThreadSafeAccessToXcodeInspector(
            activeDocumentURL: fileURL,
            hasActiveXcode: false,
            hasFocusedEditor: true
        )
<<<<<<< HEAD
        assertEqual(
=======
        XCTAssertFalse(
>>>>>>> 4a8ae39... Pre-release 0.22.73
            TabToAcceptSuggestion.shouldAcceptSuggestion(
                event: createEvent(48),
                workspacePool: workspacePool,
                xcodeInspector: xcodeInspector
<<<<<<< HEAD
            ), (false, "No active Xcode", nil)
=======
            )
>>>>>>> 4a8ae39... Pre-release 0.22.73
        )
    }

    @WorkspaceActor
    func test_should_not_accept_without_active_document() {
        let fileURL = URL(string: "file:///test")!
        let workspacePool = FakeWorkspacePool()
        workspacePool.setTestFile(fileURL: fileURL)
        let xcodeInspector = FakeThreadSafeAccessToXcodeInspector(
            activeDocumentURL: nil,
            hasActiveXcode: true,
            hasFocusedEditor: true
        )
<<<<<<< HEAD
        assertEqual(
=======
        XCTAssertFalse(
>>>>>>> 4a8ae39... Pre-release 0.22.73
            TabToAcceptSuggestion.shouldAcceptSuggestion(
                event: createEvent(48),
                workspacePool: workspacePool,
                xcodeInspector: xcodeInspector
<<<<<<< HEAD
            ), (false, "No active document", nil)
=======
            )
>>>>>>> 4a8ae39... Pre-release 0.22.73
        )
    }

    @WorkspaceActor
    func test_should_not_accept_with_shift() {
        let fileURL = URL(string: "file:///test")!
        let workspacePool = FakeWorkspacePool()
        workspacePool.setTestFile(fileURL: fileURL)
        let xcodeInspector = FakeThreadSafeAccessToXcodeInspector(
            activeDocumentURL: fileURL,
            hasActiveXcode: true,
            hasFocusedEditor: true
        )
<<<<<<< HEAD
        assertEqual(
=======
        XCTAssertFalse(
>>>>>>> 4a8ae39... Pre-release 0.22.73
            TabToAcceptSuggestion.shouldAcceptSuggestion(
                event: createEvent(48, flags: .maskShift),
                workspacePool: workspacePool,
                xcodeInspector: xcodeInspector
<<<<<<< HEAD
            ), (false, nil, nil)
=======
            )
>>>>>>> 4a8ae39... Pre-release 0.22.73
        )
    }

    @WorkspaceActor
    func test_should_not_accept_with_command() {
        let fileURL = URL(string: "file:///test")!
        let workspacePool = FakeWorkspacePool()
        workspacePool.setTestFile(fileURL: fileURL)
        let xcodeInspector = FakeThreadSafeAccessToXcodeInspector(
            activeDocumentURL: fileURL,
            hasActiveXcode: true,
            hasFocusedEditor: true
        )
<<<<<<< HEAD
        assertEqual(
=======
        XCTAssertFalse(
>>>>>>> 4a8ae39... Pre-release 0.22.73
            TabToAcceptSuggestion.shouldAcceptSuggestion(
                event: createEvent(48, flags: .maskCommand),
                workspacePool: workspacePool,
                xcodeInspector: xcodeInspector
<<<<<<< HEAD
            ), (false, nil, nil)
=======
            )
>>>>>>> 4a8ae39... Pre-release 0.22.73
        )
    }

    @WorkspaceActor
    func test_should_not_accept_with_control() {
        let fileURL = URL(string: "file:///test")!
        let workspacePool = FakeWorkspacePool()
        workspacePool.setTestFile(fileURL: fileURL)
        let xcodeInspector = FakeThreadSafeAccessToXcodeInspector(
            activeDocumentURL: fileURL,
            hasActiveXcode: true,
            hasFocusedEditor: true
        )
<<<<<<< HEAD
        assertEqual(
=======
        XCTAssertFalse(
>>>>>>> 4a8ae39... Pre-release 0.22.73
            TabToAcceptSuggestion.shouldAcceptSuggestion(
                event: createEvent(48, flags: .maskControl),
                workspacePool: workspacePool,
                xcodeInspector: xcodeInspector
<<<<<<< HEAD
            ), (false, nil, nil)
=======
            )
>>>>>>> 4a8ae39... Pre-release 0.22.73
        )
    }

    @WorkspaceActor
    func test_should_not_accept_with_help() {
        let fileURL = URL(string: "file:///test")!
        let workspacePool = FakeWorkspacePool()
        workspacePool.setTestFile(fileURL: fileURL)
        let xcodeInspector = FakeThreadSafeAccessToXcodeInspector(
            activeDocumentURL: fileURL,
            hasActiveXcode: true,
            hasFocusedEditor: true
        )
<<<<<<< HEAD
        assertEqual(
=======
        XCTAssertFalse(
>>>>>>> 4a8ae39... Pre-release 0.22.73
            TabToAcceptSuggestion.shouldAcceptSuggestion(
                event: createEvent(48, flags: .maskHelp),
                workspacePool: workspacePool,
                xcodeInspector: xcodeInspector
<<<<<<< HEAD
            ), (false, nil, nil)
        )
    }
}

private func assertEqual(
    _ result: (Bool, String?, CodeSuggestionType?),
    _ expected: (Bool, String?, CodeSuggestionType?),
) {
    if result != expected {
        XCTFail("Expected \(expected), got \(result)")
=======
            )
        )
    }

    @WorkspaceActor
    func test_should_not_accept_without_tab() {
        let fileURL = URL(string: "file:///test")!
        let workspacePool = FakeWorkspacePool()
        workspacePool.setTestFile(fileURL: fileURL)
        let xcodeInspector = FakeThreadSafeAccessToXcodeInspector(
            activeDocumentURL: fileURL,
            hasActiveXcode: true,
            hasFocusedEditor: true
        )
        XCTAssertFalse(
            TabToAcceptSuggestion.shouldAcceptSuggestion(
                event: createEvent(50),
                workspacePool: workspacePool,
                xcodeInspector: xcodeInspector
            )
        )
>>>>>>> 4a8ae39... Pre-release 0.22.73
    }
}

private func createEvent(_ keyCode: CGKeyCode, flags: CGEventFlags = []) -> CGEvent {
    let event = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: true)!
    event.flags = flags
    return event
}

private struct FakeThreadSafeAccessToXcodeInspector: ThreadSafeAccessToXcodeInspectorProtocol {
    let activeDocumentURL: URL?
    let hasActiveXcode: Bool
    let hasFocusedEditor: Bool
}

private class FakeWorkspacePool: WorkspacePool {
    private var fileURL: URL?
    private var filespace: Filespace?
    
    @WorkspaceActor
<<<<<<< HEAD
    func setTestFile(fileURL: URL, skipSuggestion: Bool = false) {
        self.fileURL = fileURL
        self.filespace = Filespace(fileURL: fileURL, content: "", onSave: {_ in }, onClose: {_ in })
        if skipSuggestion { return }
=======
    func setTestFile(fileURL: URL) {
        self.fileURL = fileURL
        self.filespace = Filespace(fileURL: fileURL, onSave: {_ in }, onClose: {_ in })
>>>>>>> 4a8ae39... Pre-release 0.22.73
        guard let filespace = self.filespace else { return }
        filespace.setSuggestions([.init(id: "id", text: "test", position: .zero, range: .zero)])
    }
    
    override func fetchFilespaceIfExisted(fileURL: URL) -> Filespace? {
        guard fileURL == self.fileURL else { return .none }
        return filespace
    }
}

