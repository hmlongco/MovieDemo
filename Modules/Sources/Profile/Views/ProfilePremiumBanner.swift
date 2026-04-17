import SwiftUI

struct ProfilePremiumBanner: View {
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(hex: "6366f1"))
                    .frame(width: 40, height: 40)
                Image(systemName: "star.fill")
                    .foregroundStyle(.white)
                    .font(.system(size: 16))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Premium Plan")
                    .foregroundStyle(.white)
                    .font(.system(size: 14, weight: .medium))
                Text("Next billing on Nov 24")
                    .foregroundStyle(Color(red: 199/255, green: 210/255, blue: 254/255).opacity(0.7))
                    .font(.system(size: 10))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(Color(hex: "818cf8"))
                .font(.system(size: 14))
        }
        .padding(16)
        .background(Color(hex: "6366f1").opacity(0.05))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "6366f1").opacity(0.2), lineWidth: 1))
    }
}
