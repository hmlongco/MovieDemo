import SwiftUI

struct ProfileSettingsRow: View {
    let icon:       String
    let title:      String
    var titleColor: Color = Color(hex: "E5E5E5")
    var iconColor:  Color = Color(hex: "A3A3A3")
    let isLast:     Bool

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
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color(hex: "525252"))
                    .font(.system(size: 12))
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
