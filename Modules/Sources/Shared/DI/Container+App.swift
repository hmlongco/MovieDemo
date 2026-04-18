import FactoryKit

extension Container {

    public var movieClient: Factory<NetworkClient> {
        self {
            NetworkClient(
                configuration: NetworkConfiguration(baseURL: TMDBConfiguration.baseURL),
                interceptors: [
                    TMDBRequestInterceptor(),
                    LoggerInterceptor()
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
