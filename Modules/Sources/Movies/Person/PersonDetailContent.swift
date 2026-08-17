import Runes
import Shared
import SwiftUI

struct PersonDetailContent: View {

    let detail: PersonDetail
    let filmography: [PersonCredit]

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            PersonHeaderView(detail: detail)

            if !detail.biography.isEmpty {
                PersonBiographySection(biography: detail.biography)
            }

            if !filmography.isEmpty {
                PersonFilmographySection(credits: filmography)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .padding(.bottom, 40)
    }
}
