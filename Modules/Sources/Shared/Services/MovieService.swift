import Foundation

@MainActor
public class MovieService: MovieServices {
    private let client: NetworkClient
    
    public init(client: NetworkClient = .init(
        configuration: NetworkConfiguration(baseURL: TMDBConfiguration.baseURL),
        interceptors: [TMDBRequestInterceptor(), LoggerInterceptor()])
    ) {
        self.client = client
    }
    
    public func getPopularMovies(page: Int = 1) async throws -> MovieResponse {
        return try await client.request(MoviesEndpoint.getPopularMovies(page: page))
    }
    
    public func getTopRatedMovies(page: Int = 1) async throws -> MovieResponse {
        return try await client.request(MoviesEndpoint.getTopRated(page: page))
    }
    
    public func getNowPlayingMovies(page: Int = 1) async throws -> MovieResponse {
        return try await client.request(MoviesEndpoint.getNowPlaying(page: page))
    }
    
    public func getMovieDetails(id: Int) async throws -> MovieDetail {
        return try await client.request(MoviesEndpoint.getMovieDetails(id: id))
    }
    
    public func getMovieCredits(id: Int) async throws -> CreditsResponse {
        return try await client.request(MoviesEndpoint.getMovieCredits(id: id))
    }
    
    public func getGenres() async throws -> GenreResponse {
        return try await client.request(MoviesEndpoint.getGenres)
    }
    
    public func discoverMovies(page: Int, genreId: Int?) async throws -> MovieResponse {
        return try await client.request(MoviesEndpoint.discover(page: page, genreId: genreId))
    }
    
    public func searchMovies(query: String, page: Int = 1) async throws -> MovieResponse {
        return try await client.request(MoviesEndpoint.search(query: query, page: page))
    }
}
