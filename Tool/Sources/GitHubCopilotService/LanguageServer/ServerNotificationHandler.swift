import Combine
import Foundation
import JSONRPC
import LanguageServerProtocol

protocol ServerNotificationHandler {
    var protocolProgressSubject: PassthroughSubject<ProgressParams, Never> { get }
    func handleNotification(_ notification: AnyJSONRPCNotification)
}

class ServerNotificationHandlerImpl: ServerNotificationHandler {
    public static let shared = ServerNotificationHandlerImpl()
    var protocolProgressSubject: PassthroughSubject<LanguageServerProtocol.ProgressParams, Never>
    var conversationProgressHandler: ConversationProgressHandler = ConversationProgressHandlerImpl.shared
    var featureFlagNotifier: FeatureFlagNotifier = FeatureFlagNotifierImpl.shared
<<<<<<< HEAD
    var copilotPolicyNotifier: CopilotPolicyNotifier = CopilotPolicyNotifierImpl.shared
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

    init() {
        self.protocolProgressSubject = PassthroughSubject<ProgressParams, Never>()
    }

    func handleNotification(_ notification: AnyJSONRPCNotification) {
        let methodName = notification.method
        
        if let method = ServerNotification.Method(rawValue: methodName) {
            switch method {
            case .windowLogMessage:
                break
            case .protocolProgress:
                if let data = try? JSONEncoder().encode(notification.params),
                   let progress = try? JSONDecoder().decode(ProgressParams.self, from: data) {
                    conversationProgressHandler.handleConversationProgress(progress)
                }
            default:
                break
            }
        } else {
            switch methodName {
<<<<<<< HEAD
            case "copilot/didChangeFeatureFlags":
                if let data = try? JSONEncoder().encode(notification.params),
                   let didChangeFeatureFlagsParams = try? JSONDecoder().decode(
                    DidChangeFeatureFlagsParams.self,
                    from: data
                   ) {
                    featureFlagNotifier.handleFeatureFlagNotification(didChangeFeatureFlagsParams)
                }
                break
            case "policy/didChange":
                if let data = try? JSONEncoder().encode(notification.params),
                   let policy = try? JSONDecoder().decode(
                    CopilotPolicy.self,
                    from: data
                   ) {
                    copilotPolicyNotifier.handleCopilotPolicyNotification(policy)
=======
            case "featureFlagsNotification":
                if let data = try? JSONEncoder().encode(notification.params),
                    let featureFlags = try? JSONDecoder().decode(FeatureFlags.self, from: data) {
                    featureFlagNotifier.handleFeatureFlagNotification(featureFlags)
>>>>>>> 4a8ae39... Pre-release 0.22.73
                }
                break
            default:
                break
            }
        }
    }
}
