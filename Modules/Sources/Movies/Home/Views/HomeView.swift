import FactoryKit
import SwiftUI
import NavigatorUI
import Runes
import Shared

public struct HomeView: View {

    @Environment(\.navigator) private var navigator

    @State private var refreshID:    Int     = 0
    @State private var allGenres:    [Genre] = []

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                HomeHeroSection(refreshID: refreshID) { movie in
                    navigateToDetail(movie: movie)
                }
                HomeGenresSection(
                    refreshID: refreshID,
                    onGenreTap: { navigateToList(section: .categories, genre: $0) },
                    onGenresLoaded: { allGenres = $0 }
                )
                HomePopularSection(
                    refreshID: refreshID,
                    onSeeAll: { navigateToList(section: .popular) },
                    onMovieTap: { navigateToDetail(movie: $0) }
                )
                HomeUpcomingSection(
                    refreshID: refreshID,
                    onSeeAll: { navigateToList(section: .upcoming) },
                    onMovieTap: { navigateToDetail(movie: $0) }
                )
                HomeTopRatedSection(refreshID: refreshID) { movie in
                    navigateToDetail(movie: movie)
                }
            }
            .padding(.bottom, 100)
        }
        .background(Color(hex: "0A0A0A").ignoresSafeArea())
        .scrollIndicators(.hidden)
        .ignoresSafeArea(edges: .top)
        .refreshable { refreshID += 1 }
    }

    // MARK: - Navigation

    private func navigateToDetail(movie: Movie) {
        navigator.navigate(to: MovieDestination.movieDetail(movieId: movie.id))
    }

    private func navigateToList(section: HomeSection, genre: Genre? = nil) {
        let title: String
        switch section {
        case .popular:    title = "Popular Movies"
        case .upcoming:   title = "Upcoming Movies"
        case .topRated:   title = "Top Rated Movies"
        case .categories: title = genre?.name ?? "Genre"
        case .hero:       title = "Movies"
        }
        navigator.navigate(to: MovieDestination.movieList(
            title:          title,
            sectionTypeRaw: section.rawValue,
            genreId:        genre?.id,
            genreName:      genre?.name,
            allGenres:      allGenres
        ))
    }
}

#if DEBUG
#Preview {
    Container.shared.setupMovieMocks()
    HomeView()
}
#endif
