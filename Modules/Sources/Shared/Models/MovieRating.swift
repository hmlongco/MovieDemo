import SwiftData

@Model
public final class MovieRating {
    public var movieId: Int
    public var rating: Int

    public init(movieId: Int, rating: Int) {
        self.movieId = movieId
        self.rating = rating
    }
}
