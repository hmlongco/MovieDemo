import SwiftUI

struct ProfileDownloadsView: View {
    var body: some View {
        ProfileStubView(title: "Downloads", icon: "arrow.down.circle")
    }
}

#if DEBUG
#Preview {
    ProfileDownloadsView()
        .preferredColorScheme(.dark)
}
#endif
