import SwiftUI

/// Previous/next buttons pinned to the leading and trailing edges of the hero carousel.
struct HeroNavigationButtons: View {
    let isEnabled: Bool
    let showPrevious: () -> Void
    let showNext: () -> Void

    /// Distance from the card's edge to the visible circle.
    private let edgeInset: CGFloat = 26

    var body: some View {
        HStack {
            Button("Previous", systemImage: "chevron.left", action: showPrevious)

            Spacer()

            Button("Next", systemImage: "chevron.right", action: showNext)
        }
        .disabled(!isEnabled)
        .buttonStyle(HeroNavigationButtonStyle())
        .padding(.horizontal, edgeInset - HeroNavigationButtonStyle.hitInset)
    }
}

/// A circular icon button whose tappable area extends well beyond the visible circle, so taps that miss the circle
/// don't fall through to the hero card underneath.
private struct HeroNavigationButtonStyle: ButtonStyle {
    static let hitInset: CGFloat = 24

    func makeBody(configuration: Configuration) -> some View {
        CircleButton(configuration: configuration)
    }

    private struct CircleButton: View {
        let configuration: ButtonStyleConfiguration
        @Environment(\.isEnabled) private var isEnabled

        var body: some View {
            configuration.label
                .labelStyle(.iconOnly)
                .font(.title3)
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(.white.opacity(configuration.isPressed ? 0.4 : 0.25), in: .circle)
                .opacity(isEnabled ? 1 : 0.4)
                .padding(HeroNavigationButtonStyle.hitInset)
                .contentShape(.rect)
        }
    }
}
