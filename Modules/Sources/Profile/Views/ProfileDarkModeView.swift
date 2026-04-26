import SwiftUI

struct ProfileDarkModeView: View {
    var body: some View {
        ProfileStubView(title: "Dark Mode", icon: "moon")
    }
}

#if DEBUG
#Preview {
    ProfileDarkModeView()
        .preferredColorScheme(.dark)
}
#endif
