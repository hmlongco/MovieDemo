import SwiftUI

struct ProfileStubView: View {
    let title: String
    let icon: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(Color(hex: "404040"))
            Text(title)
                .foregroundStyle(Color(hex: "737373"))
                .font(.system(size: 15))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "0A0A0A").ignoresSafeArea())
    }
}

#if DEBUG
#Preview {
    ProfileStubView(title: "Downloads", icon: "arrow.down.circle")
        .preferredColorScheme(.dark)
}
#endif
