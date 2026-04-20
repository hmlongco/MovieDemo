import SwiftUI

enum AppTab: Int {
    case home
    case explore
    case profile
}

@Observable
final class AppNavigator {
    var selectedTab: AppTab = .home
}

extension EnvironmentValues {
    @Entry var appNav: AppNavigator = .init()
}
