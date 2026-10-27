import SwiftUI

/// Previous/next buttons pinned to the leading and trailing edges of the hero carousel.
struct HeroNavigationButtons: View {
    let isEnabled: Bool
    let showPrevious: () -> Void
    let showNext: () -> Void

    var body: some View {
        HStack {
            Button("Previous", systemImage: "chevron.left", action: showPrevious)

            Spacer()

            Button("Next", systemImage: "chevron.right", action: showNext)
        }
        .disabled(!isEnabled)
        .labelStyle(.iconOnly)
        .buttonStyle(.bordered)
        .buttonBorderShape(.circle)
        .controlSize(.large)
        .padding(.horizontal, 26)
    }
}
