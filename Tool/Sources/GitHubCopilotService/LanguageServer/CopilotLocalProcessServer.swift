import Combine
<<<<<<< HEAD
import ConversationServiceProvider
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
import Foundation
import JSONRPC
import LanguageClient
import LanguageServerProtocol
import Logger
import ProcessEnv
<<<<<<< HEAD
import Status

public enum ServerError: LocalizedError {
    case handlerUnavailable(String)
    case unhandledMethod(String)
    case notificationDispatchFailed(Error)
    case requestDispatchFailed(Error)
    case clientDataUnavailable(Error)
    case serverUnavailable
    case missingExpectedParameter
    case missingExpectedResult
    case unableToDecodeRequest(Error)
    case unableToSendRequest(Error)
    case unableToSendNotification(Error)
    case serverError(code: Int, message: String, data: Codable?)
    case invalidRequest(Error?)
    case timeout
    case unknownError(Error)

    static func responseError(_ error: AnyJSONRPCResponseError) -> ServerError {
        return ServerError.serverError(code: error.code,
                                       message: error.message,
                                       data: error.data)
    }
    
    static func decodingError(_ error: DecodingError) -> ServerError {
        let message: String
        
        switch error {
        case .typeMismatch(let type, let context):
            message = "Type mismatch: Expected \(type). \(context.debugDescription)"
            
        case .valueNotFound(let type, let context):
            message = "Value not found: Expected \(type). \(context.debugDescription)"
            
        case .keyNotFound(let key, let context):
            message = "Key '\(key.stringValue)' not found. \(context.debugDescription)"
            
        case .dataCorrupted(let context):
            message = "Data corrupted: \(context.debugDescription)"
            
        @unknown default:
            message = error.localizedDescription
        }
        
        return ServerError.serverError(code: -32700, message: message, data: nil)
    }

    static func convertToServerError(error: any Error) -> ServerError {
        if let serverError = error as? ServerError {
            return serverError
        } else if let jsonRPCError = error as? AnyJSONRPCResponseError {
            return responseError(jsonRPCError)
        } else if let decodeError = error as? DecodingError {
            return decodingError(decodeError)
        }
        
        return .unknownError(error)
    }
}

public typealias LSPResponse = Decodable & Sendable
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

/// A clone of the `LocalProcessServer`.
/// We need it because the original one does not allow us to handle custom notifications.
class CopilotLocalProcessServer {
    public var notificationPublisher: PassthroughSubject<AnyJSONRPCNotification, Never> = PassthroughSubject<AnyJSONRPCNotification, Never>()
    
<<<<<<< HEAD
    private var process: Process?
    private var wrappedServer: CustomJSONRPCServerConnection?

    private var cancellables = Set<AnyCancellable>()
=======
    private let transport: StdioDataTransport
    private let customTransport: CustomDataTransport
    private let process: Process
    private var wrappedServer: CustomJSONRPCLanguageServer?
    private var cancellables = Set<AnyCancellable>()
    var terminationHandler: (() -> Void)?
>>>>>>> 4a8ae39... Pre-release 0.22.73
    @MainActor var ongoingCompletionRequestIDs: [JSONId] = []
    @MainActor var ongoingConversationRequestIDs = [String: JSONId]()
    
    public convenience init(
        path: String,
        arguments: [String],
        environment: [String: String]? = nil
    ) {
        let params = Process.ExecutionParameters(
            path: path,
            arguments: arguments,
            environment: environment
        )

        self.init(executionParameters: params)
    }

    init(executionParameters parameters: Process.ExecutionParameters) {
<<<<<<< HEAD
        do {
            let channel: DataChannel = try startLocalProcess(parameters: parameters, terminationHandler: processTerminated)
            let noop: @Sendable (Data) async -> Void = { _ in }
            let newChannel = DataChannel.tap(channel: channel.withMessageFraming(), onRead: noop, onWrite: onWriteRequest)

            self.wrappedServer = CustomJSONRPCServerConnection(dataChannel: newChannel, notificationHandler: handleNotification)
        } catch {
            Logger.gitHubCopilot.error("Failed to start local CLS process: \(error)")
        }
    }
    
    deinit {
        self.process?.terminate()
    }

    private func startLocalProcess(parameters: Process.ExecutionParameters,
                                      terminationHandler: @escaping @Sendable () -> Void) throws -> DataChannel {
        let (channel, process) = try DataChannel.localProcessChannel(parameters: parameters, terminationHandler: terminationHandler)

        // Create a serial queue to synchronize writes
        let writeQueue = DispatchQueue(label: "DataChannel.writeQueue")
        let stdinPipe: Pipe = process.standardInput as! Pipe
        self.process = process
        let handler: DataChannel.WriteHandler = { data in
            try writeQueue.sync {
                // write is not thread-safe, so we need to use queue to ensure it thread-safe
                try stdinPipe.fileHandleForWriting.write(contentsOf: data)
            }
        }

        let wrappedChannel = DataChannel(
            writeHandler: handler,
            dataSequence: channel.dataSequence
        )

        return wrappedChannel
    }
    
    @Sendable
    private func onWriteRequest(data: Data) {
        guard let request = try? JSONDecoder().decode(JSONRPCRequest<JSONValue>.self, from: data) else {
            return
        }

        if request.method == "getCompletionsCycling" || request.method == "textDocument/copilotInlineEdit" {
            Task { @MainActor [weak self] in
                self?.ongoingCompletionRequestIDs.append(request.id)
            }
        } else if request.method == "conversation/create" {
            Task { @MainActor [weak self] in
                if let paramsData = try? JSONEncoder().encode(request.params) {
                    do {
                        let params = try JSONDecoder().decode(ConversationCreateParams.self, from: paramsData)
                        self?.ongoingConversationRequestIDs[params.workDoneToken] = request.id
                    } catch {
                        // Handle decoding error
                        Logger.gitHubCopilot.error("Error decoding ConversationCreateParams: \(error)")
                    }
                }
            }
        } else if request.method == "conversation/turn" {
            Task { @MainActor [weak self] in
                if let paramsData = try? JSONEncoder().encode(request.params) {
                    do {
                        let params = try JSONDecoder().decode(TurnCreateParams.self, from: paramsData)
                        self?.ongoingConversationRequestIDs[params.workDoneToken] = request.id
                    } catch {
                        // Handle decoding error
                        Logger.gitHubCopilot.error("Error decoding TurnCreateParams: \(error)")
=======
        transport = StdioDataTransport()
        let framing = SeperatedHTTPHeaderMessageFraming()
        let messageTransport = MessageTransport(
            dataTransport: transport,
            messageProtocol: framing
        )
        customTransport = CustomDataTransport(nextTransport: messageTransport)
        wrappedServer = CustomJSONRPCLanguageServer(dataTransport: customTransport)

        process = Process()

        // Because the implementation of LanguageClient is so closed,
        // we need to get the request IDs from a custom transport before the data
        // is written to the language server.
        customTransport.onWriteRequest = { [weak self] request in
            if request.method == "getCompletionsCycling" {
                Task { @MainActor [weak self] in
                    self?.ongoingCompletionRequestIDs.append(request.id)
                }
            } else if request.method == "conversation/create" {
                Task { @MainActor [weak self] in
                    if let paramsData = try? JSONEncoder().encode(request.params) {
                        do {
                            let params = try JSONDecoder().decode(ConversationCreateParams.self, from: paramsData)
                            self?.ongoingConversationRequestIDs[params.workDoneToken] = request.id
                        } catch {
                            // Handle decoding error
                            print("Error decoding ConversationCreateParams: \(error)")
                        }
                    }
                }
            } else if request.method == "conversation/turn" {
                Task { @MainActor [weak self] in
                    if let paramsData = try? JSONEncoder().encode(request.params) {
                        do {
                            let params = try JSONDecoder().decode(TurnCreateParams.self, from: paramsData)
                            self?.ongoingConversationRequestIDs[params.workDoneToken] = request.id
                        } catch {
                            // Handle decoding error
                            print("Error decoding TurnCreateParams: \(error)")
                        }
>>>>>>> 4a8ae39... Pre-release 0.22.73
                    }
                }
            }
        }
<<<<<<< HEAD
    }

    @Sendable
    private func processTerminated() {
        // releasing the server here will short-circuit any pending requests,
        // which might otherwise take a while to time out, if ever.
        wrappedServer = nil
    }

    private func handleNotification(
        _ anyNotification: AnyJSONRPCNotification,
        data: Data
    ) -> Bool {
        let methodName = anyNotification.method
        let debugDescription = encodeJSONParams(params: anyNotification.params)
        if let method = ServerNotification.Method(rawValue: methodName) {
            switch method {
            case .windowLogMessage:
                Logger.gitHubCopilot.info("\(anyNotification.method): \(debugDescription)")
                return true
            case .protocolProgress:
                notificationPublisher.send(anyNotification)
                return true
            default:
                return false
            }
        } else {
            switch methodName {
            case "LogMessage":
                Logger.gitHubCopilot.info("\(anyNotification.method): \(debugDescription)")
                return true
            case "didChangeStatus":
                Logger.gitHubCopilot.info("\(anyNotification.method): \(debugDescription)")
                if let payload = GitHubCopilotNotification.StatusNotification.decode(fromParams: anyNotification.params) {
                    Task {
                        await Status.shared
                            .updateCLSStatus(
                                payload.kind.clsStatus,
                                busy: payload.busy,
                                message: payload.message ?? ""
                            )
                    }
                }
                return true
            case "copilot/didChangeFeatureFlags":
                notificationPublisher.send(anyNotification)
                return true
            case "copilot/mcpTools":
                notificationPublisher.send(anyNotification)
                return true
            case "copilot/mcpRuntimeLogs":
                notificationPublisher.send(anyNotification)
                return true
            case "policy/didChange":
                notificationPublisher.send(anyNotification)
                return true
            case "conversation/preconditionsNotification", "statusNotification":
                // Ignore
                return true
            default:
                return false
            }
        }
    }
}

extension CopilotLocalProcessServer: ServerConnection {
    var eventSequence: EventSequence {
        guard let server = wrappedServer else {
            let result = EventSequence.makeStream()
            result.continuation.finish()
            return result.stream
        }
        
        return server.eventSequence
    }

    public func sendNotification(_ notif: ClientNotification) async throws {
        guard let server = wrappedServer, let process = process, process.isRunning else {
            throw ServerError.serverUnavailable
        }
        
        do {
            try await server.sendNotification(notif)
        } catch {
            throw ServerError.unableToSendNotification(error)
        }
    }
    
    /// send copilot specific notification
    public func sendCopilotNotification(_ notif: CopilotClientNotification) async throws -> Void {
        guard let server = wrappedServer, let process = process, process.isRunning else {
            throw ServerError.serverUnavailable
        }
        
        let method = notif.method.rawValue
        
        do {
            switch notif {
            case .copilotDidChangeWatchedFiles(let params):
                try await server.sendNotification(params, method: method)
            case .clientProtocolProgress(let params):
                try await server.sendNotification(params, method: method)
            case .textDocumentDidShowInlineEdit(let params):
                try await server.sendNotification(params, method: method)
            }
        } catch {
            throw ServerError.unableToSendNotification(error)
        }
=======
        
        wrappedServer?.notificationPublisher.sink(receiveValue: { [weak self] notification in
            self?.notificationPublisher.send(notification)
        }).store(in: &cancellables)

        process.standardInput = transport.stdinPipe
        process.standardOutput = transport.stdoutPipe
        process.standardError = transport.stderrPipe
        
        process.parameters = parameters
        
        process.terminationHandler = { [unowned self] task in
            self.processTerminated(task)
        }
        
        process.launch()
    }

    deinit {
        process.terminationHandler = nil
        process.terminate()
        transport.close()
    }

    private func processTerminated(_: Process) {
        transport.close()

        // releasing the server here will short-circuit any pending requests,
        // which might otherwise take a while to time out, if ever.
        wrappedServer = nil
        terminationHandler?()
    }

    var logMessages: Bool {
        get { return wrappedServer?.logMessages ?? false }
        set { wrappedServer?.logMessages = newValue }
    }
}

extension CopilotLocalProcessServer: LanguageServerProtocol.Server {
    public var requestHandler: RequestHandler? {
        get { return wrappedServer?.requestHandler }
        set { wrappedServer?.requestHandler = newValue }
    }

    public var notificationHandler: NotificationHandler? {
        get { wrappedServer?.notificationHandler }
        set { wrappedServer?.notificationHandler = newValue }
    }

    public func sendNotification(
        _ notif: ClientNotification,
        completionHandler: @escaping (ServerError?) -> Void
    ) {
        guard let server = wrappedServer, process.isRunning else {
            completionHandler(.serverUnavailable)
            return
        }

        server.sendNotification(notif, completionHandler: completionHandler)
>>>>>>> 4a8ae39... Pre-release 0.22.73
    }

    /// Cancel ongoing completion requests.
    public func cancelOngoingTasks() async {
        let task = Task { @MainActor in
            for id in ongoingCompletionRequestIDs {
                await cancelTask(id)
            }
            self.ongoingCompletionRequestIDs = []
        }
        await task.value
    }
    
    public func cancelOngoingTask(_ workDoneToken: String) async {
        let task = Task { @MainActor in
            guard let id = ongoingConversationRequestIDs[workDoneToken] else { return }
            await cancelTask(id)
        }
        await task.value
    }
    
    public func cancelTask(_ id: JSONId) async {
<<<<<<< HEAD
        guard let server = wrappedServer, let process = process, process.isRunning else {
=======
        guard let server = wrappedServer, process.isRunning else {
>>>>>>> 4a8ae39... Pre-release 0.22.73
            return
        }
        
        switch id {
        case let .numericId(id):
            try? await server.sendNotification(.protocolCancelRequest(.init(id: id)))
        case let .stringId(id):
            try? await server.sendNotification(.protocolCancelRequest(.init(id: id)))
        }
    }
<<<<<<< HEAD
    
    public func sendRequest<Response: LSPResponse>(
        _ request: ClientRequest
    ) async throws -> Response {
        guard let server = wrappedServer, let process = process, process.isRunning else {
            throw ServerError.serverUnavailable
        }
        
        do {
            return try await server.sendRequest(request)
        } catch {
            throw ServerError.convertToServerError(error: error)
        }
    }
}

func encodeJSONParams(params: JSONValue?) -> String {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    if let jsonData = try? encoder.encode(params),
       let text = String(data: jsonData, encoding: .utf8)
    {
        return text
    }
    return "N/A"
}

// MARK: - Copilot custom notification

public struct CopilotDidChangeWatchedFilesParams: Codable, Hashable {
    /// The CLS need an additional parameter `workspaceUri` for "workspace/didChangeWatchedFiles" event
    public var workspaceUri: String
    public var changes: [FileEvent]

    public init(workspaceUri: String, changes: [FileEvent]) {
        self.workspaceUri = workspaceUri
        self.changes = changes
    }
}

public enum CopilotClientNotification {
    public enum Method: String {
        case workspaceDidChangeWatchedFiles = "workspace/didChangeWatchedFiles"
        case protocolProgress = "$/progress"
        case textDocumentDidShowInlineEdit = "textDocument/didShowInlineEdit"
    }
    
    case copilotDidChangeWatchedFiles(CopilotDidChangeWatchedFilesParams)
    case clientProtocolProgress(ProgressParams)
    case textDocumentDidShowInlineEdit(TextDocumentDidShowInlineEditParams)
    
    public var method: Method {
        switch self {
        case .copilotDidChangeWatchedFiles:
            return .workspaceDidChangeWatchedFiles
        case .clientProtocolProgress:
            return .protocolProgress
        case .textDocumentDidShowInlineEdit:
            return .textDocumentDidShowInlineEdit
        }
    }
}
=======

    public func sendRequest<Response: Codable>(
        _ request: ClientRequest,
        completionHandler: @escaping (ServerResult<Response>) -> Void
    ) {
        guard let server = wrappedServer, process.isRunning else {
            completionHandler(.failure(.serverUnavailable))
            return
        }

        server.sendRequest(request, completionHandler: completionHandler)
    }
}

final class CustomJSONRPCLanguageServer: Server {
    let internalServer: JSONRPCLanguageServer

    typealias ProtocolResponse<T: Codable> = ProtocolTransport.ResponseResult<T>

    private let protocolTransport: ProtocolTransport

    public var requestHandler: RequestHandler?
    public var notificationHandler: NotificationHandler?
    public var notificationPublisher: PassthroughSubject<AnyJSONRPCNotification, Never> = PassthroughSubject<AnyJSONRPCNotification, Never>()

    private var outOfBandError: Error?

    init(protocolTransport: ProtocolTransport) {
        self.protocolTransport = protocolTransport
        internalServer = JSONRPCLanguageServer(protocolTransport: protocolTransport)

        let previouseRequestHandler = protocolTransport.requestHandler
        let previouseNotificationHandler = protocolTransport.notificationHandler

        protocolTransport
            .requestHandler = { [weak self] in
                guard let self else { return }
                if !self.handleRequest($0, data: $1, callback: $2) {
                    previouseRequestHandler?($0, $1, $2)
                }
            }
        protocolTransport
            .notificationHandler = { [weak self] in
                guard let self else { return }
                if !self.handleNotification($0, data: $1, block: $2) {
                    previouseNotificationHandler?($0, $1, $2)
                }
            }
    }

    convenience init(dataTransport: DataTransport) {
        self.init(protocolTransport: ProtocolTransport(dataTransport: dataTransport))
    }

    deinit {
        protocolTransport.requestHandler = nil
        protocolTransport.notificationHandler = nil
    }

    var logMessages: Bool {
        get { return internalServer.logMessages }
        set { internalServer.logMessages = newValue }
    }
}

extension CustomJSONRPCLanguageServer {
    private func handleNotification(
        _ anyNotification: AnyJSONRPCNotification,
        data: Data,
        block: @escaping (Error?) -> Void
    ) -> Bool {
        let methodName = anyNotification.method
        let debugDescription = {
            if let params = anyNotification.params {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                if let jsonData = try? encoder.encode(params),
                   let text = String(data: jsonData, encoding: .utf8)
                {
                    return text
                }
            }
            return "N/A"
        }()
        
        if let method = ServerNotification.Method(rawValue: methodName) {
            switch method {
            case .windowLogMessage:
                Logger.gitHubCopilot.info("\(anyNotification.method): \(debugDescription)")
                block(nil)
                return true
            case .protocolProgress:
                notificationPublisher.send(anyNotification)
                block(nil)
                return true
            default:
                return false
            }
        } else {
            switch methodName {
            case "LogMessage":
                Logger.gitHubCopilot.info("\(anyNotification.method): \(debugDescription)")
                block(nil)
                return true
            case "statusNotification":
                Logger.gitHubCopilot.info("\(anyNotification.method): \(debugDescription)")
                block(nil)
                return true
            case "featureFlagsNotification":
                notificationPublisher.send(anyNotification)
                block(nil)
                return true
            case "conversation/preconditionsNotification":
                // Ignore
                block(nil)
                return true
            default:
                return false
            }
        }
    }

    public func sendNotification(
        _ notif: ClientNotification,
        completionHandler: @escaping (ServerError?) -> Void
    ) {
        internalServer.sendNotification(notif, completionHandler: completionHandler)
    }
}

extension CustomJSONRPCLanguageServer {
    private func handleRequest(
        _ request: AnyJSONRPCRequest,
        data: Data,
        callback: @escaping (AnyJSONRPCResponse) -> Void
    ) -> Bool {
        return false
    }
}

extension CustomJSONRPCLanguageServer {
    public func sendRequest<Response: Codable>(
        _ request: ClientRequest,
        completionHandler: @escaping (ServerResult<Response>) -> Void
    ) {
        internalServer.sendRequest(request, completionHandler: completionHandler)
    }
}

>>>>>>> 4a8ae39... Pre-release 0.22.73
