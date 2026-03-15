import AppKit
import Foundation
<<<<<<< HEAD
import XcodeInspector
import ConversationServiceProvider

public struct WidgetLocation: Equatable {
    // Indicates from where the widget location generation was triggered
    enum LocationTrigger {
        case sourceEditor, xcodeWorkspaceWindow, unknown, otherApp
        
        var isSourceEditor: Bool { self == .sourceEditor }
        var isOtherApp: Bool { self == .otherApp }
        var isFromXcode: Bool { self == .sourceEditor || self == .xcodeWorkspaceWindow}
    }
    
    struct NESPanelLocation: Equatable {
        struct DiffViewConstraints: Equatable {
            var maxX: CGFloat
            var y: CGFloat
            var maxWidth: CGFloat
            var maxHeight: CGFloat
        }

        var scrollViewFrame: CGRect
        var screenFrame: CGRect
        var lineFirstCharacterFrame: CGRect
        
        var lineHeight: Double {
            lineFirstCharacterFrame.height
        }
        var menuFrame: CGRect {
            .init(
                x: scrollViewFrame.minX + Style.nesSuggestionMenuLeadingPadding,
                y: screenFrame.height - lineFirstCharacterFrame.maxY,
                width: lineFirstCharacterFrame.width,
                height: lineHeight
            )
        }
        
        var availableHeight: CGFloat? {
            guard scrollViewFrame.contains(lineFirstCharacterFrame) else {
                return nil
            }
            return scrollViewFrame.maxY - lineFirstCharacterFrame.minY
        }
        
        var availableWidth: CGFloat {
            return scrollViewFrame.width / 2
        }
        
        func calcDiffViewFrame(contentSize: CGSize) -> CGRect? {
            guard scrollViewFrame.contains(lineFirstCharacterFrame) else {
                return nil
            }
            
            let availableWidth = max(0, scrollViewFrame.width / 2)
            let availableHeight = max(0, scrollViewFrame.maxY - lineFirstCharacterFrame.minY)
            let preferredWidth = max(contentSize.width, 1)
            let preferredHeight = max(contentSize.height, lineHeight)
            
            let width = availableWidth > 0 ? min(preferredWidth, availableWidth) : preferredWidth
            let height = availableHeight > 0 ? min(preferredHeight, availableHeight) : preferredHeight
            
            return .init(
                x: scrollViewFrame.maxX - width - Style.nesSuggestionMenuLeadingPadding,
                y: screenFrame.height - lineFirstCharacterFrame.minY - height,
                width: width,
                height: height
            )
        }
    }
    
    struct AgentConfigurationWidgetLocation: Equatable {
        var firstLineFrame: CGRect
        var scrollViewRect: CGRect
        var screenFrame: CGRect
        var textEndX: CGFloat
        
        var lineHeight: CGFloat {
            firstLineFrame.height
        }
        
        func getWidgetFrame(_ originalFrame: NSRect) -> NSRect {
            let width = originalFrame.width
            let height = originalFrame.height
            let lineCenter = firstLineFrame.minY + firstLineFrame.height / 2
            let panelHalfHeight = originalFrame.height / 2
            
            return .init(
                x: textEndX + Style.agentConfigurationWidgetLeadingSpacing,
                y: screenFrame.maxY - lineCenter - panelHalfHeight + screenFrame.minY,
                width: width,
                height: height
            )
        }
    }
    
=======

public struct WidgetLocation: Equatable {
>>>>>>> 4a8ae39... Pre-release 0.22.73
    struct PanelLocation: Equatable {
        var frame: CGRect
        var alignPanelTop: Bool
        var firstLineIndent: Double?
        var lineHeight: Double?
    }
<<<<<<< HEAD
    
=======

>>>>>>> 4a8ae39... Pre-release 0.22.73
    var widgetFrame: CGRect
    var tabFrame: CGRect
    var defaultPanelLocation: PanelLocation
    var suggestionPanelLocation: PanelLocation?
<<<<<<< HEAD
    var nesSuggestionPanelLocation: NESPanelLocation?
    var locationTrigger: LocationTrigger = .unknown
    var agentConfigurationWidgetLocation: AgentConfigurationWidgetLocation?
    
    mutating func setNESSuggestionPanelLocation(_ location: NESPanelLocation?) {
        self.nesSuggestionPanelLocation = location
    }
    
    mutating func setLocationTrigger(_ trigger: LocationTrigger) {
        self.locationTrigger = trigger
    }
    
    mutating func setAgentConfigurationWidgetLocation(_ location: AgentConfigurationWidgetLocation?) {
        self.agentConfigurationWidgetLocation = location
    }
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
}

enum UpdateLocationStrategy {
    struct AlignToTextCursor {
        func framesForWindows(
            editorFrame: CGRect,
            mainScreen: NSScreen,
            activeScreen: NSScreen,
            editor: AXUIElement,
            hideCircularWidget: Bool = UserDefaults.shared.value(for: \.hideCircularWidget),
            preferredInsideEditorMinWidth: Double = UserDefaults.shared
                .value(for: \.preferWidgetToStayInsideEditorWhenWidthGreaterThan)
        ) -> WidgetLocation {
            guard let selectedRange: AXValue = try? editor
                .copyValue(key: kAXSelectedTextRangeAttribute),
<<<<<<< HEAD
                  let rect: AXValue = try? editor.copyParameterizedValue(
                    key: kAXBoundsForRangeParameterizedAttribute,
                    parameters: selectedRange
                  )
=======
                let rect: AXValue = try? editor.copyParameterizedValue(
                    key: kAXBoundsForRangeParameterizedAttribute,
                    parameters: selectedRange
                )
>>>>>>> 4a8ae39... Pre-release 0.22.73
            else {
                return FixedToBottom().framesForWindows(
                    editorFrame: editorFrame,
                    mainScreen: mainScreen,
                    activeScreen: activeScreen,
                    hideCircularWidget: hideCircularWidget
                )
            }
            var frame: CGRect = .zero
            let found = AXValueGetValue(rect, .cgRect, &frame)
            guard found else {
                return FixedToBottom().framesForWindows(
                    editorFrame: editorFrame,
                    mainScreen: mainScreen,
                    activeScreen: activeScreen,
                    hideCircularWidget: hideCircularWidget
                )
            }
            return HorizontalMovable().framesForWindows(
                y: mainScreen.frame.height - frame.maxY,
                alignPanelTopToAnchor: nil,
                editorFrame: editorFrame,
                mainScreen: mainScreen,
                activeScreen: activeScreen,
                preferredInsideEditorMinWidth: preferredInsideEditorMinWidth,
                hideCircularWidget: hideCircularWidget
            )
        }
    }
<<<<<<< HEAD
    
=======

>>>>>>> 4a8ae39... Pre-release 0.22.73
    struct FixedToBottom {
        func framesForWindows(
            editorFrame: CGRect,
            mainScreen: NSScreen,
            activeScreen: NSScreen,
            hideCircularWidget: Bool = UserDefaults.shared.value(for: \.hideCircularWidget),
            preferredInsideEditorMinWidth: Double = UserDefaults.shared
                .value(for: \.preferWidgetToStayInsideEditorWhenWidthGreaterThan),
            editorFrameExpendedSize: CGSize = .zero
        ) -> WidgetLocation {
            return HorizontalMovable().framesForWindows(
                y: mainScreen.frame.height - editorFrame.maxY + Style.widgetPadding,
                alignPanelTopToAnchor: false,
                editorFrame: editorFrame,
                mainScreen: mainScreen,
                activeScreen: activeScreen,
                preferredInsideEditorMinWidth: preferredInsideEditorMinWidth,
                hideCircularWidget: hideCircularWidget,
                editorFrameExpendedSize: editorFrameExpendedSize
            )
        }
    }
<<<<<<< HEAD
    
=======

>>>>>>> 4a8ae39... Pre-release 0.22.73
    struct HorizontalMovable {
        func framesForWindows(
            y: CGFloat,
            alignPanelTopToAnchor fixedAlignment: Bool?,
            editorFrame: CGRect,
            mainScreen: NSScreen,
            activeScreen: NSScreen,
            preferredInsideEditorMinWidth: Double,
            hideCircularWidget: Bool = UserDefaults.shared.value(for: \.hideCircularWidget),
            editorFrameExpendedSize: CGSize = .zero
        ) -> WidgetLocation {
            let maxY = max(
                y,
                mainScreen.frame.height - editorFrame.maxY + Style.widgetPadding,
                4 + activeScreen.frame.minY
            )
            let y = min(
                maxY,
                activeScreen.frame.maxY - 4,
                mainScreen.frame.height - editorFrame.minY - Style.widgetHeight - Style
                    .widgetPadding
            )
<<<<<<< HEAD
            
=======

>>>>>>> 4a8ae39... Pre-release 0.22.73
            var proposedAnchorFrameOnTheRightSide = CGRect(
                x: editorFrame.maxX - Style.widgetPadding,
                y: y,
                width: 0,
                height: 0
            )
<<<<<<< HEAD
            
=======

>>>>>>> 4a8ae39... Pre-release 0.22.73
            let widgetFrameOnTheRightSide = CGRect(
                x: editorFrame.maxX - Style.widgetPadding - Style.widgetWidth,
                y: y,
                width: Style.widgetWidth,
                height: Style.widgetHeight
            )
<<<<<<< HEAD
            
            if !hideCircularWidget {
                proposedAnchorFrameOnTheRightSide = widgetFrameOnTheRightSide
            }
            
            let proposedPanelX = proposedAnchorFrameOnTheRightSide.maxX
            + Style.widgetPadding * 2
            - editorFrameExpendedSize.width
=======

            if !hideCircularWidget {
                proposedAnchorFrameOnTheRightSide = widgetFrameOnTheRightSide
            }

            let proposedPanelX = proposedAnchorFrameOnTheRightSide.maxX
                + Style.widgetPadding * 2
                - editorFrameExpendedSize.width
>>>>>>> 4a8ae39... Pre-release 0.22.73
            let putPanelToTheRight = {
                if editorFrame.size.width >= preferredInsideEditorMinWidth { return false }
                return activeScreen.frame.maxX > proposedPanelX + Style.panelWidth
            }()
            let alignPanelTopToAnchor = fixedAlignment ?? (y > activeScreen.frame.midY)
<<<<<<< HEAD
            
            let chatPanelFrame = getChatPanelFrame(mainScreen)
            
            if putPanelToTheRight {
                let anchorFrame = proposedAnchorFrameOnTheRightSide
                let tabFrame = CGRect(
                    x: anchorFrame.origin.x,
                    y: alignPanelTopToAnchor
                    ? anchorFrame.minY - Style.widgetHeight - Style.widgetPadding
                    : anchorFrame.maxY + Style.widgetPadding,
                    width: Style.widgetWidth,
                    height: Style.widgetHeight
                )
                
=======

            if putPanelToTheRight {
                let anchorFrame = proposedAnchorFrameOnTheRightSide
                let panelFrame = CGRect(
                    x: proposedPanelX,
                    y: alignPanelTopToAnchor
                        ? anchorFrame.maxY - Style.panelHeight
                        : anchorFrame.minY - editorFrameExpendedSize.height,
                    width: Style.panelWidth,
                    height: Style.panelHeight
                )
                let tabFrame = CGRect(
                    x: anchorFrame.origin.x,
                    y: alignPanelTopToAnchor
                        ? anchorFrame.minY - Style.widgetHeight - Style.widgetPadding
                        : anchorFrame.maxY + Style.widgetPadding,
                    width: Style.widgetWidth,
                    height: Style.widgetHeight
                )

>>>>>>> 4a8ae39... Pre-release 0.22.73
                return .init(
                    widgetFrame: widgetFrameOnTheRightSide,
                    tabFrame: tabFrame,
                    defaultPanelLocation: .init(
<<<<<<< HEAD
                        frame: chatPanelFrame,
=======
                        frame: panelFrame,
>>>>>>> 4a8ae39... Pre-release 0.22.73
                        alignPanelTop: alignPanelTopToAnchor
                    ),
                    suggestionPanelLocation: nil
                )
            } else {
                var proposedAnchorFrameOnTheLeftSide = CGRect(
                    x: editorFrame.minX + Style.widgetPadding,
                    y: proposedAnchorFrameOnTheRightSide.origin.y,
                    width: 0,
                    height: 0
                )
<<<<<<< HEAD
                
=======

>>>>>>> 4a8ae39... Pre-release 0.22.73
                let widgetFrameOnTheLeftSide = CGRect(
                    x: editorFrame.minX + Style.widgetPadding,
                    y: proposedAnchorFrameOnTheRightSide.origin.y,
                    width: Style.widgetWidth,
                    height: Style.widgetHeight
                )
<<<<<<< HEAD
                
                if !hideCircularWidget {
                    proposedAnchorFrameOnTheLeftSide = widgetFrameOnTheLeftSide
                }
                
                let proposedPanelX = proposedAnchorFrameOnTheLeftSide.minX
                - Style.widgetPadding * 2
                - Style.panelWidth
                + editorFrameExpendedSize.width
=======

                if !hideCircularWidget {
                    proposedAnchorFrameOnTheLeftSide = widgetFrameOnTheLeftSide
                }

                let proposedPanelX = proposedAnchorFrameOnTheLeftSide.minX
                    - Style.widgetPadding * 2
                    - Style.panelWidth
                    + editorFrameExpendedSize.width
>>>>>>> 4a8ae39... Pre-release 0.22.73
                let putAnchorToTheLeft = {
                    if editorFrame.size.width >= preferredInsideEditorMinWidth {
                        if editorFrame.maxX <= activeScreen.frame.maxX {
                            return false
                        }
                    }
                    return proposedPanelX > activeScreen.frame.minX
                }()
<<<<<<< HEAD
                
                if putAnchorToTheLeft {
                    let anchorFrame = proposedAnchorFrameOnTheLeftSide
                    let tabFrame = CGRect(
                        x: anchorFrame.origin.x,
                        y: alignPanelTopToAnchor
                        ? anchorFrame.minY - Style.widgetHeight - Style.widgetPadding
                        : anchorFrame.maxY + Style.widgetPadding,
=======

                if putAnchorToTheLeft {
                    let anchorFrame = proposedAnchorFrameOnTheLeftSide
                    let panelFrame = CGRect(
                        x: proposedPanelX,
                        y: alignPanelTopToAnchor
                            ? anchorFrame.maxY - Style.panelHeight
                            : anchorFrame.minY - editorFrameExpendedSize.height,
                        width: Style.panelWidth,
                        height: Style.panelHeight
                    )
                    let tabFrame = CGRect(
                        x: anchorFrame.origin.x,
                        y: alignPanelTopToAnchor
                            ? anchorFrame.minY - Style.widgetHeight - Style.widgetPadding
                            : anchorFrame.maxY + Style.widgetPadding,
>>>>>>> 4a8ae39... Pre-release 0.22.73
                        width: Style.widgetWidth,
                        height: Style.widgetHeight
                    )
                    return .init(
                        widgetFrame: widgetFrameOnTheLeftSide,
                        tabFrame: tabFrame,
                        defaultPanelLocation: .init(
<<<<<<< HEAD
                            frame: chatPanelFrame,
=======
                            frame: panelFrame,
>>>>>>> 4a8ae39... Pre-release 0.22.73
                            alignPanelTop: alignPanelTopToAnchor
                        ),
                        suggestionPanelLocation: nil
                    )
                } else {
                    let anchorFrame = proposedAnchorFrameOnTheRightSide
<<<<<<< HEAD
=======
                    let panelFrame = CGRect(
                        x: anchorFrame.maxX - Style.panelWidth,
                        y: alignPanelTopToAnchor
                            ? anchorFrame.maxY - Style.panelHeight - Style.widgetHeight
                            - Style.widgetPadding
                            : anchorFrame.maxY + Style.widgetPadding
                            - editorFrameExpendedSize.height,
                        width: Style.panelWidth,
                        height: Style.panelHeight
                    )
>>>>>>> 4a8ae39... Pre-release 0.22.73
                    let tabFrame = CGRect(
                        x: anchorFrame.minX - Style.widgetPadding - Style.widgetWidth,
                        y: anchorFrame.origin.y,
                        width: Style.widgetWidth,
                        height: Style.widgetHeight
                    )
                    return .init(
                        widgetFrame: widgetFrameOnTheRightSide,
                        tabFrame: tabFrame,
                        defaultPanelLocation: .init(
<<<<<<< HEAD
                            frame: chatPanelFrame,
=======
                            frame: panelFrame,
>>>>>>> 4a8ae39... Pre-release 0.22.73
                            alignPanelTop: alignPanelTopToAnchor
                        ),
                        suggestionPanelLocation: nil
                    )
                }
            }
        }
    }
<<<<<<< HEAD
    
=======

>>>>>>> 4a8ae39... Pre-release 0.22.73
    struct NearbyTextCursor {
        func framesForSuggestionWindow(
            editorFrame: CGRect,
            mainScreen: NSScreen,
            activeScreen: NSScreen,
            editor: AXUIElement,
            completionPanel: AXUIElement?
        ) -> WidgetLocation.PanelLocation? {
            guard let selectionFrame = UpdateLocationStrategy
                .getSelectionFirstLineFrame(editor: editor) else { return nil }
<<<<<<< HEAD
            
=======

>>>>>>> 4a8ae39... Pre-release 0.22.73
            // hide it when the line of code is outside of the editor visible rect
            if selectionFrame.maxY < editorFrame.minY || selectionFrame.minY > editorFrame.maxY {
                return nil
            }
<<<<<<< HEAD
            
            let lineHeight: Double = selectionFrame.height
            let selectionMinY = selectionFrame.minY
=======

>>>>>>> 4a8ae39... Pre-release 0.22.73
            // Always place suggestion window at cursor position.
            return .init(
                frame: .init(
                    x: editorFrame.minX,
<<<<<<< HEAD
                    y: mainScreen.frame.height - selectionMinY - Style.inlineSuggestionMaxHeight + Style.inlineSuggestionPadding,
=======
                    y: mainScreen.frame.height - selectionFrame.minY - Style.inlineSuggestionMaxHeight + Style.inlineSuggestionPadding,
>>>>>>> 4a8ae39... Pre-release 0.22.73
                    width: editorFrame.width,
                    height: Style.inlineSuggestionMaxHeight
                ),
                alignPanelTop: true,
                firstLineIndent: selectionFrame.maxX - editorFrame.minX - Style.inlineSuggestionPadding,
<<<<<<< HEAD
                lineHeight: lineHeight
            )
        }
    }
    
=======
                lineHeight: selectionFrame.height
            )
        }
    }

>>>>>>> 4a8ae39... Pre-release 0.22.73
    /// Get the frame of the selection.
    static func getSelectionFrame(editor: AXUIElement) -> CGRect? {
        guard let selectedRange: AXValue = try? editor
            .copyValue(key: kAXSelectedTextRangeAttribute),
<<<<<<< HEAD
              let rect: AXValue = try? editor.copyParameterizedValue(
                key: kAXBoundsForRangeParameterizedAttribute,
                parameters: selectedRange
              )
=======
            let rect: AXValue = try? editor.copyParameterizedValue(
                key: kAXBoundsForRangeParameterizedAttribute,
                parameters: selectedRange
            )
>>>>>>> 4a8ae39... Pre-release 0.22.73
        else {
            return nil
        }
        var selectionFrame: CGRect = .zero
        let found = AXValueGetValue(rect, .cgRect, &selectionFrame)
        guard found else { return nil }
        return selectionFrame
    }
<<<<<<< HEAD
    
=======

>>>>>>> 4a8ae39... Pre-release 0.22.73
    /// Get the frame of the first line of the selection.
    static func getSelectionFirstLineFrame(editor: AXUIElement) -> CGRect? {
        // Find selection range rect
        guard let selectedRange: AXValue = try? editor
            .copyValue(key: kAXSelectedTextRangeAttribute),
<<<<<<< HEAD
              let rect: AXValue = try? editor.copyParameterizedValue(
                key: kAXBoundsForRangeParameterizedAttribute,
                parameters: selectedRange
              )
=======
            let rect: AXValue = try? editor.copyParameterizedValue(
                key: kAXBoundsForRangeParameterizedAttribute,
                parameters: selectedRange
            )
>>>>>>> 4a8ae39... Pre-release 0.22.73
        else {
            return nil
        }
        var selectionFrame: CGRect = .zero
        let found = AXValueGetValue(rect, .cgRect, &selectionFrame)
        guard found else { return nil }
<<<<<<< HEAD
        
        var firstLineRange: CFRange = .init()
        let foundFirstLine = AXValueGetValue(selectedRange, .cfRange, &firstLineRange)
        firstLineRange.length = 0
        
#warning(
        "FIXME: When selection is too low and out of the screen, the selection range becomes something else."
        )
        
        if foundFirstLine,
           let firstLineSelectionRange = AXValueCreate(.cfRange, &firstLineRange),
           let firstLineRect: AXValue = try? editor.copyParameterizedValue(
            key: kAXBoundsForRangeParameterizedAttribute,
            parameters: firstLineSelectionRange
=======

        var firstLineRange: CFRange = .init()
        let foundFirstLine = AXValueGetValue(selectedRange, .cfRange, &firstLineRange)
        firstLineRange.length = 0

        #warning(
            "FIXME: When selection is too low and out of the screen, the selection range becomes something else."
        )

        if foundFirstLine,
           let firstLineSelectionRange = AXValueCreate(.cfRange, &firstLineRange),
           let firstLineRect: AXValue = try? editor.copyParameterizedValue(
               key: kAXBoundsForRangeParameterizedAttribute,
               parameters: firstLineSelectionRange
>>>>>>> 4a8ae39... Pre-release 0.22.73
           )
        {
            var firstLineFrame: CGRect = .zero
            let foundFirstLineFrame = AXValueGetValue(firstLineRect, .cgRect, &firstLineFrame)
            if foundFirstLineFrame {
                selectionFrame = firstLineFrame
            }
        }
<<<<<<< HEAD
        
        return selectionFrame
    }
    
    static func getChatPanelFrame(_ screen: NSScreen? = nil) -> CGRect {
        let screen = screen ??  NSScreen.main ?? NSScreen.screens.first!
        
        let visibleScreenFrame = screen.visibleFrame
        
        // Default Frame
        let width = min(Style.panelWidth, visibleScreenFrame.width * 0.3)
        let height = visibleScreenFrame.height
        let x = visibleScreenFrame.maxX - width
        let y = visibleScreenFrame.minY
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    static func getAttachedChatPanelFrame(_ screen: NSScreen, workspaceWindowElement: AXUIElement) -> CGRect {
        guard let xcodeScreen = workspaceWindowElement.maxIntersectionScreen,
              let xcodeRect = workspaceWindowElement.rect,
              let mainDisplayScreen = NSScreen.screens.first(where: { $0.frame.origin == .zero })
        else {
            return getChatPanelFrame()
        }
        
        let minWidth = Style.minChatPanelWidth
        let visibleXcodeScreenFrame = xcodeScreen.visibleFrame
        
        let width = max(visibleXcodeScreenFrame.maxX - xcodeRect.maxX, minWidth)
        let height = xcodeRect.height
        let x = visibleXcodeScreenFrame.maxX - width
        
        // AXUIElement coordinates: Y=0 at top-left
        // NSWindow coordinates: Y=0 at bottom-left
        let y = mainDisplayScreen.frame.maxY - xcodeRect.maxY + mainDisplayScreen.frame.minY
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

public struct CodeReviewLocationStrategy {
    static func calculateCurrentLineNumber(
        for originalLineNumber: Int, // 1-based
        originalLines: [String],
        currentLines: [String]
    ) -> Int {
        let difference = currentLines.difference(from: originalLines)
        
        let targetIndex = originalLineNumber
        var adjustment = 0
        
        for change in difference {
            switch change {
            case .insert(let offset, _, _):
                // Inserted at or before target line
                if offset <= targetIndex + adjustment {
                    adjustment += 1
                }
            case .remove(let offset, _, _):
                // Deleted at or before target line
                if offset <= targetIndex + adjustment {
                    adjustment -= 1
                }
            }
        }
        
        return targetIndex + adjustment
    }
    
    static func getCurrentLineFrame(
        editor: AXUIElement,
        currentContent: String,
        comment: ReviewComment,
        originalContent: String
    ) -> (lineNumber: Int?, lineFrame: CGRect?) {
        let originalLines = originalContent.components(separatedBy: .newlines)
        let currentLines = currentContent.components(separatedBy: .newlines)
        
        let originalLineNumber = comment.range.end.line
        let currentLineNumber = calculateCurrentLineNumber(
            for: originalLineNumber,
            originalLines: originalLines,
            currentLines: currentLines
        ) // 0-based
        
        guard let rect = LocationStrategyHelper.getLineFrame(currentLineNumber, in: editor, with: currentLines) else {
            return (nil, nil)
        }
        
        return (currentLineNumber, rect)
    }
}

public struct NESPanelLocationStrategy {
    static func getNESPanelLocation(
        maybeEditor: AXUIElement,
        state: WidgetFeature.State
    ) -> WidgetLocation.NESPanelLocation? {
        guard let sourceEditor = maybeEditor.findSourceEditorElement(shouldRetry: false),
              let editorContent: String = try? sourceEditor.copyValue(key: kAXValueAttribute),
              let nesContent = state.panelState.nesContent,
              let screen = NSScreen.screens.first(where: { $0.frame.origin == .zero })
        else {
            return nil
        }
        
        let startLine = nesContent.range.start.line
        guard let lineFirstCharacterFrame = LocationStrategyHelper.getLineFrame(
            startLine,
            in: sourceEditor,
            with: editorContent.components(separatedBy: .newlines),
            length: 1
        ) else {
            return nil
        }
        
        guard let scrollViewFrame = sourceEditor.parent?.rect else {
            return nil
        }
        
        return .init(
            scrollViewFrame: scrollViewFrame,
            screenFrame: screen.frame,
            lineFirstCharacterFrame: lineFirstCharacterFrame
        )
    }
}

public struct AgentConfigurationWidgetLocationStrategy {
    static func getAgentConfigurationWidgetLocation(
        maybeEditor: AXUIElement,
        screen: NSScreen
    ) -> WidgetLocation.AgentConfigurationWidgetLocation? {
        guard let sourceEditorElement = maybeEditor.findSourceEditorElement(shouldRetry: false),
              let editorContent: String = try? sourceEditorElement.copyValue(key: kAXValueAttribute),
              let scrollViewRect = sourceEditorElement.parent?.rect
        else {
            return nil
        }
        
        // Get the editor content to access lines
        let lines = editorContent.components(separatedBy: .newlines)
        guard !lines.isEmpty else {
            return nil
        }
        
        // Get the frame of the first line (line 0)
        guard let firstLineFrame = LocationStrategyHelper.getLineFrame(
            0,
            in: sourceEditorElement,
            with: [lines[0]]
        ) else {
            return nil
        }
        
        // Check if the first line is visible within the scroll view
        guard firstLineFrame.width > 0, firstLineFrame.height > 0,
              scrollViewRect.contains(firstLineFrame)
        else {
            return nil
        }
        
        // Get the actual text content width (excluding trailing whitespace)
        let firstLineText = lines[0].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let textEndX: CGFloat
        
        if !firstLineText.isEmpty {
            // Calculate character position for the end of the trimmed text
            let textLength = firstLineText.count
            var range = CFRange(location: 0, length: textLength)
            
            if let rangeValue = AXValueCreate(AXValueType.cfRange, &range),
               let boundsValue: AXValue = try? sourceEditorElement.copyParameterizedValue(
                key: kAXBoundsForRangeParameterizedAttribute,
                parameters: rangeValue
               ) {
                var textRect = CGRect.zero
                if AXValueGetValue(boundsValue, .cgRect, &textRect) {
                    textEndX = textRect.maxX
                } else {
                    textEndX = firstLineFrame.minX
                }
            } else {
                textEndX = firstLineFrame.minX
            }
        } else {
            textEndX = firstLineFrame.minX
        }
        
        return .init(
            firstLineFrame: firstLineFrame,
            scrollViewRect: scrollViewRect,
            screenFrame: screen.frame,
            textEndX: textEndX
        )
    }
}
=======

        return selectionFrame
    }
}

>>>>>>> 4a8ae39... Pre-release 0.22.73
