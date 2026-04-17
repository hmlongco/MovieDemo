import SwiftUI

public struct LoadableStateView<T: Equatable, Content: View>: View {
    private let state: LoadableState<T>
    @ViewBuilder private let content: (T) -> Content

    public init(state: LoadableState<T>, content: @escaping (T) -> Content) {
        self.state = state
        self.content = content
    }

    public var body: some View {
        switch state {
        case .initial:
            Color.clear

        case .loading:
            ProgressView()
                .tint(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded(let value):
            content(value)

        case .empty(let message):
            ContentUnavailableView(
                "Nothing here",
                systemImage: "film",
                description: Text(message)
            )
            .foregroundStyle(.white)

        case .error(let message):
            ContentUnavailableView(
                "Something went wrong",
                systemImage: "exclamationmark.circle",
                description: Text(message)
            )
            .foregroundStyle(.white)
        }
    }
}
