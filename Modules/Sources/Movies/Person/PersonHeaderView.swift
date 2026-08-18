import Runes
import Shared
import SwiftUI

struct PersonHeaderView: View {

    let detail: PersonDetail

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            RemoteImageView(url: detail.profileURL)
                .frame(width: 140, height: 140)
                .clipShape(.circle)
                .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 1))

            VStack(alignment: .leading, spacing: 6) {
                Text(detail.name)
                    .foregroundStyle(.white)
                    .font(.title3.bold())

                if let department = detail.knownForDepartment, !department.isEmpty {
                    Text(department)
                        .foregroundStyle(Color(hex: "A3A3A3"))
                        .font(.footnote)
                }

                if let birthInfo {
                    Text(birthInfo)
                        .foregroundStyle(Color(hex: "737373"))
                        .font(.footnote)
                }
            }
        }
    }

    private var birthInfo: String? {
        var parts: [String] = []
        if let birthday = detail.birthday {
            if let deathday = detail.deathday {
                parts.append("\(birthday) – \(deathday)")
            } else {
                parts.append("Born \(birthday)")
            }
        }
        if let placeOfBirth = detail.placeOfBirth {
            parts.append(placeOfBirth)
        }
        return parts.isEmpty ? nil : parts.joined(separator: "\n")
    }
}
