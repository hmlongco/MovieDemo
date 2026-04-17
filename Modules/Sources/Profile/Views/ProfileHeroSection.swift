import SwiftUI

struct ProfileHeroSection: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 88, height: 88)
                .foregroundStyle(.gray)

            VStack(spacing: 4) {
                Text("Alex Morgan")
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .medium))
                Text("@alexmorgan • Member since 2023")
                    .foregroundStyle(Color(hex: "737373"))
                    .font(.system(size: 12))
            }

            HStack(spacing: 12) {
                ProfileStatBox(value: "124", label: "Watched")
                ProfileStatBox(value: "48",  label: "Reviews")
                ProfileStatBox(value: "12",  label: "Lists")
            }
        }
    }
}

private struct ProfileStatBox: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .foregroundStyle(.white)
                .font(.system(size: 12, weight: .semibold))
            Text(label)
                .foregroundStyle(Color(hex: "737373"))
                .font(.system(size: 10))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.05), lineWidth: 1))
    }
}
