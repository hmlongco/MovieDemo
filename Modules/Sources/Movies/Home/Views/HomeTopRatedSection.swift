import FactoryKit
import SwiftUI
import Runes
import Shared

struct HomeTopRatedSection: View {
    let refreshID: Int
    let onMovieTap: (Movie) -> Void

    @State private var viewModel = HomeTopRatedViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Top Rated")

            switch viewModel.state {
            case .loaded(let movies) where !movies.isEmpty:
                VStack(spacing: 12) {
                    ForEach(Array(movies.prefix(10).enumerated()), id: \.offset) { index, movie in
                        TopRatedRow(index: index + 1, movie: movie)
                            .onTapGesture { onMovieTap(movie) }
                        if index < min(9, movies.count - 1) {
                            Divider().background(Color.white.opacity(0.07)).padding(.horizontal, 16)
                        }
                    }
                }
            default:
                VStack(spacing: 12) {
                    ForEach(0..<4, id: \.self) { _ in
                        HStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 4).fill(Color(.secondarySystemFill)).frame(width: 32, height: 18)
                            RoundedRectangle(cornerRadius: 6).fill(Color(.secondarySystemFill)).frame(width: 56, height: 78)
                            VStack(alignment: .leading, spacing: 6) {
                                RoundedRectangle(cornerRadius: 4).fill(Color(.secondarySystemFill)).frame(height: 16)
                                RoundedRectangle(cornerRadius: 4).fill(Color(.secondarySystemFill)).frame(width: 100, height: 12)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .shimmer()
            }
        }
        .padding(.top, 24)
        .task(id: refreshID) { await viewModel.load() }
    }
}

// MARK: - Top Rated Row

private struct TopRatedRow: View {
    let index: Int
    let movie: Movie
    var body: some View {
        HStack(spacing: 12) {
            Text(String(format: "%02d", index))
                .foregroundStyle(Color(hex: "525252"))
                .font(.system(size: 18, weight: .bold))
                .frame(width: 32)

            RemoteImageView(url: movie.posterURL)
                .frame(width: 56, height: 78)
                .cornerRadius(6)
                .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .foregroundStyle(.white)
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(2)

                HStack(spacing: 4) {
                    Image(systemName: "star.fill").foregroundStyle(.yellow).font(.system(size: 10))
                    Text(String(format: "%.1f", movie.voteAverage))
                        .foregroundStyle(Color(hex: "A3A3A3")).font(.system(size: 12))
                    if let date = movie.releaseDate {
                        Text("• \(date.prefix(4))")
                            .foregroundStyle(Color(hex: "525252")).font(.system(size: 12))
                    }
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(Color(hex: "525252"))
                .font(.system(size: 12))
        }
        .padding(.horizontal, 16)
        .contentShape(Rectangle())
    }
}

#if DEBUG
#Preview {
    Container.shared.setupMovieMocks()
    HomeTopRatedSection(refreshID: 1, onMovieTap: { _ in })
        .preferredColorScheme(.dark)
}
#endif
