
import FactoryKit
import Shared
import Testing
import FactoryTesting

@MainActor
@Suite(.container)
struct SharedSuccessTests {

    init() {
        Container.shared.setupMovieMocks()
    }

    // MARK: - AuthenticationService

    @Test func authServiceHasMockUserOnInit() {
        let service = AuthenticationService()
        #expect(service.isAuthenticated)
        #expect(service.authenticatedUser?.userName == "mlong")
        #expect(service.authenticatedUser?.fullName == "Michael Long")
    }

    @Test func authServiceLogoutClearsUser() async {
        let service = AuthenticationService()
        await service.logout()
        #expect(!service.isAuthenticated)
        #expect(service.authenticatedUser == nil)
    }

    @Test func authServiceLoginRestoresUser() async {
        let service = AuthenticationService()
        await service.logout()
        await service.login()
        #expect(service.isAuthenticated)
        #expect(service.authenticatedUser != nil)
    }

    // MARK: - MovieService

    @Test func movieServiceReturnsPopularMovies() async throws {
        let service = Container.shared.movieService()
        let response = try await service.getPopularMovies(page: 1)
        #expect(response.page == 1)
        #expect(!response.results.isEmpty)
        #expect(response.results.first?.title == "Inception")
    }

    @Test func movieServiceReturnsMovieDetail() async throws {
        let service = Container.shared.movieService()
        let detail = try await service.getMovieDetails(id: 1)
        #expect(detail.title == "Inception")
        #expect(detail.runtime == 148)
    }

    @Test func movieServiceReturnsGenres() async throws {
        let service = Container.shared.movieService()
        let response = try await service.getGenres()
        #expect(!response.genres.isEmpty)
        #expect(response.genres.first?.name == "Action")
    }

    @Test func movieServiceReturnsCredits() async throws {
        let service = Container.shared.movieService()
        let credits = try await service.getMovieCredits(id: 1)
        #expect(!credits.cast.isEmpty)
        #expect(credits.cast.first?.name == "Leonardo DiCaprio")
    }

    // MARK: - MovieRepository Caching

    @Test func repositoryReturnsCachedPopularMovies() async throws {
        let repo = MovieRepository()
        let first  = try await repo.getPopularMovies(page: 1)
        let second = try await repo.getPopularMovies(page: 1)
        #expect(first == second)
    }

    @Test func repositoryReturnsCachedGenres() async throws {
        let repo = MovieRepository()
        let first  = try await repo.getGenres()
        let second = try await repo.getGenres()
        #expect(first == second)
    }

    @Test func repositoryInvalidatesPopularCache() async throws {
        let repo = MovieRepository()
        _ = try await repo.getPopularMovies(page: 1)
        repo.invalidate(.popularMovies())
        let response = try await repo.getPopularMovies(page: 1)
        #expect(!response.results.isEmpty)
    }

    @Test func repositoryInvalidatesAllCaches() async throws {
        let repo = MovieRepository()
        _ = try await repo.getPopularMovies(page: 1)
        _ = try await repo.getTopRatedMovies(page: 1)
        _ = try await repo.getGenres()
        repo.invalidate(.all)
        let movies = try await repo.getPopularMovies(page: 1)
        let genres = try await repo.getGenres()
        #expect(!movies.results.isEmpty)
        #expect(!genres.genres.isEmpty)
    }

}

@MainActor
@Suite(.container)
struct SharedErrorTests {

    init() {
        Container.shared.setupMovieErrors()
    }

    // MARK: - MovieService Error Propagation

    @Test func movieServicePopularMoviesThrows() async {
        let service = Container.shared.movieService()
        await #expect(throws: NetworkError.self) {
            try await service.getPopularMovies(page: 1)
        }
    }

    @Test func movieServiceTopRatedMoviesThrows() async {
        let service = Container.shared.movieService()
        await #expect(throws: NetworkError.self) {
            try await service.getTopRatedMovies(page: 1)
        }
    }

    @Test func movieServiceNowPlayingMoviesThrows() async {
        let service = Container.shared.movieService()
        await #expect(throws: NetworkError.self) {
            try await service.getNowPlayingMovies(page: 1)
        }
    }

    @Test func movieServiceMovieDetailThrows() async {
        let service = Container.shared.movieService()
        await #expect(throws: NetworkError.self) {
            try await service.getMovieDetails(id: 1)
        }
    }

    @Test func movieServiceMovieCreditsThrows() async {
        let service = Container.shared.movieService()
        await #expect(throws: NetworkError.self) {
            try await service.getMovieCredits(id: 1)
        }
    }

    @Test func movieServiceGenresThrows() async {
        let service = Container.shared.movieService()
        await #expect(throws: NetworkError.self) {
            try await service.getGenres()
        }
    }

    @Test func movieServiceDiscoverThrows() async {
        let service = Container.shared.movieService()
        await #expect(throws: NetworkError.self) {
            try await service.discoverMovies(page: 1, genreId: nil)
        }
    }

    @Test func movieServiceSearchThrows() async {
        let service = Container.shared.movieService()
        await #expect(throws: NetworkError.self) {
            try await service.searchMovies(query: "", page: 1)
        }
    }

    // MARK: - MovieRepository Error Propagation

    @Test func repositoryPopularMoviesThrows() async {
        let repo = MovieRepository()
        await #expect(throws: NetworkError.self) {
            try await repo.getPopularMovies(page: 1)
        }
    }

    @Test func repositoryTopRatedMoviesThrows() async {
        let repo = MovieRepository()
        await #expect(throws: NetworkError.self) {
            try await repo.getTopRatedMovies(page: 1)
        }
    }

    @Test func repositoryNowPlayingMoviesThrows() async {
        let repo = MovieRepository()
        await #expect(throws: NetworkError.self) {
            try await repo.getNowPlayingMovies(page: 1)
        }
    }

    @Test func repositoryMovieDetailThrows() async {
        let repo = MovieRepository()
        await #expect(throws: NetworkError.self) {
            try await repo.getMovieDetails(id: 1)
        }
    }

    @Test func repositoryMovieCreditsThrows() async {
        let repo = MovieRepository()
        await #expect(throws: NetworkError.self) {
            try await repo.getMovieCredits(id: 1)
        }
    }

    @Test func repositoryGenresThrows() async {
        let repo = MovieRepository()
        await #expect(throws: NetworkError.self) {
            try await repo.getGenres()
        }
    }

    @Test func repositoryDiscoverThrows() async {
        let repo = MovieRepository()
        await #expect(throws: NetworkError.self) {
            try await repo.discoverMovies(page: 1, genreId: nil)
        }
    }

    @Test func repositorySearchThrows() async {
        let repo = MovieRepository()
        await #expect(throws: NetworkError.self) {
            try await repo.searchMovies(query: "", page: 1)
        }
    }

}
