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
        let movieCredits = (credits.cast + credits.crew).filter { $0.mediaType == "movie" }

        // A person can carry multiple crew credits for the same film (e.g. Director + Writer),
        // each with its own credit_id but the same movie id. Keep one row per film, preferring
        // the directing credit when present since it's the most relevant role to surface.
        var order: [Int] = []
        var chosen: [Int: PersonCredit] = [:]
        for credit in movieCredits {
            if let existing = chosen[credit.id] {
                if existing.job != "Director" && credit.job == "Director" {
                    chosen[credit.id] = credit
                }
            } else {
                chosen[credit.id] = credit
                order.append(credit.id)
            }
        }

        return order
            .compactMap { chosen[$0] }
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
