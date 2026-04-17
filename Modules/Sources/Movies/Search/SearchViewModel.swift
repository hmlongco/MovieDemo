import Foundation
import FactoryKit
import Runes
import Shared

@Observable
@MainActor
final class SearchViewModel {

    var searchQuery:   String                  = ""
    var searchResults: LoadableState<[Movie]>  = .initial

    var isLoading: Bool {
        if case .loading = searchResults { return true }
        return false
    }

    var isEmpty: Bool {
        !isLoading && searchResults.value?.isEmpty == true && !searchQuery.isEmpty
    }

    var isInitial: Bool {
        if case .initial = searchResults { return true }
        return false
    }

    @ObservationIgnored
    @Injected(\.movieRepository) private var service

    @ObservationIgnored
    private var searchTask: Task<Void, Never>?

    func onQueryChanged(_ query: String) {
        searchTask?.cancel()
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            searchResults = .initial
            return
        }
        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(500))
            guard !Task.isCancelled else { return }
            await performSearch(query: trimmed)
        }
    }

    private func performSearch(query: String) async {
        searchResults = .loading
        do {
            try? await Task.sleep(for: .seconds(1))
            let result = try await service.searchMovies(query: query, page: 1)
            searchResults = result.results.isEmpty ? .empty("No results for \"\(query)\"") : .loaded(result.results)
        } catch {
            searchResults = .error(error.localizedDescription)
        }
    }
}
