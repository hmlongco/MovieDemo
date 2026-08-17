import NavigatorUI
import Runes
import Shared
import SwiftUI

struct PersonFilmographyRow: View {

    let credit: PersonCredit
    @Environment(\.navigator) private var navigator

    var body: some View {
        Button {
            navigator.navigate(to: MovieDestination.movieDetail(movieId: credit.id))
        } label: {
            HStack(spacing: 12) {
                RemoteImageView(url: credit.posterURL)
                    .frame(width: 46, height: 66)
                    .clipShape(.rect(cornerRadius: 6))

                VStack(alignment: .leading, spacing: 2) {
                    Text(credit.displayTitle)
                        .foregroundStyle(.white)
                        .font(.system(size: 14, weight: .medium))
                        .lineLimit(1)

                    if !credit.roleText.isEmpty {
                        Text(credit.roleText)
                            .foregroundStyle(Color(hex: "737373"))
                            .font(.system(size: 12))
                            .lineLimit(1)
                    }
                }

                Spacer()

                if let year = credit.displayDate?.prefix(4) {
                    Text(year)
                        .foregroundStyle(Color(hex: "A3A3A3"))
                        .font(.system(size: 12))
                }
            }
        }
        .buttonStyle(.plain)
    }
}
