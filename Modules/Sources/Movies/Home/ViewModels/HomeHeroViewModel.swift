import Foundation
import FactoryKit
import Runes
import Shared

@Observable
@MainActor
final class HomeHeroViewModel {

    static let maxPages = 5

    var state: LoadableState<[Movie]> = .initial
    var selectedIndex = 0

    @ObservationIgnored
    @Injected(\.movieRepository) private var service

    private var pageCount: Int { min(state.value?.count ?? 0, Self.maxPages) }

    var canNavigate: Bool { pageCount > 1 }

    func showPrevious() {
        guard canNavigate else { return }
        selectedIndex = (selectedIndex - 1 + pageCount) % pageCount
    }

    func showNext() {
        guard canNavigate else { return }
        selectedIndex = (selectedIndex + 1) % pageCount
    }

    func load() async {
        state = .loading
        selectedIndex = 0
        do {
            let result = try await service.getNowPlayingMovies(page: 1)
            state = .loaded(result.results)
        } catch {
            state = .loaded([])
        }
    }
}
