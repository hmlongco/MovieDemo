import Foundation
import FactoryMacros
import Runes
import Shared

@Dependency(\.movieRepository)
@MainActor @Observable final class HomeUpcomingViewModel {

    var state: LoadableState<[Movie]> = .initial

    func load() async {
        state = .loading
        do {
            let result = try await movieRepository.getPopularMovies(page: 2)
            state = .loaded(result.results)
        } catch {
            state = .loaded([])
        }
    }
}
