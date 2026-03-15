import SwiftUI
<<<<<<< HEAD
import SharedUIComponents
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

struct ErrorPanel: View {
    var description: String
    var onCloseButtonTap: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Text(description)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
            
            // close button
            Button(action: onCloseButtonTap) {
                Image(systemName: "xmark")
<<<<<<< HEAD
                    .scaledFont(.body)
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
                    .padding([.leading, .bottom], 16)
                    .padding([.top, .trailing], 8)
                    .foregroundColor(.white)
            }
            .buttonStyle(.plain)
        }
        .xcodeStyleFrame()
    }
}
