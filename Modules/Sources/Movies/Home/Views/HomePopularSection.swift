import FactoryKit
import SwiftUI
import Runes
import Shared

struct HomePopularSection: View {
    let refreshID: Int
    let onSeeAll: () -> Void
    let onMovieTap: (Movie) -> Void

    @State private var viewModel = HomePopularViewModel()

    var body: some View {
        HorizontalMovieSection(
            title: "Popular Now",
            actionTitle: "See All",
            state: viewModel.state,
            skeletonCount: 4,
            skeletonWidth: 128,
            skeletonHeight: 200,
            onSeeAll: onSeeAll,
            onMovieTap: onMovieTap
        ) { movie in
            PosterCard(movie: movie)
                .frame(width: 128)
        }
        .task(id: refreshID) { viewModel.load() }
    }
}

// MARK: - Poster Card

private struct PosterCard: View {
    let movie: Movie
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            RemoteImageView(url: movie.posterURL)
                .frame(height: 180)
                .cornerRadius(8)
                .clipped()
            Text(movie.title)
                .foregroundStyle(.white)
                .font(.system(size: 13, weight: .medium))
                .lineLimit(1)
            HStack(spacing: 4) {
                Image(systemName: "star.fill").foregroundStyle(.yellow).font(.system(size: 10))
                Text(String(format: "%.1f", movie.voteAverage))
                    .foregroundStyle(Color(hex: "A3A3A3")).font(.system(size: 12))
            }
        }
    }
}

#if DEBUG
#Preview {
    Container.shared.setupMovieMocks()
    HomePopularSection(refreshID: 1, onSeeAll: {}, onMovieTap: { _ in })
        .preferredColorScheme(.dark)
}
#endif
