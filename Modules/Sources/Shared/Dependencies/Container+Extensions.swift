import FactoryKit
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
}

#if DEBUG
extension Container {
    @discardableResult
    public func setupMovieMocks() -> some View{
        movieClient().mock(TMDBEndpoint.getPopularMovies(page: 1), value: MovieResponse.mock1)
        movieClient().mock(TMDBEndpoint.getTopRated(page: 1), value: MovieResponse.mock1)
        movieClient().mock(TMDBEndpoint.getNowPlaying(page: 1), value: MovieResponse.mock1)
        movieClient().mock(TMDBEndpoint.getMovieDetails(id: 1), value: MovieDetail.mock1)
        movieClient().mock(TMDBEndpoint.getMovieCredits(id: 1), value: CreditsResponse.mock1)
        movieClient().mock(TMDBEndpoint.getGenres, value: GenreResponse.mock1)
        movieClient().mock(TMDBEndpoint.discover(page: 1, genreId: nil), value: MovieResponse.mock1)
        movieClient().mock(TMDBEndpoint.search(query: "", page: 1), value: MovieResponse.mock1)
        return EmptyView()
    }
}
#endif
