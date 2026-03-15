import AppKit
import SwiftUI
import ConversationServiceProvider

public struct DownvoteButton: View {
    public var downvote: (ConversationRating) -> Void
    @State var isSelected = false
    
    public init(downvote: @escaping (ConversationRating) -> Void) {
        self.downvote = downvote
    }
    
    public var body: some View {
        Button(action: {
            isSelected = !isSelected
            isSelected ? downvote(.unhelpful) : downvote(.unrated)
        }) {
            Image(systemName: isSelected ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                .resizable()
<<<<<<< HEAD
                .scaledToFit()
                .scaledPadding(2)
                .scaledFrame(width: 16, height: 16)
                .foregroundColor(.secondary)
                .help("Unhelpful")
        }
        .buttonStyle(HoverButtonStyle(padding: 0))
=======
                .aspectRatio(contentMode: .fit)
                .frame(width: 14, height: 14)
                .frame(width: 20, height: 20, alignment: .center)
                .foregroundColor(.secondary)
                .background(
                    .regularMaterial,
                    in: RoundedRectangle(cornerRadius: 4, style: .circular)
                )
                .padding(4)
        }
        .buttonStyle(.borderless)
>>>>>>> 4a8ae39... Pre-release 0.22.73
    }
}
