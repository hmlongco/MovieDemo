import SwiftUI
import NavigatorUI

struct ProfileGeneralSettingsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("GENERAL")
                .foregroundStyle(Color(hex: "737373"))
                .font(.system(size: 12, weight: .medium))
                .padding(.leading, 4)

            VStack(spacing: 0) {
                NavigationLink(to: ProfileDestination.downloads) {
                    ProfileSettingsRow(icon: "arrow.down.circle", title: "Downloads", isLast: false)
                }
                NavigationLink(to: ProfileDestination.notifications) {
                    ProfileSettingsRow(icon: "bell", title: "Notifications", isLast: false)
                }
                NavigationLink(to: ProfileDestination.darkMode) {
                    ProfileSettingsRow(icon: "moon", title: "Dark Mode", isLast: true)
                }
            }
            .buttonStyle(.plain)
            .background(Color.white.opacity(0.03))
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.05), lineWidth: 1))
        }
    }
}

#if DEBUG
#Preview {
    ManagedNavigationStack {
        ProfileGeneralSettingsSection()
            .padding(20)
            .background(Color(hex: "0A0A0A"))
    }
    .preferredColorScheme(.dark)
}
#endif
