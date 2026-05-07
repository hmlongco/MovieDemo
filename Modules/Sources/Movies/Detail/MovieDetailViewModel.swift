import Foundation
import FactoryMacros
import Runes
import Shared

@Dependency(\.movieRepository)
@MainActor @Observable final class MovieDetailViewModel {

    var detailState: LoadableState<MovieDetail> = .initial
    var castsState:  LoadableState<[Cast]>      = .initial

    func load(movieId: Int) async {
        detailState = .loading
        castsState  = .loading
        async let detailTask  = movieRepository.getMovieDetails(id: movieId)
        async let creditsTask = movieRepository.getMovieCredits(id: movieId)
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
