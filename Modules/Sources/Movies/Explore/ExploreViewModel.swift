import Foundation
import FactoryKit

public struct ExploreGenre: Hashable, Identifiable {
    public let id: String
    public let name: String
    public let colorHex: String
}

public struct ExploreCollection: Hashable, Identifiable {
    public let id: String
    public let topic: String
    public let title: String
    public let imageURL: String
}

public struct ExploreArrival: Hashable, Identifiable {
    public let id: String
    public let title: String
    public let subtitle: String
    public let imageURL: String
}

@Observable
@MainActor
final class ExploreViewModel {

    var genres:      [ExploreGenre]      = []
    var allGenres:   [ExploreGenre]      = []
    var collections: [ExploreCollection] = []
    var arrivals:    [ExploreArrival]    = []
    var isLoading:   Bool                = false

    @ObservationIgnored
    @Injected(\.movieRepository) private var service

    func loadData() async {
        isLoading = true
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchGenres() }
            group.addTask { await self.fetchCollections() }
            group.addTask { await self.fetchArrivals() }
        }
        isLoading = false
    }

    private func fetchGenres() async {
        let colors = ["#FF3B30", "#5AC8FA", "#FF9500", "#AF52DE"]
        do {
            let response = try await service.getGenres()
            allGenres = response.genres.enumerated().map { index, genre in
                ExploreGenre(
                    id: String(genre.id),
                    name: genre.name,
                    colorHex: colors[index % colors.count]
                )
            }
            genres = Array(allGenres.prefix(4))
        } catch {
            print("Failed to fetch genres: \(error)")
        }
    }

    private func fetchCollections() async {
        do {
            let popular = try await service.getPopularMovies(page: 1)
            collections = popular.results.prefix(5).map { movie in
                ExploreCollection(
                    id: String(movie.id),
                    topic: "TRENDING",
                    title: movie.title,
                    imageURL: movie.backdropURL?.absoluteString ?? ""
                )
            }
        } catch {
            print("Failed to fetch collections: \(error)")
        }
    }

    private func fetchArrivals() async {
        do {
            let nowPlaying = try await service.getNowPlayingMovies(page: 1)
            arrivals = nowPlaying.results.prefix(10).map { movie in
                ExploreArrival(
                    id: String(movie.id),
                    title: movie.title,
                    subtitle: "Score: \(String(format: "%.1f", movie.voteAverage)) • \(movie.releaseDate ?? "Recently Added")",
                    imageURL: movie.backdropURL?.absoluteString ?? ""
                )
            }
        } catch {
            print("Failed to fetch arrivals: \(error)")
        }
    }
}
