import SwiftUI

enum AppTab: Int {
    case home
    case explore
}

@Observable
final class AppNavigator {
    var selectedTab: AppTab = .home
}
