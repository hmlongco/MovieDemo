import FactoryKit
import NavigatorUI
import Runes
import Shared
import SwiftData
import SwiftUI

struct MovieDetailView: View {

    let movieId: Int
    @State private var viewModel = MovieDetailViewModel()
    @Environment(\.navigator) private var navigator
    @Environment(\.sceneGeometry) private var geo

    private let heroHeight: CGFloat = 520

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                switch viewModel.detailState {
                case .loaded(let detail):
                    VStack(spacing: 0) {
                        HeroCard(movie: detail, width: geo.size.width, height: heroHeight)
                        detailContent
                    }

                default:
                    MovieDetailSkeletonView()
                        .shimmer()
                }
            }
            .padding(.bottom, 100)
        }
        .background(Color(hex: "0A0A0A").ignoresSafeArea())
        .scrollIndicators(.hidden)
        .ignoresSafeArea(edges: .top)
        .ignoresSafeArea(edges: .horizontal)
        .task {
            await viewModel.load(movieId: movieId)
        }
    }

    // MARK: - Hero Image

    private var heroImage: some View {
        RemoteImageView(url: viewModel.detailState.value?.backdropURL ?? viewModel.detailState.value?.posterURL)
            .frame(width: geo.size.width, height: heroHeight)
            .clipped()
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
                    if !detail.genreText.isEmpty {
                        Text(detail.genreText)
                            .foregroundStyle(Color(hex: "737373"))
                            .font(.system(size: 13))
                    }
                }

                // Overview
                if !detail.overview.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        SectionHeader("Storyline")
                        ExpandableText(detail.overview)
                            .padding(.leading, geo.safeAreaInsets.leading)
                            .padding(.trailing, geo.safeAreaInsets.trailing)
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
        let director = viewModel.detailState.value?.director
        switch viewModel.castsState {
        case .loaded(let cast) where !cast.isEmpty || director != nil:
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader("Cast/Credits")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                         ForEach(cast.prefix(10)) { member in
                            Button {
                                navigator.navigate(to: MovieDestination.personDetail(personId: member.id))
                            } label: {
                                CastMemberView(name: member.name, role: member.character, profileURL: member.profileURL)
                            }
                            .buttonStyle(.plain)
                        }
                        if let director {
                            Button {
                                navigator.navigate(to: MovieDestination.personDetail(personId: director.id))
                            } label: {
                                CastMemberView(name: director.name, role: director.job, profileURL: director.profileURL)
                            }
                            .buttonStyle(.plain)
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
            SectionHeader("More Like This")
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
    let name: String
    let role: String
    let profileURL: URL?
    var body: some View {
        VStack(spacing: 6) {
            RemoteImageView(url: profileURL)
                .frame(width: 64, height: 64)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 1))

            Text(name)
                .foregroundStyle(.white)
                .font(.system(size: 11, weight: .medium))
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 64)

            Text(role)
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

#if DEBUG
#Preview {
    Container.shared.setupMovieMocks()
    Container.shared.setupRatingMocks()
    MovieDetailView(movieId: 1)
        .modelContainer(for: MovieRating.self, inMemory: true)
}
#endif
