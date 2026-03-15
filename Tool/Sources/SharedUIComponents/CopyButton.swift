import AppKit
import SwiftUI

public struct CopyButton: View {
    public var copy: () -> Void
    @State var isCopied = false
<<<<<<< HEAD
    private var foregroundColor: Color?
    private var fontWeight: Font.Weight? 
    
    public init(copy: @escaping () -> Void, foregroundColor: Color? = nil, fontWeight: Font.Weight? = nil) { 
        self.copy = copy
        self.foregroundColor = foregroundColor
        self.fontWeight = fontWeight 
=======
    
    public init(copy: @escaping () -> Void) {
        self.copy = copy
>>>>>>> 4a8ae39... Pre-release 0.22.73
    }
    
    public var body: some View {
        Button(action: {
            withAnimation(.linear(duration: 0.1)) {
                isCopied = true
            }
            copy()
            Task {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                withAnimation(.linear(duration: 0.1)) {
                    isCopied = false
                }
            }
        }) {
            Image(systemName: isCopied ? "checkmark.circle" : "doc.on.doc")
                .resizable()
<<<<<<< HEAD
                .scaledToFit()
                .scaledPadding(2)
                .scaledFrame(width: 16, height: 16)
                .foregroundColor(foregroundColor ?? .secondary)
                .conditionalFontWeight(fontWeight)
        }
        .buttonStyle(HoverButtonStyle(padding: 0))
        .help("Copy")
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
