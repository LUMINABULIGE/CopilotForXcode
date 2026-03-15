import Foundation

public enum GitHubCopilotAccountStatus: String, Codable, CustomStringConvertible {
    case alreadySignedIn = "AlreadySignedIn"
    case maybeOk = "MaybeOk"
    case notAuthorized = "NotAuthorized"
    case notSignedIn = "NotSignedIn"
    case ok = "OK"
<<<<<<< HEAD
    case failedToGetToken = "FailedToGetToken"
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

    public var description: String {
        switch self {
        case .alreadySignedIn:
            return "Already Signed In"
        case .maybeOk:
<<<<<<< HEAD
            return "Unknown"
        case .notAuthorized:
            return "No Subscription"
        case .notSignedIn:
            return "Not Signed In"
        case .ok:
            return "Active"
        case .failedToGetToken:
            return "Failed to Get Token"
=======
            return "Maybe OK"
        case .notAuthorized:
            return "Not Authorized"
        case .notSignedIn:
            return "Not Signed In"
        case .ok:
            return "OK"
>>>>>>> 4a8ae39... Pre-release 0.22.73
        }
    }
}
