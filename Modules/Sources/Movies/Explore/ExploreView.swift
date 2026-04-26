import FactoryKit
import SwiftUI
import NavigatorUI
import Runes
import Shared

public struct ExploreView: View {

    @State private var viewModel       = ExploreViewModel()
    @State private var searchViewModel = SearchViewModel()
    @FocusState private var isSearchFocused: Bool
    @Environment(\.navigator) private var navigator

    public init() {}

    private var isSearching: Bool {
        isSearchFocused || !searchViewModel.searchQuery.isEmpty
    }

    public var body: some View {
        ZStack(alignment: .top) {
            Color(hex: "0A0A0A").ignoresSafeArea()

            if isSearching {
                searchResultsContent
            } else {
                exploreScrollContent
            }

            searchBar
        }
        .task { await viewModel.loadData() }
        .animation(.easeInOut(duration: 0.2), value: isSearching)
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
                TextField("Search movies...", text: $searchViewModel.searchQuery)
                    .foregroundStyle(.white)
                    .tint(.white)
                    .submitLabel(.search)
                    .focused($isSearchFocused)
                    .onChange(of: searchViewModel.searchQuery) { _, query in
                        searchViewModel.onQueryChanged(query)
                    }
                if !searchViewModel.searchQuery.isEmpty {
                    Button {
                        searchViewModel.searchQuery = ""
                        searchViewModel.onQueryChanged("")
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)
                    }
                }
            }
            .padding(12)
            .background(Color.white.opacity(0.08))
            .cornerRadius(12)

            if isSearching {
                Button("Cancel") {
                    searchViewModel.searchQuery = ""
                    searchViewModel.onQueryChanged("")
                    isSearchFocused = false
                }
                .foregroundStyle(.white)
                .font(.system(size: 15))
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(hex: "0A0A0A"))
    }

    // MARK: - Explore Content

    private var exploreScrollContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                Color.clear.frame(height: 60)

                if !viewModel.genres.isEmpty {
                    genresSection
                }

                if !viewModel.collections.isEmpty {
                    collectionsSection
                }

                if !viewModel.arrivals.isEmpty {
                    arrivalsSection
                }
            }
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
    }

    // MARK: - Search Results

    @ViewBuilder
    private var searchResultsContent: some View {
        VStack(spacing: 0) {
            Color.clear.frame(height: 60)
            Divider().background(Color.white.opacity(0.1))

            switch searchViewModel.searchResults {
            case .initial:
                Spacer()
                Text("Search for a movie")
                    .foregroundStyle(Color(hex: "737373"))
                    .font(.system(size: 16))
                Spacer()

            case .loading:
                Spacer()
                ProgressView().tint(.white)
                Spacer()

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
                Spacer()
                Text(message)
                    .foregroundStyle(Color(hex: "737373"))
                    .font(.system(size: 15))
                Spacer()

            case .error(let message):
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

    // MARK: - Genres

    private var genresSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionTitle(title: "Genres")

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(viewModel.genres) { genre in
                    ExploreGenreCard(genre: genre)
                        .onTapGesture { navigate(to: genre) }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Collections

    private var collectionsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionTitle(title: "Collections")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.collections) { collection in
                        ExploreCollectionCard(collection: collection)
                            .onTapGesture {
                                navigator.navigate(to: MovieDestination.movieDetail(movieId: Int(collection.id) ?? 0))
                            }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    // MARK: - Arrivals

    private var arrivalsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionTitle(title: "New Arrivals")

            VStack(spacing: 0) {
                ForEach(viewModel.arrivals) { arrival in
                    ExploreArrivalRow(arrival: arrival)
                        .onTapGesture {
                            navigator.navigate(to: MovieDestination.movieDetail(movieId: Int(arrival.id) ?? 0))
                        }
                    Divider().background(Color.white.opacity(0.07))
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Navigation Helper

    private func navigate(to genre: ExploreGenre) {
        guard let genreId = Int(genre.id) else { return }
        let allGenres = viewModel.allGenres.compactMap { g -> Genre? in
            guard let id = Int(g.id) else { return nil }
            return Genre(id: id, name: g.name)
        }
        navigator.navigate(to: MovieDestination.movieList(
            title:          genre.name,
            sectionTypeRaw: HomeSection.categories.rawValue,
            genreId:        genreId,
            genreName:      genre.name,
            allGenres:      allGenres
        ))
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

// MARK: - Supporting Views

private struct SectionTitle: View {
    let title: String
    var body: some View {
        Text(title)
            .foregroundStyle(.white)
            .font(.system(size: 20, weight: .bold))
            .padding(.horizontal, 16)
    }
}

private struct ExploreGenreCard: View {
    let genre: ExploreGenre
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: genre.colorHex).opacity(0.2))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: genre.colorHex).opacity(0.3), lineWidth: 1))
            Text(genre.name)
                .foregroundStyle(.white)
                .font(.system(size: 14, weight: .semibold))
                .padding(.vertical, 22)
        }
    }
}

private struct ExploreCollectionCard: View {
    let collection: ExploreCollection
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RemoteImageView(url: URL(string: collection.imageURL))
                .frame(width: 220, height: 130)
                .cornerRadius(10)
                .clipped()

            LinearGradient(colors: [.clear, .black.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                .frame(width: 220, height: 130)
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 2) {
                Text(collection.topic)
                    .foregroundStyle(Color(hex: "A3A3A3"))
                    .font(.system(size: 10, weight: .medium))
                Text(collection.title)
                    .foregroundStyle(.white)
                    .font(.system(size: 13, weight: .semibold))
                    .lineLimit(1)
            }
            .padding(10)
        }
        .frame(width: 220)
    }
}

private struct ExploreArrivalRow: View {
    let arrival: ExploreArrival
    var body: some View {
        HStack(spacing: 12) {
            RemoteImageView(url: URL(string: arrival.imageURL))
                .frame(width: 80, height: 50)
                .cornerRadius(6)
                .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(arrival.title)
                    .foregroundStyle(.white)
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(1)
                Text(arrival.subtitle)
                    .foregroundStyle(Color(hex: "737373"))
                    .font(.system(size: 12))
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(Color(hex: "525252"))
                .font(.system(size: 12))
        }
        .padding(.vertical, 10)
        .contentShape(Rectangle())
    }
}

#if DEBUG
#Preview {
    Container.shared.setupMovieMocks()
    ExploreView()
}
#endif
