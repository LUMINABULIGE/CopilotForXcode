import ComposableArchitecture
import Dependencies
import Foundation
import SwiftUI

/// A pool that stores all the available tabs.
public final class ChatTabPool {
<<<<<<< HEAD
    public var createStore: (ChatTabInfo) -> StoreOf<ChatTabItem> = { info in
        .init(
            initialState: info,
=======
    public var createStore: (String) -> StoreOf<ChatTabItem> = { id in
        .init(
            initialState: .init(id: id, title: ""),
>>>>>>> 4a8ae39... Pre-release 0.22.73
            reducer: { ChatTabItem() }
        )
    }

    private var pool: [String: any ChatTab]

    public init(_ pool: [String: any ChatTab] = [:]) {
        self.pool = pool
    }

    public func getTab(of id: String) -> (any ChatTab)? {
        pool[id]
    }

    public func setTab(_ tab: any ChatTab) {
        pool[tab.id] = tab
    }

    public func removeTab(of id: String) {
<<<<<<< HEAD
        guard getTab(of: id) != nil else { return }
        
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
        pool.removeValue(forKey: id)
    }
}

public struct ChatTabPoolDependencyKey: DependencyKey {
    public static let liveValue = ChatTabPool()
}

public extension DependencyValues {
    var chatTabPool: ChatTabPool {
        get { self[ChatTabPoolDependencyKey.self] }
        set { self[ChatTabPoolDependencyKey.self] = newValue }
    }
}

public struct ChatTabPoolEnvironmentKey: EnvironmentKey {
    public static let defaultValue = ChatTabPool()
}

public extension EnvironmentValues {
    var chatTabPool: ChatTabPool {
        get { self[ChatTabPoolEnvironmentKey.self] }
        set { self[ChatTabPoolEnvironmentKey.self] = newValue }
    }
}

