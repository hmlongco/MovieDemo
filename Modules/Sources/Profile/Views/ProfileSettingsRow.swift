import SwiftUI

struct ProfileSettingsRow: View {
    let icon:       String
    let title:      String
    var titleColor: Color = Color(hex: "E5E5E5")
    var iconColor:  Color = Color(hex: "A3A3A3")
    var isButton:   Bool = false
    var isLast:     Bool = false

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundStyle(iconColor)
                    .frame(width: 20, height: 20)
                Text(title)
                    .foregroundStyle(titleColor)
                    .font(.system(size: 14, weight: .medium))
                Spacer()
                if !isButton {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color(hex: "525252"))
                        .font(.system(size: 12))
                }
            }
            .padding(16)
            .contentShape(Rectangle())

            if !isLast {
                Divider()
                    .background(Color.white.opacity(0.05))
            }
        }
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 0) {
        ProfileSettingsRow(icon: "arrow.down.circle", title: "Downloads")
        ProfileSettingsRow(icon: "bell", title: "Notifications")
        ProfileSettingsRow(icon: "moon", title: "Dark Mode", isLast: true)
        ProfileSettingsRow(
            icon: "rectangle.portrait.and.arrow.right",
            title: "Log Out",
            titleColor: Color(hex: "f43f5e"),
            iconColor: Color(hex: "f43f5e").opacity(0.8),
            isButton: true,
            isLast: true
        )
    }
    .background(Color.white.opacity(0.03))
    .cornerRadius(16)
    .padding(20)
    .background(Color(hex: "0A0A0A"))
    .preferredColorScheme(.dark)
}
#endif
