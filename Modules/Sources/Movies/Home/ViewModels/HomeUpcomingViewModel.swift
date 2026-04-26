import Foundation
import FactoryKit
import Runes
import Shared

@Observable
@MainActor
final class HomeUpcomingViewModel {

    var state: LoadableState<[Movie]> = .initial

    @ObservationIgnored
    @Injected(\.movieRepository) private var service

    func load() async {
        state = .loading
        do {
            let result = try await service.getPopularMovies(page: 2)
            state = .loaded(result.results)
        } catch {
            state = .loaded([])
        }
    }
}
