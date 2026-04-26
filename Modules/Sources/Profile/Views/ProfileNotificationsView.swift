import SwiftUI

struct ProfileNotificationsView: View {
    var body: some View {
        ProfileStubView(title: "Notifications", icon: "bell")
    }
}

#if DEBUG
#Preview {
    ProfileNotificationsView()
        .preferredColorScheme(.dark)
}
#endif
