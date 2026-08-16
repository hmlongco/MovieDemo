import Shared
import SwiftData
import SwiftUI

struct StarRatingView: View {
    let movieId: Int
    let rating: Int
    let setRating: (Int) -> Void

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { star in
                Button {
                    setRating(star)
                } label: {
                    Image(systemName: star <= rating ? "star.fill" : "star")
                        .font(.footnote)
                }
                .buttonStyle(.plain)
            }
        }
        .foregroundStyle(.yellow)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Rating")
        .accessibilityValue("\(rating) out of 5 stars")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                setRating(rating + 1)
            case .decrement:
                setRating(rating - 1)
            default: break
            }
        }
    }
}

#Preview {
    VStack {
        StarRatingView(movieId: 1, rating: -1, setRating: { _ in })
        StarRatingView(movieId: 1, rating: 0, setRating: { _ in })
        StarRatingView(movieId: 1, rating: 1, setRating: { _ in })
        StarRatingView(movieId: 1, rating: 2, setRating: { _ in })
        StarRatingView(movieId: 1, rating: 3, setRating: { _ in })
        StarRatingView(movieId: 1, rating: 4, setRating: { _ in })
        StarRatingView(movieId: 1, rating: 5, setRating: { _ in })
        StarRatingView(movieId: 1, rating: 6, setRating: { _ in })
    }
    .preferredColorScheme(.dark)
}
