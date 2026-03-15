import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
public struct SuggestionPanelFeature {
    @ObservableState
    public struct State: Equatable {
        var content: CodeSuggestionProvider?
        var isExpanded: Bool = false
        var colorScheme: ColorScheme = .light
        var alignTopToAnchor = false
        var firstLineIndent: Double = 0
        var lineHeight: Double = 17
        var isPanelDisplayed: Bool = false
        var isPanelOutOfFrame: Bool = false
<<<<<<< HEAD
        var warningMessage: String?
        var warningURL: String?
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
        var opacity: Double {
            guard isPanelDisplayed else { return 0 }
            if isPanelOutOfFrame { return 0 }
            guard content != nil else { return 0 }
            return 1
        }
    }

    public enum Action: Equatable {
        case noAction
<<<<<<< HEAD
        case dismissWarning
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .dismissWarning:
                state.warningMessage = nil
                state.warningURL = nil
                return .none
            default:
                return .none
            }
        }
=======
    }

    public var body: some ReducerOf<Self> {
        Reduce { _, _ in .none }
>>>>>>> 4a8ae39... Pre-release 0.22.73
    }
}
