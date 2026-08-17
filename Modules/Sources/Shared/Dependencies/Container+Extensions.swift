import FactoryKit
import SwiftData
import SwiftUI

extension Container {

    @MainActor
    public var authenticationService: Factory<AuthenticationServices> {
        self { AuthenticationService() }
            .singleton
    }

    public var movieApiKey: Factory<String?> {
        promised()
    }

    /// The app's shared SwiftData `ModelContainer`. Must be registered by the composition root
    /// (e.g. `MoviesApp`/`App`'s `AppDependencies.autoRegister()`) before any `@Model`-backed
    /// repository resolves it. `.singleton` so every resolution shares one container/store rather
    /// than each caller creating its own.
    public var modelContainer: Factory<ModelContainer?> {
        promised().singleton
    }

    public var modelContext: Factory<ModelContext> {
        self { ModelContext(self.modelContainer()!) }.singleton
    }

    public var movieClient: Factory<NetworkClient> {
        self {
            StandardNetworkClient(
                configuration: NetworkConfiguration(baseURL: TMDBConfiguration.baseURL),
                interceptors: [
                    TMDBRequestInterceptor(apiKey: self.movieApiKey())
                ]
            )
        }
        .singleton
    }

    @MainActor
    public var movieService: Factory<MovieServices> {
        self { MovieService(client: self.movieClient()) }
            .singleton
    }

    @MainActor
    public var movieRepository: Factory<MovieServices> {
        self { MovieRepository() }
            .singleton
    }

    @MainActor
    public var movieRatingRepository: Factory<MovieRatingRepository> {
        self { MovieRatingRepository() }
            .cached
    }
}

#if DEBUG
extension Container {
    @discardableResult
    public func setupMovieMocks() -> some View {
        movieClient().mock(TMDBEndpoint.getPopularMovies(page: 1), value: MovieResponse.mock1)
        movieClient().mock(TMDBEndpoint.getTopRated(page: 1), value: MovieResponse.mock1)
        movieClient().mock(TMDBEndpoint.getNowPlaying(page: 1), value: MovieResponse.mock1)
        movieClient().mock(TMDBEndpoint.getMovieDetails(id: 1), value: MovieDetail.mock1)
        movieClient().mock(TMDBEndpoint.getMovieCredits(id: 1), value: CreditsResponse.mock1)
        movieClient().mock(TMDBEndpoint.getGenres, value: GenreResponse.mock1)
        movieClient().mock(TMDBEndpoint.discover(page: 1, genreId: nil), value: MovieResponse.mock1)
        movieClient().mock(TMDBEndpoint.search(query: "", page: 1), value: MovieResponse.mock1)
        movieClient().mock(TMDBEndpoint.getPersonDetails(id: 1), value: PersonDetail.mock1)
        movieClient().mock(TMDBEndpoint.getPersonCombinedCredits(id: 1), value: PersonCombinedCredits.mock1)
        return EmptyView()
    }

    @discardableResult
    public func setupMovieErrors(_ error: NetworkError = .serverError(statusCode: 503, data: nil)) -> some View {
        movieClient().mock(TMDBEndpoint.getPopularMovies(page: 1), error: error)
        movieClient().mock(TMDBEndpoint.getTopRated(page: 1), error: error)
        movieClient().mock(TMDBEndpoint.getNowPlaying(page: 1), error: error)
        movieClient().mock(TMDBEndpoint.getMovieDetails(id: 1), error: error)
        movieClient().mock(TMDBEndpoint.getMovieCredits(id: 1), error: error)
        movieClient().mock(TMDBEndpoint.getGenres, error: error)
        movieClient().mock(TMDBEndpoint.discover(page: 1, genreId: nil), error: error)
        movieClient().mock(TMDBEndpoint.search(query: "", page: 1), error: error)
        movieClient().mock(TMDBEndpoint.getPersonDetails(id: 1), error: error)
        movieClient().mock(TMDBEndpoint.getPersonCombinedCredits(id: 1), error: error)
        return EmptyView()
    }

    /// Registers an in-memory `ModelContainer` so previews using `movieRatingRepository`
    /// (or anything else resolving `\.modelContainer`) don't crash on the unregistered promise.
    @discardableResult
    public func setupRatingMocks() -> some View {
        modelContainer.register {
            try? ModelContainer(for: MovieRating.self, configurations: .init(isStoredInMemoryOnly: true))
        }
        return EmptyView()
    }
}
#endif
