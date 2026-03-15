import Combine
import Foundation
import JSONRPC
import LanguageServerProtocol
<<<<<<< HEAD
import Logger
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

public enum ProgressKind: String {
    case begin, report, end
}

public protocol ConversationProgressHandler {
<<<<<<< HEAD
    var onBegin: PassthroughSubject<(String, ConversationProgressBegin), Never> { get }
    var onProgress: PassthroughSubject<(String, ConversationProgressReport), Never> { get }
    var onEnd: PassthroughSubject<(String, ConversationProgressEnd), Never> { get }
=======
    var onBegin: PassthroughSubject<(String, ConversationProgress), Never> { get }
    var onProgress: PassthroughSubject<(String, ConversationProgress), Never> { get }
    var onEnd: PassthroughSubject<(String, ConversationProgress), Never> { get }
>>>>>>> 4a8ae39... Pre-release 0.22.73
    func handleConversationProgress(_ progressParams: ProgressParams)
}

public final class ConversationProgressHandlerImpl: ConversationProgressHandler {
    public static let shared = ConversationProgressHandlerImpl()

<<<<<<< HEAD
    public var onBegin = PassthroughSubject<(String, ConversationProgressBegin), Never>()
    public var onProgress = PassthroughSubject<(String, ConversationProgressReport), Never>()
    public var onEnd = PassthroughSubject<(String, ConversationProgressEnd), Never>()
=======
    public var onBegin = PassthroughSubject<(String, ConversationProgress), Never>()
    public var onProgress = PassthroughSubject<(String, ConversationProgress), Never>()
    public var onEnd = PassthroughSubject<(String, ConversationProgress), Never>()
>>>>>>> 4a8ae39... Pre-release 0.22.73

    private var cancellables = Set<AnyCancellable>()

    public func handleConversationProgress(_ progressParams: ProgressParams) {
        guard let token = getValueAsString(from: progressParams.token),
<<<<<<< HEAD
              let data = try? JSONEncoder().encode(progressParams.value) else {
            print("Error encountered while parsing conversation progress params")
            Logger.gitHubCopilot.error("Error encountered while parsing conversation progress params")
            return
        }

        let progress = try? JSONDecoder().decode(ConversationProgressContainer.self, from: data)
        switch progress {
        case .begin(let begin):
            onBegin.send((token, begin))
        case .report(let report):
            onProgress.send((token, report))
        case .end(let end):
            onEnd.send((token, end))
        default:
            print("Invalid progress kind")
            return
        }
}
=======
              let data = try? JSONEncoder().encode(progressParams.value),
              let progress = try? JSONDecoder().decode(ConversationProgress.self, from: data) else {
            print("Error encountered while parsing conversation progress params")
            return
        }

        if let kind = ProgressKind(rawValue: progress.kind) {
            switch kind {
            case .begin:
                onBegin.send((token, progress))
            case .report:
                onProgress.send((token, progress))
            case .end:
                onEnd.send((token, progress))
            }
        }
    }
>>>>>>> 4a8ae39... Pre-release 0.22.73

    private func getValueAsString(from token: ProgressToken) -> String? {
        switch token {
        case .optionA(let intValue):
            return String(intValue)
        case .optionB(let stringValue):
            return stringValue
        }
    }
}
