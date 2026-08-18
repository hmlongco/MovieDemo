import Runes
import SwiftUI

public struct ExpandableText: View {
    private let text: String
    private let font: Font
    private let textColor: Color
    private let backgroundColor: Color
    private let lineLimit: Int
    private let lineSpacing: CGFloat

    @State private var isExpanded = false

    public init(
        _ text: String,
        font: Font = .system(size: 14),
        textColor: Color = Color(hex: "A3A3A3"),
        backgroundColor: Color = Color(hex: "0A0A0A"),
        lineLimit: Int = 6,
        lineSpacing: CGFloat = 4
    ) {
        self.text = text
        self.font = font
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.lineLimit = lineLimit
        self.lineSpacing = lineSpacing
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: isExpanded ? 8 : 0) {
            Button {
                if !isExpanded {
                    isExpanded.toggle()
                }
            } label: {
                Text(text)
                    .foregroundStyle(textColor)
                    .font(font)
                    .lineSpacing(lineSpacing)
                    .lineLimit(isExpanded ? nil : lineLimit)
                    .multilineTextAlignment(.leading)
                    .overlay(alignment: .bottom) {
                        if !isExpanded {
                            LinearGradient(
                                colors: [backgroundColor.opacity(0), backgroundColor],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(height: 48)
                            .allowsHitTesting(false)
                        }
                    }
            }
            .disabled(isExpanded)

            Button(isExpanded ? "Less" : "More", action: toggleExpanded)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.white)
                .offset(y: isExpanded ? 0 : -10)
        }
        .animation(.easeInOut, value: isExpanded)
    }

    private func toggleExpanded() {
        isExpanded.toggle()
    }
}
