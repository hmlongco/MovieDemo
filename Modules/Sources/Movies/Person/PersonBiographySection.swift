import Runes
import Shared
import SwiftUI

struct PersonBiographySection: View {

    let biography: String

    @State private var isExpanded = false

    private let collapsedLineLimit = 6

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "Biography")

            Text(biography)
                .foregroundStyle(Color(hex: "A3A3A3"))
                .font(.system(size: 14))
                .lineSpacing(4)
                .lineLimit(isExpanded ? nil : collapsedLineLimit)
                .overlay(alignment: .bottom) {
                    if !isExpanded {
                        LinearGradient(
                            colors: [Color(hex: "0A0A0A").opacity(0), Color(hex: "0A0A0A")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 36)
                        .allowsHitTesting(false)
                    }
                }

            Button(isExpanded ? "Less" : "More", action: toggleExpanded)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.white)
        }
    }

    private func toggleExpanded() {
        isExpanded.toggle()
    }
}
