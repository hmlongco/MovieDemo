import FactoryKit
import Runes
import Shared
import SwiftUI

public struct HeroCard: View {
    public let movie: any MovieSummary
    public let width: CGFloat
    public let height: CGFloat

    public var body: some View {
        ZStack(alignment: .bottomLeading) {
            RemoteImageView(url: movie.backdropURL ?? movie.posterURL)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()

            LinearGradient(
                colors: [.clear, Color(hex: "0A0A0A").opacity(0.8), Color(hex: "0A0A0A")],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: height / 2)
        }
        .frame(width: width, height: height)
        .overlay(alignment: .bottomLeading) {
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .foregroundStyle(.white)
                    .font(.system(size: 28, weight: .bold))
                    .lineLimit(2)

                HStack(spacing: 8) {
                    if let date = movie.releaseDate {
                        Text(date.prefix(4))
                            .foregroundStyle(Color(hex: "A3A3A3"))
                            .font(.system(size: 13))
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                            .font(.system(size: 11))
                        Text(String(format: "%.1f", movie.voteAverage))
                            .foregroundStyle(.white)
                            .font(.system(size: 13, weight: .medium))
                    }
                    Spacer()
                    StarRatingRepositoryView(movieId: movie.id)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 48)
        }
        .clipped()
    }
}

#if DEBUG
#Preview {
    Container.shared.setupMovieMocks()
    Container.shared.setupRatingMocks()
    HeroCard(movie: Movie.mock1, width: 420, height: 300)
        .modelContainer(for: MovieRating.self, inMemory: true)
}
#endif
