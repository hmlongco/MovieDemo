import SwiftUI
import Runes
import Shared

struct HorizontalMovieSection<CardView: View>: View {
    let title: String
    let actionTitle: String
    let state: LoadableState<[Movie]>
    let skeletonCount: Int
    let skeletonWidth: CGFloat
    let skeletonHeight: CGFloat
    let onSeeAll: () -> Void
    let onMovieTap: (Movie) -> Void
    @ViewBuilder let cardView: (Movie) -> CardView

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                SectionHeader(title: title)
                Spacer()
                Button(action: onSeeAll) {
                    Text(actionTitle)
                        .foregroundStyle(Color(hex: "A3A3A3"))
                        .font(.system(size: 13))
                }
            }
            .padding(.horizontal, 16)

            switch state {
            case .loaded(let movies) where !movies.isEmpty:
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(movies) { movie in
                            cardView(movie)
                                .onTapGesture { onMovieTap(movie) }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            default:
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(0..<skeletonCount, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.secondarySystemFill))
                                .frame(width: skeletonWidth, height: skeletonHeight)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .shimmer()
            }
        }
        .padding(.top, 24)
    }
}
