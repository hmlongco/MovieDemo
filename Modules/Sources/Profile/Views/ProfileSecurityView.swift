import SwiftUI

struct ProfileSecurityView: View {
    var body: some View {
        ProfileStubView(title: "Security", icon: "exclamationmark.shield")
    }
}

#if DEBUG
#Preview {
    ProfileSecurityView()
        .preferredColorScheme(.dark)
}
#endif
