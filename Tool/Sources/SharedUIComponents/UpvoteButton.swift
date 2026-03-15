import AppKit
import SwiftUI
import ConversationServiceProvider

public struct UpvoteButton: View {
    public var upvote: (ConversationRating) -> Void
    @State var isSelected = false
    
    public init(upvote: @escaping (ConversationRating) -> Void) {
        self.upvote = upvote
    }
    
    public var body: some View {
        Button(action: {
            isSelected = !isSelected
            isSelected ? upvote(.helpful) : upvote(.unrated)
        }) {
            Image(systemName: isSelected ? "hand.thumbsup.fill" : "hand.thumbsup")
                .resizable()
<<<<<<< HEAD
                .scaledToFit()
                .scaledPadding(2)
                .scaledFrame(width: 16, height: 16)
                .foregroundColor(.secondary)
                .help("Helpful")
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
