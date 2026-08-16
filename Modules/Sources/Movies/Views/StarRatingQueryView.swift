import Shared
import SwiftData
import SwiftUI

struct StarRatingQueryView: View {
    let movieId: Int

    @Environment(\.modelContext) private var modelContext
    @Query private var ratings: [MovieRating]

    init(movieId: Int) {
        self.movieId = movieId
        _ratings = Query(filter: #Predicate<MovieRating> { $0.movieId == movieId })
    }

    var body: some View {
        StarRatingView(movieId: movieId, rating: ratings.first?.rating ?? 0, setRating: setRating)
    }

    private func setRating(_ newRating: Int) {
        let rating = max(0, min(newRating, 5))
        if let existing = ratings.first {
            existing.rating = rating
        } else {
            modelContext.insert(MovieRating(movieId: movieId, rating: rating))
        }
        try? modelContext.save()
    }
}
