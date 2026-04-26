import FactoryKit
import SwiftUI
import NavigatorUI
import Runes
import Shared

struct HomeHeroSection: View {
    let refreshID: Int
    let onMovieTap: (Movie) -> Void

    @State private var viewModel = HomeHeroViewModel()

    var body: some View {
        Group {
            switch viewModel.state {
            case .loaded(let movies) where !movies.isEmpty:
                GeometryReader { geo in
                    TabView {
                        ForEach(movies.prefix(5)) { movie in
                            HeroCard(movie: movie, width: geo.size.width, height: 520)
                                .onTapGesture { onMovieTap(movie) }
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                }
                .frame(height: 520)

            default:
                ZStack(alignment: .bottomLeading) {
                    Rectangle()
                        .fill(Color(.secondarySystemFill))
                        .frame(maxWidth: .infinity)
                        .frame(height: 520)
                    VStack(alignment: .leading, spacing: 8) {
                        RoundedRectangle(cornerRadius: 4).fill(Color(hex: "2C2C2E")).frame(width: 200, height: 28)
                        RoundedRectangle(cornerRadius: 4).fill(Color(hex: "2C2C2E")).frame(width: 140, height: 16)
                    }
                    .padding(24)
                }
                .shimmer()
            }
        }
        .task(id: refreshID) { await viewModel.load() }
    }
}

// MARK: - Hero Card

private struct HeroCard: View {
    let movie: Movie
    let width: CGFloat
    let height: CGFloat

    var body: some View {
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
    VStack {
        HomeHeroSection(refreshID: 1, onMovieTap: { _ in })
            .preferredColorScheme(.dark)
        Spacer()
    }
    .ignoresSafeArea(.all)
}
#endif
