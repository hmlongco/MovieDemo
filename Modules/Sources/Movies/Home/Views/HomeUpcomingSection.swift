import FactoryKit
import SwiftUI
import Runes
import Shared

struct HomeUpcomingSection: View {
    let refreshID: Int
    let onSeeAll: () -> Void
    let onMovieTap: (Movie) -> Void

    @State private var viewModel = HomeUpcomingViewModel()

    var body: some View {
        HorizontalMovieSection(
            title: "Upcoming",
            actionTitle: "See All",
            state: viewModel.state,
            skeletonCount: 3,
            skeletonWidth: 280,
            skeletonHeight: 160,
            onSeeAll: onSeeAll,
            onMovieTap: onMovieTap
        ) { movie in
            UpcomingCard(movie: movie)
                .frame(width: 280)
        }
        .task(id: refreshID) {
            await viewModel.load()
        }
    }
}

// MARK: - Upcoming Card

private struct UpcomingCard: View {
    let movie: Movie
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RemoteImageView(url: movie.backdropURL ?? movie.posterURL)
                .frame(height: 160)
                .cornerRadius(10)
                .clipped()

            LinearGradient(colors: [.clear, .black.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                .frame(height: 160)
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .foregroundStyle(.white)
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(1)
                if let date = movie.releaseDate {
                    Text(date.prefix(4))
                        .foregroundStyle(Color(hex: "A3A3A3"))
                        .font(.system(size: 12))
                }
            }
            .padding(10)
        }
    }
}

#if DEBUG
#Preview {
    Container.shared.setupMovieMocks()
    HomeUpcomingSection(refreshID: 1, onSeeAll: { }, onMovieTap: { _ in })
        .preferredColorScheme(.dark)
}

#Preview {
    Container.shared.setupMovieMocks()
    UpcomingCard(movie: .mock1)
        .containerRelativeFrame(.horizontal) { w, _ in w * 0.5 }
        .preferredColorScheme(.dark)
}
#endif
