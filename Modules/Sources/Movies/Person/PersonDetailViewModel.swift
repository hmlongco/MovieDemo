import Foundation
import FactoryKit
import Shared

@Observable
@MainActor
final class PersonDetailViewModel {

    var detailState: LoadableState<PersonDetail> = .initial
    var creditsState: LoadableState<PersonCombinedCredits> = .initial

    @ObservationIgnored
    @Injected(\.movieRepository) private var service

    var filmography: [PersonCredit] {
        guard let credits = creditsState.value else { return [] }
        return (credits.cast + credits.crew)
            .filter { $0.mediaType == "movie" }
            .sorted { lhs, rhs in
                switch (lhs.displayDate, rhs.displayDate) {
                case let (lhsDate?, rhsDate?): return lhsDate > rhsDate
                case (nil, _): return false
                case (_, nil): return true
                }
            }
    }

    func load(personId: Int) async {
        detailState  = .loading
        creditsState = .loading
        async let detailTask  = service.getPersonDetails(id: personId)
        async let creditsTask = service.getPersonCombinedCredits(id: personId)
        do {
            let (detail, credits) = try await (detailTask, creditsTask)
            detailState  = .loaded(detail)
            creditsState = .loaded(credits)
        } catch {
            detailState  = .error(error.localizedDescription)
            creditsState = .error(error.localizedDescription)
        }
    }
}
