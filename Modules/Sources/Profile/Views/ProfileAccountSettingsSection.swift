import SwiftUI
import NavigatorUI

struct ProfileAccountSettingsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("ACCOUNT")
                .foregroundStyle(Color(hex: "737373"))
                .font(.system(size: 12, weight: .medium))
                .padding(.leading, 4)

            VStack(spacing: 0) {
                NavigationLink(to: ProfileDestination.paymentMethods) {
                    ProfileSettingsRow(icon: "creditcard", title: "Payment Methods", isLast: false)
                }
                NavigationLink(to: ProfileDestination.security) {
                    ProfileSettingsRow(icon: "exclamationmark.shield", title: "Security", isLast: false)
                }
                NavigationLink(to: ProfileDestination.logOut) {
                    ProfileSettingsRow(
                        icon:       "rectangle.portrait.and.arrow.right",
                        title:      "Log Out",
                        titleColor: Color(hex: "f43f5e"),
                        iconColor:  Color(hex: "f43f5e").opacity(0.8),
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
