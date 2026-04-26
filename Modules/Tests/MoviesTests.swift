
import FactoryKit
import Shared
import Testing
import FactoryTesting

@testable import Movies

@MainActor
@Suite(.container)
struct MovieSuccessTests {

    init() {
        Container.shared.setupMovieMocks()
    }

    // MARK: - HomePopularViewModel

    @Test func popularMoviesInitialState() {
        let vm = HomePopularViewModel()
        #expect(vm.state == .initial)
    }

    @Test func popularMoviesLoadsMovies() async throws {
        let vm = HomePopularViewModel()
        await vm.load()
        let movies = try #require(vm.state.value)
        #expect(!movies.isEmpty)
        #expect(movies.first?.title == "Inception")
    }

    // MARK: - MovieDetailViewModel

    @Test func detailViewModelInitialState() {
        let vm = MovieDetailViewModel()
        #expect(vm.detailState == .initial)
        #expect(vm.castsState == .initial)
    }

    @Test func detailViewModelLoadsDetailAndCast() async throws {
        let vm = MovieDetailViewModel()
        await vm.load(movieId: 1)
        let detail = try #require(vm.detailState.value)
        #expect(detail.title == "Inception")
        #expect(detail.runtime == 148)
        let cast = try #require(vm.castsState.value)
        #expect(!cast.isEmpty)
        #expect(cast.first?.name == "Leonardo DiCaprio")
    }

    // MARK: - SearchViewModel

    @Test func searchViewModelInitialState() {
        let vm = SearchViewModel()
        #expect(vm.searchQuery.isEmpty)
        #expect(vm.isInitial)
        #expect(!vm.isLoading)
        #expect(!vm.isEmpty)
    }

    @Test func searchViewModelEmptyQueryResetsState() {
        let vm = SearchViewModel()
        vm.onQueryChanged("")
        #expect(vm.searchResults == .initial)
    }

    @Test func searchViewModelWhitespaceOnlyQueryResetsState() {
        let vm = SearchViewModel()
        vm.onQueryChanged("   ")
        #expect(vm.searchResults == .initial)
    }

    // MARK: - MovieListViewModel

    @Test func movieListFilterItemsIncludeAllOption() {
        let genres = GenreResponse.mock1.genres
        let vm = MovieListViewModel(title: "Popular", sectionType: .popular, genres: genres, selectedGenre: nil)
        let filters = vm.filterItems
        #expect(filters.first?.title == "All")
        #expect(filters.first?.isSelected == true)
        #expect(filters.count == genres.count + 1)
    }

    @Test func movieListGenreSelectionUpdatesFilter() {
        let genres = GenreResponse.mock1.genres
        let vm = MovieListViewModel(title: "Popular", sectionType: .popular, genres: genres, selectedGenre: nil)
        let genre = genres[0]
        vm.selectGenre(genre)
        #expect(vm.selectedGenre == genre)
        #expect(vm.filterItems.first(where: { $0.genre?.id == genre.id })?.isSelected == true)
        #expect(vm.filterItems.first(where: { $0.title == "All" })?.isSelected == false)
    }

    @Test func movieListInitialLoad() async {
        let vm = MovieListViewModel(
            title: "Popular",
            sectionType: .popular,
            genres: GenreResponse.mock1.genres,
            selectedGenre: nil
        )
        await vm.initialLoad()
        #expect(!vm.movies.isEmpty)
        #expect(!vm.isLoading)
        #expect(vm.error == nil)
    }

    // MARK: - ExploreViewModel

    @Test func exploreViewModelLoadsAllSections() async {
        let vm = ExploreViewModel()
        #expect(!vm.isLoading)
        await vm.loadData()
        #expect(!vm.isLoading)
        #expect(!vm.genres.isEmpty)
        #expect(vm.genres.count <= 4)
        #expect(!vm.allGenres.isEmpty)
        #expect(!vm.collections.isEmpty)
        #expect(!vm.arrivals.isEmpty)
    }

}

@MainActor
@Suite(.container)
struct MovieErrorTests {

    init() {
        Container.shared.setupMovieErrors()
    }

    // MARK: - HomePopularViewModel

    @Test func popularMoviesErrorFallsBackToEmpty() async {
        let vm = HomePopularViewModel()
        await vm.load()
        #expect(vm.state == .loaded([]))
    }

    // MARK: - HomeHeroViewModel

    @Test func heroMoviesErrorFallsBackToEmpty() async {
        let vm = HomeHeroViewModel()
        await vm.load()
        #expect(vm.state == .loaded([]))
    }

    // MARK: - HomeTopRatedViewModel

    @Test func topRatedMoviesErrorFallsBackToEmpty() async {
        let vm = HomeTopRatedViewModel()
        await vm.load()
        #expect(vm.state == .loaded([]))
    }

    // MARK: - MovieDetailViewModel

    @Test func detailViewModelSetsErrorState() async {
        let vm = MovieDetailViewModel()
        await vm.load(movieId: 1)
        if case .error = vm.detailState { } else {
            Issue.record("Expected detailState to be .error, got \(vm.detailState)")
        }
        if case .error = vm.castsState { } else {
            Issue.record("Expected castsState to be .error, got \(vm.castsState)")
        }
    }

    // MARK: - MovieListViewModel

    @Test func movieListSetsErrorOnFailure() async {
        let vm = MovieListViewModel(
            title: "Popular",
            sectionType: .popular,
            genres: GenreResponse.mock1.genres,
            selectedGenre: nil
        )
        await vm.initialLoad()
        #expect(vm.error != nil)
        #expect(vm.movies.isEmpty)
        #expect(!vm.isLoading)
    }

    // MARK: - ExploreViewModel

    @Test func exploreViewModelSilentlyHandlesErrors() async {
        let vm = ExploreViewModel()
        await vm.loadData()
        #expect(!vm.isLoading)
        #expect(vm.genres.isEmpty)
        #expect(vm.allGenres.isEmpty)
        #expect(vm.collections.isEmpty)
        #expect(vm.arrivals.isEmpty)
    }

}
