import Foundation
import FactoryKit

@MainActor
public final class MovieRepository: MovieServices {

    // MARK: - Cache Key

    public enum CacheKey {
        case popularMovies(page: Int? = nil)
        case topRatedMovies(page: Int? = nil)
        case nowPlayingMovies(page: Int? = nil)
        case discoverMovies(page: Int? = nil, genreId: Int? = nil)
        case movieDetail(id: Int)
        case movieCredits(id: Int)
        case genres
        case all
    }

    // MARK: - Cache Storage

    private var popularCache:    [Int: MovieResponse]    = [:]
    private var topRatedCache:   [Int: MovieResponse]    = [:]
    private var nowPlayingCache: [Int: MovieResponse]    = [:]
    private var discoverCache:   [String: MovieResponse] = [:]
    private var detailCache:     [Int: MovieDetail]      = [:]
    private var creditsCache:    [Int: CreditsResponse]  = [:]
    private var genresCache:     GenreResponse?          = nil

    // MARK: - Dependencies

    @Injected(\.movieService) private var service

    // MARK: - Lifecycle

    public init() {}

    // MARK: - MovieServiceProtocol

    public func getPopularMovies(page: Int) async throws -> MovieResponse {
        if let cached = popularCache[page] { return cached }
        let result = try await service.getPopularMovies(page: page)
        popularCache[page] = result
        return result
    }

    public func getTopRatedMovies(page: Int) async throws -> MovieResponse {
        if let cached = topRatedCache[page] { return cached }
        let result = try await service.getTopRatedMovies(page: page)
        topRatedCache[page] = result
        return result
    }

    public func getNowPlayingMovies(page: Int) async throws -> MovieResponse {
        if let cached = nowPlayingCache[page] { return cached }
        let result = try await service.getNowPlayingMovies(page: page)
        nowPlayingCache[page] = result
        return result
    }

    public func getMovieDetails(id: Int) async throws -> MovieDetail {
        if let cached = detailCache[id] { return cached }
        let result = try await service.getMovieDetails(id: id)
        detailCache[id] = result
        return result
    }

    public func getMovieCredits(id: Int) async throws -> CreditsResponse {
        if let cached = creditsCache[id] { return cached }
        let result = try await service.getMovieCredits(id: id)
        creditsCache[id] = result
        return result
    }

    public func getGenres() async throws -> GenreResponse {
        if let cached = genresCache { return cached }
        let result = try await service.getGenres()
        genresCache = result
        return result
    }

    public func discoverMovies(page: Int, genreId: Int?) async throws -> MovieResponse {
        let key = "\(page)_\(genreId ?? 0)"
        if let cached = discoverCache[key] { return cached }
        let result = try await service.discoverMovies(page: page, genreId: genreId)
        discoverCache[key] = result
        return result
    }

    public func searchMovies(query: String, page: Int) async throws -> MovieResponse {
        try await service.searchMovies(query: query, page: page)
    }

    // MARK: - Cache Invalidation

    public func invalidate(_ key: CacheKey) {
        switch key {
        case .popularMovies(let page):
            if let page { popularCache.removeValue(forKey: page) }
            else { popularCache.removeAll() }

        case .topRatedMovies(let page):
            if let page { topRatedCache.removeValue(forKey: page) }
            else { topRatedCache.removeAll() }

        case .nowPlayingMovies(let page):
            if let page { nowPlayingCache.removeValue(forKey: page) }
            else { nowPlayingCache.removeAll() }

        case .discoverMovies(let page, let genreId):
            switch (page, genreId) {
            case (let p?, let g?): discoverCache.removeValue(forKey: "\(p)_\(g)")
            case (let p?, nil):    discoverCache = discoverCache.filter { !$0.key.hasPrefix("\(p)_") }
            case (nil, let g?):    discoverCache = discoverCache.filter { !$0.key.hasSuffix("_\(g)") }
            case (nil, nil):       discoverCache.removeAll()
            }

        case .movieDetail(let id):
            detailCache.removeValue(forKey: id)

        case .movieCredits(let id):
            creditsCache.removeValue(forKey: id)

        case .genres:
            genresCache = nil

        case .all:
            popularCache.removeAll()
            topRatedCache.removeAll()
            nowPlayingCache.removeAll()
            discoverCache.removeAll()
            detailCache.removeAll()
            creditsCache.removeAll()
            genresCache = nil
        }
    }
}
