import Foundation
import LaunchAgentManager

<<<<<<< HEAD
public extension LaunchAgentManager {
=======
extension LaunchAgentManager {
>>>>>>> 4a8ae39... Pre-release 0.22.73
    init() {
        self.init(
            serviceIdentifier: Bundle.main
                .object(forInfoDictionaryKey: "BUNDLE_IDENTIFIER_BASE") as! String +
                ".CommunicationBridge",
            executablePath: Bundle.main.bundleURL
                .appendingPathComponent("Contents")
                .appendingPathComponent("Applications")
                .appendingPathComponent("CommunicationBridge")
                .path,
            bundleIdentifier: Bundle.main
                .object(forInfoDictionaryKey: "BUNDLE_IDENTIFIER_BASE") as! String
        )
    }
}

