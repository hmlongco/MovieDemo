import SwiftUI
import NavigatorUI

struct ProfileAccountSettingsSection: View {
    let onLogout: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("ACCOUNT")
                .foregroundStyle(Color(hex: "737373"))
                .font(.system(size: 12, weight: .medium))
                .padding(.leading, 4)

            VStack(spacing: 0) {
                NavigationLink(to: ProfileDestination.paymentMethods) {
                    ProfileSettingsRow(icon: "creditcard", title: "Payment Methods")
                }
                NavigationLink(to: ProfileDestination.security) {
                    ProfileSettingsRow(icon: "exclamationmark.shield", title: "Security")
                }
                Button(action: onLogout) {
                    ProfileSettingsRow(
                        icon:       "rectangle.portrait.and.arrow.right",
                        title:      "Log Out",
                        titleColor: Color(hex: "f43f5e"),
                        iconColor:  Color(hex: "f43f5e").opacity(0.8),
                        isButton:   true,
                        isLast:     true
                    )
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
        ProfileAccountSettingsSection(onLogout: {})
            .padding(20)
            .background(Color(hex: "0A0A0A"))
    }
    .preferredColorScheme(.dark)
}
#endif
