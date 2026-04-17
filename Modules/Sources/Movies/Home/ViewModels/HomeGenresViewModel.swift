import Foundation
import FactoryKit
import Runes
import Shared

@Observable
@MainActor
final class HomeGenresViewModel {

    var state: LoadableState<[Genre]> = .initial

    var currentGenres: [Genre] { state.value ?? [] }

    @ObservationIgnored
    @Injected(\.movieRepository) private var service

    func load() {
        state = .loading
        Task {
            do {
                let result = try await service.getGenres()
                state = .loaded(result.genres)
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
}
