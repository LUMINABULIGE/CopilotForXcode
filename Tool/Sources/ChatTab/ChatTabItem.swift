import ComposableArchitecture
import Foundation

public struct AnyChatTabBuilder: Equatable {
    public static func == (lhs: AnyChatTabBuilder, rhs: AnyChatTabBuilder) -> Bool {
        true
    }

    public let chatTabBuilder: any ChatTabBuilder

    public init(_ chatTabBuilder: any ChatTabBuilder) {
        self.chatTabBuilder = chatTabBuilder
    }
}

@Reducer
public struct ChatTabItem {
    public typealias State = ChatTabInfo

    public enum Action: Equatable {
        case updateTitle(String)
        case openNewTab(AnyChatTabBuilder)
        case tabContentUpdated
        case close
        case focus
<<<<<<< HEAD
        case setCLSConversationID(String)
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
<<<<<<< HEAD
            // the actions will be handled elsewhere in the ChatPanelFeature
            switch action {
            case .updateTitle:
=======
            switch action {
            case let .updateTitle(title):
                state.title = title
>>>>>>> 4a8ae39... Pre-release 0.22.73
                return .none
            case .openNewTab:
                return .none
            case .tabContentUpdated:
                return .none
            case .close:
                return .none
            case .focus:
                state.focusTrigger += 1
                return .none
<<<<<<< HEAD
            case .setCLSConversationID:
                return .none
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
            }
        }
    }
}

