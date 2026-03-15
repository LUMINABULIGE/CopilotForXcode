import ComposableArchitecture
import Dependencies
import Foundation
import SwiftUI
import Toast

<<<<<<< HEAD
private struct HitTestConfiguration: ViewModifier {
    let hitTestPredicate: () -> Bool
    
    func body(content: Content) -> some View {
        WithPerceptionTracking {
            content.allowsHitTesting(hitTestPredicate())
        }
    }
}

struct ToastPanelView: View {
    let store: StoreOf<ToastPanel>
    @Dependency(\.toastController) var toastController
=======
struct ToastPanelView: View {
    let store: StoreOf<ToastPanel>
>>>>>>> 4a8ae39... Pre-release 0.22.73

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 4) {
                if !store.alignTopToAnchor {
                    Spacer()
<<<<<<< HEAD
                        .allowsHitTesting(false)
                }

                ForEach(store.toast.messages) { message in
                    NotificationView(
                        message: message,
                        onDismiss: { toastController.dismissMessage(withId: message.id) }
                    )
                    .frame(maxWidth: 450)
                    // Allow hit testing for notification views
                    .allowsHitTesting(true)
=======
                }

                ForEach(store.toast.messages) { message in
                    message.content
                        .foregroundColor(.white)
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background({
                            switch message.type {
                            case .info: return Color.accentColor
                            case .error: return Color(nsColor: .systemRed)
                            case .warning: return Color(nsColor: .systemOrange)
                            }
                        }() as Color, in: RoundedRectangle(cornerRadius: 8))
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black.opacity(0.3), lineWidth: 1)
                        }
>>>>>>> 4a8ae39... Pre-release 0.22.73
                }

                if store.alignTopToAnchor {
                    Spacer()
<<<<<<< HEAD
                        .allowsHitTesting(false)
                }
            }
            .colorScheme(store.colorScheme)
            .background(Color.clear)
            // Only allow hit testing when there are messages
            // to prevent the view from blocking the mouse events
            .modifier(HitTestConfiguration(hitTestPredicate: { !store.toast.messages.isEmpty }))
        }
    }
}
=======
                }
            }
            .colorScheme(store.colorScheme)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .allowsHitTesting(false)
        }
    }
}

>>>>>>> 4a8ae39... Pre-release 0.22.73
