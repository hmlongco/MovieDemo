import Foundation
import FactoryMacros
import Runes
import Shared

@Dependency(\.movieRepository)
@MainActor @Observable final class HomeGenresViewModel {

    var state: LoadableState<[Genre]> = .initial

    var currentGenres: [Genre] { state.value ?? [] }

    func load() async {
        state = .loading
        do {
            let result = try await movieRepository.getGenres()
            state = .loaded(result.genres)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
