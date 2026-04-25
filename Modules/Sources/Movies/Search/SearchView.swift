import FactoryKit
import SwiftUI
import NavigatorUI
import Runes
import Shared

struct SearchView: View {

    @State private var viewModel = SearchViewModel()
    @Environment(\.navigator) private var navigator

    var body: some View {
        VStack(spacing: 0) {
            searchBar
            Divider().background(Color.white.opacity(0.1))
            resultsArea
        }
        .background(Color(hex: "0A0A0A"))
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)
            TextField("Search movies...", text: $viewModel.searchQuery)
                .foregroundStyle(.white)
                .tint(.white)
                .submitLabel(.search)
                .onChange(of: viewModel.searchQuery) { _, query in
                    viewModel.onQueryChanged(query)
                }
            if !viewModel.searchQuery.isEmpty {
                Button {
                    viewModel.searchQuery = ""
                    viewModel.onQueryChanged("")
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.08))
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Results

    @ViewBuilder
    private var resultsArea: some View {
        switch viewModel.searchResults {
        case .initial:
            VStack {
                Spacer()
                Text("Search for a movie")
                    .foregroundStyle(Color(hex: "737373"))
                    .font(.system(size: 16))
                Spacer()
            }

        case .loading:
            VStack {
                Spacer()
                ProgressView().tint(.white)
                Spacer()
            }

        case .loaded(let movies):
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(movies) { movie in
                        SearchResultRow(movie: movie)
                            .onTapGesture {
                                navigator.navigate(to: MovieDestination.movieDetail(movieId: movie.id))
                            }
                        Divider().background(Color.white.opacity(0.07))
                    }
                }
            }
            .scrollIndicators(.hidden)

        case .empty(let message):
            VStack {
                Spacer()
                Text(message)
                    .foregroundStyle(Color(hex: "737373"))
                    .font(.system(size: 15))
                Spacer()
            }

        case .error(let message):
            VStack {
                Spacer()
                Text(message)
                    .foregroundStyle(.red.opacity(0.8))
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                Spacer()
            }
        }
    }
}

// MARK: - Search Result Row

private struct SearchResultRow: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: 12) {
            RemoteImageView(url: movie.posterURL)
                .frame(width: 50, height: 75)
                .cornerRadius(6)
                .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .foregroundStyle(.white)
                    .font(.system(size: 15, weight: .medium))
                    .lineLimit(2)

                if let date = movie.releaseDate {
                    Text(date.prefix(4))
                        .foregroundStyle(Color(hex: "737373"))
                        .font(.system(size: 13))
                }

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                        .font(.system(size: 11))
                    Text(String(format: "%.1f", movie.voteAverage))
                        .foregroundStyle(Color(hex: "A3A3A3"))
                        .font(.system(size: 13))
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(Color(hex: "525252"))
                .font(.system(size: 13))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

#if DEBUG
#Preview {
    Container.shared.setupMovieMocks()
    SearchView()
}
#endif
