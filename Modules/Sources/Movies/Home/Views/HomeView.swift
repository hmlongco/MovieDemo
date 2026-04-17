import SwiftUI
import NavigatorUI
import Runes
import Shared

public struct HomeView: View {

    @Environment(\.navigator)       private var navigator
//    @Environment(AppNavigator.self) private var appNav

    @State private var scrollOffset: CGFloat = 0
    @State private var refreshID:    Int     = 0
    @State private var allGenres:    [Genre] = []

    public init() {}

    public var body: some View {
        ScrollView {
            GeometryReader { geo in
                let offset = geo.frame(in: .named("homeScroll")).minY
                Color.clear
                    .preference(key: HomeScrollOffsetKey.self, value: offset)
                    .frame(height: 0)
            }
            .frame(height: 0)

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
        .coordinateSpace(name: "homeScroll")
        .onPreferenceChange(HomeScrollOffsetKey.self) { scrollOffset = $0 }
        .scrollIndicators(.hidden)
        .refreshable { refreshID += 1 }
        .background(Color(hex: "0A0A0A").ignoresSafeArea())
        .ignoresSafeArea(edges: .top)
//        .toolbar { homeNavBar }
    }

    // MARK: - Navigation Bar

//    private var homeNavBar: some ToolbarContent {
//        ToolbarItem(placement: .topBarTrailing) {
//            Button {
//                appNav.selectedTab = .explore
//            } label: {
//                Image(systemName: "magnifyingglass")
//                    .foregroundStyle(.white)
//                    .font(.system(size: 18))
//            }
//        }
//    }

    // MARK: - Navigation

    private func navigateToDetail(movie: Movie) {
        navigator.navigate(to: MovieDestination.movieDetail(movieId: String(movie.id)))
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

// MARK: - Preference Key

private struct HomeScrollOffsetKey: PreferenceKey {
    nonisolated(unsafe) static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
