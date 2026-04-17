import Foundation
import FactoryKit
import Runes
import Shared

@Observable
@MainActor
final class MovieDetailViewModel {

    var detailState: LoadableState<MovieDetail> = .initial
    var castsState:  LoadableState<[Cast]>      = .initial

    @ObservationIgnored
    @Injected(\.movieRepository) private var service

    func load(movieId: Int) {
        detailState = .loading
        castsState  = .loading
        Task {
            async let detailTask  = service.getMovieDetails(id: movieId)
            async let creditsTask = service.getMovieCredits(id: movieId)
            do {
                let (detail, credits) = try await (detailTask, creditsTask)
                detailState = .loaded(detail)
                castsState  = .loaded(credits.cast)
            } catch {
                detailState = .error(error.localizedDescription)
                castsState  = .error(error.localizedDescription)
            }
        }
    }
}
