import Foundation
import Workspace
<<<<<<< HEAD
import LanguageServerProtocol
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

public final class BuiltinExtensionWorkspacePlugin: WorkspacePlugin {
    let extensionManager: BuiltinExtensionManager

    public init(workspace: Workspace, extensionManager: BuiltinExtensionManager = .shared) {
        self.extensionManager = extensionManager
        super.init(workspace: workspace)
    }

<<<<<<< HEAD
    override public func didOpenFilespace(_ filespace: Filespace) async {
        await notifyOpenFile(filespace: filespace)
=======
    override public func didOpenFilespace(_ filespace: Filespace) {
        notifyOpenFile(filespace: filespace)
>>>>>>> 4a8ae39... Pre-release 0.22.73
    }

    override public func didSaveFilespace(_ filespace: Filespace) {
        notifySaveFile(filespace: filespace)
    }

<<<<<<< HEAD
    override public func didUpdateFilespace(
        _ filespace: Filespace,
        content: String,
        contentChanges: [TextDocumentContentChangeEvent]? = nil
    ) async {
        await notifyUpdateFile(filespace: filespace, content: content, contentChanges: contentChanges)
=======
    override public func didUpdateFilespace(_ filespace: Filespace, content: String) {
        notifyUpdateFile(filespace: filespace, content: content)
>>>>>>> 4a8ae39... Pre-release 0.22.73
    }

    override public func didCloseFilespace(_ fileURL: URL) {
        Task {
            for ext in extensionManager.extensions {
                ext.workspace(
                    .init(workspaceURL: workspaceURL, projectURL: projectRootURL),
                    didCloseDocumentAt: fileURL
                )
            }
        }
    }

<<<<<<< HEAD
    public func notifyOpenFile(filespace: Filespace) async {
        guard filespace.isTextReadable else { return }
        for ext in extensionManager.extensions {
            await ext.workspace(
                .init(workspaceURL: workspaceURL, projectURL: projectRootURL),
                didOpenDocumentAt: filespace.fileURL
            )
        }
    }

    public func notifyUpdateFile(
        filespace: Filespace,
        content: String,
        contentChanges: [TextDocumentContentChangeEvent]? = nil
    ) async {
        guard filespace.isTextReadable else { return }
        for ext in extensionManager.extensions {
            await ext.workspace(
                .init(workspaceURL: workspaceURL, projectURL: projectRootURL),
                didUpdateDocumentAt: filespace.fileURL,
                content: content,
                contentChanges: contentChanges
            )
=======
    public func notifyOpenFile(filespace: Filespace) {
        Task {
            guard filespace.isTextReadable else { return }
            for ext in extensionManager.extensions {
                ext.workspace(
                    .init(workspaceURL: workspaceURL, projectURL: projectRootURL),
                    didOpenDocumentAt: filespace.fileURL
                )
            }
        }
    }

    public func notifyUpdateFile(filespace: Filespace, content: String) {
        Task {
            guard filespace.isTextReadable else { return }
            for ext in extensionManager.extensions {
                ext.workspace(
                    .init(workspaceURL: workspaceURL, projectURL: projectRootURL),
                    didUpdateDocumentAt: filespace.fileURL, 
                    content: content
                )
            }
>>>>>>> 4a8ae39... Pre-release 0.22.73
        }
    }

    public func notifySaveFile(filespace: Filespace) {
        Task {
            guard filespace.isTextReadable else { return }
            for ext in extensionManager.extensions {
                ext.workspace(
                    .init(workspaceURL: workspaceURL, projectURL: projectRootURL),
                    didSaveDocumentAt: filespace.fileURL
                )
            }
        }
    }
}

