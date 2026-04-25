import FactoryKit
import NavigatorUI
import Runes
import Shared
import SwiftUI

struct MovieDetailView: View {

    let movieId: Int
    @State private var viewModel = MovieDetailViewModel()
    @Environment(\.navigator) private var navigator

    @State private var scrollOffset: CGFloat = 0
    private let heroHeight: CGFloat = 480

    var body: some View {
        ScrollView {
            GeometryReader { geo in
                let offset = geo.frame(in: .named("scroll")).minY
                Color.clear
                    .preference(key: ScrollOffsetKey.self, value: offset)
                    .frame(height: 0)
            }
            .frame(height: 0)

            VStack(spacing: 0) {
                heroImage
                detailContent
            }
        }
        .background(Color(hex: "0A0A0A").ignoresSafeArea())
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ScrollOffsetKey.self) { scrollOffset = $0 }
        .scrollIndicators(.hidden)
        .ignoresSafeArea(edges: .top)
        .task {
            viewModel.load(movieId: movieId)
        }
    }

    // MARK: - Hero Image

    private var heroImage: some View {
        GeometryReader { geo in
            let offset = max(0, scrollOffset)
            RemoteImageView(url: viewModel.detailState.value?.backdropURL ?? viewModel.detailState.value?.posterURL)
                .frame(width: geo.size.width, height: heroHeight + max(0, -scrollOffset))
                .clipped()
                .offset(y: offset > 0 ? -offset / 2 : 0)
        }
        .frame(height: heroHeight)
        .overlay(alignment: .bottom) {
            LinearGradient(
                colors: [.clear, Color(hex: "0A0A0A")],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 100)
        }
    }

    // MARK: - Detail Content

    @ViewBuilder
    private var detailContent: some View {
        switch viewModel.detailState {
        case .initial, .loading:
            MovieDetailSkeletonView()
                .padding(.top, -40)

        case .loaded(let detail):
            VStack(alignment: .leading, spacing: 24) {
                // Title + Meta
                VStack(alignment: .leading, spacing: 8) {
                    Text(detail.title)
                        .foregroundStyle(.white)
                        .font(.system(size: 26, weight: .bold))

                    HStack(spacing: 12) {
                        if let date = detail.releaseDate {
                            Text(date.prefix(4))
                                .foregroundStyle(Color(hex: "A3A3A3"))
                                .font(.system(size: 13))
                        }
                        if !detail.durationText.isEmpty {
                            Text("•")
                                .foregroundStyle(Color(hex: "525252"))
                            Text(detail.durationText)
                                .foregroundStyle(Color(hex: "A3A3A3"))
                                .font(.system(size: 13))
                        }
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                                .font(.system(size: 11))
                            Text(String(format: "%.1f", detail.voteAverage))
                                .foregroundStyle(.white)
                                .font(.system(size: 13, weight: .medium))
                        }
                    }

                    if !detail.genreText.isEmpty {
                        Text(detail.genreText)
                            .foregroundStyle(Color(hex: "737373"))
                            .font(.system(size: 13))
                    }
                }

                // Overview
                if !detail.overview.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        SectionHeader(title: "Storyline")
                        Text(detail.overview)
                            .foregroundStyle(Color(hex: "A3A3A3"))
                            .font(.system(size: 14))
                            .lineSpacing(4)
                    }
                }

                // Cast
                castSection

                // Similar Movies
                if let similar = detail.similar, !similar.results.isEmpty {
                    similarSection(movies: similar.results)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, -40)
            .padding(.bottom, 40)

        case .error(let msg):
            Text(msg)
                .foregroundStyle(.red.opacity(0.8))
                .padding(24)

        case .empty:
            EmptyView()
        }
    }

    // MARK: - Cast

    @ViewBuilder
    private var castSection: some View {
        switch viewModel.castsState {
        case .loaded(let cast) where !cast.isEmpty:
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Cast")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(cast.prefix(10)) { member in
                            CastMemberView(cast: member)
                        }
                    }
                    .padding(.horizontal, 2)
                }
            }
        default:
            EmptyView()
        }
    }

    // MARK: - Similar Movies

    private func similarSection(movies: [Movie]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "More Like This")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(movies.prefix(10)) { movie in
                        SimilarMovieCard(movie: movie)
                            .onTapGesture {
                                navigator.navigate(to: MovieDestination.movieDetail(movieId: movie.id))
                            }
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }
}

// MARK: - Supporting Views

private struct CastMemberView: View {
    let cast: Cast
    var body: some View {
        VStack(spacing: 6) {
            RemoteImageView(url: cast.profileURL)
                .frame(width: 64, height: 64)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 1))

            Text(cast.name)
                .foregroundStyle(.white)
                .font(.system(size: 11, weight: .medium))
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 64)

            Text(cast.character)
                .foregroundStyle(Color(hex: "737373"))
                .font(.system(size: 10))
                .lineLimit(1)
                .frame(width: 64)
        }
    }
}

private struct SimilarMovieCard: View {
    let movie: Movie
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            RemoteImageView(url: movie.posterURL)
                .frame(width: 110, height: 160)
                .cornerRadius(8)
                .clipped()
            Text(movie.title)
                .foregroundStyle(.white)
                .font(.system(size: 12, weight: .medium))
                .lineLimit(2, reservesSpace: true)
                .frame(width: 110, alignment: .leading)
        }
    }
}

private struct MovieDetailSkeletonView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            RoundedRectangle(cornerRadius: 6).fill(Color(.secondarySystemFill)).frame(height: 28)
            RoundedRectangle(cornerRadius: 6).fill(Color(.secondarySystemFill)).frame(width: 160, height: 16)
            RoundedRectangle(cornerRadius: 6).fill(Color(.secondarySystemFill)).frame(height: 80)
        }
        .padding(.horizontal, 16)
        .shimmer()
    }
}

// MARK: - Preference Key

private struct ScrollOffsetKey: PreferenceKey {
    nonisolated(unsafe) static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#if DEBUG
#Preview {
    Container.shared.setupMovieMocks()
    MovieDetailView(movieId: 1)
}
#endif
