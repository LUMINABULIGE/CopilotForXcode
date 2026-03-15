import ComposableArchitecture
import ChatService
import Foundation
import MarkdownUI
import SharedUIComponents
import SwiftUI
<<<<<<< HEAD
import Status
import Cache
import ChatTab
import ConversationServiceProvider
import SwiftUIFlowLayout
import ChatAPIService

private let MAX_TEXT_LENGTH = 10000 // Maximum characters to prevent crashes
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73

struct UserMessage: View {
    var r: Double { messageBubbleCornerRadius }
    let id: String
    let text: String
<<<<<<< HEAD
    let imageReferences: [ImageReference]
    let chat: StoreOf<Chat>
    let editorCornerRadius: Double
    let requestType: RequestType
    @Environment(\.colorScheme) var colorScheme
    @State var isMessageHovering: Bool = false

    // Truncate the displayed user message if it's too long.
    private var displayText: String {
        if text.count > MAX_TEXT_LENGTH {
            return String(text.prefix(MAX_TEXT_LENGTH)) + "\n… (message too long, rest hidden)"
        }
        return text
    }
    
    private var isEditing: Bool {
        if case .editUserMessage(let editId) = chat.state.editorMode {
            return editId == id
        }
        return false
    }
    
    private var editorMode: Chat.EditorMode { .editUserMessage(id) }
    
    private var isConversationMessage: Bool { requestType == .conversation }

    var body: some View {
        if !isEditing {
            messageView
        } else {
            MessageInputArea(editorMode: editorMode, chat: chat, editorCornerRadius: editorCornerRadius)
        }
    }

    var messageView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                textView
                    .scaledPadding(.vertical, 8)
                    .scaledPadding(.horizontal, 10)
                    .background(
                        RoundedRectangle(cornerRadius: r)
                            .fill(isMessageHovering ? Color("DarkBlue") : Color("LightBlue"))
                    )
                    .overlay(
                        Group {
                            if isConversationMessage {
                                Color.clear
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        chat.send(.setEditorMode(.editUserMessage(id)))
                                    }
                                    .allowsHitTesting(true)
                            }
                        }
                    )
                    .onHover { isHovered in
                        if isConversationMessage {
                            isMessageHovering = isHovered
                            if isHovered {
                                NSCursor.pointingHand.push()
                            } else {
                                NSCursor.pop()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
                if !imageReferences.isEmpty {
                    FlowLayout(mode: .scrollable, items: imageReferences, itemSpacing: 4) { item in
                        ImageReferenceItemView(item: item)
                    }
                    .environment(\.layoutDirection, .rightToLeft)
                }
            }
        }
    }
    
    var textView: some View {
        ThemedMarkdownText(text: displayText, chat: chat)
    }
}

private struct MessageInputArea: View {
    let editorMode: Chat.EditorMode
    let chat: StoreOf<Chat>
    let editorCornerRadius: Double
    
    var body: some View {
        ChatPanelInputArea(
            chat: chat,
            r: editorCornerRadius,
            editorMode: editorMode
        )
        .frame(maxWidth: .infinity)
    }
}

struct UserMessage_Previews: PreviewProvider {
    static var previews: some View {
        let chatTabInfo = ChatTabInfo(id: "id", workspacePath: "path", username: "name")
        UserMessage(
            id: "A",
            text: #"""
            Please buy me a coffee!
            | Coffee | Milk |
            |--------|------|
            | Espresso | No |
            | Latte | Yes |
            ```swift
            func foo() {}
            ```
            ```objectivec
            - (void)bar {}
            ```
            """#,
            imageReferences: [],
            chat: .init(
                initialState: .init(history: [] as [DisplayedChatMessage], isReceivingMessage: false),
                reducer: { Chat(service: ChatService.service(for: chatTabInfo)) }
            ),
            editorCornerRadius: 4,
            requestType: .conversation
        )
        .padding()
        .fixedSize(horizontal: true, vertical: true)
        .background(Color.yellow)
        
    }
}
=======
    let chat: StoreOf<Chat>
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack() {
            Spacer()
            VStack(alignment: .trailing) {
                ThemedMarkdownText(text)
                    .frame(alignment: .leading)
                    .padding()
            }
            .background {
                RoundedCorners(tl: r, tr: r, bl: r, br: 0)
                    .fill(Color.userChatContentBackground)
            }
            .overlay {
                RoundedCorners(tl: r, tr: r, bl: r, br: 0)
                    .stroke(Color(nsColor: .separatorColor), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.05), radius: 6)
        }
        .padding(.leading, 8)
        .padding(.trailing, 8)
    }
}

#Preview {
    UserMessage(
        id: "A",
        text: #"""
        Please buy me a coffee!
        | Coffee | Milk |
        |--------|------|
        | Espresso | No |
        | Latte | Yes |
        ```swift
        func foo() {}
        ```
        ```objectivec
        - (void)bar {}
        ```
        """#,
        chat: .init(
            initialState: .init(history: [] as [DisplayedChatMessage], isReceivingMessage: false),
            reducer: { Chat(service: ChatService.service()) }
        )
    )
    .padding()
    .fixedSize(horizontal: true, vertical: true)
}

>>>>>>> 4a8ae39... Pre-release 0.22.73
