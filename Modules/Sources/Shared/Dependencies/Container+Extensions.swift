import FactoryKit

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
