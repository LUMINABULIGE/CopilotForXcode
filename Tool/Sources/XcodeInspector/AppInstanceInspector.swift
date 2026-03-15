import AppKit
import Foundation

public class AppInstanceInspector: ObservableObject {
<<<<<<< HEAD
    public let runningApplication: NSRunningApplication
=======
    let runningApplication: NSRunningApplication
>>>>>>> 4a8ae39... Pre-release 0.22.73
    public let processIdentifier: pid_t
    public let bundleURL: URL?
    public let bundleIdentifier: String?

<<<<<<< HEAD
    public var appElement: AXUIElement { .fromRunningApplication(runningApplication) }
=======
    public var appElement: AXUIElement {
        let app = AXUIElementCreateApplication(runningApplication.processIdentifier)
        app.setMessagingTimeout(2)
        return app
    }
>>>>>>> 4a8ae39... Pre-release 0.22.73

    public var isTerminated: Bool {
        return runningApplication.isTerminated
    }

    public var isActive: Bool {
        guard !runningApplication.isTerminated else { return false }
        return runningApplication.isActive
    }

    public var isXcode: Bool {
        guard !runningApplication.isTerminated else { return false }
        return runningApplication.isXcode
    }
<<<<<<< HEAD
    
    public var isCopilotForXcodeExtensionService: Bool {
        guard !runningApplication.isTerminated else { return false }
        return runningApplication.isCopilotForXcodeExtensionService
    }
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

    public var isExtensionService: Bool {
        guard !runningApplication.isTerminated else { return false }
        return runningApplication.isCopilotForXcodeExtensionService
    }

    public func activate() -> Bool {
        return runningApplication.activate()
    }
<<<<<<< HEAD
    
    public func activate(options: NSApplication.ActivationOptions) -> Bool {
        return runningApplication.activate(options: options)
    }

    public init(runningApplication: NSRunningApplication) {
=======

    init(runningApplication: NSRunningApplication) {
>>>>>>> 4a8ae39... Pre-release 0.22.73
        self.runningApplication = runningApplication
        processIdentifier = runningApplication.processIdentifier
        bundleURL = runningApplication.bundleURL
        bundleIdentifier = runningApplication.bundleIdentifier
    }
}

