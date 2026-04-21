import Runes
import Shared
import SwiftUI

public struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let user = viewModel.authenticatedUser {
                    ProfileHeroSection(user: user)
                    ProfilePremiumBanner()
                    ProfileGeneralSettingsSection()
                    ProfileAccountSettingsSection(onLogout: viewModel.logout)
                    Text("Version 2.4.0 (Build 892)")
                        .foregroundStyle(Color(hex: "404040"))
                        .font(.system(size: 10))
                        .padding(.bottom, 16)
                }
            }
            .padding(20)
        }
        .background(Color(hex: "0A0A0A"))
        .scrollIndicators(.hidden)
    }
}
