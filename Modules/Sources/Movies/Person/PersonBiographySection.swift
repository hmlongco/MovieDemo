import Shared
import SwiftUI

struct PersonBiographySection: View {

    let biography: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader("Biography")
            ExpandableText(biography)
        }
    }
}
