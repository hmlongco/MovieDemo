import Foundation
import FactoryMacros
import Runes
import Shared

@Dependency(\.movieRepository)
@MainActor @Observable final class HomePopularViewModel {

    var state: LoadableState<[Movie]> = .initial

    func load() async {
        state = .loading
        do {
            let result = try await movieRepository.getPopularMovies(page: 1)
            state = .loaded(result.results)
        } catch {
            state = .loaded([])
        }
    }
}
