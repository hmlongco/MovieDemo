import Foundation
import FactoryKit
import Runes
import Shared

@Observable
@MainActor
final class HomeTopRatedViewModel {

    var state: LoadableState<[Movie]> = .initial

    @ObservationIgnored
    @Injected(\.movieRepository) private var service

    func load() async {
        state = .loading
        do {
            let result = try await service.getTopRatedMovies(page: 1)
            state = .loaded(result.results)
        } catch {
            state = .loaded([])
        }
    }
}
