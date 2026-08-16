import Foundation
import FactoryKit
import SwiftData

@Observable
@MainActor
public final class MovieRatingRepository {

    @ObservationIgnored
    @Injected(\.modelContext) private var modelContext

    public private(set) var ratings: [Int : Int] = [:]

    public init() {
        do {
            let descriptor = FetchDescriptor<MovieRating>(fetchLimit: 1000)
            ratings = try modelContext.fetch(descriptor).keyed(by: \.movieId, value: \.rating)
        } catch {
            // nothing for now
        }
    }

    public func load(for movieId: Int) {
        guard ratings[movieId] == nil else {
            return
        }
        let descriptor = FetchDescriptor<MovieRating>(fetchLimit: 1, predicate: #Predicate { $0.movieId == movieId })
        let existing = try? modelContext.fetch(descriptor).first
        ratings[movieId] = existing?.rating ?? 0
    }

    public func setRating(_ newRating: Int, for movieId: Int) {
        let rating = max(0, min(newRating, 5))
        let descriptor = FetchDescriptor<MovieRating>(fetchLimit: 1, predicate: #Predicate { $0.movieId == movieId })
        if let existing = try? modelContext.fetch(descriptor).first {
            existing.rating = rating
        } else {
            modelContext.insert(MovieRating(movieId: movieId, rating: rating))
        }
        try? modelContext.save()
        ratings[movieId] = rating
    }
}
