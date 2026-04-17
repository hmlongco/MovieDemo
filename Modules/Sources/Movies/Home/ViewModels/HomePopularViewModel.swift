import Foundation
import FactoryKit
import Runes
import Shared

@Observable
@MainActor
final class HomePopularViewModel {

    var state: LoadableState<[Movie]> = .initial

    @ObservationIgnored
    @Injected(\.movieRepository) private var service

    func load() {
        state = .loading
        Task {
            do {
                let result = try await service.getPopularMovies(page: 1)
                state = .loaded(result.results)
            } catch {
                state = .loaded([])
            }
        }
    }
}
