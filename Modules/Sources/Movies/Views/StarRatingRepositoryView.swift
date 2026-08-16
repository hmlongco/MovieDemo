import FactoryKit
import Shared
import SwiftUI

struct StarRatingRepositoryView: View {
    let movieId: Int

    @InjectedObservable(\.movieRatingRepository) private var repository

    var body: some View {
        StarRatingView(movieId: movieId, rating: repository.ratings[movieId] ?? 0) {
            repository.setRating($0, for: movieId)
        }
        .task {
            repository.load(for: movieId)
        }
    }
}
