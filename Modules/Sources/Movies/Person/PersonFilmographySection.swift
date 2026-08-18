import Shared
import SwiftUI

struct PersonFilmographySection: View {

    let credits: [PersonCredit]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("Filmography")
            VStack(spacing: 12) {
                ForEach(credits) { credit in
                    PersonFilmographyRow(credit: credit)
                }
            }
        }
    }
}
